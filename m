Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CBD584300
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbiG1PX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiG1PXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:23:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442FF61B0C;
        Thu, 28 Jul 2022 08:23:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79679B8248C;
        Thu, 28 Jul 2022 15:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96B1C433C1;
        Thu, 28 Jul 2022 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659021831;
        bh=0hhABROJReg1rrWg4K/jP9yLbgvWogyJo+5SUx6dOo8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ATvISLUXENUsFt/tUzzSdmivFILNgad9AuZUJgvCsGvmz6hgsxnP02vWUIyQvYUBO
         UObN4hQfktdD4DiwR+sCL+me24agDRVIFwk3CulLpBXVG7BmzrKQmeRLfAUEVEnopw
         cm64iUF6BaN4tyB1xSSJTptliTjnnbBJHxm3+cUoT/E6a+iTcKWOu/CQFvHa/+Chxe
         /o2/PWHvXJrV+aZVFj829aQh1f57PIqJpN2KE1RGnyUO6ddt++I1IRLblpjRV747No
         4x220HtVDjtnBsYa5RzGvcnOZKJ4Z0aoTIOM/UuJ8XH+FOkLnv7k9PTz11gEoDDUe0
         f7WHSyalcX1ig==
Date:   Thu, 28 Jul 2022 08:23:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next V3 1/3] sched/topology: Add NUMA-based CPUs
 spread API
Message-ID: <20220728082349.2ba6deae@kernel.org>
In-Reply-To: <20220719162339.23865-2-tariqt@nvidia.com>
References: <20220719162339.23865-1-tariqt@nvidia.com>
        <20220719162339.23865-2-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022 19:23:37 +0300 Tariq Toukan wrote:
> +static inline void sched_cpus_set_spread(int node, u16 *cpus, int ncpus)
> +{
> +}

I was going to poke Peter again, but before doing that - shouldn't we
memset() the cpus here? Just to keep the semantics that the array is
always initialized?
