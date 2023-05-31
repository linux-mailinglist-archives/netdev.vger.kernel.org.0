Return-Path: <netdev+bounces-6666-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6459A7175C1
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13A632812FC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 04:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 216FF10F1;
	Wed, 31 May 2023 04:38:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11008A40
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 04:38:58 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BB497
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:38:57 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f6a6b9bebdso40995e9.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685507935; x=1688099935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P/+gjCsFKqG9vnZmOOKmadqwNTWxQaaIAiyi21nC3sk=;
        b=plXfXHtcMzSr4jW+jPJQnghT0pr6aubL0icFv5xkhKRp8C0+KYGoQTVMi/xVwurxMh
         c03806dxjq1NBBa96Ep+mLrcf+xXucr85bb7X/BaN+r8OqblB047mMGzcocyHujB6at/
         IHJ8lyOpmn/dFFSPlak4uHr3CTwYDu+YQWrpKgTdlLoL0clpL7H2whO9NlUmS9Qja8Qe
         qu+xKfoehyU02AzNC2t818ZRxG121w0cKTZb5zuvg/kMKrlny9U5yhR7kqlPbSERRvx6
         F9/rY3fzKR/TKYYerYWk7Uxnlh1x7MmRPi8pScNAXbNRvBGUCFhnLgVWApxCtqkzuwcQ
         7/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685507935; x=1688099935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P/+gjCsFKqG9vnZmOOKmadqwNTWxQaaIAiyi21nC3sk=;
        b=ld4X7Iv732pcCN8Vts054clMAoA7tJGgoyNr26J9Bjy1WUm2r0sIfWJVavRX4sQHUa
         cyVjKymnkvW7X+Ue9fCjkKBVmrX1TL9le3VjaEOWjCT7f0Y0dF4W6AJBkLsciFaekE5B
         e+vdsRUbX6et/mIzo1GuGS2Y293GCtTg8XdnwERzBz6YHTEshwKEJ0xyTwHEUNf2+/Am
         0y6H9jpAYVzlsHmdv4V1RAiGkq/P/QOW0nYKJmN19fElvfT35BMMsdFKW5h/vo8HMqbu
         dVB3KnbFNXvOkuUU+NSDY6BtuN2NI7jJSmKnmWw2ORtb5OYDpA499n1ouujp0zIUvBA/
         TZnw==
X-Gm-Message-State: AC+VfDwEIv3Nri2yAcVX3PQGisWVTeih8h/LmDIZeBKU5iKRuZwPSlWh
	mM0gritvKmPtqeMSL7U7Y0UtRf/t9B6soqasQ9l4pKaAuN8bbV+8Fb9n3Q==
X-Google-Smtp-Source: ACHHUZ5Dng4r5VkNz1A0sFcaRSceKqExvLudTNf9cD5IyBB10jcUm+pq8gOL6Mv5cJw0u5BUQcWAJisnZd4hAscLFHA=
X-Received: by 2002:a05:600c:310f:b0:3f1:6fe9:4a95 with SMTP id
 g15-20020a05600c310f00b003f16fe94a95mr95797wmo.4.1685507935523; Tue, 30 May
 2023 21:38:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230529134430.492879-1-parav@nvidia.com> <b4940bfa-aab6-644a-77d3-20bf9a876a6a@kernel.org>
 <CANn89iLxUk6KpQ1a=Q+pNb95nkS6fYbHsuBGdxyTX23fuTGo6g@mail.gmail.com>
 <20230530123929.42472e9f@kernel.org> <cabcc033-89d2-de7b-d510-14f875942109@kernel.org>
In-Reply-To: <cabcc033-89d2-de7b-d510-14f875942109@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 31 May 2023 06:38:43 +0200
Message-ID: <CANn89iKKsOGWQNhYFSXChkHMx5ZBojLZf2sKuybTxage4LC4_Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Make gro complete function to return void
To: David Ahern <dsahern@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Parav Pandit <parav@nvidia.com>, davem@davemloft.net, 
	pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 12:36=E2=80=AFAM David Ahern <dsahern@kernel.org> w=
rote:
>
> On 5/30/23 1:39 PM, Jakub Kicinski wrote:
> > On Tue, 30 May 2023 17:48:22 +0200 Eric Dumazet wrote:
> >>> tcp_gro_complete seems fairly trivial. Any reason not to make it an
> >>> inline and avoid another function call in the datapath?
> >>
> >> Probably, although it is a regular function call, not an indirect one.
> >>
> >> In the grand total of driver rx napi + GRO cost, saving a few cycles
> >> per GRO completed packet is quite small.
> >
> > IOW please make sure you include the performance analysis quantifying
> > the win, if you want to make this a static inline. Or let us know if
> > the patch is good as is, I'm keeping it in pw for now.
>
> I am not suggesting holding up this patch; just constantly looking for
> these little savings here and there to keep lowering the overhead.
>
> 100G, 1500 MTU, line rate is 8.3M pps so GRO wise that would be ~180k
> fewer function calls.

Here with 4K MTU, this is called 67k per second

An __skb_put() instead of skb_put() in a driver (eg mlx5e_build_linear_skb(=
))
would have 45x more impact, and would still be noise.

