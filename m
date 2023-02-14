Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0398269646C
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbjBNNSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjBNNSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:18:32 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5434126593
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:18:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcNlNDGWbEzGgHpL9fQVjKMYqzeRXmPUQj9jXTEJStt3Tn6YbU/VDSDtwe2rSqbnzc5/DtqMHqFWvnIelABQ3n9xotGz2M6/9gj0OPcX4qpWecf9Cd6oSj62dpkGA7CPDUOmhxz3IfFADFbGSgyW47Ty87RHipL1wE+I5a4ZRkRZ1DS/iB/ydPB6Qpy5CZptsOv3DjSzDgtOR8FEIwIYvUep1jtnD0olyf+MimKQq0MOAC/U0BcgKk1DY74sDAaO0f3rWX5lnhH0bVavspiLpCkHCiw5i5NM+iG/AIrEKT1DMWrcWG/2HHAfTRie7RL0zUntYT4ObRt65Mw2mjcV7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8hZlae35s3Hqc51mq/QNvLMTkGsF+Ei8TkTQdpWaYN8=;
 b=B3KytU7hIcJOFYbWObbk0PpfDqn6XEgCh0nS+lznlInzgxDA5WAVT8c/d2IZSTBJENr5uid7z1aLeqFwh7cFXhcmzTZ2W29J6jFpiGWY1w5debJo5qVYBZfUUKZ1QcRkD/w6/jqdpLPkr04UGT+ZvUO/2S12LONb5/3DXqeUZZutQ+gF727ytKh7uN8e7lC9UJaUbMCWbk7wegYalaGVx79k12b9xAkBRAGBgIBZSZcm5vZ6HCUQhdQsigibnTX52L6mDgjW5vjAuxe7a8qKFrfwSYZzFm0U/qI8IYyt4zqCx42ThtrPg0eUJDgw2cKwJlhJIVGjzDAfAwRV/fVZuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hZlae35s3Hqc51mq/QNvLMTkGsF+Ei8TkTQdpWaYN8=;
 b=uYSHYv8GXEE/0WPyfzlJrskcfxtR0qud2khCJhUBbVLxl56VaqohjOVKM+LqfeekLfWP72JwPVeW8dqEt5+XGtevTpZzKRu70ikB/w2FjPB2v0PiHBAI1OFtsXzD7PQ8MyL3SXHPHRoEVxnMBH3ufm+pfgUX0fjc+zUmPRkROnmcd2ZgMM74mBJm+sQJPnvrkgU/e/Bi/u9oa7Gwa5Rr2Oafs9YL5Vjxu3qaxCP8iIZdSQtWM0opSa9op4J5OI+r5orKGDAuVkG1ReTxAz86mGZfHOLVIEAysQqL7fchQCrSeYty1u/opAjZczQOaxWM4k2zKU7l8VF1MupIC/mWqQ==
Received: from MW4PR04CA0114.namprd04.prod.outlook.com (2603:10b6:303:83::29)
 by SN7PR12MB7156.namprd12.prod.outlook.com (2603:10b6:806:2a7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 13:18:29 +0000
Received: from CO1NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::e7) by MW4PR04CA0114.outlook.office365.com
 (2603:10b6:303:83::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Tue, 14 Feb 2023 13:18:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT095.mail.protection.outlook.com (10.13.174.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24 via Frontend Transport; Tue, 14 Feb 2023 13:18:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:18:16 -0800
Received: from [172.27.0.240] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:18:15 -0800
Message-ID: <5ca5c440-f332-9a0a-4ab9-8bf5ea4db9e8@nvidia.com>
Date:   Tue, 14 Feb 2023 15:18:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next 01/10] devlink: Split out health reporter create
 code
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
 <1676294058-136786-2-git-send-email-moshe@nvidia.com>
 <20230213221712.3f91f288@kernel.org>
From:   Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20230213221712.3f91f288@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT095:EE_|SN7PR12MB7156:EE_
X-MS-Office365-Filtering-Correlation-Id: 74f5e71e-d651-4796-f9fb-08db0e8df681
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V+r7eZcykHZDbF6nxLeGkBOXxxrUL6uT7liMgxX2LBhSVHYTzqXnI8JvpzwFRta+MD1+PoO219k+4SlJsRRsonvmEV7s2XCwIYcRQ40B1JwcU88ch36rNB0klCxyjRVgoq7SBit5wPvv38t7t/5e8YRXn51HyB0xWLMX4St6Jc3e40KX4pIcKzoYmbusUcawiqVvuX9hyqxUSpZp5/KwTaX/b2vz5Y75MYnDHJ8+PgV7hxjHfva6m53oEQe4njYvu6HhHht8MRPYOgRMOywBOUdLb7mVBZ87eSzH8xiNgmwxVOz/rPa0rz7m9DVeZpFSHmoHIOOpqWwftvMCntowoYCwoE7Mqu3Vo7qpCeo+SEThKW0TMhdcbljee+xPYdUWt8azxfudtVOxIuIXMe7mNJmLUhPldkt5F/f/vIwzYLwjClGl+qmb3fbLNmB2Mv30KNCCfPmQOSfh7kVZ+IT4Na3/+3uvNeUzfduo3S7bh6rPMQTwJF8PXibhf9n6ekwzWzcWYFVEo+xkTDY1lkl3iW+pBPxOYLOC8nJyUS8rzc/gy9LORziG1R2zTBczZlrR6jZUWxkhxR38+xM9VBCdy2WXK9jfkaf4TuoHOxgXrRcX6UTGKgN4rQa+iX73BIMibxULs5WtcSEB8+T9+7GXru9W3o5qzoVZwZBWV3EhSTYdvz6ZtH5+m70MXp09TuspuT98bCBfTgZ7T/za4x19DJcqPBX32trDUWeT3u5zYnM=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199018)(36840700001)(40470700004)(46966006)(26005)(186003)(16526019)(7636003)(82740400003)(5660300002)(16576012)(316002)(36860700001)(86362001)(356005)(41300700001)(8676002)(4326008)(31696002)(40480700001)(70586007)(70206006)(426003)(6916009)(336012)(47076005)(82310400005)(36756003)(8936002)(2616005)(40460700003)(54906003)(4744005)(6666004)(478600001)(31686004)(2906002)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 13:18:29.0385
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f5e71e-d651-4796-f9fb-08db0e8df681
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7156
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/02/2023 8:17, Jakub Kicinski wrote:
> On Mon, 13 Feb 2023 15:14:09 +0200 Moshe Shemesh wrote:
>> +/**
>> + *   devl_port_health_reporter_create - create devlink health reporter for
>> + *                                      specified port instance
>> + *
>> + *   @port: devlink_port which should contain the new reporter
>> + *   @ops: ops
>> + *   @graceful_period: to avoid recovery loops, in msecs
>> + *   @priv: priv
>> + */
> Can we drop or touch-up the kdoc as we move?

Sure,  will send v2 fixing kdoc

>
> The indent should just use a space, not a tab.
> () after function name
>
> @port: devlink_port to which the health reports will relate
> @ops: driver health reporter ops
> @graceful_period: min time between recovery attempts
> @priv: driver priv pointer
