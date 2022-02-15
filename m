Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E864B6A5D
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbiBOLKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:10:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236970AbiBOLKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:10:39 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2048.outbound.protection.outlook.com [40.107.95.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1171107D36
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 03:10:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJMGQCFSxM7esgZS/y0r4VKBXuq6rTw2wsQd4dt/q5gSA4U/dNdFKXtFIeB+jzIF8tk7keqtzxAtVVnBdcHgO6xFk551/ncxEtP6U4G5bcz3XHEsM0pwpPq20GYJ7IrNIuUllhQ0rTn7HMMBpxS/yzSyvE8J/2aGr/Y1guXZJ6qp7q7i33gyyY4WSOcKL/PclRtfR+7YqOvdPwLVh2jn9T10xtbJSVoRsSQoYnTayo69ciyvodU04fLHauf4anW94QrSBsLEKoNXdrsJCwbg2wtaFBEAwlxtWQ5iQYKWoEjEgCyHatGiNZ6AY4PRwrS8UbhExZQkaZVp9XEIaQ4OiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O4FdTrs6+Qryv8MtgaZCm0cL20UVfh67KTTOo9ESghQ=;
 b=e3AcOXKNoCmNXGmIHljYfEhWVTutl0xyLxiIaZ7Ap/mQ2d4MKXLBaJZVe8MyD8QYA+7I0UGoiLavNRRzw/mbqUgU0HhOjCPexNOytNpLJJAlLcRM6limqqXAT+340UVliv/l/9TF9INfu/D2L/FUDvlIhr9rmMZpMZoOzax6GOTEXJxoXd/ZyYcXmdy741Hqb3/+A1rKMcUzzNjfvmIxCEB+4un0XU4sTkDqLl2XVy1VGDIMP2I5dv2vesgLFJTl9xlJ9iK+E/G5DPzNO92C8Ncah8DZ4L1p4UbNEI23NycnT6eF/v5wjDCbj4NOOWhTrlgX5G/u1HvbvpXBCHpkrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4FdTrs6+Qryv8MtgaZCm0cL20UVfh67KTTOo9ESghQ=;
 b=hjjwRqK5A5FMJrbG5A2QkLfIaqGzUIRuwseK9pvugmf7UMlnvIelVG1SrEXooF6wRaZkJTdIY0i67ZCwWWDGPe2kNK1Dyw8LoHs++0A30O9oSn+RSCuDn5463O8jB6HcctRDhP0ZIbbFbxoIjuPxy9lmTEd4nZ16cYAiC8d1F+EUyJlVRPY1YvCDZ14KW0MDqYr+aj18FWBaVi9EXcBKVbtQBiw/ALWoy/MvSmBo7U6taw4tM/ClCmeI0zoefUmGjdowjone34vCyOfyzOelwEd2FYyrCC+0xz1vHSPJgbnwi9oOgQG10rPHhVoDJDfO5Q4RVa64ruchGVi8KCKQ3w==
Received: from BN9P221CA0012.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::7)
 by DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Tue, 15 Feb
 2022 11:10:25 +0000
