Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD67F4A7711
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 18:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiBBRrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 12:47:42 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42130 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229747AbiBBRrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 12:47:41 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 212HY84K000892;
        Wed, 2 Feb 2022 17:47:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=X3LRawdiu+q/Ctvp53dn9yHstWqyzhqA99pUAZzo8EI=;
 b=iCuh9LpSrkk/QtB+t8f4Re3v/MeLtlrw+CdSdBTu4DJE6VIcdd+o+GWG/LFYkq7ISTfX
 qCRyfV68WpMrDeIuDC7dwuGHM70eSyZAV3iPRvIndsuBUwio8Aa40Rv3ky4ViTwuc0F9
 TLyO6ttejTI9nvI82yADmHugk0FBTWTNG1bmx/jj679J9WxVaxzhFJgm+EosdbyeJgWM
 3de7UC1peiEL+5RtDWvPNiXdxB6f/Vwf0NWZIAblEbVhvEzuFhaOBAJtbQSjhkye2CTE
 lC+pL1hB5mSREw0vxo5G3Hun8Fq2YnQz1Mg9YqnRQdh4BAqgP1yyw63pzL8u+6YVT3eZ hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9vew0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Feb 2022 17:47:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 212HjvJD140369;
        Wed, 2 Feb 2022 17:47:33 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
        by userp3020.oracle.com with ESMTP id 3dvy1sxagp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Feb 2022 17:47:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGqyxaqfoXpN6H847AAKSYphFJiuwGK8zkOTNv6RC1Ymk1nNV7ECJPNS45MoBwleGkxGl2HBN0KPGJhfWz37Nmi4qlqDqjsTN5vzDSCNU7Bm+fI1I8JZjhsXts8efbIhOsNCjkv1Xzk1/UuAYdWi06nCuFmtCZtD7K7/iCZOvQ3fZKzYmXuBY6Eyrtqh+XDkXyIQmn8B/X+MwnTal+2HGhzw0Fo/yTfTVoupCkmUjbB3lt9s9FsPIffCUYv2EQi6dMWftYxc/CTIAeb20RqArFVD8Z0q3PzfDtjYhlrX17azB0pgRhPtLLEk3wBITuUNm4YJHxX2O351Vxn1ljenFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X3LRawdiu+q/Ctvp53dn9yHstWqyzhqA99pUAZzo8EI=;
 b=I3mbQ3xWWUA94UuazVYv/xmEtzI09sEbTMCdkIA0W5gK3S/+4idt7dt8zUhJYXIhuj3RyuJLGbVmJYW4bXVtF91iAiyiZuDssxEa+l/KYiUoQCP4xuocnGkuJHX/WnYqV06zi3wh27SUb6Z+5EYTJ1olK/DTLoUPde33AbbBma+OZ4QNz8O0dIVJTfq27up9+aFHWsM+GS4EbN/YUd/wZtFJB4w9kRE6OFVFPEkAZRf11L/ct4OYpFBNlgWROxsQt82ro5KvQJHxJ5JNZcBLWX5LOMCemhKsmU9/aHwAZh/SG/+oYzd/AMexxhWHTHc7VU3p8w2UrHPsLlwtcN9IoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3LRawdiu+q/Ctvp53dn9yHstWqyzhqA99pUAZzo8EI=;
 b=bkZ77os/Zd3iE15vWnT8A9GTYv7DFV2MxpAzkQ3Dc2bJVx+VsVpYnuH+kUTezNl/LHGpUkjwQqbHlDWot+qJkzhmronq1KeFzEzHQ9Q1MIZkm68rka9LEX5kOx4DXImHKqkfQWwdn1wJQanh7IheqjnOo3lByY6Rn/PoAAotaCA=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SJ0PR10MB4560.namprd10.prod.outlook.com
 (2603:10b6:a03:2d3::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Wed, 2 Feb
 2022 17:47:30 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4930.021; Wed, 2 Feb 2022
 17:47:30 +0000
Date:   Wed, 2 Feb 2022 20:47:09 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, jreuter@yaina.de, ralf@linux-mips.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Fixes] ax25: add refcount in ax25_dev to avoid UAF bugs
Message-ID: <20220202174709.GY1978@kadam>
References: <20220202161846.26198-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202161846.26198-1-duoming@zju.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0033.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7e83f65-9ec2-47fa-e4e5-08d9e6741590
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4560:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4560219EC9DBC340D9CA762D8E279@SJ0PR10MB4560.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:268;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rw5cvoW5M9+exkgxlTl9v2b9Hk8hx2Gf8KO7ZuFwQUdZDPmXRJ70Ar7QVA74vEJ8fxq0yaxaTDEO19oTmTDr7dVzDmt8QZ4By4JlYKmWjb/uRbW73nW+o+dSz4esS0iX67LUF+7hrivBgm6XIPsszg5jS82CRDZACX0hPOAxb+yojSITBNqcWjz7h6R8RsXpyPbrpcAhzCRC1vnn0ONzZ/HmDtMKnAUQ7Nmxto8EDU04RCGeSDn7QSwhUy9LE3Nt7RNQNi6Go2N+gOmqrXJpt+f0C3xN6z/3y41LY1uzHu/NsPbEVTV41juB2NN4DZpKVM4PnJmIifxJBs89He45t3KaQLUxliSZl7RnYdJD34D7X3XWuOLgopuPcE2nKpf65llcRs8JKXnR9y0W3fJp65/8UDGJGVgahOwwDk7ehrlbyZHG94Ydyojn/HQdMirMG5pj6UMoF1cM1Ao53axdj1s+FNphJuVBOCqBbO/kUcpoBErzSM3RJE8QiRILFuk//vCMIH0s1ODvaXRPeYQaB2N3jovpDTYvs7KgcEV6MlIoaIw/stu3hGL5rjrcJ3elc0o3Cxq9h/atiiTHPEUXQQAk/OcwO5NWrEDK8c2CIhILsOinlhoW+QjADUjwr3nwZxh/g092BAngvlgL3L8WSo22dZ6BjWLjilMvUbZwtQRAoa83h9b3lvSccsUTn7RnOu+GTljGeL1+T1GWCr0Sbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66476007)(66946007)(33716001)(4326008)(6486002)(8936002)(86362001)(66556008)(38350700002)(508600001)(38100700002)(8676002)(6916009)(316002)(6512007)(5660300002)(9686003)(44832011)(26005)(33656002)(186003)(1076003)(2906002)(6666004)(83380400001)(52116002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HU3YEKyQIgkRW4/UQDX98BQ4kCnbApSk/iVZ/PyMaJmDzcd+WU04IEvRg2nd?=
 =?us-ascii?Q?LJQVtjfqUYHlIfF0VmjjtOGJnCnFbNAdEPmYla2kF93thmX4AI8wzfEVf6xl?=
 =?us-ascii?Q?Ubr5Gal6+x5GuDs7fpfKVk/FIE5wf6gWpk2FOJj4e9P32+T8rJ5WXqQuQRwp?=
 =?us-ascii?Q?ZDQzs25H29qJ7zHYAfDkarMWHylNUm+0+9IKSUHVe5JIpqAFBvJYXw5FJ+CG?=
 =?us-ascii?Q?bM5oxUCYJdSX5/nJxMC2YTgVejqJfXNxmrN52aN17fdD9nKCvPlkv3kCVzuj?=
 =?us-ascii?Q?kD3cOXtT4AxjxxSZMwCHVWBUbqSHksU+ZZ1tpO2p4thQUz52sUQrWrg+HsDO?=
 =?us-ascii?Q?U0pP2HgaCJ6swZqqS3mLEhrt2l9MfJKb709U20C9RdDtMrk5VFWc/vnblZK+?=
 =?us-ascii?Q?nHawceraj7DH89lSawXQCtNaNvBEM5ezTslnfMNL/7ol6Q6EdZd5mzput18u?=
 =?us-ascii?Q?UmTHsEvexLxni8hbhDZrgZAbVLXhzfy7jqw/rlynSW84BWYWkKNq3bAt0Dso?=
 =?us-ascii?Q?KkFQZU3lNR7EahsZUVw+Y53ZJhH+W0l+xHJSyQhvzrSacoyhLR78UUpx844x?=
 =?us-ascii?Q?iOJ6mfOC+uZMHuCX2lrJeJzrBAoQnYkdQRu6w8HJUqfbXaBeVtxqTpMLRlei?=
 =?us-ascii?Q?nKHDHXg7kov0bb/AnoCwIMnUjwgptAqfRjKIuakFx8Mf/5I7ITwFAZ97Ts8T?=
 =?us-ascii?Q?OC0bWA4YHyWqOiX5yvp+1Aa2I7G/jvdHu11KMah3ztJcGOXRIDP5SWC+jYtC?=
 =?us-ascii?Q?kNpkzwDIrW5aUHVtvec+OWVLCrzfsdcB987zSDGKNMFGzUWxM9tJ7MUCAR6g?=
 =?us-ascii?Q?pWey5eLp8CsvnK3qETN68CCWZJ3+qt6LfI+j3SUItT8sIYLIK7pcVAD4cD6+?=
 =?us-ascii?Q?FJoUWYyv7pOAIFDglRs1dFEdKHLEYF7Elomwxi6z4a/q8Z52uS5K8GCaUb+Y?=
 =?us-ascii?Q?hVvdkL++I8md1zwta2mvu/+C+DPFog3VXhtG5OizgwpALE0sicJLEpSFgIbK?=
 =?us-ascii?Q?kzms0OkvlntSIeg63q5rkBQiBQ5HBc+KIJLoe7UcHHNEhcN7Mum87hlQy8+K?=
 =?us-ascii?Q?aMMW9/XRnnAOeaq/nqHTmzTaVfnHG9n7MTiyag9AliqCIbZ8cFn12Nyc0GT5?=
 =?us-ascii?Q?wFJf7+xHvPekUTkZ1QjyDeEcNlAafHFVhytGqtK9lXjuDAHsPe8N2/j0+3cb?=
 =?us-ascii?Q?fuH9YEbkqgYKlF7Bh9ObYVhK1X+AriFkcon6Allx1qRxqawG+rYB14ROyN1E?=
 =?us-ascii?Q?4KEULYVXo7ZxzdDy6yELeeawWIclmOtG0lB+WzGmtvNYqxCBCVgGkdfNAjc0?=
 =?us-ascii?Q?aXtLcAUo5LVk7wk2Ns1JC3f7CsH7JIu2UwdAEwKv1FxpNaid7x9OSc6q0Pk4?=
 =?us-ascii?Q?ungfsznOuzy57QWuBeQ0fEx0Tqi2YEI1z+L7Uvlkt+L/RI8wZofnZpK+ej16?=
 =?us-ascii?Q?+4lHd0UlMulciyYD402M0tMjtPVdkQ0PzSjB1Sr5r+eXz/reIk8Vnue7EgUV?=
 =?us-ascii?Q?xx9OoOee5SpJ546oNM8pz15SExXXFu1KTW9zV5uOtLgueTwEKvVsPXJ/YREh?=
 =?us-ascii?Q?xFv9IXtA/tkm1/4ixSMTaKZ2LaspErt6cVKgADXWwbLxe/1T6YSMxKcxg88d?=
 =?us-ascii?Q?ry5TE+b5w+rnk428fPKXsWawTVyZVTkKdpuidqSnM380H4Ajgqxeti0eOUY8?=
 =?us-ascii?Q?Lrh5E6x0+aEAlWOyxIwIdbo8CPA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7e83f65-9ec2-47fa-e4e5-08d9e6741590
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 17:47:30.5953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i7cJkllUcQnVkVYkgBI6viYvsdKHGgLsAvkupgpLO4iy/axckYrTiGtNyInc4cGC5bLkSGMf+WiKynlezf+g79VV+9JPHyFc+xGdT2+t/7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4560
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10246 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202020099
X-Proofpoint-ORIG-GUID: HnzHLR8cMhshtZoesUKYb6vwJ8xPyLmK
X-Proofpoint-GUID: HnzHLR8cMhshtZoesUKYb6vwJ8xPyLmK
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Duoming Zhou,

