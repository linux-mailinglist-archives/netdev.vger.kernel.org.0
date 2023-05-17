Return-Path: <netdev+bounces-3264-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5456A706474
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:45:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BEC91C20E87
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D930156CD;
	Wed, 17 May 2023 09:45:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E23156CA
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:45:14 +0000 (UTC)
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3357420B
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 02:45:11 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-510d1972d5aso573464a12.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 02:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1684316710; x=1686908710;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=XZrVa3PF/0YiCuRDxc1RTd1NEGG3jk4fNI1qEjLq8MU=;
        b=FCN03G7zLQdRYnGPe1ATDFNd8U9FP9nOfPxbjFQfNzGuVQRpnfIk8aUTzXrMiSNLra
         /iFG/eYVeJ4ar4qcpn04qpEzQWfH5wxsv+QeziYxF9XbmSarJrP5m6TE7eWdTHnD5Tdb
         H7BuH0n2l+NEYyMw9++YObU0rxM1C/jBWfZPY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684316710; x=1686908710;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZrVa3PF/0YiCuRDxc1RTd1NEGG3jk4fNI1qEjLq8MU=;
        b=PaaFbyybo92w3KdZH9Z2XgWzSMPoXOsgBUX99b9iC8xPHe4mTzYdH94L7z5WYOA4yg
         +T154rNBqFx3zmbgsQanyh7/n4sH1yJP98/npBXtQ/cWrl0paxrnaTJy3a6ZjtxAlxUm
         BbqvaZDtBZW3Suvq8C9sdFoO1HFlALTfDVkSKEAjHOIdeHmeWvdsRK2VnuVbsnTcobMS
         xSpdlmmmHiQPPPAXc/vkAcqMane6ABw69u9Y0m9Khlv2To9yBZ3BlR3zfoldto02hhAB
         WExdouNVocQ5LFdrWO39+fU0RAWSJVq2k2UuzhSppxKmedpi3yWN/8ezj6yzqdO1fN+x
         t1pQ==
X-Gm-Message-State: AC+VfDw/D9FuiKj7+Kimlt5oMWlmRGYAI8kwM4yaNkRhktflM2IPegCB
	Rg+Iwus5hoBm2cL/L4buzuPjBw==
X-Google-Smtp-Source: ACHHUZ6eYigrjPbq20PxH4JdsIGENu0XEV0bNTf53WTxHiNAWcDgW/7kRE9Z93TQQ5++SDyOreAoew==
X-Received: by 2002:aa7:dbcf:0:b0:510:d8a7:dacf with SMTP id v15-20020aa7dbcf000000b00510d8a7dacfmr354774edt.4.1684316710176;
        Wed, 17 May 2023 02:45:10 -0700 (PDT)
Received: from cloudflare.com ([82.163.205.2])
        by smtp.gmail.com with ESMTPSA id by26-20020a0564021b1a00b00506a09795e6sm8951911edb.26.2023.05.17.02.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 02:45:09 -0700 (PDT)
References: <20230517052244.294755-1-john.fastabend@gmail.com>
 <20230517052244.294755-5-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From: Jakub Sitnicki <jakub@cloudflare.com>
To: John Fastabend <john.fastabend@gmail.com>
Cc: daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
 edumazet@google.com, ast@kernel.org, andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v8 04/13] bpf: sockmap, improved check for empty queue
Date: Wed, 17 May 2023 11:44:51 +0200
In-reply-to: <20230517052244.294755-5-john.fastabend@gmail.com>
Message-ID: <87mt238f6j.fsf@cloudflare.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 10:22 PM -07, John Fastabend wrote:
> We noticed some rare sk_buffs were stepping past the queue when system was
> under memory pressure. The general theory is to skip enqueueing
> sk_buffs when its not necessary which is the normal case with a system
> that is properly provisioned for the task, no memory pressure and enough
> cpu assigned.
>
> But, if we can't allocate memory due to an ENOMEM error when enqueueing
> the sk_buff into the sockmap receive queue we push it onto a delayed
> workqueue to retry later. When a new sk_buff is received we then check
> if that queue is empty. However, there is a problem with simply checking
> the queue length. When a sk_buff is being processed from the ingress queue
> but not yet on the sockmap msg receive queue its possible to also recv
> a sk_buff through normal path. It will check the ingress queue which is
> zero and then skip ahead of the pkt being processed.
>
> Previously we used sock lock from both contexts which made the problem
> harder to hit, but not impossible.
>
> To fix instead of popping the skb from the queue entirely we peek the
> skb from the queue and do the copy there. This ensures checks to the
> queue length are non-zero while skb is being processed. Then finally
> when the entire skb has been copied to user space queue or another
> socket we pop it off the queue. This way the queue length check allows
> bypassing the queue only after the list has been completely processed.
>
> To reproduce issue we run NGINX compliance test with sockmap running and
> observe some flakes in our testing that we attributed to this issue.
>
> Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> Tested-by: William Findlay <will@isovalent.com>
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

