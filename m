Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878CA6B7735
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 13:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjCMMLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 08:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbjCMMK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 08:10:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1F453D94;
        Mon, 13 Mar 2023 05:10:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPYWl1mmGg9O3iNbjYSxTQnt+VNmS4Tmv6PsvfZFAEGNKZku2x6awcSXM8tcB+5hmE2ZmlXqCYFDINlfaRf295zSLThLGEgfxepoZHYPkEr3bD/IZl9Weob73yAVu0S5s7vwVdVZTRDjBYXCgygTPWyOoCyYFdMU8VJPkTuP/bL7j2vODhDvECYRFWlbt06TswaQjhsrvzAXgI4prDr/Hl2oZD1zCjfvRL1z6lhbxs9N0FWKYW/iB+IZ2RCjGTt89D/uuYnneEQFTWA9y7uS1v50MDB71ZFw3CVcE+NdMTe0J9aLWPiasNKdWw38K4++Q/FNz/TxIAM9Nflk07+MNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ja08yMmklfxsW7lTaup33U9NHL3KYPyYjLX7527gNU=;
 b=hQhGQdDGFC/XeqQMQeoUV1xiDmK5jC9bZVS3RP1/seHEwGaguBr1m92q/4RyHnBZP0GNP9sbTXWND+E/UhWzbWuVpqn3FlPnMEnWd9B9oI9T91ec+2Dqlxm4kkZqRGTpmTx54C8vmXnwHal+puU4c5vFJz5fvHzp+MKJxGoIFO99b9SUGiKp7mgS6bngHLjLNSYjGLpdMMPKFIfXmhAIPMvgOD27ZIK+wYW46rV/kSjnt4hF21QdA1eo17AE5ylrFxbcxnJpvdMzkp2qeXObatX1W2xHqD0JsSm00d4t7li3/ujkASECKzhHSa+0LS5C79sPltF54UeskTMp31BRJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ja08yMmklfxsW7lTaup33U9NHL3KYPyYjLX7527gNU=;
 b=tKoPhexfj0YUIKe24q5OphUWepcNpkOkuoR3xTrONTcMlUBivHb8Wb7W6ZsqYrRNTPzF8LcMyAcLrfaZgcgAat25pveZR+N30R+xRsdFqBfIE7HZlwqTh5xXdtPvO2McTJoCufN+0iM0iOkC6odNbXHDRREGldjO/8ePu1b0sB0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by DM6PR12MB4926.namprd12.prod.outlook.com (2603:10b6:5:1bb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 12:10:52 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 12:10:51 +0000
Message-ID: <3a3b63f5-66a9-47aa-ba0d-3bb99c928a60@amd.com>
Date:   Mon, 13 Mar 2023 17:40:33 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 09/14] sfc: implement device status related
 vdpa config operations
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
 <20230307113621.64153-10-gautam.dawar@amd.com>
 <CACGkMEvpK4P1TTAO2bZ+YMXuNFMk_hJHQBPszCwOTzbQX70s7w@mail.gmail.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <CACGkMEvpK4P1TTAO2bZ+YMXuNFMk_hJHQBPszCwOTzbQX70s7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0023.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::13) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|DM6PR12MB4926:EE_
