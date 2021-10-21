Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA098436B53
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 21:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhJUT1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 15:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJUT1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 15:27:15 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C99C061764;
        Thu, 21 Oct 2021 12:24:59 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id h196so2426079iof.2;
        Thu, 21 Oct 2021 12:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=h4ajIR9Y0UVDthxBy4URJWNO4BoPBm7SGv1Qn4bQseA=;
        b=a0WyxGGXRTVeledn/ZYsw/lP88BQ1R+TeSFbYGlmWKDbd9ylBm1r1c2x7uwJlNUUfM
         oZ7+O/rqehkE+J7/pCI422oLx8SgjIb7jNwlYrG+83nU551vttQBuvz4WoMBH1vgyNQs
         F+KfQVv4avOB7h1CUQjAC6MujMRuSDGgKnJpiN3ANnhhpcm+OFOOUi5/N9G4MctuOnmP
         oTgew4nt1Ye2s64C4ILnE6fthVkjDUIZasSssCiWYz2FujDqUJMyrUNcboEufYYvfk8O
         /kgPWYIZFu8TLLt7gcRmPj6K6XFN191laSeG9XDGVHk4gIpj/R8VXFEqapiSWGRCVPKR
         eDSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=h4ajIR9Y0UVDthxBy4URJWNO4BoPBm7SGv1Qn4bQseA=;
        b=Cfs2P5meNw4Mf8fJYR7KP3hTGV5EEtFCTDfKDA7TqPp6gmsFRgMY8Z2JB8kB0KVBNF
         9Esjnb+zLAObuaZgJx/eHR3MA6v7+YpGeddtkqzUkdWFLoN5CU3Lsnk8Rrzvus6C4H46
         nN+1916XuRepvmfA0fntEmfs6m2BN+YDb1JdJhOMqTCbrWIXENxjByhsXac2rtXagoAr
         02J/feo7hRs/yUw/HReJA5ufErVFvtIqqWGT6k3g1YUsvwFwwTdeaTYbBOeg18nDOlCs
         11rmFdWTzsYqWVSWxDlibREGuKBd+3hzDvMIrq7ELQ4Lf0fc0jU/bLyG5mio5O+aa+qt
         ZORQ==
X-Gm-Message-State: AOAM531abQnmTXre6nU5mPz59/zvmnecMVKVCGFah7cEHAfbIgInmVDe
        iambvD21qykK6SAHiQPblqo=
X-Google-Smtp-Source: ABdhPJxwKg3j6dFooUgFU26OUduKSUp6WNyh/BlvMSOfavBfySA5ZGK1kVRKBx74WLS/R7Hwy4hsCQ==
X-Received: by 2002:a5d:9bd4:: with SMTP id d20mr5333540ion.105.1634844298576;
        Thu, 21 Oct 2021 12:24:58 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id k11sm3148156iov.20.2021.10.21.12.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 12:24:58 -0700 (PDT)
Date:   Thu, 21 Oct 2021 12:24:50 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        joamaki@gmail.com, xiyou.wangcong@gmail.com,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <6171be822d690_663a720898@john-XPS-13-9370.notmuch>
In-Reply-To: <87o87jfyd2.fsf@cloudflare.com>
References: <20211011191647.418704-1-john.fastabend@gmail.com>
 <20211011191647.418704-2-john.fastabend@gmail.com>
 <87tuhdfpq4.fsf@cloudflare.com>
 <616fa9127fa63_340c7208ef@john-XPS-13-9370.notmuch>
 <87pmrzg28a.fsf@cloudflare.com>
 <61703b183b7ac_48ee720873@john-XPS-13-9370.notmuch>
 <87o87jfyd2.fsf@cloudflare.com>
Subject: Re: [PATCH bpf 1/4] bpf, sockmap: Remove unhash handler for BPF
 sockmap usage
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Wed, Oct 20, 2021 at 05:51 PM CEST, John Fastabend wrote:
> > Jakub Sitnicki wrote:
> >> On Wed, Oct 20, 2021 at 07:28 AM CEST, John Fastabend wrote:
> >> > Jakub Sitnicki wrote:
> >> >> On Mon, Oct 11, 2021 at 09:16 PM CEST, John Fastabend wrote:
> >> >> > We do not need to handle unhash from BPF side we can simply wait for the
> >> >> > close to happen. The original concern was a socket could transition from
> >> >> > ESTABLISHED state to a new state while the BPF hook was still attached.
> >> >> > But, we convinced ourself this is no longer possible and we also
> >> >> > improved BPF sockmap to handle listen sockets so this is no longer a
> >> >> > problem.
> >> >> >
> >> >> > More importantly though there are cases where unhash is called when data is
> >> >> > in the receive queue. The BPF unhash logic will flush this data which is
> >> >> > wrong. To be correct it should keep the data in the receive queue and allow
> >> >> > a receiving application to continue reading the data. This may happen when
> >> >> > tcp_abort is received for example. Instead of complicating the logic in
> >> >> > unhash simply moving all this to tcp_close hook solves this.
> >> >> >
> >> >> > Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
> >> >> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> >> >> > ---
> >> >>
> >> >> Doesn't this open the possibility of having a TCP_CLOSE socket in
> >> >> sockmap if I disconnect it, that is call connect(AF_UNSPEC), instead of
> >> >> close it?
> >> >

[...]

 >> If we're considering allowing TCP sockets in TCP_CLOSE state in sockmap,
