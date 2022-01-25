Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF04949B0E3
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbiAYJwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234915AbiAYJrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:47:48 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF9FC061747
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 01:47:46 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ka4so29295401ejc.11
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 01:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j1HI/Fwezauw1Idb6mPYTjC6lZx1WcHyp1QiyuSB2II=;
        b=lW81ZfPkPpVn6RHyZR05gf/whO/vqv5uEqQJHKu4bGZFUjESMWOhqX/GEaA+LPbO2Y
         9xJP1F49f0eb4ser2qLx4Y7NUqjD79VQw84PzlwP85muO1stNEJTxITTjbXNu172VKHT
         4NmR6zGEpx/VzaKWqoXebKuxmEKgXfY/CLkdLYTaDxwB+DUMYDfM5i+IAPnocvEMz856
         6KU2uogjKWH4e+Kl05DReEGUwTFGbN1L4regGRaZz5ZvGWMErosaOjTBxmTO5mRoWVNo
         hJXIC8duHy/ObRn93MsQnaEvSQXOvyWSvxVFTFB+tzCAv+sjfYxXiau6wN+6wgae8dBx
         h1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j1HI/Fwezauw1Idb6mPYTjC6lZx1WcHyp1QiyuSB2II=;
        b=L+8a1j2IDiGpzCjp5JGEHDnK47OfjkNwVIj3vzTg6Sp9SH/15rcOEJ7zbEBo1tzDwi
         wwkxNnL7zN/49voARG9W5z0LPZyPnrU2J59sV2GpYyeinidBgff/n7zhsItGye0nu4uu
         9HUIWLAzpPl4mYT8SbEx9wAInxL25tEH0UiV9kuJeijHpo2Y7PpXZs5HvRa03OmUHbwQ
         RoaF/Otdmlwsgn7PzEtngaNj4q3gVFQwqLnH/dkEj0k+JNLpfD07MfSNidT0kmVh52LR
         Cu4+cb3XMBcJOqbFaiKsa8HzhQ39cEbGbc2quISiHEByxtF6NT2t6dG0l1BnVDi/I6sN
         SAnA==
X-Gm-Message-State: AOAM532DwNxXbt/4iMOWGCMM/Dh80CNuhPie/KQ8v7tb2rv4lTw8Jr0F
        vX+SWv81CeESdMzU4w0vGyo=
X-Google-Smtp-Source: ABdhPJyLIaE7/IReiDk1YZxup35P3HPJvJACHASK1YTubY87EIDhi+euh3GyHkhcY9RXzC3mKT82zw==
X-Received: by 2002:a17:906:b1c2:: with SMTP id bv2mr16574801ejb.395.1643104064895;
        Tue, 25 Jan 2022 01:47:44 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id u14sm8017327eds.1.2022.01.25.01.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 01:47:44 -0800 (PST)
Date:   Tue, 25 Jan 2022 11:47:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Message-ID: <20220125094742.nkxgv4r2fetpko7r@skbuf>
References: <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
 <20220124172158.tkbfstpwg2zp5kaq@skbuf>
 <20220124093556.50fe39a3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124102051.7c40e015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124190845.md3m2wzu7jx4xtpr@skbuf>
 <20220124113812.5b75eaab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124205607.kugsccikzgmbdgmf@skbuf>
 <20220124134242.595fd728@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124223053.gpeonw6f34icwsht@skbuf>
 <CAJq09z5JF71kFKxF860RCXPvofhitaPe7ES4UTMeEVO8LH=PoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z5JF71kFKxF860RCXPvofhitaPe7ES4UTMeEVO8LH=PoA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

On Tue, Jan 25, 2022 at 04:15:23AM -0300, Luiz Angelo Daros de Luca wrote:
> I believe that those drivers with NETIF_F_HW_CSUM are fine for every
> type of DSA, right? So, just those with NETIF_F_IP_CSUM |
> NETIF_F_IPV6_CSUM set needs to be adjusted. A fully implemented
> ndo_features_check() will work but improving it for every driver will
> add extra code/overhead for all packets, used with DSA or not. And
> that extra code needed for DSA will either always keep or remove the
> same features for a given slave.

Could you implement a prototype of packet parsing in ndo_features_check,
which checks for the known DSA EtherType and clears the offload bit for
unsupported packets, and do some performance testing before and after,
to lean the argument in your favor with some numbers? I've no problem if
you test for the worst case, i.e. line rate with small UDP packets
encapsulated with the known (offload-capable) DSA tag format, where
there is little benefit for offloading TX checksumming.
