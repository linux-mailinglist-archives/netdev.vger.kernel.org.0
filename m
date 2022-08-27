Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CC85A33DA
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbiH0Ck5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiH0Ck5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:40:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6866A2182A;
        Fri, 26 Aug 2022 19:40:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15422B83390;
        Sat, 27 Aug 2022 02:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F775C43470;
        Sat, 27 Aug 2022 02:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661568053;
        bh=gW+EVdebQkvJRGGhWrUKteUychBX0QjK459mR3jEJwU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uVgmLgG3a6xAdgVmue1SY553R2KC8n0CKN8emJx5Q8Wjh9/WQCifc37JAvlj9wOTA
         QhVuNQAqq7ZRDbKU93N54Y4KHS2gzRwbfi89YbC3moB3IPbURRQtj+gFA1qeowsIkD
         cvG9V3DSqESfIrYaYN9QGwAZayl2ifNc5zEPyWh3LO3qffmQoMeVkmEo+ZlPNlwU2R
         uvOx4opCUxNDe464f6kND+RU3HleJTJ3a/ZhhJ5awQvze9APriNr/j7Asv4UeMNh6+
         b2IVbp5im4cjlOv8cp0BEhjTzFsk6LGJgjq9qf9oH0jm7XxipmGYfBtl5Bcg/66dLz
         4TKxyo49wzfnQ==
Date:   Fri, 26 Aug 2022 19:40:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH net-next 0/3] net: sched: add other statistics when
 calling qdisc_drop()
Message-ID: <20220826194052.7978b101@kernel.org>
In-Reply-To: <20220825032943.34778-1-shaozhengchao@huawei.com>
References: <20220825032943.34778-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 11:29:40 +0800 Zhengchao Shao wrote:
> According to the description, "other" should be added when calling
> qdisc_drop() to discard packets.

The fact that an old copy & pasted comment says something is not 
in itself a sufficient justification to make code changes.

qdisc_drop() already counts drops, duplicating the same information 
in another place seems like a waste of CPU cycles.
