Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9F04CA9EF
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241181AbiCBQQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiCBQQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:16:01 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACF2CD316
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:15:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvvrYlSH/Fpus9J8e2harxDPX/pCuR/yrUeYRFkN/aCf8/5D6lyNDt6+td5wluiUf6nz2URXVCiiyAxxusg9yNEY7SD5ArDFo1cXyfJ3L8Oe03RDO/DMqQDdI6pGPYmCTsprV9CdgTbrwpDeZgNVKWUMfWReAtSD40GyBYDTd2/M3xRzIkgEAmoEmTxmwSW9R3Wy2u2NTUg+nmnJG7P2KMfTeoyxxL4gOCoeCjF1Ab+e4bPTqHDeyg7o+mlqs1BprNYoKQNU2y/7yV2CX+fGJgszcoj//9zPgdz7/oDrtCYnIX+Gtvtj/voeVOxU96DbiDOYKZm5GM3YIx+0B6WTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TCJQTxMWDXlQKgeaSI+U++Tsn2H9E/Q0ylHXoNgUfv4=;
 b=Jc7qjqLsiLmwkA396DMbrFQakAU3OXLk/Zc6DR9MWbZwCEIvqq0ngNydVdArLF0KbpAy5jzJt8TetoFEWgz0SxwkLaKx+resemK3Sbxvh0O3E8B51hWnXgs6+dAdK65ZgUmQ2dYGc1ez7JMavkwys1KmTAXgn9wokiyLHdg9+povd3A/RyZGfpOBNdenIulCWA9t24JL1r9jIJxbOl6wr6JTZ6bri5rVG37xv/Ta/sdw59Mcg0YKH5DZh/YGe4Imj0vdA2PlSxkXA63TYy2XQ2LEtuy/4ZrJLedsIMNVSViukwzcAXI14ug//BjLOPRyN2+sfuqU3781067fJue8EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCJQTxMWDXlQKgeaSI+U++Tsn2H9E/Q0ylHXoNgUfv4=;
 b=BhJNXv+vtR8jx+D3dOlulqb59nP6zNtoXyJq3LBPWU58+9rKURdnBfraZj48LmgoBdVQFeuLJfsNwK9DpzJGKjJmfyZErPsTj1W/mjCLPx15B6+mJQjdVxsfTmCXaDEM/E58U5zZtWKy94nPn9rW/h5cc+QQziFjYUbLw7lL/JlApHU934hqZ3sKUrIjdSUouV8tR5NfjSfWCMj4KCSFA3DTU2FVbW254Lm4mXaZPX9NVFvALD+1KFfWxjF0YWg2gRgajTTqaVXs1X24Ryws8i0GOZVkHvj5U/gp2GyOh34y5pDmT/D/fKHzHcCNx+zhi7nW6AoS3KfVvOzmfRpgLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM4PR12MB5136.namprd12.prod.outlook.com (2603:10b6:5:393::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 16:15:16 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:15:16 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 0/2] selftests: mlxsw: A couple of fixes
Date:   Wed,  2 Mar 2022 18:14:45 +0200
Message-Id: <20220302161447.217447-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0118.eurprd09.prod.outlook.com
 (2603:10a6:803:78::41) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e30f0c3-a181-4fe8-3c8e-08d9fc67d6a1
