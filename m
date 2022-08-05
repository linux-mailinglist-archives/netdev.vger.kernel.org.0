Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F194758A5DD
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 08:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbiHEG0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 02:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiHEG0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 02:26:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8770A606A2;
        Thu,  4 Aug 2022 23:26:38 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2752hs3c027430;
        Fri, 5 Aug 2022 06:26:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=TWjbBBLKLmKlRrwrcJ3ZKLW9UApgGKzwgUoH/Fz/HIU=;
 b=F91Q1/91laKYuWoeea6UUT50uspdxlTuaCybaC1QgSQju3a5ZxKqscR+n8XCENwbthn9
 wCdJSHzYmcOBIkTWlv1r5LWd5QcQE9nk/9m0+MS/NvKObv92vSXgKJOl2FaAIDUENZUq
 GUWrFf7GIOcEQo7+MI8tnXHlpGmBK6brhSo60RNs++0cTct+YY8fMF6FP7lCDSiOYeLo
 qTLVtqkXhnd/v6mjBHMasrI85CODFo3+rM6m9vyL0Eg7g87OqSXOpIDAOHM3F3b1VhC9
 MF7EVOlVYit+CcGL8TruF5t9Q3pjQvVAiOfe6zXzj7dXHUOAGBDu3LkuAeQIO0I8xRm/ AA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmvh9xj1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 06:26:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2751d6Zu001200;
        Fri, 5 Aug 2022 06:26:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hp57tws0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Aug 2022 06:26:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j0NOqyL4K3XwW+W71WPWKqufqVC1Wux728i6RPT1iz7MTPxZyUZmCIcf6YGjh8AYVfRX99AVOm6rkdsYn4b1ij+m4FCrIEB9LS+3ouKoWNQHDanHRI/ftP1zcyOe1O0fjMffJiT7Au5JaZngqqyT3M31SMjkWbOYkWjUHORc1ESnzZn0hDuWyk4DWNWrK6uUjpNpavZK/pnKwuO2kl9yMYkbJFfIbgEosyqPReZ4sV5vIuHNUq3o5fg4jC4+DCIqtxB7RwSxxX8gcMsAplCvUGjMzjun5KwPrPx+mDu3O2AdT+40+zQ+LHD6dt132p/qv1FwHf98scNvr/RRHZVQjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWjbBBLKLmKlRrwrcJ3ZKLW9UApgGKzwgUoH/Fz/HIU=;
 b=UNgKtqay81Y0/VmaSH/llzaRMwRxh2/wli8cJS9bLIJJJtr5yeTfWbvyhWnbbQ9lbZeQuwxpN3vhkM/nPZkIXDkhIeh40860UaWqLUn5JYJ+j/kwPtNB1G2QtG/x1Ev7L9hr3PmspScHkxgQDCwuHtG4RjFGpuM+INpZKnmLitUnh24eSmB5psEkbowIj13T8c7R3GjiKuFbajKg0b2kBD12XPfsdhq3suupJfdiO7rDyPmeP2jn3SUUPWk3KFylKs4kq8g7ODiTjq2lS8Dci5wZZjcJ/upvQCFwn6ft3CP7+C/BOZ6QbM7VYL5ZNMEsCeJ2K4hJRGb8qcMxO8fG3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWjbBBLKLmKlRrwrcJ3ZKLW9UApgGKzwgUoH/Fz/HIU=;
 b=VoV/FYILxF7dwK0WojMU4Iq616IMXg2Eq3htdP1m72bAOMVz6a49aU2a44O4TIc7oT/x6uE7x4a3ixGhDfLcQQ7byIn9G2N0GI/lx2CyBsKU71zGNMT/sH7pgoM8V0oRYDr32Y6ag7Xu4aLZHlBcY12G9s88o4uAXV6AhjOtePQ=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BLAPR10MB4930.namprd10.prod.outlook.com
 (2603:10b6:208:323::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 06:26:27 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 06:26:27 +0000
Date:   Fri, 5 Aug 2022 09:26:06 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Lama Kayal <lkayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: Fix use after free in mlx5e_fs_init()
Message-ID: <20220805062606.GL3460@kadam>
References: <YuvbCRstoxopHi4n@kili>
 <2e33b89a-5387-e68c-a0fb-dec2c54f87e2@gmail.com>
 <20220805062141.GG3438@kadam>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805062141.GG3438@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0024.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::36)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad65ef1c-7b9b-4be0-49ce-08da76ab6d77
