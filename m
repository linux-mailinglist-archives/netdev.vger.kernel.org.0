Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69BC2EC5E8
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 22:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbhAFVyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 16:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbhAFVye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 16:54:34 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C44C061575
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 13:53:54 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id d9so4167798iob.6
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 13:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YSXUYL/hcpw8psXz1Uun+cU8ues50U1mSdo3BeXPwSU=;
        b=Mh4w6mwwXiOohtM9I0r3Sip/eJuRm9pcs2olbc3+DS0lVCBl1/ja02d2RstJRSGC1i
         AmZKQOPm8Hurf6ysIHpnWgzvAKwiUBZarRtO87u2eoWOSkGG59AY3Atw87zZF5P+GT8B
         4WIZ39qjrI9/q6tFFYszrJWyFbR6fC6kZEeWi8+YaMMPDRmCqWdBvPCzPitUNoCzbHoS
         AicxDsJUblwjEJWiyFyQvnEmIhZB1pBOWZ2LT2bmGw6WpCSmWhu0l3qLxtdxm7C9K3sr
         OgmaIM81HoAl2j2EAMebdkaNbMiI+t1tqtM4xlnrXRa0KR4rr494RegilAFLfWTUuF6T
         lYAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YSXUYL/hcpw8psXz1Uun+cU8ues50U1mSdo3BeXPwSU=;
        b=ERqGK7LVGmAesxteqbwiUe8V0oRzlqBscQXaAGzbthX+Pkf3X3PX/WLsNYMHpc+5mb
         YOFgxZstFlsLa3p0UCV3Zu3kvMBAZQbHQb03GpKIZy1RH8YAYIbr25diIxP42PSV9SRD
         St237QuJhvIDt1yFtF51xrpGfN1MF2YIF3M7eOgTDR5ocJllQIlmJEeJ4pEtBVZf3rvW
         pjTm7l7PxHkA3x9fsbTkTsAyDU2UJPdHDvS1DcsaV3wMoAmntYkld6CheaLSrx+2vIX4
         RIIGSSAU6FIdUqQfBZ4JOyqriQIQR3K5zikkxZudiNXqYgaQkhDBB+ZpdrzWOGXAZdVG
         5POg==
X-Gm-Message-State: AOAM533sxwvyobzhWCywnGkFAH7MU443kREfD26GOV/ny0SIR4CHs/bC
        s+mXvc7YJ+pGsV8CaeaulEykyJWwEzCgKlcRDA8=
X-Google-Smtp-Source: ABdhPJz9oQ46hg9UVne6/dCDUrjHKnlncc8q2lofFpNGZIhrPI9HQBtrTH5uuhfdprarxbe2WLE4Wl8IJ2FLXSTurZ4=
X-Received: by 2002:a6b:8e41:: with SMTP id q62mr4399576iod.5.1609970033525;
 Wed, 06 Jan 2021 13:53:53 -0800 (PST)
MIME-Version: 1.0
References: <20210106210637.1839662-1-kuba@kernel.org>
In-Reply-To: <20210106210637.1839662-1-kuba@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 6 Jan 2021 13:53:42 -0800
Message-ID: <CAKgT0Uf4eP=_rs66_=kx3z2Pmc8JB7McSUMv6DjZXbjboH0ptw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] udp_tunnel_nic: post conversion cleanup
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com,
        Michael Chan <michael.chan@broadcom.com>, rajur@chelsio.com,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, tariqt@nvidia.com,
        saeedm@nvidia.com, GR-Linux-NIC-Dev@marvell.com,
        ecree.xilinx@gmail.com, Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 6, 2021 at 1:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> It has been two releases since we added the common infra for UDP
> tunnel port offload, and we have not heard of any major issues.
> Remove the old direct driver NDOs completely, and perform minor
> simplifications in the tunnel drivers.
>
> Jakub Kicinski (4):
>   udp_tunnel: hard-wire NDOs to udp_tunnel_nic_*_port() helpers
>   udp_tunnel: remove REGISTER/UNREGISTER handling from tunnel drivers
>   net: remove ndo_udp_tunnel_* callbacks
>   udp_tunnel: reshuffle NETIF_F_RX_UDP_TUNNEL_PORT checks

The patch set looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
