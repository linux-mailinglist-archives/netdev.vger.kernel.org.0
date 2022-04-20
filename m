Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20E75091A6
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 22:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382274AbiDTUyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 16:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358062AbiDTUyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 16:54:36 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2100.outbound.protection.outlook.com [40.107.22.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB4317E11;
        Wed, 20 Apr 2022 13:51:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eNO08+F1b4glwLSu0axL8vzY268XdsMuj3WEh2Cz19a0KaDRdQa1YqP2EsQjrU4rnSQmkQy54jwNL8HZreusZDqzKQvwO3ujjB46DKedDtI1JHzz3oWF1wS1wQsvoyWx0Edq3HiLHEhAaHrFbD/+pAm9ONe+3uhiNySe9bgUGLCxIWpyUmr6Q2bLOcNHivaru21wKtHNxz/vSfCkYdWoHMdfEx13EV86gGG4Wh1NHr3NZZeRZ9lo3+WStSyqZtW5Ds29Mgw4AI2yNsbgVojK+pOsoQFZ1aF8R7r1RHJCjSlJ2XFykGBlFE5z2ghpy0OJmhDVXNopIZCSc85jAihSIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BxBILNihGtyY6rBstYsAHqeDbbxKn0dB4PuzoEZrhBI=;
 b=c70r0P+vL6rTJpTZrHMhZFjgV9GMGLs7E1FlYYfzbd8kVyDt7HVNKDQ9uf4SkefUyjlsHIefkuzPXvbTBcqoAPTAo9RcYByh88VZJDRhYjdARtwFDij3Yt1nn6uNzCEh2jaNdVcECEjzUwzC9g8+DghzfbqprmjtQDKBoOo5pjwFBrtOVn+ChOXEtvTK4b22+Ewn7prFMp55GkipTh52ZbSMtFPRfJi8PauqA04euixMVnQneQ13W7CKeMIZ1irsD9rX0N6Iw3DQKWdc/dDByZC22ah3irqFCpYGPwGQ5dTBRaR+kTin27SUQPDK1JV8bEHcMT52E3tUw8jOfHDGkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silicom-usa.com; dmarc=pass action=none
 header.from=silicom-usa.com; dkim=pass header.d=silicom-usa.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SILICOMLTD.onmicrosoft.com; s=selector2-SILICOMLTD-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BxBILNihGtyY6rBstYsAHqeDbbxKn0dB4PuzoEZrhBI=;
 b=ntyAmYRyNf58EOs4yVkQt6KPP2kWAAqK4OQegst1cnfLl4JC2D4SaUoafpHjhdQcR+MHAqMG5JZ950u9fXaYNJIAxyblDFfVzmuNURszeaSidEpRGLJWRFP1+NvIsvVUCO5tw24LRyaGf+LpVuU34ZPbAenQGx/jgl/JiyXe1Ic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silicom-usa.com;
Received: from AM0PR0402MB3506.eurprd04.prod.outlook.com
 (2603:10a6:208:17::29) by DU2PR04MB8647.eurprd04.prod.outlook.com
 (2603:10a6:10:2de::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Wed, 20 Apr
 2022 20:51:44 +0000
Received: from AM0PR0402MB3506.eurprd04.prod.outlook.com
 ([fe80::193e:c83e:7e13:ddb]) by AM0PR0402MB3506.eurprd04.prod.outlook.com
 ([fe80::193e:c83e:7e13:ddb%6]) with mapi id 15.20.5164.026; Wed, 20 Apr 2022
 20:51:44 +0000
From:   Jeff Daly <jeffd@silicom-usa.com>
To:     intel-wired-lan@osuosl.org
Cc:     Stephen Douthit <stephend@silicom-usa.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] ixgbe: correct SDP0 check of SFP cage for X550
Date:   Wed, 20 Apr 2022 16:51:30 -0400
Message-Id: <20220420205130.23616-1-jeffd@silicom-usa.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0325.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::30) To AM0PR0402MB3506.eurprd04.prod.outlook.com
 (2603:10a6:208:17::29)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df23258d-0d95-46b7-b96f-08da230f9402
