Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C107878C06
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 14:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfG2MuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 08:50:22 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35932 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbfG2MuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 08:50:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so61797168wrs.3
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 05:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FaAv73c7/caKA+SdXX+K+mh6Cm/86re9CSFJB7tkoPQ=;
        b=KW0x3QFgAkbJtmPiI15VrDGcIK27GRcEgALtT7jEwcEraGN0NVvEz0pwJrsydt95ER
         Gscowby0iaA/F56RCBP3ZeYqmxbBk0IT8HWNux4xxYpbZXYyoOy5qSmYe11ZL7x4A70k
         GOuwSowPaBiPvlK5jU1gZjN8I57ndtLQhpu2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FaAv73c7/caKA+SdXX+K+mh6Cm/86re9CSFJB7tkoPQ=;
        b=MkyPFwIR27OOMGMqcbMItek/qqyNJEFo2g3SA9Mucn6t35ZmDEfZKynw3EHBJ6h587
         +rE8/CItTjoMOgc2SgaEof9U4eJv+Am+u7MaJkn2quF5rlC+10ZqbYQtNlvO9s8OSHlc
         ZLRi/7zkZYhxtOlcpE9VDswymroGX1Dd/IG78zMfabw11w4YZ1fGvU0434sH8LyGpjCm
         /Mvf8qMQQ8jl4NLdSpHMvd5Go9dBeMF07VHvyg3qsZoSznVcU8+OnoE65a+cmymnDwt7
         vy9DYPNZMwkiFXV6Ojmxb+dneqPKlIYM45E7QavbTnV5eMSlzxTkKAK1+7zK1nwunNwW
         s8fg==
X-Gm-Message-State: APjAAAUXI/2pGVw/dJYvzplM9gsIwwvm7hEKMHqz2/g5sbLiKJg5WsYI
        NxgHPijLTsC9AGEOtbJUsqXF4Q==
X-Google-Smtp-Source: APXvYqylO0ojx7HMCNib0ntkfakVQdA8p4X9NuiyKtM1VMknioWDrk4uX2Xz5EwZvObFvgSjRiOTJw==
X-Received: by 2002:a5d:6a52:: with SMTP id t18mr19177948wrw.178.1564404620043;
        Mon, 29 Jul 2019 05:50:20 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a67sm67519549wmh.40.2019.07.29.05.50.18
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 05:50:19 -0700 (PDT)
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
 <7e7a7015-6072-d884-b2ba-0a51177245ab@cumulusnetworks.com>
 <eef063fe-fd3a-7e02-89c2-e40728a17578@cumulusnetworks.com>
 <20190725142101.65tusauc6fzxb2yp@soft-dev3.microsemi.net>
 <b9ce433a-3ef7-fe15-642a-659c5715d992@cumulusnetworks.com>
 <e6ad982f-4706-46f9-b8f0-1337b09de350@cumulusnetworks.com>
 <20190726120214.c26oj5vks7g5ntwu@soft-dev3.microsemi.net>
 <b755f613-e6d8-a2e6-16cd-6f13ec0a6ddc@cumulusnetworks.com>
 <20190729121409.wa47uelw5f6l4vs4@lx-anielsen.microsemi.net>
 <95315f9e-0d31-2d34-ba50-11e1bbc1465c@cumulusnetworks.com>
Message-ID: <f4347439-0b96-f7f6-db34-4c7afbeba141@cumulusnetworks.com>
Date:   Mon, 29 Jul 2019 15:50:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <95315f9e-0d31-2d34-ba50-11e1bbc1465c@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/07/2019 15:22, Nikolay Aleksandrov wrote:
> Hi Allan,
> On 29/07/2019 15:14, Allan W. Nielsen wrote:
>> Hi Nikolay,
>>
>> First of all, as mentioned further down in this thread, I realized that our
>> implementation of the multicast floodmasks does not align with the existing SW
>> implementation. We will change this, such that all multicast packets goes to the
>> SW bridge.
>>
>> This changes things a bit, not that much.
>>
>> I actually think you summarized the issue we have (after changing to multicast
>> flood-masks) right here:
>>
>> The 07/26/2019 12:26, Nikolay Aleksandrov wrote:
>>>>> Actually you mentioned non-IP traffic, so the querier stuff is not a problem. This
>>>>> traffic will always be flooded by the bridge (and also a copy will be locally sent up).
>>>>> Thus only the flooding may need to be controlled.
>>
>> This seems to be exactly what we need.
>>
>> Assuming we have a SW bridge (br0) with 4 slave interfaces (eth0-3). We use this
>> on a network where we want to limit the flooding of frames with dmac
>> 01:21:6C:00:00:01 (which is non IP traffic) to eth0 and eth1.
>>
>> One way of doing this could potentially be to support the following command:
>>
>> bridge fdb add    01:21:6C:00:00:01 port eth0
>> bridge fdb append 01:21:6C:00:00:01 port eth1
>>

And the fdbs become linked lists ? So we'll increase the complexity for something
that is already supported by ACLs (e.g. tc) and also bridge per-port multicast
flood flag ?

I'm sorry but that doesn't sound good to me for a case which is very rare and
there are existing ways to solve without incurring performance hits or increasing
code complexity.

>> On 25/07/2019 16:06, Nikolay Aleksandrov wrote:
>>>>>>>>>  In general NLM_F_APPEND is only used in vxlan, the bridge does not
>>>>>>>>>  handle that flag at all.  FDB is only for *unicast*, nothing is joined
>>>>>>>>>  and no multicast should be used with fdbs. MDB is used for multicast
>>>>>>>>>  handling, but both of these are used for forwarding.
>> This is true, and this should have been addressed in the patch, we were too
>> focused on setting up the offload patch in the driver, and forgot to do the SW
>> implementation.
>>
>> Do you see any issues in supporting this flag, and updating the SW
>> forwarding in br_handle_frame_finish such that it can support/allow a FDB entry
>> to be a multicast?
>>
> 
> Yes, all of the multicast code is handled differently, it doesn't go through the fdb
> lookup or code at all. I don't see how you'll do a lookup in the fdb table with a
> multicast mac address, take a look at br_handle_frame_finish() and you'll notice
> that when a multicast dmac is detected then we use the bridge mcast code for lookups
> and forwarding. If you're trying to achieve Rx only on the bridge of these then
> why not just use Ido's tc suggestion or even the ip maddr add offload for each port ?
> 
> If you add a multicast mac in the fdb (currently allowed, but has no effect) and you
> use dev_mc_add() as suggested that'd just be a hack to pass it down and it is already
> possible to achieve via other methods, no need to go through the bridge.
> 
>> /Allan
>>
> 

