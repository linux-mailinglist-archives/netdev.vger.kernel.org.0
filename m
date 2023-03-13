Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAD36B7EB6
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjCMRFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjCMRFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:05:20 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518A67D09F;
        Mon, 13 Mar 2023 10:04:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2c/ezHj6uu5y2jw9lwhDFqLRjKvYpiNA9n4qepQrtFgySfxjnPpPn8UKFwfGv3YSOmAb+1dpSj5TV8veA2GPe8e+yiw2rdY/SnQQvcTGegJGkzbeNM2W9bHqDZVojA30CWLwjUM/x7DkS1V/DuyrT1yb2qy+QZUBWQz10tBfU9NpK0BH0RU/p13OT4iVUHMpnrF3AMX/To9nNZsEJRi+6/ea806KCGyKySQJSW4nwHJCalVrNwAQLlPmq0NNwqabZ7k0cBuIeqlopIulNrREXl2wQhYFtNtFBIpZSXdEHXdfzCaNgtADn0v2kRuML0KDW2Z0MtnQJd0YC3ifKZcGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5WSkfHT8ATthvEX66XPi+k/JczSKSx9O0mkw2IuVxk=;
 b=OX/WvbiLBInICZc1tphPBbWVAj9glF23hhCZMONSowAdWap1HCLqs8+koeHqm9hbJqxVpGbdy+KZL+X4Omvnt91MM/VGVsYCa3NXWXE+esy0WlgnnAKGx2nEeujceulU3eMQTNP/OPGCwgUe1lCS867rRzAoOlII7clIM5RzAAxenWn5G3cX9jfjpTVEwT8rddTHVCbKU+sd4PT0UXlbWf6dxdOs1uNNbLbXEHoOxcecA21FdnXUaUQlRrbhttkPW0zvRFCmVwKN+MgOuaPQqNR9dzL9VWOZsNBNiZ/N8Z9MoONaEFGS/18xZq4B+xsJxlArq3qAmV53XL2Uet3Kaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5WSkfHT8ATthvEX66XPi+k/JczSKSx9O0mkw2IuVxk=;
 b=MmF2tICeeQDKXizjuHhzdwUdIEdFrtHfGpemZ97jxOQb73mR43RyA4tiSkKNsRkEocYKPzCgNvwEluBDbEhBJy+uTbHn0VpUt592rbxxDxfRGXhmkvF/MTl/qSyK70Go7Tvwu2T1071No5ci4pMuIyg0qccsduleToZAZQ6xl+c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by IA1PR12MB6114.namprd12.prod.outlook.com (2603:10b6:208:3ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 17:03:36 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 17:03:35 +0000
Message-ID: <9d0065d2-4047-8d95-011f-5d0de1e5454c@amd.com>
Date:   Mon, 13 Mar 2023 22:33:22 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 08/14] sfc: implement vdpa vring config
 operations
