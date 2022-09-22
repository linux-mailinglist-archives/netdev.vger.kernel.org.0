Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 099965E666C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 17:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiIVPFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 11:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiIVPFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 11:05:33 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2059.outbound.protection.outlook.com [40.107.96.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547E59018D;
        Thu, 22 Sep 2022 08:05:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIGHpZBpi/wA9EiNM/6Wt42LBeC7Iz8g2aSf7q7pbqxydvWZzzOAMEgJuYMz1z6PevNSJBJHtzFF8IJ+ejQignEJfyaGa/pLMhLAVJQJAWcc7mqh0z+TDVlWo6eOPdvLXB71FUhmkKLMLVCkROKRp0tegrAG5HigyA2qaGqWdv9QN8xG49PbMNLcmw4sSS/wDNdLppKes2cV3iZHZQHUH8A1j3NnExcvq34todRuTQ0ABesyJwPVXu2xfYWkK9MGX4wSlFWu/PmlqZIJdE0ZDDyRetXGr0VR1wzaGD2RLdq+mnJNY/2XfBKSibmyFKz9dNCx1T37MVOEUB8DmFBZrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+NmHWpx0cQrVBdb6t7FlRgawM6egpAEgwH+J5S69XA=;
 b=Z9rodHMSxQGV2f0Ps1oZK3utvC46YeMhNEl/oSvlen80kpvx4gIJ/YVz783bOLyjN8gMhw7vbEgtk0HZidSFC9nImb26OGsglkyUTwV1QK5rwUJv/ZFwCXy3rICwAt0qcA2xC7y8NEc9WJZtNm64GFMp1WvUcdldNFrUr2uC67O91hzZGXVqJvjirQW8N4eC/kRQh/F2GqtL6BXDZ84F6r39aWjWBKQbygMGPL4qJTbBTxgDXaR3kKukjvYyjvFSvaXjjo1gV0XNGvQCdL9u+hkSzXEbBLWhMb54ohftzJD8JUpGr1akwglneZZdxbFc/MVtwypFgnhC729EIfV6OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+NmHWpx0cQrVBdb6t7FlRgawM6egpAEgwH+J5S69XA=;
 b=hTJ2DdKbGfWmqHwHT6gMenghx+9t9JZDZCfxu/D+QIFOVPJJHS4A5JsVXA7M0cw5LqQTxTn9D4w1VxUK8vYW77sAUJFkkfdJo5ja9XLtkx+xtm8qPLT1wbeA8uNrjieJWnzrYrreOv/wsz3sJsyMYGoY8WfhF7eyee0pG47x7yfETPMEVTxJlE6G/CIeE2P3s2/J1vDMza8qNSHW2QH0I9+x5jx4/pNake/gU4b9+Ygk/Y5iEIyD9iHf868s01OgqW8ojm8ZmeDfaKX8UX0MFHBQi09Erca1niMDzg2KaWF9DkNR3HTC/E2yInGPy8QCF5e7bUa7rOKYah7/L3FAHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 MN2PR12MB4518.namprd12.prod.outlook.com (2603:10b6:208:266::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 15:05:29 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::b07f:53b1:426e:a29d]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::b07f:53b1:426e:a29d%5]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 15:05:29 +0000
