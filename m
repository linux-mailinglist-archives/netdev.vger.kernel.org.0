Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD21868878A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 20:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbjBBTeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 14:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBBTeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 14:34:13 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885142C64B;
        Thu,  2 Feb 2023 11:34:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZ+4Ug8fM1q3M/dPpUZsmg099C9NYGmRHd6T9Ha8TbS7MepyWBMKdqL24UrzhRX8yqhB3EHElH4bkxKPXo4rNWtZ84zl+BsI1Xy7ujMbJFYMv1Ku4qZav/n1RVZz1onU9dXrvoCOz07nKohLw/iV62PQQeH4Wod8qVguBWKrstk6NT1uzfdhZ4L1wMJC2F9HEzmIjMBwaKbQBmIUGZsXf/g7HzvKwDUnumESva3PKHCaP3JuysfBHJYr+7qyD+c8RBKKJ2XimOKNexRzTxTn4EdDol2+QeVU4h3xGBTVgnH97LmxgmSeZut8zvaJoDCiGEglL+SmfmtZZ4bx3WT3NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ST6S4MmwoEMA5I0j8P326vcCPpR/EUQptDM/zqhfzns=;
 b=Jbvs0GVnSKlFmGTbHnjhC2K3PxHBCavfBZxRVtB/ijGvgX0kWzBmnmBZRzR3zgke7dpVFfVIGAX++ObliDfLVVjyq4UlrQZODrljz/mREz1n+hJ9sVMjMYqe9E85CI6Nr/CXbJEZsuOM6t5WG0QL4iTnhHB4PbfUmpnoEZK+xGpOIXu6V7LJVW0porM+UGCOrdk0mhWy2cqu+YVvIpVDZ3/x7ym7qn0lDf9NWIEUi1K9lqTQbATrWyx6ImemENkFah5hzI1IeCZ5oo0iy+8giw7hzA5G3UPJx5bJtGlLtRrnL/ZoS4S1RNKh4mXnPaEP5d+yF2TLyuUCoHE32kc4VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ST6S4MmwoEMA5I0j8P326vcCPpR/EUQptDM/zqhfzns=;
 b=A9JAGIIpJDZnH4+uALhi8kfbI0X1xx8cUb6/HaFOzK+Jgs2K6gSYzx/L5OT6LDvuTJojy3BEMmpS7bzTPMD+C9ROknPHItb0lF2Zgqa6gpdfSV8JTpqKOXSbXNvx1lysvQiqcGLymtxaCHaZPI/6p9+ngQtgUpFwGpY7VxdXlUh4v4uXQwLn5tQRlOHgeHL1m0X1HALzUIg3FWKTsT7Cz4BCi/I3lXLWEzsi8lTjsvDxrkshJlCNw6MP7VNJKGnQ06EcuX8lgsO5sFzEq7eCskcXV1+VkhcDfthwYSpk3//SBoVNzga6HeLg60eAhjcMFAGo1bqDZknW9cLYskZvAA==
Received: from MW4PR03CA0170.namprd03.prod.outlook.com (2603:10b6:303:8d::25)
 by SJ0PR12MB7459.namprd12.prod.outlook.com (2603:10b6:a03:48d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 19:34:09 +0000
Received: from CO1NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::c8) by MW4PR03CA0170.outlook.office365.com
 (2603:10b6:303:8d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27 via Frontend
 Transport; Thu, 2 Feb 2023 19:34:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT086.mail.protection.outlook.com (10.13.175.73) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 19:34:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 11:33:57 -0800
Received: from [172.27.0.20] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 11:33:55 -0800
Message-ID: <52392558-f79e-5980-4f10-47f111d69fc0@nvidia.com>
Date:   Thu, 2 Feb 2023 21:33:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 7/7] devlink: Move devlink dev selftest code to
 dev
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1675349226-284034-1-git-send-email-moshe@nvidia.com>
 <1675349226-284034-8-git-send-email-moshe@nvidia.com>
 <20230202101712.15a0169d@kernel.org>
From:   Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20230202101712.15a0169d@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT086:EE_|SJ0PR12MB7459:EE_
X-MS-Office365-Filtering-Correlation-Id: 8859c174-b637-4695-5aa0-08db0554749e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c+halTPW1rsTRMh0UR98w5wmc0PCIZtZCrpymzmoVEM0rRA+HB90v9gDN8ziTmW4tRz9Dw3T07fgdXJnfnUdZX11r0pCyOtKl4cPra86PLlB3GkEJF+nwC2ztH71eVCB02ss8Ee9F/pMxqFvpnP9fmCLFE/8y9xBlVrZc8Xacfw4pc05iRdl0StdM705eisn299q/XYsWCapnWmbF5VP+qatYY0UEkVFiIHDP1CsxRzFphZtalHfZ6S9qaCOZ3/0VXTovKQYHSaebVrfqIyUb2cIPYBwyHx8jCMFJPr35x6OWKzT1K2xMJbnXQ3CyMWl50ebaI/AD/sTWd6sOSmUIFRJaLz7G1IqhyRSKx7T1JBjQbfUJdZBLeKF8mLH/2+VSD0dYqvBE5ZpM9pFrZoUl7G0ZhhL7xUfys0/KCHuvZxmGc2Oolj+z1lvhVry7c7cPZJgTqslaDYm/CwX2YJ2fGhDosiLxLG+i60nICfZ3SOm3zwBOkkQXttb5u+5qQamrmqPkdgmQWfV0Ss5doP1JUJdmla1gLM0Hss9xE4iyr/iqGgoTHEMoZk/HtnV7Qq8Agp6SSYxq1LiIZQsNgn/uIv45uEPdRrNXG0lA8EzlbD3JkH8hnGAopa+lpku/26kzTtZIyjYjzvmBK96L1Qk1xzj+gSKeVOo3j1IfmbCwoZY+F6UDR/ytEOKEAadlh98LpUknR7gV70q9juy7JaOeHBpDPfZ8f8AP9gVCDnD51U=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199018)(36840700001)(46966006)(40470700004)(31686004)(336012)(316002)(47076005)(82310400005)(426003)(54906003)(6666004)(2616005)(16576012)(2906002)(36756003)(7636003)(36860700001)(356005)(82740400003)(40460700003)(53546011)(70206006)(4326008)(8676002)(70586007)(478600001)(26005)(186003)(16526019)(40480700001)(41300700001)(31696002)(86362001)(6916009)(8936002)(4744005)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 19:34:09.4046
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8859c174-b637-4695-5aa0-08db0554749e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7459
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 02/02/2023 20:17, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Thu, 2 Feb 2023 16:47:06 +0200 Moshe Shemesh wrote:
>> Move devlink dev selftest callbacks and related code from leftover.c to
>> file dev.c. No functional change in this patch.
> selftest I'd put in its own file. We don't want every command which
> doesn't have a specific sub-object to end up in dev.c, right?
> At least that was my initial thinking. I don't see any dependencies
> between the selftest code and the rest of the dev code either.
> WDYT?


I thought as it is devlink dev selftest, the sub-object is dev. 
Otherwise, what should be the rule here ?

How do we decide if it should get its own file ?

