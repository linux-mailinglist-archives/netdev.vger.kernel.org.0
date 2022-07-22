Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB66257DA52
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 08:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiGVGdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 02:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiGVGdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 02:33:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A954D4E5;
        Thu, 21 Jul 2022 23:33:05 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26M6Suuc024173;
        Fri, 22 Jul 2022 06:32:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=2acmMK8XLu+j0qnfdk4cy8/PECXA5Ep3EPzsvYrxsvA=;
 b=LIDnARg6DnD7aberSTbGRWOzBSidjV6QLUfOYYG+/z8heNpBPhYCiStVH25WhFEhpb4k
 Fu2zeHPu+c/V+cYiwLQfP9f1LoNTVoktunjxIhBiQHqn/HDwTvjNd2YSQAvVjRe2/axb
 x3wGjl+A7WYYFByiZG1YPZg6bk3f0poF7DbkFu1jpYR3UU7FrGRtaebUYVRO7+GXreCE
 vcBXdCXCeCXRqeUWvMQ/U+iR77wrPseZgAoa5N5LoXf1Msf4I2AQpLEWxNc3In8z7Mli
 wP0qwwAnyVVZ+LTJKDO7swHFSjCvZMO7hFAShAHLyX246cYgJQoMAzJMUXxby+7pfDaY WA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbkx16jrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 06:32:54 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26M3WOsu016449;
        Fri, 22 Jul 2022 06:32:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1eqcvpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jul 2022 06:32:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFUQAc74CSCylDVcjePJDYU0ZgS41zfxqxUTG7rsLUx9ARfK/xiU02pbcX7S6N7tiS5mDA2eOZnjX3PuJgDgr5Agq/JPLDtStE3avYVetpAbLZ5cqrYan+HmrIx8tY7++s8E/e9MwqZlPqeW0cM+m9h0/Ws9JA6VqOnPDGR4CEDrTTgj9b5BWeiHnBRrX90WjyWFmWOLMtL6kXtKk8qAbdKPX5JbfBbqW3cjpdHkuarG06es4lGaOhl8b2LFo0uwr2+4pgmJNoinoh5uNSDTuQiPTRuqxiuxE7CgzHzCIPCdd+h0m9VSlCGn9izFg3aj2q8iVKk6Hvv7/DYgcrzK7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2acmMK8XLu+j0qnfdk4cy8/PECXA5Ep3EPzsvYrxsvA=;
 b=R1kVQj9+grL6YGRScUIZgEvzh2TPKL5nxaSWPIw0RlZkS4UKcQ8qStrdzFnLSwyQB8VQMhgwAFdSdceNunroRCf0NNmwEdJjIWKyN5pKIiOltKJckjFpql+uwrAZwHR2c1uq76wPud6Z79rtQbD8sHl6yd2LPM9IRevB00uJ1mXCPVF0shJqBPTNA8P3uXDmssG38b5Oqp9GbcFqdY+rNLYkvx19AAyR85qP/lTpgycXmDGiMnhLkyAI485By9A39NQAGU+eC8jy+JL7ZMNwMuzyGkSa0G5Cqlnq0+JpasIsUZY8lTReKd5APdUQH9Lj/Aa2ZqMiR4fHEZjjbdrigw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2acmMK8XLu+j0qnfdk4cy8/PECXA5Ep3EPzsvYrxsvA=;
 b=UG8+1HKbpxO6ANo6o3RBI7YZXZfjlJ3LAOLaSDBHGj91n/pd3dOrUKuTXi2B+/rZ8KCpN9uhszfh4Ohb6+VdPm+emIhAWjRmy0xQXNu/a0fBLEGMCKqXQJ1E30p6basPA/glMcQ7Jb0RFjDGRsOphdyrlLDhWjTczQ86Kjfi67o=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SJ0PR10MB5744.namprd10.prod.outlook.com
 (2603:10b6:a03:3ef::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 06:32:51 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::24dc:9f9a:c139:5c97]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::24dc:9f9a:c139:5c97%4]) with mapi id 15.20.5458.018; Fri, 22 Jul 2022
 06:32:51 +0000
