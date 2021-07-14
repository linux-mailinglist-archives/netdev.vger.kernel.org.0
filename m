Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947DB3C7FBF
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 10:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238403AbhGNIJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 04:09:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52434 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238287AbhGNIJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 04:09:07 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E82viB002641;
        Wed, 14 Jul 2021 08:05:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2020-01-29;
 bh=2aMRnxf4q0qGjXWqt9IqyAouyCjXtcLlRPi/lTe6FWc=;
 b=ljXnHRU52sls3Lxw0akVaXTOPNR3XOqMh2oBM0A5DeB4ZG37zmVjW4mq69Tst2R9XS3X
 oUSOKSVDdMWnaTMJJBJtNgrWL5QPRJQS4ciqNlQuOo0+pEhsANDufyz8LU/bSUkCEiw2
 v88Zn5QxXR1MJ4yPc3d7bkm4RdtNQ47mEzx5IpwEMIw+LTZ3TvPiif11BFeLMuCCEUc6
 CJxTB/AA46+CKYAvzJ4nvQcFUhzzs0zmK5pTuO/9abO8pXKRc9PRDGezSKHf2N/jjC+w
 TXgbj7ilYW4EUPgXOkDzCIAYpu0OtLHX1ljG5o/38Gqsun40f37cWN/59KuOIvfgp77v jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rpd8vbtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 08:05:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E80mpI146936;
        Wed, 14 Jul 2021 08:05:55 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by aserp3020.oracle.com with ESMTP id 39q3cekgef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 08:05:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftkGNcPwybH7eN3kw8gkIagWC9onMEQd0EUFZoCqAbFr/6Ge2EKZLkMxV/bTvrAZ0WZWkR3pdzfYoSpVCwOqYq5VNYbjtqF2Odt5CxboCLgp6haJ8IywE3pgJF6bYwVEX54Q2kNZC1Cttz+XVDG04qmLC28FT4MJkJVqMy+N/USuJABkHZxuKamOddachC3dVDfevX/+X7ikk9eCINosaQZfcakqCBQCRfH0OkEM+ZnTrWQQTnLbzK6RqD7mXRMu6BlMFbzUZft44xE/QMbDtmcJMVD37d63CGL2aDBF49Omu8cPdAcvH2Og2LIPyPI7A9ZSyaN7sTxeXD7b7ULj3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aMRnxf4q0qGjXWqt9IqyAouyCjXtcLlRPi/lTe6FWc=;
 b=b9y5A+gmqgvVivjZuPnl/c74WJveCF6cVq1R2bjfBCnrylan/a62PZzyeIiQUZvbHHFCwyITk8ToNHKMCXtFY+kTA7O6p3OsN3WGBFbR+tXyYLoMzckDftnOCrcoqRCY2NtdNqHxQkAH6iA1v6mc1yqzkuaTKooK+axv1TrJOQJ4Z7cWDgK0NZR76BV0eddAdiamKirfI8nQfgevnWbyw9SWMLNjpoW/C/odWiDrOqQh8MpsTurpneEoCoIJpSHGOMnpnr5B9zWqiPOLAp6aSNR1F+FSK+/O6/t7ENcAqoR66Ngiq9EU9C090vBhECm8XYgrcO00QhYy8RaYCBumWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2aMRnxf4q0qGjXWqt9IqyAouyCjXtcLlRPi/lTe6FWc=;
 b=JtVcghPlZTFacNHYoxIfYz6Quvf29l77Z/dIqKFngkXiasaRw/MrQ2AQVcG7Tgsn2A+upEjck+idqI7yAsSf7kb56vC0EFjekI5RAu8jNyTOQ8mO8Bllp+/tgVe27MTJS32tBQ0bZzEJKeZtN5JpKdOITv0g2FbzS75CU6LnF3w=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4483.namprd10.prod.outlook.com
 (2603:10b6:303:98::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 14 Jul
 2021 08:05:53 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 08:05:53 +0000
Date:   Wed, 14 Jul 2021 11:05:12 +0300
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
Message-ID: <20210714080512.GW1954@kadam>
References: <20210713084656.232-1-xieyongji@bytedance.com>
 <20210713084656.232-14-xieyongji@bytedance.com>
 <20210713113114.GL1954@kadam>
 <20e75b53-0dce-2f2d-b717-f78553bddcd8@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20e75b53-0dce-2f2d-b717-f78553bddcd8@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0049.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::12)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNAP275CA0049.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 14 Jul 2021 08:05:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd917d8d-68ca-4805-5f80-08d9469e3338
