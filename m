Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C3D671AFE
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjARLot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjARLoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:44:00 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B446F689F1;
        Wed, 18 Jan 2023 03:02:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJPZLzcXIiAZs4NiVpZ4SWB19cuSoy+pakzSdue+NLUCZw9y07WdfIcQE+7CuMkSgPa8Qtn91pepjudybGM1k1AiXTHK1v9KYdYcsTNNyJ1Nfxk1soBm8QRCLwxWBYjgKKe0egy7y4afT42snjzL5ErI9gVVvlWXnc/rn3fYEwWKOKW/IfrkDVosoZX+/mtYVVPQBHrb4qiIZuJcq6wQZZl4cqRLhl15NyDOtRrq8reIVnQ+P2BnvUsTcYRG4HgRwfZq0B5i17VjN0KfBO/+miJQwD/mojkJTfMBfKssqKHixLSGuP0Sk2MZFA7oW715zsHOqqXZhyhffNlf0IPGxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZ+M9NI3EiQOUqNpEIyY+5Ua9bIbRzz+tMNxtj9AaIE=;
 b=bbK4dsmBbu1s+ySmZCZbZBAjEJx/vk0U4iNO16xTLOOpNNMRgl0tO3LN8ZqXimtOEP4oz0VMdyah6AxKnlbnV4CRXhOwkIWF4afIRc6yu79XzrOM6p13W4AXJ3TWfFbI7WvLnXpeez15zxW3KottZEJVBHhe1EjvLh6XsFi4lezOY/6D1dEI62vgSjqSDxvj6pMT6KfchHPmGfF6IiHxnIiM8K25My/vyEwySS8crpT0y5wEKGJ7PwaMibw8efeOOoXHVS4WDNRU+ifQ8+T50NklxTOUomKGFycvMilui9bi/DfX43Ogq2kEdzI/bFScZ6eD13c4GSi4GkiVUv3kKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZ+M9NI3EiQOUqNpEIyY+5Ua9bIbRzz+tMNxtj9AaIE=;
 b=pmFdzBaRvIIq71siqxS9zOiPfekNDTaUgWUDF/AFDT+GwFuDz/nkSoB7O17y6f891CwTDNq3MT9Rmq2Twmu6+6kM5mV0z0HLMp+h1hLzQJEr7mQ+hoQbuypPpXRtZy98g19yZ8j5/RU+7yw1b/RwTd2JLQD2kOOcyl1ucg8xhzvhbWSG4Y0/r3b8R8qWS3CG+m+6+Vbumz0gw7CokPooBy8JC6AtxFnpM1n5eVucWL2nB499kiUFefM1NOZeOOpN6OfT/YS7n1EHx4R2koi2w1VJNs2YGpXfKCOEL64vIF0H+fL5WGbGVlAmlbJSU2HlK4TTfR/wyLiJb1Gn4uKhYA==
Received: from BN8PR15CA0060.namprd15.prod.outlook.com (2603:10b6:408:80::37)
 by IA1PR12MB8238.namprd12.prod.outlook.com (2603:10b6:208:3f9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 11:02:25 +0000
Received: from BN8NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::d9) by BN8PR15CA0060.outlook.office365.com
 (2603:10b6:408:80::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Wed, 18 Jan 2023 11:02:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT103.mail.protection.outlook.com (10.13.176.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Wed, 18 Jan 2023 11:02:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 03:02:13 -0800
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 18 Jan
 2023 03:02:07 -0800
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
 <20230116144853.2446315-3-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <petrm@nvidia.com>,
        <vladimir.oltean@nxp.com>, <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/6] net: dcb: add new common function for
 set/del of app/rewr entries
Date:   Wed, 18 Jan 2023 11:26:53 +0100
In-Reply-To: <20230116144853.2446315-3-daniel.machon@microchip.com>
Message-ID: <87cz7cw1g5.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT103:EE_|IA1PR12MB8238:EE_
X-MS-Office365-Filtering-Correlation-Id: eb8db185-a5bc-4207-3882-08daf9437b18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MOZN6L9J9R+/VjCCbStOBZFvGUHK4oTrLPV+Lu6caxPn4WOMsPA810JfvrPbDYM2C/EpK1F+M52SZa8hjWbYWl2dUNLAw+5oN2nIeSQPD6FJp5EfWxornWnbJ24OdVwJDYBUe3yxAJB3+73C5tb/dxBYg4JHppeJgsVOZZcj9T3RLzP8Sm4vlhSC+/jkRAheDZ2TICTyoMXeBhmfd61D4+DjvlrV5jk3ro5nDjsShMHzq/somBD172u0owAWnmWIcHV8xYFZBm5h8YUUDLpFRy/lFeM5iMOYpXSNZy/WxFHz4PgCFlDS+KHZ5bE0MlezC+pXyYcGCQo2jXv3MnshcN2HegBWhuVq4eW53o8bSx74sC0ZXE2A9l8klpfp8uFZKYBBPE7hNMKeez5Z9hvNfDcf9iAhU/jh7sWbDR7SCU1B+Up7tAN/0N9y4nk6IiAM+cycSpJ1riyCxGXb+kSVb+KNYKtwJq4+ZZWZZfG7vK7ZS3u5OQts6busSOq+yZLhAjnQwEZ5wxYVElE56VjwZhcGBJN6kXF5fE2KofFawIcUVHOyXd2CJBhgHAtpYuHiNLIYMHY4S8s1yuardfLJonh6sc+MJwP1uBeindmorzp7/1CRiIYxZY0YYb/gjzB2/p5FbqUb3IyJRN7/9Jc5q1PU+Iy+5rkjQnraOlPhzEChSUhp6yCJUIrD3p5KbA2L6cIx2IeVpi+ch2GZOMq/hA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199015)(46966006)(36840700001)(40470700004)(6916009)(82310400005)(82740400003)(426003)(70586007)(41300700001)(2616005)(4326008)(70206006)(26005)(47076005)(186003)(8676002)(16526019)(36756003)(86362001)(36860700001)(336012)(5660300002)(8936002)(54906003)(6666004)(83380400001)(478600001)(316002)(7636003)(40480700001)(2906002)(7416002)(4744005)(40460700003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:02:24.7625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb8db185-a5bc-4207-3882-08daf9437b18
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8238
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> In preparation for DCB rewrite. Add a new function for setting and
> deleting both app and rewrite entries. Moving this into a separate
> function reduces duplicate code, as both type of entries requires the
> same set of checks. The function will now iterate through a configurable
> nested attribute (app or rewrite attr), validate each attribute and call
> the appropriate set- or delete function.
>
> Note that this function always checks for nla_len(attr_itr) <
> sizeof(struct dcb_app), which was only done in dcbnl_ieee_set and not in
> dcbnl_ieee_del prior to this patch. This means, that any userspace tool
> that used to shove in data < sizeof(struct dcb_app) would now receive
> -ERANGE.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <petrm@nvidia.com>
