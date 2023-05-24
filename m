Return-Path: <netdev+bounces-4962-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A9970F607
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:16:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E786A1C20C0E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0CA17FFA;
	Wed, 24 May 2023 12:16:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB598472
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:16:18 +0000 (UTC)
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4684C95;
	Wed, 24 May 2023 05:16:17 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id 3f1490d57ef6-ba841216e92so1301633276.1;
        Wed, 24 May 2023 05:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684930576; x=1687522576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZeWGmrGHcTUKek5D1d/3K+N0QwqTAuk/s7DHtNDR83c=;
        b=R26KXe8UXgRByvUUE/FVl822DA6adKtRr/1tB9P/naWqoQSz4wUpGTe5WyKYntjwqf
         DufxIXcSG6YXXAQbuWi8ORPaMrp2Mpbd7gmoOBQeB6l7USaBtyVpLVi1SG5FBaqWE9BH
         CzictmoBiiM0TYG+T1DFrmw4+PRx+JAbDn7SWeuwPg/fPjxMC8LrRuOO3VUBHzHxzhC0
         DTlMzAVnYP3YXhZGfslLix+bkGxNgz38HpftGYQSKv+bkKqu0+MW8noAJuQpTMLrJ7mB
         ylyIpcwFnTuVDRgpmRCy7y3gxHIgMkRnAezApbuyv6Vl/cATOhMIEHcVb+DNRwFDo0qS
         Mk2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684930576; x=1687522576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZeWGmrGHcTUKek5D1d/3K+N0QwqTAuk/s7DHtNDR83c=;
        b=GEg2A2HqYXGNEWXj/xwxuLpA1y77T3o4pK+27DNTK4mZX1uDmMlrpFe17ZsfVMkkqC
         Ifxpl/Y8D6lYjw5r0bM0nt5BhAlT88Q/nr3ire7otCYFt2Wn6jhg6dPrlbYQRvUW2xMq
         Xe7KoxIVzgcWpW77JSx7Od2YlIzeKZGIH3FeXA0SeYzgGeIJGuMCOskrrCObWN6ALH5C
         nzbB0gP8w87f1fzoqZkFlmgpyjmrUqLILVwpMLdiPOVr06otDwZXfroUapgpRidVIF36
         LZgM1uCfvPQ+7vAqlRBvB5LKKcWtSWlxiuDJob4yImsT+PHnUYui83drEGitRXAe0szx
         ILnQ==
X-Gm-Message-State: AC+VfDw/gyUcdQoc81XVN1gt9MixljKCEkfRSusOp9G2x9ZJylZFbwFy
	79S5hPwXzrzCl1/7mozvP2t06ndYcE0Nv6T1biO2H4ojnib+CIr4
X-Google-Smtp-Source: ACHHUZ5hCBgGYEukmp17FQDml0jhNe49jTedomYwYXVvyp43i8ZlH+hhuJhlbl6KN3mYVJ2464U2aGauSZShrRZkA2I=
X-Received: by 2002:a25:71d4:0:b0:ba8:3a86:15ca with SMTP id
 m203-20020a2571d4000000b00ba83a8615camr16871157ybc.60.1684930576394; Wed, 24
 May 2023 05:16:16 -0700 (PDT)
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
 <CADxym3bLnLS=V5L6hZ9-PhrE3ZPpW2YD_cAG=XntEH9ky1Z0aw@mail.gmail.com> <CADVnQyk4Wew4iv9WRGAOiJE6fKD+OuvnwF8UQcDf+G5Ou25yUA@mail.gmail.com>
In-Reply-To: <CADVnQyk4Wew4iv9WRGAOiJE6fKD+OuvnwF8UQcDf+G5Ou25yUA@mail.gmail.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Wed, 24 May 2023 20:16:04 +0800
Message-ID: <CADxym3YRLU7QVv1gWxZuV3W3tnFTbU+JKMLL_t9B+LxZCQEdig@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: tcp: handle window shrink properly
To: Neal Cardwell <ncardwell@google.com>
Cc: Eric Dumazet <edumazet@google.com>, kuba@kernel.org, davem@davemloft.net, 
	pabeni@redhat.com, dsahern@kernel.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>, 
	Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 9:27=E2=80=AFPM Neal Cardwell <ncardwell@google.com=
> wrote:
> > Oh, I understand what you mean now. You are saying that
> > retransmit that first packet in the retransmit queue instead
> > of zero-window probe packet when OOM of the receiver,
> > isn't it? In other word, retransmit the unacked data and ignore
> > the tcp_retries2 when we find the receiver is in OOM state.
>
> Yes. The idea would be to use a heuristic to estimate the receiver is
> currently OOM and use ICSK_TIME_PROBE0 / tcp_probe_timer() /
> tcp_write_wakeup() in this case instead of ICSK_TIME_RETRANS /
> tcp_retransmit_timer().
>

Well, I think that maybe we should use ICSK_TIME_PROBE0 /
tcp_probe_timer() / tcp_retransmit_skb(), isn't it?

What tcp_write_wakeup() does is send new data if the receive
window available, which means push new data into the retransmit
queue. However, what we need to do now is retransmit the first
packet in the rtx queue, isn't it?

In the tcp_ack(), we estimate that if the receiver is OOM and
mark the sk with OOM state, and raise ICSK_TIME_PROBE0.
When new data is acked, we leave the OOM state.

The OOM state can only happen when the rtx queue is not empty,
otherwise the tcp connection will enter normal zero-window probe
state. So when the timeout of ICSK_TIME_PROBE0, we need
retransmit the skb in the rtx queue.

tcp_write_wakeup() don't do the job the retransmit packet, but
send new data.

Am I right?

Thanks!
Menglong Dong

> > That's an option, and we can make the length of the data we
> > send to 1 byte, which means we keep retransmitting the first
> > byte that has not be acked in the retransmit queue.
>
> I don't think it would be worth adding special-case code to only send
> 1 byte.  If the data receiver is not OOM then for CPU and memory
> efficiency reasons (as well as simplicity) the data sender should send
> it a full MSS. So for those reasons I would suggest that in this
> potential approach tcp_write_wakeup() should stay the same.
>
> neal

