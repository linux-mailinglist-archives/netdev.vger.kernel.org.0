Return-Path: <netdev+bounces-4129-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7728F70B03B
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 22:26:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61D70280E6B
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 20:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662579467;
	Sun, 21 May 2023 20:26:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF758F65;
	Sun, 21 May 2023 20:26:44 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0ADDE;
	Sun, 21 May 2023 13:26:41 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-96fb45a5258so202725966b.2;
        Sun, 21 May 2023 13:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684700799; x=1687292799;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X69f/eGnne5uw8yiXIr7+EFlS/jdrHMk5L4Y1wX1DGQ=;
        b=jnsY8z2hfPE31V+hrL/HzhhcAGpVZ6Mm21zRAWHOlkIBTGzfCaBM+h3RJct1KT13Qf
         M3qx5sdy6Dkr53cnZ9gVVAgU5awrQHDS6IA5Q1EdyGPZCL9EuyiLF/CPyru/DmBYGt+n
         ++9YboruM2OFupJ407QPbsSuQo2TYmJJOxiDkdfd12n+dS/RsjtT9/WJ/N4/62mvM1Gt
         HqGCf/m4XCIpHPv4qTpXZnwKP5j8zqzJP6gXB7RzcCMkKi9dH3+aAt7Ja3wHpIMznLPO
         xNqwQ8fGowGu3A3Krn3cuextzAYW3XidKaOh2papT5EgbNOZrjjsNnnt/YWlfzzzvQE4
         LhSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684700799; x=1687292799;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X69f/eGnne5uw8yiXIr7+EFlS/jdrHMk5L4Y1wX1DGQ=;
        b=Ou/Rx+OxKXT5YzcS/rLOJ/JHh8YMBnd+pQalJS+uW5FFJ6FLg+tyFHThIdaCujG+94
         tcNeuzNIZJbLdW9j+HqF3vUVhqDdfs0RxKoHfDo14Vys9EBPf4M9Xe8LdDkv6o+nburg
         bnsZrbpNelWS8AsmXoK2bO9tOsuU2VgSo1msANjl8eOWgrGRcmlEtIPuo7rFvDk3ufGX
         R5uQfBIPEbq5eQapxP3MNUBfyr74unwjxG6nTODRbL1IYUcSrC90q1O2eUOwcbR3qQnE
         NScVnvHGxR3Fn87+Gh3P6xhgaRpyTEAzoPfumB5XmKSRRqVLk3nlIbEYCweMtuEf8HFD
         G3jQ==
X-Gm-Message-State: AC+VfDw1UMpOf6QnG88ISa3CwmMM8V1vUAoJ8OS9ZJT9+dugkAo/IQTW
	mHiP2tgBAoph6DOSxnkaYdI=
X-Google-Smtp-Source: ACHHUZ74hjAZJLte5l7Qajhb8oZ9w/ViPSQhmPHkbC3tzZjyEiPOw2sJ6WzFVmLMROXwW5AUuRvdTA==
X-Received: by 2002:a17:907:6d26:b0:957:2e48:5657 with SMTP id sa38-20020a1709076d2600b009572e485657mr7459511ejc.68.1684700799383;
        Sun, 21 May 2023 13:26:39 -0700 (PDT)
Received: from krava ([83.240.61.63])
        by smtp.gmail.com with ESMTPSA id t11-20020a17090616cb00b0094f1b8901e1sm2256648ejd.68.2023.05.21.13.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 13:26:38 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Sun, 21 May 2023 22:26:37 +0200
To: Ze Gao <zegao2021@gmail.com>
Cc: Yonghong Song <yhs@meta.com>, Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>, Hao Luo <haoluo@google.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Masami Hiramatsu <mhiramat@kernel.org>, Song Liu <song@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Steven Rostedt <rostedt@goodmis.org>, Yonghong Song <yhs@fb.com>,
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kafai@fb.com,
	kpsingh@chromium.org, netdev@vger.kernel.org, paulmck@kernel.org,
	songliubraving@fb.com, Ze Gao <zegao@tencent.com>
Subject: Re:
Message-ID: <ZGp+fW855gmWuh9W@krava>
References: <20220515203653.4039075-1-jolsa@kernel.org>
 <20230520094722.5393-1-zegao@tencent.com>
 <b4f66729-90ab-080a-51ec-bf435ad6199d@meta.com>
 <CAD8CoPAXse1GKAb15O5tZJwBqMt1N_btH+qRe7c_a-ryUMjx7A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD8CoPAXse1GKAb15O5tZJwBqMt1N_btH+qRe7c_a-ryUMjx7A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 21, 2023 at 11:10:16PM +0800, Ze Gao wrote:
> > kprobe_multi/fprobe share the same set of attachments with fentry.
> > Currently, fentry does not filter with !rcu_is_watching, maybe
> > because this is an extreme corner case. Not sure whether it is
> > worthwhile or not.
> 
> Agreed, it's rare, especially after Peter's patches which push narrow
> down rcu eqs regions
> in the idle path and reduce the chance of any traceable functions
> happening in between.
> 
> However, from RCU's perspective, we ought to check if rcu_is_watching
> theoretically
> when there's a chance our code will run in the idle path and also we
> need rcu to be alive,
> And also we cannot simply make assumptions for any future changes in
> the idle path.
> You know, just like what was hit in the thread.
> 
> > Maybe if you can give a concrete example (e.g., attachment point)
> > with current code base to show what the issue you encountered and
> > it will make it easier to judge whether adding !rcu_is_watching()
> > is necessary or not.
> 
> I can reproduce likely warnings on v6.1.18 where arch_cpu_idle is
> traceable but not on the latest version
> so far. But as I state above, in theory we need it. So here is a
> gentle ping :) .

hum, this change [1] added rcu_is_watching check to ftrace_test_recursion_trylock,
which we use in fprobe_handler and is coming to fprobe_exit_handler in [2]

I might be missing something, but it seems like we don't need another
rcu_is_watching call on kprobe_multi level

jirka


[1] d099dbfd3306 cpuidle: tracing: Warn about !rcu_is_watching()
[2] https://lore.kernel.org/bpf/20230517034510.15639-4-zegao@tencent.com/

