Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A29F4C402B
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 09:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238506AbiBYIcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 03:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236278AbiBYIb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 03:31:58 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF9E23A186
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 00:31:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAw0ABt2vqYlVwibChkAIH5ghSFvPA15fPg4Na4tTlypZbkMdt9ljH1rMCGuNUqYfkJJ7OHCpLoyOE6lfomJNH2fLOJL8Rx9BVpQ2pUdCOx88To6rHFL1EbrpQog5PUOJ71q1TFf4tvQAVv0t2YO0WltUL/SxPdpweleK5Vu8vFWBa+3BqVGxSHtD/qjI3uc+34Ik/MIVrXgtDVKDkXgq+3/f4eSNCA780XPbXa53XNG03NjEUzuQ3+8Ajxh2jDWR8T+ULWlxRPTUg+AZP3dsUbhrA9KGreqhNiDBoHEpNt/qVZPjI0pbr2kt2/WknaPN9QISYsYRfIhHtNTtJL/GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGE8NLP8W7/yeT5NaKbF2cCsduRCzD4NPbXxUQjp3dM=;
 b=mgPCq0EBY/RYtzpxTU3zGvdW0LnNOucCN903oCiejh09PvQUhjwezEifmQ2ru3aBpSBbnOBmUXxpbWGvEoHhsTfH4QA7xHDJ2xeMpwpcp2HjaFEzYElD4eEnlHIZmXH3xrHHn/j475Sq55ubMHmqvKLq9ijW4q0+q5e+oWq/ElBCOismY8UtheO2Cqy4LWLqvBlzYmEAC7gZSIe26TGcOm7SjU/ZGmJAxCgDHJpkTrG94boFVh95XvowjzkyO04Sv1XYQBOtkv3uvi3sTp8Otn0qEgqPj1vcdMn3iKRCKPXxdBvg3GDLdTnXOLXmiLiwpe2VTlj601kfKtB8QNegFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGE8NLP8W7/yeT5NaKbF2cCsduRCzD4NPbXxUQjp3dM=;
 b=EXLvUro1CaP38/1uSvvseThQecXn3ZGmWKLRYNCJtqoPNbtmSNInnSdogfxdJFHiQUnXim3sVE63jn4vdj3/0LxTBmp3SimTxtUgHE3/o+/3eXcxGmW9MuxlTp2powYGZ1a8nPfbxHDrLh/Qo/ERvCFhiTU7pODxp9705cdZHpY7QmZuU3A0DRTBfvikbOxjjUcJKSgneCudwREt9oIDjguZlIilkgPVBRC9t9s50rQ4MrEU1XXSzCE3K12S8xYX2OiRntcz2u4XqFyeqf/s3459kZbhwQUYMELdMtLG1C+MBcB6MXm2UGWJkDWKiA9SibRUi5DAM+fPZDKaeFzhEA==
Received: from BN6PR20CA0060.namprd20.prod.outlook.com (2603:10b6:404:151::22)
 by DM6PR12MB3004.namprd12.prod.outlook.com (2603:10b6:5:11b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Fri, 25 Feb
 2022 08:31:23 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::e1) by BN6PR20CA0060.outlook.office365.com
 (2603:10b6:404:151::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24 via Frontend
 Transport; Fri, 25 Feb 2022 08:31:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.24 via Frontend Transport; Fri, 25 Feb 2022 08:31:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 25 Feb
 2022 08:31:18 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 25 Feb 2022
 00:31:13 -0800
References: <20220224133335.599529-1-idosch@nvidia.com>
 <20220224133335.599529-4-idosch@nvidia.com>
 <20220224221447.6c7fa95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <petrm@nvidia.com>, <jiri@nvidia.com>,
        <razor@blackwall.org>, <roopa@nvidia.com>, <dsahern@gmail.com>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 03/14] net: rtnetlink: RTM_GETSTATS: Allow
 filtering inside nests
