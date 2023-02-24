Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966A06A1E39
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjBXPMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjBXPMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:12:00 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E066CF06;
        Fri, 24 Feb 2023 07:11:30 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OEo1d5012033;
        Fri, 24 Feb 2023 15:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=KRrwQzlt5aRkpr/mL7CMLdUB9E29iFH9PIP+6PHbgtI=;
 b=Vq37TjQGSX7zf1euOjf2sd5+DWrOWVcPj50sphlLz0oSXnkDL6yne28SRuM0I3/lXGxn
 H3do7u/k+r4JaPcbWc9yG3bg6C9piVHHZAswjCdZVX0wpCKUKMvB+jK5To/DBWLxF3jT
 RLe/pmc6sdMCZLveNPNlI0Eb5aY/oEHV8lSIrj3YQle44VSltKiusCnI4rTz/w6QwmE9
 xpiafbMYLIuqBqy90oYBelowAPn34HBc295jFusPRyQKAQwkziWmzzEyCRpt+bWZcXMx
 SXSGNGal8/ERCjUnGb2oIA9heviyy2obPuXvyy1r5WdB5l/BPrioLfD3MDEPIR73DDtN fQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpjad82u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 15:10:31 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31ODVvm9030210;
        Fri, 24 Feb 2023 15:10:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn49kyca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 15:10:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IbqIo5dx5bqQOxcHPVjHbL9bSjhOud2ACce8LKoG5NSLDHbeYGPVcipb31SKrCikest8OIxw/giU01hZt2Jdx75pZz92Km1g7gKJ5FRoL9Lo75HTvdcVvAJgAahMfEXmed8EDEDZpgN/CcukcPciRrZgWlPRCZ8zIWiwHj/2tXQKsiDRTL1q2JU6kMDouY9oYFIhV1bqIBCJaHnTc+KbTL/JR4mMO4nQzgxhFb1int7/wPRb74ctcr0yemxXUZ+AJZF//lFSi41ZGbNImYPtyvxIi+WT3d8jYjJ4I1v+IB8X34T1X0gz8pXyCIrXFgIcEVwfBQ11Psr2YCfxet/Fgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KRrwQzlt5aRkpr/mL7CMLdUB9E29iFH9PIP+6PHbgtI=;
 b=EJNmkNZdCQXV7RBdRp0kfnoinuFO5Q7PW/GLrKFi12nFOz9eOtqb/ouhCfvOoyOZxl68IqJEaeVhSDrGnoQcGQar8d01dvfN75p/13GisO+3EguXZ+UT5FrG2ykxVLiceCHJPyvuhdBVuCoLlcYsBNrsFyPRTiCOSqdyS8WxsedUvIcfry+JsOXWnC602NaMQw9zujqsZRH1VVf4ZqAL3PoR+lieuJX5mGKptzWE8RmCKUfewPpKECXYLWN69+78LcQ4MJiT9w1PBU5wN78n++D/E5Y/J4wrfX6tqAi3pQSA0HoMDSvO/jJZHLUbmtKXcH1ancL9XJzElSVppwIsTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KRrwQzlt5aRkpr/mL7CMLdUB9E29iFH9PIP+6PHbgtI=;
 b=v4tzOPcCMApWYn7UHJeZJL2qxihRSixR3koBTE4mdZ7/JwFMMHU6PdxbNd74frMPvRzzEUFG55c05toVcKJFjMZSoJ2LE20PvZQq63cmjxfEQIt5jS5UGFiggyx84joygqq0fKgbrv42gBW8ze5+edB7ZKuWJATnoJfa1EreCc4=
Received: from DS0PR10MB6798.namprd10.prod.outlook.com (2603:10b6:8:13c::20)
 by SJ0PR10MB6424.namprd10.prod.outlook.com (2603:10b6:a03:44e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 15:10:28 +0000
Received: from DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::d0f7:e4fd:bd4:b760]) by DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::d0f7:e4fd:bd4:b760%3]) with mapi id 15.20.6134.019; Fri, 24 Feb 2023
 15:10:28 +0000
