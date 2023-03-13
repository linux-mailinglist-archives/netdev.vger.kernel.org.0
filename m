Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396AC6B7D00
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjCMQEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjCMQEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:04:49 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2109.outbound.protection.outlook.com [40.107.92.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFEA64B1E;
        Mon, 13 Mar 2023 09:04:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WiiVrbqX9XYXQJxSYe5uLGNxi1Im7krdYsjHWR76E1V/s6ZffkvD+LMREd5rt+qnatMeqVqXqqodhusMlGXWn+5LDHhbdyHAzmiyckjEYAuelrgzQZKBXvFeu6dsfq5e8ej3p/WpX27yCu6Pgo65uQfj5E8JAKC1T/WjqgbJdDLW75bNHSSA6QlhmOqmW2OAowwVvdE+/hKkK0EvR+P8AHKQNrCECFZ7sn5Xdc/GEnP5UIErekCTc+u6BHcvniK/Ouz3KiHY6uJUG5ywJdmPo22xGWFQY/2BsJBOhqpqpeJPuv4hClq4sNz3RYWYpjfKaVZDrsscXg8fMPfIkttoLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1sjCA78nG1Lb55qd158b1XFTQQ2gyp8oFOODgCBc+s=;
 b=ddr+bv5bycItzJfbvmumHM3Aflceh+lbCcrnmBF9hu7h2ulacGRNFgn7M/i47xWeLtAVY3lwEtJ00FSLA6WmKELnhsy3PDKKhUXgB2bhUXfmr68LmDPUaZEHeRCYKkXtfED86l5HBISPBSGhE33gisPvLsUmmnYamH5aSrYpr53KrLbVnPolKDEfnBGgFF1XxX+CFo37qh0AMOIla48W5yXI6HeNvGrjxOtmwe/JjIW+ps5oVC+JWX6RKJvBk1yWL1hiF3pvUkeMVhZeUlbyEclhicbI/6Fi3jQM0c5CWuw6nXhb+H7Mie9z6jZHxM6mKN7Tq0ryZrBOIZ8GHIZi5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1sjCA78nG1Lb55qd158b1XFTQQ2gyp8oFOODgCBc+s=;
 b=eqmb6i1WdZUlSVkLnsuSJwjXr9zNB+KmJVlDN8cieqA4G40lR30qQID15YU5OAv2fYy1/UotUErsR5v1QrAQsYDCPVCrKF33FReLwyyFggS0wvXDurfWD8tYz972zvJLQUHVwzwP0EqFTyRxUrvL3+Lgm/Z2QyMAY7pNROa8tnk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6299.namprd13.prod.outlook.com (2603:10b6:806:2f3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 16:04:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 16:04:44 +0000
Date:   Mon, 13 Mar 2023 17:04:37 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: marvell: mark OF related data as maybe
 unused
Message-ID: <ZA9JldJiu7JoX6uD@corigine.com>
References: <20230312132523.352182-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230312132523.352182-1-krzysztof.kozlowski@linaro.org>
X-ClientProxiedBy: AM4P190CA0007.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6299:EE_
X-MS-Office365-Filtering-Correlation-Id: cdc978f2-6ac5-4803-4421-08db23dca90b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6HmYKgvgMGPLYsNXzhoc2ZGiEkhcffUpPzK3CQK7dgNmZJHMoR65SwKr+R/8EpD8CGQ8D0RiJlgu1FdDEkXSOJZOg0o3W2I86CncpJOXgoBB7LOvCDP8qeDUP/TNSB9OvTZPITPb+FcW4DAZDlyomRiqIqdxveoMMAs7fpEvZ+vxY010Gzj1N9/XwsYSjc4x6OUTvfkglXUzelRggUTFxEhUuZJClFMk75BTpiWv0n1h+35GdyFAYsLzN7o8VGPFElPvLC9NyW8KxcAyy86sG/FaolkO2AUGxKSr3uKiSzM/FsLmoMj3uHXL2zRe2PCBu5B15qhonUycDaTS0oxFoQIjNQFeoa7UQDK3LzLiRS+mcuKdS8MEcceRYR5DgUyHu0GzDIuwhRYa+0u0uF0DCYVJ9vTu8fz937iYJHnoRYyi/N+ZUmJqqCd1kR2rwaMONgNckvBD3njhpeIihTGnbJb96Vp701qjvL+Z8cpsvU9foyFdZ8u361LLYEuP4IWw3vNnEFb6wJg3Hi2zHRGRL0OMTSDKYNT0w/pceoKb8OhaTmZjBcvG7CLBrsEKlisn9R0zUOAUReAPXmaT7QwR3/bJvXF2YerDG7jCq0C2w8M8M+YgzYgWbV+qTRgrO3Uk3bZphPNyNCOnO2fMfyYf0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(366004)(396003)(39840400004)(451199018)(6916009)(4326008)(5660300002)(7416002)(8936002)(2616005)(186003)(41300700001)(6512007)(6506007)(36756003)(86362001)(4744005)(44832011)(2906002)(6666004)(66556008)(66476007)(8676002)(6486002)(66946007)(316002)(54906003)(478600001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dURreUJMYzhRdHM5UzNwV1ZHUExhTnc2VXFDZFlPSElUZHJkaGQ3bG9BWjE2?=
 =?utf-8?B?MnBSSndocDdvUXNBU2JxSUJ3dHU3NWdQNDE4RlowOFhjOWt1dUI3bU1POUhk?=
 =?utf-8?B?Z1FFRHBRT2g2N2R5NHUwSGlvSDEyamhoM0JNdmc2UnhkM0FIMWpkMG1qVE9F?=
 =?utf-8?B?N0FobUVkQlJlNWZKZTlyaURCSmZZalczOXJYOVRlWUNweVZOUTJndXg2REoz?=
 =?utf-8?B?bko4RE5hdmFHUngvelpwNVZUbE0wbUh1aHUwRytHeGVqWkp0VTU0TUVHOHI3?=
 =?utf-8?B?SjJ3VUNhMmdWNnd6aGdNUkw3UW5tT0Z1aGFIL1V2RURhQkRLZUpZcE8zUDgz?=
 =?utf-8?B?ZnI3QThEU1NndWhnaStyRWRmeDBXQld2dCtySG9Mbjdhd0haRUFNemhwMkIy?=
 =?utf-8?B?c1U0WnYzTDhOdTVpT2svYkIxclhaTkhTQ3kwY1J5cXJPa1B4all4MUd2Vk0y?=
 =?utf-8?B?VXdCRG53dDlLVkpleFFpYXp3U3RSYVMzR3RveURWWFYzWGJISVkwblk2Y2Yr?=
 =?utf-8?B?cFl4SEpiQzMrSnlxeVJwcFFSenpaVGVrT2Y5SUY1K0pRdGhSKzJMK2xVVVVM?=
 =?utf-8?B?TDZIb2F2cFAyWEpRcW9sVkxzRE9XQncvdW13ZmpvZGZESSs1VmVRR0RyVXY1?=
 =?utf-8?B?UlZyczNuaTZ2VnRzUXJaSCtHR0E3MFNMdkN0NWZQRWlNaTgySVZSNlNVeXBJ?=
 =?utf-8?B?NFFnV2h5aE5HakZZbFZNNjU2a1hiL1gwaTV1a1FtMUxwR0k5SXlKb252NVh5?=
 =?utf-8?B?ZE9KVloxNWZMOXZ6V3JHYzlwN1VOU0s0cXFQVGg3L3F2ZDh1aHFiem1vTUtj?=
 =?utf-8?B?N3ZrREZXQ1hDYjZNTjZ2eVZSRkZFLzBBNVdybEx4cUNsSEJtUUxJLzFFVGlK?=
 =?utf-8?B?TVZxRUROc3h4ejZSTmlTajlrTkNIbkRqZEN0TXRoN1JQbDVRTDVqdHhPdkZI?=
 =?utf-8?B?NzdiUko2bHpMVW14M2RBcVF0eEd1OWxQSC9mcko5VFlYdittMlNhRHNHSHdG?=
 =?utf-8?B?Vk5CalZWa2xTTkNZc2NjZkxUNStNODFKelprcVg5NEJLaE1iQnlrOFBBbWpF?=
 =?utf-8?B?WHF4VVdmdzlCRDJKaGgvK1I2YzB6VUc2ZGdMQ0JRUnlFK0pGREE1NlZCYThG?=
 =?utf-8?B?cFZNaXZibVdXYXFYekx0TVBZNXpwZmRjRG1FQk4zZFIrQU1SOUhIV3dOSkVU?=
 =?utf-8?B?TW1hZW9KcE9VWHhtQ2p1R3BuNFVvd2I0bU94L1hJNmNzd09XMmg1OFY1NFla?=
 =?utf-8?B?d01kbm4rYkQxN1pVeTJENXd5SEhzdnRZMTBRMk95cnpTRlYwU2JwNG10K2ZE?=
 =?utf-8?B?U2R2V2tlZXdFT3Z3MWFEbDRTRk1VVk5IYzRPVFUrQVJaUHRKT0dubVFMRjc4?=
 =?utf-8?B?eHJnNUthNk0rZzdJNStOQXFBeGNjSkZmQjVteTZzSXFMQjJnNFR2Z3FObXpo?=
 =?utf-8?B?SmsrcEpRUFJEYnB1TVV1d1p1cnZuSEQ3MUQ5THA1TktIZzI2Z1g0VzdEQmVU?=
 =?utf-8?B?MFFEMU5YczdCQUJldElwbndVbk1SVlZraHVuNzRkc0pyM3R4L0JGNFFXR0dx?=
 =?utf-8?B?MkdYVC8zODVEckNQbnZDQlVHR2FteEE4REVUR3NHbVRabkdJVUV4OE94dVcr?=
 =?utf-8?B?NDlDMzFrcms1YXdhY1BiV1hYVm4wZ045UkdRbW9zdlFQVFNVNzBVcTFaclJQ?=
 =?utf-8?B?aUx5d2RzK3BMREVhdkFSeTNFeEtCdHVrbUlwd25rRnpRY1haeHVDTUluOUxN?=
 =?utf-8?B?U0NKejhGY21RS1FidUhBclpYSmFyRE44bWNEd05YaTRYNVNIaDhpcFVieUZ5?=
 =?utf-8?B?OVBjaml3R0NnVUVMWlp0ZkdNZ053UVBkMWVTb1MvU3dIQ2F5ZWMyWXFFaklY?=
 =?utf-8?B?OHFoODFhVGc3NlVKS1BXRVZJb0t3L1J0Q3ZEaTgvMWdGZUZLSlJHaFA2UlVB?=
 =?utf-8?B?dXo5dFF3cGVUcEg1U092ME9KSFZFRVBXL0JwcEhYQXFPVDBkWk9ZWkE0UVNq?=
 =?utf-8?B?Um15dXdOQnluZitoM3h2RnhXTDFNUW1DVURoMGEvMk80T0Jxdkg0S2hSTytV?=
 =?utf-8?B?K2pPN0puQmRycnZrczA1RGM2cDZRQ0oxOEg5NEhnWkdEYW1uVjMzbmNtQVVN?=
 =?utf-8?B?bnlKQ2ZzQ1QxVXlxenVnTzU5U1RLcmNzaDk0RmxNV2k4ZGRTWHZ3QUdQdWdX?=
 =?utf-8?B?MUlyekxSS25KVVNMem1PRklXb0RhYWQ5SnYwNTZsdUpBNVZ6eUo4bW1QSTIx?=
 =?utf-8?B?MHFTYjBCc1MwQ3hJa21CSUYycTNBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc978f2-6ac5-4803-4421-08db23dca90b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 16:04:44.1265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3UNb9EneBA6RCF1bq+TjRkGH97b0YefBCEd8qQ5jv+QxKYEK8cvGgSMq5wS0hS4AmuJrvoR7cRVGzj0szi4AULMI7Bx1xkxCN8DSVs3XBZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6299
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 02:25:23PM +0100, Krzysztof Kozlowski wrote:
> The driver can be compile tested with !CONFIG_OF making certain data
> unused:
> 
>   drivers/net/wireless/marvell/mwifiex/sdio.c:498:34: error: ‘mwifiex_sdio_of_match_table’ defined but not used [-Werror=unused-const-variable=]
>   drivers/net/wireless/marvell/mwifiex/pcie.c:175:34: error: ‘mwifiex_pcie_of_match_table’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
