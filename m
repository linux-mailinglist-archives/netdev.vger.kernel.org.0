Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0213A64943F
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 13:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiLKMyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 07:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiLKMyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 07:54:37 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472C511162;
        Sun, 11 Dec 2022 04:54:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5geqrtMeXLyBWwBm3jCysXaGerdhTNSTJ4kshp8ZB5fyeVtQ3ugDDGy0Qann8HQjYwIKg1aTDokHFpnm2PLgqJOE5dkEzLsuyzNgXRaqXxku5hdQbi7C0v3+zNhbGyO4CJRohiiAtEibrQYTIoFxOrelCWJVr6H1MYpDuDKaB3W3SZJICWlxIQAqrpMSOG5nnP+E7BxIt6FYBSL64NLj/aSbr1JGgKEmqbvS8bba4Cw433t083nn67E/wSj9TozQ+eco/Ac8OVryM5F4AXQN85gslcnYwJYvgoi87wMAbn8BN1qJ5NSYYAas8zn2g4pydFPF3w8FLo9zIolpocspQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9aV8Q2x2+ld/tqSjwgtwrlQQc9sz92fJV5OjBSDya1o=;
 b=MTbj4BRe4R/pFLl4v+L44an2naB/MV6wpSxZDoBXOKwljEV6xXGiHqCT/DsSjH9/Ifc2vkZt9FS+Xs9+vURB5QUPaXWPezINRcp7tdeev1QWVdExZs7n6Bq1xwvQbVDyc48Tn5JgQlqV9WoAYQSKE1hEfbbOYJjPFSARIs5BSg6HyIrvY+U0vcs6SJD15+tfvLgNQRq7ffs7tb+cGBmmOVhErnJsLQZMdh5veRwSOj5Gqm0KXFMtvJSbiTE2I+3w0uy+i+FKeyJopWNbQYBLpJXGlixymT/mJ8eCl8kwCv7mMZwtC+HRAg1XBOqkRzyWHSMy8EcjsxcTUwjDCMgwiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9aV8Q2x2+ld/tqSjwgtwrlQQc9sz92fJV5OjBSDya1o=;
 b=MFLHO0gCYyX7CYOBurUP0DRic3VY98Lo5+NdLGWgF1VMyHi6NiVNi1cyTi6NP7WVFJfVNBeHfdVBKzv0vTaIpIxHanooZvHFOAUYvvcVKapKUOuJnFZ2LUjgSpByRDnyp2l9QZ5eAKRQhfyL7J4wVByB7LcwAiU167hoUP4s8LFjKc791hukqkPOQow5dXAGltJhCcpg216JyPoGv+hO2LoAeTBsCO7dRTtgAEzpj1IOYHEURIq0e2opEuxrofUuGL8u49oDSKsR8IkULA+YtYgPAyQWX/1Jn/wIJxNgtojLYlQFtWWhrbl698XxknnDcriq192GjzZoWf3LYkalJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by DS7PR12MB6144.namprd12.prod.outlook.com (2603:10b6:8:98::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Sun, 11 Dec 2022 12:54:34 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::3fb9:3266:7937:44fc%8]) with mapi id 15.20.5880.019; Sun, 11 Dec 2022
 12:54:34 +0000
Message-ID: <1352e2f7-4822-4e49-cf3b-d8a9d537a172@nvidia.com>
Date:   Sun, 11 Dec 2022 14:54:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH vfio 0/7] pds vfio driver
Content-Language: en-US
To:     Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com
Cc:     shannon.nelson@amd.com, drivers@pensando.io,
        Oren Duer <oren@nvidia.com>
