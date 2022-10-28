Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B811611410
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 16:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiJ1OIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 10:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiJ1OIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 10:08:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F231DF41E;
        Fri, 28 Oct 2022 07:08:20 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SBNtZ9003776;
        Fri, 28 Oct 2022 14:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=zDIAzTSY63brcUEUymq1GphjBGryegzoGnkVDKwZ2Tg=;
 b=b62E8tR9kIMc5Q7DphEB2Xki6uaILk6X8MvMbghu79QaBH04/67lkZ2jNExSfQAllEWt
 1E9XJAQeDV3wtyLwcFdGyELoyqGp5bEvSP9vmttkilFQtGPEQcsDPgZxAJD2iqBzYkyM
 4xH44tWKFyuTNq028ejGDQtXFRcHd+C4Q0/bMPOy0CZuXP2tKTcRqVYr8Hjd4WF8pMc4
 EO7DGBmT4iM0aNRDU1PUpt6kBfSNKuPqSmdfIHVjVYwh3Opd32XC7n3ngE7obrmlKnZR
 vBlUb4JufIKE5BKt1P2jR5ZGabiMTCrYSwgzAlv9zF+zuRNDMNDs3MMBzL721Kq6ZvTr tw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfb0an2hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 14:07:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SDORK6026386;
        Fri, 28 Oct 2022 14:07:22 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagr4y12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 14:07:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhC4R/dTHB4mbB2PK/PSVBQtECvINnSa73YABy7kXrQg3d5Cdi45vU1kgj0KqtnI851eIVArqjSYYtkr0rnG/guKufZ6spwAMhWBWIPgTmNmkPBL06nxfSQIJ6x4Z5znk4dchYQpUd12ZGjxPJ6WbNzJXMdj2lNGt8UdgL4jB50UWRT6aM6XTyFoUQtR5zsdRvhedU0IEJvF9ARev3lIgUjw1QYm6p1xKFkSANLtyvQniQZ5GFBZwJJHAM9Rv09vxlbK08qewpMPxGPSmsS9xA3i9QRsbPOe8eq97WaRCS8p8wnQfHKPmppOs4wM1G8DrE139xTuDdnQ+Z6dBMN7nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zDIAzTSY63brcUEUymq1GphjBGryegzoGnkVDKwZ2Tg=;
 b=KmH29HgjyppNNtlqQ5awKUF2vaxrDDmejSSgjvO/YoAAlgk9v4F7hziSGavxr4CKf4uPC4BOcB/B3vYdMPEa4LMs3GKP/Y8Z7KssS/gDaVOPepfbTRehC3QWqfloAQCCsYF8jmeOZDe81ZsPjKrPkhfwsAEFv0CYbunUem7yLLlxwUy8hFo7FOdNXMPPd+tJakyOub7L3K3LjVf7ISq0hWKSt/m72nqj9gHjuZXPXWEkdC9Tuit8f7gABcLHdthlDQnt/yc/1EPnCt2c+vRMLITnZJobNVOPeA5yeqhmU0pp22cHlCMmgIYsgpfc6lw0CYCQQMpNH9c/FoKS2tTlUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zDIAzTSY63brcUEUymq1GphjBGryegzoGnkVDKwZ2Tg=;
 b=P2MAcoRm42y7rO5lvXCYVCHy+lWe98aGRRgRpzxwXq5LlvY4dJnQX54lvwfu1tn2edVRZEpbq1evtdfD7KSEzAZSsPTbOy/NsExnTd25DU7VyOmyvCGQ7gifucCxXryvKv6H1ce+PtrAFdFPuYvOh0bwA91cJiumM3lIaCbDaxk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MN2PR10MB4221.namprd10.prod.outlook.com
 (2603:10b6:208:1d7::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 14:07:19 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3809:e335:4589:331e%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 14:07:18 +0000
Date:   Fri, 28 Oct 2022 17:07:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     =?utf-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>,
        Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 01/15] hamradio: baycom: remove BAYCOM_MAGIC
Message-ID: <Y1viBi7DAAJAn7kP@kadam>
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
 <47c2bffb-6bfe-7f5d-0d2d-3cbb99d31019@gmail.com>
 <Y1vccrsHSnF1QOIb@kadam>
 <61febb47-28a4-3343-081c-4c06b87ba870@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61febb47-28a4-3343-081c-4c06b87ba870@gmail.com>