X-MS-Office365-Filtering-Correlation-Id: ef60cae6-d3e1-4e78-8e48-08db23bbfce4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n6elI+TmiZvWmII4nxt/tHjExrA06Jd25eaLqPpg1MjDbU8O7ch6lZbycjRR3BuwOykUkyWSHzcODDH34DnVuqFNH+G0DkcPiURn1VEXaNlEoj11lQFwApbBOWvJW4WxXPvxHJhvZcIe1ZByzxgzRVX/b/ccFDrZU6A0NoCIAvN3RXmwQxG5avzePnZspzJuX6CoyfXB5qe74KpULJDC35SPyYdrwL7k8YXzMLUYxQGu2CWR/0YzkDDz04XMLg67BotGpsYSIGzviydifkiKLD8uLEBkL3zSrZWnfYJJVtYQ+nBtCk84W9yhnKrOCc443IZhJ+3oJ+U1br9JHkewkan7qIUkaKQZlngyRm3oTRJ1IMTByjpW6Z4z5lY66H6K99K/lsxmaiHlBbH6j21t1P7k7anveo6m9s40HGzH3nbnwt9APbUqAYydhdEF1YN/Ky2vVNAGOygNg+YpB/xNeMgDcx5+0Hme84yv5OwaTgYbJ1UOHTl/jMnrunEUIozQwCBDiqlZsSJvJz5Q27p7dOh0tsueo96GrY67ZHCrmPo7NaMTzq0qw8ZrDlU+56w2W8HgPI8jkZV8r024xmxScJ0H5MPn9nwHQycyPUHYNSFl3MiSbkVNM2VHTl8iJpE1Qf7DCJ0EuKvAA6e/jyjlKmwXhpfbhSnR5JjvqsV/2hfMjIUc2XBMq/4TFqSNGsVybW8zCCNa3ms1xeje8dPwLQbBhcJxn9+MrkGImw/MF9o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199018)(36756003)(5660300002)(7416002)(30864003)(83380400001)(478600001)(6666004)(6506007)(26005)(6512007)(966005)(6486002)(2616005)(53546011)(186003)(66476007)(4326008)(54906003)(6636002)(66946007)(8936002)(66556008)(41300700001)(8676002)(31696002)(316002)(110136005)(38100700002)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2NZR0NjWlpXTGY3YnZ4NmdjUUhMb2pBRVJ4eUw0NkJsMTRIZXFyWU1nWEZt?=
 =?utf-8?B?aFVvSDRWczNvbzZxZU1MSkNPMkZ0V0FFWUh5eXl2blBDRlhPRGRtZU5oc242?=
 =?utf-8?B?SXVVZ1ZpWVc1cTdINHBic1lMOUoyNFNRRmNCcGtpQnlZYW1MU1ptNWRxQUpC?=
 =?utf-8?B?L1NrWVBacHZkTmJEemUrRWdFZjZ0NUw3Mm9pcS9JYktoUkllQTZ2UG1CTE10?=
 =?utf-8?B?RVBoYWZmeVptTUd2WUlMa3hNUkdlU2FVb0FLdjdaVnFBRjY5NlBITGpjbkpU?=
 =?utf-8?B?QXJxbS9GNDJxbWM0Y3BzZFdJL2pTd0hDRit5Qy9ycnZkc2Y2SXZGU2s5WTlE?=
 =?utf-8?B?YWJYME1MMzhqcWtWQ3Z4MkU1SXEyZ3Q5Y01RK0hwemlHajFtSlJUVDd3ckg4?=
 =?utf-8?B?UENsdEU3amoyMUZqMDdJTWd4M3hPQ0VpNVlOVStyV2J0K1lQS1ZPbVF0S0Zk?=
 =?utf-8?B?N1VHeHpkK2ZobHlDYTVLNExyaG9xaUN2clZzdEhjYnc1WndUZ1FKSGE2OFlV?=
 =?utf-8?B?MkE3L1RMRGRVTUhDRGNJVWRoeU8rSFlwSjcxOVRtVGdoUDFWQ1JlWXJzT0NI?=
 =?utf-8?B?WkF0NnJxUnhWZGlLQURJWi9DeFp1Z3E3c3NGeG9mZFJ1QnZ5TkFJRHBXUVV6?=
 =?utf-8?B?dGdESUpkSVhtM2FnLzFMSU9tZnpGMzRTSWg0Tk5KZDdFUEVjQ3MyK25oK0dU?=
 =?utf-8?B?MlRjUjNhc01LUERMcnN0Tk93d3JXSEo1V1FrcGZQVnh3Sko0ZE96anhBU0Y1?=
 =?utf-8?B?c1BjYXFrRzJUTW9sdGx3VU00RmpScW14cnZ5N3kyemMzQVRwd3ArQXRCOTd0?=
 =?utf-8?B?dk8wdVhBcTZQUElDS0w0Z2RKbDJ4RzhMR25PbXJjalJEMUo4QW9QRDFzb1I0?=
 =?utf-8?B?RTMvV2lOR3dzUVBMcUcxYk13MnFWOHd5UXlqdnNrY0FLbzMyNUlRYmc1YVFT?=
 =?utf-8?B?RWRjWGg2OFFveGpEeVBwaXhUanAyZVZsUnc5STNncmFrNkVYakFjNE5zNTdW?=
 =?utf-8?B?Yk5zZnJpRnkvRWNqZVR2bnF3OVFROXZIbmZyU3FuM0JxdjZJT29kMG5lZ2po?=
 =?utf-8?B?NitDN2xBbS9lUTVmOW1aR1BTd0lKWWUxUG14QWRIMUVZWlVXTFpCNktxWkJY?=
 =?utf-8?B?MWNvYjBaMUhTY1B6NGNyMjdVT2ZkTmxQMXk0Wk5yZG5MaDBLS2lHTnN2YUVv?=
 =?utf-8?B?R011VTJWS29CWlVpOEMyUk5JcmVIRUJsVDZ2ZUxCMU1QY2s1eklpZ0J3YnpB?=
 =?utf-8?B?eUhhQzQ4WklwbUFxenNtcEdURmNDa3Z4Mno3R2pSOUNlQkh0RlFON2lUUFI3?=
 =?utf-8?B?c2xhQ21mZUVtZ3NmTVQ5YTVnU2d1YjBCejQyM3g0RUYwam1FRGZZenRzSnNa?=
 =?utf-8?B?dFNJS3U5SVBnM0c3VTJQNERTcTNiZnQxZ2lmZy9lc1MzU3c5eU56RnRqKzZI?=
 =?utf-8?B?amlNRXdybUhVOENHY1MrY1o5cGk1Y1dDVjZIZXpjb1BRRXltRG1aOE1KemFu?=
 =?utf-8?B?V2VkUGdESi9pWWtnUXVvSENYYjEwVGwrQVRkczhnWWhBN3NSckNJdnhuVWRq?=
 =?utf-8?B?Mm1wSTlxUUtBRmxlOVVpWFMvSWdxcGZyMXlIaWg4ZVdqTnQ4K3ppUzFCQ2s0?=
 =?utf-8?B?TUFwNStNbTFJdmFURVlFU2tCc1R0cXphcWNXdDF5djR5STBsK1hnSnBxczNn?=
 =?utf-8?B?ZmpNR29Oa3U3bmdtMkdiM0IyckgrclZNbysxSmJHSlNjelJkSTJ0K3Qxcjhx?=
 =?utf-8?B?eHFUYkxHOFVHNTBRc2VqRFVKZndJTWdpQ3hQaHdnaVdTNlBjQytadkRmRWgx?=
 =?utf-8?B?Qm16U3lPQVo3enhlSzlwcWYzZXhOTGJaYzNDTkRETTlPbmt0WitUb2FZOWZ6?=
 =?utf-8?B?Y2wyaENRWXFxdjFON1Nqd0tiTGF0cDEzQWdha3NIbWw0aHEzZ2RjR3VJNWlO?=
 =?utf-8?B?UmNqTVNET0RmdU1VT09RTFIreVNGT0VheUpDMU1PMlNzRUxwUU9ReE9qZ01m?=
 =?utf-8?B?Z2VaalVNWEVjVVVONklURXEvbFRDRzlFWWwyazArdmJWb2lRWWpVQnE4YzIz?=
 =?utf-8?B?Y1hrdHNEVWhwR0V2K3Y5dzMweHUrZXdYbHNsRnlnc1FyL2VZaHpFWnhRTEdD?=
 =?utf-8?Q?UA1soCzPxsjJmTnPNfa7StNpW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef60cae6-d3e1-4e78-8e48-08db23bbfce4
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 12:10:51.7843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CFmDMSsGPks6yzC5Sl5f3z70ezNa8v+cn8C7LjLiy3oF/uSen0YMAPj3BqZgQrLi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4926
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
>> vDPA config opertions to handle get/set device status and device
>> reset have been implemented. Also .suspend config operation is
>> implemented to support Live Migration.
>>
>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>> ---
>>   drivers/net/ethernet/sfc/ef100_vdpa.c     |  16 +-
>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |   2 +
>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 367 ++++++++++++++++++++--
>>   3 files changed, 355 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> index c66e5aef69ea..4ba57827a6cd 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>> @@ -68,9 +68,14 @@ static int vdpa_allocate_vis(struct efx_nic *efx, unsigned int *allocated_vis)
>>
>>   static void ef100_vdpa_delete(struct efx_nic *efx)
>>   {
>> +       struct vdpa_device *vdpa_dev;
>> +
>>          if (efx->vdpa_nic) {
>> +               vdpa_dev = &efx->vdpa_nic->vdpa_dev;
>> +               ef100_vdpa_reset(vdpa_dev);
>> +
>>                  /* replace with _vdpa_unregister_device later */
>> -               put_device(&efx->vdpa_nic->vdpa_dev.dev);
>> +               put_device(&vdpa_dev->dev);
>>          }
>>          efx_mcdi_free_vis(efx);
>>   }
>> @@ -171,6 +176,15 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
>>                  }
>>          }
>>
>> +       rc = devm_add_action_or_reset(&efx->pci_dev->dev,
>> +                                     ef100_vdpa_irq_vectors_free,
>> +                                     efx->pci_dev);
>> +       if (rc) {
>> +               pci_err(efx->pci_dev,
>> +                       "Failed adding devres for freeing irq vectors\n");
>> +               goto err_put_device;
>> +       }
>> +
>>          rc = get_net_config(vdpa_nic);
>>          if (rc)
>>                  goto err_put_device;
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> index 348ca8a7404b..58791402e454 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>> @@ -149,6 +149,8 @@ int ef100_vdpa_register_mgmtdev(struct efx_nic *efx);
>>   void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
>>   void ef100_vdpa_irq_vectors_free(void *data);
>>   int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
>> +void ef100_vdpa_irq_vectors_free(void *data);
>> +int ef100_vdpa_reset(struct vdpa_device *vdev);
>>
>>   static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic *vdpa_nic)
>>   {
>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> index 0051c4c0e47c..95a2177f85a2 100644
>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>> @@ -22,11 +22,6 @@ static struct ef100_vdpa_nic *get_vdpa_nic(struct vdpa_device *vdev)
>>          return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>>   }
>>
>> -void ef100_vdpa_irq_vectors_free(void *data)
>> -{
>> -       pci_free_irq_vectors(data);
>> -}
>> -
>>   static int create_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>   {
>>          struct efx_vring_ctx *vring_ctx;
>> @@ -52,14 +47,6 @@ static void delete_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>          vdpa_nic->vring[idx].vring_ctx = NULL;
>>   }
>>
>> -static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> -{
>> -       vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
>> -       vdpa_nic->vring[idx].vring_state = 0;
>> -       vdpa_nic->vring[idx].last_avail_idx = 0;
>> -       vdpa_nic->vring[idx].last_used_idx = 0;
>> -}
>> -
>>   int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>   {
>>          u32 offset;
>> @@ -103,6 +90,236 @@ static bool is_qid_invalid(struct ef100_vdpa_nic *vdpa_nic, u16 idx,
>>          return false;
>>   }
>>
>> +static void irq_vring_fini(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +       struct ef100_vdpa_vring_info *vring = &vdpa_nic->vring[idx];
>> +       struct pci_dev *pci_dev = vdpa_nic->efx->pci_dev;
>> +
>> +       devm_free_irq(&pci_dev->dev, vring->irq, vring);
>> +       vring->irq = -EINVAL;
>> +}
>> +
>> +static irqreturn_t vring_intr_handler(int irq, void *arg)
>> +{
>> +       struct ef100_vdpa_vring_info *vring = arg;
>> +
>> +       if (vring->cb.callback)
>> +               return vring->cb.callback(vring->cb.private);
>> +
>> +       return IRQ_NONE;
>> +}
>> +
>> +static int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev, u16 nvqs)
>> +{
>> +       int rc;
>> +
>> +       rc = pci_alloc_irq_vectors(pci_dev, nvqs, nvqs, PCI_IRQ_MSIX);
>> +       if (rc < 0)
>> +               pci_err(pci_dev,
>> +                       "Failed to alloc %d IRQ vectors, err:%d\n", nvqs, rc);
>> +       return rc;
>> +}
>> +
>> +void ef100_vdpa_irq_vectors_free(void *data)
>> +{
>> +       pci_free_irq_vectors(data);
>> +}
>> +
>> +static int irq_vring_init(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +       struct ef100_vdpa_vring_info *vring = &vdpa_nic->vring[idx];
>> +       struct pci_dev *pci_dev = vdpa_nic->efx->pci_dev;
>> +       int irq;
>> +       int rc;
>> +
>> +       snprintf(vring->msix_name, 256, "x_vdpa[%s]-%d\n",
>> +                pci_name(pci_dev), idx);
>> +       irq = pci_irq_vector(pci_dev, idx);
>> +       rc = devm_request_irq(&pci_dev->dev, irq, vring_intr_handler, 0,
>> +                             vring->msix_name, vring);
>> +       if (rc)
>> +               pci_err(pci_dev,
>> +                       "devm_request_irq failed for vring %d, rc %d\n",
>> +                       idx, rc);
>> +       else
>> +               vring->irq = irq;
>> +
>> +       return rc;
>> +}
>> +
>> +static int delete_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +       struct efx_vring_dyn_cfg vring_dyn_cfg;
>> +       int rc;
>> +
>> +       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>> +               return 0;
>> +
>> +       rc = efx_vdpa_vring_destroy(vdpa_nic->vring[idx].vring_ctx,
>> +                                   &vring_dyn_cfg);
>> +       if (rc)
>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                       "%s: delete vring failed index:%u, err:%d\n",
>> +                       __func__, idx, rc);
>> +       vdpa_nic->vring[idx].last_avail_idx = vring_dyn_cfg.avail_idx;
>> +       vdpa_nic->vring[idx].last_used_idx = vring_dyn_cfg.used_idx;
>> +       vdpa_nic->vring[idx].vring_state &= ~EF100_VRING_CREATED;
>> +
>> +       irq_vring_fini(vdpa_nic, idx);
>> +
>> +       return rc;
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
>> +
>> +       idx_val = idx;
>> +       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
>> +                   vdpa_nic->vring[idx].doorbell_offset);
>> +}
>> +
>> +static bool can_create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +       if (vdpa_nic->vring[idx].vring_state == EF100_VRING_CONFIGURED &&
>> +           vdpa_nic->status & VIRTIO_CONFIG_S_DRIVER_OK &&
>> +           !(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>> +               return true;
>> +
>> +       return false;
>> +}
>> +
>> +static int create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +       struct efx_vring_dyn_cfg vring_dyn_cfg;
>> +       struct efx_vring_cfg vring_cfg;
>> +       int rc;
>> +
>> +       rc = irq_vring_init(vdpa_nic, idx);
>> +       if (rc) {
>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                       "%s: irq_vring_init failed. index:%u, err:%d\n",
>> +                       __func__, idx, rc);
>> +               return rc;
>> +       }
>> +       vring_cfg.desc = vdpa_nic->vring[idx].desc;
>> +       vring_cfg.avail = vdpa_nic->vring[idx].avail;
>> +       vring_cfg.used = vdpa_nic->vring[idx].used;
>> +       vring_cfg.size = vdpa_nic->vring[idx].size;
>> +       vring_cfg.features = vdpa_nic->features;
>> +       vring_cfg.msix_vector = idx;
>> +       vring_dyn_cfg.avail_idx = vdpa_nic->vring[idx].last_avail_idx;
>> +       vring_dyn_cfg.used_idx = vdpa_nic->vring[idx].last_used_idx;
>> +
>> +       rc = efx_vdpa_vring_create(vdpa_nic->vring[idx].vring_ctx,
>> +                                  &vring_cfg, &vring_dyn_cfg);
>> +       if (rc) {
>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                       "%s: vring_create failed index:%u, err:%d\n",
>> +                       __func__, idx, rc);
>> +               goto err_vring_create;
>> +       }
>> +       vdpa_nic->vring[idx].vring_state |= EF100_VRING_CREATED;
>> +
>> +       /* A VQ kick allows the device to read the avail_idx, which will be
>> +        * required at the destination after live migration.
>> +        */
>> +       ef100_vdpa_kick_vq(&vdpa_nic->vdpa_dev, idx);
>> +
>> +       return 0;
>> +
>> +err_vring_create:
>> +       irq_vring_fini(vdpa_nic, idx);
>> +       return rc;
>> +}
>> +
>> +static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>> +{
>> +       delete_vring(vdpa_nic, idx);
>> +       vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
>> +       vdpa_nic->vring[idx].vring_state = 0;
>> +       vdpa_nic->vring[idx].last_avail_idx = 0;
>> +       vdpa_nic->vring[idx].last_used_idx = 0;
>> +}
>> +
>> +static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>> +{
>> +       int i;
>> +
>> +       WARN_ON(!mutex_is_locked(&vdpa_nic->lock));
>> +
>> +       if (!vdpa_nic->status)
>> +               return;
>> +
>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>> +       vdpa_nic->status = 0;
>> +       vdpa_nic->features = 0;
>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
>> +               reset_vring(vdpa_nic, i);
>> +       ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
>> +}
>> +
>> +/* May be called under the rtnl lock */
>> +int ef100_vdpa_reset(struct vdpa_device *vdev)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +
>> +       /* vdpa device can be deleted anytime but the bar_config
>> +        * could still be vdpa and hence efx->state would be STATE_VDPA.
>> +        * Accordingly, ensure vdpa device exists before reset handling
>> +        */
>> +       if (!vdpa_nic)
>> +               return -ENODEV;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       ef100_reset_vdpa_device(vdpa_nic);
>> +       mutex_unlock(&vdpa_nic->lock);
>> +       return 0;
>> +}
>> +
>> +static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>> +{
>> +       struct efx_nic *efx = vdpa_nic->efx;
>> +       struct ef100_nic_data *nic_data;
>> +       int i, j;
>> +       int rc;
>> +
>> +       nic_data = efx->nic_data;
>> +       rc = ef100_vdpa_irq_vectors_alloc(efx->pci_dev,
>> +                                         vdpa_nic->max_queue_pairs * 2);
>> +       if (rc < 0) {
>> +               pci_err(efx->pci_dev,
>> +                       "vDPA IRQ alloc failed for vf: %u err:%d\n",
>> +                       nic_data->vf_index, rc);
>> +               return rc;
>> +       }
>> +
>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>> +               if (can_create_vring(vdpa_nic, i)) {
>> +                       rc = create_vring(vdpa_nic, i);
>> +                       if (rc)
>> +                               goto clear_vring;
>> +               }
>> +       }
>> +
>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
> It looks to me that this duplicates with the DRIVER_OK status bit.
vdpa_state is set EF100_VDPA_STATE_STARTED during DRIVER_OK handling. 
See my later response for its purpose.
>
>> +       return 0;
>> +
>> +clear_vring:
>> +       for (j = 0; j < i; j++)
>> +               delete_vring(vdpa_nic, j);
>> +
>> +       ef100_vdpa_irq_vectors_free(efx->pci_dev);
>> +       return rc;
>> +}
>> +
>>   static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
>>                                       u16 idx, u64 desc_area, u64 driver_area,
>>                                       u64 device_area)
>> @@ -144,22 +361,6 @@ static void ef100_vdpa_set_vq_num(struct vdpa_device *vdev, u16 idx, u32 num)
>>          mutex_unlock(&vdpa_nic->lock);
>>   }
>>
>> -static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
>> -{
>> -       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> -       u32 idx_val;
>> -
>> -       if (is_qid_invalid(vdpa_nic, idx, __func__))
>> -               return;
>> -
>> -       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>> -               return;
>> -
>> -       idx_val = idx;
>> -       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
>> -                   vdpa_nic->vring[idx].doorbell_offset);
>> -}
>> -
>>   static void ef100_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx,
>>                                   struct vdpa_callback *cb)
>>   {
>> @@ -176,6 +377,7 @@ static void ef100_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 idx,
>>                                      bool ready)
>>   {
>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       int rc;
>>
>>          if (is_qid_invalid(vdpa_nic, idx, __func__))
>>                  return;
>> @@ -184,9 +386,21 @@ static void ef100_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 idx,
>>          if (ready) {
>>                  vdpa_nic->vring[idx].vring_state |=
>>                                          EF100_VRING_READY_CONFIGURED;
>> +               if (vdpa_nic->vdpa_state == EF100_VDPA_STATE_STARTED &&
>> +                   can_create_vring(vdpa_nic, idx)) {
>> +                       rc = create_vring(vdpa_nic, idx);
>> +                       if (rc)
>> +                               /* Rollback ready configuration
>> +                                * So that the above layer driver
>> +                                * can make another attempt to set ready
>> +                                */
>> +                               vdpa_nic->vring[idx].vring_state &=
>> +                                       ~EF100_VRING_READY_CONFIGURED;
>> +               }
>>          } else {
>>                  vdpa_nic->vring[idx].vring_state &=
>>                                          ~EF100_VRING_READY_CONFIGURED;
>> +               delete_vring(vdpa_nic, idx);
>>          }
>>          mutex_unlock(&vdpa_nic->lock);
>>   }
>> @@ -296,6 +510,12 @@ static u64 ef100_vdpa_get_device_features(struct vdpa_device *vdev)
>>          }
>>
>>          features |= BIT_ULL(VIRTIO_NET_F_MAC);
>> +       /* As QEMU SVQ doesn't implement the following features,
>> +        * masking them off to allow Live Migration
>> +        */
>> +       features &= ~BIT_ULL(VIRTIO_F_IN_ORDER);
>> +       features &= ~BIT_ULL(VIRTIO_F_ORDER_PLATFORM);
> It's better not to work around userspace bugs in the kernel. We should
> fix Qemu instead.

