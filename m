Return-Path: <netdev+bounces-8854-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5244C72613D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:27:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72F132812B1
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0B735B34;
	Wed,  7 Jun 2023 13:27:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC753139F
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:27:38 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2048.outbound.protection.outlook.com [40.107.101.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40E61AC;
	Wed,  7 Jun 2023 06:27:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZzJJ/ThNP0nEdqylFWCIqZbyivWK2HGKLuYPt7TKBxMN/7y4HqZQd8wJzbejtIbInURsp8+VJ4u4zfIhjn5WKfMJ9VnnfguEC2td9ALgYRX0g507oK9n7B/qT7/jTbP7SdRz0I5NY3JRhgOeUn6mLmklhY0Yu47Tkyony2glAIkfiSEWvgpUPWsYinkHDOqa1e0sPabOsLQr5yb66lHM0/J596I2HX0QXN1tWgF8U6nyd8sqm6wzutzXRWspTleI/OOueMsQxAY06y1cPAP/ZMZ21ICtiZE9ohqZdAlU++GMdr8F+XQmZR58cGjcRtqxMGRq2ooc/CvQmQTzGR349Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4W7ZAlg3ymfDSEZ/m6RslfJhsMl7yVZ9HtLhCa4OVg=;
 b=a7SfcAgbj1R7l5hwYINK8oorcS0hZXoQjoRDX/y1tCFjrOkS55BO6utus+yRYBXHdmF+Ex3hE5nQ37tV3KYWuhGChE1UNAuBCLGBbzU8BlDFbiO3NYQ2A8nx72G5dimwbtSGoWpFPaJWJfMvoM76LRRZcTHYTRSRCuPipGw8Xv4YYcpE4tLUZDa5lBXEOVhle7StAX86k7ywI7ZrsCWCbUoPPojJGSB40jAgsf2duHjhfu4aB2Cw4qWitMWsrXhP5lr765ZlHk+CUYOe4IYT+Afw+LKv5FJWwNBzedwxI9HxQ5iIY6iE03ETDOGZe2HToCqmysh7aG+y/INi9wQcsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4W7ZAlg3ymfDSEZ/m6RslfJhsMl7yVZ9HtLhCa4OVg=;
 b=C+mI9hukhbROGtDt3HJssnE5ELg+SMmgxICLEAdGCOJ7WWnTqYkPmckmiUEba20dNfFB4R3ZTH9tOLYRGT+FRrmyabyx87VXLhLQf/JCj9steFexPfMZrQUBhFOGeNfV4MNWzULj/m1BWnw1vkYeqW/EGmPZ84g+sP55YKk5ykY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6460.namprd12.prod.outlook.com (2603:10b6:208:3a8::13)
 by CY5PR12MB6549.namprd12.prod.outlook.com (2603:10b6:930:43::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 13:27:32 +0000
Received: from IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::d5b1:3b31:ee99:aa94]) by IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::d5b1:3b31:ee99:aa94%7]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 13:27:32 +0000
Message-ID: <9fc1d064-7b97-9c1a-f76a-7be467994693@amd.com>
Date: Wed, 7 Jun 2023 18:57:17 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: arm: shmobile_defconfig: ld.lld: error: undefined symbol:
 lynx_pcs_destroy
Content-Language: en-US
To: Geert Uytterhoeven <geert@linux-m68k.org>,
 Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: open list <linux-kernel@vger.kernel.org>,
 Linux-Next Mailing List <linux-next@vger.kernel.org>,
 lkft-triage@lists.linaro.org, clang-built-linux <llvm@lists.linux.dev>,
 Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Netdev <netdev@vger.kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Anders Roxell <anders.roxell@linaro.org>,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>, maxime.chevallier@bootlin.com,
 joyce.ooi@intel.com
References: <CA+G9fYv0a-XxXfG6bNuPZGT=fzjtEfRGEYwk3n6M1WhEHUPo9g@mail.gmail.com>
 <CA+G9fYueN0xti1SDtYVZstPt104sUj06GfOzyqDNrd3s3xXBkA@mail.gmail.com>
 <CAMuHMdX7hqipiMCF9uxpU+_RbLmzyHeo-D0tCE_Hx8eTqQ7Pig@mail.gmail.com>
