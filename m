Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EB84A4D67
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381078AbiAaRiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:38:02 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19480 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1381046AbiAaRiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 12:38:00 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20VFwpko006232;
        Mon, 31 Jan 2022 17:37:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=iqVY+LqOqw9FLPL140wR8K/FJe7A4UCXMQVUTTDmRiA=;
 b=qkd0+a8yOpATc4IaAda0uJfZ3vl6F7Jwk7fXltxokxEW230EJ+npCnR8UGughO0WGQcb
 EsjImPXonz0h7KS96KEIYdFDaGfA3rJIBmBZksZhEVH+0NUC3iTrNXq9lsfYUNNvjEMB
 dlz8ydfUB3HrbkTfT/OsYGimYtrsCB6N6eomySDcK1GeEQT7pG5ShyO5tjYAKD4XZXEd
 4Gb+yYqogiUPKOQEaPDGjlJBg8cXynV1I0ADxPyJCOEoPYq3SkfLxbzm98FOb3rV9Cd0
 HjMqChHdUGtKveQfyeykT6e6rUJlrGwZ0S8peijZfQqaYMdMeR4Gq9ofl2gAZZ2HjqYF mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxj9w8g0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 17:37:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20VHZcOD098430;
        Mon, 31 Jan 2022 17:37:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3030.oracle.com with ESMTP id 3dvumdxc4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 17:37:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZg/r9Zi5D5Ek/QRnComTOkWeaiu0jFrKaxPfBczE012qumCvL8XeUyUhAWxNoNW3lz/x4BmRVkgfJJScxa/k29ZKfNNiroFpTDniT4OvYcqaFDM8PKCTMRSoczAZQMkSqX3U2GIvFtLi2AJ5VLJtiW7Rk2s+aWdJtHUKCH+ixcvLkGYn9OOmOUyasUnrYdFEEclqvkCrhxcEbXj5NeVu/CX5HF8wFdyZjcBl847eFNiYpaYnmavevM9c5DA1csRkg5ihtdzv6eHRdpv8uPlEyVhuaqYRhmjFx4PaTaZj6zDAQ9pbNnN4eo3L8BK4jzgn/Y8N8vUzMVCifOLuk8AWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqVY+LqOqw9FLPL140wR8K/FJe7A4UCXMQVUTTDmRiA=;
 b=gGp2vH8ufwl++G7RzR31mOQJ5RZ6pUsJEp6FKs5AjnuN5fFSmMJuVtCIxlksJdf4Ep+HG2PDE5Qf3Dy5+wq56Mfd6EuxEn3uyseAbRPIO0ksEC2FoN2wKoKy+jxzu7LlrCWIs8oIpwsQKW91skPLCrvc9720nH9tMrrw5kycH7JPy5VMZVYfsZPzIS4ejfp8rVLaI02XZgu+Hw3GYCVSyPLMs7nSN8ORghnJYAmFLHIlJ3zUWCOLWDctJPrYLNDkOcBBDB4PPaTebbqHPlHPo7qv5Tddp8/Xr04Ygb414AqlpAMjCk+bOcmYYZtWAZF5p8XanA5vIOZwMlqd4pZ1rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iqVY+LqOqw9FLPL140wR8K/FJe7A4UCXMQVUTTDmRiA=;
 b=idHubIz+An6ZFKAgMlYSIeNaOvRQlPOGlLN491nG7ISrSOcqnkm22qvCqA9Npz37I7VUmisLz/pmLOC1dgeiQhCqKUyQbb4hcOJeKARWtEyJh/gGuN/0plOkWFGt++6PppEkmO/LvofLFBpx9zmRvlZt9y9QJ54SwrJsdrc12Lk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CY4PR1001MB2342.namprd10.prod.outlook.com
 (2603:10b6:910:46::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 17:37:50 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 17:37:50 +0000
Date:   Mon, 31 Jan 2022 20:37:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, jreuter@yaina.de, ralf@linux-mips.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ax25: add refcount in ax25_dev to avoid UAF bugs
Message-ID: <20220131173729.GN1951@kadam>
References: <cover.1643343397.git.duoming@zju.edu.cn>
 <855641b37699b6ff501c4bae8370d26f59da9c81.1643343397.git.duoming@zju.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <855641b37699b6ff501c4bae8370d26f59da9c81.1643343397.git.duoming@zju.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0026.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc4370be-db01-4d48-f9f9-08d9e4e066f8
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2342:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB234200722EB4D31D79C8DC838E259@CY4PR1001MB2342.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U6x+UFIgWyvO5zU7RzEcXx5mqGCI23x2VcY9YCfzFvNePPWhnq4vQ53DZi6KWlypTcP8DhLh83Q0bHCG+UqgKYo0nvdwRpBJoxE1OQzVWtoJneJ82lRcBOwigas8Lx0KHf4tm7w6argHoteRzwGgGA1t8Gwie1na5Ym1wVPwE18H0IsTsaGvztgM3EVabz2YohG4BNFrVZ+JjFGRtNuEVlQGEl/jHXjhsOSUxPbGnHwuwAV39x7L//XXE9ipYz9AyO6CV2RTWKiqPGKnxlaN4zAzRaZ5JSykoTScrXAa1nyZY9S0N0sTB9tCtSj5ptdJm1YhgQeKeOIHgGjpFWBhpADCymW9iLp2kD6qPtouG1RSar63IuL39vbZ1esQNLX5YFwDkJkxEY15QigaidMEPkqM78wP3QqPlv27jUGG5vgW4hnRcG9NscHy/uEjamWytp/1VBLupqwB8FIZ2Zm6hCN1soajnr4x67ZhbqJUNHZZaveGw67CbFLPF4P8pgSznne6ZrBLltVr3/awTf9LIzYpBhUVzAP7mPu8g7FOUiz0VAGUY3CoGuajar/aPo+uP4dustYOe6GvAFxS6LMRYoCK/i8F8nnYKAFBnSZUYf7TZWIVq3wItk+KKQW/fl2oKkQd+U6wIh5lGid8Me6GM/qlbYckl+Z7j8PXMCkT3Z5oUhPybDEhymxj8vBp9xv3t7R54XZXYE9/O38lOkKWbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(6486002)(186003)(316002)(6916009)(33716001)(86362001)(508600001)(5660300002)(44832011)(33656002)(83380400001)(2906002)(8676002)(4326008)(9686003)(6512007)(8936002)(66476007)(66946007)(1076003)(26005)(6666004)(38350700002)(38100700002)(6506007)(52116002)(66556008)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BL/exvtdBysZLRp87btnTj+I2xPOFfSUo2ZCXzSZdEJFI1cHJOjKzvtZyWSD?=
 =?us-ascii?Q?AEhCpplH6iBU790qwEUYEhtYMcVLiK1je17PzBExWskdmh6WspVv8MhSLayW?=
 =?us-ascii?Q?J544PWxslDe2Zp+Z+JSFFDQnOQ3SSgxlHzzc+4SuUaTKhqQBLWhzJ/FhnQxd?=
 =?us-ascii?Q?SOqeCMA2hbwl+w7dZvuOwScmAAdNXPkLNcKmM/sSK0XsDhtpV7wmJRpsKcRU?=
 =?us-ascii?Q?MsolP+0X7QNPH/WXJy/qwa9jMo+opwmEybZKuVYm/KujEPAtJE8rLyMl+59Q?=
 =?us-ascii?Q?uKx58vZpz4lVvWYHBG0cYp5sr68NP+s5kCsJdIcErK0LLhQj3IdXLUw4Pvnh?=
 =?us-ascii?Q?P6C6TdKOrwCOWctHAo6GI3FIP+E64NbhfFRUTY4ZT6ua+ablrLPOPROdynfL?=
 =?us-ascii?Q?rNOnpFuFmXcAJInZxi+JjXgTQ2EBgZmAfoKRe9cFGm23+uSBkoLiHMXhCgKl?=
 =?us-ascii?Q?Y5qDsafTguwgTtc1w8CZ15QBKFrk5ZQ/Prq2JpiFMCU/OlFvi1F+7uLWHD1b?=
 =?us-ascii?Q?2HmXFkBL9a4arcyKSSdu1998jMLMFufCpqlWjYwp4v5No0bpI8BirR2JH19N?=
 =?us-ascii?Q?fOu7Cts2wJnMgkdVdiTqDPflN453eYwzaBLqEKdlEo2s6sou+pd2Kw6YS7+A?=
 =?us-ascii?Q?stxVIX7sApxQ/tqDZrvflXmW1rbsaBaxPuoVghA6PR0WIKcj3U55u7yGeWQY?=
 =?us-ascii?Q?uJXAWoxUHlh5+3w/ZgMZG8Rr7Ds/VdhKgcn8H3jFmKEOg67mKj/bhCZ3LruT?=
 =?us-ascii?Q?doZuQYRJlNBcOif9hx+r52VE4B84U5btWvCyyaH5V2X0WgYcfAtj2mzF/Guk?=
 =?us-ascii?Q?r1QlZW12ErLueKrfJc+DXzPTPU9JsFmofjAzbhvS37tHYbKokwrNspzk1r9N?=
 =?us-ascii?Q?uPmDZLS420BiHL4l8ihvUFmCYkntaQ1nloEpVDvjgNOgrM9GMAyHMmvWZvNV?=
 =?us-ascii?Q?aLbgBeCmaQLda3f6G4+6JqgKqEixnvXDdTmBptdfqDH9brwV2jylRb7recK8?=
 =?us-ascii?Q?Kl2SwOomk8xAZTgmIUSoYaOz/Gqjdm+TzrfZSHzJAGWp9uT5jhnFZ0699sn/?=
 =?us-ascii?Q?Wb6nLX6+DNAUqhf9T+Npuv9nikIrQlVJvKz+yue6FsrJIdI/UpTs2/Ag6rIT?=
 =?us-ascii?Q?F93r/OsmAvlynDsjSTXAKEFPyS3l6cmRK+rdZO7N98tbKTq1HlzNXC/tX3ri?=
 =?us-ascii?Q?rFfSHuDn6T2L7zYtn2b6h0yt1sAL98wVqhiOmrCXT2k3NjwNamOsGaYdCfdH?=
 =?us-ascii?Q?dFuIyOpBphYcydkTpdye1vwK7E2D/sJqSwS+4pqCIm/xIX4UvplXHfWz8Nvw?=
 =?us-ascii?Q?rg8Y6KlVRwwoKD35nKjZA3E03fMEN3vumsyN+jRYWzOktBJ+TR3l3Q2rHVK/?=
 =?us-ascii?Q?Am0g6CjW+RMeZ1vQkv1wQDsqyqRbWgicTT4ODBDgL8rPcc2YbE8rTo4FuKyd?=
 =?us-ascii?Q?LN9wB5T5JBZVUKB/UeLyRkv7+2DXd226tNQtYD00MH8qB3sB5et7khhpwBGJ?=
 =?us-ascii?Q?yeER5pdTxxn1Hn5VQrR/S2RxDSr3nPyp4S/mNEHa9idr1xnxPcmPft4sdKIF?=
 =?us-ascii?Q?pAp8DLkou+Bt4pBJAG5ZNLkiuIv6AnZPUyMCiIOR4d+gRRMB1Yu+YGuJxWay?=
 =?us-ascii?Q?5ClSmskMKMEFw0c03wndvl5CGBReixjFix6C+wH/MuYkuBIHDwjyPzHYbruq?=
 =?us-ascii?Q?GNhvuWBAOZ8G69nMZY4+fAbAkaY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc4370be-db01-4d48-f9f9-08d9e4e066f8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 17:37:50.4004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2bOBwjfpD4kl1EEtKD2MK2S3Est9u6g0LjGTKUqFRuW2sD+S3WOP7sUYrG5d4z9rs+uzfF+KyDeyJQ46IEyByNhWt/pG8cMJQfXs19uHDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2342
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10244 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=884 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201310114
X-Proofpoint-ORIG-GUID: e_XbMIbqQzIMIMamFPKz0GiBWsq_Buxb
X-Proofpoint-GUID: e_XbMIbqQzIMIMamFPKz0GiBWsq_Buxb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 12:47:16PM +0800, Duoming Zhou wrote:
> If we dereference ax25_dev after we call kfree(ax25_dev) in
> ax25_dev_device_down(), it will lead to concurrency UAF bugs.
> There are eight syscall functions suffer from UAF bugs, include
> ax25_bind(), ax25_release(), ax25_connect(), ax25_ioctl(),
> ax25_getname(), ax25_sendmsg(), ax25_getsockopt() and
> ax25_info_show().
> 
> One of the concurrency UAF can be shown as below:
> 
>   (USE)                       |    (FREE)
>                               |  ax25_device_event
>                               |    ax25_dev_device_down
> ax25_bind                     |    ...
>   ...                         |      kfree(ax25_dev)
>   ax25_fillin_cb()            |    ...
>     ax25_fillin_cb_from_dev() |
>   ...                         |
> 
> The root cause of UAF bugs is that kfree(ax25_dev) in
> ax25_dev_device_down() is not protected by any locks.
> When ax25_dev, which there are still pointers point to,
> is released, the concurrency UAF bug will happen.
> 
> This patch introduces refcount into ax25_dev in order to
> guarantee that there are no pointers point to it when ax25_dev
> is released.
> 
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>

I pointed out a few bugs in my previous email.  I've had more time to
look at it now.

Basically you just want to audit all the calls sites which call
ax25_dev_ax25dev() and make sure all the error paths decrement.  Most
of them are buggy.  I'm testing a new Smatch check which is supposed to
detect these sorts of bugs.

I think the refcount in ax25_bind() needs a matching decrement.  Where
is that?  I don't know networking well enough to know the answer to
this...

> @@ -112,20 +115,22 @@ void ax25_dev_device_down(struct net_device *dev)
>  
>  	if ((s = ax25_dev_list) == ax25_dev) {
>  		ax25_dev_list = s->next;
> +		ax25_dev_put(ax25_dev);

It would be more readable to do ax25_dev_put(ax25_dev_list).  It's weird
to put ax25_dev here and then a couple lines later

>  		spin_unlock_bh(&ax25_dev_lock);
>  		dev->ax25_ptr = NULL;
>  		dev_put_track(dev, &ax25_dev->dev_tracker);
> -		kfree(ax25_dev);
> +		ax25_dev_put(ax25_dev);

Here

>  		return;
>  	}
>  
>  	while (s != NULL && s->next != NULL) {
>  		if (s->next == ax25_dev) {
>  			s->next = ax25_dev->next;
> +			ax25_dev_put(ax25_dev);

Same.

>  			spin_unlock_bh(&ax25_dev_lock);
>  			dev->ax25_ptr = NULL;
>  			dev_put_track(dev, &ax25_dev->dev_tracker);
> -			kfree(ax25_dev);
> +			ax25_dev_put(ax25_dev);
>  			return;
>  		}
>  

regards,
dan carpenter
