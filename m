Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCFA5F2C94
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 10:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiJCI5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 04:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbiJCI5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 04:57:02 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6275126483;
        Mon,  3 Oct 2022 01:41:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeulDWsvMKf8Ff/UE47AQ5AqR1xb2uFh9OJgL+IQXePBT8ICvutGqh8QamsZPSyIPSs2ODaC073iW+igKYzvNYKbnJ8L4vxeu/o0aLH8+l932QClJAu98qkOKjftyHmS2TeiXYBID+ZhECNI87ttbTRL0ri5OueiMK6g7eG/MgUm6eKRqNiD05FfxeA+DKdu2DZL3mxEqIF0yprljLDCn5yx0Se3HjUIRcryst8uskfsjT2gFWO3JLEWQsK3ozmZq5UzxfQbVDeF3l3hADh4z6nS/qQHLn+MHnMjb/jZahlREOy8taariBMOPeYkPyesb6+RDOYJugd63UXFkT9SsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urRP+qVe11K+mAOfwKhVf/CAFRFCG37qfXYLWFPLLvs=;
 b=XTyCvLv9/8pqV3KetKLxU3bI8pKlxMcgqcrT/cRzaXWaFjFjHbcJ3L19sBycyUJIgScDqPUyYQWUACb+94Ddk7HjaQOloyttoIk/IMSYCMduQN8JWDe37HDixrZ3LQhcpLRid2q9uty71KiCIg7tT5wiRypRD5EDFNV4OhrwoAepJOPHBfgOuAqu2uwEg6+lrPr+8GJoaCMO9C7sF1pnE76bNs//+9gy3Fm7VmQ5Bh+1Jcp4RoTNgL+66cxX8dCpisKIrQzOpYAYlz9+czBRRCkooHLOZ4zQp4qSQTGYUlX1vSybhLIxF42O3nk20pUFCiigp+FCKEv/z26nBrIeXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urRP+qVe11K+mAOfwKhVf/CAFRFCG37qfXYLWFPLLvs=;
 b=VNMtBtlcfau8bJHH64PYaHWVn7HTA8u+vl45zh56qOeov1wGOAXOCSRpueYrD1PLuqPksJVvkLeUnylcAAYK3G9Brdmg/JVRKCzgbD3bOBL7lM8d4utNRvIjGhPM11zJQZJ9DyEKBa3111n16/7e4LR/RFlxlsZsMbfwKalVGZIYluVzZkZd8/zfsM/9oTPxEWPwfseEt+0qCSbVplOWwdQ1BdCji0dcqHodeJjkE4GoW70oxp/rXH7WXUhbOCHyNdnUNU7DJ2bPpZUprElLfS+V+63n7cGtg5wsM2Q4H7w7ryLyrZzvnw3jijrdx/zp0VhA5815KLJg6/kkwIbmFg==
Received: from BN9PR03CA0373.namprd03.prod.outlook.com (2603:10b6:408:f7::18)
 by DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Mon, 3 Oct
 2022 08:41:40 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::cf) by BN9PR03CA0373.outlook.office365.com
 (2603:10b6:408:f7::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20 via Frontend
 Transport; Mon, 3 Oct 2022 08:41:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Mon, 3 Oct 2022 08:41:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 3 Oct 2022
 01:41:24 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 3 Oct 2022
 01:41:19 -0700
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
 <20220929185207.2183473-2-daniel.machon@microchip.com>
 <87leq1uiyc.fsf@nvidia.com> <YzqH/zuzvh35PVvF@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <maxime.chevallier@bootlin.com>,
        <thomas.petazzoni@bootlin.com>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Date:   Mon, 3 Oct 2022 10:22:48 +0200
In-Reply-To: <YzqH/zuzvh35PVvF@DEN-LT-70577>
Message-ID: <87czb9xpsi.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT032:EE_|DM4PR12MB7767:EE_
X-MS-Office365-Filtering-Correlation-Id: a034a1b6-659d-4ecc-b737-08daa51b1787
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: beEsv89jgrIdVU8rQfslo6NPQo1OpcYi/D2Uj4aIq4AyhP28RKcAOEPie8sL3FnfS8VkpXdnfV4u31YR+0LBWW2YjgCzDsawUUoCK5+p60lEYbGsK+E8+x13nNHyTQpcKAnm8R753drQZFLuRlqPfbah2T9kif4F6HM0fuNCU3biYUGLY+QCev2ljXqu/3iJPlFLt1HSgsfWGR26RU0E953uZsE0jnOtRMvDqsL+ojWDr/SofsKBO/M7cDsiOWd8VOlY69HewfsQtb7cM//qJ5oZZzmhKKurVnDBEkzJjECotgTl3byFWqHdoyeRWUJ/8buD6kPlBF1RQhp8z1XxKdRQl2Lf/nVurou+szQY4HvgA8ySTfNK3z+xOCPyvAs+v5pbMiQb5Hcm2EneFxH+34nUu8yoBEJsLQKufNLFbVuYcPaAPWt2PaTCvCB/pPXkfWy3BqcSgkjPaBothKygDCstWu8yiO3NsLrH9A287LR2w/6Ehe1DnFOts4MvhY1JUUxXO4paMVpbm4/LVuVfPTksmkIeVXYwkJL29ggB1hsf6vtPE+Q6BgRMp5vYWXOtj6vJntVsWfBznzi42p6APnd2Qo33ZqS/JTaZtQqEm7Zw8KE8g6KFRYkJIJkMZYeU68lEEFTS2JIzXdCCFpCukxRqlhZdJF1jIECrcJWLVfMosG7ZMTAm965F6tpqT3aWWqHgx94jes044ajD8JWmsxd3Ww3CgSOATvzWdHfidc2qadQoKBuGaHs4LelRFlafU1pNvmC56XWex0aBGUCJ3A==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199015)(40470700004)(36840700001)(46966006)(26005)(6666004)(316002)(6916009)(40480700001)(54906003)(86362001)(478600001)(82740400003)(16526019)(40460700003)(2616005)(186003)(426003)(47076005)(36860700001)(336012)(2906002)(4326008)(356005)(41300700001)(82310400005)(5660300002)(70586007)(70206006)(8676002)(7636003)(36756003)(7416002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 08:41:40.1941
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a034a1b6-659d-4ecc-b737-08daa51b1787
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7767
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

> Right, I see your point. But. First thought; this starts to look a little
> hackish.

So it is. That's what poking backward compatible holes in an existing
API gets you. Look at modern C++ syntax for an extreme example :)

But read Jakub's email. It looks like we don't actually need to worry
about this.

> Looking through the 802.1Q-2018 std again, sel bits 0, 6 and 7 are 
> reserved (implicit for future standard implementation?). Do we know of
> any cases, where a new standard version would introduce new values beyond
> what was reserved in the first place for future use? I dont know myself.
>
> I am just trying to raise a question of whether using the std APP attr
> with a new high (255) selector, really could be preferred over this new
> non-std APP attr with new packed payload.

Yeah. We'll need to patch lldpad anyway. We can basically choose which
way we patch it. And BTW, using the too-short attribute payload of
course breaks it _as well_, because they don't do any payload size
validation.
