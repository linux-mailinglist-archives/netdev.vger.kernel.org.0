Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A45031A4E8
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 20:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhBLTCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 14:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhBLTCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 14:02:22 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74915C061574;
        Fri, 12 Feb 2021 11:01:41 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id c11so74007pfp.10;
        Fri, 12 Feb 2021 11:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hebMW61/S+qlWaHRUK83YZMjmoy9TqdfPBQnAOaR8wE=;
        b=q/ef0RFUvVUdvvDZdBmpNz+c+akwwo1XU+dl6zDz7akKP84T4aTUibO46ijbIT9R0v
         uTf4w4H16qy8owfLloZII27kghm8SEPlae9p0mGdQ9BorxRewOWFCuYcQ0+Kncr9B8ZZ
         s/IL6tZApZHlk29arsnMqCJ9G769013kdTCigsoSkmEm/kl7aHdtv7YRBtQ/0lCBKDho
         bKm5hoIh7qGeOIKaov0L9vm3J+A5dd9JyHfPxeiyH1z/RYkrWUU2MDWjDO3jiVDRdUa6
         JjsmtKXUvVR5T1HqoDvLa51KCYCjznrY3u8tfuie2NsMWNnzM5nXSKYEg6r5+JnxRElr
         k/bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hebMW61/S+qlWaHRUK83YZMjmoy9TqdfPBQnAOaR8wE=;
        b=jYFNvdazNMYqGNcfEXpWpK1CZoRckFyEddR49IrG15nIKBmfiCKcCVDRb8ghXfU/j0
         q2EgklJHCuGnM2a5abBj4iL91l5j71Xi70TxyXMwTImgygndNnNTrlFKlNSYQSsiIeG7
         Temg81ZhufezOcodO5OFwsPWw+j+B2n7MlSFaEh3/Mi29bUz2EIymQ/AmJh+uT9WmQiN
         qkbnq3GTUJH24ZSsAXR2AKbsJdUyIzxL/hvBF6fcUkYCmOLAiUhcIOBJNiDT/ifxm12E
         PncxIQP329CAN3y2WkRRTVO/ObQnSM9wJ5wH9EcUDTZEPDMqa1Z4IPSq0y6BhJHnOOFz
         eKZw==
X-Gm-Message-State: AOAM532aPEMm5CbePYJDj4rwMvSKXKcpmSl5QHvbwnki6bhJ38npJFIu
        wOIqpC3/inKnVxqhqABvH4xRleiGhW1HMV/Z4kbJxFfEPl4=
X-Google-Smtp-Source: ABdhPJym4ZVpzkjHYWRj2SovbE1JGWsnmfhKo/PGBQaIP0DBEFDIwiKvpHJP2rV5hZ8iELca4U684pgzxR7D+JH2mEM=
X-Received: by 2002:a63:eb14:: with SMTP id t20mr4512714pgh.336.1613156500982;
 Fri, 12 Feb 2021 11:01:40 -0800 (PST)
MIME-Version: 1.0
References: <20210210022136.146528-1-xiyou.wangcong@gmail.com>
 <20210210022136.146528-4-xiyou.wangcong@gmail.com> <CACAyw98ABpLzjjw9zMdttgRWvim=oOqAZrDaXrLQ49eYhVsbJQ@mail.gmail.com>
In-Reply-To: <CACAyw98ABpLzjjw9zMdttgRWvim=oOqAZrDaXrLQ49eYhVsbJQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 12 Feb 2021 11:01:30 -0800
Message-ID: <CAM_iQpU+X3iuxwDUK=+=Ux1EetkGYL6q59Wdsr4L1ppKxtfpOw@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 3/5] bpf: compute data_end dynamically with
 JIT code
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 2:56 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Wed, 10 Feb 2021 at 02:22, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Currently, we compute ->data_end with a compile-time constant
> > offset of skb. But as Jakub pointed out, we can actually compute
> > it in eBPF JIT code at run-time, so that we can competely get
> > rid of ->data_end. This is similar to skb_shinfo(skb) computation
> > in bpf_convert_shinfo_access().
> >
> > Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>
> ...
>
> > @@ -9520,6 +9510,29 @@ static u32 sock_ops_convert_ctx_access(enum bpf_=
access_type type,
> >         return insn - insn_buf;
> >  }
> >
> > +static struct bpf_insn *bpf_convert_data_end_access(const struct bpf_i=
nsn *si,
> > +                                                   struct bpf_insn *in=
sn)
>
> Is it worth adding a reference to this function in skb_headlen(),
> since we're basically open coding that function here?

I do not mind adding a comment for this.

>
> > +{
> > +       /* si->dst_reg =3D skb->data */
> > +       *insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, data),
> > +                             si->dst_reg, si->src_reg,
> > +                             offsetof(struct sk_buff, data));
> > +       /* AX =3D skb->len */
> > +       *insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, len),
> > +                             BPF_REG_AX, si->src_reg,
> > +                             offsetof(struct sk_buff, len));
> > +       /* si->dst_reg =3D skb->data + skb->len */
> > +       *insn++ =3D BPF_ALU64_REG(BPF_ADD, si->dst_reg, BPF_REG_AX);
> > +       /* AX =3D skb->data_len */
> > +       *insn++ =3D BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, data_l=
en),
> > +                             BPF_REG_AX, si->src_reg,
> > +                             offsetof(struct sk_buff, data_len));
> > +       /* si->dst_reg =3D skb->data + skb->len - skb->data_len */
> > +       *insn++ =3D BPF_ALU64_REG(BPF_SUB, si->dst_reg, BPF_REG_AX);
> > +
> > +       return insn;
> > +}
> > +
> >  static u32 sk_skb_convert_ctx_access(enum bpf_access_type type,
> >                                      const struct bpf_insn *si,
> >                                      struct bpf_insn *insn_buf,
> > @@ -9530,12 +9543,7 @@ static u32 sk_skb_convert_ctx_access(enum bpf_ac=
cess_type type,
> >
> >         switch (si->off) {
> >         case offsetof(struct __sk_buff, data_end):
> > -               off  =3D si->off;
> > -               off -=3D offsetof(struct __sk_buff, data_end);
> > -               off +=3D offsetof(struct sk_buff, cb);
> > -               off +=3D offsetof(struct tcp_skb_cb, bpf.data_end);
> > -               *insn++ =3D BPF_LDX_MEM(BPF_SIZEOF(void *), si->dst_reg=
,
> > -                                     si->src_reg, off);
> > +               insn =3D bpf_convert_data_end_access(si, insn);
>
> This generates a new warning:
>
> ../net/core/filter.c: In function =E2=80=98sk_skb_convert_ctx_access=E2=
=80=99:
> ../net/core/filter.c:9542:6: warning: unused variable =E2=80=98off=E2=80=
=99 [-Wunused-variable]
>  9542 |  int off;
>       |      ^~~

Good catch!

Apparently neither my compiler nor kernel-test-bot's catches this.

Thanks.
