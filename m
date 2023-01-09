Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF03B66231E
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 11:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbjAIKX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 05:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237131AbjAIKXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 05:23:12 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA746186AC;
        Mon,  9 Jan 2023 02:21:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDqclpScFQIZf71oT80czfOHLFj+8fy4iR7A2VdeLIl9nG0NuvEUNjYEPV8u61LYj8nwVK/huh3ADcvepmmDw1aUvJ/4FAiTvy7uKwOvIU1MwMMOSolCnU8HkjiOxuGD9C5UxJb0AAj3L2M+sO5j3PVcYOYqdELOo3sqeamZ6+/U7Cofk4/MNRvg5Pi2TIbYSErt17B5F/BiIZJ1IDIK/EVnP0QOLVxftrJwdhcSpTtg4Pyxr5+JB9APh51fuGiw25IvlyixnAKe67unmpmTbxts1zkNGCdfwxjVB70cc92AKPOyZZKqNl6EDtYINxy3ilMlpn2lkQDs1ALqJCslrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUPaZxOqPv/bp7yRxTt/JKhgQbGK00RuI2OXHa9gDWM=;
 b=GLRtN2EZXu6zunykJ1R+jswGWY2o8hoR2R8/qSOOtL9c2G+cMoWT33rb9XDfzKz3SHFU8UFe4AhX0KIogW1Ej/jYODCHhg+FXj1SOmgWOg2sqpJL9OETxOQCQd0TYgW0c4V+DBM96fO8ibIEvBfbhFyeM+Ypros8zG3PSzGacMc8NfcfJ0YS5/sG+He0krCx8oSYWJFTk4/SzZsYl15kyafEJpYw2AZmy6lTUBt+1q2hUElCKGEKScZX1mxWy5kcX0F2yX+eDv3rMzeCnaZAYh9ynbDt2qRHkXf15sX6SJCbpLwE9UGOg9n47flS38XbynYQJHs4fPe+PBKNmqls2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUPaZxOqPv/bp7yRxTt/JKhgQbGK00RuI2OXHa9gDWM=;
 b=zXhf714YSRsuEfIdP6D62aOSnJPBe54FEhnJK07XnYvdaZyFnLisAsWctZxBBxqlIwWfBWsuNuG1cKL9wGl/XwVTG+lA8CUCaP6DETYjH7SpWpY03EO7kiiIfwtHB3rKh19YfahPfvb6XA0JG8xTBSoddgIEZjNrYCRE6yXROFQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by CY8PR12MB7339.namprd12.prod.outlook.com (2603:10b6:930:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 10:21:25 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::e36e:5151:6912:18e]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::e36e:5151:6912:18e%5]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 10:21:25 +0000
Message-ID: <c5956679-82c1-336b-3190-de32db1c0926@amd.com>
Date:   Mon, 9 Jan 2023 15:51:11 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 08/11] sfc: implement device status related vdpa
 config operations
To:     Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, netdev@vger.kernel.org,
        eperezma@redhat.com, tanuj.kamde@amd.com, Koushik.Dutta@amd.com,
        harpreet.anand@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20221207145428.31544-1-gautam.dawar@amd.com>
 <20221207145428.31544-9-gautam.dawar@amd.com>
 <CACGkMEtGCbUBZRFh7EUJyymuWZ9uxiAOeJHA6h-dGa9Y3pDZGw@mail.gmail.com>
