Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13C1538BF4
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 09:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244510AbiEaH3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 03:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244507AbiEaH3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 03:29:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F100F8BD27;
        Tue, 31 May 2022 00:29:20 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24V3EpHv005524;
        Tue, 31 May 2022 07:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=2ndJySaZPT7fcR5wX8jqZLgyxIMoNmc9Py9cgo8Twm8=;
 b=u8JDLH0HIz2MdAkxAEqFpITmVDDA4ysuzEW+34rGcUDFg+whns6ati2u8j7WzaZos0y7
 HoowRQ/GzKOfEkxBOW1dwcKupnQwEUjY6xfkreW+x8Ig85A+aNW+H3DAi+nwKYqMXXka
 kByda3HmoGW7cfIxQQDmjpgdLPeTAh8T9dj2BcYyl/YBBF3K7JejSdMb6UmEdzjNTdA8
 OIJ1V5wcR0FDtl48ddZbbI0aavH2QLqhJK/X9fPpAHBkSJIrfN5ZjuUIDop2siH1cYgq
 kzO/SuM57WNnFzG5lm39b+GQBu8XkE+39lAEd/rlmBBFoSlcOpgYt1FkcJUbbkQDmWDO HQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc7km6fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 07:29:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24V79seb008744;
        Tue, 31 May 2022 07:29:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8hrahkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 07:29:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMkrYL9hI+5TZoujwFSuFggLsvzqt5QcjMajUofV/kYse3r1DE453nN4o+Myy5780NF3f2wzhAiaT2uUzxuNoVenqEMaxVnteoED4ZQt1pxtfNH3uYsN/RGihiLqjdq/6c9uAVHyA2iVtzHP/Fn7rHiEbCs3RAR5OFFsn6clEM1jX1ZeGpm3ZaaKJTFOEw03Dz2unodV+lAAqWbCyQKEAZm4ptQyuEsUTzZVqrs3Nbt4RWEjlWbHdrL/dNYmrdh5g4xynLmUuo871GLeF8QABhXHoMZsWOSqNPz3E6Bx4doMmCsVcPvsyVVMiDiirRE30u/hq7Lc/883PEQLb/VZPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ndJySaZPT7fcR5wX8jqZLgyxIMoNmc9Py9cgo8Twm8=;
 b=ibRTHBvHqThdFEnuDJmgbh17FXhL8IPSePbamXBVFMH4ZsSCZOqSg6lyEo1ubKrurBu53vjpNAbOyrAwXug+3vKmdnouJJ1A//S0xc01cO9EAKXw9cnRBizqeei2te7rvFhgfutnUppcv4iFrWZWMClcSZBoh1rM1jH+3WO1A4bQn7xXso78xcCgploY3rL1OxlVGdGMq7iNwslp/c2uxRsBen1eNngROY+SJAu442ZVfmYrzbtqBzC3chwgRcO6WgL6K1yRl/FcQWcu3M4IHrTjEqbXmhDPViUkfn+NfYoWWEpp6+3YuI+0qEihGzWGTNJAkCRS3DWe+W0WdGD3fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ndJySaZPT7fcR5wX8jqZLgyxIMoNmc9Py9cgo8Twm8=;
 b=yTeV9wjnUOYro/SkrxflB1oshgA+FahN0hd9fnO/HGTPVQ5bFucdDtKCWScQmtCTN9QTpHxy3KeR4d1GgUNl4dq+e+/+3LoMYmNBWpSTz+TcxFWNXf66uz9d5so4tAVFlp2CzS9kyRygcMb7PufsE7aoLgffgvZhALTQ/KRG+eI=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM5PR1001MB2204.namprd10.prod.outlook.com
 (2603:10b6:4:2e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Tue, 31 May
 2022 07:28:59 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 07:28:59 +0000
Date:   Tue, 31 May 2022 10:28:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Srujana Challa <schalla@marvell.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] octeontx2-af: fix error code in is_valid_offset()
Message-ID: <YpXDrTPb8qV01JSP@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0148.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::23) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22f62dc1-7aff-4eeb-0616-08da42d73a5c
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2204:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB2204B59C45E59C1E55666D478EDC9@DM5PR1001MB2204.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fKyJi7pHYQOMJA2Ic4PzWCRErYru3c43tHUnbWUSROyJ6c28D1BeskD42ass2Nx4eCnHaekW1IwTos7d7aecQjS7xfJ4q4r7DqJ+CupGtRelxl8NLvlL0pJJEmr07wuCdf0vc+XE4kKv+ZqxzfBOml2Pk0T0lAS1FvtHD/4CxPeWLitmjLZSM2BnMmOplpOd2lrZbsGVTmbUaBV1K3UmRP1QxHGGlDmNC8xpaSguR7AhfXzfeO+EOlsStbE1eoYDFejuAMBvL0eqSHoVbUAeKNDIK7FeLe4Wh5+hwqASIBWMc6XLHnefA6BB1mgqBA7T+KfyoduIg38XcxX47Faxh9+tRoJOWzOptjg+njbf3C5I4tyq+tEOKK3M2IsvvRw8HkOQU47Q3HPN4ijvebfaPtv7pt/cajXkG8RoOpNEkJFvJOYt3hcdCjNzmrlX6n80KwsYFCoRBjzJ/4hu6wBEYUrEszVmloqQGgjZYIL831EJvT9gN8Yslx0Xn7NNEn6ZOzoHrXlnuL1j7Dm9HE7n7EPK9qeMtKRGqmmWbeezHDTXW2gpHrFDaxXbyA7lAZLrBBkf+a5xZs6o9+JORBcUq3OkxAyG+OpAK53dSMgqK85QPy5jzQN+Q8MxW0cLmUCLPjyuT16LHJvdBt72VvAlxt+3EIufGTjN/aQJt3Velx+WARZPciEsHLkVjomcPxClVdZQLiZTggzccsbkpHA2sA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(44832011)(186003)(7416002)(5660300002)(508600001)(83380400001)(6486002)(6666004)(316002)(6506007)(66946007)(4744005)(86362001)(33716001)(8936002)(2906002)(66476007)(6916009)(66556008)(8676002)(26005)(52116002)(38350700002)(38100700002)(9686003)(6512007)(54906003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QFVHQJDKWr9ePvzC5L8QWku8kAxwx541Az5xYLKFrcbLGQavzX/0jzUF/3eX?=
 =?us-ascii?Q?yndTrL/rFgqylEc/jfaN5//CRN+cbvuiu8BI0VLLV3y7uaexdtVlPgO2GPjz?=
 =?us-ascii?Q?mTVaAjRZ8foEFiIzbDnlsVKglozPlGOKj8sgFNyEH5cNEv7EkC+GoV2CV0dF?=
 =?us-ascii?Q?uJrIsuwTBAk60JTm//56klDt9Xg2SX0xdYZWNcSBhGADM2Pa34Zw0b+e/ESA?=
 =?us-ascii?Q?y8eY9V/6HrfXxoQgSOA1G69bbk7cD9ZgcRV/jB8rR4kxOlmdvwrn4oGNCtr2?=
 =?us-ascii?Q?f4mcdso8Ow6Y66QB4T5QkYxweGMhnLUDB0lKI27nVmNsYI1krRv9L/PM/Nv2?=
 =?us-ascii?Q?0eHEbCnHMusdf8KK2uMybxNCNm1htJSva+tNk/wSPtKTcF617Tp16wMC86hk?=
 =?us-ascii?Q?+cKCbCJYW/7ZGsePq3exBHi1nRJCPihtLbCxlGOWNCamARY4Hi8CyFfWqXT/?=
 =?us-ascii?Q?rxknjkwgc8+e0Ylxx5MCcqMrBri+hpn72BQdn2VE/BX1YvEy8XRO9rItgl+t?=
 =?us-ascii?Q?ahgN8h7Rk3aja7/WG+WdVYUIuswBxru8z3apqBUNzYmkL22VHvbYpz1wgPuV?=
 =?us-ascii?Q?0HnLwkDIhiG9r0SnNMfR0OikNr7XRFgnwKSmxI3tl29VXHVVt3Dg60Yb/bIG?=
 =?us-ascii?Q?1dufYNNpeqY7zXl3NLrqMCatqiXh9uZQVO8f/LMChPcEE13GiebTuamFbHU2?=
 =?us-ascii?Q?fJEuVPITNsHYAEFdNvory4iaaosUB05SMe4hvt1CiKOzSTINvYNBg8se3aAc?=
 =?us-ascii?Q?WRvRMd9JkhTCQiDSSU4bEXV//NfW7Gv20fqSeIdLG6rf3fM574y0Fbqx0Kl8?=
 =?us-ascii?Q?80ISJV7OV7ABvLGrpNEsjQzYaVl399VxONbPdPYa7IBwOE3ZdhbTdW3Y3Ck4?=
 =?us-ascii?Q?qsokxRKhS1LkumRalvGWMsk4bpfRoh5DNiWVy9S+1uONZU1qS925yTmDUg9g?=
 =?us-ascii?Q?Yx6rPuWOIor5+rbkW0K0Rwey5orArzYFxCD+V93VqNd+OwJUaZqxncy2qIJB?=
 =?us-ascii?Q?gfHP4c+nsf3GLP9NHHxh9zoSPEiF8RvBbeFoegBGIvpptrN7rG/cPRwMfgyK?=
 =?us-ascii?Q?QIC4Ywg2i9guHJAEweboNR/8Ai8KoMAlWBBod9pvED/ANhaVU5YDvov1oPhV?=
 =?us-ascii?Q?wbRL7XbtARvsmkcvAEz9cHPAH88x5vtGDmlIJjslEwk8KUcJjWBjr2JTLF45?=
 =?us-ascii?Q?d4N2CXUb21ibKwHZpPNlGBKt6lGGrGFj3pnVNhCA+gM3ugv3ab9e8eZjkeqy?=
 =?us-ascii?Q?/blENew5Q/VQgrZlyiScfLEewhZOrpl4JFxGwLv48puuLONQjER4q+ggWc7B?=
 =?us-ascii?Q?uXOw6Bi8X6+pAz07wFcFjf/Pjwtqp7yq/5UBmOLiOiETjZTOtJqocQjKgOu8?=
 =?us-ascii?Q?kl3bhPG96GzGkvKnmt0zQqZXhDZ81Od1rar+jci/Kdd+V0MT8jDHIseL1t1Z?=
 =?us-ascii?Q?kzcvfJJ1kTNlrgVXw51e8EGas+0Ox+CblNfloGyVzCDX2byDTr7sJdQ0Hop/?=
 =?us-ascii?Q?ZVeAvftSNwul+Ob5zantTmXkUXRyPNmn2W7+e1Cn7WzSG3utTbfJBUYnS1B8?=
 =?us-ascii?Q?meY5beOoj3lxBVeRC78sS5Lm+Gb0/S6BO4MfZZpVbEVCMWUFkXM7Qx22p8ZX?=
 =?us-ascii?Q?TqNND8Sv8MPEx8z3B93Yb/ivmXoOyqKmfACwIdxfyhhn30XgZtEDYPb631Z/?=
 =?us-ascii?Q?8rYAz0KJCJXFsv0qg4xBes6gDZs00LlzTtwZvu/3UGK+mthriDTvXQ08tTRU?=
 =?us-ascii?Q?6KUKhBfdFH9AJKGZ/dSd7mlO7mdJk9I=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f62dc1-7aff-4eeb-0616-08da42d73a5c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 07:28:59.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0A7g5cUZmPsc6ibpMimEdcEeMN2cHbH6c4Fff7ywVXvdOmY/nTPOLcfQZCDDk/FrzRp6R26MEewR8UmqFBCa6J7Ibyq/XfNviMNvyWPnpd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2204
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-05-31_02:2022-05-30,2022-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205310037
X-Proofpoint-GUID: CNanChqPpTc25HsLG9Cu71QmIARoxT37
X-Proofpoint-ORIG-GUID: CNanChqPpTc25HsLG9Cu71QmIARoxT37
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The is_valid_offset() function returns success/true if the call to
validate_and_get_cpt_blkaddr() fails.

Fixes: ecad2ce8c48f ("octeontx2-af: cn10k: Add mailbox to configure reassembly timeout")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index a79201a9a6f0..a9da85e418a4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -579,7 +579,7 @@ static bool is_valid_offset(struct rvu *rvu, struct cpt_rd_wr_reg_msg *req)
 
 	blkaddr = validate_and_get_cpt_blkaddr(req->blkaddr);
 	if (blkaddr < 0)
-		return blkaddr;
+		return false;
 
 	/* Registers that can be accessed from PF/VF */
 	if ((offset & 0xFF000) ==  CPT_AF_LFX_CTL(0) ||
-- 
2.35.1

