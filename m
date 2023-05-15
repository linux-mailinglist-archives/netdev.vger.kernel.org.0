Return-Path: <netdev+bounces-2530-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 222597025F8
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:21:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83C4B2810EF
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A64958468;
	Mon, 15 May 2023 07:21:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9759F1FB1
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:21:25 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E837E6D
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 00:21:19 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f4234f67feso339595e9.0
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 00:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684135278; x=1686727278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eu3hDAbGl6HJftPaP2zd9YmTOFBhpgmb60DHeeqSWU4=;
        b=bGa5Diaj3pQHHQfFWaoJG2JWpF1v1vEk6B62v/9XOWFbenUFsbbXW5CnHpWNKzhOjT
         rrbtvfQiH2zCGD6SYDl7MigsjZ7IgIZBK/iO83C76qnq70m3sCmOrrdl+aseIQFsRWoK
         1u8C0YOQEjmiAks5TYSiPCt5uVRMbG61FmArKwy0tIw71koFITlAgUGubVlhNAdExYqd
         AjL4ldt3FXYr+CZ/DoJgyW6Om9N00X3omSScyk5WxuPM+xbfKjYLSeoQ9DWX00liQnTl
         k5L4RSc96Bo+vYwlQzDr6bYFMBHxnA73vmY9qFlNzwueZ3IAQSOtGR9WciZLICwhMv7Y
         /GHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684135278; x=1686727278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eu3hDAbGl6HJftPaP2zd9YmTOFBhpgmb60DHeeqSWU4=;
        b=BNx365KVJcf1XrdyLECSQLKi2ynTZQ49mO/mcuL5i1tq2QazOzZsN1ytYTTizVuX5b
         G4n2WV1xbOeeawdra5SswqblTvKBq0I75Lc50IYQ8HZOf7c1xFoGneisgUSrih+4/eDy
         WS1inWKZNIYLFzKG5ZPulmsgMgnuTahWyg8yM9qL6l3HaA2TMaerlDDfrjihsY8hHskk
         8b8PeESY0ZDnGJvMnodD53du5k+wkQOSnGVuaptA34k/ejLlJVB6zsc1MMzaCshyNsZq
         GdnpnbUFLYbZv63qMQWhnOCHEZwaQ06QqEPKE7ITky8JgF5JAj7/pMVP4Yu52yo7RzX3
         51pA==
X-Gm-Message-State: AC+VfDynJWQbl3LPmola2O43TePi3RgsnbflUrzPp1IfaWOXwgoiCQyb
	SDStXIQa+oX6yKszmOhN9CxyWMzeMPRQ81v0cGSYwQ==
X-Google-Smtp-Source: ACHHUZ7tjmwMWHPqBXry7NtB6PsuS1/EDoxOqCq209J3AafhCRrw5MkONoPuu3c0G7v4oyy+WnR04mxGZhsqmK02950=
X-Received: by 2002:a05:600c:310f:b0:3f1:6fe9:4a95 with SMTP id
 g15-20020a05600c310f00b003f16fe94a95mr790926wmo.4.1684135277727; Mon, 15 May
 2023 00:21:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230506085903.96133-1-wuyun.abel@bytedance.com>
 <588689343dcd6c904e7fc142a001043015e5b14e.camel@redhat.com>
 <d2abfe0c-0152-860c-60f7-2787973c95d0@bytedance.com> <6b355d57-30b4-748d-87f4-d79a50fe5487@bytedance.com>
In-Reply-To: <6b355d57-30b4-748d-87f4-d79a50fe5487@bytedance.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 15 May 2023 09:21:05 +0200
Message-ID: <CANn89iJqzE6r9dm2hoHxgYeLQvStZYvRhCxFVmpV_LczaO-4xw@mail.gmail.com>
Subject: Re: [PATCH] sock: Fix misuse of sk_under_memory_pressure()
To: Abel Wu <wuyun.abel@bytedance.com>
Cc: Paolo Abeni <pabeni@redhat.com>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 9:04=E2=80=AFAM Abel Wu <wuyun.abel@bytedance.com> =
wrote:
>
> Gentle ping :)
>

I still do not understand the patch.

If I do not understand the patch and its changelog now in May 2023,
how will anyone understand it later
when/if a regression is investigated ?

I repeat :

Changelog is evasive, I do not see what practical problem you want to solve=
.


sk_has_memory_pressure() is not about memcg, simply the fact that a
proto has a non NULL memory_pressure pointer.

I suggest that you answer these questions, and send a V2 with an
updated changelog.

Again, what is the practical problem you want to solve ?
What is the behavior of the current stack that you think is a problem ?

Thanks.

