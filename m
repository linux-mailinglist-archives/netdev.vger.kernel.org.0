Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A490B6BBAB5
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 18:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbjCORTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 13:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjCORTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 13:19:11 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB3FA247;
        Wed, 15 Mar 2023 10:19:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/Ltn6NykjwOXAfQ6VvePPbHQbdcJBt/pIN281++prvfmmgCIPBaWCs0cwwzFfob/BvwdxF1dL4eJ7QYU0x6hZLmfQvltZvNeWCAKK6Rw6pjVf65cjhD29/W20ztA2lf/CQrvgX7357dpz5YEPUN9MduxdHPomPAk5Fx+L4wjv9j+GmUBITGJAjaY3DiruDdi+S3dpiVYE9bp9gQqXMkMCl3GKDHfavalxVi2H8NHktQrRqE1ZI9657G0RqX3+gOjOmYByS2oNpsVJabIQP0BTcExSIkDWNXfE3TVX1XOq5TDUbyNRVHDPb9qJunnrHDp5Xlosa78Fg4zl/U8BcLAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8J5nVdtwVRINvZxIuTJPgSXZfBD5guYXIFyM4INSmo=;
 b=Vyc+gr6nyLcQ2H/iMIn1/uXgNR/B3tDzhNSC7ChHXeIbfQKzkfSS/16FctOtXFECCIdU+VWoE73C72OXVoIdplAamPMo742oHxUee9B9n14AmsLO2V/sGwMl035ftJINTSLbgWpYlHQITvMREd+Z16tMl+BSTSGmxtFDWdYeeEQB4gTijpnogTGr421DWXWScohYdp0uhUH6nA0tV5q6jcfTV5zliveNxwj5R1S8NzCWG96R59tUjkXTirGSudhx4lqZeEjP1U3hw/Vxol0oaqLyEW4rNEarOb0dld5y/wmqcM0Wp2KiV8xH6yLv+zK81yI6TnMYD+XqSmtrOfUXSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8J5nVdtwVRINvZxIuTJPgSXZfBD5guYXIFyM4INSmo=;
 b=cnWhexI4AAiqdCu3J18geN7VBK944dYwtGtcf9ZfZt1irgNjG0svC6kExLBZn7e9p4YQhInOkrp6cF70+1wt8CyFm3QSKBg2RufMWxh/kbCVx3NQ/c62Fh9RtxgmPKkVVPxEs5epvlruffj1+6sO2kIyguwywT/wIlElWlBkBtM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 17:19:04 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::7222:fe4b:effd:b732%5]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 17:19:04 +0000
