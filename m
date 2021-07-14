Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4533C8238
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239004AbhGNKBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 06:01:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39872 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238923AbhGNKBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 06:01:16 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E9vJVW000307;
        Wed, 14 Jul 2021 09:57:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2020-01-29;
 bh=ySNrfuSY91tFx0j4QsaYgb5F0zahgoMS92DsTPCExWA=;
 b=y9+nHHjBLElIxGqAz11Zh30Zsk0lj+T1SKWorfZ2bT+E+fx2MDpD309U10Sv+zH6K99s
 oc9qU58oTl5te1QiDPvnCTWfBrKEK7lgAmrs3okOW4quvqm/pFCy0eEOy7Qf4pbZeoj/
 hDXJS6DQVe7zzWWvPhFAzR+cxBrECjLTchTRANqkRfu6W0qm7kJi2gY9xXrOuNTIFgQO
 EYEvM6coogOXu+z/uUUZwjuzWkt4AvUgNO3Mv26dk6FJ2xd53REGCicGQN4vangnv9Q8
 7wGm88f+2+gBWzTzG876BseK/G2qmxfe/BjeZjE6C4j8ryLlCrDpmYsiYRe4d5pKkl/h jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb4d8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 09:57:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E9uXGL195965;
        Wed, 14 Jul 2021 09:57:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by userp3030.oracle.com with ESMTP id 39q0p82suu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 09:57:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLowqVdiwFSEwX9u5kQ6+lqKJl8h2ByYfR5ZFkdoAT8AkPvnRAGUsEsycWZUmvMUoeoM2zvqKDhGGLRf83H98avaCQGwMC7eFDOUdwQA1DWqKUGYg6MfLoCKQTaMn+G9phuheipNJ9H2GUDzmcqkRQRXZNEejhi1fQQI82Tgms8tbuau+3Acu6iC12h9PytzRUU5nO1bTqIQqsBJqXLRcCSZ5xyUqkykXB6Ev3qMySwmdXDUAYQVOlIvzPZn/Dmui+kxeMgLuKhxdQoLI+tUj2a9xIdHKIcpvcEmhQhBbztgKazbj4Kv9EQOF/KPy5neBXVKJ7/nqvCpcODZG3005Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySNrfuSY91tFx0j4QsaYgb5F0zahgoMS92DsTPCExWA=;
 b=HEfEpvb0KiMnV5P7hwJUWzOtWyQ7MEb7A/uKJc043EIFFVqpDd/kKH1nw1SWPpeqrVUoAnhV3aG0Ch6L6EDpG3wpe41RUXmQ6vvvGptj9y4c7sbHByAuo8pRrcGFmXDTemWuh6SHGiQms8T99X6glw64aEXbMoFMgjYHvLdAAbdT0z2XU/KFo/zHsi58TQ7fqWQ57FjUGBjzaaT9Xx5hH7wZl2hIt+G2YAfzla4+HrHplRHpf6+MV/HpCSHt2QWyvg2qY+anT2hc0oRxUZHKUgIRiFHtTdHrFQUEVciFYO38b6zIeMfSDMFceY8pZ0YFC7T/o3ymid1huUYlw80ZKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySNrfuSY91tFx0j4QsaYgb5F0zahgoMS92DsTPCExWA=;
 b=xSsO7jPyYy6XmEeBPu6qXTvrjUe/6E9S9YfsuIRaVeQCZz4CoBr+2u3LxDFoVyvAR8WflAllyhyQe8770NrRnjNBecghzuAphijTuSqd03tGOQy5oWeOK8r0gBhph0GYFFhX5jwUQBU5PV791pGuPoERdjUOyQn0gWIX3+Vv2dA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1359.namprd10.prod.outlook.com
 (2603:10b6:300:1f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Wed, 14 Jul
 2021 09:57:52 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 09:57:52 +0000
Date:   Wed, 14 Jul 2021 12:57:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        hch@infradead.org, christian.brauner@canonical.com,
        rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 13/17] vdpa: factor out vhost_vdpa_pa_map() and
 vhost_vdpa_pa_unmap()
