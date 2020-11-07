Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D63E2AA1FA
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 02:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgKGBR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 20:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgKGBR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 20:17:28 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65498C0613CF;
        Fri,  6 Nov 2020 17:17:28 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id 33so3084139wrl.7;
        Fri, 06 Nov 2020 17:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5MYpUKwDwx4KPKOUEurAt6pQF/9di1n9Uzo4SUu5TYo=;
        b=hE81he98WRjj9Xt7Zrbueyf8QyBD44XS9MmFt5hX2mKsiL19yWyr/WLIe8h8zaJVJ+
         shl26K1/S5t8iOaC99DCB6Tl6icdO3B7cuyB7KzrCsn5+RICb45kSm07mJuCf+FOPZ+z
         he0qCABBp48j86EHgTgwgxaqJjZJJnm4HzR+cGTWtfdTrlG8w5HgbF0yjYN3xNabTGtH
         fJWO6YjIJwP7002Wrw+4q1oJcFUSBjf/1dbs3gzitMavq1Y747n+K7BAK668uMzozfBd
         Tz3WV5x07uh1Xbo/LVmaCATP3ENNqWk27+4YAXa7fOSfflC12auFJgNlrmMgZqpvUQpU
         IjhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5MYpUKwDwx4KPKOUEurAt6pQF/9di1n9Uzo4SUu5TYo=;
        b=j0Pej09vhbByrMSS08jyy0mL8K2auLfM6EGiP63mm5VlfHxjh4ulco2S467vAVGlxF
         SSANgI1IAuJ7lEOTEBU9firx5ePIulPDwMFOubm2AQmAM5UySwU6f0put0XPyrPzLua9
         2Iv5gF+hOXMBKjuyqsRK7bDXvCQgKfBenZVkha9h5h+xkb2NBECi/DQquTUmvBgnOn+D
         ubogk5xssRmV4hdDzTm6eSJh5IkEE7oP5RjcFxgpAFsOdu/Kg6YsMxknI6IlnRH2mM6I
         fWClXsydj71jivPeerDxWPG/QSy9uMv8ygZAEuL/EzdhVWrPqz2vwKbsDzz+FCylmUFN
         K48g==
X-Gm-Message-State: AOAM531qjPjKONXO5AP6t1EQ9bukVHYitLVzuhtxIy1p5nXFpMUPI6pu
        B8HRUleGuYYj6ddMBSAYq1ksPIm96KGJsQ==
X-Google-Smtp-Source: ABdhPJypIeUhdbopDn4L/cZqGuJOI7b/ySGRUyehGt45XvuDN7byvlUfElfLTTeswt38QSsatUTv5A==
X-Received: by 2002:adf:ea8f:: with SMTP id s15mr3229175wrm.179.1604711846817;
        Fri, 06 Nov 2020 17:17:26 -0800 (PST)
Received: from [192.168.1.139] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id k18sm4537168wrx.96.2020.11.06.17.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 17:17:25 -0800 (PST)
To:     David Laight <David.Laight@ACULAB.COM>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <0dc67994b6b2478caa3d96a9e24d2bfb@AcuMS.aculab.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 4/9 next] fs/io_uring Don't use the return value from
 import_iovec().
Message-ID: <f95120c1-6f17-24a8-0cf4-666417a5c6c5@gmail.com>
Date:   Sat, 7 Nov 2020 01:14:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0dc67994b6b2478caa3d96a9e24d2bfb@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/09/2020 15:55, David Laight wrote:
> 
> This is the only code that relies on import_iovec() returning
> iter.count on success.
> This allows a better interface to import_iovec().

Seems this got nowhere. I'll pick it and send with some other
patches to Jens.

> Signed-off-by: David Laight <david.laight@aculab.com>
> ---
>  fs/io_uring.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 3790c7fe9fee..0df43882e4b3 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2824,7 +2824,7 @@ static ssize_t __io_import_iovec(int rw, struct io_kiocb *req,
>  
>  		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
>  		*iovec = NULL;
> -		return ret < 0 ? ret : sqe_len;
> +		return ret;
>  	}
>  
>  	if (req->flags & REQ_F_BUFFER_SELECT) {
> @@ -2853,7 +2853,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
>  	if (!req->io)
>  		return __io_import_iovec(rw, req, iovec, iter, needs_lock);
>  	*iovec = NULL;
> -	return iov_iter_count(&req->io->rw.iter);
> +	return 0;
>  }
>  
>  static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
> @@ -3123,7 +3123,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
>  	if (ret < 0)
>  		return ret;
>  	iov_count = iov_iter_count(iter);
> -	io_size = ret;
> +	io_size = iov_count;
>  	req->result = io_size;
>  	ret = 0;
>  
> @@ -3246,7 +3246,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
>  	if (ret < 0)
>  		return ret;
>  	iov_count = iov_iter_count(iter);
> -	io_size = ret;
> +	io_size = iov_count;
>  	req->result = io_size;
>  
>  	/* Ensure we clear previously set non-block flag */
> 

-- 
Pavel Begunkov
