Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAF62E879
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfE2Ws7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:48:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42509 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfE2Ws7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 18:48:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id r22so2575256pfh.9
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 15:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0e9M4/OfFKFwAxDFyQ/2xLJ33KYg5t+OBccoIRMFFBg=;
        b=YlTttzcVmypBduneVkJNHC/HouZcyrLPyewivXyrPgvu4jrTExL7VNrsoqK2Y/RVBq
         vXsgzwfG5OK9qTmWx7Irrw8jofBEcTYpb6ckvbO+XLMqUK8OG/9Gvi3/WYyzkKBtx4Bg
         3PyVdPDQNvbl6iNr2VU5tvvTCqR9gz+muHAWncK3qcb4Abqy+ta/uK+l/LqFGMgzyQI9
         s0jlxPI4CfJ8ePk7W78J5acoz6nBPp99KOSqoB94viIof80EoSzvFwg6Mt0O5LNKnbho
         iUSZeRhRHZ5vzIxGrGquludLamO1tlD+Q9a0ZflSpbVeYyUvLsPs5A2Llnbh5TyRJ71q
         YkGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0e9M4/OfFKFwAxDFyQ/2xLJ33KYg5t+OBccoIRMFFBg=;
        b=UNN8FyKjGXUKkMEosbuwOQ56Gh7SqU1Sp5cIH7OlArw5oDDL6uwmpeseQbvALuTbi5
         nWRKYMAyHaB26PmGD9AQWAqI3LbtoslpQFLRYjgESLG3Z3keVlMgK7Dq7ximI37eLAw2
         eLmafkPpFtErJFcvSDRcAQnHmqu1LNtkRji+7CUeI0gt05VukmXFSFxlTxn5eYjflggV
         himeSWsvfZHaFJGUKaDgbwaZEqxqN+TnezLia07zbTrTfgIdn0KKJU50pkTfjcyjlBWC
         D87n3pKIWT09IPg7lrbKVy2pi4s7YdU4aGNk7kJVsWAVKpBw8F3Q8tR5+QMmkEOxCno6
         2rMQ==
X-Gm-Message-State: APjAAAWvdzfdbwg2UGH+SN8yneFBsa1DyyhNTESeYiXXFV7Eb7S5msIA
        uvff/GJA5eQMss2o1FGUkko=
X-Google-Smtp-Source: APXvYqwpwOVQVUGn7Ethdjpzz1y3epUY1Vwforu3OKifQ+4UuZTNjmnOJ+Tm4EkgTOv9jkGWvxw4EQ==
X-Received: by 2002:a62:5387:: with SMTP id h129mr146550pfb.6.1559170133461;
        Wed, 29 May 2019 15:48:53 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id j26sm373109pgl.31.2019.05.29.15.48.52
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 15:48:52 -0700 (PDT)
Subject: Re: [PATCH net-next 1/7] net: Don't disable interrupts in
 napi_alloc_frag()
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>
References: <20190529221523.22399-1-bigeasy@linutronix.de>
 <20190529221523.22399-2-bigeasy@linutronix.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6a2940ff-ade4-64b5-2014-4e0701c14b87@gmail.com>
Date:   Wed, 29 May 2019 15:48:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190529221523.22399-2-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/29/19 3:15 PM, Sebastian Andrzej Siewior wrote:
> netdev_alloc_frag() can be used from any context and is used by NAPI
> and non-NAPI drivers. Non-NAPI drivers use it in interrupt context
> and NAPI drivers use it during initial allocation (->ndo_open() or
> ->ndo_change_mtu()). Some NAPI drivers share the same function for the
> initial allocation and the allocation in their NAPI callback.

...

> +
> +	fragsz = SKB_DATA_ALIGN(fragsz);
> +	if (irqs_disabled()) {


What is the difference between this prior test, and the following ?

if (in_irq() || irqs_disabled())

I am asking because I see the latter being used in __dev_kfree_skb_any()


> +		nc = this_cpu_ptr(&netdev_alloc_cache);
> +		data = page_frag_alloc(nc, fragsz, GFP_ATOMIC);
> +	} else {
> +		local_bh_disable();
> +		data = __napi_alloc_frag(fragsz, GFP_ATOMIC);
> +		local_bh_enable();
> +	}
> +	return data;
> +}
> +EXPORT_SYMBOL(netdev_alloc_frag);
> +
>  /**
>   *	__netdev_alloc_skb - allocate an skbuff for rx on a specific device
>   *	@dev: network device to receive on
> 
