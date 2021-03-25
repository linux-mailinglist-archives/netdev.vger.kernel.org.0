Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D7134870D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 03:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbhCYCq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 22:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhCYCqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 22:46:18 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27DCC06174A;
        Wed, 24 Mar 2021 19:46:17 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id j11so858246ilu.13;
        Wed, 24 Mar 2021 19:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=by2Wfmj5o/U0bNeUiqbM06edFn5/IV35knV2eyk/CgI=;
        b=Z+0YIDdKk2k0B/jzcyuv5quKziiJRhi2GqAPhkOE7XbkoXuo8HAt0HNVjcNqNAo2Jy
         mTbBxDFfC9jjdoGXDD3baNhYK3uR0PbeZTgo4ATaD10uc9EhUBrSR3IS1mzw+dQ2Ws4+
         qimVwTwEdSZV5uaOKg7Kcy51PJcC4fyCHSKUhrnovRNz0t+/2NzE5HWFatHhzJBZE2nh
         ZxAy9o4G2FLCJMD3Jw03dZUl99phSvYctrkwrXZgOWCqQL0CrGO9dqC34aUwlroKs6th
         zDIf7/nvOvPCGjR6CmtDYdrjVFZ2TdHTp4LiQfsCqfwkP+pgU5sFnhzbRD1jEL0o8nKM
         mv4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=by2Wfmj5o/U0bNeUiqbM06edFn5/IV35knV2eyk/CgI=;
        b=aDmPSNI2X9ATAHXSt9Ga6pfZ28qM4+8MvoVSmge4ktZDKLy3T4Ff5NpcZ4+3H26z6k
         vB0fR1AhlGoQZY2sM1UPBjH13E1wcp/vN9ADXtsg3g5/MPHEo68gSN9C8KGoEPYr3nM/
         X+TtHHlOyfMhsXR/zIq/QoWWUH3HWukH1T2Qz97VmWn8khsLHLdClIgSToXyO2uznAPw
         zqqIfNFY84pwi1ZyurQroCSq8EBk60iWgzt0OAHbmVfo3QriUZpMgfRCohfkgjSuj7px
         8NUmdOhKa2Ac/VxSrE/T+gGGSdO+mY63hpjupa8RVFBAvkbiqXMfgoAfbUXMru0YpY2N
         otag==
X-Gm-Message-State: AOAM531WWMULt4D28AEftwtEqBUVPLkyKkhaaaO9Tzn03SS5Q81hgsj+
        1iCr9fT/DMwkR4g39pVWsfw=
X-Google-Smtp-Source: ABdhPJyWfqatJfjRXK+XmtnfurZgzbz0IDs6bumVmrIP0b6g1xK3Oja8h9+iLk3Q3EpmEV5BA+0ZJQ==
X-Received: by 2002:a05:6e02:12c6:: with SMTP id i6mr4846404ilm.235.1616640377482;
        Wed, 24 Mar 2021 19:46:17 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id i67sm1981718ioa.3.2021.03.24.19.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 19:46:17 -0700 (PDT)
Date:   Wed, 24 Mar 2021 19:46:09 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <605bf9718f2fc_64fde2082b@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpVShCqWx1CYUOO9SrgWw7ztVP6j=v=W9dAd9FbChGZauQ@mail.gmail.com>
References: <161661943080.28508.5809575518293376322.stgit@john-Precision-5820-Tower>
 <161661958954.28508.16923012330549206770.stgit@john-Precision-5820-Tower>
 <CAM_iQpVShCqWx1CYUOO9SrgWw7ztVP6j=v=W9dAd9FbChGZauQ@mail.gmail.com>
Subject: Re: [bpf PATCH 2/2] bpf, sockmap: fix incorrect fwd_alloc accounting
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Wed, Mar 24, 2021 at 2:00 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Incorrect accounting fwd_alloc can result in a warning when the socket
> > is torn down,
> >

[...]

> > To resolve lets only account for sockets on the ingress queue that are
> > still associated with the current socket. On the redirect case we will
> > check memory limits per 6fa9201a89898, but will omit fwd_alloc accounting
> > until skb is actually enqueued. When the skb is sent via skb_send_sock_locked
> > or received with sk_psock_skb_ingress memory will be claimed on psock_other.
                     ^^^^^^^^^^^^^^^^^^^^
> 
> You mean sk_psock_skb_ingress(), right?

Yes.

[...]

> > @@ -880,12 +876,13 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
> >                 kfree_skb(skb);
> >                 goto out;
> >         }
> > -       skb_set_owner_r(skb, sk);
> >         prog = READ_ONCE(psock->progs.skb_verdict);
> >         if (likely(prog)) {
> > +               skb->sk = psock->sk;
> 
> Why is skb_orphan() not needed here?

These come from strparser which do not have skb->sk set.

> 
> Nit: You can just use 'sk' here, so "skb->sk = sk".

Sure that is a bit nicer, will respin with this.

> 
> 
> >                 tcp_skb_bpf_redirect_clear(skb);
> >                 ret = sk_psock_bpf_run(psock, prog, skb);
> >                 ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
> > +               skb->sk = NULL;
> 
> Why do you want to set it to NULL here?

So we don't cause the stack to throw other errors later if we
were to call skb_orphan for example. Various places in the skb
helpers expect both skb->sk and skb->destructor to be set together
and here we are just using it as a mechanism to feed the sk into
the BPF program side. The above skb_set_owner_r for example
would likely BUG().

> 
> Thanks.


