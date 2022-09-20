Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A484C5BEEE0
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 23:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiITVB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 17:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiITVBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 17:01:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4DD631A;
        Tue, 20 Sep 2022 14:01:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EA8AB82CA0;
        Tue, 20 Sep 2022 21:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8546FC433C1;
        Tue, 20 Sep 2022 21:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663707681;
        bh=hIR0tDbiJiurJ+3nIpD24XwlfVqjglmDIaa4a9tm0AM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OK/05vPEfJ4K0n5Pmv+NE7pojPUuEuiCl1UAGTOVORnTN9Mmeu6t/RVp84n+0ne34
         Csl1pCEX+oJfkhqeO9TvUgK+JcwA6Kti0gL3KVHcUcpxgnWMJJB7JxvWCpkoZtBcL9
         3MH4s6lp1wsoUtwOlrXChA9nQyNFQTLvR3IYyroKhBkXBHIFq2eJDGbmaZZLzbnCes
         MVFqpJ9QHOi6pVBAreLnQRlgCDmAB0M7Kj+tQqefv1UQaimVCvx9WXoU1BxHcgF71S
         /+D0mVGex+GTl033K3p4ca9M9ggUxCQUOvz6CpC2vBeeFgB9TbGabQMGaCggzs4wxg
         C4zseSd/9NADQ==
Date:   Tue, 20 Sep 2022 14:01:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 7/7] net/sched: taprio: replace safety
 precautions with comments
Message-ID: <20220920140119.481f74a3@kernel.org>
In-Reply-To: <20220915105046.2404072-8-vladimir.oltean@nxp.com>
References: <20220915105046.2404072-1-vladimir.oltean@nxp.com>
        <20220915105046.2404072-8-vladimir.oltean@nxp.com>
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

On Thu, 15 Sep 2022 13:50:46 +0300 Vladimir Oltean wrote:
> The WARN_ON_ONCE() checks introduced in commit 13511704f8d7 ("net:
> taprio offload: enforce qdisc to netdev queue mapping") take a small
> toll on performance, but otherwise, the conditions are never expected to
> happen. Replace them with comments, such that the information is still
> conveyed to developers.

Another option is DEBUG_NET_WARN_ON_ONCE() FWIW, you probably know..
