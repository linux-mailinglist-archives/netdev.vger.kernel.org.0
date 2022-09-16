Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690245BAE83
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 15:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbiIPNsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 09:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiIPNsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 09:48:04 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4A3AD9B2
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:48:03 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id b35so31614140edf.0
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=nsQQwYO8zzBqN9vY+PWnNnpg3Mp0vBo7aurlDJ3647A=;
        b=ae0rvmrSJDa5SMlOm8chgCb8X3scNWgo+S6Wn9lKGpuigi0Jast5RriDW1b5T8HACX
         mf3DXXc61/ZW/L98ZORwmvHEZgNuLR053bY8NWB73RUNZQYv935jkepNqpRh9toInZd0
         FNA+5QIRewJcmKMl1nXQrtGgiNCf4M6BPDPYAL9vrSV8mVy9rHDrOACXvzOwgXfBgqwn
         Sz7+uuR2M7OmTaD+6z/w9FpljksgnnenRm6V5ahlCH+MoE55L4dicAZkDUIDxvvsSmb9
         F7COseX3n5KaECQxaowndnkIm8aMfwdTTYHVcF8aLtx6+bfOdBM4IKXJ8zH+gTr9Tarr
         MEFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=nsQQwYO8zzBqN9vY+PWnNnpg3Mp0vBo7aurlDJ3647A=;
        b=eNLJR5TAs1gRX5vIsltKvItRTVJexIQfDTj6y4h2w8142acx2vFNnN2Gx7nytiKnWe
         flheaSYUKWJABpq53IP/NB66ddbn99ENB7SfacHWmyDsJnb3WkYnykzZV4XWO3BFw0tg
         idjTdxm9bMsInE3Q96hv0vbUWmbZJVpjpRQoxRmiT+ZbBTQrBDDXSzoq6xuJDrOrdB2n
         R+HbguVxoswxNVxTaq9mbJWJz9as5J42yjA3Jk2f9VDrQxgRk9AskLxR4093EWcnvJhc
         xFvnkUyiskh43tAS+xaIojHIwktUmf1oyYEVygRlTecMoEWJppSoAf3wavgkFoWsVK8a
         y/DQ==
X-Gm-Message-State: ACrzQf1rp8UfMlDU6uvLMftCLc4DKbrrCDG68PJeQC6buR7XphvVvf8t
        TKzEaBMF/dko8LVbvFXGYk4=
X-Google-Smtp-Source: AMsMyM4h+86T7jlxHq6kV6xSnLl8REOsaaSJsK1to6MUgbiz5t4zdWGJUczlKw/AZ5nZGuRUoHYqZg==
X-Received: by 2002:a05:6402:198:b0:442:da5a:6716 with SMTP id r24-20020a056402019800b00442da5a6716mr4047332edv.5.1663336081459;
        Fri, 16 Sep 2022 06:48:01 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id ov22-20020a170906fc1600b00770e405ad4esm10337379ejb.124.2022.09.16.06.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 06:47:59 -0700 (PDT)
Date:   Fri, 16 Sep 2022 16:47:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v13 2/6] net: dsa: Add convenience functions for
 frame handling
Message-ID: <20220916134757.migsntozviogv2jh@skbuf>
References: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
 <20220916121817.4061532-3-mattias.forsblad@gmail.com>
 <63247bbd.5d0a0220.2e1d3.e804@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63247bbd.5d0a0220.2e1d3.e804@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 08:06:38AM +0200, Christian Marangi wrote:
> > +static inline void dsa_switch_inband_complete(struct dsa_switch *ds, struct completion *completion)
> > +{
> > +	/* Custom completion? */
> > +	complete(completion ?: &ds->inband_done);
>
> Missing handling for custom completion!
>
> Should be
>
> complete(completion ? completion : &ds->inband_done);

!!!!

https://en.wikipedia.org/wiki/%3F:#C
https://en.wikipedia.org/wiki/Elvis_operator

| A GNU extension to C allows omitting the second operand, and using
| implicitly the first operand as the second also:
|
| a == x ? : y;
|
| The expression is equivalent to
|
| a == x ? (a == x) : y;
|
| except that if x is an expression, it is evaluated only once. The
| difference is significant if evaluating the expression has side effects.
| This shorthand form is sometimes known as the Elvis operator in other
| languages.

cat ternary.c
#include <stdio.h>

int main(void)
{
	printf("%d\n", 3 ?: 4);
	return 0;
}

make ternary
./ternary
3
