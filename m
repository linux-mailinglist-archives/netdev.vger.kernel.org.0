Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8B26C7E94
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 14:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjCXNOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 09:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCXNOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 09:14:51 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C08DEB71;
        Fri, 24 Mar 2023 06:14:50 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b20so7905681edd.1;
        Fri, 24 Mar 2023 06:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679663688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4C2Xjynd/QVbdXclxsjAeLaEctmSISPKI1FYwZ216X4=;
        b=DSLJ4H4zCmV45v+r2JCjP7WOdrz4EISGNt1vyczaJ430PPyQ2oVtKeZ/dodBd61oUF
         VDyn27zoK8NALvAC9QKi5eDtzcbikxPq5pYNCltdsZ5DfA5QVl1VlrEs7jmOJQekYcaF
         V6PwlfTOSRsAb2nntDsMz/wEOrN4Bt736YEPYMy5el8IcBVQZs+BExRNMO07cEfoEGWL
         m6osbPnxEOshH5ygJTBlsn1eHaRKSZdpSYgZmoVM0vAV5bhzkeVG1ovxmjtZNSJTzjoF
         KLit+xVQLV+vxr9raGo+Bv+qyipNr/zh3LvxoM/gj5AjgZJzBCcj2PHpaEJ7wlm8V24h
         bVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679663688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4C2Xjynd/QVbdXclxsjAeLaEctmSISPKI1FYwZ216X4=;
        b=XHQmdpiRZxv8zEsAprETujG2EI8u4xdIRaYNzVee/ofxAASAE5lKdmKh+IDZAcvZrm
         ecLhyex44tVagwj4k/Ji9ENR11v/tdk3FuF5EY6aTgsyguTK/UsqQD0hPbHseQth4Qdm
         GLd99Fwx8AIvqGDTxvqA7x/E0zgZFckJ7/D7LJIvIzNCaShjZ1Dj/9a6c/gXVtLRGXkS
         VZkNyp90JZhy/4R2nW8cRH1244V6a5FsDG7JgO7M++EAbRmqbqrqo40vXar7lw0//0X7
         Rv+i98d0K0khF8Juxu90/69yaG6gKr1XpnnVlDd3UY08srxABAfC/t1okSJ3y+3tJNLv
         Q35w==
X-Gm-Message-State: AO0yUKUaajg8ZGEaRzinz2RoTzMgao+SBLxoQK8xbbatWBR8kmaB83W+
        7b0zyQ/QADiTC6jB69Z/esE=
X-Google-Smtp-Source: AKy350YiRP0hA2xKwsJk3la5nIITaD+9SPkMNBL8zKCCZT6Tlc9ZQqosO+08awM/Wqj47MVUaVEZoQ==
X-Received: by 2002:a17:907:a50f:b0:930:a74:52bb with SMTP id vr15-20020a170907a50f00b009300a7452bbmr3064874ejc.14.1679663688396;
        Fri, 24 Mar 2023 06:14:48 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id o7-20020a1709062e8700b00933356c681esm8703435eji.150.2023.03.24.06.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 06:14:48 -0700 (PDT)
Date:   Fri, 24 Mar 2023 15:14:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Daniil Dulov <d.dulov@aladdin.ru>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-patches@linuxtesting.org
Subject: Re: [PATCH] media: dib7000p: Fix potential division by zero
Message-ID: <20230324131445.g42kvq5wzj2z3qil@skbuf>
References: <20230324131209.651475-1-d.dulov@aladdin.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324131209.651475-1-d.dulov@aladdin.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniil,

On Fri, Mar 24, 2023 at 06:12:09AM -0700, Daniil Dulov wrote:
> Variable loopdiv can be assigned 0, then it is used as a denominator,
> without checking it for 0.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 713d54a8bd81 ("[media] DiB7090: add support for the dib7090 based")
> Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
> ---
>  drivers/media/dvb-frontends/dib7000p.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
> index 55bee50aa871..bea5717907e7 100644
> --- a/drivers/media/dvb-frontends/dib7000p.c
> +++ b/drivers/media/dvb-frontends/dib7000p.c
> @@ -497,7 +497,7 @@ static int dib7000p_update_pll(struct dvb_frontend *fe, struct dibx000_bandwidth
>  	prediv = reg_1856 & 0x3f;
>  	loopdiv = (reg_1856 >> 6) & 0x3f;
>  
> -	if ((bw != NULL) && (bw->pll_prediv != prediv || bw->pll_ratio != loopdiv)) {
> +	if (loopdiv && (bw != NULL) && (bw->pll_prediv != prediv || bw->pll_ratio != loopdiv)) {
>  		dprintk("Updating pll (prediv: old =  %d new = %d ; loopdiv : old = %d new = %d)\n", prediv, bw->pll_prediv, loopdiv, bw->pll_ratio);
>  		reg_1856 &= 0xf000;
>  		reg_1857 = dib7000p_read_word(state, 1857);
> -- 
> 2.25.1
> 

Did you send this patch to the correct recipients and mailing lists?

$ ./scripts/get_maintainer.pl drivers/media/dvb-frontends/dib7000p.c
Mauro Carvalho Chehab <mchehab@kernel.org> (maintainer:MEDIA INPUT INFRASTRUCTURE (V4L/DVB))
linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE (V4L/DVB))
linux-kernel@vger.kernel.org (open list)
