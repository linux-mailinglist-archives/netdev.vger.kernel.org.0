Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1193D498CF5
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 20:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351333AbiAXT0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 14:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349916AbiAXTWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 14:22:55 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33E9C061798
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 11:08:48 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id ah7so24051472ejc.4
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 11:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5AaETPz3DQHdxIbwnzebJmEBXgAYfAm/9yrLnWcbLg8=;
        b=plXqay4BHbzKlDZZTvveDzDO9Xx0Mg73bVG3Tm1mKljSH0nUEs5LzxYEbd/Rino4Yg
         6uuvWuT9ZFuuLPv9kprtTrwFOnadAMo+h0N95/z2rHO8rnsDfcLQrIL5WiLrVDFhApG8
         nBh/18qDkHR44F6RDtd3h27M2efNqTlO4dqKcgh61nPrtfXcLsBRPHYEGtqn0oSmMF6R
         qqcAlWw1xD4fn0Ypsn3d1K43EckO9nG5mBm/yOREzG+oXgf0lBQ5/poNdWVBGv8kPhRR
         QY0wVrNCz47IkbX8757N5daTciDNaggZT/yHvibHMpcvY2pAKHn7MZoBFipfIdZJ3/8n
         Mk2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5AaETPz3DQHdxIbwnzebJmEBXgAYfAm/9yrLnWcbLg8=;
        b=p/1qJf3bWgnoF1g7yMu/gDBi7VRbu5mDpGzVbU8urxRlx52XgzuMbi9vxKpt80KaLx
         71dUDW+O0+vh65zdGsJ/gekJz9dSCLQ54hfryECz8XAqbovD5YZky7leZbmzeqmCdMqt
         HScYJ9HsX7liwjB/7uRtm/2AhfMVFIWlT3H94DwBGLno0Wo/sJGGOS7URiBgS2FHlSKS
         MEnijjymVbQG8cx9pZ1A8UA7tiQY1jlzIyWJk0CmyMMfJLe1H9Kqc+/xv0Bn2ZNf5pYx
         J6AikK9b+JrrK3PMrY4rticHEnrfAgEWVZV+qW6E3Oasp9cA18Z54RCMsLMEKpLXWrp2
         L4CA==
X-Gm-Message-State: AOAM533oTNCVaYr0QNV8z8a4dlm0UcrzreC/ufnBoQjGtto517GMqvoA
        7lfe9gNT0KQrAWU/njuhrv0=
X-Google-Smtp-Source: ABdhPJyECfffNbkCTU1irRpHwwYHnIIf5hpvDJXV8w6LR88gaQwDn6+FvDrG+MGJVDU+ZgS0T1UcBQ==
X-Received: by 2002:a17:906:4fc4:: with SMTP id i4mr12968505ejw.81.1643051327296;
        Mon, 24 Jan 2022 11:08:47 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id c5sm5239591ejz.88.2022.01.24.11.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 11:08:46 -0800 (PST)
Date:   Mon, 24 Jan 2022 21:08:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Message-ID: <20220124190845.md3m2wzu7jx4xtpr@skbuf>
References: <CAJq09z7v90AU=kxraf5CTT0D4S6ggEkVXTQNsk5uWPH-pGr7NA@mail.gmail.com>
 <20220121224949.xb3ra3qohlvoldol@skbuf>
 <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
 <20220124153147.agpxxune53crfawy@skbuf>
 <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124165535.tksp4aayeaww7mbf@skbuf>
 <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
 <20220124172158.tkbfstpwg2zp5kaq@skbuf>
 <20220124093556.50fe39a3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124102051.7c40e015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124102051.7c40e015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 10:20:51AM -0800, Jakub Kicinski wrote:
> On Mon, 24 Jan 2022 09:35:56 -0800 Jakub Kicinski wrote:
> > Sorry I used "geometry" loosely.
> >
> > What I meant is simply that if the driver uses NETIF_F_IP*_CSUM
> > it should parse the packet before it hands it off to the HW.
> >
> > There is infinity of protocols users can come up with, while the device
> > parser is very much finite, so it's only practical to check compliance
> > with the HW parser in the driver. The reverse approach of adding
> > per-protocol caps is a dead end IMO. And we should not bloat the stack
> > when NETIF_F_HW_CSUM exists and the memo that parsing packets on Tx is
> > bad b/c of protocol ossification went out a decade ago.
>
> > It's not about DSA. The driver should not check
> >
> > if (dsa())
> > 	blah;
> >
> > it should check
> >
> > if (!(eth [-> vlan] -> ip -> tcp/udp))
> > 	csum_help();
>
> Admittedly on a quick look thru the drivers which already do this
> I only see L3, L4 and GRE/UDP encap checks. Nothing validates L2.

So before we declare that any given Ethernet driver is buggy for declaring
NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM and not checking that skb->csum_start
points where it expects it to (taking into consideration potential VLAN
headers, IPv6 extension headers), is there any driver that _does_
perform these checks correctly, that could be used as an example?
