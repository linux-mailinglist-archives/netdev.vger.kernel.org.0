Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600B66B6FD7
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 08:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCMHJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 03:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCMHJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 03:09:29 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E4E30E99;
        Mon, 13 Mar 2023 00:09:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADH1KZfomO95jC5nne9IPD4427LzTOG0aq3OHMkfqqAn9tcNinbzTOjh/vQd0NA1YqsiQ/Knjg+tDyVuQtnwPHUN02Ochl+99CBWTMWRl8kIzQ6MQFl+BBtA/mCqM9xqaq6evFs/1LK4LlhNWK4DK62qid4Wbhnu9oNShaMMT6JDNVuCMqmz6EdVC8DoL0dFyq52GRPnIhfUKLFK1qEazWVbkRePxXc5j7ddVBTGI5BDRTR4pybmu6BXajNbcE0kTLeMw8ZMAXl3UsOqwx9BhkhL7jnDswWE/ro5b0c+RXZJrrV4hIrtZkdXy8MupbKBKQboElfxV2vThF4+MU48ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qG441qbm6Zo6DDlc0HWq68ft5Xw6IDxYnbdwRAJ0JE8=;
 b=C1VOtpxnt1Cugy1mKA4u/Pisr6QxxW03AvuRAE6KKTxvgc5wHNvi6vw/UC2vGKJiBI95eJsTTN94a/ihgXfHhboxWpnRkA7NctIw7n8Bsey3AsVairtD7IcQ4sZDiqRJswnz59Ghx0vJEfPYXIfyoO9dmX/fDCX8gED9G4IFENYaDK99rGxAVxrfIAfy15tSnqJP1vDY4Tp1kwghhLrJOulmKPrEyH7bYF6DIUbXO97Y0U5a1AptiCJDh0VFgxk4nMIxd/IQfVurTwGDbFmUGQ/QxSVrnXbbt2xZa/g64bmi4rnf7DZ4hu4INLP3w73L9584IsHx49riamsdXWSTJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qG441qbm6Zo6DDlc0HWq68ft5Xw6IDxYnbdwRAJ0JE8=;
 b=mGW1dmkUlFzgrC2pt51yP7SMtuTts3FsFLEYkR2Ht8GtIeS6+gr3IYDhzzz+gaatIl5xyN/Abso6NlzjtzQXAy5Rr4euFDRr0Za+NZqAsHF/Ef0OCOZzqf0aKWy/l+/24cVNbPzPtWC0EZbRei7hgF5lUzkm1N0wnl+Ks0Lgzfc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by DS7PR12MB6045.namprd12.prod.outlook.com (2603:10b6:8:86::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 07:09:25 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 07:09:25 +0000
Message-ID: <311a2506-d178-b136-bf4f-8da8a96b9d47@amd.com>
Date:   Mon, 13 Mar 2023 12:39:12 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 12/14] sfc: unmap VF's MCDI buffer when
 switching to vDPA mode
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
 <20230307113621.64153-13-gautam.dawar@amd.com>
 <CACGkMEuvJF9WXu0N+d-54hB=kGgjU=zNk=620d7chinRWz=j5Q@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEuvJF9WXu0N+d-54hB=kGgjU=zNk=620d7chinRWz=j5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0069.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::14) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|DS7PR12MB6045:EE_
