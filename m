Return-Path: <netdev+bounces-5394-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88FEC71110D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:33:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33076281645
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA1CFC15;
	Thu, 25 May 2023 16:33:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D857E3
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 16:33:51 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AFE197
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:33:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1q2DuI-0006vy-2c; Thu, 25 May 2023 18:33:42 +0200
Date: Thu, 25 May 2023 18:33:42 +0200
From: Florian Westphal <fw@strlen.de>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: fw@strlen.de, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	kuni1840@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com,
	syzbot+444ca0907e96f7c5e48b@syzkaller.appspotmail.com
Subject: Re: [PATCH v1 net] udplite: Fix NULL pointer dereference in
 __sk_mem_raise_allocated().
Message-ID: <20230525163342.GB25057@breakpoint.cc>
References: <20230525151842.GA13172@breakpoint.cc>
 <20230525162137.93121-1-kuniyu@amazon.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525162137.93121-1-kuniyu@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> > I'd remove it in -next.  Same for DCCP.
> 
> Ok, I'll do for UDP Lite.

Thanks.

> +1 for DCCP, but we know there are real?
> still experimenting? users ... ?

Yes, and they can continue to work on their out of tree fork
and research projects, no problem.

I'd say next time some net/core change needs dccp changes,
remove dccp first (or mark it as CONFIG_BROKEN) so it doesn't
cause extra work.

DCCP can be brought back when someone has interest to maintain it.

Looking at DCCP patches its either:
1. odd syzbot fixes
2. api changes in net that need folloup changes in dccp
3. automated transformations

There is no sign that anyone is maintaining this (or running it
in a production environment...).