X-ClientProxiedBy: JNAP275CA0001.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4c::6)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|MN2PR10MB4221:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ae65770-0a78-490b-386a-08dab8edb97a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RyhzLAZ/pO3CLkPCH69fb8Ahc5/aK834URE9BPWBSqpl3OSiZDZSXx9dO1veBvaAaHTOnlLPH4FOTEiYD2bFDvhqFw819GYAExeCM62TiywzTcSKPZ6ti1rtF9/Jbx2DN0D/oSoLmH6aF+saKZy65Nf4tPVTBZdho4PY8CuUdSmOCq7A17fJirLETiE+lvqWnOBk58QxsJ4WvpXMyPN2jKmqzt9q4eu62zr8viTkgd2nH2d5LhEMdnxktpwZQRGVuNkWsqIpkmgoT+4ItPldaw+dGtwQFxCc8aLKYkoLQn9OWmP9RqCHDu3iGO07eJKxKR39FfX7FoFOfLljzJpY7fO/yZR44j2Ko2njGL49HCI6nPKN6Lba7fPszlvxQcPC742rAveQUq/NeLKm7udj6+eytpm0rgh6R2HQcUPWKQS7l6JpK3tWOOLMnQrp0ppeNsLaQfoiiKwrw9LtKfNUw9Oe/fG9+0KJqQSN5c0dDCSGOfk+Uo7cQPc2UCiqVaMtoVM3cKqcz788k9doWIeBU9usoryT7kIbq/w6xknhkUbITgLNyQZZcXYimtKqa8d0xLAOkfEbt/IQlK2PIdUIqj9ZTbt7E9EVRPvmr0hJZcd2jQBexhrji3Umj9bm8OTOZ68pxKlZk6q7X2kMdfVeQrWuB2G76fMe4Aac/VAEhLH9lpnVuBxRnWyexdIEhcckBVt3hTAkmtftMs5DbqDS/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199015)(6916009)(316002)(26005)(4326008)(53546011)(6506007)(54906003)(5660300002)(9686003)(6512007)(7416002)(86362001)(66476007)(8936002)(2906002)(8676002)(41300700001)(66556008)(66946007)(44832011)(83380400001)(6666004)(478600001)(6486002)(38100700002)(186003)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IWJm1kgM0vpH9DA7ts3StuWrIA4sCuRDpOU3T58xSQ6AmXC7Jugg32bJgMd1?=
 =?us-ascii?Q?MvnRpY00Y/dG8iMAQUZImMg/jJZVEcdBvHQSUcmIMBQwzjjp68bUUBlsLGAU?=
 =?us-ascii?Q?EkYRUErmjZI7l5ddFpn93Iwv5km+OZP8oK2tAb8vMOC7C3NSwcqve+GGy2Kz?=
 =?us-ascii?Q?7rNfdmAMdlzrBoiiPkssn+wcIsDKQc7QlysarHZK5kqnHAyc50UtRL7J8Hrb?=
 =?us-ascii?Q?HLo02g7nMv8js2Va4E23RDHcKvxofcd96oDoDUAUCRwd/S6vpP0OG2QWkUon?=
 =?us-ascii?Q?F/UBxEzpPTyekZm4uSzQjM5Dq1dsEfRAYyP/K89M0rt/YXgpXgXysodF4jG7?=
 =?us-ascii?Q?l5AydknNSoYjGyR+YxlgkEVvo3+RFn+il5vTKsrniUIQ1d5oZZker8RDT5Jf?=
 =?us-ascii?Q?sK7iVAiKsSdb/tIVfuQAD2VpCHAbegXsIIFSmuy5y6LpQyeQoMB0Y0Rzt2z4?=
 =?us-ascii?Q?oky2Ahlq1f/fyu/0VF+Egg+M+qdz/vdtq2P6LcD0v0jXJk4T07NXAUPMZDE5?=
 =?us-ascii?Q?MZDG87SgYKgevTy+MSxyhTzyuVO2zF0W1EAZlnI4LgRJ2QIRHNyoFLeon0B5?=
 =?us-ascii?Q?D1/9y0JFbGFcEPwj9sC5XWDcu0DERhL4FE39+xwkJnMYxZQGw0m0diVjAKuF?=
 =?us-ascii?Q?qelkNslI/5B+d1YM079U/1/qEvzJY/MENJ5Ilk1GRMGiWOUGhiwxIGFwDrIf?=
 =?us-ascii?Q?ndC4pthCmYfE5dgXrQl/nmLd3rYvFn52kYik2Umpb7wSp40zVyq9zAFmJrZg?=
 =?us-ascii?Q?YVhsFtNxQ6BwZK7kzONX9Sm5ZrZm4oIHChP5rYQfd3Y3QL1mEOx/PxuIj8T1?=
 =?us-ascii?Q?r7JeF8Cso1d+Gp+9J3THs2H2YLpzav6HBgmupephkeRpOcjW44IaS7OOwHC2?=
 =?us-ascii?Q?JMpYkQrOzP96FBCTt9WfvfvgiLpshodfmZxU5JUNviPIz+BHVJYikVqTwL0J?=
 =?us-ascii?Q?OrQH7x6eF5JbxbU5HmEJvJFWTpA2EHklKp3/mMUy5vUGTpEGOhHZOhBzlYfV?=
 =?us-ascii?Q?3VMRqohAFhft05CqdAqFo9uuHH5i+YRXuSutqTbnpkBNBMxoyCMlkgjUfyVI?=
 =?us-ascii?Q?dxWc47Xh5oCUKZr/i7K+lQrYNpZPdw7V81z/hZsXoI9QXIbqeQXq95ebfFuo?=
 =?us-ascii?Q?GcKR82DVQhp+ldA1AOXUOgznrJlWHjjB+HZ1nQlhXaxDEOBw66494esi3yOC?=
 =?us-ascii?Q?VAzx7zREVa63se1asdWcSHKvOVGxaNnVNzQCmNbuUnJjc6nI2xnP0Bw84IHO?=
 =?us-ascii?Q?cpnVjPfrViKeoJP2UXEmGwpVetG/v0VTRJ+6uEnX1qMezHUQQOEK4FWtGMtN?=
 =?us-ascii?Q?IQ+iGUX3wufNt6LRgkNTu+eKgKNoWpzn+VvV5kyKCfu9nEEQQWRiNn0gwJ+7?=
 =?us-ascii?Q?MSK+xFQajftODOt2kyQwEQCnniCOJEyhrKI+2D+kXXtuFZlJdu6eok0WwVpc?=
 =?us-ascii?Q?L5AbofA3qA0pNKHNKhTO7vSgA6fcyDlYb+k8ogkzjWAG7ayovvAU3+5NiDon?=
 =?us-ascii?Q?mSOP/i38t/Ps26UM5o4kJhjMDiq4c1TV5SycJQGiDQHU4+ORPhOY0hFMorPe?=
 =?us-ascii?Q?XpF8sNQa2jt0HLz5C66lWXiPMBpuGvLBMZxLyC0+v3DUmcG9mnFpGgjnxX6B?=
 =?us-ascii?Q?pg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ae65770-0a78-490b-386a-08dab8edb97a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 14:07:18.9275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zvL3UMzYjaBZswe5GrWlDsQDDizuzyAJppKnms0yRCJsQtbNnqgEi1XT/LSntpuuVfEi2lM3R4kM9qZ3njl1QzP08/4HV3HAEZseYHJgzDA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4221
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=759
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210280088
X-Proofpoint-GUID: brr0eHMmY66ho7Gho_oV3ufpix3-UiQr
X-Proofpoint-ORIG-GUID: brr0eHMmY66ho7Gho_oV3ufpix3-UiQr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 08:50:59PM +0700, Bagas Sanjaya wrote:
> On 10/28/22 20:43, Dan Carpenter wrote:
> >>
> >> Also, s/Kill it/Remove BAYCOM_MAGIC from magic numbers table/ (your
> >> wording is kinda mature).
> >>
> > 
> > The kernel has almost 13 thousand kills...
> > 
> > $ git grep -i kill | wc -l
> > 12975
> > $
> > 
> > It's fine.
> > 
> 
> The word meaning depends on context. In this case, the author means
> removing SOME_MAGIC magic number from the table, one by one until
> the magic number documentation is removed (due to historical cruft).

Kernel devs are naturally blood thirsty people...

$ git log --after=2022-01-01 | grep -w kill | wc -l
207

When people talk about killing stuff they mostly mean deleting code.
Look at this sample of the very first kills from January.  Seven out
of ten times this is what they meant.

$ git log --after=2022-01-01 | grep -w kill | head -n 10
    useless now, kill it.
    net: ipa: kill ipa_table_valid()
    net: ipa: kill two constant symbols
      io_uring: kill hot path fixed file bitmap debug checks
                   newattrs.ia_valid = ATTR_FORCE | kill;
                newattrs.ia_valid = ATTR_FORCE | kill;
                        newattrs.ia_valid = attr_force | kill;
    kill it off before it ends up in a release. It was just part of the
    io_uring: kill hot path fixed file bitmap debug checks
      block: kill deprecated BUG_ON() in the flush handling
$

regards,
dan carpenter
