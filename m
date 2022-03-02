Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2084CAA51
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242308AbiCBQeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242593AbiCBQeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:34:01 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6006248393
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:33:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ik4Hrzy15ATaipSqMOKBycfL32la8NAVSvNXwpgmx+Ozp0PHg2YpZ/7X0sZx/xtP5t1UpFpwxjmEnMm+mXgqRIYjxof+QP8nh/I81PCosJ5URxenXaPF37EExm2Sic3lRu+1QBeWmr6LrJY/Q4IfoWSzsBPHduXZrT9DMofPRV26IWS8aMucGQ4VvSMWZz3cVXVw/b8XDy0KDXiQeVYf139yvquvRWMqbgWR4aajVOi4RgOEyZVGraBdJceiJdc3BVaJQfaZBYKVFTgGkkrP8ETAU3Wt0mXSdwpTL9Ve5znVouqetkupTfHBmMEp3PXNUvedWqg83zlhzC0GY/kRUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ba52Y8UsqBq5t6xftkEOKhp3rZxCpaTjAN9biOb6TuI=;
 b=Z2O+A8oHHYO12prLA8YjP3sdei+3GD3m94quXn5MtPjRmEKSNKHMAZhw4egkTpnsTkwZt4oq9qPtK4xYFCeIvAbQS55TWWXBLwpUrvAhzWtTg6vxCe1757SkO5lSrD6qPJkveZlO2Y/otso9sOtb44mClE5LI4g3xoLwjyx1oq+J2VzH3dlBguuNHIddr48/7tUJE8/Iqlu+qqEIyHAzV3RkirIBDw0Q4ufg4N2EvzYFXC4q0R8IKn9iYGAvhmqdLnNq4cD1Va+fVwkfPeVKW0Kv5kmFLqN7+v8TXJeAjKx1JP57SdEgsp+RvQjWQwaXoSHoHEtCXhRrsLs9PEIrBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ba52Y8UsqBq5t6xftkEOKhp3rZxCpaTjAN9biOb6TuI=;
 b=lzeyAig1HRifxZQ1KryNt+lLDzd2V/9Dh9nfdHKMx2LIG6wn9x2iJew/HZKFzz+YMPbswLbYGXZZ1rqf2Z12lcFW1bidKvh4bSey0Rw93haw4p6p2DsEJkMzOQdomX/5eJ4T6QftNOo44cBxMa0hldc9Q9ji7KDq9VkuV+a41qEKuOF4vMhpe1u/bds7Mci/QM2DiQVIDd0aey3lOuQZXT22eWTuH+o/eTb0+DOAI0YyMR0AoxVzqT1JUKM46x3JO846+0bqVJcTSy7r5R1SAp0vcDRM2nmfrrfAFOSGHvVPJOEMlM/FvaT+8IKmEDMe1Iu9mCTjxvYqvZXWuu0S3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BYAPR12MB3208.namprd12.prod.outlook.com (2603:10b6:a03:13b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Wed, 2 Mar
 2022 16:33:11 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%6]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 16:33:11 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, roopa@nvidia.com, razor@blackwall.org,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 12/14] mlxsw: Extract classification of router-related events to a helper
Date:   Wed,  2 Mar 2022 18:31:26 +0200
Message-Id: <20220302163128.218798-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220302163128.218798-1-idosch@nvidia.com>
References: <20220302163128.218798-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0165.eurprd09.prod.outlook.com
 (2603:10a6:800:120::19) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5efbdf8c-381d-4526-42ca-08d9fc6a57aa
