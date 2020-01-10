Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8943613717B
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgAJPjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:39:04 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42597 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgAJPjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:39:03 -0500
Received: by mail-lj1-f195.google.com with SMTP id y4so2567798ljj.9
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 07:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y1QB9R6bh9eDoK3rwoTzgbhXWkTdUGimAWJVMTqnIFk=;
        b=O4rt//V4xdikyG8ZAsffheasvFdkAN+OAh9IvXJOvUhXcggzuN+zpjmfBQtfOVsxbx
         hx/QFFQhmy5ItXBMzARVi8iCfMH550Qq3698afJqO8Bwhos1Zb322LougYzTBnm0bHSB
         ZE+4vk+pBQYHHcIzYf3BCh0di6krGdaZjEG60=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y1QB9R6bh9eDoK3rwoTzgbhXWkTdUGimAWJVMTqnIFk=;
        b=Rg7Ls9vtH3K94pBAdDKpN/K5P515Mt42cy8Np49/bsYNRFZE1WmI/58JRN7k2l7KCt
         /uqLxVvpa48+MSw7KxMgBezDC6MLrRUHO/RYzQLD2KHiE8MWKHdpfRccLh3x99k2dlaq
         rhUyW6P4zmSZtXcnUw9xmkG5IzMMgPFbRQmC38hharMnrL/OA6BkVAd2eX0eyA1V8TPl
         Ii7MIrx0GqnU+nGZxtQcZ/BXYnuraYX9PbRmIgV5V0GEX/rkFzNtkrRvgSyRZZqBPXA0
         GAOW1zKXgLA9VtAScctQskfCApnyoKLCCewbbFCeHyzJdmXL/LNERhaj6UWUXiulUwu7
         SVfg==
X-Gm-Message-State: APjAAAWrvmm/6PtgaN/KtVhQe0DWZC9J8TKG6JrVrnEvMEzv3d4ywPh1
        X7Hjqn3JdHyxO/o3QL6puGO7rA==
X-Google-Smtp-Source: APXvYqw2w1n9kvLSh45QkHwcUpjk0D61qK+Sb+Kwg9JkqRTWdjboOjzXBxnrWwlUPDSR7BqfSHHQeQ==
X-Received: by 2002:a2e:3e03:: with SMTP id l3mr3121523lja.237.1578670737371;
        Fri, 10 Jan 2020 07:38:57 -0800 (PST)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id z5sm1180030lji.40.2020.01.10.07.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2020 07:38:56 -0800 (PST)
Subject: Re: [RFC net-next Patch 0/3] net: bridge: mrp: Add support for Media
 Redundancy Protocol(MRP)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, vivien.didelot@gmail.com,
        andrew@lunn.ch, jeffrey.t.kirsher@intel.com, olteanv@gmail.com,
        anirudh.venkataramanan@intel.com, dsahern@gmail.com,
        jiri@mellanox.com, UNGLinuxDriver@microchip.com
References: <20200109150640.532-1-horatiu.vultur@microchip.com>
 <6f1936e9-97e5-9502-f062-f2925c9652c9@cumulusnetworks.com>