Content-Language: en-US
To:     Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        jasowang@redhat.com, Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230307113621.64153-1-gautam.dawar@amd.com>
 <20230307113621.64153-9-gautam.dawar@amd.com> <ZAjAfoWwgVxsndgD@gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <ZAjAfoWwgVxsndgD@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0158.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::11) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|IA1PR12MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: f746dbd0-0bcb-4fd6-4754-08db23e4e1e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qbm0DcXrqJ7HQBm+ptlW3wIsNGV9lsQjXHqDwFbCo57TpAkkM4HhQOJ7FRWJAxVy9qym7dRqzxSA6TLpTMtCvpnNj5yBrWOJpl5C14nW4afPq+Y07YEeRwmAAW2Ha/EatspEmzKAAmQbst3GC/756XdZmAyNjUs4w4thPjZSzxrqYYWclL6DOBbsxCxX2lhcfW/EVzLsh4xv319VjCgp6xxcKI60UnIktPSOWC69ohyspjUxL2VCGW28I7UuKPbybKyqSNulmormvsMFf3vBzn8gWBoKxQQnqbnJF4Oq2PBGE/hAXP0t6noZSfnubYuuyXPiIdLvMJhXA7MGMjlXJ5VDCxTGlCcEwmewbK9ds12gQM9pw58fwh/IZjjKsD3S+Btpy9+KA4cnwcH2/BdOFZhcm5Qg4OCT+q2Iqu6LugPoUaWcjnIizeeqhSx+aI0cPOYRvb/uBi7mv6hpfjEoAzpxmoLpob+dYE+iDTiPLZt3DfdJ8aKL8u2+ROQaw+UlcteUGO/WGEXEMvMKE75bK4jPD7xup6IasOgMF470wBF27xySo4y3/XQTXrNE6j3jHj/oADsMrdw8++2JYzHpefd6GCezj+zNBFxpUolNTEjc6P4I0KvXrrlo8XEmwt3YOY4EcxYXUv/WYoivxoFQJi7tFJ/PyFZjnVXk77+4VA6i7lcInTyIkv2uq1jysvlkmCqHVRG8ZGrHcoFVdXgl5pePe257EECK139Ak0SVQH2iH4UTuZjDyXp/jZUZfUbM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199018)(921005)(2906002)(41300700001)(66476007)(66556008)(8676002)(478600001)(316002)(31696002)(6636002)(66946007)(110136005)(36756003)(5660300002)(38100700002)(6486002)(30864003)(53546011)(26005)(6512007)(6506007)(2616005)(186003)(31686004)(7416002)(6666004)(8936002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0RHQVZRM3lFNXBTMWczWVBxZ0NVOFgwNllObExGTnJtbExjOXFkRG42SDdV?=
 =?utf-8?B?NkE0SDk3NHFoN3laYUp0Sm9reWk5MTNPWENEQXhTQ0J3ank2MFlJN2lqakxp?=
 =?utf-8?B?SE5PeU0yRFBYUnNTcTNEV1FUWC9vdmVheG4zbWlDbTc3c0o3dFR5eHE4QWdG?=
 =?utf-8?B?bXAzT09WelhEd1p5ekJGYWNFRjR3UHV3LzB0UDJaY2w4bDhzNmlkNGxUb2xW?=
 =?utf-8?B?WEUvVUJPZEIzRzZUT2p0cm4xMkRsT1hzQ0MxdzdCLy9NTHIzNS9OVy9vaTVJ?=
 =?utf-8?B?dXpuU1pocTVMcG1hOEZOSjhIcDdYa2tJS2sxZmE3Z2R3V3FIN0dTSWZvTlR5?=
 =?utf-8?B?S1M4cTBQVnpOM1BSRDBvNzRuMDRQZ2FoVi90ODZsUUFHelg5WnNmV2lVT2Jv?=
 =?utf-8?B?NytqVXpFbThnMDdlMDU0cnpFWjAwQ3AzTENOVExEWFZyd2EzbHNVN1ZkeVhz?=
 =?utf-8?B?eTBCRzJnRlIrS0VadkNmZ2dRaFpUTmw3MndzcEl1VGI3R3F4SGk1OG9vZ1ZL?=
 =?utf-8?B?cTdGZ0xST2JMSHNHbFBaM1JMWndkTlpNOU9oaHE4cmM4S1lsYXZSWlFvZkJP?=
 =?utf-8?B?VS9Yejkva2s0ZTE0bGVMNkpUYnBzeFFibXdNdE9CWWdRSk9ObmloQnozNFU2?=
 =?utf-8?B?bjg2eUs3dGJpNE8zSU8vdFhKaXZKcFFmMFduaHlvNVJ6L3ViRDZzSEpPS2FK?=
 =?utf-8?B?SjhsU2NwcnVxMlJoTWZqeXI5NTBNa09uaGZEK3VjOW1uc0NTUHhMMnZ4OFFm?=
 =?utf-8?B?aUptWGpTVzRaS0t5RlhlVDR5a3JIdXUzU05qSnNpQ1d4N3hDMTh1WGRVWVBk?=
 =?utf-8?B?SHFpYndPdTc3b0hnVnRYK0F0OWxCRjRRaGhhN2plSkswVDNqN2pSZXpNTisr?=
 =?utf-8?B?eklVY2lKRklCNldsL0YrSUxxTXVwejlKQlZWbzRSSDNKbkJhdjAxZEg1UURM?=
 =?utf-8?B?bkxtaCtDclpFb01Md1lSdVJsdlVLaUszaFRFSlJSQVJtY1FkZUlQU3BVZU9a?=
 =?utf-8?B?ZURSNUtST2ZDa1l0MGlXaDB0UC9SVTY2K3lDNmlSZUVEWm5XVy9YSTMxdjQ5?=
 =?utf-8?B?ay9reThlN0x0S0pjMVpQOHo4ck8xdjQ1K2lGZWZlQWZQM0ZhZURrTWdqSTNh?=
 =?utf-8?B?OWF1dnFjQlNhSFFnMTA3a3pvQkJCaGxlclprNER5Mndpd01jSjJVSk0xNHFs?=
 =?utf-8?B?cGtZOUo5bVdSci9UelZ2Y0FTb1VPUzlWc05FOHpHcFR2NWV5bGxiY3ptT3py?=
 =?utf-8?B?U1pueVFoVHVOWmRYVTQyZFRtc3UwWk11dGY3Qm16WDJVellnVndDYjlsV2sr?=
 =?utf-8?B?dytQLyt6RnkrTkdGaHJURDMxZ2dVeitISWtBNndwYVNzR3plU0JCZjBjL081?=
 =?utf-8?B?Yk15VFRNOVFQbzZ0d1pQVTFaY2VwUENoWUMxSDNLdWZhei93elM3Qms5NTEx?=
 =?utf-8?B?KzRsNUFuUUhQOTZHU2JPTi96dDZBWmNaZXFvOWV6WEVZN1BWOVYrSE5lZzNh?=
 =?utf-8?B?dE1GYlhkb1JiaFNGSU8yMWtuK2ZOZnU5cEJNdEppbTRCOVI1NU9JbFpad0pw?=
 =?utf-8?B?NTFmVkQ3M2VvWnhRSWF6VTBtMHNRb0x6dCtZSHVUSHlCeGdvTGI1cCt1YlMw?=
 =?utf-8?B?VE9HWXhPajFlSUwvcGJkeElRNHNHblJNYWgxd2FVaHA2K0U2d1Y1cTBFaklT?=
 =?utf-8?B?YVh2UzdzTDhxYkg0OWJJRzZCT1RQWUI4ZEk5RWt6U1ZmM1pZRlFQdCtCWVND?=
 =?utf-8?B?c2o3NDk4ejF4SW9JalRJY283ellyNnFqSUtFcFp6SklBSnBpc2JNT1cwUGx1?=
 =?utf-8?B?ZzVNY1E1SkRpcnVRRFIzaVhpdFFubkdhOFIyMS91ZHNlajRmS0xiaXA2RHl1?=
 =?utf-8?B?dFV2OTh3dXNDeTYvVy9VbEdJT3RRV3hiaS96U1lmVDQ4WTI3dUluME9mQVRo?=
 =?utf-8?B?SjRScEY0d0VaNmRtV29qSmYvVUtiejlWZDZzM3hXSnpEdENGdXFFd3J2bUU1?=
 =?utf-8?B?NkppS2JLQ0ZXK0xYMllCWHN2Nk51K3MwZk04WmVwVWRKS0dUajlTdzlyNGl5?=
 =?utf-8?B?Y1IraWZnNzZZb2VwMDhvVi9wTEdjWUVobmVSVWhESmt3SDRtN3c0dmpZRXls?=
 =?utf-8?Q?tmNwUoiuE+z57ZlTk/SiS3NXi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f746dbd0-0bcb-4fd6-4754-08db23e4e1e0
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 17:03:35.8250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k37iqkKZPkdPXgWfalQ3SkKtZTEQVTYv8vHH8se00dI6oQRfjSFygoeidgoW24C8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6114
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/8/23 22:36, Martin Habets wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Tue, Mar 07, 2023 at 05:06:10PM +0530, Gautam Dawar wrote:
>> This patch implements the vDPA config operations related to
>> virtqueues or vrings. These include setting vring address,
>> getting vq state, operations to enable/disable a vq etc.
>> The resources required for vring operations eg. VI, interrupts etc.
>> are also allocated.
>>
>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>> ---
>>   drivers/net/ethernet/sfc/ef100_vdpa.c     |  46 +++-
>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |  54 +++++
>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 275 ++++++++++++++++++++++
>>   3 files changed, 374 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> index 4c5a98c9d6c3..c66e5aef69ea 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> @@ -14,6 +14,7 @@
>>   #include "ef100_vdpa.h"
>>   #include "mcdi_vdpa.h"
>>   #include "mcdi_filters.h"
>> +#include "mcdi_functions.h"
>>   #include "ef100_netdev.h"
>>
>>   static struct virtio_device_id ef100_vdpa_id_table[] = {
>> @@ -47,12 +48,31 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data)
>>        return rc;
>>   }
>>
>> +static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
>> +{
>> +     /* The first VI is reserved for MCDI
>> +      * 1 VI each for rx + tx ring
>> +      */
>> +     unsigned int max_vis = 1 + EF100_VDPA_MAX_QUEUES_PAIRS;
>> +     unsigned int min_vis = 1 + 1;
>> +     int rc;
>> +
>> +     rc = efx_mcdi_alloc_vis(efx, min_vis, max_vis,
>> +                             NULL, allocated_vis);
>> +     if (!rc)
>> +             return rc;
>> +     if (*allocated_vis < min_vis)
>> +             return -ENOSPC;
>> +     return 0;
>> +}
>> +
>>   static void ef100_vdpa_delete(struct efx_nic *efx)
>>   {
>>        if (efx->vdpa_nic) {
>>                /* replace with _vdpa_unregister_device later */
>>                put_device(&efx->vdpa_nic->vdpa_dev.dev);
>>        }
>> +     efx_mcdi_free_vis(efx);
>>   }
>>
>>   void ef100_vdpa_fini(struct efx_probe_data *probe_data)
>> @@ -104,9 +124,19 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>   {
>>        struct ef100_nic_data *nic_data = efx->nic_data;
>>        struct ef100_vdpa_nic *vdpa_nic;
>> +     unsigned int allocated_vis;
>>        int rc;
>> +     u8 i;
>>
>>        nic_data->vdpa_class = dev_type;
>> +     rc = vdpa_allocate_vis(efx, &allocated_vis);
>> +     if (rc) {
>> +             pci_err(efx->pci_dev,
>> +                     "%s Alloc VIs failed for vf:%u error:%d\n",
>> +                      __func__, nic_data->vf_index, rc);
>> +             return ERR_PTR(rc);
>> +     }
>> +
>>        vdpa_nic = vdpa_alloc_device(struct ef100_vdpa_nic,
>>                                     vdpa_dev, &efx->pci_dev->dev,
>>                                     &ef100_vdpa_config_ops,
>> @@ -117,7 +147,8 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>                        "vDPA device allocation failed for vf: %u\n",
>>                        nic_data->vf_index);
>>                nic_data->vdpa_class = EF100_VDPA_CLASS_NONE;
>> -             return ERR_PTR(-ENOMEM);
>> +             rc = -ENOMEM;
>> +             goto err_alloc_vis_free;
>>        }
>>
>>        mutex_init(&vdpa_nic->lock);
>> @@ -125,11 +156,21 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>        vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
>>        vdpa_nic->vdpa_dev.mdev = efx->mgmt_dev;
>>        vdpa_nic->efx = efx;
>> +     vdpa_nic->max_queue_pairs = allocated_vis - 1;
>>        vdpa_nic->pf_index = nic_data->pf_index;
>>        vdpa_nic->vf_index = nic_data->vf_index;
>>        vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>>        vdpa_nic->mac_address = (u8 *)&vdpa_nic->net_config.mac;
>>
>> +     for (i = 0; i < (2 * vdpa_nic->max_queue_pairs); i++) {
>> +             rc = ef100_vdpa_init_vring(vdpa_nic, i);
>> +             if (rc) {
>> +                     pci_err(efx->pci_dev,
>> +                             "vring init idx: %u failed, rc: %d\n", i, rc);
>> +                     goto err_put_device;
>> +             }
>> +     }
>> +
>>        rc = get_net_config(vdpa_nic);
>>        if (rc)
>>                goto err_put_device;
>> @@ -146,6 +187,9 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>   err_put_device:
>>        /* put_device invokes ef100_vdpa_free */
>>        put_device(&vdpa_nic->vdpa_dev.dev);
>> +
>> +err_alloc_vis_free:
>> +     efx_mcdi_free_vis(efx);
>>        return ERR_PTR(rc);
>>   }
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> index dcf4a8156415..348ca8a7404b 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> @@ -32,6 +32,21 @@
>>   /* Alignment requirement of the Virtqueue */
>>   #define EF100_VDPA_VQ_ALIGN 4096
>>
>> +/* Vring configuration definitions */
>> +#define EF100_VRING_ADDRESS_CONFIGURED 0x1
>> +#define EF100_VRING_SIZE_CONFIGURED 0x10
>> +#define EF100_VRING_READY_CONFIGURED 0x100
>> +#define EF100_VRING_CONFIGURED (EF100_VRING_ADDRESS_CONFIGURED | \
>> +                             EF100_VRING_SIZE_CONFIGURED | \
>> +                             EF100_VRING_READY_CONFIGURED)
>> +#define EF100_VRING_CREATED 0x1000
> I only see these defines used a bit masks. So why skip all the bits
> in stead of using 0x2, 0x4, 0x8 respectively?

