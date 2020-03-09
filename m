Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90CC017E5F5
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbgCIRrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:47:11 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59366 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbgCIRrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:47:11 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E731458005A;
        Mon,  9 Mar 2020 17:47:09 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 9 Mar 2020
 17:47:01 +0000
Subject: Re: [patch net-next v4 01/10] flow_offload: Introduce offload of HW
 stats type
To:     Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <saeedm@mellanox.com>, <leon@kernel.org>,
        <michael.chan@broadcom.com>, <vishal@chelsio.com>,
        <jeffrey.t.kirsher@intel.com>, <idosch@mellanox.com>,
        <aelior@marvell.com>, <peppe.cavallaro@st.com>,
        <alexandre.torgue@st.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <pablo@netfilter.org>,
        <mlxsw@mellanox.com>
References: <20200307114020.8664-1-jiri@resnulli.us>
 <20200307114020.8664-2-jiri@resnulli.us>
 <1b7ddf97-5626-e58c-0468-eae83ad020b3@solarflare.com>
 <20200309173412.GF13968@nanopsycho.orion>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <28ec0ed4-38b6-bb27-d769-5bf9d1d4f09c@solarflare.com>
Date:   Mon, 9 Mar 2020 17:46:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200309173412.GF13968@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25278.003
X-TM-AS-Result: No-2.322600-8.000000-10
X-TMASE-MatchedRID: cgbqQT5W8hfmLzc6AOD8DfHkpkyUphL9hhy6s2hQl4SmsJrgXrmYK12v
        ft2Sc3zC1V2t9BS+kTGq8GB8/0VLshPXzMq0J6v++Fq9Vk/m1Nr17lqbebntfclgi/vLS272Cto
        21bgORlh94sx2jukY5BxtvLYB7XTZZ5vCKrIOHHE3X0+M8lqGUj2SB1qSnBxNQzcrLK1tq+ejxY
        yRBa/qJfkvV+z371TK5MIx11wv+COujVRFkkVsm9vLamDgern+xb05EzyCl9pBBcV/jfKoLkhUd
        c2GZ+yk3+7fgXRWYBbE6L66514Xd4UJZCtuXB+0jfgKRvTCaV+Wp1fntiL+6oVyAlz5A0zC7xsm
        i8libwVi6nHReNJA8sM4VWYqoYnhs+fe0WifpQo=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.322600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25278.003
X-MDID: 1583776031-Kju5QkZcsZnF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/03/2020 17:34, Jiri Pirko wrote:
> Mon, Mar 09, 2020 at 05:52:16PM CET, ecree@solarflare.com wrote:
>> An enum type seems safer.
> Well, it's is a bitfield, how do you envision to implement it. Have enum
> value for every combination? I don't get it.
enum flow_action_stats_type {
    FLOW_ACTION_HW_STATS_TYPE_DISABLED=0,
    FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE=BIT(0),
    FLOW_ACTION_HW_STATS_TYPE_DELAYED=BIT(1),
    FLOW_ACTION_HW_STATS_TYPE_ANY=(FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE |
                                   FLOW_ACTION_HW_STATS_TYPE_DELAYED),
};

It's not a requirement of the language for every value used withan
 enumeration to be a defined enumerator value, so if someone ends up
 putting (FLOW_ACTION_HW_STATS_TYPE_FOO | FLOW_ACTION_HW_STATS_TYPE_BAR)
 into (say) a driver that supports only FOO and BAR, that will work
 just fine.  I don't see what problem you expect to occur here.

-ed
