Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B6D18AB2C
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 04:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgCSD3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 23:29:39 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42856 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCSD3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 23:29:38 -0400
Received: by mail-pg1-f195.google.com with SMTP id h8so434024pgs.9
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 20:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tQlJ3NjfplqkMyQMxVBekp3rm26vqmGcdAxC1LUBh9w=;
        b=Z/LTi23X8599QqYsduum93XoZCbF6aAoZdqITodxVhofIeDMXO5IudoV3CyvuCSdZb
         AmuGdND6iQODj0quj7g7CIQj8t5TYq3GYfed5ijrMix2tFYbXB+vfDe4baWFUB0mYU77
         J+Di17Le82m4mOcKLKabIDnlO2lDIKSTFx3Y0HXdsTaKxFLZq4Vc8YZLNdeQYE9TuBJC
         eDAzLyh1ci3xaWMtlBcVXOPdhuMg4ySbI1EQ4LA+oDB2idcajDYVGgM282YrodAcQ+OV
         vaO9/N292ZeguVaqJlR3ipFjv9PQ3nD8fffnJVhHumOEY+qN01Yd8LnHqIXsjQVdHjIB
         41dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tQlJ3NjfplqkMyQMxVBekp3rm26vqmGcdAxC1LUBh9w=;
        b=hyl6zuSuyLkJy+ZRoDu5FzEqXrapjpyfctJqJtXmwJTfbH8Syhg1+r24I7osEGYnUd
         e/8Oy+ZW3Y0/+GRPVpB3K/U5Vo8W+9O2kMSld9vvwbZpp2xxKy7+cMXMPnVPJQdt/F/s
         dBzB5tF1BkuDNBeNVdoZo12iY04iVGsKDIZ7X5NfatFZyNLmSDWkVjS3d281v9aZY4b5
         NX6qk9MflhPNIlyPdJlnwYeCBcmrxqKUqR9a4+b2HJsoV8lbnf8vk8gsVvm5JONKtKpY
         zCFz5z4Df6lsa7ReRzmYZN0tBZ7mI8HwpS8U8FkhsiVmRGiXwdvjpYOKlBR6S218D1h8
         l+iw==
X-Gm-Message-State: ANhLgQ0QoxMYymo+usrngJsxJZBQ8EFssbRR6uXaYG3bq+W96SHqYaJE
        lA0rfYO/laTTG4pPS8GPGE8=
X-Google-Smtp-Source: ADFU+vt39HsKzBphwuiaKKwMxjzFUa/s7HsssUVqlfE7mfwN/YzPQZJld3aOiHyyaCp78OJ0d/oY8g==
X-Received: by 2002:a63:cc13:: with SMTP id x19mr1074838pgf.65.1584588577374;
        Wed, 18 Mar 2020 20:29:37 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g75sm316198pje.37.2020.03.18.20.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 20:29:36 -0700 (PDT)
Subject: Re: [RFC PATCH 24/28] tcp: try to fit AccECN option with SACK
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1584524612-24470-25-git-send-email-ilpo.jarvinen@helsinki.fi>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4ae2c8be-3235-9158-a2a7-7f9d30a20c04@gmail.com>
Date:   Wed, 18 Mar 2020 20:29:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1584524612-24470-25-git-send-email-ilpo.jarvinen@helsinki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/20 2:43 AM, Ilpo Järvinen wrote:
> From: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
> 
> As SACK blocks tend to eat all option space when there are
> many holes, it is useful to compromise on sending many SACK
> blocks in every ACK and try to fit AccECN option there
> by reduction the number of SACK blocks. But never go below
> two SACK blocks because of AccECN option.
> 
> As AccECN option is often not put to every ACK, the space
> hijack is usually only temporary.
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
> ---
>  net/ipv4/tcp_output.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 4cc590a47f43..0aec2c57a9cc 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -756,6 +756,21 @@ static int tcp_options_fit_accecn(struct tcp_out_options *opts, int required,
>  	if (opts->num_ecn_bytes < required)
>  		return 0;

Have you tested this patch ?

(You forgot to remove the prior 2 lines)

>  
> +	if (opts->num_ecn_bytes < required) {
> +		if (opts->num_sack_blocks > 2) {
> +			/* Try to fit the option by removing one SACK block */
> +			opts->num_sack_blocks--;
> +			size = tcp_options_fit_accecn(opts, required,
> +						      remaining + TCPOLEN_SACK_PERBLOCK,
> +						      max_combine_saving);
> +			if (opts->options & OPTION_ACCECN)
> +				return size - TCPOLEN_SACK_PERBLOCK;
> +
> +			opts->num_sack_blocks++;
> +		}
> +		return 0;
> +	}
> +
>  	opts->options |= OPTION_ACCECN;
>  	return size;
>  }
> 
