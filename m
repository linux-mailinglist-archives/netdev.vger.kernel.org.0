Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5320A4A5AE1
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 12:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbiBALIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 06:08:12 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30040 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236791AbiBALIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 06:08:10 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211B6uIB011042;
        Tue, 1 Feb 2022 11:07:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=FWm7jCCkj5tedsD59sZvkPCSPFVuVXwiOyI/EHM3Sbg=;
 b=vzCiGNHPWgau4txfzSfXUFhN2AhGT2HMqx0OP6WZ3huDCopXajSdeyOvCRrLbj0YRLHJ
 fLFCgiPJlD4tcwwvrxMpR75gieo1pNGoATxkQXO4QJFojwsNq4VE87smugoQTWj8onEG
 lJA1UojO71qLBniMcCLwcP95gzd/P0OLuVT8fuseU8k/J7E4uaXJaaXqXBjVzpm9rruV
 +hiBx+8JYuy9zJVsDU8BGw7Diu79qpesocGmpzWTK/TDUWPTjZ2p38qm8oEoFt391t11
 ZLAkUZmG95NWoAXGl/tZM0FqMrSKq8vg5DmH/b/5HqQIVDVybHAI/TzOsd+gdFj1BvOm zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxjattm03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 11:07:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211B7ALW138102;
        Tue, 1 Feb 2022 11:07:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 3dvwd5ynky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 11:07:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nu54e+6Zo9u0NHPlDrF72kziVnY7JoMsmqnGyJCE6FWqPx8JcBuFGvIjkOCZlZAcNaxCgUSY/1juU5VYieMEdxmo9/V4jf+W7kQpi/DMCrUW+GFOdqqgcJJPTb6A9SDd+vnhF42CW1CvyhL4IPlVj/2l0rhCA4/o/1pnRfgbR+wpscFrBJFekkAyGD9E8UaGnIGgF98On0vkAJmfTOJogfhF+i7CER89NIjsySuxe0WBs2tJScetimAOwz3fBLSKPJPO6NT5h8tAgGX+LodhsBNYvQYKFcFYtjPCBcdg+vtNbWl4cVx7/pGc9UgXKxSNmAaHnDB7eDiu9pvPw1CGSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FWm7jCCkj5tedsD59sZvkPCSPFVuVXwiOyI/EHM3Sbg=;
 b=fBBPA/Xy3BhcaeNZDjdb6mY4wXeS3WLXNE2RUt+8RDgWXnWjYH+WEFLZi2qkhGwJ6MV1X7+nYUIFyLsnxI2BKLIweTsNvxB3GiwtXb0fpHmNnKKd/ge8JzlQ/oH89HEOVcS+SfR2omRZds1ZaUJd0V4twq13KW5e27HMAx215INDeOGwd0+26rTdyQJfcZHOLqS7SeMSwpznJamkgKI9xrV4aOsV+cbev2c4XZcbMNA+5Ff3DibSxIhUw59SZE46iRycghwwdOz8BCBMq/6tFmyoIIY3E6doFtfDla3r9ckXrdELNTFwoUkHc/kNBicXOxS8BuIz5EIQk4arFEacVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWm7jCCkj5tedsD59sZvkPCSPFVuVXwiOyI/EHM3Sbg=;
 b=XaeWEz3PHQyauT+uBgE00UYdbrbelmMq0SJLAYPZ0zq4u8RdFoxQTR4Lvx/bk/Pn1mpIg/egFj9yFyy9X2zA4uZPVSVfC7OyoT8X1ks76W8/HsKR5PkoAJ83JNHrjeusl3T81UCmDu1spLYAcXr2TNmBZjCh5SZpXcgXcDskWH4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB3498.namprd10.prod.outlook.com
 (2603:10b6:5:17a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Tue, 1 Feb
 2022 11:07:43 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4930.021; Tue, 1 Feb 2022
 11:07:43 +0000
Date:   Tue, 1 Feb 2022 14:07:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "weiyongjun (A)" <weiyongjun1@huawei.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH net-next] net/fsl: xgmac_mdio: fix return value check in
 xgmac_mdio_probe()
Message-ID: <20220201110711.GR1978@kadam>
References: <20220129012702.3220704-1-weiyongjun1@huawei.com>
 <87czkabjgo.fsf@waldekranz.com>
 <2855194d-9680-c78f-ad87-a2b789cc0363@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2855194d-9680-c78f-ad87-a2b789cc0363@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0041.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::29)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcad589b-8545-4b06-5f7e-08d9e573114f