From: "Aithal, Srikanth" <sraithal@amd.com>
In-Reply-To: <CAMuHMdX7hqipiMCF9uxpU+_RbLmzyHeo-D0tCE_Hx8eTqQ7Pig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0124.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::9) To IA1PR12MB6460.namprd12.prod.outlook.com
 (2603:10b6:208:3a8::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6460:EE_|CY5PR12MB6549:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ec5bb2c-8982-443d-6196-08db675af2dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	FEeGJtu87mBuZXPLY8X5uQ+oHHNZzifqFWAxbyQ8t0JCXVId+d9bAbSAIpcJUHZuFrIIEpIElOs21OM+r3voM2RlFzgCqKBNQv8DworRoBocw32DPPR0CTMbqEZm3cElCz4WmnXINElQQwBZoHZT/r2xbmKgk/BBeSH2HxoRgiCV/bdGryMuppwNEohlsyxr5x7SlLA7NSk6ZV9v2XGLK48545BjnVhaoKnBPNcpemY8jQlu6nsjwF4n8XHa7VLF46SQhTsvb6wi0r+JJ5TftvQw2G5lqzTHCWJHjQRVCe9COQlexWxtyMY+oj4YCnCLCzPsdWkltTG9Y3E5r0HQqc1QgjZyhO1m7kuN6yGLrWLOWlIA1La7/FM4FNmWP5IwDdP1bzgGy5rgOdgjYSZoDxQRuD+ju1JL7Fk21otSvIjvq89nTY1t+2ZX6P8B/W+dQZMn7CKtAWYU7GErJ4ECvt/G3jDboqgCT2wFfNjZr6s1YRTLAKT2ExBShw7xDylD66DLgxx9QOmxpErDUSncXlNCvuY13pTusV4wbbgij5XhoduOHpb2sfdyyLLhhrnaxcXKFSgujx0GlQ7HzG+6Ap8/l3b+pBUOXBdXBnAUbrdw5mR2OdyZiL5GDyIZyW1tsoDlXbop2RBH8lz+zR0Zvw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6460.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199021)(2906002)(2616005)(36756003)(31696002)(38100700002)(41300700001)(6486002)(316002)(6666004)(5660300002)(966005)(8936002)(8676002)(110136005)(478600001)(54906003)(66556008)(66946007)(66476007)(4326008)(31686004)(6506007)(53546011)(6512007)(26005)(186003)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0RNUW9lVkV4ZG1weFY2MXcvWnBPQWY0ektPeGZ2dVdra0QxemlFRjBrY2Q3?=
 =?utf-8?B?Sm95YmZBRWs5MnBhNFVRQjlDT1BuUzlHVUxJVVRmTE5RaDRpZEZvNzRSaVox?=
 =?utf-8?B?eExwVkFaMVQyRTIvNWtmcHZUQVdXUHFxMzBYbGJ6WFY1VUZQTXJZb2U2TnF6?=
 =?utf-8?B?VEtUQjh2ejBiVGd3WDZBd3B6SVRkdUZyM25PL2F4ZGdEaTNyR0p0Z3NWNHpN?=
 =?utf-8?B?RmVTTzJUM0RvQUxpcXF0MVpwNUJ5L0JzYkU1TnZZSDlLSnpUTnhSZ1FZc3hG?=
 =?utf-8?B?NitqUjNIUFpYTk5yam1QYTUyM1h3S1pqaEIyWGxKRklmb1JBSnNoUVZtbXo2?=
 =?utf-8?B?TDhKOENqMHpVRXdPa0UvOTduL21iSTBsNTZBU1BpZzNvaG5hclpmTjJlZStp?=
 =?utf-8?B?OGoyWWdVS0NFS05yODZrS2ZYRS9zdStvV1ZXa0hFc0EzZEVBUlpwS2p1eENE?=
 =?utf-8?B?Ny9tSGN2QXpUM21oV1oyZnRSMWRWV0IwbmhoM09hajdWRnZ0by95UGVjY1pR?=
 =?utf-8?B?c2U2bkRxbVg5KzhBQVdTL2swek95N3dCQ2FJbk5yZEJJT0xjMEViQ0FhV1RG?=
 =?utf-8?B?NWVwQTNRUVQ0bW1VQnNrOHp0SUtBQ3lBa3V5aFJQbEtMOVBZdS90WXJyeWNv?=
 =?utf-8?B?YXY5MWtDekhaS0dRQkhUbWtNQzlhYmx4Y3FGOENHbXJib2dtNHhhTURjaktH?=
 =?utf-8?B?M3pteEtQWXJ4K0FEUTEvQnUyVEFmeDhxRXFoWmNoWDIxOFJ5K0JCdXpIQUM4?=
 =?utf-8?B?YXRDU1hBUjVvWTRidjF3cTdqRDhYai9HT1lZKzhEbVZnelJpUEdtYVcyRndW?=
 =?utf-8?B?N0dOWU5jSHg0dzVEUFdYQkozeWk1ZjNuOTVqenk4dzcxbWpJRGgwU1YzQlhH?=
 =?utf-8?B?bG1Fb3F1V1k3WlRyZVdHTStCYVRCK1RNS1FrU25UUWd3a1FmZlJOalk3Tmxq?=
 =?utf-8?B?VkNLOFp2QTJwVFhZdG5PN3V1RDU1bjRQT2cwWlgvRFZHa3oySjU0aEdVaUwv?=
 =?utf-8?B?MEdaR1ZETXlHOVVFSlVqL3F1di9KaXVBU0IrazUwVGI2S3h0T2dLcHZPSkt3?=
 =?utf-8?B?bkFDcCtvY3cvUVRuZVg1REZkczNEQ045YTBXeTZkaHBUL1VCNWd3Zy82SzlR?=
 =?utf-8?B?L2w0c0hXOFZFU3NuUWM2V0xPZmJJUFJWcEhWSC9VNXlKalg0UUVBL1F4L1BI?=
 =?utf-8?B?WG42NVg3aVFtcGd2WlNtWGkzTFpuTW5YdkE4OStVT1MzU0J0MFBRMXlnQ3h5?=
 =?utf-8?B?NVlWUm5OMmE1eHgrRVovc0JEbUxMeklHa2huZHFtU24yZStVc3FqSHViUWJJ?=
 =?utf-8?B?cDdjSGY2eXRsRDV2c1FOYjMzRmxoT044aXZhcnpDSDVkdjV2RlJXNitPclFi?=
 =?utf-8?B?djMvUW9vNUczSkhPN1JHZFByMVpPZG9WWEUvdnlXZHRRdktzWGdTeDhDNWUr?=
 =?utf-8?B?cnRpL3hsaS95RXVJczJvRGRvMGx2VTJiV1FCRkVlamlhTGI5enNvYzFWa0gr?=
 =?utf-8?B?MEluUHZiM0pqbEpmcnFEdHBqbWlpR0V5VkZWSjJyaWs1djRCby9mTjd3aGZF?=
 =?utf-8?B?eXlUbU54YWVGUFduTVhrZ1lYTG9OYVQ2TXlSUXNTMjFleHlORzZhdHB3N214?=
 =?utf-8?B?WlA3bFJ3MGJ0Mlo2VmJtd0lGWkd6VmE4Yy9IUFp1RXZNS2dROGtxT2l1d2dI?=
 =?utf-8?B?cGQ5bmxITWx1T3Z6U1hIVXptWXl6MmZaNmFNZXhhWDZ1ZnJFM2huQ3hkOVdx?=
 =?utf-8?B?Nm8vdmI5YUtwa1V5RXN3UTFjcktzUktVdG11NnBCeFBCM2VOeERscTV2Uk1r?=
 =?utf-8?B?cFI2aUlVQUszT0dCL1FlRFJxSEUyK3FCYjlQZlpWSmtnd2k3UVlncWs2c1Jx?=
 =?utf-8?B?RHI1Z2tVQ1dVOWd3V1lyOUxvZWJHV0x5R1ZCOC96a1JsbjI2T0pBajdUaS9O?=
 =?utf-8?B?QlVNa0I5ZU1JQStaaVN3U0NpSnRId3FjY1lzdG9GRjBoN1lFLzlrN1dROVlN?=
 =?utf-8?B?eWVYM1RyVDVmdWE5UDFBVmlyYitqOWtjWk41L2gxemkxbkxIWXhrRWxlZHdn?=
 =?utf-8?B?NjVWcktSOVprVWg1Q0JUS0wwc2pQTElCVlM3R0dDamM3UzI4Tk13cHd4NXlu?=
 =?utf-8?Q?D36R0Nlrsjo8rYi3J7em1u7iw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ec5bb2c-8982-443d-6196-08db675af2dd
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6460.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 13:27:32.6331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ERCaqShwDodu3cekifJ2kDITg110BBTUZN7XNOSSbdSqv+QinAN2ncYJw2Z5qQcwF95CgPHNZvqeN9S9OmZuEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6549
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/6/2023 2:31 PM, Geert Uytterhoeven wrote:
> Hi Naresh,
> 
> On Tue, Jun 6, 2023 at 10:53 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
>> On Tue, 6 Jun 2023 at 14:17, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>> Following build regressions found while building arm shmobile_defconfig on
>>> Linux next-20230606.
>>>
>>> Regressions found on arm:
>>>
>>>   - build/clang-16-shmobile_defconfig
>>>   - build/gcc-8-shmobile_defconfig
>>>   - build/gcc-12-shmobile_defconfig
>>>   - build/clang-nightly-shmobile_defconfig
>>
>> And mips defconfig builds failed.
>> Regressions found on mips:
>>
>>    - build/clang-16-defconfig
>>    - build/gcc-12-defconfig
>>    - build/gcc-8-defconfig
>>    - build/clang-nightly-defconfig
> 
> Please give my fix a try:
> https://lore.kernel.org/linux-renesas-soc/7b36ac43778b41831debd5c30b5b37d268512195.1686039915.git.geert+renesas@glider.be
On x86 as well seeing couple of issues related to same, not on defconfig 
though..

ERROR: modpost: "lynx_pcs_destroy" 
[drivers/net/ethernet/stmicro/stmmac/stmmac.ko] undefined!
ERROR: modpost: "lynx_pcs_destroy" 
[drivers/net/ethernet/altera/altera_tse.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:136: Module.symvers] Error 1
make: *** [Makefile:1984: modpost] Error 2

Among above issues stmmac issue would be resolved with above mentioned fix.
> 
> Thanks!
> 
> Gr{oetje,eeting}s,
> 
>                          Geert
> 


