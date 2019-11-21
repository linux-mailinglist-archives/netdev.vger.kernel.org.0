Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D14105AD7
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfKUUJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:09:29 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43286 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUUJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:09:29 -0500
Received: by mail-qt1-f195.google.com with SMTP id q8so2464545qtr.10
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 12:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BYpRW79iRcPqVSR3cOMESgqb3xchkh1S2PLuj5/KaS4=;
        b=D1q4xyhcAls7P/c/4VnNoxe+ZN9qOTPNeOawyMRt3VvRq7csKD1xMRyheDc0TmiXHf
         4yN+8T4GBw8ihSNJ7jovxtyuB0mbbOCeIMJUNTNu2qzAt+omme1S9Fs5/y7wU0S9YOwQ
         fogbUgdV5Y939Y4uvzueo42jXrLiPq1kpiB3wb8qsFqR5BP+al/Y9XovFOpQeXwl/WrL
         svA+9Chwoj8B9AcaWd6gbWhqvjofXGRZa+2LzOnyPpvxpEYChhTpAJ0CRBA6/xczMn24
         616ijCFtzAM8xDwlQ6/hE0InzKVCO+7+ZwHMChnj83+gYSBkIESE5XK/Dvd3LkTUVWnZ
         MB6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BYpRW79iRcPqVSR3cOMESgqb3xchkh1S2PLuj5/KaS4=;
        b=XM/UeLUonxtPKCwOkl/i082WxwxsyNet07wXnBgIiVsmWHVpnHpAJ0xTsHoBjnOfab
         xrykSrcCpenJ9oENwpeGASt75om1jKleIkLMTqghB3cKbcw0ddxWcCsBh/M76pZqmZLE
         WclvCtj9yW+rjy6+EhhydsZzP3Zq4EUY1oe1QnD5sIgwUPyyqNn3IPJDTTVR5rO5QhuF
         E7988pRlwA/o30n15s9F2P+PtyY0YgjrAnGvbut7FsrHXdTnVNe4HNBWpq11eMQtiAHS
         RZdS98sfe/n5vnugVaSqZr9V7jN7D63sctwOGFGkUrq+O82CfZtBlwcto5Sef8VY5gBj
         YKsg==
X-Gm-Message-State: APjAAAUaJNQsUO1f8PftiE2og1FqXlbD/y83VmbtDC+CUdoARufUYniO
        hlMIuXb+IChi/x6pzsOV8K0=
X-Google-Smtp-Source: APXvYqylTPrJNBLfuTOlBtH0bc2rSm7s2PPzCvB76fkQSRsIQeaTgv5OQTlSDKEZ4bX9DT5+lTptBw==
X-Received: by 2002:ac8:1084:: with SMTP id a4mr10654230qtj.114.1574366967254;
        Thu, 21 Nov 2019 12:09:27 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b9b1:601f:b338:feda])
        by smtp.googlemail.com with ESMTPSA id l93sm2132208qtd.86.2019.11.21.12.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 12:09:26 -0800 (PST)
Subject: Re: [PATCH net-next v4 2/5] ipv6: keep track of routes using src
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <cover.1574252982.git.pabeni@redhat.com>
 <8e2c5bdc1b81e411da76df89cd9c13be2869ea2d.1574252982.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ece35d5e-fa1e-c2d2-9de9-2e4c54a99f3a@gmail.com>
Date:   Thu, 21 Nov 2019 13:09:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8e2c5bdc1b81e411da76df89cd9c13be2869ea2d.1574252982.git.pabeni@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/19 5:47 AM, Paolo Abeni wrote:
> Use a per namespace counter, increment it on successful creation
> of any route using the source address, decrement it on deletion
> of such routes.
> 
> This allows us to check easily if the routing decision in the
> current namespace depends on the packet source. Will be used
> by the next patch.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/net/ip6_fib.h    | 30 ++++++++++++++++++++++++++++++
>  include/net/netns/ipv6.h |  3 +++
>  net/ipv6/ip6_fib.c       |  4 ++++
>  net/ipv6/route.c         |  3 +++
>  4 files changed, 40 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
