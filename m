Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DCB651E57
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 11:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiLTKFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 05:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbiLTKE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 05:04:57 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CB918B1F;
        Tue, 20 Dec 2022 02:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wFmQ7lRJi3uyaPcaAHBI+uNPG9r+91kEtiS0MtrW62Q=; b=ScnmtR6fKw0ny50Sd65lB+3C84
        RcMtR5j+YKw3plF+WWUHvXhSVAXY5LxHFvM0YlSZbBCVC/+3kMn7+3uZz7Dzb9r416KpywdWCJxsj
        Z9H6qgrAJG9oHh5mOccz4OIiPzm44i/mCbGJ8xJe4rGCkqSSLQvJqzyUjQW70Zz0pKnrNz6SiHj6R
        FWObk0Ihgn1D4KJnB4ODt/qkjfEqJQb6ysAtNBqjY8Ju1EBQUAsUuD0zcdbs4bVdWBVjEBfgr+ewU
        pHbjD5kkxQ6KwLEhhCGqDeA+D2v1oTEHMHzextFn2WtLNtH9JBBNZU8KJYOYFOcnFHvYgBKMNXPOs
        TyODiHQA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p7ZU6-00CxAQ-2C;
        Tue, 20 Dec 2022 10:04:30 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EF9CE3000DD;
        Tue, 20 Dec 2022 11:04:30 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B82CA200A4AD7; Tue, 20 Dec 2022 11:04:30 +0100 (CET)
Date:   Tue, 20 Dec 2022 11:04:30 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     syzbot <syzbot+b8e8c01c8ade4fe6e48f@syzkaller.appspotmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] KASAN: use-after-free Read in put_pmu_ctx
Message-ID: <Y6GIrqpDU331TTeB@hirez.programming.kicks-ass.net>
References: <Y6Fxfw5fhHhQYaSd@hirez.programming.kicks-ass.net>
 <000000000000de0f0b05f03e6d9b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000de0f0b05f03e6d9b@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 12:43:25AM -0800, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> INFO: rcu detected stall in corrupted
> 
> rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P5791 } 2673 jiffies s: 2805 root: 0x0/T
> rcu: blocking rcu_node structures (internal RCU debug):

That is an entirely different issue methinks. Let me go write up a
Changelog for that thing and stuff it somewhere /urgent.
