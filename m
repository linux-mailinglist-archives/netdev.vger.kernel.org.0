Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AE66BE7D8
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjCQLTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjCQLTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:19:19 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DEE746DA;
        Fri, 17 Mar 2023 04:19:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7XyNXsyScY0eP89G+jsNTJygJLBeupYK/P9xIuLYvdVoE3qXcqLs+vo5Gs1JopE1iKerzwlcJScoBmWp81r5iDPaFlRQW2xWwP7rf6rSbvXf1hK+6egad3GVqkcWPXSyuraid3AJc7QSojEAGIlTwcTbm/716ZoG6lxRilva4i9502ZxchahFXCaOUwRz9nBuv5DCSHjyLWnvHjVGBnw9GPr33wpf6wwIbeS8m2hP83J5yy1LDnLIMfmg2tOoknBWcatjyfdJMcp4Psdjy3aULim78SQTlhEtW+xx4VKKGXsgQbzymiG/NDnnrNUm9LD3eJTOHbY0Ax+3NozOkxOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LKMgehARYdRTla1HcS2cXFdFng9LUQYBfEf+QVZM3wU=;
 b=Jqpef3knxIWhzotHAtzPKRlnl9vEoB6uz4aE+sEVMDSuwW7AVXNp6JR97R9wTDJxNRJWIty76JK3zkJiMLcAOkqOMFzJIEAHLQmBZP8kvze04utHKH1bBeh+p6aU8O6lFXDF279UI8IDdU4PLjg5m/n/JS+rYglJvmSgi1RiThTB2YAXDn6EpvX1bW5o7K5dPR+3tHyIb963WBWwKnsAyAxYSXmEedxA1XqJdi8mfCezl0Krn0IB11zgy7GD6TPeh8zyz0vLPeft7n3dictiREbE677JzV8SQ2Tt8tR+EyYrC5wiVBkb9xVAWVouTXWzn++nK7hI8FzaArQjw9TjLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LKMgehARYdRTla1HcS2cXFdFng9LUQYBfEf+QVZM3wU=;
 b=AIedNbMw6Nqf+FNiWArE8POm/eiszOj+z7foHGlABJT0FVsCaCx/kXA/Kd4x1Ixj1u7QIiwQ9usXMI0lbyWd8I+dMV/Jx9nAslBGtTFG8k/HsYPBdI7RTUn0O/36g/rTBaDAOp21NwoDJIDDJYXrF61qPu8r1qf5Ccz6WpwO4o8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by LV2PR12MB5728.namprd12.prod.outlook.com (2603:10b6:408:17c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Fri, 17 Mar
 2023 11:19:09 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Fri, 17 Mar 2023
 11:19:09 +0000
Message-ID: <0fe7688b-b944-2707-a084-3ebd432d8e85@amd.com>
Date:   Fri, 17 Mar 2023 16:48:54 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 04/14] sfc: evaluate vdpa support based on FW
 capability CLIENT_CMD_VF_PROXY
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
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
 <85ad74df-147b-8d27-dd39-cc9d828ada4b@amd.com> <ZBAym05znKuFjJ3G@gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <ZBAym05znKuFjJ3G@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0202.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::10) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|LV2PR12MB5728:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f07cdbd-1a57-4bf8-0109-08db26d96dc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RK5PpazoAYGY96PftiQj87rQRVkpzXG3RxhjZOiOmLx7qEg9yt1HyVfxc9sMMvWVCHB2nL9s3ecVjQQ8owWdv5ntaUzZu7eUnHFZG1iXDhlORaFvZlMOtqZXK/S4c+dvcTDFivc9EtbDAkLfjK86trBlsNUA+jZEIJlq1AhgmF1s9XSDHihJJDlX3zpVhHfv9JyyRCtFUuN/aW1DKWPEhXUHEWKFWZSXRHTElmZEgMyLFxQai+XAbv4JWLZJ3OYz3TlFobvpyFrXzOnM2ldTehqgCWJthe9ryfRjq2LFP38lmhwUo3VBuWWWWy+Woj/jYTQvaSZftTWPs67f3PIXRSRSG3td9sYEVO2QmT6HuOI7+F5fxv83uibGOpLeqQdhf1N/P7T6OkBHfYl5J/EG2vr/+6H1J7WBu5t0GcIPiPNn6ElrzJuJltgo/YIoYFVsblC9I/NQALnXhCM12idQxUTsM/R5nAlYE4oQJoL5011NuxhW1irrTRNhxh7G9tNdl1z5lPbQMtB5+n+MBkPDFfl2qD+EyswpYD3eujTwbMD21uou78WQ3Vtx6Ek/Kb31pei7YOxPI+Dsdbl/Y1oBdYZUCMqIQ/sH7GHKaEgN0EFy4Eb0zslndBXGrDwKjEUrp4sYaUAFpC919WYu/hreyDELpJBisotPYPhEFsB/T7yOHF/ttNbwzU2QmJEQgbmufky3kGYENXH3lbnrnoeRfy4XpYPNZ2j/4buiQV3ohS+YtBZPKcuwu01/Ami70o5+CwPAnzarEmyY8RzpVbv+2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199018)(31696002)(36756003)(921005)(38100700002)(7416002)(5660300002)(2906002)(8936002)(41300700001)(110136005)(53546011)(26005)(186003)(6636002)(6506007)(6512007)(83380400001)(2616005)(316002)(66556008)(66476007)(6486002)(66946007)(478600001)(8676002)(6666004)(31686004)(2004002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0JHM0xlZWhOTHB4N2J3KzJRQVhsMlplS0lDNEdLS1RwR0l0RllqajdRejRJ?=
 =?utf-8?B?aXV3U2phK1ZMa3AxdEpyUm1NOHBOd3lTL2ZqNCtSa21qaGV1bkVNUVdRN0E0?=
 =?utf-8?B?NFowakpWOUk0ZnpsbVhYN21GTlZrM2hUb0gyR3VlOEErU3l5MGJ3SzdSTUxw?=
 =?utf-8?B?RU5UbUhPSHYxV2hIUUpVcjJxSi9lUXI1N011RW1kK1RUL3ZicmNxMFQrdTJn?=
 =?utf-8?B?ejRKOWVPOUhsZ0xQaW1TYUt4N3VlUTFLVWtFR0U4OGZ5akFXdnl4MVVhWXdI?=
 =?utf-8?B?bUZRVVBITDZmWFc2QVdQRHgzUXErM1ZSTUJnQ2FvREd1dktua1dkcDh0OU1P?=
 =?utf-8?B?dElnUldKdFlLczdZWTFTeXNCTGhzNjhYU3g0OGxCcC80VDNRNlFUd2RRb3dB?=
 =?utf-8?B?L2QyeG11QzZIYU5STXhkaFgvZW9uWUhBaXorRTQxWjgyUXJIYUJ1NG5kcWp2?=
 =?utf-8?B?UGFrZ0hBajhBejl6Ung2ZThVdkNJZ1ZlbHZtQTdrRU5Va213dHFyblgxRUlC?=
 =?utf-8?B?c1Y4NDA1QVp4RThYUUpvTUd1alE0RjlwSVUvTXJFandLZGsvWVRmdTRMUGJX?=
 =?utf-8?B?TmY4V0ozQTF1MFhjd3lsT0FSN0RPNHpqM0pEaGw0dUIybllzRkdyWEFDNkdI?=
 =?utf-8?B?Zm96RmJDai9yM2dyNW5LMGVCMzNTOUdGYUY0bUo2SHBYLyttdEZaaTRHUkVM?=
 =?utf-8?B?Mlk4N0VPQ1RqdWw2eTZUNjc3dWFMSE0yWDVZMStpYU5mQmdyS1AzeHdsbk5U?=
 =?utf-8?B?RVdzckdKa0lVVHRuNlFxYkI0NU1scnUrVS9iYVNvT2MrQnZJbjIrbHpFYXdt?=
 =?utf-8?B?MGF4bmhkZTdwd3VnYkVFdWFiaG8vdlJoWVhtSWxJbkZvUE5Zb2ZBZEJiR2xV?=
 =?utf-8?B?azJCQ2s0QlBwNy9CZkNtaFRUYzlhRGNrZXNoRUozK1h4dHdUYzN4RHZSUFJx?=
 =?utf-8?B?M3ZYMnIyc3hRRnJnbmlFMysrN044b0xIM1V5YVlXS3hPOXNUcVh5OHcxR3Nk?=
 =?utf-8?B?bTlsVytNZDlRVUZxakQzejcveUtvR1J1Tk9BMmxmMlhiNi9xcUs0SE5BOVZn?=
 =?utf-8?B?M1hNM0hKTjBJZDcvZTV3Q3AvUGdDL3I4b2xMd3d0SGRYbjNUeHdyS1NIZHdQ?=
 =?utf-8?B?OW84bTQ5NlBXeVE5eHRDd1ZQckpIVlR1S1VWM2pyQ3lVRnYxTXVYdzhRY1dw?=
 =?utf-8?B?a1VEMlV3bmIyYmovUlN5THRKTEhnN004dHVWamt6aHA2U08reEVJRlRGd2xP?=
 =?utf-8?B?ajRLQ1JlQmdYQ05xSGpDSU5pcXpJNjZUM1hxTE9JWjBtdTZmRVN1bzIvK3Ur?=
 =?utf-8?B?ak1XVjBFdVRTeUZjR2Rkc3pKdzJueEh5cUJqYzBqajdXQmdZT2ZkcFowd2Y2?=
 =?utf-8?B?d2NtakZiSVVDNUQ2a2I4aWcyYVZJUjNUeXhZeVVaeXdheDQxYk11cXNGNkZS?=
 =?utf-8?B?aVVjeHZSdnlvMkh3Uk9tdjBqL3d3elBRSU4vTVU4RVZoaGs0SUx0aHVza0tp?=
 =?utf-8?B?dDJ6S1VUNHJ5cEVwTUo1R3hIK1Jka25xa3FHbGMybHpVMzdRaGlWejh2c1Ft?=
 =?utf-8?B?WlR2SnJHSEhYZ0M3VGxQZVpaaVhsODBwR2FWbkRqNkRMUjB5R2poL3FySUZQ?=
 =?utf-8?B?M2M4OFovK3FkcnlHZ1d4T3krYmdVSkthL3NuNVBUTElPNGpua0JVczdpankx?=
 =?utf-8?B?VFVRNWFKMmRBbTNYVVpZTTN3NUliYlpTQXp6cmN3Njc0RnFoaDdKMUdNd1Fw?=
 =?utf-8?B?Sm1TRm1CNFVPaTRFYU1IRFBhQTEyVEMydzNNSjMxbng5czh3dGtVdnBteDQy?=
 =?utf-8?B?ZmsyOEhSMit2QldlbXgvSFNrOWFPWlMvbks0ZDliQlorQ0lyZ1ZEOElDdTk3?=
 =?utf-8?B?SU16RUtwS1JkSUVoNzlabG0wb1JqeWQrdWhEMEdQYUx4R05UOE1JVjhrVXVC?=
 =?utf-8?B?bS96NXdmZGtTWE1ya1R4WWdPcFZsejFJQ0lDVWs2NHNVdW9mbnRoRGVQTDdW?=
 =?utf-8?B?d2dNWjRoYk5NeHVQdXRPand3allPeGxaRzhsQTNTc2lZSWZpRnMrTjBkejlu?=
 =?utf-8?B?ekRaekd2eDJQdnR3SmNSNkc2Y1k0Qkd2OGI2N2ZhN1J0REVYaFVWTG9nT1dY?=
 =?utf-8?Q?7WAuFHZcYmxpiR7bkgQhchxbj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f07cdbd-1a57-4bf8-0109-08db26d96dc2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 11:19:09.5652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B20gAwg65Szxb64ilbRH8HFAT1ZN/PvYuMqUL2+Xj2Mcmz+3y8b1273GuW942Upv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5728
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/14/23 14:08, Martin Habets wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Mon, Mar 13, 2023 at 06:09:19PM +0530, Gautam Dawar wrote:
>> On 3/10/23 10:34, Jason Wang wrote:
>>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>>
>>>
>>> On Tue, Mar 7, 2023 at 7:37 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
>>>> Add and update vdpa_supported field to struct efx_nic to true if
>>>> running Firmware supports CLIENT_CMD_VF_PROXY capability. This is
>>>> required to ensure DMA isolation between MCDI command buffer and guest
>>>> buffers.
>>>>
>>>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>>>> ---
>>>>    drivers/net/ethernet/sfc/ef100_netdev.c | 26 +++++++++++++++---
>>>>    drivers/net/ethernet/sfc/ef100_nic.c    | 35 +++++++++----------------
>>>>    drivers/net/ethernet/sfc/ef100_nic.h    |  6 +++--
>>>>    drivers/net/ethernet/sfc/ef100_vdpa.h   |  5 ++--
>>>>    4 files changed, 41 insertions(+), 31 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
>>>> index d916877b5a9a..5d93e870d9b7 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
>>>> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
>>>> @@ -355,6 +355,28 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
>>>>           efx->state = STATE_PROBED;
>>>>    }
>>>>
>>>> +static void efx_ef100_update_tso_features(struct efx_nic *efx)
>>>> +{
>>>> +       struct ef100_nic_data *nic_data = efx->nic_data;
>>>> +       struct net_device *net_dev = efx->net_dev;
>>>> +       netdev_features_t tso;
>>>> +
>>>> +       if (!efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3))
>>>> +               return;
>>>> +
>>>> +       tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
>>>> +             NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
>>>> +             NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
>>>> +
>>>> +       net_dev->features |= tso;
>>>> +       net_dev->hw_features |= tso;
>>>> +       net_dev->hw_enc_features |= tso;
>>>> +       /* EF100 HW can only offload outer checksums if they are UDP,
>>>> +        * so for GRE_CSUM we have to use GSO_PARTIAL.
>>>> +        */
>>>> +       net_dev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
>>>> +}
>>> I don't see a direct relationship between vDPA and the TSO capability.
>>> Is this an independent fix?
>> This isn't actually fixing any issue. This a minor code refactoring that
>> wraps-up updating of the TSO capabilities in a separate function for better
>> readability.
> There definity was an issue here: the vDPA code now needs access to the NIC
> capabilities. For this is should use the efx_ef100_init_datapath_caps below,
> but that was also doing this netdev specific stuff.
> The solution is to split up efx_ef100_init_datapath_caps into a generic API
> that vDPA can use, and this netdev specific API which should not be used by vDPA.
>
> Gautam, you could explain this API split in the description.

