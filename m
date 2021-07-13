Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6E53C7132
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 15:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbhGMNbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 09:31:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41082 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236222AbhGMNbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 09:31:24 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DDB8dv019611;
        Tue, 13 Jul 2021 13:28:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=V+hDJC6UxUAt+YkJsBAyrxkG9jbOGSuBdLUKEyOL0ak=;
 b=sT5gCQo7AJ4FLoLc4eOwf3Exszwl8UQaALh86mZcTBgClyIxp5eDBxFZQ/zXyzAOvBb3
 JgduWFBcCXVVnLe3MHKU7Mca6QFyPuxhzMY2kIo7fSTki3fzRcphoxzqG59RIzVcfi9J
 gYDVaXldEwQu5JE7xEQGTH4vVodZgYO3poXHhT6eoPMm9AKMT501CBu2kwFT5rQeVTxr
 fS3z9HjBzSneVxQbyKM5LHxHnYA5EnAANyWRPdICfIWOZoSfs7crRe0m+6EoPW0PoLSX
 tJWunvBxCdTHCczZEtf/dG1ZePCzQqy168sBMHWZd3e3VBJpujPBQtD9N0eC5xfQ+yf8 EA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb2bba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 13:28:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16DDErkh161042;
        Tue, 13 Jul 2021 13:28:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3020.oracle.com with ESMTP id 39qnay2q4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 13:28:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbWen2f8srQmHhZBVi82RG8MIIhJ+5T6NvakCmjBt4KpeYx6i8VhWN/bFYlgPjDlt+eNf5T5Su0o13dTHaJUOprzsFVNXtoFb9QgsCcimNNZFVhbsNScXL8VSY24hxHzGb/DpsNkK2yl2c5PZ87nfsOehDLgmI7RS1SfQQBwMSi8NFWPjkMH3DmLeX5XMxippqUc20y/VhOXLNZa+pDTKXt0HG2NClxJCk0xD/3G6oM8RzO57KfVzN9Lfv5Omhyk/9zxvs266/KO3L3r57w/Bgjv2seZMe23x6tvg3Xyn/4orx2Lp3Jty2dvqFwc6SbMY4JWsD64Yllg6+N2SiHXPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+hDJC6UxUAt+YkJsBAyrxkG9jbOGSuBdLUKEyOL0ak=;
 b=MIgZCIRtCMz9j99EmUdHQZUBglofqkdzGC0Ea0YcU0Joiu0fisXACXNeXdtw7yST8xtkb0bu4WPLmwBDE1e+25XesfEvqWQ6IxlVwT9IV/RmildJtxL1vNsv9i4aCJQlZLZs5FNEaibHsHuAMaxlGHVWomnyHMqmHSGzTM0H6mZvVIiiBmLnCNHGPPxjW6XPqQax7CRiF7Xuh/06lgiUk0L7MXWXXo31tazEXQHo6hjMZLNI4zJTj8Kr4lPRxmtjfgvZSUgHStw+Btl8kEqt7p4ZNs4dzBS2XipJ4UhGPiiKC5pDLQhXGNuayzcb4/k2k1dKeUUVj4RAWgTso9x7GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V+hDJC6UxUAt+YkJsBAyrxkG9jbOGSuBdLUKEyOL0ak=;
 b=Y37RSr/mWqftmJz8VF/TPEq4z8xPBUNtuF48xDxojQTbT5Ky8pOlMyP9UrxJCIwRtRm2bqA4p8L92HuVZo4eVRZTENIqH1fFKLik7vx9wdDOQhqpIarHcDt9gV28y6DErISoLJy3inQouIARfkwmXEqg7lrN4FlLqdyRWpo8VhI=
Authentication-Results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1901.namprd10.prod.outlook.com
 (2603:10b6:300:10c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.25; Tue, 13 Jul
 2021 13:28:11 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 13:28:11 +0000
Date:   Tue, 13 Jul 2021 16:27:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Xie Yongji <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        joro@8bytes.org, gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 16/17] vduse: Introduce VDUSE - vDPA Device in
 Userspace
