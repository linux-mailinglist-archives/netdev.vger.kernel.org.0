Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1055867D869
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 23:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjAZWcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 17:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbjAZWch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 17:32:37 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDC56B983
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 14:32:17 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id m12so3227619edq.5
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 14:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CASC8qHfi6FSsKB7UllTORAfQ+O2NNzwp78HdWbLEwg=;
        b=EnSfpGW2O17/2EGNuqfi0V1fIaK2mHROkGaBzNPIIZ3N06ToM4KKvlJMDAZ8Ermmw6
         ++8WOhuiffljKnWiysqe639ZQwgq8EKSH5K2eH+psEOQBp1Ib0Jq4vxhr4vylFekvF/y
         Fbf5K1gHu+DlnWzh5nugZNqNgE9KvBJXKU2M4JQn0/SKREWTCg+NLF07C/sngK2gLSLN
         4KPk//inZsPdUK2qc2jLxs6X/lHPhiOW+093tRMntXEqJ3GZQSXbZ1ZwmDEMtC5+aYsC
         31vm/4FBXQEJBPivt4Yd9j8j0ZH9BJMD1qkmCOE5nvaw3ci7g6oc/Qw6T8xLB8fpqGln
         2pcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CASC8qHfi6FSsKB7UllTORAfQ+O2NNzwp78HdWbLEwg=;
        b=AmFO8PZ2FfK+KdQneL3g6CHw/qiHK1VAMwQ6Ll83etEXX/P71EjgDF4vl1+RH0i1Z+
         wivoTyXz0r+4EOUFR9bOqIGUDAeJPSsQLYxa4l50cngDkT3fM2GFp7WLVp0AL2L+5AD6
         /1Iwlr4bnbynPp1t0X2TUkVeqrgyt6HYQK/uo7Nj4bDGRfVj5F+b0Gg82B3vBHF976m6
         Z5NSQdVplDvjhj4uqLQShffD+aVjxvXiS/XO7wePeFGj3T2q5wX0IjWo8RAuRK0BHg2F
         DHQWLzPlCnY0OzYwiyY8zjQjQ30IBUbKlDdOrmpXHzT8yWIP3T2atinIIanxi64Vc5S5
         0qoA==
X-Gm-Message-State: AFqh2kqiD49gdT2Mt0mk8uDT5GQ/Q5kYB1cb5/urHk6zgyMrQBj6ou50
        7r6FkWRrJGb5lj35tY6lpUE=
X-Google-Smtp-Source: AMrXdXuE7Zq9NVXL13vqsoSzxrZPf476ni0f0ILRmTiVHpqJZf1ZPxJbRyT64+Z8KzRnVGHS6GddmA==
X-Received: by 2002:a05:6402:4305:b0:49b:4711:f4b4 with SMTP id m5-20020a056402430500b0049b4711f4b4mr47470164edc.0.1674772335876;
        Thu, 26 Jan 2023 14:32:15 -0800 (PST)
Received: from skbuf ([188.27.185.224])
        by smtp.gmail.com with ESMTPSA id j8-20020a05640211c800b0048ebe118a46sm1356735edw.77.2023.01.26.14.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 14:32:15 -0800 (PST)
Date:   Fri, 27 Jan 2023 00:32:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next] netlink: provide an ability to set default
 extack message
Message-ID: <20230126223213.riq6i2gdztwuinwi@skbuf>
References: <2919eb55e2e9b92265a3ba600afc8137a901ae5f.1674760340.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2919eb55e2e9b92265a3ba600afc8137a901ae5f.1674760340.git.leon@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 09:15:03PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> In netdev common pattern, xxtack pointer is forwarded to the drivers
                            ~~~~~~
                            extack

> to be filled with error message. However, the caller can easily
> overwrite the filled message.
> 
> Instead of adding multiple "if (!extack->_msg)" checks before any
> NL_SET_ERR_MSG() call, which appears after call to the driver, let's
> add this check to common code.
> 
> [1] https://lore.kernel.org/all/Y9Irgrgf3uxOjwUm@unreal
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---

I would somewhat prefer not doing this, and instead introducing a new
NL_SET_ERR_MSG_WEAK() of sorts.

The reason has to do with the fact that an extack is sometimes also
used to convey warnings rather than hard errors, for example right here
in net/dsa/slave.c:

	if (err == -EOPNOTSUPP) {
		if (extack && !extack->_msg)
			NL_SET_ERR_MSG_MOD(extack,
					   "Offloading not supported");
		NL_SET_ERR_MSG_MOD(extack,
				   "Offloading not supported");
		err = 0;
	}

Imagine (not the case here) that below such a "warning extack" lies
something like this:

	if (arg > range) {
		NL_SET_ERR_MSG_MOD(extack, "Argument outside expected range");
		return -ERANGE;
	}

What you'll get is:

Error: Offloading not supported (error code -ERANGE).

whereas before, we relied on any NL_SET_ERR_MSG_MOD() call to overwrite
the "warning" extack, and that to only be shown on error code 0.

Also, if we make this change this way, there's no going back (just like
there's no going back from kfree(NULL), rtnl_lock() and others).
