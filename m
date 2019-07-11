Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 150C166117
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 23:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfGKV0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 17:26:03 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41435 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfGKV0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 17:26:03 -0400
Received: by mail-pf1-f193.google.com with SMTP id m30so3330710pff.8;
        Thu, 11 Jul 2019 14:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=4N9aDBIH/e3s3OQv1dn/ZnQPSIncvFaSYm1vrdk9LBQ=;
        b=KvhOy2GNY8piigP8gfonlFUwqz7T4Z6XOX7jfSXMew3IRxTYNGCXgclfS+oxUn7KBa
         OzX3hkOErVQmwHAiMwD4YKHx3qnXfNscsTT3JtLmBylHiULQLf5kwooABQf1i+kRKMjs
         dno/uvXGi29aKQMqKss7DuxDbULxadZ5lzBnTQs9U1UE0ax73aWSo3913J0Z6sy9DKKb
         KVMfr4YPPoPA9YuJJ7kGurc5Yd398EW5UGEFqYt8d8vLECMb0KTdysmTroKlUVLsnCrM
         o60JhszozuGX1UZv1p/zuKBHdlv/S5V2ZY98RcaX5jcU18nWHMCp4zLPz1NXMk9gJafp
         xOhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=4N9aDBIH/e3s3OQv1dn/ZnQPSIncvFaSYm1vrdk9LBQ=;
        b=dn7hRAR8N0KN6WmJhIBzzMyKh9AEtKtBoWOD3iygFCCchINuYcMpQmOXM/x15dGdLX
         t81Mz+TAd00MiwnuE/SOZxJMe3aq7r2XIsSzWSC3UYWBHq3UQEj8/beZAhGtOYf78A2r
         JwLRwRqCuW7RiprGurxIhGzM9SzYIoQpyX6Kvx4riJcVQOukjD6e/NN2VYiW8LuYaXZx
         VCwS20/Gby2RpbwqaLWmTM0n/wRqC/IP4Lp2kz5zqIG7MhdJTZ+ktTO+TlRWMVCBZAyG
         q7n5gg65KJicz2kcM2nnh9L4o2l0gBdPcnJThoA29wbYPOrfiGa90KWEsXSCXKYFpMHj
         lCqw==
X-Gm-Message-State: APjAAAVX1I4p7kjUD3PuC+wMlYOdYEN7Y4m6XU6eeKoMx6GHONrLbHdy
        A6ys79RzPPFuIWlDyn48s34=
X-Google-Smtp-Source: APXvYqx0EMLl2Jk94p2LsOhcSkQFs61ZQAU/GV0vr4p/EKyNeBN5HvRFIkwPlI6agbaCZMnAsXYEDA==
X-Received: by 2002:a17:90a:7d04:: with SMTP id g4mr7264410pjl.41.1562880362423;
        Thu, 11 Jul 2019 14:26:02 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 14sm6008410pgp.37.2019.07.11.14.26.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 14:26:01 -0700 (PDT)
Date:   Thu, 11 Jul 2019 14:25:54 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Message-ID: <5d27a9627b092_19762abc80ff85b856@john-XPS-13-9370.notmuch>
In-Reply-To: <20190711113218.2f0b8c1f@cakuba.netronome.com>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
 <156261324561.31108.14410711674221391677.stgit@ubuntu3-kvm1>
 <20190709194525.0d4c15a6@cakuba.netronome.com>
 <5d255dececd33_1b7a2aec940d65b45@john-XPS-13-9370.notmuch>
 <20190710123417.2157a459@cakuba.netronome.com>
 <20190710130411.08c54ddd@cakuba.netronome.com>
 <5d276814a76ad_698f2aaeaaf925bc8a@john-XPS-13-9370.notmuch>
 <20190711113218.2f0b8c1f@cakuba.netronome.com>
Subject: Re: [bpf PATCH v2 2/6] bpf: tls fix transition through disconnect
 with close
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Thu, 11 Jul 2019 09:47:16 -0700, John Fastabend wrote:
> > Jakub Kicinski wrote:
> > > On Wed, 10 Jul 2019 12:34:17 -0700, Jakub Kicinski wrote:  =

> > > > > > > +		if (sk->sk_prot->unhash)
> > > > > > > +			sk->sk_prot->unhash(sk);
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	ctx =3D tls_get_ctx(sk);
> > > > > > > +	if (ctx->tx_conf =3D=3D TLS_SW || ctx->rx_conf =3D=3D TLS=
_SW)
> > > > > > > +		tls_sk_proto_cleanup(sk, ctx, timeo);  =

> > > =

> > > Do we still need to hook into unhash? With patch 6 in place perhaps=
 we
> > > can just do disconnect =F0=9F=A5=BA  =

> > =

> > ?? "can just do a disconnect", not sure I folow. We still need unhash=

> > in cases where we have a TLS socket transition from ESTABLISHED
> > to LISTEN state without calling close(). This is independent of if
> > sockmap is running or not.
> > =

> > Originally, I thought this would be extremely rare but I did see it
> > in real applications on the sockmap side so presumably it is possible=

> > here as well.
> =

> Ugh, sorry, I meant shutdown. Instead of replacing the unhash callback
> replace the shutdown callback. We probably shouldn't release the socket=

> lock either there, but we can sleep, so I'll be able to run the device
> connection remove callback (which sleep).
> =


ah OK seems doable to me. Do you want to write that on top of this
series? Or would you like to push it onto your branch and I can pull
it in push the rest of the patches on top and send it out? I think
if you can get to it in the next few days then it makes sense to wait.

I can't test the hardware side so probably makes more sense for
you to do it if you can.


> > > cleanup is going to kick off TX but also:
> > > =

> > > 	if (unlikely(sk->sk_write_pending) &&
> > > 	    !wait_on_pending_writer(sk, &timeo))
> > > 		tls_handle_open_record(sk, 0);
> > > =

> > > Are we guaranteed that sk_write_pending is 0?  Otherwise
> > > wait_on_pending_writer is hiding yet another release_sock() :(  =

> > =

> > Not seeing the path to release_sock() at the moment?
> > =

> >    tls_handle_open_record
> >      push_pending_record
> >       tls_sw_push_pending_record
> >         bpf_exec_tx_verdict
> =

> wait_on_pending_writer
>   sk_wait_event
>     release_sock
> =


ah OK. I'll check on sk_write_pending...

> > If bpf_exec_tx_verdict does a redirect we could hit a relase but that=

> > is another fix I have to get queued up shortly. I think we can fix
> > that in another series.
> =

> Ugh.