X-MS-TrafficTypeDiagnostic: CO1PR10MB4483:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB44834A42145BD63D9730C1ED8E139@CO1PR10MB4483.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M0OaoS6zF+rsSwlJZaOGZm7h2cBuTijTMvEcizkW0BXuwNO96fV1UqLA5GJSWngw4RtBP8BQpujnjGTjCPacw+W3dQ1epkjHqmXJap5cuzv/ec0mzb8ZBMIsSuyikyTG7ezUM0R3jgmnaGG5ZdNczqcKhi0NP60X3m0dIGZ5i5Wnk+r3wvHY5vKsGwY4C9w4w8mDN5jIjSXI6o3rG6XYM+wPoeA6mJX+fYCoytazd8pXeiroimKHQCypFYSnLnO8D+zl0HKbWvxpcRu0Dy4fFoJbxVlcqV457pDaSNwCDO4Guw6qVcAgKXIQfs+vWdAEhXI+Q2M3K9rta7tnisnRhEi4/TsbFMCWIKdM7FrZYbRztkJ39exmfOHe1KS8oRd1QN8TLVxz/W6/bhPWUMeYTL9XVFQk7b4i0/XKIRYkJRRWKimZjSGh8bFxxSn9il2+vLBlRZ5D/PmISdJN+WqOSuXbwJjZO1/rjA4fzznkOL3Lyqtz3owwUlRQoNRrTH5WcCZdkwNoqxPAyOAKKlhWub5RNw8Dzy4YtzmQkoASb3Xg6F60xAc/620SaRL9tp/ql+4gtoMihhZ8dAhTmYM5mkvayNehvWPsEvivkbL73M62xHjChixElTLMKg/rgt/txxIlMy/5OSz2ZPYhToABJ/fQfL5oDvckQiPbDmokAqV37pm6MG1wCAN2dfbxw1s8x4FKjSNZCGj8uHaAqxeleQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(366004)(39860400002)(478600001)(55016002)(9686003)(8936002)(8676002)(33656002)(83380400001)(4326008)(6666004)(6916009)(38100700002)(38350700002)(9576002)(316002)(956004)(2906002)(7416002)(1076003)(52116002)(6496006)(186003)(66476007)(5660300002)(66946007)(86362001)(66556008)(33716001)(26005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUp4cmJnY28vTW5QZ0JrTTFhb3RhQkhsWkMzQ0R4Y1V0Q1N6S3lIU0lza0RY?=
 =?utf-8?B?cDhUTytiVzhIQktyYzBLaWxpNXF0RmZ4LzJSeUZIQzNZallUbVdKVDRkcm9o?=
 =?utf-8?B?b3Z2NWJETWxxOEZpNlVtZVA1WXRaVG84azdXZ0NNRFhsRlJTVkh4emcwWFpm?=
 =?utf-8?B?cWwrdVR0T0pNcDFZZko4MkhKajZ3VWlLK1lsR2NmY3A2VDduTWRBY3o5bEYz?=
 =?utf-8?B?Y01ZaVlQOWtyRFowNEswSTM1QlU2WGRqQktHNzQvNTQxTHZCMTgxUitDVUUx?=
 =?utf-8?B?UEYzQWU5NEV3di92c0xZSG5PUWxFRDMxVjF1clF4eUNiOTFzWVYxSjMzM3lJ?=
 =?utf-8?B?cVJOUmorS3Rrcyt3UldNTVdrM0lqTDFnTkE4RjZ0QlVac2p1RHIydE05bVoy?=
 =?utf-8?B?aWgxamo0cEp1TlMrMmcwWjBrWlROK3Q3a2xnZHNSb29rWXJXNkQ0UHg5aUZS?=
 =?utf-8?B?a1pzcGRNaDNCUnhPbUJIZ3lFOXYwVGd1WG9aWVNGNkRMbkFieVExK2wxYU9Y?=
 =?utf-8?B?aXdVbU01VERieGFoOEdjUmFTK1Z4cmpOWndKbCszL2E3aGErU0hwY2tWQW5E?=
 =?utf-8?B?QXhnQkZLSXdhb0F1RHRFL3FoZU14Tm1ibDEybUkwaGF0VUJwWUJqUXZmWlB6?=
 =?utf-8?B?Zi8ydVpBbEdpN0o3YWw4Tk9FUzkyRWRodjF6eHF4SmJqb1hkREdHL2MrSGFG?=
 =?utf-8?B?VmdGczBIYXpqSDBZV1NFRVNNU2RUd3ZNd3dGdTFIZVlhT05NeDJ3VDl3VTdG?=
 =?utf-8?B?dVNOMUpmdjc3REF2d2RHQkoyUnB4aGc4SHVKVnQxUWdZMmZtUzNMQlNWQWE5?=
 =?utf-8?B?RTFjRUpMRzBhZWhCaEtTOEVjQng0NjNFWVJMRTkyOGR0d0o2Kyt6UkdUMmxz?=
 =?utf-8?B?bFVlRmEwRWVFdE5keFlNcXN6ZUpaek5qT2drL1lweER0R0ZDcXBlMWdnSUtz?=
 =?utf-8?B?UTZHZUZCUG9ENEJYWUtYTjd1REVLWENqYi9qMmphTVVlMFVLVmYrWTQwZnVH?=
 =?utf-8?B?cHZ5NkYwemRzM2pHY1NiWSt4TVQyUzZ5eWhOUW1PdDJydUtyZGd6STYvclBT?=
 =?utf-8?B?Vmx0TnQ0b3NNdnpEaDRYYnZFczdFZWtsMlA0NjdwOEg0MlVYRmxOV1RqMTZZ?=
 =?utf-8?B?Tzc1d0VOOUlNTjZHaW9pNUtQNTJSRE53T0ZJZFVYa1dOdm5BK3VVb29wWFB1?=
 =?utf-8?B?ZHU5UWNQaE5EcnJZaG1JZkVYemVmQTJLQWRsSC85MnJKeXRXZ2k4QW15djNv?=
 =?utf-8?B?T3I5VHJJYmhLTXhCZlFyK2UrSWsrM3hRS3VoU3NtYitxOW4zZnpVNjF0YXNs?=
 =?utf-8?B?TS9YK1QzV2ZoYlh4ZTNON05SWllFZUFPWDNqU3dPcm1uc2QyZXpwMlRCcGxG?=
 =?utf-8?B?RTFxejFQVGVyWWNCY29WRUx3RjRzcUV1T0FrQmNkdm9vMk41cDRMT3pwc29P?=
 =?utf-8?B?WDMrVGYxVlI5Q1kyeW41enBJZ2paNDRaeXM1ekJBdGpiOXhYWU1ncVg4cnhv?=
 =?utf-8?B?K3ErcWI3S2d6Uk9palV4QVZiS3hrOWFFYkQ3YjRkcUowYi9PQkY5ZjBGUE1l?=
 =?utf-8?B?aktCa2NlSURLK1FtYnJ3NlQzR1RkSzh2aE94ckZOczdXNHRqZDAyaDN2M2Rn?=
 =?utf-8?B?b3dISC9FSEhWTEFhQ3dBYXlVQ09zdWhUZ241ZXJmVzNzUjVkdTRYbDhmdVAy?=
 =?utf-8?B?Z1lncUdvZlpyNmFDWHA2MWVOWjhqWWdHeWZ6WExYUkUvbHNZeWV5ZmdNaW5x?=
 =?utf-8?Q?c+aNIVVq//2JME5PJyiK9l3Hg4tu/TfVvDm0oBX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd917d8d-68ca-4805-5f80-08d9469e3338
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 08:05:53.3112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SUhx5rHBP/c9tDOnZRauYWqXXZ9aE4oEJND9iXUm8H9whENcj8JCyNVCMx+ryNMHAMwJo2C8upQnhFptEfl6FJ0ZKhIndBtm59+jrH7QiKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4483
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=870 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140051
X-Proofpoint-GUID: Xy6BNIYKnJ9bTEb3yuv1KWtknz2jLlMB
X-Proofpoint-ORIG-GUID: Xy6BNIYKnJ9bTEb3yuv1KWtknz2jLlMB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 10:14:32AM +0800, Jason Wang wrote:
> 
> 在 2021/7/13 下午7:31, Dan Carpenter 写道:
> > On Tue, Jul 13, 2021 at 04:46:52PM +0800, Xie Yongji wrote:
> > > @@ -613,37 +618,28 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
> > >   	}
> > >   }
> > > -static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
> > > -					   struct vhost_iotlb_msg *msg)
> > > +static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
> > > +			     u64 iova, u64 size, u64 uaddr, u32 perm)
> > >   {
> > >   	struct vhost_dev *dev = &v->vdev;
> > > -	struct vhost_iotlb *iotlb = dev->iotlb;
> > >   	struct page **page_list;
> > >   	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
> > >   	unsigned int gup_flags = FOLL_LONGTERM;
> > >   	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
> > >   	unsigned long lock_limit, sz2pin, nchunks, i;
> > > -	u64 iova = msg->iova;
> > > +	u64 start = iova;
> > >   	long pinned;
> > >   	int ret = 0;
> > > -	if (msg->iova < v->range.first ||
> > > -	    msg->iova + msg->size - 1 > v->range.last)
> > > -		return -EINVAL;
> > This is not related to your patch, but can the "msg->iova + msg->size"
> > addition can have an integer overflow.  From looking at the callers it
> > seems like it can.  msg comes from:
> >    vhost_chr_write_iter()
> >    --> dev->msg_handler(dev, &msg);
> >        --> vhost_vdpa_process_iotlb_msg()
> >           --> vhost_vdpa_process_iotlb_update()
> 
> 
> Yes.
> 
> 
> > 
> > If I'm thinking of the right thing then these are allowed to overflow to
> > 0 because of the " - 1" but not further than that.  I believe the check
> > needs to be something like:
> > 
> > 	if (msg->iova < v->range.first ||
> > 	    msg->iova - 1 > U64_MAX - msg->size ||
> 
> 
> I guess we don't need - 1 here?

The - 1 is important.  The highest address is 0xffffffff.  So it goes
start + size = 0 and then start + size - 1 == 0xffffffff.

I guess we could move the - 1 to the other side?

	msg->iova > U64_MAX - msg->size + 1 ||

regards,
dan carpenter


