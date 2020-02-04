Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E575A151AFA
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 14:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgBDNK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 08:10:59 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52138 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbgBDNK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 08:10:59 -0500
Received: by mail-wm1-f67.google.com with SMTP id t23so3269933wmi.1
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 05:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iyq7B+eErKW+JTeAkxnBVJODB7cFLrl66Z12JjulmGg=;
        b=MU5LG2vgwbjUBrbZ8VOPR88F+7dDaJEqoJprDjBmJxT8I58kqK7CiBVPUtkJbgkvDo
         H2JaYHRkzvVdPXme3eEimmnzN58fCWKB+QYo4CyXsGdYW/hHBaOTAmZBSmAq6CSM4Ntt
         G432akUSXkMlmbUqAoAyX1LCWmTFhEqm3NG2FSgu+C2BR9q1WQooRHeabsfFC3sbK2lj
         D6yf3HCffdWqqAPKyC37vWOwhCbObzOQUTG21ZHa708+Nk7S02JwCFtofS6a6CldEp8H
         I9bC0pLbZwTBqffp7Fsbke8e30+AkqyhAnNGwIRqARzp57Q/7F0RcBEu3pI+8T/YwTiS
         iQPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=iyq7B+eErKW+JTeAkxnBVJODB7cFLrl66Z12JjulmGg=;
        b=t/d8O3e716hcv0821iMr1A21mhxkhYd+3xTJCFa+p5vgS/WN03gbezbc4UsqfHED6T
         ckf/LeijLkYjOJSBxE1HaHXwKi+8NTEMXY+sBN0L7Km9h/YHVocbtMa/tOeX/143seOL
         IuP6TNIlswHv8gbodHPUB5EJW2fCn9R8CvfKLDmuuXfel1sYazucyJlCtIES8OuBvjOM
         8QF0WC8gzsH4gf7e0BrXLwRC2IqDuRVzuhmkZp6d/bjVZkAVU+HhQMGtLLzUzhCOrrSP
         DdMmBcn4gV8umpv7j6cHk1VjDVDEbfXx3lqihwrLkwpAYEFdigYQvJNTd5JKYKRwlylY
         0Q+w==
X-Gm-Message-State: APjAAAUhMFueY07hy5xhRI/z4XXZrWmtukntYiQGr6rMrzVBUHOFeg7u
        pKWERdJizHLyq5Canm+5+X0YHZRKx8g=
X-Google-Smtp-Source: APXvYqyg55bCefjySJkU5wQbm7/pNW2kztbA2fBTFILRMgzbritdi5UrQp9K8gbEFa4hYXU2rDBxMQ==
X-Received: by 2002:a1c:2282:: with SMTP id i124mr5564641wmi.109.1580821857328;
        Tue, 04 Feb 2020 05:10:57 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:71a5:2cb:1dcc:7f16? ([2a01:e0a:410:bb00:71a5:2cb:1dcc:7f16])
        by smtp.gmail.com with ESMTPSA id s65sm3907577wmf.48.2020.02.04.05.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 05:10:56 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec v2] vti[6]: fix packet tx through bpf_redirect() in
 XinY cases
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     steffen.klassert@secunet.com, davem@davemloft.net,
        netdev@vger.kernel.org
References: <202002041523.F56NC2Bi%lkp@intel.com>
 <20200204105248.28729-1-nicolas.dichtel@6wind.com>
 <20200204114604.GA59185@bistromath.localdomain>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <238cfe44-b8aa-ca4c-787a-c282117a405a@6wind.com>
Date:   Tue, 4 Feb 2020 14:10:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200204114604.GA59185@bistromath.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 04/02/2020 à 12:46, Sabrina Dubroca a écrit :
[snip]
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +		case htons(ETH_P_IPV6):
>> +			fl->u.ip6.flowi6_oif = dev->ifindex;
>> +			fl->u.ip6.flowi6_flags |= FLOWI_FLAG_ANYSRC;
>> +			dst = ip6_route_output(dev_net(dev), NULL, &fl->u.ip6);
> 
> I don't think that works with CONFIG_IPV6=m and CONFIG_NET_IPVTI=y:
> 
> ld: net/ipv4/ip_vti.o: in function `ip6_route_output':
> /home/sab/linux/net/./include/net/ip6_route.h:98: undefined reference to `ip6_route_output_flags'
:/

> 
> You probably have to do like ipvlan did in commit 7f897db37b76
> ("ipvlan: fix building with modular IPV6").
> 
Thanks for pointing this out.
