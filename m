Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD2A28C6EE
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 03:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgJMBzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 21:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgJMBzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 21:55:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A06C0613D0;
        Mon, 12 Oct 2020 18:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=XZ4PnfNtwakIDlRRmh47GHVxqUjiVpoW6RClzSLlVzI=; b=XUUZ4fqAb9ywdL3Jx1BwPY9nJF
        iKs2Te4/mNvPSrju67WdoJ/QCbrAFA+clkdxX64WQg3c+9bKiPnFI4f5asilYqfKGH72XDZmnsqHp
        Kvf8wcF8HS0BqzRGycWfFdmw1R1G4GortaEEZClVb8nq/w8TkUFKDWsQvpbdXoSqaUmvkp6kk4Ukb
        XLrm32/BBTILt0MJIXpqmIa+UaafcrPp5akacLOp8c8Vku9Gxk35K++Xry7n+lss9nHpm33DdNQ2M
        KPniw/AZ7n0euRWQxfHH0JfzNia/dNHs2P0FhVbA5ZzXV+2E8NyXBCrwI2YygAduTJka4X+rvPPTf
        9b6QTkQg==;
Received: from [2601:1c0:6280:3f0::507c]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kS9X2-0003p6-DD; Tue, 13 Oct 2020 01:55:16 +0000
Subject: Re: [PATCH v2 2/6] ASoC: SOF: Introduce descriptors for SOF client
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org
Cc:     tiwai@suse.de, broonie@kernel.org, linux-rdma@vger.kernel.org,
        jgg@nvidia.com, dledford@redhat.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        ranjani.sridharan@linux.intel.com, fred.oh@linux.intel.com,
        parav@mellanox.com, shiraz.saleem@intel.com,
        dan.j.williams@intel.com, kiran.patil@intel.com
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-3-david.m.ertman@intel.com>
 <076a0c53-0738-270e-845f-0ac968a4ea78@infradead.org>
 <d9f062ee-a5f0-b41c-c8f6-b81b374754fa@linux.intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <9ef98f33-a0d3-579d-26e0-6046dd593eef@infradead.org>
Date:   Mon, 12 Oct 2020 18:55:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <d9f062ee-a5f0-b41c-c8f6-b81b374754fa@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/20 6:31 PM, Pierre-Louis Bossart wrote:
> 
>>> +config SND_SOC_SOF_CLIENT
>>> +    tristate
>>> +    select ANCILLARY_BUS
>>> +    help
>>> +      This option is not user-selectable but automagically handled by
>>> +      'select' statements at a higher level
>>> +
>>> +config SND_SOC_SOF_CLIENT_SUPPORT
>>> +    bool "SOF enable clients"
>>
>> Tell users what "SOF" means.
> 
> This option can only be reached if the user already selected the topic-level option. From there on the SOF acronym is used. Is this not enough?

Yes, that's enough. I didn't see it. Sorry about that.

> config SND_SOC_SOF_TOPLEVEL
>     bool "Sound Open Firmware Support"
>     help
>       This adds support for Sound Open Firmware (SOF). SOF is a free and
>       generic open source audio DSP firmware for multiple devices.
>       Say Y if you have such a device that is supported by SOF.
> 
>>
>>> +    depends on SND_SOC_SOF
>>> +    help
>>> +      This adds support for ancillary client devices to separate out the debug
>>> +      functionality for IPC tests, probes etc. into separate devices. This
>>> +      option would also allow adding client devices based on DSP FW
>>
>> spell out firmware
> 
> agree on this one.
> 
>>
>>> +      capabilities and ACPI/OF device information.
>>> +      Say Y if you want to enable clients with SOF.
>>> +      If unsure select "N".
>>> +
>>
>>

thanks.
-- 
~Randy

