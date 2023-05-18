Return-Path: <netdev+bounces-3482-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C35D707819
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 04:35:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D46C1C21011
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 02:35:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57838376;
	Thu, 18 May 2023 02:35:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DFA19B
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 02:35:13 +0000 (UTC)
Received: from mail-yw1-x1141.google.com (mail-yw1-x1141.google.com [IPv6:2607:f8b0:4864:20::1141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD87271C;
	Wed, 17 May 2023 19:35:11 -0700 (PDT)
Received: by mail-yw1-x1141.google.com with SMTP id 00721157ae682-55a8e9e2c53so14100597b3.1;
        Wed, 17 May 2023 19:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684377311; x=1686969311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVYu0Kdniu+LeyAgJA6DxqCaT7Y/4cXtb7QYlDhpbAo=;
        b=aBCcK89w/zLXN5wAjxL34JR8mtN28L8xm9l1r5uF4mA68Wps5/kT5yrrRkL1hlFTT9
         1hsdDN8tQN5uKXhXbW3A4jKYZJ+wwIseS7IDv+DbOF7BTLajLBecWJis4J94xejHLMVG
         JoGxsHxXn9QuEbMUMullhLAu1tRbmKsYnEcsmV/DW2KbZq/PXXlRuZUYLT7RhoZoDsZ5
         HDeDqZsoFSaa8LTvfQpztCniK9BcB6iJ8zxmcZBasvCfG1Nw9SnlAY6I6zSzkIFfKb5a
         It/sJ7+ruku/GhIKVWSyDSA5tC79U39QcHn7Wh5guyGHFNz8XZtKe2/Gq/2x5757LeDf
         sm2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684377311; x=1686969311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wVYu0Kdniu+LeyAgJA6DxqCaT7Y/4cXtb7QYlDhpbAo=;
        b=MkTRyr26jvnzgRnlaoPIEzPeWb7eY3eLuQwxtqRsJt5tAfpmUKKPgNnklPuVaOfRlX
         4FoVLfeAxXG3ZhvYewhc43G/dwYZMHZXPrQTOCejpMKhoYUB32i76pD2+2eMZCuNhoQx
         DpoMlo/ukWMeoUuIb0jzRLEH8hjfy4Dc1z+4p10F8bKZwPjKcbQ/Z3fQnDc46nCGutbv
         GCM5OadEfvaMarCClNhSr0jD9OR889G3rVw6yRKPZ+oaVVXOwIxFdPAdzjH7wTh5KQe8
         NU18QFe1v69ss9vFqrpbQv8r9GJo+hATEzMhc5DYNHt8hpUb1cG4pO+/FVXs3pMM6hqI
         pRXg==
X-Gm-Message-State: AC+VfDyJMreTOKItWQzAgYygT4yjRejLUtaZvNr7VIJ3yuXT0B/+3pFY
	JjulzQs0HYYB+BaI2zfjJsIyH00AL4AyMYlJngLhYjfCXy9t+yYX
X-Google-Smtp-Source: ACHHUZ5woWaegw7WkNe3DS8eKpU3rIA7TCmW6RrJrL9oa4rwSu5LiF7GQ59UVDeupoUBMBCnLxR8XBHmGcORNCDxtmI=
X-Received: by 2002:a81:7d55:0:b0:54f:752e:9b63 with SMTP id
 y82-20020a817d55000000b0054f752e9b63mr194146ywc.15.1684377310756; Wed, 17 May
 2023 19:35:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517124201.441634-1-imagedong@tencent.com>
 <20230517124201.441634-4-imagedong@tencent.com> <CANn89iKLf=V664AsUYC52h_q-xjEq9xC3KqTq8q+t262T91qVQ@mail.gmail.com>
In-Reply-To: <CANn89iKLf=V664AsUYC52h_q-xjEq9xC3KqTq8q+t262T91qVQ@mail.gmail.com>
From: Menglong Dong <menglong8.dong@gmail.com>
Date: Thu, 18 May 2023 10:34:59 +0800
Message-ID: <CADxym3a0gmzmD3Vwu_shoJnAHm-xjD5tJRuKwTvAXnVk_H55AA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: tcp: handle window shrink properly
To: Eric Dumazet <edumazet@google.com>
Cc: kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com, 
	dsahern@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 10:47=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Wed, May 17, 2023 at 2:42=E2=80=AFPM <menglong8.dong@gmail.com> wrote:
> >
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Window shrink is not allowed and also not handled for now, but it's
> > needed in some case.
> >
> > In the origin logic, 0 probe is triggered only when there is no any
> > data in the retrans queue and the receive window can't hold the data
> > of the 1th packet in the send queue.
> >
> > Now, let's change it and trigger the 0 probe in such cases:
> >
> > - if the retrans queue has data and the 1th packet in it is not within
> > the receive window
> > - no data in the retrans queue and the 1th packet in the send queue is
> > out of the end of the receive window
>
> Sorry, I do not understand.
>
> Please provide packetdrill tests for new behavior like that.
>

Yes. The problem can be reproduced easily.

1. choose a server machine, decrease it's tcp_mem with:
    echo '1024 1500 2048' > /proc/sys/net/ipv4/tcp_mem
2. call listen() and accept() on a port, such as 8888. We call
    accept() looply and without call recv() to make the data stay
    in the receive queue.
3. choose a client machine, and create 100 TCP connection
    to the 8888 port of the server. Then, every connection sends
    data about 1M.
4. we can see that some of the connection enter the 0-probe
    state, but some of them keep retrans again and again. As
    the server is up to the tcp_mem[2] and skb is dropped before
    the recv_buf full and the connection enter 0-probe state.
    Finially, some of these connection will timeout and break.

With this series, all the 100 connections will enter 0-probe
status and connection break won't happen. And the data
trans will recover if we increase tcp_mem or call 'recv()'
on the sockets in the server.

> Also, such fundamental change would need IETF discussion first.
> We do not want linux to cause network collapses just because billions
> of devices send more zero probes.

I think it maybe a good idea to make the connection enter
0-probe, rather than drop the skb silently. What 0-probe
meaning is to wait for space available when the buffer of the
receive queue is full. And maybe we can also use 0-probe
when the "buffer" of "TCP protocol" (which means tcp_mem)
is full?

Am I right?

Thanks!
Menglong Dong

