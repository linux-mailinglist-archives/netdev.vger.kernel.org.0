Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1CD4CCC1A
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 04:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237805AbiCDDNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 22:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiCDDNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 22:13:20 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED9B6400
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 19:12:33 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id qx21so14658133ejb.13
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 19:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xNYAIN2hA3gu+Z50PcYguQjtYMaTgvViFwg/zMWvPdg=;
        b=C91ewx+eVGaojXaWaATne1SlGFV0OwP9tb0JwVhKNq4pfhG8vlnvLSQnh2iC+76hMZ
         z616vnEFqeWwBivInT9ov9/vmLst4ao7v3Ssz0DBnZeRemiHNAnHADk6XOwCNVGdSkdS
         ftTdR8JfTnT5F824FCvZoc4zeTftRjpuwuO8CJf7qU5ZS6i6Xba4IVS6c5Cg2byqvNRK
         4GzRvUJ640KzhtfJWjizlki0mjqOwBf80vQYZ+TXycoErUfV4mXIjyNY8cKJDIvnssph
         rYZLI3aDPLf9bD1L47rV/x2jcl8iHL7WDCPRR185ilYUM0O9gm22J9E9oIGb4g+ZXRHl
         EWIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xNYAIN2hA3gu+Z50PcYguQjtYMaTgvViFwg/zMWvPdg=;
        b=WGICFDQmMelKJZ6ABay+iRPP+j2jJWjhzn1R9AFxLbVmIKi4XS7URbiHUQOlbOnxfe
         Ei7OTiRGBJPAL0tMQ7kTQbOppYNkh6Rl9+DcRrLeU4lYBuZ00K9H9G4gbirFUwil9quD
         xzdxewMZ3qg7pX5TMWQUqkY+qLgA9cPKtJVQb4KPpbC0+3K8pFiDxVPYhuHHqJrW+qH5
         mPrG93iEkonftxQXSavSGbMlu4+yGkYi5cAsMxADT2H0VtresRilW3E4LA+WP4xW2Icb
         bM0i1rF055T/v4jUCs/wkbxKc1Durp4bJ1fQYqjFrrFitvP3kaOnJOan9EFroKoOrcnx
         MmrQ==
X-Gm-Message-State: AOAM5336d6bdqlGJxEuZopx/gA7jmnq3sM6WIg4Dt9uEskeJOX4F8m4c
        rshyw0+RDqv1OWwZ512a13XzprtvBEAc0gwMtRzKVGLWhv4=
X-Google-Smtp-Source: ABdhPJxUStfkCWNQ2gHmKbAlS3rs4PJ25YAFJZjuDuhzzDtGl/AviFmGRx/AyeSxNh4C2Ex7gWSHZ6Phx6VOgyVdEiw=
X-Received: by 2002:a17:906:c141:b0:6da:b786:3fd4 with SMTP id
 dp1-20020a170906c14100b006dab7863fd4mr821608ejc.16.1646363551668; Thu, 03 Mar
 2022 19:12:31 -0800 (PST)
MIME-Version: 1.0
References: <20220303171505.1604775-1-bigeasy@linutronix.de> <20220303171505.1604775-3-bigeasy@linutronix.de>
In-Reply-To: <20220303171505.1604775-3-bigeasy@linutronix.de>
From:   Max Filippov <jcmvbkbc@gmail.com>
Date:   Thu, 3 Mar 2022 19:12:20 -0800
Message-ID: <CAMo8Bf+mw6BS4X06o9QGFZgkKiDavR7Li23hcO10KnntuxaWcg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/9] net: xtensa: Use netif_rx().
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Zankel <chris@zankel.net>,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 3, 2022 at 9:15 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> Since commit
>    baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
>
> the function netif_rx() can be used in preemptible/thread context as
> well as in interrupt context.
>
> Use netif_rx().
>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Cc: linux-xtensa@linux-xtensa.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  arch/xtensa/platforms/iss/network.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
