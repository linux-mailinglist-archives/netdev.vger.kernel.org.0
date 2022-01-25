Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA9549B0FB
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237814AbiAYJy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:54:59 -0500
Received: from mail-co1nam11on2042.outbound.protection.outlook.com ([40.107.220.42]:57147
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237014AbiAYJwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 04:52:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n31AeFgWIOPa1V+zqKriucX0yCeQnmtLuDmUvf4pzo4WH9S2poaObzoNTXe8ewZC6rT8kAAEjXjGQqwiCLIsTiNJ7CO+fcoS08ghLCWRxEvcG6z2HjIyC5F8gu6CJs9MNjMuPh63fyYfXxiAWhdGXdtwoURzhRm1ioeADjouUX5GMGhaYxlsVrgVfGay9OdgofD8E2TcO+gBiGmZuFKa2WzquQoRmlq72cuxnB2GSNL9qZjZ3KeMAtECjMNi4VKDkjQcbhMqEyrMZN2atUEnrx952dVYI+z+0iKNiT33+LVwJmHdDJJ9ZKrNVHGMeLUiiSEuF+4MDnNePT1cxSRw3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYljgxDCOqBS0cG9ozrUiwS1rxenhMHmVw3PQ2I7MOU=;
 b=PLTklmAETmlcyFe8g48r9xWKo/F7EfO1I6JuJ8F6Y3DWKgMoZInMFaU7byf59D69BrbwO8etPLvqf8ga7UGZ5r2WwYnX2cslrVdoBLIlsTPodwsSb1mAONCdp5JV70/XStn1qZkRLsbBM4BF4YW3vxGRVvIGVoHqWIZaxBhjzMY4f37P6g7M69gnZVxWZPLI4BAXi+y8AMzp9U+KCNsEIG2cPzI4yrlRx9MezYEdIgFizA0szJqDt/12y5cxi3biy/97dHMp13KSlpOSWRmZuUaR7rZ6S433oqoW9ZeMiuRggllnnmL6/teca2UjzSF0sji0ftYa/SmvP5tK8CJntg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYljgxDCOqBS0cG9ozrUiwS1rxenhMHmVw3PQ2I7MOU=;
 b=d881QzRAD7HJEdK+Qa4qIx9zHxINwZwOfb3kpA3Ua0M4Dm2qioxrpfXOsKKom45GcCon9dpNCxBGFMl4NemX5BWegYcFQ+YctBPCmx95vb8dtYW82Y8LutK3Hp3Nvj568N12pBQ1MEGmif8EbalxInWBesV+Is4lDRGt5i7tbkEhzqNkDe0dhwY4hb5CCeWS1Zr8pa5qlTOqKXuKQJW1ocV7qKspF7I3aBjips3MBXadOchJQ7RLEf+poBqWXxBpaUknPWwUUyUuO56N7CpCtLm7VSS5sdtQiGZJenbQFlHmPEpVHSbTr5IMOGOjzNRO1QqCmkZ0eiDXduL7XHucRA==
Received: from DM6PR13CA0033.namprd13.prod.outlook.com (2603:10b6:5:bc::46) by
 BYAPR12MB3624.namprd12.prod.outlook.com (2603:10b6:a03:aa::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.15; Tue, 25 Jan 2022 09:52:02 +0000
Received: from DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:bc:cafe::2d) by DM6PR13CA0033.outlook.office365.com
 (2603:10b6:5:bc::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.7 via Frontend
 Transport; Tue, 25 Jan 2022 09:52:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT024.mail.protection.outlook.com (10.13.172.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Tue, 25 Jan 2022 09:52:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 25 Jan
 2022 09:52:00 +0000
Received: from [172.27.12.100] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 25 Jan 2022
 01:51:57 -0800
Message-ID: <25ec6925-8ebf-d2fa-7d73-708ba72cec0a@nvidia.com>
Date:   Tue, 25 Jan 2022 11:51:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net] net: bridge: vlan: Fix dumping with ifindex
Content-Language: en-US
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     Benjamin Poirier <bpoirier@nvidia.com>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
References: <20220125061903.714509-1-bpoirier@nvidia.com>
 <cc425efa-1e20-286a-ba96-bc9555142c9c@nvidia.com>
In-Reply-To: <cc425efa-1e20-286a-ba96-bc9555142c9c@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: drhqmail203.nvidia.com (10.126.190.182) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47d35212-d2be-45d7-ff2b-08d9dfe855a3
X-MS-TrafficTypeDiagnostic: BYAPR12MB3624:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB36245D4FF473A52872F28B59DF5F9@BYAPR12MB3624.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uXcG8XGHjWV0UgUfUakd+c6F0IgM9Ms5BtUCZplkUzL1s5DbH+OkQLNJJ15MP+eObnXrG6KBni15aMdyDQhplZ02QPwTL6j1TriH+b44NcyWRI5dBd51QallSjzygOyFjv1pXpBSTh2WuTdKtx196aMf7oKF7cFdL+8Paa++xBrVkauKCxWtCPkh4E9thQSo91u1u7Rdc0jxQOGCQlNmFUMCGCgzYX9plRue27L4WDwIw4lJrphfVLqE+zkmBNZtVKtRX/Pgar6Oip2vI9vor/6ix9Kcxz5CoFSNhY51z1T8VR4V0mmngqTAZadF4qB3ibGwdHOCTGsk4CMXvrOfYg56fYnJBmDZTcoEX0xcizzpPvT/FL4JICsWO/CLn6+Z48DAbSXUSdGqhiPxVoxVZTKUAyK41MgUVV4XDP61F4znIdm+esW9nsp1tJfQAlMPEytdDlMgOwTAzKldGam2rLPr0ie9f8YgNKUngK9S/0LxZ+5MCqYaHAArJoe1vF1F6LLDJGbGE7y3Dj5EaaSbaxkDZ9Zad4mQhBpjbjvGCmqUXVZ/IlrnYhiGhh9sXACtCt+kwkBc9zCpAutlshq0iWQY767AQMV2XTk5nafGE6EpJgrKddJCmwTgOdZbABjU0ufqrpG9clSmlrn++N+QA4sJubtg8QnK0IGs2oNdcs1ogaaVNm2wnnvIU3rsdMy4A4Y5SsRotHIV28YvLEICZsOMmgeL4AuNN+HZElf+a031KKANko/g/vjXy0OCZ7Qe
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(6666004)(16576012)(86362001)(316002)(37006003)(82310400004)(54906003)(31696002)(83380400001)(81166007)(40460700003)(508600001)(6636002)(53546011)(47076005)(356005)(2616005)(336012)(426003)(186003)(26005)(36860700001)(16526019)(36756003)(8936002)(31686004)(5660300002)(4326008)(6862004)(70586007)(70206006)(2906002)(8676002)(43740500002)(36900700001)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 09:52:01.0447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d35212-d2be-45d7-ff2b-08d9dfe855a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3624
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/01/2022 10:24, Nikolay Aleksandrov wrote:
> On 25/01/2022 08:19, Benjamin Poirier wrote:
>> Specifying ifindex in a RTM_GETVLAN dump leads to an infinite repetition
>> of the same entries. netlink_dump() normally calls the dump function
>> repeatedly until it returns 0 which br_vlan_rtm_dump() never does in
>> that case.
>>
>> Fixes: 8dcea187088b ("net: bridge: vlan: add rtm definitions and dump support")
>> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
>> ---
>>  net/bridge/br_vlan.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
> [snip]
>>
>> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
>> index 84ba456a78cc..2e606f2b9a4d 100644
>> --- a/net/bridge/br_vlan.c
>> +++ b/net/bridge/br_vlan.c
>> @@ -2013,7 +2013,7 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
>>  		dump_flags = nla_get_u32(dtb[BRIDGE_VLANDB_DUMP_FLAGS]);
>>  
>>  	rcu_read_lock();
>> -	if (bvm->ifindex) {
>> +	if (bvm->ifindex && !s_idx) {
>>  		dev = dev_get_by_index_rcu(net, bvm->ifindex);
>>  		if (!dev) {
>>  			err = -ENODEV;
>> @@ -2022,7 +2022,9 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
>>  		err = br_vlan_dump_dev(dev, skb, cb, dump_flags);
>>  		if (err && err != -EMSGSIZE)
>>  			goto out_err;
>> -	} else {
>> +		else if (!err)
>> +			idx++;
>> +	} else if (!bvm->ifindex) {
>>  		for_each_netdev_rcu(net, dev) {
>>  			if (idx < s_idx)
>>  				goto skip;
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Actually I'd prefer an alternative that would encapsulate handling the single
device dump in its block, avoid all the "else if"s and is simpler (untested):

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 84ba456a78cc..43201260e37b 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -2020,7 +2020,8 @@ static int br_vlan_rtm_dump(struct sk_buff *skb, struct netlink_callback *cb)
                        goto out_err;
                }
                err = br_vlan_dump_dev(dev, skb, cb, dump_flags);
-               if (err && err != -EMSGSIZE)
+               /* if the dump completed without an error we return 0 here */
+               if (err != -EMSGSIZE)
                        goto out_err;
        } else {
                for_each_netdev_rcu(net, dev) {
