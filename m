Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFE4435041
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 18:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhJTQhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 12:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhJTQhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 12:37:40 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13261C061749
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 09:35:24 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id e19so13565204ljk.12
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 09:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=OdU+bgXoYXyezlWN+g9oRiIOveUP3dWgtIEKKskFW9w=;
        b=gZMjIjq5IfqjoBi5EDZ4OY/VQn79ffIBw+Tm+ox85a/WbLxWZnBN9v5VWPRBGTauP3
         1TshHJuqQPw887XtRPo0Tf0FeDwzHpLU0IkwbYtxgkq17Ve/imnfbBwvqZyq7XYxNzwp
         Xq/slsBzSS8iBf247yZfrUbCPkL2WJXTspV5Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=OdU+bgXoYXyezlWN+g9oRiIOveUP3dWgtIEKKskFW9w=;
        b=yH4VrczQkI3b4XEe5di7GtpeyiuEotJO2pnpvW7zCNGBFM6Hgm4lWFdj5nhIrbt6PS
         xK0LJq73LIrROoK+NimMkH3CGvHoW1UI1xN1kSTq8xi1R9nJWFQHdIGe8U5luZRXDmIb
         S1GJdYUVN4hf+OZ2Gdkt+qtOXVcauamcVJ0DHZrSMI1bZ3do8LKCNY5GfkursMXOPJqG
         x3egYNBWFbIx+qe+ooOe8KrrNjQuHOBqZ9IDDIHoC/Xc/6V7rLj4VcfIL/k8QW9W63t4
         fkWGRMeZhGr1YHA2Eq2kuVSKy02hzM1syLDOr9TNu+ytY9v2eAWGgfi3wjoVZnA2br9S
         gARQ==
X-Gm-Message-State: AOAM530uj4dcIrU+Gc15QkyI/NNxWjleSq8IDXOtz/CSmB6OBADiiKZ1
        vf23fHJOyrPd13ToQJ9ZKlR9hA==
X-Google-Smtp-Source: ABdhPJz7XuuPxCd6LR7eYWc/Eof3rFzqdkinTxHjkDhVNpqiqwZnlAHE86Z+LOUC4vIhJj/NcsJr4g==
X-Received: by 2002:a05:651c:2107:: with SMTP id a7mr64329ljq.435.1634747722201;
        Wed, 20 Oct 2021 09:35:22 -0700 (PDT)
Received: from cloudflare.com (2a01-110f-480d-6f00-ff34-bf12-0ef2-5071.aa.ipv6.supernova.orange.pl. [2a01:110f:480d:6f00:ff34:bf12:ef2:5071])
        by smtp.gmail.com with ESMTPSA id 4sm228464lfq.5.2021.10.20.09.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 09:35:21 -0700 (PDT)
References: <20211011191647.418704-1-john.fastabend@gmail.com>
 <20211011191647.418704-2-john.fastabend@gmail.com>
 <87tuhdfpq4.fsf@cloudflare.com>
 <616fa9127fa63_340c7208ef@john-XPS-13-9370.notmuch>
 <87pmrzg28a.fsf@cloudflare.com>
 <61703b183b7ac_48ee720873@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        joamaki@gmail.com, xiyou.wangcong@gmail.com,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf 1/4] bpf, sockmap: Remove unhash handler for BPF
 sockmap usage
In-reply-to: <61703b183b7ac_48ee720873@john-XPS-13-9370.notmuch>
Date:   Wed, 20 Oct 2021 18:35:21 +0200
Message-ID: <87o87jfyd2.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 05:51 PM CEST, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> On Wed, Oct 20, 2021 at 07:28 AM CEST, John Fastabend wrote:
>> > Jakub Sitnicki wrote:
>> >> On Mon, Oct 11, 2021 at 09:16 PM CEST, John Fastabend wrote:
>> >> > We do not need to handle unhash from BPF side we can simply wait for the
>> >> > close to happen. The original concern was a socket could transition from
>> >> > ESTABLISHED state to a new state while the BPF hook was still attached.
>> >> > But, we convinced ourself this is no longer possible and we also
>> >> > improved BPF sockmap to handle listen sockets so this is no longer a
>> >> > problem.
>> >> >
>> >> > More importantly though there are cases where unhash is called when data is
>> >> > in the receive queue. The BPF unhash logic will flush this data which is
>> >> > wrong. To be correct it should keep the data in the receive queue and allow
>> >> > a receiving application to continue reading the data. This may happen when
>> >> > tcp_abort is received for example. Instead of complicating the logic in
>> >> > unhash simply moving all this to tcp_close hook solves this.
>> >> >
>> >> > Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
>> >> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
>> >> > ---
>> >>
>> >> Doesn't this open the possibility of having a TCP_CLOSE socket in
>> >> sockmap if I disconnect it, that is call connect(AF_UNSPEC), instead of
>> >> close it?
>> >
>> > Correct it means we may have TCP_CLOSE socket in the map. I'm not
>> > seeing any problem with this though. A send on the socket would
>> > fail the sk_state checks in the send hooks. (tcp.c:1245). Receiving
>> > from the TCP stack would fail with normal TCP stack checks.
>> >
>> > Maybe we want a check on redirect into ingress if the sock is in
>> > ESTABLISHED state as well? I might push that in its own patch
>> > though it seems related, but I think we should have that there
>> > regardless of this patch.
>> >
>> > Did you happen to see any issues on the sock_map side for close case?
>> > It looks good to me.
>>
>> OK, I didn't understand if that was an intended change or not.
>>
>
> wrt bpf-next:
> The problem is this needs to be backported in some way that fixes the
> case for stable kernels as well. We have applications that are throwing
> errors when they hit this at the moment.

