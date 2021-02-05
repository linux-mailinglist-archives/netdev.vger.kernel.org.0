Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4676031187B
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhBFCjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbhBFCgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:36:05 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EBFC08ED32
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 15:05:24 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id r12so14662931ejb.9
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 15:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1JZC5vcCmEfy4KOq0SnN5OVPczE9uF1YgmJZXdKOUJs=;
        b=eOglrKE0Jhd/ToTakCQOKx2tnCIxZEgcRuvUUNqdqNSxSR+FmvXu/F4rrBOTR+iWv6
         XZsAvoS/nQ3rgQeqxXjCRxiAg966Xt8ziRNIw9jPUwpGaBTJuFdFtCaSsILzRCDnhiCJ
         f+d3pc8G7ilzDX3H3BKjBEbnGa2z7MlUWUaxKDPvi995nsKNtORoj0V96HfGQ7Y0d8ZO
         AybnhDHTsrPhIoO9pm9DIdPemQYCh86jRecSEYTqSxBFAKXIL9iPApMkNh+c9sEQY9Ra
         YsDJiU2QUnLrWaY9xBwggjN9B4bpCrpkpn7cLaMHWqmqfLSRnH3wl7Ia6Sf/hzrQjgXc
         7HsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1JZC5vcCmEfy4KOq0SnN5OVPczE9uF1YgmJZXdKOUJs=;
        b=O/WZI0Ti0I/yc3uwlib1qRQXMDG9ZG5SF7cojmAd/Yo2aC7EKTAgcmc4PKJ2D5uJ/Q
         GyPh80blrqK29KS4JxPQKiuhyex8QGSlW2VnM6vuXP0U1fisGap+xm3G6TEmP+2gMSp6
         PQaNlISD6vpfRdVjeqgGyXWpXQkZ3BUTPmGYf248Mmlt7cbVAIvtgAOJK/4FQ8Pi5cDp
         yuQG96PwkoYKfW37oMZ8edM+W4We6gLCNZNEuOhgtrN/1vGfpi0ZFLU7oj5P22KCbKzt
         vmZOmV1i//7I/ZwkqNBES4AGxDMEO5fDQyXfShNGS7Rcezuby0nLvN9cCh6oXhkIeOfU
         sLsQ==
X-Gm-Message-State: AOAM530AbDJSy1vFDynjy1o/kCO2fmwnEJSkQLgehDN46dkkFcx7Np19
        bq4WTY8gHW7aNb9O502mJew=
X-Google-Smtp-Source: ABdhPJyVLiv+fwjjJNpibr8jah+OIXR1+PyvOzkY4MC26vihyr2y6AuyWla7Kj0lDe9EhUT1YgD1bw==
X-Received: by 2002:a17:906:3285:: with SMTP id 5mr6261324ejw.356.1612566323491;
        Fri, 05 Feb 2021 15:05:23 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f6sm4702134edk.13.2021.02.05.15.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 15:05:22 -0800 (PST)
Date:   Sat, 6 Feb 2021 01:05:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: allow port mirroring towards foreign
 interfaces
Message-ID: <20210205230521.s2eb2alw5pkqqafv@skbuf>
References: <20210205223355.298049-1-olteanv@gmail.com>
 <fead6d2a-3455-785a-a367-974c2e6efdf3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fead6d2a-3455-785a-a367-974c2e6efdf3@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 02:42:55PM -0800, Florian Fainelli wrote:
> How does the mirred action deal with that case? How does it know that
> packets delivered to the DSA master should be sent towards a foreign
> address, do I need to set-up two mirred rules? One that set-ups the
> filter on say sw0p0 to redirect egress to eth0 (DSA master) and another
> one to ingress filter on eth0 and egress mirror to eth1 (USB ethernet
> dongle)?

[ I should have posted this as RFC, somebody asked me if it's possible,
  I only tested ingress mirroring, saw something come out, and posted this.
  I didn't even study act_mirred.c to see why I got anything at all ]

For ingress mirroring there should be nothing special about the mirror
packets, it's just more traffic in the ingress data path where the qdisc
hook already exists.

For egress mirroring I don't think there's really any way for the mirred
action to take over the packets from what is basically the ingress qdisc
and into the egress qdisc of the DSA interface such that they will be
redirected to the selected mirror. I hadn't even thought about egress
mirroring. I suppose with more API, we could have DSA do introspection
into the frame header, see it's an egress-mirrored packet, and inject it
into the egress qdisc of the net device instead of doing netif_rx.

The idea with 2 mirrors might work however it's not amazing and I was
thinking that if we bother to do something at all, we could as well try
to think it through and come up with something that's seamless for the
user.
