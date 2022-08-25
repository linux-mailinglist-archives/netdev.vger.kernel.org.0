Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2515B5A097B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 09:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiHYHIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 03:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236668AbiHYHIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 03:08:43 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B5E9E6A7
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 00:08:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJWP+n3Bl74C7SPZU2MQH/eQiPl9HY97cQ23mYNHcSjWHUmvGD8wR/lKqh2PdnVeAXWUFen79hMF1yHhI4/bcumNHy1/2hj08n+z7ZtKhRxKRgz0N88zinXfs3c/HnUEkLh5RZgXgm7BlA8fZXlW8lh3fU0DqFRpDiY23pnkNX3KSpQVaYuYi+LuWKX2QOgXc6N1y5IrJ2VtW6U28JLmWpdfnzXBpTIj2dCgOiayvoxqqriVcr271V1WgHEQSayKJSeU+psTRLzkdCqz47elGsCXAOKWFXHcTffnJRm9fqlAtQx1V5IBQsLhjDp7+tQZT0YFSYGDi3eCoClPKPjRQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMJxX0nyRxQgB3D4Smh1Ot+DqGJeByyfxABz9pGFbJA=;
 b=fT5upPkSSw8pis6hBb9kYTHs3oJeuWQzcTnnv59oeUHkIK90CFt8A/SQm4IMQtbaEjfF7pkH1xn1f/uHmGIGxHBx4fUiDeFPZyeVp3VfRF8mLOUXTD0n1On7aM2DUd9vmCDajyoI4hOIs0iBPtsKK7NnXmDGntEBd5cAxNleJKbOQu5jxQPcwb/Tt8iZ6QeEIUkK5RhqsYBsUAU+aOLG1sfbBO/Hd2oart3T35woJkyGLL93/2Z/+Lx6rkyix/lxfC6GbSnVXdAJ6jzmcJGNgXskR8PrnfJ0hQ/kbMgDvD6+A8h23ELpMS5RBlVll8zO+/nroPDJA42EjZcwmMjv7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMJxX0nyRxQgB3D4Smh1Ot+DqGJeByyfxABz9pGFbJA=;
 b=BTQmyOLY4Swp/+2ed/XUW1FZz46fRRro5JjBx8XAqm60LeVSKbVhK0o+bK/Viot1SzyxLyVxNnEQV4O6wPAP13nC0kTZ5KehULkW8+qTMt3OHAZdloEl3jn3NabEjkQWG47Ey/7GpLXYE/1IFmbR/XcnOnLgPJmmsyf47vNcLwipqRHmFSf6fxW5Hni7OH+UNYtiE0UpgeCfS85WnFVLN5rzBeusPP/5HNaad5gMaxp2B6EYyMkx3xWjFzVlOd4Jr9JmW1EGRLpJvB6vcY2ePDPZEuUv/37Rl/BVenNmLN+2GTqQ+bvh5K8M/nhzUSRKYI1usZaOBGHXjmNjKyoTKA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 MW2PR12MB2506.namprd12.prod.outlook.com (2603:10b6:907:7::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Thu, 25 Aug 2022 07:08:39 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58%9]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 07:08:39 +0000
Message-ID: <2602a3a2-0bb4-8da7-0691-aaa5566278dd@nvidia.com>
Date:   Thu, 25 Aug 2022 10:08:32 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
 <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
 <20220824092521.1a02d280@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220824092521.1a02d280@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0053.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::22) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5c89564-9d71-4aac-6c2f-08da8668a2cf
