Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE1BFE7B4
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 23:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfKOWVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 17:21:20 -0500
Received: from mail-pl1-f176.google.com ([209.85.214.176]:39486 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfKOWVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 17:21:20 -0500
Received: by mail-pl1-f176.google.com with SMTP id o9so5605796plk.6;
        Fri, 15 Nov 2019 14:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=deJB1ZmwOztcSOAFmiNM9dxaXrAfaUv7l+zQRm1Qajw=;
        b=qBZhdE4jqSM3FKDyziq0ZNWcKhNjDCyy6++WvMnLQwPy9PTP8wk2/n1kdD29t9RDKp
         Hjrkgf4V5eJW5oLGqpXJK2QG09TUxQHbA3wN5bNhilunNZbZrjWPn/SrxEu4cRKpk5Ix
         pSy2KA1B+bvfBlQ3KRtKRllHUye61UJwXjMKiluUq2p6HphBTeaUntN9OepJhtneG4tF
         7N2bYgHe0DwUA43xRO6OilZKCXGGe6rkBllXhSAwA1Z84iwdXRhXL91zHdGbCD+u1eqS
         vm2gb2zopavf+FvZ2aZIoHMmYUrEF7KC+sXuQ53BWQ54F9ykF0g6VGVV8cb0l/wjDCu+
         SVgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=deJB1ZmwOztcSOAFmiNM9dxaXrAfaUv7l+zQRm1Qajw=;
        b=TZhH0RjblP4o/WvsFqnhiGcEC151XritnLJf8lsCvlUD/VFkeMtxi28Pb2lhC9gKc/
         ILNTDR/DRgI0G8fqdGdf+sQZN4F3Eb0lLNOVT32w/t0twnI2bcZ8Bi9/9t0/W8Yu+0Ka
         tjhDFMjLtiVpTdyFx8cgobrvGSmiP/CdL91GRFxK4sMdFzJ9bEjHL54qw8DOfgO7jxH5
         8Ys48rH6KlbchjTDvA1XhzEU6ocq+wE+IbS8b8pP4+ZbGPnaxtz10mK9Eq4HxsIb3kF2
         hx6/1HlZmjrz/QWq50LjWx8WjfMVTvDUWDMraHl7tmZWqh7JX/AQcJK9/wG9G47qJnCO
         kBzA==
X-Gm-Message-State: APjAAAU3AAsxeUBmaubZDJbjBjMgPySjSBk/gxb+8IHGyCyFHjKRY+03
        4tQ4WMpRo9EEIHdgiPWojtPoqzvN
X-Google-Smtp-Source: APXvYqzypaxQNUFyXJcS87TBhR+ofCcU7kgBnWUzZ4xvb3mhpkrcqAzjxRciuY82hXAUA948UPllVA==
X-Received: by 2002:a17:90b:144:: with SMTP id em4mr23457230pjb.29.1573856479136;
        Fri, 15 Nov 2019 14:21:19 -0800 (PST)
Received: from localhost (198-0-60-179-static.hfc.comcastbusiness.net. [198.0.60.179])
        by smtp.gmail.com with ESMTPSA id z7sm13353878pfr.165.2019.11.15.14.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:21:18 -0800 (PST)
Date:   Fri, 15 Nov 2019 14:21:17 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        bpf <bpf@vger.kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5dcf24ddc492e_66d2acadef865b4b2@john-XPS-13-9370.notmuch>
In-Reply-To: <CA+FuTSfTMuKv8s0zdS6YzLC14bNdPQxi2mu7ak6e_sS+qyyrFg@mail.gmail.com>
References: <CA+FuTSfTMuKv8s0zdS6YzLC14bNdPQxi2mu7ak6e_sS+qyyrFg@mail.gmail.com>
Subject: RE: combining sockmap + ktls
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn wrote:
> I've been playing with sockmap and ktls. They're fantastic tools.

Great, glad to get more eyes on it. Thanks.

> Combining them I did run into a few issues. Would like to understand
> whether (a) it's just me, else (b) whether these are known issues and
> (c) some feedback on an initial hacky patch.

There are still a few outstanding things I need to flush out of my
queue listed below.

> 
> My test [1] sets up an echo request/response between a client and
> server, optionally interposed by an "icept" guard process on each side
> and optionally enabling ktls between the icept processes.
> 
> Without ktls, most variants of interpositioning {iptables, iptables +
> splice(), iptables + sockmap splice, sk_msg to icept tx } work.
> 
> Only sk_msg redirection to icept ingress with BPF_F_INGRESS does not
> if the destination socket has a verdict program. I *think* this is
> intentional, judging from commit 552de9106882 ("bpf: sk_msg, fix
> socket data_ready events") explicitly ensuring that the process gets
> awoken on new data if a socket has a verdict program and another
> socket redirects to it, as opposed to passing it to the program.

Right.

> 
> For this workload, more interesting is sk_msg directly to icept
> egress, anyway. This works without ktls. Support for ktls is added in
> commit d3b18ad31f93 ("tls: add bpf support to sk_msg handling"). The
> relevant callback function tls_sw_sendpage_locked was not immediately
> used and subsequently removed in commit cc1dbdfed023 ("Revert
> "net/tls: remove unused function tls_sw_sendpage_locked""). It appears
> to work once reverting that change, plus registering the function

I don't fully understand this. Are you saying a BPF_SK_MSG_VERDICT
program attach to a ktls socket is not being called? Or packets are
being dropped or ...? Or that the program doesn't work even with
just KTLS and no bpf involved. 

> 
>         @@ -859,6 +861,7 @@ static int __init tls_register(void)
> 
>                 tls_sw_proto_ops = inet_stream_ops;
>                 tls_sw_proto_ops.splice_read = tls_sw_splice_read;
>         +       tls_sw_proto_ops.sendpage_locked   = tls_sw_sendpage_locked,
> 
> and additionally allowing MSG_NO_SHARED_FRAGS:
> 
>          int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
>                                     int offset, size_t size, int flags)
>          {
>                if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
>         -                     MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
>         +                     MSG_SENDPAGE_NOTLAST |
> MSG_SENDPAGE_NOPOLICY | MSG_NO_SHARED_FRAGS))
>                          return -ENOTSUPP;
> 

If you had added MSG_NO_SHARED_FRAGS to the existing tls_sw_sendpage
would that have been sufficient?

> and not registering parser+verdict programs on the destination socket.
> Note that without ktls this mode also works with such programs
> attached.

Right ingress + ktls is known to be broken at the moment. Also I have
plans to cleanup ingress side at some point. The current model is a
bit clumsy IMO. The workqueue adds latency spikes on the 99+
percentiles. At this point it makes the ingress side similar to the
egress side without a workqueue and with verdict+parser done in a
single program.

> 
> Lastly, sockmap splicing from icept ingress to egress (no sk_msg) also
> stops working when I enable ktls on the egress socket. I'm taking a
> look at that next. But this email is long enough already ;)

Yes this is a known bug I've got a set of patches to address this. I've
been trying to get to it for awhile now and just resolved a few other
things on my side so plan to do this Monday/Tuesday next week.

FWIW there is also a bugfix on the way to resolve a case where we
receive a FIN/RST flag after redirecting data causing dropped data.

> 
> Thanks for having a look!
> 
>   Willem
> 
> [1] https://github.com/wdebruij/kerneltools/tree/icept.2
> 
> probably more readable is the stack of commits, one per feature:
> 
>   c86c112 icept: initial client/server test
>   727a8ae icept: add iptables interception
>   60c34b2 icept: add splice interception
>   03a516a icept: add sockmap interception
>   c9c6103 icept: run client and server in cgroup
>   579bcae icept: add skmsg interception
>   e1b0d17 icept: add kTLS


