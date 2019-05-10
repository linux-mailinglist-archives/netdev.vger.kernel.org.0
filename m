Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67CA1A57E
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 01:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbfEJXDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 19:03:23 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:52222 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbfEJXDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 19:03:22 -0400
Received: by mail-it1-f196.google.com with SMTP id s3so11952700itk.1;
        Fri, 10 May 2019 16:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=e3M6JwX/5Snb9e5vaNrJkKW+5XlxMp1QJjqq/xu5PGw=;
        b=DY8JcaO2bHSD8e2vT7wFYUgOSvhW6RTyg7D6d8RsIGQnqOqFTW7ubMzjlCD4mALCKC
         xjAChOFN01/NwWxWpoFMU+XY3iG3uGes7I9v47LKffI3K9REatNTI6j24YeS5PVOQE6u
         iK5NdtnikaE7v5z+rb0N596OcfDlNK00E8Nup9zgbOrng33UYOr7PkH5aXMyYUq8G3nI
         YkYvvr+DWlQQp5hUJHzz/yBAv1BQHMR6deLwuSQ4cku1ZXdfLHSemDvKTjbiF56BGvdQ
         c528fyMP1Bv7BzffeAE0GhsxXbChLxG2QpmwUzEg0t4qJMMlWDj14OiEsdlebRtEXSmS
         bQ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=e3M6JwX/5Snb9e5vaNrJkKW+5XlxMp1QJjqq/xu5PGw=;
        b=AD2T3aKhMkE26BjpxIY8lMZTkJj/S5eSjKV6GYKU/S2Gi9jHlDwkXSN6zhjD97gjEp
         KBMHIonixdKgQfaZ3tXFw/CNrlBj8XI4rczSf1Q7kWFcto2yWeSz6tjC/+cw++igEoGf
         CsuyjYsdRYcGEmkVEEZU0RZCfATk38Lr89r0PKEQsF5RmPH6xzYnPWvzB3s70og82AvO
         TyksUBp8s8ByIbPSAMtBYdI1rU/8W1gN4Vhbo9mwo+XoYpVeW/XN2EOyBQh8YpmhKtcu
         Dg7Z3+J4ilC9CDaqPxWnTFGtKvd2Oeldq6oKv0C6nMUAZJ50KJ6rG9x8aspUhA77uOgC
         7WpQ==
X-Gm-Message-State: APjAAAWBNiSBjHOv1TqkOwrFuNFe3DEN5oiW765FgtNxRkX+p0VJhkDV
        NvB0Aex89X5Qm3QxTX+zX9M=
X-Google-Smtp-Source: APXvYqyLedsuEFamdFvS/Kal+8aJKxOZZFM3dpWHo4P8rps40QsjhTeTHd0VEbJNxECrq4bUWaYvaw==
X-Received: by 2002:a05:6638:29a:: with SMTP id c26mr9549359jaq.140.1557529401623;
        Fri, 10 May 2019 16:03:21 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y62sm3142674ita.15.2019.05.10.16.03.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 16:03:20 -0700 (PDT)
Date:   Fri, 10 May 2019 16:03:14 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Message-ID: <5cd603329f753_af72ae355cbe5b8e8@john-XPS-13-9360.notmuch>
In-Reply-To: <20190510100054.29f7235c@cakuba.netronome.com>
References: <155746412544.20677.8888193135689886027.stgit@john-XPS-13-9360>
 <155746426913.20677.2783358822817593806.stgit@john-XPS-13-9360>
 <20190510100054.29f7235c@cakuba.netronome.com>
Subject: Re: [bpf PATCH v4 1/4] bpf: tls, implement unhash to avoid transition
 out of ESTABLISHED
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Thu, 09 May 2019 21:57:49 -0700, John Fastabend wrote:
> > @@ -2042,12 +2060,14 @@ void tls_sw_free_resources_tx(struct sock *sk)
> >  	if (atomic_read(&ctx->encrypt_pending))
> >  		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
> >  
> > -	release_sock(sk);
> > +	if (locked)
> > +		release_sock(sk);
> >  	cancel_delayed_work_sync(&ctx->tx_work.work);
> 
> So in the splat I got (on a slightly hacked up kernel) it seemed like
> unhash may be called in atomic context:
> 
> [  783.232150]  tls_sk_proto_unhash+0x72/0x110 [tls]
> [  783.237497]  tcp_set_state+0x484/0x640
> [  783.241776]  ? __sk_mem_reduce_allocated+0x72/0x4a0
> [  783.247317]  ? tcp_recv_timestamp+0x5c0/0x5c0
> [  783.252265]  ? tcp_write_queue_purge+0xa6a/0x1180
> [  783.257614]  tcp_done+0xac/0x260
> [  783.261309]  tcp_reset+0xbe/0x350
> [  783.265101]  tcp_validate_incoming+0xd9d/0x1530
> 
> I may have been unclear off-list, I only tested the patch no longer
> crashes the offload :(
> 

Yep, I misread and thought it was resolved here as well. OK I'll dig into
it. I'm not seeing it from selftests but I guess that means we are missing
a testcase. :( yet another version I guess.

Thanks,
John


> > -	lock_sock(sk);
> > +	if (locked)
> > +		lock_sock(sk);
> >  
> >  	/* Tx whatever records we can transmit and abandon the rest */
> > -	tls_tx_records(sk, -1);
> > +	tls_tx_records(sk, tls_ctx, -1);
> >  
> >  	/* Free up un-sent records in tx_list. First, free
> >  	 * the partially sent record if any at head of tx_list.
> 


