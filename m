Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D746BE77A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 12:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCQLBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 07:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjCQLBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 07:01:42 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4C2497C3;
        Fri, 17 Mar 2023 04:01:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBuPInDccu1Lh2n/aTyfwSmXH1oe4BQSs5I2q9dBD2tfmoYiUsZjMOttMtHEr8ff46VSrgNVQEBD8qBET0UkrJgHskecwRyjFeHRoHFVDh/Gd28uR7hHAjRkNqS1x7YicWyDYQPGvU6E51F/t+4L9HKPCPbCddxS6/h4REFweK6wqyzISikfE8cW9lM+XFI+r6PaSs8jn4MncTrvdWkOBQwYs/XYK5G9aSM0P+CJB9DF3KMHHtpNBz1XfpWjQFE2RfanhlXVP0gR+EjocF1wu63jIn+7p4k+QRsvRRuinwsUdbpchJJ1WO3INfJea5TkZdYAo/Rr7xSQE0e0ZQziDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fNCgT4MgkI4vVNDOJOou0/+JljCUE6E7L/3rZEVkuEE=;
 b=IKyr7RAuikRnKLu5pmJUk4b+8cr4KBaTu9cBhjEPLc4KOQ9JfY3Wj8FmizwplRFPti5Y6dJLym3zGscn/2q3gel7AcTyrwEoSCTLLadcj9vk4+30Q7A4WB7NQqiMjKgqgmtcEIhExzBDnhTOhLDoyrWZn4RzvucVz7AMSC1cpHKGOlNip4QPeoZBHKt/c9eX8x2o9DzryW5YXW/olMeoNjCbiHvkSFf9gVLv7lyL4MRvLay5Tw+hcFTkIWPnPImjzfvNcemTj5veFG7z84jcEeyK3Omygba267rnMuUFQlZmeUUF34wvGT6ElUfFw6NxSndp18R2Iz3ueAAyGzSniA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNCgT4MgkI4vVNDOJOou0/+JljCUE6E7L/3rZEVkuEE=;
 b=ZZsuHHUABzb9iRsn4g+Hr7Vj3pd0bC7iyCpwUujGn/ITpTw6whiGPJZp52C76eZx9rDwwxV03xf8LKS5wQbmvf0AVm2LjkH2e/RDTwdHhGLj3e6j6nOxIGHLT0kl6KAd6QBzTy4XHIhoBCnb6VRQIkQWUlYaNkn2xAmpoiuBIrs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by SA1PR12MB5637.namprd12.prod.outlook.com (2603:10b6:806:228::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Fri, 17 Mar
 2023 11:01:34 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Fri, 17 Mar 2023
 11:01:34 +0000
Message-ID: <31db518a-b475-8311-7328-cb4cc073c2bb@amd.com>
Date:   Fri, 17 Mar 2023 16:31:13 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 09/14] sfc: implement device status related
 vdpa config operations
Content-Language: en-US
From:   Gautam Dawar <gdawar@amd.com>
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
 <3a3b63f5-66a9-47aa-ba0d-3bb99c928a60@amd.com>
 <a6562f42-7bb1-0e0d-3990-7d5962efe6b9@redhat.com>
 <6c05c616-502e-fa07-b8e8-6f733b1c2e2e@amd.com>
