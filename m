Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D97F4D9577
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 08:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345534AbiCOHlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 03:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345570AbiCOHlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 03:41:02 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2085.outbound.protection.outlook.com [40.107.101.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637224B85F
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 00:39:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGCWBy75VHoylOLTrExm+t+YrKY8BtjT67Y1fQGLqb8a2z5peD6zkP8397WomjzqwAGLBG0f2mOhfH7vT9sQ8Z8NpA4j1Zghk4fQYf2pvBVo7bOyOf0kLeXkkR6u5rN0Hyy8S6PX2tpCRd1Hxwf6eK0XZX6VM4tblDTHMcOIUdXN1QkRwZEXL5PsDQNVKfk6AHozQ4iBQYBssyMBa6i7yBSEsDKEMcq0UYxqpF7iNtuRB3gzTlOi3OkNB6y4x2UmK3Zijq5PkbQK8N4ZPQNJVWB/FyB42JMpZcLqALV3H4sNljuu+LjoL8Wi/kGQZieKwhF0vTLL44D61PZBksqBPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eWgszz1rhuF6y7RovN0sqBJ+dcuItso49Z8WH8sntvc=;
 b=f+Fg7khpXdEoKNoGa/v+ih3gSFWnG83h+9qcLFZEc1ayLsmzKCjKWnmYmLzk+pvIMQqkmnOwYIelpHnI1cNOEuRyqpzff7OswzDzocQkwbz0srhMH4hrXtv/mUXRGilFsXhT/1ZfM0tbYY+IN0aC11fn96J8Xjd2cHGu5YbdZ2NXTvXUcuiMNQCVSb9srQd7WGg6DlR3SONRtxLKj0W+gnhedSuoSkDcPW5zZ+8P3hh3lWPmFkuy3QlxTjjlN1Eg+J/ypbZ0JueptFQvKZAwNJukcgP8AUlhkNnKWEaDUMbAwQjVswApam7JrWbQksPtRe8JmRBj5dzJJC/0ATAaOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWgszz1rhuF6y7RovN0sqBJ+dcuItso49Z8WH8sntvc=;
 b=q3NLsTRYBogPaewX8SRmYCRel53SwJPGTEKBLAwVhhG/YfMLq6GPhTkZp35Xt0F/fU8ZPU9ttORLWs88zMLS0lEir1ooGtSxX9R/4DB6OP990RDYtXzbSwZ+BUIv4P5qt6olrogSqErGU+hE+E1HNSii3nxkN/xV+2Ej7hjg54vFj2QeK7UJNHluIKWwcV2R2l0Peab/gsCopxTTU3vcRO81U7tQoPv1i5VHpALrD9jgkfk86kynVrIOPre5+w4K9OPhmQ+iXiDRxGJiJpjeqpF3imP68ImHZxNVs8xAYtioeA6Y9w/yNmtBam0kxb8AAKIeqI8Wlv8dK2Abo6Earw==
Received: from BN6PR13CA0038.namprd13.prod.outlook.com (2603:10b6:404:13e::24)
 by DM5PR1201MB0169.namprd12.prod.outlook.com (2603:10b6:4:55::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Tue, 15 Mar
 2022 07:39:38 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13e:cafe::c8) by BN6PR13CA0038.outlook.office365.com
 (2603:10b6:404:13e::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14 via Frontend
 Transport; Tue, 15 Mar 2022 07:39:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Tue, 15 Mar 2022 07:39:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 15 Mar
 2022 07:39:36 +0000
Received: from localhost (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 15 Mar
 2022 00:39:34 -0700
Date:   Tue, 15 Mar 2022 09:39:31 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ido Schimmel <idosch@idosch.org>, <idosch@nvidia.com>,
        <petrm@nvidia.com>, <simon.horman@corigine.com>,
        <netdev@vger.kernel.org>, <jiri@resnulli.us>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and simplify
 port splitting
Message-ID: <YjBCs/uc+djgQRgH@unreal>
References: <20220310001632.470337-1-kuba@kernel.org>
 <Yim9aIeF8oHG59tG@shredder>
 <Yipp3sQewk9y0RVP@shredder>
 <20220314114645.5708bf90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220314114645.5708bf90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73b96732-f1dc-43e5-7b75-08da0656f54e
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0169:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB01690E8B832F7E2845AE5AA1BD109@DM5PR1201MB0169.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5NCM7DgXqkcrP70u7kwNVb9DCIGUSAyBJwkcUSaQT49Eg/C9NVP4teLj8yvQZqvfOM03xfvMbY/hoLmSmLLUFKuc6aV+IGU5PW3kKU3PJyaiIa94E/Imjh+hc7xX9x8k59GemwXzX+dhW9SIdEAzuvC8hiZTc8hjC6BoNtFcsnPKCmWzddlp/zQvb0OhicT8W2vv+PmX3Wt41QUgIjr1DddwZkjO/QgSvcdMacLEYiTaFqf5b6E78HRL4Nv6Op6bZE/YfjmatLrRl5kEbOHRkB/NfoiWTRzTBbC4ODBIVsRYHnSfP9LlTA0B6iZ6Hocv98ct/yTPnPcIKb7KfrkPXRMloANq9k8Loq2v9lI8FJV7SXRMVFu5nJRVQpTc8cyPa+yFnxiXHUf+kcFvBxkWss6g/ubL1w9KQCMOXzCWwj2L6iHl9VpGtG5TAIPEXcvc2iBsOr7Bt/U1ITgRn65iWGif3id0Tov19ymcBuKxjw0etkP70ZEvN1f69B4O59h0Ctj8WspmErcm9eN1gvSICpzJHFRluzoWUtOpWV4/3o4fLrr7RJF/yXrEXJcYqSt5XGpZ8PEMBYfeTL8KUBo6DeWTjtPWE9Vj0n1Te1zR7uyGYRW17wjjjt2Avw70LEmQjKJ6e84aINzo9bhE4NwP6fUucgx0rHylD7pcqoT/6VXC4DbD8mz9jVegHU+PrrkJtz3HzOJPdqlbRlKP1GlCWg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(7916004)(40470700004)(36840700001)(46966006)(186003)(81166007)(26005)(356005)(33716001)(426003)(336012)(16526019)(86362001)(6666004)(82310400004)(2906002)(9686003)(508600001)(47076005)(4326008)(8676002)(5660300002)(70206006)(70586007)(36860700001)(8936002)(558084003)(83380400001)(54906003)(40460700003)(6916009)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 07:39:37.6987
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73b96732-f1dc-43e5-7b75-08da0656f54e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0169
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 11:46:45AM -0700, Jakub Kicinski wrote:
> On Thu, 10 Mar 2022 23:13:02 +0200 Ido Schimmel wrote:

<...>

> I have the eswitch mode conversion patches almost ready with the
> "almost" being mlx5. 

I wonder why do you need to change eswitch locking in mlx5?

Thanks
