Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED62E522F8E
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbiEKJgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241096AbiEKJgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:36:44 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19A41A07D;
        Wed, 11 May 2022 02:36:42 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g20so1826532edw.6;
        Wed, 11 May 2022 02:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=70Qlhkcc4Ow/r5C//bTIZEag8dRv3Msy3Svgs6lC2hI=;
        b=flahq3cL2dnd5v3fLrVHVfP6KORvv3Nm+FhgP/SSZP+l4mdQ3hpY3kR5byA1sMrvjT
         bP7q/WMKmli69dcZGaEctSVq0hHf1pjHd+vSIT+ok5ew/Ag03r69OYUYcoZkc+Z3dMZq
         WIkBDEyaA6im6AIRuFHLyVD6wVpJmIHhWpvZ1Au4nvxsuSWX+8/js4xYyl2w4v2ACn8J
         oFgsH/ZgjKRklnHzMkmsqXbBwUcDjtCHchd9wMmkSzaxuMX8e0od6at3Q+H4pVaVQ46E
         7Ci/ROMxCIhJ6BHxuwiPEycQlwFkd1bzE/9IOckbsmLyrgYdAlBu5UrzgLLCl+zm5xsc
         ydgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=70Qlhkcc4Ow/r5C//bTIZEag8dRv3Msy3Svgs6lC2hI=;
        b=amIl+OngMofPNL6uZV8nrJLaNT1/WnqzrMEGhGVZtoAjjlGRr2Qafh+EvIbgEffXIr
         zfy9Qn/k7WVEjZyKPj434OVxte3MmuRPUS8YIef6gtWpD7PqGq6pQNgeNKQUDCTiOUUX
         WrsD33i1S/HKnn0tubSypFuNyXzcPB05VCmuXkAZI4uVRH3vvp3/JMKPt56id7F7bluN
         eI8KcL48Wu06Po3MTAVRcFTzBLNWTwU1IrLeWEUJKQYDTIn9qSSVYuXUXQLYF4Jd8eWb
         pyTDeys1pPS17JgKxba7pMtFCM9uOhE7QTdOHuNGJ3ctDIdjJM+64JQAGUHIe+c8Wr9N
         lbbw==
X-Gm-Message-State: AOAM533sojFqHcLyk/afiHtNNvNyzMGjdQxafyERaSiycjdTSpV9ooSw
        vaXDFKd7WGzy+yXBnueyagk=
X-Google-Smtp-Source: ABdhPJx8eOqhXvG8IguKS02jcUHHeREfjnKpkk3qk3xLY82RHhp4Lk6jY+vKDSWdDEeIntvpnYiuGg==
X-Received: by 2002:a05:6402:1a34:b0:425:ca01:58ec with SMTP id be20-20020a0564021a3400b00425ca0158ecmr27804005edb.373.1652261801188;
        Wed, 11 May 2022 02:36:41 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id z5-20020aa7cf85000000b00428b4381686sm878579edx.64.2022.05.11.02.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 02:36:40 -0700 (PDT)
Date:   Wed, 11 May 2022 12:36:38 +0300
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
Subject: Re: [PATCH net-next v4 06/12] net: dsa: rzn1-a5psw: add Renesas
 RZ/N1 advanced 5 port switch driver
Message-ID: <20220511093638.kc32n6ldtaqfwupi@skbuf>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
 <20220509131900.7840-7-clement.leger@bootlin.com>
 <20220509160813.stfqb4c2houmfn2g@skbuf>
 <20220510103458.381aaee2@xps-bootlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220510103458.381aaee2@xps-bootlin>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 10:34:58AM +0200, Clément Léger wrote:
> > By the way, does this switch pass
> > tools/testing/selftests/drivers/net/dsa/no_forwarding.sh?
> 
> Unfortunately, the board I have only has 2 ports availables and thus, I
> can only test one bridge or two separated ports at a time... I *should*
> receive a 4 ports one in a near future but that not yet sure.

2 switch ports or 2 ports in total? h1 and h2 can be non-switch ports
(should work with USB-Ethernet adapters etc).