Message-ID: <20210714095722.GC25548@kadam>
References: <20210713084656.232-1-xieyongji@bytedance.com>
 <20210713084656.232-14-xieyongji@bytedance.com>
 <20210713113114.GL1954@kadam>
 <20e75b53-0dce-2f2d-b717-f78553bddcd8@redhat.com>
 <20210714080512.GW1954@kadam>
 <db02315d-0ffe-f4a2-da67-5a014060fa4a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db02315d-0ffe-f4a2-da67-5a014060fa4a@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0022.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::8)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0022.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 09:57:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a437edd-4bd6-410e-d4eb-08d946add800
X-MS-TrafficTypeDiagnostic: MWHPR10MB1359:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1359BE47C729E943858EB9368E139@MWHPR10MB1359.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IH+SB1WMCzv3wS2junlOy+9m+l2X7s1XJ0MzcI1/5Z74c3lahO8rc6uXNrZeoeQ8MdK/YQkNinxHzXB5roZ9pyVC6CfiohzHGHvh0FSzK8Kf7UP4rq5GDvyA/RtbVqXo7iu3PNnCOaqFFRSDJrE44ChR0DAebXfckM1+gJ2xPErdFmgrR50j6fB/UhYlBYFdovu0TzSuql3AEz8w9LIJq1eJfpVhwDjYBhj++jhV4mx/z214xrnuqpx7Xi6N9dwmZpN6EjkE9XuMS4OtI1uQ+SyyBbuwObVC+hm2W6BPjg5kmnZ6Dr3dko+I8uY6adZHJkRA7XOPePL1A1N9kc03JS+l+CRVEQWwnpF8xBMUgfOcFf5V79mvoGrlVkm20tee6FgqmKbWtUvWTc8xgNaIzF8RmooQlzXu6LnB/MwqTx9lZWqAYNS3ohys/dm0bwIZ7+4HcUUsk4cIV1lGPzAv3SZ/Mo902U+oePasb/qZjs3fEPZpTneM9lqNUlUyfwu4Em7m9TwNMGnpe76HU0BoMIpWWo4mQCQ14eolVxT8cnCskJV8Hwi8dsdGCJXDSq66RVHQReAdaoLHufXwSwG36exEHmTHz6Eag0RltqCdCizbmNyO+sbT4L920QDKANTv/q9JVqcwhL/llcdweM7YcxogIbUA4tiYR1SR6UPFT6Yx7wTqUrmeUa+gr+lZGsY1mKEguAX76DShdnaOy4YZNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(136003)(396003)(376002)(26005)(6666004)(55016002)(33716001)(2906002)(186003)(38350700002)(478600001)(7416002)(52116002)(4326008)(6916009)(1076003)(9686003)(8676002)(66946007)(66476007)(86362001)(956004)(66556008)(8936002)(5660300002)(33656002)(316002)(44832011)(6496006)(83380400001)(9576002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dE8rajllYzJEb1dGbVBBRlFCM1laVkYyK3U2ZjVwUFV0SGpRV0RTaWN0bTNW?=
 =?utf-8?B?QU8wc2lkc2l1d0NrTFRVOExFdDkxSTFZVUpOTFR5aTJIRHVkL3FsZGNNK3dz?=
 =?utf-8?B?dlAreHl2ZlNoZkpTNm1WenZEVy83WWdHUmJOWXVIUStaemdDL0pPL21mYkEv?=
 =?utf-8?B?ZVUvVEVVZm5sZkhkZ2lIS2hydGZMWkZxYWtCWktxSFJadU9NUmI2RU5SaXg5?=
 =?utf-8?B?U3pzQkwrUStmTVduR1hVMVJ0bVlzbS94RW1LK2hpMDM1N2ZVdlNyYXV4NTlq?=
 =?utf-8?B?VmdxbXNoWVE2Q2ZoQnVubmkrOEkxb0tGYnhvTEhMb0cvTkwxeXU1S1ZwZys5?=
 =?utf-8?B?bDF4YUlDeG9neGh1UEFFYUUzMEx6Wm16MDFXcE83NXR5b25vR3pjSW9uZ0RM?=
 =?utf-8?B?ZWdKaXkzMkJwUjRlRzBZQW9hU2pQR3Q0R3dYQno0Y0NJQ3pseFFJTDRFYXdU?=
 =?utf-8?B?U3VvNWNlTUxIVWxNUjh3OGlzdVJhNlV1K1NmY24ydWtzS01NWmJnY2dpVldi?=
 =?utf-8?B?SFpYekdjVkozM3NSWG4rdzJCVHZnRVVPRVlhRFQwa08wSkFpNG1LbjR3Q0xR?=
 =?utf-8?B?YncwVlRlQkI1cGg5ZTBBR0VTR1QranBRd0E3VjMrUmxRd0x5UUsyRUJkTEJB?=
 =?utf-8?B?dkduWS9hSnhsRWQ2MllmcmlNSERzcFVBK3h4N0JwT1I1LzJzTW4zZWluM1JP?=
 =?utf-8?B?YldRU1oxYWZBaVFFTDFEOXVESVNtNXRWcHdwU09VTzRUdkZOdHBjVlp0TUp5?=
 =?utf-8?B?N01ZRFJOTm1xMTcxSy80dXowVjJaOExIZFVSVGRWbjRhOHZwc29UaFgvTVRn?=
 =?utf-8?B?ekZzWXpaa09HSE9VZGFiTHAySXI5UVRVVEVmc1pIRDhYQ2RmR2RESkJyL0tw?=
 =?utf-8?B?bTNvUFJFMllWRy9BL3I2QmtoN2NVLzVnS2xTUGVRT09VdjlmL3h0NXl5VEdP?=
 =?utf-8?B?Z0FFWXZ0SnRXZ2xlUy9MWDVjbk9RS1ZaWkZXSlV6MWlHbk41cFF1RnRpdVFI?=
 =?utf-8?B?OGpidzAxbSt0eitCUGZEMjc5b2M0OHVMUU95Z2p1aFVmSWpsckZXRXVKekxr?=
 =?utf-8?B?a2pxSjI0V3ZqTEdUcW9vSnB2aDhUeC9xUVNSenpNRGRBalF2U2tlb2lURXdL?=
 =?utf-8?B?dE9MQmorN3E3cWFnSWVUWGI1WTFYdGd4VWUvTFRSN3hHYU93d01sdEEzRDBz?=
 =?utf-8?B?VEZwSFF3UjJDRDJadFNXZzRLMFVFNllWL2FZK3E2ZzUxblZPdXJjUHh6TEdK?=
 =?utf-8?B?VGJMMmlsZStOVFBydnNXYkxFbGJIVWhIS0ovYUh6SFo4VkJwclJDVldxcmJt?=
 =?utf-8?B?Z1FEL1NkNFFRV0pWL1dLUGg0Q2FSeElnMlVPdFNXVFhUeXhCTzJjck0vRFUx?=
 =?utf-8?B?RWFoVis4cjQzQnEzMWlzWEJQd1RqRGd1Q0lkcDRjUXhuODZwc0RJa1FNV1Ro?=
 =?utf-8?B?S01TSGlUTm9QYjRoS2ljRFArY05JRVJJWElCRG4yRkRGYk9iaVhpSlNQVVZh?=
 =?utf-8?B?ejBSNmJHWWlVdXFlUTM3WlB5Umd6My9jditXTjdzcXdwRERzTktxd3JhSTYw?=
 =?utf-8?B?d2JqajhRMXp0NkswLzRtMEJkdkZKQWpJNW05NGxadmtNWmYwRUZLMm9ub2p5?=
 =?utf-8?B?em5rdThFb3Q4OFlSVThQTjB3Rndqd09EL1Myb1oyYVNJY2NKS1lYZVdQcUt3?=
 =?utf-8?B?cSthV1dkeGVYODNldDlucXBZYUhXMVlTRWxrZGIzSjBBeGFoejh3MWRhOFFN?=
 =?utf-8?Q?ulGB0DroMR0nHsjc4TPp7Hj3TPYT9kR0H1uaTiH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a437edd-4bd6-410e-d4eb-08d946add800
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 09:57:52.2392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: So+Yubu+n1JsCLF1nKs1Um64geOaxRSaPFNRJ5TbPh2KaHC73D7I+NSyj1Uo6Ao+PBZGzTLFd2P+4iWqKwBR6OwDCsiCydOtDMJQnjdZdpU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1359
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=844 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140065
X-Proofpoint-ORIG-GUID: PhHiYWmApShfgBOj5Zgb6NL3N1Tg7NRL
X-Proofpoint-GUID: PhHiYWmApShfgBOj5Zgb6NL3N1Tg7NRL
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 05:41:54PM +0800, Jason Wang wrote:
> 
> 在 2021/7/14 下午4:05, Dan Carpenter 写道:
> > On Wed, Jul 14, 2021 at 10:14:32AM +0800, Jason Wang wrote:
> > > 在 2021/7/13 下午7:31, Dan Carpenter 写道:
> > > > On Tue, Jul 13, 2021 at 04:46:52PM +0800, Xie Yongji wrote:
> > > > > @@ -613,37 +618,28 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
> > > > >    	}
> > > > >    }
> > > > > -static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
> > > > > -					   struct vhost_iotlb_msg *msg)
> > > > > +static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
> > > > > +			     u64 iova, u64 size, u64 uaddr, u32 perm)
> > > > >    {
> > > > >    	struct vhost_dev *dev = &v->vdev;
> > > > > -	struct vhost_iotlb *iotlb = dev->iotlb;
> > > > >    	struct page **page_list;
> > > > >    	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
> > > > >    	unsigned int gup_flags = FOLL_LONGTERM;
> > > > >    	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
> > > > >    	unsigned long lock_limit, sz2pin, nchunks, i;
> > > > > -	u64 iova = msg->iova;
> > > > > +	u64 start = iova;
> > > > >    	long pinned;
> > > > >    	int ret = 0;
> > > > > -	if (msg->iova < v->range.first ||
> > > > > -	    msg->iova + msg->size - 1 > v->range.last)
> > > > > -		return -EINVAL;
> > > > This is not related to your patch, but can the "msg->iova + msg->size"
> > > > addition can have an integer overflow.  From looking at the callers it
> > > > seems like it can.  msg comes from:
> > > >     vhost_chr_write_iter()
> > > >     --> dev->msg_handler(dev, &msg);
> > > >         --> vhost_vdpa_process_iotlb_msg()
> > > >            --> vhost_vdpa_process_iotlb_update()
> > > 
> > > Yes.
> > > 
> > > 
> > > > If I'm thinking of the right thing then these are allowed to overflow to
> > > > 0 because of the " - 1" but not further than that.  I believe the check
> > > > needs to be something like:
> > > > 
> > > > 	if (msg->iova < v->range.first ||
> > > > 	    msg->iova - 1 > U64_MAX - msg->size ||
> > > 
> > > I guess we don't need - 1 here?
> > The - 1 is important.  The highest address is 0xffffffff.  So it goes
> > start + size = 0 and then start + size - 1 == 0xffffffff.
> 
> 
> Right, so actually
> 
> msg->iova = 0xfffffffe, msg->size=2 is valid.

I believe so, yes.  It's inclusive of 0xfffffffe and 0xffffffff.
(Not an expert).

regards,
dan carpenter

