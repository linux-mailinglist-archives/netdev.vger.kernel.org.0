Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F1833B357
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 14:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhCONKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 09:10:37 -0400
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:45024
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229900AbhCONK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 09:10:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxeznuKnUXX7cf8R8ypPAutKdRpURCwBTXm5JKlpiozQAVaSzBJk01oLjRZ7DA8Mi/lmRg/cI0rJrtuAl4Y/QwIFnGupdnRhNR66wUbpqhB4rWXEQTND8bfahe6RZF48IwzIa7NgZQdCVvWYFiJsesKEF6FB2yAT0fD0k4aaQWajqNLQZvYkoYnqh4l1rdi3WnAZmoIp79+882DA6SAKd5vfYzIXVlPV+UAtwGPZ16QvtoT7AAUL+kM72VAqdnr7EfQPpQA8Sce8V1QlOdcedtKx8djG7noUoVjWD09iOLxDgDIYPoBEtJtnuXI2954WpzFV8jJiAPL76H8d/BisFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBlL/F+dh/0fjmqADXwQuhnlAbar7jBdJRaOL9rNi5E=;
 b=E4r1ojdX7TNWRQwUstmu56UjGbPBHRJ0U5p+2xGxH2FtoNabx4uRaYXDPFAa/Wa7ga1HGw3kRh1a51GUDfMF6riv2BO+54MAT935SFeCjoXgFed0qfuS8qONVfGzYY9IPhGm05ad+2KbNwZS2p2CWt1lrHrrAueTAG5zQMoMEohbJtgmC+l6VAptTj9qz41Lrn66Zp2fVkD5yxLF+0tZbMUiBSritZyEpOKSu/PAeEAfb3Vab64sZrr7krmmopE91xQOo7uTmFRmGVDeCw6Ugy3d6hk/imYVrnfD+XcRLVaxm6WcpYWh9VE9Ea3DLuAXmx8NkW/ITBJ+b+1EKzSRjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBlL/F+dh/0fjmqADXwQuhnlAbar7jBdJRaOL9rNi5E=;
 b=GAbg5raIBnCIQnOwqtRGAUdjz8QnTwTlS9CHJG2bCZco/FAVuLku2Pd3jVrYFGfO2YlUOFVB1R2nsHRZF7HOYSVh4Su4BomNCrJCBl5sCZ1R+F2o5jxZ+oPaSieRLVJVaIcY57Zxb6hmob6WIduE6FpX8+F4IYIgXAIicu75zwyVtteeyUR4NWYSZz0wbUrE36W9qivVLeuo2+K0EHnXUnujD9RwnGczr2XCavInbE7KVp5ff81mI5RkBhipnDUeI7nGy09+yHBIr6qj0IV49D9s62IV2lCElN/rHpsjMtvsqTnFJl/dmtBw3p55y2dVerJYrjDcfPRjzCfdtgeOpg==
Received: from BN7PR06CA0054.namprd06.prod.outlook.com (2603:10b6:408:34::31)
 by SA0PR12MB4478.namprd12.prod.outlook.com (2603:10b6:806:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Mon, 15 Mar
 2021 13:10:26 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::a) by BN7PR06CA0054.outlook.office365.com
 (2603:10b6:408:34::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Mon, 15 Mar 2021 13:10:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 13:10:26 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar 2021 13:10:15
 +0000
References: <20210222121030.2109-1-roid@nvidia.com> <875z2kl1yt.fsf@nvidia.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v2] dcb: Fix compilation warning about
 reallocarray
In-Reply-To: <875z2kl1yt.fsf@nvidia.com>
Date:   Mon, 15 Mar 2021 14:10:12 +0100
Message-ID: <87v99sh8az.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1b10816-5562-4ae4-24fe-08d8e7b3b339
X-MS-TrafficTypeDiagnostic: SA0PR12MB4478:
X-Microsoft-Antispam-PRVS: <SA0PR12MB44784298D39F8E5EC124CEE5D66C9@SA0PR12MB4478.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fmV/+dw7L3R/SGjujVibzR1c3vBVEOwqt48L0wenbyVTBgRuYj3+Ri4P2MrQ0CFGfvWDWB9aV+Lr20ZsUFa9X+lyPTJxsrOUWp+SOww5s2iSBW5sQIj/dlEf3f1KkSCihMLqWRFFJmW4T+7mK5oy1lSE6vo1x9UxSFdwyWEDSa4hwWGDzX9VZK8H4ezK+wD1BbgQwm3ZsyTxx87ml+VVLUUmwj+yhmNOQlKfRf2lwCfc3q9LxBFYdnAihCfmo7hQuaH4J3qXnU3wj2oQy5KrZxfdnjizv99mUdMdE0RIYRg57EUWJGMSspRbRc5TZWy/C76MsGAwfkAA2yeQdonDW9vJyv9MCcd27toDnmYky3p8Qn+U9lOMFwpri20tA8ZXOhQ0QpbwqCNW5v1tJz59UV47OT2wOCCQ+frUEQJVXEerIltXawI0Neprr0BqNyL5PWa3Lz7MyyIp0MC9I1IjQLGxu8hCtm/lPela8jzm+9WPmjjqxQ3oKn0NI7jEwLalbWKCtIBw1OY1MgBFxENRBNo6dFKoetVo+RvIJrI0SlgBUv8dPDz+WBF8diGUlhe9ujbsE1ZBAj5UdaiQSt9uP8xLnkefNpNADHmbUuGAyXSjq4HMvwg1FDh4NSIBEPW/Hce21fHmi2k9pw+9Y3atwBu/pbiENmeWtrDryfTVAM+bl/2F43WGiagmDlL5oCMr
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(46966006)(36840700001)(356005)(4326008)(186003)(6862004)(8936002)(26005)(36860700001)(36756003)(2616005)(16526019)(4744005)(82740400003)(6200100001)(6666004)(316002)(36906005)(70206006)(7636003)(2906002)(47076005)(82310400003)(34020700004)(8676002)(336012)(5660300002)(478600001)(426003)(86362001)(54906003)(70586007)(37006003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 13:10:26.3265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b10816-5562-4ae4-24fe-08d8e7b3b339
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4478
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> Roi Dayan <roid@nvidia.com> writes:
>
>> --- a/dcb/dcb_app.c
>> +++ b/dcb/dcb_app.c
>> @@ -65,8 +65,7 @@ static void dcb_app_table_fini(struct dcb_app_table *tab)
>>  
>>  static int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
>>  {
>> -	struct dcb_app *apps = reallocarray(tab->apps, tab->n_apps + 1,
>> -					    sizeof(*tab->apps));
>> +	struct dcb_app *apps = realloc(tab->apps, (tab->n_apps + 1) * sizeof(*tab->apps));
>
> Reviewed-by: Petr Machata <petrm@nvidia.com>

Could this be merged, please?
