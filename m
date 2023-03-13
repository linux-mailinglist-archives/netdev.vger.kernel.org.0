Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51F06B77AD
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 13:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjCMMjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 08:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCMMji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 08:39:38 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2070.outbound.protection.outlook.com [40.107.102.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452892DE6B;
        Mon, 13 Mar 2023 05:39:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEHCACKsYJPodlxjWMsCDCDfVawiQx7gC0k/blawxbsgI7Nl468IS7Vn6AKkuWyB1GzqxiSdJ7Op5/ZaxEXcPkF6gPD6J7T3gilYTZ3mxuL5Kf0ZmU+Xml2EvnV2+geNWzqzqNxAmz0OsOKz15f0FXK7jCftP3M2RyZ6GDsqmNdCpkbAwyv02nFlhErtCJ1V60KyXkrnPzfotPX5enXPdJzslgWdUj5L/fKkFIZ/JURC/oB4WNlEVKaSdgBvnEHfKFCtvikPDZl8doccDP2cxOiJklcAXtegL7FVxkHyCEE9P786rcBH5/QM3TDdsbMWw/p0S67FsaC84PGonXFfaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o6cogHANDG7J7g0zCb2X56wKkghhzQoJ1cwoEsLFzro=;
 b=BSBrW7axEh8/8uI2WzLIuEOO2R5KXGj8IcQJMCsVCKa9eZaEmTyJsTR3ycw9EJi01Z5jBsJtpQyUaELrXJR9+nDicQ67+hztysprSqRl0ujLhPBTKu1LHONNQC9t5VqCO/jwuytbALMT7Les15jNNsZ6zwAxv/NSm1zmP4IvfmIAq3QYy85FtrkzqSBnbt/98S13Ku2d+3Dk5/2RQ33qRYxlgSfXR1Lwr287BNRC1gmBME/qqB7ppuVzqzTX/7x9sNG8i2RqmV436ASzYYxpLOl6kO53AezIKMevwzx579q/TXjAF7kuSQY/WCbC2qrc0hhQpOz84IAbjoEo+u6rEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6cogHANDG7J7g0zCb2X56wKkghhzQoJ1cwoEsLFzro=;
 b=s6NzmMJ+9hXTbDS54Uh6K7oHew1X/91EZyis/t2rl8dLro9+98zFMvKB3BEmzpoo/IlmIB60icEF5DcZBJc/jG6AHOwtkPet/+CgVf7amQgdPWdJuCMKwZJbDzgqqVyhXOE2f86qrzuKynZfcxdL27jtleZgLnrvhHMq6qWyIlI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by DS0PR12MB7852.namprd12.prod.outlook.com (2603:10b6:8:147::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 12:39:33 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 12:39:33 +0000
Message-ID: <85ad74df-147b-8d27-dd39-cc9d828ada4b@amd.com>
Date:   Mon, 13 Mar 2023 18:09:19 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 04/14] sfc: evaluate vdpa support based on FW
 capability CLIENT_CMD_VF_PROXY
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
 <20230307113621.64153-5-gautam.dawar@amd.com>
 <CACGkMEvUhC3HfizpiM8zxMa2RwgkR=yLm-GDpY120_32aBmWFw@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEvUhC3HfizpiM8zxMa2RwgkR=yLm-GDpY120_32aBmWFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::8) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|DS0PR12MB7852:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ed6dac0-9da6-47e3-eb2d-08db23bfff38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: glhTXLXcpwDJt1N7lxcJUHHaymCMtSdRSHB8ilexI1r/G5YEfIrz+SGhpxQquE/U99dCwBCmtRyIr2Mq71RaVE3yERAGSm4Fto3amcpHvcP82GZq9OBUqNF7nAETmCk2FFLeDHFojZr758Y4ycZK2yKakfyVHjowoMOkHx1PWZWQ4hVCqX3sfBZ0ECmqPbFFPV7zUEtbRY/JJ9iFPPCUqBmhOF/kK1vPqRcQV/9g5kIlXbICDfAzArH3u8U25+hayWsuWq/gKdWfsfTUf5H1DsPEnq8tR8s+jlDtQ6Yd2HqCyr+Sr64cblv44Hsh9KW2LdQ1dpAWiYIdtA/1XOFERiwwF7W1AExG0kNFp005BvIXnWAvUkHWvwFJ/aeq35EWj5jIo+rivGUyJj/pGrgKJdgJGEUjvLiOdCPhXNFq6ghXswkr8iUtsJsMIDJlNdx9n/IE/tRgTAgnsBZQRUi+D0ZpnHrM2CVNYOrVy48+o8OUkjjERmiGKR0Db5gF/5b16EeAowJRj1ToJ+km3cNITgx6X8qzkOXhICn3lSbHBfwHheA5zFe90ktawtINvcdcbx+egKBUqDJ6hdJU938aJijw0PWEHiVd51zSM38VH8ZTXlMut2MWE1oyPwnzKAh+BqzFlhss+qndejMQoSIK28MvZIcX3cIf1xYzSWcxPV0OQqjID254W/+PAEwBoo0H7sd2T9malyMAEWt4i3mD1avJ6AIC7R3GnM9Gw62OQHDi1L1f1pgOQ7a8dJ4vEfdb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(451199018)(5660300002)(7416002)(36756003)(83380400001)(186003)(478600001)(6512007)(6506007)(6666004)(6486002)(2616005)(26005)(53546011)(4326008)(66476007)(8936002)(66556008)(66946007)(8676002)(31696002)(54906003)(110136005)(6636002)(316002)(38100700002)(41300700001)(31686004)(2906002)(2004002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDVjWjhTK29hOVo3ZDNJNWg4ckhpSElaU0tQZXZLd2RBdnBvRmYvd1ViMTJu?=
 =?utf-8?B?S2FFU0VCTnBBc1gvZUJmU1l1STR1cDYramZzU2wyb0NtK1B0S0twaGZvbVBO?=
 =?utf-8?B?QUZBTlV0VVVpM3BhRDArem9XckJPMGFnT1oyK3l5Vi9LejQ2eHRxei9XZmhY?=
 =?utf-8?B?N1hVd3grWU5sZ2QxdVE4a0drZ1ZiSWJwNGcxSXpVRWd3M2lvVEpodldBdzA4?=
 =?utf-8?B?YUQvT0xzdGdPRW44Z0hWTnNPZTIranBzZTRFdlczUXRkZ0p4NjdsNWczYys3?=
 =?utf-8?B?c0Uxcng3UFFDZ1hHZ0FsYjRURiswU3ZwZWF4OWl0QmNlTitoQzJSYllBZWNK?=
 =?utf-8?B?S0EvWGl4S0VVRzBoUjlNM0pqODIzclFDRndLdzRuUWcrWHphd05jUWpNRWU1?=
 =?utf-8?B?eTUxM0lZb2JZR1YrKzdvNm9KZHl5TkMxaEJXcDlZMlcwM2NhUUhjZ2dmWTR1?=
 =?utf-8?B?VlBySkhXRVByd3VTUFNHNnFTcmhSemU2MlhDQkp3Um9kdjRZdmdTd0s0WXJh?=
 =?utf-8?B?ZjRYaEdhSm4rRlF1eEJ5cUlVNWxkTnQxQVhCeVQyNmVUZFlrUXprcWZ0dUFu?=
 =?utf-8?B?Y09zWVpYZXFBZDVmbk40WlQ0MytJY3lZZ2t3UDFBUGE1OVJBVVpQK3YyQnlQ?=
 =?utf-8?B?dnBhb3l3OUhKK0VIanZKRTJ4Vyt0UHF5dDdXSnVPRnV0Q05jVzB5SUZCUDlI?=
 =?utf-8?B?ZVdvQzZsbkNVVWNWeDg4RnRkcjBnaXFubFFtQ3doN0NzOXJISmtNNmVLRkJp?=
 =?utf-8?B?dEVZeFBmNU9YVTRla0RDN3lkTFZ1d3RJb2J2bnJxdXlSQ3k5UEFuSEtpZlBG?=
 =?utf-8?B?cVQxczllN21BN0dlYXJRemw2eS9nNExVZlhLK3lhQ2lzMTVmQUVOemVBUjNH?=
 =?utf-8?B?RnVtV1JtWGk0Wi8zTnp6MzdEV1NHeGxtM1YyaEQrcEpGbVFmN2xsbTQ4b01q?=
 =?utf-8?B?VURGVGhzcHpJK0ZYbTd4OEl6ekZzL1hLTW0zWXNCY240STdsT0YyNWRtWVRF?=
 =?utf-8?B?cEF0RllCWEtncHZ5ODhma3lQQVA1K1ZQNENrSkVLb1dyeXRkeElQTTFTMlNG?=
 =?utf-8?B?L0daM1pGcmxvcFdnLzNyMkFVS1ZlSUd5eVVzanBqT2pDMTBRQmpzekYxYllm?=
 =?utf-8?B?TUZLSXNWY1oyelo1NnhNN3FvYTZjUlV1Wm1YdW5SSGovTFRDWVJ6ZHAraVgv?=
 =?utf-8?B?N20yMmI0UGJ3aStoUDFINkl6Vi9sTmxSZlA5TkdPZXRVM0FaTzNSOWFsNXoz?=
 =?utf-8?B?ZzhLTGppTk81OTZRRW10eVZ2eU1tVXh6bHBZNnlYWnIvbUpVS3c3OGlzNkhp?=
 =?utf-8?B?M1p1eXFzdkJQaytYRmRVYjJUNjhXZGxlTHhtTXowY3puTEdXSHhlUmM0VGIr?=
 =?utf-8?B?dUw5ZkowKzRzcktRZWNvV29GNVVOc3dsMUg5YWloNEJKVkE4ZkMzME8ybWVI?=
 =?utf-8?B?NCtYR0dMTnd1bnAzbmN4WnNwN1BWazRyTWtmc1V0bUFYd1pNL1ZGd0ZDRDFM?=
 =?utf-8?B?MkhkMnhHQWp1OXVIR216Wi92UzAvazN1cGdaZmdHc2wycVlqYTRHbUdXN05B?=
 =?utf-8?B?VUlJbFJoUHB1REpnWDE3aDVPbzFDTVVRQkNTcy9aTnJiaW9sZjFVa0VnajVu?=
 =?utf-8?B?bTUvZEpXZTZCTzhFUlJKVDBoOS9nQUMxdXdIcndOZUM2U3BFSk1pRnJKL0Vk?=
 =?utf-8?B?N3FtUDgzNENRaW5hc1dFbjdOVW9VWHJpNnpjZGZNK21CSyswSzNEWWRCejls?=
 =?utf-8?B?aWU2eUJFRm12QVVJRVJLeitNN09GZncwRVZjSlA5VnE3MURRWW1CSUN5ay9X?=
 =?utf-8?B?QnRWWmNCaHhTSlk1SFdPeGVJQUphdHhSNFVTeEVSbkpodnJKbUtFcFp4YWN1?=
 =?utf-8?B?UHdyM3R1emZaNDdEZlNlSGpnTzNJak5kT0t1WlJZcWJUVUlxZVdieGFVdFJj?=
 =?utf-8?B?aUZhUm5UMFdwUjBHT2wrcjQyMmpQVXZNVmszSjJEUXQxdlZ3dkxudWZEMHJL?=
 =?utf-8?B?SjVnZVpTd282d1RGZlVxWTV3UkVtSkJRMUhaSEVBWjR3M2ZUL2gzYWpWaFFX?=
 =?utf-8?B?anM5Y2huUlNrTWpkK3FOR05yUlo1TitZZm9Ub3p2QW82a05jb3UyVXN1UHRt?=
 =?utf-8?Q?zVNqPlOFAZgxzHJfRsR/dRBni?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed6dac0-9da6-47e3-eb2d-08db23bfff38
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 12:39:33.5401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pBhi3cc6f7MmzzYgQChzIyWjdSN3xDp0/UhA9UT8F5fkymgpQztz+h5LONCY8PJu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7852
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
>> Add and update vdpa_supported field to struct efx_nic to true if
>> running Firmware supports CLIENT_CMD_VF_PROXY capability. This is
>> required to ensure DMA isolation between MCDI command buffer and guest
>> buffers.
>>
>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>> ---
>>   drivers/net/ethernet/sfc/ef100_netdev.c | 26 +++++++++++++++---
>>   drivers/net/ethernet/sfc/ef100_nic.c    | 35 +++++++++----------------
>>   drivers/net/ethernet/sfc/ef100_nic.h    |  6 +++--
>>   drivers/net/ethernet/sfc/ef100_vdpa.h   |  5 ++--
>>   4 files changed, 41 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
>> index d916877b5a9a..5d93e870d9b7 100644
>> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
>> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
>> @@ -355,6 +355,28 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
>>          efx->state = STATE_PROBED;
>>   }
>>
>> +static void efx_ef100_update_tso_features(struct efx_nic *efx)
>> +{
>> +       struct ef100_nic_data *nic_data = efx->nic_data;
>> +       struct net_device *net_dev = efx->net_dev;
>> +       netdev_features_t tso;
>> +
>> +       if (!efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3))
>> +               return;
>> +
>> +       tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
>> +             NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
>> +             NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
>> +
>> +       net_dev->features |= tso;
>> +       net_dev->hw_features |= tso;
>> +       net_dev->hw_enc_features |= tso;
>> +       /* EF100 HW can only offload outer checksums if they are UDP,
>> +        * so for GRE_CSUM we have to use GSO_PARTIAL.
>> +        */
>> +       net_dev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
>> +}
> I don't see a direct relationship between vDPA and the TSO capability.
> Is this an independent fix?
This isn't actually fixing any issue. This a minor code refactoring that 
wraps-up updating of the TSO capabilities in a separate function for 
better readability.
>
>> +
>>   int ef100_probe_netdev(struct efx_probe_data *probe_data)
>>   {
>>          struct efx_nic *efx = &probe_data->efx;
>> @@ -387,9 +409,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>>                                 ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
>>          efx->mdio.dev = net_dev;
>>
>> -       rc = efx_ef100_init_datapath_caps(efx);
>> -       if (rc < 0)
>> -               goto fail;
>> +       efx_ef100_update_tso_features(efx);
>>
>>          rc = ef100_phy_probe(efx);
>>          if (rc)
>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>> index 8cbe5e0f4bdf..ef6e295efcf7 100644
>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
>> @@ -161,7 +161,7 @@ int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
>>          return 0;
>>   }
>>
>> -int efx_ef100_init_datapath_caps(struct efx_nic *efx)
>> +static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
>>   {
>>          MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V7_OUT_LEN);
>>          struct ef100_nic_data *nic_data = efx->nic_data;
>> @@ -197,25 +197,15 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx)
>>          if (rc)
>>                  return rc;
>>
>> -       if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
>> -               struct net_device *net_dev = efx->net_dev;
>> -               netdev_features_t tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
>> -                                       NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
>> -                                       NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
>> -
>> -               net_dev->features |= tso;
>> -               net_dev->hw_features |= tso;
>> -               net_dev->hw_enc_features |= tso;
>> -               /* EF100 HW can only offload outer checksums if they are UDP,
>> -                * so for GRE_CSUM we have to use GSO_PARTIAL.
>> -                */
>> -               net_dev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
>> -       }
>>          efx->num_mac_stats = MCDI_WORD(outbuf,
>>                                         GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
>>          netif_dbg(efx, probe, efx->net_dev,
>>                    "firmware reports num_mac_stats = %u\n",
>>                    efx->num_mac_stats);
>> +
>> +       nic_data->vdpa_supported = efx_ef100_has_cap(nic_data->datapath_caps3,
>> +                                                    CLIENT_CMD_VF_PROXY) &&
>> +                                  efx->type->is_vf;
>>          return 0;
>>   }
>>
>> @@ -806,13 +796,6 @@ static char *bar_config_name[] = {
>>          [EF100_BAR_CONFIG_VDPA] = "vDPA",
>>   };
>>
>> -#ifdef CONFIG_SFC_VDPA
>> -static bool efx_vdpa_supported(struct efx_nic *efx)
>> -{
>> -       return efx->type->is_vf;
>> -}
>> -#endif
>> -
>>   int efx_ef100_set_bar_config(struct efx_nic *efx,
>>                               enum ef100_bar_config new_config)
>>   {
>> @@ -828,7 +811,7 @@ int efx_ef100_set_bar_config(struct efx_nic *efx,
>>
>>   #ifdef CONFIG_SFC_VDPA
>>          /* Current EF100 hardware supports vDPA on VFs only */
>> -       if (new_config == EF100_BAR_CONFIG_VDPA && !efx_vdpa_supported(efx)) {
>> +       if (new_config == EF100_BAR_CONFIG_VDPA && !nic_data->vdpa_supported) {
>>                  pci_err(efx->pci_dev, "vdpa over PF not supported : %s",
>>                          efx->name);
>>                  return -EOPNOTSUPP;
>> @@ -1208,6 +1191,12 @@ static int ef100_probe_main(struct efx_nic *efx)
>>                  goto fail;
>>          }
>>
>> +       rc = efx_ef100_init_datapath_caps(efx);
>> +       if (rc) {
>> +               pci_info(efx->pci_dev, "Unable to initialize datapath caps\n");
>> +               goto fail;
>> +       }
>> +
>>          return 0;
>>   fail:
>>          return rc;
>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
>> index 4562982f2965..117a73d0795c 100644
>> --- a/drivers/net/ethernet/sfc/ef100_nic.h
>> +++ b/drivers/net/ethernet/sfc/ef100_nic.h
>> @@ -76,6 +76,9 @@ struct ef100_nic_data {
>>          u32 datapath_caps3;
>>          unsigned int pf_index;
>>          u16 warm_boot_count;
>> +#ifdef CONFIG_SFC_VDPA
>> +       bool vdpa_supported; /* true if vdpa is supported on this PCIe FN */
>> +#endif
>>          u8 port_id[ETH_ALEN];
>>          DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
>>          enum ef100_bar_config bar_config;
>> @@ -95,9 +98,8 @@ struct ef100_nic_data {
>>   };
>>
>>   #define efx_ef100_has_cap(caps, flag) \
>> -       (!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V4_OUT_ ## flag ## _LBN)))
>> +       (!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V7_OUT_ ## flag ## _LBN)))
>>
>> -int efx_ef100_init_datapath_caps(struct efx_nic *efx);
>>   int ef100_phy_probe(struct efx_nic *efx);
>>   int ef100_filter_table_probe(struct efx_nic *efx);
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> index f6564448d0c7..90062fd8a25d 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> @@ -1,7 +1,6 @@
>>   /* SPDX-License-Identifier: GPL-2.0 */
>> -/* Driver for Xilinx network controllers and boards
>> - * Copyright (C) 2020-2022, Xilinx, Inc.
>> - * Copyright (C) 2022, Advanced Micro Devices, Inc.
>> +/* Driver for AMD network controllers and boards
>> + * Copyright (C) 2023, Advanced Micro Devices, Inc.
> Let's fix this in the patch that introduces this.

Sure, will fix.

Thanks

>
> Thanks
>
>
>
>>    *
>>    * This program is free software; you can redistribute it and/or modify it
>>    * under the terms of the GNU General Public License version 2 as published
>> --
>> 2.30.1
>>
