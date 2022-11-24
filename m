Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F114637D80
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 17:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiKXQMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 11:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKXQMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 11:12:30 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C05EB7E2
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 08:12:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYzVs0TOKei6W2M6hIBE7hokZnXoOORTq9KWcXn6N6/tY73K7LcmIwnQPptlG5rKXh3PB2t8idSS+cnlbNE3RXWdT/FK7APgYi8hrUHq2ea5LInzhrie21QnMoUiIc1YmN/KpUoXwqawykH5neu223J1QllizSd4HJ5j/D9KjWGm49rd31sz9GGDbNuFUNldARilEVwl5EEF/WCnb9kplUEmVzUe5UODkBApd51/XdYp3YokOhuUdm3Uq22AXU8vMRLvFOHz5NOZNU9sBlrr4RM9M9DNyIA8JhQ/snZ4p6tnD8OU+iepZm+FkL6yYme843oQPoQ61xB5k3nJ3dPdgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+raroAX5u07fGV43T6DC/XCg6kdqCIQLsJmmJ0dB8g=;
 b=n7Il4V4/ituxFbTSdN2ODlSKtkVBDxrRqrP1oxaksUUCKEmNM3cg0YKzFMVB37fGVkva5ZqaiFXJUlHdjBgDmPyeDLISgNd5sa6bATeN//tkc5YWPGE1s5KlJbSjTxOS3+IB3d2GhTqwuTEQ4CDpTRzxAhvX2uvuWQ6z5OzQQEdoIDBEejx1gQaa4PRsSXtczjWMXJYAu3sPFPJcl4Ky1oSj62EndQ34jlHLJ9jZ62kDLUW4+5JDdcfAPxOFGdd/GE5SkxshD2zkPC6M+PR88TBvOI/SUulKjUw2dkZPUiJpW0jniJPG2QQ5otsbaKHzITilIi+EWObAV8gQjcLlZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/+raroAX5u07fGV43T6DC/XCg6kdqCIQLsJmmJ0dB8g=;
 b=UsWI+/+xoy2fzhnB3zVSdVMSUs0XBDtD4gq0Oxs6or0bbpDnT29rdUmPvrcqRv/1UdcdN8ZmrnE0xwkWgKGkJkF3puOjgcv3VwU7qWJqKFrsbjgElJlUYGgP/2S5mIPjawbTOrIHZqHoJ17Sv9LsNV1Hbp7Ap5jy4N98xUQiiFqhofTeq+VW90a2mF782V+9ouYFt/J2iEdH2CujnhMuMA1hHUwTBwQ0bm4r9zy8+ioSS5CgLvM+uRPQHf2336OILbiiNnLyafpPDoejb8Ic5m+e9nOv7zLKFmcAma2anysfXD3+qVqa12/FYmRs6ssvWly1rwgpieMEqnFP97ypGg==
Received: from DM6PR03CA0054.namprd03.prod.outlook.com (2603:10b6:5:100::31)
 by DM6PR12MB4090.namprd12.prod.outlook.com (2603:10b6:5:217::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.19; Thu, 24 Nov
 2022 16:12:27 +0000
Received: from DS1PEPF0000E642.namprd02.prod.outlook.com
 (2603:10b6:5:100:cafe::2a) by DM6PR03CA0054.outlook.office365.com
 (2603:10b6:5:100::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 16:12:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E642.mail.protection.outlook.com (10.167.17.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17 via Frontend Transport; Thu, 24 Nov 2022 16:12:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 08:12:15 -0800
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 08:12:12 -0800
References: <20221122104112.144293-1-daniel.machon@microchip.com>
 <20221122104112.144293-2-daniel.machon@microchip.com>
 <87wn7kibn8.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Daniel Machon <daniel.machon@microchip.com>,
        <netdev@vger.kernel.org>, <dsahern@kernel.org>,
        <stephen@networkplumber.org>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next 1/2] dcb: add new pcp-prio parameter to
 dcb app
Date:   Thu, 24 Nov 2022 17:11:43 +0100
In-Reply-To: <87wn7kibn8.fsf@nvidia.com>
Message-ID: <87sfi8ib6t.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E642:EE_|DM6PR12MB4090:EE_
X-MS-Office365-Filtering-Correlation-Id: a390a680-84d3-4e3f-8e01-08dace36ae7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QXJ7OW6aNzURq/bEz8n3F+kTcttUkMcdCZ/zZhgUgSq3LzSXaXaaEzFjTBfEXx5usEp/06wP/MPh/MGTzgtyLdjOoSyoBRkMZBcTwYBvNmENty62bkeFiIsmzWZG0NtPA7MPtKSF3ckxmrPp9We03vBAlhlT4gxAyaMT/iMn+46yRv2XRp5ler7nrxHfTNFjfjnKwfjMDyPj+7hw9pbwv1hiyXSEAFZJHvdhYqzI14p2t5VmG2YmbtHWbqNLmSlzj9mvAtHDfsw3akb/IIKZl1M6iIddl4KZnx6nHGrNgjpAzJOBnWV53iYpNwSr1vHGegxRv8e/7AVPeI4lUgwd0Mv2YRgVRkT+W7UtFqHpLbSU2N1LwehUiA2z76oQJbYxOwlq5Pv314A72l8t27veOY04hsm79mbQBZzajVGJHixuOJV9PPITiwwzU192XrmyfkM7tRKCjlWSwH347tFgXk2VObmjx+lJlqwYSs9GRTr+w+LQLgbWIgEzJ+Eq+D2mkQSNXLH6A5X9vm7TokIxOw2t9WcBgTyl61+OmUOfyluFFZxhRE1FZm0sDTLVrvK9zj9UEH7wbEbOndeUNrk2nIU2P24Z7hugw/ezgYFoJ7O0GJPCBbw5RAOxlqSq/zb1rohkIknhYq6yw2DGJRKogzDrpNAX0CieWjGjYtcM2qbkLqjNNBWgA452zsnekGQ23luGbUJchUAlqMp+eTSKNg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199015)(40470700004)(46966006)(36840700001)(478600001)(40480700001)(82310400005)(47076005)(6666004)(36756003)(26005)(316002)(4326008)(70206006)(5660300002)(8676002)(70586007)(41300700001)(16526019)(2616005)(8936002)(336012)(40460700003)(186003)(6862004)(54906003)(82740400003)(6200100001)(356005)(426003)(7636003)(86362001)(37006003)(2906002)(36860700001)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 16:12:27.6025
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a390a680-84d3-4e3f-8e01-08dace36ae7e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E642.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4090
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> This looks good to me overall, I just have a few nits.
>
> Daniel Machon <daniel.machon@microchip.com> writes:
>
>> Add new pcp-prio parameter to the app subcommand, which can be used to
>> classify traffic based on PCP and DEI from the VLAN header. PCP and DEI
>> is specified in a combination of numerical and symbolic form, where 'de'
>> (as specified in the PCP Encoding Table, 802.1Q) means DEI=1.
>>
>> Map PCP 1 and DEI 0 to priority 1 $ dcb app add dev eth0 pcp-prio 1:1
>>
>> Map PCP 1 and DEI 1 to priority 1 $ dcb app add dev eth0 pcp-prio 1de:1
>>
>> Internally, PCP and DEI is encoded in the protocol field of the dcb_app
>> struct. Each combination of PCP and DEI maps to a priority, thus needing
>> a range of  0-15. A well formed dcb_app entry for PCP/DEI
>> prioritization, could look like:
>>
>>     struct dcb_app pcp = {
>>         .selector = DCB_APP_SEL_PCP,
>> 	.priority = 7,
>>         .protocol = 15
>>     }
>>
>> For mapping PCP=7 and DEI=1 to Prio=7.
>>
>> Also, two helper functions for translating between std and non-std APP
>> selectors, have been added to dcb_app.c and exposed through dcb.h.
>
> Could you include an example or two of how PCP is configured? E.g. the
> following was part of the dcb-app submission:
>
>     # dcb app add dev eni1np1 dscp-prio 0:0 CS3:3 CS6:6
>     # dcb app show dev eni1np1
>     dscp-prio 0:0 CS3:3 CS6:6

I just noticed you have the examples up there. Maybe just reformat them
a bit so that they stand out.