From:   Nick Alcock <nick.alcock@oracle.com>
To:     mcgrof@kernel.org
Cc:     linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 27/27] lib: packing: remove MODULE_LICENSE in non-modules
Date:   Fri, 24 Feb 2023 15:08:11 +0000
Message-Id: <20230224150811.80316-28-nick.alcock@oracle.com>
X-Mailer: git-send-email 2.39.1.268.g9de2f9a303
In-Reply-To: <20230224150811.80316-1-nick.alcock@oracle.com>
References: <20230224150811.80316-1-nick.alcock@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0396.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::23) To DS0PR10MB6798.namprd10.prod.outlook.com
 (2603:10b6:8:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB6798:EE_|SJ0PR10MB6424:EE_
X-MS-Office365-Filtering-Correlation-Id: e56e921c-9632-431a-4357-08db16794384
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nG27zJ9SJwIJY3ZF5wkxF8JF/0sW5/HzPmvxCvE/AZIG/N47GeSKU+bjhDdhAiFFf+oySvJ0pGRAWjDC6jiynl8duXN/QRpaKXUVsgApmZZpXF+S1BGKmF1ZndDwzv6TUrDwP+qOfQug0Un7Unzm0VI3mLEoXZuKeNuhS94M7uQzZ8qEUobGSCdFI0/zFbwAKDL4EGGVG8DNyt1eDH20fcEAMA2BCHomT+WiunUpE2M4jvOBeAROzHG+B4zCQF9bS9HKrHlrXY4r9uvOWI4KNDjOQBEwgVX39/3CmwXZoOag3suI7S8ytm/SJIZKgaeVTUDtmsieUZlXYTClbGJMfl/NIitfzfeagpfAkaRSCcJklePZFdCIPHbwCBRNbp+pW3c6CNrMPy7t+K9SpTyl0QADvbJoxfJBo0xyDYd/8DiS8SIILHokLXJLLcAh1usrZ3UudW71hQVlLOOmJjV6rnGG7nAfgq0F2J4gJjK0+bGO8rZn1U+ssKYNaatU90T081/0xpb5eCQZoFVSj2kiEfaUKWrNxWtFiKEFELpDVa/VWUhHawpZ44ItTVz4lNdohcZcsa/WQyfBfkd2SOoMa1HXKV92kkecbMaPxUQZeMcQTtHDbn0poS3kdHXslWD3hxVX/+12hVAp7CIP34T6cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB6798.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199018)(83380400001)(36756003)(4326008)(66476007)(66556008)(66946007)(6916009)(8676002)(86362001)(2906002)(38100700002)(41300700001)(478600001)(186003)(2616005)(1076003)(54906003)(6666004)(6512007)(6506007)(316002)(8936002)(44832011)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kd8fI2tPlncPTffDzFVHYcetr/wIBvc0h0uJ2lg3V8p5aep2DxU8N52Ou+3O?=
 =?us-ascii?Q?IkCNc3ipO0VTIzIMhKe9mQgKAKQsxJ32t1NhfxAzr/U0RJesuB7aLkitxbP4?=
 =?us-ascii?Q?pZ9NCb4O3EQ7R5ytKtXGzwvJdTKFT7Q0oAmb2mBRZXq5zsnKHslOyCnBU+lr?=
 =?us-ascii?Q?e9qw/9JeZoiMQnIYtlNe3lvpsFBmfaMXGhVGblLDyLmQvFoqmoy43v4YYKOk?=
 =?us-ascii?Q?ZyJe1NQ//3Rt7Wk44n4rIsFirTUkQLgtMWSqxXYbziKlh0o6h3n9I1KGfv/S?=
 =?us-ascii?Q?dKhw4NwcV0gZvvQlEbow2JUsh/+QwUXLf5hTNlqbeUbmtxbPlm9dhF1eVylN?=
 =?us-ascii?Q?Dr/z1oOHsEGIbg/eTvLm9wMwoU+9xpFbtAnyZC1xGwXHSqY//FFrBGcNF0k2?=
 =?us-ascii?Q?X8M5rGRF65AaPFnOQJlFWh/tbcJJyhbXSOBf85pdQLO/v7C8htbtTPjmJgk8?=
 =?us-ascii?Q?B0h+rLh+ZsrtQNaNHZWPZubFDhb9Zt9IXpJDDewmr4p7lDiZjAW90OJrfu1Q?=
 =?us-ascii?Q?faIvddQXm6eZq2KnFwuStxynlObo1wCkrisWzjFG1KS2pxwsCsE+BtVWxBKk?=
 =?us-ascii?Q?cNSQLDv/Buf3zZQL1mOdfD9Mwo455RxspmIELiDQ2lrqaNuvgWNNpcy/yoLn?=
 =?us-ascii?Q?gjhuuULNGEmE6z7OlEhTzssVc9gavbenCoebYJtw2RxhXBP8oAjDjn8wqv+u?=
 =?us-ascii?Q?dPyk8Mw+UxrIC7XiwF+ji+mPWFDi9jVnL9yVI1uWJpDqLlWc0jDEGYsS/Mjj?=
 =?us-ascii?Q?uskBi0I3Z7a6yM8se8K/sFeumkgKjjc9wbrfOvSKi0Ri0g6Zye3w+RbUqcD5?=
 =?us-ascii?Q?sRd4gWXjvrtjwy6OyFwRv33uInAF3v67xwlWsRbCc0MU03KRHSKl3ulTiBGe?=
 =?us-ascii?Q?60OJzI47XAQvCDax3AUOTz9P3zzI2qtxe/SRtYlirVqY2EFn6CKTxBU9TM6B?=
 =?us-ascii?Q?r47MbWmnAxjnsqVTCURE1tb8Q2Mmx4vQQaZT5yAyGPKRRh3ie+8t+deITYR0?=
 =?us-ascii?Q?3kysF8KUGmf+eBSQ+6pFF/fvpJCi8+EKPbQvVo8RmpqB7uKFU1+R3B1sYqB2?=
 =?us-ascii?Q?5hNvej2wAPbAxZSXMwwAhWOr/mo654mpri9VKojG+8Ed/UKwdK6v3O7Hzlym?=
 =?us-ascii?Q?AUyeEfd0HuVMaxpflzAaia3WcBGxZlockzwNFwg51qZdOt/Sd3wZkmdM2ZBd?=
 =?us-ascii?Q?gtpyvyWpNXsLfhCUykoxKlQJP4wm7eG1n3Gral3tGHFIAAuMV6jI4YTpU7Nr?=
 =?us-ascii?Q?XTKRmvD4HSmZh3TSkCpncqZWiFsBpuMW7UimSRmC+BLNRTyGFUdeM6n5dqmD?=
 =?us-ascii?Q?1wsvKWjzOOnowhpFIoZtRh0CKRceEw+/xxFPRnSfi6oiAlK1xqhgT+tSz/8y?=
 =?us-ascii?Q?4tkarhSwAlVeUkZpNY/t+tvVFXlLQSwTFc8QL+Z3Xt2f+rywJaae3NuVYbdQ?=
 =?us-ascii?Q?eBZELLvwccN7WLtzZP2kgOhsVMnIeTXISmb1r+5T4S8k6DvluUEkgiVohPq2?=
 =?us-ascii?Q?VdJm0E15LhJ1hNfKEYAXfhLzqWT4l4lbl7H8HDiwrCERQ9ny44W3Na3Yjka3?=
 =?us-ascii?Q?n3u+jqXOOKJBEzoBw+Pf61y1GIx36pO91yjfMncHaAZp588PAY2VYeHwtvTp?=
 =?us-ascii?Q?Wk3DHhiPTVDwqZP+uicB4Bk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hInkZf1bOLdvP61Q4/04r6rudOfGYF40lu5zSY/2mm08Sac9IwIo0QbRlkZxuXd9wcQSNigGA+I1/FhWlfB3+t0N0dVGfBc0v0h6P/1UpM+phfr2+OYi1Xzya3StjNgEWWlcjM73fwsHTLnFh468927to6arlalBrfXMGo1G1XMx9FSwG+7BwUJAqdzySKK4/lPegfXBqhELAHAKokOpjyyeH20pk0HUmbAFGliWsn9Q+wMHclYY1Sris4XlE+jUKX3Y69jCzKd2P7pIwlAO+PZKh/dc3QzJraK7za4X6w5w8c9KbPThFhLDT3IoLnlm6rdV+1+KGCI/mWK39kyx9jhQ9bDpD91lhYWg8nLITj6rNMrRRxleUjO5M8NTGkp3S5IVnV+D3zV16nwGjLgJxpcFufLaVPn3GTupGLv7/vDrQWDVVPmqQpDMlWgHnpH9FiwaRk1z2JzMqptIWuCpQ7hDXZc8x05Tji6NK7okdf5LtpOvLVTdncmrHAL9xizpotT3BOKc6u5IbriMJO6qEL4rGJIhsiKWIdscGQpwPmVfA6urQ6GBMzQPLsDM+exGpCJkEUkIAc8Eh8aPEHTKS4qC5yOeGNEkRonFNeURBhospYwCjzQPFkD1g6N/5dstd5TblkCanJ2MRFbMlRH26n1TESuiKkr9EHD8iDqHkg5Vbd8XVr1AVfrzkvnvA22EQlYSM7VJilSmvS1CDnLyizHB8Pc8R2m9a/q1LC5gFY8Nzmb6x8gdfYfPBjKdc+04tqvgUD0vklX1eik4cREIVkmsMdm0b9XftWUdWV9VFs9z+mC0t+wiC+dldSYfI1zaMbkTUty72uP3JWLgJz20Gnfw1BIPddZwJtjrL0cKAzc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e56e921c-9632-431a-4357-08db16794384
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB6798.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 15:10:28.3746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KQSw+7XkiHIRIwWeSTR+gbGl6PxgKvEbypERT73FfCofvxBgjyFIwwpZpc8FsSv1VkEsFan/pDUZuAKJinjiKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6424
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_10,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240118
X-Proofpoint-ORIG-GUID: si0ElL4JkVQXWoSqFDc9rl_51ESnZ2xH
X-Proofpoint-GUID: si0ElL4JkVQXWoSqFDc9rl_51ESnZ2xH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 8b41fc4454e ("kbuild: create modules.builtin without
Makefile.modbuiltin or tristate.conf"), MODULE_LICENSE declarations
are used to identify modules. As a consequence, uses of the macro
in non-modules will cause modprobe to misidentify their containing
object file as a module when it is not (false positives), and modprobe
might succeed rather than failing with a suitable error message.

So remove it in the files in this commit, none of which can be built as
modules.

Signed-off-by: Nick Alcock <nick.alcock@oracle.com>
Suggested-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-modules@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: netdev@vger.kernel.org
---
 lib/packing.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/packing.c b/lib/packing.c
index a96169237ae6..3f656167c17e 100644
--- a/lib/packing.c
+++ b/lib/packing.c
@@ -198,5 +198,4 @@ int packing(void *pbuf, u64 *uval, int startbit, int endbit, size_t pbuflen,
 }
 EXPORT_SYMBOL(packing);
 
-MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Generic bitfield packing and unpacking");
-- 
2.39.1.268.g9de2f9a303

