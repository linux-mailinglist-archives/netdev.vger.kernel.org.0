Return-Path: <netdev+bounces-4663-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F271D70DBCA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:52:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA852281325
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A008D4A86E;
	Tue, 23 May 2023 11:52:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2F14A840
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 11:52:46 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062A8FE
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 04:52:45 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f601283b36so56605e9.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 04:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684842763; x=1687434763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wwn1+wSqu8BJa8ZePb3EGa+GpX6etsfdBmhlNHIm73k=;
        b=KjE+b2BgxwD9k8nR38iJHvKW2NNYm5Zq0XfRYI51d74JBM2ZjARaMz6jPL76ABkEdY
         j8C42zMeRj5BgV4RCqo1ouqxJdPQ3aKe0VRPXNtEEGgqJONTBuS0KoOywyTwzIFwGJzP
         Up8pFzQmuqekcyGB0VkQzaeFJDeF3Wqj+4brA76rAgo27EAe4qSXYZ1yyJeyuOZAmX+Q
         3jJ6RRrTmJMllhSPN5WyyPlHJMWaRysyNvxMF8E6Li1ntSNML1ze2ou3iwXIP8xn4dPo
         etVUDd0YP+zACSIgLNb60aWI8Cxp+0OueLRUavNK0UqOKlUhSuOFcfOJTLxem/20OBnz
         qDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684842763; x=1687434763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wwn1+wSqu8BJa8ZePb3EGa+GpX6etsfdBmhlNHIm73k=;
        b=k2QigR2Q8Yqrp71IwuoIRRMxQ3waBqhBHtLunWa1LLXJF2r3+oSYl4m8RLnA05lcZG
         mlnEqv401mgnaIzq0oAs0qGKaUUUaj6jOP4MXexwQvy8zuBxLZSI5zX7zSLlaO/lcyuw
         RGAKjcnS2S89WUtOjFDPyHRsy4+H8SYrHdwqAsqcBpr0qFmeFtkeeaaFPPNErKmk6EIX
         kiMiFf3/BluUQXjFRrlyORfxMHi4P/ymT2d98xHnY3FWAz7cGfFLVhce55nkhmTufLGe
         PBe/N5ZYJZEoIlpB8zhP69HIce9F4F1kzJlEQJ92wTpfN1m+p9pzywK3IPiu3URxb4vW
         oh/g==
X-Gm-Message-State: AC+VfDz4UN/9FhRY0uAlskUOymwfn0txej7UP5JmWsTbtuEajCb898tz
	uyukv8jtQlrBCCB/FM0AYfZKdk5Oh9THlUW3u2Xv+qsN0yHjd+BCETmjWQ==
X-Google-Smtp-Source: ACHHUZ5Cnc61oWMxuF385kVvxNOZuAtr1k252PasGL9zhKaMJGLFNZLljtBKFa2u6YPLov+BOUhxcSzc42a7+rjzwI4=
X-Received: by 2002:a05:600c:19cf:b0:3f1:73b8:b5fe with SMTP id
 u15-20020a05600c19cf00b003f173b8b5femr117011wmq.3.1684842763375; Tue, 23 May
 2023 04:52:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <34BAAED6-5CD0-42D0-A9FB-82A01962A2D7@linux.alibaba.com>
 <20230519080118.25539-1-cambda@linux.alibaba.com> <f55cd2026c6cc01e19f2248ef4ed27b7b8ad11e1.camel@redhat.com>
In-Reply-To: <f55cd2026c6cc01e19f2248ef4ed27b7b8ad11e1.camel@redhat.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 23 May 2023 13:52:31 +0200
Message-ID: <CANn89iJmsM1YH01MsuDovn2LAKTQopOBjg6LNP8Uy_jOJh1+5Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state
To: Paolo Abeni <pabeni@redhat.com>
Cc: Cambda Zhu <cambda@linux.alibaba.com>, netdev@vger.kernel.org, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, 
	Tony Lu <tonylu@linux.alibaba.com>, Jack Yang <mingliang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 12:28=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> wr=
ote:
>
> On Fri, 2023-05-19 at 16:01 +0800, Cambda Zhu wrote:
> > > This patch removes the tp->mss_cache check in getting TCP_MAXSEG of
> > > CLOSE/LISTEN sock. Checking if tp->mss_cache is zero is probably a bu=
g,
> > > since tp->mss_cache is initialized with TCP_MSS_DEFAULT. Getting
> > > TCP_MAXSEG of sock in other state will still return tp->mss_cache.
> > >
> > > Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> > > Reported-by: Jack Yang <mingliang@linux.alibaba.com>
>
> It's a bit strange not seeing Eric being mentioned above:
>

...

Usual way of dealing with this would be to add

Suggested-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/netdev/CANn89i+3kL9pYtkxkwxwNMzvC_w3LNUum_2=
=3D3u+UyLBmGmifHA@mail.gmail.com/#t


> https://lore.kernel.org/netdev/CANn89i+3kL9pYtkxkwxwNMzvC_w3LNUum_2=3D3u+=
UyLBmGmifHA@mail.gmail.com/#t
>
> Paolo
>

Patch SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>

