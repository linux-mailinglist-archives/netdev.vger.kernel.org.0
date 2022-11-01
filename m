Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39832614C33
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 15:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiKAOFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 10:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiKAOFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 10:05:41 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772311A827;
        Tue,  1 Nov 2022 07:05:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVJBF4Z+djbcgBtZmsZDzUGJRWsF7AQKSXYBWsmtNJiWDpsTpE567JrDFts/Sc7Wduf/5deXMrVLjav5uKsfPJGER/PwOo3XwLngpyoTVxxAkMXdt7BWcgEJu2f2qeejLQx25q40MRz5n34CucFaioD1afN/Zv6QZTqQqqMykSI4y4xipROugrjSeB82UK8qkq1ivY7bq5qlsCxDvlz0oIARdQY3vtirt+xrVj9iRvF6i412hyDsDi90VGZT620w7jCECLorP/j/9vb+e4qfsQuCPAaejNPQj76hwvjX/1T0qp8xVJuRAz88+6QdOfEjnlgoDFACv13ZQhw4zHNM8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=URMbwXSwkWrENuVAUGFSBOV29W4YAQdqr+k6SQH0mT0=;
 b=VLbq55ExgdHlnDBtS4rIOQZK0a2sjXr4RnTUQh+LdAe8ytvRxwKVgfEXOOX+78AIbDZXbWS54fXMzExXf5Flrop1q8xkD8G3daGaVSfgl3Ggr56ItVzp2RSmrUAyZ3cMdyghrOSQU15jSSY0njFRYAC96sV0XOeGAyeG9F7ui+GDLthapfl/XqwF6vCfTkfYXJJf1UA4a/e2Hn2CmwogqEYHe8Q/lss+dC8lvd4PMRvVIoxD4f6tyBll9xW7YD7CLhlo6LzjXFahYkWHfaICOtjPBIqehs9TZKR7ZnchwpkqpauKkCokT50fRacD9hnUYPjQLhpUWCff6wqQSnLzsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URMbwXSwkWrENuVAUGFSBOV29W4YAQdqr+k6SQH0mT0=;
 b=K8XOMF+SjfqSVyxR/KMGOl6hFn46ZGA63CdwvlBlr2LDVMVaptit9It1VPttGX8uM1IBDtJWF+5l+Cx3ceTrJguDni6f/KupKLIZfj1mUGErXeOhQDisrqF49skhaAVkV9uAAoOfEQ9sjopwLc36t012OJGvtizXiB68/4sjfoPJtijsL8UCHJj00lGG92hFE6ekZPE1OIn3hU7x3C1i5Koxo+fhDmKwxnMUsqjt3Ixg5Xi87Bu6i0QJ6chADvD0YZju9NqHH2SKMEsJfdpNsUVDzOrDZ11Esqr8MZS7Wo0uQjFKAP1xf1JQkvdBsXqjbteZtiStUsSZDOnCXfrFWg==
Received: from BN9PR03CA0267.namprd03.prod.outlook.com (2603:10b6:408:ff::32)
 by LV2PR12MB6013.namprd12.prod.outlook.com (2603:10b6:408:171::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Tue, 1 Nov
 2022 14:05:37 +0000
Received: from BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::de) by BN9PR03CA0267.outlook.office365.com
 (2603:10b6:408:ff::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15 via Frontend
 Transport; Tue, 1 Nov 2022 14:05:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT057.mail.protection.outlook.com (10.13.177.49) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.14 via Frontend Transport; Tue, 1 Nov 2022 14:05:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 1 Nov 2022
 07:05:10 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 1 Nov 2022
 07:05:06 -0700
References: <20221101094834.2726202-1-daniel.machon@microchip.com>
 <20221101094834.2726202-3-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <petrm@nvidia.com>, <maxime.chevallier@bootlin.com>,
        <thomas.petazzoni@bootlin.com>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v6 2/6] net: dcb: add new apptrust attribute
Date:   Tue, 1 Nov 2022 15:04:51 +0100
In-Reply-To: <20221101094834.2726202-3-daniel.machon@microchip.com>
Message-ID: <87a65avkhb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT057:EE_|LV2PR12MB6013:EE_
X-MS-Office365-Filtering-Correlation-Id: f50c1984-4398-43a0-3f53-08dabc1226e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LZrHquvPk7+YvLb9xWfXN/lHeEPrpVoNnHKwL3F+WbYZv2GVtf1lICcjDakijvb1SxFKkwAlL9quiCMWSKCAj0aQMjAUXHvuLDf2e6hkTUKgQDyw5U/UpC3DkWv1shNF+Gr0f9K3ZYJTGwQJ2Nj2Fs4IKNVEBt2IyJh//67TVZwJNi+7Ttq0K0hMt7SPVWROV4FIGOxNeQ5a5s5X3gR83unPHhewn5WfYqPzal3HYAzqpSWJvPeRAVwaDGuwIQ96kifr/fUZY2UuVQi6yb/i54wn1hm8rFeNBrdyL/kzn2ZyAYza6ABNJZA2fbVZ1OUiZcNFSSIWzlXWpXpiolOmdYfRL43fXUbnf1Z8JTzAL6mNTNvcb0EwZZqhcZXjbnuI9NqmcJE+LWIt9kFf9MZWzDJmnt8BW15OfPDDJPy9M7595L8a3uatEF/91vBldmkRf3wlE55BAUjiw2w2LDM4U+CWDAoCU75N0cwZVYMQjjEXC9j8YjD9Kwn+Cwqg0fq5zkCOWSR4yqwazOJ05wOfn7qXEJMt9OoSgYlJIuL3D43rjD4W57pT0CRsrCMF95G0vTmelEhJgRpwm0UOM4nUto4vUJZ5kQvzA3M46hue+kKbQma9n0Ggc4IYBxzauU9h/RF3suRuKIOsUsXe5/6ykgwA5JheN77BTu8x4xHonfCWgkEYVsBh2epXOekQcVVFH9CD37/jZILGOr+ryEyZm1z43+9E+YQYIXpScjbkdxFPQcJddR8Tlfl6Tp5c4iqOp6WMLrLmQ4sngGsd4WKxLA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(8936002)(6916009)(36756003)(5660300002)(54906003)(41300700001)(316002)(478600001)(40460700003)(7416002)(86362001)(2906002)(4744005)(6666004)(47076005)(40480700001)(7636003)(36860700001)(82310400005)(82740400003)(26005)(426003)(336012)(356005)(2616005)(83380400001)(4326008)(16526019)(70586007)(70206006)(186003)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 14:05:37.2110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f50c1984-4398-43a0-3f53-08dabc1226e2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6013
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> Add new apptrust extension attributes to the 8021Qaz APP managed object.
>
> Two new attributes, DCB_ATTR_DCB_APP_TRUST_TABLE and
> DCB_ATTR_DCB_APP_TRUST, has been added. Trusted selectors are passed in
> the nested attribute DCB_ATTR_DCB_APP_TRUST, in order of precedence.
>
> The new attributes are meant to allow drivers, whose hw supports the
> notion of trust, to be able to set whether a particular app selector is
> trusted - and in which order.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
