Return-Path: <netdev+bounces-4638-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A684D70DA6F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:26:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 735491C20D1C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 676491EA84;
	Tue, 23 May 2023 10:26:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561ED1EA70
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:26:24 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B826FE
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:26:20 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f606e111d3so38205e9.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684837579; x=1687429579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L1H76tKbgjPFeSY6ce6Fy9Gg5JTky+hF4vrdziz1dy0=;
        b=datsF4F2PP91XwOTePCnE1IMO83smQN6dzZrt4pSdfmrMJz/RpZ7LwT03X+EaUF0sd
         3rMkYOfLFESd5YmuX4zNZb/wrFuvu4CsKcAMiKg34oFacNxTgVMyh2JeHUNnpI9C1mrl
         R7cv8pq5JJtpcKdNwHjwUX59UBTSf3gnDCbZ8nSH6EYNHpzY08Pm4k2WNiAST5ZCzzrN
         rrrhoAFvFs9gpr8ARkVZekdzHyjebqv/1I/MUf+CRsZuAKsyY32IajkjH5A9jR3H1RBF
         Bt1DVgD3COqdnPE5J5XBtkgIyn05Bm7Jtbvz4wpuW+yJknid7JXRCuJ3uvK0mJeM8YDS
         1LRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684837579; x=1687429579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L1H76tKbgjPFeSY6ce6Fy9Gg5JTky+hF4vrdziz1dy0=;
        b=DN0QIxWD7xk/wulxuKF7nbyFiPYrxvOp6glHXQZiosJCHzHnTD+sxjrEWPPkLUzhKc
         I6TvY0V3PzLMltMxgVayDAduszabN9nrqd1GXTJ0rXbg/KguQinN7a+agJnF1MEMnxws
         0ZW6gcvPcBLUHqfFUyfamSp/Z1fSqSzt+x3Gb1/6vyXePyVNQVaRwslcudonHOhPv0m+
         FrXhieTW43TffCrqpFfg6mxO2z7Px+RSnr/Ht+62h0Tglj+OGOhbtHzvA70pwxbyNW0X
         xqfEWv4UEDE3e1wEdHJgJVX/7BKvzN5W97WeZd4Wk+NBDT6n8XKtrTmdeb2Dcz7cPsay
         EkQA==
X-Gm-Message-State: AC+VfDyct7W5JOAERz6ZTYzeHxaetwNEUzInxy3zRNJ3J8yr2Bicjtlq
	+Qopq7geDqaWyRqViegKlLU2rONR4ARoUt6deMOOoQ==
X-Google-Smtp-Source: ACHHUZ7p/LxtpjcqvWmqtAZKSYkPYql8MUrCOUd2n55sPHU1VYSxR9YvliEd4xR2jzKu+OHpmRmJtmXUX2xRF8ev38Y=
X-Received: by 2002:a05:600c:1e0f:b0:3f2:4fd2:e961 with SMTP id
 ay15-20020a05600c1e0f00b003f24fd2e961mr165715wmb.0.1684837578832; Tue, 23 May
 2023 03:26:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517124201.441634-1-imagedong@tencent.com>
 <20230517124201.441634-4-imagedong@tencent.com> <CANn89iKLf=V664AsUYC52h_q-xjEq9xC3KqTq8q+t262T91qVQ@mail.gmail.com>
 <CADxym3a0gmzmD3Vwu_shoJnAHm-xjD5tJRuKwTvAXnVk_H55AA@mail.gmail.com>
 <CADVnQynZ67511+cKF=hyiaLx5-fqPGGmpyJ-5Lk6ge-ivmAf-w@mail.gmail.com>
 <CADxym3ZiyYK7Vyz05qLv8jOPmNZXXepCsTbZxdkhSQxRx0cdSA@mail.gmail.com>
 <CADVnQy=JQkVGRsbL0u=-oZSpdaFBpz907yX24p3uUu2pMhUjGg@mail.gmail.com>
 <CADxym3awe-c29C-e1Y+efepLdpFWrG520ezJO1EjJ5C3arq6Eg@mail.gmail.com>
 <CADVnQyk2y68HKScad4W2jOy9uqe7TTCyY-StwdLWFPJhXU+CUA@mail.gmail.com>
 <CADxym3bbGkOv4dwATp6wT0KA4ZPiPGfxvqvYtEzF45GJDe=RXQ@mail.gmail.com> <CADVnQymzzZ9m30-1ZA+muvmt-bjaebtMT0Bh8Wp5vXZuYifONQ@mail.gmail.com>
In-Reply-To: <CADVnQymzzZ9m30-1ZA+muvmt-bjaebtMT0Bh8Wp5vXZuYifONQ@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 23 May 2023 12:26:06 +0200
Message-ID: <CANn89i+K1vo=suwPR43MHeRera513sof7Sz8Qz2tGS3WfWW=OA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: tcp: handle window shrink properly
To: Neal Cardwell <ncardwell@google.com>
Cc: Menglong Dong <menglong8.dong@gmail.com>, kuba@kernel.org, davem@davemloft.net, 
	pabeni@redhat.com, dsahern@kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>, 
	Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 5:04=E2=80=AFPM Neal Cardwell <ncardwell@google.com=
> wrote:
>
> On Sun, May 21, 2023 at 10:55=E2=80=AFPM Menglong Dong <menglong8.dong@gm=
ail.com> wrote:
>
> > BTW, a previous patch has explained the need to
> > support window shrink, which should satisfy the RFC
> > of TCP protocol:
> >
> > https://lore.kernel.org/netdev/20230308053353.675086-1-mfreemon@cloudfl=
are.com/
>
> Let's see what Eric thinks about that patch.

I have not received a copy of the patch, so I will not comment on it.

