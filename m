Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A0A668C61
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjAMGR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbjAMGQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:16:34 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24D71166;
        Thu, 12 Jan 2023 22:10:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUPXxrkKm+S7ahIfMUMKmDjLTbOTeVG5Pr2S4+L7fEg4R3D3cjTtzYU1AhZbfxsOV5GZcJtPsRo/M4ubw53fwlpmDb5Qk291ypCJ5qWBLYPoD+iKx0LI++OqCP+IR9XvldzKvE4CX70nsC9ZN0zw/EVUeATFCY8gxkVwh7pnhjYncsglyPmTGRFmh0TFsDvR90zL5I24WqMhoA6xCi0kIjSpBNf0dAtAU1rpTqTmNegp8qTv83f/Eb3+tNg8fzr1n56Tw19IiZdgMICkG6QLVezclclHGQmjxmj1lzS5Qw61yQRTuWFhC+kxf/sV4uDdJgOOgjMmN22fI4d+TXjlKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGr5QJ5UhU2DN8KFaYCCNo6T6Ed52r3/AlyOp9oElJM=;
 b=bccvGbnc+oTk5rX0oUPZtzcPaaodrMfwbQpL9kpk4+Fihy2ynl6nhwiNxPb4Frlov1YgZIWIhdCroxE9gGvrGm02PMZoC80964CedNApm4zIFcJsf/4FVGuArcjPatYPdPM41tisDX48wQrdnNzjQlPgf9oO1IeXEFGKCqH1FvUoK/ZTVRm7D671WXZiO08r2WFNHkn7KX5v/c8dJvf3qSE2Nj/FeINUSai22geXSDeQX6F5fWtWeNXYCSsAFOnQMpUfs1Xs5IHR62ivvW38XP+Iz74ttggiZNd1Pzb3TzU5zUp94tKOXowiWjA+XXrJdzQLjd918kipr/Qc4biI7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGr5QJ5UhU2DN8KFaYCCNo6T6Ed52r3/AlyOp9oElJM=;
 b=NjrL7ZoqjMhipxbKOSzNjqDzIdIOVVz/oe+Wa7B7nLbR/peiQBT7AxoK/60Yo7JYwuxyqnbt+7/98AXPSSdRZ1+MEb2Oi3yCwftfuK8v9q8rNRUpJWdQJxG5/iWiP1JhvzBP0XnMVpKCNc0jZtmmA2Xr2jDdSB6k1tprFNwMKnQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by BL0PR12MB4930.namprd12.prod.outlook.com (2603:10b6:208:1c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 13 Jan
 2023 06:10:52 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::e36e:5151:6912:18e]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::e36e:5151:6912:18e%5]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 06:10:52 +0000
Message-ID: <289dc054-4cb7-e31c-69b4-b02a62a2fe16@amd.com>
Date:   Fri, 13 Jan 2023 11:40:39 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 08/11] sfc: implement device status related vdpa
 config operations
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        netdev@vger.kernel.org, eperezma@redhat.com, tanuj.kamde@amd.com,
        Koushik.Dutta@amd.com, harpreet.anand@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20221207145428.31544-1-gautam.dawar@amd.com>
 <20221207145428.31544-9-gautam.dawar@amd.com>
 <CACGkMEtGCbUBZRFh7EUJyymuWZ9uxiAOeJHA6h-dGa9Y3pDZGw@mail.gmail.com>
 <c5956679-82c1-336b-3190-de32db1c0926@amd.com>
 <CACGkMEvVnAQ2t4piV3U-hACELvUozRKJOiCCcQLp5ch2TQ9r4w@mail.gmail.com>
 <CACGkMEt866q9CR_4JNUX+35gyV4ykYPiviLHeYfgqKCmrqXZ4A@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEt866q9CR_4JNUX+35gyV4ykYPiviLHeYfgqKCmrqXZ4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0222.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::12) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|BL0PR12MB4930:EE_
