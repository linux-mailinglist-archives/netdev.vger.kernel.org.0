Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74025BE23D
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiITJkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiITJkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:40:36 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C1025C76
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:40:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAoTAgq6HG0Lh1T2u6Yx8wVqGaXkCNaSrSI0X+vSygXq+7By+37qZAs7nq4Ce3LA8PtDxNiNajEfr4x25JojvC9ToV2sFidUuVSUXQI+RklX6zFY1mhXJfkxfOtOorwNJP2W8sYcGD8pbKDm4KOvT+eaD0kUMW2nl9VDla559zTxsgJ1tDphHU0vvaZO43hlUgJ+1CrwVeHQOhevBZMB/l6WILNn2Lz212OVEn+zCJwfQDwPvgCQ3xgM3RMfhrii9GXP5lL0NXNDO3UzGXWCTDZBVd6TrhX82rd7dnn4Vcf2Mw3FFAIeY6foPwLKGtOPQtwZcLEHPTu6v2qv+zqGrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iIT14MZJadC3nieMgtlY6Rj/tOCkVFHETNgzC2oZycU=;
 b=SagJykhHtyuoQjAF/+slUH1ubyMtQd2/lHCiOrqsKRAP7XCMRwR4xfWie1MrzEx5JA15ecXH23YTZtX7K+YhrhTMsJKL2H2V+0DZ8F07rFx+P68qDYe4D5Og20e9r3v9pO/y0TyKzx3pbVfYC+0QpVLreSAVIrBAmFEZeu7Bv4l5IrSSUObS//UD7/ki4lnPf+GQx2H8yPfZA2D8qu5ec+Q02pKwJ4OwzMtUIuKqyBWQrsea7uHZPh4ohQR65FN6I1seWqX8YOnGyYNewrqyOlJQLonG17qk0yCnInLoV8+OizZJMo/Yj4Bs2EP18xNUUDc9HeChcBx2HkmbcCozFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iIT14MZJadC3nieMgtlY6Rj/tOCkVFHETNgzC2oZycU=;
 b=Ra9/uOw6iifYTCekgrKXxQ4/mhYYb+ZXtK7HU3GG1TXpwO4hfiE2rd+nN9ayffxNKjNn1vKG3I1nzbn742EL0pFhgRBri8AQ/AKuzMaEI4kQG9nKXeW06bSD5vJcGemENTzvvOh26vKZd2TNqEbfyWnDsxgP+8CYxHyy89MC0JZIs+6/cf6DrORFKzdDtwR/e/5uqjBMaN6MHaEbIG3t3n+LUU/KnSOFD6aJ5xyoPBHI0GiGgUgj61npVHjk9HTD14mEA9Gy3ZjyFf75K9UP7ue6DGSjrx+jrIMXN992lxjwN2n5UXbK4znjWSsuGF+mD/ZVvXEZtbNM75P75WlVYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 BL3PR12MB6451.namprd12.prod.outlook.com (2603:10b6:208:3ba::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Tue, 20 Sep 2022 09:40:26 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::24e2:5b76:cdee:bd15]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::24e2:5b76:cdee:bd15%7]) with mapi id 15.20.5632.016; Tue, 20 Sep 2022
 09:40:26 +0000
