Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04AE445DCF
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 03:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbhKECLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 22:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhKECLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 22:11:21 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1971EC061714;
        Thu,  4 Nov 2021 19:08:43 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id u1so11382930wru.13;
        Thu, 04 Nov 2021 19:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=G7p3eOuyEP7P+5SWAUtBhjcxOrwbMlR3hzNOptyZbA0=;
        b=IhRaPGPTa0Jq3iIOcXz9/JXOprUzK8DqDoOx5denLiUjptwj8/xLn0hta0XM0v0huY
         /QxlgAOlv1ZjWed0HDnlQoh2ESmisDJRm/0U2D9ml9Fw3GLkDvJowHiGw6aVh/x9QrYD
         C7I9Q+/Jpg/Kuw1QKheqT1ENR6jue0hnbE7JFxs9ybiohII2nS/dLTr4IECH5gUDNmWo
         0JShhxbc1kniPMH5ldiPE7ntLeUop/CkFJoXgHawHt6tz5oNQ/k01qZL00AWZXo6yIt3
         O/aeVM9LaQJ6mXHtks6yk9/POvvwv4lTeHRBu2VGA5R67KW58kNU0gY76G4R+aFa54mX
         jbpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G7p3eOuyEP7P+5SWAUtBhjcxOrwbMlR3hzNOptyZbA0=;
        b=w1Ap5emnC3gFKGp6aecKlLhGdTo4LIF5Kp39D1gd9gBJoY6K1t2WKawHOJStKK5ANk
         vaNvzcSsSXEErWaThxEQe2NBSJv9cfXZqGfHRq7Zp5PPGNkZCBBYSbIj1alQK8PJzcPn
         R38oyQV5gNI7DmcEXWEGzg/tN5SD6ZkzX+nKxrc47+tTajIRtC/h9vhgmAHFk7B7fX6J
         yF9+4w3Ex8+7JJj8dHhj9Tc52K5GxoDesV9a45Haw/BxV8OHDl2sRIbsBVmxXmz0z4c6
         iTCVZyCYbtRnjv2igL+js6g7nVQ25bjRxUq0wTfzdojQ8ajTPBc/8LoJNuRTuihsLU/A
         0QKw==
X-Gm-Message-State: AOAM531KpGRUp8oK8AKCKEYrhkCC6Cpc4LU8rCN1tSpi1OrQA6IQlNir
        utDwNb1uoDvxMgamHODBiP4=
X-Google-Smtp-Source: ABdhPJwpTipJXleSQHRC7vbUYDE69iJq9tdFx60i8nBEEQca7rflWerJjT27oEqn4pfEMs5EGZBDHQ==
X-Received: by 2002:adf:df0b:: with SMTP id y11mr45201713wrl.181.1636078121738;
        Thu, 04 Nov 2021 19:08:41 -0700 (PDT)
Received: from ?IPV6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c79sm6826731wme.43.2021.11.04.19.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 19:08:41 -0700 (PDT)
Message-ID: <7a32f18e-aa92-8fd8-4f53-72b4ef8b0ffc@gmail.com>
Date:   Fri, 5 Nov 2021 02:08:40 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 06/25] tcp: authopt: Compute packet signatures
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
References: <cover.1635784253.git.cdleonard@gmail.com>
 <5245f35901015acc6a41d1da92deb96f3e593b7c.1635784253.git.cdleonard@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
In-Reply-To: <5245f35901015acc6a41d1da92deb96f3e593b7c.1635784253.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 16:34, Leonard Crestez wrote:
[..]
> +/* Find TCP_AUTHOPT in header.
> + *
> + * Returns pointer to TCP_AUTHOPT or NULL if not found.
> + */
> +static u8 *tcp_authopt_find_option(struct tcphdr *th)
> +{
> +	int length = (th->doff << 2) - sizeof(*th);
> +	u8 *ptr = (u8 *)(th + 1);
> +
> +	while (length >= 2) {
> +		int opcode = *ptr++;
> +		int opsize;
> +
> +		switch (opcode) {
> +		case TCPOPT_EOL:
> +			return NULL;
> +		case TCPOPT_NOP:
> +			length--;
> +			continue;
> +		default:
> +			if (length < 2)
> +				return NULL;

^ never true, as checked by the loop condition

> +			opsize = *ptr++;
> +			if (opsize < 2)
> +				return NULL;
> +			if (opsize > length)
> +				return NULL;
> +			if (opcode == TCPOPT_AUTHOPT)
> +				return ptr - 2;
> +		}
> +		ptr += opsize - 2;
> +		length -= opsize;
> +	}
> +	return NULL;
> +}

Why copy'n'pasting tcp_parse_md5sig_option(), rather than adding a new
argument to the function?

Thanks,
            Dmitry
