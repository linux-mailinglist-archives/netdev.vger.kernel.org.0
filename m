Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F194F7E09
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 13:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244788AbiDGL2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 07:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244816AbiDGL1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 07:27:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C4D5F44;
        Thu,  7 Apr 2022 04:25:46 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237A6uTV024447;
        Thu, 7 Apr 2022 11:25:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=MaarpEtlYbUBwV21Ndt89ixaKQpb70WgN+t+/MbCejQ=;
 b=Y15aLm4WMlphdzDM+CG/PbcL1k6O1NtsrTJ8SJ01rT/rxRaRjmW6CcM+hw7tyHA3Pr+L
 V9izSZ1Z/U3l6bRfXQkqYxw5+c5Kjd1ZII2Btx0lB1JAwywsaH0Am+Ui79M87T2YFbvz
 rs0CrmVXXvsHUBmtYkahl6Hay9ja0aAxbgYQEOOaxcoc3saWb0IgYrX+oCZy9EC6d6/f
 Vp29cuDxpGeu8/lhE/URlAiulb/EOOLNhZb3h5wZ7zfROpFXYD+G4Q7khswjiCez4IzJ
 3vFYzmlwcuxQwGVqsKa7JWLyIMe9FRVMUJOHgQf2KxyiUiSnyIEGQBUqkxeAWVJBcOEZ SA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6f1tbtas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 11:25:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237BBasE004314;
        Thu, 7 Apr 2022 11:25:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97tt6myb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 11:25:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAvQtd8ZCPegRxVK+12inHiDuZqimdgzxRsDO/QOEMnSXm55Gf8TiINOPfNh006Lswc1zkMiBY3KYUaid89vzQ5GDrEpPbCDnIa7mDa5Ko0C6bENWDVuxRCZYnjJc2nqQPRNHIbxahfDWczPvk8WrTlSgs0mOUSIgIzGX+Y7ep53nwu9IsXtFsUbOsartUNhCiT2fwvV5DIMr/2Vd0vFhg7y3djBUcdcCQJa+0EkXMDtRA61p+6LyV0oNIAfs+qoj6ULeDJL0RBjFGj3V2G39gwQns1OjrNOIDdzwVKCwz8bnZaZpafubzs5Xxv4oboYGbjrCxLSDpNfpYh2Fy2kjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MaarpEtlYbUBwV21Ndt89ixaKQpb70WgN+t+/MbCejQ=;
 b=DBHdyp5Za0Z6l7uCe5aVp/Kxrnul4EhrVzFThZFR0jVeyn6/kwlQpDSXzS/p/hYbTtj9KK53xA6ck5icaJ6xruyfNy0vx66aVbefgfcU4sk024hGv40StVepVXjs+z20MGeSE7aICTAVpcZFVrW2/cAIFSJLGWgjluctOtfQmyNwOCYMOPHSjK7/03hXifcRp2FcsCYbtLjLE0nzugJ+VheJuy+34BM4In4itzHAy3KX0g5sn9VeWl9H9l2x+Aqzuexd360TNIU3n3NrP5VETps2TABByxyVaUF+1/zfoRCVepqIWvTjsKmIa1lcaEbQUm9rG51de0FeVtkmeJHILA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MaarpEtlYbUBwV21Ndt89ixaKQpb70WgN+t+/MbCejQ=;
 b=jT2fYPKWTVoZsBZXInzw7gHt3LVgWn3Z7tpDMdrOf5pITmRbXG3cIXTf80AoaYQXThF/5ada2U7f4DDcx/qNPZpnyucpy/H2341sPpuFCAv8VK9YmrnP2GKL7P7pcagwpppptLZlPtGU+Uyg8zebAtv4CKEJx/QC01pcf9asUHM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS7PR10MB5087.namprd10.prod.outlook.com
 (2603:10b6:5:3b0::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 11:25:14 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 11:25:14 +0000
Date:   Thu, 7 Apr 2022 14:24:56 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, chris@zankel.net, jcmvbkbc@gmail.com,
        mustafa.ismail@intel.com, shiraz.saleem@intel.com, jgg@ziepe.ca,
        wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, jes@trained-monkey.org,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alexander.deucher@amd.com, linux-xtensa@linux-xtensa.org,
        linux-rdma@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-hippi@sunsite.dk,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 09/11] drivers: infiniband: hw: Fix deadlock in
 irdma_cleanup_cm_core()
