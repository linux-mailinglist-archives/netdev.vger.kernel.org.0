Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF7EC28C6
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731887AbfI3V0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:26:02 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:60398 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727702AbfI3V0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:26:02 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 1EFA213C283;
        Mon, 30 Sep 2019 11:45:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 1EFA213C283
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1569869151;
        bh=QRMir/2Pzm8sf9iXSmS9d7M2CKkPM6L2u/3in98jYqE=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=N6bYWVmYc6zxAIs5EahVeNL3RUqOqLnIKakPMtwCFyQv+fHfa/8UrFG18nRBo1rmL
         3R/4w0oUx5RAbYd2vvWiJbrFIs2iP5jHGrFmT44g0V6XJU8W8l4SqIcIUC83CgGMu4
         cojNVgjipKOFJ0WbR2K3BVze2bm+YXo455pcMQ6w=
Subject: Re: Strange routing with VRF and 5.2.7+
To:     David Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>
References: <91749b17-7800-44c0-d137-5242b8ceb819@candelatech.com>
 <51aae991-a320-43be-bf73-8b8c0ffcba60@candelatech.com>
 <7d1de949-5cf0-cb74-6ca3-52315c34a340@candelatech.com>
 <795cb41e-4990-fdbe-8cbe-9c0ada751b80@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <9eb82b65-0067-4320-4b11-7a02b6226cd5@candelatech.com>
Date:   Mon, 30 Sep 2019 11:45:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <795cb41e-4990-fdbe-8cbe-9c0ada751b80@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/19 12:23 PM, David Ahern wrote:
> On 9/20/19 9:57 AM, Ben Greear wrote:
>> On 9/10/19 6:08 PM, Ben Greear wrote:
>>> On 9/10/19 3:17 PM, Ben Greear wrote:
>>>> Today we were testing creating 200 virtual station vdevs on ath9k,
>>>> and using
>>>> VRF for the routing.
>>>
>>> Looks like the same issue happens w/out VRF, but there I have oodles
>>> of routing
>>> rules, so it is an area ripe for failure.
>>>
>>> Will upgrade to 5.2.14+ and retest, and try 4.20 as well....
>>
>> Turns out, this was ipsec (strongswan) inserting a rule that pointed to
>> a table
>> that we then used for a vrf w/out realizing the rule was added.
>>
>> Stopping strongswan and/or reconfiguring how routing tables are assigned
>> resolved the issue.
>>
> 
> Hi Ben:
> 
> Since you are the pioneer with vrf and ipsec, can you add an ipsec
> section with some notes to Documentation/networking/vrf.txt?

I need to to some more testing, an initial attempt to reproduce my working
config on another system did not work properly, and I have not yet dug into
it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

