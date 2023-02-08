Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B77468FB14
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 00:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjBHXVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 18:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjBHXVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 18:21:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369EDF759;
        Wed,  8 Feb 2023 15:21:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C21E461806;
        Wed,  8 Feb 2023 23:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23883C4339B;
        Wed,  8 Feb 2023 23:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675898468;
        bh=V8fWl/k6mey3hU7Kqp91TSyMc8cvo2RhUVtz0LJkIdI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qlOmPt6WxLO7e0aXkEJdpkGU5Mfkyc1WFOse11zKkBG1ETdcWpUhgIlOgQS29PtG0
         uV3fXyJ6Ar6KuVZKrpUojc4Sui8jtrpEnLwMQXjf0/BvfaYyTZW/6Zls91CM1m+SJt
         x2y49azNhPt+1IGxnbhqo6+wv1ROjVn2WKgPBvSU3OWYws6OrODR1b4euvUpMkYC8P
         QzJFuOqK3EpnhKa+8dW3/OeWMny35KttkVlj8g+uquNkaO/NczNYYscEC3vnbCME8w
         d3hJYkSyvCyg/EI4Fd4l9THJvWAhdLkcGpSzfU1JMViG6MnYZ5+p8IrWKQkTsX4evT
         eTFCcaurwqOtA==
Date:   Wed, 8 Feb 2023 15:21:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pawel Chmielewski <pawel.chmielewski@intel.com>
Cc:     yury.norov@gmail.com, Jonathan.Cameron@huawei.com,
        andriy.shevchenko@linux.intel.com, baohua@kernel.org,
        bristot@redhat.com, bsegall@google.com, davem@davemloft.net,
        dietmar.eggemann@arm.com, gal@nvidia.com,
        gregkh@linuxfoundation.org, hca@linux.ibm.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        jgg@nvidia.com, juri.lelli@redhat.com, leonro@nvidia.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux@rasmusvillemoes.dk,
        mgorman@suse.de, mingo@redhat.com, netdev@vger.kernel.org,
        peter@n8pjl.ca, peterz@infradead.org, rostedt@goodmis.org,
        saeedm@nvidia.com, tariqt@nvidia.com, tony.luck@intel.com,
        torvalds@linux-foundation.org, ttoukan.linux@gmail.com,
        vincent.guittot@linaro.org, vschneid@redhat.com
Subject: Re: [PATCH 1/1] ice: Change assigning method of the CPU affinity
 masks
Message-ID: <20230208152106.09e5ad83@kernel.org>
In-Reply-To: <20230208153905.109912-1-pawel.chmielewski@intel.com>
References: <20230121042436.2661843-1-yury.norov@gmail.com>
        <20230208153905.109912-1-pawel.chmielewski@intel.com>
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

On Wed,  8 Feb 2023 16:39:05 +0100 Pawel Chmielewski wrote:
> With the introduction of sched_numa_hop_mask() and
> for_each_numa_hop_mask(), the affinity masks for queue vectors can be
> conveniently set by preferring the CPUs that are closest to the NUMA node
> of the parent PCI device.

Damn, you had this one locked and ready, didn't you.. :)