X-MS-TrafficTypeDiagnostic: BYAPR12MB3208:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3208E87CEDAF974CC164E750B2039@BYAPR12MB3208.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eSog5GbLUghoQmZEKPWGseyRcCp6bfo/lRIMmg+65o/CO0FCInK9FpYRlGn8xLwXbgJy/ne9UNDnVn1DXSaNYeL53de8C9TmtmgirJQZbLmUNRKuadj0JiigKmYlYq+aqB2cXp/d4TkrGb5LuVvAb3n3AWR1szg0ib1+/Ej1sT439x1op/M0DpaKw5a2mjFIv2W1fIha1KBd64OXgzSflph3/74+WioB6TP+04RLszZyBnITWSS0/FBLfWvwVdTRYeaHiXDOcUwRTDTZ6a09cVIuJp9chQBLA8Vp8gbHHQhWBPY4piMmb2iXbaxptVlsl6W0XTG/Ni4BeFRn7qCvKunIZatY4RGIqenMv2tMH1sViAMhTf0pgLltfvdFH/evzYcII4tNSScuB1jnHHVSs8q081sV7PTksKwDsq4/NC/renpuPMVMDJDV3lmPECZdHOgesyAfQTTulI6dZbzk5f9mkb5GG+DKdObZLcllBV6rZ6b8e9hD2Jx4rzbZlRrH0v58R1IPKg6RhwVgqOxEFNdV95I7DaXMmPiD6wYJ8ia6DLfQuHrLP//1qtsSN9K9Wa+z5vGJWaXPY+vA3I869EM7p+IQwpTKEDROYSMR0VeE4PGVQwWbx/MCGPppdHpAw8mLTN10W0cbiEmUF0/Fzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(66574015)(6512007)(107886003)(4326008)(66946007)(66476007)(38100700002)(66556008)(2616005)(2906002)(86362001)(5660300002)(8676002)(26005)(83380400001)(186003)(6666004)(36756003)(6486002)(508600001)(316002)(6916009)(6506007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1PF4BPmpbYtWLtXxX0aB9amgFUCvUBk2bvo6Ly2m0UUsmk7oWYyqydh94RgR?=
 =?us-ascii?Q?FaxocIFgZVBoyTZwLRlvAUR5P3yr1OQ2wwUAVfPwOuCHElzfGaYo2nqi1bNc?=
 =?us-ascii?Q?CvpFYC4hLBZJirHGr5lr9NcMRH7eviWQkqJQXsx4evZMc8HpCalnLQMLCHZF?=
 =?us-ascii?Q?YHAJ2IwL7JdzzWyNWL36USJ7x1nVbhyB3zUa7Ja8O1hp4k0rypzCqK9qrapJ?=
 =?us-ascii?Q?7gcaQe2hQq1IVwmLMO5UZY5T+J1g88cvhem0xRptdNPVaFRaJObdNCFda8tB?=
 =?us-ascii?Q?Eo9i95g9KX3143Otm8WgnxjlT3fBwIpiQ6kaGiW8J1/EP9cPvRdNjkuW1S4U?=
 =?us-ascii?Q?Y22S746rggGoKeWtUrIN1N106u2tXNXJXitLUMAqemoXJQNjyiXZIvbkF/3N?=
 =?us-ascii?Q?jQZccotuNbZh5lnJQ86nV4Ae8VR2go5V/FOfHTGmlfNL/Ox4zPEKyvcf3O9S?=
 =?us-ascii?Q?IC+caf0QNcrWr8h3tWp3G2z5TDCHC6wiJ1LyPuHXZaXq2zWqaZncW9xyq4Aq?=
 =?us-ascii?Q?lPuQix7Vo7HHVHgTAzfl7QKiQSZR8uw53W2RejkznZEBU3fTLCay5dPj3m3w?=
 =?us-ascii?Q?WzFRSrjoIyRqueHQ3yMbl6Ij1UL0V4jiMSrIUHTAAFODz8nqDox85GM3s7H0?=
 =?us-ascii?Q?gZDJYklAWQV1uxJzG3pszom52ZjNlL8cl0ITwSKW0c42RJ6JeG1xX8nKq6ff?=
 =?us-ascii?Q?5SHf5cLAjjZthS7Lov1zw883w9wWCSBVKNY6C3YTlqrg4zJ5SX7zfcY65ltB?=
 =?us-ascii?Q?0UWZI2jVo2OOLKSI3ioAoH8FjEqMXBUwxiGum783B7SJnRrDMR2PGtUdKdM8?=
 =?us-ascii?Q?U2D+WK9Q9Dm8jfRrXbWd5Qt7PbgRJ6M0618MJ41r4+uTAWSypr3s+mgErMi8?=
 =?us-ascii?Q?/7gnzvyvxabmGeozkcagMVyxk4VDrP4mtFtyfwkZsRIrvIpqVFfOeZiX/hED?=
 =?us-ascii?Q?IUON1xWvTm0VqSnMUQ2cVNSf5KXr+vc0nzzOikfdic2SevoAD0kzYzXWcN6o?=
 =?us-ascii?Q?oMHrUVNfhENANR9AMEYIeinIIx6Uo6WAPGmsYsiIVtXXL3ePmAKHrrDgR1FF?=
 =?us-ascii?Q?ZEKJIZNzGBqMoQQvJE5miGdpNNwzSieZmwbR0oPqUxI+fYnxHCTkxaagduW5?=
 =?us-ascii?Q?0oClfZ6lYoPb+TIx+LbuC/mNGL7roqcbFuuipQbMCW2+UayNox8F9txfJ/2r?=
 =?us-ascii?Q?n+lvXyPcLIrysw5qf3GxR+UW8V77cVKK5+UrEksxxJc/Q7sTH5r/JrOOkTBv?=
 =?us-ascii?Q?ssEGQftDG3OQJsVQu3Q3mAzpRNtlhzEkZfwCZ3rqZjCREWhdC1Pxiq2zCzVO?=
 =?us-ascii?Q?kVpXdkqcRnHxvYN2Mqkx8tF+EkvVQ7qf8S+uc4jdui/uBJMU1EcoGny66YyR?=
 =?us-ascii?Q?4Cus8jaPjqUGrsql/dsftuZTzR2yaCjsPYNrAptPq6U+oHa/mR9GqPvU1WUI?=
 =?us-ascii?Q?ifjQmBPzNH51F/RT+T0xqp4t+vyn3MwZWpaoZTG8V7EXfbDBqU6jqlWFLos+?=
 =?us-ascii?Q?ucAeZQzTN7lQ7k4/iU5yTPi252OlFmYJ1x/5Wim2IE+jAZfP+upQgrQkMK+N?=
 =?us-ascii?Q?tvPUEJq2w3DbjKQHRr3L6WbKnFJBZHs3fwAJ5Give3gKkJtCaF4R5saYad6H?=
 =?us-ascii?Q?1gsxowrbd1ZOifgBC7JxmT8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5efbdf8c-381d-4526-42ca-08d9fc6a57aa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 16:33:11.7769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYDV5FhYNnLCufi8kvl7Ys9aVEdl0lR5npl1k4YCA2YJsr5/WLa0K3+dlxT7ha9sh9pCsMYKBMjnfkRVQ64Giw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3208
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Several more events are coming in the following patches, and extending the
if statement is getting awkward. Instead, convert it to a switch.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 4880521b11a7..10f32deea158 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4823,6 +4823,18 @@ static int mlxsw_sp_netdevice_vxlan_event(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
+static bool mlxsw_sp_netdevice_event_is_router(unsigned long event)
+{
+	switch (event) {
+	case NETDEV_PRE_CHANGEADDR:
+	case NETDEV_CHANGEADDR:
+	case NETDEV_CHANGEMTU:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int mlxsw_sp_netdevice_event(struct notifier_block *nb,
 				    unsigned long event, void *ptr)
 {
@@ -4847,9 +4859,7 @@ static int mlxsw_sp_netdevice_event(struct notifier_block *nb,
 	else if (mlxsw_sp_netdev_is_ipip_ul(mlxsw_sp, dev))
 		err = mlxsw_sp_netdevice_ipip_ul_event(mlxsw_sp, dev,
 						       event, ptr);
-	else if (event == NETDEV_PRE_CHANGEADDR ||
-		 event == NETDEV_CHANGEADDR ||
-		 event == NETDEV_CHANGEMTU)
+	else if (mlxsw_sp_netdevice_event_is_router(event))
 		err = mlxsw_sp_netdevice_router_port_event(dev, event, ptr);
 	else if (mlxsw_sp_is_vrf_event(event, ptr))
 		err = mlxsw_sp_netdevice_vrf_event(dev, event, ptr);
-- 
2.33.1