In-Reply-To: <6c05c616-502e-fa07-b8e8-6f733b1c2e2e@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0183.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::9) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|SA1PR12MB5637:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c918a15-ef23-47aa-448d-08db26d6f8c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PEFKv7acApEOZOiDkUEwVIZA5JHjKI2zsdy/Eb1AJtb8xL+I9lTfSXUCtwxBZd1wuysQx+worjGFLdDbDRJgUkH5YWTj+S+HlpmkKOJdB1RI+3j/aGfcDKjY70pMJtfr8a3GZ3lqxWzWVvGETtv+Zm2mkqpmD0i/xAI+aKjdkZf3MEP3+KnYbDGp0xrpSVGQ8BJWssDWfxn4QiHR+jcJvy5V12XjI4trUhWIR64TeNLbyUUZkiKtAkDUekc0058em/NFt1ibZ/9/fM7dpTg2tbn4D/aDJl+abAK3/6b5CKCRGD9xkDnyPw0y0aWc6ns9HqHhXFPUV2z5wow6yvwdE4FuHGBisUvjW1EZpg/pvAY4/kis69kTN4qU8KmBWKLbA/F/M2QACgUTQKPZGf21hf+6ZVmJXsoZaXq6uaJPxVbjYGgP/0jTwm88UHfl9EDC1UTzLtNpNX9SbukXkpml+cjW4Lg0S9bZireYAqLaBNoJSlowtDpOo2fVNPs8RMZZUU3bWhdO0B5oc81WwDx91BFKkysyHiwH856AJIS7o7jxFlxd6+/kkRHXyJWwJX8JZZMJJfJuZ5JuBgpkHpepWZ0rNigfXd8y8Hei9WHTe/Az15awctMXXRWk8ws92DWnfjjUoKIcQd5yH8WWbOHHg48DMoCsnoQZpagnLCHMIki+phyK1sYbvg/08UgK5KGS7uJkEkcXgzScGMQSoCEZCO578f9aSf9QLFp77KFq34c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199018)(66899018)(31686004)(4326008)(2906002)(41300700001)(8936002)(7416002)(30864003)(5660300002)(38100700002)(31696002)(36756003)(6666004)(6486002)(478600001)(8676002)(66476007)(966005)(66946007)(66556008)(83380400001)(6506007)(6636002)(316002)(54906003)(110136005)(53546011)(26005)(2616005)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlVyOW9ZRktPc3pQbU0vL1VqVTFNTC8rV25vNHlhNWM2eTJ1d01QY0xHZmVQ?=
 =?utf-8?B?dDRaYWlTUndvVG9XUGtOeEx0cmpKN1hHTXhBMmxuRXBCQ1F2VXZsMC9ScXN2?=
 =?utf-8?B?QWRkT2I0bksvVUd1bnE2NzFRS3BiWjJCSWYwTXp6R0YvWlJ4cWZ6WWRQT21q?=
 =?utf-8?B?bFM1SVNhWFdBSHpPQUs0N3JpenBIYWc3eDJFbkRwNkNNTFRxZVdaWTFvQ0FR?=
 =?utf-8?B?L1pXcGlkOWp3TUxiWGlqUHl2MW5JYjB5Q0hsck9aZEQ2ejdOWi85ZUwzM01I?=
 =?utf-8?B?cmRKb0ZTNHMyU1lPck8yMzNmN2ZIVlJ2Qzh3YzBkSEFMK3pQWGVhVUI2a2NV?=
 =?utf-8?B?K1JzWXlKaUhLb2xsS0hYbGJlNGRZNUk5eXZNUklXTVI5WEpsYmZiTk9YV2NM?=
 =?utf-8?B?Wit6eStqWTdtNURUNlk4VDRxU1VxNzhaWHZia2RQWjdRalpicjBlNE9xZHQ2?=
 =?utf-8?B?MHB0QXdGeXczZ2J0Q3Z5L0hKc3ZEamRrVWJrcVRRcnhQcGcwZzQzMDZENENF?=
 =?utf-8?B?U0UyaFVXK3dxSmZyazNWd0xQcVZJcWFSSFhiOC9YeFRDRkRib09pUGo4bHRG?=
 =?utf-8?B?aGY3UGNlb01oQmtoSGFlZGtuMkVTR2VwcE5rSmJuSmk2LzBoSDBtVHY1WU83?=
 =?utf-8?B?dGlWWm9YVHdFSFJiYnVpK2VxYldFclBmSjFyQXM0Qk8zWi9HTzVvTXNvRVA2?=
 =?utf-8?B?enV0Q040YklNaTFiOStBSzhxRXpYYVNGU05GNjkwYzNZaXQ3NHYyUmVlQ25u?=
 =?utf-8?B?TnhhR25ka2hndEUvSDBBSkRwWG1aRWM5WXpXN2xzYXRVeEZ3UzJVQlVLNU5T?=
 =?utf-8?B?eWVMMVUyYm9RK0Z2WExjelRWYjBiVGV4TWs2NUplcGZ2aWVDdVYrVnZncHQ5?=
 =?utf-8?B?eHNmY0c4TEFKbXJPekFKTEh2emVJR3FUcm9zUTQvQlMybE1XK1dMQlh0K0hx?=
 =?utf-8?B?RHh5bTB5cjE5NHZ4WWFlRVowcWZQZmFuQ2hoZ3N5T29jclduSmhXUzdkZW1X?=
 =?utf-8?B?NWVXbld3RHZ3cnk4a2VlbzUwTld1TGMxcTZucXhaaVlOSFRCRVRGdXczb0lR?=
 =?utf-8?B?b0pIUHlmOXdiTlQ5TmZ5cTBPZUpzUWFxeTA5by96dlVUazhZcWxWbks4V1o4?=
 =?utf-8?B?QVVLMWZ4bHBlaU1RUEhqR1JaUnJrTFpwY1pGZDMrY3k5Y1Y1c0x1QUVZdlNl?=
 =?utf-8?B?Nm8yN3p1VkhueXpBOStsWTNxS2tDMjg2ZU9CN2NYaTI0NnplMjdscXRmd08v?=
 =?utf-8?B?U2YyZlpJN3dXelFzTDMrdVB4ZTk5SUEwZG4xWkVGZTJVZ1VlSFNhRHBBQjFV?=
 =?utf-8?B?bCtGVE5yTUdSdGJjVy9zSkdmN1l2NnpKK0doLzZ5Qmw4Zkp0cHhiUGt3M2Zw?=
 =?utf-8?B?bURiY3g1a0VtaDdJZTVxdlppenhPdCtYcDZkRlVRWVd6MmEzYVQveW5KT05Y?=
 =?utf-8?B?cGNhS2tuSG1SMUc3cFlST2ZBN0J3YldLUkpWclN2STdCdHAyZXd6T3lnOUg4?=
 =?utf-8?B?SjZ0OW5ObWRqLzJYS0hyUkdPVTFreHRSZ2NrMURwUXRYY2duNHd1VTZwZFE1?=
 =?utf-8?B?ZTZobS9yNDVGMGc1OWt4MW1uK3JXcW1wOXNNRTFOZm04ZUtZNmRhcHBVZXli?=
 =?utf-8?B?MXAxcXFrZ0E4aUR5N1c0VW9hczY1Qlk1QWQ5bitBSlZRSkNhUEJMYWsyZmx4?=
 =?utf-8?B?d29VTkIvcTJydlpWOFdkSVRGcU8xcnl6aXFlUTFtUU1IV2hxc2dyQzhmSWFZ?=
 =?utf-8?B?ODJYemsvMWtpb3lMMUpXdWJNeklQTGdqZndmZFV0UHJ5U0VsR3pLR0xGbGI1?=
 =?utf-8?B?T1dJNDNzWm1kb1NsN09BSFpVL29lRk1CUlFUYTEyKzMzZEU0cGpSTXVaMnRL?=
 =?utf-8?B?MGJpWGE4c2lNbWYzYVliUzhBL3FDMHRXS0FvMjJVMy9JcGZYUUFldDRPOWlw?=
 =?utf-8?B?SUJsak1hdGROSTUyVEV4clBJUmhMTkhuNzhMaFovVHZNMWpicWdyWUxZb2hs?=
 =?utf-8?B?YVlxdzR2azlTUnpUS0xOSFR4eFp2YTZ0VVFZWEVvb3grMzd5NThzOG5ES3F6?=
 =?utf-8?B?aTJyWnVlVkdnQmpSTnI1TjA2M1hPL1VyWUl5N25RcjdCZDBqQTA1cHJEQVNM?=
 =?utf-8?Q?rC+DjprIUwAhhqPp2fh4Ts1J9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c918a15-ef23-47aa-448d-08db26d6f8c1
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 11:01:34.5703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pU49IzXXXe8EG5XLJv0kpQPYM+dAbKj3OOzaZyt5GHJJC0Xtyk8bpW+uHlzSwhL3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5637
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/15/23 22:48, Gautam Dawar wrote:
>
> On 3/15/23 10:30, Jason Wang wrote:
>> Caution: This message originated from an External Source. Use proper 
>> caution when opening attachments, clicking links, or responding.
>>
>>
>> 在 2023/3/13 20:10, Gautam Dawar 写道:
>>>
>>> On 3/10/23 10:35, Jason Wang wrote:
>>>> Caution: This message originated from an External Source. Use proper
>>>> caution when opening attachments, clicking links, or responding.
>>>>
>>>>
>>>> On Tue, Mar 7, 2023 at 7:38 PM Gautam Dawar <gautam.dawar@amd.com>
>>>> wrote:
>>>>> vDPA config opertions to handle get/set device status and device
>>>>> reset have been implemented. Also .suspend config operation is
>>>>> implemented to support Live Migration.
>>>>>
>>>>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>>>>> ---
>>>>>   drivers/net/ethernet/sfc/ef100_vdpa.c     |  16 +-
>>>>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |   2 +
>>>>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 367
>>>>> ++++++++++++++++++++--
>>>>>   3 files changed, 355 insertions(+), 30 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>>> b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>>> index c66e5aef69ea..4ba57827a6cd 100644
>>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>>> @@ -68,9 +68,14 @@ static int vdpa_allocate_vis(struct efx_nic *efx,
>>>>> unsigned int *allocated_vis)
>>>>>
>>>>>   static void ef100_vdpa_delete(struct efx_nic *efx)
>>>>>   {
>>>>> +       struct vdpa_device *vdpa_dev;
>>>>> +
>>>>>          if (efx->vdpa_nic) {
>>>>> +               vdpa_dev = &efx->vdpa_nic->vdpa_dev;
>>>>> +               ef100_vdpa_reset(vdpa_dev);
>>>>> +
>>>>>                  /* replace with _vdpa_unregister_device later */
>>>>> - put_device(&efx->vdpa_nic->vdpa_dev.dev);
>>>>> +               put_device(&vdpa_dev->dev);
>>>>>          }
>>>>>          efx_mcdi_free_vis(efx);
>>>>>   }
>>>>> @@ -171,6 +176,15 @@ static struct ef100_vdpa_nic
>>>>> *ef100_vdpa_create(struct efx_nic *efx,
>>>>>                  }
>>>>>          }
>>>>>
>>>>> +       rc = devm_add_action_or_reset(&efx->pci_dev->dev,
>>>>> + ef100_vdpa_irq_vectors_free,
>>>>> +                                     efx->pci_dev);
>>>>> +       if (rc) {
>>>>> +               pci_err(efx->pci_dev,
>>>>> +                       "Failed adding devres for freeing irq
>>>>> vectors\n");
>>>>> +               goto err_put_device;
>>>>> +       }
>>>>> +
>>>>>          rc = get_net_config(vdpa_nic);
>>>>>          if (rc)
>>>>>                  goto err_put_device;
>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>>> b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>>> index 348ca8a7404b..58791402e454 100644
>>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>>> @@ -149,6 +149,8 @@ int ef100_vdpa_register_mgmtdev(struct efx_nic
>>>>> *efx);
>>>>>   void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
>>>>>   void ef100_vdpa_irq_vectors_free(void *data);
>>>>>   int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 
>>>>> idx);
>>>>> +void ef100_vdpa_irq_vectors_free(void *data);
>>>>> +int ef100_vdpa_reset(struct vdpa_device *vdev);
>>>>>
>>>>>   static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic
>>>>> *vdpa_nic)
>>>>>   {
>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>>> b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>>> index 0051c4c0e47c..95a2177f85a2 100644
>>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>>> @@ -22,11 +22,6 @@ static struct ef100_vdpa_nic *get_vdpa_nic(struct
>>>>> vdpa_device *vdev)
>>>>>          return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>>>>>   }
>>>>>
>>>>> -void ef100_vdpa_irq_vectors_free(void *data)
>>>>> -{
>>>>> -       pci_free_irq_vectors(data);
>>>>> -}
>>>>> -
>>>>>   static int create_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 
>>>>> idx)
>>>>>   {
>>>>>          struct efx_vring_ctx *vring_ctx;
>>>>> @@ -52,14 +47,6 @@ static void delete_vring_ctx(struct
>>>>> ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>>>          vdpa_nic->vring[idx].vring_ctx = NULL;
>>>>>   }
>>>>>
>>>>> -static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>>> -{
>>>>> -       vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
>>>>> -       vdpa_nic->vring[idx].vring_state = 0;
>>>>> -       vdpa_nic->vring[idx].last_avail_idx = 0;
>>>>> -       vdpa_nic->vring[idx].last_used_idx = 0;
>>>>> -}
>>>>> -
>>>>>   int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>>>   {
>>>>>          u32 offset;
>>>>> @@ -103,6 +90,236 @@ static bool is_qid_invalid(struct
>>>>> ef100_vdpa_nic *vdpa_nic, u16 idx,
>>>>>          return false;
>>>>>   }
>>>>>
>>>>> +static void irq_vring_fini(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>>> +{
>>>>> +       struct ef100_vdpa_vring_info *vring = &vdpa_nic->vring[idx];
>>>>> +       struct pci_dev *pci_dev = vdpa_nic->efx->pci_dev;
>>>>> +
>>>>> +       devm_free_irq(&pci_dev->dev, vring->irq, vring);
>>>>> +       vring->irq = -EINVAL;
>>>>> +}
>>>>> +
>>>>> +static irqreturn_t vring_intr_handler(int irq, void *arg)
>>>>> +{
>>>>> +       struct ef100_vdpa_vring_info *vring = arg;
>>>>> +
>>>>> +       if (vring->cb.callback)
>>>>> +               return vring->cb.callback(vring->cb.private);
>>>>> +
>>>>> +       return IRQ_NONE;
>>>>> +}
>>>>> +
>>>>> +static int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev,
>>>>> u16 nvqs)
>>>>> +{
>>>>> +       int rc;
>>>>> +
>>>>> +       rc = pci_alloc_irq_vectors(pci_dev, nvqs, nvqs, 
>>>>> PCI_IRQ_MSIX);
>>>>> +       if (rc < 0)
>>>>> +               pci_err(pci_dev,
>>>>> +                       "Failed to alloc %d IRQ vectors, err:%d\n",
>>>>> nvqs, rc);
>>>>> +       return rc;
>>>>> +}
>>>>> +
>>>>> +void ef100_vdpa_irq_vectors_free(void *data)
>>>>> +{
>>>>> +       pci_free_irq_vectors(data);
>>>>> +}
>>>>> +
>>>>> +static int irq_vring_init(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>>> +{
>>>>> +       struct ef100_vdpa_vring_info *vring = &vdpa_nic->vring[idx];
>>>>> +       struct pci_dev *pci_dev = vdpa_nic->efx->pci_dev;
>>>>> +       int irq;
>>>>> +       int rc;
>>>>> +
>>>>> +       snprintf(vring->msix_name, 256, "x_vdpa[%s]-%d\n",
>>>>> +                pci_name(pci_dev), idx);
>>>>> +       irq = pci_irq_vector(pci_dev, idx);
>>>>> +       rc = devm_request_irq(&pci_dev->dev, irq,
>>>>> vring_intr_handler, 0,
>>>>> +                             vring->msix_name, vring);
>>>>> +       if (rc)
>>>>> +               pci_err(pci_dev,
>>>>> +                       "devm_request_irq failed for vring %d, rc
>>>>> %d\n",
>>>>> +                       idx, rc);
>>>>> +       else
>>>>> +               vring->irq = irq;
>>>>> +
>>>>> +       return rc;
>>>>> +}
>>>>> +
>>>>> +static int delete_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>>> +{
>>>>> +       struct efx_vring_dyn_cfg vring_dyn_cfg;
>>>>> +       int rc;
>>>>> +
>>>>> +       if (!(vdpa_nic->vring[idx].vring_state & 
>>>>> EF100_VRING_CREATED))
>>>>> +               return 0;
>>>>> +
>>>>> +       rc = efx_vdpa_vring_destroy(vdpa_nic->vring[idx].vring_ctx,
>>>>> +                                   &vring_dyn_cfg);
>>>>> +       if (rc)
>>>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>>>> +                       "%s: delete vring failed index:%u, err:%d\n",
>>>>> +                       __func__, idx, rc);
>>>>> +       vdpa_nic->vring[idx].last_avail_idx = 
>>>>> vring_dyn_cfg.avail_idx;
>>>>> +       vdpa_nic->vring[idx].last_used_idx = vring_dyn_cfg.used_idx;
>>>>> +       vdpa_nic->vring[idx].vring_state &= ~EF100_VRING_CREATED;
>>>>> +
>>>>> +       irq_vring_fini(vdpa_nic, idx);
>>>>> +
>>>>> +       return rc;
>>>>> +}
>>>>> +
>>>>> +static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
>>>>> +{
>>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>> +       u32 idx_val;
>>>>> +
>>>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>>> +               return;
>>>>> +
>>>>> +       if (!(vdpa_nic->vring[idx].vring_state & 
>>>>> EF100_VRING_CREATED))
>>>>> +               return;
>>>>> +
>>>>> +       idx_val = idx;
>>>>> +       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
>>>>> + vdpa_nic->vring[idx].doorbell_offset);
>>>>> +}
>>>>> +
>>>>> +static bool can_create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 
>>>>> idx)
>>>>> +{
>>>>> +       if (vdpa_nic->vring[idx].vring_state ==
>>>>> EF100_VRING_CONFIGURED &&
>>>>> +           vdpa_nic->status & VIRTIO_CONFIG_S_DRIVER_OK &&
>>>>> +           !(vdpa_nic->vring[idx].vring_state & 
>>>>> EF100_VRING_CREATED))
>>>>> +               return true;
>>>>> +
>>>>> +       return false;
>>>>> +}
>>>>> +
>>>>> +static int create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>>> +{
>>>>> +       struct efx_vring_dyn_cfg vring_dyn_cfg;
>>>>> +       struct efx_vring_cfg vring_cfg;
>>>>> +       int rc;
>>>>> +
>>>>> +       rc = irq_vring_init(vdpa_nic, idx);
>>>>> +       if (rc) {
>>>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>>>> +                       "%s: irq_vring_init failed. index:%u,
>>>>> err:%d\n",
>>>>> +                       __func__, idx, rc);
>>>>> +               return rc;
>>>>> +       }
>>>>> +       vring_cfg.desc = vdpa_nic->vring[idx].desc;
>>>>> +       vring_cfg.avail = vdpa_nic->vring[idx].avail;
>>>>> +       vring_cfg.used = vdpa_nic->vring[idx].used;
>>>>> +       vring_cfg.size = vdpa_nic->vring[idx].size;
>>>>> +       vring_cfg.features = vdpa_nic->features;
>>>>> +       vring_cfg.msix_vector = idx;
>>>>> +       vring_dyn_cfg.avail_idx = 
>>>>> vdpa_nic->vring[idx].last_avail_idx;
>>>>> +       vring_dyn_cfg.used_idx = vdpa_nic->vring[idx].last_used_idx;
>>>>> +
>>>>> +       rc = efx_vdpa_vring_create(vdpa_nic->vring[idx].vring_ctx,
>>>>> +                                  &vring_cfg, &vring_dyn_cfg);
>>>>> +       if (rc) {
>>>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>>>> +                       "%s: vring_create failed index:%u, err:%d\n",
>>>>> +                       __func__, idx, rc);
>>>>> +               goto err_vring_create;
>>>>> +       }
>>>>> +       vdpa_nic->vring[idx].vring_state |= EF100_VRING_CREATED;
>>>>> +
>>>>> +       /* A VQ kick allows the device to read the avail_idx, which
>>>>> will be
>>>>> +        * required at the destination after live migration.
>>>>> +        */
>>>>> +       ef100_vdpa_kick_vq(&vdpa_nic->vdpa_dev, idx);
>>>>> +
>>>>> +       return 0;
>>>>> +
>>>>> +err_vring_create:
>>>>> +       irq_vring_fini(vdpa_nic, idx);
>>>>> +       return rc;
>>>>> +}
>>>>> +
>>>>> +static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>>> +{
>>>>> +       delete_vring(vdpa_nic, idx);
>>>>> +       vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
>>>>> +       vdpa_nic->vring[idx].vring_state = 0;
>>>>> +       vdpa_nic->vring[idx].last_avail_idx = 0;
>>>>> +       vdpa_nic->vring[idx].last_used_idx = 0;
>>>>> +}
>>>>> +
>>>>> +static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>>>> +{
>>>>> +       int i;
>>>>> +
>>>>> +       WARN_ON(!mutex_is_locked(&vdpa_nic->lock));
>>>>> +
>>>>> +       if (!vdpa_nic->status)
>>>>> +               return;
>>>>> +
>>>>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>>>>> +       vdpa_nic->status = 0;
>>>>> +       vdpa_nic->features = 0;
>>>>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
>>>>> +               reset_vring(vdpa_nic, i);
>>>>> + ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
>>>>> +}
>>>>> +
>>>>> +/* May be called under the rtnl lock */
>>>>> +int ef100_vdpa_reset(struct vdpa_device *vdev)
>>>>> +{
>>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>> +
>>>>> +       /* vdpa device can be deleted anytime but the bar_config
>>>>> +        * could still be vdpa and hence efx->state would be
>>>>> STATE_VDPA.
>>>>> +        * Accordingly, ensure vdpa device exists before reset 
>>>>> handling
>>>>> +        */
>>>>> +       if (!vdpa_nic)
>>>>> +               return -ENODEV;
>>>>> +
>>>>> +       mutex_lock(&vdpa_nic->lock);
>>>>> +       ef100_reset_vdpa_device(vdpa_nic);
>>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>> +static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>>>> +{
>>>>> +       struct efx_nic *efx = vdpa_nic->efx;
>>>>> +       struct ef100_nic_data *nic_data;
>>>>> +       int i, j;
>>>>> +       int rc;
>>>>> +
>>>>> +       nic_data = efx->nic_data;
>>>>> +       rc = ef100_vdpa_irq_vectors_alloc(efx->pci_dev,
>>>>> + vdpa_nic->max_queue_pairs * 2);
>>>>> +       if (rc < 0) {
>>>>> +               pci_err(efx->pci_dev,
>>>>> +                       "vDPA IRQ alloc failed for vf: %u err:%d\n",
>>>>> +                       nic_data->vf_index, rc);
>>>>> +               return rc;
>>>>> +       }
>>>>> +
>>>>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>>>>> +               if (can_create_vring(vdpa_nic, i)) {
>>>>> +                       rc = create_vring(vdpa_nic, i);
>>>>> +                       if (rc)
>>>>> +                               goto clear_vring;
>>>>> +               }
>>>>> +       }
>>>>> +
>>>>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
>>>> It looks to me that this duplicates with the DRIVER_OK status bit.
>>> vdpa_state is set EF100_VDPA_STATE_STARTED during DRIVER_OK handling.
>>> See my later response for its purpose.
>>>>
>>>>> +       return 0;
>>>>> +
>>>>> +clear_vring:
>>>>> +       for (j = 0; j < i; j++)
>>>>> +               delete_vring(vdpa_nic, j);
>>>>> +
>>>>> +       ef100_vdpa_irq_vectors_free(efx->pci_dev);
>>>>> +       return rc;
>>>>> +}
>>>>> +
>>>>>   static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
>>>>>                                       u16 idx, u64 desc_area, u64
>>>>> driver_area,
>>>>>                                       u64 device_area)
>>>>> @@ -144,22 +361,6 @@ static void ef100_vdpa_set_vq_num(struct
>>>>> vdpa_device *vdev, u16 idx, u32 num)
>>>>>          mutex_unlock(&vdpa_nic->lock);
>>>>>   }
>>>>>
>>>>> -static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
>>>>> -{
>>>>> -       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>> -       u32 idx_val;
>>>>> -
>>>>> -       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>>> -               return;
>>>>> -
>>>>> -       if (!(vdpa_nic->vring[idx].vring_state & 
>>>>> EF100_VRING_CREATED))
>>>>> -               return;
>>>>> -
>>>>> -       idx_val = idx;
>>>>> -       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
>>>>> - vdpa_nic->vring[idx].doorbell_offset);
>>>>> -}
>>>>> -
>>>>>   static void ef100_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx,
>>>>>                                   struct vdpa_callback *cb)
>>>>>   {
>>>>> @@ -176,6 +377,7 @@ static void ef100_vdpa_set_vq_ready(struct
>>>>> vdpa_device *vdev, u16 idx,
>>>>>                                      bool ready)
>>>>>   {
>>>>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>> +       int rc;
>>>>>
>>>>>          if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>>>                  return;
>>>>> @@ -184,9 +386,21 @@ static void ef100_vdpa_set_vq_ready(struct
>>>>> vdpa_device *vdev, u16 idx,
>>>>>          if (ready) {
>>>>>                  vdpa_nic->vring[idx].vring_state |=
>>>>> EF100_VRING_READY_CONFIGURED;
>>>>> +               if (vdpa_nic->vdpa_state == 
>>>>> EF100_VDPA_STATE_STARTED &&
>>>>> +                   can_create_vring(vdpa_nic, idx)) {
>>>>> +                       rc = create_vring(vdpa_nic, idx);
>>>>> +                       if (rc)
>>>>> +                               /* Rollback ready configuration
>>>>> +                                * So that the above layer driver
>>>>> +                                * can make another attempt to set
>>>>> ready
>>>>> +                                */
>>>>> + vdpa_nic->vring[idx].vring_state &=
>>>>> + ~EF100_VRING_READY_CONFIGURED;
>>>>> +               }
>>>>>          } else {
>>>>>                  vdpa_nic->vring[idx].vring_state &=
>>>>> ~EF100_VRING_READY_CONFIGURED;
>>>>> +               delete_vring(vdpa_nic, idx);
>>>>>          }
>>>>>          mutex_unlock(&vdpa_nic->lock);
>>>>>   }
>>>>> @@ -296,6 +510,12 @@ static u64
>>>>> ef100_vdpa_get_device_features(struct vdpa_device *vdev)
>>>>>          }
>>>>>
>>>>>          features |= BIT_ULL(VIRTIO_NET_F_MAC);
>>>>> +       /* As QEMU SVQ doesn't implement the following features,
>>>>> +        * masking them off to allow Live Migration
>>>>> +        */
>>>>> +       features &= ~BIT_ULL(VIRTIO_F_IN_ORDER);
>>>>> +       features &= ~BIT_ULL(VIRTIO_F_ORDER_PLATFORM);
>>>> It's better not to work around userspace bugs in the kernel. We should
>>>> fix Qemu instead.
>>>
>>> There's already a QEMU patch [1] submitted to support
>>> VIRTIO_F_ORDER_PLATFORM but it hasn't concluded yet. Also, there is no
>>> support for VIRTIO_F_IN_ORDER in the kernel virtio driver. The motive
>>> of this change is to have VM Live Migration working with the kernel
>>> in-tree driver without requiring any changes.
>>>
>>> Once QEMU is able to handle these features, we can submit a patch to
>>> undo these changes.
>>
>>
>> I can understand the motivation, but it works for prototyping but not
>> formal kernel code (especially consider SVQ is not mature and still
>> being development). What's more, we can not assume Qemu is the only
>> user, we have other users like DPDK and cloud-hypervisors.
>
> Ok, if the expectation is to have the user deal with the issues and 
> make required changes on the in-tree driver to make it work, I'll 
> remove this part.
>
>>
>> Thanks
>>
>>
>>>
>>>>
>>>>> +
>>>>>          return features;
>>>>>   }
>>>>>
>>>>> @@ -356,6 +576,77 @@ static u32 ef100_vdpa_get_vendor_id(struct
>>>>> vdpa_device *vdev)
>>>>>          return EF100_VDPA_VENDOR_ID;
>>>>>   }
>>>>>
>>>>> +static u8 ef100_vdpa_get_status(struct vdpa_device *vdev)
>>>>> +{
>>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>> +       u8 status;
>>>>> +
>>>>> +       mutex_lock(&vdpa_nic->lock);
>>>>> +       status = vdpa_nic->status;
>>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>>> +       return status;
>>>>> +}
>>>>> +
>>>>> +static void ef100_vdpa_set_status(struct vdpa_device *vdev, u8 
>>>>> status)
>>>>> +{
>>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>> +       u8 new_status;
>>>>> +       int rc;
>>>>> +
>>>>> +       mutex_lock(&vdpa_nic->lock);
>>>>> +       if (!status) {
>>>>> +               dev_info(&vdev->dev,
>>>>> +                        "%s: Status received is 0. Device reset
>>>>> being done\n",
>>>>> +                        __func__);
>>>> This is trigger-able by the userspace. It might be better to use
>>>> dev_dbg() instead.
>>> Will change.
>>>>
>>>>> + ef100_reset_vdpa_device(vdpa_nic);
>>>>> +               goto unlock_return;
>>>>> +       }
>>>>> +       new_status = status & ~vdpa_nic->status;
>>>>> +       if (new_status == 0) {
>>>>> +               dev_info(&vdev->dev,
>>>>> +                        "%s: New status same as current status\n",
>>>>> __func__);
>>>> Same here.
>>> Ok.
>>>>
>>>>> +               goto unlock_return;
>>>>> +       }
>>>>> +       if (new_status & VIRTIO_CONFIG_S_FAILED) {
>>>>> +               ef100_reset_vdpa_device(vdpa_nic);
>>>>> +               goto unlock_return;
>>>>> +       }
>>>>> +
>>>>> +       if (new_status & VIRTIO_CONFIG_S_ACKNOWLEDGE) {
>>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
>>>>> +               new_status &= ~VIRTIO_CONFIG_S_ACKNOWLEDGE;
>>>>> +       }
>>>>> +       if (new_status & VIRTIO_CONFIG_S_DRIVER) {
>>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER;
>>>>> +               new_status &= ~VIRTIO_CONFIG_S_DRIVER;
>>>>> +       }
>>>>> +       if (new_status & VIRTIO_CONFIG_S_FEATURES_OK) {
>>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_FEATURES_OK;
>>>>> +               vdpa_nic->vdpa_state = EF100_VDPA_STATE_NEGOTIATED;
>>>> It might be better to explain the reason we need to track another
>>>> state in vdpa_state instead of simply using the device status.
>>> vdpa_state helps to ensure correct status transitions in the
>>> .set_status callback and safe-guards against incorrect/malicious
>>> user-space driver.
>>
>>
>> Ok, let's document this in the definition of vdpa_state.
> Sure, will do.
>>
>>
>>>>
>>>>> +               new_status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
>>>>> +       }
>>>>> +       if (new_status & VIRTIO_CONFIG_S_DRIVER_OK &&
>>>>> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_NEGOTIATED) {
>>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER_OK;
>>>>> +               rc = start_vdpa_device(vdpa_nic);
>>>>> +               if (rc) {
>>>>> + dev_err(&vdpa_nic->vdpa_dev.dev,
>>>>> +                               "%s: vDPA device failed:%d\n",
>>>>> __func__, rc);
>>>>> +                       vdpa_nic->status &= 
>>>>> ~VIRTIO_CONFIG_S_DRIVER_OK;
>>>>> +                       goto unlock_return;
>>>>> +               }
>>>>> +               new_status &= ~VIRTIO_CONFIG_S_DRIVER_OK;
>>>>> +       }
>>>>> +       if (new_status) {
>>>>> +               dev_warn(&vdev->dev,
>>>>> +                        "%s: Mismatch Status: %x & State: %u\n",
>>>>> +                        __func__, new_status, vdpa_nic->vdpa_state);
>>>>> +       }
>>>>> +
>>>>> +unlock_return:
>>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>>> +}
>>>>> +
>>>>>   static size_t ef100_vdpa_get_config_size(struct vdpa_device *vdev)
>>>>>   {
>>>>>          return sizeof(struct virtio_net_config);
>>>>> @@ -393,6 +684,20 @@ static void ef100_vdpa_set_config(struct
>>>>> vdpa_device *vdev, unsigned int offset,
>>>>>                  vdpa_nic->mac_configured = true;
>>>>>   }
>>>>>
>>>>> +static int ef100_vdpa_suspend(struct vdpa_device *vdev)
>>>>> +{
>>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>> +       int i, rc;
>>>>> +
>>>>> +       mutex_lock(&vdpa_nic->lock);
>>>>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>>>>> +               rc = delete_vring(vdpa_nic, i);
>>>> Note that the suspension matters for the whole device. It means the
>>>> config space should not be changed. But the code here only suspends
>>>> the vring, is this intende/d?
>>> Are you referring to the possibility of updating device configuration
>>> (eg. MAC address) using .set_config() after suspend operation? Is
>>> there any other user triggered operation that falls in this category?
>>
>>
>> Updating MAC should be prohibited, one typical use case is the link 
>> status.
> I think this can be dealt with an additional SUSPEND state which can 
> be used to avoid any changes to the config space.
>>
>>
>>>>
>>>> Reset may have the same issue.
>>> Could you pls elaborate on the requirement during device reset?
>>
>>
>> I meant ef100_reset_vdpa_device() may suffer from the same issue:
>>
>> It only reset all the vring but not the config space?
>
> Ok, I think resetting config space would basically be clearing the 
> memory for vdpa_nic->net_config which is the initial state after vdpa 
> device allocation.

On second thought, the virtio_net_config data except mac is static 
(updated during vdpa device creation) and must not be cleared during 
device reset. Also, as currently the MAC address of the existing vdpa 
device can't be updated, it too should not be cleared.

Gautam

>
>
> Gautam
>
>>
>> Thanks
>>
>>
>>>>
>>>> Thanks
>>> [1]
>>> https://patchew.org/QEMU/20230213191929.1547497-1-eperezma@redhat.com/
>>>>
>>>>> +               if (rc)
>>>>> +                       break;
>>>>> +       }
>>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>>> +       return rc;
>>>>> +}
>>>>>   static void ef100_vdpa_free(struct vdpa_device *vdev)
>>>>>   {
>>>>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>>> @@ -428,9 +733,13 @@ const struct vdpa_config_ops
>>>>> ef100_vdpa_config_ops = {
>>>>>          .get_vq_num_max      = ef100_vdpa_get_vq_num_max,
>>>>>          .get_device_id       = ef100_vdpa_get_device_id,
>>>>>          .get_vendor_id       = ef100_vdpa_get_vendor_id,
>>>>> +       .get_status          = ef100_vdpa_get_status,
>>>>> +       .set_status          = ef100_vdpa_set_status,
>>>>> +       .reset               = ef100_vdpa_reset,
>>>>>          .get_config_size     = ef100_vdpa_get_config_size,
>>>>>          .get_config          = ef100_vdpa_get_config,
>>>>>          .set_config          = ef100_vdpa_set_config,
>>>>>          .get_generation      = NULL,
>>>>> +       .suspend             = ef100_vdpa_suspend,
>>>>>          .free                = ef100_vdpa_free,
>>>>>   };
>>>>> -- 
>>>>> 2.30.1
>>>>>
>>>
>>
