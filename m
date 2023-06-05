Return-Path: <netdev+bounces-8128-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1542722DA0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A97928125A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F16218B1A;
	Mon,  5 Jun 2023 17:26:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C126FC3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 17:26:50 +0000 (UTC)
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F22E10B
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:26:49 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f6e194e7bso4524263a12.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 10:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685986008; x=1688578008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gI5++jso8zojBV0vx6mKi/JVB3NStV9TzsSq8gpkyGA=;
        b=PSwb4y32X+7AX397LSBZScP3Tf2M7xCGNFdQmHQr9VKemE8hVL+QDGlKh+EBEdBIot
         paGsVJwM1q9ohix7Fl1ICi9rNp1cpN7X/So5fNTRn7CjJxfKGx8MQpk6E7LdLUaLJzdd
         yvrnI2CbMfwqB4YiSNDB7datL+0i9c3OZP4yPpiYH4TExE7A209nlepyNBSXyTfbUVWb
         1kyqHHHc5b+EuaMkhMaXzK5L8VbGVLP6Ly6ubQ1VWwTmhNo+gHIgQkrbN5HteXwJhfE8
         lIWsJ5sgQ/+DC7JLi1cqKzf4crOks92AaVcxmV98G3gafZC5VOF4zfZ1HNW3o8GGRSNH
         zeHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685986008; x=1688578008;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gI5++jso8zojBV0vx6mKi/JVB3NStV9TzsSq8gpkyGA=;
        b=Qf4xrVauXY7UUyj4U54oh6eIxG57PIA4b6df+vwWBbC8IX+84VGAHDa9N1oHO08saW
         Riaq4hhP/sMCOhp4x53hIx8epr5znJYkaVqG2/SrVwEB6esuD+I8GIhFM7nb9hqCDLBp
         wPekwaxF2SNO2LTSHEn57NiX0UzfD1E81+YgWzhZ8+b4pK/XDYoWEztFuBLxsH9OFb63
         tB4YQth6AkXHBLIIL6QbsZRsSDvqdXbPc1eXhANdjufXMKhSdvt4pN8Dofu1mXeWNtSD
         Ub6OpvTAjlA27GZnfQG0ShToUhH0fejLcUrNB1Whx9D3Xuzd6t3pSgt1hWvnVSRiVmDW
         nTWg==
X-Gm-Message-State: AC+VfDwT/j7lhYmtV3IXxIIq2xXYOuwB/JucGuzep6ENN0Lp+oMLndZ+
	9m35hOOVXahqlJMhvQiod9vXS6A=
X-Google-Smtp-Source: ACHHUZ7jBorG0N5niR51/rjKQ02tEOhsYvW3GusoQqySYItyHe2yyK+9rICJCRfVrzhy+Jm09OGOWcs=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a63:1542:0:b0:50c:a00:c1fa with SMTP id
 2-20020a631542000000b0050c0a00c1famr85783pgv.7.1685986008448; Mon, 05 Jun
 2023 10:26:48 -0700 (PDT)
Date: Mon, 5 Jun 2023 10:26:46 -0700
In-Reply-To: <20230605033449.239123-1-liuxin350@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230605033449.239123-1-liuxin350@huawei.com>
Message-ID: <ZH4a1l1pfG8ewo3v@google.com>
Subject: Re: [PATCH] libbpf:fix use empty function pointers in ringbuf_poll
From: Stanislav Fomichev <sdf@google.com>
To: Xin Liu <liuxin350@huawei.com>
Cc: daniel@iogearbox.net, andrii@kernel.org, ast@kernel.org, 
	bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com, 
	hsinweih@uci.edu, jakub@cloudflare.com, john.fastabend@gmail.com, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzbot+49f6cef45247ff249498@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com, yanan@huawei.com, wuchangye@huawei.com, 
	xiesongyang@huawei.com, kongweibin2@huawei.com, zhangmingyi5@huawei.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/05, Xin Liu wrote:
> From: zhangmingyi <zhangmingyi5@huawei.com>
> 
> The sample_cb of the ring_buffer__new interface can transfer NULL. However,
> the system does not check whether sample_cb is NULL during 
> ring_buffer__poll, null pointer is used.

What is the point of calling ring_buffer__new with sample_cb == NULL?

