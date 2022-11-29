Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B83863B8B5
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 04:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235336AbiK2DZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 22:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235304AbiK2DZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 22:25:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBAE4490B7
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 19:25:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 701E16153C
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 03:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7658AC433D6;
        Tue, 29 Nov 2022 03:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669692318;
        bh=60DUggiKxDrIpuGHSsvvJQ7i0/xnfEEmQnYxm7nPGd0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bfnPrsSg3ewjBcmh3guJ7/J097PMhpIn1YVbVCGMhziga/d5ITojMPSunXcLXSo1J
         dHJzuYaRjwb1+OfzwdAgDQxFiwL8F8MnsPFN348pmTPBKVmLzkyh40FZttBScUssbv
         hRmmwkmvY6SsZGlfB9Y0dGnEF/3OclQ43eZuorq0A4NQnA0PSp90j164ndjQPk6YSH
         c4QfoigSF9qpbfq1HPVrT1HcaoxNQGKI0dykAYRfRWsi0VEZ/9cggN9j8niJWY0Fuk
         dzdWyCU7NKEhZqm2dB5YZxpiyEEa6EUCR/0rm2b76sjPqWdi2m3Wysr74iGa2FNT3c
         Lpz2JBa7QTmaA==
Date:   Mon, 28 Nov 2022 19:25:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH v4 net-next 7/8] hsr: Use a single struct for self_node.
Message-ID: <20221128192517.193e9751@kernel.org>
In-Reply-To: <20221125165610.3802446-8-bigeasy@linutronix.de>
References: <20221125165610.3802446-1-bigeasy@linutronix.de>
        <20221125165610.3802446-8-bigeasy@linutronix.de>
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

On Fri, 25 Nov 2022 17:56:09 +0100 Sebastian Andrzej Siewior wrote:
> -	struct list_head	self_node_db;	/* MACs of slaves */
> +	struct hsr_self_node	*self_node;	/* MACs of slaves */

sparse bemoans the lack of __rcu on this pointer.