X-MS-TrafficTypeDiagnostic: BLAPR10MB4930:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wZlWySHzpOont1qMxoFqJE3xgwKWDEfn80HavicbF/zBcEFOTV+rzSmBzUKHRqkdTpsWNatBF+LStuc6OYHtrULFsNxeuMnH9EFIZV6O44YalN9wB1bu2K59rH00BYC1kEyOJlkX8r9E8p0W5BsiX2gXaA7RFoh+YlraYvMaRlogVX6aMl40QDyan3TEoG8HHkWtRDmrXwx2DBVn8SI8UQ+0YkUf75hrpFDBgcemM2M/rmbI7CwAU+HnuivrYDNmOfN/Lo2tONX7Xz41dB7RGcpzmAOcS/mJzcTXHPMEjZI6LHStPzT/ih4bYo4bAk01Ch+vMFYxKrQBB7o2FfMVPUm2ZapKID84TQgQexr/7k7pC48/i5cWDOJHn71W5qGprDgOq8Q/z6gm+MuY4YW+wjYZCLkf1T2rZjmTym95rTxaDEUPpxw6BrCQUKLhuKolro5lnAdTv/kh/i4XxSZBZXdF4aZLkoS1sD7RfLJW8ManTxmHsacfQotMZ/iU9mPMzwGinfmKoc3gBBmlorOsRqJTsNzWSTx6Rd9ZUDacHtUjl8COrt4zlZgqUxl8u//w028JvVDT+RRefYijXM/9ZBJMBOr/KaeGKK/M1p3TtKhKoJpBHE7nuxNt5Jdoperr3gI/jzqUVIodGy2N130Emxv+fvTXHbW9VzuBe4ynnObGsWhCJ5Ujv8liTHjlnKAHkE8AxcXODynYfLqW5WOAD5KDGhC0l7f9OYrgFhxbcpMi/6G6akPDvTdaZ28f+Q1TM8k2ZC4WXZU5XbSBs2d1Nl039yDO47kTESOggwwa8UQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(396003)(366004)(136003)(376002)(39860400002)(346002)(66476007)(38350700002)(44832011)(66556008)(38100700002)(7416002)(1076003)(66946007)(4326008)(316002)(6666004)(8676002)(33656002)(41300700001)(4744005)(2906002)(8936002)(6486002)(86362001)(186003)(478600001)(6512007)(5660300002)(9686003)(26005)(6916009)(33716001)(6506007)(52116002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VFI/gdiFVu5o6eqBs4Y50Ln7Cnw0RAm9sapb7jSgB0Py+xDr66ulQSveW1vp?=
 =?us-ascii?Q?kTXlqjMFR1Hdmnzbc6UTfArcPh6UgzI4sfuQY7oSWPwuBWaha0otrzNcMe52?=
 =?us-ascii?Q?Ny1QLl8kLvW6wznFkXmuwE5eDs6q/j2OO1VcC+l0Rqi+FaNn27Oow8Jr15yL?=
 =?us-ascii?Q?CMU2y+FchHGiHN7FCEewAXlnzdGiW+bx4uWfsUv/5qstPdtkwL8ImfNlXZ8g?=
 =?us-ascii?Q?Q98mFByOy6kspEr9TvOR/Or+qogCqBhe/4PiiPgiH+jm8UZyNEFptW+hCyXq?=
 =?us-ascii?Q?wRuICL5FeTUBLoPd5V+bsEl/0W9UK2bjXVOh47EIqv0I3tzXBBhHkHKea0SH?=
 =?us-ascii?Q?EBXkZqhnoN2cU3FRis98VpH4WOgHv+uJ2VSbi0puLEH5vGPdZd0kCck6e8qd?=
 =?us-ascii?Q?ZWB8euLO6Y7EoqrJ5oi9HQNiTPzQjlwo0CdQ1wNSFrRj1du44J3ETSiGG7JA?=
 =?us-ascii?Q?LrYfEP+dudrxogBYgS5xTLN4CGCcI0v+zR63DWiPLFTLYebbqUu+5CUwKaJC?=
 =?us-ascii?Q?qFtN2KiY2ZXjvMFeH1WYIAaFs2Nha2EhoMMUK8fBvzAwlZAN12jbjVAlQx2y?=
 =?us-ascii?Q?YLHvwIpQkCeTxeV6njuBZB8ShgfyIlqSs9Y0SpA9VqXJ+1TT8YE2FMdfIHQy?=
 =?us-ascii?Q?X+6GJ6+/rzMglu9ZMAsewFzT/J1xM8LNHaXhgQLDQLwfOX9wXFeyJtlOYZQE?=
 =?us-ascii?Q?DYMpvlHoLH1GgOrO8Ww1f/P0n2XhoNTvky31MuM7DgaKMDQ9IRDXhcaMED8Y?=
 =?us-ascii?Q?W6zcmwc5yvcee/8ah7VrWSPmNFtPJ+0eDAk6u4vwRHDx63z9xmvjU2pBLo6t?=
 =?us-ascii?Q?+WPUzNlyqUTre/daeU1Qi3LP1BPzv23Vh7BnTnV+ROIlRxioxmc17nEuQWHj?=
 =?us-ascii?Q?da4nBNwHrUI/q9QOXcpVhUAzIPrUsmRXZcvf+Z+6E8F/yfQVlg9oLjge6ARx?=
 =?us-ascii?Q?tFmiVVOcjDrEcJ7vFIvCoXOIsi36wy6Q3f1edWiULVMwaGYJit6hXUkZ6dLa?=
 =?us-ascii?Q?rFbgj7luaNk2ghhypp+VE8SE1vIdHpQc2XLu6vQD2VMy0+rzfNKJjspItOrM?=
 =?us-ascii?Q?7wX/6yIPcskCIF2y58vg263L3hWFtySfvkceX0SdZEMAlCPQGnXtH+WexUBM?=
 =?us-ascii?Q?VUS7QNqZe7cx7Vm5MrSyYpIe+pkwtqR9IzYRnOSVkwedvc6p+WwppwMJyqPh?=
 =?us-ascii?Q?S+3kocAdHX0H0FANfrHGmJOpL98Gr/MZR90KJA/PATSa82WsK/J3hqDzkDw5?=
 =?us-ascii?Q?W+jUZC5ZEz9wCfV7eHCAviF/VkhCpthzhiksvMtA/s/kacLnU75ksxMbPxbm?=
 =?us-ascii?Q?izCuyaMmtZYD+1HexNeAtU3dpgPlv/ubuRjGGG00iK+5olatx/JcoWDdu3i+?=
 =?us-ascii?Q?WRkzNdLuHp/WMAcIqxSWHHHTEU/u9JR6EP8PzvJlDA8o321AdmbPrUjKG6p7?=
 =?us-ascii?Q?Q6Eq0T0aWmdeR+h3MQxw8JmjDldrOVjE9mnqBHonPy9mzeRpXqSk8M1KYQD+?=
 =?us-ascii?Q?CqzgGs1m0y98llGcKlq4yKm5D6WBsaSJ3dVmB4VDl7k7/RrYjjwo4/dbNHqk?=
 =?us-ascii?Q?emWgYBQrHmnuPU0H/J6D1PSBwGewhDD9kGaUExE+Dbc2g8wxchI8I8nhLN2O?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad65ef1c-7b9b-4be0-49ce-08da76ab6d77
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 06:26:27.5772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vF9+WZs7hnU/QC7arWS5pKG3Cs8ZRWV9XjfIRVjK3lm3iurlFd9IIdH6H3Frh5L7ileLgxd69/2v58x2i2N3VLcok/fz8KNM6dsjwgjnpEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4930
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_01,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208050031
X-Proofpoint-ORIG-GUID: 8a7KLcHJ9c5yJAplFg8-okjSPO0So-Ps
X-Proofpoint-GUID: 8a7KLcHJ9c5yJAplFg8-okjSPO0So-Ps
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 05, 2022 at 09:21:41AM +0300, Dan Carpenter wrote:
> I can't remember how it works, but it's somehow my job to remember this
> stuff for 200+ *hundred* different friggin git trees and put the tree
> name in the subject.  :P  (small rant).
> 

Huh.  It's actuall 360 trees now.  Wow.

Anyway, it needs to go into net and not net-next.  I've told everyone
else besides networking who asks for something like that in the subject
that they can pound dirt.

regards,
dan carpenter

