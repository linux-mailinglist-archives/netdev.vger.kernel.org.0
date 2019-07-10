Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF0663FA6
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 05:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfGJDeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 23:34:16 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44999 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfGJDeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 23:34:16 -0400
Received: by mail-io1-f66.google.com with SMTP id s7so1555787iob.11;
        Tue, 09 Jul 2019 20:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ocgN2JyaeuZzfP7D6dXOnC1we/qTpQ9TctNWqwNUkG4=;
        b=XTASlWXFRNsR8ByzJ7rOHbkmj8qNHteAOTmZ7eZUq6ZBiDuOXZPOiQBm5jlEwXk0lU
         mShXNXIMXvW2GlgUYTRv61b5KMMesAQgACcfKyjsIcib1hDRuNYUnpCbVOtHGnyXR3LR
         Cy+9qFypT3FWkKwYcKRtHLKP5jaZzebKtZo8psrE4cSIeCIpSj8k1ld/OqhYMkjKkJEs
         qce+S7zbN/y7DxFGD6eOeT+jg+LNYf6FLFHYbbIey6Li/Tgd/j8EhNlSIS5UDNR0zDRc
         o/VFKsDpR+m5sBJTtYA1INywnviXn7x3E0YGUspC9VkQU4kJvTlsm1za6U5PCyX2hDJy
         Lwkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ocgN2JyaeuZzfP7D6dXOnC1we/qTpQ9TctNWqwNUkG4=;
        b=sYR8JPmJgnA1t8gViG46Jm4xiRHZuf7lhgab+FdCXmjLY3S2/biHMoccMdflQXE48M
         F+AjCKhBydEHRBj8/Xhi8tbSGZU4RffnINuv0PWpquTL5fBCKEQ6AMKfpXKy0UJ4zUgb
         StzGTZV1m7Jau9n9659nJaEExOgUC8/zQsjnJt+/2BLLKR7eoUucjLNhnSmDpzfUkn/6
         l8BH7VKU1GyN0EX4us7bx7mNX2LmSUknTvwf4WF3ddnsecZevTX8oW4aFc4Y6/cHZ52V
         7t//7K6juSfKrNVD7xbzbiB1W40bW1TqEf1Cj37m8a88Ro6ANDNDNu4lFUK2T2LtDVLh
         RHgA==
X-Gm-Message-State: APjAAAXIX+XKp9JXFGGauWAzvCabfxl27O3UN5Dzfy7r7ZGFtCaTPrM/
        a51HzyQG4EsHNcTVzEXr5Zg=
X-Google-Smtp-Source: APXvYqwhyRufbMlx4AngiBdlkrsn89G44g7ExKV/pnIY1d7nZypArDRFWNYfuKVzMDOHYktN7rpUng==
X-Received: by 2002:a5d:834f:: with SMTP id q15mr8410447ior.59.1562729655835;
        Tue, 09 Jul 2019 20:34:15 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s10sm2269615iod.46.2019.07.09.20.34.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 20:34:15 -0700 (PDT)
Date:   Tue, 09 Jul 2019 20:33:58 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Message-ID: <5d255ca6e5b0d_1b7a2aec940d65b4f6@john-XPS-13-9370.notmuch>
In-Reply-To: <20190709193846.62f0a2c7@cakuba.netronome.com>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
 <156261331866.31108.6405316261950259075.stgit@ubuntu3-kvm1>
 <20190709193846.62f0a2c7@cakuba.netronome.com>
Subject: Re: [bpf PATCH v2 6/6] bpf: sockmap/tls, close can race with map free
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Mon, 08 Jul 2019 19:15:18 +0000, John Fastabend wrote:
> > @@ -352,15 +354,18 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
> >  	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE)
> >  		goto skip_tx_cleanup;
> >  
> > -	sk->sk_prot = ctx->sk_proto;
> >  	tls_sk_proto_cleanup(sk, ctx, timeo);
> >  
> >  skip_tx_cleanup:
> > +	write_lock_bh(&sk->sk_callback_lock);
> > +	icsk->icsk_ulp_data = NULL;
> 
> Is ulp_data pointer now supposed to be updated under the
> sk_callback_lock?

Yes otherwise it can race with tls_update(). I didn't remove the
ulp pointer null set from tcp_ulp.c though. Could be done in this
patch or as a follow up.
> 
> > +	if (sk->sk_prot->close == tls_sk_proto_close)
> > +		sk->sk_prot = ctx->sk_proto;
> > +	write_unlock_bh(&sk->sk_callback_lock);
> >  	release_sock(sk);
> >  	if (ctx->rx_conf == TLS_SW)
> >  		tls_sw_release_strp_rx(ctx);
> > -	sk_proto_close(sk, timeout);
> > -
> > +	ctx->sk_proto_close(sk, timeout);
> >  	if (ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW &&
> >  	    ctx->tx_conf != TLS_HW_RECORD && ctx->rx_conf != TLS_HW_RECORD)
> >  		tls_ctx_free(ctx);
