Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983AA643AFF
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 02:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbiLFByE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 20:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbiLFByA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 20:54:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE672222B5;
        Mon,  5 Dec 2022 17:53:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A5466134A;
        Tue,  6 Dec 2022 01:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C21C4314B;
        Tue,  6 Dec 2022 01:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670291635;
        bh=DDQbi+KJQ7V2lMrD4+CR/trAapNuSTe1zXKcQfUSM9g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EceTsQigGITun0q1kFBs2rFcrAcvGTX/K3M8dONSjj9SCTqE3ewwA8xmKPPrHRKTx
         UwSfmzd/lcHrEkxf3T/j9JPsE5Iy3rZv+GJdBFh8b0u+/hbC4zfJ5qs/HWbEXS0jWC
         BYNenZueBCoRFDIygpTMV/AcfPgAX6rrEcIBzXJ5Ubly8txEXjdnGVrFzcNg7wZVc8
         Dm9T3e6fROT941qNLGWHdaZfhkYVR6Bcj74HajgVP6Wu0l0SMLi7N+850RghhWrNX+
         soIz5PjD3CZ5jcR37Di/8xeQBB9whGg71sKcBfdRXNueqV9o3LS6Njo9PlVwElOqw3
         IJ/Z+JnPUgMwg==
Date:   Mon, 5 Dec 2022 17:53:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yang.yang29@zte.com.cn>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <kuniyu@amazon.com>, <petrm@nvidia.com>, <liu3101@purdue.edu>,
        <wujianguo@chinatelecom.cn>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH linux-next v2] net: record times of netdev_budget
 exhausted
Message-ID: <20221205175354.3949c6bb@kernel.org>
In-Reply-To: <202212050936120314474@zte.com.cn>
References: <202212050936120314474@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Dec 2022 09:36:12 +0800 (CST) yang.yang29@zte.com.cn wrote:
> A long time ago time_squeeze was used to only record netdev_budget
> exhausted[1]. Then we added netdev_budget_usecs to enable softirq
> tuning[2]. And when polling elapsed netdev_budget_usecs, it's also
> record by time_squeeze.
> For tuning netdev_budget and netdev_budget_usecs respectively, we'd
> better distinguish from netdev_budget exhausted and netdev_budget_usecs
> elapsed, so add budget_exhaust to record netdev_budget exhausted.
> 
> [1] commit 1da177e4c3f4("Linux-2.6.12-rc2")
> [2] commit 7acf8a1e8a28("Replace 2 jiffies with sysctl netdev_budget_usecs to enable softirq tuning")

Same comments as on v1.
