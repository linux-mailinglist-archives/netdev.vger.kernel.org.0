Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7128D6B7261
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjCMJUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbjCMJUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:20:16 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E399424498;
        Mon, 13 Mar 2023 02:20:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgG8+6UTE4R1at/Z/9hNcbV1hCbyiZEzRQ+wviCVY0F6ttgXbtytXS0L0Sb166HzPm7YiUD9If32/9MIQT+quk4jjqnrNFVEug1CBSeNhZ86lUbAm1WbyAbuS4dMwNWtZFzdOTyQaK/46d9lTpu20KNXOp2BEelvlgvPNC13eBoOQi5K7lEAcrZ1KYjJMItCWvcjLeCxmj9xdf7wEiNh7FxKuv7t4LgLTrIEZ3NSnnxFO+FPWjeyiXJpQsaApvwShI5zM3ULg5kMPptbH1FfXaiTtKG9QpHdNLe9i24+QcY4Zi96oxynBOrJxGOZiQ5IT1e8bgKz2YBgkTk0xino3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zZYwoUNYeBnyY8MfEQklirU/wSKsXrqd++6yuhtnqj8=;
 b=awksbzdVXpU6G/NFh4crJConSK5Oat9K4GYMDBz2fgOvZFONHtcgTdNzEKSHmw1yTpMFBsnzyqqsXyz58N4cAz+kRkB9L/edt0NszREXkFGtajoiKRo1VDLbnMAqM1YU3lXKB4Fvjrv2QS8LywoTX7WeanHRXJz/Me3Eca0C+8CUkBE0ptFb0Kwc1OV+mY1KhKCaVnX0zY7of3cwy8KpVtC4IUPCLgXue4TgThLDippy4lLB9v2658R9MXPrXkwBALuyHhzUWLPuU+xreyTh4Bk/fS2hZh3sf9pSvkDD473MR10tLdlNuBAPqJ57J56uhulLitz7SLMg1SYU5tONjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZYwoUNYeBnyY8MfEQklirU/wSKsXrqd++6yuhtnqj8=;
 b=R/8+ILkMeFzF1XW3ZgHqXrb0vMTYrNlpV/ytKeljG/PtjhJaOyJGbmmaRPHg1piup4mtl0sMZKKVzijR2QVknXQtdC1k4p2Zt/kAD0psSvjHv8frICyqJ/cCNvKgTLJFLdnHmUxO0IK6Qa6g7o1S9UjJ3Lzo0ig9DH++WWYiZTM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by CY8PR12MB7100.namprd12.prod.outlook.com (2603:10b6:930:60::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 09:20:11 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 09:20:11 +0000
Message-ID: <4086d641-fa32-2b66-6ffa-6e6d37e6de95@amd.com>
Date:   Mon, 13 Mar 2023 14:49:59 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 10/14] sfc: implement filters for receiving
 traffic
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
 <20230307113621.64153-11-gautam.dawar@amd.com>
 <CACGkMEvydZGva7onADoG7H-1a6upjD1bv1Aw90eRDEFp+Hv2Jg@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEvydZGva7onADoG7H-1a6upjD1bv1Aw90eRDEFp+Hv2Jg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0236.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::20) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|CY8PR12MB7100:EE_
