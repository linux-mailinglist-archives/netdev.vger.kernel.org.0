Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60310508C43
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 17:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380292AbiDTPiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 11:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380280AbiDTPiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 11:38:21 -0400
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C44843AF4;
        Wed, 20 Apr 2022 08:35:34 -0700 (PDT)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.119])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 808AC2007B;
        Wed, 20 Apr 2022 15:35:32 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 97CA07C0091;
        Wed, 20 Apr 2022 15:35:31 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 0D55D13C2B0;
        Wed, 20 Apr 2022 08:35:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 0D55D13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1650468931;
        bh=m6UmcaUNAJbiUAjl9D1S7563d1lALHm4+6MIjVko97A=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VOttTPX9D2xuN0YICl2Gr74GByEwy6WkJtsWdYYbJ1jWW92A+ZjlIRkHQkeFwMfe/
         Bx4/9LYrN7rYiRhBm81uvJmeMyt9H39cTT7CxWcHu8ch+Au38fqb9pz3xT02gj3+T5
         1mcU2k0rtCDlXqGL2HzqW+G/wJyTd8/SJ3meo4eY=
Subject: Re: [PATCH 0/1] add support for enum module parameters
To:     Kalle Valo <kvalo@kernel.org>, Jani Nikula <jani.nikula@intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20220414123033.654198-1-jani.nikula@intel.com>
 <YlgfXxjefuxiXjtC@kroah.com> <87a6cneoco.fsf@intel.com>
 <87sfq8qqus.fsf@tynnyri.adurom.net>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <0be3baa1-d4aa-8ab2-173f-085d47497251@candelatech.com>
Date:   Wed, 20 Apr 2022 08:35:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <87sfq8qqus.fsf@tynnyri.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MDID: 1650468933-iY1Kl7vagF1E
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/19/22 10:13 PM, Kalle Valo wrote:
> + linux-wireless, netdev
> 
> Jani Nikula <jani.nikula@intel.com> writes:
> 
>> On Thu, 14 Apr 2022, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>> On Thu, Apr 14, 2022 at 03:30:32PM +0300, Jani Nikula wrote:
>>>> Hey, I've sent this before, ages ago, but haven't really followed
>>>> through with it. I still think it would be useful for many scenarios
>>>> where a plain number is a clumsy interface for a module param.
>>>>
>>>> Thoughts?
>>>
>>> We should not be adding new module parameters anyway (they operate on
>>> code, not data/devices), so what would this be used for?
>>
>> I think it's just easier to use names than random values, and this also
>> gives you range check on the input.
>>
>> I also keep telling people not to add new module parameters, but it's
>> not like they're going away anytime soon.
>>
>> If there's a solution to being able to pass device specific debug
>> parameters at probe time, I'm all ears. At least i915 has a bunch of
>> things which can't really be changed after probe, when debugfs for the
>> device is around. Module parameters aren't ideal, but debugfs doesn't
>> work for this.
> 
> Wireless drivers would also desperately need to pass device specific
> parameters at (or before) probe time. And not only debug parameters but
> also configuration parameters, for example firmware memory allocations
> schemes (optimise for features vs number of clients etc) and whatnot.
> 
> Any ideas how to implement that? Is there any prior work for anything
> like this? This is pretty hard limiting usability of upstream wireless
> drivers and I really want to find a proper solution.

I used a 'fwcfg' file that is loaded during ath10k initialization, from
same general location as the firmware.  Name is with pci-id or other unique
identifier like board files sometimes are named, and you get per radio
configuration at device load time.  I'm sure I posted a patch on this
some years ago, but I can point you to my current tree if you prefer.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

