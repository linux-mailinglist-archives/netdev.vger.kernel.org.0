Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D20E12FEA9
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 23:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgACWRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 17:17:44 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:45862 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728687AbgACWRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 17:17:44 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 003MHePD060733;
        Fri, 3 Jan 2020 16:17:40 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1578089860;
        bh=Z0q9DHuHfz9KwCjvTYk0S2aokhZW+jACV343DoP0Ris=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=MbrwwB51zqRT4hqFm5sMHL2rbO2Irc0INedbCzJ1FAr9eOzmfCnug2GjiAEddY8sT
         2AHbCFJ1xf4iQG42cS4LRMFIe200rNb5jGCiF1AJ5jg1Rm7j44i7JSfisHTWZfWnFz
         Pzs4OCWMyGsYlea3iMcD6UUHQ7tAAa0VArVBNYMU=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 003MHd1d092618
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 3 Jan 2020 16:17:40 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 3 Jan
 2020 16:17:39 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 3 Jan 2020 16:17:39 -0600
Received: from [158.218.117.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 003MHc1M041767;
        Fri, 3 Jan 2020 16:17:39 -0600
Subject: Re: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        David Ahern <dsahern@gmail.com>
References: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
 <874kxxck0m.fsf@linux.intel.com>
 <BN8PR12MB3266C894D60449BD86E7CE69D3530@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <a911e7b4-bb62-8dfb-43cb-ee6ff78c9415@ti.com>
Date:   Fri, 3 Jan 2020 17:24:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <BN8PR12MB3266C894D60449BD86E7CE69D3530@BN8PR12MB3266.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

On 12/18/2019 06:08 PM, Jose Abreu wrote:
> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Date: Dec/18/2019, 23:05:13 (UTC+00:00)
> 
>> Hi Jose,
>>
>> Jose Abreu <Jose.Abreu@synopsys.com> writes:
>>
>>> Although this is already in kernel, currently the tool does not support
>>> them. We need these commands for full TSN features which are currently
>>> supported in Synopsys IPs such as QoS and XGMAC3.
>>>
>>> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
>>
>> This patch looks good in itself.
>>
>> However, I feel that this is incomplete. At least the way I understand
>> things, without specifying which traffic classes are going to be
>> preemptible (or it's dual concept, express), I don't see how this is
>> going to be used in practice. Or does the hardware have a default
>> configuration, that all traffic classes are preemptible, for example.
>>
>> What am I missing here?
> 
> On our IPs Queue 0 is by preemptible and all remaining ones are express
> by default.
> 
> The way I tested it is quite easy: send traffic from queue 0 and at same
> time configure EST with SetAndHold for remaining queues. Which means
> queue 0 traffic will be blocked while remaining ones are sending.
> 
So you have one sched entry that specify SetAndHold for all remaining
queues. So this means, queue 0 will never get sent. I guess you also
support SetAndRelease so that a mix of SetAndHold followed by 
SetAndRelease can be sent to enable sending from Queue 0. Is that
correct?

Something like
               sched-entry H 02 300000 \ <=== 300 usec tx from Q1
               sched-entry R 01 200000   <=== 300 usec tx from Q0

Just trying to understand how this is being used for real world
application.

Regards,
Murali
> ---
> Thanks,
> Jose Miguel Abreu
> 

-- 
Murali Karicheri
Texas Instruments
