Return-Path: <netdev+bounces-4525-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 202C770D2D8
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:41:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D03932811F4
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23CDD4C8C;
	Tue, 23 May 2023 04:41:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158324C60
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 04:41:03 +0000 (UTC)
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5459EFA;
	Mon, 22 May 2023 21:41:01 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-75788255892so336114585a.0;
        Mon, 22 May 2023 21:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684816860; x=1687408860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sPNUzETyhkj3aRDll67ULSPjJU+HMr4o/YJWjxlqwJo=;
        b=QIkPR+TDbEW1/AGnwRZwu1CTLhhESC1vX2vYbpJ4xAVntURh9xy5n6YujCkQp30yj+
         XdKNSe0KrJS1cB6k7yNeIwMOS02mZ3Uvvj8VZdfnjCIsJLTpMso2FB+03iQSa8b0hgkd
         y/o9wRK68/f5rMVuLTa1qAoZUZd3sZJYivSU5/A6hj4Jf4PdpBxYxGufYgBsOw/z39+e
         0v78l9wMGeFSoIbsSfQW41g8mcfMnmRVj6xQ5M9toAbE/KmaDPssJgVyr8afbBfdE2fV
         OniQXzdNMAms4jaBBwsLLon824tOwusLpr5eLtih+q4jSoxS/eMPQZvgTWhTU+M+OAvy
         olOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684816860; x=1687408860;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sPNUzETyhkj3aRDll67ULSPjJU+HMr4o/YJWjxlqwJo=;
        b=KKHDKpR4ZauJ4rt3q1sV4L1twCHyaG4jmmeV6JOrS+DjjXDW80sB28DrdLN20bCtWQ
         ZkTxkCwk/sBO9Xpq3moG85NEOKFhOeIOA9oPRX8PrDaDdHL0LXFSiA/xUvMGxjTZ/hZC
         UmwRrWZy7/zL4jtkL1ENlz7gCuo/3sthM2fJR2PX+KWfe23o3zTJkxVJYyUdym0gvIc8
         kToyhCK+bqyOhr8wUYY8onhui9aDcRsu85tey1UK14w2pUyCNhqNe1edQ2JQsM673Kli
         wnNVS65ks0LIgDSKaZAABhHe869U0h3hlfTSkqqPmEaIS6f9z280pWtWgXtXdFur56Wo
         cGLw==
X-Gm-Message-State: AC+VfDzlkehh6KfvQniSEB+S8iaMOUSLBXlnUMKgtRpA189BfnWXLzI9
	Q8Tv88r6k2rLQIr270o4FQ==
X-Google-Smtp-Source: ACHHUZ5r/ch+baEMfxxeubO4WLp16UazMj7E6vivplQOianGPTJQMQ+txjZ9kG13KAygIw7l6e8HFw==
X-Received: by 2002:ae9:edd4:0:b0:75b:23a1:8e46 with SMTP id c203-20020ae9edd4000000b0075b23a18e46mr2719164qkg.23.1684816860399;
        Mon, 22 May 2023 21:41:00 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:18c1:dc19:5e29:e9a0])
        by smtp.gmail.com with ESMTPSA id k21-20020a05620a143500b007591805caefsm2244491qkj.18.2023.05.22.21.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 21:41:00 -0700 (PDT)
Date: Mon, 22 May 2023 21:40:53 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
	Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH v2 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZGxD1U4fI8SNSNOW@C02FL77VMD6R.googleapis.com>
References: <cover.1684796705.git.peilin.ye@bytedance.com>
 <8e3383d0bacd084f0e33d9158d24bd411f1bf6ba.1684796705.git.peilin.ye@bytedance.com>
 <5b28cd6f-d921-b095-1190-474bcce89e53@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b28cd6f-d921-b095-1190-474bcce89e53@mojatatu.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Pedro,

On Tue, May 23, 2023 at 12:51:44AM -0300, Pedro Tammela wrote:
> With V2 patches 5 and 6 applied I was still able to trigger an oops.
>
> Branch is 'net' + patches 5 & 6:
> 145f639b9403 (HEAD -> main) net/sched: qdisc_destroy() old ingress and
> clsact Qdiscs before grafting
> 1aac74ef9673 net/sched: Refactor qdisc_graft() for ingress and clsact Qdiscs
> 18c40a1cc1d9 (origin/main, origin/HEAD) net/handshake: Fix sock->file
> allocation
>
> Kernel config is the same as in the syzbot report.
> Note that this was on a _single core_ VM.
> I will double check if v1 is triggering this issue (basically run the repro
> for a long time). For multi-core my VM is running OOM even on a 32Gb system.
> I will check if we have a spare server to run the repro.

Thanks for testing this, but the syzbot reproducer creates ingress Qdiscs
under TC_H_ROOT, which isn't covered by [6/6] i.e. it exercises the
"!ingress" path in qdisc_graft().  I think that's why you are still seeing
the oops.  Adding sch_{ingress,clsact} to TC_H_ROOT is no longer possible
after [1,2/6], and I think we'll need a different reproducer for [5,6/6].

However I just noticed that for some reason my git-send-email in my new
setup didn't auto-generate From: tags with my work email, so Author: will
be my personal email (I have to send patches from personal email to avoid
"[External] " subject prefixes) ... I will fix it in v3 soon.  Sorry in
advance for spamming.

Thanks,
Peilin Ye