The original patch was already applied so you need to just send the
fixes by themselves on top of the net-next git tree.

> ---
>  include/net/ax25.h    | 12 ++++++++++++
>  net/ax25/af_ax25.c    | 20 ++++++++++++++++----
>  net/ax25/ax25_dev.c   | 33 +++++++++++++++++++++++++++------
>  net/ax25/ax25_route.c | 27 ++++++++++++++++++++++-----
>  4 files changed, 77 insertions(+), 15 deletions(-)
> 
> diff --git a/include/net/ax25.h b/include/net/ax25.h
> index 526e4958919..1a38b1ad529 100644
> --- a/include/net/ax25.h
> +++ b/include/net/ax25.h
> @@ -239,6 +239,7 @@ typedef struct ax25_dev {
>  #if defined(CONFIG_AX25_DAMA_SLAVE) || defined(CONFIG_AX25_DAMA_MASTER)
>  	ax25_dama_info		dama;
>  #endif
> +	refcount_t		refcount;
>  } ax25_dev;
>  
>  typedef struct ax25_cb {
> @@ -293,6 +294,17 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
>  	}
>  }
>  
> +static inline void ax25_dev_hold(ax25_dev *ax25_dev)
> +{
> +	refcount_inc(&ax25_dev->refcount);
> +}
> +
> +static inline void ax25_dev_put(ax25_dev *ax25_dev)
> +{
> +	if (refcount_dec_and_test(&ax25_dev->refcount))
> +		kfree(ax25_dev);
> +}
> +