X-MS-TrafficTypeDiagnostic: MW2PR12MB2506:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /LLQ6Vt4ZXlVP01DgcsjeIweDwcZiZjPDnbBse1nBqKwsxk03oOU2EiRbNANmadyzd0yxeRZgR2vtDHkiPcyXsnwFjXNB8p5Aiz4Qgo2Opb0Arro2kLXOWfmlNIIgrCV8VsQH9dk2rmA0MAOJ+JHhhT26ahc1M5nWCI/NP9R7ZX1Hvd4Eb2vUcW5x8ZLkdpjlNkVglqTbNq4F4ZPHvgKRzeGiHZk249gPdcaxlaa2b5k382rWJg7utnh0Lv2DFURUwVyk6f4rSZa3hOX6eQivkl6zTZm3ahCFDVnMg6iOwLyk19AayImuq5zIOxZ4UyZbacJoNZXenVJUILjkHnhms2oKTp7/ErJWIhb4lQnNTgiU5mBfJJaFKloZU3ULC/H6s/v/KaNZFZ1ZeLumZnWEG3O4SGJS1iINvOTLUjKHSmtcmylshlA+EU2THQc7ponChdeuXoSeCGlqhpxsEg61oZ4d3rz6e6K6RACxy/E5HQ/tDeIzHGcVpOadfNhUbCkcWVXKouTeTLe04Hpo2HsL+SfvAIGZM5zbCENzM7b6/pvZb3Qx5MnzlEuq7IiovuCUj2++YRhstm/b3xD2xEU6DoGgM4TnSXJtAypenmH5BP16pZxXNltflgbivI/VJxRaXp7M6OshiJmMuyJ9yHVQmU9pFn06yL9R4xfyDtzegUOCL8OGA7TxVVdm5ilQWm5SuOI7sqouJp9oN8n87/lkIkugSgqSP8/0hCr06IJdSLI8gBxp407gBl82Cawx60BJfsCwvraHY41XNAvHY6tSdSVPtZxf0wGP6/OWxfd2fw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(41300700001)(53546011)(6506007)(2906002)(6666004)(31696002)(86362001)(8936002)(8676002)(66946007)(66556008)(66476007)(4326008)(478600001)(6486002)(5660300002)(2616005)(186003)(6512007)(26005)(38100700002)(316002)(54906003)(6916009)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWREWUlncnFMZGZsRWlGT3JhbHFQM3Z5TGFDYnVhelpidTk1VGJISlkzK0hv?=
 =?utf-8?B?VFo2b0taTUtyU25CZjVPaUlPWmpqNnJJdm9ZempQQXl0T0pxNHQrM1V3UUVl?=
 =?utf-8?B?Sm1GUFo1QmNUSjFTbEkxNkFBdDZseG5UbnkrYlZ4YllZSlR1M1JwQnQxaHZy?=
 =?utf-8?B?dkFEbERSQkpHUGhqQXN0d3Z0QlE1aTlib3J2MzBhNDlzbjh4eXFJQ3dVaVFZ?=
 =?utf-8?B?a0dQVkY4dVc0YnlYVjE4QVZZaEIyUFR0T0RBWFN5aVVLTERGZGhRbGZsd25l?=
 =?utf-8?B?eVhqS0MvRXBJNjB4UXBvS3J6c3N3bXo4dDBxRW1zQXpaZEVBQ3loa1NrTzhh?=
 =?utf-8?B?RVFsc3l2TjVpVk5ENktESE9HVDhjMTBWdGhGamFtam5vdE1TamhXY3NWanpk?=
 =?utf-8?B?eWJPRWZXV1RuaGFENFFHVDg1c2RvOE9iUGgzeW1ibDJhNEtLMERwbjRJQXJB?=
 =?utf-8?B?NTIwUlNmcWhnYVFmNEZlZ2lLcEFjdHdLREVDVXk0YjdHVElVd1hjMWRwQmF3?=
 =?utf-8?B?alFzanpreVQxRk1PUzFOTHVYS1Nwek9HbHRsQ211QVphVklVbnY1S0RzZDY5?=
 =?utf-8?B?eDgzMUtITGRseUlvczY5S2RTbDFwQXZ6UHB6Z2sxN3JxWXhVYkZYOVlpVmk4?=
 =?utf-8?B?VGgwQzAxVWRMUU5WOHlzRy9PU3hUdDFiREtlLzBLOXRZeUxYWXRUbXBOS2Zi?=
 =?utf-8?B?OWk0ZGVGcE13WE1YSUlLWWp4OW04RDd4WnZRT2s4Q2xmMVR5OFlncERBbWVs?=
 =?utf-8?B?UGJsZnpZV3cxNjFMVnNMbXNIR2JKdkNJL2FPWjQ5N3V4aFplRnpWbWpwYTdm?=
 =?utf-8?B?Sk9HNVZ4VDZwcU1oczBaU0dsSDBNSHMrVGEwS3lDYXJsSXBpdVU3SWVmenFB?=
 =?utf-8?B?VnVBdDdFdkgvd1EwckI5cDQ0RFZSWWdaZTcrLzNrVjAzWnhTZWFCeEExQ1RP?=
 =?utf-8?B?Z0pMa29Xa2h1OXhDVHprYklFdDNwSStjYWRMRTM4bHhqRjNSbGpPTHNYd056?=
 =?utf-8?B?WFUyZklpeWdBWUkxVGczdXpLQU9Pd1kzRFNxZEZ1a01VRlpuMDFtKzdHVTBw?=
 =?utf-8?B?MHBza294WDJlMzB1M1kvVUFGeThPSm1sSHBHa1ZaUGRkWXcyY0pjQ082ZTlW?=
 =?utf-8?B?ZUNkS1JSNDk3MUd6dGhJTnFlZGJQUko2R2VITFNCUmZXTTFyeXNpV09QY2ZK?=
 =?utf-8?B?NkdKSVMxNDhQQmgxTXFBYnVubmRubStBWXBjM3VyRGIxQ1RFMzBoNU1QNEVD?=
 =?utf-8?B?RE9DaVdNN0JuMXZsaFVCY2pXdXdyLzZkbTBzYitYNm1MTXBHbitKTHlUMnJN?=
 =?utf-8?B?VVNaTVFlRURiU25DK3R6NHNxRkZRR3ZsVk9iNGFCL3F3VGFsYXBzcG1nUjZ5?=
 =?utf-8?B?Y1VyTmc5RXpXMHptcGR1czh5aS9wZ0gzWFJGdFdBWS91MWY1cElETGZaTmJw?=
 =?utf-8?B?YVpZNUNqeXdGaEFOZEJIemJTZlA2Um1CcThNVGRwVXZwbU1QOWVtNktNTWl2?=
 =?utf-8?B?K213cStUYldtWWc3Y3R0UXJGTkFSQTRKczdZTFNXcUVoMlg3M0Rub1J4c0xR?=
 =?utf-8?B?U2dvT2d4UFFzWE5rSU0xMXh6cXozNVdNZ0dGZ3RUVzhCOW9ENm9mUlA2MXph?=
 =?utf-8?B?cmErSGlMdEU3U0J1WGFRaE1vQUY5T2tFNFU3WXZMeHc1N1RNRXM0djM0VzFW?=
 =?utf-8?B?NVN2NmZ3d2xWbER3ZDNQRDVUU25EZ2NsMk44MTNJWFB0dlI1OGYzbm8rVlpS?=
 =?utf-8?B?a2prNzRxSmpHVkJac21FTjdIY0Q2eFBCa0JqY0JaS05lWVJodnpsSWNiZXVn?=
 =?utf-8?B?K1RmbWJLYjRLUUdFVkFzUFNwT1kwV2syV1MyZjNUbkVydDhVUVF0ODdYMmhZ?=
 =?utf-8?B?Q3hFV3p4YnZxb3BPb2xNUE1wR0FoN1VHZ2xuWjI2Q3FWTCtBWDRQdE5wbDFN?=
 =?utf-8?B?OU9qbmdUQXNub0xVTjR2VTFvMUZva1NLQnVPeFdkc2pSdll1S2xxMkpPU0tz?=
 =?utf-8?B?VSt1TnpVajkyT0Rmd0tQSFRNeG92bm5RSmh4QXBDYWxSMWVNSTU0TlRUOWtF?=
 =?utf-8?B?TW03RzBqbXgzenNEK2Z4dW5CbnNwV0ViSG1yQkg2Z2k0UTRJQUt2ZlJNZEN1?=
 =?utf-8?Q?fx2AN+oxICcxfhFza39qGDPHa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5c89564-9d71-4aac-6c2f-08da8668a2cf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 07:08:39.4600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zkg/KOvWfqBDjSReyVOnG7k+r0TfDUi+SRlpuR8BWlaNYkF0yz0Erqc2Z3stj+fv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2506
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/08/2022 19:25, Jakub Kicinski wrote:
> On Wed, 24 Aug 2022 16:35:41 +0300 Gal Pressman wrote:
>> On 23/08/2022 18:04, Jacob Keller wrote:
>>> 2) always treat ETHTOOL_FEC_AUTO as "automatic + allow disable"
>>>
>>>   This could work, but it means that behavior will differ depending on the
>>>   firmware version. Users have no way to know that and might be surprised to
>>>   find the behavior differ across devices which have different firmware
>>>   which do or don't support this variation of automatic selection.  
>> Hi Jacob,
>> This is exactly how it's already implemented in mlx5, and I don't really
>> understand how firmware version is related? Is it specific to your
>> device firmware?
>> Maybe you can workaround that in the driver?
>>
>> I feel like we're going the wrong way here having different flags
>> interpretations by different drivers.
> Hm, according to my notes the drivers supporting a single bit and
> multiple bits were evenly split when I wrote the docs. Either way
> we're going to make someone unhappy?

IMHO, passing both auto and off is confusing.
BTW, I think this is also inconsistent with the direction SONiC took (or
is taking?) with the auto fec mode interpretation?

> While we're talking about mlx5 FEC, what does it report on get?
> I wasn't sure if it reports the supported or configured mode.

I think it's the configured mode and the active mode.
