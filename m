Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDFD61659DD
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 10:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgBTJJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 04:09:02 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39843 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgBTJJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 04:09:02 -0500
Received: by mail-lf1-f67.google.com with SMTP id t23so2465307lfk.6
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 01:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KFjjOM/ATxcLGNdaN9di1npOi28u97TQGyXHv0wmFXw=;
        b=eadWqpkp5Vo1b81QGCZOyn4AynMqBeEj3XDArEaOELEQ3U0I0zewuEynz/bmC025ac
         GycxMBYJad0D+XjtuJc1uRjnnMCx0rJuGW1I7LGzc3+spyoab2ZsFNYMtYSpU854pH+V
         THZl66rl/WCzH1AGKSDVzE9Qt7MDZD70wH3fU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KFjjOM/ATxcLGNdaN9di1npOi28u97TQGyXHv0wmFXw=;
        b=kWaT7NCYyX+0CiQMHIu5Fi/04L7NCFChOm/UsRlhomvqQDfUVc8OsA0l4Z6f/8PS+5
         VIlkUGQZr8HoexcOz0UX1KLAc4YPMKWaF45o/ozUGPP+f7Ab0bMxs/AWac3jU5kLrNu9
         CkAbwOYDClK6OKT8BC77u/kNHK7Z4M1g4+uhSKL9cgEYz66u98+sFwd1yRz83pSRcjnK
         a7XtminNffxGVnOgL9KjpWVkXS1nldOjyQ1/PIHtoQeAheg5tHpuhuTaPFwA4QJvunux
         CNzWsz0110tscHMOSwvAM98FFIW5lQoKNxFaEXKiELHDy4UEvYS3A84FKJFnE2gNms7r
         J4HQ==
X-Gm-Message-State: APjAAAVRO0fcl2Y4YRvTJQUJVwP+eRvF+wDIl+SKgPqm2TriUW3avnOV
        FviSgyGRkGpPS0JM4etKuiRNFg==
X-Google-Smtp-Source: APXvYqy45/4Ap6BjwajnmmM6G5U9Ws6yAE795RDfSZGhdc4380Z2tcYVCRQyqKGvGmzI8k/CRfGmKw==
X-Received: by 2002:a05:6512:3284:: with SMTP id p4mr2007451lfe.166.1582189740582;
        Thu, 20 Feb 2020 01:09:00 -0800 (PST)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id w8sm1457501lfk.75.2020.02.20.01.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 01:09:00 -0800 (PST)
Subject: Re: [RFC net-next v3 03/10] net: bridge: mrp: Add MRP interface used
 by netlink
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        jiri@resnulli.us, ivecera@redhat.com, davem@davemloft.net,
        roopa@cumulusnetworks.com, anirudh.venkataramanan@intel.com,
        olteanv@gmail.com, jeffrey.t.kirsher@intel.com,
        UNGLinuxDriver@microchip.com
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-4-horatiu.vultur@microchip.com>
 <20200124174315.GC13647@lunn.ch>
 <20200125113726.ousbmm4n3ab4xnqt@soft-dev3.microsemi.net>
 <20200125152023.GA18311@lunn.ch>
 <20200125191612.5dlzlvb7g2bucqna@lx-anielsen.microsemi.net>
 <20200126132843.k4rzn7vfti7lqvos@soft-dev3.microsemi.net>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <08c2d3f8-8d70-730c-95d5-8493e6919f3e@cumulusnetworks.com>
Date:   Thu, 20 Feb 2020 11:08:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200126132843.k4rzn7vfti7lqvos@soft-dev3.microsemi.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2020 15:28, Horatiu Vultur wrote:
> The 01/25/2020 20:16, Allan W. Nielsen wrote:
>> On 25.01.2020 16:20, Andrew Lunn wrote:
>>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>>
>>> On Sat, Jan 25, 2020 at 12:37:26PM +0100, Horatiu Vultur wrote:
>>>> The 01/24/2020 18:43, Andrew Lunn wrote:
>>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>>>>
>>>>>> br_mrp_flush - will flush the FDB.
>>>>>
>>>>> How does this differ from a normal bridge flush? I assume there is a
>>>>> way for user space to flush the bridge FDB.
>>>>
>>>> Hi,
>>>>
>>>> If I seen corectly the normal bridge flush will clear the entire FDB for
>>>> all the ports of the bridge. In this case it is require to clear FDB
>>>> entries only for the ring ports.
>>>
>>> Maybe it would be better to extend the current bridge netlink call to
>>> be able to pass an optional interface to be flushed?  I'm not sure it
>>> is a good idea to have two APIs doing very similar things.
>> I agree.
> I would look over this.
> 

There's already a way to flush FDBs per-port - IFLA_BRPORT_FLUSH.

>>
>> And when looking at this again, I start to think that we should have
>> extended the existing netlink interface with new commands, instead of
>> adding a generic netlink.
> We could do also that. The main reason why I have added a new generic
> netlink was that I thought it would be clearer what commands are for MRP
> configuration. But if you think that we should go forward by extending
> existing netlink interface, that is perfectly fine for me.
> 
>>
>> /Allan
>>
> 

I don't mind extending the current netlink interface but the bridge already has
a huge (the largest) set of options and each time we add a new option we have
to adjust RTNL_MAX_TYPE. If you do decide to go this way maybe look into nesting
all the MRP options under one master MRP element into the bridge options, example:
[IFLA_BR_MRP]
  [IFLA_BR_MRP_X]
  [IFLA_BR_MRP_Y]
  ...

To avoid increasing the stack usage and bumping the max rtnl type too much.

Cheers,
 Nik
