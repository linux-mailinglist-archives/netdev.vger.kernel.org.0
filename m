Return-Path: <netdev+bounces-11930-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A900F7354F1
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6462D280FC1
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76741C142;
	Mon, 19 Jun 2023 10:59:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652FEC8E3
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:59:34 +0000 (UTC)
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0299B1BEA
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 03:59:31 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-3fde9bfb3c8so226531cf.0
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 03:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687172370; x=1689764370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vHU7Q3r9VuSR/qoRbBtGP+PwKHWneYQZHsRkTZogn8k=;
        b=0/JQ958alc48g9izGzBI+fW1TV+YaHwH0csOhj5ucGvB1Hz0zc960+LsPOUC/jIjY1
         +62bnqWg318itsFqGCoFD2u5ir+oIlSsfYbyzmTvs4+kbfLDhncTGE0T2nfUH8TW+I1h
         zBZ0xQazdu0cRetwKNqlWULioT1gcuddT1GYI50ScxJJplTmMGnsK3TJZoSbAZZ0Ja5d
         lliYJDdIqoBhSsr/OkR327Bd1gKbNHzNWa3dGC4QlqILfSXfvlODCHTAUSEh+t0KIhFr
         VYtvDCgr+cLFlmC3mROzMVF5o94GPGyFcjyBKy3msA/b7cFBZXIMna+gf1geh6nfgZP1
         BXNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687172370; x=1689764370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vHU7Q3r9VuSR/qoRbBtGP+PwKHWneYQZHsRkTZogn8k=;
        b=OLxp71BlJ2gfFTr1HqWnAlYCez0Vts+tHH5Lys/tWvzn8uht2cMNwUMDKtvjYylrzY
         +7k1hmEGIbJJareSUV6RCOby9D20pvisxLTJqU8FMHB0IgFLuoTMc9ZqANqa8ElPa5Yw
         Pt1c0nKAuxDPPm/Wgx/yQFhLCBoFrBGvnL6HNtmiWlQ60JJLuk92LYPotr3O7dWEqw+L
         uCcR5Fhcnl3rLJHmx8E8D5fy71ilSP3IqOf+VKeEnX8vY1lGtA9xJ+M8fM8nWaiHzjHK
         dhZFpnUb4YSncyfvrwuuvCHpofQlFQ0qY6T0Nccwus7dtQ2nuuI4UJD2qHTnExujrXLX
         kONA==
X-Gm-Message-State: AC+VfDxhtvjgo7e9wIRs9h0UfFN/gsUtANPnA6WMYFNQ8IM9q7ylYNIz
	k2KYdadu8dEEtjkeUFVC87ysJ5D+Mj409cKEKPMlOw==
X-Google-Smtp-Source: ACHHUZ60tWBhB1nzeFv+kh71okgXX6b+8Od/dNV/ks9AnDlD0VoZxmn1v5feECvWG/FleoCruXMxy+nMSbbOrM4JrqA=
X-Received: by 2002:ac8:7f8c:0:b0:3f8:6685:c944 with SMTP id
 z12-20020ac87f8c000000b003f86685c944mr929157qtj.14.1687172369892; Mon, 19 Jun
 2023 03:59:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1684501922.git.asml.silence@gmail.com> <a6838ca891ccff2c2407d9232ccd2a46fa3f8989.1684501922.git.asml.silence@gmail.com>
 <c025952ddc527f0b60b2c476bb30bd45e9863d41.camel@redhat.com>
 <5b93b626-df9a-6f8f-edc3-32a4478b8f00@gmail.com> <e972fc86-b884-3600-4e16-c9dbb53c6464@gmail.com>
In-Reply-To: <e972fc86-b884-3600-4e16-c9dbb53c6464@gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 19 Jun 2023 12:59:18 +0200
Message-ID: <CANn89iLU0BWxWrh1a3cfh+vOhRuyU5UJ8d5oD7ZW_GLfkMtvAQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net/tcp: optimise locking for blocking splice
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, davem@davemloft.net, 
	dsahern@kernel.org, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 11:27=E2=80=AFAM Pavel Begunkov <asml.silence@gmail=
.com> wrote:
>
> On 5/24/23 13:51, Pavel Begunkov wrote:
> > On 5/23/23 14:52, Paolo Abeni wrote:
> >> On Fri, 2023-05-19 at 14:33 +0100, Pavel Begunkov wrote:
> >>> Even when tcp_splice_read() reads all it was asked for, for blocking
> >>> sockets it'll release and immediately regrab the socket lock, loop
> >>> around and break on the while check.
> >>>
> >>> Check tss.len right after we adjust it, and return if we're done.
> >>> That saves us one release_sock(); lock_sock(); pair per successful
> >>> blocking splice read.
> >>>
> >>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >>> ---
> >>>   net/ipv4/tcp.c | 8 +++++---
> >>>   1 file changed, 5 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> >>> index 4d6392c16b7a..bf7627f37e69 100644
> >>> --- a/net/ipv4/tcp.c
> >>> +++ b/net/ipv4/tcp.c
> >>> @@ -789,13 +789,15 @@ ssize_t tcp_splice_read(struct socket *sock, lo=
ff_t *ppos,
> >>>        */
> >>>       if (unlikely(*ppos))
> >>>           return -ESPIPE;
> >>> +    if (unlikely(!tss.len))
> >>> +        return 0;
> >>>       ret =3D spliced =3D 0;
> >>>       lock_sock(sk);
> >>>       timeo =3D sock_rcvtimeo(sk, sock->file->f_flags & O_NONBLOCK);
> >>> -    while (tss.len) {
> >>> +    while (true) {
> >>>           ret =3D __tcp_splice_read(sk, &tss);
> >>>           if (ret < 0)
> >>>               break;
> >>> @@ -835,10 +837,10 @@ ssize_t tcp_splice_read(struct socket *sock, lo=
ff_t *ppos,
> >>>               }
> >>>               continue;
> >>>           }
> >>> -        tss.len -=3D ret;
> >>>           spliced +=3D ret;
> >>> +        tss.len -=3D ret;
> >>
> >> The patch LGTM. The only minor thing that I note is that the above
> >> chunk is not needed. Perhaps avoiding unneeded delta could be worthy.
> >
> > It keeps it closer to the tss.len test, so I'd leave it for that reason=
,
> > but on the other hand the compiler should be perfectly able to optimise=
 it
> > regardless (i.e. sub;cmp;jcc; vs sub;jcc;). I don't have a hard feeling
> > on that, can change if you want.
>
> Is there anything I can do to help here? I think the patch is
> fine, but can amend the change per Paolo's suggestion if required.
>

We prefer seeing patches focusing on the change, instead of also doing
arbitrary changes
making future backports more likely to conflict.

Thanks.

