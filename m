Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB643119F5
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhBFDY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:24:56 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42368 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbhBFDP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 22:15:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 115Msml7028781;
        Fri, 5 Feb 2021 23:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZuUklnVrtmrlChSaOiMgA2ETT14qRZOJ1yxuHLjuf1k=;
 b=GL9o/6GLeU6sMjgM2HV+eer9vTH27ohDaaSRuQOkmqlL5bHbDlBWQ0o6kUTUzXYfkeH9
 FEqMw8gleqiPbt63lFs3EgaW/J87z3qNjgEwVwNYPe1bk++ngv+qXf8NnQgqUr53gPVz
 w4KW0cmDirJN6Fnnt1vk/MBPTD/OzL/lHQKaDZM55nR2SeuttPiqTBdEcQuzIycos0p8
 pGM0QLR08sFYgyMBdpRTcY1VgCQ4QPrV2AAGnHNikBDfXtPlO2Rcc0rRol6rhcLVFAP0
 ++5oRlYcLj3t7ccTe74lq6ADJ/u2RaRL7qqk7VkBcKxjGkmhaz3whHXsvIVCBNUF3fRx tQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36cxvre51y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 23:07:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 115MtA4Q028242;
        Fri, 5 Feb 2021 23:07:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3020.oracle.com with ESMTP id 36dhc4tf0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 23:07:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+yzDyX3DzK6J3PsX6IKDwd7mcN33qOZmzrWtAiyc8nXs2ksqOQgGHaNlNZzhqAB+szc9FdE2t25IHqwlF3McdexV5iOOYCUK3AHlTk2uhShjXjO26ij9CokBkMlGOhtogI2RGCAEva5jG1xhBKKRNMHzyl5YyaiYy/VoZ/GzRj7ymImBkmxNuHOKDOXTwEkq0S0+U3LzjipaPBdvqyEm6Fb96JagA+PHw6wf39RgmIuh3v19dkiL+Ai06xiohT+w09XQ2smibmna1wAh0L0sl6KTllfiJ3qgWvDxiALsi5QqawWPZk4eX39H8bcBEQa1JtAbMGbFYLXs5kuTbhxJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuUklnVrtmrlChSaOiMgA2ETT14qRZOJ1yxuHLjuf1k=;
 b=gr2sH+bPeeds5j0W7VTGsu7Mrsf22D/F4uGWMYi6Ga0hsEiSRTKdeE27+V6IMRQJmEMwAFSjq2kTKKcRfxmWET7TRMxlOe3QD5UL+U4QQk3rmt6qoWLF5VuZvkmozxmtu2Sw7EPJOy6czflCaopoxDyLAscld/D7j1CvwcGLBSacykmjIuiF8GsGgbZRYSlxbiG5J8v3uo+pOVsoRS40lUasG21GjaMtk7VvRC8WwHZ/hKFWYytenoGAhXQzChwosHZMIi3Dr/x7ggZZYrOtMHrh90wHPAi8yrUTgXKbUBpKQgfPfMiTCFR+Onl0z6GOP5TH+RaXDpfSp8sdY9S8lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuUklnVrtmrlChSaOiMgA2ETT14qRZOJ1yxuHLjuf1k=;
 b=Qz7ONe8Hwb+wNItjpP4ugGhTWCQj53jfivwxBCQTdYkWXESE753gQhvhKewIFqGOfEy3BAMhWY62ApARBW1Rispl5qcSrNS+ngYzCpMU0ZnQ+33Be02IoAn/TN6SCr9yCSb+Z0YFE7eSR9oJujU5x4JbTKSf8j0jTONIhqWIduw=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BYAPR10MB3429.namprd10.prod.outlook.com (2603:10b6:a03:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Fri, 5 Feb
 2021 23:07:20 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3825.024; Fri, 5 Feb 2021
 23:07:20 +0000
Subject: Re: [PATCH v1] vdpa/mlx5: Restore the hardware used index after
 change map
To:     Eli Cohen <elic@nvidia.com>, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     lulu@redhat.com
References: <20210204073618.36336-1-elic@nvidia.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <81f5ce4f-cdb0-26cd-0dce-7ada824b1b86@oracle.com>
Date:   Fri, 5 Feb 2021 15:07:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210204073618.36336-1-elic@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [73.189.186.83]
X-ClientProxiedBy: SJ0PR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:a03:331::20) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (73.189.186.83) by SJ0PR03CA0075.namprd03.prod.outlook.com (2603:10b6:a03:331::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 23:07:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7259991d-e455-4d99-bf1c-08d8ca2aca5e
X-MS-TrafficTypeDiagnostic: BYAPR10MB3429:
X-Microsoft-Antispam-PRVS: <BYAPR10MB34294C38DA6256C3E0AAD3A7B1B29@BYAPR10MB3429.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eLnvwwuhJYif7Y3wXJUIkp2tvX+1GyQoXn/EH2hYJWHP7Z15KEE3lgUeUQX88fffmhIgOIheWWxtwNbLRP1IPdFyRsQwPpu0g1r/ZMu4482myA8WHD36GQLbPOSz3R77Wvmf8i44fgu0H1aIA9xWsi0wFiERCUbFz6Yp2hDwZI1Jy9dE15/rgrPww/EtJALI/GcCilKcM05RIMSzUBG+IBtypkjwwWIcW1Wym9UyLv/sUpn+VRe+FbN1/0dAZsumXQ4w9xh5OmF9YkLr8vrO1FkCQM5jrk+v8MmL/9JeHtG1R6LfzC7QO1W0rjbvmOyXvV+l3+5p8yg7Rt1hKz3Dsv9t/Fjepd46oUrYCFkn/og7R36O6x4G4Q0qda9iv7lnSP+Xx8IQofRiCR4+cVIx42g0L/8R21ewBqttGxa7cUhvYuWaLncUnOjV/423udtk8pEf60jMwYPm2wZfd3vpzQOGo7T3GHXaaXB81X4hESzIf0jr9X6hJTFnoSU6GOVh4zQNChPJwdG1nH4n0/klimlSVkV6PdKPHSL38gXF0GVzgMRdblzIJJS9vA7wMe69FM3CNITH+9tZE/lMGMtQtJ+GBSk70fr9Nn/Y/lxR3pA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(136003)(346002)(376002)(86362001)(478600001)(26005)(5660300002)(956004)(6666004)(53546011)(16526019)(6486002)(186003)(2616005)(66556008)(66476007)(66946007)(31686004)(83380400001)(316002)(4326008)(8936002)(16576012)(8676002)(2906002)(31696002)(36916002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b0w2Sm94ZGNUaGtQVDZ3QnBwTjVXajg5Z1B5ZlJBZDFmcHJyTHVCWGowUnl6?=
 =?utf-8?B?emR0WXkzV202YStISUJxQ2F4S0pjd2d2cy9BSW5HbkI2eE81ZS81VE5XK0xM?=
 =?utf-8?B?TTh0R1RWY0hTYzIvQlBHOFEycmRMMXZYWks3bWYyYzRoVXE0VklWd2hqdjlo?=
 =?utf-8?B?M1RGYnJNZWs3QkRpN2FPUWJ5OXovWXZrMHY1YkFlSFRhd1QvYkg3MDFCR25B?=
 =?utf-8?B?ajlhTzdyaXJRZWVnSUZ6VE80UkZPTERidmtLc3A2dkdlemIrQXpLY1YxaVB3?=
 =?utf-8?B?aEJXUFFsTXB6cTljMWdhNFd1d1BzYzBMRTRVU2xWTDUydDZHa3I0ZHYrbDNz?=
 =?utf-8?B?M3hlTWVIa2dkV0RFcC9pYVpLTTU1ZDd5ajdJaDNvNWZWVmhoNjlpeGorbWpo?=
 =?utf-8?B?aHhQNjZYVnF4RnJLcW90RXhpOEFNUG9KYjlxNWZaZWxiV25PMDQ4V2lKSTRa?=
 =?utf-8?B?dW1keHVQdUs0STRja293dCtjRlRuZXZDTHFTSDE2WEEva0dWYXpyMkJEZGR3?=
 =?utf-8?B?cG5YMGF5ZW9XY0ZpcXQyZlV4YTVIbHNMQTM3OXZGdUE2RWthamJyVU54YnBj?=
 =?utf-8?B?SUFFRjF2NDZZWGZXVGdZRit3N3k2aG1qcUh1eVo2bjR2NXFmZ3dreWFHYXcx?=
 =?utf-8?B?dHQveTZXNzhKUlBibzl2U3E4U1gwSUI2RVpSMHZLdk5Sc3lveXQ0SzJtZG0z?=
 =?utf-8?B?a3VWNW9Xa3dUQlpxcDdkRk1UZnUycjJlNkNhaWR3eFFWUGJ0aHF5aEZJakNv?=
 =?utf-8?B?Vy8yOEcxWjBrVXBuMnI4eWhoTStib2QvWi8rdjUyVmFnYXR3azNhMmtvQ1lo?=
 =?utf-8?B?KzliYlBhcjI2UjlRUXJDMm9sWnVGam5qWnF1T0svRFpIVmpFdGQrMHNjNmJL?=
 =?utf-8?B?UkZLbExzOWorbG5nRFZrN21ud1FGbXV6b01mYWlJbVJqK3BnVXl1N1haeXcv?=
 =?utf-8?B?MDdkNCtpMzJ3eGEwcjZJRlVYTUI3eldnWTI1L2Y1VG1xaXBaZThxaXdxcmxH?=
 =?utf-8?B?aTJkNXBrV1pEOVMyTmgwUVZHRmRHVDl5eFRQcmhMbCt4MGE5WG9teWlNRGYv?=
 =?utf-8?B?RTkrQXVNcDNmcFlHY2tWcEZOYTliRFMxeEE5djNFWTd1OXcyOHNCOTg5aUUw?=
 =?utf-8?B?bHdNZmpMSUs2VC8zSEpoWnkxa1g1SDFPZU8yU0RvZHB2YWZJQkluWWNETFo2?=
 =?utf-8?B?R1J0aS9TSjBZS0pUVUdFNkFFRTUwdGxRVmVZby9ZSkFmMnJiN09vcXBEOEs2?=
 =?utf-8?B?eXFHeklhSzA2RjRTVDltYkY3Q21jL1FtRWFucmpQVGhnTnpLbFNFOEo2clU0?=
 =?utf-8?B?K3NtVlR4ZWFXeEpraEtES2J2dTJacE1tUmFYM2RGMXhpS212KzZOQ1pyVnNQ?=
 =?utf-8?B?Zy94M3d1M0FZcHBXaXBQdUhSWXczbGlnMlZ2UzhaR3RPK25RVzdBVCs1ZThE?=
 =?utf-8?B?NGVDYlY4cUtIMERZamg4UnpEa0RUc2loNnIyZzQ3V1BIdHpQSHNWb3pZeUVk?=
 =?utf-8?B?bGRlcElwcHd5K240Z0xzQTNyUWxJSXBkNlR2MFI4Q25FTENDN3FpS0dWdWg5?=
 =?utf-8?B?N2NFdEVvVkxtQ2tRSzlYdFMvY1dFQWxodW1vWEl2UnVMTGJ1Y2FJbkZoMmY2?=
 =?utf-8?B?ZkUyZ2JwVU1LWE5kZTN2SUdOWVh5WTVJeFNnZk1ZdTZvaDhhcDFuK0NLN0NQ?=
 =?utf-8?B?RDM3UFdYWU40NytzMzRGRnhzaThXVlhJeWpCK0haOUhHSFAvVjUxcUhIRVNj?=
 =?utf-8?Q?g2jaRlfPiafEjN91RGlrWHdBHeE5TKxWV57c8SI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7259991d-e455-4d99-bf1c-08d8ca2aca5e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 23:07:20.7798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8VeIb/+QM6Ha4zm2U8g3PpJTZR1oDniZJzSqf//wyAw9aU7dWrDlAZpEs/qWECRnDccCRilWfAbolaRLRoad+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3429
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9886 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102050142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9886 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102050142
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/2021 11:36 PM, Eli Cohen wrote:
> When a change of memory map occurs, the hardware resources are destroyed
> and then re-created again with the new memory map. In such case, we need
> to restore the hardware available and used indices. The driver failed to
> restore the used index which is added here.
>
> Also, since the driver also fails to reset the available and used
> indices upon device reset, fix this here to avoid regression caused by
> the fact that used index may not be zero upon device reset.
>
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
> v0 -> v1:
> Clear indices upon device reset
>
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 88dde3455bfd..b5fe6d2ad22f 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
>   	u64 device_addr;
>   	u64 driver_addr;
>   	u16 avail_index;
> +	u16 used_index;
>   	bool ready;
>   	struct vdpa_callback cb;
>   	bool restore;
> @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
>   	u32 virtq_id;
>   	struct mlx5_vdpa_net *ndev;
>   	u16 avail_idx;
> +	u16 used_idx;
>   	int fw_state;
>   
>   	/* keep last in the struct */
> @@ -804,6 +806,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
>   
>   	obj_context = MLX5_ADDR_OF(create_virtio_net_q_in, in, obj_context);
>   	MLX5_SET(virtio_net_q_object, obj_context, hw_available_index, mvq->avail_idx);
> +	MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_idx);
>   	MLX5_SET(virtio_net_q_object, obj_context, queue_feature_bit_mask_12_3,
>   		 get_features_12_3(ndev->mvdev.actual_features));
>   	vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_context);
> @@ -1022,6 +1025,7 @@ static int connect_qps(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
>   struct mlx5_virtq_attr {
>   	u8 state;
>   	u16 available_index;
> +	u16 used_index;
>   };
>   
>   static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq,
> @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
>   	memset(attr, 0, sizeof(*attr));
>   	attr->state = MLX5_GET(virtio_net_q_object, obj_context, state);
>   	attr->available_index = MLX5_GET(virtio_net_q_object, obj_context, hw_available_index);
> +	attr->used_index = MLX5_GET(virtio_net_q_object, obj_context, hw_used_index);
>   	kfree(out);
>   	return 0;
>   
> @@ -1535,6 +1540,16 @@ static void teardown_virtqueues(struct mlx5_vdpa_net *ndev)
>   	}
>   }
>   
> +static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
> +{
> +	int i;
> +
> +	for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
> +		ndev->vqs[i].avail_idx = 0;
> +		ndev->vqs[i].used_idx = 0;
> +	}
> +}
> +
>   /* TODO: cross-endian support */
>   static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
>   {
> @@ -1610,6 +1625,7 @@ static int save_channel_info(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
>   		return err;
>   
>   	ri->avail_index = attr.available_index;
> +	ri->used_index = attr.used_index;
>   	ri->ready = mvq->ready;
>   	ri->num_ent = mvq->num_ent;
>   	ri->desc_addr = mvq->desc_addr;
> @@ -1654,6 +1670,7 @@ static void restore_channels_info(struct mlx5_vdpa_net *ndev)
>   			continue;
>   
>   		mvq->avail_idx = ri->avail_index;
> +		mvq->used_idx = ri->used_index;
>   		mvq->ready = ri->ready;
>   		mvq->num_ent = ri->num_ent;
>   		mvq->desc_addr = ri->desc_addr;
> @@ -1768,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>   	if (!status) {
>   		mlx5_vdpa_info(mvdev, "performing device reset\n");
>   		teardown_driver(ndev);
> +		clear_virtqueues(ndev);
The clearing looks fine at the first glance, as it aligns with the other 
state cleanups floating around at the same place. However, the thing is 
get_vq_state() is supposed to be called right after to get sync'ed with 
the latest internal avail_index from device while vq is stopped. The 
index was saved in the driver software at vq suspension, but before the 
virtq object is destroyed. We shouldn't clear the avail_index too early.

Possibly it can be postponed to where VIRTIO_CONFIG_S_DRIVER_OK gets set 
again, i.e. right before the setup_driver() in mlx5_vdpa_set_status()?

-Siwei

>   		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>   		ndev->mvdev.status = 0;
>   		ndev->mvdev.mlx_features = 0;

