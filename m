Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5464555315F
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350092AbiFULvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349688AbiFULvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:51:24 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B91E2AC5C;
        Tue, 21 Jun 2022 04:51:23 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id ay16so7554342ejb.6;
        Tue, 21 Jun 2022 04:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=A6z8EyIWtSjhv1qsgDmsEARBUgF7vOWwaGhqdMdxjmg=;
        b=h7Tk4Gk4wXtwCe1JUnnRuM5joaDicK10WIlrLRYqUSB8s4RVm3M+pq0NJZYZCvbfDp
         2CZN7/B+2UzmiFEWBe/W1Yi1MnTiPhAmQcLPJNXOt/2o60AbraoPBABIrGZPpDKuXJwB
         KX97VI5bcuQG/RDpvMj43wp3kaWoF2UCDNzLnyqzMzZApgEICEHsuJl6+uVqgKbTurGj
         2O+hnqfyp13YZCKwsBNBVY7aQx+MOnYJnOgQIy89wH7jPh9ulnfWWqBoHmh/U4TVvOSu
         tvlDxtbXXbkZA5zElJ0C200MvOkVJIxU6ofYLRD0O+sqsYTjhR9gwmsrlwOerHb2z9EV
         tDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=A6z8EyIWtSjhv1qsgDmsEARBUgF7vOWwaGhqdMdxjmg=;
        b=Xe8UAe+lqj08F9RDSN7T6zldWf3R+sc49BTnwLOe4O/k631h1n/34KAHIk38Yvu3Iq
         QB2drcuXhiXelmwV9tLfaa9jvZsULVOGeCAUrfAXCxcdq1oDdndwj1IDOMActzBVM/s5
         NonmD9DgOEN6COw5pvOJL6zAKLQCbaa4cYqP77FdoeBz13pY9MGCofV9DyEABks5KU+m
         azzgtarOUzyKz7e7JwdHT/qnGIR+YEj6IoGhjVfwZYHnCWdGnFLXBS0iSIwz7maM1oBk
         Mr9hisOvLSpF5pWS906BlHYQdK7093ewUKKpmTvutnG/TqxTpaKtvQystkfKxyA8f+Wg
         oMSQ==
X-Gm-Message-State: AJIora85ZEjrdjfJHgXw97yAz3J40N6JOu1S/Nt8EOmroW8DuQZd30Ou
        6LUrwfcM0XysLiH3enCnQQk=
X-Google-Smtp-Source: AGRyM1sO8Ql94yNsfKTq6dsJ57UV5X0/W/zaMXn3wDgm+rtwheqIqyaZFXloYPeUq4AbigdikJ5Wjw==
X-Received: by 2002:a17:906:ee1:b0:70d:d293:7b30 with SMTP id x1-20020a1709060ee100b0070dd2937b30mr24861378eji.134.1655812282076;
        Tue, 21 Jun 2022 04:51:22 -0700 (PDT)
Received: from skbuf ([188.25.159.210])
        by smtp.gmail.com with ESMTPSA id s10-20020aa7cb0a000000b00435728cd12fsm7278397edt.18.2022.06.21.04.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 04:51:21 -0700 (PDT)
Date:   Tue, 21 Jun 2022 14:51:18 +0300
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
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v8 09/16] net: dsa: rzn1-a5psw: add FDB support
Message-ID: <20220621115118.fk6zlvehq4jbhvlx@skbuf>
References: <20220620110846.374787-1-clement.leger@bootlin.com>
 <20220620110846.374787-10-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220620110846.374787-10-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 01:08:39PM +0200, Clément Léger wrote:
> This commits add forwarding database support to the driver. It
> implements fdb_add(), fdb_del() and fdb_dump().
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
