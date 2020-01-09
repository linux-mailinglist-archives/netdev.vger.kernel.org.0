Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC093135FB2
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388331AbgAIRu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:50:57 -0500
Received: from mail1.fiberby.net ([193.104.135.124]:40390 "EHLO
        mail1.fiberby.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730326AbgAIRu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 12:50:56 -0500
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Jan 2020 12:50:55 EST
Received: from x201s.roaming.asbjorn.biz (193-104-135-243.ip4.fiberby.net [193.104.135.243])
        by mail1.fiberby.net (Postfix) with ESMTPSA id A759A6010C;
        Thu,  9 Jan 2020 17:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fiberby.net;
        s=201905; t=1578591697;
        bh=aO90ZkWcNxvVfMQ699FY54Oi71pyX/FoCIGUYqP1+0U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ZGdO3bXag3oQlpfK+0ry+F2q+jK9NIvMoyCTZ+8g9s+A5xN6ZwndRz+s0AzM6Hjri
         vJT0o0qp16Oooy5k36E16sHSREKf2SpYLk9WYAvXLgDD3Td2OBAqG/oGyh6Woxe45k
         irwutle4gtBzSVE4jfjejfDbJxyt1hg9bhjwymFPIh68o9032/zKqmSOQuYI/ly/Zx
         4EWS9aTpVexV78lZonSKKVul6ey7gZofKsCB1Q7ocC89MNvl3Ar2fS/7Wn3OpB2t4D
         aa6nMdpgdh89WFlMINxTgHHCo6ZSVzFTtGr7B2KcwudgJilzAt9zEnqlfE9EZY9aDG
         V5wfaYA+QQ33A==
Received: from x201s.roaming.asbjorn.biz (localhost [127.0.0.1])
        by x201s.roaming.asbjorn.biz (Postfix) with ESMTP id 0AC5020023E;
        Thu,  9 Jan 2020 17:41:34 +0000 (UTC)
Subject: Re: [Bridge] [RFC net-next Patch 0/3] net: bridge: mrp: Add support
 for Media Redundancy Protocol(MRP)
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     andrew@lunn.ch, jakub.kicinski@netronome.com,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        UNGLinuxDriver@microchip.com, anirudh.venkataramanan@intel.com,
        jiri@mellanox.com, jeffrey.t.kirsher@intel.com, dsahern@gmail.com,
        olteanv@gmail.com, davem@davemloft.net,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20200109150640.532-1-horatiu.vultur@microchip.com>
 <20200109081907.06281c0f@hermes.lan>
From:   =?UTF-8?Q?Asbj=c3=b8rn_Sloth_T=c3=b8nnesen?= <ast@fiberby.net>
Message-ID: <da02006c-dc9d-ce1a-861e-4fc1c1dc2830@fiberby.net>
Date:   Thu, 9 Jan 2020 17:41:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200109081907.06281c0f@hermes.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu and Stephen,

Horatiu, thanks for giving this a try. I am looking forward to maybe someday
be able to run ERPS on white box switches.

On 1/9/20 4:19 PM, Stephen Hemminger wrote:
> Can this be implemented in userspace?
> 
> Putting STP in the kernel was a mistake (even original author says so).
> Adding more control protocols in kernel is a security and stability risk.

Another case is VRRP, ERPS (ITU-T G.8032), VRRP group.

My use-case might not be common, but I have machines with about 10k net_dev (QinQ),
I would like to be able to do VRRP group on the outer VLANs, which are only a few
hundred instances without excessive context switching. I would then keep the the
normal keep-alive state machine in kernel, basically a BPF-based timed periodic
packet emitter facility and a XDP recieve hook. So only setup and event handling
has to context switched to user-space.

Unfortunately I haven't had time to explore this yet, but I think such an approach
could solve a few of the reasons that scalable bridge/ring/ha protocols have to wait
20 years before being implemented in Linux.

-- 
Best regards
Asbjørn Sloth Tønnesen
Network Engineer
Fiberby ApS - AS42541
