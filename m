Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBBEA676D35
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 14:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjAVNrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 08:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjAVNrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 08:47:20 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2053.outbound.protection.outlook.com [40.107.212.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9140117CF9;
        Sun, 22 Jan 2023 05:47:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XvYvUvsAZjIclEM4ENyLnGNOjfLhOXVbq28xWdRUA93mbvIQ9jt7w5o8vKkkUOMph3sKHqwXSAxwgO4pqXQywxj4GCkl4GGQ29QbDZiLGWb5TyGTyHsLsw1Fv4EvHYYI390y1pYj19LeyhGzx+K4bHX2viP0Mj1Wh48tffH4FlvhwYkefucpQNqlqqmzhIJbz3fv6JCogjiUsGM/8okbQz3tK05xSiVpVyzYvqYlFSYUPA7fgR8XDA+Dk2ap4egrVqZT2Jjg4QYJs8C4kbJjyl2ShWkcwxyxXKa7DTmKuWK1cxIRSt2WCbGpIbwhFnktq1I5bxcOx/wtAR+sYJClzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29LxjuquIV7ZozcSDc6273XVmi4AEucr8B9ECnBAWXM=;
 b=XpK1GB1Pj0UExdorxtbvEYEOfoIOTrJgut6ExEC+illbu824K7mrBf35JgR0OIJHugpTfxN1uD+XdzBPPCjkwCeW6u0mElEBB1EVndV017rh8m2hO05aeTb1pkFtIbl2Al7NwauSRaNwkNnWNdYqgUZI2pe9B9UO5YKt0JY5uGv27CntYtIECd29qn8uJ7kFAWYmMRZ+2w/8qfQHVox8YT+hdBEpVc2nTraT8O7TzY++XCYciRYFPBDXMZhb5f5Lw58VGWNEw6sgd/J6rzb6cdVdOcGLu8ZcTFaHpL9gAZeiCePJstMZa78TcKFE6c/RnH/6LazFx4aDDmHeKgZncw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29LxjuquIV7ZozcSDc6273XVmi4AEucr8B9ECnBAWXM=;
 b=tOgZL0lfl0eNVgOiUo2wdQTrioXOdeFtTzDC2En/WstS1+/GtEkqdOGErPeD8YDGbyNACYW/HQys72oYJ51wZrHkP/o3NjjMXtvpfFB15Np1grLnUW1MMqoQsZ+8FPeOO6V6T4ycexccaFKY4Yv/J2WkLfFxSngQQozO7BWaJnujDO1AajoixmfaYC5D9GSCbczkZyFlEqhpqdy6OKHxMpHxOGh3lwhSAbiZWeA8dZKCw3G6lMbThh25epRShTE8FTUZ0sNNPudKw1wSU+lLDIjTyth7bZcbWPOVEX6/rDpxMQA0at7JrZmsgA4hBMrce9deZXmCQ/Cw/X4YX0ysHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 CY5PR12MB6274.namprd12.prod.outlook.com (2603:10b6:930:21::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.27; Sun, 22 Jan 2023 13:47:17 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::70c6:a62a:4199:b8ed]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::70c6:a62a:4199:b8ed%4]) with mapi id 15.20.6002.028; Sun, 22 Jan 2023
 13:47:17 +0000
Message-ID: <07a24753-767b-4e1e-2bcf-21ec04bc044a@nvidia.com>
Date:   Sun, 22 Jan 2023 15:47:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/4] virtio_net: notify MAC address change on device
 initialization
Content-Language: en-US
To:     Laurent Vivier <lvivier@redhat.com>, linux-kernel@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Cindy Lu <lulu@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <20230122100526.2302556-1-lvivier@redhat.com>
 <20230122100526.2302556-2-lvivier@redhat.com>
