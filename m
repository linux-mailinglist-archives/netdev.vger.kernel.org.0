Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD06534FE1
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 15:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347528AbiEZNVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 09:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238733AbiEZNVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 09:21:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672FDB2279;
        Thu, 26 May 2022 06:21:33 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QAnHlK012459;
        Thu, 26 May 2022 13:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=NU92ImzSWPOWYqR/1bvPyAiumqE/qIQbeAVUhPEKf44=;
 b=DHRolHdnmFvwz2vMbU47sXyNdBB/+rYlu25e6qaiG6UNurLUP7HnscwDo9RnN/quFkwC
 5oS5ejOVhCGkN6YERD5lEfXzn/EXHE06AXquyPWzvvwMGvp84+VcEWRYLfP1kKpIOzIR
 qcKZBAgQbrSZEchQVjfJsKzyuuiOpCFbwmzvraoRuutzp2Fr9b2qV1B4nSMK+k5FssaG
 V3PU5/UuzYhdZtLYD1M1HU5JAGmebRZSFEKgLIK0R4xXnxTh43nPbrjxKwQ5c7g2J7iO
 EsCARWjMsvXXYWd5zTLEK/45wAQajZUIlo0rFBV7Z0ALpM4Blvo+AZK8SKpNgWhOCaZ2 TQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tbvt1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 13:21:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24QDGDFn040177;
        Thu, 26 May 2022 13:21:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g93wxb6be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 13:21:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nv+FQ0d7NTvDTLBdCNTLxuNivnw/cGlEQk7QH9biAQHEUK44xTgZy+QqyeHWGb481bHbPmG3u1y8hK+EItikb/UWS8Iembjpesu+3R4yn+W9Zf/C42XdmnCG/Pwwnyb2TOB9SJhtvqbiNp4UtO1Bjxe79r5+ADo5dZZ1n+jBpywF8sCpw33e7bhp3DH6HMmpZRjm/kWR3NjnRNRkMUxi9KGJPKqyLKAWYz4A+gpjBF+IPSuqhhA/k2ZpA0GJWEDC9T1usufGhebLQXMOXBa0qV+XXECSSCspIGV7Dv+UDkDv5n74Np3qHEaA+K2xD4SuwBxLxv6/4w2F6VrZNT/KEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NU92ImzSWPOWYqR/1bvPyAiumqE/qIQbeAVUhPEKf44=;
 b=GsEjEuu1Fm8oVZfBljGD4GLOjfeBlnCarE/bYj+wDJfI0qho5UUjtp6cdFNvwstJgNHNpDvu9A6GvN+RnnjejsYEw/5ZvztSxRX8rd+Wias2eI00yS7l7z+Ah/Gy8oJZrEANE5l+Kw1X3CZj184Wo4c6tYP6fWr3lsmeb+t7kZ1x2uORRvF3OjZP/o6a2oEoEe8JN0bXwisO1lamc4xeNzlcR//wAsoqk5ctvfBK4eENklCrhEvQsVAGCHBWPJeqgDMe935+sYOoLMraD1b+UQ9obonO6fKHMkl5/cRQIN4H/11Pqt3TNtefPsieJybdNUGgK4Oea3lX1MbM8v2VYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NU92ImzSWPOWYqR/1bvPyAiumqE/qIQbeAVUhPEKf44=;
 b=jOYZXoYn5b3htttzLW1/nkVOIi2OycwkA5oNQ0rHbJHQ8Xy0fmSC2Bf//gZJDlEufSRkg+eXOh82zjsftbZDgu3Khtiqs6kv4vjV0+8JEEqzsMqS5hyN7VlFtRBtKLloFAEhv9KrYH0arFMxo+k+p/RF9F8rHAg4ikK5A0GKjj8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DS7PR10MB4928.namprd10.prod.outlook.com
 (2603:10b6:5:3a1::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 13:21:13 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 13:21:13 +0000
Date:   Thu, 26 May 2022 16:20:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        Eli Cohen <elic@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Xie Yongji <xieyongji@bytedance.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Longpeng <longpeng2@huawei.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        "Kamde, Tanuj" <tanuj.kamde@amd.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        "hanand@xilinx.com" <hanand@xilinx.com>
Subject: Re: [PATCH v3 2/4] vhost-vdpa: introduce STOP backend feature bit
Message-ID: <20220526132038.GF2168@kadam>
References: <20220525105922.2413991-1-eperezma@redhat.com>
 <20220525105922.2413991-3-eperezma@redhat.com>
 <BL1PR12MB582520CC9CE024149141327499D69@BL1PR12MB5825.namprd12.prod.outlook.com>
 <CAJaqyWc9_ErCg4whLKrjNyP5z2DZno-LJm7PN=-9uk7PUT4fJw@mail.gmail.com>
 <20220526090706.maf645wayelb7mcp@sgarzare-redhat>
 <CAJaqyWf7PumZXy1g3PbbTNCdn3u1XH3XQF73tw2w8Py5yLkSAg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJaqyWf7PumZXy1g3PbbTNCdn3u1XH3XQF73tw2w8Py5yLkSAg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0025.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::13)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eab60510-b8dd-4cd5-4ae6-08da3f1a9b24
