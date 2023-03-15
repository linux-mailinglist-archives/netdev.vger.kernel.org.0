Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E736BBA74
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 18:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjCORG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 13:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbjCORGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 13:06:55 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6BA77E14;
        Wed, 15 Mar 2023 10:06:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RV0csFfjvD4NiFsTJbwKaC9HtQJ7D0CKDwaUs3+iaU3tNwr7p05QT7sRd5VpYwIWXATijE0KJS8os5VKHWaBVSTXl7mrp+egltis1hOfyT1cMQixZBZz9TO+DB3SqWjDniV4yoY05jm5HGOx6PyNxUfl3Saqn9uL50XUqOz2Atx5+/tBrtDUX8Re6SxhhYQTPFb+l5SgC7jPmip1Z1sqgPkrgHylYAellLMTYlgUADLzQNBXC4CkhUMatydLaP+8E2gMQNtcSFCNQvR3Mk08EFbGS72Qwswa0q1cFBzUnFX/65tjhRFjY43MJ1gtiWW4qfE4aQ7g3CVAN9IXrz3V4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCkVtbIm0aJuKsW/xNiENrs+DAi2ynUkLQhb6RecxiY=;
 b=WX0sRU4+tqZ5ggfZyCxvBkbjDeAGiL7qy6F0LA6mtbLjeb9Rmx3hO5O48/CsAqtUkkaP8Fl6I0WG52dPBwzsVA4qidev9+s6onVmGBiZ0dttXDKZSsOVIS1r8j+V0876vehYZKdrFz6ar5gChQMymGcCmRl3iRMqtPQGe26PdwBEiWtaO41CB6+T6qTJCJvz1ujpmqX8IM663tI43Zn11nifniQRezGkHSt3CdRrEzvyzxl2u48Uyc5LESqZIg16kDdmS+u2nH4jlTEaV9WYJ9BNFWThYxGe7dXGJMMNiJVzwjP58sZqVF7lyA+b+aIfJq6x+KCxdUANfu2CtsIKXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCkVtbIm0aJuKsW/xNiENrs+DAi2ynUkLQhb6RecxiY=;
 b=eDq+KkPc1GAWJdW3htYosFcu7vlyNo0QLhvgk6RURAAz1U/He733F4PYVciHMGOpZl+v04MKfPR1XS86u1vR37DnBo3/A1TmB1RwTiswUINTmZdLuL/RoU2PEKYrEnLCve++XlGa2h7HJQUYuxiPtM/0QjILegQgVoDu7HlqOGs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by MN2PR12MB4549.namprd12.prod.outlook.com (2603:10b6:208:268::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Wed, 15 Mar
 2023 17:06:47 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 17:06:47 +0000
Message-ID: <b09842b6-8c55-f0e0-0550-769cc380ea4c@amd.com>
Date:   Wed, 15 Mar 2023 22:36:30 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 08/14] sfc: implement vdpa vring config
 operations
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230307113621.64153-1-gautam.dawar@amd.com>
 <20230307113621.64153-9-gautam.dawar@amd.com>
 <CACGkMEut9FY-2OYnAQPr_wGpcpVc3yurOA+imQARzVcMeuTH1A@mail.gmail.com>
 <7522e236-3105-bc1d-6c14-6fba82703abc@amd.com>
 <8572a910-82a1-1020-5abe-5adbd38cc8bc@redhat.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <8572a910-82a1-1020-5abe-5adbd38cc8bc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0199.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::9) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|MN2PR12MB4549:EE_
