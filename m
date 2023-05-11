Return-Path: <netdev+bounces-1772-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D65676FF19A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:34:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 929612816A0
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE0FC1F92C;
	Thu, 11 May 2023 12:34:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC92865B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:34:08 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DB449EF
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 05:33:58 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f423c17bafso189355e9.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 05:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683808437; x=1686400437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a7gCQBChAJ0go57ntZ4mHaZPrVTO04vdjqbNzuzG34c=;
        b=SAU2GaqgYm+aMs5tUmO37wvuabkm7eWxZRN+nCU9OmT732yPu1LjrlX0eiA8c+KY3N
         +NwikmNaNL1TqL0fzmc+cdlWR7yVH/Ao2Jk+fZ1QHwu286kLWQBxY0NvAVPTiPxCfkl9
         vbyYamunGCfO5axMUI8W2jJAHQS5+xuVb2XnlgQ5s3PMhl6Y8mdzTeAeG7jCkOhqZZry
         VPnxEYO/vOtsq4JZPUAQem2bd6cH27z5jHQFQHBc+LHLS7bVrKAoUq5MdbBLhiCKZJVT
         65usgIa1gcunBSAJ8Aums7AODzHqGPo5zmZNh5VhSUX0F2m07Gv8ZPrJNWP1FZJz5rQh
         2R9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683808437; x=1686400437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a7gCQBChAJ0go57ntZ4mHaZPrVTO04vdjqbNzuzG34c=;
        b=SFDp7e9qoVABMOz+jA+DpRaz3i+v7zcU0S9sDCKTl/9FWiEzZ+Z5cxQF/fiAnGw1gK
         R4mapdJB0twKP/LosXm2Tx1TxT23svOocjlIbpcnMB/GLWOroGVeBUH3fA89kZgQ3Jpk
         0Fz0k1x7bfSyH6ec+d5x23KFdFNcn9TDh2lawN00+0u4dUYif+FPYcEa7ZV9ibuyqwUL
         d9wxEaVZysGPg2Zeh6S3SbTUOR5mO/rZzot5RqCiNKWBxq0HYdNjPNhzF7srOPJkfIju
         hAkWRORBBzf186xNOE3wsQWXt57a0u6yllwBsHR0UXAiDDCa86IMHAL+XYEJV5kRMG/m
         BVww==
X-Gm-Message-State: AC+VfDwYUL78FOiPVbnJVPcodM/sXjDF7b7oIAtt+2dB41De33zZuvby
	kn57epKW7fxI3PvgFZZKgI6whCAelV6aRyK98Di5dg==
X-Google-Smtp-Source: ACHHUZ6yf+AplqV5xubC1j7qz7en+0MurMPgIft3OWaOQ4DYUKeL8BMnDjzIXaE2xiZEtHVtrkzuDUFHt1fq3aV6iGE=
X-Received: by 2002:a05:600c:46d4:b0:3f4:fb7:48d4 with SMTP id
 q20-20020a05600c46d400b003f40fb748d4mr138891wmo.3.1683808436786; Thu, 11 May
 2023 05:33:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230511093456.672221-1-atenart@kernel.org> <20230511093456.672221-5-atenart@kernel.org>
 <fe2f6594-b330-bc5b-55a5-8e1686a2eac1@redhat.com>
In-Reply-To: <fe2f6594-b330-bc5b-55a5-8e1686a2eac1@redhat.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 11 May 2023 14:33:44 +0200
Message-ID: <CANn89i+R4fdkbQr1u2L-upJobSM3aQOpGi6Kbbix_HPkkovnpA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] net: skbuff: fix l4_hash comment
To: Dumitru Ceara <dceara@redhat.com>
Cc: Antoine Tenart <atenart@kernel.org>, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, netdev@vger.kernel.org, Ilya Maximets <i.maximets@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 2:10=E2=80=AFPM Dumitru Ceara <dceara@redhat.com> w=
rote:
>
> Hi Antoine,
>
> On 5/11/23 11:34, Antoine Tenart wrote:
> > Since commit 877d1f6291f8 ("net: Set sk_txhash from a random number")
> > sk->sk_txhash is not a canonical 4-tuple hash. sk->sk_txhash is
> > used in the TCP Tx path to populate skb->hash, with skb->l4_hash=3D1.
> > With this, skb->l4_hash does not always indicate the hash is a
> > "canonical 4-tuple hash over transport ports" but rather a hash from L4
> > layer to provide a uniform distribution over flows. Reword the comment
> > accordingly, to avoid misunderstandings.
>
> But AFAIU the hash used to be a canonical 4-tuple hash and was used as
> such by other components, e.g., OvS:
>
> https://elixir.bootlin.com/linux/latest/source/net/openvswitch/actions.c#=
L1069
>
> It seems to me at least unfortunate that semantics change without
> considering other users.  The fact that we now fix the documentation
> makes it seem like OvS was wrong to use the skb hash.  However, before
> 877d1f6291f8 ("net: Set sk_txhash from a random number") it was OK for
> OvS to use the skb hash as a canonical 4-tuple hash.
>

I do not think we can undo stuff that was done back in 2015

Has anyone complained ?

Note that skb->hash has never been considered as canonical, for obvious rea=
sons.


> Best regards,
> Dumitru
>
> >
> > Signed-off-by: Antoine Tenart <atenart@kernel.org>
> > ---
> >  include/linux/skbuff.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 738776ab8838..f54c84193b23 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -791,8 +791,8 @@ typedef unsigned char *sk_buff_data_t;
> >   *   @active_extensions: active extensions (skb_ext_id types)
> >   *   @ndisc_nodetype: router type (from link layer)
> >   *   @ooo_okay: allow the mapping of a socket to a queue to be changed
> > - *   @l4_hash: indicate hash is a canonical 4-tuple hash over transpor=
t
> > - *           ports.
> > + *   @l4_hash: indicate hash is from layer 4 and provides a uniform
> > + *           distribution over flows.
> >   *   @sw_hash: indicates hash was computed in software stack
> >   *   @wifi_acked_valid: wifi_acked was set
> >   *   @wifi_acked: whether frame was acked on wifi or not
>

