Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48ED4B6A52
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbiBOLIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:08:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236941AbiBOLIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:08:44 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B94107D0B
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 03:08:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsesN8Oh7FrSMq4SxRLL+5m3Q51runYb53me0rmdgmpFAmI8PAPPKvbfoC7yOIanCR0spj8eHvEUy9uKjaHaQUk+x1Ulw3aTN5kNNvlET0UwtLrhxj6fg8MO0vUsoWw3G/pvWujWv2Rmh2EmbMPYfkO8ieTX0A4TyyV+Ea8kBhrAzsExHCFC5AytJ9LtURCIBNH9txRmQsOM/RRzMxL6tzluw0S2gRwhUep4srM8Q+4oDuOdrfcQUQNqOfWVqCpbLCCNHLCFeNile8Om3JsK6pEw1f8s7kzzL7ogyvxH3iXt7O2+b5zXWnHhDQYs2FnWzaI6OP4z2OiLYOoYHzH0vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZKfTxVel3Q+R7C28XnlBbtcp0pljDlgTmylGrviJhP0=;
 b=VDHoM81Ty7feUPgm8sApSc/eeFSlMoi0RTEZ27J0n98CoQG+UeITru29qx1p9Uqd176nAvE75Y11BoMR+N4v0Scze6JETZX1V2GTT9/w0KH0lSj80/zRFWkdD9uj+XcnwwPAdYbNKNAaZvKvqU5GKtcEktyu0padBscrbfuxQqlkCUt9qXoeluw800VCu7Y5SAC4hV57TSZcEKHQo4xc/I612wuUzdKGALKL9W5OgU+8ig+IHyWoNBcJycECijqYQkZDLq9Cm/4lqsMK1Un0JhxUR0d/E8b8V8BmuNbK+QHJcbnkn/y7nTuZ04XBsEjSmV7+CnAB81/Lk/9Iuswspg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZKfTxVel3Q+R7C28XnlBbtcp0pljDlgTmylGrviJhP0=;
 b=ibcLk2CrtG4yIyzmSeANWSo9IYbVlao2/2pMBidQm/Ecr/g84ZprqozehtVsDp64lmawVeVuPziwSgA6+iA/lU2QHqvYIjKWeNkKOJgRN8np1tadjGAE1LFAUhh+muRW6HG60VKVfeo6vFoASjLGiE1in8Ce7cB0a3tJGLPxqonqPyP3M7LJC3oVRP/Z9CIWPeqK0S3HsDNj3RE6hSbP52Pk5sk44uhoqHKjUnKjyHnNv5j5KVIwKr8UOgDj09xBCsJnpFx6TM/NfL42Lj0PycKJbwvziw/LlmLSi54VeG0IZcTZW1JE8w4LTgflapXN59mqJif5X8LlZoEBp4JlUQ==