X-MS-TrafficTypeDiagnostic: DS7PR10MB4928:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB4928876772E176221D6CC3A48ED99@DS7PR10MB4928.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s0n/50L33b1zymPqJ7V0N8zHatprM+oEgPskvO9Gx7CV0rDrar5EGcEdX5fx5/oiwK15YoFb5LLlOJVDXk/35qbXOQoTRUJwSCJm6TlCX4Hdlg5hQc5dFI6ZJuhl/TyjEy2htmoSbTdLGCLVZwhXEfFKNOazCiRnuvKpMNtyJapIXf3GVYJXMPVLwYaIiPmLp2a0O1xb0NVrDW8nqQX9IAGrKv6g82R96Yf4mT+qhMkTJt4UxSX8DR8bp4ydcWAgS4TSuV+YOvDvJgDyCYxw4bcbExJzKS5xFJL/wt7gGZ0n22svVk54sSOH1xXXgjNa1QSJAMhsown1vL6TBcfEP6b/nbSGoc3NOwjFleFuu4hj6dq4b7dj70xYcylmsC5LIL2iTgNaoC9M5v/X6jbLOaKWK7Uyfzrmcu3CiomnhsjIn5D+WYJnA59QI0xM6qGlnIWqWqRMG1Atvws1TQV/Wyea6FRsbCkB2zwxXucTs0mLPdoCjSzQAqfD/DSZTasRZyskRc3AJ2xYcnwt+dJye0DL9MVpauBeWbNihHVx897c7VDJQ9zEe7MZwgMM22OeMPDyIrHCMdgRxwfslsdftxCB7Sc8ZY8k8NIdajgsdMvuuKqqvvWOqj7F8KaKhVK91kjAyAweMErAxnfu6RDWCAdwp+L0mY4XPFGTaIOhpzoEIa7uZZAmvf0M0Hh2NSGumXthQaeCigWOBNeaPRWj8igryZPs8Z8kM7GiceFqkSc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6666004)(83380400001)(38100700002)(6486002)(54906003)(316002)(52116002)(8676002)(9686003)(6512007)(26005)(6506007)(508600001)(33656002)(6916009)(186003)(66946007)(86362001)(66556008)(66476007)(1076003)(4326008)(2906002)(38350700002)(44832011)(33716001)(8936002)(7416002)(5660300002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5isw/V3UlVhOH2antEhezCal+V5vUNGewDiqJoIEjBvW/QVv/Dkx4eaTLoHz?=
 =?us-ascii?Q?472zErYtCjTs3Jh3a3kKE1dZsqPQ49QTG+yQ59YzCH0+nZ6OpH0OIkaGnlkA?=
 =?us-ascii?Q?3LqDazxJa8wusbcNiYtUBHU13JJ4f9K4iamOHehY2wmMNqSqKnxw1EjIxEL2?=
 =?us-ascii?Q?kFwFHcbUGUwwFTwSm0iT2Sb3aFf6Gfy8kzM6lFVS8/dMTR1pV/etTrTZXGwG?=
 =?us-ascii?Q?4q9pbfe7Uf43nRw6ZxyF5V78u37jmWIgoqlUsh4LxDA79v58rVR+xRKOfoyh?=
 =?us-ascii?Q?ggcCVPnojCnb2LPxupErREREFr0SWx3IqtALgySEsPV3RzmfRQ8mBeCDQK/O?=
 =?us-ascii?Q?+EntUjPAzwyLgeM/HkkyYHQegudxhe/3kVi55uOf9M0ofH74dTGfSKNOkKSY?=
 =?us-ascii?Q?Uzc0lnFF8NLiyaoPhs+KpkQZMzPl33CzhhwQo27kGPYthMMpQmW27WD53/cE?=
 =?us-ascii?Q?+5Xt/erKW/dXOuceGRKRs1OxqgLAQODrgMP5P8d0NLPYbcMPmbaw5yJOr4dE?=
 =?us-ascii?Q?HEQMe8q5W6LSZgS9SFMWrmRDbVT4h/RWzygbABicum9qA8BJyoLhuFPAdT5w?=
 =?us-ascii?Q?O0s0ZbVKQ9DqZsH9D5lbWxFb26KiLObE3+QJ5SePH8dmOYexIgG2hQs1/mgS?=
 =?us-ascii?Q?AJH5oPdGOSafsn/Mh/znY3XlCu/mkEVSAoN6bt1uD98oYmWFNaUG43Xa4Iqt?=
 =?us-ascii?Q?AC62MIF+Q1GlIvrmlnYimA1SpUmZGoQQvJG89WNZruQKn9YPuF7ivCqTkNC/?=
 =?us-ascii?Q?noE8cweQDGp26aMn3Z0O+ykaslHhpzNOTyAnb/k1doLI86jhENiZUUbJ7lst?=
 =?us-ascii?Q?7vxBjbJuJaBkMdP7Km3k8jfXoOiv/JfKBycH+s5E4LHorUuACzGEoEOZXeJs?=
 =?us-ascii?Q?utmzfWzHpBGBmKNctSdFMnbuGieLZNP62cCpYv45pFqB/h7h9Zftf6oh8IE4?=
 =?us-ascii?Q?BwF/MHNNVxKF5VHscxrtQopM5LmI6YR+2arAGbSkcFrsqpwW2OVPy+okQF0J?=
 =?us-ascii?Q?56emUFMtk/UWlXucV0LrOAG20CWXymth/GhxyyqT01cp7quLb/bWlVb8EkWq?=
 =?us-ascii?Q?Th3HbOoPerjTlTiDbIWiMaCrLAr1gPSgN5BAx2hLxQfdD/xU0D5skz1l7cB4?=
 =?us-ascii?Q?Cw8LDO+8ZEX1HIGU0wFZ84w+7v1I2Y33AIe6KAtVBIbynCI9ctuUrV2ZsZUp?=
 =?us-ascii?Q?5FRQ3Oz69kJHJDQRjMHEYKZ/aqGDZPS1gfwiKcMlsqRxkM6pulUUOMXBC38G?=
 =?us-ascii?Q?g57ud0EjVGCqxeWEN+NPfUDkO3Z1DvE7NeEXoMfOjVTTPGb1lhvphbRX3W+3?=
 =?us-ascii?Q?Nt+R4FdeTBHo4+NtdUAjDqj8j4am2qUcAnT43M9hRAJPy/C/GExRb7H5DePV?=
 =?us-ascii?Q?JwVfg1kYcXg5YySQ1QKMP/36qMbgsx/DW0jlE0+zI98xQ9FS17lNK1/jf6OK?=
 =?us-ascii?Q?UQsRqX+voeQLoR3WEFhv5QiwhnZWGb8a4sJ1y83gGkHUKGCwfoKT3jTNaTUO?=
 =?us-ascii?Q?ZJW3cruMSJF96TekN/X/GxagQuH7Tx2aZtPdkKNMR4RdwoChjn7LmRYSfiFZ?=
 =?us-ascii?Q?k/eUOeBoz3eozOduDnfu4LgPtWRfi6ULNe/s/acbBcnpCaOKm+a/PqkJOPf4?=
 =?us-ascii?Q?mY5xCw2Q5jEi3tVyf2PDKqftmrPvYBT+t3uG3EkjDfVffcQ25xAxl6LgLFs1?=
 =?us-ascii?Q?Ic3lyK/klpjSVcaxUxZ1KBZUJZAJ/t5yKZ/M08OoEEqZQWRJcXQ0rklPF6PM?=
 =?us-ascii?Q?2sHD8L6jxbiANDq+9VhMFah7NRssYyg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab60510-b8dd-4cd5-4ae6-08da3f1a9b24
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 13:21:13.3236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c+GZqTA8pOB/81rs5smYK+O5nSEXQKafx8PxEzqkKQVJZMb6377NGRx8wmm9WhnducLmW+OU7nBlK4MvX5zqw4MNRJUzSBz26bz2lXiM45I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4928
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-26_05:2022-05-25,2022-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205260066
X-Proofpoint-GUID: ASKUJ9De3lMvI1NxJF5eRWxVX_VNbhWz
X-Proofpoint-ORIG-GUID: ASKUJ9De3lMvI1NxJF5eRWxVX_VNbhWz
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 02:44:02PM +0200, Eugenio Perez Martin wrote:
> > >> +static bool vhost_vdpa_can_stop(const struct vhost_vdpa *v) {
> > >> +       struct vdpa_device *vdpa = v->vdpa;
> > >> +       const struct vdpa_config_ops *ops = vdpa->config;
> > >> +
> > >> +       return ops->stop;
> > >> [GD>>] Would it be better to explicitly return a bool to match the return type?
> > >
> > >I'm not sure about the kernel code style regarding that casting. Maybe
> > >it's better to return !!ops->stop here. The macros likely and unlikely
> > >do that.
> >
> > IIUC `ops->stop` is a function pointer, so what about
> >
> >      return ops->stop != NULL;
> >
> 
> I'm ok with any method proposed. Both three ways can be found in the
> kernel so I think they are all valid (although the double negation is
> from bool to integer in (0,1) set actually).
> 
> Maybe Jason or Michael (as maintainers) can state the preferred method here.

Always just do whatever the person who responded feels like because
they're likely the person who cares the most.  ;)

I don't think there are any static analysis tools which will complain
about this.  Smatch will complain if you return a negative literal.
It feels like returning any literal that isn't 1 or 0 should trigger a
warning...  I've written that and will check it out tonight.

Really anything negative should trigger a warning.  See new Smatch stuff
below.

regards,
dan carpenter

================ TEST CASE =========================

int x;
_Bool one(int *p)
{
        if (p)
                x = -2;
        return x;
}
_Bool two(int *p)
{
        return -4;  // returning 2 triggers a warning now
}

=============== OUTPUT =============================

test.c:10 one() warn: potential negative cast to bool 'x'
test.c:14 two() warn: signedness bug returning '(-4)'
test.c:14 two() warn: '(-4)' is not bool

=============== CODE ===============================

#include "smatch.h"
#include "smatch_extra.h"
#include "smatch_slist.h"

static int my_id;

static void match_literals(struct expression *ret_value)
{
	struct symbol *type;
	sval_t sval;

	type = cur_func_return_type();
	if (!type || sval_type_max(type).value != 1)
		return;

	if (!get_implied_value(ret_value, &sval))
		return;

	if (sval.value == 0 || sval.value == 1)
		return;

	sm_warning("'%s' is not bool", sval_to_str(sval));
}

static void match_any_negative(struct expression *ret_value)
{
	struct symbol *type;
	struct sm_state *extra, *sm;
	sval_t sval;
	char *name;

	type = cur_func_return_type();
	if (!type || sval_type_max(type).value != 1)
		return;

	extra = get_extra_sm_state(ret_value);
	if (!extra)
		return;
	FOR_EACH_PTR(extra->possible, sm) {
		if (estate_get_single_value(sm->state, &sval) &&
		    sval_is_negative(sval)) {
			name = expr_to_str(ret_value);
			sm_warning("potential negative cast to bool '%s'", name);
			free_string(name);
			return;
		}
	} END_FOR_EACH_PTR(sm);
}

void check_bool_return(int id)
{
	my_id = id;

	add_hook(&match_literals, RETURN_HOOK);
	add_hook(&match_any_negative, RETURN_HOOK);
}

