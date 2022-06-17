Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB78A54FB35
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 18:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383427AbiFQQj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 12:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383422AbiFQQj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 12:39:26 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE430427D5
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 09:39:25 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id cv13so2039176pjb.4
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 09:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=h6IrLdY6w4OsypWEzzKKv5b850fPgk5gwMN7Tf3l3vQ=;
        b=cGB9S6qXHZUmmKqLb8Czce7aQQ31G8cciRGY3uS9OqZ2KLHawZOjaiA/UhIeiPKRoQ
         RGuqtkjn3l21zbzDcWWuJPd0THw5jwa7NmutFVEycllAOF3tWpkr/85h2O2wCLkiuLFw
         8N+27G96xzt/eUHx0kvvnLRlNMnhPTX+o7qiAHUN7skj0o/o0ZlnsCy7YjPfQp37Ly3L
         3DHUV3EqAvFn4BVzjqNIkCCIOAJ3Mmd1LEB5SVxYqSMvp87RZlon0Wxd+CymmWt6tIn9
         vNMFfo2Z+LtXNL6Yc6HoJcu2P+UwgmfKDfQlpdHrykmwYAPkaV+JwMzziTavYhEc7RlI
         pz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=h6IrLdY6w4OsypWEzzKKv5b850fPgk5gwMN7Tf3l3vQ=;
        b=CGSF8/F/ubGcEeat41LOv02jh1HjYyJrUYyhP52k6EXzk1fygb84E0Sc/CQYuEy7rK
         eTTOaI0F1OTaDNMkd8N0VlOekF+U/vFnRzEphUs1aoCHSZTr665mbzH4z2vuXBdA4Q6n
         Vq6SAuaZ4moVyXgA4sW2IpYzFPznk/L9sl9m8gx9W6d9wjNUKG8oyHq8vUIqf8uLNInI
         QrkP9q1uehRTe8MXEWDLXIF8WG1BCIIUbyyDqBHwLIq0yQ41UNu4qMzAnzdaT9VmH/UF
         gtNrHFDOKhm95VuAJjL04ADVtfll92EGnds8JpIeaeRlPX/DGXyNWQ+v+5u0qd5qYCxT
         bkTA==
X-Gm-Message-State: AJIora/hNmUZ7HXz7H80zfJz3tVOGfW7vqtjuydds3cA1Sl+xq0fStuT
        ZzoO5+bFxn6kwrY5HK5hwZpQ9A==
X-Google-Smtp-Source: AGRyM1tSNcsBlD5rmWFBnXmaOQSTZiEb3QWszdo4GJLGK5UOx6thlgdZtHfv+x5h3/bswUKYS8BMdQ==
X-Received: by 2002:a17:90b:1b07:b0:1e8:41d8:fa2 with SMTP id nu7-20020a17090b1b0700b001e841d80fa2mr11466844pjb.204.1655483965098;
        Fri, 17 Jun 2022 09:39:25 -0700 (PDT)
Received: from google.com (201.59.83.34.bc.googleusercontent.com. [34.83.59.201])
        by smtp.gmail.com with ESMTPSA id o12-20020a62f90c000000b0051be16492basm3934309pfh.195.2022.06.17.09.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 09:39:24 -0700 (PDT)
Date:   Fri, 17 Jun 2022 16:39:21 +0000
From:   Carlos Llamas <cmllamas@google.com>
To:     Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Miaohe Lin <linmiaohe@huawei.com>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Subject: Re: [PATCH v2] ipv4: ping: fix bind address validity check
Message-ID: <YqyuOfvR4mesRTfe@google.com>
References: <20220617085435.193319-1-pbl@bestov.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220617085435.193319-1-pbl@bestov.io>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 10:54:35AM +0200, Riccardo Paolo Bestetti wrote:
> Commit 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
> introduced a helper function to fold duplicated validity checks of bind
> addresses into inet_addr_valid_or_nonlocal(). However, this caused an
> unintended regression in ping_check_bind_addr(), which previously would
> reject binding to multicast and broadcast addresses, but now these are
> both incorrectly allowed as reported in [1].
> 
> This patch restores the original check. A simple reordering is done to
> improve readability and make it evident that multicast and broadcast
> addresses should not be allowed. Also, add an early exit for INADDR_ANY
> which replaces lost behavior added by commit 0ce779a9f501 ("net: Avoid
> unnecessary inet_addr_type() call when addr is INADDR_ANY").
> 
> Furthermore, this patch introduces regression selftests to catch these
> specific cases.
> 
> [1] https://lore.kernel.org/netdev/CANP3RGdkAcDyAZoT1h8Gtuu0saq+eOrrTiWbxnOs+5zn+cpyKg@mail.gmail.com/
> 
> Fixes: 8ff978b8b222 ("ipv4/raw: support binding to nonlocal addresses")
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Reported-by: Maciej Żenczykowski <maze@google.com>
> Signed-off-by: Carlos Llamas <cmllamas@google.com>
> Signed-off-by: Riccardo Paolo Bestetti <pbl@bestov.io>
> ---
> This patch is sent as a follow-up to the discussion on the v1 by Carlos
> Llamas.
> 
> Original thread:
> https://lore.kernel.org/netdev/20220617020213.1881452-1-cmllamas@google.com/
> 

Reviewed-by: Carlos Llamas <cmllamas@google.com>

Thanks Riccardo for adding the test cases. I would appreciate it if next
time you add a co-developed tag or maybe a separate commit as opposed to
overriding the original author. This is fine though.

--
Carlos Llamas
