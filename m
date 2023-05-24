Return-Path: <netdev+bounces-4925-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07A5470F32C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3CC71C20B69
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97403C8D5;
	Wed, 24 May 2023 09:40:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CD1C8D3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:40:17 +0000 (UTC)
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A377BF
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 02:40:15 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id 006d021491bc7-54f8b7a4feeso255732eaf.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 02:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684921214; x=1687513214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ewrtfd84Th92UyeCbo96CAATpNqDA8JdwgNkAAsxfOg=;
        b=cKoZEcXov/cWA2aDLHhqwsaEjOIO03hwYrkpQzO8Wx01r09ecCXkrj+teK+aNFVauI
         IshI1N1gxk55r8URsPEVzob1Q5tI4SIpmQXVdLRHkVdD39x0PIbcyVOyKByOvPCa+eKO
         11xIf2MX4SFw4VSTrTpAze71411dW7Nz1VPpmD/DO9K4dex0v5tIL4BDDlwKA37a/sGq
         1MM55BeYKWgw4/Ef1VE7vzFqOLxDMzo6EXQ7e6QB5X77ALTairdlgotCzUeB3Z0Gyg1R
         PMbmJ/jhSfOkdONqH4k6SqbFUvhkEexDIT02dWeSkX1xnzJNHKMZZaYx5aaYy/IjqmpV
         FC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684921214; x=1687513214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ewrtfd84Th92UyeCbo96CAATpNqDA8JdwgNkAAsxfOg=;
        b=ZdEqx1efcdjMPQHBgZOcV9CtTp0gKkPdUiJq5jouD5dRLqu1lRBjUJi8/gviLTfY/I
         5giXfS3o/pTZoZUQdewTgdW5xoQZhAtCZyDIqGYAs6KWH+FNrjLEw9lqt5kneJoABDkM
         SvOQQ7FnaErHT9rQFGFg2CDrBAJyiTs4CNqxoFoBjQotJyQpqhA7wjvmZ6L1FIEJebgL
         rK6VGXhVj7zw7FL3KCqPPcsRVtpdyqZN5Yt1Q/BLW9JTmVk7B7nGTPxV9UjjgsmGoBwh
         oEEqK7tQibNibVJteo23qRANLO8aCIurPk82OgpGmN6awDiE4pZ7hMLCDJTrBGLLt+xu
         PXDw==
X-Gm-Message-State: AC+VfDy0rc7Y9X8EwSIPadfYWPsJdmskFG/W4gMYW4uPjRN2DnKKHMy0
	Ii39mKSrXIpSOBJz1HvRSqS3gmhR3zywBEpywvQ=
X-Google-Smtp-Source: ACHHUZ7AgZhwDSXsFUOpP7IKnSkHJ9hoRPMikP1nO2fMHz6Vbi5XwcZN+YYL0VW+mi/uQkNgIUtXtQO9knRqSUWOndQ=
X-Received: by 2002:aca:2209:0:b0:38e:36d1:2f99 with SMTP id
 b9-20020aca2209000000b0038e36d12f99mr8287889oic.12.1684921214284; Wed, 24 May
 2023 02:40:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230524083350.54197-1-cambda@linux.alibaba.com> <FB0C4E1D-1558-4EFC-BCC4-E6E8C6F01B7A@linux.alibaba.com>
In-Reply-To: <FB0C4E1D-1558-4EFC-BCC4-E6E8C6F01B7A@linux.alibaba.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Wed, 24 May 2023 17:39:38 +0800
Message-ID: <CAL+tcoBMWkeDU+H7fG-qvusmixwMVCueWR0=ZgwKqnn9kPGz6g@mail.gmail.com>
Subject: Re: [PATCH net v1] tcp: Return user_mss for TCP_MAXSEG in
 CLOSE/LISTEN state if user_mss set
To: Cambda Zhu <cambda@linux.alibaba.com>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Dust Li <dust.li@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>, 
	Jack Yang <mingliang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 5:11=E2=80=AFPM Cambda Zhu <cambda@linux.alibaba.co=
m> wrote:
>
>
> > On May 24, 2023, at 16:33, Cambda Zhu <cambda@linux.alibaba.com> wrote:
> >
> > This patch replaces the tp->mss_cache check in getting TCP_MAXSEG
> > with tp->rx_opt.user_mss check for CLOSE/LISTEN sock. Since
> > tp->mss_cache is initialized with TCP_MSS_DEFAULT, checking if
> > it's zero is probably a bug.
> >
> > With this change, getting TCP_MAXSEG before connecting will return
> > default MSS normally, and return user_mss if user_mss is set.
> >
> > Fixes: 0c409e85f0ac ("Import 2.3.41pre2")
> > Reported-by: Jack Yang <mingliang@linux.alibaba.com>
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Link: https://lore.kernel.org/netdev/CANn89i+3kL9pYtkxkwxwNMzvC_w3LNUum=
_2=3D3u+UyLBmGmifHA@mail.gmail.com/#t
> > Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> > Link: https://lore.kernel.org/netdev/14D45862-36EA-4076-974C-EA67513C92=
F6@linux.alibaba.com/
> > ---
> > v1:
> > - Return default MSS if user_mss not set for backwards compatibility.
> > - Send patch to net instead of net-next, with Fixes tag.
> > - Add Eric's tags.
> > ---
> > net/ipv4/tcp.c | 3 ++-
> > 1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index 4d6392c16b7a..3e01a58724b8 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -4081,7 +4081,8 @@ int do_tcp_getsockopt(struct sock *sk, int level,
> > switch (optname) {
> > case TCP_MAXSEG:
> > val =3D tp->mss_cache;
> > - if (!val && ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> > + if (tp->rx_opt.user_mss &&
> > +    ((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
> > val =3D tp->rx_opt.user_mss;
> > if (tp->repair)
> > val =3D tp->rx_opt.mss_clamp;
> > --
> > 2.16.6
>
> I see netdev/verify_fixes check failed for the commit 0c409e85f0ac ("Impo=
rt 2.3.41pre2").
> The commit is from:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>
> Should I remove the Fixes tag?

Please using the correct Fixes tag as below because we cannot trace it
(0c409e85f0ac) in the current tree:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Probably you have to send the v3 version. Let's wait to hear more
opinions about this patch.

Otherwise it looks good to me. Please feel free to add:
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>

Thanks,
Jason

>
> Thanks!
>
> Cambda

