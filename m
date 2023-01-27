Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3BE767E889
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 15:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbjA0Ooj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 09:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjA0Ooi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 09:44:38 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2070.outbound.protection.outlook.com [40.107.95.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FC27DBE7;
        Fri, 27 Jan 2023 06:44:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DrnnBSBMZFm5ZTQxoH3l1TNQFV7hXCDi4lm6q16DiOFgM/ewBuK7AqYiwyidttV28qDlNAJNPkXS7wOciawKL2lZjAdDakYY+dv/ih6kcz0WsmRxl0qU8cda2+NXjzKpC7ncmRYOIU2wu6V+kv5705OkBVgoDCwFwUzLT8Ext8F952foH4hq0bI2AbPPq2U1YQ51Dc3A8i2qo09tBv3waNMtOt4atv4lwibZp1PUFN8ef0o4qvZ4lleLmy/kd5NP2m4+isTAVo35QZPlvzMS+k5qf420pkJAj5Oa7/1L6t1Q/9e8WHw6yqCV8n0jNLITXBdHpfITiXSa+pSuBxTyLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIq/f+MlrXemkUn2KwP3Vd5EB4Af8Ean9vt4f2VAZjA=;
 b=mk8DSXsb4tGnE8YZPwUhvkGFkUBtV/IzE+VwJ3bvBUBJlUZdyTINI3weddBHQHvloh0O7O6EWUkZVLuMaGVkkBGBbY5LqjQmS3bcqCu5ZDb6vZPhab+K6/dRilLDyRt4oBeicPji0WGCbwBED3q4KazmKHhaehHnIsDt2yxOPL529O+WHvwQAH7s3ogrsqdR75MnUkvD/9dX33XxVX5s1/nn3VsCtvYVyWAT++YCZMGQmAmNqw5PS8txdSFLKv04cnh8evHRweFjmHQjPjOPo83U6rmoyH3+NbmSaHNdvjSFsTE5PSM8X+0wmCu/MKaFniwW2FygdoVhlEabdsyGCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIq/f+MlrXemkUn2KwP3Vd5EB4Af8Ean9vt4f2VAZjA=;
 b=Ujivl0FQ02eWUptu2R8Pfho+ZCFpg2y/MCcseDN0hB8GWXcsB/iW9GwS6CmNP8BgOer7seRrzjoyPRvuNKmmFguauUP/BbJCKBaylztVYep9R/6Gy3HB+NnFYmY+1fdIDAh7og51XO0R4oaTD49rYoRXb351P6qfyXsRlexpYr6TBU7eQI1t1RWQ8JriOFemDUmx+yrq50d27M/09c+Hzupojeukh8GXGUeLHTH1Tj+a7omv9JKm1M3bkVbmDqcgcxZlh5WDljJE4vpGYOeHXx/CgWiYeCugb6nNj1cpILIUZlbTTLybKLvJ5jw6MgFvLSvgkc6RDVLKjfQojyrgSA==
Received: from BL0PR02CA0087.namprd02.prod.outlook.com (2603:10b6:208:51::28)
 by SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.23; Fri, 27 Jan
 2023 14:44:35 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:51:cafe::18) by BL0PR02CA0087.outlook.office365.com
 (2603:10b6:208:51::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25 via Frontend
 Transport; Fri, 27 Jan 2023 14:44:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.13 via Frontend Transport; Fri, 27 Jan 2023 14:44:35 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 06:44:21 -0800
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 06:44:18 -0800
References: <cover.1674752051.git.petrm@nvidia.com>
 <ed2e2e305dd49423745b62c0152a0b85bc84a767.1674752051.git.petrm@nvidia.com>
 <20230126125344.1b7b34e2@gandalf.local.home>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, Roopa Prabhu <roopa@nvidia.com>,
        "Nikolay Aleksandrov" <razor@blackwall.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@nvidia.com>,
        <linux-trace-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 06/16] net: bridge: Add a tracepoint for MDB
 overflows
Date:   Fri, 27 Jan 2023 15:29:19 +0100
In-Reply-To: <20230126125344.1b7b34e2@gandalf.local.home>
Message-ID: <87h6wc3um7.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|SA0PR12MB4400:EE_
X-MS-Office365-Filtering-Correlation-Id: 872ff41b-fb92-4125-1378-08db0075029d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cZsZzyvAjV00LF+bJK7k5kr8FgS8P5fTDIOGAJKpBM4Nvy2yYLL9B97b+zuAzs5GECj4j+/mX7CuBX6E1Kz5r0B50g8gAJTIAAk2YbaTbiiIzOoabRG9h4IBZ0oxJRCbV/xvxAbfG5BAcJe2T2P3pmbL1RDl75AjL8UOcJgFXhaBRkZ8BDb3haLoPB+YM/9K5Lrfdn/BTDUkw2kJRIrNr8x2eEHyxJy6QNZB3FfytPd2AdITgiKUAZU5+6JUwNYV3SSWoSQI0fmqRqCCIZncjvLWkdHQM1BsgyZpHc0jkjyULM/oaLpZNLSwiHuhEObmFRpNstGFmr74xeiBv31z2ubgNN6+J2QYpFD3CNbcScKFY9l9tp3/MK3KEbz9fpyDDfjtZMy2TxCrsTElsHhPt8oV+e8ZdLZS1ys5UKCj5XDQTU4mIFUI87/W7GNhQRnLjkExospz/qF/VbbGcD3DC9Es+IOZsP5oIyn2EezESh6xkm777wtwPj24xsJEoq1ncv0D7PTGAyQuea94UpUc/GK+e17acwxSKLTBFBFrlER8WnEWz0iXkb8VEBmS1SGzwMS8MaWjoJEa8OUA+GY3HtsxAjdc8XSKAUEsk5yAfzSp/wCMht6Urrk46mvO/lwuG9yNpVBtBLRiE7KP17xaUNSRXhr0W5+gEwcJgVfdRQbH5GVUO3XajmlOQS9iJz0r8Ra5j0vrQQfmDKC1p+DOSQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199018)(46966006)(40470700004)(36840700001)(4326008)(8676002)(41300700001)(6916009)(83380400001)(70206006)(70586007)(54906003)(8936002)(316002)(40460700003)(26005)(36756003)(186003)(16526019)(356005)(47076005)(426003)(36860700001)(40480700001)(2906002)(5660300002)(336012)(7636003)(82740400003)(86362001)(478600001)(82310400005)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 14:44:35.5891
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 872ff41b-fb92-4125-1378-08db0075029d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4400
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Steven Rostedt <rostedt@goodmis.org> writes:

>> diff --git a/include/trace/events/bridge.h b/include/trace/events/bridge.h
>> index 6b200059c2c5..00d5e2dcb3ad 100644
>> --- a/include/trace/events/bridge.h
>> +++ b/include/trace/events/bridge.h
>> @@ -122,6 +122,73 @@ TRACE_EVENT(br_fdb_update,
>>  		  __entry->flags)
>>  );
>>  
>> +TRACE_EVENT(br_mdb_full,
>> +
>> +	TP_PROTO(const struct net_device *dev,
>> +		 const struct br_ip *group),
>> +
>> +	TP_ARGS(dev, group),
>> +
>> +	TP_STRUCT__entry(
>> +		__string(dev, dev->name)
>> +		__field(int, af)
>> +		__field(u16, vid)
>> +		__array(__u8, src4, 4)
>> +		__array(__u8, src6, 16)
>> +		__array(__u8, grp4, 4)
>> +		__array(__u8, grp6, 16)
>> +		__array(__u8, grpmac, ETH_ALEN) /* For af == 0. */
>
> Instead of wasting ring buffer space, why not just have:
>
> 		__array(__u8, src, 16)
> 		__array(__u8, grp, 16)
>
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__assign_str(dev, dev->name);
>> +		__entry->vid = group->vid;
>> +
>> +		if (!group->proto) {
>> +			__entry->af = 0;
>> +
>> +			memset(__entry->src4, 0, sizeof(__entry->src4));
>> +			memset(__entry->src6, 0, sizeof(__entry->src6));
>> +			memset(__entry->grp4, 0, sizeof(__entry->grp4));
>> +			memset(__entry->grp6, 0, sizeof(__entry->grp6));
>> +			memcpy(__entry->grpmac, group->dst.mac_addr, ETH_ALEN);
>> +		} else if (group->proto == htons(ETH_P_IP)) {
>> +			__be32 *p32;
>> +
>> +			__entry->af = AF_INET;
>> +
>> +			p32 = (__be32 *) __entry->src4;
>> +			*p32 = group->src.ip4;
>> +
>> +			p32 = (__be32 *) __entry->grp4;
>> +			*p32 = group->dst.ip4;
>
> 			struct in6_addr *in6;
>
> 			in6 = (struct in6_addr *)__entry->src;
> 			ipv6_addr_set_v4mapped(group->src.ip4, in6);
>
> 			in6 = (struct in6_addr *)__entry->grp;
> 			ipv6_addr_set_v4mapped(group->grp.ip4, in6);
>
>> +
>> +			memset(__entry->src6, 0, sizeof(__entry->src6));
>> +			memset(__entry->grp6, 0, sizeof(__entry->grp6));
>> +			memset(__entry->grpmac, 0, ETH_ALEN);
>> +#if IS_ENABLED(CONFIG_IPV6)
>> +		} else {
>> +			struct in6_addr *in6;
>> +
>> +			__entry->af = AF_INET6;
>> +
>> +			in6 = (struct in6_addr *)__entry->src6;
>> +			*in6 = group->src.ip6;
>> +
>> +			in6 = (struct in6_addr *)__entry->grp6;
>> +			*in6 = group->dst.ip6;
>> +
>> +			memset(__entry->src4, 0, sizeof(__entry->src4));
>> +			memset(__entry->grp4, 0, sizeof(__entry->grp4));
>> +			memset(__entry->grpmac, 0, ETH_ALEN);
>> +#endif
>> +		}
>> +	),
>> +
>> +	TP_printk("dev %s af %u src %pI4/%pI6c grp %pI4/%pI6c/%pM vid %u",
>> +		  __get_str(dev), __entry->af, __entry->src4, __entry->src6,
>> +		  __entry->grp4, __entry->grp6, __entry->grpmac, __entry->vid)
>
> And just have: 
>
> 	TP_printk("dev %s af %u src %pI6c grp %pI6c/%pM vid %u",
> 		  __get_str(dev), __entry->af, __entry->src, __entry->grp,
> 		  __entry->grpmac, __entry->vid)
>
> As the %pI6c should detect that it's a ipv4 address and show that.

So the reason I split the fields was that %pI4, %pI6c, %pM do not seem
to work with buffers of wrong size.

But I can consolidate 4/6 by changing the address to IPv6 like you
propose. I'll do this for v2. Thanks!
