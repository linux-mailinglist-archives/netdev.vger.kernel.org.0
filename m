Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE26553154
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350051AbiFULta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbiFULt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:49:28 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ADB2A722;
        Tue, 21 Jun 2022 04:49:25 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id e40so6440108eda.2;
        Tue, 21 Jun 2022 04:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/KjuSvz2XM+mtCdWacCX6VCvTINBuSfQJWfr0MpTBYE=;
        b=VKl69iGuhLsKZHNxt1BIgtYgpduAbtN4852TgXZwpFwGJSjhS62pxBCIASZI1oO+mh
         c1nMfOHZZhsQ2A59VvWXyGDbzQ8n9Pxm3n7ORjLbQWAV61aSBKEg9MGLg6AqGL+B8T/0
         INUy1M6Q3LufrHxYbTmsYyK72l7VFRYip8kDLnO5THtoUQYwV5bQZjiCEnlNxnUqngdL
         V/mNtbDpUyeOlp4OQ2SMnRKppECvO0o822u6ktYYeKKMrB8LQPfZu7Pppjy3l2v/ne28
         90ObeMMtUjjjTDHbRo7q0s0+TJFE/20hZ9TcvdLnrjeWJeo+mB84lxg8KPBN2ZTZLEIB
         aW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/KjuSvz2XM+mtCdWacCX6VCvTINBuSfQJWfr0MpTBYE=;
        b=bb1qLKL8wiQ5b+LFufT/F51RQecIppCaPK5/fjom3FH78PnRPNb9DDu4tbnBToPTEH
         oW6UkDydZeft0oJFCj3iIGOjcgBU1+ymxsYHivRvhQBeK8i9dgP8PBdN5BQwyaoLbA+G
         BeIYjTgNmH35G2d9AumUrxKw+2r5s8FeIPCLV5QF+X0VfNHLdluJ6g7WhzSJhFKqTqw/
         1Z+5OiI2SPGVV4gFNLPMYUaI6mk5W7XzDGSh0CWUJN8IevtnNXrhqsWadog91cmwnXZb
         TNi96ZK0AOYaf8VTVH4j6WSH+GLQX4te2gyvU772/fTK1CW17qw8F14WLxlGUfp99lnI
         v0tQ==
X-Gm-Message-State: AJIora/PiKQNvlfZNTV2G4ohbUHHMIN161iN31JCKIU6A/NQyK8i87sT
        yT9J+X4tYpXHmeDkfITTjAk=
X-Google-Smtp-Source: AGRyM1uPnk6NbxBtk4hnGGHQRIHPHUbfEBOTeMFMH9wrgytTZvuC2D6MWfc7DJaq7MbviOagDeALnA==
X-Received: by 2002:aa7:c681:0:b0:42f:b180:bb3d with SMTP id n1-20020aa7c681000000b0042fb180bb3dmr34292639edq.191.1655812164154;
        Tue, 21 Jun 2022 04:49:24 -0700 (PDT)
Received: from skbuf ([188.25.159.210])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906538800b006ff05d4726esm7446318ejo.50.2022.06.21.04.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 04:49:23 -0700 (PDT)
Date:   Tue, 21 Jun 2022 14:49:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next v8 07/16] net: dsa: rzn1-a5psw: add Renesas
 RZ/N1 advanced 5 port switch driver
Message-ID: <20220621114921.qvzpn2atckq7ldd3@skbuf>
References: <20220620110846.374787-1-clement.leger@bootlin.com>
 <20220620110846.374787-8-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220620110846.374787-8-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 01:08:37PM +0200, Clément Léger wrote:
> Add Renesas RZ/N1 advanced 5 port switch driver. This switch handles 5
> ports including 1 CPU management port. A MDIO bus is also exposed by
> this switch and allows to communicate with PHYs connected to the ports.
> Each switch port (except for the CPU management ports) is connected to
> the MII converter.
> 
> This driver includes basic bridging support, more support will be added
> later (vlan, etc).
> 
> Suggested-by: Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>
> Suggested-by: Phil Edworthy <phil.edworthy@renesas.com>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
