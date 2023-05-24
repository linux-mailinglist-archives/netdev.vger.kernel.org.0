Return-Path: <netdev+bounces-5067-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E77E70F92F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:51:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05ED82810B8
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD1DC18C21;
	Wed, 24 May 2023 14:50:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1C1182DD
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 14:50:15 +0000 (UTC)
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3123135
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:50:12 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2af318fa2b8so13225541fa.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684939811; x=1687531811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PNI83IHDZg0DnQTSLvZZXiewUAhamCAFKviDqnioBtI=;
        b=1DVRg0+X+MTtQXzLll9ukhaTqIfXFP8BQDeFLQ4x8MmsVAEt83UYe4CEbNL1LdQ6i0
         9Bgg85PD7rWuhZnFGS+ixSR/5EQQZ7WvafA3fBTAMEOaLXjNM7+FLbDA+Je9VC1o++d5
         KqiN+SLvgkUM4uT+20Iqh/vk7BHwTdA+SLQoK/bLU5A7YAxOwecR9TjFjzXrlFbDaTxI
         H+fs173tnSHA2yZqrlUw51GGDzymCA87XuRYyEMIzT7kVoP8aoWlOnscyTuoGseJfciY
         YMTlHyyrt5F7o37yA5HCKCLKRvqxjwapGY6jFLZObo6dPdzZ+Dgryl6ZuDzOpx6PhDOf
         G2MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684939811; x=1687531811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PNI83IHDZg0DnQTSLvZZXiewUAhamCAFKviDqnioBtI=;
        b=F1QuqaV7Uw50Qwqy8t3MNBsX9dVBCdl3/g6kiD8kYGSmwBkoKNWlRSlTDDaAOFJ8BY
         N0WnXREo7MMocmVBovZaDjYrcg5tlRBSM6ChNDxz+nL1cqaO9etkwYAPYdQNYEuJKXA9
         Xp7x6/4H2KBaXVDOgLzJJb5wFIaj13OJjUCR0hkPuKF7BotY1NQjTBzYo1u52mr/75Ku
         q2tap7FBv8HfJReIg1PGofFcksZhVk05AfuFBkVWHLJ2WplvP84r2Mj4a0+kvpsFL96n
         yECZLIPa4QhBFByNnqtugom8kSPUjN8KW2pULe+LkAii4xf0M/aHRy+/dX1lfSoq29qP
         Ycpw==
X-Gm-Message-State: AC+VfDyNMRAvWReIuY3HLANoQTY9wzLua3Vzzf6V9lZfoeXiKWNVAkQ+
	/1LZk4MkpzRQ4YkrIfA8CC9xY6GPuZ6DRdyEcLVrTg==
X-Google-Smtp-Source: ACHHUZ5beHPEr/+7zmE8TL90w0AEunYP+kfpG6t/HAzbfugxCZaEPvw3Fi3MasPM6BKV6EoWR9P5YAcfx5Z1Bma4XrE=
X-Received: by 2002:a2e:850f:0:b0:2af:1622:a69 with SMTP id
 j15-20020a2e850f000000b002af16220a69mr6892941lji.48.1684939810842; Wed, 24
 May 2023 07:50:10 -0700 (PDT)
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
 <CADxym3bbGkOv4dwATp6wT0KA4ZPiPGfxvqvYtEzF45GJDe=RXQ@mail.gmail.com>
 <CADVnQymzzZ9m30-1ZA+muvmt-bjaebtMT0Bh8Wp5vXZuYifONQ@mail.gmail.com>
 <CADxym3bLnLS=V5L6hZ9-PhrE3ZPpW2YD_cAG=XntEH9ky1Z0aw@mail.gmail.com>
 <CADVnQyk4Wew4iv9WRGAOiJE6fKD+OuvnwF8UQcDf+G5Ou25yUA@mail.gmail.com> <CADxym3YRLU7QVv1gWxZuV3W3tnFTbU+JKMLL_t9B+LxZCQEdig@mail.gmail.com>
In-Reply-To: <CADxym3YRLU7QVv1gWxZuV3W3tnFTbU+JKMLL_t9B+LxZCQEdig@mail.gmail.com>
From: Neal Cardwell <ncardwell@google.com>
Date: Wed, 24 May 2023 10:49:48 -0400
Message-ID: <CADVnQy=KO5N=8S9Ow9Z40d-UYqvCH_ZLery_CiaJYDGmjB5qkg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: tcp: handle window shrink properly
To: Menglong Dong <menglong8.dong@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, kuba@kernel.org, davem@davemloft.net, 
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

On Wed, May 24, 2023 at 8:16=E2=80=AFAM Menglong Dong <menglong8.dong@gmail=
.com> wrote:
>
> On Tue, May 23, 2023 at 9:27=E2=80=AFPM Neal Cardwell <ncardwell@google.c=
om> wrote:
> > > Oh, I understand what you mean now. You are saying that
> > > retransmit that first packet in the retransmit queue instead
> > > of zero-window probe packet when OOM of the receiver,
> > > isn't it? In other word, retransmit the unacked data and ignore
> > > the tcp_retries2 when we find the receiver is in OOM state.
> >
> > Yes. The idea would be to use a heuristic to estimate the receiver is
> > currently OOM and use ICSK_TIME_PROBE0 / tcp_probe_timer() /
> > tcp_write_wakeup() in this case instead of ICSK_TIME_RETRANS /
> > tcp_retransmit_timer().
> >
>
> Well, I think that maybe we should use ICSK_TIME_PROBE0 /
> tcp_probe_timer() / tcp_retransmit_skb(), isn't it?
>
> What tcp_write_wakeup() does is send new data if the receive
> window available, which means push new data into the retransmit
> queue. However, what we need to do now is retransmit the first
> packet in the rtx queue, isn't it?
>
> In the tcp_ack(), we estimate that if the receiver is OOM and
> mark the sk with OOM state, and raise ICSK_TIME_PROBE0.
> When new data is acked, we leave the OOM state.
>
> The OOM state can only happen when the rtx queue is not empty,
> otherwise the tcp connection will enter normal zero-window probe
> state. So when the timeout of ICSK_TIME_PROBE0, we need
> retransmit the skb in the rtx queue.
>
> tcp_write_wakeup() don't do the job the retransmit packet, but
> send new data.
>
> Am I right?

Yes, that's a good point that the tcp_write_wakeup() code is not
currently a good fit for the OOM case, since it currently can only
send unsent data.

cheers,
neal


> Thanks!
> Menglong Dong
>
> > > That's an option, and we can make the length of the data we
> > > send to 1 byte, which means we keep retransmitting the first
> > > byte that has not be acked in the retransmit queue.
> >
> > I don't think it would be worth adding special-case code to only send
> > 1 byte.  If the data receiver is not OOM then for CPU and memory
> > efficiency reasons (as well as simplicity) the data sender should send
> > it a full MSS. So for those reasons I would suggest that in this
> > potential approach tcp_write_wakeup() should stay the same.
> >
> > neal

