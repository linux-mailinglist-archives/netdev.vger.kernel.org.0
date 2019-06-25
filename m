Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76C4755654
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730748AbfFYRv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:51:56 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36902 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfFYRv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 13:51:56 -0400
Received: by mail-io1-f67.google.com with SMTP id e5so2189057iok.4
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 10:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nTXi62qVQRCfNE86+C5hg1Js4XTaw0IlP8ZF+UCpy9k=;
        b=Hnv7r4DLa3cyo9lik8Iz7gifBP5dA+qWWvVk1d1c0EVvQDc/Ef+/czegXHTQOxY3gm
         AOBpHwKLorfqzc7bvx7i9xQ2rbRLBonHorMQb+Ad913SFv6P7qJc5qSEluStWjdsBSCa
         qmRg/PnnVpx9YgYQY6X+t2K9jggz1YGhEHRl1SEJKwG2KkI5JcqNaSKLjJXE+KmNes/p
         0YObozaN9tPdVsDzHgOAa6RCq7cgAIFiVY9JUM1/zZAO1vWlD8LE9Ag9KMS803Foi6fQ
         25cCa+kuYc+3bN3qH6kHxwvi/goytaUrlK1QuoTX0f9Cuqvk4VjOPAQKd7/Iu+f7G4vE
         MsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nTXi62qVQRCfNE86+C5hg1Js4XTaw0IlP8ZF+UCpy9k=;
        b=U/da+fLFCy5Fui3fMmbGr07JwCeRv875t5MPifLhZXOG1FSWQBpGUvYslmJh5JAvav
         2KP444ipcAkmOazj7hapmsF7PW7boBQQI/FMD4M28k4SpftXAutcss9zw3YYbjIoxvag
         ryKfsEI8CSO5G2dMPa01gV5zwIDwKcHEmXrdmWivMSqzdmu4xMwWwMg1oqYAvKPAgt+B
         /2ZWCiNhFfH4LZ8Flk1lFurb7QLAt1lwJt+NBuPsKB9bgRtEr3CfKwKK1JasDohvrsCU
         g7nat2yqgUmyA1Xs9JdSMBDKoi5oIq2ykoRllJLBe8maTdCAOGzMN+RQ71/8y8exHQiA
         SbLw==
X-Gm-Message-State: APjAAAV3+5jSW0ugmyGycLK8i3gGzgQSOZmypQ5SQQ70MH5piBYY2aGT
        AcNxaSukrke6l3w5mxJf5Ew=
X-Google-Smtp-Source: APXvYqwMbM6PKQDti4GoQrIkFE4K+fl19b3zhs4b6+PLcFhCCh4N3AVZO0C699dKGJIIAfDfv2Q6MA==
X-Received: by 2002:a6b:2b08:: with SMTP id r8mr78429878ior.34.1561485115565;
        Tue, 25 Jun 2019 10:51:55 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:15b9:c7c8:5be8:b2c9? ([2601:282:800:fd80:15b9:c7c8:5be8:b2c9])
        by smtp.googlemail.com with ESMTPSA id a7sm13123525iok.19.2019.06.25.10.51.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 10:51:54 -0700 (PDT)
Subject: Re: [PATCH net] ipv4: Use return value of inet_iif() for
 __raw_v4_lookup in the while loop
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com
References: <20190625001406.6437-1-ssuryaextr@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dd17803b-2f9e-89a6-a9e3-f319ca2ac6ce@gmail.com>
Date:   Tue, 25 Jun 2019 11:51:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190625001406.6437-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/19 6:14 PM, Stephen Suryaputra wrote:
> In commit 19e4e768064a8 ("ipv4: Fix raw socket lookup for local
> traffic"), the dif argument to __raw_v4_lookup() is coming from the
> returned value of inet_iif() but the change was done only for the first
> lookup. Subsequent lookups in the while loop still use skb->dev->ifIndex.
> 
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> ---
>  net/ipv4/raw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
> index 0b8e06ca75d6..40a6abbc9cf6 100644
> --- a/net/ipv4/raw.c
> +++ b/net/ipv4/raw.c
> @@ -197,7 +197,7 @@ static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
>  		}
>  		sk = __raw_v4_lookup(net, sk_next(sk), iph->protocol,
>  				     iph->saddr, iph->daddr,
> -				     skb->dev->ifindex, sdif);
> +				     dif, sdif);
>  	}
>  out:
>  	read_unlock(&raw_v4_hashinfo.lock);
> 

ugh, missed that in 19e4e768064a8; thanks for the patch.

Reviewed-by: David Ahern <dsahern@gmail.com>
