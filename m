Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0BF39DD33
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 15:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhFGNBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 09:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbhFGNBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 09:01:52 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7777FC061766;
        Mon,  7 Jun 2021 05:59:48 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 5-20020a9d01050000b02903c700c45721so15510353otu.6;
        Mon, 07 Jun 2021 05:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ZZTtxObXY+nX0k3hctypzmRdrTFJu2YTSlJJnUwDmMA=;
        b=nic8sVIKyjt9RfrctW5gp5kyA4ewBAV+BXxGI2j5NPCudG2LOEeu7WKpufsv+PA+f6
         NC2ru2A7HfjcSqlWuzCLe+fKmv/dzwFRR0kHX9mkVduPcV9C4DwfFA4AM8qjIHEYK/Fp
         3PSCbZzF4/ZlfVTlpa+fkC85wS847i2dKmhla2Of6sgvj40W6N5I5wqi5948eUXIdFdK
         QuE6B+WuQTA597SuCbGZx5/ywzBiHLNjlSsK+pql8kaJsuJWBErdlIWDsvNRfaKmnmRT
         jBHkNm2Esm9s6W/V7RigNKiSyskePOZE+bYNLbsEyp6gTCGK3wmfEULWCpqItn47xS2B
         bm7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZZTtxObXY+nX0k3hctypzmRdrTFJu2YTSlJJnUwDmMA=;
        b=fUfMHP/dMSQZ8zpDmaI4o6Bd6uA+DM4m8OXdpK7sNl5ovxQDO4uLHqS6BxzYHsAUGp
         YM4hf/n2YsGGaPOb73RC6x52FtI/il+qeBj1RPXulGALbqlV1dX5v2/zQebrQAFuLgPS
         KuhFOX/e/1rcqug5iU5Dttcoyt7R1w7h6kxuMia+twtxylQQcPwwBdDdELu/KzsgnhWp
         pkM/e+ZP5Ch8jCMa3PI5r4KQGO8KlmpOXwMU9sXnJZ5SiZUVx3T0MBaaZxY+aAGnxrhU
         VbsytCHTrSpvoXEYZp36oRPQ4yP2Zm3fWe8sDK3G4tOiULHwkq3k/M1C2W1PA7jjcEL5
         EHoQ==
X-Gm-Message-State: AOAM5316Uvk7j2Um9C5BPsFNaTZ23qqIdx16GieffvOrYHkk1grSTef+
        2IgqZLc9uZkfgOSD4MDzSXHHFUmUeNE=
X-Google-Smtp-Source: ABdhPJzma4xxSmnZb4Hp/qjQHRn6dhEzfTxV1hd+zbaMcWfoHWekiK5nyLkAVysixpKK8UV4y9tnpQ==
X-Received: by 2002:a9d:554b:: with SMTP id h11mr13472271oti.4.1623070786209;
        Mon, 07 Jun 2021 05:59:46 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id 88sm2337416otb.7.2021.06.07.05.59.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 05:59:45 -0700 (PDT)
Subject: Re: [PATCH net-next] net: ipv4: use BUG_ON instead of if condition
 followed by BUG
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210607091131.2766890-1-zhengyongjun3@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6b84747d-80a9-08d8-c4e3-c91cdaa99330@gmail.com>
Date:   Mon, 7 Jun 2021 06:59:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607091131.2766890-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/21 3:11 AM, Zheng Yongjun wrote:
> Use BUG_ON instead of if condition followed by BUG in inet_set_link_af.
> 
> This issue was detected with the help of Coccinelle.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/ipv4/devinet.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index 2e35f68da40a..e3e1e8a600ef 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -1988,8 +1988,7 @@ static int inet_set_link_af(struct net_device *dev, const struct nlattr *nla,
>  	if (!in_dev)
>  		return -EAFNOSUPPORT;
>  
> -	if (nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla, NULL, NULL) < 0)
> -		BUG();
> +	BUG_ON(nla_parse_nested_deprecated(tb, IFLA_INET_MAX, nla, NULL, NULL) < 0);
>  
>  	if (tb[IFLA_INET_CONF]) {
>  		nla_for_each_nested(a, tb[IFLA_INET_CONF], rem)
> 

no reason to have a BUG here at all. Catch the error and return.
