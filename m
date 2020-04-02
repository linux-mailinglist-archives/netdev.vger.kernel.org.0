Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7E5A19BFD7
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 13:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388043AbgDBLGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 07:06:10 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:56904 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388028AbgDBLGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 07:06:10 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 032B5mRO043791;
        Thu, 2 Apr 2020 06:05:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1585825548;
        bh=tIB72R51lzoNJX57UIZhH59wu8O+hq4911x6tWDtvvM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=gOwzDAgbuy6A3udlkBX8OS1lDFrDuI3qTrkUUUoUoc1Yt9GM0kjMrSICN2gv/wUlm
         N+ARrhZGUUrVkkiTymEvE3f/gQ0olYy2JhnxKFZhbQXKqGzmqCM1iDA1vOBRRtxLjN
         seH14/kjhBenKSX66yfQfWQXgz7tR2iWiqHLX0bM=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 032B5mcq096678;
        Thu, 2 Apr 2020 06:05:48 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 2 Apr
 2020 06:05:48 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 2 Apr 2020 06:05:47 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 032B5fOW029504;
        Thu, 2 Apr 2020 06:05:42 -0500
Subject: Re: [PATCH net-next v6 00/11] net: ethernet: ti: add networking
 support for k3 am65x/j721e soc
To:     Will Deacon <will@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
CC:     <davem@davemloft.net>, <arnd@arndb.de>,
        <devicetree@vger.kernel.org>, <kishon@ti.com>, <kuba@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <m-karicheri2@ti.com>,
        <netdev@vger.kernel.org>, <nsekhar@ti.com>, <olof@lixom.net>,
        <olteanv@gmail.com>, <peter.ujfalusi@ti.com>, <robh@kernel.org>,
        <rogerq@ti.com>, <t-kristo@ti.com>,
        <clang-built-linux@googlegroups.com>
References: <20200401.113627.1377328159361906184.davem@davemloft.net>
 <20200401223500.224253-1-ndesaulniers@google.com>
 <20200402094239.GA3770@willie-the-truck>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <adc2aa08-60e2-cdc3-6b5b-6d96f8805c44@ti.com>
Date:   Thu, 2 Apr 2020 14:05:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200402094239.GA3770@willie-the-truck>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 02/04/2020 12:42, Will Deacon wrote:
> On Wed, Apr 01, 2020 at 03:35:00PM -0700, Nick Desaulniers wrote:
>>>> I think the ARM64 build is now also broken on Linus' master branch,
>>>> after the net-next merge? I am not quite sure if the device tree
>>>> patches were supposed to land in mainline the way they did.
>>>
>>> There's a fix in my net tree and it will go to Linus soon.
>>>
>>> There is no clear policy for dt change integration, and honestly
>>> I try to deal with the situation on a case by case basis.
>>
>> Yep, mainline aarch64-linux-gnu- builds are totally hosed.  DTC fails the build
>> very early on:
>> https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/311246218
>> https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/311246270
>> There was no failure in -next, not sure how we skipped our canary in the coal
>> mine.
> 
> Yes, one of the things linux-next does a really good job at catching is
> build breakage so it would've been nice to have seen this there rather
> than end up with breakage in Linus' tree :(
> 
> Was the timing just bad, or are we missing DT coverage or something else?

It seems issue was not caught in -next because the patch that fixes the issue was already in -next
before this series was pushed.

Sorry for the mess again.

-- 
Best regards,
grygorii