Received: from BN9PR03CA0517.namprd03.prod.outlook.com (2603:10b6:408:131::12)
 by CH2PR12MB4972.namprd12.prod.outlook.com (2603:10b6:610:69::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Tue, 15 Feb
 2022 11:08:33 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:131:cafe::b9) by BN9PR03CA0517.outlook.office365.com
 (2603:10b6:408:131::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Tue, 15 Feb 2022 11:08:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Tue, 15 Feb 2022 11:08:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 15 Feb
 2022 11:08:23 +0000
Received: from [172.27.13.89] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 15 Feb 2022
 03:08:17 -0800
Message-ID: <5db82bf1-844d-0709-c85e-cbe62445e7dc@nvidia.com>
Date:   Tue, 15 Feb 2022 13:08:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220214233111.1586715-1-vladimir.oltean@nxp.com>
 <20220214233111.1586715-2-vladimir.oltean@nxp.com>
 <bcb8c699-4abc-d458-a694-d975398f1c57@nvidia.com>
 <20220215095405.d2cy6rjd2faj3az2@skbuf>
 <a38ac2a6-d9b9-190a-f144-496be1768b98@nvidia.com>
 <20220215103009.fcw4wjnpbxx5tybj@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220215103009.fcw4wjnpbxx5tybj@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb4a0c63-ae6d-4b6f-40ba-08d9f073813f
X-MS-TrafficTypeDiagnostic: CH2PR12MB4972:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB497226712E6169C647666FCDDF349@CH2PR12MB4972.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: swHY5xxDH3xeKO3ZS8fAdi83JCUjngcxg1Ut+DF0BIlAYG8SXxdioOD8Mjpq9Q8LDV908DWMQBjyNyAyTX8cTPFaA7okW1MFKmCc7tyPNIi6yL/pZcBwEjtIV2/oIS4O2Rc9EtjELg30N/Myzc0DSMKHK2O2VKK6Io5pbOnuxOY0lPbX4N82Jo/QCWYPJD2IlNVzcNQVoXQHlRNKLllEbyUdJ8km0zKZm+FBRr3iBM3mPrwADBI8wV4aI2oVQrwtoL73GRdEiJefn7JN228lwB4pfqM3rj1RGMOOkKVU4SrsCSORnYWUklag5wK9+8idY1E60UQuo52Rzrd0g7q7Ofyx/R3R+GpIzCh67TYzBCZOKHemwVnJkT/7mSbbTbv+cqeVvd5wZVU7qX+IH40hFCdgLj1i9ZUOB5BoyJQTezwIQB9xU++q3WblCB8c54NLvPyS9wzAtj09dSQdZewkSJ7a67qMm4uEmiYLwNV8brjF3PL3HxDcbSxB0HLGvN1hAaZp3v75xRL6UJnVf85J5v1OUnraJpxqcEguKAfoHg7EM9x18F1BbMP2c40wABwRk8fOl4P5/lKyAHhDMPe2WLufFmDAVDpWw7cc9k9J/7HfUEnk5fnJpDNyqSf8VrZgVOOLO+jXutl+kCkGGawk+CiPzxP1dv+qbOnoHFIkoiYtHbztq5A4Z61o4HFSxjl1AM+1AS2/eBVnFTeA9TeYlQ/TTZWaJAFSq+Hl1M2UdmjqjXT0xaWpbfeHAWxSkFUi
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36756003)(31686004)(5660300002)(508600001)(6666004)(2906002)(53546011)(7416002)(36860700001)(6916009)(16526019)(82310400004)(70206006)(316002)(16576012)(47076005)(26005)(336012)(356005)(54906003)(426003)(40460700003)(4326008)(83380400001)(81166007)(70586007)(2616005)(31696002)(86362001)(8936002)(8676002)(186003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 11:08:32.8228
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb4a0c63-ae6d-4b6f-40ba-08d9f073813f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4972
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/02/2022 12:30, Vladimir Oltean wrote:
> On Tue, Feb 15, 2022 at 12:12:11PM +0200, Nikolay Aleksandrov wrote:
>> On 15/02/2022 11:54, Vladimir Oltean wrote:
>>> On Tue, Feb 15, 2022 at 10:54:26AM +0200, Nikolay Aleksandrov wrote:
>>>>> +/* return true if anything will change as a result of __vlan_add_flags,
>>>>> + * false otherwise
>>>>> + */
>>>>> +static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16 flags)
>>>>> +{
>>>>> +	struct net_bridge_vlan_group *vg;
>>>>> +	u16 old_flags = v->flags;
>>>>> +	bool pvid_changed;
>>>>>  
>>>>> -	return ret || !!(old_flags ^ v->flags);
>>>>> +	if (br_vlan_is_master(v))
>>>>> +		vg = br_vlan_group(v->br);
>>>>> +	else
>>>>> +		vg = nbp_vlan_group(v->port);
>>>>> +
>>>>> +	if (flags & BRIDGE_VLAN_INFO_PVID)
>>>>> +		pvid_changed = (vg->pvid == v->vid);
>>>>> +	else
>>>>> +		pvid_changed = (vg->pvid != v->vid);
>>>>> +
>>>>> +	return pvid_changed || !!(old_flags ^ v->flags);
>>>>>  }
>>>>
>>>> These two have to depend on each other, otherwise it's error-prone and
>>>> surely in the future someone will forget to update both.
>>>> How about add a "commit" argument to __vlan_add_flags and possibly rename
>>>> it to __vlan_update_flags, then add 2 small helpers like __vlan_update_flags_precommit
>>>> with commit == false and __vlan_update_flags_commit with commit == true.
>>>> Or some other naming, the point is to always use the same flow and checks
>>>> when updating the flags to make sure people don't forget.
>>>
>>> You want to squash __vlan_flags_would_change() and __vlan_add_flags()
>>> into a single function? But "would_change" returns bool, and "add"
>>> returns void.
>>>
>>
>> Hence the wrappers for commit == false and commit == true. You could name the precommit
>> one __vlan_flags_would_change or something more appropriate. The point is to make
>> sure we always update both when flags are changed.
> 
> I still have a little doubt that I understood you properly.
> Do you mean like this?
> 

