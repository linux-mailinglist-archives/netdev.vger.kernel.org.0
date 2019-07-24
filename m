Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F26D7419D
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729514AbfGXWpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:45:35 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41485 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729510AbfGXWpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:45:34 -0400
Received: by mail-qk1-f196.google.com with SMTP id v22so35021754qkj.8;
        Wed, 24 Jul 2019 15:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E8a/bwAXMBqGjLKpjBQe2OuOJL89Jj5ebMkzaXg/5JU=;
        b=j+BpcDUCHbRccXUgoziwpu3Jnf+dHvHDh1yHvL6+dzdkO3mOVXmQmrY5X1sUOO/u2f
         2a7yVRGOiKeB90NL77iaoqVYaMtZ2ACD1jFkx2yBuna4NJvbuQ/x7FmG8NyiS0jC0Igq
         o0u9IrM26wt5V7IBJMz00Ko/kgGWj/IJAsLmF4P4pHpCuM6F9fEsCVJCjjUhK1m8KOgf
         Otx/gemqAM4Ljljqqj0OK+Rpldulqg05eFYtHSih/eoca81R7yiDa4uUtQOOvvubJISS
         FxR8JNn2iNquysz/eeVZHp3s/Ak+6qUG3RNEC04nrPDYAqS4UmQf5dV3Tu2fBNFNsFGA
         9msA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E8a/bwAXMBqGjLKpjBQe2OuOJL89Jj5ebMkzaXg/5JU=;
        b=Lc3sUTopga4UE1ZDOfv7TZfltdVHCBkbqbz3+9AZlTWNCyNoH+DXMaN1DiOh646K/v
         I7d3TAssIPy/ErVkUvWW7VFpptgchDW90vyynPXMdUCdJS5zIuxEFuZAtDCyJhdkAfmY
         X9x6DR7xuiU4SiVl+KGGfw2avDu3k6ijy3p31EeZspPuIbotIYF6ggUJRnTmkUVqDZ3u
         GzHYQSbCE7xRee/LTfGYGWcHMTljxBxxHYr56PRi5vWxCX0B/iarlRLF96pH8uK87ji1
         Ltt2oJFdD44NTNqTLNFK2K2DS/uerJVMASXBDoQfBJKxPGFny+tTvi+wp6iXeSitUnZd
         aHyQ==
X-Gm-Message-State: APjAAAXpsSy2eck6klO9jAMQRudKFs5uLyk9L1tV3pVhrzyjVrDECgnX
        vytJ9AMjMddHolWiAaqZogzIK+NmeczM4v1UFSCxB/KA
X-Google-Smtp-Source: APXvYqx5XEKbDWoFd2VzQRR2pltHZRjshtpR+j9v9A7qedygj0ZeZq6q74JIol3+6qRwTlEGt2b6OlocDNNHvmMWG8I=
X-Received: by 2002:ae9:e40f:: with SMTP id q15mr51783521qkc.241.1564008333776;
 Wed, 24 Jul 2019 15:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190724170018.96659-1-sdf@google.com> <20190724170018.96659-2-sdf@google.com>
 <CAPhsuW6wq_6Pf80yV7oEb0uW7Xv9=UKAbTm4XJLyKAtSmDzCBQ@mail.gmail.com> <20190724223210.GA3500@mini-arch>
In-Reply-To: <20190724223210.GA3500@mini-arch>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 15:45:22 -0700
Message-ID: <CAPhsuW4f+tCi_=Hx+txSdpe2HLZZ2+zvgR+WyZ9V5=4PCZ67nQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/7] bpf/flow_dissector: pass input flags to BPF
 flow dissector program
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 3:32 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 07/24, Song Liu wrote:
> > On Wed, Jul 24, 2019 at 10:11 AM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > C flow dissector supports input flags that tell it to customize parsing
> > > by either stopping early or trying to parse as deep as possible. Pass
> > > those flags to the BPF flow dissector so it can make the same
> > > decisions. In the next commits I'll add support for those flags to
> > > our reference bpf_flow.c
> > >
> > > Cc: Willem de Bruijn <willemb@google.com>
> > > Cc: Petar Penkov <ppenkov@google.com>
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  include/linux/skbuff.h       | 2 +-
> > >  include/net/flow_dissector.h | 4 ----
> > >  include/uapi/linux/bpf.h     | 5 +++++
> > >  net/bpf/test_run.c           | 2 +-
> > >  net/core/flow_dissector.c    | 5 +++--
> > >  5 files changed, 10 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > > index 718742b1c505..9b7a8038beec 100644
> > > --- a/include/linux/skbuff.h
> > > +++ b/include/linux/skbuff.h
> > > @@ -1271,7 +1271,7 @@ static inline int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
> > >
> > >  struct bpf_flow_dissector;
> > >  bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
> > > -                     __be16 proto, int nhoff, int hlen);
> > > +                     __be16 proto, int nhoff, int hlen, unsigned int flags);
> > >
> > >  bool __skb_flow_dissect(const struct net *net,
> > >                         const struct sk_buff *skb,
> > > diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> > > index 90bd210be060..3e2642587b76 100644
> > > --- a/include/net/flow_dissector.h
> > > +++ b/include/net/flow_dissector.h
> > > @@ -253,10 +253,6 @@ enum flow_dissector_key_id {
> > >         FLOW_DISSECTOR_KEY_MAX,
> > >  };
> > >
> > > -#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG                BIT(0)
> > > -#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL    BIT(1)
> > > -#define FLOW_DISSECTOR_F_STOP_AT_ENCAP         BIT(2)
> > > -
> > >  struct flow_dissector_key {
> > >         enum flow_dissector_key_id key_id;
> > >         size_t offset; /* offset of struct flow_dissector_key_*
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index fa1c753dcdbc..b4ad19bd6aa8 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -3507,6 +3507,10 @@ enum bpf_task_fd_type {
> > >         BPF_FD_TYPE_URETPROBE,          /* filename + offset */
> > >  };
> > >
> > > +#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG                (1U << 0)
> > > +#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL    (1U << 1)
> > > +#define FLOW_DISSECTOR_F_STOP_AT_ENCAP         (1U << 2)
> >
> > Do we have to move these?
> These have to be a part of UAPI one way or another. The easiest thing
> we can do is to call the existing flags a UAPI and move them into
> exported headers. Alternatively, we can introduce new set of UAPI flags
> and do some kind of conversion between exported and internal ones.
>
> Since it's pretty easy to add/deprecate them (see cover letter), I've
> decided to just move them instead of adding another set and doing
> conversion. I'm open to suggestions if you think otherwise.

I see. This looks good to me. Thanks for the explanation.

Acked-by: Song Liu <songliubraving@fb.com>
