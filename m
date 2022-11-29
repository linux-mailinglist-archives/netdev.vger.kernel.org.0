Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D62C63BFC9
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 13:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbiK2MLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 07:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiK2MK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 07:10:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDE52AA;
        Tue, 29 Nov 2022 04:10:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 149A2616E7;
        Tue, 29 Nov 2022 12:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5620C433C1;
        Tue, 29 Nov 2022 12:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669723854;
        bh=eK3eWs+NakxQYgxM//BYeenp/ALFDb+g86OEaVascqA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mj9ZmH+0V4LM3h58rvnCrwkPwoNhBo15JZD1/1Iz69v9Lj9WG6c/AHd+QdyoeJejU
         zIrRCRdAkXPE+zwUaCaljzQQaDnVSY6hJBzRKgF0l+odTrUClVF70Q2k3IMFHCIABA
         OKNzfNzjsjljqey3uq0OG7mGEagNWoQwXBIDKxF+56OfscLPE8vGF19ucITk7/grMY
         27rEr8kDWOnErW7KHhTC40hDmaWu0O8JMwMvZmeopHDc8cpB/AzHrDsdxX9pXG6cWH
         E+uUwAkoMZruyrBVCDkaEyq5yOGtdJHP7G9220yLf12RMS9hVVMjahnQLO8lkTkTcs
         KtdCPp0bVvB6Q==
Date:   Tue, 29 Nov 2022 13:10:51 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        fweisbec@gmail.com
Subject: Re: [PATCH v2 3/4] sched/isolation: Add HK_TYPE_WQ to isolcpus=domain
Message-ID: <20221129121051.GB1715045@lothringen>
References: <20221013184028.129486-1-leobras@redhat.com>
 <20221013184028.129486-4-leobras@redhat.com>
 <Y0kfgypRPdJYrvM3@hirez.programming.kicks-ass.net>
 <20221014132410.GA1108603@lothringen>
 <7249d33e5b3e7d63b1b2a0df2b43e7a6f2082cf9.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7249d33e5b3e7d63b1b2a0df2b43e7a6f2082cf9.camel@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 01:27:25PM -0300, Leonardo Brás wrote:
> Hello Frederic,
> 
> So, IIUC you are removing all flags composing nohz_full= parameter in favor of a
> unified NOHZ_FULL flag. 
> 
> I am very new to the code, and I am probably missing the whole picture, but I
> actually think it's a good approach to keep them split for a couple reasons:
> 1 - They are easier to understand in code (IMHO): 
> "This cpu should not do this, because it's not able to do WQ housekeeping" looks
> better than "because it's not in DOMAIN or NOHZ_FULL housekeeping"

A comment above each site may solve that.

> 
> 2 - They are simpler for using: 
> Suppose we have this function that should run at a WQ, but we want to keep them
> out of the isolated cpus. If we have the unified flags, we need to combine both
> DOMAIN and NOHZ_FULL bitmasks, and then combine it again with something like
> cpu_online_mask. It usually means allocating a new cpumask_t, and also freeing
> it afterwards.
> If we have a single WQ flag, we can avoid the allocation altogether by using
> for_each_cpu_and(), making the code much simpler.

I guess having a specific function for workqueues would arrange for it.

> 
> 3 - It makes easier to compose new isolation modes:
> In case the future requires a new isolation mode that also uses the types of
> isolation we currently have implemented, it would be much easier to just compose
> it with the current HK flags, instead of having to go through all usages and do
> a cpumask_and() there. Also, new isolation modes would make (2) worse.

Actually having a new feature merged in HK_NOHZ_FULL would make it easier to
handle as it avoids spreading cpumasks. I'm not sure I understand what you
mean.

Thanks.
