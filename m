Return-Path: <netdev+bounces-10726-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5CF72FFDB
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 15:21:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC4E31C20D09
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:21:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C22AFAD41;
	Wed, 14 Jun 2023 13:21:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59EAAD31
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 13:21:49 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::61a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4368D191
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 06:21:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZA4X5X5vrTx1Pd/dUfqazhmFHhS6VBPTvJnS9tgPJO/GAaSA1QRby1zsyNAj4AIeQ64+/0pqz5vr/nbGO2ojAtmS7LtLjYw/KIYJYlNA/h8yUABxPNFMTcTom9MksVgJOgR8v6kIbQLE+5vNXcAU4A49fYW/RHwU8GSZEa4W2sv7P/HE2yTQJ8KRWybTdjlCmLqr9i5I6deh6tZNwLMFf4m3vYhHbAkvXzGaARs/EVfCee+uszx0B5O2KOCfz7ww5JNACIn7En+/xDNvVf7Ytjomtg8kiiYSdVWwJD5/jv1Ebc+VLX4xZyaqLFnKJiRq8k0PvKtSHPG+dWqnP1Z0YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lW3zFoz6oQLPh9abFH4Hj9IusCIeX7H8caFeoJJ9260=;
 b=Hh6u6XuBHRIrwVAkrTA/APV+jhhDpWgfu2YJAHGazd2uZM161UmFmoKOrsWON/R3ACPJAGF+Ji0kCFJ/KA+526nO6mDVq9nwlnPFxT8lRjB2pe27GFY8+OJ7vhEh2rCp4ha0EofQm+SFXQHZLYDDECN2caYGrIoHg0eZDi1QN7qhSjfUSMEn8UGAYj2y7aOjzQ5MXkIAxOeyykWAbf/vJ4cN5UBRn3F1kMDUaCk2YoUWlAYiuVbtG1OyLTFuJQhpeYwRrAz8PhYlLX5yFm9JkqsBpRx/B7+iWNs3tM+4yi2beuqU843dr1PtAqywdL2VABt9NSeQ6r5CXII4GFgBZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lW3zFoz6oQLPh9abFH4Hj9IusCIeX7H8caFeoJJ9260=;
 b=ktpXCRaJpt3cZQl2sj3cng+9+TX3s2HwlOmYHlObNNnFoekx0mrc1w9oA3GeNYj15qmLCS6fUNlXhzVaQ4IGUme9E+hwOFYbVZLIVeKJjKEKyVtn4h93FmBoLEYsdqHfZtnLlKNcNMNxPAHE7ZzsELEmMe9qngAAGEfrvCmXHouq3FzQxhuUC1p+LWemBSUvIaDRzFPu0Vqw1E7mPBsUAL7aAzCDH5e+noQ0t1gWrlrK3N+9pY7/l8c004PxMMvPOwdAN0FebiXPGr5FTyl8FxuCiZwax93R5qGwhHWO2d75lglafq3nOkxVVrKfo+bNn1uIciQR0RjCphhKWHlV3A==
Received: from DS7PR03CA0255.namprd03.prod.outlook.com (2603:10b6:5:3b3::20)
 by BL1PR12MB5029.namprd12.prod.outlook.com (2603:10b6:208:31d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 13:21:45 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:5:3b3:cafe::62) by DS7PR03CA0255.outlook.office365.com
 (2603:10b6:5:3b3::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37 via Frontend
 Transport; Wed, 14 Jun 2023 13:21:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.25 via Frontend Transport; Wed, 14 Jun 2023 13:21:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 14 Jun 2023
 06:21:34 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 14 Jun
 2023 06:21:31 -0700
References: <cover.1686581444.git.petrm@nvidia.com>
 <7397c89078f4736857e9f8cbcf41f9b361960cf9.1686581444.git.petrm@nvidia.com>
 <4c056da27c19d95ffeaba5acf1427ecadfc3f94c.camel@redhat.com>
User-agent: mu4e 1.6.6; emacs 28.2
From: Petr Machata <petrm@nvidia.com>
To: Paolo Abeni <pabeni@redhat.com>
CC: Petr Machata <petrm@nvidia.com>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	<netdev@vger.kernel.org>, Ido Schimmel <idosch@nvidia.com>, Amit Cohen
	<amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 04/10] mlxsw: spectrum_router: Access rif->dev
 from params in mlxsw_sp_rif_create()
Date: Wed, 14 Jun 2023 15:13:39 +0200
In-Reply-To: <4c056da27c19d95ffeaba5acf1427ecadfc3f94c.camel@redhat.com>
Message-ID: <87sfau9o2u.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|BL1PR12MB5029:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e90f07c-6166-446f-f05b-08db6cda4cfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tZniBvZXNL1r2NddOQXFV8wOdLtcTFx/2q9nV/l1yLPoQ01NoHxnpkXZM00F5lxEcuP6xcD8Pm9iVGFiNrVhnyaDgIGfNz0ytp5JyV4Q5aYNVUdRJpQjBQ9X6gQSoRs5BbTGX+MooKfbATxlA7RBFb2ioZza2mJF5uZ5RJsILajffS8l/GGrLZNa3r9l76ICFJFny7X6HdbgANAo1EtSgvfGZQarXZAyFWgAV4hTQ9SS7D6ZTOEX50x5O9MGkEOA9Xl8qPhDIV5ImEsoRY77qDiK54yowoHXFNyQF+LvsW4nMKlECx1HLYcYp6ADcmoreqLGbb1rlzamVEEpaVd0yld+zNSFsfjmmDYSTAIpQTVBqGPRA9tYthHU2FNRH/kXO44qoi+65jfbWQUcdan1NwHSFXY7z/g2WaverG7z/+mTyXK7uFK1nANyW+qYwY3KBOxUW++gFR8yVw3wMJNl8Ze2iWYM+bTqILG11ubswnujYjBG39b2/f1F79NSGoGZMy+YGt6UEEyHb74Tt9Jr3udQxze0ombYy0/flcGFqkD/c97xadjVIQparoSTBS1wsOSPoY+N915lggxHdMPsD889vDGYnFvCXBGhJRc1Kyot6WrE3qMbjrjD8AgNGehjnIVVCsnUK53MqE31ot2vyVMcPwSjY4TthteL+jCGBhEhcal/rGyHz6VqUVI78+K02QUpMH7K3KICv2r+t6zER2aL7XUodJC9QC6nZm16GIFQ75zvn6rxkKCDrK+OwypZ
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199021)(36840700001)(40470700004)(46966006)(5660300002)(426003)(186003)(336012)(40480700001)(2906002)(47076005)(2616005)(16526019)(107886003)(41300700001)(36860700001)(8936002)(26005)(40460700003)(8676002)(316002)(54906003)(82740400003)(36756003)(478600001)(356005)(7636003)(82310400005)(86362001)(4326008)(70586007)(70206006)(6916009)(558084003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 13:21:45.2344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e90f07c-6166-446f-f05b-08db6cda4cfd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5029
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Paolo Abeni <pabeni@redhat.com> writes:

> Side note: since you are touching this, and dev_{put,hold} are now
> deprecated in favour of the tracker-enabled variants netdev_{put,hold},
> what about a follow-up introducing the usage of the latter helpers?

Yeah, we should do that. I'll look into it.

