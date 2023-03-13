Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437756B702A
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 08:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjCMHft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 03:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCMHfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 03:35:48 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF44029175;
        Mon, 13 Mar 2023 00:35:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jaUCo0JWRZdnHQrgIhmAJHEYzCWC2uh7w3PComi9DoAg2+J2Rihhz+r7kIraZmkV7XTKN/EywbZhYmMYSJJj8D4LC/QYT64OImbO161L7K4saAprOTX6+Bep509gucwEwT2+MY+HSeoGOGk2sTUfxSDcXF7kY88uSiZASc7OCihrKKkxMS4+OoLu2RQb4qd3vk0Xn3M2z7ZLLc1e+OgtU1WmdL2QD5gC2w/QokYqnfpTXaFUNLbo+7qCIHeq1gLfEciugNTzgVPSERLT40LGS6v+0smwA/CclZVebFbMKOsYkqYxNqgYzFO+c4M9HoY2PFOrEy+vX1SnoGTOIesy5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMQ00xMPUydCN8hGpc9jpCPqLwaWvq7UmEm/ZO5f4cY=;
 b=YJbyYrEKse0bdk86elmIUcvK31l2/zBMRTC9nqeJ9BP1jcaWdJoZgtZzIJhCNfRgbKbB/48idfOQqaOS7oM/faRzGrAfO5x3MguXV/cpeDT5bNylTaO2NVd0t1o2IPT2CI8yYC0v6PFO6bDNzSwYg83qd4aueMyx4Xz/XQeJoTuxhcJ+9tRIXRY+Hk+fPVqPQoyipERCMalvHKZ4vnHb6ykRIGIAoMWmKVJH1LIpaJc+lxntAVF/+dI+Po5dbSxPFVruq9WY6urEvomhLu0HHVmUV+PDOCLJ1QM+Feq7G34CzVdicPmYGKkx28CE5OdYWcUflAYGBlu/B1FumJnszw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMQ00xMPUydCN8hGpc9jpCPqLwaWvq7UmEm/ZO5f4cY=;
 b=O0vAqOsiUAq78hz7jnQ8obruVlgAqNl7+Likv3MDX/4f21UGWoLgiMDpRv/LQA02u+tTTqDpWIv0WDzQeJLxp+gV3q1pJHJP3e/g3I5D9wQ+6FyoDPj7p4vupZEEqDXU0OhCkiF7CVFrJ2QoDzpBqXo81wqW8p6p209Z7pE+bNg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by IA0PR12MB8906.namprd12.prod.outlook.com (2603:10b6:208:481::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 07:35:42 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 07:35:42 +0000
Message-ID: <b6776801-3e06-29e8-4804-47b0bf90add3@amd.com>
Date:   Mon, 13 Mar 2023 13:05:28 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 11/14] sfc: use PF's IOMMU domain for running
 VF's MCDI commands
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
 <20230307113621.64153-12-gautam.dawar@amd.com>
 <CACGkMEt7Lb9mkgd3oiWWsQcAvZYode35GQ_ie63VngcWOpWCBw@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEt7Lb9mkgd3oiWWsQcAvZYode35GQ_ie63VngcWOpWCBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0089.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::34) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|IA0PR12MB8906:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b97c395-50f0-4dad-26e6-08db23958cf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w1cGIcIMAPHkBqte8A0ROuV5n0bome33X1NIsjqr0tH9iJ6Gb+4qiyqn/UR3weeQTxtfNGwaoj1Cbqef+Dqfa/jvW04uGGkY9uhQvyRgrkDz/TxFSuzEFTMNh/ppoPVoQu4zA8I/FfQB17/qVs1t765GlIwH41ILDNbDm8BT3VZHqCmY013LLW0J3/m7gM+AcZen0CBhWNZZKnhOHOYr3DqXZFad49se9K6Iq6TRLjXI3pU/LShxcQDNIOVel+0F2L4FIw1Qg1M3JeNmHH0/sbNBs5zmBADKhyGNNYM6/UT3rCRW6wLRhxA470Dz0M40pu7oHFlNcAug+Se/IsvBnZeJ8THESu5WGIS6j90q89OwweFvSWJpqVxXieu9CvLhUSi3TRZzQHsGSj2oGydG7xpIAAHyj8SEl3YrWltLSDpAxS8CnjVxforsjfkPLug1Gl8/H33VmlIqCMHxceucylcm4G0bWES3ftCsT+UUQm+SJb11vGfcZqdRkH9sWBcaZfW+jNEm3kC0Xbp7ZldGj83xYaB1yI/v24rp9xXs7+K8yUZH9VtvMz0AZaXa6uO4bVyVgweHsY63N9eyupx4pwBF2VIufR6mL9CHyktjrwl5cpnp8kPuQB8CN0P3a6UD9eMDUnUSI8FnEhfxazyeQcOMpnP6QThH8UqXlLaxn24GHJ95K+qU+LrXfWCeROtT6AwnR7Gk3S4cYbN4Dw21bMbmcYbzwgnEgHhU/FoBWm4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199018)(478600001)(83380400001)(2906002)(38100700002)(8936002)(7416002)(5660300002)(30864003)(31696002)(36756003)(110136005)(4326008)(8676002)(66946007)(66556008)(66476007)(6636002)(54906003)(41300700001)(316002)(26005)(186003)(6666004)(2616005)(6506007)(6512007)(53546011)(31686004)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2xQRkxldTVndFBJUGFpTVVIdk11eEhSWmdCYTVlTTFacGE2UVJveHhKMmE5?=
 =?utf-8?B?ZklDNGVWK2svVGpla3ByMFpNY0VlRG5JYWl6Q3dRT3dyL0sxR2pHcVdNQ0ZD?=
 =?utf-8?B?Wjh2T2FubFpwa1EwbVZNNTZhWFBJM3FOZGl3cjBYSHhvRzM1QTZ4bjQ2L21T?=
 =?utf-8?B?cHQzRUVDMERaOUxvUTQ5WTFpUzBLVlFnYnR0N0tMVm52K2traGtrdnJIWjB6?=
 =?utf-8?B?d1VsdHgra3hjeE5hQjJYaS8rdzhkUlBDdDhueXd4WkxDUDlFOXd4SSt5a0R6?=
 =?utf-8?B?dXBxVkNGeEF4cHlvUno3ZUViUnFaRWFwZUU2LzJGemx2bjRrRUY4RElZc2E2?=
 =?utf-8?B?d2FaZjh0YncrK05CdUFacUc4MVBYaC9MRElqeWZqOU5TRVAvNG9qblQ0RGZx?=
 =?utf-8?B?TTk0WjBLZktiY3JnSWx1cDNpaVU3a1IwdTdDclRIaTh4SDdGdjlsWExsOXBI?=
 =?utf-8?B?WWVDY2tORkJqbDBXQnQvbytxS3l1WWdObU9TbWtvK1hicjJNdlo4S0UwdXJx?=
 =?utf-8?B?QzQxelhDajFMeERWdlhHSXJwQklaK3kyU1Vncm02TXo0MGw4WG5pNWZ6c29P?=
 =?utf-8?B?a0RvSVlxR01EWVdWMk9GZjZiR2NLa1pLcWZ4VmdSSjRHS1NwbWNmcjFhYnhx?=
 =?utf-8?B?MXNMWUhrb0FkTjQ2d2lZM2ZUajgyUGVjeS9UYjJUY3lUUG1rOGZmUkdwN1Q4?=
 =?utf-8?B?aHgwZG8yMC93VzNLanN0ellMazFWTElWSmo4UlpTM1BkNWVwK3g1cC9kRUhL?=
 =?utf-8?B?Q0lHcEN4VkRYZ2V5a1NObGJKZW91YVlEbmtWV3Y1L0k5SU5rV0sxWjhRT1BQ?=
 =?utf-8?B?ay9xRnlxYkFkRXQ0ZHBEWEowVkorMWczL3R3clBnbEJMS0VsNjRLb0U5MDAv?=
 =?utf-8?B?Z216ZHlqejc0UzhVQThoaEo4S1JybFY5ek5iL0IxZEkxOW9wa2R0Ly91ODJV?=
 =?utf-8?B?VlRCdG9oSHh4aFRibTZHd2NmZmRLT0FUNWM2akoxcjBXdE83TWNUR2x3THhR?=
 =?utf-8?B?MVU0dXVxWVNLN0s3bmFTSzdxaVlJMVpnL045bEVRQ1BIcnIwTmwxS1E2Nm54?=
 =?utf-8?B?V1VqVlpHRDErbWZYM3J6am5JeWpHai8zUUQ3RkFnNFVibEZXNUwveXA4QkY4?=
 =?utf-8?B?TDIxYUdIc05XZ0VuRWI0QTJHdEUwSERTTEo1UWMxTHdQQlQ2b3orVmI3RUZX?=
 =?utf-8?B?a3BZV0JZaXRjWFNSMlN3SmdDcXdqUDRMMjgwTlNKRDM1Y3dpQ0FKc1NHYVhH?=
 =?utf-8?B?d2JEcS9hMVZsWEd0TUVkSCs5bHhJa0ROUlhMWjlqSkNnblFRTmkrSGZPVXVS?=
 =?utf-8?B?T1RCTGo2a3BhTUVXTFN0aVVXeFplemdhQWZDRFZ3dUFqNm0xc3pFRHZxSWFw?=
 =?utf-8?B?QWNNQk1rT3VPTEgxWXZLK0hVZ3ZGYWNMNG5RWTFQNVlZNkZ5L1pMVk1GbGZC?=
 =?utf-8?B?STJmdDZBRXVpS0ZaekgzWjAzSFlDMVRiTXUvazRVcHRoUmtoNERJNHY3UFI2?=
 =?utf-8?B?SmJzeitZMmpyV0h3MS9BdCtKWCtLMjdBSXh2MGFranJlOXZUY2ZGaTEzWDlQ?=
 =?utf-8?B?MzZMbDNScGwrZzhyU054QnpGMk9wYnRiUTZvWEJWcmNpcmFxRmFyVGx0VzR6?=
 =?utf-8?B?RTBpYUxoaE9vMDd5c3JVNlpyQTBtbWVwa09qbzZEaXdUOTlCRDVTeEtyK2FK?=
 =?utf-8?B?dk5hTmx0Y2hXaDJIeWJ4cE1jeEs2WFFIcC9UeDhCMmNZOUcvV251YnBtRXU0?=
 =?utf-8?B?WEM0UEkrWjdlOXh3Y2JlUWtGa2x6U3JqTkQvK2MxeE5MWGFwNGZoNm5WckNP?=
 =?utf-8?B?TmltUHk1VVZlejA2U2xaOGZTSDZUdXNEcG1sQ3MyTDh3VTF3WVNkYkt2TEow?=
 =?utf-8?B?TGNwN2FtN2cwMTY0NVdHUUkrbVRCK2QyVC81NU4wWEZxN0x5cWpqZ2JOdnI0?=
 =?utf-8?B?b2dvZkF3Lys4dVZiVVpsaFg1QTN0ZGtsOWlEMVJiZ09malgvUW1RNjBmYnM0?=
 =?utf-8?B?ZlZGVjJvVGcrQStCT3FyeDZ3Z0NMcUY2Wk1wcllwTFE1czJ1T1M2cVVlajR1?=
 =?utf-8?B?ZXFUc3AvSEgrdjRETktOa250bzRYNDdodS9WcUdneWd3ak1KMHRtZEtpY3JH?=
 =?utf-8?Q?4jynC6//JDnC1nUsfd6npIVGU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b97c395-50f0-4dad-26e6-08db23958cf4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 07:35:42.6217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RkeuHPL3gUVQyZzFMNPT3s3oSJzunIGhf1o5otwLWjFow8AsOF1BDcS6Z0RzMsbh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8906
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
>>          efx->type = (const struct efx_nic_type *)entry->driver_data;
>>
>>          efx->pci_dev = pci_dev;
>> +       efx->client_id = MC_CMD_CLIENT_ID_SELF;
>>          pci_set_drvdata(pci_dev, efx);
>>          rc = efx_init_struct(efx, pci_dev);
>>          if (rc)
>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>> index bda4fcbe1126..cd9f724a9e64 100644
>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
>> @@ -206,9 +206,11 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
>>                    "firmware reports num_mac_stats = %u\n",
>>                    efx->num_mac_stats);
>>
>> +#ifdef CONFIG_SFC_VDPA
>>          nic_data->vdpa_supported = efx_ef100_has_cap(nic_data->datapath_caps3,
>>                                                       CLIENT_CMD_VF_PROXY) &&
>>                                     efx->type->is_vf;
>> +#endif
> This should be done at patch 4?
Yeah, right. Will fix.
>
>>          return 0;
>>   }
>>
>> @@ -1086,6 +1088,35 @@ static int ef100_check_design_params(struct efx_nic *efx)
>>          return rc;
>>   }
>>
>> +static int efx_ef100_update_client_id(struct efx_nic *efx)
>> +{
>> +       struct ef100_nic_data *nic_data = efx->nic_data;
>> +       unsigned int pf_index = PCIE_FUNCTION_PF_NULL;
>> +       unsigned int vf_index = PCIE_FUNCTION_VF_NULL;
>> +       efx_qword_t pciefn;
>> +       int rc;
>> +
>> +       if (efx->pci_dev->is_virtfn)
>> +               vf_index = nic_data->vf_index;
>> +       else
>> +               pf_index = nic_data->pf_index;
>> +
>> +       /* Construct PCIE_FUNCTION structure */
>> +       EFX_POPULATE_QWORD_3(pciefn,
>> +                            PCIE_FUNCTION_PF, pf_index,
>> +                            PCIE_FUNCTION_VF, vf_index,
>> +                            PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
>> +       /* look up self client ID */
>> +       rc = efx_ef100_lookup_client_id(efx, pciefn, &efx->client_id);
>> +       if (rc) {
>> +               pci_warn(efx->pci_dev,
>> +                        "%s: Failed to get client ID, rc %d\n",
>> +                        __func__, rc);
>> +       }
>> +
>> +       return rc;
>> +}
>> +
>>   /*     NIC probe and remove
>>    */
>>   static int ef100_probe_main(struct efx_nic *efx)
>> @@ -1173,6 +1204,10 @@ static int ef100_probe_main(struct efx_nic *efx)
>>                  goto fail;
>>          efx->port_num = rc;
>>
>> +       rc = efx_ef100_update_client_id(efx);
>> +       if (rc)
>> +               goto fail;
>> +
>>          efx_mcdi_print_fwver(efx, fw_version, sizeof(fw_version));
>>          pci_dbg(efx->pci_dev, "Firmware version %s\n", fw_version);
>>
>> diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
>> index a7f2c31071e8..3bf1ebe05775 100644
>> --- a/drivers/net/ethernet/sfc/mcdi.c
>> +++ b/drivers/net/ethernet/sfc/mcdi.c
>> @@ -145,14 +145,15 @@ void efx_mcdi_fini(struct efx_nic *efx)
>>          kfree(efx->mcdi);
>>   }
>>
>> -static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
>> -                                 const efx_dword_t *inbuf, size_t inlen)
>> +static void efx_mcdi_send_request(struct efx_nic *efx, u32 client_id,
>> +                                 unsigned int cmd, const efx_dword_t *inbuf,
>> +                                 size_t inlen)
>>   {
>>          struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
>>   #ifdef CONFIG_SFC_MCDI_LOGGING
>>          char *buf = mcdi->logging_buffer; /* page-sized */
>>   #endif
>> -       efx_dword_t hdr[2];
>> +       efx_dword_t hdr[5];
>>          size_t hdr_len;
>>          u32 xflags, seqno;
>>
>> @@ -179,7 +180,7 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
>>                                       MCDI_HEADER_XFLAGS, xflags,
>>                                       MCDI_HEADER_NOT_EPOCH, !mcdi->new_epoch);
>>                  hdr_len = 4;
>> -       } else {
>> +       } else if (client_id == efx->client_id) {
>>                  /* MCDI v2 */
>>                  BUG_ON(inlen > MCDI_CTL_SDU_LEN_MAX_V2);
>>                  EFX_POPULATE_DWORD_7(hdr[0],
>> @@ -194,6 +195,35 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
>>                                       MC_CMD_V2_EXTN_IN_EXTENDED_CMD, cmd,
>>                                       MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen);
>>                  hdr_len = 8;
>> +       } else {
>> +               /* MCDI v2 */
> Just wonder if V2 is a must for vDPA? If yes we probably need to fail
> vDPA creation without it.

Agreed, will add this condition in evaluation of nic_data->vdpa_supported.

Thanks

>
> Thanks
>
>
>> +               WARN_ON(inlen > MCDI_CTL_SDU_LEN_MAX_V2);
>> +               /* MCDI v2 with credentials of a different client */
>> +               BUILD_BUG_ON(MC_CMD_CLIENT_CMD_IN_LEN != 4);
>> +               /* Outer CLIENT_CMD wrapper command with client ID */
>> +               EFX_POPULATE_DWORD_7(hdr[0],
>> +                                    MCDI_HEADER_RESPONSE, 0,
>> +                                    MCDI_HEADER_RESYNC, 1,
>> +                                    MCDI_HEADER_CODE, MC_CMD_V2_EXTN,
>> +                                    MCDI_HEADER_DATALEN, 0,
>> +                                    MCDI_HEADER_SEQ, seqno,
>> +                                    MCDI_HEADER_XFLAGS, xflags,
>> +                                    MCDI_HEADER_NOT_EPOCH, !mcdi->new_epoch);
>> +               EFX_POPULATE_DWORD_2(hdr[1],
>> +                                    MC_CMD_V2_EXTN_IN_EXTENDED_CMD,
>> +                                    MC_CMD_CLIENT_CMD,
>> +                                    MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen + 12);
>> +               MCDI_SET_DWORD(&hdr[2],
>> +                              CLIENT_CMD_IN_CLIENT_ID, client_id);
>> +
>> +               /* MCDIv2 header for inner command */
>> +               EFX_POPULATE_DWORD_2(hdr[3],
>> +                                    MCDI_HEADER_CODE, MC_CMD_V2_EXTN,
>> +                                    MCDI_HEADER_DATALEN, 0);
>> +               EFX_POPULATE_DWORD_2(hdr[4],
>> +                                    MC_CMD_V2_EXTN_IN_EXTENDED_CMD, cmd,
>> +                                    MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen);
>> +               hdr_len = 20;
>>          }
>>
>>   #ifdef CONFIG_SFC_MCDI_LOGGING
>> @@ -474,7 +504,8 @@ static void efx_mcdi_release(struct efx_mcdi_iface *mcdi)
>>                          &mcdi->async_list, struct efx_mcdi_async_param, list);
>>                  if (async) {
>>                          mcdi->state = MCDI_STATE_RUNNING_ASYNC;
>> -                       efx_mcdi_send_request(efx, async->cmd,
>> +                       efx_mcdi_send_request(efx, efx->client_id,
>> +                                             async->cmd,
>>                                                (const efx_dword_t *)(async + 1),
>>                                                async->inlen);
>>                          mod_timer(&mcdi->async_timer,
>> @@ -797,7 +828,7 @@ static int efx_mcdi_proxy_wait(struct efx_nic *efx, u32 handle, bool quiet)
>>          return mcdi->proxy_rx_status;
>>   }
>>
>> -static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
>> +static int _efx_mcdi_rpc(struct efx_nic *efx, u32 client_id, unsigned int cmd,
>>                           const efx_dword_t *inbuf, size_t inlen,
>>                           efx_dword_t *outbuf, size_t outlen,
>>                           size_t *outlen_actual, bool quiet, int *raw_rc)
>> @@ -811,7 +842,7 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
>>                  return -EINVAL;
>>          }
>>
>> -       rc = efx_mcdi_rpc_start(efx, cmd, inbuf, inlen);
>> +       rc = efx_mcdi_rpc_start(efx, client_id, cmd, inbuf, inlen);
>>          if (rc)
>>                  return rc;
>>
>> @@ -836,7 +867,8 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
>>
>>                          /* We now retry the original request. */
>>                          mcdi->state = MCDI_STATE_RUNNING_SYNC;
>> -                       efx_mcdi_send_request(efx, cmd, inbuf, inlen);
>> +                       efx_mcdi_send_request(efx, efx->client_id, cmd,
>> +                                             inbuf, inlen);
>>
>>                          rc = _efx_mcdi_rpc_finish(efx, cmd, inlen,
>>                                                    outbuf, outlen, outlen_actual,
>> @@ -855,16 +887,44 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
>>          return rc;
>>   }
>>
>> +#ifdef CONFIG_SFC_VDPA
>> +static bool is_mode_vdpa(struct efx_nic *efx)
>> +{
>> +       if (efx->pci_dev->is_virtfn &&
>> +           efx->pci_dev->physfn &&
>> +           efx->state == STATE_VDPA &&
>> +           efx->vdpa_nic)
>> +               return true;
>> +
>> +       return false;
>> +}
>> +#endif
>> +
>>   static int _efx_mcdi_rpc_evb_retry(struct efx_nic *efx, unsigned cmd,
>>                                     const efx_dword_t *inbuf, size_t inlen,
>>                                     efx_dword_t *outbuf, size_t outlen,
>>                                     size_t *outlen_actual, bool quiet)
>>   {
>> +#ifdef CONFIG_SFC_VDPA
>> +       struct efx_nic *efx_pf;
>> +#endif
>>          int raw_rc = 0;
>>          int rc;
>>
>> -       rc = _efx_mcdi_rpc(efx, cmd, inbuf, inlen,
>> -                          outbuf, outlen, outlen_actual, true, &raw_rc);
>> +#ifdef CONFIG_SFC_VDPA
>> +       if (is_mode_vdpa(efx)) {
>> +               efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
>> +               rc = _efx_mcdi_rpc(efx_pf, efx->client_id, cmd, inbuf,
>> +                                  inlen, outbuf, outlen, outlen_actual,
>> +                                  true, &raw_rc);
>> +       } else {
>> +#endif
>> +               rc = _efx_mcdi_rpc(efx, efx->client_id, cmd, inbuf,
>> +                                  inlen, outbuf, outlen, outlen_actual, true,
>> +                                  &raw_rc);
>> +#ifdef CONFIG_SFC_VDPA
>> +       }
>> +#endif
>>
>>          if ((rc == -EPROTO) && (raw_rc == MC_CMD_ERR_NO_EVB_PORT) &&
>>              efx->type->is_vf) {
>> @@ -881,9 +941,22 @@ static int _efx_mcdi_rpc_evb_retry(struct efx_nic *efx, unsigned cmd,
>>
>>                  do {
>>                          usleep_range(delay_us, delay_us + 10000);
>> -                       rc = _efx_mcdi_rpc(efx, cmd, inbuf, inlen,
>> -                                          outbuf, outlen, outlen_actual,
>> -                                          true, &raw_rc);
>> +#ifdef CONFIG_SFC_VDPA
>> +                       if (is_mode_vdpa(efx)) {
>> +                               efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
>> +                               rc = _efx_mcdi_rpc(efx_pf, efx->client_id, cmd,
>> +                                                  inbuf, inlen, outbuf, outlen,
>> +                                                  outlen_actual, true,
>> +                                                  &raw_rc);
>> +                       } else {
>> +#endif
>> +                               rc = _efx_mcdi_rpc(efx, efx->client_id,
>> +                                                  cmd, inbuf, inlen, outbuf,
>> +                                                  outlen, outlen_actual, true,
>> +                                                  &raw_rc);
>> +#ifdef CONFIG_SFC_VDPA
>> +                       }
>> +#endif
>>                          if (delay_us < 100000)
>>                                  delay_us <<= 1;
>>                  } while ((rc == -EPROTO) &&
>> @@ -939,7 +1012,7 @@ int efx_mcdi_rpc(struct efx_nic *efx, unsigned cmd,
>>    * function and is then responsible for calling efx_mcdi_display_error
>>    * as needed.
>>    */
>> -int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
>> +int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned int cmd,
>>                         const efx_dword_t *inbuf, size_t inlen,
>>                         efx_dword_t *outbuf, size_t outlen,
>>                         size_t *outlen_actual)
>> @@ -948,7 +1021,7 @@ int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
>>                                         outlen_actual, true);
>>   }
>>
>> -int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
>> +int efx_mcdi_rpc_start(struct efx_nic *efx, u32 client_id, unsigned int cmd,
>>                         const efx_dword_t *inbuf, size_t inlen)
>>   {
>>          struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
>> @@ -965,7 +1038,7 @@ int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
>>                  return -ENETDOWN;
>>
>>          efx_mcdi_acquire_sync(mcdi);
>> -       efx_mcdi_send_request(efx, cmd, inbuf, inlen);
>> +       efx_mcdi_send_request(efx, client_id, cmd, inbuf, inlen);
>>          return 0;
>>   }
>>
>> @@ -1009,7 +1082,8 @@ static int _efx_mcdi_rpc_async(struct efx_nic *efx, unsigned int cmd,
>>                   */
>>                  if (mcdi->async_list.next == &async->list &&
>>                      efx_mcdi_acquire_async(mcdi)) {
>> -                       efx_mcdi_send_request(efx, cmd, inbuf, inlen);
>> +                       efx_mcdi_send_request(efx, efx->client_id,
>> +                                             cmd, inbuf, inlen);
>>                          mod_timer(&mcdi->async_timer,
>>                                    jiffies + MCDI_RPC_TIMEOUT);
>>                  }
>> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
>> index dafab52aaef7..2c526d2edeb6 100644
>> --- a/drivers/net/ethernet/sfc/mcdi.h
>> +++ b/drivers/net/ethernet/sfc/mcdi.h
>> @@ -150,7 +150,7 @@ int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
>>                         efx_dword_t *outbuf, size_t outlen,
>>                         size_t *outlen_actual);
>>
>> -int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
>> +int efx_mcdi_rpc_start(struct efx_nic *efx, u32 client_id, unsigned int cmd,
>>                         const efx_dword_t *inbuf, size_t inlen);
>>   int efx_mcdi_rpc_finish(struct efx_nic *efx, unsigned cmd, size_t inlen,
>>                          efx_dword_t *outbuf, size_t outlen,
>> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
>> index 1da71deac71c..948c7a06403a 100644
>> --- a/drivers/net/ethernet/sfc/net_driver.h
>> +++ b/drivers/net/ethernet/sfc/net_driver.h
>> @@ -859,6 +859,7 @@ struct efx_mae;
>>    * @secondary_list: List of &struct efx_nic instances for the secondary PCI
>>    *     functions of the controller, if this is for the primary function.
>>    *     Serialised by rtnl_lock.
>> + * @client_id: client ID of this PCIe function
>>    * @type: Controller type attributes
>>    * @legacy_irq: IRQ number
>>    * @workqueue: Workqueue for port reconfigures and the HW monitor.
>> @@ -1022,6 +1023,7 @@ struct efx_nic {
>>          struct list_head secondary_list;
>>          struct pci_dev *pci_dev;
>>          unsigned int port_num;
>> +       u32 client_id;
>>          const struct efx_nic_type *type;
>>          int legacy_irq;
>>          bool eeh_disabled_legacy_irq;
>> diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
>> index 9f07e1ba7780..d90d4f6b3824 100644
>> --- a/drivers/net/ethernet/sfc/ptp.c
>> +++ b/drivers/net/ethernet/sfc/ptp.c
>> @@ -1052,8 +1052,8 @@ static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
>>
>>          /* Clear flag that signals MC ready */
>>          WRITE_ONCE(*start, 0);
>> -       rc = efx_mcdi_rpc_start(efx, MC_CMD_PTP, synch_buf,
>> -                               MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
>> +       rc = efx_mcdi_rpc_start(efx, MC_CMD_CLIENT_ID_SELF, MC_CMD_PTP,
>> +                               synch_buf, MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
>>          EFX_WARN_ON_ONCE_PARANOID(rc);
>>
>>          /* Wait for start from MCDI (or timeout) */
>> --
>> 2.30.1
>>
