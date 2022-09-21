Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FC15BFED3
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiIUNSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiIUNSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:18:01 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48368B2C6;
        Wed, 21 Sep 2022 06:17:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlUu2CmbBTquWlFjbDp1gVlDcVwC0iZbX9su7b4ON3vI9edZtIDN9SK3Z5WHMAWSCh+lE16VC4JYTKqdnbgqHbYWiCRUnQ0VR9+eJw2o3DoAmiDFT/Yp0D0dFNS1VRWW++uuZQRZchLXCwaS11oAAUFBnNYonq5i1GTh7zFBE/rtk8N5D3BHIY6S+gMFDfO+F4iSBBZdLbXR3wWX1U3IrvBYbMr68B8DDqR2JXg/h2GscFqHaJ9yAf1bDIaP192YGBjljmeojfIo6XilZ1JTqTnZsmRySzqYsb3XVwCHpxAQhCmYC2bIw+rwWH2CJ2Q5efnGZY1OQ1teKd7IjPyoQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vOfOEXYGdX5uY53CIqahw8hcTGyHWNgD2E56iH/Z3Gc=;
 b=It9Z/e0RIY2LG2AoEZg6oEfZ477eilHjNWHoPO4WniI8R87g0PMzpSZbfYJyIBffMnalMhBdt9IJIBPJ6PVoTGPhSs0OYZDjTQPgAitdXVAmMqsAfmFfu+XlElYNHyDD7dxzryptq1VduSCTpINT8uIxK55X9ChYasGgZ2/rZMrQimXPQTMeqXAECU5Kqj1LsuM//n0OVElJ+Og/5pYFLJZ4/znrjM4ByTMbz1evUxlBN9TNXgMmgIIpFlZW9bp/76qverfE0o33ZTRhScqNWoTaCtMSP91A6EeK3u4aOGEqHSks/5s1Zl08ECzcAGSc23hD4/XYZa1647f4Tf1lVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOfOEXYGdX5uY53CIqahw8hcTGyHWNgD2E56iH/Z3Gc=;
 b=mFlzvgIhxr3NsdXz6zxdsc6Du0O3+MEcwGrRzjRYAmE7cdhCN6YqJw55DmFab+eW2JlzMJ0usjUmun5BM7uN2d0MVx1ju+QlZSahd9DLtHRDV3JuC3O2jyqoqfCX0Lqevt1k8sRiIE4wny1aV5at0yI0JhqLSaIlwLlgewRY1Vyz0gEI58E+S8Y7aRUNR5yr5XlesuSNyL3uiEKzhBSVmA06KdMWnlcfgjmpffH0PT4djcQctDPD/DQrwdO0meRyikpOo4Gqkmzkx8UiTNCRQAxzN1CnPYkwYKg96KhHmSCWqz5rzOi12dCdKnt0vzaQUoBQiqoCrL4utTUVff9VaQ==
Received: from DM6PR11CA0010.namprd11.prod.outlook.com (2603:10b6:5:190::23)
 by MW4PR12MB6682.namprd12.prod.outlook.com (2603:10b6:303:1e3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Wed, 21 Sep
 2022 13:17:56 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::b4) by DM6PR11CA0010.outlook.office365.com
 (2603:10b6:5:190::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14 via Frontend
 Transport; Wed, 21 Sep 2022 13:17:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.14 via Frontend Transport; Wed, 21 Sep 2022 13:17:55 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 21 Sep
 2022 06:17:43 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 21 Sep
 2022 06:17:38 -0700
References: <20220921090455.752011-1-cuigaosheng1@huawei.com>
 <20220921090455.752011-2-cuigaosheng1@huawei.com>
 <875yhgyijv.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Gaosheng Cui <cuigaosheng1@huawei.com>, <idosch@nvidia.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <nbd@nbd.name>, <lorenzo@kernel.org>,
        <ryder.lee@mediatek.com>, <shayne.chen@mediatek.com>,
        <sean.wang@mediatek.com>, <kvalo@kernel.org>,
        <matthias.bgg@gmail.com>, <amcohen@nvidia.com>,
        <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 1/5] mlxsw: reg: Remove unused inline function
 mlxsw_reg_sftr2_pack()
Date:   Wed, 21 Sep 2022 15:17:21 +0200
In-Reply-To: <875yhgyijv.fsf@nvidia.com>
Message-ID: <871qs4yihc.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT066:EE_|MW4PR12MB6682:EE_
X-MS-Office365-Filtering-Correlation-Id: 49b3b975-8210-4a84-76df-08da9bd3b278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S6AB0g75PaQ59kr66LO2A9TQn155fDwE3lKmq8jvSp3l/dm9C8WW3SYeNgueRx3ybGR51ixvg5ld8Y3+sMrXkHj8r/qqjcWgykUDcRtlWQ9hFEO7lt84fVe9TtH30Iul6ZQixyfQnWwKAtZBueugkbD/OpQ361pdunZfg/50f2HLXLsg1NpI/GEBc6oYjCjUdw0Rn/0PlLMK8SsTLdpKPI8mm6dsY1XKDPL4KSQfJ6HyZG18gUcu1GX1ksEt1H2IDwEBsjj69KmlQasGfW4aAySSSmk2D8Diot9+5KXtwQPHh3tnT7lQgluRsLLCYvBJBM5qTzWBA9gKaj7Q2JmmCtz1eejsr70Ghmva7hq0FLYIU/8D+iaApgdxXM4bn0WJjBr7jNlPPHzj3yie4/qwRB4QIE89EExEBc7ODO4hDNZe1qZ+XDjPkYV/R78YTA0Sh1MR8stDiy/ezVz90gsi5ZkYei7XMGQFJ1IGRPpAK//XtmqarH8b78v/V2PzK4OR8SzWc9xusNbpTGNmbVsJuisaxWiobqjBSkh7KwXnztxRqFnRDm5leVte/ze4UIjQXp/6Iw5xA+sowFeNvGl51HGAuH/vroxuSDpz321lN8WJAGSp711vEFijpGMOejgsMGm0Q/77We3P7uWcQIRznbqeAQpIVKCzFQL6jtkvjcK/vceUyoij1W2kM7TaAQ6452E3EczQd0XQYDANw5nUJas8nffDBMyYJPlm1uoG5PDoftPGWZjyM9Iu2XKxZeMTW4yYXND3AOViQiBII9OOrQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199015)(36840700001)(40470700004)(46966006)(37006003)(2906002)(40480700001)(6200100001)(82310400005)(4744005)(6666004)(36756003)(86362001)(36860700001)(426003)(47076005)(82740400003)(7416002)(6862004)(5660300002)(70586007)(70206006)(8676002)(4326008)(316002)(8936002)(16526019)(336012)(356005)(186003)(7636003)(2616005)(478600001)(26005)(41300700001)(54906003)(40460700003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 13:17:55.9428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b3b975-8210-4a84-76df-08da9bd3b278
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6682
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> Gaosheng Cui <cuigaosheng1@huawei.com> writes:
>
>> All uses of mlxsw_reg_sftr2_pack() have
>> been removed since commit 77b7f83d5c25 ("mlxsw: Enable unified
>> bridge model"), so remove it.
>>
>> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
>
> Reviewed-by: Petr Machata <petrm@nvidia.com>

I missed Ido's reply.
