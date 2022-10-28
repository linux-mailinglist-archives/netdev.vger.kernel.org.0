Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B116611562
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 17:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiJ1PDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 11:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiJ1PDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 11:03:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A68207518;
        Fri, 28 Oct 2022 08:03:03 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SEk2tP030888;
        Fri, 28 Oct 2022 15:02:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=9WFm0z2EpUCWMQy6wDPEGGHP5c7i+yc9iG65dCyBRPM=;
 b=g4TpnjE1f4jbbHLvvKjKx6PvHcihYvA5D00JSxuVivEVKo3QO012nVA8je0keKRu7Feb
 dHzq5JaBBI81jMxWf0f8yalOztflZ774LygtiW8yffnMTAbo7CyytFixENWOiFTNXQ0+
 OmX3HZE5u6hoxvAmRdLoSJ93hvkzH56gGXVk5nTrXFWH4kpQKBdBdksiArk+LQMLZtiI
 S2s+AGd/jI3ukIgfYZviL5DLUpQJgcEB8zx8SVjhhVakRnMmhf28+bQLA0fPIQCZCE92
 Zk5ZOA5+WohbtB/Tl+Ppzgt5aVP699DUtW8pYuy7RNyFnQ93eO0JxCMTeR4PQ6ShLQF2 1w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfays5cu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 15:02:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SDXZ4n026273;
        Fri, 28 Oct 2022 15:02:35 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagr6gd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 15:02:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFwmUAa0i9MjoNQLIybIjm+UAriHXMox2twmOIHgY3mZBv53r3p5r3tBV+Gmsfpt93YqICH4Gj3cvYeArjJPt1tJqq2dix9BtcsZV5hLeTO8Ri262e6DIbe0Rta7Kgr/pasO6GESaR/240FiyOTniAen5quomBp87PejQKRtU/uqRmx2XOivjtsAE/Dxmg98DWnY2yyDikoIh6ypLr7LabX2ktl+8qtxbv5e5gp2TH2vzX52v5gekT0G1MQXi266fMSs2VUSKZ2Vx2BClq3A2TYwdTW+9TcaW6FEgGxoQPwYUDmWR5fTcxo743ANCyvYY53m+3ADHUjFq5RBWUWcEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9WFm0z2EpUCWMQy6wDPEGGHP5c7i+yc9iG65dCyBRPM=;
 b=Qzn93U58NtYVxovwCi/dawSTQqECitD9EK2RWxKyS+lIwVagaBhzZEzBsdNct03mmYJlhQCwAePbnvU8O6Paq5EH7twZB94tG4xa5/ScK56XphFiS8cRs52JhG12wIhwt8OrI3UqFFEQxN3Df8KiQKIv2b+Dpl+V0W5gvg+nfVhQm/wfUxGH97oCQY5NNAy4vuj5LVoU3GP0cvwTAK200YZ0l18KHG0zWwCPR7JnxlR+zL3sR6H7apnWf/5rrObXxr7QHPx3VJtccu2j6dZHaDzCl7TKp8+gHxrKicEagO+E9nNSd5grLGK2MQN2TKvZeo9Umznwrud+IRJojquwyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9WFm0z2EpUCWMQy6wDPEGGHP5c7i+yc9iG65dCyBRPM=;
 b=fQiBiOuGjkW57SEt8GFJdk9fQu3rSt/y5xUbr2qY22qLgotMlw4Do5wmntAWkdUbu0iCEGcoAPHdG9YjXLn0uvZvcfNpTSuhi6anpKBDLYeexWEl0XxTOPXYIL5VdSf5Qm2E7P9jOk3ueJ4c5tSI6+0rXI46zYAzqhr8GBPk0jQ=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS7PR10MB5040.namprd10.prod.outlook.com
 (2603:10b6:5:3b0::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Fri, 28 Oct
 2022 15:02:34 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 15:02:33 +0000
Date:   Fri, 28 Oct 2022 18:02:24 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] ice: Fix off by one in ice_tc_forward_to_queue()
Message-ID: <Y1vvAJ6jOmKEUZue@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0078.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::11) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|DS7PR10MB5040:EE_
X-MS-Office365-Filtering-Correlation-Id: 746d84c8-ea35-47f7-467d-08dab8f57181
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fTyGymicOGwk7eXdhTPBUPVPtZDgwVvyScJ82p4O6ibNCNgf8Qk/lwLZdGGjacTRwyunI13csocVdwNDGYGtToalRaBIelglWQA+O/JkAZPc3eYhxZO7goPkHT26z1qWDfQGCZpEdv3DmN3sJYRj3YfM0xMIDgJa27DIppo5vnO5eUhgsRDCI3bws775b9vUUUmYN8rpPrpf47QCeuDONLmW/9MO85yqpjEq6FSE7+lfbHLRvrztIXMeeF9nLg7vhJY8nGYvRfJ7oovg7ptJ+ctdR9uqSMhYuTiBPML/Q0R8Jm9/so4klqaAz8uTD5xECWRmVL4yZcI6QsiNnIG8p8KKZAZbv6Ioloz456ays3AJoB0hTm6QEsOGbnBbApYOGRVrbIVb7UbHe2t17yq1HTtbMFofInL53Efm91FeBPkXAq9HIOumdi6LPBP9wKk7P+07taU2kqcsfv8co1sFeP7jvlKdk813J1Worv8Px48YWxhadzUON6VmZeDt+Dx5SAjSvHVtQ3TqHzKmPC1gBIEh1zX5EhbgM4StF61P1+9kk8EKj1PqDiDaJU0I2JqmHFByoymjS+U3fi6Wy7LEHC60oxqz2Er3pI4lrsniOSHPo1RmVPqRnkRMZaikTN8txlSCYfnr6gG/STY1SWaXYB4MS6p+TSjr+3igF3Vs3X69Huk7m1QMl78A59SZYehK33YPnZvd8MdNcb8u5PcA3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199015)(6666004)(478600001)(6486002)(38100700002)(33716001)(6506007)(54906003)(316002)(44832011)(26005)(6512007)(9686003)(186003)(83380400001)(110136005)(86362001)(2906002)(8936002)(66476007)(66946007)(41300700001)(4326008)(5660300002)(7416002)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JH68nHhQRQTiIpp274Ngx7PCaUTuRhiuX92EZN2ldp+g349pl78WSeT3e1zJ?=
 =?us-ascii?Q?om04Ej0nnIOp54YDTkh8Mnog0JWPdSxSg5MiNJQJ9npBY6JFLx3Ea1pcqkZD?=
 =?us-ascii?Q?QTQpVCyGAz6RAHTdJuKlwchsLtIlP70RWtBgIT97QioyCDB+JOCn7Qw2i3UO?=
 =?us-ascii?Q?G/iB5GFmS2uN+5LgUlhneZLiaNVLRemyOiVK/eGF5ZL9sWKeS87gtH9WfPoW?=
 =?us-ascii?Q?Ljg0vIFKMWIVRbo3dnOkK7an9RUmeiIUdss6uorat5oWtUeOJD0lxdkLAUX4?=
 =?us-ascii?Q?HKE3SI+Vd+JEqetYzYiwrRBGy44pp91wCATiTyzbYEYyfO7SOIhW6Zjkn0l7?=
 =?us-ascii?Q?Y0HTAVfReACZVAHSyZvzM249MnSFKQcfwsg8SRzoA9I+9qL75jq1X3s7hlMu?=
 =?us-ascii?Q?xlOU8ViIAhqlR/xa925N40k3NN0hi4TyZTsqhFyWXRmu2A6TG50e1fxSvsF+?=
 =?us-ascii?Q?94e9H3d5l4y6HWCPvP8WA5GAwAzPuTaIsiR2bYpa7vRueukqto2aPok/LRQU?=
 =?us-ascii?Q?10o4TRYOjNYW7kqv7hOxcrsXIDdVfXymkC1e5F02akNvYbK4gf0NoGfa49kK?=
 =?us-ascii?Q?h2GQYHvT+JDe7s64eCsF/etRkuKH2QGF3FuMJgPPnQhaLVo2ccpez/oRrYA8?=
 =?us-ascii?Q?8Hvlz8m9An16WQRQL51oj0XrCYBIrPg/pcC8VjmmAJ2HhWRbju1UaaWfAr+v?=
 =?us-ascii?Q?EG/illnAsTijvlEDCFy3IRA1mXkOmaDayi0L9MwjueCIz/rcQqgxfIA8i8Jn?=
 =?us-ascii?Q?JrWb3iF5t44cAnEIDWlCjSWoOtkEgxyz38o1Jm9sVwikjCxtQM2E3haWbBdD?=
 =?us-ascii?Q?taWjDwzYamYGVDPAoDC5I4uhA7WKd3vFOM0XfYkm2//cyY7DNpjD6Qrv46Bd?=
 =?us-ascii?Q?NvPfTf4Na5T4IEF+aBCQUCEFnHylLLo128P/OMq0QJp/zc+o4eiQMNOhGZTP?=
 =?us-ascii?Q?BvOTIzwn8fAc8hpso5KFcl52w1w+Osn41xoQg+c0Sj1a29X4yBI8x8Ftg5bw?=
 =?us-ascii?Q?jshXQT1QC/gKQYG7lI5YqZLlQiic/2AGwzkqLaJkLHJxHoy/s5DWKTV3pSIY?=
 =?us-ascii?Q?B3wImgLwKqZoxtDqmLtK+rsJuVzXuSX3B4wEuuHftP3MGl7KVEI10Hu0TSBX?=
 =?us-ascii?Q?dv5iv7KnvpoPScMyj2cZYGqWG0l7WI0Vp7zpV5nyWfEd2aeji+ZpKhjzbLAp?=
 =?us-ascii?Q?k4I2lKpYERyL1ReCKXxJ5bwXiRpcdes1RwLDE6uN1Bh0flJ7tf18jxjW8GjC?=
 =?us-ascii?Q?R6Nl+dst1NH2kxVd9PCi/eyKF05gDhSG/dDLQbluvv7cz3vJqrx5f8h9SNh1?=
 =?us-ascii?Q?mykJ70dpKV6Jxw2XKUWY8mk/v2cnb7FehEtgQan1fwMiL43UO3Di7tKWyaWi?=
 =?us-ascii?Q?rpApr0Al52pRNV8fGLVSkyaln8NxXAlm7QuUBXauZT8VncNrUt3U4Jtq/KQT?=
 =?us-ascii?Q?CoODNe9dTOpOrjjbTS8sVSGoYfU/D82Do5TLy6eRx/oU3ndh17K1OMlPweGL?=
 =?us-ascii?Q?q9IUIqv3suPFdyjZbCQLC0zdrP8rh/iI4QFt3Ojv2JX3rC09m9NFCWNR73yp?=
 =?us-ascii?Q?sl1Po11BKxGZCgPsz9pOuKfAqkDxip29BDaWdvsNS2/IFsWsNxJS/KjkXfD/?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 746d84c8-ea35-47f7-467d-08dab8f57181
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 15:02:33.8704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 52BqiOv8yiiOtb6JaRZQVlcEp8XUMfOyT/Zhs9wvYfLyuQ1ALUTDZVSV36vXAsyPlQO3ccKZLmtcyyNFxYILs6Of+7yPQItmQH20jHVRudg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5040
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280093
X-Proofpoint-ORIG-GUID: Cum0lyIPhE-UoOkhThu0oxNs86uE7IPG
X-Proofpoint-GUID: Cum0lyIPhE-UoOkhThu0oxNs86uE7IPG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The > comparison should be >= to prevent reading one element beyond
the end of the array.

The "vsi->num_rxq" is not strictly speaking the number of elements in
the vsi->rxq_map[] array.  The array has "vsi->alloc_rxq" elements and
"vsi->num_rxq" is less than or equal to the number of elements in the
array.  The array is allocated in ice_vsi_alloc_arrays().  It's still
an off by one but it might not access outside the end of the array.

Fixes: 143b86f346c7 ("ice: Enable RX queue selection using skbedit action")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Applies to net-next.

 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index faba0f857cd9..95f392ab9670 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -1681,7 +1681,7 @@ ice_tc_forward_to_queue(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr,
 	struct ice_vsi *ch_vsi = NULL;
 	u16 queue = act->rx_queue;
 
-	if (queue > vsi->num_rxq) {
+	if (queue >= vsi->num_rxq) {
 		NL_SET_ERR_MSG_MOD(fltr->extack,
 				   "Unable to add filter because specified queue is invalid");
 		return -EINVAL;
-- 
2.35.1

