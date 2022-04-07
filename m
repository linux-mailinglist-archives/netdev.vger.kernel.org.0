Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F381A4F82E9
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 17:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344692AbiDGP1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 11:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344681AbiDGP12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 11:27:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C704121C73C;
        Thu,  7 Apr 2022 08:25:27 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 237EJd2G004957;
        Thu, 7 Apr 2022 15:24:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=pRwMXJzn+OB7HOOFxe/oi9vjcK+e9k6L8YlpKWHBJNs=;
 b=volWHe0alp6PjN1qEXndQ1vF7LcY+YxUC/JrkfPQepeoIJQONhtapcFx6h3KDX+2AmkG
 qPLUHcE7mSz4agG0qGKLWq/GaeONzD64Pz4etKMX2DRgbMlcyREil263UyqLSp8SRuMy
 Xx4z73hqaCdfL+V//uz6uSxuRv5kizlkulLoBI0F3ema3UzY/CB8I1leqTRM+hWSeCYR
 5UoBBBGLXE6LovbYNK/R7cuSPz6ZNh9pEiFxglyrqgB1quoDszdpyaKSnVzYhTfMgowZ
 t41FbTkiqcnDjr4mUKK9y8vITRnXjFC79CuXOOhyStKE/EDlXNg97Lwer5QkowTW9HKR 0Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d934av3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 15:24:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 237DLVof029019;
        Thu, 7 Apr 2022 15:24:28 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f974e7f3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Apr 2022 15:24:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYLBFJcLgkbnVRRK/iwRULGI5tGFcm/W/ZbQSl49drHkxWfNaB9BVLyFMtxPoRTpXWS7fhMIoOEd6rwrSFGwLyfsU4OE+dCHgfCt3PTi20DId8IOJqJMxlitEHbgBelz/OCPh4NYDbITNM1+sAMhlh69r4Oo9LDgICbAC3m5rG1ciqaYDryKNvpDYJyomo8w1R7IhaSCt8Djw4ldRhFcPHlbqBo3yltk2hCQxpkycZ4Vo+evNkmGxQZ5T8Je0y4ryeBV4M8HW8k9b5RGU3ILSOhjHdb2gzRU9PNZBmYV3faUaMJ9Hyyn6rBChg4fhjbLt+6Mzcbj48n6T2mIuLqEyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pRwMXJzn+OB7HOOFxe/oi9vjcK+e9k6L8YlpKWHBJNs=;
 b=UzV8vHNRLD1T9JfEDC341y9mJz8KLMm4bN6AY4VkSRlWddhPnM+c5KSspwCNHcztDaCweJWuuHJN/Sqf6ZpHdlYY0isYgT84bPUg5zz6SAXghnDArxFPxR66p1GKuFJAbEUYZLgiwhfGPXwxmP6Ogl+FOG1SrTYMrNTJvVUqy4uvdwlh4Iemif1J0l2mK8W/QbPE8FQpH6zofw0rkRUJuBrjdfTSCBsSjtOh9UvrHG7GdQ+GCIDpg13XybRom+9YSHBx4jLsmLFBc+9+XI5zTD+pKODDXIRng31Z5uJ4/wtYEJ6drsrc26UYs7G6+WzRcpriYuhLHVNPX5NDVZPUwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pRwMXJzn+OB7HOOFxe/oi9vjcK+e9k6L8YlpKWHBJNs=;
 b=V/XhBj0DXpWnRhTXhFg/2SnCBTFfoxgYX5nxirezDyp+3jvVGdPK+g4IfGtXD26pZpmDfSePxlwqa3x9WfNnmwigMmFv/9EWXYyajITTKcXXl4whGIEFllWNRXJA69vdbfnellTQXAwdwFGnbMf/d2wXaBLQX0Qnhx70tNVtlWc=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MN2PR10MB3661.namprd10.prod.outlook.com
 (2603:10b6:208:110::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 15:24:25 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 15:24:25 +0000
Date:   Thu, 7 Apr 2022 18:24:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     duoming@zju.edu.cn
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
Subject: Re: Re: [PATCH 09/11] drivers: infiniband: hw: Fix deadlock in
 irdma_cleanup_cm_core()
Message-ID: <20220407142908.GO12805@kadam>
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <4069b99042d28c8e51b941d9e698b99d1656ed33.1649310812.git.duoming@zju.edu.cn>
 <20220407112455.GK3293@kadam>
 <1be0c02d.3f701.1800416ef60.Coremail.duoming@zju.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1be0c02d.3f701.1800416ef60.Coremail.duoming@zju.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0013.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f566e0cd-657e-43f1-de40-08da18aab282
X-MS-TrafficTypeDiagnostic: MN2PR10MB3661:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB366146CECCC6D1C358D88B578EE69@MN2PR10MB3661.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 01DruJKGx0jmnjb8lDtBxUerWM0kyDBmAsOo3EjyKSIKxfOYInvMj8BZtAmOk/qLdU0JpfSkXbZEMwdqfFmPjUpfNJ7oRqLOJ56h0kZXK66D9lJpvQRUIjv+GEAzGcW8bmIYg3MDIHc3bqLIqmSNPBa+0+Dnc6hjLt1QEEfXpaV8SU/17UDgnLGVpWXpsBEDBNAZav7ht9Li0QeVzehdAl7VmKopbx9vMCRQRJ3r9oy6vV5SCrmxW7jK5qlLHOACvHMwYgdbx+jkEXXNvn0HU0dz01boo+LcX/HBXIwy262oUw8bL0n5OsZrrTi4RuVm90xWpbSyiI4QQW0hSI7tFYHJsGeMfj6lyVDXmRoTbAcr3uCnFZjMgoTvErV9DDBxRRdCDDO/Z1B0jU4vQTsIZY+gm/oGHHVgyqPOAP8rl8t/YYwL7+Y+52vA+5yaUBwAeiYJxWJe21f6Kxo+9EvzGA5/nvmAHJs+V1RUA4uMNrr6RbPFbjs2yZGgEwzZzefpoeU3/Od+z8CHjKz7Pes3fAyp7F1GY3CPWLvKfjmHmgW6JBt8UbCIwcXgqMBQpvnLEk6U6Jy0nRP6lzQYO+oCqpm7nnNtkuYYCuyo4h9+q5Umh4dChg6LuqmGNwZVdTXq65jXLud4vOrCs0mWo+cjjvGdvp3aQlEu3u5ZUNEU6/ePKt6FMjO5VY4HHTa9V5cqLe6OCjGcnkzM1pLAtj6zrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66946007)(6486002)(4326008)(8676002)(66476007)(66556008)(316002)(6916009)(33656002)(38100700002)(38350700002)(86362001)(1076003)(7416002)(508600001)(6666004)(26005)(6506007)(52116002)(9686003)(6512007)(33716001)(8936002)(44832011)(2906002)(83380400001)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WLyn3bK7hUVqRYcqNvmOpEQ7E4jycAlnE5QNz1/9xZsXPZUYfx7KeM2T9SlW?=
 =?us-ascii?Q?qjhnNpCevu8Mn9hb+z8TDYgoK2SqXLWsDDymF8+fTxgxcukebgInhyukM/DU?=
 =?us-ascii?Q?lrUv6PZIcL4UEmDOWTB9kDdFy0UlXaZMoHO6YqfQzXrmeJGAJFf2i/o+Cr8/?=
 =?us-ascii?Q?frZLRE5Nx8ySYmjQeAww5AVJErx3YVad06UAcPqK031TlOl8lxwHoA1I/oIr?=
 =?us-ascii?Q?CHrXg+xjYAg2M19F+baRjUIzE2VFmlCIfQ8P9saG2UoztEHWuDo/ccAnZ4MY?=
 =?us-ascii?Q?lWzjoYJU+0ghPlLdvHcuyqYSHkv/n6GvHeKIJDD+BtdIFPzjxh4KAnVogYrQ?=
 =?us-ascii?Q?8FqjqAw8YfQX428cIhynxSq6x1tO2421ghjvkbA4pQyk8uF+igBPCnatHyir?=
 =?us-ascii?Q?sl+wTEPZZ4QDDB8f2daBxYyvmgxOLbJN1jeXyeSeN3NmIT2Q8K9mGD/wh5Nb?=
 =?us-ascii?Q?/5UH7Ge0SpfLCh6S7GgrBUFd5kb3Boff/FSrfe4/cuBB3xol1NMk7yb8NPFQ?=
 =?us-ascii?Q?oBQm0ATo/LCE6hOdwBIT/5TpciP3DoISkDgSFq2T6g8+vxCfjsn3ZCjRBZFK?=
 =?us-ascii?Q?Om7Nz9d/MwjwUTcv3RXsn4hWNwTrcjIBG7xZQ/98HqfLP2mJr+3OhfXfJXWQ?=
 =?us-ascii?Q?hkIKAnYXYbfyk9Q5ImcWhtGGksu/xCyV+NGF9/mu9RVg6NsNX2ABO6Oqutv4?=
 =?us-ascii?Q?OFCht8I4Jwo/4LBiz/W8w8sS/XN2wmf26qGcWzzopwj6n9YAfpegduqKSdY9?=
 =?us-ascii?Q?rkv7BPv7+V3twjIRnJ80xIjyvvl5tYCNp4XeF26egsecVZRzxfirYWoEpLRQ?=
 =?us-ascii?Q?ler4dZqxepfp1JgI0JaoYnFMES31w1zgY8McLfjejPs6WrzjhluP6SvkFhC6?=
 =?us-ascii?Q?c8TNeJqDz4c47YDi/y2VST+DYTGCekxpOM/4+93WVOltKDI2D8qwbDqlLst8?=
 =?us-ascii?Q?3Ip3LSmQOxfI43P10Pmx4It3PF/PksUSqcYdh23kp5BhI230IkD44kjPF5tE?=
 =?us-ascii?Q?LoNYWomOPWgN26YihmjzRPWuSvqBVfhRzS9OU23NYkcFMN4uQVzHqkYSVhR4?=
 =?us-ascii?Q?qeUPZvl3pkLRkze/VfSpVEZbRMHumVIghvHtprT7NtMinnTutb2KbCW/Y9by?=
 =?us-ascii?Q?90FlsIOfTJlpksVk2hsyduk6Tt40mTD+NeS9SUVYnlyMFICiqP3NZa3IFxc2?=
 =?us-ascii?Q?1kqfI93JTPC60UHt5M/h5j49z2g9FK2LagM+ZsBojlu2DTRhLOEcKHv3aKof?=
 =?us-ascii?Q?H2z1wMDyWs4Us2dyhfNeGyx6xhJmbsu1Iu1B2WO6XUaiK0lLcv0VPamclNYZ?=
 =?us-ascii?Q?USPqSXxV/6c5ChCVjHUKa84ICKNX1uyR/84Ha1Hf/fvYULXHm6i45VSocfEW?=
 =?us-ascii?Q?QPk2u/xcVbMMqHJQ+wylDp267YHfnZ9pcPNC0a5FZK79fnA1JbIuBWg5sicM?=
 =?us-ascii?Q?NUfDWWXWD8yrvE5OwPbd8isUOBWqyRuMO0SNbRiQcP1K1SWL7eqjzCLB34MY?=
 =?us-ascii?Q?KjL9+UFYKXiXCzihgBv5e3GJnBCqS/oxm91JNHTuNbiSt3mCI3uk79qzViUw?=
 =?us-ascii?Q?kcb/ZSkjy16D8soH5Y6EVzU4UUCHmC0llYeHuhU0JcV1IqHGHBduCALiTIYh?=
 =?us-ascii?Q?3GyKKqjtS/MnvOs8X/UENK1o4F6w51vBl2hmZIhuqTjBVpQVAA9ik1nQf/q7?=
 =?us-ascii?Q?EkC//8xzSg8rP9i2ibNVVJawNgu2l2j2RkjPSQSyYyTnJBczVrAvhptHEtNC?=
 =?us-ascii?Q?YMbOfNWz3SPwNXhtSqb6i2fN9gHDYgc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f566e0cd-657e-43f1-de40-08da18aab282
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 15:24:24.9149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hfy43mcctkb+CWz3PrijJzQGOr075FZMYxibI0UYhegryWxMMM4+BbI/hs6dBwIsNKWm4mC13ObR6umCAeq5IQyzJqGdx/J9g8n2UEESUs4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3661
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-07_01:2022-04-07,2022-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=857 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204070064
X-Proofpoint-ORIG-GUID: 5RoZQBvOFaj12tO73tidiV7V3bpFaAmu
X-Proofpoint-GUID: 5RoZQBvOFaj12tO73tidiV7V3bpFaAmu
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 08:54:13PM +0800, duoming@zju.edu.cn wrote:
> Hello,
> 
> On Thu, 7 Apr 2022 14:24:56 +0300 Dan Carpenter wrote:
> 
> > > There is a deadlock in irdma_cleanup_cm_core(), which is shown
> > > below:
> > > 
> > >    (Thread 1)              |      (Thread 2)
> > >                            | irdma_schedule_cm_timer()
> > > irdma_cleanup_cm_core()    |  add_timer()
> > >  spin_lock_irqsave() //(1) |  (wait a time)
> > >  ...                       | irdma_cm_timer_tick()
> > >  del_timer_sync()          |  spin_lock_irqsave() //(2)
> > >  (wait timer to stop)      |  ...
> > > 
> > > We hold cm_core->ht_lock in position (1) of thread 1 and
> > > use del_timer_sync() to wait timer to stop, but timer handler
> > > also need cm_core->ht_lock in position (2) of thread 2.
> > > As a result, irdma_cleanup_cm_core() will block forever.
> > > 
> > > This patch extracts del_timer_sync() from the protection of
> > > spin_lock_irqsave(), which could let timer handler to obtain
> > > the needed lock.
> > > 
> > > Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> > > ---
> > >  drivers/infiniband/hw/irdma/cm.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
> > > index dedb3b7edd8..019dd8bfe08 100644
> > > --- a/drivers/infiniband/hw/irdma/cm.c
> > > +++ b/drivers/infiniband/hw/irdma/cm.c
> > > @@ -3252,8 +3252,11 @@ void irdma_cleanup_cm_core(struct irdma_cm_core *cm_core)
> > >  		return;
> > >  
> > >  	spin_lock_irqsave(&cm_core->ht_lock, flags);
> > > -	if (timer_pending(&cm_core->tcp_timer))
> > > +	if (timer_pending(&cm_core->tcp_timer)) {
> > > +		spin_unlock_irqrestore(&cm_core->ht_lock, flags);
> > >  		del_timer_sync(&cm_core->tcp_timer);
> > > +		spin_lock_irqsave(&cm_core->ht_lock, flags);
> > > +	}
> > >  	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
> > 
> > This lock doesn't seem to be protecting anything.  Also do we need to
> > check timer_pending()?  I think the del_timer_sync() function will just
> > return directly if there isn't a pending lock?
> 
> Thanks a lot for your advice, I will remove the timer_pending() and the
> redundant lock.

I didn't give any advice. :P I only ask questions when I don't know the
answers.  Someone probably needs to look at &cm_core->ht_lock and figure
out what it's protecting.

regards,
dan carpenter


