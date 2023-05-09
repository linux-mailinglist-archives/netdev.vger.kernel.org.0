Return-Path: <netdev+bounces-1204-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF24E6FCA1C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:19:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5309B2812F8
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1B718008;
	Tue,  9 May 2023 15:19:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAAC17FFC
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:19:37 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C5B40DB;
	Tue,  9 May 2023 08:19:36 -0700 (PDT)
Date: Tue, 9 May 2023 17:19:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1683645574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UqejwA2SlPIA1S+P2yVF0lec7SSacjZYHG6Osl3fEK0=;
	b=XDQ+dwnbV7nZxmUwjIXs5pTmoLevO7PaY+Q4jZPMB/dTmmCx6S8z1itFDv36Od3MUAQit4
	53k6ygQanN4A6V7eJHaGS0fOuusfNV4+KhzWXN+x7etFfCgRv6hx/gAwmRoJrFMAvbUJbu
	vYj4lBPfrq1dB8/9qh4G+ExHqoRiA8SLvZ3K+Qnxdo6Eb9bbaXE/2qyrudSK+nYJq4Cf3G
	23ds3uIqGvXF5OnX4dtnYq1E10vbXtcBrfclDnxXcz1EaUl/L0s5OV3KAEFQPnhwT04vbj
	i2bvHMPrimru0nmNNYOUkfNYBajbhokBJ7t31qm1V/RBryQwTokyDGEPKe0n0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1683645574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UqejwA2SlPIA1S+P2yVF0lec7SSacjZYHG6Osl3fEK0=;
	b=HnwHBvm6HDawxNscWo2HIqrtPYCczNWcpuTexLzQbvJ7eRXpmnEwVRB+6KDwzfZnjl52OQ
	BZHo3Kcvx2voF3CA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org,
	netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] revert: "softirq: Let ksoftirqd do its job"
Message-ID: <20230509151932.0YIQkuy6@linutronix.de>
References: <57e66b364f1b6f09c9bc0316742c3b14f4ce83bd.1683526542.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <57e66b364f1b6f09c9bc0316742c3b14f4ce83bd.1683526542.git.pabeni@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023-05-08 08:17:44 [+0200], Paolo Abeni wrote:
> Due to the mentioned commit, when the ksoftirqd processes take charge
> of softirq processing, the system can experience high latencies.

Yes. RT wise I tried a lot to keep ksoftirqd from getting scheduled.
With this change, it makes the life a lot easier.

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian

