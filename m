Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C16F4AFC25
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 19:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241292AbiBISz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 13:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241094AbiBISzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 13:55:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CDDC043180
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 10:51:40 -0800 (PST)
Date:   Wed, 9 Feb 2022 19:51:37 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644432699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AMNKWXmxkqvUrLA3wTi5R8V6+U7/aSA69fbIp5TfHvg=;
        b=f/+0nYXOmJx6L+ng5pqE6tq0N32h4YmScRvKjafWpy9h8MSbzPjQIQROz2rSJJ5W22lWde
        iLSkMdS/5W0mldSc77/DK7PuZXaXb6UtzNQIVOc3zpYqC9zHWGkdkLR7eBAaT5SC1fQPFo
        aouXVjp++eOQqS+jJ2qW4Z4QmYKrFc8eoXGZzsiX707YvmWICX2tSXJMgv/JdJLAhLwV2z
        +h5bwd4d9J9x/MA+LW62TOLAXGuDEczGF7sJHbw3v3f8S2a6TN7R34XE6ghnzIQhfQYn0o
        2Y0/0TPAHriKLzqkOpecsAv07QCO7H1u+1dlsz4MH1d9dhSNXTHtFqEkk9EiQw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644432699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AMNKWXmxkqvUrLA3wTi5R8V6+U7/aSA69fbIp5TfHvg=;
        b=LliTxexLYx22iOu6ki/xXKOIgSxZOY7AW7YGoPDxkCZQS8EFFIH5LbYBs8FtUd/cF1oOry
        k2s86XlwHQq3MqBw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        eric.dumazet@gmail.com, davem@davemloft.net, dsahern@kernel.org,
        efault@gmx.de, tglx@linutronix.de, yoshfuji@linux-ipv6.org,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH net v3] tcp: Don't acquire inet_listen_hashbucket::lock
 with disabled BH.
Message-ID: <YgQNOfR4Xjfawxqn@linutronix.de>
References: <YgKh9fbQ2dcBu3e1@linutronix.de>
 <20220208170314.7fbd85c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220208170314.7fbd85c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-08 17:03:14 [-0800], Jakub Kicinski wrote:
> On Tue, 8 Feb 2022 18:01:41 +0100 Sebastian Andrzej Siewior wrote:
> >    Reposted with fixes and net-tree as requested. Please keep in mind that
> >    this only effects the PREEMPT_RT preemption model and I'm posting this
> >    as part of the merging efforts. Therefore I didn't add the Fixes: tag
> >    and used net-next as I didn't expect any -stable backports (but then
> >    Greg sometimes backports RT-only patches since "it makes the life of
> >    some folks easier" as he puts it).
> 
> It says [PATCH net] in the the subject :S  net-next makes sense.

Sure, no worries.

Sebastian
