Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9CB4B68FF
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 11:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiBOKQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 05:16:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiBOKQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 05:16:10 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD6210E078
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 02:15:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OmJLVDJKiMnkQ83FvXAtfKtsUWEcdRmB3C6p08Px3DMwemnJQMctGg037Zd0d78mYejGQy+YxHcTth96EL0L7y0RdG3xKKVgHqCdS389gwoWiaKSrJ2jZ5+S2EIeVxbU6WyfzwZXtSXbh6K8Im8aC/Je5AFurnfHFGpsCrXpPM3+fT3y6Rxpnrksb2ZORD+aAuLTorwxCaobdf3nyrkEUyN9S2fkiF/cGKtfd6HoAc+wPSQsimqy5ziVbl3gBpMjFwwj4WkSCLSB1Tu4qw5zm6ii6Zff8+TuHfxSroXOVViJZW23vHVcG1DrHqIazYgVBaVhj6z+HQV/jUB+jU9tYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cS+kGnwu5jn+7ZidQbpyVdG07dFw6QCiQZhiaNnQhnA=;
 b=fQeL4l+2uYh3nmXJkRtkYAu1U6H/Z1piOFEE6JJ00UkPXlOClj843gY3BYB4d+h/AavtTKPgCuaEbQpHvGUL9Nq9UskJyA79QMWMBghmjbQgKaJTWfe9PJmCqXygpXhV70FrtNFhPExnr8T5ULmAnNbp+62k97mhFrngefBMxjo3Rb9KMYDLf/Ie9MrQ/9IsXJXlWp2JkRexk/8ZPvsBWsTAVcyXO1ZdTuYuvKXuN2C4dC6TL993nWPDe5KmCPS9Dn4lA/yDqWid3CA2ZzfE6J7XHvZV6BaSAfkqhIo67wtukny6sGYdQPDOsN6SJ+cg+hgu529GhDIwksCqXfsLSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cS+kGnwu5jn+7ZidQbpyVdG07dFw6QCiQZhiaNnQhnA=;
 b=R0dgIYXvYYp1rmvOPCTnh0ljXfzK9LXSI8Xr7GQKtCsiVVwxBYf/p+FKAWGRUsDF+nu9X7EObGDRneCztnw5aa2sPnvTkM5JadhPb0eIRmmuRZ1JJ5r9nW7GfiMqW6gJ/oyyd4JTed7K34e62GIfj12YuKzISK9ypfmgaQ4YGlMj6q9eU6ZHbke+nsbqLKo+NWP21tRYjxeomXIgJe3U0uu5d0rChFuMKHb9GNV4P2+3ikvWnyQW2zoABZE83o/5dO7vm4IWMbjaDPu+2Lo8PSt3Ne7csZRYerw/z8sJQqNVdglI++/64OXACQpjMq96+ZycvuVIXrz+L6MkAK72Nw==
