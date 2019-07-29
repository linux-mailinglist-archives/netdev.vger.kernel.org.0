Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCFEE79388
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 21:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbfG2TD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 15:03:58 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41699 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfG2TD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 15:03:57 -0400
Received: by mail-qk1-f194.google.com with SMTP id v22so44828759qkj.8;
        Mon, 29 Jul 2019 12:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=P8PKbj5/kVJRE77VGyx4tqM3teDWFVy4oqqQvsX6TPg=;
        b=j7Vcz5YhzBinJwVxgDGSMRwVTQkEGE1HV5EcHjmfuRwYF0HK8IlLg8lNN9JiuGkl5w
         7Iky5h9OxoqdhPsgZPNIbiu5ycgAw7idsgSwCH9zuB2A/uwDG6WX0X+4QRdZfkkRt8ar
         eeriZhW3ME/SRnOfrEOc2zEVPvxNXenqyeHQQxekBw1Y+lBiku5MUF07p+7ShEZAVtWV
         uo7EQQlVGJ4//Q2lzuu4Wo7P6QcNZfqCZAJzEkBNf1wjOaNjPDlwVYTP7gAa8lYfB2r6
         C+K8QfiU126ZolHuiX4cz0XlPsG3Bi26CvR4ub209SDAOPWf98T0/dNhAx9owwgC8Fxv
         lZkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=P8PKbj5/kVJRE77VGyx4tqM3teDWFVy4oqqQvsX6TPg=;
        b=BUB6ei0I0bJAe+3jPOhwqyQm62wP9Qmj7uX1UX0ME+s+6+qTuSUbK1upkZfLLEwoll
         quPFdZFaXDDy+JMOvZjoZ0mUcG5MEgtKVKyTDKWbuLlsVGrnG5L8Uv/rESLfojmNmN6l
         f/unCoi5SB8WsW2nsIYaMZNl1rATuMIhPkfn/5GjUv14U5tmSCf4dNSloLdrCXWLprXz
         4/nq0mUA3TZnK1h+v27p8iY9j7mt40nD+bZ/vt0JKMpQgJOoKll7cXCVFck2WHZfvnK4
         slXQ5ZTaNCqX6iX+VUFiTvC78lTBwH58fAPcEbzOLCMHgvRD0u7YwpW+b4nL4TXSvGIo
         pDqw==
X-Gm-Message-State: APjAAAW9k8HN5tp20PA1Vb/BVzs/SDg9GkLkxzdDQG/JfTyo/1eWkTrC
        R5RXbBIwU2EvzaqqW3oIlas=
X-Google-Smtp-Source: APXvYqy7eUQofVXEvopk+EJ3UTpDUvbii8+tkBox0yvO+aP7gKU5xUX3zpdmeVRPSJsuUn8OqKR9lw==
X-Received: by 2002:a37:270a:: with SMTP id n10mr75124045qkn.434.1564427036466;
        Mon, 29 Jul 2019 12:03:56 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:a0af:c6c5:7c31:69b:3f23])
        by smtp.gmail.com with ESMTPSA id r4sm41553650qta.93.2019.07.29.12.03.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 12:03:55 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 0BCA7C1628; Mon, 29 Jul 2019 16:03:53 -0300 (-03)
Date:   Mon, 29 Jul 2019 16:03:52 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, vyasevich@gmail.com,
        nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: sctp: drop unneeded likely() call around IS_ERR()
Message-ID: <20190729190352.GD4064@localhost.localdomain>
References: <1564426521-22525-1-git-send-email-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564426521-22525-1-git-send-email-info@metux.net>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 08:55:21PM +0200, Enrico Weigelt, metux IT consult wrote:
> From: Enrico Weigelt <info@metux.net>
> 
> IS_ERR() already calls unlikely(), so this extra unlikely() call
> around IS_ERR() is not needed.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/socket.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index aa80cda..9d1f83b 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -985,7 +985,7 @@ static int sctp_setsockopt_bindx(struct sock *sk,
>  		return -EINVAL;
>  
>  	kaddrs = memdup_user(addrs, addrs_size);
> -	if (unlikely(IS_ERR(kaddrs)))
> +	if (IS_ERR(kaddrs))
>  		return PTR_ERR(kaddrs);
>  
>  	/* Walk through the addrs buffer and count the number of addresses. */
> @@ -1315,7 +1315,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
>  		return -EINVAL;
>  
>  	kaddrs = memdup_user(addrs, addrs_size);
> -	if (unlikely(IS_ERR(kaddrs)))
> +	if (IS_ERR(kaddrs))
>  		return PTR_ERR(kaddrs);
>  
>  	/* Allow security module to validate connectx addresses. */
> -- 
> 1.9.1
> 
