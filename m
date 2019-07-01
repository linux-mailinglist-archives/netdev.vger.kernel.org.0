Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18245C27A
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfGASA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:00:28 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42967 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfGASA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:00:27 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so7690315plb.9
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 11:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Mqvdd0z0EFPjP5eFXmfsAjH2G/Q7mgchQ4JPswrXFus=;
        b=xXollsQCV3EzPraTfSBNHx4QXwJN+76fy8Nq0MchEEWz5+nn1nfhEWhB+QJn60VrRB
         biB+cZ/9ZTjhehOA/93LL9biF0nadIF3KQrDdh0F3jytjm+cGuHm3bWYDs/7NicFOBC0
         FimZs1Udx47Rer9w/UC/KtqA4unCr/t7D51eSgJQe2xDRx8unw2ovvvFTFeNdEWgNDVX
         FvopwO8DjUQ7OKhQUI8my75aoyjZMyF6oT1Q6nEUPbr5wg30dyCCOlUBxYDeV5HYdsZW
         /U99bIUOsIqKIpCqI6ErWV9HD55X8dEzyfx8+DwzlnbHyI/G2pWcN8nNooyiubrhLOxI
         ZihA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Mqvdd0z0EFPjP5eFXmfsAjH2G/Q7mgchQ4JPswrXFus=;
        b=X00rpNyY1meTxFrg4VJU3VKhn0ePS6gAlBf3a9GO4T5hgVPan+0nC++pmzc6jOY3qT
         MtA6Je9B5Q0b/PZAMH81hn/R3lninMjNXj7fM26vj4b+hCB5kslfz8M/8zwqB4KT4zle
         0Tx8mpKvcvx3WweCK4Bn4I/PsOzQoowEreWPCt0OSIsNsNp7r2vhA5/DBLtJ4tWZRTQH
         IbpR+Iq/CB9weXtpHtOo4Cfh1/tGXy7b5X3JaibKKAbyYRBVV/dzU7INjleZsuWPojwr
         eM0205ygq9WiZ2QD8N2OEiIy5HyOAuJ9kO4Wpg9rD9AlKAbKiszbcX+3ut8my0VebuM8
         3XMQ==
X-Gm-Message-State: APjAAAUu7Jp1ApATo+c5j6jxA1a31TiLowfu3i2hiNM4wE+kexJ6lJot
        CTQwaADFreMIjALuvxTo0A9H3pIlAHk=
X-Google-Smtp-Source: APXvYqyIL1HCc1Wbs4W2/6nBWspQpiViKTNDHHVG7BiJ0c9X56lf381d0movohNKls49rBlMj1ru1g==
X-Received: by 2002:a17:902:16f:: with SMTP id 102mr29254113plb.94.1562004026799;
        Mon, 01 Jul 2019 11:00:26 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j16sm144048pjz.31.2019.07.01.11.00.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 11:00:26 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 04/19] ionic: Add basic lif support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190628213934.8810-1-snelson@pensando.io>
 <20190628213934.8810-5-snelson@pensando.io>
 <20190629114526.4da68321@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3ba46066-8e52-f7cc-30f1-2560890a23b7@pensando.io>
Date:   Mon, 1 Jul 2019 11:00:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190629114526.4da68321@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/19 11:45 AM, Jakub Kicinski wrote:
> On Fri, 28 Jun 2019 14:39:19 -0700, Shannon Nelson wrote:
>> @@ -64,4 +66,49 @@ int ionic_debugfs_add_ident(struct ionic *ionic)
>>   				   ionic, &identity_fops) ? 0 : -ENOTSUPP;
>>   }
>>   
>> +int ionic_debugfs_add_sizes(struct ionic *ionic)
>> +{
>> +	debugfs_create_u32("nlifs", 0400, ionic->dentry,
>> +			   (u32 *)&ionic->ident.dev.nlifs);
>> +	debugfs_create_u32("nintrs", 0400, ionic->dentry, &ionic->nintrs);
>> +
>> +	debugfs_create_u32("ntxqs_per_lif", 0400, ionic->dentry,
>> +			   (u32 *)&ionic->ident.lif.eth.config.queue_count[IONIC_QTYPE_TXQ]);
>> +	debugfs_create_u32("nrxqs_per_lif", 0400, ionic->dentry,
>> +			   (u32 *)&ionic->ident.lif.eth.config.queue_count[IONIC_QTYPE_RXQ]);
> Are these __le32s?  Does the driver build cleanly with W=1 C=1?

Aside from a couple of "expression using sizeof(void)" messages that I 
haven't been able to fully clean out, yes, the driver builds pretty 
clean with sparse.  In this particular case, I think the typecast stops 
the complaint that you are expecting here.  But yes, these would be 
better off with le32_to_cpu().

sln

>
>> +	return 0;
>> +}

