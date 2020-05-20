Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB281DB415
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 14:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgETMrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 08:47:45 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:53780 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETMro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 08:47:44 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04KClbBh051869;
        Wed, 20 May 2020 07:47:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589978857;
        bh=AqvDDiNjhhJJhH+2Iuzf1KQzaudYFdiwJFg+rGhVDtI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=OTkEIzZ04akVj95vxKCo/fEJGIogs0keHAhPYz7nPnkDbD9MNwcZy6km1ASENQhXj
         D6itTR60obTCXXgXw1gA4b/TA1wES0D9ffHvV5oP3NJKS2T1XikhKIn5xHgxAXfz+y
         4/3LADkD7ZB8L2Up7CcpZ0Tr2705zv0P0TjZb2RU=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04KClbLc110251
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 07:47:37 -0500
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 20
 May 2020 07:47:36 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 20 May 2020 07:47:36 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04KClaIm129871;
        Wed, 20 May 2020 07:47:36 -0500
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     <jeffrey.t.kirsher@intel.com>, <netdev@vger.kernel.org>,
        <vladimir.oltean@nxp.com>, <po.liu@nxp.com>,
        <Jose.Abreu@synopsys.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
 <158992799425.36166.17850279656312622646@twxiong-mobl.amr.corp.intel.com>
 <87y2pnmr83.fsf@intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <13d8b7ba-8afd-cb67-c782-56aff1412bcd@ti.com>
Date:   Wed, 20 May 2020 08:47:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87y2pnmr83.fsf@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 5/19/20 7:37 PM, Vinicius Costa Gomes wrote:
> Andre Guedes <andre.guedes@intel.com> writes:
> 
>> Hi,
>>
>> Quoting Vinicius Costa Gomes (2020-05-15 18:29:44)
>>> One example, for retrieving and setting the configuration:
>>>
>>> $ ethtool $ sudo ./ethtool --show-frame-preemption enp3s0
>>> Frame preemption settings for enp3s0:
>>>          support: supported
>>>          active: active
>>
>> IIUC the code in patch 2, 'active' is the actual configuration knob that
>> enables or disables the FP functionality on the NIC.
>>
>> That sounded a bit confusing to me since the spec uses the term 'active' to
>> indicate FP is currently enabled at both ends, and it is a read-only
>> information (see 12.30.1.4 from IEEE 802.1Q-2018). Maybe if we called this
>> 'enabled' it would be more clear.
> 
> Good point. Will rename this to "enabled".
> 
>>
>>>          supported queues: 0xf
>>>          supported queues: 0xe
>>>          minimum fragment size: 68
>>
>> I'm assuming this is the configuration knob for the minimal non-final fragment
>> defined in 802.3br.
>>
>> My understanding from the specs is that this value must be a multiple from 64
>> and cannot assume arbitrary values like shown here. See 99.4.7.3 from IEEE
>> 802.3 and Note 1 in S.2 from IEEE 802.1Q. In the previous discussion about FP,
>> we had this as a multiplier factor, not absolute value.
> 
> I thought that exposing this as "(1 + N)*64" (with 0 <= N <= 3) that it
> was more related to what's exposed via LLDP than the actual capabilities
> of the hardware. And for the hardware I have actually the values
> supported are: (1 + N)*64 + 4 (for N = 0, 1, 2, 3).
> 
> So I thought I was better to let the driver decide what values are
> acceptable.
> 
> This is a good question for people working with other hardware.
> 
> 
AM65 CPSW supports this as a multiple of 64. Since this ethtool
configuration is for the hardware, might want to make it as a multiple
of 64.

Murali

-- 
Murali Karicheri
Texas Instruments