Message-ID: <64414eac-fa09-732e-6582-408cfb9d41dd@nvidia.com>
Date:   Thu, 22 Sep 2022 16:05:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 9/9] stmmac: tegra: Add MGBE support
Content-Language: en-US
To:     Thierry Reding <thierry.reding@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220707074818.1481776-1-thierry.reding@gmail.com>
 <20220707074818.1481776-10-thierry.reding@gmail.com> <YxjIj1kr0mrdoWcd@orome>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <YxjIj1kr0mrdoWcd@orome>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0059.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::23) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|MN2PR12MB4518:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c8cd146-fdbd-450d-92b5-08da9cabe353
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hl4TkN8MIpQY3zuF498oR/LsrwyOvRHevkLYF/rhKqVOiz16jy7NIyrd1i6mnGNhBiIhzsg/T+S5iJVMtOBm3qN6iqQBiSxJ89luRI8vfsMarPSiS8pikYvTZ49ZgUSA6gPmVAv+miFGVohj3Tfu/o5z7WH3ZcVagLhsrh6GoqcwrxT5IyW9/iTnoBhh6pfkoWaVPcAcW0o6FH/0y99OjyErghVOJt1IKUXAxhmFlHmf0rMXFtZJMXcs+WqiLjiZlT9fUBZ9GPNJFb4eo0fV3OoRcyWnfTd6r1Z/bRp4oatSXn9N53HqHNCI1eTBm7CuKkSeLLrQ/17LiSnKVySp44QLqnrdck6R69DEo7sI4K7y2pdd7j7p1eS9f806z4DlGIAaSZl6iLok9DTXPDhi0Gj9EdoUgFZMCidwPzzq1Lrq868hKx2zPpQJ1ppnS/qbcJF56gTt2mtN3cTcgnTHkGxg2+kHS5ADeenm4AugwMk9T/AidcJtuRjsYdKxoTApYdeYhVXCzXchhxLwee+nenN9Gxlrp5P1dCkBXVzc8ZfiieU0w/Mi/2d9fzKTcl1VAmqXgmuV7GEdYLZ0toMh//bAflBJF3WlRrAPjFcY2ObiNQnXupLf6f+m3hz4CgaTSyKsIXQ3kapZiI2JqvaeWmDZVntPSOhGktx7WklzqdDAgKmtCzkZU86A6zyWVpDpSr0wAir2iaWgnDouezJd3hMqhwzH3ZfxccNWZX31mTrSiHo3bGvwu4n8tp5ct0UUWzQFZYOK/G+IuqRrNxr6vpofzk4rFQ02plAVpR+BImM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199015)(8936002)(66476007)(7416002)(110136005)(54906003)(5660300002)(86362001)(316002)(66556008)(66946007)(8676002)(31696002)(4326008)(186003)(38100700002)(6666004)(41300700001)(6506007)(53546011)(6486002)(2616005)(6512007)(478600001)(2906002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEI1UG4zbDRuUzNEUG9mVDB1UllabEJQZWhGaFBiSXVUSnRHaXI5N3hzVWw3?=
 =?utf-8?B?TE90RTdGelZ4ZmhsNzNHcHExU1FUcStYYmlRODdVWWJtZjRYY0lHVStkSkpG?=
 =?utf-8?B?TmwxeVdWWUluclhud3pBSjh2MlpXcko4MjlzZlBxWFA1dzFXb0lxd0E3QWth?=
 =?utf-8?B?a2Fza2g5R3AvQyt6UlJuUWtLRDlybkI4MTVwMGRCNFUrUndCV3dpUmJJbTNy?=
 =?utf-8?B?QlFGR1R6c2pRVkpnd0F0bHBqZlczTVlvUXJmM1ZVYjltQnF0WDc5d1FXd1Rk?=
 =?utf-8?B?SzNjcTFjVnZwVjVzUEFrb1d0RXdxaDVEdHJIMUZ0dlpaZHNGUzJidndmci9p?=
 =?utf-8?B?amdPRHJZWTF1NVZuSUZqSnZTOTZTaXY2ZUpmak5ZUDdUTUVLeHFNS2RGRURl?=
 =?utf-8?B?YmpZWThWYjJlbGJTa3JKSHJmTkEvNDlzaGtDQVhDaWIrNW45S2phK3Exd2Ez?=
 =?utf-8?B?cnVwQ1VXYngraElTaXBnWlJWVmJQcmNCWjNWRUZNb215ZEZLRHgzZVVNNXN5?=
 =?utf-8?B?RWlOQWFvOVVBczJvQ01IdUxLTWQ2aHgvNHlONXJxaU40bFZzbUdvU2xjWXNk?=
 =?utf-8?B?TVpKc3k4RHhwYWRDZHlSdStoRTRRSkEvWW9aRWhDbXY4ZlN1ekxOKzRySGdB?=
 =?utf-8?B?c1A4eW1JOXd1SjRmTmc3SVhVN3BHQmhVMTVRUWdPM0ZwL2RNT3llSlAxQ21X?=
 =?utf-8?B?QnVTSEFEZUs0OXJDZFhNMlVqaHhWOUg5TjMwS1pQRFRBRWI1dXpDVnZKS3ly?=
 =?utf-8?B?K1QrYkduVEkxTk4rQzR6cWlhaWpCc1lXMzhrWG5MN01YTk1mQW1ES1p6SXRH?=
 =?utf-8?B?bDh5eWNIdlNIbjhDVExUZjYzMHlESFlzbjlEeDA1SjBVRVlqT3o2cGN1WDYw?=
 =?utf-8?B?VVhGMWZZUWpWMytqV3RtU1RYOVFOTm5lUXNTdzVuSVErNXlINTUrc1ZhbmN6?=
 =?utf-8?B?bFVQcDBvZzBodG10bnBPL1paeFdYZFhOZ1VQUExHKzU3dW9KY0tVQXllYUR1?=
 =?utf-8?B?c0tncS9aR3JXRkErZFZnRWpQY3N6cG12aTJkRC8xcGF2YTYzdG41UWttMTN1?=
 =?utf-8?B?WjU5dkZaTEdLakdHanZ2VHlZSlFoNTIyekVMZWVmYkc0ZWNHdGNoa2dRNDFz?=
 =?utf-8?B?dWY2enU3aUN0K2FJekovL09DTnVBOHVwMnI2cFRCRzVWTmEzMy93bndlb3hL?=
 =?utf-8?B?dytTMmtkRGoyU2hDWFgzTHNudFA5bGRCL3Iya2lKMHB6aGk1aWUzZGQ2RHUw?=
 =?utf-8?B?ZllacnlpdW50KzFGOGlSS3AwRjBhbUJJYWhDNUNjbXlRUkY1OXcyeUlrU1VD?=
 =?utf-8?B?TTJlYjIyVkgyVTRlT2cvcHh4SHl1UzB5UEFVMythMW5sZDIvdkUyay83VDVH?=
 =?utf-8?B?ZGZzWml4VnQrNDlNVHBYSU1GbVJBT2ozdFpSaWtVak1JcEVtZ2RGNWVlTFpS?=
 =?utf-8?B?MDJ0TFU5NVZUN0dkV1ZxS1MxREdRQVdyZ0k3RTBacWVLUTdrWXVPT2xKWHhK?=
 =?utf-8?B?RGlvdTJRbTZlT2g4aFJvME8xZDFOQmJCNnpJTHZ6aTFtSkxUV0RjUi8rV0s3?=
 =?utf-8?B?S1RuNjFWWWFPYkEzTWdxdG11RHdoV2hrdmo3ZDQ4aFcvdWJ5ZFRld0tsQUJs?=
 =?utf-8?B?VG9iV01xNWlWR3NYL1N4aHdkOWE4T01SSkhONjdOUDhNVWsrcSs3VkZ1ZjRB?=
 =?utf-8?B?UzhHVkk0eG1tYWl5VVVXL05zWm5nb0J4WHJtVldhV3FvRFJnbmVTaU9JbndS?=
 =?utf-8?B?aTJRRDRld0xGYnRoZHYxMGhLZFErWDBzdWhMN0tsUGpQc2FWOVhOYU1VQjVv?=
 =?utf-8?B?U3pPdStwZDlablcram1tYlZIN3ZzeHpKdEJlSCs4SE5LSFZMcDR2c1lEQ2Rz?=
 =?utf-8?B?K0VPZnlDYzF4QVE3OHRndmZ1UzR4VEtTUDA0Vm1TODNZSTZScXMzK3B4NWVn?=
 =?utf-8?B?cGFvQ1ZVNzRlZ09xUlI5bXUzakt6elg4NGhxY0l3OCsvYUdqTkdLazQ5NFl3?=
 =?utf-8?B?a1EyM2p0b2JhUHhFT1lYWU42Q0l2c285bjQyL0xEYmIvdWx1RUJpUzFObGwr?=
 =?utf-8?B?T21MQmFZQzhDMzYyTmExNGpGVkRnU1BTL0YvVHkvVWN2UHFIeWN4TnlJODh2?=
 =?utf-8?B?Y1pvYmhnTTVrNFNMODF0bENxNDV2clhpVVBzSlcrUkdGNFhLZWFCdm5qVFhF?=
 =?utf-8?B?cFRyRlBzangrcHpDYUZNeWluRzdLS3NDTm5vZElLdTltdXIzQXUvOGxnM1N4?=
 =?utf-8?B?aEswcTV2cXZ0K1A3SGNtV2t5Z2tRPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c8cd146-fdbd-450d-92b5-08da9cabe353
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 15:05:29.6416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YpZGZ1uT4wqumyxidma3iSbxxEzUjJr/Qy3jYXT/PcHzzahlA60+tq6s4vaYwYPtPsDoMFVyx0QKYjkE+/Q3lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4518
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

