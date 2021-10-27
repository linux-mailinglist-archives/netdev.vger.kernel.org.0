Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9E343CEC7
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhJ0Qg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:36:28 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20638 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233805AbhJ0Qg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 12:36:26 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RG5PmY023695;
        Wed, 27 Oct 2021 16:33:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ltoM15fa8DDV9i85o4BVM1M3tOQ0E/tfJeyHwWzq2RA=;
 b=d4LWppFKcSTYrF6QS2h/OAuSYK5qQjy6LvZ5NoTxeE6Swth33Sdk4nbUm7kZNDtBevNs
 v2smETvafLy5YLsZmHr3FNoqllumhzzTGHAaQ9kwvPXrGee3eQjt4fUHFW9LXmAuby53
 scOF6acY8HMNsZc91pNo6hoxr9UbbmqsPk/u6IlPu1ibCKWvhDQo1HPlHlm23OIodLtX
 9SySSwwHdtq0gJufERZElG8GRKCiw00/MlPFiubNI8dYnzXtd8k0Z2gkI2wpGjK3oW0L
 bBklmKU3c8G6JV1XqO3Hqk7zNFcmhWkD8seKH1c2qlSGn3k+Qfq/DxzKPDEKNERSwlOn aQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fj4un1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 16:33:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19RGVapS074517;
        Wed, 27 Oct 2021 16:33:50 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by aserp3020.oracle.com with ESMTP id 3bx4gcyst3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 16:33:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7rpBSm6cV3URvifMIqsaeHYQhjVwKW0RfWyvw5KUtjDva0+QXKBBVnJkfcm+AhjRlW/dEJf3PoqHlP6Ak8mrVmWWaRpYhd9IDkmCMxxE9jrpZ2qWCXf4zsPQGatcc2bBwHpRPxxWW93N7tdwmdTrbGm79avl3to79cCDr4soJGkVN8hGeT7Dg49c4hUVii1E+2UMQWEIp8rgJRPciRExjoBqdGUtvERJGjtPdySHfSCLGneVXNbLUMeVCoqSaUo89UrS2SaIVz4RIKWpIxEDaDtrymj4xU+pOyG6h9XG9mMth/Lg/mFbnt+5SqALsjip/kK+OpnEjH8MjI/1ptPzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ltoM15fa8DDV9i85o4BVM1M3tOQ0E/tfJeyHwWzq2RA=;
 b=K7EVab147S80Pc19/GGbsKPAt6/IXhWNikD7NyYc1Sn/5/eO1Dnd7HqF6l9RYvpNu+wJV7NSKM3XhbuR2eDSjYB2aFm/YVvybp8GyjafdWlGv9HdtvK9IKhsn0i6F+E3ImICGTs32GKEvZlBIxfJN3TdQpfK7M1sJ7hDKPU0K+Nnn6vdCNEnb4Xakef1RM5gJ/yq2hsj/bQyy+8RuFRtWi4g0d34o0b8sJVDXA0Ehg2zqXPg1DfnqmEyoGjz5xmCa1HQRuyi1GR7AygzO9XKqWoJIAbK9lu6K+T9TnSfr3Mo6A9cijEYnYKXzpUBSJc7P6Q1CdxoUA0cV9ozU34sUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ltoM15fa8DDV9i85o4BVM1M3tOQ0E/tfJeyHwWzq2RA=;
 b=HJLyJzR6CZ1MxuFROR6tj0FbueA7YOgnq3g3L4tGermVJrCJkcRT13n8cvENExYY/xzL8L4aiyOBsQOC8TxUP2ZKsSBS1SYURsrdF9jpyEkFIs2MpiTVHiR0yYIOki7V3x682g7IrbKTkW9NcusjAPg7q008q80zulj84oO/vUU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BYAPR10MB3638.namprd10.prod.outlook.com (2603:10b6:a03:125::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Wed, 27 Oct
 2021 16:33:48 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::2848:63dc:b87:8021]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::2848:63dc:b87:8021%7]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 16:33:48 +0000
Subject: Re: [PATCH 1/3] virtio: cache indirect desc for split
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20211027061913.76276-1-xuanzhuo@linux.alibaba.com>
 <20211027061913.76276-2-xuanzhuo@linux.alibaba.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <d6a38629-cb0a-be7b-5256-30ed8b34ee76@oracle.com>
