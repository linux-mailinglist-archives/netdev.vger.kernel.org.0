Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F605B1CE1
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiIHMZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiIHMZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:25:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCA6C59F9;
        Thu,  8 Sep 2022 05:25:33 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 288BGDa8011919;
        Thu, 8 Sep 2022 12:25:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=3NTWsdDJM9PAR3qGValMeLcQ4NAtplKNfF6rBTIGDa0=;
 b=BPWa0lx3mLaIgcWMI2j8oP4pZksol6/5IhAPAvQ2FZEjb2M82Bx3jhEVRxdBfu3bCdcN
 EvVWEelgYZrG+RN5+TT6HeQDC5c6enkV4+n/kVemFPaW2w44jV/VNDonAzJGGjxFDakb
 1bWBlkdnTGTOIQJUUb+/wxMAXWueN/5Xa7J9uRGIE8FRwBtvBHQ8dxQsMOUKwtUhnIb4
 sZ5EqPFfQVaRdEH6SkP0CA1jK/2plsq1oPCet1M4kKiq8DlNiXoXAxMTAKVPRibLAOpd
 bJy1T4sMuhtu+VvaMSQ+t1VaPzVaZGukg5tuZ6BSRA8B0D8CXabZzZ5t/SNDqapb9Bp0 yA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbxhsunbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Sep 2022 12:25:23 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 288COS1J013831;
        Thu, 8 Sep 2022 12:24:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwc5csf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Sep 2022 12:24:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jefYJDeZtqK+ObAwGp6l+efiHQ+XCZ9ZforZD53dAXiRjvdlq6rXXi+3MunlwtqqG5Zx2Y/hVHBvlyWbW+mZtG3dE+yZfIK5o0oA8YNfYOjfMUy3Q7LIfklzLLvoNwsuXiHUJWe9aSvqfbLme8lxttdxKsfAmgG35JZCYuC7qdrnV2qkol7ElaPWn2e2Lej7n7iLf/4n4aASxB6HMZBz1BejppOHNJSEpH++vJJ8rAM7Bineyd53V3yDN5qXkf9+Kma3D6jC1vRJFE7JvwsZcSi3UcmzM2oaMO8OgHH7tBU+MgHkCmcvPpHswUeh6jZ/jcCEKPdfPqe9XiwnfIqq3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NTWsdDJM9PAR3qGValMeLcQ4NAtplKNfF6rBTIGDa0=;
 b=Y1pAChj2vS8RPT8lKbicSUvhfrEfVqxp0GYlMSOcfV2vYIK+pi6kBrpo+xbxCl5PlFcsciu26bVfQpnJ5btXbEuw9GEzqCTT3wTzHAsh4OlQjCH3WeAwNscd8kToot6iE2xxCuX19toDLOo8j6wFkCl5nk1vaJU0bZQH9sIEBgdHAAfnvkj4gzb2lCsXoS20hpFVYFAgTHEcC4Vf7846qz46QUDOuGlyfCvDCWcVXWAhQXHy1eMJ266kRdXyXLVMf7Tv94OY4cZCB6ssiVGkn08fZU+NEfXOFQaWzYDO7n+ySXftuIymJFL/mNE8Cfq6hJtR+vAcV14jFlsvt3YGag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NTWsdDJM9PAR3qGValMeLcQ4NAtplKNfF6rBTIGDa0=;
 b=iT7dFMmydYIN/ZMHmZ9rv8Am0pRBPLY72rJf9SB/wnl8XnYMUIFpeN2ycjcefPYRWGN77MLIZ9zQB5q330ckaJ5N5V6lU/tanILF/8rfAplv1iEiuV1VaeF7Q6lqgLehVenBS16pKElA/rEGmw1UEo6DkU5WT8RIvv6uDx64bj0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SA1PR10MB5824.namprd10.prod.outlook.com
 (2603:10b6:806:236::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Thu, 8 Sep
 2022 12:20:29 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6%6]) with mapi id 15.20.5588.018; Thu, 8 Sep 2022
 12:20:29 +0000
