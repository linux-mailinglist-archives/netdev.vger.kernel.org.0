Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A50553976B
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 21:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347385AbiEaT7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 15:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239464AbiEaT7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 15:59:06 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2052.outbound.protection.outlook.com [40.107.22.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A0C60052;
        Tue, 31 May 2022 12:59:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lf6XVc/+9G5I6e/W+nrFep2VGbFNcul1X1i4JoBQEh654qblqUR5HhI0OevxrBy48ADnmL2uu3PxdSFgINdjjm041Orov5GFh5kIkXbIo3BpIy3TQIW6p67kt0JYiOoyxfQkam09zLwyZDQb5We5V/ZwjatjV2D2Jjby7JSKB+NAEEGjQ8dwaNiqK508Wbc/vC3FX/pkpZzpbNVK+GgmVXpH8PaGwpluHUJDN1X0F+7MNg9N3FkJ92C4/0pow3LkqYkkbNnKufdJscxqN67v+wpoRtuQTpsegU5RrC+buPqLOb6+m5KhOgFQG4iqs7nDrPSMgWdQHRhuCPJcQgwP4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E7yfWBQjcKQDCROyt5NpBWupMfKQMD4gnzHX32CetLY=;
 b=ZNlIcabanjJySDhBbsQHTs4Cq6aD6B1yCtOaxMARmagUM2hGqySsdaMgaTa4v2Mf1iQifORjXIvFWiaohdOM1ZzdIvqHB+cAfaQD/umKxcu1opExoISIplOcZke6CJqNqWcBRAyWv7V97WLC+wyUEESbrPMOdmX0QHCx0veHrRyvZ3Wx0fh4HUPvbSitgJ9wjf91etUU7+OaHQKT4f282TVn8+D1xrgdL0mxvFQt2xr8TYl5aoqMg6nGRajXWuDzyrOxur5DVABfWbJ6bOXAyme7WzvnZ76KjLhBfVxFCAxicMXsQrUYD8CRifgCpiOmVMqko/wOhyiurz3GYqH/Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E7yfWBQjcKQDCROyt5NpBWupMfKQMD4gnzHX32CetLY=;
 b=1Z01tqhCGZE2DYSUhR4ljkl/PRRawSE/jNKQr+UQARwyh/06vlw72jpr5M/VDbk5hm/OG8AVT9FeTEk/bI3ZORMJL1m/7tL9bh4FY3aT2pYJRNjNqIdb2Vn0E0HRDy2Ju5ktVZ//LANnDhXTvpqtS7k/dDxmfXXNzdsw6PR0GZ6x+smhmyL/F2e8ih7IpitoyclHJp42T3noCmd5xapsJ2e7PzoA8g8OWRq+sJ/Ih4y+G3uoZFHDb5UEw+518G4Jv29WLEvEvFD7gwPGkUpXX9VtIZeV2Z6F9pWJ6H8uRk9j57OtcqK/rDR7yJEBt+oviT+6B1uNhhqhedFcszDUUA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PA4PR03MB7309.eurprd03.prod.outlook.com (2603:10a6:102:102::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Tue, 31 May
 2022 19:59:01 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf%6]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 19:59:01 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 0/4] net: fman: Various cleanups
Date:   Tue, 31 May 2022 15:58:46 -0400
Message-Id: <20220531195851.1592220-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0113.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::28) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fe0f4ee-457e-48e2-302d-08da434001e1
X-MS-TrafficTypeDiagnostic: PA4PR03MB7309:EE_
X-Microsoft-Antispam-PRVS: <PA4PR03MB7309B383E7378C363CD75D0896DC9@PA4PR03MB7309.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YBHU2L/GRGdhHAZt5T54o84Tjvue0+HaYL/6zxBcJXI+1KvAFePaCuDrmBzNeTrWCcrJfo5r7AjNzWVfsw6JX68zvOsFyQ2iThxDgsE+powmH75pRpiU3DeDIeMvDjdwFhJ3YOiATvpnbNAWq2nr1+KJaTrFv0sZEPWuNWxZReT8lIjb4pDki6aTBYykfMth62qUscfheSAuNGxVHrqB+Ic438x+Hs8pfgXMbqkPq7sWUI6y6zDWQ4zZ6XAB/r24j61b+GdVT3oDMMgUKihVB7h+0LEfChq9CRcZ17qxhWdLApLd6IfNXkXU2CElG3y/fCGNxuMlLBMkFsPv3labjHvF72EIa53BeZ2TrfBvgq0T1x9rVybrMbGrmaRe18kFSSnqTi1Rlm17MMqMJLM0EYWwQYOvFlRLpD/XrtFPi1+lLCTEq0luRN4aiQQVrk7FYQYz0jeQh+y/pjutDSrob40CZcJHF80nSRILgzvt8UA/4GTZCaSEzADfba+qrJweOrB0qzeYZ/FdxdcGy5xYHz1a5CZp+IzM3or7xcSZ4QFK00Gl2IIfinAVb0Osg4SwbpRUhjLVEUS97Q4xey8lIuhD/o8V2i1w/nBEMym8Ptn1SxD5kkb/LeRmALFoIvz5IzpOyVa9nyo/vg3wOixxz7ch9UpPz2T33q0BGKW9zIBHaftgUf+bqUQ39CG3jhwCinjKvmTvuQBnUqt4En1m7X4VhEt4H1mOcJJrxmVSAaOckVZ2UxiyNqK3S8BmKu+r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(186003)(1076003)(107886003)(2616005)(38350700002)(110136005)(54906003)(36756003)(316002)(4326008)(8676002)(66476007)(66556008)(66946007)(83380400001)(8936002)(508600001)(6506007)(86362001)(6486002)(52116002)(44832011)(5660300002)(6512007)(26005)(6666004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MMcUdajlCR5seGQDQtNW5rkeuK9UxXB94fL76I0mTdUrjW3p7Sv9bc15dRU6?=
 =?us-ascii?Q?8c01iNR42NcOUolVCj2mF+fLv4vrOot6cwWMIXbVZjPhYX9I3wKtFvWoAKV0?=
 =?us-ascii?Q?gCpL1q1WPaEXSJx01yJaznfkH7L9UlKERBxTgMm4Awnju2zO7hyqhxgnUfhh?=
 =?us-ascii?Q?Ag0t0fhHk/oiKQt0IOiYMzoxrsMsg8sNcpUwk1CABBxqB0cAatbqdbTHX08y?=
 =?us-ascii?Q?IQTCGBFjRU8vADo/SYqbqweYld2cyWoelki3CLvyzyk0FqJmV1DydLZQOJ11?=
 =?us-ascii?Q?yS0jF7Nl61obhdtc469lQYRlC9fbeTlc5Fyc54LiOnL723Q1q1mPVhnr44E3?=
 =?us-ascii?Q?+7EeL5pfu2njlYSE0ptoSTo4jIlLJHJ4ZZPkImKe7vYv2M1rZhNB8Dvd6nwe?=
 =?us-ascii?Q?3f62R5QHBndmynX9ynKYdXsjZ0+zmzq5tNBPqud82tF4crrV4b0J7yaSqmMq?=
 =?us-ascii?Q?i/PFpXTaWq/KOgeV6UBnyZhQfgQ44OmY+6QSaFi1jkjPFFItqGIIMfq2m9Pg?=
 =?us-ascii?Q?ZZrp1Zp8KoVLj5leDp8W314nzxBXWwFNoP9EmOTyYWFLKZIQzcmczILUB49l?=
 =?us-ascii?Q?tkG4fVsSojE9kpoJtafK9n3HtaqrLKhpFNN6n2bxYUVrMPnZM6lCyTUSZGDN?=
 =?us-ascii?Q?4kWpP64dRQLOvN6F5+pKS1ri27a0PGRKuhFgtWL97MIzzzIXofXcBTqFoEuz?=
 =?us-ascii?Q?gDrjJf1eLrwT/+HULLzKjCisB0jRtE5YD5JRcMs62aDe/btczos2p3vMhotr?=
 =?us-ascii?Q?qBQWOtCR9MCt2BqLSLlhq4Eg4Yg09YtIlxF2GzDEa/K42MnRYeYcjxOKFDo4?=
 =?us-ascii?Q?3pGCE4lN4xbG5CI5Ueei7xjt4T59IeGlewhTDWpzyIAx2vs+Ig03F/cNt5TL?=
 =?us-ascii?Q?lqw9YpCWkke/brH6xGyqL7HjVGE2ojS4tPcrLgo2Zl8vjun4fN7ls2A/tq9X?=
 =?us-ascii?Q?U/qfh5astOjUTGlk9AOBFC+I1YjzJ7CmP1BdsK2j0oTZwZJnaIA2QoEBplX5?=
 =?us-ascii?Q?kWCiRFkBB9bYnQHxs9zglKMO2j0qmsZa4yRm6KPtfOePFkAIf9d3E+dGcTDw?=
 =?us-ascii?Q?wtzUdHa1055ryP/WCgvhhMb5M+s/17gSTijx8lvH+zej3tuMdswN2bi80PmG?=
 =?us-ascii?Q?PyCbhvmCVVeJ47skCrTE/tkgwPMdMdapO36gX+I1Gdbl2OrEgrFxaqt/in9v?=
 =?us-ascii?Q?zdaXai+3KgxrjN2+FrDDpALe5e8K6ngD04ANAQTDEJZSy54kPo+jQ57+s82+?=
 =?us-ascii?Q?ty0iDhwIDEOtE3nsKbCJtepq3KZ/MSI6S+ptJGev/KSzzKXqluAjcaLLK7Rt?=
 =?us-ascii?Q?R/qqt9maUn2RS92QnjkN9ByBtiWyTEj8DzdOhT6F6K6XJQV583cLuxgRY19/?=
 =?us-ascii?Q?xRVkNlg/9V5hL8Tqm+cdxfwnlwW4g4yPc8PwUi4089qTqfsknRCJZRICccun?=
 =?us-ascii?Q?wdZfQarKz+EJUv1HEI+RHJ6sMANw8q3N0YWbLJVjRCzCLKzWEDkqp6JJtVwj?=
 =?us-ascii?Q?teAwMzx13jTlkLlxWERmuNuBdTA8CyJmO2RhprJ2w12wMzymatnFfvNgdhbq?=
 =?us-ascii?Q?fQZG5nUe7w9QYDGAXuY+hk51r9M//OFy+DPIUjFaQPVp1j5/Zi3PIMl1V01u?=
 =?us-ascii?Q?YkZLBdaOfB2+NimD2oI7eEG1XANXdP253I1qjfjzGhdeFHLYZljuEhgPYwC6?=
 =?us-ascii?Q?mCGXcIgYe28TefedXoNJ9J1TI+x9/w77ZqXoUp1iRG1sjvYjvhn364kfWUsz?=
 =?us-ascii?Q?7v822k4C6B8HV7Jgs618NsCxM6bCbuI=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fe0f4ee-457e-48e2-302d-08da434001e1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 19:59:01.6099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8lzgA/T7nlpvQ505+kuk/4pmUoDRpUV53CgbnNuYP9vD4DUisjoQdBgGLiZgY+aP27hMosL/jdxmDk1wz52KCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7309
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series performs a variety of cleanups for dpaa/fman, with the aim
of reducing unused flexibility. I've tested this on layerscape, but I
don't have any PPC platforms to test with (nor do I have access to the
dtsec errata).


