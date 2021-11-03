Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED596443B73
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbhKCCma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhKCCm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 22:42:29 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D428C061714;
        Tue,  2 Nov 2021 19:39:54 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id w29-20020a056830411d00b0055abaca9349so1529670ott.13;
        Tue, 02 Nov 2021 19:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xvmUh+kq0qTw+qHqGvn2Q3Zzs548+5cTf9/0rb+MLBg=;
        b=J20RSSX8JCBK5BS5hTCLpLsYV8WHE2ZeTA8iSflgoS8iGa17seKc8DdIt6mpWT3qtX
         5s4O6TEPY/KAZ7pwTLRyprD5mrxQ2etlcuPjxIH50HjPw5ASImHvkdt+LptDJSoihK6M
         +KPkR/peMqvzrxhoSyu62snNPf1NUKh2n3TG8WYURCiPx9kP5XgWp7uozwjqtjezrxXC
         iy5ukKJi809VPxDd1sF4FOgoYjsqCNoy/p3j4tAUWcl/4H/nyj+TBjcVFC5bcULuUOWn
         rGB6zNonvoixk53xlXieUtklibMCzCiS8aaWKb4l8OMS/aDZbR2wvOsGK+acFa4xQYO8
         CVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xvmUh+kq0qTw+qHqGvn2Q3Zzs548+5cTf9/0rb+MLBg=;
        b=u9diKYsNpIBqCYLVqu1M7eyj/cXUMIgpfrLO0g3tt4EKDgz3ed8W3F+dzoSg0rVGXv
         DvinfDfLXhoNWNUHVQsRpcErfsgc/kwN4oyMzGz6Z5fARb9TBy6F6VTa/82zDprXc7Ka
         14R0ZRron1eNYuKRMxUfOCBVVTtYuvD5B0jzRAjtPebETHIvSF7seNqID6JDHv+m4LMH
         auDL037ayIaW8HxJ65kzbyYDMTinYprIsY7chJbcnYZnqTBcAZYR7MKp2TPh0tOsGDGm
         S/2gCJzkZq5KlkjAQSTA6jSNbI++rAaePBLSGyPU8DdTtMvua4YUCUakuL4wC0S+cCPI
         TxAw==
X-Gm-Message-State: AOAM532ZHdyNOeWuvkvqLRJgBp8NBqrTmfXfLQO4v3wWHsF9UGSCzrN9
        BKpoj4lHDPWwZsPsayJOC5g=
X-Google-Smtp-Source: ABdhPJz4tKMQ1MjNEIG7ggL1zNJpch1g4/PBFmNyxqIjP4oWUPpngevfdi8k5NcR3AKhb6kaSbEAeA==
X-Received: by 2002:a9d:4c11:: with SMTP id l17mr3801606otf.289.1635907193676;
        Tue, 02 Nov 2021 19:39:53 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id 64sm210982otm.37.2021.11.02.19.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 19:39:53 -0700 (PDT)
Message-ID: <019e96b5-4047-6458-0cfa-c9ef8f0d0470@gmail.com>
Date:   Tue, 2 Nov 2021 20:39:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2 09/25] tcp: authopt: Disable via sysctl by default
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
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
        linux-kernel@vger.kernel.org
References: <cover.1635784253.git.cdleonard@gmail.com>
 <137399b962131c278acbfa5446a3b6d59aa0547b.1635784253.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <137399b962131c278acbfa5446a3b6d59aa0547b.1635784253.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 10:34 AM, Leonard Crestez wrote:
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 97eb54774924..cc34de6e4817 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -17,10 +17,11 @@
>  #include <net/udp.h>
>  #include <net/cipso_ipv4.h>
>  #include <net/ping.h>
>  #include <net/protocol.h>
>  #include <net/netevent.h>
> +#include <net/tcp_authopt.h>
>  
>  static int two = 2;
>  static int three __maybe_unused = 3;
>  static int four = 4;
>  static int thousand = 1000;
> @@ -583,10 +584,19 @@ static struct ctl_table ipv4_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_douintvec_minmax,
>  		.extra1		= &sysctl_fib_sync_mem_min,
>  		.extra2		= &sysctl_fib_sync_mem_max,
>  	},
> +#ifdef CONFIG_TCP_AUTHOPT
> +	{
> +		.procname	= "tcp_authopt",
> +		.data		= &sysctl_tcp_authopt,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,

Just add it to the namespace set, and this could be a u8 (try to plug a
hole if possible) with min/max specified:

                .maxlen         = sizeof(u8),
                .mode           = 0644,
                .extra1         = SYSCTL_ZERO,
                .extra2         = SYSCTL_ONE


see icmp_echo_enable_probe as an example. And if you are not going to
clean up when toggled off, you need a handler that tells the user it can
not be disabled by erroring out on attempts to disable it.