X-MS-TrafficTypeDiagnostic: DM6PR10MB3498:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3498CEEC56BF6A2CCA94D0C38E269@DM6PR10MB3498.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+wwr1+yyINiBjIlmoNWLzv/1OGeD0g3LupL70SDpYMg9G7pJ7s4lSC3MV7s4YVa+HhOuF3M5beYIy9+KtsSYy/bLJOgRmk7dHGlIyzF0dQ49BWHwLxFLANvt8MC7J/gd+TVAt+5fpQXicB+/IBXvxJbsfy18+7rVjDErbgCMdviB//SVuhPRnC1WHgAx3tkpuW7aTN1wphWiyBe07NoSiJ7kP2wpZq1OcaIHcoYuOerjypIV+2eY6VN6l8pzp80tGhEQquJzJlO264ptUf1s3CEk0yM2THArIyzUe4PSxnZ1YAfhZM34+yeaEPHB4hAPfr080dRuZxlunIT2m5afU/EA5R4wL6n+rRfWaPtDK4HsOfBjmDv1zqD3xKWAdIGXNJmpRDsj3+cEjMK1JWT+p/61h32GSl5p9I2Yhh14D/BoOPUfaaJhvYkaZONd0CUyQU9cRVwOwQO9DPceEm5KHsXqpF7s3cey9o3Y5oDgu1AKjj/lf9hbhx1mbDzd3Qas4M2aqPyg1u6EBhzZVypyk54kHjKNhfBaXnb0Uf0gzFr8prR+E/edpSfYlwYcyETbZFzcdgJk9tphG5agxQZXxTsb00yusJC9KGOBVHBUbWktZkHCQxLQo5CLpK1wbT8Fj/jt56k+thtFgg0yFpC6AMeUgRZXwy7yaMxDeQ5jDz1FpOrmBTpwHt08fylYjYBlos2EjmmeHUpEPIJYyAi1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66946007)(5660300002)(1076003)(33716001)(316002)(66476007)(6916009)(6486002)(54906003)(6512007)(4326008)(8936002)(26005)(508600001)(66556008)(9686003)(6666004)(53546011)(186003)(8676002)(6506007)(86362001)(52116002)(83380400001)(7416002)(44832011)(33656002)(38100700002)(38350700002)(2906002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pe+BHl6/A+CWtrSxbJ3XNCwiTp37xsY6yQyn/nNnnYtGB7l6jPm09zDcK3dU?=
 =?us-ascii?Q?24duf8VOjhmvIF/GiqZzVdzABaCbPYL5WaTrk315douUV0cgzea5BDE4tgE+?=
 =?us-ascii?Q?hcLJrd1EDBxK983Y7MfW/z3bdvLaZ12QQrI5dgG16MQYEK80sjdcfDAkfK4T?=
 =?us-ascii?Q?a+5UBZUDmDGqHKMzovBR+FymqOdgAOVNgB9OivkmTqYdhbV1sH9JPmqygEUL?=
 =?us-ascii?Q?fsoQYLgf6BsW0gI9VBkmHHsLOLFVNXe99ezEpC3E3w8uY3+lfBXLSuX5vs0r?=
 =?us-ascii?Q?qZv4egvmuSZcRMzajP0XBBgIvu0MexFnjz0YwLqqxQfpwDGeSzFpjlXoFQIG?=
 =?us-ascii?Q?O+Um2HVMMnmqtJ/M/Bhp5/gGVGCjfiHCNJ0q97YPtFXUuGeB5v+VdTh8E5QX?=
 =?us-ascii?Q?fy3S3SehcRRiwe2DcFQYics03FqPcZb7fGTU60opbiovAsLI/LRahlCGr3mg?=
 =?us-ascii?Q?Jwpz+OOWeOta1S4LBNWUuL3rbiZ5/gB7gKo57TBsodXPipFdr9NQT6RCyvjJ?=
 =?us-ascii?Q?EAuqr29D0q4jJl4E+6gPYFME+GhJpYj8JVmkma6OAxmJ5yZqnhzQ85gjXZtZ?=
 =?us-ascii?Q?2MP3ivPbS1IKuMkak87t1/vpx02XRZmoFyFO8DcIGOduQ3DHdhMMY3xuxADy?=
 =?us-ascii?Q?4CWebJJkbPiHLXb9+HGdTpcSSgQuBWl4Upp+3FAy6EIUt14hZETthEzu90Io?=
 =?us-ascii?Q?zub3wU7y9DyNikO8c0cXo4jlaioFeAWrb+7xKE8r0JY92GD4Yg3Rci7qhjC+?=
 =?us-ascii?Q?bMf+oluHaTzhQmQUKsUPOrm6OuFmZvskHDNHLB9n17Ev3v0Ucy9Wi+vWt4Fl?=
 =?us-ascii?Q?kiMe8aGuJxP0UGbT98DeUCdXqxzxAIsTM7rkwNDnAQ2Gwhh/Wqxqk2hAdxs7?=
 =?us-ascii?Q?teIGFogEc3yxiqsy3tV4WNqbLEjZ04FdcKTtp4tQVFqEEkILU9hdLrOgHAxt?=
 =?us-ascii?Q?mU4Aug48KpJdA/g/6OYPuWM6hrEoEMOt5v5deUPor95ykk0LUGQ8MzNH7fWu?=
 =?us-ascii?Q?3dAyr/LP8jssJsxVYAvpgYy4gGDMRNVfRajs8WKeSuS8SO9AAePjSzzeLKa9?=
 =?us-ascii?Q?n2ae73LlrrnBAWStUEOLrnNDHROEzYgitLiqEJfXJRKmyUuNWDklR+S/RH/C?=
 =?us-ascii?Q?Dr0oVvUu8NSU/YtnHzEL0XOPlGq5ugqEyfifT/KsW+Rhv/ZSCOjdiopX/GoT?=
 =?us-ascii?Q?Id4Z6TchVQFo2FXqxuKS3qPcvNY4NGOCVPKIF00jat/1YkfRIBfCvi120D/4?=
 =?us-ascii?Q?yIn6r6SQCKWPPYu9XQXzPAMrICbUzv//ZAMzAdL3CAo/hBX0bpxsKhK+Gssx?=
 =?us-ascii?Q?qCQomn8MVpLSlMbPBTsBRMRtFZApcWT8UCJ5J//0g2zyxPebtZ2OVvYgtznU?=
 =?us-ascii?Q?IjVOTjk/H7yFKgVstbCY6Kgit9qCUzwv7W4w7yYSxnd0yOD47+ngI2uLDvtQ?=
 =?us-ascii?Q?dQQD1MQqQPHJ4eQFY79cqL94NlNWzYuWM3drMLi9bASPZd5gScKQQlzsHgGP?=
 =?us-ascii?Q?NPYgMWk77+K/kx85kzBgLpaXHqQcgb1iqDHza2zX67rvSkc0e0paWz67UhpE?=
 =?us-ascii?Q?UKt8j8hWEVF2lU+dw6UydWqWLxTm0fhsSIYhQcVGgd+hiuEyjpJR0kiZ7sr5?=
 =?us-ascii?Q?vK76YtUakXQNrlPVknvkxL98Lcwsb/R1KrXQwhc7N1fWYl06lfApTKa0x3pD?=
 =?us-ascii?Q?AlhDVs9gKnsajUPwqPjGbWbUttk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcad589b-8545-4b06-5f7e-08d9e573114f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 11:07:43.0768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wj5Glilz2DxzMBwD+Fko3OGfJ1bRK5wYIA/fVBo3YflKZ/tF9r9f/1Gq2NB1ccgGMRJQcugAmQfdcGomser5nN57+LZHimpFtGAyiNoqHJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3498
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10244 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=782 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202010062
X-Proofpoint-GUID: jEY6Rt0WRtVzbOWAJpMPqF2J7ym3pa05
X-Proofpoint-ORIG-GUID: jEY6Rt0WRtVzbOWAJpMPqF2J7ym3pa05
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 30, 2022 at 08:58:55AM +0800, weiyongjun (A) wrote:
> 
> > On Sat, Jan 29, 2022 at 01:27, Wei Yongjun <weiyongjun1@huawei.com> wrote:
> > > In case of error, the function devm_ioremap() returns NULL pointer
> > > not ERR_PTR(). The IS_ERR() test in the return value check should
> > > be replaced with NULL test.
> > > 
> > > Fixes: 1d14eb15dc2c ("net/fsl: xgmac_mdio: Use managed device resources")
> > > Reported-by: Hulk Robot <hulkci@huawei.com>
> > > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> > Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
> > 
> > Sorry about that. I started out by using devm_ioremap_resource, which
> > uses the in-band error signaling, and forgot to match the guard when I
> > changed it.
> > 
> > I see that this was reported by your CI, do you mind me asking what it
> > is running in the back-end? At least my version of sparse does not seem
> > to catch this.
> 
> 
> It was reported by coccinelle with follow script:
> 
> 
> @@
> expression ret, E;
> @@
> ret = \(devm_ioport_map\|
> devm_ioremap\|
> devm_ioremap_wc\|
> devm_irq_alloc_generic_chip\|
> devm_kasprintf\|
> devm_kcalloc\|
> devm_kmalloc\|
> devm_kmalloc_array\|
> devm_kmemdup\|
> devm_kstrdup\|
> devm_kzalloc\|
> \)(...);
> ... when != ret = E
> (
> - IS_ERR(ret)
> + !ret
> |
> - !IS_ERR(ret)
> + ret
> |
> - PTR_ERR(ret)
> + -ENOMEM
> )
> 
> 
> 
> It seems smatch also can report this.

Yeah.  I had this patch in my postponed messages but you beat me to
sending it.

The Smatch check for this requires you to have the cross function
database built.  I should update it to remove that requirement for
at least the common functions that you have listed.

regards,
dan carpenter