Content-Language: en-US
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEtGCbUBZRFh7EUJyymuWZ9uxiAOeJHA6h-dGa9Y3pDZGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0067.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:99::7) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|CY8PR12MB7339:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d5a708e-e0a0-4319-a176-08daf22b42fb
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NMpHUJm8mROg2blvfUccrDvG2jnXLwYYw7WxH9YORLhmIbne0Rh0+AYZYlEd1CgkMWmXetVIwoWgDFEmEXJ7ojl0xQFxI1acLZH4XAkpr+gY47v6+H5aA1GHj2B8YnEKwEBOu1uH4q2hwzTy9u/QudsZn1waARAMv60iFnFGGBriRwzyzE/0yDp3mwdXtBVvtAzKxsdksLp86g5zUXDz9freveCON1XqI1cweQ605IqiUTvkiwNFwNbzHyqXPM2XTPjXJoMM27aItXysD/T3dOknNIzMvU8d57Ark1xzOITcpayGCzVdHfqH0WzRECX7kZr/OleikQADms2JA907w2uACug8VHcV7iIWTBXf89lWoFzrTeBjmQE6XYRReP4mInpWdZ7Iubl2HYxkVURFxfn7TevpHeWKnLy/T2ChopOzQ8P0s6sg60/WE7gBRN6laQ9aHMOLNHpGRd1FoeBtA9uC1wjcfqc6An+fRg9Q0UEIBXCoLqfXvwwgGBm21GQylOweaeudPqmhBTLSvFX+MC6qLct7WKk+9vtDt//7ke1bh5/87HCaztdS3dIIbLgWQliF38pZpttx4vnto0vmL93MlOcqzNGBJfJKmCOqZknOtxKcLwDcZeKoq0FTlVWfOD1r0hst1INB9BQwTYnmAz1WkNZtrScYSLAqk3RvYcHyKADaCN14/HYPJjHIoVm6rvvQI1snk7M6g2HYCG8gLrXWuJ9toMZ9i5MfmiHw8FM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(451199015)(36756003)(6636002)(186003)(53546011)(8936002)(6666004)(26005)(6506007)(6512007)(2616005)(110136005)(54906003)(5660300002)(66946007)(7416002)(66476007)(66556008)(4326008)(316002)(31696002)(6486002)(38100700002)(478600001)(41300700001)(31686004)(8676002)(2906002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0phUzQwdGJtSG9IaWRnMWI5UStzUUVrRm1vdWtKMUNha2FLV3ZkVGc0aGRP?=
 =?utf-8?B?R2xWLzBQUllhbE9Wdk5BeGxhZk95SVZ6MklJT0gyeW1HYlVxVDFtS1lIQjB2?=
 =?utf-8?B?QXBwR09wUmhPMWRRZE1XMTB2KzlUdUdWT3ZBaEhvU1hCaW02YmhMQzVKK0pN?=
 =?utf-8?B?a0thVDNVTHhhbVRJWXhMWHk2amcraUIwWVVlTkNFVU12SC92bmNNOEV5NWFW?=
 =?utf-8?B?TzJES0xSenRsM0FJeG9DMFQ2NTZ3Sk9oQ2lZWkt2djdUcGpkSnZJdHZHdURk?=
 =?utf-8?B?QXZnaEhjdkE2d3NaWENiY2Y2cVlUVFRDSDJaalhMVmE5azBlOWFNc2J1UmZK?=
 =?utf-8?B?Mk90ck1pWDJRTW1LeDBrTVYweWlaVXAxWW1BSVh2VWs1SEpmUE5NdlJBcnl1?=
 =?utf-8?B?aVFoL2NaeVI2ckMzbk1pRU9ELzlJcWQ0Q3dyTGxYQjBOZTZwYUR5a2VzT2Ft?=
 =?utf-8?B?NWhuMjVOK1AvTzhhMDl1c1BOQ2lWRnpqNWVrSlBtM0ROTXRPTDZQSWZYaUd3?=
 =?utf-8?B?b1VweDlmdHRmYUJOS3ZQTWpic0JiejFQa2o2cTk1dFJMSEVldEJEaVhDZUFY?=
 =?utf-8?B?QmZZMWRkeWdXbzhldHZNTEUvY1NSdWFpdHFmNVZQTTVPMGhTazNaQ3JRbDJQ?=
 =?utf-8?B?akhVdWp2ZXdTMDg5bEtNUU8raUpCWjBzWGtoeVcrRm9ueFY1YjJFS3VsVXdi?=
 =?utf-8?B?eVVrVTV4b012aHRlWmZ4K2krdG82bExyNFZkYVVLb0xTY054Q3FqdksvWFJQ?=
 =?utf-8?B?YmtucGV6OFBOL3FWTkZIdTI4YTloZWNSa1poQXlMME5QQ1YycnQ5QTRlNk4v?=
 =?utf-8?B?MHVJaWJWL25odTI5aVVZTnJuRy9tZ1AvaU9CZm9rdTZOYmhIOXlkaFVNYjdS?=
 =?utf-8?B?dTI2RmxGdXR3Z1d6MWZUdkJKVTZoUXVhMmxGVTJWZkpHL2ZoaE9tZm1HNGNl?=
 =?utf-8?B?ZzcwNks3ZGpkYkdMSVhHWkkzN1pMdUNqTi93cEluVGoybHFwSGlRNUVoeU11?=
 =?utf-8?B?Nml6cTAyZ1ZSb0Y3dDRkMWJuWG0wWlA0dDFXNHhoanFzR0U4S1hCVUJRajd0?=
 =?utf-8?B?U2pMd2FPWE5hek1zTS9Cd2U5RDNYL2lvaC9hNlcrRE5wS09wU0M4eVpkelNZ?=
 =?utf-8?B?Y2c0bjVIc1lHUkUycmc5S0dhbk1sRXpvaHNqQ3IwejRMZ2p0d1VZTDFMR1pF?=
 =?utf-8?B?d1RwMGRyMDF5aVRSbkFZVTFoNWFmR0VwQm9UVUpIV0V4ZVkrNE5tcXJMMXNW?=
 =?utf-8?B?QXYwY29ON1lVOCtKSzl4Y1ZPZTZTNVBZcTMzOHk2WFZtRzYrWUVzOXloUTQz?=
 =?utf-8?B?N0NvY3MyQ1J5WGc3OUE2Z0RhaFRGdlZ5VGxiSmZ6MDhuQUcvZWpFd3RtNXRJ?=
 =?utf-8?B?b3NQQTNWcU8wdE5lOEhoUTlqODZlYWVheXZXNm9KczZiWWgzQ0N4OGFiS1dM?=
 =?utf-8?B?VkxnOXpWOUUxSXBhK0pCQ0l1S2o2WWZkRlVBZEpqdlNSOVhrMExuMEpHcG9z?=
 =?utf-8?B?eTl1cjdyNStsc0FVWXRUSXduTiswT2ljN2VYNnIyalEyQVpZS3daQTRSZzhJ?=
 =?utf-8?B?OEV5ckRQMDc3b2NFWWtFYjNaVWc1OXpIdnhKRDloYkZBQWdYTDl4dFg3dmln?=
 =?utf-8?B?NG9OeENHVG44OUxPdExTQ3F3eHVHNDhOK0hocXU3cndPdFRPTCt1NFNEcis5?=
 =?utf-8?B?ZVJxTEg0K1Y3L3FZNkRDY05hSkRxNnNUTjJrSnp4VFl1OWFCbVUyakhOYnls?=
 =?utf-8?B?bVVraUlwMFdGcHoyeWFyb2NjMUo3eGx5UjdPWi9ieW9ReHhIL3JDdDNKTWZk?=
 =?utf-8?B?VTdwS0tyeWcvcFNSOU4xNkNWK0duZXJSVnI3S1lQSFRiV2prWVB0R3Z6akxj?=
 =?utf-8?B?OWhEb1BxL1NWU3ZYWjl1R1BkRnRYNCtORS9pbGQ1dlI3Zjd4dFM5NWU1VmZ5?=
 =?utf-8?B?aGFHa1MzblZSRmg0S3JrM1oxZmkvY1RKaTVQNkI3and0Qmt0RWtzSXMyeWxm?=
 =?utf-8?B?c0ZJQndHT2lpemF4blNjYjFBUi9hSmg5QUxXRVhsUEpDNnJLeFJWSEQzempk?=
 =?utf-8?B?Uldnci9pVFN6KzY3dUtXOWE0bkJhd3hJc3R5UHY3a041cjZlUHlnWXp4V0lw?=
 =?utf-8?Q?Rmv2EoEGLeSCxXw0UMjRf9O4a?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d5a708e-e0a0-4319-a176-08daf22b42fb
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 10:21:25.0930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3l7SVhz4NrtI5qkJkoAnLpfOBeoRaTrA7ZMP7EeftCBK6CcafKVX4soB1p7QGwL5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7339
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/14/22 12:15, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Wed, Dec 7, 2022 at 10:57 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>> vDPA config opertions to handle get/set device status and device
>> reset have been implemented.
>>
>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>> ---
>>   drivers/net/ethernet/sfc/ef100_vdpa.c     |   7 +-
>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |   1 +
>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 133 ++++++++++++++++++++++
>>   3 files changed, 140 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> index 04d64bfe3c93..80bca281a748 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> @@ -225,9 +225,14 @@ static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
>>
>>   static void ef100_vdpa_delete(struct efx_nic *efx)
>>   {
>> +       struct vdpa_device *vdpa_dev;
>> +
>>          if (efx->vdpa_nic) {
>> +               vdpa_dev = &efx->vdpa_nic->vdpa_dev;
>> +               ef100_vdpa_reset(vdpa_dev);
> Any reason we need to reset during delete?
ef100_reset_vdpa_device() does the necessary clean-up including freeing 
irqs, deleting filters and deleting the vrings which is required while 
removing the vdpa device or unloading the driver.
>
>> +
>>                  /* replace with _vdpa_unregister_device later */
>> -               put_device(&efx->vdpa_nic->vdpa_dev.dev);
>> +               put_device(&vdpa_dev->dev);
>>                  efx->vdpa_nic = NULL;
>>          }
>>          efx_mcdi_free_vis(efx);
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> index a33edd6dda12..1b0bbba88154 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> @@ -186,6 +186,7 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
>>                            enum ef100_vdpa_mac_filter_type type);
>>   int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs);
>>   void ef100_vdpa_irq_vectors_free(void *data);
>> +int ef100_vdpa_reset(struct vdpa_device *vdev);
>>
>>   static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
>>   {
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> index 132ddb4a647b..718b67f6da90 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> @@ -251,6 +251,62 @@ static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
>>          return false;
>>   }
>>
>> +static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>> +{
>> +       int i;
>> +
>> +       WARN_ON(!mutex_is_locked(&vdpa_nic->lock));
>> +
>> +       if (!vdpa_nic->status)
>> +               return;
>> +
>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>> +       vdpa_nic->status = 0;
>> +       vdpa_nic->features = 0;
>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
>> +               reset_vring(vdpa_nic, i);
>> +}
>> +
>> +/* May be called under the rtnl lock */
>> +int ef100_vdpa_reset(struct vdpa_device *vdev)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +       /* vdpa device can be deleted anytime but the bar_config
>> +        * could still be vdpa and hence efx->state would be STATE_VDPA.
>> +        * Accordingly, ensure vdpa device exists before reset handling
>> +        */
>> +       if (!vdpa_nic)
>> +               return -ENODEV;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       ef100_reset_vdpa_device(vdpa_nic);
>> +       mutex_unlock(&vdpa_nic->lock);
>> +       return 0;
>> +}
>> +
>> +static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>> +{
>> +       int rc = 0;
>> +       int i, j;
>> +
>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>> +               if (can_create_vring(vdpa_nic, i)) {
>> +                       rc = create_vring(vdpa_nic, i);
> So I think we can safely remove the create_vring() in set_vq_ready()
> since it's undefined behaviour if set_vq_ready() is called after
> DRIVER_OK.
Is this (undefined) behavior documented in the virtio spec? If so, can 
you please point me to the section of virtio spec that calls this order 
(set_vq_ready() after setting DRIVER_OK) undefined? Is it just that the 
queue can't be enabled after DRIVER_OK or the reverse (disabling the 
queue) after DRIVER_OK is not allowed?
>
>> +                       if (rc)
>> +                               goto clear_vring;
>> +               }
>> +       }
>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
>> +       return rc;
>> +
>> +clear_vring:
>> +       for (j = 0; j < i; j++)
>> +               if (vdpa_nic->vring[j].vring_created)
>> +                       delete_vring(vdpa_nic, j);
>> +       return rc;
>> +}
>> +
>>   static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
>>                                       u16 idx, u64 desc_area, u64 driver_area,
>>                                       u64 device_area)
>> @@ -568,6 +624,80 @@ static u32 ef100_vdpa_get_vendor_id(struct vdpa_device *vdev)
>>          return EF100_VDPA_VENDOR_ID;
>>   }
>>
>> +static u8 ef100_vdpa_get_status(struct vdpa_device *vdev)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       u8 status;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       status = vdpa_nic->status;
>> +       mutex_unlock(&vdpa_nic->lock);
>> +       return status;
>> +}
>> +
>> +static void ef100_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       u8 new_status;
>> +       int rc;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       if (!status) {
>> +               dev_info(&vdev->dev,
>> +                        "%s: Status received is 0. Device reset being done\n",
>> +                        __func__);
>> +               ef100_reset_vdpa_device(vdpa_nic);
>> +               goto unlock_return;
>> +       }
>> +       new_status = status & ~vdpa_nic->status;
>> +       if (new_status == 0) {
>> +               dev_info(&vdev->dev,
>> +                        "%s: New status same as current status\n", __func__);
>> +               goto unlock_return;
>> +       }
>> +       if (new_status & VIRTIO_CONFIG_S_FAILED) {
>> +               ef100_reset_vdpa_device(vdpa_nic);
>> +               goto unlock_return;
>> +       }
>> +
>> +       if (new_status & VIRTIO_CONFIG_S_ACKNOWLEDGE &&
>> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
> As replied before, I think there's no need to check
> EF100_VDPA_STATE_INITIALIZED, otherwise it could be a bug somewhere.
Ok. Will remove the check against EF100_VDPA_STATE_INITIALIZED.
>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
>> +               new_status &= ~VIRTIO_CONFIG_S_ACKNOWLEDGE;
>> +       }
>> +       if (new_status & VIRTIO_CONFIG_S_DRIVER &&
>> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER;
>> +               new_status &= ~VIRTIO_CONFIG_S_DRIVER;
>> +       }
>> +       if (new_status & VIRTIO_CONFIG_S_FEATURES_OK &&
>> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_FEATURES_OK;
>> +               vdpa_nic->vdpa_state = EF100_VDPA_STATE_NEGOTIATED;
> I think we can simply map EF100_VDPA_STATE_NEGOTIATED to
> VIRTIO_CONFIG_S_FEATURES_OK.
>
> E.g the code doesn't fail the feature negotiation by clearing the
> VIRTIO_CONFIG_S_FEATURES_OK when ef100_vdpa_set_driver_feature fails?
Ok.
>
> Thanks

Regards,

Gautam

