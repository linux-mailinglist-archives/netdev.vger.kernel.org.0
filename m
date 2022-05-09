Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7C7520152
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbiEIPoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiEIPog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:44:36 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D430F2DB
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 08:40:42 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id i27so27593690ejd.9
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 08:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B2mgnI+9urrOy853Kd1n6sCiO+qYSmEpyM81Uf9ODR8=;
        b=ZO61L/Ub4v4Uxr62NTC6cO+qA529j+jbkXJDcG1ruhv2fTTtt7Md2jVGW+zoFxVoKp
         lZxTetuNuaEaV4g2G/pQiEBJduSN7GdvXxpc2oPBdvZMFvN7up7mo+ZsXgn8HJexrYge
         P4E6rE0Y4CztyLM7oD2a0RiE8A09ZmGUgkWEpB99VZh67TqmrFR+fG5GF8eQb53VnSY+
         X5SfTEQTrlrXOI3DL6DIBhiffw0bcx1JjuFuHYFeIaBflTPV/j3Ycy0oUoD1X00FOeEx
         SjrpmeY61g2Y3fnendoYVSxyx3tvNXNVoaRIYgApiOluN8If4pcPEuyCdKYWbO8NfLaG
         OQHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B2mgnI+9urrOy853Kd1n6sCiO+qYSmEpyM81Uf9ODR8=;
        b=vZY1Ush+uEAKosAu5VDFvOW7AtCgN4WwE6GvDd9rkoaUi9k5Ylp1e2PFzHygjzc4Jx
         GImUXeBBercCavOWnSgIiH6SCSPWqZ1wQxEGhg87i/yOG5/n+J5womIig0VRyDJ0O9rS
         MURNsNtkX1qm82MPhmudHGuE8wnJMw7KRBvoqEs7bhRqkLdRYYMw4+WRrtH1CLJ+mkMa
         UigrouShXRm3BTyKuO5FS61zuxhEDjOdwJlSotNfXI51C1cNynptvvEWspbAEpgHjTRT
         Ik8zBofN+FNn9rCjqX1SStarc2WcVvVbPnynGOhTKk+HVhIlSV+mbSPKkfECA5Cplymy
         Es7g==
X-Gm-Message-State: AOAM533hPmF1+zxp/ii7vc/zdJloO/5GYjPY3b3eivKf7OH+1RbhD6GT
        y080xnumhJv8Tch1QUkETcQ=
X-Google-Smtp-Source: ABdhPJzUoLLXYn2HpC7KsR48dpAl9PE3CV+4MQyKyXV728yNc0SHlGy5sj93tyGs3tmMnozeyW9cyw==
X-Received: by 2002:a17:907:7f9e:b0:6f4:d3d0:8d8e with SMTP id qk30-20020a1709077f9e00b006f4d3d08d8emr15919489ejc.501.1652110841243;
        Mon, 09 May 2022 08:40:41 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id m26-20020a17090672da00b006f3ef214e06sm5175941ejl.108.2022.05.09.08.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 08:40:40 -0700 (PDT)
Date:   Mon, 9 May 2022 18:40:38 +0300
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
Message-ID: <20220509154038.qt4i6m2aqxuvhgps@skbuf>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
 <CAJq09z7+bDpMShTxuOvURmp272d-FVDNaDpx1_-qjuOZOOrS3g@mail.gmail.com>
 <CAJq09z5=xAKN99xXSQNbYXej0VdCTM=kFF0CTx1JxCjUcOUudw@mail.gmail.com>
 <4724449b-75b2-2a25-c40b-e31bfcffa7ff@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4724449b-75b2-2a25-c40b-e31bfcffa7ff@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 08:36:19AM -0700, Florian Fainelli wrote:
> On 5/9/2022 12:38 AM, Luiz Angelo Daros de Luca wrote:
> > > > Hauke Mehrtens (4):
> > > >    net: dsa: realtek: rtl8365mb: Fix interface type mask
> > > >    net: dsa: realtek: rtl8365mb: Get chip option
> > > >    net: dsa: realtek: rtl8365mb: Add setting MTU
> > > >    net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
> > 
> > I didn't get these two, although patchwork got them:
> > 
> >    net: dsa: realtek: rtl8365mb: Get chip option
> >    net: dsa: realtek: rtl8365mb: Add SGMII and HSGMII support
> 
> Probably yet another instance of poor interaction between gmail.com and
> vger.kernel.org, I got all of them in my inbox.
> -- 
> Florian

But you were copied to the emails, Luiz wasn't.
I'm also having trouble receiving emails from the mailing list, I get
them with a huge delay (days).