By the way I just noticed that __vlan_flags_would_change has another bug, it's testing
vlan's flags against themselves without any change (old_flags == v->flags).

I meant something similar to this (quickly hacked, untested, add flags probably
could be renamed to something more appropriate):

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 1402d5ca242d..1de69090d3cb 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -34,53 +34,66 @@ static struct net_bridge_vlan *br_vlan_lookup(struct rhashtable *tbl, u16 vid)
        return rhashtable_lookup_fast(tbl, &vid, br_vlan_rht_params);
 }
 
-static bool __vlan_add_pvid(struct net_bridge_vlan_group *vg,
+static void __vlan_add_pvid(struct net_bridge_vlan_group *vg,
                            const struct net_bridge_vlan *v)
 {
        if (vg->pvid == v->vid)
-               return false;
+               return;
 
        smp_wmb();
        br_vlan_set_pvid_state(vg, v->state);
        vg->pvid = v->vid;
-
-       return true;
 }
 
-static bool __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid)
+static void __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid)
 {
        if (vg->pvid != vid)
-               return false;
+               return;
 
        smp_wmb();
        vg->pvid = 0;
-
-       return true;
 }
 
 /* return true if anything changed, false otherwise */
-static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
+static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags, bool commit)
 {
        struct net_bridge_vlan_group *vg;
-       u16 old_flags = v->flags;
-       bool ret;
+       bool change;
 
        if (br_vlan_is_master(v))
                vg = br_vlan_group(v->br);
        else
                vg = nbp_vlan_group(v->port);
 
+       /* check if anything would be changed on commit */
+       change = (!!(flags & BRIDGE_VLAN_INFO_PVID) == !!(vg->pvid != v->vid) ||
+                 ((flags ^ v->flags) & BRIDGE_VLAN_INFO_UNTAGGED));
+
+       if (!commit)
+               goto out;
+
        if (flags & BRIDGE_VLAN_INFO_PVID)
-               ret = __vlan_add_pvid(vg, v);
+               __vlan_add_pvid(vg, v);
        else
-               ret = __vlan_delete_pvid(vg, v->vid);
+               __vlan_delete_pvid(vg, v->vid);
 
        if (flags & BRIDGE_VLAN_INFO_UNTAGGED)
                v->flags |= BRIDGE_VLAN_INFO_UNTAGGED;
        else
                v->flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
 
-       return ret || !!(old_flags ^ v->flags);
+out:
+       return change;
+}
+
+static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16 flags)
+{
+       return __vlan_add_flags(v, flags, false);
+}
+
+static bool __vlan_flags_commit(struct net_bridge_vlan *v, u16 flags)
+{
+       return __vlan_add_flags(v, flags, true);
 }
 
 static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