From:   Eli Cohen <elic@nvidia.com>
In-Reply-To: <20230122100526.2302556-2-lvivier@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::21) To DM8PR12MB5400.namprd12.prod.outlook.com
 (2603:10b6:8:3b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5400:EE_|CY5PR12MB6274:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e460f7b-f3be-4080-921a-08dafc7f2d11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Okn3Kr/A5N0cYMCBV9yKttEE9fI+v7VxSB/6yyWa8cwPeCnU+1GDWvxXknzVAsje+GA53n2JROP8FKjwmQK6ELUvRlDetEahSFnZwoqBEdL5tkkNzNfpkzjJZ710xDv5jEZM/p93M21kUO6VNRscnvtxQpN8j0FlknFnIDOfnAla2YMg/Z9jp6IvHP7zvBP5iCc2Okap3vbYGShn45p8V7Ahw8BWzDvaeucRX1BYm7pT1+WDuEEdyhPgLez9T1bBZbuwNOaadwhliED5H48ZC2VBJUcX7Wi6m3QAIANQiiPyCUMrfAmJ4BwlTLv0TrGdeYVsGzTMQG4xB6zm0rX8sQHRPwbtpbVaFZXQpqmdd+A3BE6qv2I2fkIkwUdsp0LyGeS1sZD4jqxcIzxyKRB0quxDdjo3SnsO0zWztg4rtOexTWEV9tZRBieVX7Jac6OcWFj1VdL0bo17FaD5fAkGW7IZ5Un0ZQ+ePmgdbNI23fM3ipcYn+iYRL+Nm+I1S/8m2hi2xSsI4Gjohos4g6PgmtWGSdHtwNI9wiaE48R00KkUr9Xs9TNF1LdPQCkrfBcff8gHte4QweXrvlKIOi66tyTBgC32bc02+bS24skmlLvmbPpSDtaYRi6Vdf9Sb7XtFUC4TODjmiRcBCJl1zqmgZAXca7RuVd4CeNbqDxXOL1jXbcs3alZh0a9hNAoMGjdak5AVrO+P2DNAbAuaTeAxa8TGNfnxbvWbw+5vQJC6ZM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(451199015)(31686004)(83380400001)(6486002)(478600001)(31696002)(36756003)(6512007)(2616005)(86362001)(38100700002)(6506007)(41300700001)(2906002)(7416002)(6666004)(53546011)(186003)(26005)(66476007)(5660300002)(66556008)(4326008)(316002)(8676002)(8936002)(66946007)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWdZaGdZVEsydUprODRTWDEzb25IZWgrMkhOMmYvcFVVM1puZDdvWllIQ3pa?=
 =?utf-8?B?V1VBeTVGOGsrbVlsbkpkVm9CNkR4VDVGNEZSRHBmcGswMXlySjF0TkNxSE9p?=
 =?utf-8?B?NFhZY1llVUduT2ErWU9SQU12Q3BVdWUvN0ZtUWVCRjdBNm1TczVnZHVoWHBM?=
 =?utf-8?B?RnVIb0dMU2N1SFp2ekNudFVZZ25RZUdxSEdOb09mQ3NJZTMyTlFNemtpVnE5?=
 =?utf-8?B?T2dST2M5U3hXUkFlbW9tbTRpQnA0L0JCRlpuU21RVis1cXJLQ2FkU1V0NGJh?=
 =?utf-8?B?Q2c2bTVQb3dMcEFuTkoyVlFUeENuK3pVaXhRVVNtSGJyQmRBVGJMazdSYmts?=
 =?utf-8?B?V1c4NVp0Q3p3ZkxWWk5wUDAzUk13UmY4TTVQd29BaE4zajVaN2o0VEFyZlpT?=
 =?utf-8?B?L25RM2pnZWg1VUgvZFNxeUhGNWZhcXpQQzk1VUpLM1JkaThqRFROVXR5UXNT?=
 =?utf-8?B?bWk0dktvSFVZOFp4cFBPVGZlcWxtcFkycXNqWnhpa3g1cjZ0bGNTMnFXUlAv?=
 =?utf-8?B?RTl2NldPRFBiaVN0RmVtbTZxTnhHY012RlAvbUdlYzY4SlJCZThMSU8xd1hE?=
 =?utf-8?B?UGZ6R2lCYzVTQ1lSdExPTk9uUlloM3JrQ29YZ3VnZ1lORGEwcWNDM1VIZXZj?=
 =?utf-8?B?bkZ2R2JTNFNlaW1WUGdSUjZiejBqRW1maEcyYnZQMlZEemQxOU5UdSszV214?=
 =?utf-8?B?bW5pS052MElYTFBMUTR1QS9Zb0Q2Wm5EMi9OSk1VckdrUW9VOHFwOXdqSWZ3?=
 =?utf-8?B?dmZscTFUV1pKTURyWndDYkJOUDNITXNja1M4ay8wL2taRkpyaE9KSVhPcHVq?=
 =?utf-8?B?ejJ5NlUvOTRDTXJ4STZ3M2dNa3dxaTJ3SnVvWERJTjI0dmVXK1BvZkkxdGFM?=
 =?utf-8?B?UWZUVkdVNnozWjBCVzlvUlo3MjcwTUtvMURDeUJ3aEN4WG5CMk9US1dqWnZP?=
 =?utf-8?B?Y0cwQWV3eGQrMVk3aXBaemY4UjExUGZyL2Izd3hhTG5BUmowM21VU1JmVVFD?=
 =?utf-8?B?UWZEUU5uRU4vVlo0MHgvanBZZS83QTE1MGcyUnllUzBleWxuS1kvMjlySGVV?=
 =?utf-8?B?RkRhZE40VUpFd2wrYlNRRmRmNDUvdmZSRGsraXhqeXRRQnc5Zk9lNW5wUWp3?=
 =?utf-8?B?SktzWnhJV0JBSVIxdFNjTVphUG5VTFRzSlluNFFnOWw4ZzhIUFVGY01rdTZu?=
 =?utf-8?B?QkVtRy9MWFRHUlcwUE16L2p4ZVdwcnFBc2JUNndLOU1jYTRhNGthbDJBaXFh?=
 =?utf-8?B?MWtZN3NHSkduWHVzL1U2VlQ5cEk1aW9ZTDMvdEVxVFB1aEd1M1R0UmlCcUl6?=
 =?utf-8?B?R3dkc0pQN2IwY0kvYUcva0ZJalprb0QwY2J0dGRRNEM5bFhNaUQrcEhxWHhj?=
 =?utf-8?B?ZVhaTENEQXd6MXRPVDZmaG5hdVNtQVdmYVpaY1dOdC92clhUWWdPYVF6ejN0?=
 =?utf-8?B?VitYcjZEdzFuK0Q0UDJZVU9oc0JmMW5LSjRsd2lpWXlIcVZjR0JxTW9yc3Jp?=
 =?utf-8?B?UzNjTjJNRUlueVpUVGdZaVVST3JsRjlBR1VSNnVIWUgvaHFMMU1XeWpSVlh2?=
 =?utf-8?B?OCtqODJxYzJPLzlPc01kdCs0U3JCYnNjYUlDQ3pRMUNjRDBScEhacHJmcEdo?=
 =?utf-8?B?ZDI5RTdQQmhsdkc5OWppRkhwZ25HTTV1eTY4M1FUSnFidW1QUUhPd1pVMlk2?=
 =?utf-8?B?QXZiNWZDd21iMUg3cHdqRjF3ZmxRSy9yYmlBNThEemlNNVlKMnN3VGRuRTNZ?=
 =?utf-8?B?R01OaldRUmFrWWZyTkRVYnM2QVA0Y1d6aVl0ZjlNQWptdGNIdlVhVml3NWxV?=
 =?utf-8?B?V3ZUMnc3Z1pTbmUrbXRmS2F0aE1HSWFUK1FxbWc3MklhbUc0T0FBNnJFM1ov?=
 =?utf-8?B?QmJGUTZpazBJS0tKOElJT2dzYmFyWWU1UTQ1ZnFFb0hSeUVlajczY1V4WE9k?=
 =?utf-8?B?bWs1ckdqZDczNEpGM3dxNGlWaktuS3c0UXhuR3FML3BtY2ZHWm1GSlJXNDdX?=
 =?utf-8?B?a21qNEJhZ21XSzBPNlczaGpyelVkT0ZmTWxMT2R0SGlMUXJzcmp0eTZxLzdN?=
 =?utf-8?B?S2NJNXdlN2c5VWxvU3doamZCRjYvUkhqMkVleHFocXU5Uk5BbW1vRE1DRHg4?=
 =?utf-8?Q?3TmjvqBBVEclyOe+mIUfQd9ow?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e460f7b-f3be-4080-921a-08dafc7f2d11
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 13:47:17.6487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cs4KAtReTbgR+o5iZKOHXLphsvxbHhp5B7ADcsNTmKa5F9mKYqvxNnfXyR+Hk2Vb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6274
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22/01/2023 12:05, Laurent Vivier wrote:
> In virtnet_probe(), if the device doesn't provide a MAC address the
> driver assigns a random one.
> As we modify the MAC address we need to notify the device to allow it
> to update all the related information.
>
> The problem can be seen with vDPA and mlx5_vdpa driver as it doesn't
> assign a MAC address by default. The virtio_net device uses a random
> MAC address (we can see it with "ip link"), but we can't ping a net
> namespace from another one using the virtio-vdpa device because the
> new MAC address has not been provided to the hardware.
>
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> ---
>   drivers/net/virtio_net.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7723b2a49d8e..25511a86590e 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3800,6 +3800,8 @@ static int virtnet_probe(struct virtio_device *vdev)
>   		eth_hw_addr_set(dev, addr);
>   	} else {
>   		eth_hw_addr_random(dev);
> +		dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
> +			 dev->dev_addr);
>   	}
>   
>   	/* Set up our device-specific information */
> @@ -3956,6 +3958,18 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	pr_debug("virtnet: registered device %s with %d RX and TX vq's\n",
>   		 dev->name, max_queue_pairs);
>   
> +	/* a random MAC address has been assigned, notify the device */
> +	if (dev->addr_assign_type == NET_ADDR_RANDOM &&
Maybe it's better to not count on addr_assign_type and use a local 
variable to indicate that virtnet_probe assigned random MAC. The reason 
is that the hardware driver might have done that as well and does not 
need notification.
> +	    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
> +		struct scatterlist sg;
> +
> +		sg_init_one(&sg, dev->dev_addr, dev->addr_len);
> +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
> +					  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
> +			dev_warn(&vdev->dev, "Failed to update MAC address.\n");
> +		}
> +	}
> +
>   	return 0;
>   
>   free_unregister_netdev:
