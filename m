Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEE85120AD
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241076AbiD0QA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241054AbiD0P76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:59:58 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082DA8070E
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:56:25 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n18so1921692plg.5
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S7gjHtnoBbugQauhNsDeWPF5G5twM4OriQvPe+xVavg=;
        b=IjLkvsUydINfST/SeE3kJPSTPMbbn1Qz9dv2EWCikm+f6aHgbuMsIJOUwGAluCFOFv
         8GBorrPOSw3MkEA8ebb/4/Xa9eiuLUObT3bYrskiT1VavjLKAcViXwfiuY+fkwkEDSnv
         rsrAEmjg51YA69Z0IObAvGMxePXUQL0GpSLKkPfd3I5tDiJ78B0ReBqmwkzfZd9cDQY+
         gPvJiMc53AaLS6Pikn+//xzrpHdpwXk3QZ/oirJL6q3HrsGLcST9aaN3HYXZMH34G/NJ
         2kURUdwHdfQkL7+EcINfm33CMWAOKq/RVQPWjmdGEfZ0SiieiBoKJRhEDumG8B2WW9Zl
         RyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S7gjHtnoBbugQauhNsDeWPF5G5twM4OriQvPe+xVavg=;
        b=k8BM9aUB4ccnDMBQYkeloR8eu13ZUr0idq5QUfKFLE72lP+KSCRrSWNYMdZgC6+uhh
         Pqe+T26ZEIZsWkyYmkLIodH5Mhr+loVmyAruvQFFafDYjGVzP3fxY6qibPmBQlga8lt5
         HsPa7iBDZrOOcMwKuv1+JgI73g2dqUhh8DVIT+X3/dVhK27jHRDlWZwFjU3Xn0yijayE
         CseW8+26cVFHk9+YllSVyIUU/MShu/W/S5A0SwfLlgk0Bs8SnSs0u2E+6MoN18qYtlLI
         QjihJjpJ0agSUcA8C2Bwm4Zc046HQ9y0aOlax6uVl1lUbMLBlgFiU1VIYADveoTyPd5R
         idcw==
X-Gm-Message-State: AOAM531um28EVeYsGqlvc36DyemH6DJY1J/8WEJbrmyzg2vo8Vaxw19H
        aXnwIy6AtJRsjLxp331WKLIE1g==
X-Google-Smtp-Source: ABdhPJwovTBCuIAY1Dof31W4pMLa6odSaAw525T/ZOd/QWQRPmu7DuY3/ib8HvU8rF8OJSvBa5Fjxg==
X-Received: by 2002:a17:902:ce01:b0:15c:eedb:f00c with SMTP id k1-20020a170902ce0100b0015ceedbf00cmr21330243plg.122.1651074984238;
        Wed, 27 Apr 2022 08:56:24 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id s22-20020a17090a5d1600b001d954837197sm7500133pji.22.2022.04.27.08.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 08:56:23 -0700 (PDT)
Date:   Wed, 27 Apr 2022 08:56:21 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 3/7] tcp: resalt the secret every 10 seconds
Message-ID: <20220427085621.5f2d1759@hermes.local>
In-Reply-To: <20220427065233.2075-4-w@1wt.eu>
References: <20220427065233.2075-1-w@1wt.eu>
        <20220427065233.2075-4-w@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Apr 2022 08:52:29 +0200
Willy Tarreau <w@1wt.eu> wrote:

> From: Eric Dumazet <edumazet@google.com>
> 
> In order to limit the ability for an observer to recognize the source
> ports sequence used to contact a set of destinations, we should
> periodically shuffle the secret. 10 seconds looks effective enough
> without causing particular issues.
> 
> Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
> Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
> Cc: Amit Klein <aksecurity@gmail.com>
> Tested-by: Willy Tarreau <w@1wt.eu>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/core/secure_seq.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
> index 2cdd43a63f64..200ab4686275 100644
> --- a/net/core/secure_seq.c
> +++ b/net/core/secure_seq.c
> @@ -22,6 +22,8 @@
>  static siphash_aligned_key_t net_secret;
>  static siphash_aligned_key_t ts_secret;
>  

Rather than hard coding, why not have a sysctl knob for this?
That way the tinfoil types can set it smaller.