On 07/09/2022 17:36, Thierry Reding wrote:
> On Thu, Jul 07, 2022 at 09:48:18AM +0200, Thierry Reding wrote:
>> From: Bhadram Varka <vbhadram@nvidia.com>
>>
>> Add support for the Multi-Gigabit Ethernet (MGBE/XPCS) IP found on
>> NVIDIA Tegra234 SoCs.
>>
>> Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>> ---
>> Note that this doesn't have any dependencies on any of the patches
>> earlier in the series, so this can be applied independently.
>>
>>   drivers/net/ethernet/stmicro/stmmac/Kconfig   |   6 +
>>   drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>>   .../net/ethernet/stmicro/stmmac/dwmac-tegra.c | 290 ++++++++++++++++++
>>   3 files changed, 297 insertions(+)
>>   create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
> 
> Patches 1-8 of this have already been applied to the Tegra tree. Are
> there any more comments on this or can this be merged as well?
> 
>  From a Tegra point of view this looks good, so:
> 
> Acked-by: Thierry Reding <treding@nvidia.com>

	
Acked-by: Jon Hunter <jonathanh@nvidia.com>

Please can we queue this for v6.1? I have added the stmmac maintainers 
to the email, but not sure if you can pick this up?

Thanks!
Jon

-- 
nvpublic
