Return-Path: <netdev+bounces-4589-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A83D770D53C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:37:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 804081C20D17
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19CEA1DDD3;
	Tue, 23 May 2023 07:36:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5C01D2D9
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:36:58 +0000 (UTC)
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6005C139
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 00:36:57 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-94a342f7c4cso1328286166b.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 00:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1684827415; x=1687419415;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=t59b5dObDa+SJIKgajgep5LVPEaYQ+q4ZH79RVF4PVM=;
        b=DLXJl66VC1/9BLZlVa1h7s99aBB4anQSbKyZ7VTzFsrTOtBGIHRLRuV+OcVOlkrJhm
         E0qGscSIVZjFwDD/YbPE9C6cQfyzuggRgXtYM8FIl5TG2EGq2bQhBSS404htbAX8MIC4
         PQvxl6Y1OVJB2mNGAuyb63/vK/NYHnFNTeMFE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684827415; x=1687419415;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t59b5dObDa+SJIKgajgep5LVPEaYQ+q4ZH79RVF4PVM=;
        b=jc+EvhlopL56d4/9cPV251lwh6jVj2wRBJdc3DYo2TfXYzjb716eHJ9dEFh9XTGbFF
         S16TjgFRqma64MXOt1E/SBu6UPY8pwDy0vYq5zmIpBQc+I9apf3S1ZCR3SvBZJJ/34Li
         xKdm9Voi/q0uAIksSloopJA+WwsViDzigTJOcEPNBH/LDwLAYIl7rt6VUDisNDF0N6+a
         w7yXc0bLpfdrea5z//GZ/ceo3W/r9t7WPQNAmRS0wgifaxSn4HtKbZpTkgbWIyoJsn2w
         DJlvOMRZb2z7VWwHWq9vBbrfTPSCMIiNLjzxKGRNjYJA5IjUX7+pfqOFyfXSeh3ETWwl
         N0hg==
X-Gm-Message-State: AC+VfDzwx7g+JCOpgSgYpV/Myp0S9GySdwAZys3SuNZRlnhshxTzRUxv
	8UP0+vjTksLDwhG0KheLqG63fA==
X-Google-Smtp-Source: ACHHUZ6/lWowG6QRPF8M+CFtCnOmr1Od3qg12tfnXsmc9bIeXWRqYUtdJ7HahEkF69ndmNBW8iPumQ==
X-Received: by 2002:a17:907:3ea5:b0:950:e44:47ae with SMTP id hs37-20020a1709073ea500b009500e4447aemr14264658ejc.40.1684827414748;
        Tue, 23 May 2023 00:36:54 -0700 (PDT)
Received: from cloudflare.com (79.184.126.163.ipv4.supernova.orange.pl. [79.184.126.163])
        by smtp.gmail.com with ESMTPSA id gv18-20020a170906f11200b00965a4350411sm4008921ejb.9.2023.05.23.00.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 00:36:54 -0700 (PDT)
References: <20230523025618.113937-1-john.fastabend@gmail.com>
 <20230523025618.113937-5-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From: Jakub Sitnicki <jakub@cloudflare.com>
To: John Fastabend <john.fastabend@gmail.com>
Cc: daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
 edumazet@google.com, ast@kernel.org, andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v10 04/14] bpf: sockmap, improved check for empty queue
Date: Tue, 23 May 2023 09:35:42 +0200
In-reply-to: <20230523025618.113937-5-john.fastabend@gmail.com>
Message-ID: <87h6s37b3f.fsf@cloudflare.com>
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
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 07:56 PM -07, John Fastabend wrote:
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

