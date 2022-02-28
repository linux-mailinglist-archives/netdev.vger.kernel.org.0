Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A754C707E
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 16:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbiB1PXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 10:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbiB1PXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 10:23:03 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7B8E0EE
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 07:22:24 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id x5so18062940edd.11
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 07:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=JL31O1c434hLBaT9+uaQB/kbdracoLl+AsXqc6gXEzE=;
        b=GaQnxUrZLZPF0Xe2XYeOjkUIQ5yf+c97pOUOe2IoJZjIky5juZRHWCMCFvr7xM+a9c
         7Js0YGdsvkk39bf3ww73jYYf9n37vgyqFEgSF6HYnkDsc/5150bVJKlDjEtzKtFOU4lf
         rq4HuzzOeWDVDgPxuEd2cRPoP9UtxIePX8WVGN3JAwAjT5XGEM64QSCIGs72QiKq8YS0
         0jmIYRSiXjmaAASaYXBVnO7su7iEXzy5GHTiMBHgQ9bki6fZXwLB7IQetGxTUi9MkofR
         P/eNFfVIwkMEd3J+0wt16bKALxdHCBe3TNI7zNig2NQ08cjqYOfPfvU6APKlQBc2Am7c
         WegQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JL31O1c434hLBaT9+uaQB/kbdracoLl+AsXqc6gXEzE=;
        b=rWUrwOh0RfzQrhSJkxCBxAe8MX1VyayJUPplHVHgxJDuSIKnTr3h1wFR2yCAHAlteg
         WkJk8rHQVzjCOBEDGJyxdzP424VTLbA+0jIk9E/V9gOAofXBP0Usvp24J+KczBfd+bCY
         SoOPQw3nmMaThm+hKdoIRXlYUF3mNjSOSUYAndmd7u8ih9jiVxdl2Xj4xdhFwUGV0guW
         7oxo2EyNj7hhqv63clPoFkSqH1sCgoUz0vQVz9EikCYt/lBDH4o5TTsyGRjIwo1EVpwz
         Ggb7uu4LIBVu1/fC7GgdiD055D7IUAFbnFpSu3jVDV5b+Xji2pRelH1GrO2B81K/ZGF/
         8rbQ==
X-Gm-Message-State: AOAM531oRNPRAPxaj2H7MluiqALslVKKnCVLXAlVLu+7pB9bfMroMVgv
        DssdqsvJwKgXmgjecJTBg636CsVjnoQ=
X-Google-Smtp-Source: ABdhPJxvqNaLSXJUaVBlWU4jR8u888JdDKH74bwpxOfe0bjK27sSOOdO8+PDiP55LslUtdH6z2uR0Q==
X-Received: by 2002:aa7:c446:0:b0:410:9a8e:9b85 with SMTP id n6-20020aa7c446000000b004109a8e9b85mr19536757edr.319.1646061742954;
        Mon, 28 Feb 2022 07:22:22 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id ka6-20020a170907990600b006ce54c95e3csm4466485ejc.161.2022.02.28.07.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 07:22:22 -0800 (PST)
Date:   Mon, 28 Feb 2022 17:22:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 2/3] net: dsa: tag_rtl8_4: add rtl8_4t
 trailing variant
Message-ID: <20220228152221.t4hpni66hav2ockb@skbuf>
References: <20220227035920.19101-1-luizluca@gmail.com>
 <20220227035920.19101-3-luizluca@gmail.com>
 <87zgmbb34o.fsf@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zgmbb34o.fsf@bang-olufsen.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 28, 2022 at 12:13:28PM +0000, Alvin Šipraga wrote:
> Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:
> 
> > Realtek switches supports the same tag both before ethertype or between
> > payload and the CRC.
> >
> > Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> 
> Hi Luiz,
> 
> Please note that you should normally put my Reviewed-by after your
> S-o-b. After your v1 (and assuming you remembered your S-o-b) it should
> be treated as append-only. Gives some chronology to the review process.

I don't know if this is a hard and fast rule, but it is also how I do
things, and how b4 applies the tags as well. But I've seen people do
otherwise too.
