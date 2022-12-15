Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28BE364D70B
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 08:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiLOHND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 02:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiLOHMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 02:12:36 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDF45EDE5;
        Wed, 14 Dec 2022 23:08:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itGvjB66FfJRneLV4aGEOSiBe3m/y0f0x8aSbwk5D/KQsSaj93Xo7XUdW9Bv4eNxGW0dFzGfD8m+mdkwVR3BAnENjxh8yGeZcV0hQVp5X6JuRiJ6T7l575e5WyeHjflDiDDfyArKFd52heEanUcaAuph0p6W8S9yu+z+Tg1J33MlaYWhz583blEErQ44mBZAjjlVoryaQ/3WjLWoUiUIMi1WeCNq9Trhq+W0fiZd0n+dEWbw1AVOZNEdyb2UDe6hlgHeX4pjv20GxaKrbLo985+xIIHFUKEKibSrmyPoeXOnt7eQg4RCQphbE0z8AO4Bp8e+D7662Q+lmJqGpWKSjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aGUTMQTCBqAIVbtnD/rqgiycYM9XFp8tSeleWzZjPYs=;
 b=VcknSP8JHvBBYoolXUwMhuY6W/XkLnSOf00WOd6O0viad1Sb98QV9v+fDERcYNIYlFOrcRIvf4A6SIl9ftOVYTapNZC2JleMydGQwjSXCtierafCLlMzgTleh6icbl6Kij3nCZ06r38jkHbkZhFv4FmiLZZLM+5TcQIr5M64GrZqJREr8z7hOzJnWW4oQZz0gtcRGOc/OG3iObwAhdYrtwcYZfiHPXbdeuLXyVMQ9VB9ZzVyZ3QKSjRHjlAcBGJbO9VJNFFuxUQ2Tc7RJKgEyTq21a29X2d5BJ5C8NmPbnRjSjcPAoW0mrxvTQCwKMQw54a2814lkZKhvT2Pl3lOfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGUTMQTCBqAIVbtnD/rqgiycYM9XFp8tSeleWzZjPYs=;
 b=gYSO367CokG3RKefLWYVyMn1DMA7suNpBWWTGoQWjlDnMy6qgH38tvNQe1ME+BqtT+kR4W6frgKOuEK0ztZuDs29iPTrGbQ+xgZopUvSMa5CCfnX6td5n3CtZMiCn7WYl1VNIrox8pZ+MMqYpmunZgvxaKU5nU6WqcE0/S8nSFc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by DS7PR12MB5765.namprd12.prod.outlook.com (2603:10b6:8:74::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 07:08:01 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::2e66:40bf:438e:74b]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::2e66:40bf:438e:74b%9]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 07:08:01 +0000
Message-ID: <01edfee3-3704-1698-ac19-fa003f41bea2@amd.com>
Date:   Thu, 15 Dec 2022 12:37:48 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 04/11] sfc: implement vDPA management device
 operations
Content-Language: en-US
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
 <20221207145428.31544-5-gautam.dawar@amd.com>
 <CACGkMEsgxi1MsS-F_uhCoEoJg50-1nxKEi0qz0-oSQRwQDRyKA@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEsgxi1MsS-F_uhCoEoJg50-1nxKEi0qz0-oSQRwQDRyKA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0092.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::10) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|DS7PR12MB5765:EE_
X-MS-Office365-Filtering-Correlation-Id: 019b4941-ab70-48e3-c69b-08dade6b1a2c
X-LD-Processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IJ56uQij4sFHiChM+0EYcgvZZ494yi94MEd5G+3GIqKnpbuiJB8HTws0aPzUJhouf2EvUqTVMjFYkkfT2fZ8/zwXUM271qfvRkyMBHtfo5cmOTtWYlqE7vEpDoowfOS2y4eOUhiOAfbi7nmzzJz8sqgh5g2+bnSHYvGM4SnW6FcqzfASMW5qVDF5MwRe/jir3tzWTiAReA9XwuHF+2oa8UTmIDX6kHMU9g53Q0RybtK6p1ukU/XnF5YsaqvNOXok8SJXbJvurKDbN7FyzCcQXtOeLoK35K2v5GZFSo8SjaifjbqqLAutXoKPFvEEB1hkylzkdse0yRt9tslg3uJWD6268gmN0N1vs4eaGku2EKwnPU2MmvGvW9zO12P+PghDT6F6Y1lSyKPJuuIRNjfdCu0woeEZQRoIK0ZfkHc4OndWBacvjS7LJUtIz/Z3tODWCFVMTiGFy1TlfK3OkNwlfWXl2UfJFyMaoMe+g8oBatqY0h8S1WLKLiQzQxAjgk/rl+SS1O3g3phqzqRSAGECDZFFdT5KptEDxKSRjWI3AMHTAxzxAOwC57vWA44jQuU488ANQcAXTLKWadIcqqElewG3ppA+wcs9p+p/s4rph2hZJ64qhPPKaDHt4lsDxjWCLr1QVRQwKoEI/gmveRsapX5rXpfR+mYMU+aTwefJqYTyoEuxMNTDAh5Xj10JOh3L5TsJwK0dU2fxO5xMqY78JtMcs+PvF65Khv18MLPaLzJoXwk0dLEhL2w1ZCUbEgPY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199015)(8676002)(4326008)(66476007)(66946007)(66556008)(83380400001)(36756003)(41300700001)(186003)(26005)(53546011)(6636002)(6666004)(6486002)(316002)(6512007)(54906003)(31696002)(478600001)(110136005)(2616005)(2906002)(31686004)(6506007)(8936002)(7416002)(5660300002)(38100700002)(30864003)(2004002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVdWVG8wbmpMcGF4V004eGJ5clFkQTZYNDVQdlZPM0FGakxkNmovaWZ1YTdj?=
 =?utf-8?B?T0R1eE1kNkJUallMOGxjbDVacWxGbGVDc0RVTzBxT0VYaVhYVFdtclY4MVMz?=
 =?utf-8?B?cFlNNVNFR3V5K0xXTVVKNzBGNks4Q0gwVXNCKy9nbXh4UGFyYm9SeDVYTXlq?=
 =?utf-8?B?WTlUbU92eDVnZzZVVDJ2WHNnVlQxbzF2QkNkVVhoR0RSTnV6cXhsT2szcHB3?=
 =?utf-8?B?OFZ2NmpFcXk0bWNtajcyRktTUk5YbzRMcmpVMmlvSHlNanBEWmk4blFaREdH?=
 =?utf-8?B?aGluNno2Z0RXQ2xPK1dyaXlFVzdWdWFJbHEzblloaUZ3Z0p0VXZEUkgwVEhG?=
 =?utf-8?B?OXFqTDlWUks4SCt4ZWMrRHNRdWdwNTZjWVlBdklaOUtMMVBpR1NnR2h4LzFm?=
 =?utf-8?B?UDFySFRlbVN0bzV6eVpoVFFteWlQeGQvcjR1TmNlRFV3M01GV1VMY1B3NG5C?=
 =?utf-8?B?VGE0UXU4dE9CeHYza1VabkJjSUlUQWw5OTdiL0NMR2JBekVydkEyUGtkNkxJ?=
 =?utf-8?B?RHQvak1SSEZUNzRPb2tKWFAwYVM1THBhVHVQRUZ5Q0cxelE0eVN4Y0ZLMVVp?=
 =?utf-8?B?UkExMmU4NkEydFlIVWs3cm4wTGZGWnJJUHloZUNWV1RGQkxPbmdZb3QzWTdX?=
 =?utf-8?B?ZHRWSTVwTWVRY2VCUUJvc0lsTlcxVVJqN2p3WTQ4Nk5iYmlEOCs4Wi9ERE9H?=
 =?utf-8?B?QmdpQU1uYU9mN2cwVXdvK0ppb0VkR2pVanFNQmVtU0UrSmhVS1RKNjJRVkJ5?=
 =?utf-8?B?ZFRTcExHK1lZS041NHVlT0JxMERIRE9hL0Z5czJWRVEvK0Y4ZDRnb0dWRmtq?=
 =?utf-8?B?Uzc1STg3Yk9QL2RyYWRyTkJCc1BLU3NQaVFEbGcwb011SnNnVFI0d0ZsWjZk?=
 =?utf-8?B?UmpHa3hPQnp5Y0ZiNnA4ZHNkL2ozZjZXUDBYejAxQTRCaEl5cGtockdHcFJm?=
 =?utf-8?B?eGdJWDlMZFBnNW5KZUdxbm5Ta1VHWUxuVUVNbHM0ZHZpS1pSK2taNlZTbFhl?=
 =?utf-8?B?aWxUNnROTmg1dFlpUmc2QURNVFJBUlZEMERKV0JxOG1oMk5Fd2hXN2ZxY21r?=
 =?utf-8?B?YjMvRzhGWmFaYU1KTlZDY09CM3AyTG5IY2hTR3ZjYnBRd290T1FUeWx2cnB1?=
 =?utf-8?B?UXRYQ0trWTZ1RlJQNlltdDR0UDJXSUEyT0pSWnViQXFCak5kSmp6amNUcjRZ?=
 =?utf-8?B?aEVlRU5yNWh6NW9MbjdoV2J1RjVlT0Nraml4STAwTVNwN01PTHhwY2RFZFdu?=
 =?utf-8?B?MXFvbXIxb0Fmb1pIbGRqUUROWkc1amNXaVpvRVlsZTJiNWtWb1VEa3lQR1p3?=
 =?utf-8?B?b2dHTUNCS283R1V3dnJ2czFYTXdIRFEyRHBvSUExcmppaE55TlRjV2E5TUlD?=
 =?utf-8?B?eGlYeUdoWkVGTVBiSnhkNFREZWluMUlIQmpLdGhtV2ZOVnRvaGNaYWQ5WkNE?=
 =?utf-8?B?RzFyR0FHQTI3R21KYkFpb2VrYVZGWHByK2V3YVpMTTRseFpzYlpjT3l0dlQ3?=
 =?utf-8?B?OXVtWERGZmZaVkdGckdBcWtFSDEvblNocFpUb085VFFwTmhMRjFqWHphSmZ4?=
 =?utf-8?B?WmZzSDNWeEdJRTZSK2hWa3pWVmYxTkJDZ3pNU3Naek5DaS9aaWN0WG5BNG1Y?=
 =?utf-8?B?YlV3RE5mQnB6V3hScnh1V2VDZmFrdUVpdlFCVjRtQm1RKy84NlcxeW9wZ1Zw?=
 =?utf-8?B?S1BlMlRTcFhGNll6WTlxdFliMVZVd2ZRNWhzdkRuU2xacE9RWmI4V3NrL3V0?=
 =?utf-8?B?N3RkMWp6MVRjNjZFVE9CbW5XYXppcjFZRHhkYlZsekVlZXNxMUU5NzF1aUpm?=
 =?utf-8?B?SExieXVGRTJOZjJHb0lOUi81S2NaeC94YUJ3YVZ6T2FDcHhUNVI1a2c5cWV1?=
 =?utf-8?B?MFluZW94cDNSYS94L1ZrYi9WTGx5OGI2a2Vyd0o1bVQrYUJRc3gyeHEyZndL?=
 =?utf-8?B?c3hGQ3B1eDd2Zm9XNTdmTFpZSlROQy9ORWcwSjFUTUR1SDV1SHd2K1I2UVoy?=
 =?utf-8?B?T0pQV2JmZ1g5YnQrUnlVZ3FjeHVJemFlVXhoOVV0aUVYZGprV3plTmtrK0x2?=
 =?utf-8?B?azhVbWxWdXYwTUtKcnZoYXBXazNodW5SZSthSzF5bVFPbEJJV3hrdStGRWtt?=
 =?utf-8?Q?tfIPFZ6cd+78DXlrs5mdzBzIw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 019b4941-ab70-48e3-c69b-08dade6b1a2c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 07:08:01.2261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VCyQCkw8d3mh7vuXFwpR9lNBik1pxODlA1DqPDZLvJDfodjI81ddP7GXftgZo65Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5765
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/14/22 12:13, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Wed, Dec 7, 2022 at 10:56 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>> To allow vDPA device creation and deletion, add a vDPA management
>> device per function. Currently, the vDPA devices can be created
>> only on a VF. Also, for now only network class of vDPA devices
>> are supported.
>>
>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>> ---
>>   drivers/net/ethernet/sfc/Makefile         |   2 +-
>>   drivers/net/ethernet/sfc/ef10.c           |   2 +-
>>   drivers/net/ethernet/sfc/ef100_nic.c      |  24 ++-
>>   drivers/net/ethernet/sfc/ef100_nic.h      |  11 +
>>   drivers/net/ethernet/sfc/ef100_vdpa.c     | 232 ++++++++++++++++++++++
>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |  84 ++++++++
>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  28 +++
>>   drivers/net/ethernet/sfc/mcdi_functions.c |   9 +-
>>   drivers/net/ethernet/sfc/mcdi_functions.h |   3 +-
>>   drivers/net/ethernet/sfc/net_driver.h     |   6 +
>>   10 files changed, 394 insertions(+), 7 deletions(-)
>>   create mode 100644 drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>
>> diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
>> index 84c9f0590368..a10eac91ab23 100644
>> --- a/drivers/net/ethernet/sfc/Makefile
>> +++ b/drivers/net/ethernet/sfc/Makefile
>> @@ -11,7 +11,7 @@ sfc-$(CONFIG_SFC_MTD) += mtd.o
>>   sfc-$(CONFIG_SFC_SRIOV)        += sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
>>                              mae.o tc.o tc_bindings.o tc_counters.o
>>
>> -sfc-$(CONFIG_SFC_VDPA) += mcdi_vdpa.o ef100_vdpa.o
>> +sfc-$(CONFIG_SFC_VDPA) += mcdi_vdpa.o ef100_vdpa.o ef100_vdpa_ops.o
>>   obj-$(CONFIG_SFC)      += sfc.o
>>
>>   obj-$(CONFIG_SFC_FALCON) += falcon/
>> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
>> index 7022fb2005a2..366ecd3c80b1 100644
>> --- a/drivers/net/ethernet/sfc/ef10.c
>> +++ b/drivers/net/ethernet/sfc/ef10.c
>> @@ -589,7 +589,7 @@ static int efx_ef10_probe(struct efx_nic *efx)
>>          if (rc)
>>                  goto fail4;
>>
>> -       rc = efx_get_pf_index(efx, &nic_data->pf_index);
>> +       rc = efx_get_fn_info(efx, &nic_data->pf_index, NULL);
>>          if (rc)
>>                  goto fail5;
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>> index 41175eb00326..41811c519275 100644
>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
>> @@ -1160,7 +1160,7 @@ static int ef100_probe_main(struct efx_nic *efx)
>>          if (rc)
>>                  goto fail;
>>
>> -       rc = efx_get_pf_index(efx, &nic_data->pf_index);
>> +       rc = efx_get_fn_info(efx, &nic_data->pf_index, &nic_data->vf_index);
>>          if (rc)
>>                  goto fail;
>>
>> @@ -1247,13 +1247,33 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
>>
>>   int ef100_probe_vf(struct efx_nic *efx)
>>   {
>> -       return ef100_probe_main(efx);
>> +#if defined(CONFIG_SFC_VDPA)
>> +       int err;
>> +#endif
>> +       int rc;
>> +
>> +       rc = ef100_probe_main(efx);
>> +       if (rc)
>> +               return rc;
>> +
>> +#if defined(CONFIG_SFC_VDPA)
>> +       err = ef100_vdpa_register_mgmtdev(efx);
>> +       if (err)
>> +               pci_warn(efx->pci_dev,
>> +                        "vdpa_register_mgmtdev failed, err: %d\n", err);
>> +#endif
>> +       return 0;
>>   }
>>
>>   void ef100_remove(struct efx_nic *efx)
>>   {
>>          struct ef100_nic_data *nic_data = efx->nic_data;
>>
>> +#if defined(CONFIG_SFC_VDPA)
>> +       if (efx_vdpa_supported(efx))
>> +               ef100_vdpa_unregister_mgmtdev(efx);
>> +#endif
>> +
>>          efx_mcdi_detach(efx);
>>          efx_mcdi_fini(efx);
>>          if (nic_data) {
>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
>> index 5ed693fbe79f..730c8bb932b0 100644
>> --- a/drivers/net/ethernet/sfc/ef100_nic.h
>> +++ b/drivers/net/ethernet/sfc/ef100_nic.h
>> @@ -68,6 +68,13 @@ enum ef100_bar_config {
>>          EF100_BAR_CONFIG_VDPA,
>>   };
>>
>> +#ifdef CONFIG_SFC_VDPA
>> +enum ef100_vdpa_class {
>> +       EF100_VDPA_CLASS_NONE,
>> +       EF100_VDPA_CLASS_NET,
>> +};
>> +#endif
>> +
>>   struct ef100_nic_data {
>>          struct efx_nic *efx;
>>          struct efx_buffer mcdi_buf;
>> @@ -75,7 +82,11 @@ struct ef100_nic_data {
>>          u32 datapath_caps2;
>>          u32 datapath_caps3;
>>          unsigned int pf_index;
>> +       unsigned int vf_index;
>>          u16 warm_boot_count;
>> +#ifdef CONFIG_SFC_VDPA
>> +       enum ef100_vdpa_class vdpa_class;
>> +#endif
>>          u8 port_id[ETH_ALEN];
>>          DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
>>          enum ef100_bar_config bar_config;
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> index 5e215cee585a..ff4bb61e598e 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> @@ -11,11 +11,17 @@
>>   #include <linux/err.h>
>>   #include <linux/vdpa.h>
>>   #include <linux/virtio_net.h>
>> +#include <uapi/linux/vdpa.h>
>>   #include "ef100_vdpa.h"
>>   #include "mcdi_vdpa.h"
>>   #include "mcdi_filters.h"
>>   #include "ef100_netdev.h"
>>
>> +static struct virtio_device_id ef100_vdpa_id_table[] = {
>> +       { .device = VIRTIO_ID_NET, .vendor = PCI_VENDOR_ID_REDHAT_QUMRANET },
>> +       { 0 },
>> +};
>> +
>>   int ef100_vdpa_init(struct efx_probe_data *probe_data)
>>   {
>>          struct efx_nic *efx = &probe_data->efx;
>> @@ -42,17 +48,243 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data)
>>          return rc;
>>   }
>>
>> +static void ef100_vdpa_delete(struct efx_nic *efx)
>> +{
>> +       if (efx->vdpa_nic) {
>> +               /* replace with _vdpa_unregister_device later */
>> +               put_device(&efx->vdpa_nic->vdpa_dev.dev);
>> +               efx->vdpa_nic = NULL;
>> +       }
>> +}
>> +
>>   void ef100_vdpa_fini(struct efx_probe_data *probe_data)
>>   {
>>          struct efx_nic *efx = &probe_data->efx;
>> +       struct ef100_nic_data *nic_data;
>>
>>          if (efx->state != STATE_VDPA && efx->state != STATE_DISABLED) {
>>                  pci_err(efx->pci_dev, "Invalid efx state %u", efx->state);
>>                  return;
>>          }
>>
>> +       /* Handle vdpa device deletion, if not done explicitly */
>> +       ef100_vdpa_delete(efx);
>> +       nic_data = efx->nic_data;
>> +       nic_data->vdpa_class = EF100_VDPA_CLASS_NONE;
>>          efx->state = STATE_PROBED;
>>          down_write(&efx->filter_sem);
>>          efx_mcdi_filter_table_remove(efx);
>>          up_write(&efx->filter_sem);
>>   }
>> +
>> +static int get_net_config(struct ef100_vdpa_nic *vdpa_nic)
>> +{
>> +       struct efx_nic *efx = vdpa_nic->efx;
>> +       u16 mtu;
>> +       int rc;
>> +
>> +       vdpa_nic->net_config.max_virtqueue_pairs =
>> +               cpu_to_efx_vdpa16(vdpa_nic, vdpa_nic->max_queue_pairs);
>> +
>> +       rc = efx_vdpa_get_mtu(efx, &mtu);
>> +       if (rc) {
>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                       "%s: Get MTU for vf:%u failed:%d\n", __func__,
>> +                       vdpa_nic->vf_index, rc);
>> +               return rc;
>> +       }
>> +       vdpa_nic->net_config.mtu = cpu_to_efx_vdpa16(vdpa_nic, mtu);
>> +       vdpa_nic->net_config.status = cpu_to_efx_vdpa16(vdpa_nic,
>> +                                                       VIRTIO_NET_S_LINK_UP);
>> +       return 0;
>> +}
>> +
>> +static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>> +                                               const char *dev_name,
>> +                                               enum ef100_vdpa_class dev_type,
>> +                                               const u8 *mac)
>> +{
>> +       struct ef100_nic_data *nic_data = efx->nic_data;
>> +       struct ef100_vdpa_nic *vdpa_nic;
>> +       struct device *dev;
>> +       int rc;
>> +
>> +       nic_data->vdpa_class = dev_type;
>> +       vdpa_nic = vdpa_alloc_device(struct ef100_vdpa_nic,
>> +                                    vdpa_dev, &efx->pci_dev->dev,
>> +                                    &ef100_vdpa_config_ops,
>> +                                    1, 1,
>> +                                    dev_name, false);
>> +       if (!vdpa_nic) {
>> +               pci_err(efx->pci_dev,
>> +                       "vDPA device allocation failed for vf: %u\n",
>> +                       nic_data->vf_index);
>> +               nic_data->vdpa_class = EF100_VDPA_CLASS_NONE;
>> +               return ERR_PTR(-ENOMEM);
>> +       }
>> +
>> +       mutex_init(&vdpa_nic->lock);
>> +       dev = &vdpa_nic->vdpa_dev.dev;
>> +       efx->vdpa_nic = vdpa_nic;
>> +       vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
>> +       vdpa_nic->vdpa_dev.mdev = efx->mgmt_dev;
>> +       vdpa_nic->efx = efx;
>> +       vdpa_nic->pf_index = nic_data->pf_index;
>> +       vdpa_nic->vf_index = nic_data->vf_index;
>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>> +       vdpa_nic->mac_address = (u8 *)&vdpa_nic->net_config.mac;
>> +       ether_addr_copy(vdpa_nic->mac_address, mac);
>> +       vdpa_nic->mac_configured = true;
>> +
>> +       rc = get_net_config(vdpa_nic);
>> +       if (rc)
>> +               goto err_put_device;
>> +
>> +       /* _vdpa_register_device when its ready */
>> +
>> +       return vdpa_nic;
>> +
>> +err_put_device:
>> +       /* put_device invokes ef100_vdpa_free */
>> +       put_device(&vdpa_nic->vdpa_dev.dev);
>> +       return ERR_PTR(rc);
>> +}
>> +
>> +static void ef100_vdpa_net_dev_del(struct vdpa_mgmt_dev *mgmt_dev,
>> +                                  struct vdpa_device *vdev)
>> +{
>> +       struct ef100_nic_data *nic_data;
>> +       struct efx_nic *efx;
>> +       int rc;
>> +
>> +       efx = pci_get_drvdata(to_pci_dev(mgmt_dev->device));
>> +       nic_data = efx->nic_data;
>> +
>> +       rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
>> +       if (rc)
>> +               pci_err(efx->pci_dev,
>> +                       "set_bar_config EF100 failed, err: %d\n", rc);
>> +       else
>> +               pci_dbg(efx->pci_dev,
>> +                       "vdpa net device deleted, vf: %u\n",
>> +                       nic_data->vf_index);
>> +}
>> +
>> +static int ef100_vdpa_net_dev_add(struct vdpa_mgmt_dev *mgmt_dev,
>> +                                 const char *name,
>> +                                 const struct vdpa_dev_set_config *config)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic;
>> +       struct ef100_nic_data *nic_data;
>> +       struct efx_nic *efx;
>> +       int rc, err;
>> +
>> +       efx = pci_get_drvdata(to_pci_dev(mgmt_dev->device));
>> +       if (efx->vdpa_nic) {
>> +               pci_warn(efx->pci_dev,
>> +                        "vDPA device already exists on this VF\n");
>> +               return -EEXIST;
>> +       }
>> +
>> +       if (config->mask & BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR)) {
>> +               if (!is_valid_ether_addr(config->net.mac)) {
>> +                       pci_err(efx->pci_dev, "Invalid MAC address %pM\n",
>> +                               config->net.mac);
>> +                       return -EINVAL;
>> +               }
>> +       } else {
>> +               pci_err(efx->pci_dev, "MAC address parameter missing\n");
> Does this mean ef100 vf doesn't have a given mac address?
We are working on adding support to configure VF MAC addresses using 
devlink port and once that is available, we can get rid of this 
restriction of specifying the MAC address at vdpa device creation time.
>
>
>
>> +               return -EIO;
>> +       }
>> +
>> +       nic_data = efx->nic_data;
>> +
>> +       rc = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_VDPA);
>> +       if (rc) {
>> +               pci_err(efx->pci_dev,
>> +                       "set_bar_config vDPA failed, err: %d\n", rc);
>> +               goto err_set_bar_config;
>> +       }
>> +
>> +       vdpa_nic = ef100_vdpa_create(efx, name, EF100_VDPA_CLASS_NET,
>> +                                    (const u8 *)config->net.mac);
>> +       if (IS_ERR(vdpa_nic)) {
>> +               pci_err(efx->pci_dev,
>> +                       "vDPA device creation failed, vf: %u, err: %ld\n",
>> +                       nic_data->vf_index, PTR_ERR(vdpa_nic));
>> +               rc = PTR_ERR(vdpa_nic);
>> +               goto err_set_bar_config;
>> +       } else {
>> +               pci_dbg(efx->pci_dev,
>> +                       "vdpa net device created, vf: %u\n",
>> +                       nic_data->vf_index);
>> +               pci_warn(efx->pci_dev,
>> +                        "Use QEMU versions 6.1.0 and later with vhost-vdpa\n");
>> +       }
>> +
>> +       return 0;
>> +
>> +err_set_bar_config:
>> +       err = efx_ef100_set_bar_config(efx, EF100_BAR_CONFIG_EF100);
>> +       if (err)
>> +               pci_err(efx->pci_dev,
>> +                       "set_bar_config EF100 failed, err: %d\n", err);
>> +
>> +       return rc;
>> +}
>> +
>> +static const struct vdpa_mgmtdev_ops ef100_vdpa_net_mgmtdev_ops = {
>> +       .dev_add = ef100_vdpa_net_dev_add,
>> +       .dev_del = ef100_vdpa_net_dev_del
>> +};
>> +
>> +int ef100_vdpa_register_mgmtdev(struct efx_nic *efx)
>> +{
>> +       struct vdpa_mgmt_dev *mgmt_dev;
>> +       u64 features;
>> +       int rc;
>> +
>> +       mgmt_dev = kzalloc(sizeof(*mgmt_dev), GFP_KERNEL);
>> +       if (!mgmt_dev)
>> +               return -ENOMEM;
>> +
>> +       rc = efx_vdpa_get_features(efx, EF100_VDPA_DEVICE_TYPE_NET, &features);
>> +       if (rc) {
>> +               pci_err(efx->pci_dev, "%s: MCDI get features error:%d\n",
>> +                       __func__, rc);
>> +               goto err_get_features;
>> +       }
>> +
>> +       efx->mgmt_dev = mgmt_dev;
>> +       mgmt_dev->device = &efx->pci_dev->dev;
>> +       mgmt_dev->id_table = ef100_vdpa_id_table;
>> +       mgmt_dev->ops = &ef100_vdpa_net_mgmtdev_ops;
>> +       mgmt_dev->supported_features = features;
>> +       mgmt_dev->max_supported_vqs = EF100_VDPA_MAX_QUEUES_PAIRS * 2;
>> +       mgmt_dev->config_attr_mask = BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR);
>> +
>> +       rc = vdpa_mgmtdev_register(mgmt_dev);
>> +       if (rc) {
>> +               pci_err(efx->pci_dev,
>> +                       "vdpa_mgmtdev_register failed, err: %d\n", rc);
>> +               goto err_mgmtdev_register;
>> +       }
>> +
>> +       return 0;
>> +
>> +err_mgmtdev_register:
>> +err_get_features:
>> +       kfree(mgmt_dev);
>> +       efx->mgmt_dev = NULL;
>> +
>> +       return rc;
>> +}
>> +
>> +void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx)
>> +{
>> +       if (efx->mgmt_dev) {
>> +               vdpa_mgmtdev_unregister(efx->mgmt_dev);
>> +               kfree(efx->mgmt_dev);
>> +               efx->mgmt_dev = NULL;
>> +       }
>> +}
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> index 6b51a05becd8..83f6d819f6a5 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> @@ -18,6 +18,24 @@
>>
>>   #if defined(CONFIG_SFC_VDPA)
>>
>> +/* Max queue pairs currently supported */
>> +#define EF100_VDPA_MAX_QUEUES_PAIRS 1
>> +
>> +/**
>> + * enum ef100_vdpa_nic_state - possible states for a vDPA NIC
>> + *
>> + * @EF100_VDPA_STATE_INITIALIZED: State after vDPA NIC created
>> + * @EF100_VDPA_STATE_NEGOTIATED: State after feature negotiation
>> + * @EF100_VDPA_STATE_STARTED: State after driver ok
>> + * @EF100_VDPA_STATE_NSTATES: Number of VDPA states
>> + */
>> +enum ef100_vdpa_nic_state {
>> +       EF100_VDPA_STATE_INITIALIZED,
>> +       EF100_VDPA_STATE_NEGOTIATED,
>> +       EF100_VDPA_STATE_STARTED,
>> +       EF100_VDPA_STATE_NSTATES
>> +};
>> +
>>   enum ef100_vdpa_device_type {
>>          EF100_VDPA_DEVICE_TYPE_NET,
>>   };
>> @@ -28,7 +46,73 @@ enum ef100_vdpa_vq_type {
>>          EF100_VDPA_VQ_NTYPES
>>   };
>>
>> +/**
>> + *  struct ef100_vdpa_nic - vDPA NIC data structure
>> + *
>> + * @vdpa_dev: vdpa_device object which registers on the vDPA bus.
>> + * @vdpa_state: NIC state machine governed by ef100_vdpa_nic_state
>> + * @efx: pointer to the VF's efx_nic object
>> + * @lock: Managing access to vdpa config operations
>> + * @pf_index: PF index of the vDPA VF
>> + * @vf_index: VF index of the vDPA VF
>> + * @status: device status as per VIRTIO spec
>> + * @features: negotiated feature bits
>> + * @max_queue_pairs: maximum number of queue pairs supported
>> + * @net_config: virtio_net_config data
>> + * @mac_address: mac address of interface associated with this vdpa device
>> + * @mac_configured: true after MAC address is configured
>> + */
>> +struct ef100_vdpa_nic {
>> +       struct vdpa_device vdpa_dev;
>> +       enum ef100_vdpa_nic_state vdpa_state;
>> +       struct efx_nic *efx;
>> +       /* for synchronizing access to vdpa config operations */
>> +       struct mutex lock;
>> +       u32 pf_index;
>> +       u32 vf_index;
>> +       u8 status;
>> +       u64 features;
>> +       u32 max_queue_pairs;
>> +       struct virtio_net_config net_config;
>> +       u8 *mac_address;
>> +       bool mac_configured;
>> +};
>> +
>>   int ef100_vdpa_init(struct efx_probe_data *probe_data);
>>   void ef100_vdpa_fini(struct efx_probe_data *probe_data);
>> +int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
>> +void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
>> +
>> +static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
>> +{
>> +       return virtio_legacy_is_little_endian() ||
>> +               (vdpa_nic->features & (1ULL << VIRTIO_F_VERSION_1));
>> +}
>> +
>> +static inline u16 efx_vdpa16_to_cpu(struct ef100_vdpa_nic *vdpa_nic,
>> +                                   __virtio16 val)
>> +{
>> +       return __virtio16_to_cpu(efx_vdpa_is_little_endian(vdpa_nic), val);
>> +}
>> +
>> +static inline __virtio16 cpu_to_efx_vdpa16(struct ef100_vdpa_nic *vdpa_nic,
>> +                                          u16 val)
>> +{
>> +       return __cpu_to_virtio16(efx_vdpa_is_little_endian(vdpa_nic), val);
>> +}
>> +
>> +static inline u32 efx_vdpa32_to_cpu(struct ef100_vdpa_nic *vdpa_nic,
>> +                                   __virtio32 val)
>> +{
>> +       return __virtio32_to_cpu(efx_vdpa_is_little_endian(vdpa_nic), val);
>> +}
>> +
>> +static inline __virtio32 cpu_to_efx_vdpa32(struct ef100_vdpa_nic *vdpa_nic,
>> +                                          u32 val)
>> +{
>> +       return __cpu_to_virtio32(efx_vdpa_is_little_endian(vdpa_nic), val);
>> +}
>> +
>> +extern const struct vdpa_config_ops ef100_vdpa_config_ops;
>>   #endif /* CONFIG_SFC_VDPA */
>>   #endif /* __EF100_VDPA_H__ */
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> new file mode 100644
>> index 000000000000..31952931c198
>> --- /dev/null
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> @@ -0,0 +1,28 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Driver for Xilinx network controllers and boards
>> + * Copyright(C) 2020-2022 Xilinx, Inc.
>> + * Copyright(C) 2022 Advanced Micro Devices, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License version 2 as published
>> + * by the Free Software Foundation, incorporated herein by reference.
>> + */
>> +
>> +#include <linux/vdpa.h>
>> +#include "ef100_vdpa.h"
>> +
>> +static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
>> +{
>> +       return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>> +}
>> +
>> +static void ef100_vdpa_free(struct vdpa_device *vdev)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +       mutex_destroy(&vdpa_nic->lock);
>> +}
>> +
>> +const struct vdpa_config_ops ef100_vdpa_config_ops = {
>> +       .free                = ef100_vdpa_free,
>> +};
>> diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
>> index d3e6d8239f5c..4415f19cf68f 100644
>> --- a/drivers/net/ethernet/sfc/mcdi_functions.c
>> +++ b/drivers/net/ethernet/sfc/mcdi_functions.c
>> @@ -413,7 +413,8 @@ int efx_mcdi_window_mode_to_stride(struct efx_nic *efx, u8 vi_window_mode)
>>          return 0;
>>   }
>>
>> -int efx_get_pf_index(struct efx_nic *efx, unsigned int *pf_index)
>> +int efx_get_fn_info(struct efx_nic *efx, unsigned int *pf_index,
>> +                   unsigned int *vf_index)
>>   {
>>          MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_FUNCTION_INFO_OUT_LEN);
>>          size_t outlen;
>> @@ -426,6 +427,10 @@ int efx_get_pf_index(struct efx_nic *efx, unsigned int *pf_index)
>>          if (outlen < sizeof(outbuf))
>>                  return -EIO;
>>
>> -       *pf_index = MCDI_DWORD(outbuf, GET_FUNCTION_INFO_OUT_PF);
>> +       if (pf_index)
>> +               *pf_index = MCDI_DWORD(outbuf, GET_FUNCTION_INFO_OUT_PF);
>> +
>> +       if (efx->type->is_vf && vf_index)
>> +               *vf_index = MCDI_DWORD(outbuf, GET_FUNCTION_INFO_OUT_VF);
>>          return 0;
>>   }
>> diff --git a/drivers/net/ethernet/sfc/mcdi_functions.h b/drivers/net/ethernet/sfc/mcdi_functions.h
>> index b0e2f53a0d9b..76dc0a13463e 100644
>> --- a/drivers/net/ethernet/sfc/mcdi_functions.h
>> +++ b/drivers/net/ethernet/sfc/mcdi_functions.h
>> @@ -28,6 +28,7 @@ void efx_mcdi_rx_remove(struct efx_rx_queue *rx_queue);
>>   void efx_mcdi_rx_fini(struct efx_rx_queue *rx_queue);
>>   int efx_fini_dmaq(struct efx_nic *efx);
>>   int efx_mcdi_window_mode_to_stride(struct efx_nic *efx, u8 vi_window_mode);
>> -int efx_get_pf_index(struct efx_nic *efx, unsigned int *pf_index);
>> +int efx_get_fn_info(struct efx_nic *efx, unsigned int *pf_index,
>> +                   unsigned int *vf_index);
>>
>>   #endif
>> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
>> index ffda80a95221..79356d614109 100644
>> --- a/drivers/net/ethernet/sfc/net_driver.h
>> +++ b/drivers/net/ethernet/sfc/net_driver.h
>> @@ -1182,6 +1182,12 @@ struct efx_nic {
>>
>>          unsigned int mem_bar;
>>          u32 reg_base;
>> +#ifdef CONFIG_SFC_VDPA
>> +       /** @mgmt_dev: vDPA Management device */
>> +       struct vdpa_mgmt_dev *mgmt_dev;
>> +       /** @vdpa_nic: vDPA device structure (EF100) */
>> +       struct ef100_vdpa_nic *vdpa_nic;
>> +#endif
>>
>>          /* The following fields may be written more often */
>>
>> --
>> 2.30.1
>>
