Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A8931DFC8
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 20:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbhBQTno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 14:43:44 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:57002 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbhBQTnl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 14:43:41 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HJcLvX144341;
        Wed, 17 Feb 2021 19:42:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=n3t+r44VWzFgulsY8MTpUR7Yv7TMyjpzg0x8c3r2cow=;
 b=mP92p7J/zSUZDt8ESonIOruYc3FqRzjmirRj/+ivdnnhX0zxfGjOK8Faitt3vUiGYhCS
 HGXrMksHDKI6XGMTUQjGZ2cgDngP8BQ9EsDdMUaxLuR6DyVCZ7y7WST/uRE5o3+5cNev
 f8yIbDg8GvNMMrAQIhoa1Y18IsPJd17tiOD796A5HDj0AX+ej7PYSa7/nmL8pSnunUhz
 cTfBk+IA1XOGJFTLbFamUBOtv464k1rKcpsiDyWKZ+1NqzGykoxDJvBh6YgrfC2m6LYW
 l2ltG3rECUXggIZPBzeajU7ZziTqBH6FMngdwmS23/gtvq6cgMJvs9agafY3H0IpxRMc mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36p49bbtb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 19:42:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HJfdC9115215;
        Wed, 17 Feb 2021 19:42:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3020.oracle.com with ESMTP id 36prht9rxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 19:42:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIKi7ugSe9aiw79C+JthQu5tfrkmv9TXzWh6hV/Qy1BEIVfAqOmAk+Y5eUYHG9bB6u71CV8lQ0diuBFcGKrqSFOuCcI4rViv8SUbsZ5YXIU+t8wuZCPJdjHUEiCfKWDL7aYXoTutzh5uxzndnJn2rXX370Hk5qT/WMy+J7/iXrslm81/oGtUcQVQRineVsGmNvjN9u3/J3C32ZQmyMgbJEldM14tmhiKinIA0cykd8jE5mtb1Jun4LQedDQc5Wdyz4Btau2ffde4ppvkKpEykAIWHtcjkLvCgtVbLJJTkk//axzuwRad0n8D6O/3u81oep0WKu25PN/bTwTuWsqvQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3t+r44VWzFgulsY8MTpUR7Yv7TMyjpzg0x8c3r2cow=;
 b=dDGPATCIr2SrMX6j1RyIhJ5p/9eAuvgyYecpbtfPzE4j4NVmbmQhAA7bbiVRpca+fvLj7FljCIju0PnE6Qqy/PhBbibmwDLwNBCcTyo5U4ByjT6DVPPYaNxHwE2ctuSK/8TlV0CGKD3oqDojXnZafkbzmydCxWlifGlA9B8yfa1w46iv67WcbwxetdN0IBrgnimLv7Sovxh/Prvx+Ff4sn6WA0YMEy09h/SA2DsjPZR6NNjw2m/m8so2repO4/xBt6BpRts7+gyxLOj8rYepnbTMeIRbapAg8GfsazgrJ+J5aGk1DHgyqPz3ZeK31V1X+RagTVjUzILa3ROeCnQr9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3t+r44VWzFgulsY8MTpUR7Yv7TMyjpzg0x8c3r2cow=;
 b=SxXADpk6mV+4PO3+ljNfBixlJUy9QHQaJGWQNcP/ah7wEISAmEv/cK/3nMg45vgRtxe+PeHner7mhheav3uWxSdDcFzVA31W2D/Z01qELhK6pEuG1/n5LR447FJPjTRGcQsTNE2SH+V9BNwmAJZxXlBegq+V2fRuSdxDumeNxgU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SJ0PR10MB4431.namprd10.prod.outlook.com (2603:10b6:a03:2dc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 17 Feb
 2021 19:42:51 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 19:42:51 +0000
Subject: Re: [PATCH 1/2] vdpa/mlx5: Fix suspend/resume index restoration
To:     Eli Cohen <elic@nvidia.com>, mst@redhat.com, jasowang@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20210216162001.83541-1-elic@nvidia.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <4ecc1c7f-4f5a-68be-6734-e18dfeb91437@oracle.com>
Date:   Wed, 17 Feb 2021 11:42:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210216162001.83541-1-elic@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [73.189.186.83]
X-ClientProxiedBy: SJ0PR03CA0267.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::32) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (73.189.186.83) by SJ0PR03CA0267.namprd03.prod.outlook.com (2603:10b6:a03:3a0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 19:42:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa81896f-1c7f-457b-c365-08d8d37c35d5
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4431:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44315B94176899D41FD51837B1869@SJ0PR10MB4431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4iqYBcBOpTWun5U5AFNECQVFn4UeeWmkb4017bMLZ9TA9JJENy7VoSonDH8babFsl963N7s3w/89dbuYV9RPLCEanznG3g4W0tYABz85nz1PZu9PCiIUhU92PsmPWV87unyM9d/IMjHd0JJ0E5ajlMtnQDjt/9bVEevhrjMUlqVClL1PyH8B5fN7J+tmHx8bv0PWhGk17NcmXezkTJ0gDBHgwYv1PjuOBMIoYMlIPebHoXCR4vYZOO9UmU3gLUrjGKxd4RCu9a1DUCW911mfUHX1XHdavUrUdfJgJsjhSKGeyRRMsAKUNKe1lwhSkNkk6f4jHdkjzxyqRxoEuB7sh4e4d0ZMdUCjdIhBgu/+GmmIrBgf9pA6Yio6Iwfp/gvEsWGGjsly+BtiM1XLw1qyf6jGpcLmh0KFK1C2kf1Su4wlMHdpGrFY99Ydb7vOpPRr6Vmw/D/RoKW5+X4sHUag+iM0RZnOMWQxMPey5oP77VoiJkJQAKuQe4t8RNFTxHsWH9ivdlgX2NOUxkaiAYR4uFbjsfoNcVLIYPH8GXJUfiFq3snAHSct5gYzeljzPfORkzfbp1j08SqysamUJi9A9f5HcntLGb0cMNhLa1+F83Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(39860400002)(396003)(136003)(66946007)(31686004)(66556008)(15650500001)(66476007)(478600001)(83380400001)(5660300002)(16576012)(31696002)(86362001)(36756003)(8676002)(8936002)(956004)(2616005)(316002)(6486002)(2906002)(16526019)(186003)(36916002)(26005)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eGtSN2k4N2F6VFM3K1B6eGFpdnlEUm80NldBeU5OTU0zQUN4VTZ6U0VraW1X?=
 =?utf-8?B?azlGbnhBd0ltajRnc3ZCU2F2bHhtc3c3K25TNVluSzM0NU1RSUVIVjNyWk5K?=
 =?utf-8?B?MnVZVzBDTk1sVHBoU0REOEhTYUpCckNuVkxaelQzZUlIUmJTclpRbzZCU09m?=
 =?utf-8?B?djI0REcwcGFTSDNzYm5Obi81VDBVY29EeTkzdXFXckp0VkNacmVldkhIalUw?=
 =?utf-8?B?dU5YWU9HVmp3b3o1MlhXN1QzNGxQRU1VOWtDUUFZVkFzZU9UN3owb1NKMGUx?=
 =?utf-8?B?R1AzKzNUdWo4WDQ1TnFYZ0N5SldKYVdBd1lqbEpuU280Z3JucFNUbG9lNHVj?=
 =?utf-8?B?WXh2OUROZGlRUklhM3ZSOU5mOW5aMXVoamhuYzBFbUNFQU56OWR3ZnkrdzFz?=
 =?utf-8?B?cVhNMC9pSW5Sc3c3cWl1ak1UaU1QOS9KYm5janVJalhpTVd6eXlwM2htTFpm?=
 =?utf-8?B?cnRDbWJpYWc4ZjZpWDhNVnh2UW5VY2p6VTEvWms5eTNJVkJFd2VBazQrckoy?=
 =?utf-8?B?ay8rVHd3bHRsNU9sRGlQVUFMMVZUNUFDWUNGaE1SUE1DcE94Q2lrbmNhTEFE?=
 =?utf-8?B?b2Iyb3VIelVzN2traEhQREM3QjRST3VSL2NjSk9aOEJoRm04N3h1OWkrUU0y?=
 =?utf-8?B?SmVqMHVic3I0S0NwS3Yza1IrYzRJbGZVOEZQdjJlQStjNVA3ZVhUY2VDclFZ?=
 =?utf-8?B?V0gvY2xQbFJadUwrZ2lzNytaWi9ZT2VxZjJhTnhmcUt0VnRWbWZUT0kwaElo?=
 =?utf-8?B?SlBCQ3d2R1RXVHVhQyttMXF1akl2TWVvblVUTXdMVEYyeXdHdlg1VGhVc3I4?=
 =?utf-8?B?OE1yaTgzNXpBWWRNV0xmS3dYdmpqTVVCU3lTb1gzcVUrUjBPMldKQzB6R2d3?=
 =?utf-8?B?K09OUDdCWDFLa0E0aENxOVlJeHNyKzFZNVJjU09OQ0JoTWtlNllwRVdGeTl3?=
 =?utf-8?B?dDVvbjBlUE54Y3Z3YldaUUZmRG5yMWpnNStpVzZQMlpjdzRBWjlXTlBZd05z?=
 =?utf-8?B?ZkI1VlNDQzIzc0tkKzdzdGtyZUVib0tSdExta0I1L3JMeGM1WUduY3lSK0lz?=
 =?utf-8?B?aDdBSC8yRGNwYW5mZ0gyZ2llZVZVcWpvWHZ2aGFaZlpDMkROQ2IyQXNaUDUw?=
 =?utf-8?B?dTZUSjdsSzd0bmRiMUU5OFMzcUxXZjlmS3QxaUo4bU9rM25xNE9FYWxIbHpC?=
 =?utf-8?B?NDRZNk5SbEpmM2xGUHpBRFJ6S0VUSkh6OFVrbmZ4SUNSRFQ3TUZZanAveGV3?=
 =?utf-8?B?cXE3THhBNitUYjBOdXA3UkxHbjRYd0VlaXBOa2lwdDBVUC8rSXRSTncxTkw3?=
 =?utf-8?B?d1VNekVaRmpySFgrYm9qYlUwT3NJR3RrZWlqMjRoTktxN245dGJ0RmJlUzlI?=
 =?utf-8?B?ZlRERVozT04vZkh5YWpxcXFsMHNHalF4aEQxdk5EcW1yd210MzZTeiszeGFQ?=
 =?utf-8?B?Y3FTOTIwVFdlRStneitHeWJlZDRYR09YY1VQaUYyT3dNT3dueXBIL0RQT2xv?=
 =?utf-8?B?alZYdm1LUzduaGh6aUFLYzNuOG9QcmR6NzN1TytWSUhxZUVuQmpYbnJ5ZzRV?=
 =?utf-8?B?RHZoUDNkRjdCL0VSanhuRTZIL3VLVy8vUFpvcHphL3A1bXd2cG1zWFRjQndV?=
 =?utf-8?B?UE9jMkFsYlU2OVNDcVR1VzJVeE92UGVBSFc1aTJqY0Y3eTAyVythbVBma1d3?=
 =?utf-8?B?SVdOQ281T2FiNWs2S1R6Q05wSmlwQ2NvcTFGSmdMcFhzY1I0YWlzMGt0emF3?=
 =?utf-8?Q?gN0y3aVikn8p9qDAEjcU5e0K7H46zvjMB+Rgbsv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa81896f-1c7f-457b-c365-08d8d37c35d5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 19:42:50.8610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5VJMAdub13jwuwEEaI52fiaCcIFinzFmJDTd6P3J54CDIeTjOdi5ohzgzlj/8EMb+k6pe98PQ/VpNKCe5wYciA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170144
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/2021 8:20 AM, Eli Cohen wrote:
> When we suspend the VM, the VDPA interface will be reset. When the VM is
> resumed again, clear_virtqueues() will clear the available and used
> indices resulting in hardware virqtqueue objects becoming out of sync.
> We can avoid this function alltogether since qemu will clear them if
> required, e.g. when the VM went through a reboot.
>
> Moreover, since the hw available and used indices should always be
> identical on query and should be restored to the same value same value
> for virtqueues that complete in order, we set the single value provided
> by set_vq_state(). In get_vq_state() we return the value of hardware
> used index.
>
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
Acked-by: Si-Wei Liu <si-wei.liu@oracle.com>

> ---
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 17 ++++-------------
>   1 file changed, 4 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index b8e9d525d66c..a51b0f86afe2 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1169,6 +1169,7 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
>   		return;
>   	}
>   	mvq->avail_idx = attr.available_index;
> +	mvq->used_idx = attr.used_index;
>   }
>   
>   static void suspend_vqs(struct mlx5_vdpa_net *ndev)
> @@ -1426,6 +1427,7 @@ static int mlx5_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
>   		return -EINVAL;
>   	}
>   
> +	mvq->used_idx = state->avail_index;
>   	mvq->avail_idx = state->avail_index;
>   	return 0;
>   }
> @@ -1443,7 +1445,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
>   	 * that cares about emulating the index after vq is stopped.
>   	 */
>   	if (!mvq->initialized) {
> -		state->avail_index = mvq->avail_idx;
> +		state->avail_index = mvq->used_idx;
>   		return 0;
>   	}
>   
> @@ -1452,7 +1454,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
>   		mlx5_vdpa_warn(mvdev, "failed to query virtqueue\n");
>   		return err;
>   	}
> -	state->avail_index = attr.available_index;
> +	state->avail_index = attr.used_index;
>   	return 0;
>   }
>   
> @@ -1532,16 +1534,6 @@ static void teardown_virtqueues(struct mlx5_vdpa_net *ndev)
>   	}
>   }
>   
> -static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
> -{
> -	int i;
> -
> -	for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
> -		ndev->vqs[i].avail_idx = 0;
> -		ndev->vqs[i].used_idx = 0;
> -	}
> -}
> -
>   /* TODO: cross-endian support */
>   static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
>   {
> @@ -1777,7 +1769,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>   	if (!status) {
>   		mlx5_vdpa_info(mvdev, "performing device reset\n");
>   		teardown_driver(ndev);
> -		clear_virtqueues(ndev);
>   		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>   		ndev->mvdev.status = 0;
>   		++mvdev->generation;

