Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A2F4B6628
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 09:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiBOIcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 03:32:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiBOIcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 03:32:08 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2072.outbound.protection.outlook.com [40.107.100.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369068302A
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 00:31:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/bDk7/pvDwJSlpahEU03iHcGhmWB5OhWvOWI2bu6Qlauz06VDxt2tOnZvFUwU0OV9QNThH1wCiapm+U3WtRpVeytoVZF5cw7NU+AuQnrQMqvb6CYxFk5kXFE/ml8jfUafKkQLmxIp+GhhzYZnocYiNdKEpmWthgmfDrtuLg4QBRHjU/My0IhutLA8OD4MWx/dyu5qNo+wwy8vQDuwAkdt2HHRccO6opvc4jS8iLxM/Mai3dWRizGEJkeYDKSPsd57tR7uvRnwnqVuTjfU1QyeZ2v8BtD1jyxZ4trI1t/SIZX5vuo0mcR6wqkqYXzGCncQ8HUZEchY5YoJ6uAkL63A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LwksxREnqDZhIxaP722rqDcCTZJ0GA30yPvOjRHAYo0=;
 b=C9iKa6NzoVXoVxxMoZVkAlLUM2WMprJQuBJf2sKz4NNU3hBWYhTbSNTNma5G/IS9rcLawI5kGwpkkH8kQCBBVJvboDOIH2wOrfmpb/c7sx4qAA52xFv388eBMffCkdi2I3OX0tFpnbdWF7W9G6Oh3PM3fKcgUHi2D1qCR+xGIOjZBoprxBmrlD3/jGPUh0Fre8YtW/3yZCsmL20CPGYUCzBpYjhrIbsMvWBFTj6VWTWOw0PArIdyQovjrCt7QRdtFN7piyx0g168L9ZpECj3+jzlUBi5aX9EeLZ/edQpRKDB3Cin2Z0G5RjI+oV5LmTc9naK4ZYZ+6EDXY1jt3HqqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LwksxREnqDZhIxaP722rqDcCTZJ0GA30yPvOjRHAYo0=;
 b=g4QfpHz8xXM2mIOiHsc+z6zc3UyL1kI/y0hhLAHjklTPopP/z0XGtMeQWPyBIZleOVUh5DHlf2aDc2YJ/R7bMfmX5LQDc3Im0SgW4Hr5pINvalZe/YDthQ9QZ/KGyx3KGQvyqLaV5dA6ijc8U1v9uuDNzzGCU+0q5SbKgSQM/ehQy8wo3tCN8N7wZRfs9HcdMfay5DknhT5RJ6cn4rRfNsV9qpmrztGFHChZJGyigHqL6dIzqWtTOOvrXFl0C1tMmn7BkhUJ4/bO3BjthCDr4r8hTn6l+O6Y0MpJRP/0Km+MFlUvbMksfSmzXjAq3qVCzqiamFWHchZgGAHjQ2tiuw==
Received: from DM6PR07CA0068.namprd07.prod.outlook.com (2603:10b6:5:74::45) by
 MN2PR12MB4423.namprd12.prod.outlook.com (2603:10b6:208:24f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Tue, 15 Feb
 2022 08:31:54 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::14) by DM6PR07CA0068.outlook.office365.com
 (2603:10b6:5:74::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17 via Frontend
 Transport; Tue, 15 Feb 2022 08:31:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Tue, 15 Feb 2022 08:31:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 15 Feb
 2022 08:31:50 +0000
Received: from [172.27.13.89] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 15 Feb 2022
 00:31:45 -0800
Message-ID: <9429cc71-1b0f-7fe3-c9dc-12246a397e96@nvidia.com>
Date:   Tue, 15 Feb 2022 10:31:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: bridge: multicast: notify switchdev driver whenever
 MC processing gets disabled
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
CC:     <netdev@vger.kernel.org>, Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@idosch.org>
References: <20220211131426.5433-1-oleksandr.mazur@plvision.eu>
 <20220214211309.261bd9d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220214211309.261bd9d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7ad1dbc-5865-4909-9325-08d9f05d9e9c
X-MS-TrafficTypeDiagnostic: MN2PR12MB4423:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB442330A554E555BEE4506E0DDF349@MN2PR12MB4423.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RpsOXHshMIyZOw/94c8fPqfI6GAkK3KUsBHGWvqskgVgnSYezB0SejL9SUnsaEbLzmQY20OOPgivnm0jFw+WBN/rHVmUTOQY7nVPmK9QrKuokyHF9WIKiRtlXLexddRMlc60HJbguDFo4ahR5vNPBJ83pEaRfuay1UsEOSGTg8h9EdIHBHrCuSVmxCxgIDjqM5TAA/9KiN+hYUwsZqIYDCk+Tay4f5VZSG1FgneodgoSIEZJIzT1pKyVH8LhAwyT0eoo1v68xZGuyHAxOF/9vO/JlDLmLbQEf9RbcClRoodFdg+T1uN5K1+gU57FMYkRiuw+9x7eczgLpX9Qgb3f/tDc7MS+Uz0UgJ52dr3RiVtA5gzzW2RiWFQvhc1vsH8xM+6z2P+JAINocqj9yZH6Pw9mpAv6hnKUNy6zsBTqW7/IveewJ+PgE48RpVStKuJtDGWvYOKyJBj+sGkhxQuTaAxxoRYX8rFf0P+GULesqzERnvPAK3//h1oU6vjoYyfcFwkfLH5sop0VzH4o6COLRllvMzYedsIcyzWvDH7l89WC31NaQf9VPi4lcWchVRAwAMJ3TseVj14pDC+lTEf9XkxhPimoiEMyvWpFdWBSAA2THvi9esdg4asCzkdiJoT0R07+BIsVB0USmml6MjZunNK8LXqkBs4wn/n0j3MGwjy9cHkVWAo7EgUcDmJUGjzwNFFkjsa+7zVZ1srOXk3t6z8z94If56EQTRJ6MlitDuK5WfmmEzChMTzCSEhMpY17
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(81166007)(4326008)(426003)(53546011)(508600001)(86362001)(2616005)(70586007)(70206006)(356005)(336012)(5660300002)(83380400001)(8676002)(82310400004)(6666004)(8936002)(36860700001)(110136005)(31696002)(2906002)(186003)(16576012)(316002)(54906003)(36756003)(40460700003)(31686004)(26005)(16526019)(47076005)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2022 08:31:53.2228
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ad1dbc-5865-4909-9325-08d9f05d9e9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4423
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

(+CC Ido)
On 15/02/2022 07:13, Jakub Kicinski wrote:
> On Fri, 11 Feb 2022 15:14:26 +0200 Oleksandr Mazur wrote:
>> Whenever bridge driver hits the max capacity of MDBs, it disables
>> the MC processing (by setting corresponding bridge option), but never
>> notifies switchdev about such change (the notifiers are called only upon
>> explicit setting of this option, through the registered netlink interface).
>>
>> This could lead to situation when Software MDB processing gets disabled,
>> but this event never gets offloaded to the underlying Hardware.
>>
>> Fix this by adding a notify message in such case.
> 
> Any comments on this one?
> 
> We have drivers offloading mdb so presumably this should have a Fixes
> tag and go to net, right?

The change looks ok, but it'd be nice to get switchdev folks comment as well.
About the tree, -net should be targeted. I think the issue has existed
since mdb disabled could be offloaded, so the tag should be:

Fixes: 147c1e9b902c ("switchdev: bridge: Offload multicast disabled")

