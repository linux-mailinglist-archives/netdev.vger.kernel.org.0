Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC464FBF88
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347456AbiDKOtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiDKOtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:49:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2059.outbound.protection.outlook.com [40.107.236.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5287821E32
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:47:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ii0zVNeQJXLGnWDR+Fn5pDtXqthl6d4H+iAkWyj8iqXwCNhu8TWEjN+olpbGzpkJjiK19m521Xy0b3qIDVorUkAIuYu8uOPXu+d1ZQaRnIc1qFD/jMlTL/HjoYLo9r9S+HU2xMSWsWblZANQimhEf2WaTDb7xOOhvTpsqM/eEiagi0alPTAN5w8O06ZEkLGPoS1wMPRI935nB2UjjjhLb8d0WCmGGDvcei676wCjwzf26H5Ru8aJhiT5wc2pog+3OK7PRGFYeePhWcwKrWkBR/9QxERVef81fT+/Abe9Vcz/fovJKdrZab65Nj1GJ+18JSRaeuyxP0Ycqln2W1hqNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDhhkBAXuY2K0oeWI2vF5JQA3+swIFtLHPv6OfhZM7M=;
 b=PQx7/LFRjNZO+JkhQDMbBuGUOBsuuWsdwavvltt72y4rLGe3HPEnU+1LpzvZS+dfOPLtuDXDArm2ZdM4Miw3abvNetCCEe5Kq7g266tHUIujctiT2/PZZiIrPNktqnRR0jc+irYHt7T0BqAqCdffVWBiMSW6d+kQxfBm0pnVfpAnNyChMLjjRj4loFmQB1jCMOQwEeUs7b62JyqYWL28iKiQU98T/s5PfMwBBxaA/jHdkR8ImpmJiepRysfMfXSo6MjPAfmrQkWXQd5Fw+GhTNJprtH3dYErvO9KmDzXm5Hti8tLuD61VCIDZmmTJK+DQGQnuWVAEzaTHYO+/lNwhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDhhkBAXuY2K0oeWI2vF5JQA3+swIFtLHPv6OfhZM7M=;
 b=KTNONJ2g+cxW4zRDIbWcaBarBNOdnyND4fDQuNjYO5akkVn9tZHSJ/dKX2kWdQ0pdzfvLefHA7isEUlGZSMi25GhbN4HY88YPvJQs0q+6rqh0/JoFxKUm+ZQ5epgB2cepoxbRX21OPKaQiYc3lCBo5yk9byY77VYIDnFKKpbA1K0N8e2KwvfJUcjeB2ut6TYjvTboZvv5hjguDyg9i/w4X/8p2AYs0CG6/snH85Zoi37kHj93fmOzrRQOBwKAUZPGgNgc1csICvlhs8UUnOBhtuZ473od9vXnCgiMAMxuPMrP8N6eZaNWsnjtClYFIXSsy9PaaU6vQ64J6UXo5lJvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CY4PR12MB1430.namprd12.prod.outlook.com (2603:10b6:903:3e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:47:30 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:47:30 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/8] mlxsw: Extend device registers for line cards support
Date:   Mon, 11 Apr 2022 17:46:49 +0300
Message-Id: <20220411144657.2655752-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0028.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::16) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c725530-679c-4771-d954-08da1bca3495
X-MS-TrafficTypeDiagnostic: CY4PR12MB1430:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB143081307A863569CFFB0510B2EA9@CY4PR12MB1430.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Upc5w3X/ukbekWSArCPsCHh0PJvOLt3yxfzCEtwwMHqEHi0yuDqwrb4yMirtak3+0pCNGyg33lu/S/9pIr/AasMDthkPNnyLm1hOK9JJRxLciqSHouPMQXkwlU869qp64N/VS1JSJbdO/v62h8kiG7iH0uQ/r2joaWiUUlew6Z9F5OGgf348wIwoWizdFnudhT9tZ1hr6xia44phO/GmO+hWVkjyWFlMC0jd1EEvyFMQ3jyhZmCqSH9kb5z2nqOgeD6DArjtgg6Fnj+o5dFXDS2G0X179NivxU2gKGZ22/5peROC3Uku6rovuoDARwjL77G958i3sBjuPFwbOwxNED0zaonZOr6EYCdwwBv0pjhfagSyaw03V/tGLLSVTx6lOFjLK255bMIq2xxugd6uj0aJsxN2myahLFS1MIOLWGYienbJ65b3H7XXyXectq6OHDfe0FMiqqo2qfdpmH3q3T1yyO2zPoXWtlcgz9jC8xNx4ullxcQsuR3DKZvjqL/DIiPI5W55TgcrzkaXRdwZ52csTtgk7zHLZHIXpsKHRxXdUi8eKdHoTSoYXtrZRBIzU4KvsttGM9xaRRcF19LIbuU98wVqG2V/cKaCjUI+gsdU+M+CstQUYJV59giTy13qnohx52MES8Vm8TCfbuDpuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(66946007)(66556008)(6486002)(66476007)(107886003)(6512007)(2616005)(1076003)(186003)(26005)(6506007)(6666004)(36756003)(38100700002)(2906002)(83380400001)(86362001)(4326008)(8676002)(6916009)(316002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WHwduodUgAXZodjRIxeDkxEVbJojEFLoN5erbGDIbv8V0bcZwLdSCvYnrgvW?=
 =?us-ascii?Q?98Hs/En0dEwv/aX2kaxprlXIBuMC+1oYomhdlA0RE+2yx9mqIGM7hPJQTnSZ?=
 =?us-ascii?Q?FzqypG1wo4wDC7pOPXDljmCxwixA+9mZ+c9cT5vW5K9lV4YcQScAN0NsmxqN?=
 =?us-ascii?Q?JS2xcnLd7DpHJE22nY1jyjFT/Cuvmq0JNHwIanC7bF7UFmZTX6fWjyOcYfPj?=
 =?us-ascii?Q?flt5aOxNaNHgFBrFyyuRbZKVRn1ROAjW8J48elBr0nKbI19SJs12QUkM6+qv?=
 =?us-ascii?Q?ulmqugcdogoiF9GsdkEVaaVfvX1swtbS2LmvGrQvhAdTZjhGR5z/XNYqdm1T?=
 =?us-ascii?Q?wXPrtRG7+PTFMD/M07WSAkGJbvioaacXslifzW/xLmWnBVguc9oQt61ARaaI?=
 =?us-ascii?Q?mpC4/Jfsk2bWHRiL3T27ldoN7Wup7Xi9D8LBUFjCtL46QcUV/6yRtCbhkrT1?=
 =?us-ascii?Q?vCzDuW+T4xyALtoGaSTeVadUrYCdJQM+h/OLQAnowoZhmyD0oPezG9a7iT3Q?=
 =?us-ascii?Q?4kViO4gwi/3lYS2pD1imv50lKZAs9NiLcK00kF91wxaNLKrK5DCXK729jBSQ?=
 =?us-ascii?Q?0rv2Mkvwn3ndGN57G3fRVqYHR3eyKvmMRCMtYuYrip2Qe1bQ/Sr/Hyr7cy8k?=
 =?us-ascii?Q?8B4wz56lWYUKr6AJHEEKEmPCqzh7hqRoTo36t/qkea4WvY0lXi722ZYY96j4?=
 =?us-ascii?Q?HVwOOI5jaHZzBZp0EzcQwNioUU+oJSD3F0TlEP3RaVfgcuxu/h53G3Oq0h+D?=
 =?us-ascii?Q?yJgELcwxYDIs1Qky0Uf/6Qz2MpJVFUYb5HumKAF9fRhlZ5Ka/ucPd1AzKQfa?=
 =?us-ascii?Q?/2B/+lnne/LrnSfA6hBc7aSZoPeUBdu1k+7iYDGNmZktoOLkMovQuRKoi2Oz?=
 =?us-ascii?Q?dfYhW0vpwnt3IFY8Urtp1DxS9Z1K1sKIXPXdyXldGduutIf+YffJF1xlAQhG?=
 =?us-ascii?Q?N1QUg2WdIXd2OkgKGBgSFkhj3u3KnUR18TdZa5tXLQ0iZSy3eHKfwkXfwJ7d?=
 =?us-ascii?Q?E9/0MsvLAKdHTNirvSPC30mLEK0889QVXyZ4g4d6oAQEOlu/6oZCKRDaxAiJ?=
 =?us-ascii?Q?3PnpOMWRTr1Mip2ZHYnqiasFcvV7Nt8wgPNLuDiVVKn6dX6339Dck+8YH1OM?=
 =?us-ascii?Q?P22KNa08/UBKD/sONEUZdusYTXGN63/ACJ0EuOL4dnfNUkALw3md00/dflHY?=
 =?us-ascii?Q?SQWuyEwU4YzNNOFHn2HlzJxY2w3HZjTnEk+xs3oMNUcjYJ6NsLUlu/nKJUAf?=
 =?us-ascii?Q?HbeRsx+9VqgewfOq531rWLxfy+RpPC8ZHqRtX/gLPlgJCQ3p4TWzChIDuW0k?=
 =?us-ascii?Q?k6hbwXbCjAjSPncSgHNcA7y2K/xpKkWvrv5BXuOf1wcxL7B0gduOWVcE0TeE?=
 =?us-ascii?Q?AEPtovCfO1EHR9FMcvBedqeZIFTtF2/f8nnApyPL7iPMRZ24j+77S7qvy3Hq?=
 =?us-ascii?Q?LjBu2+Gc3wJRLK9tAY0titMutW4c7e8gQZ2j/VIUUEWI8JuBUExNZwrrDOiQ?=
 =?us-ascii?Q?jKYqCFlMsE6SEVnkzoGZc6Eb4gnyO7/ccnxvvNlL6PMRoC7nYFauDsPD06O1?=
 =?us-ascii?Q?XTtFaCGOyknTQtCWOQPzlDJB5sOXIDJMeI7Rn7tcZKUo5qS25otCSiSn24Te?=
 =?us-ascii?Q?S+dRxjwubRfwP3DmcnBMtrXhbVBHiU3/2x7mvrO2zRL8JCLqVz/DNTwJKidA?=
 =?us-ascii?Q?e+wnM9q0QeUBRsES7YGKDDV5z6W7ni04XDJas0jiW9yA97eU2E27KvMsCVDM?=
 =?us-ascii?Q?9quw3rZ36Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c725530-679c-4771-d954-08da1bca3495
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 14:47:30.6863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N8DLgXSxoGrZT7HtBEOcpC2VZcMKDNBOcavK+QRA7knLZ4gCmWzr+yU6Zx5thYb39+P6Pl8ALPodFhpQxMkb1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1430
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set prepares mlxsw for line cards support by extending device
registers with a slot index, which allows accessing components found on
a line card at a given slot. Currently, only slot index 0 (main board)
is used.

No user visible changes that I am aware of.

The next patchsets will:

1. Extend internal mlxsw interfaces and data structures for line cards
support
2. Add line cards support in devlink and mlxsw_spectrum
3. Add hwmon/thermal support for components found on line cards
4. Extend devlink to expose line card info (e.g., HW revision) and
devices found on line cards (e.g., gearboxes)
5. Extend devlink with the ability to flash devices found on line cards
6. Add line cards support in mlxsw_minimal

Vadim Pasternak (8):
  mlxsw: reg: Extend MTMP register with new slot number field
  mlxsw: reg: Extend MTBR register with new slot number field
  mlxsw: reg: Extend MCIA register with new slot number field
  mlxsw: reg: Extend MCION register with new slot number field
  mlxsw: reg: Extend PMMP register with new slot number field
  mlxsw: reg: Extend MGPIR register with new slot fields
  mlxsw: core_env: Pass slot index during PMAOS register write call
  mlxsw: reg: Add new field to Management General Peripheral Information
    Register

 .../net/ethernet/mellanox/mlxsw/core_env.c    | 33 ++++----
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 24 +++---
 .../ethernet/mellanox/mlxsw/core_thermal.c    | 14 ++--
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 83 ++++++++++++++++---
 4 files changed, 108 insertions(+), 46 deletions(-)

-- 
2.33.1

