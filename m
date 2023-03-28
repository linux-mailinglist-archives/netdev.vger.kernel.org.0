Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567266CB9B9
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 10:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjC1IqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 04:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjC1IqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 04:46:03 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8374EE7;
        Tue, 28 Mar 2023 01:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q3lb5YS+GhFIWVJLPbd636ctIGN0ZCi+MsHHeLITikQ=; b=LbYS2EuL+c/zVuV+toTowelL8n
        PDjQ6qw/wR4EnGXyjjaAOqAQAMJ8AqAHVHATYuGOBiaGAdQr42RDFXuM8k7oU2wq+XL0BJH4jzxDL
        +VTgOoRmSo3xfE27i0YzJGLMp3DgRsob6trPCmBuMtKV7BKq0Cqc+VyqPsPWwaBl5CoEy/5CANuza
        w5tLHNDEGvZ+0ovBi/XlTIoiC6JdzD7GzarIbRUSPgrNbz20+z+mUsr1/9gOVLyAQj9QqptwT7lRL
        du38XY0VlosEgOpn7/98DRmtBdhWmH0eXMqiCNrV4c15FyYI6fr3CzD8sZOEnvJi7TicvJ0isF5Tx
        yo9ckwgQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1ph4xV-006W2g-08;
        Tue, 28 Mar 2023 08:45:37 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E75DE300379;
        Tue, 28 Mar 2023 10:45:34 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A1A592CB89F0E; Tue, 28 Mar 2023 10:45:34 +0200 (CEST)
Date:   Tue, 28 Mar 2023 10:45:34 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [patch V3 0/4] net, refcount: Address dst_entry reference count
 scalability issues
Message-ID: <20230328084534.GE4253@hirez.programming.kicks-ass.net>
References: <20230323102649.764958589@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323102649.764958589@linutronix.de>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



I've stuffed the two atomic patches in tip/locking/rcuref for Jakub
which I then merged into tip/locking/core.

Jakub, you should be able to merge that topic branch (rc1 based) and
stuff the network bits on top.

If anything went sideways, please holler!
