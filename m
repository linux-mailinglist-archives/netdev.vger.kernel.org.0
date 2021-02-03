Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0574930D64D
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbhBCJ26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbhBCJ1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 04:27:46 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F753C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 01:27:06 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id c18so27471088ljd.9
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 01:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=53MeZZMkjzJbVenvhM/1aKq5/NLA6Fl0R4vPeJN8bLQ=;
        b=ohO8FUU6821FQhAZ2OPfzoYG+pQ9ivrAv+5kyCgw31vWyw2AQoHAX9JhuSuNJarkFv
         h6KtvOO28XB9ljMGo9xu2ko8KHIoJqwXXibLPfdxS0clytjKfZbpu21uEOkXM5LqWzL3
         UxP52VUp6BFss8+olfSx/WYu8mVT4FAfmKSP9m6mpVy5FfRqlNe44Gkmxwu/Ztb3hBKy
         TWOsW6WC0/BqTg+dzGTCvvt+jW8FqAvYiXDWK77OVOU/mW/TumuM4uWD/GfQwCjAjp+5
         0arPU+d4r678FfUdc5JSO8YAImd7Zf71ogY+uYX69eHGveIzmbf+1qy1XoXhgeNkAek/
         ttiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=53MeZZMkjzJbVenvhM/1aKq5/NLA6Fl0R4vPeJN8bLQ=;
        b=R2AkmRz2kr3YifdNKB37betZEyUDIbE2TvS9pvkVmKl+3n3gpTFe5F0OWeD424643z
         xKN5YlHdr/OByTDbUQ+acwK30e1EAlfsMTjZxnMWxlIHTC0GmkQiVeVVDaK9d1Ss7VjH
         Qj4kLqgfNPdTGgFoGD6AI+f62/LQwGzw8SPKDNXdiq5XKrf99CFXlSDaa7VYvZq6phEI
         qN2IHu1ihEitPctf0il8Q1TyYU07/WXg6llxWBc5xC7rN7SjX5GWOBinafd59BwwMlmo
         olDsJKMF9GbTbBjxKG6L7cCbZgJokLuTC2cZqYPByPArw2YY/ET9sAVQS2is0yKIqGn3
         WFPQ==
X-Gm-Message-State: AOAM5328Mbxu2aiFIYKVrcXK5M8LbKvkI/3P9A8AD1ioGnogMgEPAlyD
        9GrH1/ZTeh0Qv5G1Qciq25/vRPmtkk0tRkGh
X-Google-Smtp-Source: ABdhPJw/5ItVr86YI5OUGspCfXeGgRXZbROfuHIGY5gt/ZmcqdSNWzyoNT2L2ORtY95qKbhxgzycbw==
X-Received: by 2002:a2e:97d7:: with SMTP id m23mr1168916ljj.456.1612344423253;
        Wed, 03 Feb 2021 01:27:03 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id n16sm180301lfq.301.2021.02.03.01.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 01:27:02 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        netdev@vger.kernel.org
Subject: Re: [RFC net-next 7/7] net: dsa: mv88e6xxx: Request assisted learning on CPU port
In-Reply-To: <20210201062439.15244-1-dqfext@gmail.com>
References: <20210116012515.3152-1-tobias@waldekranz.com> <20210201062439.15244-1-dqfext@gmail.com>
Date:   Wed, 03 Feb 2021 10:27:02 +0100
Message-ID: <8735yd5wnt.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 14:24, DENG Qingfang <dqfext@gmail.com> wrote:
> Hi Tobias,
>
> I've tested your patch series on kernel 5.4 and found that it only works
> when VLAN filtering is enabled.
> After some debugging, I noticed DSA will add static entries to ATU 0 if
> VLAN filtering is disabled, regardless of default_pvid of the bridge,
> which is also the ATU# used by the bridge.

Good catch, thanks! This seems to stem from a different policy regarding
VLAN assignment in the bridge vs. how a Marvell switch works.

By default, a bridge will use a default PVID of 1, even when VLAN
filtering is disabled (nbp_vlan_init). Yet it will assign all packets to
VLAN 0 on ingress (br_handle_frame_finish->br_allowed_ingress).

The switch OTOH, will use the PVID of the port for all packets when
802.1Q is disabled, thus assigning all packets to VLAN 1 when VLAN
filtering is disabled.

Andrew, Vladimir: Should mv88e6xxx always set the PVID to 0 when VLAN
filtering is disabled?

> Currently I use the hack below to rewrite ATU# to 1, but it obviously
> does not solve the root cause.

Alternatively, as a userspace workaround, you can change the default
PVID to 0:

ip link set dev $BR type bridge vlan_default_pvid 0
