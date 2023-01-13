Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E8A668E40
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240425AbjAMGuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237529AbjAMGtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:49:47 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A91C7CDE8;
        Thu, 12 Jan 2023 22:34:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ln5SBc1rZXB4yaP/lca+/OPqHa9GgOP/pQDsK4WRiEsfxhY9ETIh5r3vYIZcnlKWIRyTfS+nTaTj2PiTqvgRc6VCvf1CASptQ9s7XUy9Y0+WzZY/S1V8n/kLGx6Focrx2XrdMJ8SI1CsXtpqmmNSiEv0OXh7o3TsVALAw/V+5569YPoRNHNUoDVcxLn07sPDYJz0wwh1TxRdvci1HBRlR8J70As9scck7eMqhUPbymEJzKK3VO+xiMkF9ApAkcTGBE5jW1a+gZ2rf2GHg0AXBnn6bX7Jdl+OA4skcMEfeWEAK6ceiSy/hncO5q+lYFdSZdwIkxQ/3wjMLQ6U3A00EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4XtfgneTZsST4o4XCYfDvxxjrCym/GXQ5GSpWbb234=;
 b=XnUjrPeZKVHoRzyqkh4GVvs8sRQnySqNyGhxIw/SwKbHZvpRB5nBrbHF4GLEKLtOm7Ft/L35yj9QQl3rm6ig/q1k6vCb1hcwetuJQSU8vZSPhJMS9ZgVsqShVTK+a/AyoON++pqKZkJXGS328lajFE3Q7glfyR/KY/SJqLBom+Vc+yGwHHDAnnAQBPexRkX3c3XPgE0ajJnue2zobeJOQq0eRFhdyHL0hUa2xzgmZyIpdHSEJHblWPP96S2iC7XdwITQkOxRYqOI4cqmZTCZYe4exv/cn0ostnlkP8KFSnCl3cWr3alq8yNkbYnUwOpaCRuMrLJXY5RJW86GpVaB5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g4XtfgneTZsST4o4XCYfDvxxjrCym/GXQ5GSpWbb234=;
 b=Ac4uf1ga5BQewS+c2/7B82PEPvKlnTyFIYDJyLBGwbKpZ82BBXMGuO91YQcA9+tUj2tt11iXf2308u++tPfswe9UxVnluw+GX4GBv1EfVl6z2wNqPxXRaLzIbAHF/Nv1qkWqo1aEBridRfzQ8C5wRUl3oJEW7YPv6cDtPBBwB94=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 06:33:18 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::e36e:5151:6912:18e]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::e36e:5151:6912:18e%5]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 06:33:18 +0000
Message-ID: <71066e12-1c5c-c226-bfb7-67bea171a4e1@amd.com>
Date:   Fri, 13 Jan 2023 12:03:06 +0530
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
 <289dc054-4cb7-e31c-69b4-b02a62a2fe16@amd.com>
 <CACGkMEv6vy31646YfLYEyLqeeJcn1sKnUy9z_9++2dkTSAEPPw@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEv6vy31646YfLYEyLqeeJcn1sKnUy9z_9++2dkTSAEPPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0169.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:de::13) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|SA0PR12MB4349:EE_