There is no particular reason. I just re-used the macros and their 
values from the out of tree driver. Will change the to 0x1, 0x2, 0x4 and 
0x8 respectively.

Thanks

>
> Martin
>
>> +
>> +/* Maximum size of msix name */
>> +#define EF100_VDPA_MAX_MSIX_NAME_SIZE 256
>> +
>> +/* Default high IOVA for MCDI buffer */
>> +#define EF100_VDPA_IOVA_BASE_ADDR 0x20000000000
>> +
>>   /**
>>    * enum ef100_vdpa_nic_state - possible states for a vDPA NIC
>>    *
>> @@ -57,6 +72,41 @@ enum ef100_vdpa_vq_type {
>>        EF100_VDPA_VQ_NTYPES
>>   };
>>
>> +/**
>> + * struct ef100_vdpa_vring_info - vDPA vring data structure
>> + *
>> + * @desc: Descriptor area address of the vring
>> + * @avail: Available area address of the vring
>> + * @used: Device area address of the vring
>> + * @size: Number of entries in the vring
>> + * @vring_state: bit map to track vring configuration
>> + * @last_avail_idx: last available index of the vring
>> + * @last_used_idx: last used index of the vring
>> + * @doorbell_offset: doorbell offset
>> + * @doorbell_offset_valid: true if @doorbell_offset is updated
>> + * @vring_type: type of vring created
>> + * @vring_ctx: vring context information
>> + * @msix_name: device name for vring irq handler
>> + * @irq: irq number for vring irq handler
>> + * @cb: callback for vring interrupts
>> + */
>> +struct ef100_vdpa_vring_info {
>> +     dma_addr_t desc;
>> +     dma_addr_t avail;
>> +     dma_addr_t used;
>> +     u32 size;
>> +     u16 vring_state;
>> +     u32 last_avail_idx;
>> +     u32 last_used_idx;
>> +     u32 doorbell_offset;
>> +     bool doorbell_offset_valid;
>> +     enum ef100_vdpa_vq_type vring_type;
>> +     struct efx_vring_ctx *vring_ctx;
>> +     char msix_name[EF100_VDPA_MAX_MSIX_NAME_SIZE];
>> +     u32 irq;
>> +     struct vdpa_callback cb;
>> +};
>> +
>>   /**
>>    *  struct ef100_vdpa_nic - vDPA NIC data structure
>>    *
>> @@ -70,6 +120,7 @@ enum ef100_vdpa_vq_type {
>>    * @features: negotiated feature bits
>>    * @max_queue_pairs: maximum number of queue pairs supported
>>    * @net_config: virtio_net_config data
>> + * @vring: vring information of the vDPA device.
>>    * @mac_address: mac address of interface associated with this vdpa device
>>    * @mac_configured: true after MAC address is configured
>>    * @cfg_cb: callback for config change
>> @@ -86,6 +137,7 @@ struct ef100_vdpa_nic {
>>        u64 features;
>>        u32 max_queue_pairs;
>>        struct virtio_net_config net_config;
>> +     struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
>>        u8 *mac_address;
>>        bool mac_configured;
>>        struct vdpa_callback cfg_cb;
>> @@ -95,6 +147,8 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data);
>>   void ef100_vdpa_fini(struct efx_probe_data *probe_data);
>>   int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
>>   void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
>> +void ef100_vdpa_irq_vectors_free(void *data);
>> +int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
>>
>>   static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
>>   {
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> index a2364ef9f492..0051c4c0e47c 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> @@ -9,13 +9,270 @@
>>
>>   #include <linux/vdpa.h>
>>   #include "ef100_vdpa.h"
>> +#include "io.h"
>>   #include "mcdi_vdpa.h"
>>
>> +/* Get the queue's function-local index of the associated VI
>> + * virtqueue number queue 0 is reserved for MCDI
>> + */
>> +#define EFX_GET_VI_INDEX(vq_num) (((vq_num) / 2) + 1)
>> +
>>   static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
>>   {
>>        return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>>   }
>>
>> +void ef100_vdpa_irq_vectors_free(void *data)
>> +{
>> +     pci_free_irq_vectors(data);
>> +}
>> +
>> +static int create_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +     struct efx_vring_ctx *vring_ctx;
>> +     u32 vi_index;
>> +
>> +     if (idx % 2) /* Even VQ for RX and odd for TX */
>> +             vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_TYPE_NET_TXQ;
>> +     else
>> +             vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_TYPE_NET_RXQ;
>> +     vi_index = EFX_GET_VI_INDEX(idx);
>> +     vring_ctx = efx_vdpa_vring_init(vdpa_nic->efx, vi_index,
>> +                                     vdpa_nic->vring[idx].vring_type);
>> +     if (IS_ERR(vring_ctx))
>> +             return PTR_ERR(vring_ctx);
>> +
>> +     vdpa_nic->vring[idx].vring_ctx = vring_ctx;
>> +     return 0;
>> +}
>> +
>> +static void delete_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +     efx_vdpa_vring_fini(vdpa_nic->vring[idx].vring_ctx);
>> +     vdpa_nic->vring[idx].vring_ctx = NULL;
>> +}
>> +
>> +static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +     vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
>> +     vdpa_nic->vring[idx].vring_state = 0;
>> +     vdpa_nic->vring[idx].last_avail_idx = 0;
>> +     vdpa_nic->vring[idx].last_used_idx = 0;
>> +}
>> +
>> +int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +     u32 offset;
>> +     int rc;
>> +
>> +     vdpa_nic->vring[idx].irq = -EINVAL;
>> +     rc = create_vring_ctx(vdpa_nic, idx);
>> +     if (rc) {
>> +             dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                     "%s: create_vring_ctx failed, idx:%u, err:%d\n",
>> +                     __func__, idx, rc);
>> +             return rc;
>> +     }
>> +
>> +     rc = efx_vdpa_get_doorbell_offset(vdpa_nic->vring[idx].vring_ctx,
>> +                                       &offset);
>> +     if (rc) {
>> +             dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                     "%s: get_doorbell failed idx:%u, err:%d\n",
>> +                     __func__, idx, rc);
>> +             goto err_get_doorbell_offset;
>> +     }
>> +     vdpa_nic->vring[idx].doorbell_offset = offset;
>> +     vdpa_nic->vring[idx].doorbell_offset_valid = true;
>> +
>> +     return 0;
>> +
>> +err_get_doorbell_offset:
>> +     delete_vring_ctx(vdpa_nic, idx);
>> +     return rc;
>> +}
>> +
>> +static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
>> +                        const char *caller)
>> +{
>> +     if (unlikely(idx >= (vdpa_nic->max_queue_pairs * 2))) {
>> +             dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                     "%s: Invalid qid %u\n", caller, idx);
>> +             return true;
>> +     }
>> +     return false;
>> +}
>> +
>> +static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
>> +                                  u16 idx, u64 desc_area, u64 driver_area,
>> +                                  u64 device_area)
>> +{
>> +     struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +     if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +             return -EINVAL;
>> +
>> +     mutex_lock(&vdpa_nic->lock);
>> +     vdpa_nic->vring[idx].desc = desc_area;
>> +     vdpa_nic->vring[idx].avail = driver_area;
>> +     vdpa_nic->vring[idx].used = device_area;
>> +     vdpa_nic->vring[idx].vring_state |= EF100_VRING_ADDRESS_CONFIGURED;
>> +     mutex_unlock(&vdpa_nic->lock);
>> +     return 0;
>> +}
>> +
>> +static void ef100_vdpa_set_vq_num(struct vdpa_device *vdev, u16 idx, u32 num)
>> +{
>> +     struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +     if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +             return;
>> +
>> +     if (!is_power_of_2(num)) {
>> +             dev_err(&vdev->dev, "%s: Index:%u size:%u not power of 2\n",
>> +                     __func__, idx, num);
>> +             return;
>> +     }
>> +     if (num > EF100_VDPA_VQ_NUM_MAX_SIZE) {
>> +             dev_err(&vdev->dev, "%s: Index:%u size:%u more than max:%u\n",
>> +                     __func__, idx, num, EF100_VDPA_VQ_NUM_MAX_SIZE);
>> +             return;
>> +     }
>> +     mutex_lock(&vdpa_nic->lock);
>> +     vdpa_nic->vring[idx].size  = num;
>> +     vdpa_nic->vring[idx].vring_state |= EF100_VRING_SIZE_CONFIGURED;
>> +     mutex_unlock(&vdpa_nic->lock);
>> +}
>> +
>> +static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
>> +{
>> +     struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +     u32 idx_val;
>> +
>> +     if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +             return;
>> +
>> +     if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>> +             return;
>> +
>> +     idx_val = idx;
>> +     _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
>> +                 vdpa_nic->vring[idx].doorbell_offset);
>> +}
>> +
>> +static void ef100_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx,
>> +                              struct vdpa_callback *cb)
>> +{
>> +     struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +     if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +             return;
>> +
>> +     if (cb)
>> +             vdpa_nic->vring[idx].cb = *cb;
>> +}
>> +
>> +static void ef100_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 idx,
>> +                                 bool ready)
>> +{
>> +     struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +     if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +             return;
>> +
>> +     mutex_lock(&vdpa_nic->lock);
>> +     if (ready) {
>> +             vdpa_nic->vring[idx].vring_state |=
>> +                                     EF100_VRING_READY_CONFIGURED;
>> +     } else {
>> +             vdpa_nic->vring[idx].vring_state &=
>> +                                     ~EF100_VRING_READY_CONFIGURED;
>> +     }
>> +     mutex_unlock(&vdpa_nic->lock);
>> +}
>> +
>> +static bool ef100_vdpa_get_vq_ready(struct vdpa_device *vdev, u16 idx)
>> +{
>> +     struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +     bool ready;
>> +
>> +     if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +             return false;
>> +
>> +     mutex_lock(&vdpa_nic->lock);
>> +     ready = vdpa_nic->vring[idx].vring_state & EF100_VRING_READY_CONFIGURED;
>> +     mutex_unlock(&vdpa_nic->lock);
>> +     return ready;
>> +}
>> +
>> +static int ef100_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
>> +                                const struct vdpa_vq_state *state)
>> +{
>> +     struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +     if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +             return -EINVAL;
>> +
>> +     mutex_lock(&vdpa_nic->lock);
>> +     vdpa_nic->vring[idx].last_avail_idx = state->split.avail_index;
>> +     vdpa_nic->vring[idx].last_used_idx = state->split.avail_index;
>> +     mutex_unlock(&vdpa_nic->lock);
>> +     return 0;
>> +}
>> +
>> +static int ef100_vdpa_get_vq_state(struct vdpa_device *vdev,
>> +                                u16 idx, struct vdpa_vq_state *state)
>> +{
>> +     struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +     if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +             return -EINVAL;
>> +
>> +     mutex_lock(&vdpa_nic->lock);
>> +     state->split.avail_index = (u16)vdpa_nic->vring[idx].last_used_idx;
>> +     mutex_unlock(&vdpa_nic->lock);
>> +
>> +     return 0;
>> +}
>> +
>> +static struct vdpa_notification_area
>> +             ef100_vdpa_get_vq_notification(struct vdpa_device *vdev,
>> +                                            u16 idx)
>> +{
>> +     struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +     struct vdpa_notification_area notify_area = {0, 0};
>> +
>> +     if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +             goto end;
>> +
>> +     mutex_lock(&vdpa_nic->lock);
>> +     notify_area.addr = (uintptr_t)(vdpa_nic->efx->membase_phys +
>> +                             vdpa_nic->vring[idx].doorbell_offset);
>> +     /* VDPA doorbells are at a stride of VI/2
>> +      * One VI stride is shared by both rx & tx doorbells
>> +      */
>> +     notify_area.size = vdpa_nic->efx->vi_stride / 2;
>> +     mutex_unlock(&vdpa_nic->lock);
>> +
>> +end:
>> +     return notify_area;
>> +}
>> +
>> +static int ef100_get_vq_irq(struct vdpa_device *vdev, u16 idx)
>> +{
>> +     struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +     u32 irq;
>> +
>> +     if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +             return -EINVAL;
>> +
>> +     mutex_lock(&vdpa_nic->lock);
>> +     irq = vdpa_nic->vring[idx].irq;
>> +     mutex_unlock(&vdpa_nic->lock);
>> +
>> +     return irq;
>> +}
>> +
>>   static u32 ef100_vdpa_get_vq_align(struct vdpa_device *vdev)
>>   {
>>        return EF100_VDPA_VQ_ALIGN;
>> @@ -80,6 +337,8 @@ static void ef100_vdpa_set_config_cb(struct vdpa_device *vdev,
>>
>>        if (cb)
>>                vdpa_nic->cfg_cb = *cb;
>> +     else
>> +             memset(&vdpa_nic->cfg_cb, 0, sizeof(vdpa_nic->cfg_cb));
>>   }
>>
>>   static u16 ef100_vdpa_get_vq_num_max(struct vdpa_device *vdev)
>> @@ -137,14 +396,30 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
>>   static void ef100_vdpa_free(struct vdpa_device *vdev)
>>   {
>>        struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +     int i;
>>
>>        if (vdpa_nic) {
>> +             for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>> +                     reset_vring(vdpa_nic, i);
>> +                     if (vdpa_nic->vring[i].vring_ctx)
>> +                             delete_vring_ctx(vdpa_nic, i);
>> +             }
>>                mutex_destroy(&vdpa_nic->lock);
>>                vdpa_nic->efx->vdpa_nic = NULL;
>>        }
>>   }
>>
>>   const struct vdpa_config_ops ef100_vdpa_config_ops = {
>> +     .set_vq_address      = ef100_vdpa_set_vq_address,
>> +     .set_vq_num          = ef100_vdpa_set_vq_num,
>> +     .kick_vq             = ef100_vdpa_kick_vq,
>> +     .set_vq_cb           = ef100_vdpa_set_vq_cb,
>> +     .set_vq_ready        = ef100_vdpa_set_vq_ready,
>> +     .get_vq_ready        = ef100_vdpa_get_vq_ready,
>> +     .set_vq_state        = ef100_vdpa_set_vq_state,
>> +     .get_vq_state        = ef100_vdpa_get_vq_state,
>> +     .get_vq_notification = ef100_vdpa_get_vq_notification,
>> +     .get_vq_irq          = ef100_get_vq_irq,
>>        .get_vq_align        = ef100_vdpa_get_vq_align,
>>        .get_device_features = ef100_vdpa_get_device_features,
>>        .set_driver_features = ef100_vdpa_set_driver_features,
>> --
>> 2.30.1