X-MS-TrafficTypeDiagnostic: DM4PR12MB5136:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5136037C3C5550634FF87DDCB2039@DM4PR12MB5136.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IHcObY0iCsQcCYaSe3pGH3lho75pPHCaYfrYd1nG3EyKdO7QUxOcoPtIzFiiB/X9/EVT+ej9zrwAkB3BRy0HRb+UwZjnIaj9Sknn3aF6KmVeWlbCXUjwuNx88qAZk0BsFx8qTZxLZK2W4YXGvixJIicfkuxoEYRKoSFJJwAcYWxVsguU75vQQ9qNrx5sEP4urqjDU7quQFsGKH8ctLK7fggL00nSLRv5EzmoU4DwqTXLviH5D9h+fVCy227pheksAnM3wb9sW6TMV1IHbjuwnVkLpD2zeUcBRfoNMO1Z+dauBlvgRFzUwPWBNwnx9W2KbQS43na3XjcknDx5N29f6+BSCbVlGNd/qipjzfJGbazb0UUOs71nVhEdlCSmUq4Ly1Qq7pEUYynqZlzKw5d8zqKsGkBWOrceL0O7jmbH8cH+tYUlkXEx4+7mX+GXTjmWn+8Y+QJi1O2GLAF26M0Im7zxtRFzjO+zW+evYx+sEavbJ4KSy6KQBuB1Vh5u4NffrGFR+6bZfDGwKmSiiuBPxcRmq/e1SNBg55gB62LCoizEE3a/eBXcphXxkk+R1mHPNL04NCK+6MnXmiNbIy6z7ygQtcw65bPaRHAbR3QvH+l1GWjgpDPaNTIYLb0QVrSkoUD8Tc4Cu1fwc+RQt9khGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(107886003)(6506007)(38100700002)(36756003)(6916009)(186003)(2906002)(6512007)(5660300002)(26005)(6666004)(8936002)(1076003)(2616005)(4744005)(316002)(508600001)(6486002)(4326008)(86362001)(8676002)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ab5aiNyVhkTXzbaUyOFuxCB7VujAtnYGBfLleqsS+VpgbHIFBSxEO7GdtL82?=
 =?us-ascii?Q?icLX/MEBntpun86Dyu7+KgXqaqjTIGxGsT29uEQtxDIpfCWVql1hso9wKADG?=
 =?us-ascii?Q?N5xgAi3+5Flab5RD/iugIa4HTnYecABtwpeI5tS0NZNQx5b6kx17TWHehYA3?=
 =?us-ascii?Q?9RPTEdWMiQriICxI6C3lt8vF5cBXmz4u7ZvtZ5Cz8NM03m5h0T5JDlAheSbC?=
 =?us-ascii?Q?RrLYQO3MUO9U3mQqP/X73toHbDYTjVbz5QJw6TfREQ4mWil71rVm8R89f+NS?=
 =?us-ascii?Q?7HxE50uyrxGygSZ+lCFMGuGNUbQUqyebbXfA83NqyzIAyORFFtOaqIiUt9KX?=
 =?us-ascii?Q?E9dhQhyorydB+jFQPQArbM+r4fY0w+K/6A0NP2AtkSBZbq6Hr8GEGi06z/wu?=
 =?us-ascii?Q?gr7F+CDgyN7LoJosM738w08kS0CB/jiXjWA6BgMNVtd0DLbdN7vHcmf8p1co?=
 =?us-ascii?Q?8r9kxIaq9tr5lb5aweEMJEKQOafxK49zyL52DFrA6x5AJw0xAfZtxlCTmD76?=
 =?us-ascii?Q?O1r8n7l5wHVHnjw8unL1Mr6a/MFMkCjgfLXSD84S5GnkqKsvIdHRMWMmUu18?=
 =?us-ascii?Q?OkvcR0xUDlP6CXNOEZgf2igQFYdgTY3e+Emqj/nV4q7qkjRbBTXya93kBMdI?=
 =?us-ascii?Q?F6TvfukHqXaivlV8YDD0r1llaTDXVf60CH+UGs6pzeUALD1iUdlmsXU9De9P?=
 =?us-ascii?Q?SB5KIxsB0vX1csFWjYntueAFbkikt0jreyPkyhS96l2gnTzCtxt4Ho1UBccL?=
 =?us-ascii?Q?ScfK2wcoh+bm2VzacG3rqYuK6lJApJk3Sgc6dI/dp+9YSFw0Y0iIG3SC6OkT?=
 =?us-ascii?Q?zL0zcTTtn7SaRNd5Etpy0Gn5Uw4qNSwBpsuOwGJYD8cus5H1rtgeIDJT8PXd?=
 =?us-ascii?Q?2Q/utthyrEwAWNZuZ3d2r9oFMtaQZZYkUtkczgy1gRCUSFV/qkdqKAFyQtlO?=
 =?us-ascii?Q?8oqeADHj+lzDzlbzsJKDzpmHwsg8efS17bc1ciEmJgfcsZVjUgS2fJ7GikwX?=
 =?us-ascii?Q?Nc1RtTm9Jg05VdtRceRYyG+neUTjiKE5TlM2Doqivn2pJnk4Ne9gI5HyHGuq?=
 =?us-ascii?Q?JaaNfo1oNBuq3xllKAoWQLgm4ECVVBUO/4yjl0wBoENOFl+zwctEDkwcSwkv?=
 =?us-ascii?Q?MjdjJmgQK2+9Rf7HdaiJSSasGBcEYztTKOmwdwWFfMCthuXW+GFq/x7T9PqB?=
 =?us-ascii?Q?1Akv9KgGfu7SvZEBabG0EwWBgcCy7aExb0cdwfA9w6Go+U0q9gK8EgkPpn0s?=
 =?us-ascii?Q?AyMnB8WbGVRxtJodWgfCE1g5ipxAjxubQoK/avyOAFkSBhOiFhHlvywADmOh?=
 =?us-ascii?Q?kEDqvP4SYS/hSx4Gsc6RZvTNoU/GFFIiiRSKX3/bGca4A1klqmWA8CdKpQAa?=
 =?us-ascii?Q?bvpjqG/xxfm0o0FADcvwv/nZ9e4f9CGIghwon44iQbdySZm/VgrXDx4ts9JB?=
 =?us-ascii?Q?gBfaeg84wK06L4r9c83/erYlJzVOE02vrtv3D4bAS7AodqMMFCUIigzoNuNF?=
 =?us-ascii?Q?tHyh5XLZB8ySErJESOBtiszmo8+8NLaGOeRCa6QImgfbHT83Fi/o04fyeGw6?=
 =?us-ascii?Q?Pt0Pn8ykRD5PoMQzEhC4dkN7JXb5iWSCDs1YNr2ArCnniEyNyXCdAvdFnDKs?=
 =?us-ascii?Q?6n89WqTYtysyt/sYtlWsHuk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e30f0c3-a181-4fe8-3c8e-08d9fc67d6a1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:15:16.4065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2y0bo8o2eghdzHCZLgZG7ogh+koK+XjizZwSwmY1QOZHm7bcMFQakqxVKhB8OtUwLLAecXQ80hU7Gw0qtuMs6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5136
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 fixes a breakage due to a change in iproute2 output. The real
problem is not iproute2, but the fact that the check was not strict
enough. Fixed by using JSON output instead. Targeting at net so that the
test will pass as part of old and new kernels regardless of iproute2
version.

Patch #2 fixes an issue uncovered by the first one.

Amit Cohen (2):
  selftests: mlxsw: tc_police_scale: Make test more robust
  selftests: mlxsw: resource_scale: Fix return value

 .../selftests/drivers/net/mlxsw/spectrum/resource_scale.sh     | 2 +-
 tools/testing/selftests/drivers/net/mlxsw/tc_police_scale.sh   | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.33.1

