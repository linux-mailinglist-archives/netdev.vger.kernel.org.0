Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E4E4B8675
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiBPLIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:08:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiBPLIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:08:17 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C775FA2533
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 03:08:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NP10pckpziaF9EbARC2mA8ZPMfdyExmB9M3YVqd/cywX+xVLEkhsByUaGXnK7KkeBHCPYzRhfrSHv5RfhVxKPihFMuZ0828bepmVCaRlxiQS7XqiUXhzdCGs6FFu/kaV+8KwI6JCI74D9YD3OscqCj/C/JRiDhJNYRBxaOGZjILDRQtXt20sx1Wpbv/a3FTcHJpx+6AeuobltWXRJ4hHWwSwoveyKu6dq8LgAYvtEbirybkdGzdG1zGo7U+UP6EeKlQeNe0JNNY4WrMKGx8K1QkkuZaFbdQprqKZlsj1pp87nTKM9j/RtxPY5xa9GUbmr9dacEC3nPpAuuTs2VkB5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqBqlMgyES3RqDM3X+BMFNnAApQEIiUqR8cGBaMyrus=;
 b=QoeO5sc0A1qUc/L5h5jHLAhAM4Cht9nPq4oVoRMMRvmmXnUeOIuNOaXaPAEDs7GpPeQEyTvmoYLpAzSWGZkdjBv674KI7T5FQM4D1GDUVxLk2o4CLmsHKP+WBA1BFgb54/Ym8IGF7tfX3IZwBaZ1tN7cEl4BKU5oc3pKONvSVM3724q+vVx97pkUmthvsQpkj2khiL6VtX46LylGBbYL1WDvURcdksTckXsdAFsw3mOPfn6NNxEWkd4oYBZXsMSgAJA45iMAWw43xKR0vXknjCbeBOD1cIJ4KegUBwF8hne7xwJe7YF5YiTMUzvNdBoOVly74mtazc+We4R526DxWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqBqlMgyES3RqDM3X+BMFNnAApQEIiUqR8cGBaMyrus=;
 b=YO9kSfERY+KNDygJuvS2zmRrT71BMrneWIpCI04LoS/h/TWADc8E6PQA87EDo7JxRRgIV/3RjN1EvJH4VcPedZ5JKUG2ot/siLh51c+TebJy/oveX0voWloL8oabbjCr5dp00b07IkISZmw14lLHn0kHJ/LOeOccWZh9+0szngSH5NMLD3BSNXcmQ2nKIGkHIHy1K63r3QGzUu8+NR9LdnRdBVCf3BS5jkfS4yUdvAZV36A77k0CY9XuZLGLJYiz0vVTWbtTwzJJOb0wADvKDzWBf+dMqfum7nvwyIPG1mDeaNheUQJrs10pnq6ZlSYyNpS8cwsuRzMDyUTWH3CoTw==
Received: from DM5PR18CA0077.namprd18.prod.outlook.com (2603:10b6:3:3::15) by
 PH7PR12MB5928.namprd12.prod.outlook.com (2603:10b6:510:1db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Wed, 16 Feb
 2022 11:08:03 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::e0) by DM5PR18CA0077.outlook.office365.com
 (2603:10b6:3:3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17 via Frontend
 Transport; Wed, 16 Feb 2022 11:08:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 11:08:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 11:08:02 +0000
Received: from [172.27.13.137] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 03:07:55 -0800
Message-ID: <d396a685-11c6-4927-26fa-e8a9c8a51ffe@nvidia.com>
Date:   Wed, 16 Feb 2022 13:07:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 net-next 03/11] net: bridge: vlan: make
 __vlan_add_flags react only to PVID and UNTAGGED
Content-Language: en-US
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
 <20220215170218.2032432-4-vladimir.oltean@nxp.com>
 <79237e2d-e1d2-c6cd-975d-b28f064a2c20@nvidia.com>
