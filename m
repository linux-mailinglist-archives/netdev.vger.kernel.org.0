Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0AF5BC3D7
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 10:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiISIAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 04:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiISIAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 04:00:08 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2081.outbound.protection.outlook.com [40.107.95.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7123864E2
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 00:59:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/keOf/0McoQLL1m/Yiy9ixrQbvgdyZZ32D6WD+IlqwuOwyiCIS9+Gq8wIZGEb+DdIwRDe9fAfpnBDNr8Xvgf7m0pS7lUU9BftZwG/W8jYiAmlu8Gd+7aHFOxF6ppeL4Fe4eD6EacwV3vxlaTwSKbpsmC6wTbGuYGYiSi689MjT7Jvq3gijpSJNfZ1oUg2KZ/zerYNoGKkuOYdI8qH6fjsZ87i/t2TavMRcRJkKLCKsVoEc5U3ieL/ckTa8wg2m8Pk4/sZK31gAzezLWmXsyExAj9ivhWe8E9q89hqGeTi4D6bEb7hE0D0k7uK1/2a/c80fPYgxQWOyp+jsDiThKcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UrSF4xFb9Tl0YgJWjemNa7Q2qEb8uW2nqKi62zEsQi4=;
 b=RtOfTM3I6eIlJblnmmB3DcDqaugfjmydNjSMQ6ldnrKJY+7Pfdz4JuXWxzZ085cBwNlP43J35wz2F0tSFp4rKvbleBPdR46Nk+vP7OhYqOtxphKtq0JeFmX/In/a8c/ajCwNyzeBDwOtXHTiTAWYS0gPbHngzt10tKmaILUAewZ2ahOpnLgzAJyjDM4VsyNw6rdG7UQmOmbvKr/TIq9fz00TPnPzUl2C08WuYdlE3nQR27mtegIpJ2dt516wiOij0RaP1I9zM4bGOya3r2zPicktUED6WbrtcKxZVzdIqTVBrDc0dDkYbVtYU+8ZEkLeL5PFUor9e60NvbQNAlob6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=bootlin.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrSF4xFb9Tl0YgJWjemNa7Q2qEb8uW2nqKi62zEsQi4=;
 b=kq4EsJ8pENcnX/Ss0W8s0OoiVm/nt+ejqZu+9DGW9UmC1YUspcJzqDHli3EcEbV2pePoCgAKOrR7SkIP7lNAh3nyDp3cXf3njmr44i6DuTmUIv63BqNpiBPLZW+U0LwDjTjD1mGaO2G50bCxT4YARn8yZqwqlmcEORuiDssKJ7uPmjl9bPiAiHSlUvQXPaOmrAKR/0fpxW1RcRpK64A09DQP0RWTV0gpZLD/hoMuEdlI1AYiwb+WlNiNHfVS9RO4dZN9SF17ZafJca5qTLIzDld+l9uktDjYvSegH6BQGrtYHKP9cHjPK89us0VKEL+7wJYbiebX0Hf3DalqKZp6Ng==
Received: from MW2PR2101CA0001.namprd21.prod.outlook.com (2603:10b6:302:1::14)
 by PH7PR12MB6586.namprd12.prod.outlook.com (2603:10b6:510:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Mon, 19 Sep
 2022 07:59:40 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::b3) by MW2PR2101CA0001.outlook.office365.com
 (2603:10b6:302:1::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.4 via Frontend
 Transport; Mon, 19 Sep 2022 07:59:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Mon, 19 Sep 2022 07:59:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 19 Sep
 2022 00:59:22 -0700
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 19 Sep
 2022 00:59:20 -0700
References: <20220915095757.2861822-1-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <Allan.Nielsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <petrm@nvidia.com>, <kuba@kernel.org>,
        <vinicius.gomes@intel.com>, <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH v2 net-next 0/2] Add PCP selector and new APPTRUST
 attribute
Date:   Mon, 19 Sep 2022 09:54:23 +0200
In-Reply-To: <20220915095757.2861822-1-daniel.machon@microchip.com>
Message-ID: <87illjyeui.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT007:EE_|PH7PR12MB6586:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b6dba2f-3f6a-4198-16b4-08da9a14e772
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D2CD7MymzfBW/BJGasAPNNbkmGJa1E1AUCh3oAT9qLSdi2CV6epRDaVIyviaWGp+xhyclDE1sTdYZA4GJos/MpuGb8a9Xii3ESSLXn7DxGNFl+jS0/T8O8FPhOpKDz39Ffr82pBj4kt4IeF9ZaAXlwErCxMObtbQVH5ii7p1rQ3vL9A/BLt/YQHl6w0BnmGykA5RKBwdhP+vUBDxFweN05JQQ+TJ5b962wp3krF9Y7Ubx1mlOuPhIzuBpIpCsN4lcApkJXTqS0KUXuo29epIOmgfjtAJO27FJn4cwsN4ylTsama3FQEoIajLrBicaWaPvcN4ZwXn0MnApG+nN3ndRgEyo/H9mAnseABddxgXbS6YDShfuj+2H98tKtf6c/fDfQyK6fEMrZP7V1X61R3Gre2WxPRIAivm2fn9snbvY8zuqVMp3lpmre6uFGqW58I/cB7tOx/jW3dTu5SIXf525Wyh4yOUUk9rBnI4DMeBm6vP852VfT3yUbHyQ5Xd++K08JA3RskjOXRBWKO/tovH7YhQbX8yogioQapVpqS2x9cEa3YCmVnoLQMHMAe4AiHuB/GLp0muLls16sCLNackqRn7LkfieoVWVQSnF0xqZyxbdiofga2mFvSAUwW87fvpoCtVRPHyMEM7+WZCq8X9WrFunsPckgs51WvruKeVX5xir3rrez1NjA289q77+wSLLxqHG8qV5Lh78EaDnI3FeeBhrrMTVZy7fudD9N4Xl/Gy3VVTw6rF41YjAzjFZlBOhygkXDgE09GJnlupakRdvg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199015)(40470700004)(36840700001)(46966006)(41300700001)(5660300002)(4744005)(8936002)(8676002)(36860700001)(2906002)(4326008)(70206006)(70586007)(6916009)(316002)(36756003)(82740400003)(2616005)(54906003)(7636003)(356005)(82310400005)(26005)(16526019)(86362001)(426003)(336012)(186003)(47076005)(478600001)(40480700001)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 07:59:39.7821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b6dba2f-3f6a-4198-16b4-08da9a14e772
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6586
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, this looks good to me overall, despite the several points
Vladimir and I raised. I think it would be good to send this as non-RFC.

Note that for the non-RFC version, an actual user of the interface needs
to be present as well. So one of the offloading drivers should be
adapted to make use of the APP_TRUST and the new PCP selector.
mlxsw would like to make use of both, but I don't know when I will have
time to implement that.
