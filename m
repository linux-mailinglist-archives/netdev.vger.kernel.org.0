Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 410701A0F5
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 18:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfEJQGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 12:06:35 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40096 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbfEJQGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 12:06:35 -0400
Received: by mail-qt1-f196.google.com with SMTP id k24so2219581qtq.7
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 09:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=QlEbz1UU6RimL/g44BhPuE7AbiMAwgftKU2T1TcTDq4=;
        b=VE0bOgo1VRq3HRsM8afxXruMVSbWJNxNKvC4zIVq5pE8ijg+NFWZR7DmkMqPsv8Cdd
         5wSOClNF/Bx7ZJ9QDKi63Ka4kCQXbMLNKMrwDP0yDlgCIXX9YJ4m8swS05JM2qoIQz6j
         cIOu5g0kdx3Y0pgofjOq3CIXxnvTTnS5W/kjbkA42p2UqRNhGPYaaUTAXshgQ7tOYNxK
         kX+nm74VVZU9NYEWTLXUErDoA5e68tlqZxlYLFjDUISrNiRbcCIgd1fnLwKcOl0SHEhg
         ecesQgP8FD+ZwPNhadDrtmHfONUxBAI9BNAM7ximUeAXxyvD+KBeRnGNotePJg2W+JSa
         T0QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QlEbz1UU6RimL/g44BhPuE7AbiMAwgftKU2T1TcTDq4=;
        b=XpNrTV6ek6fjMA8ik5YBOpJ5bffM8pU2KSyHRmv3RBcX4rsdawuf17MSiuifJreuqN
         Chj5nI4DSZtF8OkGfE8lZSwH3kGkVWeETov7XfWyCj/xjaLUXXajskm108UBNyIlXaGs
         r4HOZNSTQBXwI+1i/C5iTJuQdVZKWVfzxBCNeo3Jh4GMzmjjerRCt1BAZem1SOayF4La
         d1yzVzNrf7SvCAt3IWxu9fG6mFV0yWgx6y4JpIuor/pwQSrKLmf9Iw5614vacsMHY/IQ
         xTZ4+Q0cR+Jb5NWWUKePz9Bnr37q/DlfDbJfoYRbo0ZVbhO+SjkR3IZPRTht2KJF36n7
         WdRA==
X-Gm-Message-State: APjAAAUy9R8UeYhykt8+Cyeq1QdghqAyIsiaKVfPQkGIm2rEZEzFLAFi
        kM/jC6h8gZRFNrXdSpJiJLPq/w==
X-Google-Smtp-Source: APXvYqzrQxl2Ej8R+kD6SfM9t67Ocp5SQ2SjOJ9YRuGIpi7r0hFf8DKXVbzslX8wbU/V9trysS3RWg==
X-Received: by 2002:ac8:2e38:: with SMTP id r53mr10256693qta.192.1557504394290;
        Fri, 10 May 2019 09:06:34 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e37sm4055278qte.23.2019.05.10.09.06.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 10 May 2019 09:06:34 -0700 (PDT)
Date:   Fri, 10 May 2019 09:06:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Dave Watson <davejwatson@fb.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: Re: [PATCH net 2/2] net/tls: handle errors from padding_length()
Message-ID: <20190510090619.6ce8d85c@cakuba.netronome.com>
In-Reply-To: <5cd587cc179c0_61292af501ab05c4ae@john-XPS-13-9360.notmuch>
References: <20190509231407.25685-1-jakub.kicinski@netronome.com>
        <20190509231407.25685-3-jakub.kicinski@netronome.com>
        <5cd587cc179c0_61292af501ab05c4ae@john-XPS-13-9360.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 May 2019 07:16:44 -0700, John Fastabend wrote:
> Jakub Kicinski wrote:
> > At the time padding_length() is called the record header
> > is still part of the message.  If malicious TLS 1.3 peer
> > sends an all-zero record padding_length() will stop at
> > the record header, and return full length of the data
> > including the tail_size.
> > 
> > Subsequent subtraction of prot->overhead_size from rxm->full_len
> > will cause rxm->full_len to turn negative.  skb accessors,
> > however, will always catch resulting out-of-bounds operation,
> > so in practice this fix comes down to returning the correct
> > error code.  It also fixes a set but not used warning.  
> 
> In practice returning incorrect error codes to users can confuse
> applications though so this seems important. I've observed apps
> hang with wrong codes for example and this error seems to be pushed
> all the way up to sw_recvmsg.
> 
> > 
> > This code was added by commit 130b392c6cd6 ("net: tls: Add tls 1.3 support").
> > 
> > CC: Dave Watson <davejwatson@fb.com>
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> > ---  
> 
> Looks good to me but one question below,

Thanks for the reviews!

> >  	/* After using skb->sk to propagate sk through crypto async callback
> > @@ -1478,7 +1488,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
> >  	struct tls_prot_info *prot = &tls_ctx->prot_info;
> >  	int version = prot->version;
> >  	struct strp_msg *rxm = strp_msg(skb);
> > -	int err = 0;
> > +	int pad, err = 0;
> >  
> >  	if (!ctx->decrypted) {
> >  #ifdef CONFIG_TLS_DEVICE
> > @@ -1501,7 +1511,11 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
> >  			*zc = false;
> >  		}
> >  
> > -		rxm->full_len -= padding_length(ctx, tls_ctx, skb);
> > +		pad = padding_length(ctx, prot, skb);
> > +		if (pad < 0)
> > +			return pad;
> > +  
> 
> Need to review a bit closer on my side, but do we need to do any cleanup
> if this fails? It looks like the other padding_length call sites will
> but here we eventually return directly to recvmsg.

Please double check my thinking, but not as far as I could tell.  
At this point we must have a decrypted frame, meaning no async
operation can be in progress on this skb.  And since the error 
will kill the connection, we don't have to worry about advancing
the record sequence number etc.

> > +		rxm->full_len -= pad;
> >  		rxm->offset += prot->prepend_size;
> >  		rxm->full_len -= prot->overhead_size;
> >  		tls_advance_record_sn(sk, &tls_ctx->rx, version);
> > -- 
> > 2.21.0
> >   
