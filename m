Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058451722A9
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 16:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbgB0P5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 10:57:45 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:53244 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729274AbgB0P5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 10:57:45 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8D5444C0059;
        Thu, 27 Feb 2020 15:57:43 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 27 Feb
 2020 15:57:34 +0000
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW stats
 type
To:     Jiri Pirko <jiri@resnulli.us>, Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <saeedm@mellanox.com>, <leon@kernel.org>,
        <michael.chan@broadcom.com>, <vishal@chelsio.com>,
        <jeffrey.t.kirsher@intel.com>, <idosch@mellanox.com>,
        <aelior@marvell.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <xiyou.wangcong@gmail.com>,
        <pablo@netfilter.org>, <mlxsw@mellanox.com>
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
 <20200224131101.GC16270@nanopsycho>
 <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
 <20200224162521.GE16270@nanopsycho>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <c149d5e1-e2a4-71c8-68e8-5a08b02a57f7@solarflare.com>
Date:   Thu, 27 Feb 2020 15:57:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200224162521.GE16270@nanopsycho>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25256.003
X-TM-AS-Result: No-6.892900-8.000000-10
X-TMASE-MatchedRID: vEvJ7Rh1lGjmLzc6AOD8DfHkpkyUphL9sKi4EXb8AIprvf5eVgMu7Pl+
        hNlUoH3vCbljYuBjZafMWIN5/xAIPFXKKbgrtyh88sc9oYKBve0edbTsDE6BP//rgj9ncWz9MeT
        dqMbWFbkKz3nQwl8s8lznGj19LiwL7VVa6H+v8r/KpUenZy+yng73P4/aDCIFAv57j5eT9BYtgg
        Ft5MvFq6QOANr8fESAHjp5FN0r1FiPG6kqlFlR4r09KAokwDFU9e5am3m57X1WPcnrekBHfKeeg
        I8Z8ffsfMtvnnFP0XjhreRc/fcXVa42liFPoJXkuZBZOg7RfX8A+JHhu0IR5hQUOSCpbPwO94do
        8m0JE5LPBTE2aRq1vCjmA30q8LSsojetVtTnysHvVbHa5Rs8t30tCKdnhB581B0Hk1Q1KyL3PDi
        XO/tFSY6HM5rqDwqtnp8dbM32b4Jiz/oWO4ocKisrDnP4JEe5k24LsI9E/qUhyLeDpg+JL0MMpr
        cbiest
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.892900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25256.003
X-MDID: 1582819064-GhxrtL4MtYYW
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/02/2020 16:25, Jiri Pirko wrote:
> In hardware, we have a separate "counter" action with counter index.
> You can reuse this index in multiple counter action instances.
> However, in tc there is implicit separate counter for every action.
Importantly, not all actions have counters.  Only those with a
 .stats_update() method in their struct tc_action_ops have an implicit
 counter (which requires hardware offload), and to a first approximation
 those are the 'deliverish' actions (pass, drop, mirred).
This informs the sfc design below.

> The counter is limited resource. So we overcome this mismatch in mlxsw
> by having action "counter" always first for every rule inserted:
> rule->action_counter,the_actual_action,the_actual_action2,...the_actual_actionN
>
> and we report stats from action_counter for all the_actual_actionX.
For comparison, here's how we're doing it in the upcoming sfc hardware:
Rather than a sequence of actions in an arbitrary order (applied
 cumulatively to the original packet), we have a concept of an 'action
 set', which is some subset of a fixed sequence of actions, the last of
 which is a delivery.  (One of these actions is 'count', which takes one
 or more counter IDs as its metadata.)  Then the result of a rule match
 is an _action set list_, one or more action sets each of which is
 applied to a separate copy of the original packet.
This works because the delivery (hw) action corresponds to the only (tc)
 action that wants stats, combined with some cleverness in the defined
 order of our fixed action sequence.  And it means that we can properly
 support per-action counters, including making stats type be a per-action
 property (if one of the mirreds doesn't want stats, just don't put a
 'count' in that action-set).
For shared counters we just use the same counter index.  Mapping from
 tc action index to hw counter index is handled in the driver (transparent
 to userspace).

So from our perspective, making stats-type a property of the TC action is
 the Right Thing and fits in with the existing design of TC.  See also my
 old RFC series restoring per-action stats to flow_offload [1] which (in
 patch 4/4) added a 'want_stats' field to struct flow_action_entry; this
 would presumably become an enum flow_cls_hw_stats_typeto support these
 new stats-type semantics, and would be set to
 FLOW_CLS_HW_STATS_TYPE_DISABLEDif act->ops->stats_update == NULL
 regardless of the stats-type specified by the user.

-ed

[1] http://patchwork.ozlabs.org/cover/1110071/
