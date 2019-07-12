Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAE66651D
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 05:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbfGLDki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 23:40:38 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41378 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729404AbfGLDki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 23:40:38 -0400
Received: by mail-pl1-f196.google.com with SMTP id m9so4059665pls.8
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 20:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HwoGMFhk2hDKCRlCt4L8Ff+FIKzrm0a28GHN+h42gd8=;
        b=j+5lr7WJlTSxonjWj0Jg7hhiC0t+rjjYl3g2+hUMsC5C7oBxNRPCTwlRvq0/Nhx9TS
         UbESU5XYq3c2POs+Gto5EzPy2GB45EfHHWtv36iVRLQziIR9r3UHQlbQrZekWeGhpfei
         kvtrf74jiWAyHkYFcBDztm09bZQsWKg+xWV5K2h4n99WVByQJdCQu5+et4ajCMCNdhZo
         jAJqQkvqvNSNsajEs+RMNnFYkD3mtxR+jR3UKizEcxh6xVUqESCyMDE92DCwDErIeEQX
         0jEbzGSWSev1V7p1sLZFNGDpPKdFThp90Bd3fwCCdZW0BSNq7jfJdHnE6xsT5B7b+nVB
         snkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HwoGMFhk2hDKCRlCt4L8Ff+FIKzrm0a28GHN+h42gd8=;
        b=Dxpl5FDqEVCgPdC0UHHZnBA/nLerKXdJpig2f/hb9lP/F8HkGwRHh8h8qBjmcqU3TK
         gPdyWvbj6smgutYjQs9mvko/Qt3IAJGuKa4594ybUiFw2yQ4rWmBNMDUBSu0Ucp89TRE
         RIxo3E//rD4Q0w2kbshkLdrb3ReJpt1maM33qba2D0a9oQeabdvQ4hr27gEKdehFUGqf
         awaZkPzMpHn6eUHSeypqvddBgtmD06Vdmi1RPRkptPllbKG2bFT4F1dfqEF+EL/kQqIt
         XQiqIHmjHY+zmThL8OblfCAAgGTwEdzsYM3evAm7iHPYV76kCRgMVpZ2QnpfePgzrrH2
         Ee/Q==
X-Gm-Message-State: APjAAAV6+qVe5tvp0dVGKZBBmzKAH0RciPHmmP0SJZ6FnNU6T3lysnyf
        Zb86PXIptJ8NHCMwPhd6vsI=
X-Google-Smtp-Source: APXvYqxPSAQmcODZqNkZYNQVHzR1R981cUSNoF3FdiExR0QiS+EMdslZUT3niMuyKWfyP92F3jD8NQ==
X-Received: by 2002:a17:902:e613:: with SMTP id cm19mr8106483plb.299.1562902837626;
        Thu, 11 Jul 2019 20:40:37 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a6sm6095084pjs.31.2019.07.11.20.40.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 20:40:36 -0700 (PDT)
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data paths
To:     Neil Horman <nhorman@tuxdriver.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, pablo@netfilter.org,
        jakub.kicinski@netronome.com, pieter.jansenvanvuuren@netronome.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, idosch@mellanox.com
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707.124541.451040901050013496.davem@davemloft.net>
 <20190711123909.GA10978@splinter>
 <20190711235354.GA30396@hmswarspite.think-freely.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <69d0917f-895f-6239-4044-76944432e8ca@gmail.com>
Date:   Thu, 11 Jul 2019 20:40:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190711235354.GA30396@hmswarspite.think-freely.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/11/2019 4:53 PM, Neil Horman wrote:
>> I would like to emphasize that the configuration of whether these
>> dropped packets are even sent to the CPU from the device still needs to
>> reside in devlink given this is the go-to tool for device-specific
>> configuration. In addition, these drop traps are a small subset of the
>> entire packet traps devices support and all have similar needs such as
>> HW policer configuration and statistics.
>>
>> In the future we might also want to report events that indicate the
>> formation of possible problems. For example, in case packets are queued
>> above a certain threshold or for long periods of time. I hope we could
>> re-use drop_monitor for this as well, thereby making it the go-to
>> channel for diagnosing current and to-be problems in the data path.
>>
> Thats an interesting idea, but dropwatch certainly isn't currently setup for
> that kind of messaging.  It may be worth creating a v2 of the netlink protocol
> and really thinking out what you want to communicate.

Is not what you describe more or less what Ido has been doing here with
this patch series?
-- 
Florian
