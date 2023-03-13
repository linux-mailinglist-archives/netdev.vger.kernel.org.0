Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07FA6B7798
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 13:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCMMej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 08:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjCMMeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 08:34:36 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054DE37713;
        Mon, 13 Mar 2023 05:34:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=huOQVll3cEQbRM6rztHqYpgMilCw60SRG5brgKgqZ78WkDNvfhEvRHSDOjC4Z5wD/6HyZ3UzpXcwiKEOOa0qeVZXPE4arZz6Sl8xqX/wS90hdCBPtd8dGcGmXpLRsGcVt1qOnsOD9vYCXozljPH9NgMLILhjqH/EzhAM7GEJW5jhi9x92QI5r793OMYN9FfWV1VnY/yybsqYnGFBp2g78RhXpHY6XodgLQItoqmjZFFEvXakScYmpihxEjo2+H2qoOA53AOnCwJ8cCeCT+hA4mllXCamatsNd5jY+kdgiu5HvKOYB9x3JrfXh6bioUpubPARZVHh17N9HqdJHxiDbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pt3Z6FDtfi9epoV25p2vf6wCm4G3MWyHp42fBpgHD7Q=;
 b=c0fqnTsrXhty1wwM4LWGoP/McZ9OKxyXqOJxIs/wglb5f52NkUNUfSd1+oNgHKH9hhdu9wQlxyENFPh/vJ8Ctss+fCTsg+Dvr1exo7zNac/hJvU1x7ute6x/zSHEpkVBTLeMUIihpws3hM4s1E5csGJL4kv+oyvZq1qilnZ4znIBglg+cS4Eupy7tQfJm5ojxl2ywH9o2KQEQjSCoXyq5jeNRd/JZ8SNFWBiPV8uothCWQVtYfJLxnl5Vg0Xbt/Gp/xo2h6h9946V2gA9aDCt+NRD1rly/CMk4WWDEOAqUfojiY4yRcBuxgauXXwagNkyYaVjAEBvOdPg8OMNE5/xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pt3Z6FDtfi9epoV25p2vf6wCm4G3MWyHp42fBpgHD7Q=;
 b=a2Wv3ohqsC3mM9I+wS8UhAOuh9949J2t5d0MzHNUHu21Py8DbAVj99YjNPOjR9RNn5bpq5ZvQtlY0OPdd0KOVA/acjblmtrWstPnMMH8CQEwu0+SH4JWK92/iV43E47+Nx+6W4WpsERLfezelMywsy4jcMuLzkd/xB/3A6OraG4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by DM6PR12MB4353.namprd12.prod.outlook.com (2603:10b6:5:2a6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 12:33:52 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 12:33:52 +0000
Message-ID: <7522e236-3105-bc1d-6c14-6fba82703abc@amd.com>
Date:   Mon, 13 Mar 2023 18:03:38 +0530
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
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEut9FY-2OYnAQPr_wGpcpVc3yurOA+imQARzVcMeuTH1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0239.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::18) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|DM6PR12MB4353:EE_
X-MS-Office365-Filtering-Correlation-Id: 65c66ab4-5693-4a01-ac20-08db23bf341a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Ur4bCAZsG6+GJtPcg+7QCkMM6JHpq87c+BL/5eZpLhjtAhlFts2Q8o4buKXb0zm8hZHVmUBeWoZ4XAKviuGZv1Qy9ONoih5Ja1x4vcD6n0QbeT9b6y1LLfiywT65XOPNWMMGYEEEV9U9KGhiVSZ3ofd4aStCFKbbEy4LgiBaqiJlHmdOFH7Te9udQnWcV73ZxNxDjJShwtnXhPDZ8U0giQ/BxAy99T7oQp8EsVD5vz5u3sYZ1y2ekf8olSfsHHZErjJlFIQOnbQNFk7lxJqstA2nm1oJ/JoXBWHtoSdFbROGoXwn0/a809zd2+kgf/SzmmKN5iJtT6c5Bt+cosNAKE16F7MLggTyh+3FUuC2GUa22PHaWnqRAOKN8uSIiZnRI1b/RuHcR9tLNu66C48W/EarR45li9T3CuR8N/FkW174eXKywPVrp2jHPXiBwMbXMBzDUY61TmykbgcmZUMOOtXJQ848sSlqKv1lQnOV1BvfPt5gg0fbqT3TRMVGmUpXLgm5KBbN2CM/MrLDsOd0jCyfEQOP2RNdtF7b9rm/zvG8jGUxPDJTpWrbjDK1LyaeMMO8UUn3OOL3c7M7vNrNohEbgmQZxeFDGyYzKvdqyGb0diRVsFGNpH/vfVVhSfz4SLOgzkJhEIPsozUDly0YymKD0rLz/2b7oYUjE6//nYGLJuIKYXMN6CodnJxioAEZoW1gahng99XC37iIBjgh8XwRseNVf3gI170tF2fdEc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199018)(6666004)(83380400001)(110136005)(316002)(38100700002)(26005)(478600001)(6636002)(54906003)(8936002)(186003)(5660300002)(6506007)(36756003)(6512007)(53546011)(4326008)(7416002)(8676002)(66556008)(66946007)(66476007)(31696002)(41300700001)(2616005)(30864003)(6486002)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUY2ODI0RHRaMFMrT2RnRnJuTmZMZmFjUEttVEhFVGFGYzFTb0c2ZERVWVcx?=
 =?utf-8?B?WjdFZSthMzBKa3lGekVYK0R0WURpWXVIVzFWcVREQVphL1B3RkI4RGVZKy8y?=
 =?utf-8?B?VFhDaXliNkF5WEl2VTQ0T3ArWnk0ZjRuU0paL3ZFQ3BMalQ1VmNDQjIza3BN?=
 =?utf-8?B?Mmk3K2xDbXhidXZiNVlTckJlZlZGVS9YdnJ3MExBN3c0WmE2ZFMzSWFJNUcv?=
 =?utf-8?B?RmFWMUNPbXVmVG1CcUc4QndkdUptekY3Y2IwUllwWUNWd2hMMG9pWDI4SU5m?=
 =?utf-8?B?ZGd1Tnc2OG5aZGE4ZTlQZHc0M1NkcGZJN1FpY1R2QkY5R3BLek8xOS9pUDRV?=
 =?utf-8?B?V09rNW1HYU00NnRhR3pWZVZNMThlNjRXRW1EbndRS1FrVHowUGxmcS9iNmhv?=
 =?utf-8?B?ZWVIcEhxUWk3OHh4WW51cXlBMXE4ZDR2SDVvSTJNYU9VMnIzRUEybzB2V3dZ?=
 =?utf-8?B?cElOQVNNcmdiRjFOS2dkeSttd1dFdlJIYmdWT0swb0ZPNTFrRW84NHQxNUVD?=
 =?utf-8?B?K3NsakhJNGJUb0JhV25sYll3cmY3U2x1YUN2bTdVdC9uTFJlRHhrcGhkTlZ2?=
 =?utf-8?B?T2VQZFlremo3b2l3ZXZOQkFkYmlQS2dpTTZIZm1pS1VZcmlTbE90Vll5bVh6?=
 =?utf-8?B?L294SHgyM3lYSkN5YWFYSm5jcE8rQ3RkVG01dW1Vc2xha1BmU1FzRldzdkNr?=
 =?utf-8?B?RlZaSklQYmp3VERkVHlCL25YRmhtSHpDY3QrU0ZjcE1tU2IvYmJpci82WXhr?=
 =?utf-8?B?aFBmdmdxRTVlc0IxcHhjZXM1dHNjZHZHOXlRT3ZyM25oSWJQU05mSmI4N2gw?=
 =?utf-8?B?TE4xMnJXTDN2MGpZVThkQnVJb3M5ZEQ4Vndmbk1vbFlpcUZHcFVYMlM1L3Ji?=
 =?utf-8?B?SlpKVVlqeXpWajdoTWExclRNbDRUbFlJNmE2UmZ0SnRXQjA4dUdyQXd0Wld5?=
 =?utf-8?B?bFlaazlxdjZxQ0pHOWJGWmgvV3MzY3FZM0FxRG4wSXlSRnNuSGtJQ1lmaE4x?=
 =?utf-8?B?MzhweHIraDl3b2s3VmhJNjdFM29nTWU5TUNqUkI1cTJtdG1GQkRiUFFiclht?=
 =?utf-8?B?Y3ZPRGRpV212RVh2bERRZjltN050b0Y2QkJ2c2k1K3pmRnAwQ2VSQjhGVjNC?=
 =?utf-8?B?ZHlidVJudExSZGhDenR6MnhGWW9uZHNXTGYzYWl1ZU45eHF0aUZPeVF4RWY2?=
 =?utf-8?B?WGJaRnkvUjkwdERDUno1RVg3NUFCbkc0UlVMTlpmdER3YzAwS0RYVXpXS0U3?=
 =?utf-8?B?VVVHY01VNXRETjFMUzcwQm1LaXlkSStYa2xiTFQ0TEVMT3doeks3MlFjenIx?=
 =?utf-8?B?WHp3MGJiQVY1VjZMRW15YVNzNXZwTHo2SzZZK3JWMTFIQ2FWWHByci9kcXVC?=
 =?utf-8?B?ZTNrd0NyMlFXdExFWU5iT2xpbWllYTRTNitWUjN0QlJvaGIxL3Jrd2grNlk3?=
 =?utf-8?B?MHpubjkyRVh4R2NuNkc4NEE2TzNmdXJLRHZxSEVTNm5wZktJajBia1NEN1RH?=
 =?utf-8?B?QXNISUxpY2wrTjg0elVRYUwrR1k2Q2VxWkE1dllZb2NkSTZUd0l4d2tVMkNB?=
 =?utf-8?B?UHBKMTB0ZmNNZ0w3c3pJOGl6RjNnZm1EbTlCTCtBZzNjRVZRaWJiWEF0K29Q?=
 =?utf-8?B?MENJcDRTYWgweVd2cURuVGpuUkx4ZXBYaFZJbFZ1QW1mU1QzdWRHWEVZMGtH?=
 =?utf-8?B?UkdoaEVzQzFDMWdYSE5Dc2F4UFBrdjltVFdqU3gxOWx0ZmxlLzY3OHBweDVS?=
 =?utf-8?B?ZjBsWDBzbHhYcU4wdEh1WFVKUWhzNTMxbXVBQXY5WGYreHNMQm1JbHFyWUYx?=
 =?utf-8?B?OGxqdWQxMENWaFBmWUNIL2JPbkVnUkhxeVBtUlJIc2owbGxWalB3NkVscW0z?=
 =?utf-8?B?RmxHT1JJZTBzb0dHUTUwUTVGYU5UUnFaN2ZDSzhIU09VUkFSZHdUa1lVKzlI?=
 =?utf-8?B?Nm5XWmYreHhLblVDZU9SREZKL2tCSE5TVElNTWhHTlZXaG1ncUhIYVVKUEVV?=
 =?utf-8?B?alMzR2NVM1NySC9aT3ZqK3UvL3JWd21jaTZ2YXg0Tm9hOVE0SnpsRmU1STZ3?=
 =?utf-8?B?Nm03TmVXU0pQdGc4dmo2UE5UOHYzRzJiY05LS2N4L0FqcTdkYjhKbk5iRVJH?=
 =?utf-8?Q?FjXbqwS+40hg3VQn3yarQ/f6N?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c66ab4-5693-4a01-ac20-08db23bf341a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 12:33:52.6206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N14Bue4Fg5DAijfkH+yUH6rhk7/p5PC/pkPJFC/7UP8e7LzV7leMR/Gsu5zgXGc4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4353
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/10/23 10:34, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Tue, Mar 7, 2023 at 7:37 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
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
>>          return rc;
>>   }
>>
>> +static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
>> +{
>> +       /* The first VI is reserved for MCDI
>> +        * 1 VI each for rx + tx ring
>> +        */
>> +       unsigned int max_vis = 1 + EF100_VDPA_MAX_QUEUES_PAIRS;
>> +       unsigned int min_vis = 1 + 1;
>> +       int rc;
>> +
>> +       rc = efx_mcdi_alloc_vis(efx, min_vis, max_vis,
>> +                               NULL, allocated_vis);
>> +       if (!rc)
>> +               return rc;
>> +       if (*allocated_vis < min_vis)
>> +               return -ENOSPC;
>> +       return 0;
>> +}
>> +
>>   static void ef100_vdpa_delete(struct efx_nic *efx)
>>   {
>>          if (efx->vdpa_nic) {
>>                  /* replace with _vdpa_unregister_device later */
>>                  put_device(&efx->vdpa_nic->vdpa_dev.dev);
>>          }
>> +       efx_mcdi_free_vis(efx);
>>   }
>>
>>   void ef100_vdpa_fini(struct efx_probe_data *probe_data)
>> @@ -104,9 +124,19 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>   {
>>          struct ef100_nic_data *nic_data = efx->nic_data;
>>          struct ef100_vdpa_nic *vdpa_nic;
>> +       unsigned int allocated_vis;
>>          int rc;
>> +       u8 i;
>>
>>          nic_data->vdpa_class = dev_type;
>> +       rc = vdpa_allocate_vis(efx, &allocated_vis);
>> +       if (rc) {
>> +               pci_err(efx->pci_dev,
>> +                       "%s Alloc VIs failed for vf:%u error:%d\n",
>> +                        __func__, nic_data->vf_index, rc);
>> +               return ERR_PTR(rc);
>> +       }
>> +
>>          vdpa_nic = vdpa_alloc_device(struct ef100_vdpa_nic,
>>                                       vdpa_dev, &efx->pci_dev->dev,
>>                                       &ef100_vdpa_config_ops,
>> @@ -117,7 +147,8 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>                          "vDPA device allocation failed for vf: %u\n",
>>                          nic_data->vf_index);
>>                  nic_data->vdpa_class = EF100_VDPA_CLASS_NONE;
>> -               return ERR_PTR(-ENOMEM);
>> +               rc = -ENOMEM;
>> +               goto err_alloc_vis_free;
>>          }
>>
>>          mutex_init(&vdpa_nic->lock);
>> @@ -125,11 +156,21 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>          vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
>>          vdpa_nic->vdpa_dev.mdev = efx->mgmt_dev;
>>          vdpa_nic->efx = efx;
>> +       vdpa_nic->max_queue_pairs = allocated_vis - 1;
>>          vdpa_nic->pf_index = nic_data->pf_index;
>>          vdpa_nic->vf_index = nic_data->vf_index;
>>          vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>>          vdpa_nic->mac_address = (u8 *)&vdpa_nic->net_config.mac;
>>
>> +       for (i = 0; i < (2 * vdpa_nic->max_queue_pairs); i++) {
>> +               rc = ef100_vdpa_init_vring(vdpa_nic, i);
>> +               if (rc) {
>> +                       pci_err(efx->pci_dev,
>> +                               "vring init idx: %u failed, rc: %d\n", i, rc);
>> +                       goto err_put_device;
>> +               }
>> +       }
>> +
>>          rc = get_net_config(vdpa_nic);
>>          if (rc)
>>                  goto err_put_device;
>> @@ -146,6 +187,9 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>   err_put_device:
>>          /* put_device invokes ef100_vdpa_free */
>>          put_device(&vdpa_nic->vdpa_dev.dev);
>> +
>> +err_alloc_vis_free:
>> +       efx_mcdi_free_vis(efx);
>>          return ERR_PTR(rc);
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
>> +                               EF100_VRING_SIZE_CONFIGURED | \
>> +                               EF100_VRING_READY_CONFIGURED)
>> +#define EF100_VRING_CREATED 0x1000
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
>>          EF100_VDPA_VQ_NTYPES
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
>> +       dma_addr_t desc;
>> +       dma_addr_t avail;
>> +       dma_addr_t used;
>> +       u32 size;
>> +       u16 vring_state;
>> +       u32 last_avail_idx;
>> +       u32 last_used_idx;
>> +       u32 doorbell_offset;
>> +       bool doorbell_offset_valid;
>> +       enum ef100_vdpa_vq_type vring_type;
>> +       struct efx_vring_ctx *vring_ctx;
>> +       char msix_name[EF100_VDPA_MAX_MSIX_NAME_SIZE];
>> +       u32 irq;
>> +       struct vdpa_callback cb;
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
>>          u64 features;
>>          u32 max_queue_pairs;
>>          struct virtio_net_config net_config;
>> +       struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
>>          u8 *mac_address;
>>          bool mac_configured;
>>          struct vdpa_callback cfg_cb;
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
>>          return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>>   }
>>
>> +void ef100_vdpa_irq_vectors_free(void *data)
>> +{
>> +       pci_free_irq_vectors(data);
>> +}
>> +
>> +static int create_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +       struct efx_vring_ctx *vring_ctx;
>> +       u32 vi_index;
>> +
>> +       if (idx % 2) /* Even VQ for RX and odd for TX */
>> +               vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_TYPE_NET_TXQ;
>> +       else
>> +               vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_TYPE_NET_RXQ;
>> +       vi_index = EFX_GET_VI_INDEX(idx);
>> +       vring_ctx = efx_vdpa_vring_init(vdpa_nic->efx, vi_index,
>> +                                       vdpa_nic->vring[idx].vring_type);
>> +       if (IS_ERR(vring_ctx))
>> +               return PTR_ERR(vring_ctx);
>> +
>> +       vdpa_nic->vring[idx].vring_ctx = vring_ctx;
>> +       return 0;
>> +}
>> +
>> +static void delete_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +       efx_vdpa_vring_fini(vdpa_nic->vring[idx].vring_ctx);
>> +       vdpa_nic->vring[idx].vring_ctx = NULL;
>> +}
>> +
>> +static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +       vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
>> +       vdpa_nic->vring[idx].vring_state = 0;
>> +       vdpa_nic->vring[idx].last_avail_idx = 0;
>> +       vdpa_nic->vring[idx].last_used_idx = 0;
>> +}
>> +
>> +int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +       u32 offset;
>> +       int rc;
>> +
>> +       vdpa_nic->vring[idx].irq = -EINVAL;
>> +       rc = create_vring_ctx(vdpa_nic, idx);
>> +       if (rc) {
>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                       "%s: create_vring_ctx failed, idx:%u, err:%d\n",
>> +                       __func__, idx, rc);
>> +               return rc;
>> +       }
>> +
>> +       rc = efx_vdpa_get_doorbell_offset(vdpa_nic->vring[idx].vring_ctx,
>> +                                         &offset);
>> +       if (rc) {
>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                       "%s: get_doorbell failed idx:%u, err:%d\n",
>> +                       __func__, idx, rc);
>> +               goto err_get_doorbell_offset;
>> +       }
>> +       vdpa_nic->vring[idx].doorbell_offset = offset;
>> +       vdpa_nic->vring[idx].doorbell_offset_valid = true;
>> +
>> +       return 0;
>> +
>> +err_get_doorbell_offset:
>> +       delete_vring_ctx(vdpa_nic, idx);
>> +       return rc;
>> +}
>> +
>> +static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
>> +                          const char *caller)
>> +{
>> +       if (unlikely(idx >= (vdpa_nic->max_queue_pairs * 2))) {
>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                       "%s: Invalid qid %u\n", caller, idx);
>> +               return true;
>> +       }
>> +       return false;
>> +}
>> +
>> +static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
>> +                                    u16 idx, u64 desc_area, u64 driver_area,
>> +                                    u64 device_area)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +               return -EINVAL;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       vdpa_nic->vring[idx].desc = desc_area;
>> +       vdpa_nic->vring[idx].avail = driver_area;
>> +       vdpa_nic->vring[idx].used = device_area;
>> +       vdpa_nic->vring[idx].vring_state |= EF100_VRING_ADDRESS_CONFIGURED;
>> +       mutex_unlock(&vdpa_nic->lock);
>> +       return 0;
>> +}
>> +
>> +static void ef100_vdpa_set_vq_num(struct vdpa_device *vdev, u16 idx, u32 num)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +               return;
>> +
>> +       if (!is_power_of_2(num)) {
>> +               dev_err(&vdev->dev, "%s: Index:%u size:%u not power of 2\n",
>> +                       __func__, idx, num);
>> +               return;
>> +       }
> Note that this is not a requirement for packed virtqueue.
>
> """
> Queue Size corresponds to the maximum number of descriptors in the
> virtqueue5. The Queue Size value does not have to be a power of 2.
> """
Yes, but we are using split vrings and virtio spec states "Queue Size 
value is always a power of 2" for Split virtqueues.
>
>> +       if (num > EF100_VDPA_VQ_NUM_MAX_SIZE) {
>> +               dev_err(&vdev->dev, "%s: Index:%u size:%u more than max:%u\n",
>> +                       __func__, idx, num, EF100_VDPA_VQ_NUM_MAX_SIZE);
>> +               return;
>> +       }
>> +       mutex_lock(&vdpa_nic->lock);
>> +       vdpa_nic->vring[idx].size  = num;
>> +       vdpa_nic->vring[idx].vring_state |= EF100_VRING_SIZE_CONFIGURED;
>> +       mutex_unlock(&vdpa_nic->lock);
>> +}
>> +
>> +static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       u32 idx_val;
>> +
>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +               return;
>> +
>> +       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>> +               return;
> In which case could we hit this condition?
I've noticed this condition in regular testing with vhost-vdpa. The 
first couple of kick_vq calls arrive when the HW queues aren't created 
yet. .I think userspace assumes queues to be ready soon after sending 
DRIVER_OK. However, there is a little time window between that and when 
the HW VQs are actually ready for datapath.
>
>> +
>> +       idx_val = idx;
>> +       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
>> +                   vdpa_nic->vring[idx].doorbell_offset);
>> +}
>> +
>> +static void ef100_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx,
>> +                                struct vdpa_callback *cb)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +               return;
>> +
>> +       if (cb)
>> +               vdpa_nic->vring[idx].cb = *cb;
>> +}
>> +
>> +static void ef100_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 idx,
>> +                                   bool ready)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +               return;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       if (ready) {
>> +               vdpa_nic->vring[idx].vring_state |=
>> +                                       EF100_VRING_READY_CONFIGURED;
> I think it would be sufficient to have EF100_VRING_READY_CONFIGURED
> here. With this set, the device can think the vq configuration is done
> by the driver.
>
> Or is there anything special for size and num?
The virtqueue is considered ready for datapath when it is fully 
configured (both size and address set and enabled with set_vq_ready). 
Depending on merely the queue enable (EF100_VRING_READY_CONFIGURED) 
would assume valid values for vq size and addresses, which we wish to avoid.
>
> Thanks
>
>
>> +       } else {
>> +               vdpa_nic->vring[idx].vring_state &=
>> +                                       ~EF100_VRING_READY_CONFIGURED;
>> +       }
>> +       mutex_unlock(&vdpa_nic->lock);
>> +}
>> +
>> +static bool ef100_vdpa_get_vq_ready(struct vdpa_device *vdev, u16 idx)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       bool ready;
>> +
>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +               return false;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       ready = vdpa_nic->vring[idx].vring_state & EF100_VRING_READY_CONFIGURED;
>> +       mutex_unlock(&vdpa_nic->lock);
>> +       return ready;
>> +}
>> +
>> +static int ef100_vdpa_set_vq_state(struct vdpa_device *vdev, u16 idx,
>> +                                  const struct vdpa_vq_state *state)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +               return -EINVAL;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       vdpa_nic->vring[idx].last_avail_idx = state->split.avail_index;
>> +       vdpa_nic->vring[idx].last_used_idx = state->split.avail_index;
>> +       mutex_unlock(&vdpa_nic->lock);
>> +       return 0;
>> +}
>> +
>> +static int ef100_vdpa_get_vq_state(struct vdpa_device *vdev,
>> +                                  u16 idx, struct vdpa_vq_state *state)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +               return -EINVAL;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       state->split.avail_index = (u16)vdpa_nic->vring[idx].last_used_idx;
>> +       mutex_unlock(&vdpa_nic->lock);
>> +
>> +       return 0;
>> +}
>> +
>> +static struct vdpa_notification_area
>> +               ef100_vdpa_get_vq_notification(struct vdpa_device *vdev,
>> +                                              u16 idx)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       struct vdpa_notification_area notify_area = {0, 0};
>> +
>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +               goto end;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       notify_area.addr = (uintptr_t)(vdpa_nic->efx->membase_phys +
>> +                               vdpa_nic->vring[idx].doorbell_offset);
>> +       /* VDPA doorbells are at a stride of VI/2
>> +        * One VI stride is shared by both rx & tx doorbells
>> +        */
>> +       notify_area.size = vdpa_nic->efx->vi_stride / 2;
>> +       mutex_unlock(&vdpa_nic->lock);
>> +
>> +end:
>> +       return notify_area;
>> +}
>> +
>> +static int ef100_get_vq_irq(struct vdpa_device *vdev, u16 idx)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       u32 irq;
>> +
>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>> +               return -EINVAL;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       irq = vdpa_nic->vring[idx].irq;
>> +       mutex_unlock(&vdpa_nic->lock);
>> +
>> +       return irq;
>> +}
>> +
>>   static u32 ef100_vdpa_get_vq_align(struct vdpa_device *vdev)
>>   {
>>          return EF100_VDPA_VQ_ALIGN;
>> @@ -80,6 +337,8 @@ static void ef100_vdpa_set_config_cb(struct vdpa_device *vdev,
>>
>>          if (cb)
>>                  vdpa_nic->cfg_cb = *cb;
>> +       else
>> +               memset(&vdpa_nic->cfg_cb, 0, sizeof(vdpa_nic->cfg_cb));
>>   }
>>
>>   static u16 ef100_vdpa_get_vq_num_max(struct vdpa_device *vdev)
>> @@ -137,14 +396,30 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
>>   static void ef100_vdpa_free(struct vdpa_device *vdev)
>>   {
>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       int i;
>>
>>          if (vdpa_nic) {
>> +               for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>> +                       reset_vring(vdpa_nic, i);
>> +                       if (vdpa_nic->vring[i].vring_ctx)
>> +                               delete_vring_ctx(vdpa_nic, i);
>> +               }
>>                  mutex_destroy(&vdpa_nic->lock);
>>                  vdpa_nic->efx->vdpa_nic = NULL;
>>          }
>>   }
>>
>>   const struct vdpa_config_ops ef100_vdpa_config_ops = {
>> +       .set_vq_address      = ef100_vdpa_set_vq_address,
>> +       .set_vq_num          = ef100_vdpa_set_vq_num,
>> +       .kick_vq             = ef100_vdpa_kick_vq,
>> +       .set_vq_cb           = ef100_vdpa_set_vq_cb,
>> +       .set_vq_ready        = ef100_vdpa_set_vq_ready,
>> +       .get_vq_ready        = ef100_vdpa_get_vq_ready,
>> +       .set_vq_state        = ef100_vdpa_set_vq_state,
>> +       .get_vq_state        = ef100_vdpa_get_vq_state,
>> +       .get_vq_notification = ef100_vdpa_get_vq_notification,
>> +       .get_vq_irq          = ef100_get_vq_irq,
>>          .get_vq_align        = ef100_vdpa_get_vq_align,
>>          .get_device_features = ef100_vdpa_get_device_features,
>>          .set_driver_features = ef100_vdpa_set_driver_features,
>> --
>> 2.30.1
>>
