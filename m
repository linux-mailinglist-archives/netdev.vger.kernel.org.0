Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8485BD018
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 17:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiISPM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 11:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiISPM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 11:12:26 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1402F008
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 08:12:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMoke9GAXkTAuHdLL4cVTv6rdG5izM/u7SHLE2VW5kne4rdUs0kG/KMJiT/2tB5VtH5v0So8NPqczPbz6+0M7IRS9mncoGswjka2T1zqkocQbq45aIA0tgcq6Jmz61TBLwS8T+7Vhyn3J4GUQbCV/YgZuKG+P3hagDffXqlJF6S0SYNXiTJRv768qUOuFsMlWvn243TdBo6qOsFQT9DSJ2xaEfCjUBaiZ+xZj04rXx+7ZFQAE5921SlQl1AkhhDMl63+ALqygA4zu+bTxoLMfDf2j59SMsV7nHbqSx1piwcc9HOewx2g5WLr7s0I21WY7emxnLepmJFnmI0B+MjuaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JRA/B8kd4FZBLa8P25DCnp4LOPV8ita+jhUiIcd1X4s=;
 b=MVweXtMSMpUpT49VVyUofPmWNZxcLbGZFpmCZoQgCaEsPF5d2q6cMT+lR26yOp3qGzDA2SVCbYlTiMMSabCxKKFEC9/6SIcereF4wI07V3Yt6x76s1eZ+CX4cZdWPMqwEy3t5m8241d2UYInfvrbT0v33AORWNYk3KAETX/R4H3QjT1FuR4lh8Xoge1E4+/u0s+rHf3PTjkL3QOJGkia8u4hK5NCWRJP/RuUFpeS7oE364l/Wg2UcitlD1lmPQftMstR0m4N6p5FJ+wtu4PA+v6FX2dh6bV5DSZuqLmEtF+a3HdmBy66xbJlloZyyWyeyRQmlkT9sAAeprMMvQYqpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=bootlin.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRA/B8kd4FZBLa8P25DCnp4LOPV8ita+jhUiIcd1X4s=;
 b=p+HsMEI28AsWHQ87uXCbxcnl4PKw/Ui1DfHL9TBl11kN4HTbzoHza+ALYLBik308ven2PQ7UbMm3t/1Ek9mv4NEwBWKMGCIeAaOLNptisHCF8KINSGWi/lVhPctS7W9eok6GHHAa0kDe/5KbvjpXx5Pgwd0rTPpIMF++24E+Diw56pvVklrWtkbRtRyeuTKmFfNq+U3kz5d3mmjrvkAlFcY/RBvZAH7BiwpmN803QFJiYYhqx71xDkA39p2tNahpMHlqnYcDjizuQV+xlsPhyU+i56AqX/3AI3+xb+M0VlI67lKRbtqNlEKuX3S1dx+dsgTAhR8bi2Rh2fiCKA8u1Q==
Received: from BN0PR04CA0073.namprd04.prod.outlook.com (2603:10b6:408:ea::18)
 by BL1PR12MB5255.namprd12.prod.outlook.com (2603:10b6:208:315::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Mon, 19 Sep
 2022 15:12:23 +0000
Received: from BN8NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::5) by BN0PR04CA0073.outlook.office365.com
 (2603:10b6:408:ea::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21 via Frontend
 Transport; Mon, 19 Sep 2022 15:12:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT109.mail.protection.outlook.com (10.13.176.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Mon, 19 Sep 2022 15:12:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 19 Sep
 2022 08:12:08 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 19 Sep
 2022 08:12:05 -0700
References: <20220915095757.2861822-1-daniel.machon@microchip.com>
 <87illjyeui.fsf@nvidia.com> <Yygm/ZjoIc3yhPso@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <Allan.Nielsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH v2 net-next 0/2] Add PCP selector and new APPTRUST
 attribute
Date:   Mon, 19 Sep 2022 17:11:33 +0200
In-Reply-To: <Yygm/ZjoIc3yhPso@DEN-LT-70577>
Message-ID: <87a66vxut9.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT109:EE_|BL1PR12MB5255:EE_
X-MS-Office365-Filtering-Correlation-Id: d11ded4d-a3cf-400c-ada0-08da9a515ae5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JhDVpKSuAsp90cIf5TNSlNf6vgNnORMkAZRaz/X34nFWBOoklKp1CySdxtJbeigOVvJOqSKCKRS/DFteQARsiwbPrtqZyBywSC1zeE9y5QitDZST8gCrdzlVxCpmvgtQ01SViyNssPGfm6QbGj831Qhc6moWo7G80QbUnbOx3MlAXAgB+JsC7rPh/Wa4i679TAZ6yga/WdXqOeYxlsBvGCpvRwQiWI99aMO8rpTYS+bRESN1sFJgQadxHnXR2P50KKjjW2vql85v/Bps60wIwMFqw3/Mu4F7JN9YQeQdWvNVm+wB4eNrlOI3E8TZ/FY5aJjUHHQ9zBpPoXCL2xj6rF8cTr36KgnjpUT+HJMwDJF1Q2NFmvdNTSZ4ESVLFreiwkx8S+CKaB6Ijspv+20ERvsc5Dg5nU8fW6/CJgpf2LbsnLsEYnHPIptCHlTR0aFDaoCkULtyWCcvwxFBJD2JfD2mpAvfLt3UPhf8PPAbrnBPDI+1m/7jIAlNgNqhuwtClC/S+dvCRkvvdJ11MT3LbBGt250C9WbJOyH+MOkZOwqa1RK3imxiYwODBYT/z6PgIZLFeMdbhdNEZ1g2/FKnP5zL+cvg7K5pFzhQ3+mg0KpTRBGty8y1BiZQuA2kfWdKosVbGiAODXMUFiBswTfqGUiM2MvyCYYNQgL5x4DTFnw1SWbU5Fr5kY6q9OfELOd38uA6abSJ6yc+SUHgEWfBcKkwl8IWaL1NxScmDd40+0TxXwleiDKqaiSWojZWy5HG4TbiY8S+krK05huo+yluQA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199015)(46966006)(40470700004)(36840700001)(36860700001)(36756003)(86362001)(82740400003)(7636003)(40480700001)(356005)(6916009)(316002)(8676002)(40460700003)(54906003)(2906002)(4744005)(4326008)(5660300002)(41300700001)(8936002)(70206006)(70586007)(426003)(336012)(82310400005)(186003)(16526019)(6666004)(47076005)(2616005)(478600001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2022 15:12:23.2345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d11ded4d-a3cf-400c-ada0-08da9a515ae5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5255
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

> Den Mon, Sep 19, 2022 at 09:54:23AM +0200 skrev Petr Machata:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>> 
>> Thanks, this looks good to me overall, despite the several points
>> Vladimir and I raised. I think it would be good to send this as non-RFC.
>> 
>> Note that for the non-RFC version, an actual user of the interface needs
>> to be present as well. So one of the offloading drivers should be
>> adapted to make use of the APP_TRUST and the new PCP selector.
>> mlxsw would like to make use of both, but I don't know when I will have
>> time to implement that.
>
> Sounds good, and thanks for reviewing to you both.
> I will go ahead and add support for this in the sparx5 driver - most of it
> is already implemented during the tests anyway.
>
> Should the driver support be posted together with said non-RFC patch
> series?

Yes.