Message-ID: <20220407112455.GK3293@kadam>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <4069b99042d28c8e51b941d9e698b99d1656ed33.1649310812.git.duoming@zju.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4069b99042d28c8e51b941d9e698b99d1656ed33.1649310812.git.duoming@zju.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0057.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3e::12) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40027955-e4ae-48a6-a7cd-08da18894856
X-MS-TrafficTypeDiagnostic: DS7PR10MB5087:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5087797915649BF242C92B1F8EE69@DS7PR10MB5087.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k1DIZkT7SxTkDFQx4XCWiAWEYpOejAH+TI/VBxPx2lJRlABfNW2kjE3/FoOk230bVnE4CoY2xyiCkq1C++TB5xdghQh+XIHiIrO9VAay8QX0wlx2pam8VeZEkCvLvD86MwsQu7SUyPtxMm7zBJ8L+Knw21Mg22sZGv5v58wzP07Z9xWOGHg2gEBmoYsXhaYoQjxP1xUVJIX8V6WhYUJ54ntgF614ceRsbIYkW/oSV/LK4uNOOQMYwnoPHAVCjJOxoxhJ/mA5ZM8q0A3Etap5AB6aGkGKAuhYNAidJUC31uVj9OO9N9NasLwsA3ZZVbo6g2RvilzGrppAVD/JeBudy2qOerBvPYmgOddvIRGFz7WlaaddPzSY2vn3kUDHsN58S61IVm4/2CxYuDvFjCaLPFwGeCAXoZAtINEcKFmqkb83MDO542rDy4oRtox0TjqtM8SoS04Fpb1hBtMNpgs1zKUSJdo+eklNHyGYMqm12fXHYxLSIvQfaDv3Cl8GWUcuusQ9L0P7aHb9gYnWlNJghqzGW+zqhkcewwF+rznarhIIGn8QYEf3GUryzthHO/K2tqW5rVG9J+4LGWzeuiSWoHqGvIHlj7YlYpY9/oPLMK1mZTC9wtY09Vh4Uz5/mh28Gjvk7z5P80JdGp+vbfBceWGNMXCRfzR81NmSwWy499FCbi0azKxLQamcXMmFofrV9/tGfSTPknkcNnL6vAWKYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(83380400001)(9686003)(26005)(186003)(6666004)(6512007)(6506007)(52116002)(8936002)(7416002)(1076003)(66556008)(66476007)(66946007)(2906002)(4326008)(8676002)(5660300002)(508600001)(33656002)(44832011)(38350700002)(38100700002)(33716001)(6916009)(86362001)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UlBc+ZrT7Z18QMKD1850bZcfPEcP9YuXNf5iE3EzB8OumU5it7PCWop4Cs9R?=
 =?us-ascii?Q?coD3HiKAjd2eNM/yl8uHBh/6h00FQ+xyegj6hGKgNzw7dkJ0Ni2g4Pz10Lcf?=
 =?us-ascii?Q?JHKtpJRh43oA8DjWRRS1uOXD+//ELAVriocnaRg/hB6O+EyFTukNwlI2vDWQ?=
 =?us-ascii?Q?tSuoGAjIuG94t3r5cZkLhfDMfkqUv0EXKH/guvEeweSb2f/E9hGHHr5QTGnY?=
 =?us-ascii?Q?qaopIqUItQI8HXCa3Y62hJAW4vczs2cD/j6l7wvhrY3BYUcnqr56sfTYvOzS?=
 =?us-ascii?Q?kQYW+VypZbPwpMmfOx842fBERDIPhSk9D7C2veHZ9+20tmSp7W5y+ZDz5SQC?=
 =?us-ascii?Q?AVHiiFHsY0Pu+bXjMTTPD+Ont/Zgl1Df7Vp1XBUhAV422I8f2Y+nWML0eZyQ?=
 =?us-ascii?Q?2myACaFnDvfzzSjD+DjG/gz9OxqeOxpL7lVGN9476sGdDbVBCo4eaF7E25Vd?=
 =?us-ascii?Q?9iYEjqEL1MHCTLwyDWt65uXqhbm4bEYvgqvD+iH/q6tRoVeXas1KHhO/Efg/?=
 =?us-ascii?Q?6myfjyIJB6VSjsn0KgCpirsn4S3Fa7dBtvIwdLOx27FrrGkEmts0q9+l46sO?=
 =?us-ascii?Q?e3T1dueI/o1kUm2iLVopfBZXGA4MBqDzxuz901+b3vmtpnrvONCkZuepjloU?=
 =?us-ascii?Q?HpqrJ54ZNrjx/ZIlndshVE7fppCsBaXJgiQQ/nRtKXbA248Gxr17BRKyz7bk?=
 =?us-ascii?Q?xD8d6zRm0t58hlMchHiIx+LnnUl1Sh8lE2KQRKLrCBSJDPy2zndCEYx62p4F?=
 =?us-ascii?Q?kfKWy3H7EBAdBrpSP2SSOlSoc12RS8Stm0Bn+g8GPsS9xfSwP/SMMU2kbaS0?=
 =?us-ascii?Q?WiGxJzB/rV2Jqvu8E3xt1Gf5p3ABkzJAGFjYa1BCuKwGjui7srWXikWPwikH?=
 =?us-ascii?Q?H2b+2QhXgYUEETABbmdIXOWRhE2Cy1S3mM7VmIZMwM3VyjKpcWqpt5kEnnpu?=
 =?us-ascii?Q?KcbQ0Pa6pqk1wR3KLJcVao6lzp1d0KEH8eOitBtX5lXNSfbHCxhOvMDC05Zc?=
 =?us-ascii?Q?XoJ6Uf+dBXEbF/PPlMN9Ixycdg4GIiBO+yIDiEP80EcotKAEtShHJ5Da0D5d?=
 =?us-ascii?Q?97LPL8NkJqa3jcWmETR6tQHlMa4u8dAv/MpaR1GzWwYDG2EN4/qKFfJpeknw?=
 =?us-ascii?Q?RC/nOHjD9jXUPyAQ5HOu/iAYmFFJpPQR4dv2f6YjzPquUv6XOaPZIl8PUG35?=
 =?us-ascii?Q?QFjb3u3G1GAfdWckCnIY4v7OIbt8F1W9e3jej1om/NHjqbml5X5BiHFnZ1FV?=
 =?us-ascii?Q?KzpevXmrje4Fzv6bRExwvtn0hEX1UD293MvXKk07CtxiGPOiy+DuqgY/nlcN?=
 =?us-ascii?Q?Pj01Hyl9YhtZXpgIl7pATwN2PKCPCpC4eY2j+pR7PFUcMyEGVge5EXLJi1T0?=
 =?us-ascii?Q?nLkNx7dZW7VRjWyzshujlfyng946BQt5E9p0AN6sCS3pAxD4dyo+ERHFSIEa?=
 =?us-ascii?Q?6avNRKNGdvLaqKCSmF14LrYClUk5FqBQEOJ6QyA8UNQL4Dh1t/8YuZH0daNd?=
 =?us-ascii?Q?d3stahhFSz5g/uH3loSiHCSywh+lIXEBsjbuB52l/CRfknYD26l57JVmXqf3?=
 =?us-ascii?Q?fw3/wXdX5HotxwD/L5RnmuTimZRjsTh6HaSNVTPVCW6vMgbVtSO3cQaJCsGI?=
 =?us-ascii?Q?Yy0+bbS+KyCizq+5FjlunGuUlQmfDwqaJacmSdkR39dNlvOzj66Yc3FB0yYu?=
 =?us-ascii?Q?eWKctXjgX5H6nvRbA1KB1+RZVuK5nLyRxfGNijtZkND/rC3inOMLKgSFKzRI?=
 =?us-ascii?Q?xSPKhBnTl8noXVPmtcAsqUMxYvLEg8I=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40027955-e4ae-48a6-a7cd-08da18894856
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 11:25:13.9882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: moWB1Voj/j0hnWZ+tEVa2AUsrau5+zGHvb6hN5TzuYS+Re/ikaBVfuRc1G9AKuCZLTgNK0JolVJAf02KudX+VkkskDeXsr7i3E+JQQIFpaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5087
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=806 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070056
X-Proofpoint-ORIG-GUID: vyeuNwlmkuby6vzU39pv8MDCglSJkh-L
X-Proofpoint-GUID: vyeuNwlmkuby6vzU39pv8MDCglSJkh-L
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 02:37:12PM +0800, Duoming Zhou wrote:
> There is a deadlock in irdma_cleanup_cm_core(), which is shown
> below:
> 
>    (Thread 1)              |      (Thread 2)
>                            | irdma_schedule_cm_timer()
> irdma_cleanup_cm_core()    |  add_timer()
>  spin_lock_irqsave() //(1) |  (wait a time)
>  ...                       | irdma_cm_timer_tick()
>  del_timer_sync()          |  spin_lock_irqsave() //(2)
>  (wait timer to stop)      |  ...
> 
> We hold cm_core->ht_lock in position (1) of thread 1 and
> use del_timer_sync() to wait timer to stop, but timer handler
> also need cm_core->ht_lock in position (2) of thread 2.
> As a result, irdma_cleanup_cm_core() will block forever.
> 
> This patch extracts del_timer_sync() from the protection of
> spin_lock_irqsave(), which could let timer handler to obtain
> the needed lock.
> 
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
>  drivers/infiniband/hw/irdma/cm.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
> index dedb3b7edd8..019dd8bfe08 100644
> --- a/drivers/infiniband/hw/irdma/cm.c
> +++ b/drivers/infiniband/hw/irdma/cm.c
> @@ -3252,8 +3252,11 @@ void irdma_cleanup_cm_core(struct irdma_cm_core *cm_core)
>  		return;
>  
>  	spin_lock_irqsave(&cm_core->ht_lock, flags);
> -	if (timer_pending(&cm_core->tcp_timer))
> +	if (timer_pending(&cm_core->tcp_timer)) {
> +		spin_unlock_irqrestore(&cm_core->ht_lock, flags);
>  		del_timer_sync(&cm_core->tcp_timer);
> +		spin_lock_irqsave(&cm_core->ht_lock, flags);
> +	}
>  	spin_unlock_irqrestore(&cm_core->ht_lock, flags);

This lock doesn't seem to be protecting anything.  Also do we need to
check timer_pending()?  I think the del_timer_sync() function will just
return directly if there isn't a pending lock?

regards,
dan carpenter

