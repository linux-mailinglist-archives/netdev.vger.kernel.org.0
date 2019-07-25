Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B178B75894
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfGYUDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:03:08 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35949 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfGYUDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 16:03:08 -0400
Received: by mail-pg1-f196.google.com with SMTP id l21so23556804pgm.3
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 13:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ELFFJ5+DQu+7PdqP+9PAJKn4mLKKH11jszvBCpwl7yo=;
        b=lXTFrBifFbTgf1V8v7UIncz0q97uwDlfS/8kSCHkNKkZMbeOkefOlPHEDpb8Towlnt
         eSYOogpOhUKzUS/pjBGJDzw2O+dIDXCv/O66vjf2lXKX6aSaRnqoMX/lj10Lbgjj5xEQ
         4hwD5FXNBoMC53tXdH21X9W2t9YIU2NslQfnNtQ/FF2l/skqjSDeMFj1iMI3fBWUZ5Wo
         Ygps0umplBHJGHUXtX+Cii8gjUCjnQoXlwpKE+Q+hicRyhbcpzKff6Ins84pQVSi3DJO
         nhmp4uQZkngJKu1rPrkkr8G5jaU+7MsjTdRcuZaY4HyK7nbGoHG697ZJLlkONYIBAy3H
         Adpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ELFFJ5+DQu+7PdqP+9PAJKn4mLKKH11jszvBCpwl7yo=;
        b=hiQ7RcZjBha/TSEaHt/hssFru8+9KyV7FOnSxd4HFOn0qR+H1FE6poKs+BtOPjfG6q
         1Q9P7wiv31rXnyz8AiYu/m9izxBWQP/QnxFSv/+d4zftDqM3H5mSLCX0HXWfUAK8gDys
         qthNowgq3axAV13NtXiH9raDB77nGIqTiG4gX5Vrr0tU4WvhVFBscO5sAGeULdBT5FHo
         i42Djjo04ZUx2SbxGNhlObsaiR9io+XEcoIfyGevgEjKLN029sizarRMgSm1hTf1b7UF
         hD/RO/xNN5oB1j3quCRkbPy9Sm2Od5nWMWiKLj8aFkJd6N0p1z+5WCmboJzexqMFl0ra
         iVbQ==
X-Gm-Message-State: APjAAAWzlQmxfQi2HCK+v/m0YpzELve+AMsWIhPX5RcPbnigRjlrVhSk
        RAqz2TuwEh38nTY2WIwHONI=
X-Google-Smtp-Source: APXvYqyFXu08COcZf2CxFFdBmTkjybldYV+jwndT7YT21ok4Uh2aLkNLqMhjXyqjI/LaFNeK79y+fA==
X-Received: by 2002:a17:90a:c70c:: with SMTP id o12mr68966969pjt.62.1564084987741;
        Thu, 25 Jul 2019 13:03:07 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id z68sm46416555pgz.88.2019.07.25.13.03.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 13:03:07 -0700 (PDT)
Date:   Thu, 25 Jul 2019 13:03:06 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, Willem de Bruijn <willemb@google.com>,
        Song Liu <songliubraving@fb.com>,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf/flow_dissector: pass input flags to
 BPF flow dissector program
Message-ID: <20190725200306.GC3500@mini-arch>
References: <20190725153342.3571-1-sdf@google.com>
 <20190725153342.3571-2-sdf@google.com>
 <20190725195856.ttdt75dxwhawjqvi@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725195856.ttdt75dxwhawjqvi@ast-mbp>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/25, Alexei Starovoitov wrote:
> On Thu, Jul 25, 2019 at 08:33:36AM -0700, Stanislav Fomichev wrote:
> > C flow dissector supports input flags that tell it to customize parsing
> > by either stopping early or trying to parse as deep as possible. Pass
> > those flags to the BPF flow dissector so it can make the same
> > decisions. In the next commits I'll add support for those flags to
> > our reference bpf_flow.c
> > 
> > Acked-by: Willem de Bruijn <willemb@google.com>
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Cc: Song Liu <songliubraving@fb.com>
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
> > -		      __be16 proto, int nhoff, int hlen);
> > +		      __be16 proto, int nhoff, int hlen, unsigned int flags);
> >  
> >  bool __skb_flow_dissect(const struct net *net,
> >  			const struct sk_buff *skb,
> > diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> > index 90bd210be060..3e2642587b76 100644
> > --- a/include/net/flow_dissector.h
> > +++ b/include/net/flow_dissector.h
> > @@ -253,10 +253,6 @@ enum flow_dissector_key_id {
> >  	FLOW_DISSECTOR_KEY_MAX,
> >  };
> >  
> > -#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG		BIT(0)
> > -#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL	BIT(1)
> > -#define FLOW_DISSECTOR_F_STOP_AT_ENCAP		BIT(2)
> > -
> >  struct flow_dissector_key {
> >  	enum flow_dissector_key_id key_id;
> >  	size_t offset; /* offset of struct flow_dissector_key_*
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index fa1c753dcdbc..b4ad19bd6aa8 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -3507,6 +3507,10 @@ enum bpf_task_fd_type {
> >  	BPF_FD_TYPE_URETPROBE,		/* filename + offset */
> >  };
> >  
> > +#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG		(1U << 0)
> > +#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL	(1U << 1)
> > +#define FLOW_DISSECTOR_F_STOP_AT_ENCAP		(1U << 2)
> > +
> 
> I'm a bit concerned with direct move.
> Last time we were in similar situation we've created:
> enum {
>         BPF_TCP_ESTABLISHED = 1,
>         BPF_TCP_SYN_SENT,
> 
> and added:
>         BUILD_BUG_ON((int)BPF_TCP_ESTABLISHED != (int)TCP_ESTABLISHED);
>         BUILD_BUG_ON((int)BPF_TCP_SYN_SENT != (int)TCP_SYN_SENT);
> 
> It may be overkill here, but feels safer than direct move.
> Adding BPF_ prefix also feels necessary to avoid very unlikely
> (but still theoretically possible) conflicts.
Sounds good, thanks for the pointers, will do the same here!