Message-ID: <6c05c616-502e-fa07-b8e8-6f733b1c2e2e@amd.com>
Date:   Wed, 15 Mar 2023 22:48:52 +0530
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
 <3a3b63f5-66a9-47aa-ba0d-3bb99c928a60@amd.com>
 <a6562f42-7bb1-0e0d-3990-7d5962efe6b9@redhat.com>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <a6562f42-7bb1-0e0d-3990-7d5962efe6b9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0028.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::33) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a43b3d1-7763-482f-a101-08db2579607b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nr1XhM/pav2tE0NiU6qEdQAVm85V6dD35XQl4n+lG7Il9PPKjaz5YCHo9/u1gYT0ZMM5KibGOG6wofh2oUca88+rFgJK/ZFsBriirC0N0qzGWivRomlptNOKUwB34c+Mm7JmlieayZGIb20YahsCivlotXBcngyuDVw2/+52MeeTs1rhzyYLpsnn0sLo6d/nvQS7mVjcKtaenpFqgOG4Lz4r3KpLRvc+aBheQUa33/2NUbBhhjC1OyVfvDgVrxolE7a/Tu6gx3jFdd1ZGHwDLIXH9reUbZQ5jXXDknAGZVhNuq/xpQtlTVjLm1vBwIA0V5HKEQEHymA8d5nXA287gY4G9JztTyMS7ppAYOcedzu+sHoe8a0WACECGrjBAuLeyMZPFSppYu3Z8jryScYtpthCZay2JKn3ker3CeYL5WU00Ba8/mp3f984AXF/Sio44BC2JnTZpxPl5Oel+xeM8CMbIcbB+ixNK7TCPfdsMz2s7+rnE+JXM6KRVxRbrNBeGGjAO2ruNHm2OePKBgw/dGaOhjdn6Ru6NbQLsR/49YR6KhtuRtDbxfKf93z5hLxTO5qOMG+rkAFUMIsqOsPL0C8fVUqUpjpwDQpmdSA4Xsc4mAxD4nWBrdk7RgHa7YNyMMBjXBjCxbjrxRAWKF77eLcdf9ST8JeGZi5sdHIVaed1/TfoLTX62C7793fs1PPKjpwyIDTaVgvSPWskTo46/jF6wPRXhp2DFg+cgYwFlwQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(451199018)(66899018)(31686004)(6666004)(316002)(110136005)(54906003)(6636002)(36756003)(53546011)(31696002)(38100700002)(83380400001)(26005)(2616005)(186003)(6512007)(6506007)(5660300002)(7416002)(8936002)(478600001)(966005)(6486002)(66476007)(41300700001)(4326008)(2906002)(8676002)(66946007)(30864003)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnNOc1oxTGUxZnlDOUx6Y0xoVjBVNVdlZjNJNFU2MldSclIvK3FVOC9ZZTlW?=
 =?utf-8?B?cjBETHR3dk0yZi9nK0VjMlNiMGVkTnpuKzJ1ZTNTRHVlTHVYRWc0aTlrQ1g0?=
 =?utf-8?B?R3kwN05nWnByVzg2azV5QkNod0dFNHVCN0ZEWEVTK25SK3ZMS2xybUtuWjNX?=
 =?utf-8?B?MXRVY01PSEorclg5emZKeVpsdmp0Njlmb0dMdC9PU1lybDNRMUxMSnk3ck9i?=
 =?utf-8?B?RTJ5TEJJeEZsM0xqS1F6cW1WYmJpNHNWd09ZMlpKcEE3bWpRRTQ5NnNLNlJr?=
 =?utf-8?B?NklSd09oaWd2MVNQR3N4N1Qzenc0Ly9oZ0lFUElObEwybVRaTkg3Mm0veHhY?=
 =?utf-8?B?d3dBbkI1eWx5OUtuK3ZxbmxhNkMxVXlheW9HZlRsU2dhekg2OGk1Tjh5Sy83?=
 =?utf-8?B?T3M4a3NQRm5mV2c4Q09ENzNPT3duN05DUDgzdnV0ZC9HWlFNeXlySGRRU2lQ?=
 =?utf-8?B?S25XcVhxUkd2YmRYMVRMRk1IZXpYTFhZSjJWeUtEVDRtTXZJZkx3ajlsYnBG?=
 =?utf-8?B?bDBXcklyaDJLNU9LRUxrOTdvOXBGMCt6QkFabkJYOXBVQlN6VG82UjVSK2Fm?=
 =?utf-8?B?cXNzS0pLRjQyWmRzK2h5TW5lZHlyRy9sZlMzdnQxWVgvWFd6L1ByMXFNYXNz?=
 =?utf-8?B?OXJZWjdwSHhlbE9hOU1la0VjZW5zMXVoYUI1a0NSL0ROTXZObklNaUVldXFZ?=
 =?utf-8?B?bHJUQ0lGNGpkWE9ud1FDdzBuczR5NVdHZDdHckFKOGZhOGY2dnBWNUN3Z0cz?=
 =?utf-8?B?VnVKZk1MenBpSDdjRWk5M3JtbS9STG9zcTJWMEhhWGdVL1d6cnMxOFo1a1VS?=
 =?utf-8?B?TVpBVU1PMFJ5aXhqM1IyNW00Wm56Y1NYaUxlaXNpSlJLZ2NGS2dwcUZOY0hX?=
 =?utf-8?B?eHo4eE1jNmJ4U3Q0VURSMnhTL21xUkIxK0FwTWJIS1A1clFRakhkbVozOU5E?=
 =?utf-8?B?TGJMakU4b2pPTTh2bVNBY2Y3UHpnckFuem9zSVRveU5zaThXSEpoL1g4byti?=
 =?utf-8?B?WDgwU29qYW4vRWxmVUZ1MzJFZitFTXlLcVlMWWw1YURjdmhMZ1pQS1FIU09W?=
 =?utf-8?B?RHdoQ3hwSVc2SCtBTEtyZ3VjUXp3Um41SFMyRTZCTUZ5VC9CSVBJREMzWDRD?=
 =?utf-8?B?K20vRjZEL0dHb2hySWxucDR2QUZNaW5sUGJTbDZtZVEyZXJpQ1VlSm44L0Fl?=
 =?utf-8?B?UWdtaHYvS0VRajMwTFhqZHJtS1JrTlZqdTV1RUJRdEk0TnI1dUlGQ2h5SHRQ?=
 =?utf-8?B?SG9kaVlpZmRLSGI4K0wxUlJVYitRRDltYjdoeVQ1R294WEJtQjc4TUVFbk96?=
 =?utf-8?B?eElpaHIzME5sM0llem9oQzZ0REN4SmVaZy9VaWM3VkdGM0dsTjVpVFZhL1hh?=
 =?utf-8?B?NlppUTltL21uUUQ2VFkrek1UbWNZR1dBb1I3UFliNS9DWjkveW91TkVINkdB?=
 =?utf-8?B?S3hIZkxhRVdSWUUyc0RLZmtxdnBhNU84QlB0RVBtTk9PQ0IyNERmWGdhSGtK?=
 =?utf-8?B?RURDZUt1TGFRZzhxRGk5Z3AvZ2F3d21YSDduTHp6enZYWmNkcUhqajZ1cEx0?=
 =?utf-8?B?blR5VFBMbnJlSTY2WkNiZ0MyNFJTbHZqdUY1MXRGWmZQMnlObldHbGF3d0Qz?=
 =?utf-8?B?TjBoRVVFVU1ESGhVajhIUTdNU1Yrc1g4UHk2NHlBNW9ZZEZnaUFlOFFra0Jr?=
 =?utf-8?B?bldEelpXNy9RZlVGVWI5K2tIY0V2bEZkeThzNmFuRnFBYTN4Y2FZYnBGUjFZ?=
 =?utf-8?B?VE5pb2w1ZlI2SEpPYjQxZkp2RngwQ0M1MlRnUHd3TGc3OEZ4emJySFk2b1lI?=
 =?utf-8?B?WWRUb2lQRENvN2VvYzhQd05ENnIwdk1ZbTZnUGk1MUJrQ0l0VHRlVitEV1ow?=
 =?utf-8?B?Tk1xOG0veXRTWDBEeXZJY2JoSzhmdHN6SGlyYndaelh1ZjZXUEt5Z2svanBZ?=
 =?utf-8?B?bTFoMW9pTzcrZ3BDalVCSTY5Zm9zek1rcC9DU2VxaXZLSFBDQ2crb3o4MXky?=
 =?utf-8?B?anZwM1crQU5VVTUzSWkxMWxTVE9qdWpPSEJhd2lYdVV1VEQxbkNCakZqbWQx?=
 =?utf-8?B?UVB3cUc0MEVvZkQyYnFtY0RBMUp4bVBLWnJkT21TTFVyWTNodmRIb3o5MkVV?=
 =?utf-8?Q?HAWPIgb/kvbc03Zr8LXNmMQbW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a43b3d1-7763-482f-a101-08db2579607b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 17:19:04.7416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4/dQKUBnVElhTk+8ZtbplEioS2He38WTaydkHo7UxN0NrkidMJ+xMKYq5gE2lSwX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/15/23 10:30, Jason Wang wrote:
