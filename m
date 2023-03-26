Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B3C6C950E
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjCZONY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbjCZONX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:13:23 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2963D6594;
        Sun, 26 Mar 2023 07:13:01 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-536af432ee5so124748477b3.0;
        Sun, 26 Mar 2023 07:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679839980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/ZRzhYebH5AuIeB7bCMisoF/7Z4hpl9JqnpdyGD997I=;
        b=ZxMwBqJ4K91caHcs8I1GmJtIU5/4ql8PImbJO0a5VKl4O6P01XEgriE9RMYizH4LWH
         8bJ/w8IWcYGjjvVpEk+vYXdRLvspD64kJHc1YZB16cZpKCm/+Dh0QYbjtMdDnEP1Yr+G
         pP1dGRPz8q0UxYRLAzKMLbCgAh6CHrmxobupRVm1f0MMl6+ldXZmpScpo3P5VYiE8C1P
         WLu3N+7OkU0MoNfptZz8FDhXrswr4Mv/XlcFJNQvwQSomAY4QxLYTImwQxZPKS9x8FJZ
         DMSL7Z0bpIhiQYwnUVT04NLgTZNIV/tIpjJ67Vfg68uE59gUw6+Y3AjOVNPxDD+zV8UZ
         L9kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679839980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ZRzhYebH5AuIeB7bCMisoF/7Z4hpl9JqnpdyGD997I=;
        b=I0ddbN/xoowmnLyUDOPAOHsvpIx69wFwyr+qstd01qP7NN8tbBAuC0WZqcleSpitBx
         IF94oSbYsxVcTo6gZ7dpqXTo9K4fwY8b2zSDRRiGeNCnaEMA7tnPmAxelQ93lHwztM9P
         Goneh7ZsEwuF+jDuxcHhZI+oU5/jEp5HkMXUB2DbZRwJMTgvIlYYz6+f/euZ/28L6Kuu
         mkyNXB7FIKnLEVxGFFx0c3xSyhkAdAEPqR6yJjLTY3Ksl0Wlm4Qr6vbayzifnpzDBrg7
         zLp3yfeA+lxm6xuNCp6ocoyjGiH7iLctAoICr+/PoGp8crshf03L6coPe/tjheNv2VsU
         +kBQ==
X-Gm-Message-State: AAQBX9e4n0sWjFu+N03ubEuSztreJKOvZ5cLPI+Fere5kXJsQFJV9Dc0
        KEo4aRdR+PswMboTXz0RgA8=
X-Google-Smtp-Source: AKy350ZrhENhMTDQOcDtvcs6PwUpixFN3qSHh1ALf+Jr+ZdkI91IYsO59P6n6/a8qTfuUBHtvrMAVw==
X-Received: by 2002:a81:49c1:0:b0:544:5c0b:1326 with SMTP id w184-20020a8149c1000000b005445c0b1326mr8853795ywa.18.1679839980260;
        Sun, 26 Mar 2023 07:13:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k10-20020a81ed0a000000b00545a0818486sm1467096ywm.22.2023.03.26.07.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 07:12:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sun, 26 Mar 2023 07:12:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        davejwatson@fb.com, aviadye@mellanox.com, ilyal@mellanox.com,
        fw@strlen.de, sd@queasysnail.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: tls: fix possible race condition between
 do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Message-ID: <fdfa0099-481c-48d6-8ab8-0c84b260e451@roeck-us.net>
References: <20230228023344.9623-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228023344.9623-1-hbh25y@gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Feb 28, 2023 at 10:33:44AM +0800, Hangyu Hua wrote:
> ctx->crypto_send.info is not protected by lock_sock in
> do_tls_getsockopt_conf(). A race condition between do_tls_getsockopt_conf()
> and do_tls_setsockopt_conf() can cause a NULL point dereference or
> use-after-free read when memcpy.
> 
> Please check the following link for pre-information:
>  https://lore.kernel.org/all/Y/ht6gQL+u6fj3dG@hog/
> 
> Fixes: 3c4d7559159b ("tls: kernel TLS support")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>

This patch has been applied to v6.1.y. Should it be applied to older kernel
branches as well ? I know it doesn't apply cleanly, but the conflicts
should be easy to resolve. I'll be happy to send backports to stable@ if
needed.

Thanks,
Guenter