In-Reply-To: <79237e2d-e1d2-c6cd-975d-b28f064a2c20@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d17019d-24e9-436b-d7e4-08d9f13c9a10
X-MS-TrafficTypeDiagnostic: PH7PR12MB5928:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5928ECFB14690F3B3CB94A8EDF359@PH7PR12MB5928.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HpMqbqAbT2yEfUoDxoJMj7gnSSVRhN+1N8xn22fPvukjcDQ0ap0WmL5RsZBvMjOVJvvwBancRMMfhINYgSgDjUUGl389rNSoIbOyspAm5rUXbuaCKl7fKU0CQNKUoNR8KPo4WmFQ+Ykiw4kiKuGphUkh+1SyLZTu2j/79ajjmEDb9smH8+Ak5U6RrnANr2wXwhoa9yPOkdy1BRdZyXu3p0nz8Zq+NLu2ZGfvrCuffAVy2NaG3LLSSWTLsejQGK+Mo8jEAhnsK5ueyHPcm9j0aCKPdeTBA53rzjxF5HoXnSbHIpEH3MTtZyLfSKAx6w9s0aBK6Fc7+lGhJkoJCxRuKeB0LnfcaTn98jrLmvD7neuhtt036W5jF6IioYA0kOIaiQIRY9OPQVQISG5FSSOEmAWKDYEdTeLTVrPURH3ikVmgvegO/9YJf+SduvXpfJBDchU+XjlkyitTmeYYX5bY1po+CEEICpkkPXiIcTQ23ouqaSc/NclS7KMlizncXtRnWfJuK5lbJA+v6wh/XhPQnQiqEXueuxqsKm4PoU/YwIaLt6kaprySu/y2vSMxeSIKHvhYX4r4oenkyCjyOi0lEBAafv9FQtZZyJzxl6a7LUyT0HwlZ5mLCB8MC5HVGmygp68uRF6e2ypyexZ3yhFIPp/3OkTQQ1Hem+1NoNWIia30aJQCM0L8y3LfcIr4QyyBnVVNSCTRMNHjD8eeAGcuEqw7lyyXJRFsi7/vyzD6K0TS1SV3z7cM9hFYlRiC+m/r
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(426003)(336012)(54906003)(508600001)(316002)(83380400001)(110136005)(82310400004)(86362001)(16576012)(31686004)(47076005)(36860700001)(6666004)(2906002)(31696002)(2616005)(16526019)(36756003)(7416002)(186003)(4326008)(8676002)(53546011)(356005)(5660300002)(70206006)(81166007)(8936002)(26005)(40460700003)(70586007)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 11:08:03.3512
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d17019d-24e9-436b-d7e4-08d9f13c9a10
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5928
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

On 16/02/2022 13:03, Nikolay Aleksandrov wrote:
> On 15/02/2022 19:02, Vladimir Oltean wrote:
>> Currently there is a very subtle aspect to the behavior of
>> __vlan_add_flags(): it changes the struct net_bridge_vlan flags and
>> pvid, yet it returns true ("changed") even if none of those changed,
>> just a transition of br_vlan_is_brentry(v) took place from false to
>> true.
>>
>> This can be seen in br_vlan_add_existing(), however we do not actually
>> rely on this subtle behavior, since the "if" condition that checks that
>> the vlan wasn't a brentry before had a useless (until now) assignment:
>>
>> 	*changed = true;
>>
>> Make things more obvious by actually making __vlan_add_flags() do what's
>> written on the box, and be more specific about what is actually written
>> on the box. This is needed because further transformations will be done
>> to __vlan_add_flags().
>>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> ---
>> v2->v3: patch is new
>>
>>  net/bridge/br_vlan.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
>> index 498cc297b492..89e2cfed7bdb 100644
>> --- a/net/bridge/br_vlan.c
>> +++ b/net/bridge/br_vlan.c
>> @@ -58,7 +58,9 @@ static bool __vlan_delete_pvid(struct net_bridge_vlan_group *vg, u16 vid)
>>  	return true;
>>  }
>>  
>> -/* return true if anything changed, false otherwise */
>> +/* Returns true if the BRIDGE_VLAN_INFO_PVID and BRIDGE_VLAN_INFO_UNTAGGED bits
>> + * of @flags produced any change onto @v, false otherwise
>> + */
>>  static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
>>  {
>>  	struct net_bridge_vlan_group *vg;
>> @@ -80,7 +82,7 @@ static bool __vlan_add_flags(struct net_bridge_vlan *v, u16 flags)
>>  	else
>>  		v->flags &= ~BRIDGE_VLAN_INFO_UNTAGGED;
>>  
>> -	return ret || !!(old_flags ^ v->flags);
>> +	return ret || !!((old_flags ^ v->flags) & BRIDGE_VLAN_INFO_UNTAGGED);
>>  }
>>  
>>  static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,
> 
> This patch is unnecessary and can be dropped given the next one.

OTOH being explicit is not bad, nevermind my comment. I'd just have put
this change after the refactoring, but it's ok either way.

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

