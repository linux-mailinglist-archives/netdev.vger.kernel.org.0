Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B028F4F40D3
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353850AbiDEUDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386444AbiDEOjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 10:39:20 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719B05EBD5;
        Tue,  5 Apr 2022 06:16:13 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 235DFOsL038335;
        Tue, 5 Apr 2022 08:15:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649164524;
        bh=JYdCG3TAoNbKpALXnh21WRPhuqXFTS0WBJhqewUEdCQ=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=Vnl2EmkA6sfzsx2ccbIzJiMsHX1n/wKxf+zgFCW8p9J7ov2+B8OGi8nB9zWtPrjt6
         vOkuz5TCROSq5qBzY4zn3PemosER2jll/k6f7A6By1RoyjVA+QJsDrmiSmkCQL27R8
         zs/5BCk53ntaO0AGU/yZVjXtQquQ+7FtDiep2AIo=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 235DFO0Y061587
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 5 Apr 2022 08:15:24 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 5
 Apr 2022 08:15:24 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Tue, 5 Apr 2022 08:15:24 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 235DFGEe099167;
        Tue, 5 Apr 2022 08:15:16 -0500
Message-ID: <defe77d9-1a41-7112-0ef6-a12aa2b725ab@ti.com>
Date:   Tue, 5 Apr 2022 16:15:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Content-Language: en-US
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Michael Walle <michael@walle.cc>
CC:     Andrew Lunn <andrew@lunn.ch>, <richardcochran@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <mlichvar@redhat.com>, <netdev@vger.kernel.org>,
        <qiangqing.zhang@nxp.com>, <vladimir.oltean@nxp.com>
References: <20220104014215.GA20062@hoboy.vegasvil.org>
 <20220404150508.3945833-1-michael@walle.cc> <YksMvHgXZxA+YZci@lunn.ch>
 <e5a6f6193b86388ed7a081939b8745be@walle.cc> <877d83rjjc.fsf@kurt>
 <ad4a8d3efbeaacf241a19bfbca5976f9@walle.cc> <87wng3pyjl.fsf@kurt>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
In-Reply-To: <87wng3pyjl.fsf@kurt>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/04/2022 14:19, Kurt Kanzenbach wrote:
> On Tue Apr 05 2022, Michael Walle wrote:
>> Am 2022-04-05 11:01, schrieb Kurt Kanzenbach:
>>> On Mon Apr 04 2022, Michael Walle wrote:
>>>> That would make sense. I guess what bothers me with the current
>>>> mechanism is that a feature addition to the PHY in the *future* (the
>>>> timestamping support) might break a board - or at least changes the
>>>> behavior by suddenly using PHY timestamping.
>>>
>>> Currently PHY timestamping is hidden behind a configuration option
>>> (NETWORK_PHY_TIMESTAMPING). By disabling this option the default
>>> behavior should stay at MAC timestamping even if additional features
>>> are added on top of the PHY drivers at later stages. Or not?
>>
>> That is correct. But a Kconfig option has several drawbacks:
>> (1) Doesn't work with boards where I might want PHY timestamping
>>       on *some* ports, thus I need to enable it and then stumple
>>       across the same problem.
>> (2) Doesn't work with generic distro support, which is what is
>>       ARM pushing right now with their SystemReady stuff (among other
>>       things also for embeddem system). Despite that, I have two boards
>>       which are already ready for booting debian out of the box for
>>       example. While I might convince Debian to enable that option
>>       (as I see it, that option is there to disable the additional
>>       overhead) it certainly won't be on a per board basis.
>>       Actually for keeping the MAC timestamping as is, you'd need to
>>       convince a distribution to never enable the PHY timestamping
>>       kconfig option.
>>
>> So yes, I agree it will work when you have control over your
>> kconfig options, after all (1) might be more academic. But I'm
>> really concerned about (2).
> 
> Yes, the limitations described above are exactly one of the reasons to
> make the timestamping layer configurable at run time as done by these
> patches.

Seems like PHY TS support belongs to HW description category, so could it be device tree material,
like generic property defining which layer should do timestamping?

-- 
Best regards,
Grygorii, Ukraine