X-MS-Office365-Filtering-Correlation-Id: 6de81f9c-7ecc-4a72-392e-08db23a42514
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ftu2mS8ewrsaUUoIW7YmMOKEshdFDOGH0RJf85qkgWLB7vaMJmAv+0bxovBx6WWzuvE2ezKWmp4+nZbEAkMHV8/YFjSnEqXU8yoDUNJUrVXyntG21hsJjSb1ku8NSLcUOqszfSVb/wtQaGoPMtc5D6ad8Bue0DJbmp73jyzH7o5VmR8/ajXB/1/3UkjFoormiA9yzDEnM/CtJuwRTTeNF98eD6UF7PiN+zFgUe9UZSgqkb1VXktdr9WVGvgNFRQerrnCmRQw94gbmfPkv4nPh6qMIAR80+TF/9JoemZ78GIme9lsJU9s/NPPUfa2Ahf9rPnR+lKPkPifcExDdipAUvBDxr/MAHQr9/u8tD1DAsfABJSVaEns43W3F/VcaQKY86qYLUap3KkjGxg4t7OT5gldi9N4tTrN9VqYpvcCVP62CZESkyWVIpFWqxwAnjn2+lZ1mj/P87UBT4s4R+5aks7i+7PPHc7ONS3MI3MYL1CG3DbmC7FMRcDVeSJa5LNqMnOxK6A70CJzRL+aSR8hTW02HWXWDLL1pK2Hs+xX8WWl+U41kkPfsb0GDtneuv1qmR3eRQqI2jvNTUND/a/XQLwtUHLkWEcghFjiCjQBW1BdFWTLY/rRmM4m52FyypI+pL/yOB03mrPGFvv3/K6NR5wjZeOV1XfWx4c+IsGjC48g+zS+oK9vexNLAGv1exNwg8TuESPPEgD5rOABbHH7EJanEpTEma38BfEGqghHwr4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199018)(38100700002)(2906002)(41300700001)(8676002)(66556008)(66476007)(4326008)(478600001)(316002)(36756003)(66946007)(6636002)(54906003)(31696002)(110136005)(6486002)(5660300002)(30864003)(53546011)(26005)(6512007)(6506007)(2616005)(31686004)(186003)(7416002)(6666004)(8936002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3dSRXlLd0hJNVpsaGRWMWNhL213czF6dDQrMGE3eGtUUWFMZ3pRTE93SDAx?=
 =?utf-8?B?OXJVU2JRTURUaG0wUmo5NGE1Yno0dVNKRDNnMnpPRGFaSWJKNnM1T3YxRGVH?=
 =?utf-8?B?a3VTMnlvRVBiZXBpZ1JoUXdZR2FPNVc5WDZ1aWxiU042UDZtMlA2VXlwaXhP?=
 =?utf-8?B?dVRab2FGbG8rQi8zVnNMZTgxZzg2alJlL2M0NjhUU0VBVFRNQmVqZHVtLzN0?=
 =?utf-8?B?TlcxcWpENU1XUUluQm0zOE5qb3ROOTh6em9jTjgxUG44RXFLV0FaaUJUTmUr?=
 =?utf-8?B?S3hxTzdKVFRvaDRYVEJFY1dPQjBLOG1RMUNsWi85V1hzY2Iyc3QxbVF1eU1N?=
 =?utf-8?B?YTlNZ1VBZ1RwcUc5NnhKYkpUN0RBczZDa25vQzV6QkFWM0prdFl0Uk9GZS83?=
 =?utf-8?B?bG5QaitRZmpGOFl5NDMrbUkyTHRyYzBkdEhYNVp3cllXYlpWSjkvVmdYYWlY?=
 =?utf-8?B?N014bm1ORjdmTFVlb2RyaGtwTEVnWW01SjhlSFkwU1VKWnpMT1ZYMnBWWHU2?=
 =?utf-8?B?UUNTT3puaTJrbEdmRWdhaytxL2oxcC9WN25TcnFPSFNVRk8xaXdlRE15d0JY?=
 =?utf-8?B?OUJ5WDI4RE04cmwrOHhCM3FZOTVoZlpYekhpcTF3YzlraGxkUkdUTHBQV2ln?=
 =?utf-8?B?K2h0YzMvMEtxRDUyUEVnUFZrbjVoRXlmaHR3S1d5ZFgxSW44SHFxTlk2bUs1?=
 =?utf-8?B?a3IyNW5ObHJWR3ZvSmFnZE9JbGgreGJlbGdCcnIyclphWVBPNFR0Zm8yOTJh?=
 =?utf-8?B?cFRpbVhnYmowK3FkeUVTNnFSYkZJQ1hoMEpsYWhEVldaL044ZmI5eEZDTTFn?=
 =?utf-8?B?UXQ1UHRRVGNnQkMxUFcwYjhNNHN5amZmRTEwdDMzL0pFSGJrdHh0a200dWp6?=
 =?utf-8?B?TEJoamRqSlZWUUZZOVQ1djBHZkQ3M09jNFJBSDR6Wk5uV3RsQXJneVRMd1cz?=
 =?utf-8?B?SVJmU0tORDZ2RENrZVFVL29MMWVTL1YzaGFHNU02MUR6OFlvVUxlZTdoN1Bh?=
 =?utf-8?B?NDlMYXV3RElGRkY2c3BScTVHNzl5VUNOV3JyNXJJT3BjN3V5WFpsVEJRUFJq?=
 =?utf-8?B?YU9HajhDT0pvVGlQSCtMT1Y2Q0JBbGx5SEJkOVVIMVE1N3BlSnF4US9IWE9O?=
 =?utf-8?B?eTFicmdlN2pBNEJiRHN5dkEzWGhBL3dUZnNubWt2QzZXZFhwNnFTOTV1L2th?=
 =?utf-8?B?T3g2R1NUYm9BbG5jcTJUL25XNERBdFhSaEJNNTlYRmEzaC82N3dwbjBoZFRo?=
 =?utf-8?B?b0w2SjFZTHVOeTlJRE5XWnRKKzBpNWJTNDdVN0QzbEdkSWtSZm1qVjNvQlNu?=
 =?utf-8?B?UTlWdnpoc0NrYk1yVHhCK1RRb0JGRHA5T3FtNlR6YzdlaHp2ZDVIR2x3RWky?=
 =?utf-8?B?MG5tQ1NCdkRqQzlLYlBjRDE3djV1YUVEM0prTmpzRzRCTHJ3UUdDWStTNDRl?=
 =?utf-8?B?dGttMDBPNmoyU0JocThrQUIxT0R4VVpBZk4zMysrSit2a0t6SzN6UUFYZzZ2?=
 =?utf-8?B?M0l6cTduMU8xQVFVYy9EYlNGa2JMSjhvVkpBcXZZb29tYTdLT0FFTUlsd3RQ?=
 =?utf-8?B?c2M5VDE1cEYxcldtdTlsVGRtWEdFamdRVFAwWmlIVkcwZkMvR0VWMFp5QWVT?=
 =?utf-8?B?bnZZN3VjNHg3NUttY0V1WUJNTGo1RjA0UkZKVjF2aStXRWRPZGFNeklDTXc2?=
 =?utf-8?B?L0tRWVY3OG5UMytkUzE1Zlp3QXdHa29HcVhjVE1qb2l5b1BkWDRTV1ZhVDhD?=
 =?utf-8?B?QUFmYkVwRjhOSkRYUGtYdWI1YlhsMEo4VEMrcWRXUVp0ZVhzWi9ZYUhITHVZ?=
 =?utf-8?B?Ym03elJpUDIzaHZzTmpqbnlVaTJJUlpycFZicnhsVHRtZW52dHYzNGJZQjcw?=
 =?utf-8?B?dHZoUXU0SXpsUXdQVVIwZmgrQ05jWlF5QVpZM3hzUlg1bTEzSkRPT1F2MmZh?=
 =?utf-8?B?dHJGb1JYWjRnZ21sK1dkYjFzL29maHJYWm1pdzlPQmpDU3V6SG1hQTloU1h2?=
 =?utf-8?B?dGExdlRINEhheHhLcWNZNXJWTU4xUUNCUWdHa1B4QTlhdVZzV1RKeXhLZnZt?=
 =?utf-8?B?RllFZzAwRVNzVEhOTWF6UlZYQUUzeXEvL2lhWEJsOXI5WjZaUlRMT1hZR29F?=
 =?utf-8?Q?vT6Che1DuzouOMYVGFv1UdH3J?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6de81f9c-7ecc-4a72-392e-08db23a42514
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 09:20:10.8311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rDkvX8YlrDsNi/T/QHb2zVLQmXMtsP7aBYhApZagfyRg6j7c0G/qeEutqQuQ9vfs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7100
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
>> Implement unicast, broadcast and unknown multicast
>> filters for receiving different types of traffic.
>>
>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>> ---
>>   drivers/net/ethernet/sfc/ef100_vdpa.c     | 157 ++++++++++++++++++++++
>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |  36 ++++-
>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c |  17 ++-
>>   3 files changed, 207 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> index 4ba57827a6cd..5c9f29f881a6 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> @@ -16,12 +16,166 @@
>>   #include "mcdi_filters.h"
>>   #include "mcdi_functions.h"
>>   #include "ef100_netdev.h"
>> +#include "filter.h"
>> +#include "efx.h"
>>
>> +#define EFX_INVALID_FILTER_ID -1
>> +
>> +/* vDPA queues starts from 2nd VI or qid 1 */
>> +#define EF100_VDPA_BASE_RX_QID 1
>> +
>> +static const char * const filter_names[] = { "bcast", "ucast", "mcast" };
>>   static struct virtio_device_id ef100_vdpa_id_table[] = {
>>          { .device = VIRTIO_ID_NET, .vendor = PCI_VENDOR_ID_REDHAT_QUMRANET },
>>          { 0 },
>>   };
>>
>> +static int ef100_vdpa_set_mac_filter(struct efx_nic *efx,
>> +                                    struct efx_filter_spec *spec,
>> +                                    u32 qid, u8 *mac_addr)
>> +{
>> +       int rc;
>> +
>> +       efx_filter_init_rx(spec, EFX_FILTER_PRI_AUTO, 0, qid);
>> +
>> +       if (mac_addr) {
>> +               rc = efx_filter_set_eth_local(spec, EFX_FILTER_VID_UNSPEC,
>> +                                             mac_addr);
>> +               if (rc)
>> +                       pci_err(efx->pci_dev,
>> +                               "Filter set eth local failed, err: %d\n", rc);
>> +       } else {
>> +               efx_filter_set_mc_def(spec);
>> +       }
>> +
>> +       rc = efx_filter_insert_filter(efx, spec, true);
>> +       if (rc < 0)
>> +               pci_err(efx->pci_dev,
>> +                       "Filter insert failed, err: %d\n", rc);
>> +
>> +       return rc;
>> +}
>> +
>> +static int ef100_vdpa_delete_filter(struct ef100_vdpa_nic *vdpa_nic,
>> +                                   enum ef100_vdpa_mac_filter_type type)
>> +{
>> +       struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
>> +       int rc;
>> +
>> +       if (vdpa_nic->filters[type].filter_id == EFX_INVALID_FILTER_ID)
>> +               return rc;
>> +
>> +       rc = efx_filter_remove_id_safe(vdpa_nic->efx,
>> +                                      EFX_FILTER_PRI_AUTO,
>> +                                      vdpa_nic->filters[type].filter_id);
>> +       if (rc) {
>> +               dev_err(&vdev->dev, "%s filter id: %d remove failed, err: %d\n",
>> +                       filter_names[type], vdpa_nic->filters[type].filter_id,
>> +                       rc);
>> +       } else {
>> +               vdpa_nic->filters[type].filter_id = EFX_INVALID_FILTER_ID;
>> +               vdpa_nic->filter_cnt--;
>> +       }
>> +       return rc;
>> +}
>> +
>> +int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
>> +                         enum ef100_vdpa_mac_filter_type type)
>> +{
>> +       struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
>> +       struct efx_nic *efx = vdpa_nic->efx;
>> +       /* Configure filter on base Rx queue only */
>> +       u32 qid = EF100_VDPA_BASE_RX_QID;
>> +       struct efx_filter_spec *spec;
>> +       u8 baddr[ETH_ALEN];
>> +       int rc;
>> +
>> +       /* remove existing filter */
>> +       rc = ef100_vdpa_delete_filter(vdpa_nic, type);
>> +       if (rc < 0) {
>> +               dev_err(&vdev->dev, "%s MAC filter deletion failed, err: %d",
>> +                       filter_names[type], rc);
>> +               return rc;
>> +       }
>> +
>> +       /* Configure MAC Filter */
>> +       spec = &vdpa_nic->filters[type].spec;
>> +       if (type == EF100_VDPA_BCAST_MAC_FILTER) {
>> +               eth_broadcast_addr(baddr);
>> +               rc = ef100_vdpa_set_mac_filter(efx, spec, qid, baddr);
>> +       } else if (type == EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER) {
>> +               rc = ef100_vdpa_set_mac_filter(efx, spec, qid, NULL);
>> +       } else {
>> +               /* Ensure we have a valid mac address */
>> +               if (!vdpa_nic->mac_configured ||
>> +                   !is_valid_ether_addr(vdpa_nic->mac_address))
>> +                       return -EINVAL;
>> +
>> +               rc = ef100_vdpa_set_mac_filter(efx, spec, qid,
>> +                                              vdpa_nic->mac_address);
>> +       }
>> +
>> +       if (rc >= 0) {
>> +               vdpa_nic->filters[type].filter_id = rc;
>> +               vdpa_nic->filter_cnt++;
>> +
>> +               return 0;
>> +       }
>> +
>> +       dev_err(&vdev->dev, "%s MAC filter insert failed, err: %d\n",
>> +               filter_names[type], rc);
>> +
>> +       if (type != EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER) {
>> +               ef100_vdpa_filter_remove(vdpa_nic);
>> +               return rc;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +int ef100_vdpa_filter_remove(struct ef100_vdpa_nic *vdpa_nic)
>> +{
>> +       enum ef100_vdpa_mac_filter_type filter;
>> +       int err = 0;
>> +       int rc;
>> +
>> +       for (filter = EF100_VDPA_BCAST_MAC_FILTER;
>> +            filter <= EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER; filter++) {
>> +               rc = ef100_vdpa_delete_filter(vdpa_nic, filter);
>> +               if (rc < 0)
>> +                       /* store status of last failed filter remove */
>> +                       err = rc;
>> +       }
>> +       return err;
>> +}
>> +
>> +int ef100_vdpa_filter_configure(struct ef100_vdpa_nic *vdpa_nic)
>> +{
>> +       struct vdpa_device *vdev = &vdpa_nic->vdpa_dev;
>> +       enum ef100_vdpa_mac_filter_type filter;
>> +       int rc;
>> +
>> +       /* remove existing filters, if any */
>> +       rc = ef100_vdpa_filter_remove(vdpa_nic);
>> +       if (rc < 0) {
>> +               dev_err(&vdev->dev,
>> +                       "MAC filter deletion failed, err: %d", rc);
>> +               goto fail;
>> +       }
>> +
>> +       for (filter = EF100_VDPA_BCAST_MAC_FILTER;
>> +            filter <= EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER; filter++) {
>> +               if (filter == EF100_VDPA_UCAST_MAC_FILTER &&
>> +                   !vdpa_nic->mac_configured)
>> +                       continue;
> Nit: is this better to move this inside ef100_vdpa_add_filter()?
In fact, this check is already part of ef100_vdpa_add_filter() and is 
duplicated here. Will fix.
>
>> +               rc = ef100_vdpa_add_filter(vdpa_nic, filter);
>> +               if (rc < 0)
>> +                       goto fail;
>> +       }
>> +fail:
>> +       return rc;
>> +}
>> +
>>   int ef100_vdpa_init(struct efx_probe_data *probe_data)
>>   {
>>          struct efx_nic *efx = &probe_data->efx;
>> @@ -185,6 +339,9 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>                  goto err_put_device;
>>          }
>>
>> +       for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
>> +               vdpa_nic->filters[i].filter_id = EFX_INVALID_FILTER_ID;
>> +
>>          rc = get_net_config(vdpa_nic);
>>          if (rc)
>>                  goto err_put_device;
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> index 58791402e454..49fb6be04eb3 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> @@ -72,6 +72,22 @@ enum ef100_vdpa_vq_type {
>>          EF100_VDPA_VQ_NTYPES
>>   };
>>
>> +/**
>> + * enum ef100_vdpa_mac_filter_type - vdpa filter types
>> + *
>> + * @EF100_VDPA_BCAST_MAC_FILTER: Broadcast MAC filter
>> + * @EF100_VDPA_UCAST_MAC_FILTER: Unicast MAC filter
>> + * @EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER: Unknown multicast MAC filter to allow
>> + *     IPv6 Neighbor Solicitation Message
>> + * @EF100_VDPA_MAC_FILTER_NTYPES: Number of vDPA filter types
>> + */
>> +enum ef100_vdpa_mac_filter_type {
>> +       EF100_VDPA_BCAST_MAC_FILTER,
>> +       EF100_VDPA_UCAST_MAC_FILTER,
>> +       EF100_VDPA_UNKNOWN_MCAST_MAC_FILTER,
>> +       EF100_VDPA_MAC_FILTER_NTYPES,
>> +};
>> +
>>   /**
>>    * struct ef100_vdpa_vring_info - vDPA vring data structure
>>    *
>> @@ -107,6 +123,17 @@ struct ef100_vdpa_vring_info {
>>          struct vdpa_callback cb;
>>   };
>>
>> +/**
>> + * struct ef100_vdpa_filter - vDPA filter data structure
>> + *
>> + * @filter_id: filter id of this filter
>> + * @efx_filter_spec: hardware filter specs for this vdpa device
>> + */
>> +struct ef100_vdpa_filter {
>> +       s32 filter_id;
>> +       struct efx_filter_spec spec;
>> +};
>> +
>>   /**
>>    *  struct ef100_vdpa_nic - vDPA NIC data structure
>>    *
>> @@ -116,6 +143,7 @@ struct ef100_vdpa_vring_info {
>>    * @lock: Managing access to vdpa config operations
>>    * @pf_index: PF index of the vDPA VF
>>    * @vf_index: VF index of the vDPA VF
>> + * @filter_cnt: total number of filters created on this vdpa device
>>    * @status: device status as per VIRTIO spec
>>    * @features: negotiated feature bits
>>    * @max_queue_pairs: maximum number of queue pairs supported
>> @@ -123,6 +151,7 @@ struct ef100_vdpa_vring_info {
>>    * @vring: vring information of the vDPA device.
>>    * @mac_address: mac address of interface associated with this vdpa device
>>    * @mac_configured: true after MAC address is configured
>> + * @filters: details of all filters created on this vdpa device
>>    * @cfg_cb: callback for config change
>>    */
>>   struct ef100_vdpa_nic {
>> @@ -133,6 +162,7 @@ struct ef100_vdpa_nic {
>>          struct mutex lock;
>>          u32 pf_index;
>>          u32 vf_index;
>> +       u32 filter_cnt;
>>          u8 status;
>>          u64 features;
>>          u32 max_queue_pairs;
>> @@ -140,6 +170,7 @@ struct ef100_vdpa_nic {
>>          struct ef100_vdpa_vring_info vring[EF100_VDPA_MAX_QUEUES_PAIRS * 2];
>>          u8 *mac_address;
>>          bool mac_configured;
>> +       struct ef100_vdpa_filter filters[EF100_VDPA_MAC_FILTER_NTYPES];
>>          struct vdpa_callback cfg_cb;
>>   };
>>
>> @@ -147,7 +178,10 @@ int ef100_vdpa_init(struct efx_probe_data *probe_data);
>>   void ef100_vdpa_fini(struct efx_probe_data *probe_data);
>>   int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
>>   void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
>> -void ef100_vdpa_irq_vectors_free(void *data);
>> +int ef100_vdpa_filter_configure(struct ef100_vdpa_nic *vdpa_nic);
>> +int ef100_vdpa_filter_remove(struct ef100_vdpa_nic *vdpa_nic);
>> +int ef100_vdpa_add_filter(struct ef100_vdpa_nic *vdpa_nic,
>> +                         enum ef100_vdpa_mac_filter_type type);
>>   int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
>>   void ef100_vdpa_irq_vectors_free(void *data);
>>   int ef100_vdpa_reset(struct vdpa_device *vdev);
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> index 95a2177f85a2..db86c2693950 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> @@ -261,6 +261,7 @@ static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>          vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>>          vdpa_nic->status = 0;
>>          vdpa_nic->features = 0;
>> +       ef100_vdpa_filter_remove(vdpa_nic);
>>          for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
>>                  reset_vring(vdpa_nic, i);
>>          ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
>> @@ -295,7 +296,7 @@ static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>          rc = ef100_vdpa_irq_vectors_alloc(efx->pci_dev,
>>                                            vdpa_nic->max_queue_pairs * 2);
>>          if (rc < 0) {
>> -               pci_err(efx->pci_dev,
>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
> This should be done in the previous patch.
Right. Will fix.
>
> Thanks
>
>
>>                          "vDPA IRQ alloc failed for vf: %u err:%d\n",
>>                          nic_data->vf_index, rc);
>>                  return rc;
>> @@ -309,9 +310,19 @@ static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>                  }
>>          }
>>
>> +       rc = ef100_vdpa_filter_configure(vdpa_nic);
>> +       if (rc < 0) {
>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                       "%s: vdpa configure filter failed, err: %d\n",
>> +                       __func__, rc);
>> +               goto err_filter_configure;
>> +       }
>> +
>>          vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
>>          return 0;
>>
>> +err_filter_configure:
>> +       ef100_vdpa_filter_remove(vdpa_nic);
>>   clear_vring:
>>          for (j = 0; j < i; j++)
>>                  delete_vring(vdpa_nic, j);
>> @@ -680,8 +691,10 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
>>          }
>>
>>          memcpy((u8 *)&vdpa_nic->net_config + offset, buf, len);
>> -       if (is_valid_ether_addr(vdpa_nic->mac_address))
>> +       if (is_valid_ether_addr(vdpa_nic->mac_address)) {
>>                  vdpa_nic->mac_configured = true;
>> +               ef100_vdpa_add_filter(vdpa_nic, EF100_VDPA_UCAST_MAC_FILTER);
>> +       }
>>   }
>>
>>   static int ef100_vdpa_suspend(struct vdpa_device *vdev)
>> --
>> 2.30.1
>>
