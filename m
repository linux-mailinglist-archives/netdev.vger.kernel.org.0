Return-Path: <netdev+bounces-3086-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDB9170565E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:51:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 513CF1C20AEB
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D95290EC;
	Tue, 16 May 2023 18:51:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220ED187E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 18:51:24 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6884A25D;
	Tue, 16 May 2023 11:51:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2fLaCgXNNCBFIOX95yzrFxBbTYFgj+n3eGOiytnKxiR9Mo54oQXLGIrGhLBgCiMIH8iPg6ApFdv0uGODeEwyXg3qrt8Pb6RMoHjaQXsPIj2ogxGqS3LlaqqzhZRQZNMSc9ssULxS8VixAJ0rsePQzEfMZG+DRoTfyxP4ejRic89xBzbHsVLaOYKFA87naUctOsrwqlVANJXQ/L8lcgVM1+bUPDF8L4VrR0BM7EbZclSv/Ngu0Mj01JA8rADW5BYZ4u9191gj/J1bDAQDyBckyQCuNSvBpkwNtvTk9/O8jDK1+cyfsJT9AjdnP3+9ITUizaN+scM8XUHBbiTqNLBRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0eVPkCqJvqORf2uTwnoPSrDUxXoyQAa2Q/sK+x4fN0Y=;
 b=a9YrNhdIrPLFtukWLT8pOYduAQ/9aHyTQ1fxlj+p2Xe+dkFbPvGGWdRZwlYH48BvWniU7qW6CKwYZcnmthkFMW3oWAaojrP7lpODxhCl/IhLWxcDVpYsbPEXIJvpx92WMnGLVZTd7msWE+m0FKqP3Uw0QiP8EQjIA7EppIxvI1ZDp8pspZCesytIGW+9PwqzRxdiTZRAeEOD5Ym7O/vci+nNCEixYFqxi1aBNM/Uxv/TOmM92E7l1rTp3svm23Ba7kigzFW9TYXlM7fCn36U+7YKKFkVnYFBpEv/8eGp7wQPuYDq3jgnyfOxUeB1WazpjbsVOIaMfvJN/QnHrIyHrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0eVPkCqJvqORf2uTwnoPSrDUxXoyQAa2Q/sK+x4fN0Y=;
 b=fFozaJsCQLvlfr5r/Gm70o/nR6Xxg349LIDPS5VNttXBhi261SUlOiA0fhnWbgL6rUyEqd5MQhvG1FjOQcR0qUeKXCpeGVsrEleHLgtVhT3qHUoPCMJItSTsw4wBN4fKEFPya3f+gyn4pVCGvIGw/KkPPMjCg21cZS+Aik1Y/wIrxbhCKZ8kvJuvCL+/2oFd0GKRIdmyLiW0EkPO7YD54KKJchZWTFA61wZHxZ164UmpLEOYlXnVsSDTY/gUdZRcQOqs8dLUCV3gKMfdqJ+zyPds+Q6dmCpEB5E6u4HwknT+pTsSbflANK1cVU/82t1O/3D++wnFDmSFbuBg83wTJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by BY5PR12MB4901.namprd12.prod.outlook.com (2603:10b6:a03:1c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 18:51:20 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::5586:8b8c:1925:1e81]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::5586:8b8c:1925:1e81%4]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 18:51:20 +0000
From: Benjamin Poirier <bpoirier@nvidia.com>
To: netdev@vger.kernel.org
Cc: Amit Cohen <amcohen@nvidia.com>,
	linux-kselftest@vger.kernel.org,
	Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] net: selftests: Fix optstring
Date: Tue, 16 May 2023 14:49:24 -0400
Message-Id: <20230516184924.153498-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.40.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0188.namprd05.prod.outlook.com
 (2603:10b6:a03:330::13) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|BY5PR12MB4901:EE_
