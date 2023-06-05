Return-Path: <netdev+bounces-8202-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC8D723190
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 22:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 294891C20D9A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5CDD24134;
	Mon,  5 Jun 2023 20:41:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB05323E;
	Mon,  5 Jun 2023 20:41:54 +0000 (UTC)
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EB2A7;
	Mon,  5 Jun 2023 13:41:53 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2b1a46ad09fso63390421fa.2;
        Mon, 05 Jun 2023 13:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685997711; x=1688589711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y5VogtmQNenQkSFLi47K5JdCwbg6KcCBFl+mvC1LNLk=;
        b=l6s/DRTxA8+iq6TNP/iUmC5mScAhJm0taS7V8Q5isxYJ9xT9wDGOI461THl54LVIeW
         InZ7e+hYg1XmlGdyj58ABHN4F6CfY/Fgh3DXolHUcDQ6ogPjYom5MfEoE0VPOAecCMWC
         3+ZU2LLsy6ewUx9BiX117/njxT/iRiiPze0rKniQV/RupI4Zw29Ukk65Um3oHjH5mq+h
         hX8gx+BmkW0dld9zA9V8KVO/FadI+4/i+9NZcfahULFBmdS31fMcd1DCTQ+6oVLe86tG
         FF3JBVtvPkI6X5b7JpVSHxeewOPsxjULNOUX5tFAB9HKyAvi/HRe5dJM6E39hWBzW2lt
         H7yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685997711; x=1688589711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y5VogtmQNenQkSFLi47K5JdCwbg6KcCBFl+mvC1LNLk=;
        b=haHHqxyKkgJdLegEJLMNxZpT9or2SiWYTNtP4TCxpNdm4PoCMu6BkzXEBcI5PxerWz
         eft5ZwlxE5qxBm/txqVbZI59Q8x48YYeZNnGd7aIFBWf/P0XOTUey33PkX2HmeGMjNI9
         Yl8Me2dqHEi3WGg180wtC1HAAK3CdUI5NfgCkxRl/Q0SbIqls8XUl68rYDeioLUe43tc
         TMS/qoeIj6G6GUOj9d1+x6nFU3a8c/nd9qEv8Ep+dnerbDpljQVjVFQzA98EvwYdG06a
         6z3jRrQXFmL2/+iU6Glfz4nsYS5mrwsCRxOjp1GVRmXxfqV1+TcU3bn0kn27vVe+pMEU
         GkjQ==
X-Gm-Message-State: AC+VfDwy5h1C7RBvOG/zPPKKJAgHVDKONtUJHbuuq3+K3OwEYuw8S9y+
	cRkHbX7vjNF3MocCJ2Cc0HHD/gEeom05iMQCJYw=
X-Google-Smtp-Source: ACHHUZ4fGFKtKKFBVrNS2KEPR/HsgMdw13aySa0flTHLXJVWzcJdd5vEvC9vSVbhWGPtIHNmo0uSh0JcQTA/u5WPQmg=
X-Received: by 2002:a2e:9653:0:b0:2a8:b579:225b with SMTP id
 z19-20020a2e9653000000b002a8b579225bmr180343ljh.40.1685997711146; Mon, 05 Jun
 2023 13:41:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <168563651438.3436004.17735707525651776648.stgit@firesoul> <ZHkA0JhRYD7WXSp+@lore-desk>
In-Reply-To: <ZHkA0JhRYD7WXSp+@lore-desk>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 5 Jun 2023 13:41:39 -0700
Message-ID: <CAADnVQK=mSCXGx8u_tWP3NEBGv-AofT_sjqX0=wQoB1c=dP9BQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next V2] bpf/xdp: optimize bpf_xdp_pointer to avoid
 reading sinfo
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>, Tariq Toukan <ttoukan.linux@gmail.com>, 
	Daniel Borkmann <borkmann@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
	Andrii Nakryiko <andrii.nakryiko@gmail.com>, bpf <bpf@vger.kernel.org>, 
	Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>, 
	Network Development <netdev@vger.kernel.org>, Eelco Chaudron <echaudro@redhat.com>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 1, 2023 at 1:34=E2=80=AFPM Lorenzo Bianconi <lorenzo@kernel.org=
> wrote:
>
> > Currently we observed a significant performance degradation in
> > samples/bpf xdp1 and xdp2, due XDP multibuffer "xdp.frags" handling,
> > added in commit 772251742262 ("samples/bpf: fixup some tools to be able
> > to support xdp multibuffer").
> >
> > This patch reduce the overhead by avoiding to read/load shared_info
> > (sinfo) memory area, when XDP packet don't have any frags. This improve=
s
> > performance because sinfo is located in another cacheline.
> >
> > Function bpf_xdp_pointer() is used by BPF helpers bpf_xdp_load_bytes()
> > and bpf_xdp_store_bytes(). As a help to reviewers, xdp_get_buff_len() c=
an
> > potentially access sinfo, but it uses xdp_buff_has_frags() flags bit ch=
eck
> > to avoid accessing sinfo in no-frags case.
> >
> > The likely/unlikely instrumentation lays out asm code such that sinfo
> > access isn't interleaved with no-frags case (checked on GCC 12.2.1-4).
> > The generated asm code is more compact towards the no-frags case.
> >
> > The BPF kfunc bpf_dynptr_slice() also use bpf_xdp_pointer(). Thus, it
> > should also take effect for that.
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  net/core/filter.c |    7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 968139f4a1ac..961db5bd2f94 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -3948,20 +3948,21 @@ void bpf_xdp_copy_buf(struct xdp_buff *xdp, uns=
igned long off,
> >
> >  void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset, u32 len)
> >  {
> > -     struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(x=
dp);
> >       u32 size =3D xdp->data_end - xdp->data;
> > +     struct skb_shared_info *sinfo;
> >       void *addr =3D xdp->data;
> >       int i;
> >
> >       if (unlikely(offset > 0xffff || len > 0xffff))
> >               return ERR_PTR(-EFAULT);
> >
> > -     if (offset + len > xdp_get_buff_len(xdp))
> > +     if (unlikely(offset + len > xdp_get_buff_len(xdp)))
> >               return ERR_PTR(-EINVAL);
> >
> > -     if (offset < size) /* linear area */
> > +     if (likely((offset < size))) /* linear area */
>
> nit: you can drop a round bracket here. Other than that:

Fixed while applying. Thanks everyone.

> Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
>
> >               goto out;
> >
> > +     sinfo =3D xdp_get_shared_info_from_buff(xdp);
> >       offset -=3D size;
> >       for (i =3D 0; i < sinfo->nr_frags; i++) { /* paged area */
> >               u32 frag_size =3D skb_frag_size(&sinfo->frags[i]);
> >
> >