Received: from BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::d4) by BN9P221CA0012.outlook.office365.com
 (2603:10b6:408:10a::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12 via Frontend
 Transport; Tue, 15 Feb 2022 11:10:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT007.mail.protection.outlook.com (10.13.177.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Tue, 15 Feb 2022 11:10:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 15 Feb
 2022 11:10:16 +0000
Received: from [172.27.13.89] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 15 Feb 2022
 03:10:09 -0800
Message-ID: <05481f69-84d5-dc80-a620-7cd9f0e5a758@nvidia.com>
Date:   Tue, 15 Feb 2022 13:10:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 1/8] net: bridge: vlan: notify switchdev only
 when something changed
Content-Language: en-US
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
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
 <5db82bf1-844d-0709-c85e-cbe62445e7dc@nvidia.com>
In-Reply-To: <5db82bf1-844d-0709-c85e-cbe62445e7dc@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e907eed-bc20-42e7-4af1-08d9f073c450
X-MS-TrafficTypeDiagnostic: DM6PR12MB4337:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB433779957C84DEE9FC71749EDF349@DM6PR12MB4337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pgdxUqJg4+YRj6Mg7euBhNxF3aR7tOiOM6ffRakES5n9Xtr5LMQLsTtzJk0Y0nzhjbZFRaepRko10CZvKAvpPXrySebBZlOB09T58xzDO/Lx3FcJt2RV5Qc3aTcSZNKfNFw7bgFdeBUAyfyijbT6+H4icmMPACmHQLGXSuQCzhva381tll2TVirzQpPBU+sbq1IR2LGKG48Eq6tzIiSHdqjbHODGj1pXzTSTK5y1sgzcWpgDBVKTRMlPac1oL97dTqUqjRw8G54uFi24MYZfsZw6nQ918793HiqE148RmjDw+b1EfvZ4Mao3TkoPlSKs4JIcTvXVdjejb3cIcTwYMySel7FF7zbKCIIDtE5ctwxuvNYqttYybzYuOVyOJ06gww2oq4cfTkYZEtsqTNeEKcN1u9qeyIOhW3FsvayYhod85s9hvuvnLfSOHg1iK1K692RSw8yD0tqzg3NSvI7xVjKtvC8UmIrT/b6/HtJ748qHcN2608ohCiYniVrr7xUNiE8WdKWn65TPVGnCyJfJLJjiVrP0h6nS5zh9CNyBZNyJXRgtgmg3srYKjD/p4iCePGKbIFdKfcFvWWY2auwcgLMa1+wshwEnnZhkN9YiecDmnPQxlU+xZ6jV8fRURzTnLvxHbISbHVVR4ij2pISW/daCqO1qhOWzyC/KP0AGcV0jCi7fBb4z3LeKCqgyViOOgrHNwdyHVJk5vIRxbmLwghJNGF6Gdbl0ExSHt0B9EEcLbqXTGIqVwVqXE+C+O/kw
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36860700001)(70586007)(356005)(2906002)(16576012)(316002)(82310400004)(6916009)(8676002)(70206006)(31696002)(4326008)(81166007)(40460700003)(54906003)(6666004)(16526019)(36756003)(5660300002)(8936002)(86362001)(7416002)(508600001)(186003)(47076005)(83380400001)(26005)(53546011)(31686004)(336012)(2616005)(426003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 11:10:24.9512
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e907eed-bc20-42e7-4af1-08d9f073c450
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
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

On 15/02/2022 13:08, Nikolay Aleksandrov wrote:
> On 15/02/2022 12:30, Vladimir Oltean wrote:
>> On Tue, Feb 15, 2022 at 12:12:11PM +0200, Nikolay Aleksandrov wrote:
>>> On 15/02/2022 11:54, Vladimir Oltean wrote:
>>>> On Tue, Feb 15, 2022 at 10:54:26AM +0200, Nikolay Aleksandrov wrote:
>>>>>> +/* return true if anything will change as a result of __vlan_add_flags,
>>>>>> + * false otherwise
>>>>>> + */
>>>>>> +static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16 flags)
>>>>>> +{
>>>>>> +	struct net_bridge_vlan_group *vg;
>>>>>> +	u16 old_flags = v->flags;
>>>>>> +	bool pvid_changed;
>>>>>>  
>>>>>> -	return ret || !!(old_flags ^ v->flags);
>>>>>> +	if (br_vlan_is_master(v))
>>>>>> +		vg = br_vlan_group(v->br);
>>>>>> +	else
>>>>>> +		vg = nbp_vlan_group(v->port);
>>>>>> +
>>>>>> +	if (flags & BRIDGE_VLAN_INFO_PVID)
>>>>>> +		pvid_changed = (vg->pvid == v->vid);
>>>>>> +	else
>>>>>> +		pvid_changed = (vg->pvid != v->vid);
>>>>>> +
>>>>>> +	return pvid_changed || !!(old_flags ^ v->flags);
>>>>>>  }
>>>>>
>>>>> These two have to depend on each other, otherwise it's error-prone and
>>>>> surely in the future someone will forget to update both.
>>>>> How about add a "commit" argument to __vlan_add_flags and possibly rename
>>>>> it to __vlan_update_flags, then add 2 small helpers like __vlan_update_flags_precommit
>>>>> with commit == false and __vlan_update_flags_commit with commit == true.
>>>>> Or some other naming, the point is to always use the same flow and checks
>>>>> when updating the flags to make sure people don't forget.
>>>>
>>>> You want to squash __vlan_flags_would_change() and __vlan_add_flags()
>>>> into a single function? But "would_change" returns bool, and "add"
>>>> returns void.
>>>>
>>>
>>> Hence the wrappers for commit == false and commit == true. You could name the precommit
>>> one __vlan_flags_would_change or something more appropriate. The point is to make
>>> sure we always update both when flags are changed.
>>
>> I still have a little doubt that I understood you properly.
>> Do you mean like this?
>>
> 
> By the way I just noticed that __vlan_flags_would_change has another bug, it's testing
> vlan's flags against themselves without any change (old_flags == v->flags).
> 
> I meant something similar to this (quickly hacked, untested, add flags probably
> could be renamed to something more appropriate):
> 
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 1402d5ca242d..1de69090d3cb 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
[snip]
> +}
> +
> +static bool __vlan_flags_would_change(struct net_bridge_vlan *v, u16 flags)
> +{
> +       return __vlan_add_flags(v, flags, false);
> +}
> +
> +static bool __vlan_flags_commit(struct net_bridge_vlan *v, u16 flags)
> +{

blah, obviously should be void here and ignore the return value

> +       return __vlan_add_flags(v, flags, true);
>  }
>  
>  static int __vlan_vid_add(struct net_device *dev, struct net_bridge *br,

