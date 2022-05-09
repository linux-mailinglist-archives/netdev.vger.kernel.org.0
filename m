Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66E6520199
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238642AbiEIPx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238639AbiEIPx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:53:57 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612772D76E4
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 08:50:02 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id k27so16805908edk.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 08:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lMkEoa9+yW0Tgt/AbLxHoi++ozBGROvx4EfB2CXxtKM=;
        b=VLrZeqFj204cSJ7qJZ303TI8v6CvnbFpHXEc1aOjnTcrYMs10quny5i/TQ9HfMr7Ep
         zDSC8eRmPtVmfGfU7+4Lqxelrm9YkAjvYI0+o/S0TjCbNqydYXXu44+YHlAlu0ocgANC
         u9Z66E22VO884bg818s0VhJ6HymwIuhcjBW/wQSdfajY0RqDKJP08qYHWvF0Ta00uSNQ
         j8SAnU8KjZUOv9A3IWK+4RN1s49jMzq10LdbWGqf/7IoxUIFdLtmzAG6pm6mkAk/akHL
         vptu100v8qNFQwnz+3ntd9bzkvcilq4r8vzF6xaDFyepjCnZ4YA+SOT09xH+YlyBF6Wp
         Z8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lMkEoa9+yW0Tgt/AbLxHoi++ozBGROvx4EfB2CXxtKM=;
        b=fbttHhNWdv+IAOfRqeGC8/h6aeObsvKv2UKSRtOtJJ03E/w4cIybBjJRR4BCtPLego
         rQmaRPGzjn5ef9e5jFg3HfJ0STOAiyAZPzC12XG2zad7Mq7oLcp8sxAjeZelsAjbYK8S
         ZVOMELqMZhniQe5exW5HU2qjFKtxYDArQPZ/mFEpkSey4vz+PMlmawItgLuOAyFnlY09
         2vCkjXk7fughO+O7p/zMVYBDu7WJHQ7YbIUF8f0gMJeM1IFQAy/GNCig3qdx73GrPjoY
         WsC4dDGqEWfiyusKjGJCPqCOe9tpnRvUiaIYtX4hcWm12yiseIrlXdev8Yg5my/7CH6F
         MYPA==
X-Gm-Message-State: AOAM532A+RFmc0+DGLEvBSdbZCUFAc6nyTOIcXmrEoRA4M1rj/zppWvI
        lXDZrUq6/Be5ks0cuwPc25o=
X-Google-Smtp-Source: ABdhPJyp45Z2+Slfg/HXu43RGoEC7H2D8xmdDVI0vl1biPrDsNYBnM/j8anlMINESxwrGCMGW//YLg==
X-Received: by 2002:a05:6402:d05:b0:425:b5c8:faeb with SMTP id eb5-20020a0564020d0500b00425b5c8faebmr18140248edb.273.1652111400832;
        Mon, 09 May 2022 08:50:00 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id jz1-20020a17090775e100b006f3ef214e52sm5223878ejc.184.2022.05.09.08.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 08:50:00 -0700 (PDT)
Date:   Mon, 9 May 2022 18:49:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH 0/4] net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII
 support
Message-ID: <20220509154958.koeyl4ubjetdu5dw@skbuf>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
 <CAJq09z7+bDpMShTxuOvURmp272d-FVDNaDpx1_-qjuOZOOrS3g@mail.gmail.com>
 <CAJq09z5=xAKN99xXSQNbYXej0VdCTM=kFF0CTx1JxCjUcOUudw@mail.gmail.com>
 <4724449b-75b2-2a25-c40b-e31bfcffa7ff@gmail.com>
 <20220509154038.qt4i6m2aqxuvhgps@skbuf>
 <78133b16-7e33-7329-3300-a30df16ada5d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78133b16-7e33-7329-3300-a30df16ada5d@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 08:41:38AM -0700, Florian Fainelli wrote:
> On 5/9/2022 8:40 AM, Vladimir Oltean wrote:
> > On Mon, May 09, 2022 at 08:36:19AM -0700, Florian Fainelli wrote:
> > > On 5/9/2022 12:38 AM, Luiz Angelo Daros de Luca wrote:
> > > > > > Hauke Mehrtens (4):
> > > > > >     net: dsa: realtek: rtl8365mb: Fix interface type mask
> > > > > >     net: dsa: realtek: rtl8365mb: Get chip option
> > > > > >     net: dsa: realtek: rtl8365mb: Add setting MTU
> > > > > >     net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
> > > > 
> > > > I didn't get these two, although patchwork got them:
> > > > 
> > > >     net: dsa: realtek: rtl8365mb: Get chip option
> > > >     net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
> > > 
> > > Probably yet another instance of poor interaction between gmail.com and
> > > vger.kernel.org, I got all of them in my inbox.
> > > -- 
> > > Florian
> > 
> > But you were copied to the emails, Luiz wasn't.
> 
> Yes, that much is true.
> 
> > I'm also having trouble receiving emails from the mailing list, I get
> > them with a huge delay (days).
> 
> Time to switch to a different toolset maybe:
> https://josefbacik.github.io/kernel/2021/10/18/lei-and-b4.html
> -- 
> Florian

I guess I'll finally try lei out, thanks.