Forget about these cleanups for now.  Just fix the reference leaks on
error.

>  static inline __be16 ax25_type_trans(struct sk_buff *skb, struct net_device *dev)
>  {
>  	skb->dev      = dev;
> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> index 44a8730c26a..7463bbd4e63 100644
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@ -91,6 +91,7 @@ static void ax25_kill_by_device(struct net_device *dev)
>  			spin_unlock_bh(&ax25_list_lock);
>  			lock_sock(sk);
>  			s->ax25_dev = NULL;
> +			ax25_dev_put(ax25_dev);
>  			release_sock(sk);
>  			ax25_disconnect(s, ENETUNREACH);
>  			spin_lock_bh(&ax25_list_lock);
> @@ -358,21 +359,31 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
>  	if (copy_from_user(&ax25_ctl, arg, sizeof(ax25_ctl)))
>  		return -EFAULT;
>  
> -	if ((ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr)) == NULL)
> +	ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr);
> +	if (ax25_dev == NULL) {
> +		ax25_dev_put(ax25_dev);

This one will lead to a NULL dereference.  These NULL dereferences are

>  		return -ENODEV;
> +	}
>  
> -	if (ax25_ctl.digi_count > AX25_MAX_DIGIS)
> +	if (ax25_ctl.digi_count > AX25_MAX_DIGIS) {
> +		ax25_dev_put(ax25_dev);
>  		return -EINVAL;
> +	}
>  
> -	if (ax25_ctl.arg > ULONG_MAX / HZ && ax25_ctl.cmd != AX25_KILL)
> +	if (ax25_ctl.arg > ULONG_MAX / HZ && ax25_ctl.cmd != AX25_KILL) {
> +		ax25_dev_put(ax25_dev);
>  		return -EINVAL;
> +	}
>  
>  	digi.ndigi = ax25_ctl.digi_count;
>  	for (k = 0; k < digi.ndigi; k++)
>  		digi.calls[k] = ax25_ctl.digi_addr[k];
>  
> -	if ((ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev)) == NULL)
> +	ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev);
> +	if (ax25 == NULL) {
> +		ax25_dev_put(ax25_dev);

Don't do this.

>  		return -ENOTCONN;
> +	}
>  
>  	switch (ax25_ctl.cmd) {
>  	case AX25_KILL:
> @@ -439,6 +450,7 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
>  	  }
>  
>  out_put:
> +	ax25_dev_put(ax25_dev);
>  	ax25_cb_put(ax25);
>  	return ret;
>  
> diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
> index 256fadb94df..77d9aa2ccab 100644
> --- a/net/ax25/ax25_dev.c
> +++ b/net/ax25/ax25_dev.c
> @@ -37,6 +37,7 @@ ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
>  	for (ax25_dev = ax25_dev_list; ax25_dev != NULL; ax25_dev = ax25_dev->next)
>  		if (ax25cmp(addr, (const ax25_address *)ax25_dev->dev->dev_addr) == 0) {
>  			res = ax25_dev;
> +			ax25_dev_hold(ax25_dev);
>  		}
>  	spin_unlock_bh(&ax25_dev_lock);
>  
> @@ -56,6 +57,7 @@ void ax25_dev_device_up(struct net_device *dev)
>  		return;
>  	}
>  
> +	refcount_set(&ax25_dev->refcount, 1);
>  	dev->ax25_ptr     = ax25_dev;
>  	ax25_dev->dev     = dev;
>  	dev_hold_track(dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
> @@ -83,6 +85,7 @@ void ax25_dev_device_up(struct net_device *dev)
>  	spin_lock_bh(&ax25_dev_lock);
>  	ax25_dev->next = ax25_dev_list;
>  	ax25_dev_list  = ax25_dev;
> +	ax25_dev_hold(ax25_dev);
>  	spin_unlock_bh(&ax25_dev_lock);
>  
>  	ax25_register_dev_sysctl(ax25_dev);
> @@ -111,21 +114,23 @@ void ax25_dev_device_down(struct net_device *dev)
>  			s->forward = NULL;
>  
>  	if ((s = ax25_dev_list) == ax25_dev) {
> +		ax25_dev_put(ax25_dev_list);

Just leave the style changes until later.  I'm sorry I brought it up.

>  		ax25_dev_list = s->next;
>  		spin_unlock_bh(&ax25_dev_lock);
>  		dev->ax25_ptr = NULL;
>  		dev_put_track(dev, &ax25_dev->dev_tracker);
> -		kfree(ax25_dev);
> +		ax25_dev_put(ax25_dev);
>  		return;
>  	}
>  
>  	while (s != NULL && s->next != NULL) {
>  		if (s->next == ax25_dev) {
> +			ax25_dev_put(s->next);
>  			s->next = ax25_dev->next;
>  			spin_unlock_bh(&ax25_dev_lock);
>  			dev->ax25_ptr = NULL;
>  			dev_put_track(dev, &ax25_dev->dev_tracker);
> -			kfree(ax25_dev);
> +			ax25_dev_put(ax25_dev);
>  			return;
>  		}
>  
> @@ -133,31 +138,47 @@ void ax25_dev_device_down(struct net_device *dev)
>  	}
>  	spin_unlock_bh(&ax25_dev_lock);
>  	dev->ax25_ptr = NULL;
> +	ax25_dev_put(ax25_dev);
>  }
>  
>  int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
>  {
>  	ax25_dev *ax25_dev, *fwd_dev;
>  
> -	if ((ax25_dev = ax25_addr_ax25dev(&fwd->port_from)) == NULL)
> +	ax25_dev = ax25_addr_ax25dev(&fwd->port_from);
> +	if (ax25_dev == NULL) {
> +		ax25_dev_put(ax25_dev);

NULL dereference.

>  		return -EINVAL;
> +	}
>  
>  	switch (cmd) {
>  	case SIOCAX25ADDFWD:
> -		if ((fwd_dev = ax25_addr_ax25dev(&fwd->port_to)) == NULL)
> +		fwd_dev = ax25_addr_ax25dev(&fwd->port_to);
> +		if (fwd_dev == NULL) {
> +			ax25_dev_put(fwd_dev);

NULL dereference.

> +			ax25_dev_put(ax25_dev);
>  			return -EINVAL;
> -		if (ax25_dev->forward != NULL)
> +		}
> +		if (ax25_dev->forward != NULL) {
> +			ax25_dev_put(ax25_dev);

Drop the fwd_dev reference as well.

>  			return -EINVAL;
> +		}
>  		ax25_dev->forward = fwd_dev->dev;
> +		ax25_dev_put(fwd_dev);
> +		ax25_dev_put(ax25_dev);
>  		break;
>  
>  	case SIOCAX25DELFWD:
> -		if (ax25_dev->forward == NULL)
> +		if (ax25_dev->forward == NULL) {
> +			ax25_dev_put(ax25_dev);
>  			return -EINVAL;
> +		}
>  		ax25_dev->forward = NULL;
> +		ax25_dev_put(ax25_dev);
>  		break;
>  
>  	default:
> +		ax25_dev_put(ax25_dev);
>  		return -EINVAL;
>  	}
>  
> diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
> index d0b2e094bd5..7fe7a83b2a3 100644
> --- a/net/ax25/ax25_route.c
> +++ b/net/ax25/ax25_route.c
> @@ -75,10 +75,15 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
>  	ax25_dev *ax25_dev;
>  	int i;
>  
> -	if ((ax25_dev = ax25_addr_ax25dev(&route->port_addr)) == NULL)
> +	ax25_dev = ax25_addr_ax25dev(&route->port_addr);
> +	if (ax25_dev == NULL) {
> +		ax25_dev_put(ax25_dev);

NULL dereference.

>  		return -EINVAL;
> -	if (route->digi_count > AX25_MAX_DIGIS)
> +	}
> +	if (route->digi_count > AX25_MAX_DIGIS) {
> +		ax25_dev_put(ax25_dev);
>  		return -EINVAL;
> +	}
>  
>  	write_lock_bh(&ax25_route_lock);
>  
> @@ -91,6 +96,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
>  			if (route->digi_count != 0) {
>  				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
>  					write_unlock_bh(&ax25_route_lock);
> +					ax25_dev_put(ax25_dev);
>  					return -ENOMEM;
>  				}
>  				ax25_rt->digipeat->lastrepeat = -1;
> @@ -101,6 +107,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
>  				}
>  			}
>  			write_unlock_bh(&ax25_route_lock);
> +			ax25_dev_put(ax25_dev);
>  			return 0;
>  		}
>  		ax25_rt = ax25_rt->next;
> @@ -108,6 +115,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
>  
>  	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_ATOMIC)) == NULL) {
>  		write_unlock_bh(&ax25_route_lock);
> +		ax25_dev_put(ax25_dev);
>  		return -ENOMEM;
>  	}
>  
> @@ -120,6 +128,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
>  		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
>  			write_unlock_bh(&ax25_route_lock);
>  			kfree(ax25_rt);
> +			ax25_dev_put(ax25_dev);
>  			return -ENOMEM;
>  		}
>  		ax25_rt->digipeat->lastrepeat = -1;
> @@ -132,6 +141,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
>  	ax25_rt->next   = ax25_route_list;
>  	ax25_route_list = ax25_rt;
>  	write_unlock_bh(&ax25_route_lock);
> +	ax25_dev_put(ax25_dev);
>  
>  	return 0;
>  }
> @@ -147,8 +157,11 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
>  	ax25_route *s, *t, *ax25_rt;
>  	ax25_dev *ax25_dev;
>  
> -	if ((ax25_dev = ax25_addr_ax25dev(&route->port_addr)) == NULL)
> +	ax25_dev = ax25_addr_ax25dev(&route->port_addr);
> +	if (ax25_dev == NULL) {
> +		ax25_dev_put(ax25_dev);

NULL dereference.

>  		return -EINVAL;
> +	}
>  
>  	write_lock_bh(&ax25_route_lock);
>  
> @@ -173,7 +186,7 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
>  		}
>  	}
>  	write_unlock_bh(&ax25_route_lock);
> -
> +	ax25_dev_put(ax25_dev);
>  	return 0;
>  }
>  
> @@ -183,8 +196,11 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
>  	ax25_dev *ax25_dev;
>  	int err = 0;
>  
> -	if ((ax25_dev = ax25_addr_ax25dev(&rt_option->port_addr)) == NULL)
> +	ax25_dev = ax25_addr_ax25dev(&rt_option->port_addr);
> +	if (ax25_dev == NULL) {
> +		ax25_dev_put(ax25_dev);

NULL dereference.

>  		return -EINVAL;
> +	}
>  
>  	write_lock_bh(&ax25_route_lock);
>  
> @@ -215,6 +231,7 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
>  
>  out:
>  	write_unlock_bh(&ax25_route_lock);
> +	ax25_dev_put(ax25_dev);
>  	return err;
>  }

Thanks for this, but please can you resend with the above issues fixed
and based on top of net-next.

regards,
dan carpenter

