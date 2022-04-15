Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103505028AC
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 13:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349151AbiDOLIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 07:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352685AbiDOLH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 07:07:56 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C009680F;
        Fri, 15 Apr 2022 04:05:28 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b15so9567882edn.4;
        Fri, 15 Apr 2022 04:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aNHgNCbgtVNEO2BN8vXFcv/xIVvPMu9dYuO7n9SQH/Q=;
        b=b+dxuyyW78CHTyt8nvSp6UEZCi6NcD7K8ggtz388LM1PSEu/OLRIrxQWqXdANsVkc3
         FQOp4Xi0upySR4tkCJfpS+GCb+nsgkgM6qXChV5u6DtVneqBwJIEMp3n3H/a0juFscen
         HUphhBL94AAnbA0lYMyc1RAxypQBDbz/j1GfpE9vd8B33OZKWL5sbk+3GkJTTlhlj+vJ
         /Vy2EVqxmNuXdpxGBlFXhSN6iTgBsh9RJPt9IKiCma+qizoqkUkR43Nw/tcl+cTNGMo6
         gftdEs+5GJmY1Wzdxpb9kLzXHn9wDGE4eV3Z3jI2c8Tp32zvUJqrieqNTk6EtV0dSCjz
         xUAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aNHgNCbgtVNEO2BN8vXFcv/xIVvPMu9dYuO7n9SQH/Q=;
        b=ufGio1xqHs8akcISTTgVvWU5fBxUATIf8yc5bQbfsQ+pHH4ORfUWicef8rZ5qsXvmm
         5WPZpbpsiinqvzVpNi0xp9Z2Figzy58qdeTbuDX1y9RTbflny+5ZG5b3DWzkFyyhgmKs
         KOpfdxnF0iQJUMnC96GrOaLY8I4nJLNDQ2rkk9e9MXPbGRRM4fkMHPlETybNkKksPlg4
         bdiaE/k9iTQ3JbRR8LJhqJl4zBLJoPBFgRqElFZrnjJy9vcSfiAefMhH1DrbMPpvSuHo
         VIx6zCsjMgTB5ZCdv0MjAmUC06r06a/cxWY+qqVbebgJtVoiHYpOzvhZldp3BbSXes3J
         zhFA==
X-Gm-Message-State: AOAM530Vhxl6AdnTlyZs8t2+D7zx2tBAVQoJIP4H14WqVx2lnRXT2jxQ
        SwWMLLtBOwFXCbsinHWbf4s=
X-Google-Smtp-Source: ABdhPJxir9Fv9dO2LvYZxagXMGCO2X2Qw+Y06fTPieGCLbeU/AHQQrvrOPgc5p/X43uvfvrnIff5Ag==
X-Received: by 2002:a05:6402:e85:b0:41d:121b:f436 with SMTP id h5-20020a0564020e8500b0041d121bf436mr7641355eda.121.1650020726814;
        Fri, 15 Apr 2022 04:05:26 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id r3-20020aa7cb83000000b0041b573e2654sm2477700edt.94.2022.04.15.04.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 04:05:26 -0700 (PDT)
Date:   Fri, 15 Apr 2022 14:05:24 +0300
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
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next 06/12] net: dsa: rzn1-a5psw: add Renesas RZ/N1
 advanced 5 port switch driver
Message-ID: <20220415110524.4lhue7gcwqlhk2iv@skbuf>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
 <20220414122250.158113-7-clement.leger@bootlin.com>
 <20220414144709.tpxiiaiy2hu4n7fd@skbuf>
 <20220415113453.1a076746@fixe.home>
 <20220415105503.ztl4zhoyua2qzelt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415105503.ztl4zhoyua2qzelt@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 01:55:03PM +0300, Vladimir Oltean wrote:
> > > The selftests don't cover nearly enough, but just to make sure that they
> > > pass for your switch, when you use 2 switch ports as h1 and h2 (hosts),
> > > and 2 ports as swp1 and swp2? There's surprisingly little that you do on
> > > .port_bridge_join, I need to study the code more.
> > 
> > Port isolation is handled by using a pattern matcher which is enabled
> > for each port at setup. If set, the port packet will only be forwarded
> > to the CPU port. When bridging is needed, the pattern matching is
> > disabled and thus, the packets are forwarded between all the ports that
> > are enabled in the bridge.
> 
> Is there some public documentation for this pattern matcher?

Again, I realize I haven't made it clear what concerns me here.
On ->port_bridge_join() and ->port_bridge_leave(), the "bridge" is given
to you as argument. 2 ports may join br0, and 2 ports may join br1.
You disregard the "bridge" argument. So you enable forwarding between
br0 and br1. What I'd like to see is what the hardware can do in terms
of this "pattern matching", to improve on this situation.
