Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886C413DF72
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgAPQAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:00:21 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34508 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbgAPQAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 11:00:20 -0500
Received: by mail-wm1-f65.google.com with SMTP id w5so7464080wmi.1
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 08:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=frQKJNnsPozLzRKyl1EnehWw6S2UfuJ2SMQ56cxf7ws=;
        b=Hv/4cB+tiiyhEdkUdYxvLXbicAo/2MBZm65ykGIiD/L/6llE4MzWKmy4ZHlCH1yiqZ
         mf0Uyil9TOM5pibAfeuMgd/x9KX5dMETl5EP3PKOhHASH++j1H8zD04D+c+jJj8C60ts
         Zj3444VbaVcJYbV0zGV/pg3E2JzJ06M3CvNGVXYolbGVOn8A3WNe6wkBHe/R0CSeyDSl
         WHTp9KL/xmZfC6FRVwCr9p2k5TjV0a2IG2M5ZlMLSZ4pSHq5GChqu+mAWikFtKef8CEM
         2mswgif1j5aDfmdMTVhdOqnbPctxEw26t3ilm/mxT9Qrd89/sMb4r81Wg9TKIJWTjVw2
         DddA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=frQKJNnsPozLzRKyl1EnehWw6S2UfuJ2SMQ56cxf7ws=;
        b=b0M0nj7BnwtwMST3gMpTb22BMgLAr9TTvWU51t6grMG6NH3QIyAfqrJfuc0Ozw8XEw
         WbuuZmURZrv4UKBWx7pQEYbF+Yj9fEJdghAK8hjd0xr8Xm4/WQip9IZHNpglKqEyKcRj
         PxgfDsspfYVBai5DR24MLU4rub4DpKUW1wEXnQm+eTXqhWcl+8NLYEMzXV8Bbz7TmGYZ
         pm4AWz4Hs5zCE0OpkzCwXc9Omwae+mEkoNOsStsOLvF8aFo8NMIlcpgtY5LAzvko9jFp
         dZ//PYisfdRw2wdXqS4ezBynO8JyVLkft2DUEDi2RUf70rW1UXgMAWJJIjCqzsHFd9xg
         OvMA==
X-Gm-Message-State: APjAAAXw9Nrr6NBo4tVR9cDVS137V0tEnzlnLu5rBNgy3phkJGokg9SH
        vWDR1ZvK8ek8GB9/ChVNFpJoAQ==
X-Google-Smtp-Source: APXvYqz4EFmq55o1ZjYRT5TxNFuYSVULEezZWC8r3XY+yuF6lMfTTXyGA1U1RJtcBkRfYpbzMI/54Q==
X-Received: by 2002:a1c:6755:: with SMTP id b82mr24853wmc.127.1579190418092;
        Thu, 16 Jan 2020 08:00:18 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:ed9f:e0c6:a41a:de2f? ([2a01:e0a:410:bb00:ed9f:e0c6:a41a:de2f])
        by smtp.gmail.com with ESMTPSA id h8sm31143398wrx.63.2020.01.16.08.00.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 08:00:16 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] net: ip6_gre: fix moving ip6gre between namespaces
To:     kortstro <niko.kortstrom@nokia.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, William Tu <u9012063@gmail.com>
References: <20200116094327.11747-1-niko.kortstrom@nokia.com>
 <8c5be34b-c201-108e-9701-e51fc31fa3de@6wind.com>
 <6465a655-2319-c6e6-d3ca-3cf5ba27640f@nokia.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <0b180112-5931-36b4-670d-192fd714a14e@6wind.com>
Date:   Thu, 16 Jan 2020 17:00:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6465a655-2319-c6e6-d3ca-3cf5ba27640f@nokia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ William Tu

Le 16/01/2020 à 15:43, kortstro a écrit :
> On 1/16/20 4:02 PM, Nicolas Dichtel wrote:
>> Le 16/01/2020 à 10:43, Niko Kortstrom a écrit :
>>> Support for moving IPv4 GRE tunnels between namespaces was added in
>>> commit b57708add314 ("gre: add x-netns support"). The respective change
>>> for IPv6 tunnels, commit 22f08069e8b4 ("ip6gre: add x-netns support")
>>> did not drop NETIF_F_NETNS_LOCAL flag so moving them from one netns to
>>> another is still denied in IPv6 case. Drop NETIF_F_NETNS_LOCAL flag from
>>> ip6gre tunnels to allow moving ip6gre tunnel endpoints between network
>>> namespaces.
>>>
>>> Signed-off-by: Niko Kortstrom <niko.kortstrom@nokia.com>
>> LGTM.
>> Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>>
>> Did you test real x-vrf cases with the three kinds of gre interfaces
>> (gre/collect_md, gretap and erspan)?
> This was only verified in real use with ip6gretap.
William, did you set this flag on collect_md interfaces because you did not test
this feature or was it another reason?

Note: the flag was added here: 6712abc168eb ("ip6_gre: add ip6 gre and gretap
collect_md mode").

Regards,
Nicolas
