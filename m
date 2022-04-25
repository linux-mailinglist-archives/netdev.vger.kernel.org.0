Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF0850D7DD
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 05:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240856AbiDYDuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 23:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240689AbiDYDt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 23:49:57 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2086.outbound.protection.outlook.com [40.107.212.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BDEE0A3
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 20:46:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGKh55XlnlCsJH84bCfnvTV3DA6dr/sTrlmJLrL9jKO+oVDjFPccfnYddq6/5KmSDS6p24KB4uax7WNab8EXGiBkeJTIo/Dw59245qDTayYyC1KdfCLC4JuqQoLazRjdpxla6NoGwtLmO/6vBKovCC5NXXv8Nn2ZnqEn2x7OVJ/JjU3fBkR2Wp3OJH0oXlkLWniMtfD78FKBqR/9zsZTGAJWbU5iooUIk4cr3oJsH1nuDP8LW9XIBSSV5A6FAOn7+KtaAG6JLDg7afknYoCJ6/91GUYTo9TrakF44jSHxd8TwXcyrsvv47WbFsamA0uNy2fi4im0ensPEu6ZQXKx+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aysSTa+oHbqsyemPQnm4QtIeH9JQS2CS56tD6nIBd+k=;
 b=CPngSxwBTOWaAnqEH5zlPzSCKoJ/IfYhOpupfaRALfNkQ+nRy6cVed89k+KczcSL/WIDz/2PhZRhvRn8Eqs187ZpCNkkn5NN/x8u2qJ2fH0RNgUz9PXkEHRTwaOAUh93IxGRcm5AlD6kNU8u/oYk8zno0d8Hr1xImoR1PuQVxS0DK005WVQ5YXHw5TSstNVX+0+C25TQmD37n94rx4kc3KARJmAoe2vHw5h0lfwTzvA8NMJU+e+2n0xH7+OFBApcGBm7j2M9L//srNSJXIgKSrbfb2kASHRWeNHEpbj8IcsUdxEc47t867VitYAAYCvayLxYU6hqm5b72jyfpq7Y7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aysSTa+oHbqsyemPQnm4QtIeH9JQS2CS56tD6nIBd+k=;
 b=nR1LprGXIOfwvcv7lD72jeMSI4uFfbRsm0JJYAZeJloUH+ogWz2F7qnyt879sfXEaQuGjlBpnOjaldgOQQ/xEvn66FyF/k93Y/mYVEXxh78nmUbbU7KZP11DPGy6AYBKmK0pxum7Ef2/GEOt22P568uKnRqdO/q3WGHTIB2LEhzYFP40AtA1I9TDFvBNJKWWPMf2vMdzhaopRSs0GQwZG73dyLdgemazsJSV1Zd8Q5ge03g1ieWutUttdEjHJsohV7+RY94tneu6xx7QWgDrzud8dJ8n/hbfxEwq73gArHSGUUmXhuVHPpH+dqGI50ga5blNygVohHre7On2IuuQ0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MWHPR1201MB0255.namprd12.prod.outlook.com (2603:10b6:301:4f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 03:46:13 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%6]) with mapi id 15.20.5186.021; Mon, 25 Apr 2022
 03:46:13 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/11] selftests: mlxsw: Check line card info on provisioned line card
