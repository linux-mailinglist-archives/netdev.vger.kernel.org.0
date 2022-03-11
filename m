Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23DE4D67B1
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349496AbiCKRjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241879AbiCKRjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:39:32 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0FE1AD950
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 09:38:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZsEoS7tdkE2wYL80vhdzD2lQVHNt7N68FiBC5QYCDqM1NW+Am/27XSFiErWN2lI0c4r6opeFs7dQGpDhQHQ9IHLT3U786xiwaG8sVmeATlhFH5Engh2QG6bGtKWMjG5zDwuUoCbYQqifzoDuLY6bAsyKSiQrsuabY0j/QUL9cqiCtKXc0hrKB4g03JmPBdHCC1nYYLDXQjj/mV2R9QKV88233X06kQz/9wEuG5iRSNafxUU9EMjHv2hdsdhgxbm2d57kkJQRgHAIcfrkm++/1/Rl5I29y0i6t1iaRTAwyV8mKsg8pua7tbNxWbbCKy163PCOQ83iOsgpFUPuCzArEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RT1SSdeIF9kQkZMAcKoBd0q6WQmmPZDfuxknV7Mxc8=;
 b=gYKrfP/ftPAV7PHHnD2YHouF0GGFIxXegumyJRnA6IeTYYg7n7Z7XBn7DZbCrUiAOZGWwQbcfJfjF4scwUJR/IQ2XgCj11im5pTmAiWBBP0uBixwFwVBBwaG/HRZVexngF7uZJQcB8PizjoSIDenpCm8m+lXHwp4zoVDohYYVbs4jQH8EGsF9rSn/0Qlxfs889co68QzsSgkZAwNbaG6ItYUmkVe2dyjPxVHtLQ57zO3xlyq1RfrsXZ+0K54G6UU4Q/HD4G0JaFwDEjop6in0n5Osq1RytIrSm9Ux0ybH07RvPWXtzFc08Yjv8PLZuUcFMbDEA/sPNUZpMWC7o2aXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RT1SSdeIF9kQkZMAcKoBd0q6WQmmPZDfuxknV7Mxc8=;
 b=k8kaa4IIdVmYVnEZgNITvIlumkiu/FC8yhE3etSTKiOYAkSRBNYXQhdwP6MqBAz4QwvI346cMeLJT4fOjI5xWgXLWy1SM4JJOVea2eTW7cuEvs/Zyxs5+YM0hgZRQKu2pFX1pW8RVZS4ZyppA2T05Q/j+rm466tfpuvCx3kza0sksyotnAu3q2SEUzbFRE9I0SLC6n8sgDDyODuo27N+YptbHTbkswq3SdKajmP+WO1LIEVlPsED0+ipsVe7c8jiolX4W3rG7xJEMyFbZ8BxPJa2q/2rWtNwmKq7NP/h+7LY9AfkIOF9YlowEIVauyuTMFchqqfNnKQ45upG4t4uQA==
Received: from DM5PR15CA0065.namprd15.prod.outlook.com (2603:10b6:3:ae::27) by
 CH2PR12MB4972.namprd12.prod.outlook.com (2603:10b6:610:69::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.24; Fri, 11 Mar 2022 17:38:27 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ae:cafe::f7) by DM5PR15CA0065.outlook.office365.com
 (2603:10b6:3:ae::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24 via Frontend
 Transport; Fri, 11 Mar 2022 17:38:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 17:38:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 17:38:25 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 11 Mar
 2022 09:38:23 -0800
References: <cover.1646928340.git.petrm@nvidia.com>
 <288b325ace94f327b3d3149e2ee61c3d43cf6870.1646928340.git.petrm@nvidia.com>
 <20220310211301.477e323c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87y21g96de.fsf@nvidia.com>
 <20220311080631.7e679bea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220311080743.50447d96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/3] netdevsim: Introduce support for L3
 offload xstats
Date:   Fri, 11 Mar 2022 18:31:57 +0100
In-Reply-To: <20220311080743.50447d96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <87pmms8k4y.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae48ffe8-9862-423f-3944-08da0385f323
X-MS-TrafficTypeDiagnostic: CH2PR12MB4972:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB497261EA8741552BFED19E51D60C9@CH2PR12MB4972.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qa4Kb8F0h3bUavH9mCYbc0XcYZzHmObJGZON2AgN+JQ2D8qIfAQ3TvJHJENid/n7CnfRbLZg65FwyBVKAnFeGmGTqHDm+RSBc4OVclFBpBxCCdNsOQytY2WcAXxs8UmWNkayIaQ9wGCS5neOa8JdI1Yor4V2tkBdQGG4022Af6wqT5wmwbo4vdZW12t9STaKXvYtYraLyt1WecppNDmV/18LKEFTwbToSoM6MIV04gU22Io94zUFm2/slLXbjT0gZxwi0v/iCFKv9G5CSIfH95Pwbcx9+BuSApjopKaUBYNTFzdCd8Ygbrq+VM8oAip+0es0GY1ICPnEBoz0JZSuADRhwdEYjclEnG2WKgG83itnIeNAYRM8HQ97TTm/GfgaOQ1+J5J+pPM4i2PDMh0O2zaGZw+zSXpY5J8D5uwJg59vkc1pgwlpYE0PnjNj61TJyUvwfIu7f7ZlufwKHqdasXE94mvRZtAx6qgMrzsqeiGu6Ivn3ZXVm4j40zeaWj+jIonpnMw5H2goqZ11Mnny0s+T8B51MdefZraHXFHmc/dgmIqsFqRVbTt8o4a7t2zKzDs+zIjnf+uv0hE33ZJWrcUrbAOQEqyh0vib2CswZwdENiTjlQ9G+5cgIiDfvAdz2rMzNksnZBvxFi88xJok9J9uEt/lnDUEXqWPu+74eNwp/EP160FRuBVB3dVcpvSYw4NLNFV1JWn4+BCA7N22CQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(356005)(70586007)(70206006)(8676002)(81166007)(316002)(6916009)(82310400004)(5660300002)(8936002)(4326008)(107886003)(4744005)(86362001)(2906002)(54906003)(47076005)(336012)(186003)(426003)(26005)(2616005)(40460700003)(16526019)(36860700001)(508600001)(36756003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 17:38:26.9802
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae48ffe8-9862-423f-3944-08da0385f323
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4972
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 11 Mar 2022 08:06:31 -0800 Jakub Kicinski wrote:
>> I'm okay with your version if you prefer, but the above works, right?
>> Or am I missing something?

I think it would. I mostly wanted to avoid comparing the pointers,
expressing this using an enum feels cleaner.

> Ah, you only have one fops now, I should have read the patch more
> carefully. Yup, that's also good.

Actually no, you do need one fops instance per file. But the fops
themselves point to the same functions each time, so I can have one
"generic" fops struct and just copy it to each instance.