Sure, will update the commit description with this information.

Thanks

>
> Martin
>
>>>> +
>>>>    int ef100_probe_netdev(struct efx_probe_data *probe_data)
>>>>    {
>>>>           struct efx_nic *efx = &probe_data->efx;
>>>> @@ -387,9 +409,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
>>>>                                  ESE_EF100_DP_GZ_TSO_MAX_HDR_NUM_SEGS_DEFAULT);
>>>>           efx->mdio.dev = net_dev;
>>>>
>>>> -       rc = efx_ef100_init_datapath_caps(efx);
>>>> -       if (rc < 0)
>>>> -               goto fail;
>>>> +       efx_ef100_update_tso_features(efx);
>>>>
>>>>           rc = ef100_phy_probe(efx);
>>>>           if (rc)
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
>>>> index 8cbe5e0f4bdf..ef6e295efcf7 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
>>>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
>>>> @@ -161,7 +161,7 @@ int ef100_get_mac_address(struct efx_nic *efx, u8 *mac_address,
>>>>           return 0;
>>>>    }
>>>>
>>>> -int efx_ef100_init_datapath_caps(struct efx_nic *efx)
>>>> +static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
>>>>    {
>>>>           MCDI_DECLARE_BUF(outbuf, MC_CMD_GET_CAPABILITIES_V7_OUT_LEN);
>>>>           struct ef100_nic_data *nic_data = efx->nic_data;
>>>> @@ -197,25 +197,15 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx)
>>>>           if (rc)
>>>>                   return rc;
>>>>
>>>> -       if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
>>>> -               struct net_device *net_dev = efx->net_dev;
>>>> -               netdev_features_t tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
>>>> -                                       NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
>>>> -                                       NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
>>>> -
>>>> -               net_dev->features |= tso;
>>>> -               net_dev->hw_features |= tso;
>>>> -               net_dev->hw_enc_features |= tso;
>>>> -               /* EF100 HW can only offload outer checksums if they are UDP,
>>>> -                * so for GRE_CSUM we have to use GSO_PARTIAL.
>>>> -                */
>>>> -               net_dev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
>>>> -       }
>>>>           efx->num_mac_stats = MCDI_WORD(outbuf,
>>>>                                          GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
>>>>           netif_dbg(efx, probe, efx->net_dev,
>>>>                     "firmware reports num_mac_stats = %u\n",
>>>>                     efx->num_mac_stats);
>>>> +
>>>> +       nic_data->vdpa_supported = efx_ef100_has_cap(nic_data->datapath_caps3,
>>>> +                                                    CLIENT_CMD_VF_PROXY) &&
>>>> +                                  efx->type->is_vf;
>>>>           return 0;
>>>>    }
>>>>
>>>> @@ -806,13 +796,6 @@ static char *bar_config_name[] = {
>>>>           [EF100_BAR_CONFIG_VDPA] = "vDPA",
>>>>    };
>>>>
>>>> -#ifdef CONFIG_SFC_VDPA
>>>> -static bool efx_vdpa_supported(struct efx_nic *efx)
>>>> -{
>>>> -       return efx->type->is_vf;
>>>> -}
>>>> -#endif
>>>> -
>>>>    int efx_ef100_set_bar_config(struct efx_nic *efx,
>>>>                                enum ef100_bar_config new_config)
>>>>    {
>>>> @@ -828,7 +811,7 @@ int efx_ef100_set_bar_config(struct efx_nic *efx,
>>>>
>>>>    #ifdef CONFIG_SFC_VDPA
>>>>           /* Current EF100 hardware supports vDPA on VFs only */
>>>> -       if (new_config == EF100_BAR_CONFIG_VDPA && !efx_vdpa_supported(efx)) {
>>>> +       if (new_config == EF100_BAR_CONFIG_VDPA && !nic_data->vdpa_supported) {
>>>>                   pci_err(efx->pci_dev, "vdpa over PF not supported : %s",
>>>>                           efx->name);
>>>>                   return -EOPNOTSUPP;
>>>> @@ -1208,6 +1191,12 @@ static int ef100_probe_main(struct efx_nic *efx)
>>>>                   goto fail;
>>>>           }
>>>>
>>>> +       rc = efx_ef100_init_datapath_caps(efx);
>>>> +       if (rc) {
>>>> +               pci_info(efx->pci_dev, "Unable to initialize datapath caps\n");
>>>> +               goto fail;
>>>> +       }
>>>> +
>>>>           return 0;
>>>>    fail:
>>>>           return rc;
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
>>>> index 4562982f2965..117a73d0795c 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_nic.h
>>>> +++ b/drivers/net/ethernet/sfc/ef100_nic.h
>>>> @@ -76,6 +76,9 @@ struct ef100_nic_data {
>>>>           u32 datapath_caps3;
>>>>           unsigned int pf_index;
>>>>           u16 warm_boot_count;
>>>> +#ifdef CONFIG_SFC_VDPA
>>>> +       bool vdpa_supported; /* true if vdpa is supported on this PCIe FN */
>>>> +#endif
>>>>           u8 port_id[ETH_ALEN];
>>>>           DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
>>>>           enum ef100_bar_config bar_config;
>>>> @@ -95,9 +98,8 @@ struct ef100_nic_data {
>>>>    };
>>>>
>>>>    #define efx_ef100_has_cap(caps, flag) \
>>>> -       (!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V4_OUT_ ## flag ## _LBN)))
>>>> +       (!!((caps) & BIT_ULL(MC_CMD_GET_CAPABILITIES_V7_OUT_ ## flag ## _LBN)))
>>>>
>>>> -int efx_ef100_init_datapath_caps(struct efx_nic *efx);
>>>>    int ef100_phy_probe(struct efx_nic *efx);
>>>>    int ef100_filter_table_probe(struct efx_nic *efx);
>>>>
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> index f6564448d0c7..90062fd8a25d 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> @@ -1,7 +1,6 @@
>>>>    /* SPDX-License-Identifier: GPL-2.0 */
>>>> -/* Driver for Xilinx network controllers and boards
>>>> - * Copyright (C) 2020-2022, Xilinx, Inc.
>>>> - * Copyright (C) 2022, Advanced Micro Devices, Inc.
>>>> +/* Driver for AMD network controllers and boards
>>>> + * Copyright (C) 2023, Advanced Micro Devices, Inc.
>>> Let's fix this in the patch that introduces this.
>> Sure, will fix.
>>
>> Thanks
>>
>>> Thanks
>>>
>>>
>>>
>>>>     *
>>>>     * This program is free software; you can redistribute it and/or modify it
>>>>     * under the terms of the GNU General Public License version 2 as published
>>>> --
>>>> 2.30.1
>>>>
