Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303C648B51
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFQSHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:07:15 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46436 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfFQSHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:07:15 -0400
Received: by mail-qt1-f196.google.com with SMTP id h21so11816196qtn.13
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 11:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0YGsj9terTeLEeLEBRMl5YlUmvd9mUf+KVtTWQDgY2Y=;
        b=pXApNlOzqYRbCirrBtIjM/DJ9+PolGZSmFSJuZ9zwxx5t4oMuss2bsqTW2dvCNQzqy
         i+daTtgAtc5TSYCi6c/ZMACCDnmXO8UNlvRmXSan4U+3YJdH8lqbZrs0rERCgu/cppwE
         kdavwC9WEN7QOFfCP6RLKK+pmfkoqyfe/AHdEmYJMNOS4Wako5sNXDaRn3nXbbQNHo10
         zaiXKD1Vs/1V3QpqeEpn3KhLyzIlgFDvQZxix5h5MfCYbNTSZjF6lx8tHIrqrXp59Yjx
         P3e3SFx/KguYtjrYvi3zkXl6vhpKZrUHsTZXhRp1NjSQrBy2pllhdYHu/y2FLT6fw4C9
         P2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0YGsj9terTeLEeLEBRMl5YlUmvd9mUf+KVtTWQDgY2Y=;
        b=ISZFP5Pv9zFcaWh1zF3vfI85wN2E0GRmdG7xeVno4g27Qa4NTvlG6DBd++lDKazYNh
         TIC6JpYaBsyyVkMhN+j7JhbmUSyzgWwVwwE+AhJ4e3DjXQ5bn/Gh5IorLC2NQ+blhVYJ
         TDcbL8WqSiXx37xAQfPc3oXJq251WkcftC4AyRef60Rq5GT4rRz3TxF4TcDelUiJ9oPy
         SMwRH5g7tyQ4bImm/wzOi206E6EGGwl7ndw9xOyyETT8NsMVTD8Tw+9UXGwWL3SQOsGt
         33gvHuu2tdF0DMky0efDOUz5sscwUZ1D6bD7wmO0FjVk0eg7eF3QrZYusiCWgwVcCmWb
         ahlw==
X-Gm-Message-State: APjAAAXSOcrB/0ZA2PJg37K/y885fi65tVNdMnNgUxYWU9qhlJLDhzjq
        DDF90lOvLyvsc3z8wuubxS4LLA==
X-Google-Smtp-Source: APXvYqx4pyBTvzL8LZB1filpj0uJvYAUgDAD81rHOm2VKWZYlUhuqhUaDXjRy6fIWRiFW0TKbpZEGg==
X-Received: by 2002:ac8:1a8d:: with SMTP id x13mr96823682qtj.114.1560794832060;
        Mon, 17 Jun 2019 11:07:12 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i35sm833844qtc.9.2019.06.17.11.07.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 11:07:11 -0700 (PDT)
Date:   Mon, 17 Jun 2019 11:07:06 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 2/2] net: tls: export protocol version and
 cipher to socket diag
Message-ID: <20190617110706.7c269328@cakuba.netronome.com>
In-Reply-To: <5ed5d6b3356c505ece2a354847e3aafd09fb82f3.camel@redhat.com>
References: <cover.1559747691.git.dcaratti@redhat.com>
        <4262dd2617a24b66f24ec5ddc73f817e683e14e0.1559747691.git.dcaratti@redhat.com>
        <20190605162555.59b4fb3e@cakuba.netronome.com>
        <5ed5d6b3356c505ece2a354847e3aafd09fb82f3.camel@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jun 2019 18:04:06 +0200, Davide Caratti wrote:
> On Wed, 2019-06-05 at 16:25 -0700, Jakub Kicinski wrote:
> > On Wed,  5 Jun 2019 17:39:23 +0200, Davide Caratti wrote:  
> > We need some indication of the directions in which kTLS is active
> > (none, rx, tx, rx/tx).
> > 
> > Also perhaps could you add TLS_SW vs TLS_HW etc. ? :)  
> 
> I can add a couple of u16 (or larger?) bitmasks to dump txconf and rxconf.
> do you think this is sufficient?

SGTM!

> > > +	int err = 0;  
> > 
> > There should be no need to init this.
> >   
> > > +	if (sk->sk_state != TCP_ESTABLISHED)  
> > 
> > Hmm.. why this check?  We never clean up the state once installed until
> > the socket dies completely (currently, pending John's unhash work).  
> 
> the goal was to ensure that we don't read ctx anymore after
> tls_sk_proto_close() has freed ctx, and I thought that a test on the value
> of sk_state was sufficient.
> 
> If it's not, then we might invent something else. For example, we might
> defer freeing kTLS ctx, so that it's called as the very last thing with
> tcp_cleanup_ulp().

Mm.. I was hoping the user space can no longer access a socket once
it reaches sk_prot->close :S  Perhaps I got this wrong.  If it can 
we need to make sure we don't free context before calling tcp_close()
otherwise the state may still be established, no?

In particular:

#ifdef CONFIG_TLS_DEVICE
	if (ctx->rx_conf == TLS_HW)
		tls_device_offload_cleanup_rx(sk);

	if (ctx->tx_conf != TLS_HW && ctx->rx_conf != TLS_HW) {
#else
	{
#endif
		tls_ctx_free(ctx);        <<<  <<<   <<<   <<< kfree()
		ctx = NULL;
	}

skip_tx_cleanup:
	release_sock(sk);
	sk_proto_close(sk, timeout);      <<<  <<<   <<<   <<< tcp_close()
	/* free ctx for TLS_HW_RECORD, used by tcp_set_state
	 * for sk->sk_prot->unhash [tls_hw_unhash]
	 */
	if (free_ctx)
		tls_ctx_free(ctx);
