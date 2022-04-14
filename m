Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009385017D3
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243114AbiDNPuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 11:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242158AbiDNPeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 11:34:15 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DA2B715D;
        Thu, 14 Apr 2022 08:11:50 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id c64so6735634edf.11;
        Thu, 14 Apr 2022 08:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ePaXFvQpBZHWZnEFe6kdyoM4M5jCBAO3IMy7bDaD+IQ=;
        b=T3y7/ezwj893tPbd5HahxfqR30GzBGzewCsL3NxKGci1PBv/JhijD1EWqxBqyiPhCq
         MixICDu2zy/rZSjOartFBhQMPEUInun7+vXgTUAn46k70RS39svn1sDFccf8XnzbCm1w
         +xfyWVzZshcJqTywem9rulpf+BAJWF4nVne0lKwjkMb+i1yyqlV9tzqxywR8zC0Dqhv7
         V6trRKYPrp1Vi4tjauvr2KhKSV0Dy5dYJtUTu2ejESyn2xhHn4ZvWRCLHV86vU3AvVgu
         ykouEjIMSV1YZldUBE1U5o7iBg44+Dt78fkPvv+0xvqc6a38kGD3EEjcy27DtWFQYj5t
         NFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ePaXFvQpBZHWZnEFe6kdyoM4M5jCBAO3IMy7bDaD+IQ=;
        b=WDtkxu0XwJF5OU38fIFUTRj2EqdoGw6qLYP8Lhp6jDyZQMk7Jyy7iAxfXX0baMocte
         +L6LMD1NXXNYwKl4eR2F4wBV+cIdzdbEYiT6LAC1079m8g63sjRy01ffLYt3A+/lmFRL
         kvvAOAKhq/fkaSJ5SaWkdp711ghwZ5SjeLtDBERLpYq4jAYIWrTlWZZVDHwTHRdzsGpD
         WZ/CFFORt8RW8NQgaVvI3uKvedxkdInP9CrDKLs3hGeS0dgNp26tSa+ol45VtWntjQFj
         GvbsphmnmP1e4nWPAinO/nfkJd9Hz1Vq0fcPtOQVxGD9Tyim2nG4jiZiQRxRKFVZIyr3
         KzbA==
X-Gm-Message-State: AOAM533861uqGFE2hBLRgrw7rUnutfBK/F4RVqPKoYbXZB0yFbwB238Z
        V8V5LokFZ0rxPx2aIRKHXjaFQSloUDY=
X-Google-Smtp-Source: ABdhPJyJ2J8sskGXXS//80pWKe+59gPk1N1HgMJtX9oy+x8bwTlGvAUINwFwJFr8voAtmH9agAzh5A==
X-Received: by 2002:a05:6402:5250:b0:41d:8556:4191 with SMTP id t16-20020a056402525000b0041d85564191mr3586219edd.269.1649949109131;
        Thu, 14 Apr 2022 08:11:49 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id hx12-20020a170906846c00b006e8ad71c18fsm706995ejc.208.2022.04.14.08.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 08:11:48 -0700 (PDT)
Date:   Thu, 14 Apr 2022 18:11:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 02/12] net: dsa: add Renesas RZ/N1 switch tag
 driver
Message-ID: <20220414151146.a2fncklswo6utiyd@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-3-clement.leger@bootlin.com>
 <20220414142242.vsvv3vxexc7i3ukm@skbuf>
 <20220414163546.3f6c5157@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414163546.3f6c5157@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 04:35:46PM +0200, Clément Léger wrote:
> > Please keep variable declarations sorted in decreasing order of line
> > length (applies throughout the patch series, I won't repeat this comment).
> 
> Acked, both PCS and DSA driver are ok with that rule. Missed that one
> though.

Are you sure? Because a5psw_port_stp_state_set() says otherwise.

> > sizeof(tag), to be consistent with the other use of sizeof() above?
> > Although, hmm, I think you could get away with editing "ptag" in place.
> 
> I was not sure of the alignment guarantee I would have here. If the
> VLAN header is guaranteed to be aligned on 2 bytes, then I guess it's
> ok to do that in-place.

If I look at Documentation/core-api/unaligned-memory-access.rst

| Alignment vs. Networking
| ========================
| 
| On architectures that require aligned loads, networking requires that the IP
| header is aligned on a four-byte boundary to optimise the IP stack. For
| regular ethernet hardware, the constant NET_IP_ALIGN is used. On most
| architectures this constant has the value 2 because the normal ethernet
| header is 14 bytes long, so in order to get proper alignment one needs to
| DMA to an address which can be expressed as 4*n + 2. One notable exception
| here is powerpc which defines NET_IP_ALIGN to 0 because DMA to unaligned
| addresses can be very expensive and dwarf the cost of unaligned loads.

Your struct a5psw_tag *ptag starts at 10 bytes (8 for tag, 2 for Ethertype)
before the IP header, so I'm thinking it is aligned at a 2 byte boundary
as well. A VLAN header between the DSA header and the IP header should
also not affect that alignment, since its length is 4 bytes.

If "ctrl_tag" is aligned at a 4 byte boundary - 10, it means "ctrl_data"
is aligned at a 4 byte boundary - 8, so also a 4 byte boundary.

But "ctrl_data2" is aligned at a 4 byte boundary + 2, so you might want
to break up the u32 access into 2 u16 accesses, just to be on the safe
side?