X-MS-Office365-Filtering-Correlation-Id: a3004e39-ab1d-4c15-4732-08db563e8931
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ny2TIoZ1hsCFiIrnDHdCPJPYj02MqmIcQzcqkYwJfvBRqn5Gyyon1LjDgWOMNrgCjiZTn4duju1JW+wHXD/NtCc8s90gFV2Gyo1sizNqCQjU076LOj6keTfMp7A5yAvhN5P59/lGLNwqDCo/jjQPTWP8DL4St4F7sbEuErX3KKzV1O6nVleWqQ1DE3BDMNywpJ78dd/0FYqosz61qdUfJ4CR2xSp9YHW1ZwXUG3zVCndrJXUbZxye8MC/BkkCmG8ZlUpgj8XUJAA/2KEYb1kphDgYAfvCL4ahY7ElOHc/taKnu+VWSccLq8M9TNLmqbFCQYUIrLUDkHLxphYj0awnvUoOwyICSMIZDhH/551gcHOO+0Z9YS04n2ZckV620BnPG9jHD3UPPIVAlghpaeZd0YA983dIGzX8tyg+mokt/2BgwGa251gXTm/DavCe/ABSZwL8hJBmjaBz5sFJo4xSipeETL8UlIsxMd6/wQQTmdB1TZhQ8b50reai2xzvBsRTeK46cUxqvcgSG5HnBndt5fKvLdY/tE6/v5/0dzNXfGPoI9Cs7WUM2GNz2j1pVaG
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199021)(36756003)(6486002)(83380400001)(107886003)(1076003)(6506007)(6512007)(26005)(186003)(2616005)(5660300002)(54906003)(86362001)(41300700001)(450100002)(316002)(38100700002)(66476007)(66946007)(8936002)(8676002)(66556008)(6916009)(4744005)(478600001)(4326008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xVvrd9I+McswoUZyJK3AQ0QTbr7oyHLXUui+QK6fKTD/rs0hd0UAC9aOizzI?=
 =?us-ascii?Q?P5+fNlEihuJ4zvXaFuhR829ddK8/jZsiSZqXZPrdN9MPAQg+Sw1lej6TlNcY?=
 =?us-ascii?Q?gLuQ0t0NooDrH7aL6Q/4CDAati0FilPHop9tAWqRjN6+S38NI/V5NSFwZrTv?=
 =?us-ascii?Q?0R8evTeut3xKkAeM+zdTzdu0d+fy13tSnWAB5pyT23LNtbhfsiAdnkCsVuBQ?=
 =?us-ascii?Q?gIuLWnQYQMpH6S8Q66RN5q1ePLbV1aZ7gqPV3hMLje+UsXb1eVbYTZ1sOh/t?=
 =?us-ascii?Q?fLoTSTyMRqZoXolVY3jZTPulALBzkJYQSe7pJmsuEY8vrPMxWTE2WtWJ92Qj?=
 =?us-ascii?Q?HvDE3MBJWFB0jKzOWx5Nw6MHh3g1KC9/ZUiTPEiH9oDz4nyxwX7L7YzIIqhV?=
 =?us-ascii?Q?JMVejIfVpQF/Ue71LqoLJ/ezSM05FI3BNNzYeTWN/F6Zvgvj0Orw2RY/Bokt?=
 =?us-ascii?Q?yEVV/lWeO55ekg/MzOuQjtQqeGjYgpLNoBD01hIPqup8UmuYaBen2AdfHPkn?=
 =?us-ascii?Q?tWIBQ1liriZt9N5NrhVhXxng8h7Onkc+DyQBeFG1UH0gzz4bZxQS9qmh5nXN?=
 =?us-ascii?Q?XVtjrR3hfOWcc7cdjlDjBZKIoy5fOhVP4ZffJOpG6tlqrPZi8s+03SVT/nkX?=
 =?us-ascii?Q?1TQnwRIKp6ih68zdXa54iSnDp5UVRlt+sW7YfNqC8g9ZBXDjSRv+re+fcPiJ?=
 =?us-ascii?Q?7wDDUGOudv+44y3NcbJJTNeli8uOMmubyyuiCjDmD4JGdjtzPShrZwCXDxO6?=
 =?us-ascii?Q?cLId8heAO4ZWt6zx/B12I78HzkcBJRiGyXp+kWaOpQciwaBLzbMyC5vjxpgZ?=
 =?us-ascii?Q?n3/skGynoND82XAivY/Ua1mw8ASVK7WciuJD2J/6/9sOpIpSMbwPrpr2+L3g?=
 =?us-ascii?Q?GX2m75/UJcjxFAdt4BhYuNoeX0vXqHHjk6kOACIxTi4dU6zN4b3vdpFkwpLi?=
 =?us-ascii?Q?BZZcd+Mj7hvC9z8Syq97mbti1jCNFftB5cTrPn1D4gpGaAc90w3uYGoUfkSj?=
 =?us-ascii?Q?hj3JEGWr/y3eAr+FmtfOeaOGragtLL0GO4itWxNeMAKlEWgaFGpF5/V1cvM7?=
 =?us-ascii?Q?wrdi1D5aOQO+UR2qOh4GUhvNCenHnMfgwWZcavEilQ19D2s3etxkHmce3w7r?=
 =?us-ascii?Q?uSRS60ADOKhaAn5ZSvvHtK0Es1kXcIibP8KZzQHvmycoBsBaHaIv+ONVndZz?=
 =?us-ascii?Q?AukPYK7DGqAZ0wLbmO0pJWYrlAGfUkkAu4t2kCiS4YDZwcJSa9loBEfMi6n7?=
 =?us-ascii?Q?KI9ZOxrpLzn4k5bzdRYhmACtgvFEMBwRohAyMaKxZmB82NJEUiDw5YSXKyjz?=
 =?us-ascii?Q?k6IYvNbn79r4GZG1qgTU6enJssJ5hnI8wLxKVI/ZF3PuzGVL8aPh+dv+xa/+?=
 =?us-ascii?Q?EV5Ft4Sj6kmZC8qHicvlbs5DrQ56d3izkgHpEdfHgxbrWA/ZGIsbM3st7eIS?=
 =?us-ascii?Q?WU3wvQUFV3TxpMWnHip3ZL5q8oFLunSRdB4UHs73zs7l8toZPWAlLG692Q3e?=
 =?us-ascii?Q?YqAjGdn+vmK+cpaOY1xlkjejJ2Mbi2LN2RB9FNAzcNtMIad8XqkU3ZWbRLma?=
 =?us-ascii?Q?s0vJzYxWuwOrD7oW8mBgtra7sV86UH/Fqt2Xq5QM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3004e39-ab1d-4c15-4732-08db563e8931
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 18:51:20.2065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cWoITr4nfyKxl2PoEtRGJyWqZE956B7v00alXcJ0ZV7MR3kT+8AkTOSCy3J4QekeZ2C7ioLuBG8Rc5I0RU/qrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4901
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The cited commit added a stray colon to the 'v' option. That makes the
option work incorrectly.

ex:
tools/testing/selftests/net# ./fib_nexthops.sh -v
(should enable verbose mode, instead it shows help text due to missing arg)

Fixes: 5feba4727395 ("selftests: fib_nexthops: Make ping timeout configurable")
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index a47b26ab48f2..0f5e88c8f4ff 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -2283,7 +2283,7 @@ EOF
 ################################################################################
 # main
 
-while getopts :t:pP46hv:w: o
+while getopts :t:pP46hvw: o
 do
 	case $o in
 		t) TESTS=$OPTARG;;
-- 
2.40.1