Date:   Mon, 25 Apr 2022 06:44:28 +0300
Message-Id: <20220425034431.3161260-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220425034431.3161260-1-idosch@nvidia.com>
References: <20220425034431.3161260-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0262.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::29) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69f8580e-bc38-4840-0513-08da266e24ff
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0255:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0255BA37D455FD9DB40CF599B2F89@MWHPR1201MB0255.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3a1bjiItnjmzAM5vg+elBngUUsxXAvmtkzofD2tJp3GVyOrMBZrUHYDEfvCMfwMSkROGFzSePMjosYjaAIhYcjyRksEs1otBeKwhyrGOteyEu/wUZAueSKsLkG/b74Pxpp6fIz7MsGlCgFQiBfrKne1aehZ0dX/J4qj2VOB2glfywxhGV99rFPeZmpJ3vIdmpf+0nBbZjQ2hDqLxFG4gr6sY2uSzbm4q+8ZfuD6y6RcWYIg4wAm9ThRwrXF7oxVEhWinQSHy+B8WJsA+NkiY9h3HPyEETF+0KeKlfm386sBc2tsuReE5czrbNvCY2I0qRTLqfgNFJMKAyDPUVVZ1iMASpmKR6rReX7dcU/Ad1/luz43Vav9e4vzJmwfvscwzYQTO2r8Q4fpZ7Jf+K2GY6EiqPneRbd4W+LYlPeR8W3GFFzxks/uG7tGg0Mdlt1jFLQ1TRDRODx/+fA9TwqCmZTnT3eIIyh4iaYC4rb8BunMV2iG03Q3p+tVg0YZaSrgUTCe7LMTTNXA8KiSvVl24Nbi3YHdkjIyBuO+BdqwiTtO1ERkpKluaLUkNt2f4sLEQHWVQomZqiux4WM1zYnHama5+tuCVhLfyIcopO0OrcpHX4BUmn5OgA/n6UfZ6/6vkKAVQhESKgDEICjmhJbxtOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(316002)(6486002)(508600001)(8676002)(66556008)(66476007)(86362001)(6916009)(38100700002)(66946007)(5660300002)(6666004)(6506007)(2906002)(36756003)(6512007)(26005)(186003)(8936002)(2616005)(1076003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tTIXBvisj3uKKnyboZZxIH8GAJGHpQcIORYtEtIbdFy8rkDI8QM21d3i94IM?=
 =?us-ascii?Q?tvP2H2JfGcf0f8Dy1Y0Q5FbJxuvWke37o9j20uMBsOC2ZtBzwRkx/SMfngPC?=
 =?us-ascii?Q?9COi6tVMhEXlAsPw2/9PTtyo+yd9fsAhb8vc4kT8BCH0e0AGhnmspJGWp6a8?=
 =?us-ascii?Q?F4jMb3hRjyRsbfHZ6sJyhCFwYQud+4th9S5OBfZtDDB0ImF7hWxU3ra08glx?=
 =?us-ascii?Q?IfViOHLuKJRYjgZ40NGDoFOWajrvS0W2xqYLlq7OJ0wU33nuMLoqvOgGeZLw?=
 =?us-ascii?Q?AjfQsncKXowqn/HbUJnP+ERAJ6bi/IlMW8CDUixnIRPJaK8vM+7DQ0nEushE?=
 =?us-ascii?Q?Cc0akE7zWQSsSBcwOn73N9jk2o1eiK1gZzZLqZGotpovtXVbfUp5l9JYMeSd?=
 =?us-ascii?Q?d7xUhKzoPb3PUm7cgSpbbb10w+KiIiLQcO8SLkhGTdMWoF/gLKAteDKKtcTx?=
 =?us-ascii?Q?iUP61JTSVkg1kj+MI3ZXCE9HMbBmfGDpy7ovF6d/ZwwZRZgLMt6QtGyvDcw4?=
 =?us-ascii?Q?XVh1TTdT+jl1W3C+QmpHlUqKaAqEV/oJYLSBtKMls9le/19znjhkbNGSxCGG?=
 =?us-ascii?Q?VEdb1ggoHYxcy2vxd1M+Ev83KRLfk+MPRG+obwEG+shZ4RSoxSaQvFIULcmA?=
 =?us-ascii?Q?oRrZcChfnjqgtNW1oFbFU1SQU5Wi5wCS/e7ZGWSioVDZQxWrc0o7Es5uTYbB?=
 =?us-ascii?Q?/z9GPnKGaEtfNe0sPs9L9I3vdMEsHg9rNimsf2OVD3QyzMrJs7eoKzIMJ3Bw?=
 =?us-ascii?Q?QBywcVbqdDBbY+q2SFB79ilpyrYWnp/xJ7Bpgv3ni5ckZe0Ymoyunxlq9XaY?=
 =?us-ascii?Q?b/8GDaj+CJ8gkRdiU6E6wYyahKSZXRUwvTzWWLwZVw4iaFi8o78jBN8TtN6m?=
 =?us-ascii?Q?2SXqzu46/tQ4qfkZQAPpl54AFweypwSMYvmQXD6XMVDumfvtR+YHoKa7mKFA?=
 =?us-ascii?Q?q+lelIpmV+uHJPU7kU7ToaYIrAkWI0crJfFej46R4faoDI0KzuoU9pSaYwiB?=
 =?us-ascii?Q?bKdQHE2n84f7BkS7ivEOyEBb6N/lANW9mKwGj9OtUyoMSy7dkZwJZKJ8TajG?=
 =?us-ascii?Q?i0mD/I1s5mhJVYd33/iSmE94MUa47yoImqpKA+9LAf1WutKg7psReFofQWNn?=
 =?us-ascii?Q?3wmPhnctYsPWBjVWv+iv5/Tjfa1oh1MRKv+DOwFqDDPbCTfYDHQHir29uPgn?=
 =?us-ascii?Q?/weMA/igUxEgHzsbDcJdOB6Wq6ruw6Lfp8d6lUn5IdwcCPL/1OgGlbjsGfaT?=
 =?us-ascii?Q?eYXMwnWZlDzVV7p3eh9FT37/PPmfUe+/j8aWolKrxiMICuEQbsT2TNtRQLuH?=
 =?us-ascii?Q?1l+l2z8XXDioDHiQ/PIjaICFIOCPbb32O4qoWsldasDUc/lZ0F6Owqn8SnBu?=
 =?us-ascii?Q?TgVhuhdhO1H9LH+eeNbKv0i8cjcEJcVVzRs3fxnL4BQrG2wMS1AlAfQ+2OBz?=
 =?us-ascii?Q?G0Tv72LN2+fOU4zjHJrdUaFYhNbG12EzSZnKqvdDXVMv4DRTvN0gv/yVqtan?=
 =?us-ascii?Q?U5B7rnfDDO2nRuZ9+c/zBNRv61ze/it4GdxsduLy13W6D1DFh1jmnLuiXHG5?=
 =?us-ascii?Q?BHSQdbd9NQY/PS/oQO2DoTKmv/0Y9qGyoWA7Vcksin9K0r1lbE747zXrLn4Q?=
 =?us-ascii?Q?GnZMgifVRto4hiduKz8p/ju5xDwbZsXAhsYrcvHLP3OiojevoAHoHqEtRA6F?=
 =?us-ascii?Q?tTJiRxovuAWc2IN4fyYGtYex8d6h/dLL1yT9IjJZo7+w7wdoxmvgh0nvc/3h?=
 =?us-ascii?Q?NId/B7xKVA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f8580e-bc38-4840-0513-08da266e24ff
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 03:46:13.7640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UDvahSaRNiQmqCpnnwB6D0q+JfwY5zCmBjCn8p8zLjJob/jJWledhHc9Tg1JcSRTMKNQq4pUhPdwxw3s3XQSmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0255
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Once line card is provisioned, check if HW revision and INI version
are exposed.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/devlink_linecard.sh       | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
index 67b0e56cb413..04bedd98eb8b 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_linecard.sh
@@ -178,6 +178,22 @@ supported_types_check()
 	check_err $? "16X100G not found between supported types of linecard $lc"
 }
 
+lc_info_check()
+{
+	local lc=$1
+	local fixed_hw_revision
+	local running_ini_version
+
+	fixed_hw_revision=$(devlink lc -v info $DEVLINK_DEV lc $lc -j | \
+			    jq -e -r '.[][][].versions.fixed."hw.revision"')
+	check_err $? "Failed to get linecard $lc fixed.hw.revision"
+	log_info "Linecard $lc fixed.hw.revision: \"$fixed_hw_revision\""
+	running_ini_version=$(devlink lc -v info $DEVLINK_DEV lc $lc -j | \
+			      jq -e -r '.[][][].versions.running."ini.version"')
+	check_err $? "Failed to get linecard $lc running.ini.version"
+	log_info "Linecard $lc running.ini.version: \"$running_ini_version\""
+}
+
 lc_devices_check()
 {
 	local lc=$1
@@ -228,6 +244,7 @@ provision_test()
 	fi
 	provision_one $lc $LC_16X100G_TYPE
 	lc_devices_check $lc $LC_16X100G_DEVICE_COUNT
+	lc_info_check $lc
 	ports_check $lc $LC_16X100G_PORT_COUNT
 	log_test "Provision"
 }
-- 
2.33.1