Date:   Fri, 25 Feb 2022 09:22:19 +0100
In-Reply-To: <20220224221447.6c7fa95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <87a6effiup.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd72e2c1-37c5-45b6-5017-08d9f83934d4
X-MS-TrafficTypeDiagnostic: DM6PR12MB3004:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3004B015C3A847F123758873D63E9@DM6PR12MB3004.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QkrISNun7B8I8gNit90v8pp+j2lCHlxE57cODIpkU2WuWzRJFi6eV+zxG2Isti03hKpU7sGcyn9j0gjgdwpLS1XRYmc6Y+Y9mR4MGN9i+x9AuZtOQ0ZsjjCiRN9qmfxlst6uvDQzDVn0P/XXdB2kvu99uPMSlo/aOlBDwB8TMqCnEd7odCPJ8KlsLPCBFCMnMSCwTqyUBrhdqOWByCyKVXIGZn675xgyFwCMNv4ZRZQY7Qm/2NSVybfbTJuzMdzGznlSj8wjg5HQ2psKWj2eq6n2YzwSyO/1D05A0yNPfDtfddie4Vmz8zqZa+t7Ye4IBpl7vIq5VenY4/yDDGDfXkEhOR+2VRrcZzyaW/iOJ+aieLe0YN/lHVk/7vdhZBErsNCvo+3+plGK3tLlmqzrbiIF1X4b+mNHiAzaSuVZ5uMFu//xcHq8bBqtlWaLA7BJXs2CO85GQfZqP1ykteSD28xAyRf1BMsm6We6utBNRb6WMVgK8Ib8RKf8MUmCjHQD+sNIKCxurDUW8bqXIHZAdHGQuN/Qn8DxucLAHnXo7yTogQ4uugkQuxB8sWApSjBvFhuIxl2Y3mQKUNwVEroPzd/hpfXvu1LfBioetIQAmGx2V1atijFKVtEq1v/MbAOkOCwNbsB77ySxF517qngGNfoL+Xhk8bZGPxgoNvbom6YcRQLY2uhw8K2jWZET2y/Pf9NGT5xzCig83rcsdWpTsQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(5660300002)(36860700001)(83380400001)(40460700003)(2906002)(426003)(336012)(54906003)(6916009)(47076005)(8936002)(36756003)(16526019)(86362001)(81166007)(2616005)(8676002)(508600001)(107886003)(70206006)(4326008)(316002)(356005)(82310400004)(186003)(26005)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 08:31:23.1070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd72e2c1-37c5-45b6-5017-08d9f83934d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3004
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 24 Feb 2022 15:33:24 +0200 Ido Schimmel wrote:
>
>> @@ -5344,6 +5368,75 @@ static size_t if_nlmsg_stats_size(const struct net_device *dev,
>>  	return size;
>>  }
>>  
>> +static const struct nla_policy
>> +rtnl_stats_get_policy[IFLA_STATS_GETSET_MAX + 1] = {
>> +	[IFLA_STATS_GETSET_UNSPEC] = { .strict_start_type = 1 },
>
> I don't think we need the .strict_start_type if the policy is not used
> in parse calls with a _deprecated() suffix, no?

You are right:

        if (strict_start_type && type >= strict_start_type)
                validate |= NL_VALIDATE_STRICT;

This flag is there to begin with in non-_depreceted calls.

I'll drop the strict_start_type.

>> +	[IFLA_STATS_GET_FILTERS] = { .type = NLA_NESTED },
>
> NLA_POLICY_NESTED()? Maybe one day we'll have policy dumping 
> for rtnetlink and it'll be useful to have policies linked up.

Nice, I'll add it.

>> +};
>> +
>> +#define RTNL_STATS_OFFLOAD_XSTATS_VALID ((1 << __IFLA_OFFLOAD_XSTATS_MAX) - 1)
>> +
>> +static const struct nla_policy
>> +rtnl_stats_get_policy_filters[IFLA_STATS_MAX + 1] = {
>> +	[IFLA_STATS_UNSPEC] = { .strict_start_type = 1 },
>> +	[IFLA_STATS_LINK_OFFLOAD_XSTATS] =
>> +			NLA_POLICY_BITFIELD32(RTNL_STATS_OFFLOAD_XSTATS_VALID),
>> +};
>> +
>> +static int rtnl_stats_get_parse_filters(struct nlattr *ifla_filters,
>> +					struct rtnl_stats_dump_filters *filters,
>> +					struct netlink_ext_ack *extack)
>> +{
>> +	struct nlattr *tb[IFLA_STATS_MAX + 1];
>> +	int err;
>> +	int at;
>> +
>> +	err = nla_parse_nested(tb, IFLA_STATS_MAX, ifla_filters,
>> +			       rtnl_stats_get_policy_filters, extack);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	for (at = 1; at <= IFLA_STATS_MAX; at++) {
>> +		if (tb[at]) {
>> +			if (!(filters->mask[0] & IFLA_STATS_FILTER_BIT(at))) {
>> +				NL_SET_ERR_MSG(extack, "Filtered attribute not enabled in filter_mask");
>> +				return -EINVAL;
>> +			}
>> +			filters->mask[at] = nla_get_bitfield32(tb[at]).value;
>
> Why use bitfield if we only use the .value, a u32 would do?

The bitfield validates the mask as well, thereby making sure that
userspace and the kernel are in sync WRT which bits are meaningful.

Specifically in case of filtering, all meaningful bits are always going
to be the set ones. So it should be OK to just handroll the check that
value doesn't include any bits that we don't know about, and we don't
really need the mask.

So I can redo this as u32 if you prefer.
