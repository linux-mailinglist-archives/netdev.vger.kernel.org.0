Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2F61D9C1D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgESQLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:11:15 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37816 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgESQLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 12:11:14 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04JGB680019838;
        Tue, 19 May 2020 11:11:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589904666;
        bh=9PSNrF+ZsrRDAVKY+XCrhqveSnWUlPgRwbE4gSyrvoY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=CbObd3zbfonpCVRCA3+R8KRXbLaISHzZFzsc3bw+bpERcbNAr+gQ/u5NmcrSzDaYv
         If/qGeWAp441XtjBNCNvIXGct+8nwfotaQoDCmabPTcHmufU0d4l4ljSfmSLbCqPAz
         JfmemVJbfcSOecixI8BCxt3KPeni+gTDVXxlEal8=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04JGB6Qq105476
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 11:11:06 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 19
 May 2020 11:11:06 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 19 May 2020 11:11:06 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04JGB5tT065261;
        Tue, 19 May 2020 11:11:05 -0500
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     <jeffrey.t.kirsher@intel.com>, <netdev@vger.kernel.org>,
        <vladimir.oltean@nxp.com>, <po.liu@nxp.com>,
        <Jose.Abreu@synopsys.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
 <b33e582f-e0e6-467a-636a-674322108855@ti.com> <87v9ksndnr.fsf@intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <a6c28ef7-59ae-94d8-a12a-1c6a821dc330@ti.com>
Date:   Tue, 19 May 2020 12:11:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87v9ksndnr.fsf@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 5/19/20 11:32 AM, Vinicius Costa Gomes wrote:
> Murali Karicheri <m-karicheri2@ti.com> writes:
> 
>>> $ ethtool $ sudo ./ethtool --show-frame-preemption enp3s0
>>> Frame preemption settings for enp3s0:
>>> 	support: supported
>>> 	active: active
>>> 	supported queues: 0xf
>>
>> I assume this is will be in sync with ethtool -L output which indicates
>> how many tx h/w queues present? I mean if there are 8 h/w queues,
>> supported queues will show 0xff.
> 
> In this approach, the driver builds these bitmasks, so it's responsible
> to keep it consistent with the rest of the stuff that's exposed in
> ethtool.
Agree
> 
>>
>>> 	supported queues: 0xe
>>   From the command below, it appears this is the preemptible queue mask.
>> bit 0  is Q0, bit 1 Q1 and so forth. Right? In that case isn't it more
>> clear to display
>>           preemptible queues : 0xef
>>
>> In the above Q7 is express queue and Q6-Q0 are preemptible.
> 
> In my case, the controller I have here only has 4 queues, and Queue 0 is
> the highest priority one, and it's marked as express.
> 

Ok. So it is up to the device driver to manage this.

>>
>> Also there is a handshake called verify that happens which initiated
>> by the h/w to check the capability of peer. It looks like
>> not all vendor's hardware supports it and good to have it displayed
>> something like
>>
>>           Verify supported/{not supported}
>>
>> If Verify is supported, FPE is enabled only if it succeeds. So may be
>> good to show a status of Verify if it is supported something like
>>           Verify success/Failed
>>
>>> 	minimum fragment size: 68
>>>
>>>
>>> $ ethtool --set-frame-preemption enp3s0 fp on min-frag-size 68 preemptible-queues-mask 0xe
>>>
>>> This is a RFC because I wanted to have feedback on some points:
>>>
>>>     - The parameters added are enough for the hardware I have, is it
>>>       enough in general?
>>
>> As described above, it would be good to add an optional parameter for
>> verify
>>
>> ethtool --set-frame-preemption enp3s0 fp on min-frag-size 68
>> preemptible-queues-mask 0xe verify on
>>
> 
> The hardware I have do not support this, but this makes sense.

I can work to support this for TI AM65 CPSW once a formal patch is
available. AM65 CPSW supports Verify as an optional feature. H/w works
also in manual mode where it is assumed that it is connected to a
IET FPE capable partner, but can't do Verify.

Thanks for sending the RFC.

regards,

Murali
> 
> 
> Cheers,
> 

-- 
Murali Karicheri
Texas Instruments