X-MS-Office365-Filtering-Correlation-Id: bd441c67-88b9-4549-52b5-08db2577a8f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tNGeZ4jYdW9LTq004O1caBl3FK86mgwnUUqkflXMUrLx2rTVpI6B/EEpGH4w/wymJkZxwr87DAmO1KD1IBzdlql4DkX5I4R309Oer5rj1aMERG8MJxW93WbhExB6fmLBwcl15AY5ptEmTfTu31r+oVq3L4zX2NEg8FiuV/rt904tgMGXOQlKN0iJlGy6I07JPnSARD1ExCDdn1bxOakAIBEV5E4C1LB9v/SpQmrOWdmb5FMu+kxhkdV7f9Wfp5+dTqlMsH4HFTqJM67uX64Qz/dbpDEsCXtqfXsIFUduQl3jSG3dLlQxvn1eyDmhIcybovZgZJKtKR5flc/iEAgoQJr/sdeUfqDYDOfFN9je0K19UBKQsL4zttcUgep0wCEIYfSJd5Z02IVY4yZPYopPPCkpJqbhRJ+/UHFB5GblOcYRNy9afdYBglVFtRq/2/U5b7rQzZNjm0bv8Mj/pBHKLPKoPA+4DhYbWO3lO/JUzfArjvNbztSBdmutiBuRE0wHwCHSHQeVY1PzezVXSYNOrchKVUjiYUm1r554vWopaLQUqZY/GctA2o6cJxLpIWnjehbSVF4CDGYvnAcGIykdHMdj/3lqTy1oQzOVKvqp7ng69zHNrRsT+anxhKXybt8cKga12BpRNWYW/t9S+5r7ARofQsjoUgcdph+q3me8Bj6V5v+5ucy9Kp5LiBdlnqH81Lt/3wWky800SU7Nduq3a3Ygv12c+bOUUymH0XCudhQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199018)(31686004)(36756003)(2906002)(30864003)(7416002)(5660300002)(31696002)(8936002)(41300700001)(66476007)(66946007)(66556008)(8676002)(316002)(38100700002)(4326008)(2616005)(83380400001)(110136005)(54906003)(186003)(478600001)(53546011)(6636002)(6506007)(26005)(6512007)(6666004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3dUUWZSb3VROEVPT002OUhIUjROYTRDeGtHZEtTbUdscXlzbjVZWEViSzF6?=
 =?utf-8?B?SjZrQkU0RGhzQndzdmdDd3hRSVYvVXRoWGgvb1J6YW4wNWFIZ2xibFdUSGZo?=
 =?utf-8?B?YjNHa3NjR05vQ3dSemFicVh3anA5SlgvRmJNWjh0ZGx0Zld4bVhZaW5mZnEv?=
 =?utf-8?B?NDhEVG05RWJnMGdQUkI2QlNsT3pPUE03ZkhNZ2llWHRyVXI4aW1XVEhESld5?=
 =?utf-8?B?YzJ5WlV5dit4ejdZcVk2cEdHNy9rZEtXVllVbGVpcGZvTlQzYW1GcUdHRXNm?=
 =?utf-8?B?S0VZSjQ2Qm4xVUlpVmZxSm56NUE4TmdhY1ViWHVVWFlvZ3pqS3ZyYTFWWjZm?=
 =?utf-8?B?M0pxSTNxS0Y4L3VvazBYVktpYVE0Q0J5cW9lNHRTeEx1ZzErS3Y2WmJJVlBR?=
 =?utf-8?B?UVdhenZVbllOVlJQT2laZlFWeDR3YXhiNWE3QWFmZFdCdWE1SlFoQmZDZDY3?=
 =?utf-8?B?elNSYVF3UGJMblBDWnlkWCsvYjBCYlI0TXpZWEpHTUErMG1hYWljVERnbTJp?=
 =?utf-8?B?MjQxcjA0Ym85V1RXRS9ONVpHRERzWXBRMWdJU2R0RWdFTDlZcjVjcHpmN0t0?=
 =?utf-8?B?bWY4QUozdDFma2NhRmtMeFBsWGZOLzJEYkRxbHczTGhhVW1XU3cxYjV1bEk1?=
 =?utf-8?B?VWlhK2srOVI5Y3VwMms0eHp4blNqSUMxK05VMVhVZWRhaFk4RlZtRDFhV3J4?=
 =?utf-8?B?VVEzOUFuMzRpR1MzRENPa0pORzlnUEZCVVZUbUlZN2QxSWgzTjFtdzhhUTJi?=
 =?utf-8?B?ekpqSVIvekZBZUl6QmxBTjIxQndQVkFTM0xIS3NKSzI2MFpwSGNXaUlFNnVO?=
 =?utf-8?B?V0ZQQ2xSNmxIOXp6RkFuS0VpbThvdmtVLyt0OU5TNHY2bkF4UTBmcjBrdGM5?=
 =?utf-8?B?Y0VhYm1sNElFUzNyS3c2d2lPNU5hd0FWVlptUXVyVGFBWHZlYW44ZWZzSmxE?=
 =?utf-8?B?c2JnSjdUTVgxMEY2RkJGVWZyVUdJNTVoNVNTV0J6Mk91MGZvamxDM3VRZXJ5?=
 =?utf-8?B?dEdhaG1ZYklTRXBla1Rka3k5QWtmMzI3cHAwWTVVNS9ZRVRXYTVXam0zWkxW?=
 =?utf-8?B?ZTlKaENBbDQvWXhGVWpWaEZ5UXlxYWRJcnJBZ3hPU01ockhoOGFjdFpLUXRw?=
 =?utf-8?B?a25NeGdOYVJBemllUTY1amZZeUdBcWZyQTNGV3dnamdMSUMzTDdJdkZCYklC?=
 =?utf-8?B?Z0V1OHFYai9CbW40QUVsZXpLdDlrb3lhdndhdzRIeEo2NWlOM092VEh5RXFq?=
 =?utf-8?B?Z1FpNTlnTG8rb3AvMHlkaUlNODNhaDBWSUcrUWxEYUhjdVYzNzZjc25oT1ho?=
 =?utf-8?B?TnFXaDBKZCtRYUxjcjI0cXV6bG16N3dEbGQ3MjBoYzc3QlpGQW5FbUNPWTdx?=
 =?utf-8?B?NTN1UVNEeUZNZWVQR2s4NXd0U1ByQk9aNUNJTTgwV3I2YzBkOWgvUlJjV1VG?=
 =?utf-8?B?LzJvTnZ4dWdrMkZYMjUwVm05MEVjYnhQTTZxVkcyWG93QXBaNjdBR3FDQ3E5?=
 =?utf-8?B?MVNPdFJPMDBtaXJ2bk5tT3V2SCtqNFM3eUtlNGFLenhFQitxanFmT2NjTnFn?=
 =?utf-8?B?TzJrRllGblUvdUpEVE10Wmk1Rzl5ZDVtSnpHV2VJenpVbU1veXEvb01vR1pB?=
 =?utf-8?B?cEp4NTBWclRudHVibmpUMFJSbGdxRjJ6cXBzQnFZZm1yNWczK1VUazVXaURV?=
 =?utf-8?B?QVorWGowYUYzcVE5S1VFZ3Y3L0ZzVjM0c0FPY3d3dm1XQTUwcEl6bGljK0hm?=
 =?utf-8?B?YWJrbkRkdElaK09TVGt0Z3FlaCtudkZNVFEwbjRyZ3JXNzBrTWR3MFpaS3py?=
 =?utf-8?B?cTV2WUExdjczY09KWW9nM2x5N1Z1L01Eb3NnV0tXcTQwZjN0RExGZWpROUhx?=
 =?utf-8?B?cEtiWSt2VG9HVlZrMHVJM3Y1VGcwTENYWG95UnlzRTJWWHNkSGhVTWlJM0VD?=
 =?utf-8?B?NGdmYW9QRllTWnVaLzhJNm0waDEzUXBZVjBrcmNQWVlMQW4vTE1XSlg1R2xW?=
 =?utf-8?B?Wng4a1hicXdnUm1kWmxVWlBHNkdPa2N3SUZXZlJveE8rblJrYllZaUlPa1RN?=
 =?utf-8?B?TjZqa2tOdGNKcVF2bkU2ek1uYXMwa3hBOU9mcEpuRSsrZldzTFY0cE0zVCti?=
 =?utf-8?Q?39TEV5qAbPOJDB0XvPQ2apLuy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd441c67-88b9-4549-52b5-08db2577a8f6
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 17:06:47.2857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C75FiiQH109K2keTDA+fe3HOEAwBNqKa58do2r14ZsVzyJWBDaYNdZuR7tJv1zSf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4549
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/15/23 10:38, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper 
> caution when opening attachments, clicking links, or responding.
>
>
> 在 2023/3/13 20:33, Gautam Dawar 写道:
>>
>> On 3/10/23 10:34, Jason Wang wrote:
>>> Caution: This message originated from an External Source. Use proper
>>> caution when opening attachments, clicking links, or responding.
>>>
>>>
>>> On Tue, Mar 7, 2023 at 7:37 PM Gautam Dawar <gautam.dawar@amd.com>
>>> wrote:
>>>> This patch implements the vDPA config operations related to
>>>> virtqueues or vrings. These include setting vring address,
>>>> getting vq state, operations to enable/disable a vq etc.
>>>> The resources required for vring operations eg. VI, interrupts etc.
>>>> are also allocated.
>>>>
>>>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>>>> ---
>>>>   drivers/net/ethernet/sfc/ef100_vdpa.c     |  46 +++-
>>>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |  54 +++++
>>>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 275
>>>> ++++++++++++++++++++++
>>>>   3 files changed, 374 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>> b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>> index 4c5a98c9d6c3..c66e5aef69ea 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>> @@ -14,6 +14,7 @@
>>>>   #include "ef100_vdpa.h"
>>>>   #include "mcdi_vdpa.h"
>>>>   #include "mcdi_filters.h"
>>>> +#include "mcdi_functions.h"
>>>>   #include "ef100_netdev.h"
>>>>
>>>>   static struct virtio_device_id ef100_vdpa_id_table[] = {
>>>> @@ -47,12 +48,31 @@ int ef100_vdpa_init(struct efx_probe_data
>>>> *probe_data)
>>>>          return rc;
>>>>   }
>>>>
>>>> +static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int
>>>> *allocated_vis)
>>>> +{
>>>> +       /* The first VI is reserved for MCDI
>>>> +        * 1 VI each for rx + tx ring
>>>> +        */
>>>> +       unsigned int max_vis = 1 + EF100_VDPA_MAX_QUEUES_PAIRS;
>>>> +       unsigned int min_vis = 1 + 1;
>>>> +       int rc;
>>>> +
>>>> +       rc = efx_mcdi_alloc_vis(efx, min_vis, max_vis,
>>>> +                               NULL, allocated_vis);
>>>> +       if (!rc)
>>>> +               return rc;
>>>> +       if (*allocated_vis < min_vis)
>>>> +               return -ENOSPC;
>>>> +       return 0;
>>>> +}
>>>> +
>>>>   static void ef100_vdpa_delete(struct efx_nic *efx)
>>>>   {
>>>>          if (efx->vdpa_nic) {
>>>>                  /* replace with _vdpa_unregister_device later */
>>>> put_device(&efx->vdpa_nic->vdpa_dev.dev);
>>>>          }
>>>> +       efx_mcdi_free_vis(efx);
>>>>   }
>>>>
>>>>   void ef100_vdpa_fini(struct efx_probe_data *probe_data)
>>>> @@ -104,9 +124,19 @@ static struct ef100_vdpa_nic
>>>> *ef100_vdpa_create(struct efx_nic *efx,
>>>>   {
>>>>          struct ef100_nic_data *nic_data = efx->nic_data;
>>>>          struct ef100_vdpa_nic *vdpa_nic;
>>>> +       unsigned int allocated_vis;
>>>>          int rc;
>>>> +       u8 i;
>>>>
>>>>          nic_data->vdpa_class = dev_type;
>>>> +       rc = vdpa_allocate_vis(efx, &allocated_vis);
>>>> +       if (rc) {
>>>> +               pci_err(efx->pci_dev,
>>>> +                       "%s Alloc VIs failed for vf:%u error:%d\n",
>>>> +                        __func__, nic_data->vf_index, rc);
>>>> +               return ERR_PTR(rc);
>>>> +       }
>>>> +
>>>>          vdpa_nic = vdpa_alloc_device(struct ef100_vdpa_nic,
>>>>                                       vdpa_dev, &efx->pci_dev->dev,
>>>> &ef100_vdpa_config_ops,
>>>> @@ -117,7 +147,8 @@ static struct ef100_vdpa_nic
>>>> *ef100_vdpa_create(struct efx_nic *efx,
>>>>                          "vDPA device allocation failed for vf: %u\n",
>>>>                          nic_data->vf_index);
>>>>                  nic_data->vdpa_class = EF100_VDPA_CLASS_NONE;
>>>> -               return ERR_PTR(-ENOMEM);
>>>> +               rc = -ENOMEM;
>>>> +               goto err_alloc_vis_free;
>>>>          }
>>>>
>>>>          mutex_init(&vdpa_nic->lock);
>>>> @@ -125,11 +156,21 @@ static struct ef100_vdpa_nic
>>>> *ef100_vdpa_create(struct efx_nic *efx,
>>>>          vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
>>>>          vdpa_nic->vdpa_dev.mdev = efx->mgmt_dev;
>>>>          vdpa_nic->efx = efx;
>>>> +       vdpa_nic->max_queue_pairs = allocated_vis - 1;
>>>>          vdpa_nic->pf_index = nic_data->pf_index;
>>>>          vdpa_nic->vf_index = nic_data->vf_index;
>>>>          vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>>>>          vdpa_nic->mac_address = (u8 *)&vdpa_nic->net_config.mac;
>>>>
>>>> +       for (i = 0; i < (2 * vdpa_nic->max_queue_pairs); i++) {
>>>> +               rc = ef100_vdpa_init_vring(vdpa_nic, i);
>>>> +               if (rc) {
>>>> +                       pci_err(efx->pci_dev,
>>>> +                               "vring init idx: %u failed, rc:
>>>> %d\n", i, rc);
>>>> +                       goto err_put_device;
>>>> +               }
>>>> +       }
>>>> +
>>>>          rc = get_net_config(vdpa_nic);
>>>>          if (rc)
>>>>                  goto err_put_device;
>>>> @@ -146,6 +187,9 @@ static struct ef100_vdpa_nic
>>>> *ef100_vdpa_create(struct efx_nic *efx,
>>>>   err_put_device:
>>>>          /* put_device invokes ef100_vdpa_free */
>>>>          put_device(&vdpa_nic->vdpa_dev.dev);
>>>> +
>>>> +err_alloc_vis_free:
>>>> +       efx_mcdi_free_vis(efx);
>>>>          return ERR_PTR(rc);
>>>>   }
>>>>
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> index dcf4a8156415..348ca8a7404b 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> @@ -32,6 +32,21 @@
>>>>   /* Alignment requirement of the Virtqueue */
>>>>   #define EF100_VDPA_VQ_ALIGN 4096
>>>>
>>>> +/* Vring configuration definitions */
>>>> +#define EF100_VRING_ADDRESS_CONFIGURED 0x1
>>>> +#define EF100_VRING_SIZE_CONFIGURED 0x10
>>>> +#define EF100_VRING_READY_CONFIGURED 0x100
>>>> +#define EF100_VRING_CONFIGURED (EF100_VRING_ADDRESS_CONFIGURED | \
>>>> +                               EF100_VRING_SIZE_CONFIGURED | \
>>>> + EF100_VRING_READY_CONFIGURED)
>>>> +#define EF100_VRING_CREATED 0x1000
>>>> +
>>>> +/* Maximum size of msix name */
>>>> +#define EF100_VDPA_MAX_MSIX_NAME_SIZE 256
>>>> +
>>>> +/* Default high IOVA for MCDI buffer */
>>>> +#define EF100_VDPA_IOVA_BASE_ADDR 0x20000000000
>>>> +
>>>>   /**
>>>>    * enum ef100_vdpa_nic_state - possible states for a vDPA NIC
>>>>    *
>>>> @@ -57,6 +72,41 @@ enum ef100_vdpa_vq_type {
>>>>          EF100_VDPA_VQ_NTYPES
>>>>   };
>>>>
>>>> +/**
>>>> + * struct ef100_vdpa_vring_info - vDPA vring data structure
>>>> + *
>>>> + * @desc: Descriptor area address of the vring
>>>> + * @avail: Available area address of the vring
>>>> + * @used: Device area address of the vring
>>>> + * @size: Number of entries in the vring
>>>> + * @vring_state: bit map to track vring configuration
>>>> + * @last_avail_idx: last available index of the vring
>>>> + * @last_used_idx: last used index of the vring
>>>> + * @doorbell_offset: doorbell offset
>>>> + * @doorbell_offset_valid: true if @doorbell_offset is updated
>>>> + * @vring_type: type of vring created
>>>> + * @vring_ctx: vring context information
>>>> + * @msix_name: device name for vring irq handler
>>>> + * @irq: irq number for vring irq handler
>>>> + * @cb: callback for vring interrupts
>>>> + */
>>>> +struct ef100_vdpa_vring_info {
>>>> +       dma_addr_t desc;
>>>> +       dma_addr_t avail;
>>>> +       dma_addr_t used;
>>>> +       u32 size;
>>>> +       u16 vring_state;
>>>> +       u32 last_avail_idx;
>>>> +       u32 last_used_idx;
>>>> +       u32 doorbell_offset;
>>>> +       bool doorbell_offset_valid;
>>>> +       enum ef100_vdpa_vq_type vring_type;
>>>> +       struct efx_vring_ctx *vring_ctx;
>>>> +       char msix_name[EF100_VDPA_MAX_MSIX_NAME_SIZE];
>>>> +       u32 irq;
>>>> +       struct vdpa_callback cb;
>>>> +};
>>>> +
>>>>   /**
>>>>    *  struct ef100_vdpa_nic - vDPA NIC data structure
>>>>    *
>>>> @@ -70,6 +120,7 @@ enum ef100_vdpa_vq_type {
>>>>    * @features: negotiated feature bits
>>>>    * @max_queue_pairs: maximum number of queue pairs supported
>>>>    * @net_config: virtio_net_config data
>>>> + * @vring: vring information of the vDPA device.
>>>>    * @mac_address: mac address of interface associated with this
>>>> vdpa device
>>>>    * @mac_configured: true after MAC address is configured
>>>>    * @cfg_cb: callback for config change
>>>> @@ -86,6 +137,7 @@ struct ef100_vdpa_nic {
>>>>          u64 features;
>>>>          u32 max_queue_pairs;
>>>>          struct virtio_net_config net_config;
>>>> +       struct ef100_vdpa_vring_info
>>>> vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
>>>>          u8 *mac_address;
>>>>          bool mac_configured;
>>>>          struct vdpa_callback cfg_cb;
>>>> @@ -95,6 +147,8 @@ int ef100_vdpa_init(struct efx_probe_data
>>>> *probe_data);
>>>>   void ef100_vdpa_fini(struct efx_probe_data *probe_data);
>>>>   int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
>>>>   void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
>>>> +void ef100_vdpa_irq_vectors_free(void *data);
>>>> +int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
>>>>
>>>>   static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic
>>>> *vdpa_nic)
>>>>   {
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>> b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>> index a2364ef9f492..0051c4c0e47c 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>> @@ -9,13 +9,270 @@
>>>>
>>>>   #include <linux/vdpa.h>
>>>>   #include "ef100_vdpa.h"
>>>> +#include "io.h"
>>>>   #include "mcdi_vdpa.h"
>>>>
>>>> +/* Get the queue's function-local index of the associated VI
>>>> + * virtqueue number queue 0 is reserved for MCDI
>>>> + */
>>>> +#define EFX_GET_VI_INDEX(vq_num) (((vq_num) / 2) + 1)
>>>> +
>>>>   static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
>>>>   {
>>>>          return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>>>>   }
>>>>
>>>> +void ef100_vdpa_irq_vectors_free(void *data)
>>>> +{
>>>> +       pci_free_irq_vectors(data);
>>>> +}
>>>> +
>>>> +static int create_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>> +{
>>>> +       struct efx_vring_ctx *vring_ctx;
>>>> +       u32 vi_index;
>>>> +
>>>> +       if (idx % 2) /* Even VQ for RX and odd for TX */
>>>> +               vdpa_nic->vring[idx].vring_type =
>>>> EF100_VDPA_VQ_TYPE_NET_TXQ;
>>>> +       else
>>>> +               vdpa_nic->vring[idx].vring_type =
>>>> EF100_VDPA_VQ_TYPE_NET_RXQ;
>>>> +       vi_index = EFX_GET_VI_INDEX(idx);
>>>> +       vring_ctx = efx_vdpa_vring_init(vdpa_nic->efx, vi_index,
>>>> + vdpa_nic->vring[idx].vring_type);
>>>> +       if (IS_ERR(vring_ctx))
>>>> +               return PTR_ERR(vring_ctx);
>>>> +
>>>> +       vdpa_nic->vring[idx].vring_ctx = vring_ctx;
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static void delete_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 
>>>> idx)
>>>> +{
>>>> + efx_vdpa_vring_fini(vdpa_nic->vring[idx].vring_ctx);
>>>> +       vdpa_nic->vring[idx].vring_ctx = NULL;
>>>> +}
>>>> +
>>>> +static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>> +{
>>>> +       vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
>>>> +       vdpa_nic->vring[idx].vring_state = 0;
>>>> +       vdpa_nic->vring[idx].last_avail_idx = 0;
>>>> +       vdpa_nic->vring[idx].last_used_idx = 0;
>>>> +}
>>>> +
>>>> +int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>> +{
>>>> +       u32 offset;
>>>> +       int rc;
>>>> +
>>>> +       vdpa_nic->vring[idx].irq = -EINVAL;
>>>> +       rc = create_vring_ctx(vdpa_nic, idx);
>>>> +       if (rc) {
>>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>>> +                       "%s: create_vring_ctx failed, idx:%u,
>>>> err:%d\n",
>>>> +                       __func__, idx, rc);
>>>> +               return rc;
>>>> +       }
>>>> +
>>>> +       rc =
>>>> efx_vdpa_get_doorbell_offset(vdpa_nic->vring[idx].vring_ctx,
>>>> +                                         &offset);
>>>> +       if (rc) {
>>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>>> +                       "%s: get_doorbell failed idx:%u, err:%d\n",
>>>> +                       __func__, idx, rc);
>>>> +               goto err_get_doorbell_offset;
>>>> +       }
>>>> +       vdpa_nic->vring[idx].doorbell_offset = offset;
>>>> +       vdpa_nic->vring[idx].doorbell_offset_valid = true;
>>>> +
>>>> +       return 0;
>>>> +
>>>> +err_get_doorbell_offset:
>>>> +       delete_vring_ctx(vdpa_nic, idx);
>>>> +       return rc;
>>>> +}
>>>> +
>>>> +static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
>>>> +                          const char *caller)
>>>> +{
>>>> +       if (unlikely(idx >= (vdpa_nic->max_queue_pairs * 2))) {
>>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>>> +                       "%s: Invalid qid %u\n", caller, idx);
>>>> +               return true;
>>>> +       }
>>>> +       return false;
>>>> +}
>>>> +
>>>> +static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
>>>> +                                    u16 idx, u64 desc_area, u64
>>>> driver_area,
>>>> +                                    u64 device_area)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +
>>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>> +               return -EINVAL;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->lock);
>>>> +       vdpa_nic->vring[idx].desc = desc_area;
>>>> +       vdpa_nic->vring[idx].avail = driver_area;
>>>> +       vdpa_nic->vring[idx].used = device_area;
>>>> +       vdpa_nic->vring[idx].vring_state |=
>>>> EF100_VRING_ADDRESS_CONFIGURED;
>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static void ef100_vdpa_set_vq_num(struct vdpa_device *vdev, u16
>>>> idx, u32 num)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +
>>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>> +               return;
>>>> +
>>>> +       if (!is_power_of_2(num)) {
>>>> +               dev_err(&vdev->dev, "%s: Index:%u size:%u not power
>>>> of 2\n",
>>>> +                       __func__, idx, num);
>>>> +               return;
>>>> +       }
>>> Note that this is not a requirement for packed virtqueue.
>>>
>>> """
>>> Queue Size corresponds to the maximum number of descriptors in the
>>> virtqueue5. The Queue Size value does not have to be a power of 2.
>>> """
>> Yes, but we are using split vrings and virtio spec states "Queue Size
>> value is always a power of 2" for Split virtqueues.
>
>
> Did you mean the device can only support split virtqueue? If yes, we'd
> better document this.
Yes. Will add a code comment.
>
> But this seems not scalable consider the packed virtqueue could be
> supported in the future. It would be nice if device can fail the command
> according to the type of the virtqueue, then the driver doesn't need any
> care about this.
Isn't the device expected to expose VIRTIO_F_RING_PACKED feature bit in 
case it supports packed virtqueues? And as sfc doesn't expose it, this 
requirement is valid.
>
>
>>>
>>>> +       if (num > EF100_VDPA_VQ_NUM_MAX_SIZE) {
>>>> +               dev_err(&vdev->dev, "%s: Index:%u size:%u more than
>>>> max:%u\n",
>>>> +                       __func__, idx, num,
>>>> EF100_VDPA_VQ_NUM_MAX_SIZE);
>>>> +               return;
>>>> +       }
>>>> +       mutex_lock(&vdpa_nic->lock);
>>>> +       vdpa_nic->vring[idx].size  = num;
>>>> +       vdpa_nic->vring[idx].vring_state |=
>>>> EF100_VRING_SIZE_CONFIGURED;
>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>> +}
>>>> +
>>>> +static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +       u32 idx_val;
>>>> +
>>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>> +               return;
>>>> +
>>>> +       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>>>> +               return;
>>> In which case could we hit this condition?
>> I've noticed this condition in regular testing with vhost-vdpa. The
>> first couple of kick_vq calls arrive when the HW queues aren't created
>> yet. .I think userspace assumes queues to be ready soon after sending
>> DRIVER_OK. However, there is a little time window between that and
>> when the HW VQs are actually ready for datapath.
>
>
> Interesting, so I think the driver need to wait until the HW VQS are
> ready before return from DRIVER_OK setting in this case. Otherwise we
> may end up with the above check (and it probably lacks some kind of
> synchronization).
This could be tricky considering the case where vq creation depends on 
both - device status set to DRIVER_OK and queue being enabled (the 
requirement for VM LM). Accordingly, I think it's ok to ignore the vq 
kick when queue doesn't exist as we are triggering a spurious vq kick 
soon after creation.
>
>
>>>
>>>> +
>>>> +       idx_val = idx;
>>>> +       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
>>>> + vdpa_nic->vring[idx].doorbell_offset);
>>>> +}
>>>> +
>>>> +static void ef100_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx,
>>>> +                                struct vdpa_callback *cb)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +
>>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>> +               return;
>>>> +
>>>> +       if (cb)
>>>> +               vdpa_nic->vring[idx].cb = *cb;
>>>> +}
>>>> +
>>>> +static void ef100_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 
>>>> idx,
>>>> +                                   bool ready)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +
>>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>> +               return;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->lock);
>>>> +       if (ready) {
>>>> +               vdpa_nic->vring[idx].vring_state |=
>>>> + EF100_VRING_READY_CONFIGURED;
>>> I think it would be sufficient to have EF100_VRING_READY_CONFIGURED
>>> here. With this set, the device can think the vq configuration is done
>>> by the driver.
>>>
>>> Or is there anything special for size and num?
>> The virtqueue is considered ready for datapath when it is fully
>> configured (both size and address set and enabled with set_vq_ready).
>> Depending on merely the queue enable (EF100_VRING_READY_CONFIGURED)
>> would assume valid values for vq size and addresses, which we wish to
>> avoid.
>
>
> Ok, but I'd say it's better to offload those to the device. According to
> the spec, once queue_enable is set, the device assumes the virtqueue
> configuration is ready (no matter if size and num are configured). And
> driver risks its own for wrong configuration and device should be ready
> for invalid configuration (this is even the case with the above codes,
> device should still need to care about illegal size and num).

I can validate the device behavior with invalid size and num but do you 
see any issue with this validation specially because it can prevent 
device malfunction as it can be triggered from the userspace?

Gautam

>
> Thanks
>
>
>>>
>>> Thanks
>>>
>>>
>>>> +       } else {
>>>> +               vdpa_nic->vring[idx].vring_state &=
>>>> + ~EF100_VRING_READY_CONFIGURED;
>>>> +       }
>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>> +}
>>>> +
>>>> +static bool ef100_vdpa_get_vq_ready(struct vdpa_device *vdev, u16 
>>>> idx)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +       bool ready;
>>>> +
>>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>> +               return false;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->lock);
>>>> +       ready = vdpa_nic->vring[idx].vring_state &
>>>> EF100_VRING_READY_CONFIGURED;
>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>> +       return ready;
>>>> +}
>>>> +
>>>> +static int ef100_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
>>>> +                                  const struct vdpa_vq_state *state)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +
>>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>> +               return -EINVAL;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->lock);
>>>> +       vdpa_nic->vring[idx].last_avail_idx = 
>>>> state->split.avail_index;
>>>> +       vdpa_nic->vring[idx].last_used_idx = state->split.avail_index;
>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int ef100_vdpa_get_vq_state(struct vdpa_device *vdev,
>>>> +                                  u16 idx, struct vdpa_vq_state
>>>> *state)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +
>>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>> +               return -EINVAL;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->lock);
>>>> +       state->split.avail_index =
>>>> (u16)vdpa_nic->vring[idx].last_used_idx;
>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static struct vdpa_notification_area
>>>> +               ef100_vdpa_get_vq_notification(struct vdpa_device
>>>> *vdev,
>>>> +                                              u16 idx)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +       struct vdpa_notification_area notify_area = {0, 0};
>>>> +
>>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>> +               goto end;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->lock);
>>>> +       notify_area.addr = (uintptr_t)(vdpa_nic->efx->membase_phys +
>>>> + vdpa_nic->vring[idx].doorbell_offset);
>>>> +       /* VDPA doorbells are at a stride of VI/2
>>>> +        * One VI stride is shared by both rx & tx doorbells
>>>> +        */
>>>> +       notify_area.size = vdpa_nic->efx->vi_stride / 2;
>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>> +
>>>> +end:
>>>> +       return notify_area;
>>>> +}
>>>> +
>>>> +static int ef100_get_vq_irq(struct vdpa_device *vdev, u16 idx)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +       u32 irq;
>>>> +
>>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>> +               return -EINVAL;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->lock);
>>>> +       irq = vdpa_nic->vring[idx].irq;
>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>> +
>>>> +       return irq;
>>>> +}
>>>> +
>>>>   static u32 ef100_vdpa_get_vq_align(struct vdpa_device *vdev)
>>>>   {
>>>>          return EF100_VDPA_VQ_ALIGN;
>>>> @@ -80,6 +337,8 @@ static void ef100_vdpa_set_config_cb(struct
>>>> vdpa_device *vdev,
>>>>
>>>>          if (cb)
>>>>                  vdpa_nic->cfg_cb = *cb;
>>>> +       else
>>>> +               memset(&vdpa_nic->cfg_cb, 0, 
>>>> sizeof(vdpa_nic->cfg_cb));
>>>>   }
>>>>
>>>>   static u16 ef100_vdpa_get_vq_num_max(struct vdpa_device *vdev)
>>>> @@ -137,14 +396,30 @@ static void ef100_vdpa_set_config(struct
>>>> vdpa_device *vdev, unsigned int offset,
>>>>   static void ef100_vdpa_free(struct vdpa_device *vdev)
>>>>   {
>>>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +       int i;
>>>>
>>>>          if (vdpa_nic) {
>>>> +               for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); 
>>>> i++) {
>>>> +                       reset_vring(vdpa_nic, i);
>>>> +                       if (vdpa_nic->vring[i].vring_ctx)
>>>> +                               delete_vring_ctx(vdpa_nic, i);
>>>> +               }
>>>>                  mutex_destroy(&vdpa_nic->lock);
>>>>                  vdpa_nic->efx->vdpa_nic = NULL;
>>>>          }
>>>>   }
>>>>
>>>>   const struct vdpa_config_ops ef100_vdpa_config_ops = {
>>>> +       .set_vq_address      = ef100_vdpa_set_vq_address,
>>>> +       .set_vq_num          = ef100_vdpa_set_vq_num,
>>>> +       .kick_vq             = ef100_vdpa_kick_vq,
>>>> +       .set_vq_cb           = ef100_vdpa_set_vq_cb,
>>>> +       .set_vq_ready        = ef100_vdpa_set_vq_ready,
>>>> +       .get_vq_ready        = ef100_vdpa_get_vq_ready,
>>>> +       .set_vq_state        = ef100_vdpa_set_vq_state,
>>>> +       .get_vq_state        = ef100_vdpa_get_vq_state,
>>>> +       .get_vq_notification = ef100_vdpa_get_vq_notification,
>>>> +       .get_vq_irq          = ef100_get_vq_irq,
>>>>          .get_vq_align        = ef100_vdpa_get_vq_align,
>>>>          .get_device_features = ef100_vdpa_get_device_features,
>>>>          .set_driver_features = ef100_vdpa_set_driver_features,
>>>> -- 
>>>> 2.30.1
>>>>
>>
>
