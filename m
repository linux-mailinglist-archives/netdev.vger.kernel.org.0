Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C34EB19ED7
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 16:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbfEJOQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 10:16:52 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39643 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727735AbfEJOQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 10:16:52 -0400
Received: by mail-io1-f66.google.com with SMTP id m7so4615995ioa.6
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 07:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=EtV7zGR2Lqfl9fVXxtZpvXI5XZeauhproMy8rGXW3QU=;
        b=VkjfV6nKmOz6zF5B1jOnWqpNEY8EOkhY1eIFWfLy6IyMXB6hACR6EkvlEGYHoKull1
         xexOmZnOhwh8SI1DLmIXkNhBIoLTxwfp+Bh6LHDyUJEC1xepjykmUVw6L37kGS4T4eJO
         AQK0SXZpuFZrAywl/rMBheRUorEW38XDvPtIMZtOIbB7TmPbm+ntIJenita6zzvu5El2
         8MXPY/dzWlqRmKwkW+ZpO3rw05VNopghi+V1IDPwNFh4igq5Ws0kArP3uSUUOm3gOmYt
         wFtx21ZY3FxWEU8gXXta/ffb5P5MUNaI3wygcj1jAjpd61X8GoEKrFz4VM8uV7LSwDpg
         0dYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=EtV7zGR2Lqfl9fVXxtZpvXI5XZeauhproMy8rGXW3QU=;
        b=fSv2IoVt3F1FNR+/O/evry0YQLXBM69qWPvNeSQz7rpOz8ej/7YOpC8IKvmv4XCHnE
         fKnpGHFEzh9/QMnHU/3zOrw4hJBZyn6ExbLL8pzjWx19GpoVX4MVQIe/mTuOGAa6KLvV
         0A5yoxiea2eHmZfJlJISmx5og0ujBj6D9j/7cxy7WqXYqA5FGEne/xZHzAghXtbTaND8
         vAPzXNkK6mGtUpyXNxfVxMEU9BGr6WegRKS9rZKhodRMLmSqDkKRdvLzn73JvWv8Az+k
         QRBrF6MKfGb7eAtI+UWBF8jod1LxsCx03VwT/ZNLG3tPOhyBumGBKpdf072Eis9Kadeq
         5+PQ==
X-Gm-Message-State: APjAAAV1jHyLmBg4MGg4MDF0ntf2Lb7V4JJOo4KkK3OVN2ACCjs2p0No
        YRUL3mbIYRGqwesIa+wkF/f0+It2CoA=
X-Google-Smtp-Source: APXvYqwZURqp8ydoCzt1ygY3C5vmRVyPGwI6b67KOnzrAyCzCi/qW4IN5sZbIHtvVNRKJ2+w77ronQ==
X-Received: by 2002:a5d:85d9:: with SMTP id e25mr6686346ios.26.1557497811878;
        Fri, 10 May 2019 07:16:51 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b10sm1778002iok.62.2019.05.10.07.16.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 07:16:51 -0700 (PDT)
Date:   Fri, 10 May 2019 07:16:44 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dave Watson <davejwatson@fb.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Message-ID: <5cd587cc179c0_61292af501ab05c4ae@john-XPS-13-9360.notmuch>
In-Reply-To: <20190509231407.25685-3-jakub.kicinski@netronome.com>
References: <20190509231407.25685-1-jakub.kicinski@netronome.com>
 <20190509231407.25685-3-jakub.kicinski@netronome.com>
Subject: RE: [PATCH net 2/2] net/tls: handle errors from padding_length()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> At the time padding_length() is called the record header
> is still part of the message.  If malicious TLS 1.3 peer
> sends an all-zero record padding_length() will stop at
> the record header, and return full length of the data
> including the tail_size.
> 
> Subsequent subtraction of prot->overhead_size from rxm->full_len
> will cause rxm->full_len to turn negative.  skb accessors,
> however, will always catch resulting out-of-bounds operation,
> so in practice this fix comes down to returning the correct
> error code.  It also fixes a set but not used warning.

In practice returning incorrect error codes to users can confuse
applications though so this seems important. I've observed apps
hang with wrong codes for example and this error seems to be pushed
all the way up to sw_recvmsg.

> 
> This code was added by commit 130b392c6cd6 ("net: tls: Add tls 1.3 support").
> 
> CC: Dave Watson <davejwatson@fb.com>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> ---

Looks good to me but one question below,

>  	/* After using skb->sk to propagate sk through crypto async callback
> @@ -1478,7 +1488,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
>  	struct tls_prot_info *prot = &tls_ctx->prot_info;
>  	int version = prot->version;
>  	struct strp_msg *rxm = strp_msg(skb);
> -	int err = 0;
> +	int pad, err = 0;
>  
>  	if (!ctx->decrypted) {
>  #ifdef CONFIG_TLS_DEVICE
> @@ -1501,7 +1511,11 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
>  			*zc = false;
>  		}
>  
> -		rxm->full_len -= padding_length(ctx, tls_ctx, skb);
> +		pad = padding_length(ctx, prot, skb);
> +		if (pad < 0)
> +			return pad;
> +

Need to review a bit closer on my side, but do we need to do any cleanup
if this fails? It looks like the other padding_length call sites will
but here we eventually return directly to recvmsg.

> +		rxm->full_len -= pad;
>  		rxm->offset += prot->prepend_size;
>  		rxm->full_len -= prot->overhead_size;
>  		tls_advance_record_sn(sk, &tls_ctx->rx, version);
> -- 
> 2.21.0
> 