Date:   Thu, 8 Sep 2022 15:20:23 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] iov_iter: use "maxpages" parameter
Message-ID: <YxneB8I8gydE+8MF@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0029.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::16) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd38fdfb-e60f-483d-d109-08da919484b7
X-MS-TrafficTypeDiagnostic: SA1PR10MB5824:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OqRk29nfGNJjiSi43OW/+0FHjU2y68F4+pM9K0eSs9kHxtqBXMTFVUj+50fKbTpA1GOSBPKF0bC7ipOxmN/7bZhQTffiem7txcs29A2Wtrw4NT7L3IVx94x/5y7MO6KmxulEIoXujoiM+beJnNFtFzVHhTd+ubyFfx/o7V1H8QYiQlkq61SC70oLiR525PNR7FEuSDAv0sb23E25pqmxfcdw60bQoL/oLkBmAYZahlOnTODiAbEsA38BIAjIKIzEY2xrt1Gb1n0lYU30ZcDHlBFXp3wHZnPL4jmAWzRX0sGYUmuHlP+jYxyYCUdldhp7hf0E4vq2bTLOwayx4jQnt9ZJualN2bmA43KQdqYKNkaqx784i1ZE2JlD8T31cgXqFjRxQ+osZlCgjtTAh1vvdVpVtOTDneIDvfuP0h27rj6Db4lEnZH0Re+/mtVOjkPN+QbiYLYU4zgVygfmh29a/sJPlOw2HGS2xFvC/ucyzFG3xj4YZhxyp9EJG245TAZ9uHBjWEv7ZJmg81Rd6xVCdMu4FEQk0syw5ZOp6ncYfgTriJg6xJrJ5fzvBi7NWk4eQf3fP0Act8p0d5RsAOjt6/TEE9NR+bQRWObdQHVfrFyJnZWIPzOdeXdKbRKhrXMH+g+fEvEbG/f3MpsBU3CUsWGK9oZXbGUfjf3aMUalC9SIo+CeMXQhCDBeEGLCApsRxEWKGoi4LWXYQPphzmyFPWgXVkkDYUQZwGr2MLeAYg+7ED4d/l8AoJw9e+2nDEoXB0cIeChcn+pQ4pMbNsSiDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(136003)(39860400002)(376002)(396003)(346002)(38100700002)(6512007)(9686003)(83380400001)(2906002)(44832011)(186003)(5660300002)(4744005)(6666004)(26005)(41300700001)(86362001)(6506007)(478600001)(8936002)(6486002)(66476007)(8676002)(66556008)(66946007)(4326008)(316002)(110136005)(33716001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NlRp2KNQbGfpUk/ZFLLCDeh1OZ9l0eCyMiwQod64Ie5W7xRjfs+BFfub9Kj7?=
 =?us-ascii?Q?hhUk5XlIny10D9eN/7WKWXW0+E+sUy0l9B84hjrdCF8BjpqqPRmyTdOU4Vfc?=
 =?us-ascii?Q?Role/IRzFNec2hs2tMmPO2Srghl+9dC+LGdOjsCrD/LNb+1IT9nT/tLVD6AH?=
 =?us-ascii?Q?ZU618VvyQ9Ub9reNS6qFbTBrA7psaJL2FnSAXpk0ZORs0d4NddBlSw3Wib/I?=
 =?us-ascii?Q?kD/62eISqriNN7Ygu1+7gcASbElPgNcmvrLK8JodaNb1+buzKVkKtvUQvQ0k?=
 =?us-ascii?Q?OszwJl4V9WX58jv8vCrWJHzzGp4EIkma/TZ2eyi8dKx1HSHS2CUr26RLk7wa?=
 =?us-ascii?Q?G6iM6Ohu9WsmIYS7+G3QIgwk6WR2HzYXiIYAh96EEXMnqHedhw4BFiVgDNhp?=
 =?us-ascii?Q?RCGzW7sD8Z9/CSfypsBMLRQXn5c+cuOP4/+nj/AuAEAlVArls9lNGFYrkjj8?=
 =?us-ascii?Q?7eZ18Kxrn0bHpn/NsCrCYf5QXViQZywHDkEvPSoo0DePOPxEEU76zowMpL+d?=
 =?us-ascii?Q?uCn7zXpHIpe+T4efbNU2NDHBl4zKMCOGPWjVTp+sPfe1Mi6wp3YuZtf8D7nl?=
 =?us-ascii?Q?XZrf9p/3n/HuarmEcxqEyjHVfaIhrWvpOlBCnyuTznmA6JxNa0t35/dDDhuW?=
 =?us-ascii?Q?ay4s0C1BdAXKxbMOQgBvZeX60chEcENlRc67uBiH8wkxt4K+gvt2Xv9qwOaK?=
 =?us-ascii?Q?1qeSySoQ5koxmxDIDOCi0SRwn9ZMu75V8tZ9SpTUaup/ulOR+XJau8dImaK0?=
 =?us-ascii?Q?8Dza8UUeVKTymIjBBComO1DL/RjNimvVRLlqPu8L3q6K+2EqjMrBSmTKzyjA?=
 =?us-ascii?Q?jE9naMdpGb99pKqTGeuEHGiCpa6vC6BlokpAKfXHu8/u9UmBE3KtRuNBpzKZ?=
 =?us-ascii?Q?aPDb+rB9Vl/FBMBgPJ6T52Erlsk8ZRObsbIDqfQJJzft8SFsk4wolt7antEm?=
 =?us-ascii?Q?05mS576BUMCBmx6pwSfHTZdvhi9sF+c1uqqkMyQ8Ru0Ggs8I5DuQoCr5Osl6?=
 =?us-ascii?Q?2uiSCSilyDqUtquXMUiABg1uIv44mbEhQ43HST4kvEeNb9dqeoA+34DVuB1m?=
 =?us-ascii?Q?YhkrFukNRyZaQoPZKEAcHv+N3/Anc/4vaOZldVliMsqqP9WzYdQZSppSnyLL?=
 =?us-ascii?Q?oK4JeYzqv0c6O5yP8KiVbwgDIr9myYmGoFgNG7gkZBjmZp/h42stTmqA+6f/?=
 =?us-ascii?Q?zmyt+Kt2zUMv5fwjkOPbtmVyMVgriTx9Uxqm88K0vpj2yIyGLTH9DvyI4TrQ?=
 =?us-ascii?Q?rml+0ICoefpkFe5178UdqrXrMHzWchXy5xQyTMmWoOFQJrTnuXHKOvBHZvbD?=
 =?us-ascii?Q?RE6eigJM8ZqnfglGr7Vi2HiEHvy71O+mKVZmdv9eNMryacbmNkINHokcEX/N?=
 =?us-ascii?Q?CrkUjzYSbfnllGpsDiv+juBO+kTecmQLkUerFiyg2zz1+qJeFcRqxBMg2Mjv?=
 =?us-ascii?Q?qAJprl8L5McjK3r+pA9/LtOkMkE3VkGDi8A/Od+2LPaoNnIvxcBbfSGwGKUo?=
 =?us-ascii?Q?ordiLxi5gE0u/0aHrT4cVFSPAFSyfDzZbwfQHy1ygA6Ff2fZeD8z6HelOyk2?=
 =?us-ascii?Q?9wrIvtX0lAJRxxN+Vq03kCGBVeuZB6hjbCaINFN3wktxT4LdyGDFNGu6gHpm?=
 =?us-ascii?Q?vQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd38fdfb-e60f-483d-d109-08da919484b7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 12:20:29.5735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Ovx+R0dTEbviJQP/9siTeC9TxhdwZ5u3Htsd9snEnL3VGdqdYcUTHbAoAM1XszgvH5fAMqwlbKZB4wX8D7oKCL/KLuwiVYXY4q1fv0C+GI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5824
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-08_08,2022-09-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209080045
X-Proofpoint-GUID: d4qY-PCylBu9dObKGgPRifOEhtVHWpw-
X-Proofpoint-ORIG-GUID: d4qY-PCylBu9dObKGgPRifOEhtVHWpw-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was intended to be "maxpages" instead of INT_MAX.  There is only
one caller and it passes INT_MAX so this does not affect runtime.

Fixes: b93235e68921 ("tls: cap the output scatter list to something reasonable")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I'm not sure which tree this should go through.  It's a cleanup and the
only caller is in networking so probably net-next is easiest.

 include/linux/uio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index e26908e443d1..47aec904a3eb 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -302,7 +302,7 @@ iov_iter_npages_cap(struct iov_iter *i, int maxpages, size_t max_bytes)
 		shorted = iov_iter_count(i) - max_bytes;
 		iov_iter_truncate(i, max_bytes);
 	}
-	npages = iov_iter_npages(i, INT_MAX);
+	npages = iov_iter_npages(i, maxpages);
 	if (shorted)
 		iov_iter_reexpand(i, iov_iter_count(i) + shorted);
 
-- 
2.35.1

