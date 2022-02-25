Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298464C4F6C
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 21:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236146AbiBYUSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 15:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236111AbiBYUSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 15:18:06 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16848329B2
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 12:17:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k08sEcRgYpFm3esi/sbuDVWxX3flA08IlCgeO4ypEZN96hq/WvGAEl+ryIl/nv74Ak6/OQurJC1etZp1ijh87/vgnB8b8zb2sck1HGB0fIeWIdmBLqToveG9v2LIPQ7NvI6/CztakM7pC/uglF9ZXfEhECC7JE8hueyJNmCp91yfKbDuLvf6/KawqpBkKHQiEh5EtJd6ucQQdZ8Ugg7ZlcZ97+dfVBDCL9YDp18W8oKHIVgcAcpBlneKVJpAJiPPEIKEVnWz9O/uuaoYi2yAnIkxvg7kj0SEbiZ8P5CVdv/eESMqpqTlr4Iz8WWDR4W6ShZ2DRBlZ56oBPiQc4AZ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjVt3+dbfOeLbRRH5W4CLUbrE+3sQ7d0ZsIXM9MvNjk=;
 b=QvRFs1R0NcWyPQNIMclMcyAKSMBW5VxPbbVGGZrH1W8kDFIhajY26VQBe6XZ5QyVozINSBM9z7xuvFwLIFt47aDQWjEcYNGNcOv9z3S4vsdch0pyhuf22SsJRB6YjKvtzu1f3xLyqhj9D0K9PryRzHfgvhtbwUm2zKoKghZU29s/eV4Z75R06M5Lsl3P3Sdglgf6lo6Bjgh6x0PUw9xlUxGDud59Ak5WTab+9A/iw+/f+jx7EEtVnzBRPi7cBRD0N7+F+Um9UMhLTPGcktZwqXDa077uu/xBWjBIHM2OHmiMGEm0H6C5KeA6pQ5zhIA2M786tkw3j/QlL3zvOsm1Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjVt3+dbfOeLbRRH5W4CLUbrE+3sQ7d0ZsIXM9MvNjk=;
 b=sNorjD0bRECi1Y7fX8FbZyHJo1EasSNatlUKSW7g4rOj+wcmRxUE237tm/UXUoWgsLD+IBgJCGA0ARlJNImbMN3R4DmnqxwLK4cl01fOKlWXAXKTWG6zFhLPezHzsSh+k670wz89h7zDwNVECyDcTMtB79FI58Auh5rXDjsUu/qCAje4X09Jo3HWzMemQhx5t/6eXyfCA3LUSRss7uFOZyJjYdFS+ttR65C9tedZo7xJOAEfUoEiWJzlKruemutgE22YsD/fwhFwdO8w4Ccr0WbVYvFc2765dfLPESkL0njj/jVEiBuorYbpc6ui+/pzJdFxYx8OHj8uE7yr5SqHOQ==
Received: from BN6PR14CA0013.namprd14.prod.outlook.com (2603:10b6:404:79::23)
 by BN6PR12MB1908.namprd12.prod.outlook.com (2603:10b6:404:fa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 25 Feb
 2022 20:17:30 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::1c) by BN6PR14CA0013.outlook.office365.com
 (2603:10b6:404:79::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Fri, 25 Feb 2022 20:17:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Fri, 25 Feb 2022 20:17:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 25 Feb
 2022 20:17:29 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 25 Feb 2022
 12:17:25 -0800
References: <20220224133335.599529-1-idosch@nvidia.com>
 <20220224133335.599529-7-idosch@nvidia.com>
 <20220224222244.0dfadb8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8735k7fg53.fsf@nvidia.com>
 <20220225081212.4b1825f2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <874k4meuoj.fsf@nvidia.com>
 <20220225095645.547a79f0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>, <jiri@nvidia.com>,
        <razor@blackwall.org>, <roopa@nvidia.com>, <dsahern@gmail.com>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 06/14] net: dev: Add hardware stats support
Date:   Fri, 25 Feb 2022 21:01:53 +0100
In-Reply-To: <20220225095645.547a79f0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Message-ID: <87wnhid7l8.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 194c7450-61f8-46a3-47b2-08d9f89bd99a
X-MS-TrafficTypeDiagnostic: BN6PR12MB1908:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1908A9EA03BEB2F8C85430C1D63E9@BN6PR12MB1908.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SbHTXMXm9k26r0+gLQLcRMXtty8B7Cn9Qzei1QUm8zODOai4JFSqyR4epABMgcxiUq3m7gjtyiPoApZE1iRGk54V0T/rqLQLAPCMKSuK+OsqGX7NZao3/z0WKeKAmjqWvhjcGnSRIlQ0lS6CDy/hLhNZWYnRpy+kIxJClZQdxHRsKUF2TXiKKRJ3xmPjHRxAIUAuBlKBkH8GUc8iOA0++52SP8BhFiwdcpXAlj8I9YqphdIxrnUlHdMqbxlGjn4D+GEL18sThWkf0sCychZpg0XM4p0YrFIQZ+pAZf6EerJZuk137K8Aqyt6VjU6gjfb27QNruWIRSBKHIMEz6ouuzSnkcBnZooJLUcWXyriFLUT088kUpIvys93be4tE5i/JKyHiUPjUEXZcs2CXxwQG/iuvpVz5WxJVk7GMF2loyKn1R/6zl1LLI7N4X/JUhIwc9qe6IjTJrYgmaFeIbmRe9VD8IeLN9IuT0HUIlsgvo4QzqyP4MMh6VTq+xVBvd1aDemUtPmcKeRfHs6WOQ9SlgZ+UqwqmPZ0m3nG9IJy+HjWhuLucggzH1HaAgWV2ojee1NLymGAapzqgRUXJmdiaXsvmUTMY0R1+0RKyVz89BOXTOnL07L+mfyKj6d8O4GVD6WpgMX6HC3b5BzJ9Dc/r7eiNACs0pi0SOQ2faHN1pHE4v/QO17E/D13BvDDwWa1zNzF66XzR1O4/o7WoChZ8/Y4z+Eh+CUWgy1EindB/wRobO25jRS7gpdyIYWGZgQz
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(508600001)(8676002)(6666004)(70206006)(2616005)(316002)(4326008)(6916009)(54906003)(70586007)(40460700003)(107886003)(36756003)(26005)(86362001)(82310400004)(426003)(336012)(16526019)(186003)(8936002)(5660300002)(2906002)(36860700001)(47076005)(4744005)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 20:17:30.2147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 194c7450-61f8-46a3-47b2-08d9f89bd99a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1908
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

> On Fri, 25 Feb 2022 18:00:11 +0100 Petr Machata wrote:
>> > What I meant is take out all the link-level / PHY stuff, I don't think
>> > any HW would be reporting these above the physical port. Basically when
>> > you look at struct rtnl_link_stats64 we can remove everything starting
>> > from and including collisions, right?  
>> 
>> My thinking is that stats64 is understood, e.g. formatting this in the
>> iproute2 suite is just a function call away. I imagine this is similar
>> in other userspace tools as well. There are benefits to just reusing
>> what exists, despite not being optimal.
>> 
>> But yeah, those 120 trail bytes are very likely going to be zero.
>> I can shave them if you feel strongly about it.
>
> Yeah, if I'm counting right we're reusing like 38% of the fields, only.
> We're better off with a new structure.

OK.
