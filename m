Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E7B645B57
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiLGNtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiLGNtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:49:09 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5998459172
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:49:07 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id h10so18626857wrx.3
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 05:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tRTj61xq+fuRuVAq7oIDPfzk5DmzmrPyPexpXKwtIXs=;
        b=iJmRWbn3uQKs24QE90Jqdfhg6+penJoj2yy2o4lag7fbvgbicO85AtdCOFfbaWlr8Z
         SA2b32pq75jILdQOWWExxCjqYpXCwZSFsmYRLxwvEJGFVScCRQQ299zwbupmQ+paRcfe
         1H3uHNUdJzTTKTCYHIAwMCKJ9q7vCV4L9mRZQsScdPVb+I+UcdkiCgxTkv4v/KX6CMgZ
         b2Nlu1I2Zp/zETcMdUBxx3SD/HM9MnW7Z4ZzLbYZaWCxGhrkx6buiGAFGE23mH7m2VN4
         jVCcxyEZjnabLgsdQWt50cO7SsXTeGoKwbYI9wNqMZocmqYjGbVhzodFzfGtwOIMTHmD
         wb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tRTj61xq+fuRuVAq7oIDPfzk5DmzmrPyPexpXKwtIXs=;
        b=225BEZLh7Bnr8y+F9ZuitEgRaJhjGB5bQkDBYLUG6xhpNFknqEdLxoPA2m2kERRJXY
         5k5xKAuF48TGxj+Hhw9ogr/t7BQq713zOI8kUlsfjr0Gocd6gKCiMrIdmbmMZxp7i78e
         uvZbqk2mfpOOiVCcg/MVLkVZHwokcY0i1U9FkY0Bkhdn23Z6e1FbA5fV/3zj0vVx7QVX
         YIED8IkSK2bcPZhDMJJGMjmWLzJk7AkC+oSc1hfRB/6dErc01EyJPLpNaSzh7gkwDJGq
         xxng/H9JyqNEzxPIsyP5aMuZOXjiJ/UdcrSVqOJPG7/IXHpEXgzcg/Pwfq2NeN/nmGAN
         rBJQ==
X-Gm-Message-State: ANoB5plTs7fQNsCpjxJWpzLr1Y00PC7ZbavVdMtnIXY+bUJL52aRENQ5
        pjqTWL8cfMUgA74kqDaw7n+ooA==
X-Google-Smtp-Source: AA0mqf45phxhL+pnFYTGpZCCc34nEyIr/bmUllCKhDOCQoKg891Al6NMIG1WMSSYBZeECw5egqdDvg==
X-Received: by 2002:a05:6000:504:b0:236:55dc:b86b with SMTP id a4-20020a056000050400b0023655dcb86bmr42308384wrf.708.1670420945959;
        Wed, 07 Dec 2022 05:49:05 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d2-20020a5d4f82000000b002425dc49024sm9399520wru.43.2022.12.07.05.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:49:05 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:49:04 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, michael.jamet@intel.com,
        mika.westerberg@linux.intel.com, YehezkelShB@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net v3] net: thunderbolt: fix memory leak in tbnet_open()
Message-ID: <Y5CZ0O/CC748/YxE@nanopsycho>
References: <20221207015001.1755826-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207015001.1755826-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 02:50:01AM CET, shaozhengchao@huawei.com wrote:
>When tb_ring_alloc_rx() failed in tbnet_open(), ida that allocated in
>tb_xdomain_alloc_out_hopid() is not released. Add
>tb_xdomain_release_out_hopid() to the error path to release ida.
>
>Fixes: 180b0689425c ("thunderbolt: Allow multiple DMA tunnels over a single XDomain connection")
>Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