X-MS-TrafficTypeDiagnostic: DU2PR04MB8647:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB8647D5EB07CAF31872862303EAF59@DU2PR04MB8647.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aB4Yb5NAD+PVtb9srNdn2PKhkJV5vpQRs4xGrYvQMdFYNktKQ4B/IbJb2Kq+qu/dsbnhpMpzoFqny1jakHfUZPiRlrDGbyqchHGY7i+N3gY0YWzFahVlSwU9rS7DHYzTLdtqrTEXBYwsfBPXjvOr2JUGa4zjDOxYtaVUAn0tHl0BdcKko6A0QFBy2eN6ZrMD1LdesZXyPCH1yOPInRmDCwTHW5qC0R+eku+dB6MANnDUdqje0XjOJNJnJQ3qAwBfx1HPOntAQaNzCxWm/4FX4U1iUWvX7qHsbDKNX5oq7rP/c3nVClVrKtpaTcwL+e1xISluCuMtQ+SmnXO8uhoLMVskupP+AsqyrIqA1Gywhi5XYTp4CgpwnUOXsLs4dhVdp1r1nEmUP41WVuMz6dPWC9c85xy2A3wiaAuUQ+VBHYLnUDQDQEPUAAF9NNnH3W/bpWeUBjvI4aHw74eSBx9VXA5dEtSeVLrVr1AezgLNkXlT/g4eILa5iD6CqW0abwcvCOjGdhDG+KExL7aWnGgM4jsuu/KdWACS3YaQt+C0sYexhm8RIxGtIvDRMZGSBZyK2BQwb2OY1kIES0nMJ+G6+Rxr62yJQU5yeESUfMQjW4MX0785UNdEc3hN+2NBdilxtMnIGO6C2OfmOUgJahNP2j2YolLByOFSqNJyM2GPSqZpH3a1ZS+QyxAqYyZbpoGLG3d4cOJ/oBCKRCuRNz1LSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3506.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(38350700002)(8936002)(316002)(86362001)(66556008)(4326008)(54906003)(66946007)(6916009)(8676002)(7416002)(6512007)(6506007)(66476007)(52116002)(26005)(83380400001)(1076003)(2616005)(508600001)(6486002)(186003)(6666004)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FAhNooq9rQjaTRX1oFwrACdrVekyyocNc1NJ3ZSLwUckDZRP2fv09qriSGR7?=
 =?us-ascii?Q?3h3MsNAF9elqtehJIMkgE5nEJpDrJKfjaZRFUiBAdqxgOosU19SKZq4460ZC?=
 =?us-ascii?Q?U2eTJmn5rLLEpptWc0sjKZHy1a5pFNFO/CMzPiduKpEamnmKWRMaogA55b8/?=
 =?us-ascii?Q?opYBcZ110SEM6k6JDHkMLi7SLIkV10r9URLRGg5YURsNURqHkev9ZpvrwFI6?=
 =?us-ascii?Q?ncFaJLCSFb9GSbLir+wl8Yg54vTdJ6F9HUXMaRFmfFpUy9nRBeluIo5581Lh?=
 =?us-ascii?Q?x0AQr3gS354/TFRhqtMNJsWS2HoJS6BTaZusIyTfs6SzmPvWlaUG6XsGz2nc?=
 =?us-ascii?Q?zAfcKFfhmfZyJd4jAFUZcclwgnr2jc67KZgmeEhYUqVDrEazRUjuBsyDOrac?=
 =?us-ascii?Q?UyvmqCrEiHtogypXedr90PaSDsDZ9g2bX084PXsiiVj5PM+f4yOxVimHwiVn?=
 =?us-ascii?Q?e8QTNx3Bsm720a/KWt+FEJM7+jgXF4p0ip6g9XtrMqMb066wn4Iuw5y3JfZh?=
 =?us-ascii?Q?u3pZNKsvuks7Zj2SoUJisyeHBPe23tv515a11hwQA4kjL3Mf5q7InuvL2vHU?=
 =?us-ascii?Q?Kjf49GehlIx0pMyFByjwiUtzIvw5rco6ZhrzfNGiO7ecNAEhuhtXBWq1k3tb?=
 =?us-ascii?Q?d8Q4CJpFnuDb8N+ulJYJo8INb0nUPf9Ik0Vm6/EnrxFrvik9Qg08OA+eX8F7?=
 =?us-ascii?Q?5f7BjJhskXI7azHsE0gAvRToNibPHi2rP6fElXRd6QDFOKgHnm4vprxxlc94?=
 =?us-ascii?Q?Sy4/H7SM8dia7iyg0WKWA+qH//xEoZ1FkF/oi1C9yrBHFplsTVeb5cKEHu5S?=
 =?us-ascii?Q?ZnUCanAiRlASQPfZJlcTfwNGNfh+NJzNSolQc81cXOkgNlk8wQBIj4o86zsy?=
 =?us-ascii?Q?rsqO1yzGC5Xj9zsC67THOD/v8cngBO8nsGFqs6sT4T42TFzfOuksA+Tr07WU?=
 =?us-ascii?Q?bY+G18obz6CD8gY5tNGhUlbYywAz544+ZUXXXTYhD7fOoNUzKSZGnIs45DRy?=
 =?us-ascii?Q?p+MqF9Kt6eaQYxGXQ8e/aH5M4Oku32VQw9JhKUYvGAYCUNwc/xLdvCaql4Im?=
 =?us-ascii?Q?PqTLSOMMdKb1Oa0xFa1wUpDYHOYcnUqrNWiV8Twbv2xhgxvB7QaPp1FkPT8k?=
 =?us-ascii?Q?vp6Bq3J2yyjPLxRY1SCAlyvK88se7W8PalHvVRd86X0DDJPLpVoASYr8UmUB?=
 =?us-ascii?Q?ON+FrehAngLQrLsRkfZxqx9hqmsosZbJABbF4ZtFToChgN/pJtZ5T+W2k/jf?=
 =?us-ascii?Q?m4ADRnc0dX+DRxEKoVPsYJQoVivKBhQuzcO2McBwlS5t+H2X6A0vadzZQmUe?=
 =?us-ascii?Q?cGxnRPXj1+xatwh32SfBpr70yHjxq7sQw+l5zj5ITOHsgicsouqguQiH5az5?=
 =?us-ascii?Q?46wbbAZ1a960cyMwTpT9anw9TuQiENbe7+FEXfgLBz8ALjC39boT1jfxRvOm?=
 =?us-ascii?Q?yLadWqVV4CAfytTcBnSjbCJ1mWlzbcanRQoF/Dh56oWGcVRJvPc57TY3yaA+?=
 =?us-ascii?Q?Plo0oPM3F2Fj3ra2nejF775vf5pUvADAVb4nDoW6veq1xfjgwGPrCyaI0uPn?=
 =?us-ascii?Q?JxneZuW6n5La47Dc6E0KTAuYRsqwV6GPhFuZcsH1YC2VmpajHQfAQIHHSi28?=
 =?us-ascii?Q?QlFo6D+fhEZ3CLT0Sv5t7DxZcNH1VtCpxRxSe8E7iw4J0UWV32dYX6ONddF+?=
 =?us-ascii?Q?vicOA1ljx7m92o3VY6CN6QRkz6RmJkL9mjyHPu6qtG/uqGv2k9D9gDYHBUQE?=
 =?us-ascii?Q?JrVbvL4jiw=3D=3D?=
