Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1217111E5D
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 00:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbfLCXBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 18:01:34 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40256 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730383AbfLCWz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 17:55:56 -0500
Received: by mail-lj1-f195.google.com with SMTP id s22so5743077ljs.7
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 14:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Cr74USMS7o2KnmyixbloqBJA2JGrzMyz1VPBNGaTjTU=;
        b=pUTeoB/B/c7n3sIbM6o9Y00LsAXCHxNwVMJsa5upgXV/7QLVLHgYcPEKzWZ766NjXa
         314xWdi15XbJovZ/FUWSw6LpC7GnkQNQoiJRjh5YkZ7bJrg1Gw38Ysbf5Sho5KU/Z3xx
         y+V5eeKP/jqO92i8+wC22UvLXbMbNZ4XncW05NyjNTXMYqy7aQMiRIR++55pL7H1Vwne
         IIpZWLD4l/XYwJ0qAg1FuOI7mFNe2o5wG7yVegvndufwPB4AdXa759iMmJOFdo1OWazz
         f4AuMBIwHpWm6y4h2vZzmI3aVgRqskwy/M7T/ebOHfDfaEuGEDniAaxF/R1jHY/KnAVA
         1uuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Cr74USMS7o2KnmyixbloqBJA2JGrzMyz1VPBNGaTjTU=;
        b=VMYdLlkrV4QuYrPI5FaUbG2d58BZzeoKtnDKkTC6ZX0ZgRE6HEnjIfifxX8mccE4vR
         yRGjFZHUk52thiHxy8qA43mgu3i1qrGQvSwybXUeN+goEPFMlWvRUl3C3kfBSAu1IoII
         n92cBuE3JrzKtPO0Xu1yim8GGDV6xpGwSkKdWD1SSg6PZ22m5qGYautWjUSEyF8cjP43
         OyCwcCv0u6AOdbCtswik7G1v/CUwjYaWa5P64WWyxpk9XXuKOqO07s0WCLPMv9/C/97s
         NK0NpLyNmw+q9apaOvWQdnX6h0iyP0riE0OERyihtYIVhUjt6P0BZvck60Ye4zYaaLqT
         8r0A==
X-Gm-Message-State: APjAAAVnytVDSblqAFdqSotV8HF9kxp0HCovx5F32dH78IewI9mRB05x
        CWZ03LnMei+K4lPQa20aZbE8HA==
X-Google-Smtp-Source: APXvYqxe7JZN3BlGibb97rF9j+EpiLYaGeW5+ag63tvVfeiJ3KxIvN+5YbyLiPNAZ+HVcLqWQGc77A==
X-Received: by 2002:a2e:2c0a:: with SMTP id s10mr25415ljs.193.1575413754281;
        Tue, 03 Dec 2019 14:55:54 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h14sm91779lfc.2.2019.12.03.14.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 14:55:54 -0800 (PST)
Date:   Tue, 3 Dec 2019 14:55:35 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Valentin Vidic <vvidic@valentin-vidic.from.hr>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/tls: Fix return values for setsockopt
Message-ID: <20191203145535.5a416ef3@cakuba.netronome.com>
In-Reply-To: <20191203224458.24338-1-vvidic@valentin-vidic.from.hr>
References: <20191203224458.24338-1-vvidic@valentin-vidic.from.hr>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Dec 2019 23:44:58 +0100, Valentin Vidic wrote:
> ENOTSUPP is not available in userspace:
> 
>   setsockopt failed, 524, Unknown error 524
> 
> Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>

I'm not 100% clear on whether we can change the return codes after they
had been exposed to user space for numerous releases..

But if we can - please fix the tools/testing/selftests/net/tls.c test
as well, because it expects ENOTSUPP.

> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index bdca31ffe6da..5830b8e02a36 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -496,7 +496,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
>  	/* check version */
>  	if (crypto_info->version != TLS_1_2_VERSION &&
>  	    crypto_info->version != TLS_1_3_VERSION) {
> -		rc = -ENOTSUPP;
> +		rc = -EINVAL;
>  		goto err_crypto_info;
>  	}
>  
> @@ -723,7 +723,7 @@ static int tls_init(struct sock *sk)
>  	 * share the ulp context.
>  	 */
>  	if (sk->sk_state != TCP_ESTABLISHED)
> -		return -ENOTSUPP;
> +		return -ENOTCONN;
>  
>  	/* allocate tls context */
>  	write_lock_bh(&sk->sk_callback_lock);

