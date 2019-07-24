Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5600D74170
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbfGXWcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:32:13 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33739 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728830AbfGXWcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:32:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id f20so12681405pgj.0
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 15:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=661OL/iR1qoYlwUkzlekgkKWwDhi9Py/1hATN7T3Ahc=;
        b=qmdbW9TGbpD4u+r2iyOlnYVTL9rTlUFPcF5T5BCUPblJVVLGwqa0ii9UlX6PZXMplF
         v7/LjVjosR4oJWqlCcoVdbSmX6oBThkQ8hDeS69QzbPU71D7qbczM+it2tgA9ZKcc9U9
         ioRvfcp2MwlD3oVgJPjHBHZpBH8dwnfHgxOuiAm7RRaYYCI+M+MhXcc+KHfU9I5jaOr9
         uJdmRixV5IqK83nYNDnHoxU0efIdPG9MphzBhEMqMILFU+AtTkdbFd27R9PId7li7smf
         OvFYDnNmr3pAyXhRvRBHo9lbwLRxQWN185/+Ljhq4QNrvePhYWFatx45NAEFqoaZLdOS
         ySSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=661OL/iR1qoYlwUkzlekgkKWwDhi9Py/1hATN7T3Ahc=;
        b=Yy25ZlITpfc9/Kkf0upwCtV3mIad4NFO91jLy305MVL3DrNX0YfwDKh3XsG1QqfNGt
         2zUhpFMW/uCOThbkzXka5/ckGZq287TkDvGA57/N5dcKdtOHm1bSzBRhWVIapZ3VTizL
         UQf7a9aXgttG11vO6aOiuhl7N7Mt4AOIx6fvkTmx6zBO+SUpK9XF5b9qqrpvGa6/nzBp
         alQBV6kk/YHo4+3XhwF3x7ANJ2+BZ4NT0cwxexSb2iQtgt9Z3iCW5v330ngXWdTJO12m
         +GSvVnarTMX6yr5iZ/ILb+BbafI2JunG8Z3m3+0ttLcZdzH15acXFCh5J4kzvR44V0oO
         Q8Zw==
X-Gm-Message-State: APjAAAWFuJc6r4Sw11denGJA6FjBrjmcwCEPH81l4VSQyXfix1pE+ZmN
        pGgiiwCnzPoAhwWs9RWOxcY=
X-Google-Smtp-Source: APXvYqwYGuSVzdaYps1FpPZOx447i2vB+efYxBYoZ554d2jsFTYzKkVFH52RIDtsgb3p918sVmq9Qg==
X-Received: by 2002:a63:61cd:: with SMTP id v196mr2365471pgb.210.1564007532269;
        Wed, 24 Jul 2019 15:32:12 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id q1sm56690279pfg.84.2019.07.24.15.32.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 15:32:11 -0700 (PDT)
Date:   Wed, 24 Jul 2019 15:32:10 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [PATCH bpf-next 1/7] bpf/flow_dissector: pass input flags to BPF
 flow dissector program
Message-ID: <20190724223210.GA3500@mini-arch>
References: <20190724170018.96659-1-sdf@google.com>
 <20190724170018.96659-2-sdf@google.com>
 <CAPhsuW6wq_6Pf80yV7oEb0uW7Xv9=UKAbTm4XJLyKAtSmDzCBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW6wq_6Pf80yV7oEb0uW7Xv9=UKAbTm4XJLyKAtSmDzCBQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/24, Song Liu wrote:
> On Wed, Jul 24, 2019 at 10:11 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > C flow dissector supports input flags that tell it to customize parsing
> > by either stopping early or trying to parse as deep as possible. Pass
> > those flags to the BPF flow dissector so it can make the same
> > decisions. In the next commits I'll add support for those flags to
> > our reference bpf_flow.c
> >
> > Cc: Willem de Bruijn <willemb@google.com>
> > Cc: Petar Penkov <ppenkov@google.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  include/linux/skbuff.h       | 2 +-
> >  include/net/flow_dissector.h | 4 ----
> >  include/uapi/linux/bpf.h     | 5 +++++
> >  net/bpf/test_run.c           | 2 +-
> >  net/core/flow_dissector.c    | 5 +++--
> >  5 files changed, 10 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 718742b1c505..9b7a8038beec 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -1271,7 +1271,7 @@ static inline int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
> >
> >  struct bpf_flow_dissector;
> >  bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
> > -                     __be16 proto, int nhoff, int hlen);
> > +                     __be16 proto, int nhoff, int hlen, unsigned int flags);
> >
> >  bool __skb_flow_dissect(const struct net *net,
> >                         const struct sk_buff *skb,
> > diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> > index 90bd210be060..3e2642587b76 100644
> > --- a/include/net/flow_dissector.h
> > +++ b/include/net/flow_dissector.h
> > @@ -253,10 +253,6 @@ enum flow_dissector_key_id {
> >         FLOW_DISSECTOR_KEY_MAX,
> >  };
> >
> > -#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG                BIT(0)
> > -#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL    BIT(1)
> > -#define FLOW_DISSECTOR_F_STOP_AT_ENCAP         BIT(2)
> > -
> >  struct flow_dissector_key {
> >         enum flow_dissector_key_id key_id;
> >         size_t offset; /* offset of struct flow_dissector_key_*
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index fa1c753dcdbc..b4ad19bd6aa8 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3507,6 +3507,10 @@ enum bpf_task_fd_type {
> >         BPF_FD_TYPE_URETPROBE,          /* filename + offset */
> >  };
> >
> > +#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG                (1U << 0)
> > +#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL    (1U << 1)
> > +#define FLOW_DISSECTOR_F_STOP_AT_ENCAP         (1U << 2)
> 
> Do we have to move these?
These have to be a part of UAPI one way or another. The easiest thing
we can do is to call the existing flags a UAPI and move them into
exported headers. Alternatively, we can introduce new set of UAPI flags
and do some kind of conversion between exported and internal ones.

Since it's pretty easy to add/deprecate them (see cover letter), I've
decided to just move them instead of adding another set and doing
conversion. I'm open to suggestions if you think otherwise.