X-MS-Office365-Filtering-Correlation-Id: e3cb3f2e-6af5-4e88-89ef-08daf5300ed9
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: do5chUgOjW8Nkzo5XJfxwRmA6C03Fz+f8E+DAfdVcsHI0bOnRponYpW3iVF3glmL4bxAcoYRmkC9LCOeDXpQS3aeDtYKaLjpzFgg7BZFWZAtbNNEV3kocqgkUXDRMr8xH50IKHsApDZEgYubWxRLgEXdw4/ss8qB0DTeqv08dj63Tia9XhrnfiJVTX/TYEhsJh9qd1pT9qyodBbCEAR07VZZ8d/89g9DPdTQmEGYLKiyKX7gJMSP+tj4d6KQ3UOL1Z9c9mevfwZSDr7/Si98XqxeAhIJqYFIbyx5VimjdQglNUZPGV9XlvdCN6tvLb+lRfdvv0yPYsH1PiZ3UFbKiFfofWb49MN9cISvWiLTVqlEsnJzRLiKZx916fYNwELzBZpYOrTP/Bw4lK7HXgNntRy6rAhiuMqIubGnIg8M2cSzSSLObdtT7OVoLyWz7RxeIIOb6e2jA3Pl7fadclj9MtckbIZ3jdlhBcLehdDctw7cStanyMS9/nMZGp1JSuRAoSiRhb/V7e+bDkd3PXJcW/zzsgvj8G7lNUx34FGolgik96XyldeiWKLc/A3gvjWKva3bCjqCik0Qg8neN5oAWL305tQ0JrSCNSsmWp+ibJP9ufKSw6xdXn+SI4EqltNh9jFNiXikHz431jJ3DgrTSk6N6Zky5Vg295zDjG+ej60BS0tYn38kp1jHj621JkxmNkHSaGkL3e3TV5WdS418yDSyiJzuGc5C5GPsUaF1GSdX7jxSETOTXetkj9xLxtksPqHIr5raz9XtFZD7lvvWrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199015)(8936002)(26005)(2906002)(5660300002)(41300700001)(7416002)(66556008)(4326008)(8676002)(316002)(66476007)(66946007)(6916009)(30864003)(54906003)(6512007)(38100700002)(2616005)(31686004)(186003)(966005)(31696002)(36756003)(83380400001)(53546011)(6506007)(478600001)(6666004)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHE1TFRYTjEvcU8zNzFtbzk5SkMzVWg3eVIyS1hrL2doekNJUmxhdFNzdFMw?=
 =?utf-8?B?WVJnbG9DQllJNGNaVEJyeEcvZjI1bnBGcC80Yy9PQnh5aGhjNGdtY2JHeHln?=
 =?utf-8?B?N2tJbWhaQk1ZWTBwemIxbzQyMytRcm9vZ3oxQUFONGluRXhoMW5YbzdabjVQ?=
 =?utf-8?B?eWt0UmFTQ1ZxTzFpbUJsUFkvT0tkZmJzMExPd0VOQTJ5a1VZWmJ3cXpDRmly?=
 =?utf-8?B?Wm9NYlJXK3VwUys5UlFpcVdFVDQzMmJTb3p6YkdKZ1Y1LzRQSU93MGx4NmU0?=
 =?utf-8?B?R0YyZ09DcnhTMjJVMkg1dUZFdXNialNoTU1HcmU1dUVMeGF4b2xZdnNrTVJR?=
 =?utf-8?B?TGtOQUx2NTl1QUF6T080YnJkRG44QlBnZVZYdjZUazc3Y1Y1QzNzSE9wNStG?=
 =?utf-8?B?SDlNeWNxM05nM2hvc1AzaEFLVjh1bytZREU2emkxcXc4OGdTNGhFQVJtK0J3?=
 =?utf-8?B?ZElJNmloTUs5ajFkVyttT09OWWxKZk15b3REak1lZEpuVUgzZjhSei9TSG5t?=
 =?utf-8?B?ZUtNT0dTRXBLVW1oQkxjdzB3bWpQTEdrUkQydVRjeTJHSGNJRWoxTE1OZjdU?=
 =?utf-8?B?Nk9qTkJKdklSTTVXWlJpdSt1SFIyd0pQamxvbDhyaXFkUTBpMXNWNUJXencv?=
 =?utf-8?B?andJWnhCQ0pDRG8yN3BiallSa09Hd290Uk56N0VlclFBaFR6M1BZR3RPa3dT?=
 =?utf-8?B?QU0rTVJLQzVDUzNuWVJkSFFmdTUxMmJJek9vRkx6UHFXS1IwK1NpZ3daYkdi?=
 =?utf-8?B?Vkw3eXF1U3N2dEYzYnBvcStvUDczaXZTb0pScCtQeHBHNkYwbzNsOThIV2JX?=
 =?utf-8?B?d2RRMVF6MkNzd1ZkM3F5cGFnaDU5REovTDRCdHhkZTB3NG44UHh0OXdnQmlY?=
 =?utf-8?B?NlJ4V1BoUEJDc04vU01GUFVzTCt3NXBvMTcxWVdLQWsyVlU0dk5pOEdjcHN2?=
 =?utf-8?B?czJXTWxhcXNjQVRuQlo1T1psZzJIcW9JUi9Sb1ZuaTQ5Vmk5Yjk1dlNRTEFL?=
 =?utf-8?B?RHliS09KWkxsZTUwL1RFdEVpbTZHZW5QUW40bDNWMXZPY3prRUVvOWNDcEh5?=
 =?utf-8?B?TUJtclFQeGZqZlg2UzU2RmZOaUZmSHVIeDFvZXgrRGhtVWV2S3FtbzNXUzBm?=
 =?utf-8?B?VFQwTnE5QTI1RE1Tcy9KWk1vTmJoTzNKK1NSNkpRdVEzSlVCTlE3dFJmOW9N?=
 =?utf-8?B?UEQ0aENCWFVyZTMrWVpTdHBRNW1rZmhPRHd3VHBuMTVJcjNsOXZ5RDBoeWF0?=
 =?utf-8?B?UlZJQjBjK1ZuQ3NkT2MrYmVubWd2bnV5K0hVNXpkaVJKUElzYXg0T0V0QllK?=
 =?utf-8?B?RG44dHlNZDY4S2F0N3NkVEM1bUlWcnI2azg4UUFRaFBmdlBTb05sZ09neDRD?=
 =?utf-8?B?UXlzeXE4OVRGMXdsc0Q1NE5zOTZtL2o4NGRFTGRFYzB6MklMRmZzVE15UG94?=
 =?utf-8?B?RHpwMnBrVmdZeGVMZUlpWjIyZ0QyYnFvRU5iSWpiekZSMU9GbmdGUEg2UGhp?=
 =?utf-8?B?MlVwQ2FDbXJ1V2hjeHhyTzFEYmV1RU95a1FodHJuVmZEb3JMWEp4R0NXOVpG?=
 =?utf-8?B?cTgzOU5YeC9EN3ZjSjdvdzBLZG1lVDJ1czV1c2Vhdkl3NGVRVi9YUFhzckxK?=
 =?utf-8?B?YStFMjhhMU5CS092R05PVWw4c0hmN3dCSUN6U1EwUXF2R2tjS1JBVFVYNGp4?=
 =?utf-8?B?RUNRb2VRR3RsZ3dpZm45c0FtVm15UCtXdlM4bS9nOXliZGhTY3VRVktpRmtT?=
 =?utf-8?B?SFFMRGRIcmN1ZEpxSUtrRmVFTzFBQ1NIQkNTaHFhQlN2V25aajFGbFM2K3NR?=
 =?utf-8?B?WE5UVWFXVlNpaUFwUWR4WkRSNHREa1R5bU5XeVl3Nk9IV2x0YmtqOSt2Ty8y?=
 =?utf-8?B?ckZ0dHVYakRnblFIOHNkSkdCY2g5ZnhuYzhkVldQbzk5ckNQSGFJQU5jMUpT?=
 =?utf-8?B?MHlKVENTWlFQeG5WZVQrRGVkbHB4VjREWlZIazNZS2RKZ212bDBpTmd3NnRP?=
 =?utf-8?B?NDdNeGRqbG45UlpsNmozbyt0NWZwL2QxakVjNDJkaExOWVBIcXlkOHcwemNo?=
 =?utf-8?B?MEd6d2NwOE5LbmhUR0ZwN1g2VFV3RzUxdEpWS1dmbXFUam9NS0MxV1BDbCtX?=
 =?utf-8?Q?0byw2WGnGhmriu3insMbwh3J/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3cb3f2e-6af5-4e88-89ef-08daf5300ed9
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 06:33:18.3813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HO049Dv3b36O3oytq1QmuxR+DOgAlFyezjt/H8xNe7MQ+sUiegKxN1BXTHa6zW3K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/13/23 11:50, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Fri, Jan 13, 2023 at 2:11 PM Gautam Dawar <gdawar@amd.com> wrote:
>>
>> On 1/13/23 09:58, Jason Wang wrote:
>>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>>
>>>
>>> On Wed, Jan 11, 2023 at 2:36 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> On Mon, Jan 9, 2023 at 6:21 PM Gautam Dawar <gdawar@amd.com> wrote:
>>>>> On 12/14/22 12:15, Jason Wang wrote:
>>>>>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>>>>>
>>>>>>
>>>>>> On Wed, Dec 7, 2022 at 10:57 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>>>>>>> vDPA config opertions to handle get/set device status and device
>>>>>>> reset have been implemented.
>>>>>>>
>>>>>>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>>>>>>> ---
>>>>>>>     drivers/net/ethernet/sfc/ef100_vdpa.c     |   7 +-
>>>>>>>     drivers/net/ethernet/sfc/ef100_vdpa.h     |   1 +
>>>>>>>     drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 133 ++++++++++++++++++++++
>>>>>>>     3 files changed, 140 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>>>>> index 04d64bfe3c93..80bca281a748 100644
>>>>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>>>>> @@ -225,9 +225,14 @@ static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
>>>>>>>
>>>>>>>     static void ef100_vdpa_delete(struct efx_nic *efx)
>>>>>>>     {
>>>>>>> +       struct vdpa_device *vdpa_dev;
>>>>>>> +
>>>>>>>            if (efx->vdpa_nic) {
>>>>>>> +               vdpa_dev = &efx->vdpa_nic->vdpa_dev;
>>>>>>> +               ef100_vdpa_reset(vdpa_dev);
>>>>>> Any reason we need to reset during delete?
>>>>> ef100_reset_vdpa_device() does the necessary clean-up including freeing
>>>>> irqs, deleting filters and deleting the vrings which is required while
>>>>> removing the vdpa device or unloading the driver.
>>>> That's fine but the name might be a little bit confusing since vDPA
>>>> reset is not necessary here.
>>>>
>>>>>>> +
>>>>>>>                    /* replace with _vdpa_unregister_device later */
>>>>>>> -               put_device(&efx->vdpa_nic->vdpa_dev.dev);
>>>>>>> +               put_device(&vdpa_dev->dev);
>>>>>>>                    efx->vdpa_nic = NULL;
>>>>>>>            }
>>>>>>>            efx_mcdi_free_vis(efx);
>>>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>>>>> index a33edd6dda12..1b0bbba88154 100644
>>>>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>>>>> @@ -186,6 +186,7 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
>>>>>>>                              enum ef100_vdpa_mac_filter_type type);
>>>>>>>     int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs);
>>>>>>>     void ef100_vdpa_irq_vectors_free(void *data);
>>>>>>> +int ef100_vdpa_reset(struct vdpa_device *vdev);
>>>>>>>
>>>>>>>     static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
>>>>>>>     {
>>>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>>>>> index 132ddb4a647b..718b67f6da90 100644
>>>>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>>>>> @@ -251,6 +251,62 @@ static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
>>>>>>>            return false;
>>>>>>>     }
>>>>>>>
>>>>>>> +static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>>>>>> +{
>>>>>>> +       int i;
>>>>>>> +
>>>>>>> +       WARN_ON(!mutex_is_locked(&vdpa_nic->lock));
>>>>>>> +
>>>>>>> +       if (!vdpa_nic->status)
>>>>>>> +               return;
>>>>>>> +
>>>>>>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>>>>>>> +       vdpa_nic->status = 0;
>>>>>>> +       vdpa_nic->features = 0;
>>>>>>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
>>>>>>> +               reset_vring(vdpa_nic, i);
>>>>>>> +}
>>>>>>> +
>>>>>>> +/* May be called under the rtnl lock */
>>>>>>> +int ef100_vdpa_reset(struct vdpa_device *vdev)
>>>>>>> +{
>>>>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>>>> +
>>>>>>> +       /* vdpa device can be deleted anytime but the bar_config
>>>>>>> +        * could still be vdpa and hence efx->state would be STATE_VDPA.
>>>>>>> +        * Accordingly, ensure vdpa device exists before reset handling
>>>>>>> +        */
>>>>>>> +       if (!vdpa_nic)
>>>>>>> +               return -ENODEV;
>>>>>>> +
>>>>>>> +       mutex_lock(&vdpa_nic->lock);
>>>>>>> +       ef100_reset_vdpa_device(vdpa_nic);
>>>>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>>>>> +       return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>>>>>> +{
>>>>>>> +       int rc = 0;
>>>>>>> +       int i, j;
>>>>>>> +
>>>>>>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>>>>>>> +               if (can_create_vring(vdpa_nic, i)) {
>>>>>>> +                       rc = create_vring(vdpa_nic, i);
>>>>>> So I think we can safely remove the create_vring() in set_vq_ready()
>>>>>> since it's undefined behaviour if set_vq_ready() is called after
>>>>>> DRIVER_OK.
>>>>> Is this (undefined) behavior documented in the virtio spec?
>>>> This part is kind of tricky:
>>>>
>>>> PCI transport has a queue_enable field. And recently,
>>>> VIRTIO_F_RING_RESET was introduced. Let's start without that first:
>>>>
>>>> In
>>>>
>>>> 4.1.4.3.2 Driver Requirements: Common configuration structure layout
>>>>
>>>> It said:
>>>>
>>>> "The driver MUST configure the other virtqueue fields before enabling
>>>> the virtqueue with queue_enable."
>>>>
>>>> and
>>>>
>>>> "The driver MUST NOT write a 0 to queue_enable."
>>>>
>>>> My understanding is that:
>>>>
>>>> 1) Write 0 is forbidden
>>>> 2) Write 1 after DRIVER_OK is undefined behaviour (or need to clarify)
>>>>
>>>> With VIRTIO_F_RING_RESET is negotiated:
>>>>
>>>> "
>>>> If VIRTIO_F_RING_RESET has been negotiated, after the driver writes 1
>>>> to queue_reset to reset the queue, the driver MUST NOT consider queue
>>>> reset to be complete until it reads back 0 in queue_reset. The driver
>>>> MAY re-enable the queue by writing 1 to queue_enable after ensuring
>>>> that other virtqueue fields have been set up correctly. The driver MAY
>>>> set driver-writeable queue configuration values to different values
>>>> than those that were used before the queue reset. (see 2.6.1).
>>>> "
>>>>
>>>> Write 1 to queue_enable after DRIVER_OK and after the queue is reset is allowed.
>>>>
>>>> Thanks
>>> Btw, I just realized that we need to stick to the current behaviour,
>>> that is to say, to allow set_vq_ready() to be called after DRIVER_OK.
>> So, both set_vq_ready() and DRIVER_OK are required for vring creation
>> and their order doesn't matter. Is that correct?
> Yes.
>
>> Also, will set_vq_ready(0) after DRIVER_OK result in queue deletion?
> I think it should be treated as suspended or stopped. Since the device
> should survive from kicking the vq even if the driver does
> set_vq_ready(0).
Ok. Is it expected that a queue restart (set_vq_ready(0) followed by 
set_vq_ready(1)) will start the queue from the last queue configuration 
when VIRTIO_F_RING_RESET isn't negotiated?
>
> Thanks
>
>>> It is needed for the cvq trap and migration for control virtqueue:
>>>
>>> https://www.mail-archive.com/qemu-devel@nongnu.org/msg931491.html
>>>
>>> Thanks
>>>
>>>
>>>>> If so, can
>>>>> you please point me to the section of virtio spec that calls this order
>>>>> (set_vq_ready() after setting DRIVER_OK) undefined? Is it just that the
>>>>> queue can't be enabled after DRIVER_OK or the reverse (disabling the
>>>>> queue) after DRIVER_OK is not allowed?
>>>>>>> +                       if (rc)
>>>>>>> +                               goto clear_vring;
>>>>>>> +               }
>>>>>>> +       }
>>>>>>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
>>>>>>> +       return rc;
>>>>>>> +
>>>>>>> +clear_vring:
>>>>>>> +       for (j = 0; j < i; j++)
>>>>>>> +               if (vdpa_nic->vring[j].vring_created)
>>>>>>> +                       delete_vring(vdpa_nic, j);
>>>>>>> +       return rc;
>>>>>>> +}
>>>>>>> +
>>>>>>>     static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
>>>>>>>                                         u16 idx, u64 desc_area, u64 driver_area,
>>>>>>>                                         u64 device_area)
>>>>>>> @@ -568,6 +624,80 @@ static u32 ef100_vdpa_get_vendor_id(struct vdpa_device *vdev)
>>>>>>>            return EF100_VDPA_VENDOR_ID;
>>>>>>>     }
>>>>>>>
>>>>>>> +static u8 ef100_vdpa_get_status(struct vdpa_device *vdev)
>>>>>>> +{
>>>>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>>>> +       u8 status;
>>>>>>> +
>>>>>>> +       mutex_lock(&vdpa_nic->lock);
>>>>>>> +       status = vdpa_nic->status;
>>>>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>>>>> +       return status;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void ef100_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>>>>>>> +{
>>>>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>>>> +       u8 new_status;
>>>>>>> +       int rc;
>>>>>>> +
>>>>>>> +       mutex_lock(&vdpa_nic->lock);
>>>>>>> +       if (!status) {
>>>>>>> +               dev_info(&vdev->dev,
>>>>>>> +                        "%s: Status received is 0. Device reset being done\n",
>>>>>>> +                        __func__);
>>>>>>> +               ef100_reset_vdpa_device(vdpa_nic);
>>>>>>> +               goto unlock_return;
>>>>>>> +       }
>>>>>>> +       new_status = status & ~vdpa_nic->status;
>>>>>>> +       if (new_status == 0) {
>>>>>>> +               dev_info(&vdev->dev,
>>>>>>> +                        "%s: New status same as current status\n", __func__);
>>>>>>> +               goto unlock_return;
>>>>>>> +       }
>>>>>>> +       if (new_status & VIRTIO_CONFIG_S_FAILED) {
>>>>>>> +               ef100_reset_vdpa_device(vdpa_nic);
>>>>>>> +               goto unlock_return;
>>>>>>> +       }
>>>>>>> +
>>>>>>> +       if (new_status & VIRTIO_CONFIG_S_ACKNOWLEDGE &&
>>>>>>> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
>>>>>> As replied before, I think there's no need to check
>>>>>> EF100_VDPA_STATE_INITIALIZED, otherwise it could be a bug somewhere.
>>>>> Ok. Will remove the check against EF100_VDPA_STATE_INITIALIZED.
>>>>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
>>>>>>> +               new_status &= ~VIRTIO_CONFIG_S_ACKNOWLEDGE;
>>>>>>> +       }
>>>>>>> +       if (new_status & VIRTIO_CONFIG_S_DRIVER &&
>>>>>>> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
>>>>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER;
>>>>>>> +               new_status &= ~VIRTIO_CONFIG_S_DRIVER;
>>>>>>> +       }
>>>>>>> +       if (new_status & VIRTIO_CONFIG_S_FEATURES_OK &&
>>>>>>> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_INITIALIZED) {
>>>>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_FEATURES_OK;
>>>>>>> +               vdpa_nic->vdpa_state = EF100_VDPA_STATE_NEGOTIATED;
>>>>>> I think we can simply map EF100_VDPA_STATE_NEGOTIATED to
>>>>>> VIRTIO_CONFIG_S_FEATURES_OK.
>>>>>>
>>>>>> E.g the code doesn't fail the feature negotiation by clearing the
>>>>>> VIRTIO_CONFIG_S_FEATURES_OK when ef100_vdpa_set_driver_feature fails?
>>>>> Ok.
>>>>>> Thanks
>>>>> Regards,
>>>>>
>>>>> Gautam
>>>>>