Sean Anderson (4):
  net: fman: Convert to SPDX identifiers
  net: fman: Don't pass comm_mode to enable/disable
  net: fman: Store en/disable in mac_device instead of mac_priv_s
  net: fman: dtsec: Always gracefully stop/start

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  11 +-
 drivers/net/ethernet/freescale/fman/fman.c    |  31 +---
 drivers/net/ethernet/freescale/fman/fman.h    |  31 +---
 .../net/ethernet/freescale/fman/fman_dtsec.c  | 139 +++++-------------
 .../net/ethernet/freescale/fman/fman_dtsec.h  |  35 +----
 .../net/ethernet/freescale/fman/fman_keygen.c |  29 +---
 .../net/ethernet/freescale/fman/fman_keygen.h |  29 +---
 .../net/ethernet/freescale/fman/fman_mac.h    |  10 --
 .../net/ethernet/freescale/fman/fman_memac.c  |  47 +-----
 .../net/ethernet/freescale/fman/fman_memac.h  |  35 +----
 .../net/ethernet/freescale/fman/fman_muram.c  |  31 +---
 .../net/ethernet/freescale/fman/fman_muram.h  |  32 +---
 .../net/ethernet/freescale/fman/fman_port.c   |  29 +---
 .../net/ethernet/freescale/fman/fman_port.h   |  29 +---
 drivers/net/ethernet/freescale/fman/fman_sp.c |  29 +---
 drivers/net/ethernet/freescale/fman/fman_sp.h |  28 +---
 .../net/ethernet/freescale/fman/fman_tgec.c   |  45 +-----
 .../net/ethernet/freescale/fman/fman_tgec.h   |  35 +----
 drivers/net/ethernet/freescale/fman/mac.c     |  76 ++--------
 drivers/net/ethernet/freescale/fman/mac.h     |  36 +----
 20 files changed, 96 insertions(+), 671 deletions(-)

-- 
2.35.1.1320.gc452695387.dirty