X-MS-Office365-Filtering-Correlation-Id: fdd3a4d5-05a1-4c6d-8412-08db2391e0a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T3jaRj9YP3EztQvSnQ35bv1HyaeaWt/VvoobpLSZpnTBZQaQ4QkTuSUik8MTKsNDuuKq6TBk88qqjGswOjmiROvcbafulQONqywctFYn0vRGtXXCt8DoWbcVXbCGAyx3Rj3+chbNaAA6M00xO1NRUlGpEZfaGos9LIeZ42K6Ef0hkPnVXY2VzzGIoGz5EmnBToPbIWV7cpLYQKrQ8Z3Io9KOEtCmdPcNBdHQt2DVm05RjZ7fjwBBm0AyKYl6fCjtq/kdkag+Yn9+KPTwIMqCkElOG4f5bFhIgU6ej3FyYq2USKDiGdt4JUDuM09O3rmlPZ6XJlh8BWs8RnPC/zVUgptISzemCHE926BvsArDV5Yaq6cjQ2+z6DzPXUCc//rVK6GIC4KaCEp8JOtEy0IAkC9w5R4FboQBNXIRyk8L5Oqer42Es4cfuwVqQW354EjX1arxBo65Jd3HR9vOWFSA0XgKlGuQl5mApoIS2IsihtnTnFQNroI2WgIjd3IOnp9l5NzgSuxGuUgi0dnkrqrCuma3QbgEeytHVtpDI5fP4BY66YIlJwJazrY3sTtI00VCMI/kja6wQFPO8Gwp64YwXku/mg+hq0uYkJ7x9/QCG8CGQkCsu1ToH0HokgIVcnurQiIdIJl6dN960Oi1v2YF4ffccZtL2nUoybN4uo40yPEYkFQdtX+Gql8zSyttF6c4OA5grJAc8DW3iUlR2vGKBqzAtRrMOgVkFuwlFZoAfH8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199018)(31686004)(8936002)(6636002)(54906003)(110136005)(41300700001)(478600001)(4326008)(8676002)(66946007)(66556008)(66476007)(36756003)(31696002)(38100700002)(53546011)(6512007)(26005)(6486002)(6666004)(186003)(7416002)(5660300002)(2906002)(316002)(6506007)(83380400001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVpGb2lMUEFKNkwxY1craGxjQXo5UE04TzRqWHU2eWdmY1cvRUNtMmRpMC9V?=
 =?utf-8?B?S01WMGlRdzVqWS9BWitnc3l2QStKU1NYZEJpTkVrejdhUndvb0xwNlpScVBv?=
 =?utf-8?B?MWpBKzR4ZGYzK3RCYjJFU0dQc3lhVnkra3B5S0RoQ0FBalpXZ3VHWmlYKzZR?=
 =?utf-8?B?UlRtSERPYmFxbU5LVmg0Sk0zYTNveTJjTmNCSTdvYUZIaWphUEh2a0hCY1FB?=
 =?utf-8?B?ZWZPVVRMNEdxR2NiWXNrZERZS25wMFBQckZFQ0h5clN5eEpWYU16a29MN0dy?=
 =?utf-8?B?QmxhTnNGMFZwNlh3QlhQNjliNUdJN0JRcS9MdzZYMFZnN3p3MElSSjNsR2Jm?=
 =?utf-8?B?S0dpcjdXMElQYXBKNXQ4dk5hcVdaSWthQUVjYlRjUnRVNVZ1bnowMlkrOUg3?=
 =?utf-8?B?ZUpEb1JJQUVtcVRFM3lYMW9mdE9yUkNnSG9zUThlMTRra2dDZm1QSFo4Y3h5?=
 =?utf-8?B?dEgvRmxiWi9yc0ljY0IrVklZTXhGQTNOZTZrdjRib09hUWo1K1p4UTgzb29Y?=
 =?utf-8?B?S1Z5c2ZjeHQ0ZUc2c2hHLzlMNjFxVFg3QVV2eUtUcTk1ZVJZdkplckZaUklI?=
 =?utf-8?B?dysxdFc4Vi9qLzd3R3FFRzQ5NVZDTW1GQUk1UkZoREcwbzRMbVpVdUxwM0to?=
 =?utf-8?B?VlErOEo1aEdhb0gvRVpnSWdBUk1hanVrUS9IRCtQRG9BMWhzL2xLS1Q2elY0?=
 =?utf-8?B?cGYxSithZXYzcFZ4RzlIYWtjVitMQVl3NllIVjBsVXVGeFQvNTU0NFpWRHcz?=
 =?utf-8?B?UlBjTzVGcWE0U01uL2lEY1ZBZjRubnJyRjlyNDRHNVB1c0VHUm9zSUlNUTJ0?=
 =?utf-8?B?TnlGcEQ5eTJuNWhSa0NsZkwrODJjY09lS1J3SWVMcDQwemNjVEJFRzEzREhp?=
 =?utf-8?B?UnNQSnpJR1JWdjRnZzc1S0RaT1JQbGNmYzFNYis4WkZNa3l1aVZGcU43Qi9r?=
 =?utf-8?B?TUNrZ0pyR0NEeXNUb0ZaMmh1U0NmV2ZmZ3RBd3lQbUhXeUJxS1FVRVlPRFFs?=
 =?utf-8?B?Rko4SEN3U1FCVWdSMFNaQkFzcTNvNnk4eS9LNSsxb0M3WjErZ01Bc1ZUalJE?=
 =?utf-8?B?ckxPMWhtWDZnUWhGWitSVU9xeHBHWWNnV0tyTDBVaUJjTkd5bnVIM2FYKzc4?=
 =?utf-8?B?Q0pVSWtBT2RjSXYyc2V6MVBMbFZDL01Xc2tKQWg2MmtmU0tMTTZJMTB0WXU5?=
 =?utf-8?B?ZnpTZHcyRE5ESE1aaGtKY2dqczgvbU8xSlBSRHEreS9pM2lrdkErUVlyVkpa?=
 =?utf-8?B?Q3lRdnZlN3QyNDkxVFdOdlNPMXRMczZYTXQvSFY3SmZmUlhUdyswT3pJSU9u?=
 =?utf-8?B?WEp1WCtpRzV5b0dSTnhIR1VaM2J5YVNoMGd4bDRuMnpMRXphODdkYm96ZjB3?=
 =?utf-8?B?Mk1raytSdW5QMWZmZStwNWlRZHpOdy9rNVM5ZWNRUnA0YXRnWExtMGxubmJS?=
 =?utf-8?B?Njg4MU9mSWgrWmJxSEtZY1IwVnFLMHQ2YkE1YW5qdDc3SDdVREI4OGNpL0Iz?=
 =?utf-8?B?cnpwdElERU5MVWRxaWY5M0V3dDVtbmkwRGNrUG94U0llVFFaTDg0MGg2UGlJ?=
 =?utf-8?B?cjZRMldlUmdyZ1h1TzdjYitxZjVXM1hGUE1MRDNhYlYwQWRUNVh6UFZrUUJK?=
 =?utf-8?B?eEQzR2xJMkU0SEZOMlBidncyTjVpQlFSQkpUR2RLK1RubTM2aFBUMStPVnls?=
 =?utf-8?B?ek5VdXdHeE8wWUkyRC94N2h4OCtNeHhJWndvaG4vNW1GM2ltbDRUREpTNGxO?=
 =?utf-8?B?MUxSRlgzUENqcHJScW1oWmQvS3pIYU4zKzhiZnNSNzV4Q1RGSWdyQWxFNVR0?=
 =?utf-8?B?SVV1aHdOM25IVmFPQ1QydjFaZXBHQ1ZONjZSazhxSjlzOGo4UlZRejdiWCtC?=
 =?utf-8?B?NHdiNnZzTmNyV1A1SWtYeFFzeC9ORmJWVXFwZWFSY2ZqY3RXTUw5dDJHYzFs?=
 =?utf-8?B?Smh4dUN5N1JqNkFTMFNFTWRjaktLdWpOZWkvNUFVSXBxUkR6K3FuMkptbjli?=
 =?utf-8?B?Q0NYWGZ5NmFtTkZQMXEzNS92ZFh3MUE4cnJPODN4elI1bEpkaVFEQzU5TGMr?=
 =?utf-8?B?ZkNxb21Dc1FLL1dGdUJtNGlPK0tUV2tjM1BwVVdyUHU0T2tVdlRCZmYxbkhk?=
 =?utf-8?Q?x3xPhNvl/RetFvN3muViOnYTd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd3a4d5-05a1-4c6d-8412-08db2391e0a2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 07:09:25.2002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CvogY7+34rxHByen6Me8DqM8wW3vJ89astKHgVsH76zmGCNPIWq/hnAz7VP4kjaN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6045
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/10/23 10:35, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Tue, Mar 7, 2023 at 7:38 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>> To avoid clash of IOVA range of VF's MCDI DMA buffer with the guest
>> buffer IOVAs, unmap the MCDI buffer when switching to vDPA mode
>> and use PF's IOMMU domain for running VF's MCDI commands.
>>
>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>> ---
>>   drivers/net/ethernet/sfc/ef100_nic.c      |  1 -
>>   drivers/net/ethernet/sfc/ef100_vdpa.c     | 25 ++++++++++++++++
>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |  3 ++
>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 35 +++++++++++++++++++++++
>>   drivers/net/ethernet/sfc/mcdi.h           |  3 ++
>>   drivers/net/ethernet/sfc/net_driver.h     | 12 ++++++++
>>   6 files changed, 78 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>> index cd9f724a9e64..1bffc1994ed8 100644
>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
>> @@ -33,7 +33,6 @@
>>
>>   #define EF100_MAX_VIS 4096
>>   #define EF100_NUM_MCDI_BUFFERS 1
>> -#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
>>
>>   #define EF100_RESET_PORT ((ETH_RESET_MAC | ETH_RESET_PHY) << ETH_RESET_SHARED_SHIFT)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> index 5c9f29f881a6..30ca4ab00175 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> @@ -223,10 +223,19 @@ static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
>>   static void ef100_vdpa_delete(struct efx_nic *efx)
>>   {
>>          struct vdpa_device *vdpa_dev;
>> +       int rc;
>>
>>          if (efx->vdpa_nic) {
>>                  vdpa_dev = &efx->vdpa_nic->vdpa_dev;
>>                  ef100_vdpa_reset(vdpa_dev);
>> +               if (efx->mcdi_buf_mode == EFX_BUF_MODE_VDPA) {
>> +                       rc = ef100_vdpa_map_mcdi_buffer(efx);
>> +                       if (rc) {
>> +                               pci_err(efx->pci_dev,
>> +                                       "map_mcdi_buffer failed, err: %d\n",
>> +                                       rc);
>> +                       }
>> +               }
>>
>>                  /* replace with _vdpa_unregister_device later */
>>                  put_device(&vdpa_dev->dev);
>> @@ -276,6 +285,21 @@ static int get_net_config(struct ef100_vdpa_nic *vdpa_nic)
>>          return 0;
>>   }
>>
>> +static void unmap_mcdi_buffer(struct efx_nic *efx)
>> +{
>> +       struct ef100_nic_data *nic_data = efx->nic_data;
>> +       struct efx_mcdi_iface *mcdi;
>> +
>> +       mcdi = efx_mcdi(efx);
>> +       spin_lock_bh(&mcdi->iface_lock);
>> +       /* Save current MCDI mode to be restored later */
>> +       efx->vdpa_nic->mcdi_mode = mcdi->mode;
>> +       efx->mcdi_buf_mode = EFX_BUF_MODE_VDPA;
>> +       mcdi->mode = MCDI_MODE_FAIL;
>> +       spin_unlock_bh(&mcdi->iface_lock);
>> +       efx_nic_free_buffer(efx, &nic_data->mcdi_buf);
>> +}
>> +
>>   static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>                                                  const char *dev_name,
>>                                                  enum ef100_vdpa_class dev_type,
>> @@ -342,6 +366,7 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>          for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
>>                  vdpa_nic->filters[i].filter_id = EFX_INVALID_FILTER_ID;
>>
>> +       unmap_mcdi_buffer(efx);
>>          rc = get_net_config(vdpa_nic);
>>          if (rc)
>>                  goto err_put_device;
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> index 49fb6be04eb3..0913ac2519cb 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> @@ -147,6 +147,7 @@ struct ef100_vdpa_filter {
>>    * @status: device status as per VIRTIO spec
>>    * @features: negotiated feature bits
>>    * @max_queue_pairs: maximum number of queue pairs supported
>> + * @mcdi_mode: MCDI mode at the time of unmapping VF mcdi buffer
>>    * @net_config: virtio_net_config data
>>    * @vring: vring information of the vDPA device.
>>    * @mac_address: mac address of interface associated with this vdpa device
>> @@ -166,6 +167,7 @@ struct ef100_vdpa_nic {
>>          u8 status;
>>          u64 features;
>>          u32 max_queue_pairs;
>> +       enum efx_mcdi_mode mcdi_mode;
>>          struct virtio_net_config net_config;
>>          struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
>>          u8 *mac_address;
>> @@ -185,6 +187,7 @@ int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
>>   int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
>>   void ef100_vdpa_irq_vectors_free(void *data);
>>   int ef100_vdpa_reset(struct vdpa_device *vdev);
>> +int ef100_vdpa_map_mcdi_buffer(struct efx_nic *efx);
>>
>>   static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
>>   {
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> index db86c2693950..c6c9458f0e6f 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> @@ -711,12 +711,47 @@ static int ef100_vdpa_suspend(struct vdpa_device *vdev)
>>          mutex_unlock(&vdpa_nic->lock);
>>          return rc;
>>   }
>> +
>> +int ef100_vdpa_map_mcdi_buffer(struct efx_nic *efx)
>> +{
> The name of this function is confusing, it's actually map buffer for
> ef100 netdev mode.

Yeah, I get your point. Actually, I am using the prefix ef100_vdpa_ for 
extern functions and this function is just mapping the  MCDI buffer 
resulting in the name ef100_vdpa_map_mcdi_buffer().

I think ef100_vdpa_map_vf_mcdi_buffer() would remove this confusion. 
What do you think?

>
> Actually, I wonder why not moving this to init/fini of bar config ops
> or if we use aux bus, it should be done during aux driver
> probe/remove.
It makes sense, however we store the last mcdi mode (poll or events) in 
vdpa_nic->mcdi_mode to restore later, which requires vdpa_nic to be 
allocated that happens later than switching to vdpa bar_config.
> Thanks
>
>
>> +       struct ef100_nic_data *nic_data = efx->nic_data;
>> +       struct efx_mcdi_iface *mcdi;
>> +       int rc;
>> +
>> +       /* Update VF's MCDI buffer when switching out of vdpa mode */
>> +       rc = efx_nic_alloc_buffer(efx, &nic_data->mcdi_buf,
>> +                                 MCDI_BUF_LEN, GFP_KERNEL);
>> +       if (rc)
>> +               return rc;
>> +
>> +       mcdi = efx_mcdi(efx);
>> +       spin_lock_bh(&mcdi->iface_lock);
>> +       mcdi->mode = efx->vdpa_nic->mcdi_mode;
>> +       efx->mcdi_buf_mode = EFX_BUF_MODE_EF100;
>> +       spin_unlock_bh(&mcdi->iface_lock);
>> +
>> +       return 0;
>> +}
>> +
>>   static void ef100_vdpa_free(struct vdpa_device *vdev)
>>   {
>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       int rc;
>>          int i;
>>
>>          if (vdpa_nic) {
>> +               if (vdpa_nic->efx->mcdi_buf_mode == EFX_BUF_MODE_VDPA) {
>> +                       /* This will only be called via call to put_device()
>> +                        * on vdpa device creation failure
>> +                        */
>> +                       rc = ef100_vdpa_map_mcdi_buffer(vdpa_nic->efx);
>> +                       if (rc) {
>> +                               dev_err(&vdev->dev,
>> +                                       "map_mcdi_buffer failed, err: %d\n",
>> +                                       rc);
>> +                       }
>> +               }
>> +
>>                  for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>>                          reset_vring(vdpa_nic, i);
>>                          if (vdpa_nic->vring[i].vring_ctx)
>> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
>> index 2c526d2edeb6..bc4de3b4e6f3 100644
>> --- a/drivers/net/ethernet/sfc/mcdi.h
>> +++ b/drivers/net/ethernet/sfc/mcdi.h
>> @@ -6,6 +6,9 @@
>>
>>   #ifndef EFX_MCDI_H
>>   #define EFX_MCDI_H
>> +#include "mcdi_pcol.h"
>> +
>> +#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
>>
>>   /**
>>    * enum efx_mcdi_state - MCDI request handling state
>> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
>> index 948c7a06403a..9cdfeb6ad05a 100644
>> --- a/drivers/net/ethernet/sfc/net_driver.h
>> +++ b/drivers/net/ethernet/sfc/net_driver.h
>> @@ -848,6 +848,16 @@ enum efx_xdp_tx_queues_mode {
>>
>>   struct efx_mae;
>>
>> +/**
>> + * enum efx_buf_alloc_mode - buffer allocation mode
>> + * @EFX_BUF_MODE_EF100: buffer setup in ef100 mode
>> + * @EFX_BUF_MODE_VDPA: buffer setup in vdpa mode
>> + */
>> +enum efx_buf_alloc_mode {
>> +       EFX_BUF_MODE_EF100,
>> +       EFX_BUF_MODE_VDPA
>> +};
>> +
>>   /**
>>    * struct efx_nic - an Efx NIC
>>    * @name: Device name (net device name or bus id before net device registered)
>> @@ -877,6 +887,7 @@ struct efx_mae;
>>    * @irq_rx_mod_step_us: Step size for IRQ moderation for RX event queues
>>    * @irq_rx_moderation_us: IRQ moderation time for RX event queues
>>    * @msg_enable: Log message enable flags
>> + * @mcdi_buf_mode: mcdi buffer allocation mode
>>    * @state: Device state number (%STATE_*). Serialised by the rtnl_lock.
>>    * @reset_pending: Bitmask for pending resets
>>    * @tx_queue: TX DMA queues
>> @@ -1045,6 +1056,7 @@ struct efx_nic {
>>          u32 msg_enable;
>>
>>          enum nic_state state;
>> +       enum efx_buf_alloc_mode mcdi_buf_mode;
>>          unsigned long reset_pending;
>>
>>          struct efx_channel *channel[EFX_MAX_CHANNELS];
>> --
>> 2.30.1
>>
