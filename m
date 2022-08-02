Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B18A587FAA
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 18:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiHBQFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 12:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiHBQFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 12:05:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E6026D;
        Tue,  2 Aug 2022 09:05:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 817C160C3E;
        Tue,  2 Aug 2022 16:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D091C433C1;
        Tue,  2 Aug 2022 16:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659456305;
        bh=GHAgcZ96JxHC6yhJU2CpSSgMIhMBl+A51ww4q3KpNJw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JRVrwOozvCj1wHy5ejf2rEKmp9+A2MsJplaIqZbotUIgpu6+yFu1wlfmDXRDNMJSJ
         yedCSDc83Nyi3IJoC804dMw3LtMhcJZhNVXB4wBDtm0/gakhOPEc/kUjpjDEAF1O5y
         meytAoENsaAga6nfBIi0eMkTRCRNRD7Qcju7TdlrpO74nt8NJoqVskTQuHu42jjzAg
         gpMOE5Srx8aRBqHC6MMnGbxyHnJuo1RuotdLrV6KgTvbQCjNeSlQj4ukF5A94vRLhi
         KxOVWVdDBnBhtbR3JjeZolky+6MaqexbvDgBnqQaHEtfzIumgmK64jQQf9jsGAN8PA
         kj2265zGng3zg==
Date:   Tue, 2 Aug 2022 09:05:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ben Segall <bsegall@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>, linux-kernel@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next V4 1/3] sched/topology: Add NUMA-based CPUs
 spread API
Message-ID: <20220802090504.23bc6ef8@kernel.org>
In-Reply-To: <xhsmhpmhjc7en.mognet@vschneid.remote.csb>
References: <20220728191203.4055-1-tariqt@nvidia.com>
        <20220728191203.4055-2-tariqt@nvidia.com>
        <7f1ab968-cc10-f0a7-cac8-63dd60021493@gmail.com>
        <9401f754-d4d6-9fbd-7354-3103ececddda@gmail.com>
        <xhsmhpmhjc7en.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 02 Aug 2022 10:38:08 +0100 Valentin Schneider wrote:
> It's not even been a week since you submitted v4 (and ~3 days since you
> last pinged this thread), and not all of us are limitless reviewing
> machines :-)
> 
> This is already in my todo-list, but isn't the topmost item yet.

I'd appreciate a review on this one soonish (as a favor, don't read this
as a passive aggressive reprimand).

Tariq got a review on a trivial export patch, which put all the logic 
in the driver instead, rather promptly. I asked them to go the extra
mile and move the code to the core so other drivers can benefit.

If this doesn't get into 6.0 it'll be a clear sign for driver
maintainers that building shared infrastructure is arduous and should
be avoided at all cost :(
