Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1757740AB66
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 12:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhINKHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 06:07:31 -0400
Received: from mail-eopbgr40053.outbound.protection.outlook.com ([40.107.4.53]:3650
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230282AbhINKHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 06:07:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlnQ/++sU2zhQSMvCXT6mHVSxHNp2CnNIUTHfHnQOr284UskSsPlyNySoRGRe5GzAxmAoAm8L87J+MakXDcHwe2DBa5WO10GAtgKarACbg5iw2KjntRoLY62SY4Dj6hIrNYpxT2ni5k0fcvyutksBlhiVyVlC3k/XQynOt2paWm/EBqMtZJJkaxuheLE9it0BIZH4aVvrz0rwgPyjqtCc7jAo0l8m0SAK8n411jzr50x26czMdyjgyK8MCuScTwR1fKjoyHaiFmofpQH5CzGcFXu9E3LODdGLg1QMoI+lxm0d+t/ZB98QHncqHsReaiO6V0Y9SyjaeJf3jLMReqf8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ldJ6jA9V0RsXHBY3AFFxkI6p62eT4h2Tk7YMqZtNwc4=;
 b=DCyTJ1fLW7sIdxL4DeNI1x3z7Dzx8dEQdts0zyD0zlH0riDU/pU7Pk7LEWzCh72t5USAKHbfLgd+dlygSbSLYubK+uDxeeKlGd+Z5AEQ3efxK1/CSwqXBfj+dKS7mKcq/B33XwUcr4B5VIfUsy6xP1LnrqmWVKbHw0ynCyqfj1kwYQ1KeyRMovPA3lXKWZh9cesPeUl9J4MkAZZECKGh22ncNa2JwZbH+LULZKCBwYJFriHNoR49yNio3zoWh/HCkZ4WCLs/WuD2/MZ0C4z4Ffh/tH1hB0ZLIg//2QTFIl85oFM9KgoSOigLIIO/44O0uiDl6dErmiywDFKC1Nc3NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wolfvision.net; dmarc=pass action=none
 header.from=wolfvision.net; dkim=pass header.d=wolfvision.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wolfvision.net;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ldJ6jA9V0RsXHBY3AFFxkI6p62eT4h2Tk7YMqZtNwc4=;
 b=X0a5jAM8Bv8QEPN36KfF5g5p0lcq1h3UskaAsJGf/joW7rsWTqpYef32dO10ja4Jpl/QcfBri6E6+XIvscpNjC5e4R0IFwGnga0UehXNmAQFwLVwVaIIBgPTwAGAPCDfCBI2iNS/NCRxRbtQq4zo00ZCWLoVEd/ZETBniKSfntY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wolfvision.net;
Received: from DBBPR08MB4523.eurprd08.prod.outlook.com (2603:10a6:10:c8::19)
 by DB9PR08MB6874.eurprd08.prod.outlook.com (2603:10a6:10:2ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 14 Sep
 2021 10:06:11 +0000
Received: from DBBPR08MB4523.eurprd08.prod.outlook.com
 ([fe80::452b:e508:9c57:a6e3]) by DBBPR08MB4523.eurprd08.prod.outlook.com
 ([fe80::452b:e508:9c57:a6e3%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 10:06:11 +0000
Subject: Re: [PATCH] net: stmmac: dwmac-rk: fix unbalanced pm_runtime_enable
 warnings
To:     Ivan Babrou <ivan@ivan.computer>, sashal@kernel.org
Cc:     alexandre.torgue@foss.st.com, davem@davemloft.net,
        joabreu@synopsys.com, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, wens@kernel.org
References: <CAGjnhw920kNaJ9Vkg54WR8vh2TaomuTtA3WwR3eieD4v6iEJDw@mail.gmail.com>
From:   Michael Riesch <michael.riesch@wolfvision.net>
Organization: WolfVision GmbH
Message-ID: <2ada6f05-fc3a-a301-a008-594f7665a514@wolfvision.net>
Date:   Tue, 14 Sep 2021 12:06:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <CAGjnhw920kNaJ9Vkg54WR8vh2TaomuTtA3WwR3eieD4v6iEJDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: VI1P194CA0051.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::40) To DBBPR08MB4523.eurprd08.prod.outlook.com
 (2603:10a6:10:c8::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.100.125] (91.118.163.37) by VI1P194CA0051.EURP194.PROD.OUTLOOK.COM (2603:10a6:803:3c::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Tue, 14 Sep 2021 10:06:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7190f6f-dffe-4aad-2a47-08d97767475a
X-MS-TrafficTypeDiagnostic: DB9PR08MB6874:
X-Microsoft-Antispam-PRVS: <DB9PR08MB687484D78662DBBCC2617779F2DA9@DB9PR08MB6874.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WPdqJ7xw0+XnK4Qwx4od0Rv92Vsok7DHx/AP2mdMd4Widl9Wn9jgBuGi1PQgqubWBeidAq4/zHosnFH4iuX7rzUqLbPM4BkXSIB70/jmYGPRo00jS18UUVo/OeAZ4Jcvusfwr216BGUZF2aZOVqRdLyWzEd2itM7Y9io5UWB3latzDON3AWMIOE+16StIJBRUtiw9ZMZtx4eAQrTywvMfiUAvEOOTNktzk5OlHcXS+qYQGtl33+1lfgnf0Q2OKJVJ/4196yKUOQEXS/8Lz9o4pqpQoi1cgGVztSy9tgsbOBJcoRUA5Crlk2F+BVEUJ83fQZpigu+6/WxXtWKRmY9WIAxQqDkJO6BEo3ePr4xnu3LBv8F+7AlEdkBc/ELxT8/VaUH+eeK3sZljG5iEqA1+bY/hafCNjCNxO/s5X13PkBSa1zWtkXO7W28VKoB0Bwbtot+ro4kI/WxJ9cWl9gPYOYg5gRmpaqbep2GGoaMS9huvJy6iA3Iw1pTazwAHsP8U+Vs6GRCaLyq0LgpU35dg4wGYq2EXdzUQbNawz/X7NRQK3SJrPCBdZw26648amvFPPc63naqmm3XuGK5ZT7lxFLLD3bwrkfrDEHCn+5HZSgnV89umfUtYSjKSubM8xzvLthbeGVZFr9+id/wxL3Sasw4HIfWXWeBEjwQyo6r4ke9Zt/8xVizkx4uk/AzakkFIdmmeEKMensukKqcc8+bUAEom7LEohOS3kBl69nrZYC1yRh+2/01oRBcFugKbDmjVxHXrkrShZLL1qxQAbqDcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR08MB4523.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(39850400004)(346002)(31686004)(31696002)(38100700002)(53546011)(26005)(38350700002)(6486002)(36756003)(186003)(8936002)(478600001)(8676002)(4744005)(7416002)(2906002)(4326008)(5660300002)(83380400001)(86362001)(44832011)(66476007)(66556008)(66946007)(36916002)(2616005)(316002)(16576012)(52116002)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TThwS3FMV0dVRjNhUzFYQk1CSkx4aHpISGdTYXdtSlRJZU5wUU1rZENidEd6?=
 =?utf-8?B?VWlHQ01WenRtTUp3dlpwYkdVT3NCaDVjR1djd0ZINEphTFZKZit4Y25FZkxQ?=
 =?utf-8?B?ZUpuUDVVSUZYNUFGMEc2TEJxOU9tVE5VcHoyMEl3YXBwRW1HeGNuYkl4ejJ0?=
 =?utf-8?B?WGZMaUVpcTIwa1BJODFUbjZKQ2VXZDhHWkJ2T3VTVEo0M1VFa2xSYUdnRTZq?=
 =?utf-8?B?M3M5YU9IN01SZFErV2tVM01TQS8weXQxQjZWNVB1T20zT0ZFbFBpd3kvckdS?=
 =?utf-8?B?TkdBZ2lRUWFUU1Urb3RGaTZDZnQ0NzNSakZNQ0c1U1Y4ZG9YSFJrdy90RSta?=
 =?utf-8?B?TFNieVJ6Y0NmM3NUNXNQN1k3T0dzcXFta0Y0aDdxTUNVQmVuM29JTE9pOHV5?=
 =?utf-8?B?Y0hOaDNVR1o1UFZFeEg4VUVhMzUwcFNlS0pkSENxNGtHem82VXBWQ3ZyMzdF?=
 =?utf-8?B?QllOMDFDbjBsaWRNclovWk4xVVlLbDU2WEZKMlVkUXkyV2VkOSs2OXNyUmVw?=
 =?utf-8?B?ZXBLeDVZdWo4TWNxQWgyL0VqQTFBa2xmclpBSkNUZlZ6U00vMGI1U09NZ3ZU?=
 =?utf-8?B?T1NtRlJYZTdqZkJiMG1UeVVPY05VT0RCNTFCTWNBeVpyOXNacFpQbGg4WWZR?=
 =?utf-8?B?MU9JL3lzZUFqUERnQkNBZ2M1QmRkbzdHZ00rcmpQVzVCU0xzaXpiemVWdjgv?=
 =?utf-8?B?dWNray80VXBLaXZCdUY3dGdpems3SEU2N01abEllU3BlQ3FlOTQyayt5ekVj?=
 =?utf-8?B?Szc0YWZBUHVndGFPL21pWWFudGpBbjFEd3liQVoyQUdUYzQ4Y2p0VURSNDBZ?=
 =?utf-8?B?Ujh4ZlNjMi9yMHVNQVQrTWJlVUhqdnhqb1hIVVBqTkVMenBScEtjL2tyZUl1?=
 =?utf-8?B?dVdDcEoxOEpmYzFWbHhRRTlCNlBuMDl5YnplOVc1cEc0OFI1ZVpSY2hXU3VS?=
 =?utf-8?B?aVdvU3B4MDNuK2d1RDkxVnR5MUMxOTd1MnExRTFVeElJcHhRa3FrRTZYRmNr?=
 =?utf-8?B?SE80eUUwWTQxYVFtaGJEVVRReWpRSm1GQTFwb2V2WlpGK3RVV1dSRXlIemp1?=
 =?utf-8?B?c291aUtTZHNKQ0I1NlZSYTNBUkZnMFFvcWdMWGJ5Sm12c3Q1cjlsdVlyVmZS?=
 =?utf-8?B?L3NqRnlFNGk3OEQyUkhVYll1OFhUWHI4MFl2a09wWGZIbWtDSWRXRzNudy9r?=
 =?utf-8?B?ZElndDV3Yncwa0dUZ080VGt0T1RlQ2J6NXU1cndGMklmdENRMVl1WDlqeUxQ?=
 =?utf-8?B?TEIxZ2R3WUIzZEEwTE1XUFhsb0tFUXZXNVJoTVhneEtKMzRjbHlhcnRWZEwv?=
 =?utf-8?B?d3V1anJ3QXhxeXBJTWdBQUVQWkt1VG9wOGtVV1VWRzFtd0tRU0hRUFdOYmdP?=
 =?utf-8?B?Ylc2ekphRGlHczlZQVk4eUpla1UxaTgwZVc1Q2pXYS9iQ1Rhajc4dW0ybUx0?=
 =?utf-8?B?dWNZTUVZYUgyTDhTS0JETlcxWk9raVZkV1ZMMjI0cmRlTkx1dkFMWW9MaEZW?=
 =?utf-8?B?WjA3dzFXS0ljalFob0NrTU9sWVRINXlBZDdhN3pxT3dyMnBWamU0Vk43VVhz?=
 =?utf-8?B?YVhRdFluZ2VoQ1RBYkQ1T1lrcjd0c2h1ZHNGVHc4bC8zdVR0OTlBb1lyYUEr?=
 =?utf-8?B?cjYrRmxaQVVSNzlLMTdaaG9PVm4wV1lkU3VYQzBDS1dvNmFoM2lJd3JtejlI?=
 =?utf-8?B?V2hHczFrY09sQ3ZXUUxrRXEyeWhSb1l0NnpFMnFuL2xvVEUrdVcwc2xOcXhT?=
 =?utf-8?Q?bvp4xGVN+tpCsp8PZD7bD0bM1d8DSzgVKxcu9uR?=
X-OriginatorOrg: wolfvision.net
X-MS-Exchange-CrossTenant-Network-Message-Id: f7190f6f-dffe-4aad-2a47-08d97767475a
X-MS-Exchange-CrossTenant-AuthSource: DBBPR08MB4523.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 10:06:11.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e94ec9da-9183-471e-83b3-51baa8eb804f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oefwP8qI/uPS3Sfc1eGSdH3AZV3nOTmvQ55RzCHf1lGm5AwiwRykuftgtHAP7+U5dO5326f4HM0OkpOe1PZElYYXPwB14dZjR8l4ifgSZPM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6874
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ivan,

On 9/14/21 3:10 AM, Ivan Babrou wrote:
> Is it possible to revert the patch from the 5.14 and 5.15 as well?
> I've tried upgrading my rockpro64 board from 5.13 to 5.15-rc1 and
> ended up bisecting the issue to this commit like the others. It would
> be nice to spare others from this exercise.

For what it is worth we believe that there is a different issue with the
dwmac-rk driver that was obscured by calling pm_runtime_get_sync()
early. Investigation in progress -- I hope that we can achieve a proper
solution before we have to revert the revert.

Best regards,
Michael