> Caution: This message originated from an External Source. Use proper 
> caution when opening attachments, clicking links, or responding.
>
>
> 在 2023/3/13 20:10, Gautam Dawar 写道:
>>
>> On 3/10/23 10:35, Jason Wang wrote:
>>> Caution: This message originated from an External Source. Use proper
>>> caution when opening attachments, clicking links, or responding.
>>>
>>>
>>> On Tue, Mar 7, 2023 at 7:38 PM Gautam Dawar <gautam.dawar@amd.com>
>>> wrote:
>>>> vDPA config opertions to handle get/set device status and device
>>>> reset have been implemented. Also .suspend config operation is
>>>> implemented to support Live Migration.
>>>>
>>>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
>>>> ---
>>>>   drivers/net/ethernet/sfc/ef100_vdpa.c     |  16 +-
>>>>   drivers/net/ethernet/sfc/ef100_vdpa.h     |   2 +
>>>>   drivers/net/ethernet/sfc/ef100_vdpa_ops.c | 367
>>>> ++++++++++++++++++++--
>>>>   3 files changed, 355 insertions(+), 30 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>> b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>> index c66e5aef69ea..4ba57827a6cd 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
>>>> @@ -68,9 +68,14 @@ static int vdpa_allocate_vis(struct efx_nic *efx,
>>>> unsigned int *allocated_vis)
>>>>
>>>>   static void ef100_vdpa_delete(struct efx_nic *efx)
>>>>   {
>>>> +       struct vdpa_device *vdpa_dev;
>>>> +
>>>>          if (efx->vdpa_nic) {
>>>> +               vdpa_dev = &efx->vdpa_nic->vdpa_dev;
>>>> +               ef100_vdpa_reset(vdpa_dev);
>>>> +
>>>>                  /* replace with _vdpa_unregister_device later */
>>>> - put_device(&efx->vdpa_nic->vdpa_dev.dev);
>>>> +               put_device(&vdpa_dev->dev);
>>>>          }
>>>>          efx_mcdi_free_vis(efx);
>>>>   }
>>>> @@ -171,6 +176,15 @@ static struct ef100_vdpa_nic
>>>> *ef100_vdpa_create(struct efx_nic *efx,
>>>>                  }
>>>>          }
>>>>
>>>> +       rc = devm_add_action_or_reset(&efx->pci_dev->dev,
>>>> + ef100_vdpa_irq_vectors_free,
>>>> +                                     efx->pci_dev);
>>>> +       if (rc) {
>>>> +               pci_err(efx->pci_dev,
>>>> +                       "Failed adding devres for freeing irq
>>>> vectors\n");
>>>> +               goto err_put_device;
>>>> +       }
>>>> +
>>>>          rc = get_net_config(vdpa_nic);
>>>>          if (rc)
>>>>                  goto err_put_device;
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> index 348ca8a7404b..58791402e454 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
>>>> @@ -149,6 +149,8 @@ int ef100_vdpa_register_mgmtdev(struct efx_nic
>>>> *efx);
>>>>   void ef100_vdpa_unregister_mgmtdev(struct efx_nic *efx);
>>>>   void ef100_vdpa_irq_vectors_free(void *data);
>>>>   int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx);
>>>> +void ef100_vdpa_irq_vectors_free(void *data);
>>>> +int ef100_vdpa_reset(struct vdpa_device *vdev);
>>>>
>>>>   static inline bool efx_vdpa_is_little_endian(struct ef100_vdpa_nic
>>>> *vdpa_nic)
>>>>   {
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>> b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>> index 0051c4c0e47c..95a2177f85a2 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
>>>> @@ -22,11 +22,6 @@ static struct ef100_vdpa_nic *get_vdpa_nic(struct
>>>> vdpa_device *vdev)
>>>>          return container_of(vdev, struct ef100_vdpa_nic, vdpa_dev);
>>>>   }
>>>>
>>>> -void ef100_vdpa_irq_vectors_free(void *data)
>>>> -{
>>>> -       pci_free_irq_vectors(data);
>>>> -}
>>>> -
>>>>   static int create_vring_ctx(struct ef100_vdpa_nic *vdpa_nic, u16 
>>>> idx)
>>>>   {
>>>>          struct efx_vring_ctx *vring_ctx;
>>>> @@ -52,14 +47,6 @@ static void delete_vring_ctx(struct
>>>> ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>>          vdpa_nic->vring[idx].vring_ctx = NULL;
>>>>   }
>>>>
>>>> -static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>> -{
>>>> -       vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
>>>> -       vdpa_nic->vring[idx].vring_state = 0;
>>>> -       vdpa_nic->vring[idx].last_avail_idx = 0;
>>>> -       vdpa_nic->vring[idx].last_used_idx = 0;
>>>> -}
>>>> -
>>>>   int ef100_vdpa_init_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>>   {
>>>>          u32 offset;
>>>> @@ -103,6 +90,236 @@ static bool is_qid_invalid(struct
>>>> ef100_vdpa_nic *vdpa_nic, u16 idx,
>>>>          return false;
>>>>   }
>>>>
>>>> +static void irq_vring_fini(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>> +{
>>>> +       struct ef100_vdpa_vring_info *vring = &vdpa_nic->vring[idx];
>>>> +       struct pci_dev *pci_dev = vdpa_nic->efx->pci_dev;
>>>> +
>>>> +       devm_free_irq(&pci_dev->dev, vring->irq, vring);
>>>> +       vring->irq = -EINVAL;
>>>> +}
>>>> +
>>>> +static irqreturn_t vring_intr_handler(int irq, void *arg)
>>>> +{
>>>> +       struct ef100_vdpa_vring_info *vring = arg;
>>>> +
>>>> +       if (vring->cb.callback)
>>>> +               return vring->cb.callback(vring->cb.private);
>>>> +
>>>> +       return IRQ_NONE;
>>>> +}
>>>> +
>>>> +static int ef100_vdpa_irq_vectors_alloc(struct pci_dev *pci_dev,
>>>> u16 nvqs)
>>>> +{
>>>> +       int rc;
>>>> +
>>>> +       rc = pci_alloc_irq_vectors(pci_dev, nvqs, nvqs, PCI_IRQ_MSIX);
>>>> +       if (rc < 0)
>>>> +               pci_err(pci_dev,
>>>> +                       "Failed to alloc %d IRQ vectors, err:%d\n",
>>>> nvqs, rc);
>>>> +       return rc;
>>>> +}
>>>> +
>>>> +void ef100_vdpa_irq_vectors_free(void *data)
>>>> +{
>>>> +       pci_free_irq_vectors(data);
>>>> +}
>>>> +
>>>> +static int irq_vring_init(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>> +{
>>>> +       struct ef100_vdpa_vring_info *vring = &vdpa_nic->vring[idx];
>>>> +       struct pci_dev *pci_dev = vdpa_nic->efx->pci_dev;
>>>> +       int irq;
>>>> +       int rc;
>>>> +
>>>> +       snprintf(vring->msix_name, 256, "x_vdpa[%s]-%d\n",
>>>> +                pci_name(pci_dev), idx);
>>>> +       irq = pci_irq_vector(pci_dev, idx);
>>>> +       rc = devm_request_irq(&pci_dev->dev, irq,
>>>> vring_intr_handler, 0,
>>>> +                             vring->msix_name, vring);
>>>> +       if (rc)
>>>> +               pci_err(pci_dev,
>>>> +                       "devm_request_irq failed for vring %d, rc
>>>> %d\n",
>>>> +                       idx, rc);
>>>> +       else
>>>> +               vring->irq = irq;
>>>> +
>>>> +       return rc;
>>>> +}
>>>> +
>>>> +static int delete_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>> +{
>>>> +       struct efx_vring_dyn_cfg vring_dyn_cfg;
>>>> +       int rc;
>>>> +
>>>> +       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>>>> +               return 0;
>>>> +
>>>> +       rc = efx_vdpa_vring_destroy(vdpa_nic->vring[idx].vring_ctx,
>>>> +                                   &vring_dyn_cfg);
>>>> +       if (rc)
>>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>>> +                       "%s: delete vring failed index:%u, err:%d\n",
>>>> +                       __func__, idx, rc);
>>>> +       vdpa_nic->vring[idx].last_avail_idx = vring_dyn_cfg.avail_idx;
>>>> +       vdpa_nic->vring[idx].last_used_idx = vring_dyn_cfg.used_idx;
>>>> +       vdpa_nic->vring[idx].vring_state &= ~EF100_VRING_CREATED;
>>>> +
>>>> +       irq_vring_fini(vdpa_nic, idx);
>>>> +
>>>> +       return rc;
>>>> +}
>>>> +
>>>> +static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +       u32 idx_val;
>>>> +
>>>> +       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>> +               return;
>>>> +
>>>> +       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>>>> +               return;
>>>> +
>>>> +       idx_val = idx;
>>>> +       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
>>>> + vdpa_nic->vring[idx].doorbell_offset);
>>>> +}
>>>> +
>>>> +static bool can_create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 
>>>> idx)
>>>> +{
>>>> +       if (vdpa_nic->vring[idx].vring_state ==
>>>> EF100_VRING_CONFIGURED &&
>>>> +           vdpa_nic->status & VIRTIO_CONFIG_S_DRIVER_OK &&
>>>> +           !(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>>>> +               return true;
>>>> +
>>>> +       return false;
>>>> +}
>>>> +
>>>> +static int create_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>> +{
>>>> +       struct efx_vring_dyn_cfg vring_dyn_cfg;
>>>> +       struct efx_vring_cfg vring_cfg;
>>>> +       int rc;
>>>> +
>>>> +       rc = irq_vring_init(vdpa_nic, idx);
>>>> +       if (rc) {
>>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>>> +                       "%s: irq_vring_init failed. index:%u,
>>>> err:%d\n",
>>>> +                       __func__, idx, rc);
>>>> +               return rc;
>>>> +       }
>>>> +       vring_cfg.desc = vdpa_nic->vring[idx].desc;
>>>> +       vring_cfg.avail = vdpa_nic->vring[idx].avail;
>>>> +       vring_cfg.used = vdpa_nic->vring[idx].used;
>>>> +       vring_cfg.size = vdpa_nic->vring[idx].size;
>>>> +       vring_cfg.features = vdpa_nic->features;
>>>> +       vring_cfg.msix_vector = idx;
>>>> +       vring_dyn_cfg.avail_idx = vdpa_nic->vring[idx].last_avail_idx;
>>>> +       vring_dyn_cfg.used_idx = vdpa_nic->vring[idx].last_used_idx;
>>>> +
>>>> +       rc = efx_vdpa_vring_create(vdpa_nic->vring[idx].vring_ctx,
>>>> +                                  &vring_cfg, &vring_dyn_cfg);
>>>> +       if (rc) {
>>>> +               dev_err(&vdpa_nic->vdpa_dev.dev,
>>>> +                       "%s: vring_create failed index:%u, err:%d\n",
>>>> +                       __func__, idx, rc);
>>>> +               goto err_vring_create;
>>>> +       }
>>>> +       vdpa_nic->vring[idx].vring_state |= EF100_VRING_CREATED;
>>>> +
>>>> +       /* A VQ kick allows the device to read the avail_idx, which
>>>> will be
>>>> +        * required at the destination after live migration.
>>>> +        */
>>>> +       ef100_vdpa_kick_vq(&vdpa_nic->vdpa_dev, idx);
>>>> +
>>>> +       return 0;
>>>> +
>>>> +err_vring_create:
>>>> +       irq_vring_fini(vdpa_nic, idx);
>>>> +       return rc;
>>>> +}
>>>> +
>>>> +static void reset_vring(struct ef100_vdpa_nic *vdpa_nic, u16 idx)
>>>> +{
>>>> +       delete_vring(vdpa_nic, idx);
>>>> +       vdpa_nic->vring[idx].vring_type = EF100_VDPA_VQ_NTYPES;
>>>> +       vdpa_nic->vring[idx].vring_state = 0;
>>>> +       vdpa_nic->vring[idx].last_avail_idx = 0;
>>>> +       vdpa_nic->vring[idx].last_used_idx = 0;
>>>> +}
>>>> +
>>>> +static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>>> +{
>>>> +       int i;
>>>> +
>>>> +       WARN_ON(!mutex_is_locked(&vdpa_nic->lock));
>>>> +
>>>> +       if (!vdpa_nic->status)
>>>> +               return;
>>>> +
>>>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
>>>> +       vdpa_nic->status = 0;
>>>> +       vdpa_nic->features = 0;
>>>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
>>>> +               reset_vring(vdpa_nic, i);
>>>> + ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
>>>> +}
>>>> +
>>>> +/* May be called under the rtnl lock */
>>>> +int ef100_vdpa_reset(struct vdpa_device *vdev)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +
>>>> +       /* vdpa device can be deleted anytime but the bar_config
>>>> +        * could still be vdpa and hence efx->state would be
>>>> STATE_VDPA.
>>>> +        * Accordingly, ensure vdpa device exists before reset 
>>>> handling
>>>> +        */
>>>> +       if (!vdpa_nic)
>>>> +               return -ENODEV;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->lock);
>>>> +       ef100_reset_vdpa_device(vdpa_nic);
>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int start_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
>>>> +{
>>>> +       struct efx_nic *efx = vdpa_nic->efx;
>>>> +       struct ef100_nic_data *nic_data;
>>>> +       int i, j;
>>>> +       int rc;
>>>> +
>>>> +       nic_data = efx->nic_data;
>>>> +       rc = ef100_vdpa_irq_vectors_alloc(efx->pci_dev,
>>>> + vdpa_nic->max_queue_pairs * 2);
>>>> +       if (rc < 0) {
>>>> +               pci_err(efx->pci_dev,
>>>> +                       "vDPA IRQ alloc failed for vf: %u err:%d\n",
>>>> +                       nic_data->vf_index, rc);
>>>> +               return rc;
>>>> +       }
>>>> +
>>>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>>>> +               if (can_create_vring(vdpa_nic, i)) {
>>>> +                       rc = create_vring(vdpa_nic, i);
>>>> +                       if (rc)
>>>> +                               goto clear_vring;
>>>> +               }
>>>> +       }
>>>> +
>>>> +       vdpa_nic->vdpa_state = EF100_VDPA_STATE_STARTED;
>>> It looks to me that this duplicates with the DRIVER_OK status bit.
>> vdpa_state is set EF100_VDPA_STATE_STARTED during DRIVER_OK handling.
>> See my later response for its purpose.
>>>
>>>> +       return 0;
>>>> +
>>>> +clear_vring:
>>>> +       for (j = 0; j < i; j++)
>>>> +               delete_vring(vdpa_nic, j);
>>>> +
>>>> +       ef100_vdpa_irq_vectors_free(efx->pci_dev);
>>>> +       return rc;
>>>> +}
>>>> +
>>>>   static int ef100_vdpa_set_vq_address(struct vdpa_device *vdev,
>>>>                                       u16 idx, u64 desc_area, u64
>>>> driver_area,
>>>>                                       u64 device_area)
>>>> @@ -144,22 +361,6 @@ static void ef100_vdpa_set_vq_num(struct
>>>> vdpa_device *vdev, u16 idx, u32 num)
>>>>          mutex_unlock(&vdpa_nic->lock);
>>>>   }
>>>>
>>>> -static void ef100_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
>>>> -{
>>>> -       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> -       u32 idx_val;
>>>> -
>>>> -       if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>> -               return;
>>>> -
>>>> -       if (!(vdpa_nic->vring[idx].vring_state & EF100_VRING_CREATED))
>>>> -               return;
>>>> -
>>>> -       idx_val = idx;
>>>> -       _efx_writed(vdpa_nic->efx, cpu_to_le32(idx_val),
>>>> - vdpa_nic->vring[idx].doorbell_offset);
>>>> -}
>>>> -
>>>>   static void ef100_vdpa_set_vq_cb(struct vdpa_device *vdev, u16 idx,
>>>>                                   struct vdpa_callback *cb)
>>>>   {
>>>> @@ -176,6 +377,7 @@ static void ef100_vdpa_set_vq_ready(struct
>>>> vdpa_device *vdev, u16 idx,
>>>>                                      bool ready)
>>>>   {
>>>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +       int rc;
>>>>
>>>>          if (is_qid_invalid(vdpa_nic, idx, __func__))
>>>>                  return;
>>>> @@ -184,9 +386,21 @@ static void ef100_vdpa_set_vq_ready(struct
>>>> vdpa_device *vdev, u16 idx,
>>>>          if (ready) {
>>>>                  vdpa_nic->vring[idx].vring_state |=
>>>> EF100_VRING_READY_CONFIGURED;
>>>> +               if (vdpa_nic->vdpa_state == 
>>>> EF100_VDPA_STATE_STARTED &&
>>>> +                   can_create_vring(vdpa_nic, idx)) {
>>>> +                       rc = create_vring(vdpa_nic, idx);
>>>> +                       if (rc)
>>>> +                               /* Rollback ready configuration
>>>> +                                * So that the above layer driver
>>>> +                                * can make another attempt to set
>>>> ready
>>>> +                                */
>>>> + vdpa_nic->vring[idx].vring_state &=
>>>> + ~EF100_VRING_READY_CONFIGURED;
>>>> +               }
>>>>          } else {
>>>>                  vdpa_nic->vring[idx].vring_state &=
>>>> ~EF100_VRING_READY_CONFIGURED;
>>>> +               delete_vring(vdpa_nic, idx);
>>>>          }
>>>>          mutex_unlock(&vdpa_nic->lock);
>>>>   }
>>>> @@ -296,6 +510,12 @@ static u64
>>>> ef100_vdpa_get_device_features(struct vdpa_device *vdev)
>>>>          }
>>>>
>>>>          features |= BIT_ULL(VIRTIO_NET_F_MAC);
>>>> +       /* As QEMU SVQ doesn't implement the following features,
>>>> +        * masking them off to allow Live Migration
>>>> +        */
>>>> +       features &= ~BIT_ULL(VIRTIO_F_IN_ORDER);
>>>> +       features &= ~BIT_ULL(VIRTIO_F_ORDER_PLATFORM);
>>> It's better not to work around userspace bugs in the kernel. We should
>>> fix Qemu instead.
>>
>> There's already a QEMU patch [1] submitted to support
>> VIRTIO_F_ORDER_PLATFORM but it hasn't concluded yet. Also, there is no
>> support for VIRTIO_F_IN_ORDER in the kernel virtio driver. The motive
>> of this change is to have VM Live Migration working with the kernel
>> in-tree driver without requiring any changes.
>>
>> Once QEMU is able to handle these features, we can submit a patch to
>> undo these changes.
>
>
> I can understand the motivation, but it works for prototyping but not
> formal kernel code (especially consider SVQ is not mature and still
> being development). What's more, we can not assume Qemu is the only
> user, we have other users like DPDK and cloud-hypervisors.

Ok, if the expectation is to have the user deal with the issues and make 
required changes on the in-tree driver to make it work, I'll remove this 
part.

>
> Thanks
>
>
>>
>>>
>>>> +
>>>>          return features;
>>>>   }
>>>>
>>>> @@ -356,6 +576,77 @@ static u32 ef100_vdpa_get_vendor_id(struct
>>>> vdpa_device *vdev)
>>>>          return EF100_VDPA_VENDOR_ID;
>>>>   }
>>>>
>>>> +static u8 ef100_vdpa_get_status(struct vdpa_device *vdev)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +       u8 status;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->lock);
>>>> +       status = vdpa_nic->status;
>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>> +       return status;
>>>> +}
>>>> +
>>>> +static void ef100_vdpa_set_status(struct vdpa_device *vdev, u8 
>>>> status)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +       u8 new_status;
>>>> +       int rc;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->lock);
>>>> +       if (!status) {
>>>> +               dev_info(&vdev->dev,
>>>> +                        "%s: Status received is 0. Device reset
>>>> being done\n",
>>>> +                        __func__);
>>> This is trigger-able by the userspace. It might be better to use
>>> dev_dbg() instead.
>> Will change.
>>>
>>>> + ef100_reset_vdpa_device(vdpa_nic);
>>>> +               goto unlock_return;
>>>> +       }
>>>> +       new_status = status & ~vdpa_nic->status;
>>>> +       if (new_status == 0) {
>>>> +               dev_info(&vdev->dev,
>>>> +                        "%s: New status same as current status\n",
>>>> __func__);
>>> Same here.
>> Ok.
>>>
>>>> +               goto unlock_return;
>>>> +       }
>>>> +       if (new_status & VIRTIO_CONFIG_S_FAILED) {
>>>> +               ef100_reset_vdpa_device(vdpa_nic);
>>>> +               goto unlock_return;
>>>> +       }
>>>> +
>>>> +       if (new_status & VIRTIO_CONFIG_S_ACKNOWLEDGE) {
>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
>>>> +               new_status &= ~VIRTIO_CONFIG_S_ACKNOWLEDGE;
>>>> +       }
>>>> +       if (new_status & VIRTIO_CONFIG_S_DRIVER) {
>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER;
>>>> +               new_status &= ~VIRTIO_CONFIG_S_DRIVER;
>>>> +       }
>>>> +       if (new_status & VIRTIO_CONFIG_S_FEATURES_OK) {
>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_FEATURES_OK;
>>>> +               vdpa_nic->vdpa_state = EF100_VDPA_STATE_NEGOTIATED;
>>> It might be better to explain the reason we need to track another
>>> state in vdpa_state instead of simply using the device status.
>> vdpa_state helps to ensure correct status transitions in the
>> .set_status callback and safe-guards against incorrect/malicious
>> user-space driver.
>
>
> Ok, let's document this in the definition of vdpa_state.
Sure, will do.
>
>
>>>
>>>> +               new_status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
>>>> +       }
>>>> +       if (new_status & VIRTIO_CONFIG_S_DRIVER_OK &&
>>>> +           vdpa_nic->vdpa_state == EF100_VDPA_STATE_NEGOTIATED) {
>>>> +               vdpa_nic->status |= VIRTIO_CONFIG_S_DRIVER_OK;
>>>> +               rc = start_vdpa_device(vdpa_nic);
>>>> +               if (rc) {
>>>> + dev_err(&vdpa_nic->vdpa_dev.dev,
>>>> +                               "%s: vDPA device failed:%d\n",
>>>> __func__, rc);
>>>> +                       vdpa_nic->status &= 
>>>> ~VIRTIO_CONFIG_S_DRIVER_OK;
>>>> +                       goto unlock_return;
>>>> +               }
>>>> +               new_status &= ~VIRTIO_CONFIG_S_DRIVER_OK;
>>>> +       }
>>>> +       if (new_status) {
>>>> +               dev_warn(&vdev->dev,
>>>> +                        "%s: Mismatch Status: %x & State: %u\n",
>>>> +                        __func__, new_status, vdpa_nic->vdpa_state);
>>>> +       }
>>>> +
>>>> +unlock_return:
>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>> +}
>>>> +
>>>>   static size_t ef100_vdpa_get_config_size(struct vdpa_device *vdev)
>>>>   {
>>>>          return sizeof(struct virtio_net_config);
>>>> @@ -393,6 +684,20 @@ static void ef100_vdpa_set_config(struct
>>>> vdpa_device *vdev, unsigned int offset,
>>>>                  vdpa_nic->mac_configured = true;
>>>>   }
>>>>
>>>> +static int ef100_vdpa_suspend(struct vdpa_device *vdev)
>>>> +{
>>>> +       struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> +       int i, rc;
>>>> +
>>>> +       mutex_lock(&vdpa_nic->lock);
>>>> +       for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++) {
>>>> +               rc = delete_vring(vdpa_nic, i);
>>> Note that the suspension matters for the whole device. It means the
>>> config space should not be changed. But the code here only suspends
>>> the vring, is this intende/d?
>> Are you referring to the possibility of updating device configuration
>> (eg. MAC address) using .set_config() after suspend operation? Is
>> there any other user triggered operation that falls in this category?
>
>
> Updating MAC should be prohibited, one typical use case is the link 
> status.
I think this can be dealt with an additional SUSPEND state which can be 
used to avoid any changes to the config space.
>
>
>>>
>>> Reset may have the same issue.
>> Could you pls elaborate on the requirement during device reset?
>
>
> I meant ef100_reset_vdpa_device() may suffer from the same issue:
>
> It only reset all the vring but not the config space?

Ok, I think resetting config space would basically be clearing the 
memory for vdpa_nic->net_config which is the initial state after vdpa 
device allocation.

Gautam

>
> Thanks
>
>
>>>
>>> Thanks
>> [1]
>> https://patchew.org/QEMU/20230213191929.1547497-1-eperezma@redhat.com/
>>>
>>>> +               if (rc)
>>>> +                       break;
>>>> +       }
>>>> +       mutex_unlock(&vdpa_nic->lock);
>>>> +       return rc;
>>>> +}
>>>>   static void ef100_vdpa_free(struct vdpa_device *vdev)
>>>>   {
>>>>          struct ef100_vdpa_nic *vdpa_nic = get_vdpa_nic(vdev);
>>>> @@ -428,9 +733,13 @@ const struct vdpa_config_ops
>>>> ef100_vdpa_config_ops = {
>>>>          .get_vq_num_max      = ef100_vdpa_get_vq_num_max,
>>>>          .get_device_id       = ef100_vdpa_get_device_id,
>>>>          .get_vendor_id       = ef100_vdpa_get_vendor_id,
>>>> +       .get_status          = ef100_vdpa_get_status,
>>>> +       .set_status          = ef100_vdpa_set_status,
>>>> +       .reset               = ef100_vdpa_reset,
>>>>          .get_config_size     = ef100_vdpa_get_config_size,
>>>>          .get_config          = ef100_vdpa_get_config,
>>>>          .set_config          = ef100_vdpa_set_config,
>>>>          .get_generation      = NULL,
>>>> +       .suspend             = ef100_vdpa_suspend,
>>>>          .free                = ef100_vdpa_free,
>>>>   };
>>>> -- 
>>>> 2.30.1
>>>>
>>
>
