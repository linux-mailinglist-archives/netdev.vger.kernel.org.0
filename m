Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A783C6FC1
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 13:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235839AbhGMLfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 07:35:01 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41146 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235574AbhGMLfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 07:35:00 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DBH7cv008126;
        Tue, 13 Jul 2021 11:31:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=k5ITN5XmfxIM6FFARz02s+Im0DkSHgOrdmjvb4C8Xxg=;
 b=vaJvakrXrI6G26I3PqJDdzd8+H1N+tkyEZOGa14cJIQ+qQIIRbtLeFDy9BK9jdVKt/jf
 JcEQ2k/Ynhq0MT8Xq2bP3L4R198g/9oxNf/am+Nmnd4UCPnDJ6hwRBICQxbJ3SShk1J/
 EWoHGhMy7lgFrRH3lIiwCZJmNLjep8PCQPltVmo/5ZLbPZ2BJH9NZEFtXqIImqBIwRQh
 VjUcq2aexZ5SJkMtMxbj1BK2fQAbFg+kE55Mcl9ZcQMqrBideTkpy+i8bD4et6T9thFI
 /gRfx3WJXNgdUHV8Na9cnfIfTYCfpB+N9z+0hoUJ+XSR31WfeXzxJJfRDioqfE2/oNkv Rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqkb23nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 11:31:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16DBKw7U177385;
        Tue, 13 Jul 2021 11:31:46 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by userp3020.oracle.com with ESMTP id 39qnaxp7t7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 11:31:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lsaCfcGdlM885KK1AJvGsfOM2fpXCnDFD55wD1DLNQZ3/q6sFP/geU67+MIqLvDMkq9VL0qCIQ737oerr8Z/M7fTk8qrH1qeK3uo5Cy0ENMfC4MVLIGZGWH206H0+L2sfkmflaNGBNkrnjvthcfyfR5X6DxygrjV17CwTPhO7F48iXo4QriRpf6HE1QQC5XPgNzNO19qZpOdW76uCqKRFnWyaNJw6MTM+L6TK4Roz5vhrJ2dQz3V10D9k9gyktH6EBpr+ETt2aijv6oSAxbOozGW1d+Y5tGrSKyYBKUNIete0Nv/i8q9rm6aBg5lw1cYXCQAg4ZpIdrd3V+R79AS5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5ITN5XmfxIM6FFARz02s+Im0DkSHgOrdmjvb4C8Xxg=;
 b=TCmqwwhOkNvljMlpjzmf8Fyn1bsEIbMjRUDThZmMJXgjQTEc3OiPXQceB1EeRm4yL2KXRSoxg5O93nDcmOq7ciLcRIA4mwrkwbpo76m4G83nVLFuN7jM88nqiOnpTwZ4n8HYLhSmrsJ0cm/UM7Hl1sKK2cEovbGBmghgaR1x6Wbd/fklgcILxo6nHVj2I1wqnGfFjCqtOznFMnGqEgBeucLo6GgrWkYH3r1NBUfvfNf2Z0+HZYaFsyaoCjMqrEe04zNm9Q30DJJeqDBcpmjAqa8M0Q4rP/R8k5ghOHxSeramttfgCocGDFUb670zR1rv0avEGuPWR21nu5OMo2JjDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5ITN5XmfxIM6FFARz02s+Im0DkSHgOrdmjvb4C8Xxg=;
 b=KsBFFZ3Y/RzM8QvDFpgRGc+Ef/iTQlceJDbg8xkGieUPDtIQnhLim8XjGlgGtq68FPgVL/cQCpK/Fl66FCo1mmAovHrcfkJm9VUtsdlvrlUnUiODDtiw0KoktLnQ8zbLzIc70Syo98Z3hAeaeeP4e8+L3TyIB5RfResapseSHkI=
Authentication-Results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1998.namprd10.prod.outlook.com
 (2603:10b6:300:10c::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Tue, 13 Jul
 2021 11:31:44 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 11:31:44 +0000
Date:   Tue, 13 Jul 2021 14:31:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        joro@8bytes.org, gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 13/17] vdpa: factor out vhost_vdpa_pa_map() and
 vhost_vdpa_pa_unmap()
