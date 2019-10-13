Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4146D57D1
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 21:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbfJMTaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 15:30:46 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46401 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729374AbfJMTaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 15:30:46 -0400
Received: by mail-pl1-f196.google.com with SMTP id q24so7003362plr.13;
        Sun, 13 Oct 2019 12:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uyjdEwimTjVOCGshMlFmT1B3OesvQtAg++QzCdP/Y+8=;
        b=alPvi028vLTX4CIZW9AH89t+YAL9PIvpj9zKUmOR9HfiTIpC0Cj3HEkG0JIZcloqQ+
         hgM4x/lmrBPtS+RX4MePUuncXFTKCj3JDKj7c/SMNmL5i+z7JNJtbhNzJZJIUKhkuvK5
         ZkkrDop46L6UV9+FIlOZNBeWikV4Ihu9Xy1hgZmVDktImNi857fN1PMU5+Epk8UzeNiq
         7TJwvnfBlPlFdjBV/RNLkphrYOoEBStvlrocbdA1VoXrbezl0Dx8XAJpdjIfPeMAHbTk
         QGTRcoNGszfxe5XR4aJUU80ZjjQI58HY4fi6TrHvEWv1pxnDpgA56R9LqDyMUcVN/OeO
         Ldfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uyjdEwimTjVOCGshMlFmT1B3OesvQtAg++QzCdP/Y+8=;
        b=pZQ7cL+u2jNqhiQlIAB3la7Zd3dRL6HuuP5oumM4EF9U80I6dmeyu1xwlHT7uOKve7
         X73nmEiO4ityMfkYBKQKOGsDmOoHDQZYdPhFbB4LcU6brX8iqhmAw0fkbxeMWbqvI3Qp
         DkDuYZbN8WtV/9cQ7e8pMgYoZrtYX3uCC38MfhSSRjb51790azY2fDCtfVlaMSEqVN6/
         jqkYP73OJhFtD9Tt9E14U6Pq/ywJgS1wVkoKyFY4d8Bm7a7xK//jL7v7pcNFUHKJZ+cQ
         CRUU7OSl9vteszJfm8Pa89KHHVttcTWh5+1CXj8+C/q7agnnSNUwUO5CVuOYNSLGaaVy
         6vKw==
X-Gm-Message-State: APjAAAWnjto2OEzCGdacYd5T7vPk48AdRnuSFV4kNIIumNYFsbqQ9DDA
        y+YDbBbEg1NZAcnBHAoSVnlMWhXf
X-Google-Smtp-Source: APXvYqxTqzK55ewzRMAlIg0czwHzQO+WyAXHg57a9mwSE65cYaNa6WOyG8bx2/wNskSxp0SYTwkOLQ==
X-Received: by 2002:a17:902:fe91:: with SMTP id x17mr25780521plm.114.1570995044960;
        Sun, 13 Oct 2019 12:30:44 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id q6sm18145350pgn.44.2019.10.13.12.30.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2019 12:30:42 -0700 (PDT)
Subject: Re: [PATCH] net: core: datagram: tidy up copy functions a bit
To:     Vito Caputo <vcaputo@pengaru.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191012115509.jrqe43yozs7kknv5@shells.gnugeneration.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8fab6f9c-70a6-02fd-5b2d-66a013c10a4f@gmail.com>
Date:   Sun, 13 Oct 2019 12:30:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191012115509.jrqe43yozs7kknv5@shells.gnugeneration.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/19 4:55 AM, Vito Caputo wrote:
> Eliminate some verbosity by using min() macro and consolidating some
> things, also fix inconsistent zero tests (! vs. == 0).
> 
> Signed-off-by: Vito Caputo <vcaputo@pengaru.com>
> ---
>  net/core/datagram.c | 44 ++++++++++++++------------------------------
>  1 file changed, 14 insertions(+), 30 deletions(-)
> 
> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index 4cc8dc5db2b7..08d403f93952 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -413,13 +413,11 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
>  					    struct iov_iter *), void *data)
>  {
>  	int start = skb_headlen(skb);
> -	int i, copy = start - offset, start_off = offset, n;
> +	int i, copy, start_off = offset, n;
>  	struct sk_buff *frag_iter;
>  
>  	/* Copy header. */
> -	if (copy > 0) {
> -		if (copy > len)
> -			copy = len;
> +	if ((copy = min(start - offset, len)) > 0) {

No, we prefer not having this kind of construct anymore.

This refactoring looks unnecessary code churn, making our future backports not
clean cherry-picks.

Simply making sure this patch does not bring a regression is very time consuming.
