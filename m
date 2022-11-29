Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA5963BD1B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiK2JkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiK2JkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:40:09 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DF22A254
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:40:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myDklLXECPolBvjZTyfv2n48hXpOtWmuv0Uy3mlSIJbl7/k6v7qZjGs5xlJUwgJFvzH029ujAgAYokomJTEqoC6u2q3RkA0oqc2k4nm+uqg5xW18SG+AiAkEtbxKEMoOa76UTNB+1suNHd6yAI+nLRMywfp5DfjlIgSwEa4TxEnSL8KIz0zcTelKAULK/X49s2CK2ji5iMo2aSguzGcjwXgOSpvA3eE82/Bpt+B3Hb571jHacubNcwKGiVYx7ftIld3t6DPNmhUT/BRsny+j2ztoFahoGK7jAg9z34NVNWnL/4FvLr6pBQManwRzJgVAJDz49EyBRt3unjMcXpx+qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ox8l61Eq9TWIUVFrusQHX1vm3eQ5oYZQp8ZUZfIdUJA=;
 b=G0aaMe3SZxrKqPmlJOjXK9OHWuxi+BQSw2p9S0+S2zcwkHHFtSWiCBGLnQCoQwjBmAY8AMnPJGn0lc67ES6Otuzc/A7O0bv1mB8F9LrNsL6utYfk7rPcQvLBKtUzllCeiFq25VdKp7JD9rH7YuaISdWxGV+bIhaXJW87Yh25FJ20Q07/rKOZ9U0Y+25xwy0iKkfyL21psYbziTqFYcUSfTZrcAN2pR2xfADwbyMedwPBRQWzJyC3ab0Fqf4CW6Xe0ccsjl+tiGb3iNv60WbgKtxxbKzY5eClNeuqatBlWd7NlVJPUzXoMms11FQKA+JAAxXQz2eOxUx93b5q+E/vLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ox8l61Eq9TWIUVFrusQHX1vm3eQ5oYZQp8ZUZfIdUJA=;
 b=bC8qDhtevE/k/cXt/DnzXLTRseSoVzty3s7mvOz6hKKbLJdV4bqgKMhXidB9jEFzLjkpqle6ZS8xBZQh26R1Y4kBFcAdnamm8qocUxy2l5sRY3EERHPZADDS2bRXOUvotXHSI+08LbGGRSCbO5kXFvhtCpYBrEjq0F11J15vFQOBjnVg8y9cvTiAArykqnWW0haR3/ld7ZsN3RVn33ZvSWS1+jY9pqbfmawI+y4mtssmh/nzeSiz31h5hU/0xjb7YIad3q2W/x/OFcQeCsnem+Qvi7C57eB9vVf4ExiIg62m8uXSoO5q0ExQ77+ozPJVh09jbr5uhi944pZKbfSZuQ==
Received: from DM6PR07CA0074.namprd07.prod.outlook.com (2603:10b6:5:337::7) by
 CY5PR12MB6549.namprd12.prod.outlook.com (2603:10b6:930:43::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 09:40:05 +0000
Received: from DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::4c) by DM6PR07CA0074.outlook.office365.com
 (2603:10b6:5:337::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Tue, 29 Nov 2022 09:40:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT010.mail.protection.outlook.com (10.13.172.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.21 via Frontend Transport; Tue, 29 Nov 2022 09:40:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 29 Nov
 2022 01:39:55 -0800
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 29 Nov
 2022 01:39:53 -0800
References: <20221128123817.2031745-1-daniel.machon@microchip.com>
 <20221128123817.2031745-2-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <dsahern@kernel.org>,
        <stephen@networkplumber.org>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 1/2] dcb: add new pcp-prio parameter to
 dcb app
Date:   Tue, 29 Nov 2022 10:35:08 +0100
In-Reply-To: <20221128123817.2031745-2-daniel.machon@microchip.com>
Message-ID: <87wn7ef6ai.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT010:EE_|CY5PR12MB6549:EE_
X-MS-Office365-Filtering-Correlation-Id: 68a2746b-1c7f-41a6-9ec1-08dad1edb1f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y2X3Z5BkOa4ceWmImkItI2mjmIrV1oV9PjS6ZBX6AHtPngiEf9M8s6JILvzADiEKCOXTN9Vgi7t4JqLuOBay/cbeAQkCQKu7452ea+u6tdd4ibWTXjiy9ad1ZjV0GRwpn+DInHevoOjVb811Zy1kv6Os8e45eBq64qD+n8Ou6Nkz8vPam+BQBIHoD8NUmhvCvTcymo8qIajbm6eCTrkdn7JSC+i6JeBKTW7AMXLqRndKZs8et2+V4FKBy8C1rMe2JFVTmJmUiaX8XEZ/HwTUKaWgsVpc1X2SXWVw4rsgTNTDXE4UEoW20p72qvY4grkLh+Q/0UN/Yz3Hm7q68XhUXA0G0RfsolsxzbS6NecZrKl/EDmyRj6oF2WKKaatmKg+BliVlcx/fkt4e06FQMv7zskeex1S6Eq1/jt4AmvoKSSWtsViRGQ4IszGkyRJ6mHfj0zFdgbab35cO2FfBWf3HsDZTa8qUVHyRYqbCMAFws6F3EVFN+LtJ6Kqve4nWQkoujIcCnXTKd3vvRDJmj10dkNU4BpvX56Fw/SCJ9Sn6tR7akIofUq50gTG05NRynj41jNRqWKXb/VcEDpZk+XxM0qqN4oPVaUr8ddWqyu6Q1Axp4nagUDtrb2Fcpypg46EcntqGztJYR4YitBwHB1hQOvRpq8/Y9V8yepI0WZdKG3iZLzOrAoru3rUL94xAeytA/rv9l3H0SHuhH/TZYWv6w==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199015)(40470700004)(46966006)(36840700001)(54906003)(86362001)(16526019)(186003)(6916009)(316002)(336012)(2616005)(478600001)(8676002)(6666004)(26005)(8936002)(82740400003)(4326008)(5660300002)(41300700001)(36860700001)(7636003)(70206006)(70586007)(356005)(40460700003)(426003)(47076005)(2906002)(82310400005)(40480700001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 09:40:04.8189
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 68a2746b-1c7f-41a6-9ec1-08dad1edb1f7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6549
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> Add new pcp-prio parameter to the app subcommand, which can be used to
> classify traffic based on PCP and DEI from the VLAN header. PCP and DEI
> is specified in a combination of numerical and symbolic form, where 'de'
> (drop-eligible) means DEI=1 and 'nd' (not-drop-eligible) means DEI=0.
>
> Map PCP 1 and DEI 0 to priority 1
> $ dcb app add dev eth0 pcp-prio 1nd:1
>
> Map PCP 1 and DEI 1 to priority 1
> $ dcb app add dev eth0 pcp-prio 1de:1
>
> Internally, PCP and DEI is encoded in the protocol field of the dcb_app
> struct. Each combination of PCP and DEI maps to a priority, thus needing
> a range of  0-15. A well formed dcb_app entry for PCP/DEI
> prioritization, could look like:
>
>     struct dcb_app pcp = {
>         .selector = DCB_APP_SEL_PCP,
> 	.priority = 7,
>         .protocol = 15
>     }
>
> For mapping PCP=7 and DEI=1 to Prio=7.
>
> Also, three helper functions for translating between std and non-std APP
> selectors, have been added to dcb_app.c and exposed through dcb.h.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
