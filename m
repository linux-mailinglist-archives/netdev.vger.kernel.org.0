Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C64D45D67
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbfFNNEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:04:04 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46279 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfFNNEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:04:04 -0400
Received: by mail-pg1-f196.google.com with SMTP id v9so1505858pgr.13;
        Fri, 14 Jun 2019 06:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ThLynGcMuiJhmVWOI3cGwSidDOAHGFZeg80j18C/zIs=;
        b=hoaabJl1f9tDQFE+qm/hgwa/ZZbqWY5KctknMJ6hxk7tYbQwK8eHxhAKW6nyskdhBm
         zOYvMNyksXRURSlMGpJlpOimJOJCCW/elkJlpvwCey6bVLouP9uDtRHlikzEU0D5bTSZ
         Wkop0d6bugHsO7Spbhhaa1xCOo+GntjpyNJWs4r59i/XD6YtPDmB3WMKn36iJGAr/sKn
         f6pndoqMf2ceq9cM0t1xuIEeASDpqyl3vt31sFJvanEZGX21HTO7LrqCzaBLBtCTwNvg
         atZJIy9py5XnQgk50fFuxPbzU7dCZSrS2z6fiwc3GQvL9tDXR9N+RwItQ5kZ7aQHaFkC
         UJuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ThLynGcMuiJhmVWOI3cGwSidDOAHGFZeg80j18C/zIs=;
        b=NoSa9rGxG36IVkhUdiliv3l7bLjUIhqYo0yZ/IUd72PXGFOj/+eVnGIwju5geLcDDO
         HJ0h5ZU2L241f6HrZGioukDnIcQytNb+Hwkfg4PxeMhloP158++hGMOjnJ5DW3OFZdHm
         qR5ksFzNDcjy0wzl0/jX+bH1tKsSLyrpmHasvAj5sRw+MR3mDLTJkYnwk4TetBbKCjfW
         SzLhqDa8RB8Pw0nTkB4orB8poEbvM+LmD7ugNrKqG1Z8EGqlHJs54uMmLeD91F5yPTGR
         xWbTnQSI4a8u7AvxDlnl2c7X6owKnhb4n2qZxZSUwBwfbcbiZ6L1azMpLxBMGjTZEYAe
         A4zQ==
X-Gm-Message-State: APjAAAUOmaSKSbSruv+u0g6UAGQL6QzXian+ZaUoux2jCUGOJwpbXU5f
        GjNumY6hp8SfEq9rj13AW+joekcl
X-Google-Smtp-Source: APXvYqzcfhLfnxM95pdx+Arbb2ofJMuHxK6XDf7JZ+N62a+9DnX0T2ooxFDpoEnhsZ7ZPj0qXSjVew==
X-Received: by 2002:a65:4cce:: with SMTP id n14mr16491026pgt.251.1560517443368;
        Fri, 14 Jun 2019 06:04:03 -0700 (PDT)
Received: from [192.168.1.9] (i223-218-240-142.s42.a013.ap.plala.or.jp. [223.218.240.142])
        by smtp.googlemail.com with ESMTPSA id s12sm2697471pfe.143.2019.06.14.06.03.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 06:04:02 -0700 (PDT)
Subject: Re: [PATCH bpf 2/3] devmap: Add missing bulk queue free
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
 <20190614082015.23336-3-toshiaki.makita1@gmail.com>
 <20190614135806.4bcb1a31@carbon>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <4ab32fa0-0c79-79c7-141b-9620f844d23b@gmail.com>
Date:   Fri, 14 Jun 2019 22:03:57 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190614135806.4bcb1a31@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/06/14 (金) 20:58:06, Jesper Dangaard Brouer wrote:
> On Fri, 14 Jun 2019 17:20:14 +0900
> Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
> 
>> dev_map_free() forgot to free bulk queue when freeing its entries.
>>
>> Fixes: 5d053f9da431 ("bpf: devmap prepare xdp frames for bulking")
>> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>> ---
>>   kernel/bpf/devmap.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index e001fb1..a126d95 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
>> @@ -186,6 +186,7 @@ static void dev_map_free(struct bpf_map *map)
>>   		if (!dev)
>>   			continue;
>>   
>> +		free_percpu(dev->bulkq);
>>   		dev_put(dev->dev);
>>   		kfree(dev);
>>   	}
> 
> Do we need to call need to call dev_map_flush_old() before
> free_percpu(dev->bulkq) ?
> 
> Looking the code, I guess this is not needed as, above we are ensuring
> all pending flush operations have completed.

My understanding is the same. The code waits for NAPI to flush the 
queue, so no need for dev_map_flush_old().

> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Thanks!

Toshiaki Makita
