Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F56583B22
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 11:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbiG1JV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 05:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbiG1JVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 05:21:23 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D94624AA
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 02:21:21 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id l22so1395141wrz.7
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 02:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B/8iQHlWs0vjQZ+sNKUneP2OEaX0pNLBGiGa6LCtUI4=;
        b=C1/3FMMAH2BvFWS58gfgRtqFBVNKaaLBTxfqfYySDN7IcMwH3syMjHR5huyGIw1YQr
         qGDCCFJVTacgs6K3kEQKwTKJjBUs32ObQinmfYoPNhINltI1/vtRX3D6o6B5vh4kyOVW
         Xez78aJapxfJyuFua7nbbLqxJUi9zCe4hyxrMvaZa2kZxwEcYVDGpvWhqACjb2xS4a/F
         Mk+8aK1fzLJ68Ls6EwUscBtejprSqMgonGMKG9moqEwjS/5odVW0V3Telgjqp4hjhshg
         klvxMnsgmCYvW2bDp8GVzi/jDHifsZetu56ixX0qRMi/fJm7pxkp/rGlO3F5jJnI5mSM
         Jdnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B/8iQHlWs0vjQZ+sNKUneP2OEaX0pNLBGiGa6LCtUI4=;
        b=XGuJE6ZoVUqx3NwxDCUK22/JYr6P4yaj9k2aRIzGLao8BEjvPVlK+8qBQ8Eeu1OCmE
         pH1k93llbRqgD259VGSeEYPUQGzjNVimWA58qvZFyA7abw3kI16hqk5icxUTYIrJ9AVn
         pN9I7q3ILb2hhz3Thaz2qjwBZnpK7COIKJOQUyAE+d0iwaNJg8dKk5yvhET/NnXiTsYu
         uKPbY2l5lsjueNrPrlPKEc+Ww9X1OUoclwh9ebwgrSss0zsnbVLP9ZOyZ9xXzq/JX5S9
         23caj6pe+dQ6246DwHiajDhb0MiJbrCFTGlB0YO86KkczSNjN0whXUoulhTjerSucoAT
         zhYg==
X-Gm-Message-State: AJIora/fAPhue2RpiOlgLW8U7E76t8ji1iM6/5rZBgIU3wGMfQQ8Yomc
        ZOWrLXwmANDeG5ZQ9DwniMWQLA==
X-Google-Smtp-Source: AGRyM1tyfDgIhkc7PCmpjHzDjWvAy1wrItt9reBK5lnbz+WD2opC4AYR44lq66sUK6M00P6PBERymg==
X-Received: by 2002:a5d:55d1:0:b0:21e:cc2c:f357 with SMTP id i17-20020a5d55d1000000b0021ecc2cf357mr4603248wrw.186.1659000079493;
        Thu, 28 Jul 2022 02:21:19 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o17-20020a056000011100b0021dbaa4f38dsm529520wrx.18.2022.07.28.02.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 02:21:18 -0700 (PDT)
Date:   Thu, 28 Jul 2022 11:21:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/9] net: devlink: remove region snapshot ID
 tracking dependency on devlink->lock
Message-ID: <YuJVDSTtjyiRLeHn@nanopsycho>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
 <1658941416-74393-2-git-send-email-moshe@nvidia.com>
 <20220727185851.22ee74aa@kernel.org>
 <YuJM5UMZW7uTKDmS@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuJM5UMZW7uTKDmS@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 28, 2022 at 10:46:29AM CEST, jiri@resnulli.us wrote:
>Thu, Jul 28, 2022 at 03:58:51AM CEST, kuba@kernel.org wrote:
>>On Wed, 27 Jul 2022 20:03:28 +0300 Moshe Shemesh wrote:
>>> So resolve this by removing dependency on devlink->lock for region
>>> snapshot ID tracking by using internal xa_lock() to maintain
>>> shapshot_ids xa_array consistency.
>>
>>xa_lock() is a spin lock, right?  s/GFP_KERNEL/GFP_ATOMIC/
>
>Correct, will fix.

Well, from how I read __xa_store(), it should be ok to have GFP_KERNEL
here, but I don't think it has any benefit over GFP_ATOMIC in this
usecase, so I will change it to GFP_ATOMIC.