Received: from MWHPR13CA0002.namprd13.prod.outlook.com (2603:10b6:300:16::12)
 by BN6PR12MB1779.namprd12.prod.outlook.com (2603:10b6:404:108::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Tue, 15 Feb
 2022 10:15:57 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:16:cafe::9) by MWHPR13CA0002.outlook.office365.com
 (2603:10b6:300:16::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.8 via Frontend
 Transport; Tue, 15 Feb 2022 10:15:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Tue, 15 Feb 2022 10:15:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 15 Feb
 2022 10:15:56 +0000
Received: from [172.27.13.89] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 15 Feb 2022
 02:15:49 -0800
Message-ID: <52796722-dfa5-1c1a-c691-9ec86bb7e3dc@nvidia.com>
Date:   Tue, 15 Feb 2022 12:15:46 +0200
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
 <20220215101017.iug7kfzzmmov6f7b@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220215101017.iug7kfzzmmov6f7b@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a93f510b-7270-4f90-2b4b-08d9f06c2826
X-MS-TrafficTypeDiagnostic: BN6PR12MB1779:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB17797F1D882F548D692969E7DF349@BN6PR12MB1779.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FqXVVqit6MFhKfPu9HnBU7aRqM7a+iE9ZNdI8WGzbDwQcXZV4tcUdzrBl1Vh3JsIKITlktDOtdlk1juBssc9YBCPhZ9numBVEIm/G1nNW703C5Tr4k2fb06+RNRw9wpMBMqJLD9FejDFzATt2UClUOhdBGSQI8RVjaGsRkLQTqElqr2w62XcI2wXGlvobIyhkdLpWYOmtMrHLbaY95pnsAjKAdUMLPi96juhapPg5UwCJ8ZWe8d1LAKEJ4p3wSIQ5QlE3GBMuYy7HWQ2j37EdIYzTB5mqeFudPe969ECkNm2pk76h5teYwVachfuHXG0XvHgBI8mR02sjh8DuwhlCFLpOPmqsLhgyDbLlQQENrTSy1rw5iwM7VAome7wdvM7xJnJFlAk34jcG58FP5/RKjQtgtTckQ3j0Vssjn8R8C1JzzMZ2DfdZtNopRnuGO9uxhN2qt/G30oQQI6nLwzH5b7esSvmkw+PwZUGTVzbt5BZBK4PP5MB9Ex/+JGHYdS2fhFR2TJ52d8JUNMbYLBtTbnOoTMmXzI7UvuN29WiErzGfI48oSEwWnjx3I0vLAOpFxGPR1hgT1o2ipLV0t57taMJamZuxnisTikamaT21UHJT9htIjdDY+h+4Jf07g1kYG9ecxygdvJZvddAn7eopI2VamWxSQhUvd42/6+wAMxw6sLXExs30Pbyr5DpL8Xkd2eL+3/zGSxW3ldmSQc+729qoeIFJbiMJa0/7YyPR6quhY+FM2t18goWur5hQAXy
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(31686004)(2616005)(36756003)(8936002)(508600001)(6666004)(53546011)(70586007)(70206006)(86362001)(26005)(16526019)(186003)(316002)(356005)(2906002)(54906003)(81166007)(6916009)(5660300002)(7416002)(16576012)(426003)(47076005)(336012)(8676002)(82310400004)(4326008)(31696002)(40460700003)(36860700001)(83380400001)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 10:15:56.9110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a93f510b-7270-4f90-2b4b-08d9f06c2826
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1779
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

On 15/02/2022 12:10, Vladimir Oltean wrote:
> On Tue, Feb 15, 2022 at 11:54:05AM +0200, Vladimir Oltean wrote:
>> On Tue, Feb 15, 2022 at 10:54:26AM +0200, Nikolay Aleksandrov wrote:
>>>> +/* return true if anything will change as a result of __vlan_add_flags,
>>>> + * false otherwise
>>>> + */
>>>> +static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16 flags)
>>>> +{
>>>> +	struct net_bridge_vlan_group *vg;
>>>> +	u16 old_flags = v->flags;
>>>> +	bool pvid_changed;
>>>>  
>>>> -	return ret || !!(old_flags ^ v->flags);
>>>> +	if (br_vlan_is_master(v))
>>>> +		vg = br_vlan_group(v->br);
>>>> +	else
>>>> +		vg = nbp_vlan_group(v->port);
>>>> +
>>>> +	if (flags & BRIDGE_VLAN_INFO_PVID)
>>>> +		pvid_changed = (vg->pvid == v->vid);
>>>> +	else
>>>> +		pvid_changed = (vg->pvid != v->vid);
>>>> +
>>>> +	return pvid_changed || !!(old_flags ^ v->flags);
>>>>  }
>>>
>>> These two have to depend on each other, otherwise it's error-prone and
>>> surely in the future someone will forget to update both.
>>> How about add a "commit" argument to __vlan_add_flags and possibly rename
>>> it to __vlan_update_flags, then add 2 small helpers like __vlan_update_flags_precommit
>>> with commit == false and __vlan_update_flags_commit with commit == true.
>>> Or some other naming, the point is to always use the same flow and checks
>>> when updating the flags to make sure people don't forget.
>>
>> You want to squash __vlan_flags_would_change() and __vlan_add_flags()
>> into a single function? But "would_change" returns bool, and "add"
>> returns void.
> 
> Plus, we have call paths that would bypass the "prepare" stage and jump
> to commit, and for good reason. Do we want to change those as well, or
> what would be the benefit?

It's not really prepare (doesn't have any effect), it's a precommit check.
You can keep the would change name, just make sure both wrappers use the
same function so people will be changing just 1 function and won't forget
to update anything. Would be nice to add a comment about it.
