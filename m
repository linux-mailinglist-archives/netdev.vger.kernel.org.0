Return-Path: <netdev+bounces-4406-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CF8170C595
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF131281072
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:57:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50E25168B9;
	Mon, 22 May 2023 18:57:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7DF13AE5
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:57:34 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42428E6
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:57:30 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f600a6a890so11815e9.0
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684781849; x=1687373849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5K2vQzMv9RNitauKRDQ5JPQe/7PjWZsdmCRNjoMZRJg=;
        b=SXJRNOYPjzr9Ao5h26jhABB5UH2RlO9zeCrZbkYsqlfWRTd1E5vELd4VYgm71YlYyo
         5pgpR0GH6ccC9IRxq+4ruCAmPQX/yLJnka4hD5KAPgAl+tP5fXUBQtRp3ARHgPpMEFJq
         6RptLOauChgR8ovFIS9J0rs12cLFnRxblqH3z068hAsOxs1Exr1rZ/c9YAtTwUaQMzcW
         gQjxwN8Ctnun+miyMIsA85gj8zgjUt2nsvP1k+q9aSQ4Qm0wk3Ux3vaJjOdKcDzrB2wF
         Db24ZCr7BL2rPnlYQDNl8x4yUIjIQM6YAFxIap92Hzwfua8e9iQWZKupSU4ftFQTI4pi
         bnug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684781849; x=1687373849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5K2vQzMv9RNitauKRDQ5JPQe/7PjWZsdmCRNjoMZRJg=;
        b=f6Iaq0yReDq9QsmegPkPUM/AYNlR7AJ+U5CnEoi1QApcWFDaNYdEYC4re21KsesN3B
         DYY/+D879hMEl1MS4g994zTB1EBh+Qt/ZlXuCx9R1twalq3oi2US88IV6hZPhB8zsZeN
         wEbL+UnU6/t9LIvx8BpvHukEFFJAGLoTfudtn8zr533T4y/f6ApLFBRZFzHeenVChwrf
         B1kkrie8bdA30qHXfvXDpk+JVrnKOx2eyLX1X0NLQ2XbThwhfn/nxSnpmsw5Eh0k8e/8
         HDGK1P2jxRdUAIJNok15EjMmDssZEl/uHOL8hnGf6T6ruQV5e/XCbDEcyDkSmK14Am9f
         tNEg==
X-Gm-Message-State: AC+VfDwd9DA+pbfqbZDYzGw6Ti3dEaNDu/ESrvOK0BNf/3ON0NCbQZSB
	fhCi0gyWMJ7cJNAu1Toc4RJPnjOXKbeRUjsXRUzWWw==
X-Google-Smtp-Source: ACHHUZ4b5kqNOwcZl03+RjJg0TP/fVR93h6Y+uu9Tv9TAjDKByd/wIHDDcoG8eaFRD9UtdmVPsA2LhR0U3rMlwebSgU=
X-Received: by 2002:a05:600c:4e02:b0:3f4:2594:118a with SMTP id
 b2-20020a05600c4e0200b003f42594118amr27609wmq.2.1684781848555; Mon, 22 May
 2023 11:57:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522172302.90235-1-sj@kernel.org> <20230522173351.90497-1-sj@kernel.org>
In-Reply-To: <20230522173351.90497-1-sj@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 22 May 2023 20:57:16 +0200
Message-ID: <CANn89iJ7JZp2mtcL912SGzq90wKH0rR=X+2vPuinTnMdTsMvQA@mail.gmail.com>
Subject: Re: [PATCH net] net: fix skb leak in __skb_tstamp_tx()
To: SeongJae Park <sj@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>, davem@davemloft.net, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, nmanthey@amazon.de, 
	pabeni@redhat.com, ptyadav@amazon.de, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 7:33=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:

> Sorry for continuing adding noises, but seems the process is, or will be,
> changed by to the mainline commit dbbe7c962c3a8 ("docs: networking: drop
> special stable handling").

Whoever backported the patch because it had a Fixes: tag will do the
same if another patch also has a Fixes: tag.

I personally prefer Fixes: very precise tags to weak ones.

