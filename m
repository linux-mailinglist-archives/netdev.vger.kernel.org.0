Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDF9134A04
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 19:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbgAHSCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 13:02:04 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:44180 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgAHSCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 13:02:03 -0500
Received: by mail-il1-f194.google.com with SMTP id z12so3378883iln.11;
        Wed, 08 Jan 2020 10:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=HEqWOcCms6EGHUmPBqScOdh4FBytf1vClXXJetZ8LjY=;
        b=IMLMRM5fFiKVLkFZ8PesI5XEP9AZBHFSxmdQSvVNp1ZfbeulcNQ5mCi7DhSFsiFZ+h
         zlPIeNbVcpNPBZ3bfGH14gjLiMKkoihvGXYQhUd7orA5m93Z4z+TLb0c2i7t4thlq/Jf
         5aojGPaWlydfnqGEaKYTG4/OD4moRHfP5CWLBZnWnpe131jVjecA4xj6aEc+PYGD8kBk
         e2/w9mEgNM5rkKNMqn+nJeuA0xER/EbJ5FGJA4lbpyHFXfWaybCr6FuqKXuNWZN5gnrr
         o6NCBdC4uWFtIsOOo9A5gg3J9bsjo++lFKL1mn79pLY5OUIjcYWx+TSjAKCYQWCBfHeR
         7vaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=HEqWOcCms6EGHUmPBqScOdh4FBytf1vClXXJetZ8LjY=;
        b=Y0/jF8kzauSlJM64LEnzAKe5qWddF9xIborb3L5QUxuJpKysb8RvCBIC5mQQEW7k4R
         CRPw5541yQ3YM0aElkzyiZI2aJ9sE6lK6r11EovewtUrOdoy4K/VE4KMkMjBhT25K/3m
         rWVuiDcppboZvW8yl+LHI1xJyHbRgoSU4jHT75SV1Rzu08oO5GS5aHG+mXW5J3q05Trw
         GsvxJsm9Xu3cBKKI5qDPrD6ZNIbM4snsyWJHYryq6by/690pqfEyEi1RcukMylAkyJ1e
         NVlmcRgftP3iaU5XoSqW9Adq2pBvQ+VWkJsxhFAT9eQvu/UFIMf00ClXeIy0++pJGFA9
         uTjA==
X-Gm-Message-State: APjAAAUODtL53WQgd6Eph0EKerUhZ7Gxu84m4/CEbFe9wg3dfc1yJ5P9
        he9sX27EjoiOimIEXorPjHU=
X-Google-Smtp-Source: APXvYqwo2+3HqTmybI36dsktHbjLPiIVgQ+3aIQMuEzGMBdETJt2THiEgaaVqNpQ7IzC30uYzxtiAA==
X-Received: by 2002:a92:9c04:: with SMTP id h4mr5182648ili.6.1578506522684;
        Wed, 08 Jan 2020 10:02:02 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v13sm800850ioh.53.2020.01.08.10.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 10:02:01 -0800 (PST)
Date:   Wed, 08 Jan 2020 10:01:55 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Lingpeng Chen <forrest0579@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5e161913342f2_67ea2afd262665bc1c@john-XPS-13-9370.notmuch>
In-Reply-To: <20200108170259.GA7665@linux-3.fritz.box>
References: <5e15526d2ebb6_68832ae93d7145c08c@john-XPS-13-9370.notmuch>
 <20200108045708.31240-1-forrest0579@gmail.com>
 <20200108170259.GA7665@linux-3.fritz.box>
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
> On Wed, Jan 08, 2020 at 12:57:08PM +0800, Lingpeng Chen wrote:
> > Right now in tcp_bpf_recvmsg, sock read data first from sk_receive_queue
> > if not empty than psock->ingress_msg otherwise. If a FIN packet arrives
> > and there's also some data in psock->ingress_msg, the data in
> > psock->ingress_msg will be purged. It is always happen when request to a
> > HTTP1.0 server like python SimpleHTTPServer since the server send FIN
> > packet after data is sent out.
> > 
> > Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> > Reported-by: Arika Chen <eaglesora@gmail.com>
> > Suggested-by: Arika Chen <eaglesora@gmail.com>
> > Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  net/ipv4/tcp_bpf.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> > index e38705165ac9..f7e902868fce 100644
> > --- a/net/ipv4/tcp_bpf.c
> > +++ b/net/ipv4/tcp_bpf.c
> > @@ -123,12 +123,13 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
> >  
> >  	if (unlikely(flags & MSG_ERRQUEUE))
> >  		return inet_recv_error(sk, msg, len, addr_len);
> 
> Shouldn't we also move the error queue handling below the psock test as
> well and let tcp_recvmsg() natively do it in case of !psock?
> 

You mean the MSG_ERRQUEUE flag handling? If the user sets MSG_ERRQUEUE
they expect to receive any queued errors it would be wrong to return
psock data in this case if psock is attached and has data on queue and
user passes MSG_ERRQUEUE flag.

 MSG_ERRQUEUE (since Linux 2.2)
  This flag specifies that queued errors should be received from the socket
  error queue.  The error is passed in an ancillary message with a type
  dependent on the protocol (for IPv4 IP_RECVERR).  The user should supply
  a buffer of sufficient size. See cmsg(3) and ip(7) for more information.
  The payload of the original packet that caused the error is passed as
  normal data via msg_iovec. The original destination address of the
  datagram that caused the error is supplied via msg_name.

I believe it needs to be where it is.


> > -	if (!skb_queue_empty(&sk->sk_receive_queue))
> > -		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
> >  
> >  	psock = sk_psock_get(sk);
> >  	if (unlikely(!psock))
> >  		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
> > +	if (!skb_queue_empty(&sk->sk_receive_queue) &&
> > +	    sk_psock_queue_empty(psock))
> > +		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
> >  	lock_sock(sk);
> >  msg_bytes_ready:
> >  	copied = __tcp_bpf_recvmsg(sk, psock, msg, len, flags);
> > @@ -139,7 +140,7 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
> >  		timeo = sock_rcvtimeo(sk, nonblock);
> >  		data = tcp_bpf_wait_data(sk, psock, flags, timeo, &err);
> >  		if (data) {
> > -			if (skb_queue_empty(&sk->sk_receive_queue))
> > +			if (!sk_psock_queue_empty(psock))
> >  				goto msg_bytes_ready;
> >  			release_sock(sk);
> >  			sk_psock_put(sk, psock);
> > -- 
> > 2.17.1
> > 