Understood.

>> If we're considering allowing TCP sockets in TCP_CLOSE state in sockmap,
>> a few things come to mind:
>
> I think what makes most sense is to do the minimal work to fix the
> described issue for bpf tree without introducing new issues and
> then do the consistency/better cases in bpf-next.
>
>>
>> 1) We can't insert TCP_CLOSE sockets today. sock_map_sk_state_allowed()
>>    won't allow it. However, with this change we will be able to have a
>>    TCP_CLOSE socket in sockmap by disconnecting it. If so, perhaps
>>    inserting TCP sockets in TCP_CLOSE state should be allowed for
>>    consistency.
>
> I agree, but would hold off on this for bpf-next. I missed points
> 2,3 though in this series.

OK, that makes sense.

>>
>> 2) Checks in bpf_sk_lookup_assign() helper need adjusting. Only TCP
>>    sockets in TCP_LISTEN state make a valid choice (and UDP sockets in
>>    TCP_CLOSE state). Today we rely on the fact there that you can't
>>    insert a TCP_CLOSE socket.
>
> This should be minimal change, just change the logic to allow only
> TCP_LISTEN.
>
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -10402,7 +10402,7 @@ BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
>                 return -EINVAL;
>         if (unlikely(sk && sk_is_refcounted(sk)))
>                 return -ESOCKTNOSUPPORT; /* reject non-RCU freed sockets */
> -       if (unlikely(sk && sk->sk_state == TCP_ESTABLISHED))
> +       if (unlikely(sk && sk->sk_state != TCP_LISTEN))
>                 return -ESOCKTNOSUPPORT; /* reject connected sockets */
>
>         /* Check if socket is suitable for packet L3/L4 protocol */
>
>

Yeah, it shouldn't be hard. But we need to cover UDP as well. Something
along the lines of:

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10402,8 +10402,10 @@ BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
                return -EINVAL;
        if (unlikely(sk && sk_is_refcounted(sk)))
                return -ESOCKTNOSUPPORT; /* reject non-RCU freed sockets */
-       if (unlikely(sk && sk->sk_state == TCP_ESTABLISHED))
-               return -ESOCKTNOSUPPORT; /* reject connected sockets */
+       if (unlikely(sk && sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN))
+               return -ESOCKTNOSUPPORT; /* reject closed TCP sockets */
+       if (unlikely(sk && sk_is_udp(sk) && sk->sk_state != TCP_CLOSE))
+               return -ESOCKTNOSUPPORT; /* reject connected UDP sockets */

        /* Check if socket is suitable for packet L3/L4 protocol */
        if (sk && sk->sk_protocol != ctx->protocol)

We aren't testing today that that error case in sk_lookup test suite,
because it wasn't possible to insert a TCP_CLOSE socket. So once that
gets in, I can add coverage.

>>
>> 3) Checks in sk_select_reuseport() helper need adjusting as well. It's a
>>    similar same case as with bpf_sk_lookup_assign() (with a slight
>>    difference that reuseport allows dispatching to connected UDP
>>    sockets).
>
> Is it needed here? There is no obvious check now.  Is ESTABLISHED
> state OK here now?

TCP ESTABLISHED sockets are not okay. They can't join the reuseport
group and will always hit the !reuse branch.

Re-reading the code, though, I think nothing needs to be done for the
sk_select_reuseport() helper. TCP sockets will be detached from
reuseport group on unhash. Hence TCP_CLOSE socket will also hit the
!reuse branch.

CC'ing Martin just in case he wants to double-check.

>
>>
>> 4) Don't know exactly how checks in sockmap redirect helpers would need
>>    to be tweaked. I recall that it can't be just TCP_ESTABLISHED state
>>    that's allowed due to a short window of opportunity that opens up
>>    when we transition from TCP_SYN_SENT to TCP_ESTABLISHED.
>>    BPF_SOCK_OPS_STATE_CB callback happens just before the state is
>>    switched to TCP_ESTABLISHED.
>>
>>    TCP_CLOSE socket sure doesn't make sense as a redirect target. Would
>>    be nice to get an error from the redirect helper. If I understand
>>    correctly, if the TCP stack drops the packet after BPF verdict has
>>    selected a socket, only the socket owner will know about by reading
>>    the error queue.
>>
>>    OTOH, redirecting to a TCP_CLOSE_WAIT socket doesn't make sense
>>    either, but we don't seem to filter it out today, so the helper is
>>    not airtight.
>
> Right. At the moment for sending we call do_tcp_sendpages() and this
> has the normal check ~(TCPF_ESABLISHED | TCPF_CLOSE_WAIT) so we
> would return an error. The missing case is ingress. We currently
> let these happen and would need a check there. I was thinking
> of doing it in a separate patch, but could tack it on to this
> series for completeness.
>

Oh, yeah, right. I see now what you mean. No problem on egress.

So it's just an SK_DROP return code from bpf_sk_redirect_map() that
could be a potential improvement.

Your call if you want to add it this series. Patching it up as a follow
up works for me as well.

>>
>> All in all, sounds like an API change when it comes to corner cases, in
>> addition to being a fix for the receive queue flush issue which you
>> explained in the patch description. If possible, would push it through
>> bpf-next.
>
> I think if we address 2,3,4 then we can fix the described issue
> without introducing new cases. And then 1 is great for consistency
> but can go via bpf-next?

So (3) is out, reuseport+sockmap users should be unaffected by this.

If you could patch (2) that would be great. We rely on this, and I can't
assume that nobody isn't disconnecting their listener sockets for some
reason.

(4) and (1) can follow later, if you ask me.
