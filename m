Return-Path: <netdev+bounces-4343-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD25270C253
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:27:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60B501C20B38
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:27:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CA4114AA4;
	Mon, 22 May 2023 15:27:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7A714A98
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 15:27:41 +0000 (UTC)
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D8EA1;
	Mon, 22 May 2023 08:27:40 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id 6a1803df08f44-5e5b5da22b8so9710596d6.0;
        Mon, 22 May 2023 08:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684769259; x=1687361259;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xa/ua3ow8lJkwBDnoTBS0dJRU1AVeGtz9D7HTeSun6k=;
        b=ECnG3apANojL8aEfq5G+Ik1+yG9BwL936d4N4e4AQstLABStMolNIBU2nwk4e609mv
         IwuHKuX35pAiRbr3tk9wQDLAxvJMRHYn1LziG7VldDjvPIhJSE+YUk9LM621zC2bvJQ9
         mgRwVWxH/xJ1zq7atFzjbsv/qi/D5hPFaFQruTeGdLNzl58jlwlJHM7CISzvH6/eznwM
         XCYntLzDYWGw8CJmc+fLxoMsPb6xH9HrR5a+R69m/DQT+BJV4MnKWGMOVzYowQ8AvqTG
         RVqH4t4/g9x9ClgRAlX4F33UzlJFZE+wcqmIvcD9S+8tPdnrgqQE6ve2wgBZ+3tXuToW
         jbuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684769259; x=1687361259;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xa/ua3ow8lJkwBDnoTBS0dJRU1AVeGtz9D7HTeSun6k=;
        b=cApo49kjN457cJEgoOWhYWOm7rbp4+zEL4nY56pD6F29S/4nKbiqWaqS+ODXiZ5xFa
         RIxbemHa+Q+7Z3TPWbyT6fXt3OBraCWC8tbvBLLBnr6PABkK2Ry9gWK3+0IL74DDl+fV
         graaxRmpkN49Y4waZVdW9VraLd5H82STkj1nQeOqx3ZnS/nLSEv1fQ5B+EAxjyfD/v2Q
         l7UjwPLbeVzkZQAMjUWylNrUreVXVDSSbuQjlbTTq1RItxZyILxqDZtDt1G3sDs3IqF0
         eUXQyyx6+slnXVYTMXJGEOjg5pzB2Oaq4i8An5S8huLZtkpl3u/UWRIYJSizF2A2Z4kA
         gh0g==
X-Gm-Message-State: AC+VfDzmhjMhRA45rfwDqRustennEl353EOmE1WAawVj7PoJab+DsRNp
	KIZmVJln/VTyPlqZdQebXw/IaRailZLJqZY44Gc=
X-Google-Smtp-Source: ACHHUZ5KYk+as52iODE4Sis2n+4GA/Rz8Y5VlAKTZhpWxv00l5E83NNoKzGzMtgFmDk+iN7tIl2rf9g82wiLbors6EY=
X-Received: by 2002:ad4:574f:0:b0:61b:73b2:85ca with SMTP id
 q15-20020ad4574f000000b0061b73b285camr18600992qvx.5.1684769258852; Mon, 22
 May 2023 08:27:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
 <20230516161841.37138-8-aleksander.lobakin@intel.com> <20230517211211.1d1bbd0b@kernel.org>
 <9feef136-7ff3-91a4-4198-237b07a91c0c@intel.com> <20230518075643.3a242837@kernel.org>
 <0dfa36f1-a847-739e-4557-fc43e2e8c6a7@intel.com> <20230518133627.72747418@kernel.org>
 <77d929b2-c124-d3db-1cd9-8301d1d269d3@intel.com> <20230519134545.5807e1d8@kernel.org>
 <5effd41a-81c3-4815-826d-ba5d8f6c69b4@intel.com>
In-Reply-To: <5effd41a-81c3-4815-826d-ba5d8f6c69b4@intel.com>
From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Mon, 22 May 2023 17:27:27 +0200
Message-ID: <CAJ8uoz30j7axJ+jd4UC4v57SBBBExbshQk7EZo-+bvPHOmcbSw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 07/11] net: page_pool: add
 DMA-sync-for-CPU inline helpers
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Larysa Zaremba <larysa.zaremba@intel.com>, netdev@vger.kernel.org, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Eric Dumazet <edumazet@google.com>, 
	Michal Kubiak <michal.kubiak@intel.com>, intel-wired-lan@lists.osuosl.org, 
	Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 22 May 2023 at 15:50, Alexander Lobakin
<aleksander.lobakin@intel.com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Fri, 19 May 2023 13:45:45 -0700
>
> > On Fri, 19 May 2023 15:56:40 +0200 Alexander Lobakin wrote:
> >> From: Jakub Kicinski <kuba@kernel.org>
> >> Date: Thu, 18 May 2023 13:36:27 -0700
>
> [...]
>
> > Ack, not saying that we need to split now, it's just about the naming
> > (everyone's favorite topic).
> >
> > I think that it's a touch weird to name the header _drv.h and then
> > include it in the core in multiple places (*cough* xdp_sock_drv.h).
>
> Hahaha, I also thought of it :>

Haha! Point taken. Will clear it up.

> > Also If someone needs to add another "heavy" static line for use by
> > the core they will try to put it in page_pool.h rather than _drv.h...
> >
> > I'd rather split the includes by the basic language-level contents,
> > first, then by the intended consumer, only if necessary. Language
> > level sorting require less thinking :)
> >
> > But none of this is important, if you don't wanna to do it, just keep
> > the new helpers in page_pool.h (let's not do another _drv.h).
>
> Ack, will just put there. It doesn't get included by the whole kernel
> via skbuff.h anymore (in v2), so new inlines won't hurt.
>
> Thanks,
> Olek
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan

