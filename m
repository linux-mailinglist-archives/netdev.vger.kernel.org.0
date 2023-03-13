Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647EA6B7F51
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 18:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjCMRWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 13:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjCMRVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 13:21:41 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20629.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A432081CDC;
        Mon, 13 Mar 2023 10:20:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+CegSyXOpIXjhHUwuDwgvLSSCJMW2pzQuFr3IVlGE+Uf+s5MyZgkUZBYxsvSBcCjJgp6Hj8dX1gh22IwdOeOMhwVmMuTfPNa2oT05+nOrQTNoPrGLWFYSfREeq6TExbBMlGdwtFTvkcvBp8KK3mv1KXBuJh/TTwm1mzsvKV65UzK1mOvAP66VFIlSkgDBbVlLB18oVdTcDSzBHfdSvEOYJx4h32hs1jO5JnC+9dpMqH3mmBLBQbfC/geThj2tx6PlGDZGzDITMBvv0NMRL4lvAemincUTM5J09uBOrdH5JUSly3yO0eABd06JNt3FP6PIyu2RCbeu6LZlcRIvJxvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11Q6Mmiqx1ClcdLLlx+e/0xWJg3wzuEWUELD7LXoXVI=;
 b=MRiI57i0WelwcXkBZbBmRTeZKfAU8oWG2VPtcXg8lhDCr+5g0KmOLvX7dcFohgcQj8H5tKkhzk/3XQWr4DKywtsZmaJQVKM1euKySgl0JZdDdHF2HcJSjCz4gKZHbVy6aUVvMTek7NiVS4inxUVvMKpuhaDPnrymw2rz7PyFApK1Y/Nhca02722Vm2vbR9cEIAKEX+o4i/PqqRtPZxKpLPMxJXJ4jeaI+s4f26nV5g/0bk2thAnjf77HrLaNCW0fWGJhEUGXzgyLyziBMuGrzwglqHghSyQV02ME2Iu6COlX+YGhUtTSjBxqyZeYlD8wGELiUcZkhxszJF/dOU6Hqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11Q6Mmiqx1ClcdLLlx+e/0xWJg3wzuEWUELD7LXoXVI=;
 b=nyI3nmWvUi4q4F8T3MqtXfWcaxOECN4vhS480lhDF8rp3AL0dX3j2ySvoePVLLiX2ggHdMINapaHF5bGO3+CNznGvtYkwW3LWYWmh3kjT33XmJcchowrbYrxg9wNOM02wdbGhNb+QygET1xbOWWasN+059wrWaTFnlYikrHkygs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by DM4PR12MB5054.namprd12.prod.outlook.com (2603:10b6:5:389::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 17:19:21 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 17:19:21 +0000
Message-ID: <0f32e6fc-deaf-c65c-4ffe-f8f7c1139346@amd.com>
Date:   Mon, 13 Mar 2023 22:49:08 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 11/14] sfc: use PF's IOMMU domain for running
 VF's MCDI commands
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
 <20230307113621.64153-12-gautam.dawar@amd.com> <ZAjNbSN38YY+vbwS@gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <ZAjNbSN38YY+vbwS@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0015.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::20) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|DM4PR12MB5054:EE_
X-MS-Office365-Filtering-Correlation-Id: 31cc29d2-0b6c-49b0-47a7-08db23e715c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RbI9XEzLUQdr3W9Tj766S2xAm0Yr++Ur2wcIedn4+4UI+DcjWPAvnwyDHRKj8VRJaAN5QY+IPfO4PK/ckXIGbP51HdI9ZZ507CZecgNLop/Jnwqxkeyybn8o5drU8Uae1h05LG+1tjpgBW7wEjc52sB3lcoicdewxL3x8bsucy5NcNn2znP7ePjrIAkge1eTzdyUGX61VjQRVfcbRlp/R4kG488PryJsaIh4Z9Nr7r3Gay0mT/jybHXCFRLCsAC+81tr5ip0yccBD9hWzQmWmA76fY0Q3aXzryjy66QcyO/LWsFVOIrLrJESbZp36g6PznM/xWu1WDvsBUmC1GKdhZ5ntfoE+WLVzbPu5jNWZ7TmD/dkx1IS7qTb+mChxGh67R9DTPpeyLoGTYjq8tbQZOCRm2TWnvyF09D2S2bcogTOP87XYP9ufqEb1TiaMrFQ1JhRsIMnYCA2kK1rQXMJBV/uwjkOmUg27RzRvlJhVckXt1fc51wlMGrVZiAO7hegMxLLQ033YCnOr2Q2VBbxXJVaeAzaxATB2IBS26i0XY+XYmKcrKzPsE5A8PrcpCL56eYNp2eP7xyig7xLYMcQvvr9mLLidQe2p+jtJ6kWo9ocr61CzWuOvyeURoGldsxvUGee7r6LnvkRGNeLb0imMBBNOGtJlCH+NkEGHLWKUnVIP9yFecEzsPy2eYqe5TB1E7mOyW0EN/o86enDd37WVeiC4c58rogbhcGHTCzZuOdH0mpX+1x69DogveR+uAEk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(451199018)(31686004)(7416002)(5660300002)(8936002)(2616005)(26005)(186003)(41300700001)(6512007)(53546011)(6506007)(36756003)(31696002)(2906002)(30864003)(83380400001)(6666004)(66556008)(66476007)(8676002)(6486002)(110136005)(66946007)(6636002)(316002)(478600001)(921005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TE5GbjQzN0ErODRGeitPQnV1TjY4a1YrTUswVlpwaVBCMStuVjZ4OGdlSnNj?=
 =?utf-8?B?S1NXc1o0V3dBbXVESEdydEhlOFpSWStlT3NtUTgzNTZkdzd4WEtTQVI5MWhB?=
 =?utf-8?B?azZobEVRV2xGYUk0RVRha2h3Q1ZEZkV6SG1qbzBZcVJwSG9QcnBlWGxFbTgv?=
 =?utf-8?B?MjFUK3ovb3NHMWhFV0xIT1FFbFU4RjZTbjRuUVJyVnF2WjJIY3V5elhJNE1x?=
 =?utf-8?B?cmRqOU5FUTlxTnA5bGY0c2loV1ltdHNZb3JEMVhkekV6ZGt0VVZmQ3d6ZEk5?=
 =?utf-8?B?MnRSb2MwMFBWOWVDdTBNM2hUUE5OWXBoOE9SbThBZWNXbW13MkNIZVVzc0dP?=
 =?utf-8?B?UnV2OStiTDBTNURDNUF5Q3JxYkJsY0tEdm9IZ0RPZUpxUmlERnVNTU1COXNO?=
 =?utf-8?B?TXlTcDlPNVd2NzRjazBxZTZtM1V0anU4RkJzOW1wRWZCRm9ZVW01WDh1eS9D?=
 =?utf-8?B?RExGei90MmtkdkZra2Y2aUZMV3pjN3g1bGxnZUlCdjJRU2FodXp4MHdseDRH?=
 =?utf-8?B?OFhhOVRHc24rdFJNREdxdG9BNXJWald3VVorZXpCOWxYTW4wUkpXdnY0SmYv?=
 =?utf-8?B?YU82MDFId3JGanhzS05JL1hsMnJnYXpLT0gvRm9mTTZvZjc4REswdm5sZ3BN?=
 =?utf-8?B?KzJKcHVwazkvSjQ3VE1rbUdwbmhLQmpMT0FmenNHSzYvQWR3NEZXS2trZXVJ?=
 =?utf-8?B?ektYYTY0M0REZHlXa01QZm9HUTJCVUNHZXYzdUdGeXN2N1ArNHpFYjc2U3B3?=
 =?utf-8?B?Lzh4Z0d2WGRiQXY1d3dKRFltOWw1ZjRmdEdqZmwvMVJLZGZDaTJoREc0L1JL?=
 =?utf-8?B?eDdJZXJndVJTR0VEWnhvU0Z2ckxGWGxwTktZcENPZHBXRnhud243bjFCNlJz?=
 =?utf-8?B?WGZjR0R1eUJCVFhOSFJmcmF4aWU3d2lpOWgvYlBobEtTZ214QnArL09vR3Jl?=
 =?utf-8?B?bElrV0x1d2dHQU9sRVdYZGVXVGlCNEdCY1lXK1NENlFJWGpGNFhuMGdQUzho?=
 =?utf-8?B?NmVORU5WSVNnbzBzOVVFNDVZNVVuUjNmL1dRL1Zsa1loYmZBTFkxL3owbmwy?=
 =?utf-8?B?NVlJQW1FSlhCN3B2RUR5SXJHMW5Hc1dIS1dCY3JNaFVtU2tONEVRNVBmV3Rx?=
 =?utf-8?B?dlVzaEtxMnc0MnRjWm5xV3pnTEd4TSthWk5iaWszVTE4c0V0b3ZhMGMxcFV5?=
 =?utf-8?B?REdMMVJCMzJVa1R6MHBBUGI2Zlg4d1FhSEdJTGlqQjEzSURJNHZRUy9ZenNQ?=
 =?utf-8?B?dWluM2ZrTnpGREFvM1NUYStUdnptcEFIcXJHdFNHS2paVE1LRW1KNjkxeXNJ?=
 =?utf-8?B?OHNobElaa0wzWmNRUk5oWGxwSys4Mk9PRkNWTE9jL0Y0K001N3hXNnhTNmxp?=
 =?utf-8?B?bU45ZEpzbU4weStLVEptb3FicmxVczFJd1pHR056Z1N0LzJaVUZ2bTUyZjgx?=
 =?utf-8?B?V0g3RGYvcjVvTmhZUGY1RjRzbCt3ZUI2STVpTDd1eFoxL1Y3RDJsWmZ3OWlI?=
 =?utf-8?B?OFUxc0hJbFFLdnhya3lVQzJ3SFBLSDhSUzVXNzhIUlFmTTRFS01mNFQ4NFBU?=
 =?utf-8?B?TFgrWWNLMFhoUUlwbEpvR3oxeVpkT3dKRTdFcDVLbVAxSEVoYnBhNVdnKy9S?=
 =?utf-8?B?eUhUbCtzTGUrVzR0R3RmSWxVNzYyazh0YWlyUmFGTGxHZ2JocWdpcDAvdGJD?=
 =?utf-8?B?TDhwM3pSTzdtZWdGdXpiKzgzVlY2eWE0VkhmQkI4M1pHNXBLcW1ZQkc3V2dx?=
 =?utf-8?B?VWZCc0VMTkVGNGsrdXdzTU5PZm54OEJCbzhjWE5mWHdySmlRcGFHQ2F5NjNh?=
 =?utf-8?B?VnUvY3hzSitDb1JicHA4WnRxWmtONG5jdXpMaTFtZVc1T0RuOW9OYU1QK3hr?=
 =?utf-8?B?YnpyRjRvcFdMV1J0MjR0L01lSzdHaXNqeVMvZnd2UnNXL1BrN0svNzJUVjdw?=
 =?utf-8?B?YWl1SGNJaHlsdngrTE05Z2NaRmxRdDRnWXh4YmFnbWY5VlU2T0d5TlhVNkt4?=
 =?utf-8?B?SmhiZm01anBrV0ZYVmVmZThrY0dWek1BY2JTK3lVM09UWXJ2RE01TjYrMnBm?=
 =?utf-8?B?WGVIbEdFb0xOMDhGbWc3YTIwa0tlWEdVQWYrN3puMktjdUxwd3Vnc0RjejI4?=
 =?utf-8?Q?CIgtbFt5AJ3gYh0XU4NJIT9cw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31cc29d2-0b6c-49b0-47a7-08db23e715c4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 17:19:21.3753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qv4jtRL+z6CqpgEMUJ248NtsEWOTC+ZP3dYZ4qkf3eRcPOOUl1tH5pVbt7ArbSMt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5054
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/8/23 23:31, Martin Habets wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Tue, Mar 07, 2023 at 05:06:13PM +0530, Gautam Dawar wrote:
>> This changeset uses MC_CMD_CLIENT_CMD to execute VF's MCDI
>> commands when running in vDPA mode (STATE_VDPA).
>> Also, use the PF's IOMMU domain for executing the encapsulated
>> VF's MCDI commands to isolate DMA of guest buffers in the VF's
>> IOMMU domain.
>> This patch also updates the PCIe FN's client id in the efx_nic
>> structure which is required while running MC_CMD_CLIENT_CMD.
>>
>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>> ---
>>   drivers/net/ethernet/sfc/ef100.c      |   1 +
>>   drivers/net/ethernet/sfc/ef100_nic.c  |  35 +++++++++
>>   drivers/net/ethernet/sfc/mcdi.c       | 108 ++++++++++++++++++++++----
>>   drivers/net/ethernet/sfc/mcdi.h       |   2 +-
>>   drivers/net/ethernet/sfc/net_driver.h |   2 +
>>   drivers/net/ethernet/sfc/ptp.c        |   4 +-
>>   6 files changed, 132 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
>> index c1c69783db7b..8453c9ba0f41 100644
>> --- a/drivers/net/ethernet/sfc/ef100.c
>> +++ b/drivers/net/ethernet/sfc/ef100.c
>> @@ -465,6 +465,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
>>        efx->type = (const struct efx_nic_type *)entry->driver_data;
>>
>>        efx->pci_dev = pci_dev;
>> +     efx->client_id = MC_CMD_CLIENT_ID_SELF;
>>        pci_set_drvdata(pci_dev, efx);
>>        rc = efx_init_struct(efx, pci_dev);
>>        if (rc)
>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>> index bda4fcbe1126..cd9f724a9e64 100644
>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
>> @@ -206,9 +206,11 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
>>                  "firmware reports num_mac_stats = %u\n",
>>                  efx->num_mac_stats);
>>
>> +#ifdef CONFIG_SFC_VDPA
> More opportunities to use IS_ENABLED(CONFIG_SFC_VDPA) in this patch
> in stead of the #ifdef.

Will fix the occurrence where nic_data->vdpa_supported is being updated. 
However, I am not sure if using something like:

if (IS_ENABLED(CONFIG_SFC_VDPA) && (new_config == EF100_BAR_CONFIG_VDPA 
&& !nic_data->vdpa_supported))

to replace

#ifdef CONFIG_SFC_VDPA
         if (new_config == EF100_BAR_CONFIG_VDPA && 
!nic_data->vdpa_supported) {

would be correct as vdpa_supported itself is conditionally defined:

struct ef100_nic_data {

...

#ifdef CONFIG_SFC_VDPA
         bool vdpa_supported; /* true if vdpa is supported on this PCIe 
FN */
  ...

}

Another way would be to use nested if statements but not sure if it is 
really needed.

Thanks

>
> Martin
>
>>        nic_data->vdpa_supported = efx_ef100_has_cap(nic_data->datapath_caps3,
>>                                                     CLIENT_CMD_VF_PROXY) &&
>>                                   efx->type->is_vf;
>> +#endif
>>        return 0;
>>   }
>>
>> @@ -1086,6 +1088,35 @@ static int ef100_check_design_params(struct efx_nic *efx)
>>        return rc;
>>   }
>>
>> +static int efx_ef100_update_client_id(struct efx_nic *efx)
>> +{
>> +     struct ef100_nic_data *nic_data = efx->nic_data;
>> +     unsigned int pf_index = PCIE_FUNCTION_PF_NULL;
>> +     unsigned int vf_index = PCIE_FUNCTION_VF_NULL;
>> +     efx_qword_t pciefn;
>> +     int rc;
>> +
>> +     if (efx->pci_dev->is_virtfn)
>> +             vf_index = nic_data->vf_index;
>> +     else
>> +             pf_index = nic_data->pf_index;
>> +
>> +     /* Construct PCIE_FUNCTION structure */
>> +     EFX_POPULATE_QWORD_3(pciefn,
>> +                          PCIE_FUNCTION_PF, pf_index,
>> +                          PCIE_FUNCTION_VF, vf_index,
>> +                          PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
>> +     /* look up self client ID */
>> +     rc = efx_ef100_lookup_client_id(efx, pciefn, &efx->client_id);
>> +     if (rc) {
>> +             pci_warn(efx->pci_dev,
>> +                      "%s: Failed to get client ID, rc %d\n",
>> +                      __func__, rc);
>> +     }
>> +
>> +     return rc;
>> +}
>> +
>>   /*   NIC probe and remove
>>    */
>>   static int ef100_probe_main(struct efx_nic *efx)
>> @@ -1173,6 +1204,10 @@ static int ef100_probe_main(struct efx_nic *efx)
>>                goto fail;
>>        efx->port_num = rc;
>>
>> +     rc = efx_ef100_update_client_id(efx);
>> +     if (rc)
>> +             goto fail;
>> +
>>        efx_mcdi_print_fwver(efx, fw_version, sizeof(fw_version));
>>        pci_dbg(efx->pci_dev, "Firmware version %s\n", fw_version);
>>
>> diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
>> index a7f2c31071e8..3bf1ebe05775 100644
>> --- a/drivers/net/ethernet/sfc/mcdi.c
>> +++ b/drivers/net/ethernet/sfc/mcdi.c
>> @@ -145,14 +145,15 @@ void efx_mcdi_fini(struct efx_nic *efx)
>>        kfree(efx->mcdi);
>>   }
>>
>> -static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
>> -                               const efx_dword_t *inbuf, size_t inlen)
>> +static void efx_mcdi_send_request(struct efx_nic *efx, u32 client_id,
>> +                               unsigned int cmd, const efx_dword_t *inbuf,
>> +                               size_t inlen)
>>   {
>>        struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
>>   #ifdef CONFIG_SFC_MCDI_LOGGING
>>        char *buf = mcdi->logging_buffer; /* page-sized */
>>   #endif
>> -     efx_dword_t hdr[2];
>> +     efx_dword_t hdr[5];
>>        size_t hdr_len;
>>        u32 xflags, seqno;
>>
>> @@ -179,7 +180,7 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
>>                                     MCDI_HEADER_XFLAGS, xflags,
>>                                     MCDI_HEADER_NOT_EPOCH, !mcdi->new_epoch);
>>                hdr_len = 4;
>> -     } else {
>> +     } else if (client_id == efx->client_id) {
>>                /* MCDI v2 */
>>                BUG_ON(inlen > MCDI_CTL_SDU_LEN_MAX_V2);
>>                EFX_POPULATE_DWORD_7(hdr[0],
>> @@ -194,6 +195,35 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
>>                                     MC_CMD_V2_EXTN_IN_EXTENDED_CMD, cmd,
>>                                     MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen);
>>                hdr_len = 8;
>> +     } else {
>> +             /* MCDI v2 */
>> +             WARN_ON(inlen > MCDI_CTL_SDU_LEN_MAX_V2);
>> +             /* MCDI v2 with credentials of a different client */
>> +             BUILD_BUG_ON(MC_CMD_CLIENT_CMD_IN_LEN != 4);
>> +             /* Outer CLIENT_CMD wrapper command with client ID */
>> +             EFX_POPULATE_DWORD_7(hdr[0],
>> +                                  MCDI_HEADER_RESPONSE, 0,
>> +                                  MCDI_HEADER_RESYNC, 1,
>> +                                  MCDI_HEADER_CODE, MC_CMD_V2_EXTN,
>> +                                  MCDI_HEADER_DATALEN, 0,
>> +                                  MCDI_HEADER_SEQ, seqno,
>> +                                  MCDI_HEADER_XFLAGS, xflags,
>> +                                  MCDI_HEADER_NOT_EPOCH, !mcdi->new_epoch);
>> +             EFX_POPULATE_DWORD_2(hdr[1],
>> +                                  MC_CMD_V2_EXTN_IN_EXTENDED_CMD,
>> +                                  MC_CMD_CLIENT_CMD,
>> +                                  MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen + 12);
>> +             MCDI_SET_DWORD(&hdr[2],
>> +                            CLIENT_CMD_IN_CLIENT_ID, client_id);
>> +
>> +             /* MCDIv2 header for inner command */
>> +             EFX_POPULATE_DWORD_2(hdr[3],
>> +                                  MCDI_HEADER_CODE, MC_CMD_V2_EXTN,
>> +                                  MCDI_HEADER_DATALEN, 0);
>> +             EFX_POPULATE_DWORD_2(hdr[4],
>> +                                  MC_CMD_V2_EXTN_IN_EXTENDED_CMD, cmd,
>> +                                  MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen);
>> +             hdr_len = 20;
>>        }
>>
>>   #ifdef CONFIG_SFC_MCDI_LOGGING
>> @@ -474,7 +504,8 @@ static void efx_mcdi_release(struct efx_mcdi_iface *mcdi)
>>                        &mcdi->async_list, struct efx_mcdi_async_param, list);
>>                if (async) {
>>                        mcdi->state = MCDI_STATE_RUNNING_ASYNC;
>> -                     efx_mcdi_send_request(efx, async->cmd,
>> +                     efx_mcdi_send_request(efx, efx->client_id,
>> +                                           async->cmd,
>>                                              (const efx_dword_t *)(async + 1),
>>                                              async->inlen);
>>                        mod_timer(&mcdi->async_timer,
>> @@ -797,7 +828,7 @@ static int efx_mcdi_proxy_wait(struct efx_nic *efx, u32 handle, bool quiet)
>>        return mcdi->proxy_rx_status;
>>   }
>>
>> -static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
>> +static int _efx_mcdi_rpc(struct efx_nic *efx, u32 client_id, unsigned int cmd,
>>                         const efx_dword_t *inbuf, size_t inlen,
>>                         efx_dword_t *outbuf, size_t outlen,
>>                         size_t *outlen_actual, bool quiet, int *raw_rc)
>> @@ -811,7 +842,7 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
>>                return -EINVAL;
>>        }
>>
>> -     rc = efx_mcdi_rpc_start(efx, cmd, inbuf, inlen);
>> +     rc = efx_mcdi_rpc_start(efx, client_id, cmd, inbuf, inlen);
>>        if (rc)
>>                return rc;
>>
>> @@ -836,7 +867,8 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
>>
>>                        /* We now retry the original request. */
>>                        mcdi->state = MCDI_STATE_RUNNING_SYNC;
>> -                     efx_mcdi_send_request(efx, cmd, inbuf, inlen);
>> +                     efx_mcdi_send_request(efx, efx->client_id, cmd,
>> +                                           inbuf, inlen);
>>
>>                        rc = _efx_mcdi_rpc_finish(efx, cmd, inlen,
>>                                                  outbuf, outlen, outlen_actual,
>> @@ -855,16 +887,44 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
>>        return rc;
>>   }
>>
>> +#ifdef CONFIG_SFC_VDPA
>> +static bool is_mode_vdpa(struct efx_nic *efx)
>> +{
>> +     if (efx->pci_dev->is_virtfn &&
>> +         efx->pci_dev->physfn &&
>> +         efx->state == STATE_VDPA &&
>> +         efx->vdpa_nic)
>> +             return true;
>> +
>> +     return false;
>> +}
>> +#endif
>> +
>>   static int _efx_mcdi_rpc_evb_retry(struct efx_nic *efx, unsigned cmd,
>>                                   const efx_dword_t *inbuf, size_t inlen,
>>                                   efx_dword_t *outbuf, size_t outlen,
>>                                   size_t *outlen_actual, bool quiet)
>>   {
>> +#ifdef CONFIG_SFC_VDPA
>> +     struct efx_nic *efx_pf;
>> +#endif
>>        int raw_rc = 0;
>>        int rc;
>>
>> -     rc = _efx_mcdi_rpc(efx, cmd, inbuf, inlen,
>> -                        outbuf, outlen, outlen_actual, true, &raw_rc);
>> +#ifdef CONFIG_SFC_VDPA
>> +     if (is_mode_vdpa(efx)) {
>> +             efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
>> +             rc = _efx_mcdi_rpc(efx_pf, efx->client_id, cmd, inbuf,
>> +                                inlen, outbuf, outlen, outlen_actual,
>> +                                true, &raw_rc);
>> +     } else {
>> +#endif
>> +             rc = _efx_mcdi_rpc(efx, efx->client_id, cmd, inbuf,
>> +                                inlen, outbuf, outlen, outlen_actual, true,
>> +                                &raw_rc);
>> +#ifdef CONFIG_SFC_VDPA
>> +     }
>> +#endif
>>
>>        if ((rc == -EPROTO) && (raw_rc == MC_CMD_ERR_NO_EVB_PORT) &&
>>            efx->type->is_vf) {
>> @@ -881,9 +941,22 @@ static int _efx_mcdi_rpc_evb_retry(struct efx_nic *efx, unsigned cmd,
>>
>>                do {
>>                        usleep_range(delay_us, delay_us + 10000);
>> -                     rc = _efx_mcdi_rpc(efx, cmd, inbuf, inlen,
>> -                                        outbuf, outlen, outlen_actual,
>> -                                        true, &raw_rc);
>> +#ifdef CONFIG_SFC_VDPA
>> +                     if (is_mode_vdpa(efx)) {
>> +                             efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
>> +                             rc = _efx_mcdi_rpc(efx_pf, efx->client_id, cmd,
>> +                                                inbuf, inlen, outbuf, outlen,
>> +                                                outlen_actual, true,
>> +                                                &raw_rc);
>> +                     } else {
>> +#endif
>> +                             rc = _efx_mcdi_rpc(efx, efx->client_id,
>> +                                                cmd, inbuf, inlen, outbuf,
>> +                                                outlen, outlen_actual, true,
>> +                                                &raw_rc);
>> +#ifdef CONFIG_SFC_VDPA
>> +                     }
>> +#endif
>>                        if (delay_us < 100000)
>>                                delay_us <<= 1;
>>                } while ((rc == -EPROTO) &&
>> @@ -939,7 +1012,7 @@ int efx_mcdi_rpc(struct efx_nic *efx, unsigned cmd,
>>    * function and is then responsible for calling efx_mcdi_display_error
>>    * as needed.
>>    */
>> -int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
>> +int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned int cmd,
>>                       const efx_dword_t *inbuf, size_t inlen,
>>                       efx_dword_t *outbuf, size_t outlen,
>>                       size_t *outlen_actual)
>> @@ -948,7 +1021,7 @@ int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
>>                                       outlen_actual, true);
>>   }
>>
>> -int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
>> +int efx_mcdi_rpc_start(struct efx_nic *efx, u32 client_id, unsigned int cmd,
>>                       const efx_dword_t *inbuf, size_t inlen)
>>   {
>>        struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
>> @@ -965,7 +1038,7 @@ int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
>>                return -ENETDOWN;
>>
>>        efx_mcdi_acquire_sync(mcdi);
>> -     efx_mcdi_send_request(efx, cmd, inbuf, inlen);
>> +     efx_mcdi_send_request(efx, client_id, cmd, inbuf, inlen);
>>        return 0;
>>   }
>>
>> @@ -1009,7 +1082,8 @@ static int _efx_mcdi_rpc_async(struct efx_nic *efx, unsigned int cmd,
>>                 */
>>                if (mcdi->async_list.next == &async->list &&
>>                    efx_mcdi_acquire_async(mcdi)) {
>> -                     efx_mcdi_send_request(efx, cmd, inbuf, inlen);
>> +                     efx_mcdi_send_request(efx, efx->client_id,
>> +                                           cmd, inbuf, inlen);
>>                        mod_timer(&mcdi->async_timer,
>>                                  jiffies + MCDI_RPC_TIMEOUT);
>>                }
>> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
>> index dafab52aaef7..2c526d2edeb6 100644
>> --- a/drivers/net/ethernet/sfc/mcdi.h
>> +++ b/drivers/net/ethernet/sfc/mcdi.h
>> @@ -150,7 +150,7 @@ int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
>>                       efx_dword_t *outbuf, size_t outlen,
>>                       size_t *outlen_actual);
>>
>> -int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
>> +int efx_mcdi_rpc_start(struct efx_nic *efx, u32 client_id, unsigned int cmd,
>>                       const efx_dword_t *inbuf, size_t inlen);
>>   int efx_mcdi_rpc_finish(struct efx_nic *efx, unsigned cmd, size_t inlen,
>>                        efx_dword_t *outbuf, size_t outlen,
>> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
>> index 1da71deac71c..948c7a06403a 100644
>> --- a/drivers/net/ethernet/sfc/net_driver.h
>> +++ b/drivers/net/ethernet/sfc/net_driver.h
>> @@ -859,6 +859,7 @@ struct efx_mae;
>>    * @secondary_list: List of &struct efx_nic instances for the secondary PCI
>>    *   functions of the controller, if this is for the primary function.
>>    *   Serialised by rtnl_lock.
>> + * @client_id: client ID of this PCIe function
>>    * @type: Controller type attributes
>>    * @legacy_irq: IRQ number
>>    * @workqueue: Workqueue for port reconfigures and the HW monitor.
>> @@ -1022,6 +1023,7 @@ struct efx_nic {
>>        struct list_head secondary_list;
>>        struct pci_dev *pci_dev;
>>        unsigned int port_num;
>> +     u32 client_id;
>>        const struct efx_nic_type *type;
>>        int legacy_irq;
>>        bool eeh_disabled_legacy_irq;
>> diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
>> index 9f07e1ba7780..d90d4f6b3824 100644
>> --- a/drivers/net/ethernet/sfc/ptp.c
>> +++ b/drivers/net/ethernet/sfc/ptp.c
>> @@ -1052,8 +1052,8 @@ static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
>>
>>        /* Clear flag that signals MC ready */
>>        WRITE_ONCE(*start, 0);
>> -     rc = efx_mcdi_rpc_start(efx, MC_CMD_PTP, synch_buf,
>> -                             MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
>> +     rc = efx_mcdi_rpc_start(efx, MC_CMD_CLIENT_ID_SELF, MC_CMD_PTP,
>> +                             synch_buf, MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
>>        EFX_WARN_ON_ONCE_PARANOID(rc);
>>
>>        /* Wait for start from MCDI (or timeout) */
>> --
>> 2.30.1
