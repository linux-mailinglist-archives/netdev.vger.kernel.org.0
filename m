Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95B2724365
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 00:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfETWQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 18:16:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46380 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfETWQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 18:16:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id t187so7419398pgb.13
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 15:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tEoVQdb6fp8qHDlC6u8Bjfj5++aRFLMTJay+DT6aDbU=;
        b=ZP7OMEM6Qj7AdJwHCmVHVtJxdO6evXw7rLNbqQRS8ym87KrYq90Jc2xF1R+4MT1FQn
         9Vbl+vQTMEUTLz4J5Gw78RcSweSqt2BSwbbdJa07Mb2aDcvyGLZXO0KlMUY+Hvr6Tkrv
         bLM1wtalDPiLu3A5J68WOooDKzb488KlhBCQQXeulaeAMkLQNSaq+kJD1z7T8qoaCUwr
         QwioeNN60Tt1++JsF2+wQywgFfZQIOuApQIbsbfE8YmGlYLNu+slk4jAj1z2mYbI5Z8t
         u/70SYsNVDWnqEstY58Pmilx7EcTn8v3Mv8PWeYDYEePiAsqIiZsEjoM+ASZVDGbZs1b
         Gerg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tEoVQdb6fp8qHDlC6u8Bjfj5++aRFLMTJay+DT6aDbU=;
        b=NymScysHEda/T4yaskqqCsLP+BuMRxaQJtaLH2+bKsnLCk2Po0PpLO2RD/dowvhh3K
         iay6VFpBF0/Quh7LLDWkM2rkxvj4Kv9KpBY1wwSF/ROLF7D+gFaxLj6mm2TD1AxN6lqG
         Y97mCPJuYyN3Mps8TO+K0Y3MkXGslwn7T/XDj8gDq4pH5zAoT4sVG+Vn6slXVrHRW9lK
         RkUZWD0R54gza+4/uZEeY41Cexs5VJU0bRZHWSOhyTldRgcuOsc3XdNdx8LvZDucZiyJ
         k+C530gfOEqTNTbvW1D81+gdEEjIwOYoZtILpgq2gGMZMeQ0Sii1iH0WTfpTmkXoPaTT
         drjw==
X-Gm-Message-State: APjAAAVMMswTgeYNULNhK8hx0ayKMMc5XI0wQDYNwzHSuIuJU7foP+p0
        8t2kharUWpUZ5q/btNwHbR0oi4VB
X-Google-Smtp-Source: APXvYqz/+c8xoQoX0v57R8bLSyNhL63QBzNamWBoe7meyj+1Wq8hcWKTdZWSSixemOQASry+I1EV2w==
X-Received: by 2002:a63:1045:: with SMTP id 5mr33744809pgq.55.1558390583793;
        Mon, 20 May 2019 15:16:23 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:4813:9811:27e6:a3ed? ([2601:282:800:fd80:4813:9811:27e6:a3ed])
        by smtp.googlemail.com with ESMTPSA id p7sm18498741pgb.92.2019.05.20.15.16.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 15:16:22 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: Consider sk_bound_dev_if when binding a raw
 socket to an address
To:     Mike Manning <mmanning@vyatta.att-mail.com>, netdev@vger.kernel.org
References: <20190520185717.24914-1-mmanning@vyatta.att-mail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8b6e12cf-08b7-d625-325e-ffacf3db7f26@gmail.com>
Date:   Mon, 20 May 2019 16:16:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190520185717.24914-1-mmanning@vyatta.att-mail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/19 12:57 PM, Mike Manning wrote:
> IPv6 does not consider if the socket is bound to a device when binding
> to an address. The result is that a socket can be bound to eth0 and
> then bound to the address of eth1. If the device is a VRF, the result
> is that a socket can only be bound to an address in the default VRF.
> 
> Resolve by considering the device if sk_bound_dev_if is set.
> 
> Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
> ---
>  net/ipv6/raw.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
> index 84dbe21b71e5..96a3559f2a09 100644
> --- a/net/ipv6/raw.c
> +++ b/net/ipv6/raw.c
> @@ -287,7 +287,9 @@ static int rawv6_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
>  			/* Binding to link-local address requires an interface */
>  			if (!sk->sk_bound_dev_if)
>  				goto out_unlock;
> +		}
>  
> +		if (sk->sk_bound_dev_if) {
>  			err = -ENODEV;
>  			dev = dev_get_by_index_rcu(sock_net(sk),
>  						   sk->sk_bound_dev_if);
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