References: <20221207010705.35128-1-brett.creeley@amd.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20221207010705.35128-1-brett.creeley@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0104.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::11) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_|DS7PR12MB6144:EE_
X-MS-Office365-Filtering-Correlation-Id: 06475fbe-8fb4-43ee-6fb7-08dadb76da88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bqswmLZm5+OIgxl6P2HZBC4rxoC3h+aoUg8Kc7ymgnfG5dgCyRTw2/mViLv1zQXxhAEdWQCwlAu30reEWGEZgbOpivjaBipwtmM+Lu2kh/FqYeOXdgA/bhFi7ViPAyl2Q76nEBTk634QTyI0eFOKEdSR4zrKxtegxedVj4Nax3H2PPDyg7ePXDDtyMDCtxDSIcSCPr4NdfDv+qNHVrTyYWD7pc1fkmpqW7iOkzHEewIbZU8sSMgU3JJPaqL38TvWB2nBbws3/HjbraVxkyr1ssMTi9eJhG4i3BOtlufdImXD2iIstjpL6H73bsxwtGoW9TBDIKnhHUX6yPtKoJ0Z7OoncXtVeqBYFor9q8pNSDuO29AV9b0wQ0EcDm24d5JbsbJoN2jLGCTBBwdgL4V0wI+xf5s/46QjcGm4iJ/5wr3Gz2hC05jW9+rJQqbIKsagdF08l4i5pTQaE770i+v1UChyEKZrWPBsJ0LKmTOidXgt/3wFhAmYojzHA/xlsT4a2Z+Fxp3NGMoeA6YSMDAR55Sw7d5rL3I7u6aEi6tRPIAeKM/QQ2ZAD0+jofjdhNqZUsI9rZ7wgViYSYSwqxK5hwLYd2plPMlEb0ZHmXng81BOHSRKCuP86A9YJMU2ECmuHHIlieWLaqMtTL88zZMuOccU96M1QW+E1E1e/caF6Md/an9gyQ3+AJVfETdzhuDiPAB4Q2H7xy+VDHH7aY9EIpIv+S5B7V5SWJlGHHUrJeonvDY/6EKBEv2JX1P6ewvsdimfwZO2z4wm3TESQ2tPkFmnOJLBcYvyDxZU7wd9rjv0r24JE/4d6LH3Ludl36hT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(451199015)(36756003)(2906002)(107886003)(41300700001)(478600001)(6666004)(966005)(6486002)(38100700002)(31696002)(86362001)(5660300002)(53546011)(2616005)(31686004)(316002)(66476007)(66946007)(8676002)(4326008)(66556008)(26005)(83380400001)(186003)(8936002)(6506007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2diZmp6ZytmVFdVWHdXb09MZHBlbDFxT2NGK3RIR3R1NzkxVEpuYnhwK2hi?=
 =?utf-8?B?L3FqMVFPUHJJQnF1STlFa0k3SmFrd1JHdGJta2hnY2lOMS9GRWNsRjBLL3lu?=
 =?utf-8?B?bU1lN0Yya3hoOFpEOGs2NGdlbW9KWVc4NnlWbDltalhMZjFISTJHNG9SUDNp?=
 =?utf-8?B?eWlFdU9oQ01VUm5jajVkNFFuKzZkYWdWQVZCVCt4Uk1qdlBxb1FwbUgxQmww?=
 =?utf-8?B?YWFSaFVnWldZTW54ZUI5OTh2WXBIRWF4SDZRQ2cxZ0w3cGVmNFJ6QzBOcDAv?=
 =?utf-8?B?THFJMEZwUU9pVmpYR3U2N1VBN0J3NHdaRDNEZ0FuY3BUbG5oL0FEb2lmTE5Z?=
 =?utf-8?B?dkRHZmt0Q05qdXpFUVN5K0s2VDZhT0hEcFFKQWE5Mlc2dXVKSkNNeTdidEZi?=
 =?utf-8?B?TklRK0VrbFdPeEdzaldpVVFaY3llMXhOZUhjeUhwNW91Z25nRmRkMVBKSnl2?=
 =?utf-8?B?VWFsb3VNR05SSHdwQlFzamRnbFRrWEFCbVFaRk5wS0xQbmJoek1KTTZSUVIv?=
 =?utf-8?B?RXFxMTRxVm8vbkFFYm1BV1phb1BiU0pqTXRLb1Y5ZWtEWU1jZStGS3VCZjUr?=
 =?utf-8?B?aGlBenhMRlpHYTIxQzcrSGg1UE1VempiRnR3QXJZR2REOW15eU04NFp4b2dw?=
 =?utf-8?B?OFVWWmhocVpQY3pUbUMxN3YvTTUvR2haY1lCMFRDZm1QbDcxTC92OVVvR2hV?=
 =?utf-8?B?d0dYVGV5bUY1czdkbUdFMDlhL1FKSUMvdk5BSHpTMlYyZEpDeDRTbmUyRExl?=
 =?utf-8?B?RW4weHJEbU1DbERzVFZHSjBZUFhOOGIrY1dSaVNKcS9uVFpnZzEwN3pxdDNP?=
 =?utf-8?B?MXVvY1Nsc0FJcDRyS0NiWFI4RWtweUpzeVB6UlNJdE1CcU04TVJsdUdDUHk0?=
 =?utf-8?B?UURWYy9yU2xhMlZtUjJaU2h1aVBqaUJqcHp0WWlNS244c1A5R1F4bStxQS9N?=
 =?utf-8?B?TUxZendNMDNoSWp1MEZsYjFtY3lzVzV2R2kzdlV1M1hJdi9Bamw3NEprbjQ5?=
 =?utf-8?B?ekV4TGgvS3d4Y0UvbWY1OGYvakNUTGhFMDVaK3FsMmpMYUpyWjJLM3FNQnp1?=
 =?utf-8?B?MWVXVUR1TS9VeHFraVdpalNDNEd5Q1ZFYk9pR2w5d3dpSVArYVBNRzdrclNW?=
 =?utf-8?B?NUpheTJBd2IwZm5OMWMxZVBRbVd2ZUdQNlYybktZUER6OWNVU3hZazAyVkc3?=
 =?utf-8?B?VEFZNXIreG9WcytBQ1B1SndmYjdaVFdqVEQvWDlWYUlSQ29oWFVCY0p1eEtl?=
 =?utf-8?B?R0YwVFpGV21OZldUNW5wVW9VU0pVWWx2VUcrUFVycFZiY2dtVzN6aWFYKzZ1?=
 =?utf-8?B?OUdDcjdCUllYSEdnaFRJdlVObkU4QXVuZm9TQUtPT2RCTXJ6RURpYVZySEIv?=
 =?utf-8?B?TXJFVnNaVk9xVUQzamVRSlVDQVpCSG9vODBwb1h4bkVpWXRKT05TRCtVMllz?=
 =?utf-8?B?OGM1VHc5dU83MklVK2ZWV0tCbnBqN2RhdXd5TVRHdzJPRnlGdlZjemN3K1Nz?=
 =?utf-8?B?VDRxS29vV3F6cjkxcHRwNm04bHhraFJnbm9iWlhJcTA3emxySlY3ak5jWUsw?=
 =?utf-8?B?U3hCQW0zNTc1eGtwRjR6VUQ0RzA4bWM5NldubmxVZTZuQ0F2MW5ZWWJ0dWYr?=
 =?utf-8?B?c3phcFEwY1crTFhWMUtYb1FrTXA5elJhQXIrb1Izcy9ZNFZnMW11dklncG5G?=
 =?utf-8?B?UWJPSFZrRWowY0k3Z2k5S3dqblorV0tpK2JYdW15elVsTEpUUU5lOFdUU0gz?=
 =?utf-8?B?eVlvay96OHV0WUpqdFBsWXplOVpLdXMvbU0vYmZDanlWVlAzRHZoT21mak1r?=
 =?utf-8?B?Z0VnOU0vQXd3MVJIRmgxVzFpdzZzQmtmUGx1T0N4dDk1YUNQTUJCUmhxb3F3?=
 =?utf-8?B?aXJFZ3MvdGM1ZmxNTzBmeWhXRkM1V2l6M1R1NHBqM3ZUU0ZLWGxyRG5qL0JY?=
 =?utf-8?B?THp3OUlHeEVqeXF2cGVzNWJ0alFQeVZlc1VDTmhIeGx3TVAxdFZua3BYNmxB?=
 =?utf-8?B?M1U0TGVxbnVId1NEcU42cENVSTZuS1FVRGtJWWJWTGlZS0hHbWNvazRwbUZI?=
 =?utf-8?B?bmJLak5IckxiM01IOEgyYzg3ZlBtaUJFVkp6UHVWS1NWQk1HaVpuY0R2ak55?=
 =?utf-8?B?YXZnWDN2aVFwMDhrTjJpYmgzSWUzWnIrSWEyQTJkbkpOVlBobzhOUEFwdDFO?=
 =?utf-8?B?Y2c9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06475fbe-8fb4-43ee-6fb7-08dadb76da88
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2022 12:54:34.7844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jeDuiiGvBdSAsQKf82JanMcc3kZtpNN3hXYj5Qg526LDxiKf2pU1JRPv9mWJONL3kXpMvSCOyRNZGHVdcQUasA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6144
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/7/2022 3:06 AM, Brett Creeley wrote:
> This is a first draft patchset for a new vendor specific VFIO driver for
> use with the AMD/Pensando Distributed Services Card (DSC). This driver
> (pds_vfio) is a client of the newly introduced pds_core driver.
>
> Reference to the pds_core patchset:
> https://lore.kernel.org/netdev/20221207004443.33779-1-shannon.nelson@amd.com/
>
> AMD/Pensando already supports a NVMe VF device (1dd8:1006) in the
> Distributed Services Card (DSC). This patchset adds the new pds_vfio
> driver in order to support NVMe VF live migration.
>
> This driver will use the pds_core device and auxiliary_bus as the VFIO
> control path to the DSC. The pds_core device creates auxiliary_bus devices
> for each live migratable VF. The devices are named by their feature plus
> the VF PCI BDF so the auxiliary_bus driver implemented by pds_vfio can find
> its related VF PCI driver instance. Once this auxiliary bus connection
> is configured, the pds_vfio driver can send admin queue commands to the
> device and receive events from pds_core.
>
> An ASCII diagram of a VFIO instance looks something like this and can
> be used with the VFIO subsystem to provide devices VFIO and live
> migration support.
>
>                                 .------.  .--------------------------.
>                                 | QEMU |--|  VM     .-------------.  |
>                                 '......'  |         | nvme driver |  |
>                                    |      |         .-------------.  |
>                                    |      |         |  SR-IOV VF  |  |
>                                    |      |         '-------------'  |
>                                    |      '---------------||---------'
>                                 .--------------.          ||
>                                 |/dev/<vfio_fd>|          ||
>                                 '--------------'          ||
> Host Userspace                         |                 ||
> ===================================================      ||
> Host Kernel                            |                 ||
>                                         |                 ||
>             pds_core.LM.2305 <--+   .--------.            ||
>                     |           |   |vfio-pci|            ||
>                     |           |   '--------'            ||
>                     |           |       |                 ||
>           .------------.       .-------------.            ||
>           |  pds_core  |       |   pds_vfio  |            ||
>           '------------'       '-------------'            ||
>                 ||                   ||                   ||
>               09:00.0              09:00.1                ||
> == PCI ==================================================||=====
>                 ||                   ||                   ||
>            .----------.         .----------.              ||
>      ,-----|    PF    |---------|    VF    |-------------------,
>      |     '----------'         '----------'  |      nvme      |
>      |                     DSC                |  data/control  |
>      |                                        |      path      |
>      -----------------------------------------------------------

Hi Brett,

what is the class code of the pds_core device ?

I see that pds_vfio class_code is PCI_CLASS_STORAGE_EXPRESS.

>
>
> The pds_vfio driver is targeted to reside in drivers/vfio/pci/pds.
> It makes use of and introduces new files in the common include/linux/pds
> include directory.
>
> Brett Creeley (7):
>    pds_vfio: Initial support for pds_vfio VFIO driver
>    pds_vfio: Add support to register as PDS client
>    pds_vfio: Add VFIO live migration support
>    vfio: Commonize combine_ranges for use in other VFIO drivers
>    pds_vfio: Add support for dirty page tracking
>    pds_vfio: Add support for firmware recovery
>    pds_vfio: Add documentation files
>
>   .../ethernet/pensando/pds_vfio.rst            |  88 +++
>   drivers/vfio/pci/Kconfig                      |   2 +
>   drivers/vfio/pci/mlx5/cmd.c                   |  48 +-
>   drivers/vfio/pci/pds/Kconfig                  |  10 +
>   drivers/vfio/pci/pds/Makefile                 |  12 +
>   drivers/vfio/pci/pds/aux_drv.c                | 216 +++++++
>   drivers/vfio/pci/pds/aux_drv.h                |  30 +
>   drivers/vfio/pci/pds/cmds.c                   | 486 ++++++++++++++++
>   drivers/vfio/pci/pds/cmds.h                   |  44 ++
>   drivers/vfio/pci/pds/dirty.c                  | 541 ++++++++++++++++++
>   drivers/vfio/pci/pds/dirty.h                  |  49 ++
>   drivers/vfio/pci/pds/lm.c                     | 484 ++++++++++++++++
>   drivers/vfio/pci/pds/lm.h                     |  53 ++
>   drivers/vfio/pci/pds/pci_drv.c                | 134 +++++
>   drivers/vfio/pci/pds/pci_drv.h                |   9 +
>   drivers/vfio/pci/pds/vfio_dev.c               | 238 ++++++++
>   drivers/vfio/pci/pds/vfio_dev.h               |  42 ++
>   drivers/vfio/vfio_main.c                      |  48 ++
>   include/linux/pds/pds_core_if.h               |   1 +
>   include/linux/pds/pds_lm.h                    | 356 ++++++++++++
>   include/linux/vfio.h                          |   3 +
>   21 files changed, 2847 insertions(+), 47 deletions(-)
>   create mode 100644 Documentation/networking/device_drivers/ethernet/pensando/pds_vfio.rst
>   create mode 100644 drivers/vfio/pci/pds/Kconfig
>   create mode 100644 drivers/vfio/pci/pds/Makefile
>   create mode 100644 drivers/vfio/pci/pds/aux_drv.c
>   create mode 100644 drivers/vfio/pci/pds/aux_drv.h
>   create mode 100644 drivers/vfio/pci/pds/cmds.c
>   create mode 100644 drivers/vfio/pci/pds/cmds.h
>   create mode 100644 drivers/vfio/pci/pds/dirty.c
>   create mode 100644 drivers/vfio/pci/pds/dirty.h
>   create mode 100644 drivers/vfio/pci/pds/lm.c
>   create mode 100644 drivers/vfio/pci/pds/lm.h
>   create mode 100644 drivers/vfio/pci/pds/pci_drv.c
>   create mode 100644 drivers/vfio/pci/pds/pci_drv.h
>   create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
>   create mode 100644 drivers/vfio/pci/pds/vfio_dev.h
>   create mode 100644 include/linux/pds/pds_lm.h
>
> --
> 2.17.1
>