X-MS-Office365-Filtering-Correlation-Id: 44ed090d-3a36-421c-1aca-08daf52cec79
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2RHF16bO9FKi2wPYc92ZBX5bZA8vW1nTrDYg9wgQIFRqYV748Ek6Ku/IuHA8Uqfu25ht1eItQN7Th8/xLjj+EgzNBTovE6LlYvQ4SHSZGFy0DvPxsvW4nn/ckO1E/CsuaVmEwnbym8KqK7hg3b4JeSMK4hTeBJoNYcN2LqHb1mrijutt9LX6LpR0Fq/oFP+LjNPrSGTKFb3k0bA2XOIGhDLHPGxVZtYHTqQyfMg+62gUFqf5JxNlRQhPgrRwvLjTDKltVr2Sv4nUy3hh9fSvW+1eoqkQu/YzdybF7fHhI9eaCv+c7xSbt3mqs/YUemEXZ29fnIOQN2bSGjVNL+M1ntakXTA4w4LufCNBu0gKygq4p38c3hcvjTIXMk8sKdukcLlJNkWWb2GGdfamLE3/wh5RU35HeQ5CIsHhQBUu7XKbjklzT4eWIAFgsZp4RULQSudZ2gdVIYk8HYaLlpnfDI93YSuBOIAb/Bai7x7Lnmb0urXiKEvqtBkfYhP7ZAfBnDpkbHHHHuTP0jk2Ko+RhKOylaQo46dHhl3UYlYB4E2mlh+toiiVFYTjzLuYGSbKOHwIebLfWeQU6vl+lSKbwocS+JWKSSV0Cnn0mi3HC0u97rZDyrmhyEwIP4nWiQ0UnndMNqKflQy2kCV/lI4bk8yFNMzQtfDe2somKNNe+4WAadSqBl436P+jt1F+TTtFFd6aLF/VI+FTJwa7G39cH4xPgq+cZdvs97OdgCf8pl+YC2jOzyu4d0otYB4EC/I9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199015)(8936002)(31686004)(6666004)(8676002)(41300700001)(66476007)(6916009)(66556008)(4326008)(66946007)(54906003)(316002)(2616005)(36756003)(2906002)(5660300002)(7416002)(6486002)(31696002)(966005)(26005)(186003)(6512007)(478600001)(53546011)(6506007)(38100700002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bktSRFdDRUlEalJoUlNGUFI0L3V4djFkSDl0UG9IcXNwazJsLzhDZVpPQkhI?=
 =?utf-8?B?WWVKalE3YnpSa2RjTUd1bVQxV1NTenFUUm1qNEpyZmZxc3lVLzh6UHR2cHVw?=
 =?utf-8?B?SUozSGZiYUs3QSswVU1oQmR0TTczTXF6WkZwNTRDYUcvNHFDZFdxSDJSWkpt?=
 =?utf-8?B?M0h4QTdOZjFkdnZPdWR2alFFWmNVdTU2aWwxQVpuSG1pNnFuV1VLOVZNVUNs?=
 =?utf-8?B?OHpHTFhpN0lVMm5uZHhHR1V5TXZFenRJdkdxaEZKQWQvZkpBQUtvUmJWVXk5?=
 =?utf-8?B?Qm4yV05ZbElia2FnbXdzRVcxRVdybFNEaUtYTlB0czBNMFNrRndleXlqWU1Q?=
 =?utf-8?B?d0cwOGZxMTBVNm1ERytnUlluVi9pNDJPNUNzRzJjVTM1Q3daZklBa2RVVGtI?=
 =?utf-8?B?MGhzYmdnL0ptYTFCVFJFTGZlR2JjS2NWV0RQZnVsNGxwc0FWLzFDOUM2RlQ0?=
 =?utf-8?B?dXY1YTJ5WlBRTkJjOU9OTDdNdkdjdnVvTjdaaGdPcUt3QjQ5ZWUvQVAwd2tz?=
 =?utf-8?B?b0dBeElBc2ZrK0FSNFZKYlRyNDRNYzVYZUFDM1ZIeFNsQnBET0VTZWN4MFYr?=
 =?utf-8?B?RjNQNVAwMXJ1aUp6VGZGWU9uSm9XNmJJZEJPb1cwSTVTSllyRE1JdHpUR200?=
 =?utf-8?B?dW40UE94a2FNMGQrV09FU3RHdXFlSXorVy9sakxWNVBDaitSbDVqQ01iZlVw?=
 =?utf-8?B?NmxORjNmZGNXcFhFUS9Mc3lBeXZxZzNMbWhIVHlTUE0wcVRIdGVtVmJIdld4?=
 =?utf-8?B?VlFpMHVueFRwY1hLYkRvQmlNWnhueFVUcmhZV0JLSHNRSVZ2dkt5YWVRem9P?=
 =?utf-8?B?NHBINDMvY0RHcS8rYVRjVUl2di9haWp3Z1RHcE1vZjhZR3pKRldFMklVMG9l?=
 =?utf-8?B?MDBabVVwRE42YkNXVHNSZFl3M2JIZVF3Ylp4SEJwQWdYdTFhRGJjT0JRaU45?=
 =?utf-8?B?VUYwN094RW4vaG1mN2puN1FzTGkwL2c1NWVSNk1NYmsrcWVjS1JDVVdSb21m?=
 =?utf-8?B?dUo0b2FDSkFuVVUxWG9TejBCS3Uwalpjb01IUzBDbnc3bElOWEZWWXM0ZlpN?=
 =?utf-8?B?Mlp5WW84eVk5R1VkYU9TcmhaY2N2N0dRRG9yeEM1QnFUQjdOcEdrNVdXSDZE?=
 =?utf-8?B?djZvUWhJK1lWK1JzTTdQVlVLSWxmUkpyZDBPejJRaTZUa2ZZUlNIeDEzbWk0?=
 =?utf-8?B?b0tGY3hBYmwxMjNCbGVNdEVvdnBnVHFRemM3WVpRUEFZcUdmYWtUZFF5cG0w?=
 =?utf-8?B?NG5zblljWThrRDAyRnpDU01EL1dlUXVaUVZFMFl2WEQ1dW8wbEdxRy9rTEs2?=
 =?utf-8?B?cm02RXB0OHlsTC9CVGZZT2RwdEhzS0lWZEl1RkZlUElxMml1TVdqTkcxT3A4?=
 =?utf-8?B?SlZGS0d5UG5YVGcvWWZyWmtBNnFYeWFSRCt4ZGIzbnhtVElzbnJ5WlJzT2pk?=
 =?utf-8?B?bDFMQ2VBSnRqd050WVRFeU9nVCtmRXQ4bklWL1drUUZ0blFPNlJaNnlZY3R5?=
 =?utf-8?B?Z2w0Tm9CT0ZLZ29EUTBkYkJVR2UrYVN4SFBSVkVJYnk5a1MyQm5LaVVhYUVW?=
 =?utf-8?B?WDNzOUxnR3ZQQ3VkcUxSNlN3Nk1yWmNSWkRMbklhQVR3SjJCWFFFUldmV21j?=
 =?utf-8?B?TWo5UENpN3UxenlBaTl1empoa1J1anIwaEdIcldaTDZMelo4V2NkTjgyZjJ5?=
 =?utf-8?B?aVd4VVI1UVlSMXlvcHU2eDJSbVBNdG1vbmwxQVFIc3BzOW9oMG9yZTVMdlFG?=
 =?utf-8?B?UjNEeHZESVB4cno1SWZFYlUvdlpHYWV4ZzJiOEZLcXdHTWRMQjZnTmFlUzc3?=
 =?utf-8?B?MTNIU1BoVjVJOTdpSXltc3BMTVpxN1c4bXk3ZXlKdEdBNWhIM1RVNjRSdXYy?=
 =?utf-8?B?dkpSYlNMMmZDUFMrQkxZUTU2a1JBenM1L01wMGZXZFRhQVhnTkcvcWZ1QnIw?=
 =?utf-8?B?Si95UUIvdzgrTkQyeE5vMWo5dXdEcEtpVE5EZzUzQlZTTnp6OER3SnB3OEh1?=
 =?utf-8?B?cmRtOXdXOCtnU0ZLajVTNnVOMGNBcEd5WkRLeVpOcWpkMUNicUpoK3hmTVRP?=
 =?utf-8?B?dGdueUtwb3M2cXhzVXB4N1N1R3JHenBnU3d5cldpeXV1eEQyMUpqR2Zpb05n?=
 =?utf-8?Q?jKKVLIkQ+qaZyaxPxEpFbJKhD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44ed090d-3a36-421c-1aca-08daf52cec79
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 06:10:52.4509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l/Jsa34PnLr8DqYmVW8u1cYE9htrtjzPLPvSz+Ahna35uHYOutc76t6Bz1sxBcCK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4930
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/13/23 09:58, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Wed, Jan 11, 2023 at 2:36 PM Jason Wang <jasowang@redhat.com> wrote:
>> On Mon, Jan 9, 2023 at 6:21 PM Gautam Dawar <gdawar@amd.com> wrote:
>>>
>>> On 12/14/22 12:15, Jason Wang wrote:
>>>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>>>
>>>>
>>>> On Wed, Dec 7, 2022 at 10:57 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>>>>> vDPA config opertions to handle get/set device status and device
>>>>> reset have been implemented.
>>>>>
>>>>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>>>>> ---
>>>>>    drivers/net/ethernet/sfc/ef100_vdpa.c     |   7 +-
>>>>>    drivers/net/ethernet/sfc/ef100_vdpa.h     |   1 +
>>>>>    drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 133 ++++++++++++++++++++++
>>>>>    3 files changed, 140 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>>> index 04d64bfe3c93..80bca281a748 100644
>>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>>> @@ -225,9 +225,14 @@ static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
>>>>>
>>>>>    static void ef100_vdpa_delete(struct efx_nic *efx)
>>>>>    {
>>>>> +       struct vdpa_device *vdpa_dev;
>>>>> +
>>>>>           if (efx->vdpa_nic) {
>>>>> +               vdpa_dev = &efx->vdpa_nic->vdpa_dev;
>>>>> +               ef100_vdpa_reset(vdpa_dev);
>>>> Any reason we need to reset during delete?
>>> ef100_reset_vdpa_device() does the necessary clean-up including freeing
>>> irqs, deleting filters and deleting the vrings which is required while
>>> removing the vdpa device or unloading the driver.
>> That's fine but the name might be a little bit confusing since vDPA
>> reset is not necessary here.
>>
>>>>> +
>>>>>                   /* replace with _vdpa_unregister_device later */
>>>>> -               put_device(&efx->vdpa_nic->vdpa_dev.dev);
>>>>> +               put_device(&vdpa_dev->dev);
>>>>>                   efx->vdpa_nic = NULL;
>>>>>           }
>>>>>           efx_mcdi_free_vis(efx);
>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>>> index a33edd6dda12..1b0bbba88154 100644
>>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>>> @@ -186,6 +186,7 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
>>>>>                             enum ef100_vdpa_mac_filter_type type);
>>>>>    int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs);
>>>>>    void ef100_vdpa_irq_vectors_free(void *data);
>>>>> +int ef100_vdpa_reset(struct vdpa_device *vdev);
>>>>>
>>>>>    static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
>>>>>    {
>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>>> index 132ddb4a647b..718b67f6da90 100644
>>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>>> @@ -251,6 +251,62 @@ static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
>>>>>           return false;
>>>>>    }
>>>>>
>>>>> +static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>>>> +{
>>>>> +       int i;
>>>>> +
>>>>> +       WARN_ON(!mutex_is_locked(&vdpa_nic->lock));
>>>>> +
>>>>> +       if (!vdpa_nic->status)
>>>>> +               return;
>>>>> +
>>>>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>>>>> +       vdpa_nic->status = 0;
>>>>> +       vdpa_nic->features = 0;
>>>>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
>>>>> +               reset_vring(vdpa_nic, i);
>>>>> +}
>>>>> +
>>>>> +/* May be called under the rtnl lock */
>>>>> +int ef100_vdpa_reset(struct vdpa_device *vdev)
>>>>> +{
>>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>> +
>>>>> +       /* vdpa device can be deleted anytime but the bar_config
>>>>> +        * could still be vdpa and hence efx->state would be STATE_VDPA.
>>>>> +        * Accordingly, ensure vdpa device exists before reset handling
>>>>> +        */
>>>>> +       if (!vdpa_nic)
>>>>> +               return -ENODEV;
>>>>> +
>>>>> +       mutex_lock(&vdpa_nic->lock);
>>>>> +       ef100_reset_vdpa_device(vdpa_nic);
>>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>> +static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>>>> +{
>>>>> +       int rc = 0;
>>>>> +       int i, j;
>>>>> +
>>>>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>>>>> +               if (can_create_vring(vdpa_nic, i)) {
>>>>> +                       rc = create_vring(vdpa_nic, i);
>>>> So I think we can safely remove the create_vring() in set_vq_ready()
>>>> since it's undefined behaviour if set_vq_ready() is called after
>>>> DRIVER_OK.
>>> Is this (undefined) behavior documented in the virtio spec?
>> This part is kind of tricky:
>>
>> PCI transport has a queue_enable field. And recently,
>> VIRTIO_F_RING_RESET was introduced. Let's start without that first:
>>
>> In
>>
>> 4.1.4.3.2 Driver Requirements: Common configuration structure layout
>>
>> It said:
>>
>> "The driver MUST configure the other virtqueue fields before enabling
>> the virtqueue with queue_enable."
>>
>> and
>>
>> "The driver MUST NOT write a 0 to queue_enable."
>>
>> My understanding is that:
>>
>> 1) Write 0 is forbidden
>> 2) Write 1 after DRIVER_OK is undefined behaviour (or need to clarify)
>>
>> With VIRTIO_F_RING_RESET is negotiated:
>>
>> "
>> If VIRTIO_F_RING_RESET has been negotiated, after the driver writes 1
>> to queue_reset to reset the queue, the driver MUST NOT consider queue
>> reset to be complete until it reads back 0 in queue_reset. The driver
>> MAY re-enable the queue by writing 1 to queue_enable after ensuring
>> that other virtqueue fields have been set up correctly. The driver MAY
>> set driver-writeable queue configuration values to different values
>> than those that were used before the queue reset. (see 2.6.1).
>> "
>>
>> Write 1 to queue_enable after DRIVER_OK and after the queue is reset is allowed.
>>
>> Thanks
> Btw, I just realized that we need to stick to the current behaviour,
> that is to say, to allow set_vq_ready() to be called after DRIVER_OK.

So, both set_vq_ready() and DRIVER_OK are required for vring creation 
and their order doesn't matter. Is that correct?

Also, will set_vq_ready(0) after DRIVER_OK result in queue deletion?

>
> It is needed for the cvq trap and migration for control virtqueue:
>
> https://www.mail-archive.com/qemu-devel@nongnu.org/msg931491.html
>
> Thanks
>
>
>>
>>> If so, can
>>> you please point me to the section of virtio spec that calls this order
>>> (set_vq_ready() after setting DRIVER_OK) undefined? Is it just that the
>>> queue can't be enabled after DRIVER_OK or the reverse (disabling the
>>> queue) after DRIVER_OK is not allowed?
>>>>> +                       if (rc)
>>>>> +                               goto clear_vring;
>>>>> +               }
>>>>> +       }
>>>>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
>>>>> +       return rc;
>>>>> +
>>>>> +clear_vring:
>>>>> +       for (j = 0; j < i; j++)
>>>>> +               if (vdpa_nic->vring[j].vring_created)
>>>>> +                       delete_vring(vdpa_nic, j);
>>>>> +       return rc;
>>>>> +}
>>>>> +
>>>>>    static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
>>>>>                                        u16 idx, u64 desc_area, u64 driver_area,
>>>>>                                        u64 device_area)
>>>>> @@ -568,6 +624,80 @@ static u32 ef100_vdpa_get_vendor_id(struct vdpa_device *vdev)
>>>>>           return EF100_VDPA_VENDOR_ID;
>>>>>    }
>>>>>
>>>>> +static u8 ef100_vdpa_get_status(struct vdpa_device *vdev)
>>>>> +{
>>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>> +       u8 status;
>>>>> +
>>>>> +       mutex_lock(&vdpa_nic->lock);
>>>>> +       status = vdpa_nic->status;
>>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>>> +       return status;
>>>>> +}
>>>>> +
>>>>> +static void ef100_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>>>>> +{
>>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>> +       u8 new_status;
>>>>> +       int rc;
>>>>> +
>>>>> +       mutex_lock(&vdpa_nic->lock);
>>>>> +       if (!status) {
>>>>> +               dev_info(&vdev->dev,
>>>>> +                        "%s: Status received is 0. Device reset being done\n",
>>>>> +                        __func__);
>>>>> +               ef100_reset_vdpa_device(vdpa_nic);
>>>>> +               goto unlock_return;
>>>>> +       }
>>>>> +       new_status = status & ~vdpa_nic->status;
>>>>> +       if (new_status == 0) {
>>>>> +               dev_info(&vdev->dev,
>>>>> +                        "%s: New status same as current status\n", __func__);
>>>>> +               goto unlock_return;
>>>>> +       }
>>>>> +       if (new_status & VIRTIO_CONFIG_S_FAILED) {
>>>>> +               ef100_reset_vdpa_device(vdpa_nic);
>>>>> +               goto unlock_return;
>>>>> +       }
>>>>> +
>>>>> +       if (new_status & VIRTIO_CONFIG_S_ACKNOWLEDGE &&
>>>>> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
>>>> As replied before, I think there's no need to check
>>>> EF100_VDPA_STATE_INITIALIZED, otherwise it could be a bug somewhere.
>>> Ok. Will remove the check against EF100_VDPA_STATE_INITIALIZED.
>>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
>>>>> +               new_status &= ~VIRTIO_CONFIG_S_ACKNOWLEDGE;
>>>>> +       }
>>>>> +       if (new_status & VIRTIO_CONFIG_S_DRIVER &&
>>>>> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
>>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER;
>>>>> +               new_status &= ~VIRTIO_CONFIG_S_DRIVER;
>>>>> +       }
>>>>> +       if (new_status & VIRTIO_CONFIG_S_FEATURES_OK &&
>>>>> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
>>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_FEATURES_OK;
>>>>> +               vdpa_nic->vdpa_state = EF100_VDPA_STATE_NEGOTIATED;
>>>> I think we can simply map EF100_VDPA_STATE_NEGOTIATED to
>>>> VIRTIO_CONFIG_S_FEATURES_OK.
>>>>
>>>> E.g the code doesn't fail the feature negotiation by clearing the
>>>> VIRTIO_CONFIG_S_FEATURES_OK when ef100_vdpa_set_driver_feature fails?
>>> Ok.
>>>> Thanks
>>> Regards,
>>>
>>> Gautam
>>>
