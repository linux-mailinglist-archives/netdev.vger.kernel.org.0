Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6401D63EEA5
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 12:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiLALBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 06:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiLALAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 06:00:47 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9968F87C82
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 03:00:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EnjI4HC+IXeBI/yvJY+muoFMWApCdsiKLn9KcvnCpA4WacnDHzHfB4/gCB+t1EBsqh5Ha7Pf0BxNW8UjVoTXJQPIWu+eYXhkmng3voIRHZp6NNb4XZajv7I4Z9mfJ7f0EreN17WUG+Rbo3K3TDio9nLbjOEvOtpVBQF6KLYSFE/dAu0U8Bbb9M7A8Fw1WH8BvYnSFZ0MgHoyn+ovt6WVSR8kbo3bo8VgeuXLxS4VuAOlmaJySCNsxrhfLD5dQUyuwKwlpIcRRk/S69UlnH3Qas+x217OTfJ5VL8GkGlyrUIsNv8zhLrD5TFSr1FyfgDfC4M4V4UIsgf+t3YyaiKuLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QgxkHEe+q60ES7CW2xcS/wgiOSC3+YEaTs9lFbhIW8=;
 b=JvGItbLPdzOJMRQFL76LUnjMM8q129H9cUbCx/V1i4zLCQxzrW2RlPvefu1gIQvt6HeIjij/NdNZKyvWuxjLfwECIDBGcgGM59oJF9aSTB1KIizeWN+y6Ke3LQfQMdTqv0bd+5jdOILJxEOKHQ6PvlzuiNk1YxqEUFKgmgKcYhf8l27vhHALL0ANkOKAysHG6OJ1BbxsabWIePJF4fCcrEFHVi8IqmWqVi73XQ21dhwK8rDqEZQFM/cCsLzYYUr9ojx4OngU5fzZFqsE/epP7IwluLizMMw64qRWjyq4QVZcjef1fuE8LY6S+0QdQXrxnQPVTx3XCorvalmNux3q7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QgxkHEe+q60ES7CW2xcS/wgiOSC3+YEaTs9lFbhIW8=;
 b=PKdvGOH8yWlh0krfQeuvX0cNjwUpSyuXd/N2faTfgCCDYukYc7Pg+ROcZcFrzkcP26UvSrcPBeOsu9FdnM8Fa5tpFeu/Yxj0tG7t7v+AWoNNjP6+3HvA+SSkSxo5mmEXAZ9NpFDFER1OS4JFZiY6ZRZx//DqFgK/szczEM6mtY5xPrTBk7QMQN580ObcbblTbGmhrx9eLucQu9Ql3lbFVC0nzwREBN70OA0SmupGUyA2MydmowafS/JeqeN03/LnTfzl73T57i+A4RSjGmvJzyRZIluSR5cYbFRSHdgjzXOzrsW3Rt1Q9FwrEam8k9ozg8Hfs625goWrnA1QGnNj/w==
Received: from MW4PR04CA0087.namprd04.prod.outlook.com (2603:10b6:303:6b::32)
 by BY5PR12MB4308.namprd12.prod.outlook.com (2603:10b6:a03:20a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 11:00:28 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::17) by MW4PR04CA0087.outlook.office365.com
 (2603:10b6:303:6b::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 11:00:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Thu, 1 Dec 2022 11:00:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 03:00:13 -0800
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 03:00:11 -0800
References: <20221128123817.2031745-1-daniel.machon@microchip.com>
 <20221128123817.2031745-2-daniel.machon@microchip.com>
 <0642f8ab-63be-7db2-bd7c-16f19a3bdddc@kernel.org>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     David Ahern <dsahern@kernel.org>
CC:     Daniel Machon <daniel.machon@microchip.com>,
        <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <petrm@nvidia.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 1/2] dcb: add new pcp-prio parameter to
 dcb app
Date:   Thu, 1 Dec 2022 11:57:13 +0100
In-Reply-To: <0642f8ab-63be-7db2-bd7c-16f19a3bdddc@kernel.org>
Message-ID: <87cz93fky0.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT020:EE_|BY5PR12MB4308:EE_
X-MS-Office365-Filtering-Correlation-Id: f33b9793-b40a-4d3d-7723-08dad38b418f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cYa+ZINUBnnFKeTKJBHptewrR2/DdfbeVPoJMMdoIKsAYyahjXhOU7ewX7DoJ88oXlYuyS+1mg8OUv3REs2kRUCYL0Ck/EejNkUCxA1avFeFHddC3qOy/nXh2r90as2hM2lP7ZvBcQbMiTnS7pzfiujxZpC28OJg6mygRQETCY2nbJEB5HN2TJAuWrF6v4YFhV2Gp4+8JcsA9dkfU4WT5GTiZ4NZ67M1653fPwwCYF81xICOMRMaB4O1g+Ew8owNXkFNQB57fPNSwNP4cJpwLdFywG2DqYIeqShqFGhiimBF2KsHwfjrwfB72R0GVjC4s+oUax3okoPtX6CA1YtneCwqCWbS037aya+utnmetvoC9sMcy7AdF5tBSMck1thKE92AVdjRrjgUilbSU1q0kWt+rsJKVjufKGEUesaTTskwOS0SiSfjHSBgO4rYtWXf0jaKq/gJoHeryYc4FqRD6Lx1wvZQs1dM330MpCVg/aKw2EYhZW/dWT14T00Wan8NPCOmbUkO9CVY2FSPf7lsQHE+g1BTEqaK7Y8Q6GqAbLVB9zXA9pmh+/Oj7F1o4MO4g9QC9Sn89D2LYghYkOle/Wqt9La4on4woxDOfOukeSEU4LxWDei9baQqO8kyGrZPJ7/GQPxoCXOCFjfd9rhBPcghnhjIMYI2WjWujaWVM5taScb5vFpK2dxK98W5fMbL
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199015)(40470700004)(46966006)(36840700001)(82310400005)(36756003)(40480700001)(186003)(70206006)(4326008)(356005)(70586007)(7636003)(16526019)(8936002)(6916009)(316002)(40460700003)(2616005)(8676002)(26005)(86362001)(426003)(5660300002)(2906002)(83380400001)(53546011)(47076005)(41300700001)(336012)(478600001)(36860700001)(54906003)(4744005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 11:00:27.8463
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f33b9793-b40a-4d3d-7723-08dad38b418f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4308
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@kernel.org> writes:

> On 11/28/22 5:38 AM, Daniel Machon wrote:
>> @@ -344,6 +420,17 @@ static int dcb_app_print_key_dscp(__u16 protocol)
>>  	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
>>  }
>>  
>> +static int dcb_app_print_key_pcp(__u16 protocol)
>> +{
>> +	/* Print in numerical form, if protocol value is out-of-range */
>> +	if (protocol > 15) {
>
> 15 is used in a number of places in this patch. What's the significance
> and can you give it a name that identifies the meaning? i.e., protocol
> is a u16 why the 15 limit? (and update all places accordingly)

In case of PCP, "protocol" is 0..7 for PCP values with DEI=0, and 8..15
for the same values respecively, but with DEI=1. That's fundamentally
where the 15 comes from.

Here in particular, it is ARRAY_LENGTH(pcp_names), and I agree, it would
be better to express it this way.
