Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C73F511350B
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 19:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbfLDScS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 13:32:18 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38246 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfLDScR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 13:32:17 -0500
Received: by mail-qt1-f193.google.com with SMTP id 14so773141qtf.5
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 10:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qy7bm3dWO5qrYO1eCEebejs73Zbzm0TjnBqs1FgOkqw=;
        b=Q/K1i/CXhsP0E+0gloMk3spDqVBHJfanD1rXV6EU6qw5MnLyKZ5Qljn4fgYazamWc8
         6XIgdDDhihQqbp9A4S1q5FNdcLrPSbYSRusnCCcKBHst0qTmsbGcSxIIbkh5PQ2H53bp
         /uNTy8/ffQPSir2N+A5LQ6gePnntPQfjUNt5BYAg0EQxQRa3c/KUr2orpiW4hwHMKWgH
         QXOZ0MjwSwz7XfaoG9m9e0mxrnpB7mEanB+qiVGAV824A3KEKVQo5xICtAl2tOGFBd7f
         X2Jw56Eedbjbj62Kzjdfq7sh+f9pZCJ0BVqNFyK7r3p2IrJp4b6ZgJk4e4ghliWqYofs
         TztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qy7bm3dWO5qrYO1eCEebejs73Zbzm0TjnBqs1FgOkqw=;
        b=pncjOg0AScI0bm4i919eXZJ28fXYBKYvNKH6JI3eTCO8sGFgKKPzXgvTcp6aSh1G6x
         giQKDpsJSSw+Rebt5rVqsXHvY/bjIPPg4wIwhjfyWFk1HWmJ9PWJ/Wpuf6zil+xEVft8
         Sbs0fXBCZ1kQSGNzqXmMOiXjfPj3cF7DJEVAq8/Jktr/eyLC5a28iyZ147TqBL+EpIx1
         jYIQDBW4yYiKBjsK8f1agUfnPfYgB6MzROXFAWmgCg4bgKfcgIQS5JQPZZxUtLEmQ1o3
         +Fi8fRRejxLTdWe0BZ+8LfQ7p8/oMA7exC0Jd5LeOOrB9kFxEqaVgmIzApLhAq8hVm7o
         5G5A==
X-Gm-Message-State: APjAAAW+uSLHG+7vknupRx7ObCum83QdqX0a9DaA0OGGb5PckywyOBeJ
        KIhvZ6K5+7V8QGC4jZi/3xAo454X
X-Google-Smtp-Source: APXvYqwbAnlSu6Fqw2+tXE22yCseyaQEf2M7j5iaxNnPmYOv3XxQKAUnUBD048eKQKITiQ9qpLw5LA==
X-Received: by 2002:ac8:60cc:: with SMTP id i12mr4088679qtm.103.1575484336766;
        Wed, 04 Dec 2019 10:32:16 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:bc97:d049:2862:6860])
        by smtp.googlemail.com with ESMTPSA id k185sm376037qke.29.2019.12.04.10.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 10:32:15 -0800 (PST)
Subject: Re: Endless "ip route show" if 255.255.255.255 route exists
From:   David Ahern <dsahern@gmail.com>
To:     Sven-Haegar Koch <haegar@sdinet.de>, netdev@vger.kernel.org
References: <alpine.DEB.2.21.1912041616460.194530@aurora64.sdinet.de>
 <a57d26df-26a4-26dc-5acf-4a49f641bcb0@gmail.com>
Message-ID: <6d6fe3ee-674a-a88b-897d-9aa9fa303be8@gmail.com>
Date:   Wed, 4 Dec 2019 11:32:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a57d26df-26a4-26dc-5acf-4a49f641bcb0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/19 11:05 AM, David Ahern wrote:
> On 12/4/19 8:22 AM, Sven-Haegar Koch wrote:
>> Then trying to show the routing table:
>>
>> root@haegar-test:~# ip ro sh | head -n 10
>> default via 10.140.184.1 dev ens18
>> 10.140.184.0/24 dev ens18 proto kernel scope link src 10.140.184.244
>> 255.255.255.255 dev ens18 scope link
>> default via 10.140.184.1 dev ens18
>> 10.140.184.0/24 dev ens18 proto kernel scope link src 10.140.184.244
>> 255.255.255.255 dev ens18 scope link
>> default via 10.140.184.1 dev ens18
>> 10.140.184.0/24 dev ens18 proto kernel scope link src 10.140.184.244
>> 255.255.255.255 dev ens18 scope link
>> default via 10.140.184.1 dev ens18 
>>
>> (Repeats endless without the "head" limit)
>>
> 
> Thanks for the report. Seems to be a problem with iproute2.
> iproute2-ss190924 works fine. I'll send a fix.
> 

nope, it's a kernel side bug with the strict checking path.