Message-ID: <20210713132741.GM1954@kadam>
References: <20210713084656.232-1-xieyongji@bytedance.com>
 <20210713084656.232-17-xieyongji@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713084656.232-17-xieyongji@bytedance.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0012.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::24)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JN2P275CA0012.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 13:27:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39d34817-cd70-4ad7-d002-08d946020f4d
X-MS-TrafficTypeDiagnostic: MWHPR10MB1901:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1901328D0029E96E2F0DEC728E149@MWHPR10MB1901.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+WOVpxeyXyimvYbAiNOLqMOIQ7m0KAQt69pX3YGrkkmDxF7qtocQ74gMBLBlZS7+/N9LTqPTe8CjZV5cPxVd/uvpESt9F0XZTJHJN6hFLRQAO6CkxuYCZFsfEZSioQKcSJzt0Iet2RlzAMoqh0a2QwqTZCuunb+h4aDrsVPyHZ9dQYZC/vfvlF7J3HZUap7u60cVyvVnvL/Am9OfBGQcMqv+Tw4fhQD7hvhAl9yhgwd2Kyuz6vyEjCmbNoPUHw7j0M+S0aThTqv/fan0WO41yBUHjWOOKHPIIfS+ow2Nycv/tTcrbuTGLo0o5s3gc/2o/b5nWwoNpMROaWpmD0OQ8dohla/KkbGkliI+0TLh9lTKycrNvC3CwCO4yAhmEWvgQWoi0vplA7Ui96XiBlb3X6+igkxynsLAUjDvCEodxLXkTFsL83Qdd4RHLBsKYW4o1/nONoiIXQE96frPoPQa2n3T0PZPciIQlaBvQq8zRBeJ2m5rHyQalG/hlf9k0P9Z2uDw4T2ACf1YFVerYHSav151VZ2lz0kqfT2GQF0GJo3RJ9kfsTKO0CeOU37WkpX8mvAWvSPttLpFdvWmZKpx/rm2fu9GEk6XAQeRWLio7RUP+b+CpoxQkZQVNsn37Fz0VxuKlxWZNKZdhERp4CjQ6rp7XstWEXB3+kTuGBGbbTA0qeskmvGBzGIZGdx2cnqGAFr7fktvxomtwiGlAnMzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(376002)(346002)(366004)(6496006)(9576002)(44832011)(66556008)(186003)(4326008)(86362001)(38350700002)(38100700002)(6666004)(8676002)(66946007)(55016002)(9686003)(7416002)(52116002)(2906002)(33656002)(478600001)(66476007)(5660300002)(316002)(1076003)(26005)(33716001)(8936002)(956004)(110136005)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?13IvTBxQRxr1x3jfi4NxJ5/IliQ8/P1nu8StGLtDevpF74LbG0oH3IDsbZdN?=
 =?us-ascii?Q?7sr15jS+XEenR1PY8zrnWVuWnnPPFeTjRk6j1/uAlEmFZ7JYv18jM5fGJOkV?=
 =?us-ascii?Q?WHOU6Z1jM+UyUyq0f2rWoOtLZFUByqYPwTUyPHSZ0ihcAwDIeB2UhMtd83Db?=
 =?us-ascii?Q?sz4NQrjDa7PftXQMPk2+M+M0lBi2SGR0r2INfIf5POcLa48ssgesO9x8jmXC?=
 =?us-ascii?Q?NJ6H5fNvidMZbskb/CCYud58tLyBtQC3uYVFBf0uP0jiFiG8Os54jUH/7pz9?=
 =?us-ascii?Q?ummH/wGaai9PbE4YGYj1d6+Kg5o5PKgEW8kLkcPRXiwv/CbtWyof6VXVNKYR?=
 =?us-ascii?Q?GaeAPKdwQ+AAt1FsAz1s3hJu3uP8J7NGsCptpk+oy9RFzH1pAvQbKygQPwJ3?=
 =?us-ascii?Q?c+1OXq5+smh+Hg+0NU2X7DirOYxzxzzII2S6oZpFhe+cTWd5V/Rl8Yl+Co6u?=
 =?us-ascii?Q?m47/TxZZcvknzXtk/g5kIMEHirKHG7i9toGopNdAYkANvqvn8ucPCmCZCDzS?=
 =?us-ascii?Q?Vi6p1w0eto/zxpELgYWdEvOVN/S+hi6MVa+T+l8eKK0qb73ACc1WYGNW6veT?=
 =?us-ascii?Q?If4GtqFI3xP0JsFGMk4T62WoXd1IMyc43s4KTtq+37Tr84g1YixquZ+wJDO9?=
 =?us-ascii?Q?T30MS2SVl4+DBRMugCDJY9QAOdUtTe8Fge0JhQFjEDmnfqqeQKE9x21ug6uh?=
 =?us-ascii?Q?OChDWFbChgQn7hc5Z+f5IzRXQFdWxBrlS3nOAcMRBt12/3BiowG8igCLnVi9?=
 =?us-ascii?Q?ReDryry2u/kh/WxK6/OagSitp74SVs88+E8VtRvKVOUzon+NYMNuFigcMtGP?=
 =?us-ascii?Q?LHj18Hff0GwKVodMqYQszquOK715HklCobO8zPm/+Nm3rOcyMBZ7/I9MnJ56?=
 =?us-ascii?Q?Gs5jaM8fSAP57Xlhgzo8XVD7KwB8+cUx1qQUqDquK+Db9SiFvPP7KuZW/qp/?=
 =?us-ascii?Q?vyv+KMpjlYh0SCX4qqeI/BgLtBP7Zh9xBJObMkMp3YR73Hor5ebsQ9idFfmk?=
 =?us-ascii?Q?8Bq7Z8PXqDo10/XyPjhCHVlRHapCqqgCh2MYXY4+Lr+MQo97Xa5uWMonip6m?=
 =?us-ascii?Q?+esCcG/ukfljxHFD9CAuzNp/zOwonfuCqaVhVpNL2Br/3BSHR1yA9hEwNCRE?=
 =?us-ascii?Q?K9l3UXanPOyCxSZ83MV212NAkLO0y9G5F9colza4zbGPBh8NwotoydCTMUgy?=
 =?us-ascii?Q?R+NQ9NYexs6i9p666p0mTp8rR/AD2YDvTa74lZAeJCCXq47zWuqoz9a+g4S6?=
 =?us-ascii?Q?bdhcI5iHHrv/Lm8fRqDjD4uvTdNqeQB+ipJO9HdY8KBYbRMv5Fu2kvS5PGnq?=
 =?us-ascii?Q?rN9W3BhI8f8t67CC1azGGru/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d34817-cd70-4ad7-d002-08d946020f4d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 13:28:11.5759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KtkM+il6WtfJ37qcx6WeGehJ/mwH1slH06A6KpAtpBYZSG4/J0j6VanZGYMyXz9dcYlPoZz+8VWEcVpQzr0/EWCZrgTqOOVYX3diJBWFDfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1901
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107130085
X-Proofpoint-ORIG-GUID: Kx9Ew6RYM8JlMa0Ovg818wQXNVEPcP8n
X-Proofpoint-GUID: Kx9Ew6RYM8JlMa0Ovg818wQXNVEPcP8n
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 04:46:55PM +0800, Xie Yongji wrote:
> +static int vduse_dev_init_vdpa(struct vduse_dev *dev, const char *name)
> +{
> +	struct vduse_vdpa *vdev;
> +	int ret;
> +
> +	if (dev->vdev)
> +		return -EEXIST;
> +
> +	vdev = vdpa_alloc_device(struct vduse_vdpa, vdpa, dev->dev,
> +				 &vduse_vdpa_config_ops, name, true);
> +	if (!vdev)
> +		return -ENOMEM;

This should be an IS_ERR() check instead of a NULL check.

The vdpa_alloc_device() macro is doing something very complicated but
I'm not sure what.  It calls container_of() and that looks buggy until
you spot the BUILD_BUG_ON_ZERO() compile time assert which ensures that
the container_of() is a no-op.

Only one of the callers checks for error pointers correctly so maybe
it's too complicated or maybe there should be better documentation.

regards,
dan carpenter
