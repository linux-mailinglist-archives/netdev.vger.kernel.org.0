Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413B221A9B0
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 23:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbgGIVYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 17:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgGIVYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 17:24:44 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF15C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 14:24:44 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id h18so1657860qvl.3
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 14:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tk+fDscVYomBYIXU8HfyI/LzRqMOIxmRU7ajvvCiORA=;
        b=ColBifgqae1Ec8nBMrUNEc6S6s1VmLFum2vzWvyqXMu7Upa5QahlPAfFQYCna9jCJt
         UpO1V/Ivgq6liC49DEutAfy6HPsrJkMAOCI9JzpHfXep23YR1NU1SkzjSJhlTFfc6/O4
         FgfQ/CsXzw94VqwyGzMEwMmcD+7rJLnDrq9jw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tk+fDscVYomBYIXU8HfyI/LzRqMOIxmRU7ajvvCiORA=;
        b=htr2bea7LOi7XA0mlvIicE9KfnNG8ObJjXU3e8nUzgha5ZOLuao7Nc9Q9TtLVqdfm3
         WuKPodrKJH1FQCtuG0pIKIc3ePW9eKy3x3cZrSUZkCW74qczHEy+7ISqHLX+0oxOcAxp
         8sylPKRI7+6kn9P6qW/itZ0GwRH8VOWU8fBswcv+hJYPRypin/bXdPpQjlKVrWTpQReB
         KitvqbfTvyFe3424pZC8QcIAJI6FtnaJlubIvt6Q6VfSfByGV4TY0WWSzXD/81zl3lBC
         GdfTpVeNFiYzrEBd4Wb5WUwiAD44vClvdNSmeKs8xSPd8ZbAbS/KvkV1l8B2rCd92zQA
         cFQg==
X-Gm-Message-State: AOAM532znj2slbM2WsGeUot0L3tDK9bdYB7ND6Z4GCuyNceWvJETat/i
        XYfX4PA9R2DvHnnNBXw7iOL6+XvP6fM9XFBer4Ciig==
X-Google-Smtp-Source: ABdhPJyEcaPSg+0O793tDnlXV9Ukm1uiL5IHeikQTE9itTe0KacUy10R/q/G47ikeTGsZ6GAdh7OINMyIYx6fwUXrIA=
X-Received: by 2002:a05:6214:bce:: with SMTP id ff14mr64003492qvb.196.1594329883274;
 Thu, 09 Jul 2020 14:24:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200709011814.4003186-1-kuba@kernel.org> <20200709011814.4003186-10-kuba@kernel.org>
 <CACKFLikN6utQT2eXKtnhZFMYxt8Tem-An=6cxX6nXgPiO+k5UQ@mail.gmail.com> <20200709135605.6ad96b88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709135605.6ad96b88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 9 Jul 2020 14:24:31 -0700
Message-ID: <CACKFLimw9pGX5fvpM82z1ALtTvijH+DdWcEOaybhXPR6SPga7w@mail.gmail.com>
Subject: Re: [PATCH net-next v2 09/10] bnxt: convert to new udp_tunnel_nic infra
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, Tariq Toukan <tariqt@mellanox.com>,
        mkubecek@suse.cz
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 1:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 8 Jul 2020 22:27:13 -0700 Michael Chan wrote:
> > On Wed, Jul 8, 2020 at 6:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > @@ -1752,10 +1752,8 @@ struct bnxt {
> > >  #define BNXT_FW_MAJ(bp)                ((bp)->fw_ver_code >> 48)
> > >
> > >         __be16                  vxlan_port;
> >
> > We can also do away with vxlan_port and nge_port, now that we no
> > longer need to pass the port from NDO to workqueue.  We just need to
> > initialize the 2 firmware tunnel IDs to INVALID_HW_RING_ID before use
> > and after free.  But it is ok the way you have it too.
>
> Seems like I need to send a v3 anyway - the only reason I kept them is
> to know if bnxt_hwrm_free_tunnel_ports() has to issue its commands or
> not.
>
> Are you suggesting I just add a flag that'd say "tunnel in use" instead
> of holding onto the ports?  Or free unconditionally?

Here's what I would do:

1. Change vxlan_fw_dst_port_id and nge_fw_dst_port_id to u16 and
initialize them to INVALID_HW_RING_ID.  This will indicate that the
ports are not offloaded.  The assignments of these fields to the fw
message will now need cpu_to_le16().

2. bnxt_hwrm_free_tunnel_ports() will check if
bp->vxlan_fw_dst_port_id == INVALID_HW_RING_ID before freeing.  After
freeing, it will set bp->vxlan_fw_dst_port_id to INVALID_HW_RING_ID.
Same for the Geneve port.
