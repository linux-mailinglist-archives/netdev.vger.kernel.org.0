Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF92DB8B4
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 22:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440826AbfJQU5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 16:57:03 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:54018 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440037AbfJQU5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 16:57:03 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9HKuunN096878;
        Thu, 17 Oct 2019 15:56:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571345816;
        bh=NonDxu76QiMt6uzLm35txcbZHeB2YY7bYHqwXcVeC3Q=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=JHCuIFHcNjSY8DN/anrADrh4RKh56u2jGatKHJ1qqXrHOtLc5kUyYGOtCRcDdk9vm
         UDuOc74kiKrnvVLd2j1+P07JJUn23XITA19GRyCEoTatKeqpUjM/Q3kDz5XdD5WNXM
         L1ofO80xBM8C+Ix8Jwb/gsjPZtakncgd07XpV+9s=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9HKuuxD124158
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Oct 2019 15:56:56 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 17
 Oct 2019 15:56:55 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 17 Oct 2019 15:56:48 -0500
Received: from [158.218.113.14] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9HKutSP010998;
        Thu, 17 Oct 2019 15:56:55 -0500
Subject: Re: taprio testing - Any help?
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a69550fc-b545-b5de-edd9-25d1e3be5f6b@ti.com>
 <87v9sv3uuf.fsf@linux.intel.com>
 <7fc6c4fd-56ed-246f-86b7-8435a1e58163@ti.com>
 <87r23j3rds.fsf@linux.intel.com>
 <CA+h21hon+QzS7tRytM2duVUvveSRY5BOGXkHtHOdTEwOSBcVAg@mail.gmail.com>
 <45d3e5ed-7ddf-3d1d-9e4e-f555437b06f9@ti.com>
 <871rve5229.fsf@linux.intel.com>
 <f6fb6448-35f0-3071-bda1-7ca5f4e3e11e@ti.com>
 <87zhi01ldy.fsf@linux.intel.com>
 <c4ff605f-d556-2c68-bcfd-65082ec8f73a@ti.com>
 <87bluf182w.fsf@linux.intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <945ee4cd-4628-4805-6429-21611bc6e08a@ti.com>
Date:   Thu, 17 Oct 2019 17:02:44 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <87bluf182w.fsf@linux.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/17/2019 03:32 PM, Vinicius Costa Gomes wrote:
> Murali Karicheri <m-karicheri2@ti.com> writes:
>>
>> root@am57xx-evm:~# tc qdisc replace dev eth0 parent root handle 100 taprio \
>>   >     num_tc 4 \
>>   >     map 2 3 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>>   >     queues 1@0 1@0 1@0 1@0 \
>>   >     base-time 1564535762845777831 \
>>   >     sched-entry S 0xC 15000000 \
>>   >     sched-entry S 0x2 15000000 \
>>   >     sched-entry S 0x4 15000000 \
>>   >     sched-entry S 0x8 15000000 \
>>   >     txtime-delay 300000 \
>>   >     flags 0x1 \
>>   >     clockid CLOCK_TAI
>> RTNETLINK answers: Invalid argument
>>
>> Anything wrong with the command syntax?
> 
> I tried this example here, and it got accepted ok. I am using the
> current net-next master. The first thing that comes to mind is that
> perhaps you backported some old version of some of the patches (so it's
> different than what's upstream now).
Was on master of kernel.org. Will try net-next master now.

Murali
> 
> 
> Cheers,
> --
> Vinicius
> 

