Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6546E31CA
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 16:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjDOOUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 10:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjDOOU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 10:20:29 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAAC44BA
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 07:20:18 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id gc14so7633327ejc.5
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 07:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681568416; x=1684160416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JQZHOzrp1CSMZr3/LCtZ/qRG3bSDti2OPauWhjg3u0Y=;
        b=b4U286TToJP394+zoAXjqEcz8IAMBQFiSADETgjTh+ZBY+4noLGk7EajXG7D7EdLoe
         ejdehxwDC5EtsB+ZxrRmKg1Xi4UbGybXvGUnBnE2+OY8dkAcCNC4DQkzakGOzeIh8fkk
         cSYaq0WpX3fYWPYOIi4PnW9Sqf7LnOox+0r8oEwBoEwDouQI8vyPLxkEBYnaq8wadcHc
         U5CWFrKq4PGMrJUq7tSbpArDq9dA3DOwvdVoalrPh/ef+TANlmhyNT5nQQSE9M0vNl5c
         HHJMQo5VH0CZXay9wYfuGl/KZ6anPFoN615K1OfBgOdVjU0wDq1DXlnFImjxvNzJVSFe
         m18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681568416; x=1684160416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JQZHOzrp1CSMZr3/LCtZ/qRG3bSDti2OPauWhjg3u0Y=;
        b=JmVXyIneFeEV5epGXL7HMvs2bHEm0N5l+ooscpxdzGi1UMvv5ghHAJcRBJt4WlQqOA
         +/k+mMKiHCccqLMsgagRvwDUgg0JmNoEVtu6tGVr2lFiOxSlLfew3lvBpU2FXOqmnGZt
         Aq65sH3t0hczLUuVVVDqLMXB/5B59CgKara7MvFKu5QPsPDCeTfpdn5/EM/1jX7jTUDq
         I7kzB1TY4zdECDxe5Hsk8A/17aI2Wo687jw9FDYGbk+dMYHLiTFCVx16wVftfAhBqCjM
         q5YmVQSneRhdN/yg4fRIc5x3ecqiH3NANkXlXWD9dSzaXZkqbfQgY8RMMTbJqSLXBjVY
         XDqA==
X-Gm-Message-State: AAQBX9dlRVs/jMilRaDejMPtkWoSm2m1zXdZgB9xmoVx601FmhbNYs5S
        eUNJZmuM3uIgmxIFDBS2S4w=
X-Google-Smtp-Source: AKy350aidtteDe7g34jZznmfadGGndjcPfGVtgrUl8BRWyDKtSZtQm4mDM6h5hO0vrUBtCGTIHbmCg==
X-Received: by 2002:a17:906:2745:b0:94c:25f7:7324 with SMTP id a5-20020a170906274500b0094c25f77324mr1940294ejd.44.1681568416477;
        Sat, 15 Apr 2023 07:20:16 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id vt2-20020a170907a60200b0094f257e3e05sm694609ejc.168.2023.04.15.07.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 07:20:16 -0700 (PDT)
Date:   Sat, 15 Apr 2023 17:20:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Thibaut <hacks@slashdirt.org>
Subject: Re: mt7530: dsa_switch_parse_of() fails, causes probe code to run
 twice
Message-ID: <20230415142014.katsq5axop6gov3i@skbuf>
References: <ZDnnjcG5uR9gQrUb@makrotopia.org>
 <5e10f823-88f1-053a-d691-6bc900bd85a6@arinc9.com>
 <ZDn1QabUsyZj6J0M@makrotopia.org>
 <01fe9c85-f1e0-107a-6fb7-e643fb76544e@arinc9.com>
 <ZDqb9zrxaZywP5QZ@makrotopia.org>
 <9284c5c0-3295-92a5-eccc-a7b3080f8915@arinc9.com>
 <20230415133813.d4et4oet53ifg2gi@skbuf>
 <5f7d58ba-60c8-f635-a06d-a041588f64da@arinc9.com>
 <20230415134604.2mw3iodnrd2savs3@skbuf>
 <ZDquYkt_5Ku2ysSA@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDquYkt_5Ku2ysSA@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 03:02:10PM +0100, Daniel Golle wrote:
> As the PHYs are accessed over the MDIO bus which is exposed by the mt7530.c
> DSA driver the only middle ground would possibly be to introduce a MFD
> driver taking care of creating the bus access regmap (MDIO vs. MDIO) and
> expose the mt7530-controlled MDIO bus.

Which is something I had already mentioned as a possible way forward in
the other thread. One would need to take care of ensuring a reasonable
migration path in terms of device tree compatibility though.

> 
> Obviously that'd be a bit more work than just moving some things from the
> switch setup function to the probe function...

On the other hand, it would actually work reliably, and would not depend
on whomever wanted to reorder things just a little bit differently for
his system to probe faster.
