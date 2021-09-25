Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40DE417F18
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 03:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346761AbhIYBy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 21:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbhIYBy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 21:54:26 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9A1C061571;
        Fri, 24 Sep 2021 18:52:51 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id 24so17143787oix.0;
        Fri, 24 Sep 2021 18:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D9BQyR31EeLU89wi549dT+9lIPo7NOe1+dJQDdRBFCM=;
        b=Iiq0Z4j6Ip+qHZCVCD3Yrdn5nM/cJt/ALnXsvJ8KZ4Flzq6NNNCJjKnPMMKSpydkfv
         bMgNQYTQY+tpdprgcZjOCPNzKuJuc5GghNmePrZd/qw5o5m9Eo/6wUFe48HUJl3cXyjD
         iUAAS9svMFEooXpivzH9yECCfqe/pLgqBM/6nQJ4BwQbW09oZvWqnjhQxFHXlcINvraA
         UYttMBkG3fkHzvlFWjZbjKwU9lEU2g0ZJH4+D7f7QQVqEhaiBC90jESdUaLPBO4N10aQ
         g7rYfsXneTGKN4TP/s/PEumS0OEbHD24wA3t9bLOAkw+KU2Z4h1DHDb2QmMVEAzNAQne
         7Q8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D9BQyR31EeLU89wi549dT+9lIPo7NOe1+dJQDdRBFCM=;
        b=fn6qHC4gxm5lEPl2BuKivLiIwDm/BzWB/7uaEbEdguxpqg3SB1hI6IL43oUfdWAM5e
         uzhK1aWqHtIV4ZbsRhVMMAQ6nRkKp7esDcfCCnGD1hTTcxX6Vw+JzuE7y3nAv07vKaOO
         pH+vMjLq53by6Zt5DAKNBdwT/ccTuH6oeqVgkEgSysNRsZCTHQ+aqqpRXk0rVUtTTWLl
         UNDPedkpjgr4DAK9FyGHN9ce9z98l0NHxTKOTrsYdBTYlVvGhj8BlpqlYtoxUjBXbcuF
         0NzS7Da0OGPhcxNH0ZrQwiHY1a6xkxfsduSJ39t7AS3lcpUCC9ekFa8z6VkU1thn0i2/
         +ZlA==
X-Gm-Message-State: AOAM530oS3MBfZvAZ9e1WCx6OEOFvDzewSyraLMUUIKYrlZifHBMYnIf
        zj1vYZ+KMsUWQA2iEtgj14ojBcX3hb+caQ==
X-Google-Smtp-Source: ABdhPJw69pQ5XDK8NGO2IjyleeK9861jOCH3RckARGX1BfEi0fdAB4k8abV+GyLH6X8wcmM2jThwiA==
X-Received: by 2002:aca:d13:: with SMTP id 19mr2508394oin.118.1632534771120;
        Fri, 24 Sep 2021 18:52:51 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id f3sm2541622oij.6.2021.09.24.18.52.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 18:52:50 -0700 (PDT)
Subject: Re: [PATCH 17/19] selftests: Add -t tcp_authopt option for
 fcnal-test.sh
To:     Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1632240523.git.cdleonard@gmail.com>
 <c52733a1cd9a7bd16aea0b6e056fad9dd1cc5aed.1632240523.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c72ad0be-9499-dcfb-0faa-be3dd51f4a86@gmail.com>
Date:   Fri, 24 Sep 2021 19:52:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c52733a1cd9a7bd16aea0b6e056fad9dd1cc5aed.1632240523.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/21 10:15 AM, Leonard Crestez wrote:
> This script is otherwise very slow to run!

there are a lot of permutations to cover.

> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
> index 74a7580b6bde..484734db708f 100755
> --- a/tools/testing/selftests/net/fcnal-test.sh
> +++ b/tools/testing/selftests/net/fcnal-test.sh
> @@ -1331,10 +1331,21 @@ ipv4_tcp()
>  	log_subsection "With VRF"
>  	setup "yes"
>  	ipv4_tcp_vrf
>  }
>  
> +
> +only_tcp_authopt()
> +{
> +	log_section "TCP Authentication"
> +	setup
> +	set_sysctl net.ipv4.tcp_l3mdev_accept=0
> +	log_subsection "IPv4 no VRF"
> +	ipv4_tcp_authopt

This feature needs to work with VRF from the beginning. v4, v6, with and
without VRF.

> +}
> +
> +
>  ################################################################################
>  # IPv4 UDP
>  
>  ipv4_udp_novrf()
>  {
> @@ -4021,10 +4032,11 @@ do
>  	ipv6_bind|bind6) ipv6_addr_bind;;
>  	ipv6_runtime)    ipv6_runtime;;
>  	ipv6_netfilter)  ipv6_netfilter;;
>  
>  	use_cases)       use_cases;;
> +	tcp_authopt)     only_tcp_authopt;;
>  
>  	# setup namespaces and config, but do not run any tests
>  	setup)		 setup; exit 0;;
>  	vrf_setup)	 setup "yes"; exit 0;;
>  
> 

This patch can be folded into the previous one, and the drop the
only_tcp_authopt function. The script has always allowed a single test
to be run by name (-t arg), so '-t tcp_authopt' runs tcp_authopt which
covers v4 and v6 with and without vrf.
