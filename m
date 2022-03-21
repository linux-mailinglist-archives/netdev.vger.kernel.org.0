Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E338C4E2F62
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 18:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350543AbiCURwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 13:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343635AbiCURwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 13:52:41 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B94A53B44
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 10:51:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cz+yYXvbvS4K7DHMKrTVLc6AZHYq4lU5ufPEvpANCAaFn1MDm9raRSFRQ48tsinq6peRnhgxi6x1eJamWbiSXofzXM/9bXksTOFj12UcnLfipDi4yI6B/7NyLgS0baFEtL7ZJWyNImKe8QMpAy/y1tbNksMRjWHb4eM7OY16LmFCo9u329JWGknR2x6cks8M2OGUrEOWjPXuccGx9BgM+QgpI6QR2uFgqTv4RkKn0KFHsK/6tncv3Cup3es8MkzTknM9p81LNujuZBdLjf6dJZHv4H8Eh8Z6vaVOxvYR+e23QPy59td0cTdR+5KJtus+Ve1WxfIeQ29eNzWDr08mBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ys5eQwSeOrKXMMIw0WCeg/8lgiBTla7Y2864i3hzmJU=;
 b=W58WIgGqFC+HugJlffHgJKd3n7FfhJudSyv2TUDBv6kcEJzLhpupWtea9B1vrvLa15g/Hd2oq59FyP5Llro+8+LUXE9eLeegvZjn8pLaSieTgZmVTOGu/5Ii+/TpULByUCBEQXStQ0yNejfGfqN8bLTtvnyQ92WKQrYWD0E47cIlE+raTOy0FZ/HFaS7emeCxCWj3JRoiDqn96x5z7S8DqSejr+1nHta9p2oZWcntVP6L14b13/n5fW+3fedqNwn2CNxZvsAYR17uk7PJChnuM8PDFSnqTTbYy7dW+cdKZcPSzwLdSUlD/oEZAAKJ95dofnq4HcBo8R717iMuhumpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ys5eQwSeOrKXMMIw0WCeg/8lgiBTla7Y2864i3hzmJU=;
 b=TQOC6didLoeq3eJG//IxzJBV1eSvALtnOsttLUfVSuY80yuU7Uj8JAsZVhOIziQ4UuJZN8fYNnccgg3LwhCyrwHH91GbRMPvIXvyR/1eMc/2FlusEBFNNZ6kt2F6su+mGWsV6pEDddFdKqqoYBuw+p28bPKnMZZlHViSM6nkCTCUi1XdPgzX2vnfqyXa1wAeTZSNJO6tGlXhEuXFLeHdqSLkhEQYfmrLZmD6YalmmrOsjdGv8tQDCZH9Drt7VKo79vdLOpvzNGVHsC5nH8pnJNMhQ3AZNGsf7zg8fbiE1MOx2O3W9V+fhpaeJSKdkmapS9h4yBxt3HPfwi16yHFg0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB2864.namprd12.prod.outlook.com (2603:10b6:208:ac::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Mon, 21 Mar
 2022 17:51:14 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::151f:fa37:1edb:fad1]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::151f:fa37:1edb:fad1%6]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 17:51:14 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        schultz.hans@gmail.com, razor@blackwall.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/2] selftests: forwarding: Locked bridge port fixes
