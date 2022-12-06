Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBBE643AFB
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 02:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiLFBxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 20:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiLFBxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 20:53:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B7012D27;
        Mon,  5 Dec 2022 17:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45CC5B81607;
        Tue,  6 Dec 2022 01:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688BCC433C1;
        Tue,  6 Dec 2022 01:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670291595;
        bh=TIB5iMFzg1Fkwmj5kErQ7nK2t9syks3lxxOR/v9EbxA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n2znrPlavG0M+tdsb/fC8mvZ1EfWMA/q8H3YB3FryOejbNuNQ+T7r7WWbgTZhGPp4
         1Y9T7sjQbQZpanF+NHIUc5h3K85xt/bstXrTd7Gv1plHwQK1T0Sou/PBVJRCBoGIC2
         02gb0HgoSAvPKjI39MwISyAtwvr936lYJDjDIAFZRZ3vn91n4OWh7D/hLZaxIndi+u
         kkKUxgGhTjMGYvsjeWT4z61dU56QnSzMDH+DpOaeCGbfCaFuibkv5NJQyrX8tGObNC
         A5k2sc+dV9mT5QemKfvynSwDVwqhVsyVaEHuQ9rhFty/nu6PxyVVsMS/U4eaaQvh3I
         PJQJyR+aLqkfg==
Date:   Mon, 5 Dec 2022 17:53:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yang.yang29@zte.com.cn>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <kuniyu@amazon.com>, <petrm@nvidia.com>, <liu3101@purdue.edu>,
        <wujianguo@chinatelecom.cn>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH linux-next] net: record times of netdev_budget exhausted
Message-ID: <20221205175314.0487527a@kernel.org>
In-Reply-To: <202212031612057505056@zte.com.cn>
References: <202212031612057505056@zte.com.cn>
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

On Sat, 3 Dec 2022 16:12:05 +0800 (CST) yang.yang29@zte.com.cn wrote:
> A long time ago time_squeeze was used to only record netdev_budget
> exhausted[1]. Then we added netdev_budget_usecs to enable softirq
> tuning[2]. And when polling elapsed netdev_budget_usecs, it's also
> record by time_squeeze.
> For tuning netdev_budget and netdev_budget_usecs respectively, we'd
> better distinguish netdev_budget exhausted from netdev_budget_usecs
> elapsed, so add a new recorder to record netdev_budget exhausted.

You're tuning netdev_budget and netdev_budget_usecs ?
You need to say more because I haven't seen anyone do that before.

time_squeeze is extremely noisy and annoyingly useless,
we need to understand exactly what you're doing before
we accept any changes to this core piece of code.