There's already a QEMU patch [1] submitted to support 
VIRTIO_F_ORDER_PLATFORM but it hasn't concluded yet. Also, there is no 
support for VIRTIO_F_IN_ORDER in the kernel virtio driver. The motive of 
this change is to have VM Live Migration working with the kernel in-tree 
driver without requiring any changes.

Once QEMU is able to handle these features, we can submit a patch to 
undo these changes.

>
>> +
>>          return features;
>>   }
>>
>> @@ -356,6 +576,77 @@ static u32 ef100_vdpa_get_vendor_id(struct vdpa_device *vdev)
>>          return EF100_VDPA_VENDOR_ID;
>>   }
>>
>> +static u8 ef100_vdpa_get_status(struct vdpa_device *vdev)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       u8 status;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       status = vdpa_nic->status;
>> +       mutex_unlock(&vdpa_nic->lock);
>> +       return status;
>> +}
>> +
>> +static void ef100_vdpa_set_status(struct vdpa_device *vdev, u8 status)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       u8 new_status;
>> +       int rc;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       if (!status) {
>> +               dev_info(&vdev->dev,
>> +                        "%s: Status received is 0. Device reset being done\n",
>> +                        __func__);
> This is trigger-able by the userspace. It might be better to use
> dev_dbg() instead.
Will change.
>
>> +               ef100_reset_vdpa_device(vdpa_nic);
>> +               goto unlock_return;
>> +       }
>> +       new_status = status & ~vdpa_nic->status;
>> +       if (new_status == 0) {
>> +               dev_info(&vdev->dev,
>> +                        "%s: New status same as current status\n", __func__);
> Same here.
Ok.
>
>> +               goto unlock_return;
>> +       }
>> +       if (new_status & VIRTIO_CONFIG_S_FAILED) {
>> +               ef100_reset_vdpa_device(vdpa_nic);
>> +               goto unlock_return;
>> +       }
>> +
>> +       if (new_status & VIRTIO_CONFIG_S_ACKNOWLEDGE) {
>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
>> +               new_status &= ~VIRTIO_CONFIG_S_ACKNOWLEDGE;
>> +       }
>> +       if (new_status & VIRTIO_CONFIG_S_DRIVER) {
>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER;
>> +               new_status &= ~VIRTIO_CONFIG_S_DRIVER;
>> +       }
>> +       if (new_status & VIRTIO_CONFIG_S_FEATURES_OK) {
>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_FEATURES_OK;
>> +               vdpa_nic->vdpa_state = EF100_VDPA_STATE_NEGOTIATED;
> It might be better to explain the reason we need to track another
> state in vdpa_state instead of simply using the device status.
vdpa_state helps to ensure correct status transitions in the .set_status 
callback and safe-guards against incorrect/malicious user-space driver.
>
>> +               new_status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
>> +       }
>> +       if (new_status & VIRTIO_CONFIG_S_DRIVER_OK &&
>> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_NEGOTIATED) {
>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER_OK;
>> +               rc = start_vdpa_device(vdpa_nic);
>> +               if (rc) {
>> +                       dev_err(&vdpa_nic->vdpa_dev.dev,
>> +                               "%s: vDPA device failed:%d\n", __func__, rc);
>> +                       vdpa_nic->status &= ~VIRTIO_CONFIG_S_DRIVER_OK;
>> +                       goto unlock_return;
>> +               }
>> +               new_status &= ~VIRTIO_CONFIG_S_DRIVER_OK;
>> +       }
>> +       if (new_status) {
>> +               dev_warn(&vdev->dev,
>> +                        "%s: Mismatch Status: %x & State: %u\n",
>> +                        __func__, new_status, vdpa_nic->vdpa_state);
>> +       }
>> +
>> +unlock_return:
>> +       mutex_unlock(&vdpa_nic->lock);
>> +}
>> +
>>   static size_t ef100_vdpa_get_config_size(struct vdpa_device *vdev)
>>   {
>>          return sizeof(struct virtio_net_config);
>> @@ -393,6 +684,20 @@ static void ef100_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset,
>>                  vdpa_nic->mac_configured = true;
>>   }
>>
>> +static int ef100_vdpa_suspend(struct vdpa_device *vdev)
>> +{
>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> +       int i, rc;
>> +
>> +       mutex_lock(&vdpa_nic->lock);
>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>> +               rc = delete_vring(vdpa_nic, i);
> Note that the suspension matters for the whole device. It means the
> config space should not be changed. But the code here only suspends
> the vring, is this intende/d?
Are you referring to the possibility of updating device configuration 
(eg. MAC address) using .set_config() after suspend operation? Is there 
any other user triggered operation that falls in this category?
>
> Reset may have the same issue.
Could you pls elaborate on the requirement during device reset?
>
> Thanks
[1] https://patchew.org/QEMU/20230213191929.1547497-1-eperezma@redhat.com/
>
>> +               if (rc)
>> +                       break;
>> +       }
>> +       mutex_unlock(&vdpa_nic->lock);
>> +       return rc;
>> +}
>>   static void ef100_vdpa_free(struct vdpa_device *vdev)
>>   {
>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>> @@ -428,9 +733,13 @@ const struct vdpa_config_ops ef100_vdpa_config_ops = {
>>          .get_vq_num_max      = ef100_vdpa_get_vq_num_max,
>>          .get_device_id       = ef100_vdpa_get_device_id,
>>          .get_vendor_id       = ef100_vdpa_get_vendor_id,
>> +       .get_status          = ef100_vdpa_get_status,
>> +       .set_status          = ef100_vdpa_set_status,
>> +       .reset               = ef100_vdpa_reset,
>>          .get_config_size     = ef100_vdpa_get_config_size,
>>          .get_config          = ef100_vdpa_get_config,
>>          .set_config          = ef100_vdpa_set_config,
>>          .get_generation      = NULL,
>> +       .suspend             = ef100_vdpa_suspend,
>>          .free                = ef100_vdpa_free,
>>   };
>> --
>> 2.30.1
>>