Date:   Fri, 22 Jul 2022 09:32:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] mlxsw: fix devlink use after frees
Message-ID: <YtpEiJz26qVoZG8s@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0169.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::16) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82a482e2-65ec-4511-5def-08da6bac007a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5744:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i/+tVYC7UUqSiXV7Qoqx1s+lY8c95SI0MwH8uvW0dN5gKR4WxZ/zEpi5cqPqwg52803hNDAhm97V4OLCgOkl4RpREqsO3IUaj9FxG5Nik9Nnaqy+lS/Eb6tezWmGS8QWrqWN96o/VCEthUD6M2zwZkJKuF3xcDwF9Xh4TZlACY69JmsPrwAYFtU3QxZozgBl1auIo/YHaB+jBNeGWtlv3qfN2XY5XUEL4mX6Tpdq8Sx658GIehT/o6XkiZuB7JGfy8chZQMeo8Fqyo4TF/Ea7JWpVeD3ZIgf5kaMESlWnE6Ud7EHvjpT9t02XIekQpSa96V0uwnUTAwlw9Unz7jB5Pw5O+bBQsJNFEqQ+4H3bWTyEpNd7ifPFT+ScyHPvxPFlEI1bh/2LjiBLk1NYhK15U66KBHvfZin3O1WIFVxzE5W3fYqTKpGrv5Bjf7M4ZMZF+ltiU/wNTKiV7YiPVUssHrYYMSbYTMKuaAOpglsCvq3MesSVoeW5ombPL+uz8MHtoNG/LfiE5WkwOvNc4H0hN6CZsDM1sNSQDHAGw72zcQFhuMPKJjz+VuA/SJ3FUcqogzRMq6AMMz5RfWVOwTSDHAedSkpIi7txQKk2NgLyP/7BmsbeOO2j69/934d49UzZoPfs5V8ijnKZqbVP68PttlYp47IOyfkSmHuWHXU/ms5SM+AKipaO10NcEvSOBq0fh/rRNsCapaX7lOdne6uceyafeJUexpi7GhMzDftb325cqOT1LqAEJaEfOgd+QX7grRhCIrfJd2H99U2eRsdq+ITUxDhtUCFfeP+OwVS95k4zNGHuGCYdytXWdItkSb5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(366004)(396003)(39860400002)(376002)(346002)(33716001)(86362001)(38350700002)(478600001)(6486002)(38100700002)(44832011)(8936002)(316002)(5660300002)(66556008)(4326008)(8676002)(110136005)(83380400001)(186003)(66476007)(6506007)(6666004)(41300700001)(2906002)(26005)(6512007)(52116002)(54906003)(9686003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/tsokYb9kYLONDpg5/IvgeJ5iCe9JXBUTo+mXgpcyS7e6c94HUivD8lo2rVr?=
 =?us-ascii?Q?ASKfQL8V/+/mIpLrhAxkADiuUOD8Ab+hdYw23DVpCyIHLuDqUkwz6+5JfQVl?=
 =?us-ascii?Q?p4/ul5oeSRqO5++bNzhEV+KdbTDHVIrQgIkc+3J0L75ixY9Y7st5emzta9Ux?=
 =?us-ascii?Q?Hopa6ua7Fq9rBgwG+xpTWPkPBaiNYS+l335sbjljpiVq/4rJkD924g0ecnVY?=
 =?us-ascii?Q?La3CHiCJZf7KdpH4NRcBOxDwDBaz6GGwHCKzquVOg3Ulk/6kzUhNJ4rqyFGY?=
 =?us-ascii?Q?/Y6vCCPFG0zoW/WpxLAxOrIz4tVHpBeGYErKyzxbI8rgXvLtm0ds0kwlxR/L?=
 =?us-ascii?Q?rXNkWHLwthIUXLJP+7bOvMroJFBO+/Z9aULaX4JyDIWeU/s6lH3FJWpArAuG?=
 =?us-ascii?Q?WHY030PXj64xGfU5oz+Ti5D7CDzHC8RS4N5kE586PpruQKAf03d/oGCCkm3s?=
 =?us-ascii?Q?lh+HU0+EpARgmnr+vsNGpHeFqnjKUBqVtvg1q5cRpZG1tXXLnB7XrxBA6aG9?=
 =?us-ascii?Q?/mBraF3GMUpo/37k4gpLzPgXWmspUFW9Wkh88rsxQgtbXBagqNY6y8Vvyt+h?=
 =?us-ascii?Q?9xIPOyf4YTON88HoZxExknLvhy/jomqfnXTynQzB6jyhNb2xVHLNsWp6a7Sa?=
 =?us-ascii?Q?+2tSuQaDP1OhxB1LpsqQOpVDFEKgJl8rHw7lCnXk3HfTOMneg6J02SruVZFe?=
 =?us-ascii?Q?qQ0iwskXXFJNOvcePdFJJeePqZ13BdR1H/TeQ9eAdnCy+73cMkbilFWWaTrk?=
 =?us-ascii?Q?eLCcAE3d3cUyqGd8/7NSFX/DxdzijpMxEkXbZdKiRbPp5D763s6Uz8vUYy1z?=
 =?us-ascii?Q?uPCvPkE8Co5BK+/SU6sMqHhEtc4i2d9iJrQWv3xci5NpukZ+zJhDJlIopQh6?=
 =?us-ascii?Q?KyOzvdNXBzpW/FBts9SdIXxw1T/wxp8sjRS9qHyf5uJx+YaeoMD3lsnlBXw8?=
 =?us-ascii?Q?5okoxJyN2S0eoyVJAoOZm0NMUhEfNJNg8yO1ybeiSuy+9DrMkiEmzIyqjPsd?=
 =?us-ascii?Q?zf0fLchcrBeAsvtza8lEIvWk+ETwgFxpV2tKWHsckUo/HDaQ93UyN3ktbvBD?=
 =?us-ascii?Q?4eM0QXaa6Wvl4UqbEnnw7AN946H3CR+DhIpUcgu3ANExNZl2JUaTuE24l1Wn?=
 =?us-ascii?Q?eO2Hq8OZHQs04A0Y4myZ1+YC80byQ8qP+humwIoaiomFwrX6Y3XBsPgPaA3C?=
 =?us-ascii?Q?IWCgRKU8Zk21b0ibndV9XcVyRI2jfbol7Hh0jD5E/10xryEj2jNYw1PJiWS7?=
 =?us-ascii?Q?OgV2zPH6ZmHCz5cB8YMqL7w+b2+CLoqP1fbAFHv74dFM5W5RGbxry1sbq9gc?=
 =?us-ascii?Q?KFqX9wjBfq7e0eeCc3PQM0k6/c8CUDoEQA/bfuHTAcWN5dvi5VznflmYENXR?=
 =?us-ascii?Q?zH6h1uI3bhW+ykAgMVM+wTdsOp3frjRy/TRFUISrFCq3gkSg0LdlRuB//9WF?=
 =?us-ascii?Q?Y6Upkdb4OoPUnVv0v7A5T3Ic+KTTzB0RqWOALDz5siom7AySk1bN5DUYe+9t?=
 =?us-ascii?Q?fT6Ibg69jUscDuQJ7MZ+wR5j1B1ozSbXulXLM15lPzz1SHygS4lVePm6eF5I?=
 =?us-ascii?Q?9fPpRMPKIoxhaNQuLa9zxPvts1Gf9fmoynPW+URtBneuQTs+YkZgoDtueYpS?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82a482e2-65ec-4511-5def-08da6bac007a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 06:32:51.4162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ist++0/ZUQethDNiPtchDh5oM8gchi2AEqAerS4OeR8Rrl1J+2zBT89lCiWkW+vv+o4g6ch2XgJMPtwhn3leam7cA3bYdW4tF4xeYi5QXQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5744
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_28,2022-07-21_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207220026
X-Proofpoint-GUID: R2n5mQzJvnihKKe0BQQvf47D-DJFRoO9
X-Proofpoint-ORIG-GUID: R2n5mQzJvnihKKe0BQQvf47D-DJFRoO9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlock "devlink" before freeing it instead of after.

Fixes: 72a4c8c94efa ("mlxsw: convert driver to use unlocked devlink API during init/fini")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 61eb96b93889..1b61bc8f59a2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2296,8 +2296,8 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 		devl_resources_unregister(devlink);
 	mlxsw_core->bus->fini(mlxsw_core->bus_priv);
 	if (!reload) {
-		devlink_free(devlink);
 		devl_unlock(devlink);
+		devlink_free(devlink);
 	}
 
 	return;
@@ -2305,8 +2305,8 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 reload_fail_deinit:
 	mlxsw_core_params_unregister(mlxsw_core);
 	devl_resources_unregister(devlink);
-	devlink_free(devlink);
 	devl_unlock(devlink);
+	devlink_free(devlink);
 }
 EXPORT_SYMBOL(mlxsw_core_bus_device_unregister);
 
-- 
2.35.1

