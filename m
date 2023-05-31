Return-Path: <netdev+bounces-6934-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFFDF718D8E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 23:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C9E81C20F7A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A4E3D3BC;
	Wed, 31 May 2023 21:51:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4556C19E7C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 21:51:54 +0000 (UTC)
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4CC121
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:51:53 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 3f1490d57ef6-ba8374001abso106537276.2
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685569912; x=1688161912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+/fBKB+Tt+JMaDs0R4CL9X1S8Cw7lfUYvP6Jxt1cZiE=;
        b=zpmcpmt8i3VdPYCBJ8VclkfTqcvCFAOfRu1+9TLjnSwPEyEnTKulV65bA7Bw+5p00J
         h0NYFHNuDsDAArbR6Zk8oAzV6FjCh0R6yfJTvVfIU3on/kJmmkZZmbLCsrwsgi9/1oXX
         OyiEmK+yRG6+LGUqs6bcDHQDjTkHQGYRKJK5rx/BIsM4DbHyaFlrYf9vFowVT2jcMWxF
         CnKGUMW6HhtSw8HZdYuzROVD0Z6PPYNN3G1smed/QpAWzteVQecK8qYSCqI9dU0YwYVX
         bSzsXmmXmRz8Rimf7dAOfuNFHgh6jppfJ/MRA2kjShJqGsXWWw5EXZKFAmaGPHNdGxrJ
         2jmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685569912; x=1688161912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+/fBKB+Tt+JMaDs0R4CL9X1S8Cw7lfUYvP6Jxt1cZiE=;
        b=QAPu3zbTCpFXdPJUwjBiSmJJBtEfU4XWRShYQDrVYQ1k1eCOyQPSfz/xZhrvEr0I/e
         hDtFXsKjgg0WNcAfrXDpa2CFGQXznUsApULSvqNn+ew5qbyzD9mj5pFp63Dx/9BiBD/I
         lM/Z0oORSJz7Zgwa8loss9njOgPxypLKqqRTrWOwdJxeQ56FIPa/LyLtt/KRj+iwf21T
         vLziqusOCHk5EhlALc2FFz+7MPDDg804kyC33/ToRDGNr8UbIy4EseLDLRodRPzUXA0C
         zyNSOU2vyvyklHbY0kqaTrQ7XPO1FSkyKjMALWZ8L5I7voWnlBA4EZZDKcNvvJsZzyq1
         k6Cw==
X-Gm-Message-State: AC+VfDyvj3OMUUO6aEpguWASg/pOMyobkIDHnlLIQlzO3BppVs4Tz4zQ
	2Mv7MRzyt6bH4WLzOXnrJs7SWg==
X-Google-Smtp-Source: ACHHUZ7Iqx0vL6V3LVeewnqqvq60pcrcmV4MCZCXkDujCQapj7giJzPzy369u8mqxENhYOeuWGUqnA==
X-Received: by 2002:a25:2515:0:b0:ba7:9c6f:e2de with SMTP id l21-20020a252515000000b00ba79c6fe2demr8114720ybl.27.1685569912139;
        Wed, 31 May 2023 14:51:52 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id b5-20020a170903228500b001ac2c3e436asm1862215plh.186.2023.05.31.14.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 14:51:50 -0700 (PDT)
Date: Wed, 31 May 2023 14:51:48 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Gal Pressman <gal@nvidia.com>
Cc: David Ahern <dsahern@gmail.com>, Eric Dumazet <edumazet@google.com>,
 netdev <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
 Hangbin Liu <liuhangbin@gmail.com>, Phil Sutter <phil@nwl.cc>, Jakub
 Kicinski <kuba@kernel.org>, Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH iproute2] lib/libnetlink: ensure a minimum of 32KB for
 the buffer used in rtnl_recvmsg()
Message-ID: <20230531145148.2cb3cbe8@hermes.local>
In-Reply-To: <7517ba8c-2f51-6ced-ba84-e349f5db8cac@nvidia.com>
References: <20190213015841.140383-1-edumazet@google.com>
	<b42f0dcb-3c8c-9797-a9f1-da71642e26cc@gmail.com>
	<7517ba8c-2f51-6ced-ba84-e349f5db8cac@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 29 May 2023 15:29:51 +0300
Gal Pressman <gal@nvidia.com> wrote:

> On 13/02/2019 4:04, David Ahern wrote:
> > On 2/12/19 6:58 PM, Eric Dumazet wrote:  
> >> In the past, we tried to increase the buffer size up to 32 KB in order
> >> to reduce number of syscalls per dump.
> >>
> >> Commit 2d34851cd341 ("lib/libnetlink: re malloc buff if size is not enough")
> >> brought the size back to 4KB because the kernel can not know the application
> >> is ready to receive bigger requests.
> >>
> >> See kernel commits 9063e21fb026 ("netlink: autosize skb lengthes") and
> >> d35c99ff77ec ("netlink: do not enter direct reclaim from netlink_dump()")
> >> for more details.
> >>
> >> Fixes: 2d34851cd341 ("lib/libnetlink: re malloc buff if size is not enough")
> >> Signed-off-by: Eric Dumazet <edumazet@google.com>
> >> Cc: Hangbin Liu <liuhangbin@gmail.com>
> >> Cc: Phil Sutter <phil@nwl.cc>
> >> ---
> >>  lib/libnetlink.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >> diff --git a/lib/libnetlink.c b/lib/libnetlink.c
> >> index 1892a02ab5d0d73776c9882ffc77edcd2c663d01..0d48a3d43cf03065dacbd419578ab10af56431a4 100644
> >> --- a/lib/libnetlink.c
> >> +++ b/lib/libnetlink.c
> >> @@ -718,6 +718,8 @@ static int rtnl_recvmsg(int fd, struct msghdr *msg, char **answer)
> >>  	if (len < 0)
> >>  		return len;
> >>  
> >> +	if (len < 32768)
> >> +		len = 32768;
> >>  	buf = malloc(len);
> >>  	if (!buf) {
> >>  		fprintf(stderr, "malloc error: not enough buffer\n");
> >>  
> > 
> > I believe that negates the whole point of 2d34851cd341 - which I have no
> > problem with. 2 recvmsg calls per message is overkill.
> > 
> > Do we know of any single message sizes > 32k? 2d34851cd341 cites
> > increasing VF's but at some point there is a limit. If not, the whole
> > PEEK thing should go away and we just malloc 32k (or 64k) buffers for
> > each recvmsg.
> >   
> 
> Hey,
> 
> Sorry for reviving this old thread, but I see this topic was already
> discussed here :).
> I have a system where the large number of VFs result in a message
> greater than 32k, which makes a simple 'ip link' command return an error.
> 
> Should we change the kernel's 'max_recvmsg_len' to 64k? Any other (more
> robust) ideas to resolve this issue?

No matter what the size, someone will always have too many VF's to fit
in the response. There is no way to get a stable solution without doing
some API changes.

It is possible to dump millions of routes, so it is not directly a netlink
issue more that the current API is slamming all the VF's as info blocks
under a single message response.

That would mean replacing IFLA_VFINFO_LIST with a separate query

