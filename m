Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2382731E1A8
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 22:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhBQVxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 16:53:16 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:52290 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhBQVwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 16:52:10 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HLfkDP064712;
        Wed, 17 Feb 2021 21:51:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=5N9UTTp9oQ7X6kRilU7MX4X0P9X1FhRUm1SdYj1lMgs=;
 b=VJd1CNQ+KvHzToC+Fvy+9ighklQHSKf8PWc2zTRmS866jpqAWCXRKteOqnddG50wZ1T8
 y7bPvOoZ+O1lk5d5hFbdNYmimzOOcrCWAHwFAiPk3X3jEzr9txHZBRH62HCjjP9plUkV
 i7MFsmEAQ/4aHpsVbnVS5Vn3ZBfX7ysUZf+qfUNkbS8ujx0GIdUdr605D9pIQm5ySX+7
 QMaMPjODeCYMpxsxrrruQWrtTlutthfeyKpx/Twra6Mk0MiaNGKgFBCCBpVJ2tlFo4tq
 LU0j6e5X3iY3veHoW+2AIdEeQw1FK9+H6onE2gvp/gg8yQnle5TNZNQAMF3jIPGHtvkF Cg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36p7dnkvp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 21:51:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HLe8XQ025997;
        Wed, 17 Feb 2021 21:51:20 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3030.oracle.com with ESMTP id 36prpynxr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 21:51:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E3PXZYhXh4IzqgEC+o3dKMPBi/giL390o2/PfvEjl3LoO5J4wpYZxSWT9zkgOEe2p+tAVSyUlkFU/QpglSKw/RICp42uLREAlDJ6AaKrYW9cbox3Vl6kGEACWK4Hc00orZcUD3zdGKPdIc8hxw6uj/M855BNt4yfrA+g60kY6yOFrcNsCPaOFJ1639eMKN8ua604i3RepWdGmptUpmLKwcNug/yM1lfzKewrmQypVZnj0R1miykkQQOQUIQLPn843dSzRrteN+td4sz28dFNgA0f6QIOwdvsBGU+RW+CiZWxhQW583xDH/kEktxFMR50R3O1XJ5wa9d3stc5CsULgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5N9UTTp9oQ7X6kRilU7MX4X0P9X1FhRUm1SdYj1lMgs=;
 b=QWmz7Gf1ZevldszHUpBVnFsfvoXBCJ/WUfE3Fb8+ihmp9fNWU4leKYoxBJ5iFKUTFfKAZeylnAlrExf6lSYTnqQwCoOwMA0znreG3rKdFPQGeAhyu/gSRv8njatuS8j0jl1HMHx8LXZZ9LSEdXRrhjqRjoV4knKdrJJS5NGVhiN/Ygpzcm8vAC2wMn623CoNsk7bWASgy3Kp/D13/3BZPyfai05xntMcvJXCTGPwacVrKVoET/eg+nS/NPbxmztsNtRhQbJ/dA30KOhKpGkN46Qq7Zd5ZMDOnaUVQY6PArgbhNk/gHsizPwNIQLaQnwx45hWgXPOxlJFLvlKfsdpZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5N9UTTp9oQ7X6kRilU7MX4X0P9X1FhRUm1SdYj1lMgs=;
 b=gdRWJV1f53lASj0rTYTFTEehLXA3lpPTVXBB/U/VL2v9xHoototcjj86IWdWsQJe8MrmSOznCT36Fov1d1efSjtOpIdOdHh6aes/nSTMu2EQxQ5gAdQGjXInmbn0ISzM8KYAvo3IzmayVg5rSitg8o2J0nHTkaSlAiNwfwwaQyk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BYAPR10MB3622.namprd10.prod.outlook.com (2603:10b6:a03:120::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Wed, 17 Feb
 2021 21:51:16 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3846.042; Wed, 17 Feb 2021
 21:51:16 +0000
Subject: Re: [PATCH 1/2] vdpa/mlx5: Fix suspend/resume index restoration
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20210216162001.83541-1-elic@nvidia.com>
 <4ecc1c7f-4f5a-68be-6734-e18dfeb91437@oracle.com>
 <20210217161858-mutt-send-email-mst@kernel.org>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <dd64c0f1-ede1-5ab5-a34c-af1efea4b53d@oracle.com>
Date:   Wed, 17 Feb 2021 13:51:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210217161858-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [73.189.186.83]
X-ClientProxiedBy: BYAPR01CA0011.prod.exchangelabs.com (2603:10b6:a02:80::24)
 To BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (73.189.186.83) by BYAPR01CA0011.prod.exchangelabs.com (2603:10b6:a02:80::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 21:51:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4ec06bb-0b5d-48ba-b3a0-08d8d38e26b8
X-MS-TrafficTypeDiagnostic: BYAPR10MB3622:
X-Microsoft-Antispam-PRVS: <BYAPR10MB362250FC1FFCD7320A2878E2B1869@BYAPR10MB3622.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bkIrgzYTpVkwilJx3x1zYPM0HuVANuv4sp28Y/Z4dCyiVzjdhpCBZL+PKrHtY80KfU4AyF78UJ65sonVEXABFO9H3jTvlIl9yTQRzTCpgOpTXeyb9APChqYp64qemPpmpIw8fwkfuawUBzWCeiGF68vQ2hta60bsNBSskUNXNJt5C3DcLcTQcLADtuNLpwmisWV3D829hvMec2Rs3yJf6toxIlL0g+QAqxenVh/sQj6BnWsxIOcrFX2hvxeVdsuzYhNQbL/6ImgUIlzNL5CrxmU3TvfVbU3hm0+npuSuo7w1xJ6c4vRGLGZgGAPCXtj8Kd/Mdd7Q/DNXFQ7IDsoCwLO3tfzYtL/5nExrs/zuQrLcn5YxM7wYnCfVaft8LSk8Oo41DDIYbwBxX/798gfvXCS/jGzL8Xo8fFeMBtPTQSjQyFCea9obx3erqpt5GI5qlLguvecCzWtYACtKQgtB+oOFd3V+baZKsqQcJggCq1yMKcOpSTjP247ejKPCU8bciIkS8W10CdyZpz8MIbHVT+VB750BTn5MZ6UAh2dzPATr+LwXDBt1KVt+zmhucvxgMDjFjxCluqgVmyOhTOvZwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(396003)(346002)(53546011)(16526019)(66476007)(5660300002)(316002)(4326008)(6486002)(186003)(66946007)(6666004)(66556008)(6916009)(86362001)(16576012)(31686004)(478600001)(15650500001)(956004)(2616005)(36916002)(36756003)(8676002)(83380400001)(2906002)(8936002)(31696002)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q0xXNlBITXpWc3pDNXJBZnQ3UXNNVGZQeWduNmVMcHpVKzl0aXNGbk1ZaUNF?=
 =?utf-8?B?N0dKbGtxTExESlFBZk5NcDVZTzlMKzBHUkg3RVI3dno0VXpvQzJpSE9GUGcy?=
 =?utf-8?B?SmNrNHNJRGIvMGM2TGRXTHYvMWZpNmJCUEo2SVllM050RTZNd0R4SndXZjZs?=
 =?utf-8?B?K1dnQUUxSVJRT0FNTWdZZ0JhMUhmRUFoTGtUa2tBV1VLOGYvUnZiTTFjZ3Bv?=
 =?utf-8?B?OUptd2wxc2p6ZXpsV21oNXZyY2pCOWkxUmQ1RGNWNjdTTS9xYlBkckw2T3pW?=
 =?utf-8?B?OGhMVThrTDZwWXVMWGlaUy9KU29qVjhVMFMrNUVSRDJadE4wQWhqWll2aTc4?=
 =?utf-8?B?VnZYYzdxSmtHeXVvNUUxbiszWURUSUtndkJxTGpLWWN1K0JaeFdnR01vZElU?=
 =?utf-8?B?U3hUeTdRUEhzVmVjMWNDRkZqMk1waFVXMFJ2dW5tV1A5ZFo4V3k1VVdSdDlI?=
 =?utf-8?B?ZHA0eExCdmVwL2RpZUMzcXVNUzFzRGNvdWZscWhnakhTY1RNNmF4UzNTSy9l?=
 =?utf-8?B?Y0cvU2dIUGZMQkRIZmFmVDZaUmoyN0l5SjlORjZyM3JjNlp6dHhjd3l1MVlv?=
 =?utf-8?B?bWJzdlVaRlpTRjdSaXZwZWVVdWtKSkFiU0puYTNhQndLbTFZL3dCS2FrK3By?=
 =?utf-8?B?d01xYmhBRWJiRzM3UzdBdUJDSDFpY214T1VIK3JYM3k5N1JhWEpHZ2tqK2JV?=
 =?utf-8?B?amVNa0NLeUIvOXpoRGh4NGJGWFpTTTJacXl0N3dsZldEZ0JEWVdralpLM0Z1?=
 =?utf-8?B?N1VZaGF0d24wc001aW1xZlpUMmZmWGpsWVZCUEt2Vlova291dGZqb1FxZzFX?=
 =?utf-8?B?VUxBeTNEWFRPbHY5bndZQjFxbGt4Y0ovVVg1dGc2blFjanNTaCtUT1REZzNJ?=
 =?utf-8?B?dm9QbG5halE1TlBjZCtEVUN0aHVJR1lNKzdPZTUzeGJNeGhyWit4MHlIZFpV?=
 =?utf-8?B?VFozUkpYRUNSOFdGUlhkdmloTWFPNzUrV1p1bFc3cWRmT3piSml6dzQzbVhQ?=
 =?utf-8?B?RUY3bnlKTld3TTZwKzluZko3NFR3Z2tVTlRRK1E1WmU5cUZteGk0Nlp5YlN5?=
 =?utf-8?B?L0tzbTg3WGJxeERwV1pudzVDWk5ZOEU4RWZ2Y01reWhUYXpzb284RVZRMjJ3?=
 =?utf-8?B?UjIwdzlJVGtQV2VSeVhrWEEwZ1ZIazUvWGZ2RW1yemFXeS9KUmJCMlNscEVU?=
 =?utf-8?B?cmZDNHJXa2R3cjJ3SjZ0MEs5ZzFrWEhvNkNlRGZuL3JKcERscDBBNWxjOEI0?=
 =?utf-8?B?ZkFtWkdjakw5RzVVNzFEb0N1WENrZklxZFJ6M3IydHcwTVU2cTNRRUdnUFNW?=
 =?utf-8?B?eDhTZ3h0eGdqVnBZSzdhd1JlcXVMb0JnNWlRKzgwckhoNWoxL1lHRUkwSnBu?=
 =?utf-8?B?ekxPMERneXZCaG1TZUdOMkFDaHF6L1pUU3ZHVUF4TWRuMGVVRGpmSkpWSHdD?=
 =?utf-8?B?SVlCcEJEYjBTWVpvVmVCTXY4WWhvMzdSQWtBZW91THRIR3hvQXhGZDFsZ2Z0?=
 =?utf-8?B?aFRhTVQ5UzRqeExyb29XQms4KzNhd2piZEd6QVRzOFIwZm1xbUJ2YjNmNG53?=
 =?utf-8?B?bEZIa240Vy9UYVVGTHF1citSeWVqUkx1MUZvcFIvaTJ6ejdBYWMrU3ZDTEpP?=
 =?utf-8?B?R2VzWXptNGhEY3RLcHN6cHBGSkt4Ukh6U1hZWUpCbERYcFFzZmVPSlhFZkhH?=
 =?utf-8?B?ejZEYUJrSnYxWXMvVGZQNUtZZ0hlM3pNbmpRSlBTeFROSlFkalhLd3dJN1d0?=
 =?utf-8?Q?EOaE5snThbxlLsRMgW145yjOmXYV31z9h60gGle?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ec06bb-0b5d-48ba-b3a0-08d8d38e26b8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 21:51:16.3419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tcVHmKhSC8KU1geXwtXiCp8iOmVZxet8BUEP+q9liq3XiJSprmqzs6qk7qkPreTTXw+s9mxy4NOc4UsgJNMipg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3622
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170161
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102170161
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/17/2021 1:20 PM, Michael S. Tsirkin wrote:
> On Wed, Feb 17, 2021 at 11:42:48AM -0800, Si-Wei Liu wrote:
>>
>> On 2/16/2021 8:20 AM, Eli Cohen wrote:
>>> When we suspend the VM, the VDPA interface will be reset. When the VM is
>>> resumed again, clear_virtqueues() will clear the available and used
>>> indices resulting in hardware virqtqueue objects becoming out of sync.
>>> We can avoid this function alltogether since qemu will clear them if
>>> required, e.g. when the VM went through a reboot.
>>>
>>> Moreover, since the hw available and used indices should always be
>>> identical on query and should be restored to the same value same value
>>> for virtqueues that complete in order, we set the single value provided
>>> by set_vq_state(). In get_vq_state() we return the value of hardware
>>> used index.
>>>
>>> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
>>> Signed-off-by: Eli Cohen <elic@nvidia.com>
>> Acked-by: Si-Wei Liu <si-wei.liu@oracle.com>
>
> Seems to also fix b35ccebe3ef76168aa2edaa35809c0232cb3578e, right?
I think so. It should have both "Fixes" tags.

-Siwei
>
>>> ---
>>>    drivers/vdpa/mlx5/net/mlx5_vnet.c | 17 ++++-------------
>>>    1 file changed, 4 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> index b8e9d525d66c..a51b0f86afe2 100644
>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> @@ -1169,6 +1169,7 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
>>>    		return;
>>>    	}
>>>    	mvq->avail_idx = attr.available_index;
>>> +	mvq->used_idx = attr.used_index;
>>>    }
>>>    static void suspend_vqs(struct mlx5_vdpa_net *ndev)
>>> @@ -1426,6 +1427,7 @@ static int mlx5_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
>>>    		return -EINVAL;
>>>    	}
>>> +	mvq->used_idx = state->avail_index;
>>>    	mvq->avail_idx = state->avail_index;
>>>    	return 0;
>>>    }
>>> @@ -1443,7 +1445,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
>>>    	 * that cares about emulating the index after vq is stopped.
>>>    	 */
>>>    	if (!mvq->initialized) {
>>> -		state->avail_index = mvq->avail_idx;
>>> +		state->avail_index = mvq->used_idx;
>>>    		return 0;
>>>    	}
>>> @@ -1452,7 +1454,7 @@ static int mlx5_vdpa_get_vq_state(struct vdpa_device *vdev, u16 idx, struct vdpa
>>>    		mlx5_vdpa_warn(mvdev, "failed to query virtqueue\n");
>>>    		return err;
>>>    	}
>>> -	state->avail_index = attr.available_index;
>>> +	state->avail_index = attr.used_index;
>>>    	return 0;
>>>    }
>>> @@ -1532,16 +1534,6 @@ static void teardown_virtqueues(struct mlx5_vdpa_net *ndev)
>>>    	}
>>>    }
>>> -static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
>>> -{
>>> -	int i;
>>> -
>>> -	for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
>>> -		ndev->vqs[i].avail_idx = 0;
>>> -		ndev->vqs[i].used_idx = 0;
>>> -	}
>>> -}
>>> -
>>>    /* TODO: cross-endian support */
>>>    static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev *mvdev)
>>>    {
>>> @@ -1777,7 +1769,6 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>>>    	if (!status) {
>>>    		mlx5_vdpa_info(mvdev, "performing device reset\n");
>>>    		teardown_driver(ndev);
>>> -		clear_virtqueues(ndev);
>>>    		mlx5_vdpa_destroy_mr(&ndev->mvdev);
>>>    		ndev->mvdev.status = 0;
>>>    		++mvdev->generation;

