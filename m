Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5824D49BE7E
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 23:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233844AbiAYW3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 17:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbiAYW3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 17:29:37 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B681C061747
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 14:29:37 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id n16-20020a17090a091000b001b46196d572so4255342pjn.5
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 14:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tvCCRY6xlvOrQ/O19UIHhWrCaHxPn5tYjPvlxSdaNTE=;
        b=ezsiHOEmDt4gnBx7CueGXVEDVlG7985IefHrNORw7k+KaA65+RLmTDDn2+WBWW19cU
         mlbpvMhhndxXhS5gW2+5Eid1Djj/Pn3b6C881PmOPmnFeQNSBhR733zGfglrVeVdI9Up
         bvV9ZMQKA/Hgf03ti70ZXiw6suVFHU4vcCNKMdgEwTf+mdp+PWLVR2L0oQQfMiHZVV/R
         QkMdSDvf4ZhO1qkaak9mcK06EzUmKaFzSUxSVPj8raiQrbypJiTALMrvZNx62nDMWFee
         HyQ9+tZm63xW+2C4tPuTnwgFIQRefLNzT9e+7tKrDBrnn5A9N9y3GPc/FPyfoDDobXAy
         p8HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tvCCRY6xlvOrQ/O19UIHhWrCaHxPn5tYjPvlxSdaNTE=;
        b=jos66UmJP1Ya1P8KwhPbJIITD8V+jNLVvufKXq36jYbbBFkJRn4bS7hYISOjylKBX/
         2Ui41PoJnJEc+OBmI405lK0/R1OD5OgBFMSngNbyCQml5TNw5JMgENm4S+XCG+epq9sl
         /Pd7AaPsVMqo0OFBojPW6D3UGvoCOttRu9tmCbl+I4w3fJspPoZEFYyaiVeUENljiC3c
         0YWz2r26FEApLHCIShXjRKvNsKlNeDuYLG6uyIchAvXJvmd03o0AnaBzJdf+tliF2nBj
         aPz8legJD7gBIajTkzpx49nbT7wC4A4kRMkYAibeWf7NaNAYKYgtJPb1he/Iu9B4XhtI
         wMoQ==
X-Gm-Message-State: AOAM53172bqgRitUsCTXRbUyJP2TgtgDVE5s4ARPMjZMRJzAUnoMb+kU
        sZvxG1CNRAMW85h7Tad+2bRIeJUVMK/WAv9Vw+4=
X-Google-Smtp-Source: ABdhPJwkJvEQszdeT+/nhBg+5zrDcMUhS8orSAKbqHKbuR1DlqEfWeLz2u1pncIlO5B4R2lj9YUNiCp8AMFC+iKn3tI=
X-Received: by 2002:a17:903:246:b0:14a:26ae:4e86 with SMTP id
 j6-20020a170903024600b0014a26ae4e86mr21446887plh.59.1643149776457; Tue, 25
 Jan 2022 14:29:36 -0800 (PST)
MIME-Version: 1.0
References: <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
 <20220124172158.tkbfstpwg2zp5kaq@skbuf> <20220124093556.50fe39a3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124102051.7c40e015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124190845.md3m2wzu7jx4xtpr@skbuf> <20220124113812.5b75eaab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124205607.kugsccikzgmbdgmf@skbuf> <20220124134242.595fd728@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124223053.gpeonw6f34icwsht@skbuf> <CAJq09z5JF71kFKxF860RCXPvofhitaPe7ES4UTMeEVO8LH=PoA@mail.gmail.com>
 <20220125094742.nkxgv4r2fetpko7r@skbuf>
In-Reply-To: <20220125094742.nkxgv4r2fetpko7r@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Tue, 25 Jan 2022 19:29:25 -0300
Message-ID: <CAJq09z4OC4OijWT8=-=vXRQhqFsaP0+asXyO69i37aj39DMB6A@mail.gmail.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Could you implement a prototype of packet parsing in ndo_features_check,
> which checks for the known DSA EtherType and clears the offload bit for
> unsupported packets, and do some performance testing before and after,
> to lean the argument in your favor with some numbers? I've no problem if
> you test for the worst case, i.e. line rate with small UDP packets
> encapsulated with the known (offload-capable) DSA tag format, where
> there is little benefit for offloading TX checksumming.

There is no way to tell if a packet has a DSA tag only by parsing its
content. For Realtek and Marvel EDSA, there is a distinct ethertype
(although Marvel EDSA uses a non-registered number) that drivers can
check. For others, specially those that add the tag before the
ethernet header or after the payload, it might not have a magic
number. It is impossible to securely identify if and which DSA is in
use for some DSA tags from the packet alone. This is also the case for
mediatek. Although it places its tag just before ethertype (like
Realtek and Marvel), there is no magic number. It needs some context
to know what type of DSA was applied.

skb_buf today knows nothing about the added DSA tag. Although
net_device does know if it is a master port in a dsa tree, and it has
a default dsa tag, with multiple switches using different tags, it
cannot tell which dsa tag was added to that packet.
That is the information I need to test if that tag is supported or not
by this drive.

I believe once an offload HW can digest a dsa tag, it might support
the same type of protocols with or without the tag.
In the end, what really matters is if a driver supports a specific dsa tag.

Wouldn't it be much easier to have a dedicated optional
ndo_dsa_tag_supported()? It would be only needed for those drivers
that still use NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM and only those that
can digest a tag.

Regards,