Message-ID: <20210713113114.GL1954@kadam>
References: <20210713084656.232-1-xieyongji@bytedance.com>
 <20210713084656.232-14-xieyongji@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713084656.232-14-xieyongji@bytedance.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0002.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNXP275CA0002.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Tue, 13 Jul 2021 11:31:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1486f005-c550-4f4c-e5c7-08d945f1ca5a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1998:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1998E0A34923347C04F97C208E149@MWHPR10MB1998.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KyGf1+qMiqbMaCqElCTxg5vu421hIQ3v8NiO6khHpQSSJgPudmhfh0TmRGbqivTP/LIAun65G4wFrWfG3xNg7IN/Bx18oUw7eeFwo6YCPJkS4l5gzm+1uG7WOgf6bx28pab4QRdj9vbf3NWeuLKcSXb+5Q/KMmg4zozz7OJpXDnYLgG1L0X9hxSyntND1s1RcgKKd3q8LhtJGhg3CKzDc/5XiqlOVhR4Gy85jFFCkdimVVbRCZyNydYV4u+/+bwRspH3ar55/l4dH/caOtXT3tss4tvCb6f5yb3XGHWVeK/ybID1SvFrowirAJdiWJbTh6DdTglUdjpQBileQItWLfPt9IDNV3Y932Dw/KD5sah+dOmssSYYTScNFFGUHon3OhYkFf+nimwqMx/onR1PW2i8MHAafDdK0uvSFXrCcN7+q8b1hVfFukAvCYqUNz43NwLALuzwW6FLXZNVEL396tB/fPWJcWZBqRLgTWQSi0hO8GbiNhsI/fD9MD+OcDXspEUUPBbMAoRGRu6vPcl+1YHL/o/s56Nd074mVm3cB5jm/aM0UvcdLARYPemwTERqN4P+zXZjg/Ayjsk9cBgxc2iIiV0mvocmgkDYWGbKJMKh79dVhnrYklCItvgZLfL+UJNT1cCYTUuws/Pik0kEC935X0/l2GiF7Q41KO3auYecQoSGRk28Dw7EqNJudgIR2yH2rhS3aJoJAO0OuefJ7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(366004)(376002)(39860400002)(8676002)(956004)(83380400001)(1076003)(8936002)(66476007)(55016002)(66556008)(86362001)(2906002)(44832011)(9686003)(478600001)(33716001)(26005)(38100700002)(7416002)(4326008)(6916009)(33656002)(52116002)(316002)(38350700002)(5660300002)(66946007)(6666004)(9576002)(186003)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a+UE+ULTtPQNxdLminwpzRe6DS6/AIyfXQ7Py2/PJnaUm6yPjN+01YX5hrgJ?=
 =?us-ascii?Q?mdWoXHgNOV0Xmz5gYMxZbRs70DQX+tfjVvcBtYJdvynu+gzVELqyMKKJU4Sa?=
 =?us-ascii?Q?rOIhtrhYlUfWSB1kgKlbviMLvDTpa+W3sx3IBheHxJyxFY0WUTlVMUyadncM?=
 =?us-ascii?Q?K90nxzOXu5Oz4ttl/YB6n/UJCi5UUymViQIf4sp3RKUkzmpHyC3k0LsHW6cr?=
 =?us-ascii?Q?Ka2F4CjLcq90LjB5ucz8dcNqd69AQL88Ovaudkmk94WQX6WeZ/jOqNOGgiQU?=
 =?us-ascii?Q?h6+Hu6W5cFOizAm/XqyzUB8RDY1Mzn/iRPhvVQxvkfbxrQEF4ymd5vu6OzHA?=
 =?us-ascii?Q?d+ULsBo6h3LtyuI8SWjMTAxLplvpqOkAZYMJQTbB10Sxc48rD2ULYda81yMV?=
 =?us-ascii?Q?Vw8vt1pjb8TLOxu4SXTBywRI7194TV46Ox5wtB2ZMvJ2BIORsjnnHcWT9yFd?=
 =?us-ascii?Q?UxqbcUHNqdGh+dUzt0V3OmqyQ/r6VmfSpoNwUKWZwl7fBUSXT5vf4C13GoNc?=
 =?us-ascii?Q?T/h9Q0A3bXtTFtgEm7DD3i8BZJauTSaMH6iiu9Gujo/iwek7x47f6KQV4AFJ?=
 =?us-ascii?Q?ysIcLOHk4p9cPTkai6RXTij126eFXdZuD4ZpHHBVv8OWZwPupbnBbvtTArrU?=
 =?us-ascii?Q?ep7/UU+NTNf5xZ3UP880GlLpjrFgR6HttRiVIlmwXgGZ+KvJHsPoKSFh8jAY?=
 =?us-ascii?Q?7j8hpJGO9IoSHEOofHIP1R5w6aGBI9EGBL0Ix2/Xbn+YL3uIHK9e92LYXuUo?=
 =?us-ascii?Q?k/oEEYMpslnuwXBDFnhOpwKw9M4M8EU4bC54nnTvmSWoVAsrXa6fOBo+wKYv?=
 =?us-ascii?Q?kRoEVxLByetl3jEp0ggtH+AnkWwmE4vpr6CW1jSqZY/kM/SWpjA7+o3wE4QI?=
 =?us-ascii?Q?2qBetV1umrOTn0IXbt4ZFy2V+DeZXddGq9h+HuCueNo41fvcFzb2/NVI/uLO?=
 =?us-ascii?Q?G1R32Pimw05/23Wt6n5xSXZb3Fh6J4lwP7CfhA4RlmBxYHJV9IE6rzMEhGO/?=
 =?us-ascii?Q?UY6o9HvkldshYMpZ0eQjPjfolMAnaKt2AzBLnNYyA3lz3/LuV8FhNl1+3Fut?=
 =?us-ascii?Q?QBBcJ2BYB5nl5k/UDl1est9o/DSaYZLdxGBkk+JjUPE6HH3WZJXawqXlb/Nh?=
 =?us-ascii?Q?q10UvfnjPlT4jVt0oV4u4RrElYHU3TW2zNvUu8Ozt5QgUtxuI7IAQSKm2NXH?=
 =?us-ascii?Q?D0SrD8sTBnhUIQ0u/wyIC8LVIXQPEniT+CixwxUres9Z61FqhK/Sm9HvFY8O?=
 =?us-ascii?Q?+sPQcc8aC8Sf3Lreli/PftMkaVsInjtDosaPQTwNZod8xZIQLJJQur2AauvI?=
 =?us-ascii?Q?+8PebxTAydQB7bB3Fh8em+eZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1486f005-c550-4f4c-e5c7-08d945f1ca5a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 11:31:43.9262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2RmxDmY9elJT+RvfP6Ppo6dX3NHbah61r4BCrdG1CS6+l888E7Bd2vHz+ZlQzEYgaH0ZSPOIm879QgoowmtBwXMoBwvdFrnN6g+mWORwcps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1998
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=837 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107130073
X-Proofpoint-ORIG-GUID: ufjBCmPPwrf3ypIeGr2TuZm9onNmXi17
X-Proofpoint-GUID: ufjBCmPPwrf3ypIeGr2TuZm9onNmXi17
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 04:46:52PM +0800, Xie Yongji wrote:
> @@ -613,37 +618,28 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size)
>  	}
>  }
>  
> -static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
> -					   struct vhost_iotlb_msg *msg)
> +static int vhost_vdpa_pa_map(struct vhost_vdpa *v,
> +			     u64 iova, u64 size, u64 uaddr, u32 perm)
>  {
>  	struct vhost_dev *dev = &v->vdev;
> -	struct vhost_iotlb *iotlb = dev->iotlb;
>  	struct page **page_list;
>  	unsigned long list_size = PAGE_SIZE / sizeof(struct page *);
>  	unsigned int gup_flags = FOLL_LONGTERM;
>  	unsigned long npages, cur_base, map_pfn, last_pfn = 0;
>  	unsigned long lock_limit, sz2pin, nchunks, i;
> -	u64 iova = msg->iova;
> +	u64 start = iova;
>  	long pinned;
>  	int ret = 0;
>  
> -	if (msg->iova < v->range.first ||
> -	    msg->iova + msg->size - 1 > v->range.last)
> -		return -EINVAL;

This is not related to your patch, but can the "msg->iova + msg->size"
addition can have an integer overflow.  From looking at the callers it
seems like it can.  msg comes from:
  vhost_chr_write_iter()
  --> dev->msg_handler(dev, &msg);
      --> vhost_vdpa_process_iotlb_msg()
         --> vhost_vdpa_process_iotlb_update()

If I'm thinking of the right thing then these are allowed to overflow to
0 because of the " - 1" but not further than that.  I believe the check
needs to be something like:

	if (msg->iova < v->range.first ||
	    msg->iova - 1 > U64_MAX - msg->size ||
	    msg->iova + msg->size - 1 > v->range.last)

But writing integer overflow check correctly is notoriously difficult.
Do you think you could send a fix for that which is separate from the
patcheset?  We'd want to backport it to stable.

regards,
dan carpenter
