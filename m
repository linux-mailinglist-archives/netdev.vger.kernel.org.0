Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4955FC7E4
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 17:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJLPBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 11:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiJLPBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 11:01:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD33B9794;
        Wed, 12 Oct 2022 08:01:35 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CE3rZ3012513;
        Wed, 12 Oct 2022 15:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=NruDWqu032l+1zZM/ZqGPMLZSRyKjeLXdv9M1SLrWiM=;
 b=du+Fqjnyjz/oQabcUdSt5wCQIUa6ipaMOt5csrfml1/g4/o3cMUuJX4AmKOLikDMHsYb
 GSK6BG3MI6lVtJmt6nDe9bUSOQwFvb7dcZVCCORmbXepa/ydlz6UzzBHXxDJlJQ4ltUW
 n0iHHUEND2Y4ecV6VMdbVwZ5b3XnuwIYg/CxmsCiZ3V54rlcngF3SVXX4TsHF/4/L6T9
 +471QYVUWHBGrfx7WZZsiNPD4rNp7X6HEPlqwnsGQ2zzrzfLzql9YZ+DAKwdO5tQ722W
 3rGRwr6OrGLDjuOyqQ5vBY4fbqq5jnrmLYSaGTHpBUKqmo35j0uH7srYqi+PDlmLr1Qa dw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k300329hk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 15:01:09 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29CEWuYs039350;
        Wed, 12 Oct 2022 15:01:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k2ynbgnkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 15:01:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDCgwv5vGldbzcuBPsaotqa6Zs/SzSwEcjwA9ap+H7tBKjWNZckFmpoTUu9JOnTLnjopQcNKQdpBhBBZPW/DdL2l8bUFdGzsroLJypX6HMgXbMT3Ji/myr3HtufhnEpwZMwiD5/i6u+Nx9MlAzMJL1ToMkTvDYkBrawBxPblFHdPy+MTdMrEV8qlNdFPaam69pgzYaAb2awStljxLL3c9LUReqtJK0Ylb3vwfFaFpjchXSocgGIhTSfX/lMaNVglqzE/VK3VPI+z1PcvMrFQLPzCJfd4JFCLoQyM0B+tBj2vaA8M8qmiT3Ljx7GxXHAVN6b853jFO2Od4JoRRXN8Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NruDWqu032l+1zZM/ZqGPMLZSRyKjeLXdv9M1SLrWiM=;
 b=cvieLuugSgKUvCCGHwvGEctNtiJEiCslhAEZ4vhF4jz3QD7evP7cTg7IaTkP0a/iXm9bCKdGmAxiCiSpshnSZiWVCTsaFitJkM2tB1OXFMG6hky6wfbRfLeLVFpJ1R5/zW09/RN8MJUmJt/2n0mIy00K5dWEOqCSX17wswERNuGNwlEnARz4Y5AMm/GDaBeq470PR9KrXpFDQnyZMHrWa+sE4G5r8VeEXtGFqcnZPHymRKFRQnrhIBvMandDriSxwk8YB334SqKWyXdKJEOxQ9JRTzi9nu2b606OJhGuTNIq9WPIDmsG/ebgpSF3b3QiJfC+TnKdF7ZniJKhMfHzUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NruDWqu032l+1zZM/ZqGPMLZSRyKjeLXdv9M1SLrWiM=;
 b=dDiRkpKboUWmPDrw9YBqxO6nvDlvYw0sqKBiUiq8iRHW3uipYfcpxVOURw5OwymKdjcRhaGNNHRjUgnQ2zwfhXAOIgnrR1Mu9+eep/9PQrAKK3b9Vco9pHN+WkXDBOCkgJErCAPcoz4STECDy7M2AnQJ0smXGfyU6HvwcUIaITk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by PH0PR10MB5682.namprd10.prod.outlook.com
 (2603:10b6:510:147::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 15:01:06 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Wed, 12 Oct 2022
 15:01:06 +0000
Date:   Wed, 12 Oct 2022 18:00:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Taras Chornyi <tchornyi@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: marvell: prestera: fix a couple NULL vs IS_ERR()
 checks
Message-ID: <Y0bWq+7DoKK465z8@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: LO4P265CA0023.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|PH0PR10MB5682:EE_
X-MS-Office365-Filtering-Correlation-Id: 28e98b53-5d84-45a7-e424-08daac6296a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xI8hoc2LqUby86MEo9y1wyE+eM/0SGfg6L8J52y65SLmx0XkoLGGrzxYo77OZVXBR1k7lN6OP2byM3IpScLjV5jFNBeVIbfMzlAeGapzzIhw3j4KhJ0+1ATsdr8SX6af4rCTqY2fjaXM0raRJNRNC4CJMIIfx5ldJJpQbM7WNF1V9OZ4wT4arfrMhozstbzyfLAccdAK1yn6fE2tMHYsKZo8GEG6z6S+OraNu10l4J9Ufal4nzFOjTyn9TaemYdm4AqkyKeNHC1WGnrItK2UhWkd6cn+BuSLfecZVH+U96T66LbhAKHyXdbhZejdgpRwdHY0lug5c56eiDgIMAoFv1IA7JDVNWX1ie1BuPmI945zKxP2rpjU7zIeyU9eKplBcSHxe8WnocLnzLhsPm72lmQbJzKfSezwLJiO14/J69id2HMvFmDtfG9v8g4LIRpEO3i7dEigpfs4vhQ9BaKi+lWFNgkuvenp0f4l/R/Ff5qN/rGznVC4dJCybi5hf3az6vVIWWRypJhCbvSHCY8xHf7ACYjKAt6seVupAq3ox6v9H3+W0F5c+otpmvT4EESrqiderIFl8AJFV0I4uMJqEwCYmtDMiC4vaa23G3RQcL1Ml4S3IbWBAan7jznXMCtrRFfSA4coRi94gwwzL6kbJQxivYaH/2KIui5UUUVwv64Z88hcmey1Dow2mRQHNQ626wHKej6UdqjcdSWepk3YqGezBxfaGxks4Fv3zcKP4/oznT4XycWiwVKQNum80eJy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199015)(6666004)(5660300002)(8936002)(6512007)(54906003)(26005)(6506007)(9686003)(44832011)(186003)(2906002)(316002)(83380400001)(33716001)(478600001)(41300700001)(110136005)(66556008)(8676002)(86362001)(66476007)(66574015)(38100700002)(66946007)(6486002)(4326008)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uXAEc70U6wUrwObYw9l1GxMI4J3RSgyFhEbmgTnw9bip/RFzu/rvNRMwVK50?=
 =?us-ascii?Q?BnOeX1leRU+Q1vYM8BpPMmLzI5EEo3mDe3uim/t+MAHJdooXOSbAVAOh34SI?=
 =?us-ascii?Q?wZSDJjXMVyZbooxSnN5VSucyQvbaVA6sl9EDGiMo0oFEdWd44Tz9aZ9krACZ?=
 =?us-ascii?Q?SJDJyLNwAQmwb+Cytw2/Grw409nCSRi2bWeYMwJd9xv+CQamC9Nz5i+4ekbe?=
 =?us-ascii?Q?pU0kPAIPlTgULQAkUsDu9fjfG9Mblzw0CSVuJ2z0tW+jBuXUxngvFlKwiRXO?=
 =?us-ascii?Q?blXDNRBieHvWK3+JwteREHNzLqL0hJjTdkocnYTZnHLFKtxvQTSfQ4madMTy?=
 =?us-ascii?Q?F3mwHhbToxO2TP9Y+eIKoPYr/fgmAyY5yCl4a4DVNaz7fmbWo56/DfNJai4r?=
 =?us-ascii?Q?9Rqwuhoia7j7QY9uDGI72KoQ/xz4/GV+gXMgdEluRFVq//3nJ25MSBoHVpyR?=
 =?us-ascii?Q?tQa2A+JKYSHFZLaJrpr66M7TmZ9OkD3M+I5xSUaNIhI9eoFogwKtGjOJhd70?=
 =?us-ascii?Q?QacSNIWI88Am5EeJWHJNJbP3LBlwkCiWBn4wWdLroc2PxG36Wqz09UKxL5nH?=
 =?us-ascii?Q?Vz0nE3eaAhngtWsTyi/TX2xJC8JokH5q6RoaP6H4toS67ek/AQmCjZzXXoep?=
 =?us-ascii?Q?3NblckDlytb6kFWokcLhwe5othv6aO/7HMNLZYXT9aG/CuufGo20tri2/Gy9?=
 =?us-ascii?Q?RvxJOXgcM2mcGaoGfP6L62IrqG+aF7ZV5nREtlBCMzPj9HirAncjWpUL2Yui?=
 =?us-ascii?Q?gmsqrvZjBfAtGxeI7R4K2Abk/Ezi9/odrTKyK0u+e/PhY2VYxc8b30dOHLrW?=
 =?us-ascii?Q?1VuCohVxWLgZfr02LXmI0kRJ688P0fxbO0jz2V6pmorXgJSBb76peK5XKucV?=
 =?us-ascii?Q?48LWuaKnfvBG3aaCa5EOxsL0u661LhZ9OuoQcQLIBAV0ptpkWpRAUsfI9vqy?=
 =?us-ascii?Q?Z6DS5FU0x+6t4Fsw+j9u9f9jpwL4opTdq/D1YQAKq8zJvUHhIw4ePk9wdOhU?=
 =?us-ascii?Q?8WjKajz0B12rPlSy5YpLzr7I6ScNrcyN6M+5eB/UXbtF6IDNa1HKwYT5cPfQ?=
 =?us-ascii?Q?6yQp4lWrPe3XjNaHoquQ6WWZAZ+lGvk7e7vi/QVYrQ2XEB6ff08d5kpL8jsE?=
 =?us-ascii?Q?abSEsP89jihFRgnpd18RqGJFKcF5uyuDAOfXCzLr+Zk/b3RkMn50WPcrin1W?=
 =?us-ascii?Q?/ULHNvjnsk/DV9jMlySU2PyaofYrQTSVPc3YCHMT8HYKgwOw3qJUOVlX+BEH?=
 =?us-ascii?Q?FXv+Pfov+xmvGej/gGq5Pg2c0uJxgJolChlTCY+gfMZam7nSQFQyH+PTjPwe?=
 =?us-ascii?Q?nA4OS1ZmAffRLH2k06y28iOGy0HNDY1FZpbkooAxrAOuFzt50GbfqfbooDXm?=
 =?us-ascii?Q?XMp8s9gh05BZ/5mPiNSQVNBfUdoZ+YcufAjg6dIFgLoMG50YibBhkmg7tkeR?=
 =?us-ascii?Q?3n9uMRKi06uYpxugxCH3G1mEq2oQrbApyK4bx2wsvoLxA3Zu63KORNZiWRcp?=
 =?us-ascii?Q?zwugrdU3qPHbaX2H1tc/R2O4s1ydOqej8KwmZzrfbPwS2sF1UM3oI9m0WTxR?=
 =?us-ascii?Q?PdBDPpQ+J5uwhc855ewK4QWP4AWZwqU8agLz4lxbh+iMXw8cCOFe5946zWuo?=
 =?us-ascii?Q?fA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28e98b53-5d84-45a7-e424-08daac6296a7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 15:01:06.3516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U60Tmg3jJhHCWVIyZvp1EuSwj7tm5bKk9fdFZN68T/fK9+egsa3LRYge8M+ZbO/asZwDWscCy2dtlKXbG/jrIpNQxb1t1XUlaPAa6zybQzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5682
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_07,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120099
X-Proofpoint-ORIG-GUID: ZciKIMd5HJQ1gr7j5VVN9OvSJnuLPQUc
X-Proofpoint-GUID: ZciKIMd5HJQ1gr7j5VVN9OvSJnuLPQUc
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The __prestera_nexthop_group_create() function returns NULL on error
and the prestera_nexthop_group_get() returns error pointers.  Fix these
two checks.

Fixes: 0a23ae237171 ("net: marvell: prestera: Add router nexthops ABI")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_router_hw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
index 4f65df0ae5e8..aa080dc57ff0 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
@@ -498,8 +498,8 @@ prestera_nexthop_group_get(struct prestera_switch *sw,
 		refcount_inc(&nh_grp->refcount);
 	} else {
 		nh_grp = __prestera_nexthop_group_create(sw, key);
-		if (IS_ERR(nh_grp))
-			return ERR_CAST(nh_grp);
+		if (!nh_grp)
+			return ERR_PTR(-ENOMEM);
 
 		refcount_set(&nh_grp->refcount, 1);
 	}
@@ -651,7 +651,7 @@ prestera_fib_node_create(struct prestera_switch *sw,
 	case PRESTERA_FIB_TYPE_UC_NH:
 		fib_node->info.nh_grp = prestera_nexthop_group_get(sw,
 								   nh_grp_key);
-		if (!fib_node->info.nh_grp)
+		if (IS_ERR(fib_node->info.nh_grp))
 			goto err_nh_grp_get;
 
 		grp_id = fib_node->info.nh_grp->grp_id;
-- 
2.35.1

