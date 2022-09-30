Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5262D5F0CE2
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbiI3OBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiI3OBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:01:11 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFF0110B0F;
        Fri, 30 Sep 2022 07:01:08 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l18so6988363wrw.9;
        Fri, 30 Sep 2022 07:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date;
        bh=XUyBB8pEItlXbD0B5GU+vaiyQaw+b+AHaZioNi2oN5o=;
        b=TUfWjdAfGeq6tqxfGs3itn7f4azVzeCFkPra38Fg38IPNYJocMDjxqW8n9Qh68Zttk
         3PCrGlJZ8n7bzxNy8gjh6WiN+kfn59bjbejJiMm5gkx38SV4j4QIqSKsEDjDxjH4rT67
         fGJK71wuxMLy88661y8d7FyuoVFSH2KgySjIJj+oBzt/wr6ZBz8sVpkhkcK3P60VFv6q
         MeECpY3IekPIQmXF+/DmqLjMEUY2a7851msCarjzhhA4d7M9ZX1D1OL193jqs1/XEKCS
         /cSgQpmCICJcsZoufEh0eFn8b3nWUX4M9shSZZS11TLhVr4aUVpukko0YKK7jv92mNGI
         ntKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=XUyBB8pEItlXbD0B5GU+vaiyQaw+b+AHaZioNi2oN5o=;
        b=rAHMJm3moRU59+n9eF/mEQ628NeOEwFgLzcvb3WBMShqMg4gBVkKuTwK7v2e1zs5aW
         dweUn3O5EunqcoSHPwNLoSxJZNl5zWyEelozyizMrdpF0X5CpKC+PNbUye9P7ZCfml7F
         aaNVQ9qHqdKNd/WIwJExZ4iaj7sjQ2XTnbnrsQ24orAAxGFZKN7N/I5peRGiyuM/mFgN
         GrLz65ZZwyQiJgvkINWjfP5h6qn1x3wHhpQrQeHLoj3BXZRXGYYM7fradq/5fw2d4iQI
         IlcWYM2ePr6gfk7QnTd2aUOfXpTtfoCioXLpslQ9R0FiG4HFi6uqUciHuycSjNecAqrs
         dvgQ==
X-Gm-Message-State: ACrzQf0e6ap1BTqw7ISBMHvecE0y7ZP6q69EO6kHHVlvmg+Zs0kihPdy
        ZSMqm5pjqLYLkWeKg76MwPOcrsaIfQ==
X-Google-Smtp-Source: AMsMyM6xxJmy3zlVG5Nlj9PWTvHARgG8b1yberrgdsgqkfCeppKU1pvKMQH/egHAfgZD6zvrU+ckug==
X-Received: by 2002:a05:6000:188a:b0:22a:e4b7:c2f4 with SMTP id a10-20020a056000188a00b0022ae4b7c2f4mr5778151wri.446.1664546466658;
        Fri, 30 Sep 2022 07:01:06 -0700 (PDT)
Received: from localhost.localdomain ([46.53.248.20])
        by smtp.gmail.com with ESMTPSA id n186-20020a1ca4c3000000b003a8434530bbsm6846099wme.13.2022.09.30.07.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 07:01:05 -0700 (PDT)
Date:   Fri, 30 Sep 2022 17:01:03 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     viro@zeniv.linux.org.uk
Cc:     ebiederm@xmission.com, torvalds@linux-foundation.org,
        David.Laight@aculab.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, serge@hallyn.com
Subject: Re: [CFT][PATCH] proc: Update /proc/net to point at the accessing
 threads network namespace
Message-ID: <Yzb2nyYK94gcOKOR@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Al wrote:

> Just to troll adobriyan a bit:
> 
> static const char *dynamic_get_link(struct delayed_call *done,
> 				    bool is_rcu,
> 				    const char *fmt, ...)
> {
> 	va_list args;
> 	char *body;
> 
> 	va_start(args, fmt);
> 	body = kvasprintf(is_rcu ? GFP_ATOMIC : GFP_KERNEL, fmt, args);
> 	va_end(args);

Ouch... Double pass over data. Who wrote this?

> 
> 	if (unlikely(!body))
> 		return is_rcu ? ERR_PTR(-ECHILD) : ERR_PTR(-ENOMEM);
> 	set_delayed_call(done, kfree_link, body);
> 	return body;
> }