Message-ID: <5d688749-697b-ea5a-8ba2-df8188ae0cf1@nvidia.com>
Date:   Tue, 20 Sep 2022 12:40:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 1/4] net/tls: Describe ciphers sizes by const
 structs
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220914090520.4170-1-gal@nvidia.com>
 <20220914090520.4170-2-gal@nvidia.com> <20220919184703.5e0d2d44@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220919184703.5e0d2d44@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0196.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::16) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|BL3PR12MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: f22bcc78-d4a5-4311-359c-08da9aec259f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mgjTx1v8UOLG9Juw8TY9XaSsy5MYNvVgFgK8MfaNzYPS7pEEwlSemdh+9HKfGQT0exvdTTaYx4GzTvXpo/y503wHh81JTjXGcWWTq0KWCnv9x9nNBOxHLUcbw4wJ+3on+BbqFhJ34SD+QSDWEOk1/fjmQCBEwIySXy7MuttqPvqpiP+k5oazej+mJvoWwhCkVfQBlgGJoT9NMrb1GpRt0/vDjFUm2QV/EmsQOOE/1Yd9xppX5ZZMLFtWWFDZb++lfkCBgX/U2DpE/xMMJoqJyi2wZvUNqnY9bLvJRw7YpeAPgeZnwTfeCMvsPKyxrnX29/jOkiAXDkWCK1hsHBYkWL24cVUFZNZrm84fm+hIGeTGnXbi5Y86YmCVKc6MMne3rc/4XctLmMvDCxW/yioEVgDsvMdAssLnulvqfZN2r9v5qq28foexDIpAy2VbKOzsEwxCMkCMaoqQSraiVFjhxTaAQDUjoZyVqX8ph3zzMlEc915dHmp0CZ0jFfI+yS3fl1R8oCGxQolmV7plCtySHXalPFHyUYhPtuSrP4p0fOwBdqxUeQPVa0vgqPHZ5rLIHRMvzgWSArc1JIG0lIeQUgwGOVkFV/27y3yP2NQKRGZcJGMTW8BV2BSkYAYo44FWcoSO8PpIV0GhPUH2XiOoVkb3IqZ+esT9dzNk6Tj9G7Pfg5QsncIoWbFs38+O7auTO4uOU454OUXFLSkz37QlQw3qxgkQxyoFl+Tepaa7qUEV3S2j2Rrc8JBpaVAVpdY8cWrqOH97C06ToFZ44/zgmFo2cFxOorQRq09utT6jKzY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199015)(8676002)(66946007)(66556008)(66476007)(4326008)(31686004)(6916009)(54906003)(316002)(26005)(2906002)(53546011)(6506007)(2616005)(4744005)(6512007)(36756003)(8936002)(38100700002)(5660300002)(6486002)(6666004)(31696002)(41300700001)(86362001)(107886003)(186003)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzAyNTVZNTFudVdUZFpUczlLODQ5SXFvb2JUcWN5L3E4L1gxUzlOSkh2ckZB?=
 =?utf-8?B?dkJNNWNVV3pwakN3ZFBMd0NIM0o3T1haN1RxaFpOKzFubTl0dU56T21qOUVi?=
 =?utf-8?B?YWNCL1AzZTZQb3kwVmpVeHNhRFJZQ3FPM1FLUldCeXlhcUh3NTUrZTJCc2Uv?=
 =?utf-8?B?c251MWxlcEhmVUdpeGpzQXhTOFYwQzBSVGczOVFGYnJkdmZBUnMzaHVPVHYy?=
 =?utf-8?B?TDZXSHQzak9hTTFXb3F4WEVPQVV1c0dkSjlsOWM1VEtQekIwZ3ZMbHd1MFZz?=
 =?utf-8?B?a01XNWJkSysyK1FsZ040WHdnQnBmd0JUV1o2eGZ5NDNFdC90WVVrRVhNbXZM?=
 =?utf-8?B?Vm1VeHh4UVQrVmU2eFkvRjcvTGYyRTRwcmVrOTJJTUU3R1g4VHVoWmE0RG5r?=
 =?utf-8?B?WFFwMjFWd0liczI3MjQyUHVLQ0hVaGJqY2YvMENSQjNmNTlkN1RMVUNOL3pP?=
 =?utf-8?B?K1FaUStmR1k3T2N6V1djOGhpZFp3UjM2Mmcyd1BFOXBkeDc1UEJqNGtsRjNI?=
 =?utf-8?B?UTFmT3BHM3l3WHFnR092OTVVeEZMaTB4c1BrRGwrblFYVFprWHhYUzQyckxQ?=
 =?utf-8?B?RC9ucCtRVHpsbzh0OWZCZlQ3a3BqTzJsbHFjMmFBd1FseFBOaytHMHNhem9U?=
 =?utf-8?B?cU5oODJMSkhXbXBKOUw5TE45YmErdDcrcjB6SFd2MXF2cnV4cVl1VHJGRUVt?=
 =?utf-8?B?a0JxcHJkTU1lczV2Q3ViMVkvMW80TS9abVhGNXVPRGwxMXBZS0NxejA0eWZh?=
 =?utf-8?B?VzV1NFc5b3Fwam9oQ3hDT1lLdE1ZMDY2TlRRaGZ0cjhZYmhlL01OZFIvN0Mw?=
 =?utf-8?B?RS9ha0ZnOHBuYXpaQU5xTU9LZmxWNGV2WUFERTR1dDNZYU9HWWp0alp2b25Y?=
 =?utf-8?B?dFRrSHhwaVN5enRpMW1iQy8xMUtZS0dDUyswUXVEYnFlTEtRUDQ4dWlmMzVV?=
 =?utf-8?B?cHZVR0VQai93ckFPOGNSYlRkNGhieUMrVHl4RzA0OGszOVNvNGI5eXQyU1R4?=
 =?utf-8?B?Nk5xMTJmNVRRM0ZsK2JxQ0NFTTh0WkZHYnJDdmdudlMyY3Z3YTZwVmc5UkRN?=
 =?utf-8?B?Y2wybnRrRE9qUy92NEZaNHV6dFhlYjVEV0dsYW1mUEV5N2RrbTRocy9KREZ0?=
 =?utf-8?B?Y2xJUjF2NC9rbGJHR2lkNTFJTTl0MllpdVpUV3QrNUV2SkxIM2hqVThFbTFX?=
 =?utf-8?B?UjNpMmYvd20wQVVMUGpvbWVyUlN4ejgzYTNUZWpNUlBtVzAvT1k0aHpjSzRE?=
 =?utf-8?B?Wm14VVAxYkN3ZnpmZWZzOEJocHpGajZkcFl1Y1lCTi9vV0toYzFUbmRwUkpU?=
 =?utf-8?B?aDF4eU9vcDZGSVhiQVVnZ0dMSlI2T1RUYUJLVWd1S0FYN1dPbmV0OGF1MXpD?=
 =?utf-8?B?KytQRDkwbUNmby9sUTRza1puUFJ5SklEUlhCNXA1a2F4bFNmRG9FUzZ2L1lC?=
 =?utf-8?B?ZGQ5QXVaUWNGWkVjblZheHIrUE5WWlNZRVpUOWZrQjZrallEU1lOenlHMVMy?=
 =?utf-8?B?VFBjQVRrWSt3SkZTZFo5R2ZxWGVORGttNDJCY2dSdWdxV0grSGRKUWFmZlJY?=
 =?utf-8?B?YzZHajJBQ0pXa0ZabHVacjkxanRyYzNRaTRma1c5QVhDMi9MZUhVS3VtOWxW?=
 =?utf-8?B?dEpEbVdFaXYwa0ZyYXVkUHFFaW5CZlFXN05CSWt4a01maDBySkxqajJseElB?=
 =?utf-8?B?Sm5Zc0UyQVdaZittejIzbEphT0R6ZFY1bGdCd0hSVUZtWXBtWkhwcE5KRExL?=
 =?utf-8?B?REttWTkwWS8xbVRwVXJxdmJXQzAzVHNvRXByMXNMQitqejdBeXg4ZGhXU1FV?=
 =?utf-8?B?eUs0R011ZVB1K2J6d1pVSXNDcWlHLzJPRUFpVEdPb0ZiZ1hSMFBjNDI0eG00?=
 =?utf-8?B?bHFHaDR5RTBzL0tuRjFuL05MY1c1cmJ5RGxuTnZZVDU5SHlIYXhjT1Nyc2U0?=
 =?utf-8?B?SFFvc255bWMzNDg2N2Ntc2JSVnc0ZnZrUXVFMERlc09XeVF4Vjc1QjR0Qk8x?=
 =?utf-8?B?UmFwdzNTSXFSQU9YcXFTb0p4SWVDZEZBd1pLcTdaNEsyVm9EUDFMMmRDUU1k?=
 =?utf-8?B?NFFvQVlFMG9tWGRaSkFFczNRaTNPam5pMXI5WjRXSnZLY05YN0dBN0lRNGtn?=
 =?utf-8?Q?KrjG1c5nhf67kfINviO7qazeg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f22bcc78-d4a5-4311-359c-08da9aec259f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 09:40:26.3307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /eipB2gbun15aHcdgmROgoyGK+QEid5MQ2GOzy6/71TL4iYwPMZPQ1qmPOv4Z37I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6451
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/09/2022 04:47, Jakub Kicinski wrote:
> On Wed, 14 Sep 2022 12:05:17 +0300 Gal Pressman wrote:
>> +#define CIPHER_SIZE_DESC(cipher) [cipher] { \
> I'll hopefully get to doing more meaningful reviews tomorrow, 
> but in the meantime please send a v2 fixing the compiler issues.
>
> This macro makes gcc unhappy, should likely be [cipher] = { ?

Right, seems like it is some kind of an extension, will fix.