Message-ID: <14d0ef5f-4605-4c28-7029-8f60e79f18f7@cumulusnetworks.com>
Date:   Fri, 10 Jan 2020 17:38:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6f1936e9-97e5-9502-f062-f2925c9652c9@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01/2020 16:13, Nikolay Aleksandrov wrote:
> On 09/01/2020 17:06, Horatiu Vultur wrote:
>> Media Redundancy Protocol is a data network protocol standardized by
>> International Electrotechnical Commission as IEC 62439-2. It allows rings of
>> Ethernet switches to overcome any single failure with recovery time faster than
>> STP. It is primarily used in Industrial Ethernet applications.
>>
>> This is the first proposal of implementing a subset of the standard. It supports
>> only 2 roles of an MRP node. It supports only Media Redundancy Manager(MRM) and
>> Media Redundancy Client(MRC). In a MRP ring, each node needs to support MRP and
>> in a ring can be only one MRM and multiple MRC. It is possible to have multiple
>> instances of MRP on a single node. But a port can be part of only one MRP
>> instance.
>>
>> The MRM is responsible for detecting when there is a loop in the ring. It is
>> sending the frame MRP_Test to detect the loops. It would send MRP_Test on both
>> ports in the ring and if the frame is received at the other end, then the ring
>> is closed. Meaning that there is a loop. In this case it sets the port state to
>> BLOCKED, not allowing traffic to pass through except MRP frames. In case it
>> stops receiving MRP_Test frames from itself then the MRM will detect that the
>> ring is open, therefor it would notify the other nodes of this change and will
>> set the state of the port to be FORWARDING.
>>
>> The MRC is responsible for forwarding MRP_Test frames between the ring ports
>> (and not to flood on other ports) and to listen when there is a change in the
>> network to clear the FDB.
>>
>> Similar with STP, MRP is implemented on top of the bridge and they can't be
>> enable at the same time. While STP runs on all ports of the bridge, MRP needs to
>> run only on 2 ports.
>>
>> The bridge needs to:
>> - notify when the link of one of the ports goes down or up, because MRP instance
>>   needs to react to link changes by sending MRP_LinkChange frames.
>> - notify when one of the ports are removed from the bridge or when the bridge
>>   is destroyed, because if the port is part of the MRP ring then MRP state
>>   machine should be stopped.
>> - add a handler to allow MRP instance to process MRP frames, if MRP is enabled.
>>   This is similar with STP design.
>> - add logic for MRP frames inside the bridge. The bridge will just detect MRP
>>   frames and it would forward them to the upper layer to allow to process it.
>> - update the logic to update non-MRP frames. If MRP is enabled, then look also
>>   at the state of the port to decide to forward or not.
>>
>> To create a MRP instance on the bridge:
>> $ bridge mrp add dev br0 p_port eth0 s_port eth1 ring_role 2 ring_id 1
>>
>> Where:
>> p_port, s_port: can be any port under the bridge
>> ring_role: can have the value 1(MRC - Media Redundancy Client) or
>>            2(MRM - Media Redundancy Manager). In a ring can be only one MRM.
>> ring_id: unique id for each MRP instance.
>>
>> It is possible to create multiple instances. Each instance has to have it's own
>> ring_id and a port can't be part of multiple instances:
>> $ bridge mrp add dev br0 p_port eth2 s_port eth3 ring_role 1 ring_id 2
>>
>> To see current MRP instances and their status:
>> $ bridge mrp show
>> dev br0 p_port eth2 s_port eth3 ring_role 1 ring_id 2 ring_state 3
>> dev br0 p_port eth0 s_port eth1 ring_role 2 ring_id 1 ring_state 4
>>
>> If this patch series is well received, the in the future it could be extended
>> with the following:
>> - add support for Media Redundancy Automanager. This role allows a node to
>>   detect if needs to behave as a MRM or MRC. The advantage of this role is that
>>   the user doesn't need to configure the nodes each time they are added/removed
>>   from a ring and it adds redundancy to the manager.
>> - add support for Interconnect rings. This allow to connect multiple rings.
>> - add HW offloading. The standard defines 4 recovery times (500, 200, 30 and 10
>>   ms). To be able to achieve 30 and 10 it is required by the HW to generate the
>>   MRP_Test frames and detect when the ring is open/closed.
>>
>> Horatiu Vultur (3):
>>   net: bridge: mrp: Add support for Media Redundancy Protocol
>>   net: bridge: mrp: Integrate MRP into the bridge
>>   net: bridge: mrp: Add netlink support to configure MRP
>>
>>  include/uapi/linux/if_bridge.h |   27 +
>>  include/uapi/linux/if_ether.h  |    1 +
>>  include/uapi/linux/rtnetlink.h |    7 +
>>  net/bridge/Kconfig             |   12 +
>>  net/bridge/Makefile            |    2 +
>>  net/bridge/br.c                |   19 +
>>  net/bridge/br_device.c         |    3 +
>>  net/bridge/br_forward.c        |    1 +
>>  net/bridge/br_if.c             |   10 +
>>  net/bridge/br_input.c          |   22 +
>>  net/bridge/br_mrp.c            | 1517 ++++++++++++++++++++++++++++++++
>>  net/bridge/br_mrp_timer.c      |  227 +++++
>>  net/bridge/br_netlink.c        |    9 +
>>  net/bridge/br_private.h        |   30 +
>>  net/bridge/br_private_mrp.h    |  208 +++++
>>  security/selinux/nlmsgtab.c    |    5 +-
>>  16 files changed, 2099 insertions(+), 1 deletion(-)
>>  create mode 100644 net/bridge/br_mrp.c
>>  create mode 100644 net/bridge/br_mrp_timer.c
>>  create mode 100644 net/bridge/br_private_mrp.h
>>
> 
> Hi all,
> I agree with Stephen here, IMO you have to take note of how STP has progressed
> and that bringing it in the kernel was a mistake, these days mstpd has an active
> community and much better support which is being extended. This looks best implemented
> in user-space in my opinion with minimal kernel changes to support it. You could simply
> open a packet socket with a filter and work through that, you don't need new netlink
> sockets. I'm not familiar with the protocol so can't really be the judge of that, if
> you present a good argument for needing a new netlink socket for these packets - then
> sure, ok.

nevermind the last sentence (about packet/netlink), I misread your earlier reply :)

> 
> If you do decide to continue with the kernel version (which I would again discourage)
> a few general points (from a quick scan):
>  - the single 1.6+k line patch is just hard to review, please break it into more digestable
>    and logical pieces
>  - the locking is wrong, also there're a few use-after-free bugs 
>  - please re-work the bridge integration code, it can be simplified and tests can be eliminated
>  - your netlink helpers usage is generally wrong and needs more work
>  - use the already existing port states instead of adding new ones and you can avoid some tests in fast-path
>  - perhaps look into using br_afspec() for configuration/retrieval initially ? I don't think you need the new rtm messages yet.
>  - I'm sure I can go on, but I really think all of this should be put in user-space -
>    in-kernel STP is a great example of how _not_ to do it. :) As a bonus you'll avoid 90% of the
>    problems above just by making your own abstractions and using them for it.
> 
> 
> Thanks,
>  Nik
> 

