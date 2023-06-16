Return-Path: <netdev+bounces-11544-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3038733854
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:49:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EACC28169B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25CA1ACBB;
	Fri, 16 Jun 2023 18:49:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B636F1428F
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 18:49:23 +0000 (UTC)
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803A13A9D
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 11:49:22 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-3f9b7de94e7so33521cf.0
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 11:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686941361; x=1689533361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+cd2dUILKbDmptWcmfcBJgbORMPyWbfjCx/wkz5oUhM=;
        b=ubz1+vPW9ofVNYKXSEmtpLtiWXK+tW1gexpEUi/jUO04UwuPSlQfd21hS/CC4sx7z0
         Q4bGpwiPfYx0iIrtu3KgNTV5YO3n4TGQCenc5gRD58Zlhx1i3N8E3+hM5BettTW88avg
         SFYCeygPyW11Cizr1uheRsjNhYoh/7B8MhEq5Wx8G6hP9zvRodLomqFdCx3F7/BzGiie
         7AJdqucMaHW57Y9yRYBgFsdDjcM9dAMr5Nv2p73EP3Dri7ohits87vwdkac4bCMNj5Qy
         KtDXrhB1NXCquJGhIEhX4eYzl0rM+3/QyQ+xvcmZl5ows42m8xDs24gIa4cvVcPQUNux
         VBYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686941361; x=1689533361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+cd2dUILKbDmptWcmfcBJgbORMPyWbfjCx/wkz5oUhM=;
        b=lGwt8tFYQqaNESYFMm4IPaMdgGax7oVCjcOdDCJJD1vYwFR1FecLasHXRGV6TTk/T9
         bmZxanIsa69KodlWefi2HesYW02UddAz1xhj13ghkHG66XtZuhDfpG7qDQlZDUwH/MeM
         YcPF3dajOoBKLXSk1PWpp56wDt4UQmHVal9rQVf8dC5py0yrhchJ7feadKLgIQB1H1zk
         EqwbR+/UuNzdG/DuOUUCuAPX9+A81La/IeLEHzkjP0l1FmEb7DTR0sLvFo8Xe+ujxc9T
         wka9kkcdUQZE5VOCyBgYCr2K5sBxgawyVmr5/ebVlpcKIM5qdMTUuHakFok23AOPeZxQ
         VKsg==
X-Gm-Message-State: AC+VfDwOHhwZWesmabggj5qnfVNEEi8Qe5rMKI/rqAEO8W5qGExxnXxl
	/PiiW1ppzwJEj04Vu+0b+4gPvzOurn+Eo7HpIMjnaA==
X-Google-Smtp-Source: ACHHUZ7OudDf47jGsL3RDmPvLzetC3PwhYOPKzSlkGr+4HRgpdrbYsKnXDVbySeSZb1+MGpJ6Agq3FeuspcsR41mOEs=
X-Received: by 2002:a05:622a:1212:b0:3fa:3c8f:3435 with SMTP id
 y18-20020a05622a121200b003fa3c8f3435mr529182qtx.27.1686941360977; Fri, 16 Jun
 2023 11:49:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612030524.60537-1-mfreemon@cloudflare.com>
In-Reply-To: <20230612030524.60537-1-mfreemon@cloudflare.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 16 Jun 2023 20:49:09 +0200
Message-ID: <CANn89iJE+RSnaWREoOJGEDj_kKyzq2ZFfW77=8n2gCbFMr+u_Q@mail.gmail.com>
Subject: Re: [PATCH net-next v5] tcp: enforce receive buffer memory limits by
 allowing the tcp window to shrink
To: Mike Freemon <mfreemon@cloudflare.com>
Cc: netdev@vger.kernel.org, kernel-team@cloudflare.com, ncardwell@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 5:05=E2=80=AFAM Mike Freemon <mfreemon@cloudflare.c=
om> wrote:
>
> From: "mfreemon@cloudflare.com" <mfreemon@cloudflare.com>
>
> Under certain circumstances, the tcp receive buffer memory limit
> set by autotuning (sk_rcvbuf) is increased due to incoming data
> packets as a result of the window not closing when it should be.
> This can result in the receive buffer growing all the way up to
> tcp_rmem[2], even for tcp sessions with a low BDP.
>
> To reproduce:  Connect a TCP session with the receiver doing
> nothing and the sender sending small packets (an infinite loop
> of socket send() with 4 bytes of payload with a sleep of 1 ms
> in between each send()).  This will cause the tcp receive buffer
> to grow all the way up to tcp_rmem[2].
>
> [1] https://www.rfc-editor.org/rfc/rfc7323#appendix-F
> [2] https://www.rfc-editor.org/rfc/rfc7323#section-2.4
> [3] https://www.rfc-editor.org/rfc/rfc1122#page-91
> [4] https://www.rfc-editor.org/rfc/rfc793
> [5] https://www.rfc-editor.org/rfc/rfc1323
>
> Signed-off-by: Mike Freemon <mfreemon@cloudflare.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