> >> a few things come to mind:
> >
> > I think what makes most sense is to do the minimal work to fix the
> > described issue for bpf tree without introducing new issues and
> > then do the consistency/better cases in bpf-next.
> >
> >>
> >> 1) We can't insert TCP_CLOSE sockets today. sock_map_sk_state_allowed()
> >>    won't allow it. However, with this change we will be able to have a
> >>    TCP_CLOSE socket in sockmap by disconnecting it. If so, perhaps
> >>    inserting TCP sockets in TCP_CLOSE state should be allowed for
> >>    consistency.
> >
> > I agree, but would hold off on this for bpf-next. I missed points
> > 2,3 though in this series.
> 
> OK, that makes sense.
> 
> >>
> >> 2) Checks in bpf_sk_lookup_assign() helper need adjusting. Only TCP
> >>    sockets in TCP_LISTEN state make a valid choice (and UDP sockets in
> >>    TCP_CLOSE state). Today we rely on the fact there that you can't
> >>    insert a TCP_CLOSE socket.
> >
> > This should be minimal change, just change the logic to allow only
> > TCP_LISTEN.
> >
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -10402,7 +10402,7 @@ BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
> >                 return -EINVAL;
> >         if (unlikely(sk && sk_is_refcounted(sk)))
> >                 return -ESOCKTNOSUPPORT; /* reject non-RCU freed sockets */
> > -       if (unlikely(sk && sk->sk_state == TCP_ESTABLISHED))
> > +       if (unlikely(sk && sk->sk_state != TCP_LISTEN))
> >                 return -ESOCKTNOSUPPORT; /* reject connected sockets */
> >
> >         /* Check if socket is suitable for packet L3/L4 protocol */
> >
> >
> 
> Yeah, it shouldn't be hard. But we need to cover UDP as well. Something
> along the lines of:
> 
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -10402,8 +10402,10 @@ BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
>                 return -EINVAL;
>         if (unlikely(sk && sk_is_refcounted(sk)))
>                 return -ESOCKTNOSUPPORT; /* reject non-RCU freed sockets */
> -       if (unlikely(sk && sk->sk_state == TCP_ESTABLISHED))
> -               return -ESOCKTNOSUPPORT; /* reject connected sockets */
> +       if (unlikely(sk && sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN))
> +               return -ESOCKTNOSUPPORT; /* reject closed TCP sockets */
> +       if (unlikely(sk && sk_is_udp(sk) && sk->sk_state != TCP_CLOSE))
> +               return -ESOCKTNOSUPPORT; /* reject connected UDP sockets */
> 
>         /* Check if socket is suitable for packet L3/L4 protocol */
>         if (sk && sk->sk_protocol != ctx->protocol)
> 
> We aren't testing today that that error case in sk_lookup test suite,
> because it wasn't possible to insert a TCP_CLOSE socket. So once that
> gets in, I can add coverage.
> 
> >>
> >> 3) Checks in sk_select_reuseport() helper need adjusting as well. It's a
> >>    similar same case as with bpf_sk_lookup_assign() (with a slight
> >>    difference that reuseport allows dispatching to connected UDP
> >>    sockets).
> >
> > Is it needed here? There is no obvious check now.  Is ESTABLISHED
> > state OK here now?
> 
> TCP ESTABLISHED sockets are not okay. They can't join the reuseport
> group and will always hit the !reuse branch.
> 
> Re-reading the code, though, I think nothing needs to be done for the
> sk_select_reuseport() helper. TCP sockets will be detached from
> reuseport group on unhash. Hence TCP_CLOSE socket will also hit the
> !reuse branch.
> 
> CC'ing Martin just in case he wants to double-check.
> 
> >
> >>
> >> 4) Don't know exactly how checks in sockmap redirect helpers would need
> >>    to be tweaked. I recall that it can't be just TCP_ESTABLISHED state
> >>    that's allowed due to a short window of opportunity that opens up
> >>    when we transition from TCP_SYN_SENT to TCP_ESTABLISHED.
> >>    BPF_SOCK_OPS_STATE_CB callback happens just before the state is
> >>    switched to TCP_ESTABLISHED.
> >>
> >>    TCP_CLOSE socket sure doesn't make sense as a redirect target. Would
> >>    be nice to get an error from the redirect helper. If I understand
> >>    correctly, if the TCP stack drops the packet after BPF verdict has
> >>    selected a socket, only the socket owner will know about by reading
> >>    the error queue.
> >>
> >>    OTOH, redirecting to a TCP_CLOSE_WAIT socket doesn't make sense
> >>    either, but we don't seem to filter it out today, so the helper is
> >>    not airtight.
> >
> > Right. At the moment for sending we call do_tcp_sendpages() and this
> > has the normal check ~(TCPF_ESABLISHED | TCPF_CLOSE_WAIT) so we
> > would return an error. The missing case is ingress. We currently
> > let these happen and would need a check there. I was thinking
> > of doing it in a separate patch, but could tack it on to this
> > series for completeness.
> >
> 
> Oh, yeah, right. I see now what you mean. No problem on egress.
> 
> So it's just an SK_DROP return code from bpf_sk_redirect_map() that
> could be a potential improvement.
> 
> Your call if you want to add it this series. Patching it up as a follow
> up works for me as well.
> 
> >>
> >> All in all, sounds like an API change when it comes to corner cases, in
> >> addition to being a fix for the receive queue flush issue which you
> >> explained in the patch description. If possible, would push it through
> >> bpf-next.
> >
> > I think if we address 2,3,4 then we can fix the described issue
> > without introducing new cases. And then 1 is great for consistency
> > but can go via bpf-next?
> 
> So (3) is out, reuseport+sockmap users should be unaffected by this.
> 
> If you could patch (2) that would be great. We rely on this, and I can't
> assume that nobody isn't disconnecting their listener sockets for some
> reason.

Yep I'll roll a new version with a fix for this and leave the rest for
a follow up.

> 
> (4) and (1) can follow later, if you ask me.

Agree.
