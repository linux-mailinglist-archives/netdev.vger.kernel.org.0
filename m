Return-Path: <netdev+bounces-1582-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 862BF6FE5E5
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 23:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42891281579
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA3AE21CDD;
	Wed, 10 May 2023 21:00:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C537F21CC3
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 21:00:09 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20616.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::616])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828DB1BCB
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:59:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuGKyiK8ew6BDH6pE2WhOmBIikdkGNB3AqoI24CzuHLLKtMY7ErKviE5Bxh5sd9BwuioDIzPIrr4XXqsretE4NnfxgPRBZWa5FnYSGZjrAQoqbrucJlzS8uAn6PbQtX8JoaFsA/AbX+1yD8EpJPw7jiYkg52bUx0EhJPpDpgAeWXoNTCSSaXETie/vT2cJJSoDenN1jEuUmcmij361YCsrTkYXFdj1+hFR9lx1gKBNgLD/d0gyzt7XA1/p+Fu/NgXg2sCZYrNMHxHc8dbAZyq8x52hl1GPJCpVyubyQ3L4y4s7LZ5okqZ9yFR4DJAGDzv1yP4TUYf09rnHv9AfcStQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JnA8HA5Jfy3OjGhgyF/nZnripRXEawcQ8YrdtqTNhlw=;
 b=hvXoxFkpycgU/GW/YprWTLkBD8xt4Wv/hcgEEc+KWWUxW3Y6qHbQmYw5vA+OvkyAzdHT3aNbgTlRTLSvlxhLZDKPa+3sr5GpfFdgpNb+/FxdPuFD37cLwwqt5XQvmpqJUhfs33rE2ruyasG+jiJRtzj1Nojq14BRQ9pCk7Ao49mJAxYEiYOIibO1rxFjkkcqdWDcyYE00KonNg6jVruAS5/rjb9SiCl02poOt6vZqhEDlpGK3LCkujXLSI5lI9ddCvpUNn5SZNM/dSnMr9BR5ZahnX4/DTSRvCgUR/cgu1IPpzQ0RYZ6s2zBIYM1R1et9h8hCZkFhiDyaViz/HThhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JnA8HA5Jfy3OjGhgyF/nZnripRXEawcQ8YrdtqTNhlw=;
 b=XZUmKfvXdMYt8cDaYdGnCIYf/uztGO59ST2p1tGPWTT4RRT5snyNdG5+f+7dMNRoYg3pkoczVKIhSOg8TUWE4NLlnA7QPe6Zeo8b/s5owyvHcPO8648Yx926dOaAAVa4AfAhkUGKOGhMonW2ZvH/JOdbuaD24bPXTpqaELBDfW0W0slGUUNUXehxE1IcGCs99ppyP3SRbDu2Re0sTEC985cDMb70vxzhXE5SbBnqtR8DIwd4enldFjuBFo6CkBcF1kffYLQ6wtloKaDhVV0cOm5+3jTo60M/72O+0LjL/fKOdyicqXQZkDGk4axIeLgFBDKHsph5YnJSkM1tvpo44g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 20:53:49 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861%7]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 20:53:48 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 1/9] ptp: Clarify ptp_clock_info .adjphase expects an internal servo to be used
