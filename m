Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B96673E3A
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392913AbfGXUXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:23:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46583 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392907AbfGXUXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 16:23:18 -0400
Received: by mail-pl1-f193.google.com with SMTP id c2so22405025plz.13
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 13:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=tE9sDoaxWP7ENUklMu9B5KmrSaJsUYEMHDJidBaTQAM=;
        b=pORCmtHgruaAh7jFtr6E4ZzUrb001kmlY/XmlhkpMHTVJPEgfTlK3OZx6oUnMQQt8g
         Yrek0PP6Cr4oSkithzkQ5gjBIg4ykENdwWyBFt64cFI/+K7L9/7iqfFbVhaGIanPFfpi
         ORYgLlchkMRWEXrqq+/hLRi++u8PtPoKZonc7cXLEAxXvM5OjhGMO6Qyg3AEwUTyA4NG
         R1Bs1mXtoJJNAo0rOqVoVZIMJQI9P23Xvcu4Azu9t4lqPQTfw3VZs1lojV+ithM078sX
         obyw5e/uSkO7b5BLoukJOazXT9dcs3tuEC8F2xVzy4WRMCCcR4TlN32hlaZ3zSFuZPQG
         sn6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tE9sDoaxWP7ENUklMu9B5KmrSaJsUYEMHDJidBaTQAM=;
        b=oHTF9ifuwLd0M/3wzM2f2fI9qyziLpNKJNae4f4ddjy6iHt1+vN94AOZ/9nzhC6omE
         Mp9VtDmrWrlR6Wb86OFEwRSxvAFBwfBTjK/q9BwdyYPQAEBa18e1qU/E9wgI3pH2VPEZ
         9CxOWFrAyUVbGZFPCW5lNm1PwhjIq4X7FuwVX6+ws2Qi3eUNUDFU4krKh0vpz0oOt43i
         ZKu+20zYIcGzEzDaPA8N5Z42V3rdG0ZE25tCo63Pmm8fpoKByrO51bMiyEyKZtO/esld
         mv6dQUqIDqIlDh6M6oXJZ7aDen3/MqbhnhAIz3WzNtNWFXJNB3BKh52jWHKTdjnMHFQU
         fXBQ==
X-Gm-Message-State: APjAAAWj8SaHLp68rpKVJpmeL30URi0rCdg76fI32UDkgxJJesdL8C4M
        fPOgMD1PWgWGokEYgHfxTw3GKg==
X-Google-Smtp-Source: APXvYqx6Zs5baeICfbzLAtdQ49/DGHuAfHj3JA1NQt8KTe+lj2CNpe8x42nM7AJg87DyyLwBjOCUKw==
X-Received: by 2002:a17:902:54f:: with SMTP id 73mr85929854plf.246.1563999797553;
        Wed, 24 Jul 2019 13:23:17 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id 3sm50811034pfg.186.2019.07.24.13.23.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 13:23:17 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 02/19] ionic: Add hardware init and device
 commands
From:   Shannon Nelson <snelson@pensando.io>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-3-snelson@pensando.io>
 <a402ea5d2badda79cf205e790d3eb967f2cb7084.camel@mellanox.com>
 <10005fdb-51e8-42fc-3a7c-ea7c0dddb584@pensando.io>
Message-ID: <7df1a5fb-9c88-a077-c54e-25ea1a12427e@pensando.io>
Date:   Wed, 24 Jul 2019 13:23:15 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <10005fdb-51e8-42fc-3a7c-ea7c0dddb584@pensando.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 5:25 PM, Shannon Nelson wrote:
> On 7/23/19 4:47 PM, Saeed Mahameed wrote:
>> On Mon, 2019-07-22 at 14:40 -0700, Shannon Nelson wrote:

>> +
>> +    /* Wait for dev cmd to complete, retrying if we get EAGAIN,
>> +     * but don't wait any longer than max_seconds.
>> +     */
>> +    max_wait = jiffies + (max_seconds * HZ);
>> +try_again:
>> +    start_time = jiffies;
>> +    do {
>> +        done = ionic_dev_cmd_done(idev);
>> READ_ONCE required here ? to read from coherent memory modified
>> by the device and read by the driver ?
>
> Good idea, I'll add that in.

Looking closer at this, it is more for coordinating memory reads between 
threads and irq handlers.  This is polling a PCI register, which is 
already marked as volatile and in at least some definitions (e.g. x86) 
has a barrier.

sln

