Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4878F3D6
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731885AbfHOSqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:46:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51770 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbfHOSqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:46:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so2082084wma.1
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 11:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tL/ePi9i7krJpLCHqo/FD7iuSf+sPcaN03XV3p51j0U=;
        b=WGiuvllZnbGFdBo36yZaCkFStgFBgGQ/4E6uMubO/kzXijDDZNKQQmkxjtktOhukSL
         v4JMxvJwsiKMoJrRJMsKfKZWKjC59SrbvWOMWHb0FcI1+biWFfsYW1JbzNg6WCcutH/Q
         I09s94UJr7SHT3WF2QAiAfePe82hVChLMW+Owipg00c3TanxRFaqRr9i/LsdMR1m+e0L
         rWorSm6bFQUc/fk11EoVS41o1Pnrdbup28PzgzyQq46YQrrQr4R+wnsKDzyWYK5jm1ks
         QwdSSNLch265eGdMAXmjPn6yx146InCNdcUED/eIDtWzcyrzXaW/cZq/omFph+M4VmSj
         IwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tL/ePi9i7krJpLCHqo/FD7iuSf+sPcaN03XV3p51j0U=;
        b=X7HIDNTAIjLuCAhunA9P5Ct9JvVzeC/ZrSX14VGYbYdXSymBVVUnhIYgxusd1bUMsf
         DUMMoZtsHlnnXXDuRgMxtqTenE6IenXGmrXs4nlqHOcjEgSkucgHBm79m1c8H2CdvhTI
         m6Ns6U9FHcfqDrCwXWOyPYxENDBb0kLmIPogbnxVjLu/ce1HLgP5f2d/4qTTn5mK2iip
         7phGL2sXpkrpB7oPkOOUeoy8ubPR294z2/bborXurOFS4r3D1xPhgFWJXHYDYnh4R6U1
         xn+2WkcmNK/59wOnMcymZju0n5McEtv8XOyeckqJ0y48p8JLfISvHKoIrD6pkxbZODAW
         4okA==
X-Gm-Message-State: APjAAAVR77fkg0cTJfvYIN1vWVld2ZO1J5lQHN8E+NpatDi88q7Jio8n
        BuLn1ORCthvHe8WQ3J4l5H/7zvKH
X-Google-Smtp-Source: APXvYqwjSmsZ28pJ4x2Maj+c1g8qpgNOodhMFiM6xE/rQQzxJpoWmEEQvgG0CzS18KmkiBVdyxHAaQ==
X-Received: by 2002:a1c:c542:: with SMTP id v63mr3933637wmf.97.1565894764681;
        Thu, 15 Aug 2019 11:46:04 -0700 (PDT)
Received: from [192.168.8.147] (171.170.185.81.rev.sfr.net. [81.185.170.171])
        by smtp.gmail.com with ESMTPSA id e11sm8380058wrc.4.2019.08.15.11.46.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 11:46:03 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] tcp: ulp: add functions to dump ulp-specific
 information
To:     Davide Caratti <dcaratti@redhat.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Watson <davejwatson@fb.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <cover.1565882584.git.dcaratti@redhat.com>
 <f9b5663d28547b0d1c187d874c7b5e5ece8fe8fa.1565882584.git.dcaratti@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <228db5cc-9b10-521f-9031-e0f86f5ded3e@gmail.com>
Date:   Thu, 15 Aug 2019 20:46:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <f9b5663d28547b0d1c187d874c7b5e5ece8fe8fa.1565882584.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/19 6:00 PM, Davide Caratti wrote:

>  
> +	if (net_admin) {
> +		const struct tcp_ulp_ops *ulp_ops;
> +
> +		rcu_read_lock();
> +		ulp_ops = icsk->icsk_ulp_ops;
> +		if (ulp_ops)
> +			err = tcp_diag_put_ulp(skb, sk, ulp_ops);
> +		rcu_read_unlock();
> +		if (err)
> +			return err;
> +	}
>  	return 0;


Why is rcu_read_lock() and rcu_read_unlock() used at all ?

icsk->icsk_ulp_ops does not seem to be rcu protected ?

If this was, then an rcu_dereference() would be appropriate.