Date:   Mon, 21 Mar 2022 19:51:00 +0200
Message-Id: <20220321175102.978020-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0106.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::21) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b234c5f-00b6-4a79-3d74-08da0b63649b
X-MS-TrafficTypeDiagnostic: MN2PR12MB2864:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB28649297D29D304FE899E7A8B2169@MN2PR12MB2864.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5I/8KZJ90jyvUhB0O51UcUZfMQpu4s0WiIVX9/87KpZ5EVDXwgaBzaxsl00e+qtIvmHpg38NQT34bnvqqT+dNM69xvTI5eWUoRIrtTrknb3zfb+U9xA3e7fxLLun2TgxTk35YGCWMM5OMWi7gWuM3aN+EFjQnBzHs18r9pfIpxbAPYXnWDTImYEVEpKYL76hVSwJ+lf2SEea2zpe/TdFHUUSwDv2ivitXA2rv0pqSwO14DizaeqKb8j2SmaW8D8n+F8cpbNBlsmrdmzIue2MLUGO8VTPBlTS1mDr3iVIrMqCeCRh0zWlPOYD01m9mj048Fgq9HAGkXPXOpBCYp3ALQqcSrA/kAgIK9JpS1H85G72jwlloHBkjTAGTf40HDnvSf4KnKjI3r76KdlvnqiWkEw7BPGh6szQjHgAZO6D5NggidK5JjLAArgIPRlkF2/ebZlo9r5CZO0TT8658+1U1qVHgWGuVFWCgUIBMJOq4QMDyR205k1zy0g9eOOnLdYwLLYaub7QFMDV+XOzkvSyETpnPF1XunK6Y6AVUxBB4wyZdGzQ5d246hGScL+aoBuZzvX48etvexaaH4nTnaA+r62M16RItid4wLZvg9UELZzIc8BmvlV7K+cXvWgOhoJ145SbxJCG7OwKlk5WpQlJ9w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(8936002)(186003)(86362001)(6916009)(2906002)(316002)(5660300002)(6666004)(107886003)(36756003)(4744005)(6506007)(1076003)(508600001)(83380400001)(6512007)(6486002)(66556008)(66476007)(8676002)(4326008)(66946007)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kfiMb0BmQGUEtD0LgFjQYUpKJkyzQ8WP0/cYYD5R9meYAdm5TmTi9zXXB9wk?=
 =?us-ascii?Q?XA7uhOx2wWjHf0n/o9aACvZpEp+ZCXeawsMT8A2XV6oO+Gd0KRn1ORGHtOj4?=
 =?us-ascii?Q?SqONva13oUaQD/DKFtE52Cdrm/L4hYPjEQjtmIn4nb5VI7COM3Igy9g/IP+I?=
 =?us-ascii?Q?grNUlzO/DVwvxVNTiUm57407slq3K2eia4Uxy/i2dtaK7jfQtIhZrIbYI64C?=
 =?us-ascii?Q?dNwkF1x4rmptQCuUz30BRymwBpPkM7ALTu4Y7YW3B55mDMo8mf4c1RC69kkM?=
 =?us-ascii?Q?74Mjs12ns/RyHNlJ7dbfReGHiUt6J5IE2078EQ4532NLT3huoNSpqGVf1ULn?=
 =?us-ascii?Q?UTMNfxhyyXUVCgsyDJ6VKxT0PWy2xtdQKb4+saLCsu9atmhsoUM7F8ozoDWF?=
 =?us-ascii?Q?Y2H7Ya78VByTR1f2nkdaArRwhjHUnwgSorDiyvuV8iJL0n6vuuQgwZ3cfduC?=
 =?us-ascii?Q?e5wc/GhcNKNFHeeqIHBU/hxHbSfllTJNyze0zElvqTdOCREeonJc0Y/mlZ9k?=
 =?us-ascii?Q?Up+AOrPd1NSigJn4+mFrcL5Ua59ha/guRNpT+LMFX2wWWNueGvfUS6de1+l+?=
 =?us-ascii?Q?NJ6c5lJaRGsjllwyBrwAM07Mb9kb+5QtNvMNk3t/km71HRF6udx6Y8cPzSks?=
 =?us-ascii?Q?PD3sgsfN41c4p0SWX23IlAB5Bnc9J1bFiUb5+1EJM1/M3iWLu59tvgoJ7ZwL?=
 =?us-ascii?Q?y5gDNZ2osICWRvFxufWY+GAlugsE6/sJycDvgf88vIQpJiRY2muvhsV2yCY4?=
 =?us-ascii?Q?Ujh+t6EKI7vSISQ4itnGNznz9lTyfYWEWb5PE3B8/prJr9OpMNlucPbcKnSw?=
 =?us-ascii?Q?q19acifcV1EhMDbI9VKooXvpEceavYsI2IHPMeY811LMe/qT2Tk0SQgF0ZLe?=
 =?us-ascii?Q?Om5eYtcOC/JpOhAygQH0VGT9osXeskkQnHckEaRgeJciJioFC9sGFuyVEB9s?=
 =?us-ascii?Q?mLtufwg+iMLGcAeSQXSOs+PBXOLJsM4dDF49RUnWAyzE+1riDL2PxexmxLxs?=
 =?us-ascii?Q?bK7bK5nTiqtwcrwZkui4SArvUwkfACRgCKkFzTXjICi9BQeWyXAQxK0cSRJ4?=
 =?us-ascii?Q?dQGtJHNzehNZw80NFKXQ+nLPcPmH/4+xOcxgRD2FyBHYP0Wg2Bhh8v24yV10?=
 =?us-ascii?Q?mMYJ6Cil8vW8sL5iHUIKGP14fxeG5i2L8OV9gyEuaN/bJjrGwORlNliZm2v/?=
 =?us-ascii?Q?iNlQ8KFVHWro7s14XjySyq2vtKclqsbSjg59nmJ5AXAxx2etb/YjAjl3Uow3?=
 =?us-ascii?Q?ICX31OBYHV3pAJqFrVjYD7Ng4rsvJeK5a/Nspe9jF56Ih8EAD426ZFr6TfGK?=
 =?us-ascii?Q?6XlBkxHfXvoSTMqzeMOux+mPPjf9KRxYuvMg9Ki+CiSlQJ1eFsiajgdFBSfB?=
 =?us-ascii?Q?Xf4p4QttMibbG7StjVgHTglnmUlmSocNgfy3LSMSk/+G4BhLjtXTcFcwTaJh?=
 =?us-ascii?Q?U1Ew+YoAJir29B6mZVu6ItlH9vcFiTim?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b234c5f-00b6-4a79-3d74-08da0b63649b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 17:51:14.4690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M5MYXM80Yb7grbFnsXYh2cxZKK7QB0I+H1tO4URVFVBX/0WPRTgjNhfd7JUiYvWgTCWI1GGdZGIJNv+J/7ln4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2864
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two fixes for the locked bridge port selftest.

Ido Schimmel (2):
  selftests: forwarding: Disable learning before link up
  selftests: forwarding: Use same VRF for port and VLAN upper

 .../selftests/net/forwarding/bridge_locked_port.sh   | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

-- 
2.33.1