Date: Wed, 10 May 2023 13:52:58 -0700
Message-Id: <20230510205306.136766-2-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230510205306.136766-1-rrameshbabu@nvidia.com>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0105.namprd05.prod.outlook.com
 (2603:10b6:a03:334::20) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 171fec36-805b-403d-fe6a-08db5198a717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	k+ez4ewNZRrv2TLUFgvNeVxSlPZ8V/p9/2iYnV/VeIgnfjFbQa+wjSFflvUrS+Mbxpq215CDDcDh/eICoFzFOx50SOrX75oW8kkBs1B0ZIJ7hgJ728bNTfajqV+BLBrs8ddt28x6AwQgqUviqHaeFzPhTwzCslOzyRi/KXtYv0y7iJqZgr79UAghkRRxWUP1cwXcdov7qsTTqXqDaPEQnp+2vwzTL67fEyKbXR2+Y0mF5QvifXuRROAIx6kVVf21tkkSVl2QVdVOMFDcIQCvQgPkMJDxjVZPyGcIio9uJDPrTSb/vgNCSe+c3E2fShdkW8JSidF+06c9pzdXXOvw7tZFWQ6s+SQRYB7VdvI+PZez15y3RzVhNH40d2wogD8Dne3/h0nftLVf5NWUEhgLkyat7EffXnFv5E5Ik1pJJ52lqCiQETjpmle9ii/gDVuQMKq2V5IDNuy0vE//C9Cp73cJVu0Q3cdONqQ5Cq/Pr2uPolp2xmMVzy2SRIMQ2DbamA6X9lDeKkP6C4l/JqtCt257s5Tak/Rb0iS8YLRsQGKqUOPHIHZ4LxIm7MFyGwBJH98XgiDTlXyWnb/H9oqHDM6X4EsLotA5+IV5XT0TX6qVCYQamaO4BadRLbBLUOg8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(86362001)(5660300002)(41300700001)(4326008)(6666004)(38100700002)(316002)(6486002)(6506007)(6512007)(26005)(1076003)(478600001)(54906003)(36756003)(2906002)(8936002)(8676002)(186003)(83380400001)(66946007)(6916009)(66476007)(66556008)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j+BbnUpPuriVv7tHV57WaMpaY3uKn9WHfDTbmXf/DHUOouWQXc6UdtUAVLsm?=
 =?us-ascii?Q?RnI464o/JTuFC+DRNHCumrcusSAOaJfY2OboVC5KlxjsNofKn+MVNHJIM9Hv?=
 =?us-ascii?Q?21MswjKV6YNcQsQ//B6jTRcMaSB9yeJp9Q2GKm7SPRexuQrWQSsGHK6Fu3L/?=
 =?us-ascii?Q?Pkt2VmQOiVZTcY8dv94C0rdF8O2PmanpVIfj64rGTivTTtZyCn0cMRq6j7VT?=
 =?us-ascii?Q?rN8L8kuUuTqm71ge0Zkjg6+hazpLALHREOBJaLOZ+aDx29JZSwC18G5Ash82?=
 =?us-ascii?Q?G91q3dxqgE3tjBXTes7zY17qI3NcrvhJgZ6C/dNGxV5X0f3iQtDVqQMD5UKC?=
 =?us-ascii?Q?/w9V+I3YNYcJydyEdDjkNXJ+H/hv1gG9BkIYwYm7FekHbTDxV46UrUL5xO+N?=
 =?us-ascii?Q?ZdBvd4aGjWKpuddQYOjsw745sWZCKEqf0N97nl8XmHv7IaLKoz0s5B3OG8Kk?=
 =?us-ascii?Q?zffLS5YTamxMAOE/Y2Zawr3UDF413cWbiBiyi69IMG31UqhzEH8LixI+Ywpl?=
 =?us-ascii?Q?HL6DbcFJEMUGjGuREVtKB6Lpw9YOiQGgKT4jzkkYPrlOL0FAHPr/blDUDiKL?=
 =?us-ascii?Q?tPrS2dncEZHfA3fS/5sBRKyEox5kC0hPh4huuL3892EKyKVidN8LWwYW8TVl?=
 =?us-ascii?Q?+NKO50CzQjQVvYlu2xIahTKAPjhiMBSDXq03yFvGb6b1UHEFdUgmF23ZRZEr?=
 =?us-ascii?Q?UiGgahu2HoNKw6Vpwg77kmqce4tjq200ElCaaV7vy/qwwkymkaIXDB8QBNxS?=
 =?us-ascii?Q?54gVlQdBz77xW7Nz/eaDUAqzIeUxnhJQ2cuZbN5nU1j2G89lQMzzXsxbnl7C?=
 =?us-ascii?Q?qyKLMub3JS/yNS4K1HROULrQH0Qyc4Bl0vEFpNWDHBEMG3zAQTIxmNGAFfQI?=
 =?us-ascii?Q?B0GZv1oNOnHMONj/71DFdXdn0VSuyKPM6bXODO3iDPB48d2dnrWQSJ45Nxn7?=
 =?us-ascii?Q?yrz/ZPeIzT1oelOjbdxVLbznSxBudEhMLMtZ9fkOVhhAepEP6gV2OIFwpzek?=
 =?us-ascii?Q?XzO5To+LmjDLurIOAWMolj8ixu+Gbx7wvNeCYNiodl04rbv/0U+sBrFbNeuo?=
 =?us-ascii?Q?uVdrjLV25IdFZgV2gOze9bhJCwVZcPIuLEar1ikm/OpR6MHIAigDQjslC06d?=
 =?us-ascii?Q?HVkp+m7yfN0kAerDy0Z/JWNWD6PvZuGId3UBgdpNmrEDLIVgGKaYMoUiiM/v?=
 =?us-ascii?Q?6zEzU7RsMzF4GghEdbE5t80rvkhm8dRX9iL/XffnnsBdEHLjyAGBVNrUOoe3?=
 =?us-ascii?Q?DV9rqmjtA236DPW9VEZ4LbPVdWitIbzb6TdW5rmtAYBJ5pxqsKIsNwaLre++?=
 =?us-ascii?Q?b4MLPFF8LgXBeaWsdrkMKSCJJ+xwmAAtNPinKEIDIlOqtr2T1ZsGPTCdTZNr?=
 =?us-ascii?Q?0qwAtm3p3xOWGa9Ifrk0WRFk3rEhBfXzrSX98CeyqEwEQ5eyL1kP/SEDnxyD?=
 =?us-ascii?Q?SNyzLPqBNSA6R7ESFK5fXK2naK1gKBLkp6N/2VQcQEDJrE43n/zlWgUo1DO6?=
 =?us-ascii?Q?3UciOvjwucFyy3MpKYweUnRlJAWladuzjF0hcIi68JQ+PJoQ+kfxnlSOgffF?=
 =?us-ascii?Q?fjCJwL3xnDfH74FSVxm0w95ClPg16QXLSb+OTpeazSyT0KiQ9pJ+G7lAREZ1?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 171fec36-805b-403d-fe6a-08db5198a717
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:53:48.5269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y+HnJjAPKu5AhhsXvci4oyfskrNOe0JHyl/epiN9b0b/KteeOT9UBkz+sFY+pbi7D9oFC5z+3pml0dMoux9rqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