X-OriginatorOrg: silicom-usa.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df23258d-0d95-46b7-b96f-08da230f9402
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3506.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 20:51:44.3534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c9e326d8-ce47-4930-8612-cc99d3c87ad1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zvxcMskD6CkHDN54sodZKERmF6DXmDsgzBc4FZOFSH5kBE8PveQJC14hp3+lDFoU46hfpWdoUytx5JSf93jrBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8647
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SDP0 for X550 NICs is active low to indicate the presence of an SFP in the
cage (MOD_ABS#).  Invert the results of the logical AND to set
sfp_cage_full variable correctly.

Fixes: aac9e053f104 ("ixgbe: cleanup crosstalk fix")

Suggested-by: Stephen Douthit <stephend@silicom-usa.com>
Signed-off-by: Jeff Daly <jeffd@silicom-usa.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 4c26c4b92f07..26d16bc85c59 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -3308,8 +3308,8 @@ s32 ixgbe_check_mac_link_generic(struct ixgbe_hw *hw, ixgbe_link_speed *speed,
 			break;
 		case ixgbe_mac_X550EM_x:
 		case ixgbe_mac_x550em_a:
-			sfp_cage_full = IXGBE_READ_REG(hw, IXGBE_ESDP) &
-					IXGBE_ESDP_SDP0;
+			sfp_cage_full = !(IXGBE_READ_REG(hw, IXGBE_ESDP) &
+					IXGBE_ESDP_SDP0);
 			break;
 		default:
 			/* sanity check - No SFP+ devices here */
-- 
2.25.1