Date:   Wed, 27 Oct 2021 09:33:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20211027061913.76276-2-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:806:120::35) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
Received: from [IPv6:2606:b400:400:7446:8000::1d4] (2606:b400:8301:1010::16aa) by SN7PR04CA0060.namprd04.prod.outlook.com (2603:10b6:806:120::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 16:33:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3acbeb82-3e22-4f43-1216-08d999678d2d
X-MS-TrafficTypeDiagnostic: BYAPR10MB3638:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3638A728CC6B3046AC9C45EEF0859@BYAPR10MB3638.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4BCaeQoS2oHmz6tdGYK/APxkMfrpuSoR5C+TvFebGspWQGS9Q8PoRv5gG6mtRzfQhXHKlna+NLfwNAB6xsSYvZfWBrd8ofrQIN4Vq9ANzL6kagDzPV/lTSfNUfp1ZWHuDyIEFrpJBgxF8NG8AOJGLgpAr6ua7wg1l5UgtUMb4OUaQIfVMrx3V5kcIe/glv5WW1lzEPYn5Qs+JN7Pv2cpKw3UHB6d/gF+WssuFQfcxOeUnuW+hfJqmccsECif2wImfXlrnauaxw2tJfIFYsjpwolTVVC/4Ibrhm8lozfPrqy/0BZnuF/SIuBTJ87ukuZa8oVm/OtEvPK0yjZJGTQfRJlWzQDJWmxig6cy/Gc9Lb+Q+xrTEiCW3kZWVSkeYxiQRJc2Y6pq5BPk/3sV1ngeO1S5wq6c6HvjlBpUJ4ojLgN5/sCMxb2eF5AWIaS8FOeSJxDW27vpQVN8BdMtmP/wes9/jied+KLh1YKZ3yJrCj1yX6LsbOncnoJo0DSxBZfao8sMKL+76Ts9TSvG0Ut+cRvyswRxegJN4qoei3Pmw5EjtjmBd92i/jEWm+e2DT+2CaLK5oVYM4H+SlQWGfl5dbfzkKfMw5eY3CrwOLYAshoPl3Jj5O4JJ75g0QBAR37cE7OBtA9yG7AC+e8InzGdQhmhgbcDSr6IPZSkaxZsiUGewC0XuGktp5DaBr1aK2JmOCsvF4OtawPS7fkAF6vMsynWer4MewzszjTga9kPYcg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(2906002)(66946007)(31686004)(5660300002)(53546011)(8676002)(54906003)(6916009)(36756003)(316002)(508600001)(186003)(8936002)(86362001)(38100700002)(4326008)(31696002)(6486002)(83380400001)(2616005)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVRFdjBCQ2kvQnkyck1Ja0F0a0xicDlOM2lFN05XL2JkNE1zRXdtNitLTWxy?=
 =?utf-8?B?ZElNbGo3WEE2dmpNYS9maGErRmRIWWJobC90VHlBM0RkRXJCaTBNNWFtRElj?=
 =?utf-8?B?UVpKdnhPa0drRG1WWGl6VmFWZFptS1lLOG9xd1dkZTR3ZnhaZk9lbm9xV0I1?=
 =?utf-8?B?QnRrTXk3SmxCRHNFd0tLRFlON1E1T0htN2MwdUpBbHlxZWlhUU9DQUhLSlVt?=
 =?utf-8?B?cml2cUNwZ0tCN3JrZmlMU3REY3VqRC9lbHk3dGRIRi9zL1RzajloY0gzTzVp?=
 =?utf-8?B?UG5LTkoxbzcvZlRQM0hzUjdjMktXWmt1TGJ4RDBlNjZCNnYxemh2VERlR2tP?=
 =?utf-8?B?SitZdTVVZlRZZmZqeFFwb3ZYcXdQeTM0TEU4bTZqTmdKVkI3eUM3dWFHdjZs?=
 =?utf-8?B?ZlBhWXZaTDY2R29VakJmcFJXN1BLUUdFZE1Obm1vdCsxNmhKcmVmZktTOWVr?=
 =?utf-8?B?RXBYd2dJeExzczNURU1KcDBtajFQcE1mZ3JqR21FeXJ2eUN4L1M3dmZvNGFQ?=
 =?utf-8?B?aW9qcFRndEVGOFQ2NzRGMFpNS0lUTDFoTzIxQ1lwaHhPZEQvZDBFTzBycEkz?=
 =?utf-8?B?QUVHbXVvNnM1NjVlZU5DaHJscUpXUVZ5VEltY3kyMmFQZGo1UWk1Z0E5bWNq?=
 =?utf-8?B?dHd2R003eUlvL1ZmUTdMS0FlVzcxTmdkaEswcWVUamowZHV1N1cxT1ZYbTRk?=
 =?utf-8?B?Ylcvb2NVNjNDWkhOR2FjanNQc2x3bGFtcUg2THI5anlxMXVoS2VMUWt2VmdU?=
 =?utf-8?B?ZFFYSUZXMVAwZEJuQTMwWEJLSXF5bTRXemlIOXRmRDQwcHkxNzN6T05Fc0Yz?=
 =?utf-8?B?M3hNaDYxOTY5YzZrZzB2VmhUUWRZMW9nc3ZWMmJKazB6VzBFc0FndllrckF3?=
 =?utf-8?B?RzNZeFdTSktiZGViR2FzRXRIanhVcG5KLzFTMWpweGgxc1FyZFFycG1PeGNk?=
 =?utf-8?B?S09McFZQQlp6N1F1QzE2RGpydzFmL21hUjJvV2tNR0ZsaGRZK3locmJaZTU5?=
 =?utf-8?B?QnE4R21MR3g3czZ6VWsvcTBUcTlZaitqRkZUbDJpRWc4Q3RPcWpTV1JyZlBT?=
 =?utf-8?B?R216Wk9FSU5WLzdsOWs4OHFSZGRtOWpJdUxJeHdydHBZYU1nOXhSV3RpcXBr?=
 =?utf-8?B?NjBQTWQ5OGw0MXNIbFFweFg1SERBV2JUMEZ1OEdlR2gwa3JlRUg2WGxPMWtF?=
 =?utf-8?B?c1RkdS9vSXoxWW5oN3NGNnRiT2pGVWEweDduN2hWOXJJL1hHYWd6YkFqQ1NK?=
 =?utf-8?B?R2VMV0FLTnpXNVZpc1drbTZqSFZUZjIrTy9MMGt4YmZMc2x5amdGanV5Mzhu?=
 =?utf-8?B?SUNvOGpOWDF0MVlRNGorUWh0cFg4MmUxTTF3R3NkMmZYRUlvaFF3VDc0MUI1?=
 =?utf-8?B?QTkwQjlNcnhlRzhmWGRRdFBpL0ZjNEx1bTI2eVVBbFNYU01LRTlBbmFPVFJQ?=
 =?utf-8?B?WDFmNDRxd0F5ejQ5eFpaTURUeXFORytyZ3hJMzFmZjFBTmNSaHcrR3NRakhX?=
 =?utf-8?B?MVZxb2dWM2ZHL2JsdmYrWlNqajkyU29md0llVERJM1NFdmdKRkN2V2Z4YkdQ?=
 =?utf-8?B?MWZGTnpqREZUZEorNU52d21BVnRZbEk2U0k5Lzg5TTVTL1VkMWNyeGJaU1JO?=
 =?utf-8?B?d29XQ0hOd2FDK3VSc3JBSWRSVlBUQldZdzlmWXlSdUo1QytWYkRRVFlvZGMz?=
 =?utf-8?B?SDMrZW8xTmVBVWdsVUJyZVdxbWdXcTRrdXVISVlkaXhBZTM3allHeStCT2lY?=
 =?utf-8?B?RmllR2docDFVSzcvMjI2VDltTGRFRnRCek5UOW1EMCtBNjcrcUF2WlJIOHpK?=
 =?utf-8?B?YnEwWjcvb0ZWM0E3Y0M3UTZHSzFBQ1kxRHAzQWp4V3NNYVVwbUIyUUtaVldj?=
 =?utf-8?B?bm00cHNrWFlvVWNTaXNTT0trMmRXSmJhQnp5UnJyU01GY1EvUXhuMUE5TVlj?=
 =?utf-8?B?b1V1SWJURngzZWxCUjd1Q2F5eSsrVi9sUlBQdlZrY3VIUW93c09mdFk1THZ0?=
 =?utf-8?B?RGVXaVlDVWVaOFhzUVROVjBraVBlL0g0VStLWndSSCtYZ1Q3OU1qbDJyd012?=
 =?utf-8?B?OGMrNWtuUm5WMFFrSWJXQU5MUjBxMW9IcmNTV0hCYWVEdXdDSkkwNUd4UFhq?=
 =?utf-8?B?ZTk4RHlSVVNDK2ozNlZVbFBhcHg5M3drbFl6Z2IvTXZ5QjI4YVd0NFdRL2ly?=
 =?utf-8?Q?TyX7TDDYSO1NuNwm97E8OMN0ZuAGb61SHtPX4US8Zz9F?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3acbeb82-3e22-4f43-1216-08d999678d2d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 16:33:48.1066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NXJ+mh6K/nxpoNsg5MX5+WEJVrq3tYrk8Z2UshpcHiZXrO4c3zkDm2w2VIu50A6u/Izs+KKM2b92SPqMOSS1bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3638
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10150 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270096
X-Proofpoint-ORIG-GUID: 3rRl2qN4I6qQmwYB9bFEuc6NfvAx_R3G
X-Proofpoint-GUID: 3rRl2qN4I6qQmwYB9bFEuc6NfvAx_R3G
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/21 11:19 PM, Xuan Zhuo wrote:
> In the case of using indirect, indirect desc must be allocated and
> released each time, which increases a lot of cpu overhead.
> 
> Here, a cache is added for indirect. If the number of indirect desc to be
> applied for is less than VIRT_QUEUE_CACHE_DESC_NUM, the desc array with
> the size of VIRT_QUEUE_CACHE_DESC_NUM is fixed and cached for reuse.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/virtio/virtio.c      |  6 ++++
>  drivers/virtio/virtio_ring.c | 63 ++++++++++++++++++++++++++++++------
>  include/linux/virtio.h       | 10 ++++++
>  3 files changed, 70 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 0a5b54034d4b..04bcb74e5b9a 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -431,6 +431,12 @@ bool is_virtio_device(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(is_virtio_device);
>  
> +void virtio_use_desc_cache(struct virtio_device *dev, bool val)
> +{
> +	dev->desc_cache = val;
> +}
> +EXPORT_SYMBOL_GPL(virtio_use_desc_cache);
> +
>  void unregister_virtio_device(struct virtio_device *dev)
>  {
>  	int index = dev->index; /* save for after device release */
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index dd95dfd85e98..0b9a8544b0e8 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -117,6 +117,10 @@ struct vring_virtqueue {
>  	/* Hint for event idx: already triggered no need to disable. */
>  	bool event_triggered;
>  
> +	/* Is indirect cache used? */
> +	bool use_desc_cache;
> +	void *desc_cache_chain;
> +
>  	union {
>  		/* Available for split ring */
>  		struct {
> @@ -423,12 +427,47 @@ static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
>  	return extra[i].next;
>  }
>  
> -static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
> +#define VIRT_QUEUE_CACHE_DESC_NUM 4
> +
> +static void desc_cache_chain_free_split(void *chain)
> +{
> +	struct vring_desc *desc;
> +
> +	while (chain) {
> +		desc = chain;
> +		chain = (void *)desc->addr;
> +		kfree(desc);
> +	}
> +}
> +
> +static void desc_cache_put_split(struct vring_virtqueue *vq,
> +				 struct vring_desc *desc, int n)
> +{
> +	if (vq->use_desc_cache && n <= VIRT_QUEUE_CACHE_DESC_NUM) {
> +		desc->addr = (u64)vq->desc_cache_chain;
> +		vq->desc_cache_chain = desc;
> +	} else {
> +		kfree(desc);
> +	}
> +}
> +
> +static struct vring_desc *alloc_indirect_split(struct vring_virtqueue *vq,
>  					       unsigned int total_sg,
>  					       gfp_t gfp)
>  {
>  	struct vring_desc *desc;
> -	unsigned int i;
> +	unsigned int i, n;
> +
> +	if (vq->use_desc_cache && total_sg <= VIRT_QUEUE_CACHE_DESC_NUM) {
> +		if (vq->desc_cache_chain) {
> +			desc = vq->desc_cache_chain;
> +			vq->desc_cache_chain = (void *)desc->addr;
> +			goto got;
> +		}
> +		n = VIRT_QUEUE_CACHE_DESC_NUM;

How about to make the VIRT_QUEUE_CACHE_DESC_NUM configurable (at least during
driver probing) unless there is a reason that the default value is 4.

Thank you very much!

Dongli Zhang



> +	} else {
> +		n = total_sg;
> +	}
>  
>  	/*
>  	 * We require lowmem mappings for the descriptors because
> @@ -437,12 +476,13 @@ static struct vring_desc *alloc_indirect_split(struct virtqueue *_vq,
>  	 */
>  	gfp &= ~__GFP_HIGHMEM;
>  
> -	desc = kmalloc_array(total_sg, sizeof(struct vring_desc), gfp);
> +	desc = kmalloc_array(n, sizeof(struct vring_desc), gfp);
>  	if (!desc)
>  		return NULL;
>  
> +got:
>  	for (i = 0; i < total_sg; i++)
> -		desc[i].next = cpu_to_virtio16(_vq->vdev, i + 1);
> +		desc[i].next = cpu_to_virtio16(vq->vq.vdev, i + 1);
>  	return desc;
>  }
>  
> @@ -508,7 +548,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>  	head = vq->free_head;
>  
>  	if (virtqueue_use_indirect(_vq, total_sg))
> -		desc = alloc_indirect_split(_vq, total_sg, gfp);
> +		desc = alloc_indirect_split(vq, total_sg, gfp);
>  	else {
>  		desc = NULL;
>  		WARN_ON_ONCE(total_sg > vq->split.vring.num && !vq->indirect);
> @@ -652,7 +692,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>  	}
>  
>  	if (indirect)
> -		kfree(desc);
> +		desc_cache_put_split(vq, desc, total_sg);
>  
>  	END_USE(vq);
>  	return -ENOMEM;
> @@ -717,7 +757,7 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>  	if (vq->indirect) {
>  		struct vring_desc *indir_desc =
>  				vq->split.desc_state[head].indir_desc;
> -		u32 len;
> +		u32 len, n;
>  
>  		/* Free the indirect table, if any, now that it's unmapped. */
>  		if (!indir_desc)
> @@ -729,10 +769,12 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>  				VRING_DESC_F_INDIRECT));
>  		BUG_ON(len == 0 || len % sizeof(struct vring_desc));
>  
> -		for (j = 0; j < len / sizeof(struct vring_desc); j++)
> +		n = len / sizeof(struct vring_desc);
> +
> +		for (j = 0; j < n; j++)
>  			vring_unmap_one_split_indirect(vq, &indir_desc[j]);
>  
> -		kfree(indir_desc);
> +		desc_cache_put_split(vq, indir_desc, n);
>  		vq->split.desc_state[head].indir_desc = NULL;
>  	} else if (ctx) {
>  		*ctx = vq->split.desc_state[head].indir_desc;
> @@ -2199,6 +2241,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>  	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
>  		!context;
>  	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
> +	vq->desc_cache_chain = NULL;
> +	vq->use_desc_cache = vdev->desc_cache;
>  
>  	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
>  		vq->weak_barriers = false;
> @@ -2329,6 +2373,7 @@ void vring_del_virtqueue(struct virtqueue *_vq)
>  	if (!vq->packed_ring) {
>  		kfree(vq->split.desc_state);
>  		kfree(vq->split.desc_extra);
> +		desc_cache_chain_free_split(vq->desc_cache_chain);
>  	}
>  	kfree(vq);
>  }
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index 41edbc01ffa4..d84b7b8f4070 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -109,6 +109,7 @@ struct virtio_device {
>  	bool failed;
>  	bool config_enabled;
>  	bool config_change_pending;
> +	bool desc_cache;
>  	spinlock_t config_lock;
>  	spinlock_t vqs_list_lock; /* Protects VQs list access */
>  	struct device dev;
> @@ -130,6 +131,15 @@ int register_virtio_device(struct virtio_device *dev);
>  void unregister_virtio_device(struct virtio_device *dev);
>  bool is_virtio_device(struct device *dev);
>  
> +/**
> + * virtio_use_desc_cache - virtio ring use desc cache
> + *
> + * virtio will cache the allocated indirect desc.
> + *
> + * This function must be called before find_vqs.
> + */
> +void virtio_use_desc_cache(struct virtio_device *dev, bool val);
> +
>  void virtio_break_device(struct virtio_device *dev);
>  
>  void virtio_config_changed(struct virtio_device *dev);
> 