.adjphase expects a PHC to use an internal servo algorithm to correct the
provided phase offset target in the callback. Implementation of the
internal servo algorithm are defined by the individual devices.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
---
 Documentation/driver-api/ptp.rst | 17 +++++++++++++++++
 include/linux/ptp_clock_kernel.h |  6 ++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-api/ptp.rst b/Documentation/driver-api/ptp.rst
index 664838ae7776..c6ef41cf6130 100644
--- a/Documentation/driver-api/ptp.rst
+++ b/Documentation/driver-api/ptp.rst
@@ -73,6 +73,23 @@ Writing clock drivers
    class driver, since the lock may also be needed by the clock
    driver's interrupt service routine.
 
+PTP hardware clock requirements for '.adjphase'
+-----------------------------------------------
+
+   The 'struct ptp_clock_info' interface has a '.adjphase' function.
+   This function has a set of requirements from the PHC in order to be
+   implemented.
+
+     * The PHC implements a servo algorithm internally that is used to
+       correct the offset passed in the '.adjphase' call.
+     * When other PTP adjustment functions are called, the PHC servo
+       algorithm is disabled, and the frequency prior to the '.adjphase'
+       call is restored internally in the PHC.
+
+   **NOTE:** '.adjphase' is not a simple time adjustment functionality
+   that 'jumps' the PHC clock time based on the provided offset. It
+   should correct the offset provided using an internal algorithm.
+
 Supported hardware
 ==================
 
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index fdffa6a98d79..f8e8443a8b35 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -77,8 +77,10 @@ struct ptp_system_timestamp {
  *            nominal frequency in parts per million, but with a
  *            16 bit binary fractional field.
  *
- * @adjphase:  Adjusts the phase offset of the hardware clock.
- *             parameter delta: Desired change in nanoseconds.
+ * @adjphase:  Indicates that the PHC should use an internal servo
+ *             algorithm to correct the provided phase offset.
+ *             parameter delta: PHC servo phase adjustment target
+ *                              in nanoseconds.
  *
  * @adjtime:  Shifts the time of the hardware clock.
  *            parameter delta: Desired change in nanoseconds.
-- 
2.38.4


