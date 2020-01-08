Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7661134A85
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgAHSev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:34:51 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:35680 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgAHSev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:34:51 -0500
Received: by mail-io1-f68.google.com with SMTP id h8so4325919iob.2;
        Wed, 08 Jan 2020 10:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=1mCqQwH/xqstM+PlDcmEXaSfBXwVOV55PSPGHJmf6Vs=;
        b=DxNx7kV7sQDABgQIHQVY7QrjuAhj7IeDyd5YBzIMP/Wet/fCz3z360ofQOYp4pqz/n
         7h/VU9R0udmNCA0/mW6jb5NBQS0ZO2gNKOZ08aD/IK+ftsRwYtyCGrh2EBRlGTnGlTfG
         UTGmVir12INZJ7S+0z5L6D7uPohNEpObV5qwkPKTZO51kPqJdWY+j/YUgYqesEKnzie9
         PUFCXG9KCgYHVhKNxngVhPPMSL/406bfrG8ok5ckTkz84+UO/ZgkEkTzzfSkeRObyswE
         wYMdOWkaXI3qpynNZ53C7MWIqj8O9bdkOxcz3/D6/cMm3PUoRYEdkGF7ewZXKeYTBsXW
         LsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=1mCqQwH/xqstM+PlDcmEXaSfBXwVOV55PSPGHJmf6Vs=;
        b=QxC/9ZbVl+EWDV/ZkRpNIIXhCnrsw+t4DSFn4Xc66741A3CRxy0OWuBcDEAYnqGrN9
         iIWwJGT896oj0cXWMXsxwqJIOfTwtQmsjWXkfmlCuxZpxqXDCjqn8ywrNhKUh/YHbP5L
         nGHi7D7S9mYzcMlwhHgk5k0YCE1MS6Bug2iTjOJH5DNjLlLKNT4aI5xUHWwd9t1C5agK
         sH5Qx7FI5dqlu9lmYssPUqGk8gbKt4wD7q3uwfTUGKQ1CsP3mewq6EgpU3Abr8pn3Nsi
         i3yXw7UduGVrZYQukTd4iIRgsHsTC7DPYqa9A/eLEMlm7CKJkMOUnreU5wzzW/tvx5Kg
         nZyw==
X-Gm-Message-State: APjAAAXzaC4JGQjZvJkLjadv3AtzlzcvZ27H1+gaaedxqNvfT0Z+Co4W
        fXcOBe9zeonhczHoIGIg0xyI4dJ3
X-Google-Smtp-Source: APXvYqxut71xWlZNHlRmT8IPQ4hvtBaEWs1SYJ13UgbVffS2yWH/HXd1KF8WZ9GPKz73Ri/es1kdgQ==
X-Received: by 2002:a02:c85b:: with SMTP id r27mr5257467jao.57.1578508490355;
        Wed, 08 Jan 2020 10:34:50 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w16sm1197669ilq.5.2020.01.08.10.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 10:34:49 -0800 (PST)
Date:   Wed, 08 Jan 2020 10:34:43 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Lingpeng Chen <forrest0579@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <5e1620c332f3c_159a2af0aa9505b861@john-XPS-13-9370.notmuch>
In-Reply-To: <e40286e9-107c-4af9-e596-4af426408eca@iogearbox.net>
References: <5e15526d2ebb6_68832ae93d7145c08c@john-XPS-13-9370.notmuch>
 <20200108045708.31240-1-forrest0579@gmail.com>
 <20200108170259.GA7665@linux-3.fritz.box>
 <5e161913342f2_67ea2afd262665bc1c@john-XPS-13-9370.notmuch>
 <e40286e9-107c-4af9-e596-4af426408eca@iogearbox.net>
Subject: Re: [PATCH] bpf/sockmap: read psock ingress_msg before
 sk_receive_queue
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 1/8/20 7:01 PM, John Fastabend wrote:
> > Daniel Borkmann wrote:
> >> On Wed, Jan 08, 2020 at 12:57:08PM +0800, Lingpeng Chen wrote:
> >>> Right now in tcp_bpf_recvmsg, sock read data first from sk_receive_queue
> >>> if not empty than psock->ingress_msg otherwise. If a FIN packet arrives
> >>> and there's also some data in psock->ingress_msg, the data in
> >>> psock->ingress_msg will be purged. It is always happen when request to a
> >>> HTTP1.0 server like python SimpleHTTPServer since the server send FIN
> >>> packet after data is sent out.
> >>>
> >>> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> >>> Reported-by: Arika Chen <eaglesora@gmail.com>
> >>> Suggested-by: Arika Chen <eaglesora@gmail.com>
> >>> Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
> >>> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> >>> ---
> >>>   net/ipv4/tcp_bpf.c | 7 ++++---
> >>>   1 file changed, 4 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> >>> index e38705165ac9..f7e902868fce 100644
> >>> --- a/net/ipv4/tcp_bpf.c
> >>> +++ b/net/ipv4/tcp_bpf.c
> >>> @@ -123,12 +123,13 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
> >>>   
> >>>   	if (unlikely(flags & MSG_ERRQUEUE))
> >>>   		return inet_recv_error(sk, msg, len, addr_len);
> >>
> >> Shouldn't we also move the error queue handling below the psock test as
> >> well and let tcp_recvmsg() natively do it in case of !psock?
> >>
> > 
> > You mean the MSG_ERRQUEUE flag handling? If the user sets MSG_ERRQUEUE
> > they expect to receive any queued errors it would be wrong to return
> > psock data in this case if psock is attached and has data on queue and
> > user passes MSG_ERRQUEUE flag.
> > 
> >   MSG_ERRQUEUE (since Linux 2.2)
> >    This flag specifies that queued errors should be received from the socket
> >    error queue.  The error is passed in an ancillary message with a type
> >    dependent on the protocol (for IPv4 IP_RECVERR).  The user should supply
> >    a buffer of sufficient size. See cmsg(3) and ip(7) for more information.
> >    The payload of the original packet that caused the error is passed as
> >    normal data via msg_iovec. The original destination address of the
> >    datagram that caused the error is supplied via msg_name.
> > 
> > I believe it needs to be where it is.
> 
> I meant that it should have looked as follows (aka moving both below the
> psock test) ...
> 
>          psock = sk_psock_get(sk);
>          if (unlikely(!psock))
>              return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
>          if (unlikely(flags & MSG_ERRQUEUE))
>              return inet_recv_error(sk, msg, len, addr_len);
> 	if (!skb_queue_empty(&sk->sk_receive_queue) && [...]
> 
> ... since when detached it's handled already via tcp_recvmsg() internals.
> 

Ah, OK the 'if (unlikely(!psock))' is a very rare case so I'm not sure
it matters much. But, I agree it is slightly nicer.

Lingpeng, can you spin a v2 moving the MSG_ERRQUEUE check down and also
keep the ACK and stable tags I don't think its a very big change the
Acks can stick around IMO.

Thanks.
