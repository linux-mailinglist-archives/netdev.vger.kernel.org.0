Return-Path: <netdev+bounces-9433-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF0D1728F43
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 07:23:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A9651C210AC
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 05:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0291815B3;
	Fri,  9 Jun 2023 05:23:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97AE15AC
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 05:23:01 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2066.outbound.protection.outlook.com [40.107.101.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73BE2D7B;
	Thu,  8 Jun 2023 22:22:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlIUczk2uM/uV6YBk6Q9nm9GsQgMqcRaIlFBbWztMX/2Lmug065uq9dzyjwPqdV8K7k6GyrT0UrsF+jmu6fCFWS/Xs9Lg3WguTsa8rlgV6+C+wSES7GrzrAtdZzjlDefFA8lBwu5v6fFqB1Irm16jvR+3ezdz5hiWhjPiU/njKqWGNLTf0b26V3/08hteYds6zZ/rkMNCZsvNUxc1ogQwHtHVByug34j6Fh43U50ewe1Pi0nG5GVskq0ID+RKmwGaYszgPYQN6MZU5Y/uqRTHmReZFPlFBNB9IEwuhYUptuI03Y/k3jVl+KrCQvo5Z4RG6A17ILPXb9Gkyf1xEX5XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9N0Rqwjm/21Bopb2yvfCBbWWQJl8IaJBNeHgqoR/Jo=;
 b=oMMQYwx7nhW0ue6UB3zb9aUqaSL6df1IRpsv8o/2wYMULyVsu+q1LzZqeqqkpZ/2SueIJXi0XNVYZwI9ajc/zhOdK5Dxy5jLCelclBsrdcUM1xySgfAay9IhpWHZdBjjvW8fekAQNCKKoqkmWwClBYnhnWHMLMWmqyr9KfbAkifV2MuZj3QD7/MjuCvIP2qsSrjEuNyRLBw/dgEaWmiSPRMkQdMLBGlWYdSMgU3lg9YjPFKk5Ett1XNXb+j6kDutnPVjQpdCNkBlqSyn4WOLCUJZ8Pvnl/xo9hBxRVdCeUqYky/hqotz4mcU2dSZosqsnArN6PebBGfa93F5Tbu/sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9N0Rqwjm/21Bopb2yvfCBbWWQJl8IaJBNeHgqoR/Jo=;
 b=0Ay22+3d3YeExw6bGnqjgBLhUkwz9weXSd7X8hVwvNh69rQZ8NOpWB194apkbemLDjGnCaktbh8r8ehU4Q/+Z0sb82X2wi4S+Pxjb8PNSmLNMntg8kDyE2ppWy0ns2mcz2k/uqJJio5DjpH3gTOUAJuuxcwycVf7+p/Oxr7HLD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6460.namprd12.prod.outlook.com (2603:10b6:208:3a8::13)
 by BY5PR12MB4036.namprd12.prod.outlook.com (2603:10b6:a03:210::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Fri, 9 Jun
 2023 05:22:54 +0000
Received: from IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::f8e1:805f:574:60e5]) by IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::f8e1:805f:574:60e5%3]) with mapi id 15.20.6455.037; Fri, 9 Jun 2023
 05:22:54 +0000
Message-ID: <e5eda6ee-33db-ac89-4857-37cbeb3d6335@amd.com>
Date: Fri, 9 Jun 2023 10:52:39 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: arm: shmobile_defconfig: ld.lld: error: undefined symbol:
 lynx_pcs_destroy
Content-Language: en-US
To: Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: open list <linux-kernel@vger.kernel.org>,
 linux-next <linux-next@vger.kernel.org>, lkft-triage@lists.linaro.org,
 clang-built-linux <llvm@lists.linux.dev>,
 Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Netdev <netdev@vger.kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 Anders Roxell <anders.roxell@linaro.org>,
 Geert Uytterhoeven <geert+renesas@glider.be>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>,
 Maxime Chevallier <maxime.chevallier@bootlin.com>, joyce.ooi@intel.com
References: <CA+G9fYv0a-XxXfG6bNuPZGT=fzjtEfRGEYwk3n6M1WhEHUPo9g@mail.gmail.com>
 <CA+G9fYueN0xti1SDtYVZstPt104sUj06GfOzyqDNrd3s3xXBkA@mail.gmail.com>
 <CAMuHMdX7hqipiMCF9uxpU+_RbLmzyHeo-D0tCE_Hx8eTqQ7Pig@mail.gmail.com>
 <9fc1d064-7b97-9c1a-f76a-7be467994693@amd.com>
 <e5c92642-02cd-4020-ac1c-7562b1e03f7d@app.fastmail.com>
From: "Aithal, Srikanth" <sraithal@amd.com>
In-Reply-To: <e5c92642-02cd-4020-ac1c-7562b1e03f7d@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN0PR01CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4f::14) To IA1PR12MB6460.namprd12.prod.outlook.com
 (2603:10b6:208:3a8::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6460:EE_|BY5PR12MB4036:EE_
X-MS-Office365-Filtering-Correlation-Id: 55a2d8bf-cef0-4bd5-4a3a-08db68a993a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1lUf5+qm/ETCP2QvftfZK5FWyqK9VK55+GR/h/1zezbggrbYTl0ZG2h89bSxFABeUw61UPmznB9cFFrsDvgFlyMQBuLj20TztM5qF2hLk5chsh9j5u+yYpUzOcNYGs45w8iUj3Y48ME3MXscSAwFyt/GNkky7XcM5canOljOeqTe1Z8E2r0PRUPoUVBam/aTGAotL9ddGUDmcfF8WV4XF3LOPk4UKZ7ppof0GXKdL4wq3arUBVAitUz/wI4vkrP4CU7a/pxEKaQ+iClK/fgQA8kDHkK0taLsAPy/XvnB7zIclD967oqSSMHeg+gXL9Mean25fL+N7iyJiwIZcGrR4mv8QTzzyA3n40L/n8eCNN//g/lrdbyDE7wv86ulzuD+rN8p3Lvu/eIf/ZUDr1xjsO94AqvQq9aHl4yXSHi1GEv7fOK4g0IQh3ywjqdTB7T2dh+OeFXBE3CDJ6srn0LfUg9bY9IUtMUUvMXe1U4url+r8TUXHXLfksc1iBm+ilqGcUMDl4DFSdqKixqBA2HvkWbxSGXRFzssS2MvMW94ussVujhNPmyVVHnvHstXlNJtonnmyVUjwIZ8rq6uXQwOKeX1ObRxZn+udu1W/ZGI3FHA4TbhKR9HCE+FYuD7Zt44CdUGkbEkRnZBAX/br9JiXA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6460.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199021)(31686004)(66556008)(478600001)(66476007)(66946007)(966005)(54906003)(4326008)(110136005)(316002)(31696002)(36756003)(2616005)(6506007)(6512007)(53546011)(186003)(26005)(41300700001)(8676002)(5660300002)(8936002)(7416002)(2906002)(6486002)(6666004)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2hOQmY0T1NOUTBtYmlaZENqSkNUbHZPVFpZMXl1ajZObjhTcWRVOEhaU05I?=
 =?utf-8?B?N1J6UUJ3ZUw4cFM3V3lpUnlzM1Fod3dlaGphQ1l4UGtyVlRRTkk5VEtKV1lE?=
 =?utf-8?B?UVB5Z3l2T1Fheis5eCtQQitYWmF3dXZoRVdwQ1c2MWp6MFdTRndjTkhzQitt?=
 =?utf-8?B?ME5iKzczK0c3MWxTVVFtTmZJZ0tLYi94Z2huRXhrMjFMWk1FVHd1SEdTOG1k?=
 =?utf-8?B?MUsySVBFc0oza21KMGJjYnJ4NUFpSkZYT2ROK1UxYVR3bWx2UFYySUQ1RjdR?=
 =?utf-8?B?a1htaTJwWktaSElVM3d5bE9HdkZ1ZzNTRHF5ckVoR0dYWi9VcllWRWtkWTlX?=
 =?utf-8?B?ZUh1N1NPOWJ0eG82dUtINDRlKzBNWFM2bmNiMHF1dVIwZXJ0R1pMd0tKTmRT?=
 =?utf-8?B?dW0wSmZndWRVdFdaT2dLRTNlSU1iRWp6a2ZHaHBMeTJZY3Y1OE5TdGh0WWJ5?=
 =?utf-8?B?MDdhM3hOK3JnQmRJcWJvZFBtNEluTHYzc2FvVTE5STFtMUJDeUpPdjJReXoz?=
 =?utf-8?B?TEdOTDRMNkJaSWQ0SW1kV1ZVQUV2U1BxWWZtRCt3dTljSFY2akVraStVL3l3?=
 =?utf-8?B?dXpjSFdBZmFqeXd4NjNtMmRoL0JWaXdZUWlsaXQ2MjV1L1Y0ZUM2R2ZhOE9I?=
 =?utf-8?B?SEhvc1daTU9wa0lTNlpGUDVEQS9WMUY4SHJpYmNEUFp6aFFyUllSMDAweTA4?=
 =?utf-8?B?aGpHc1pqMldEWEg4aDU2R3JraTJMdjRlQjg3Q2RyREFmNXdLS090c1QxNFZy?=
 =?utf-8?B?czV5dEJaTWtSM011K1ExRzllaHdPYy9BSUQ3OTdoMEI5MFFybXBjU0FSUkIx?=
 =?utf-8?B?QkU1c25iZndhU1BEeVJEUWRSczRIYklSTkNhZnYzR1p3dWRuUnNOREFERmtU?=
 =?utf-8?B?MW5tZTlDcW1Zb3pNMVhUUnp3Z2cydWorVGVLb2h0U25HS2EzU3NvV3JZWUtF?=
 =?utf-8?B?RjJPcFlvWnZ4UUpNbzRwZG12K3loaU1OKzlQSnppb2ZwdnlKcFZ4ci9tRDZR?=
 =?utf-8?B?Ni85dm1GVmkwN3podUNMZE92bks5dmZHdGd5d0ZFaHpIakhMMU02c3czZlRJ?=
 =?utf-8?B?cm1GZFV6U0JwTlhRUDk4N0t2aW9EZDFLUzdTWU42dEVXQjBQdWdOS2pJc1RN?=
 =?utf-8?B?NmdaTUZlNXAwZHVaTjgyMkJEOWhGOHQyYllrRjFacWxBS2JRRFliQWxlUlc2?=
 =?utf-8?B?KzdNdjNVSW5yZHpCRHRpbWNNY0VSM2JqZ3pYUXdVRUNHM2RuWEtZWmFoeERD?=
 =?utf-8?B?bngzR0NidXl0bXY2QlFSelVSRk5UQVNNcWlsTDN1dzJUUDFKTDY4Sm01NTY4?=
 =?utf-8?B?OTRDVWQ0OEdVZHlxY3B4L0VhdmYwbU1LZmcyYjdyZEN3aWF4N0tobVVCbzNJ?=
 =?utf-8?B?REdHaHhMSkNVQnJSeTdXMXZTU2RUaWt2V2FYTnhQRE5RYkZvM3RWNWJiVVpF?=
 =?utf-8?B?ZUh1MVV0ZlRRNEp2cy9FSjJPSjFicWhNT3BQN0xXS0RLRHkwbVZXaFlhOU9v?=
 =?utf-8?B?SER3ek5VeVdwQWdIVmNBQklFS3lOeFNCTEJ5bG1rRjhLaEYwNW9kYjhGRHQy?=
 =?utf-8?B?aXJNS3ZUNTFBOCt3SHZQSGkzRE5PUjMrcTY3bzFmTHRaSmNvZEdydldCSEZw?=
 =?utf-8?B?RHBUdTJJZjhlbGpVYnNCb1Y4VTUvNEJyaUFWZndaWklGTWppNlV2Yk14bXJi?=
 =?utf-8?B?SzQzRTIxTzF5QUhpYXZGemxlRWJkdkF2NWtuRm94Q0VFUzdTYU5xZXk2N29U?=
 =?utf-8?B?N2dKazhGYTk2b0FFamRqczFXRG1nTEgzR2NCNnBuc2tYWnE1QnFYNEdnc2JV?=
 =?utf-8?B?VzlNQmkvZFBsR0RwODF0YnlOcm9mbTJrNkVxZCtnUG1VY04wVGlidWZIa0Iw?=
 =?utf-8?B?QlpseXJCdjVaWkllZjBuTVZwcmFqL2tBZGhRWFhwQ0ppQjlzT013blVuNk5k?=
 =?utf-8?B?Rnh3YUVnZld5ZWR0d3NLb1Nnd3gwOTZMVmhkQnJnV2xSbS9oTmpaUGJSOTkx?=
 =?utf-8?B?WjBzZkhDSEtHQ2J6cGYreWdBdFlYZG9SbisrYjVRdy9QNHA3UFpaSjZOTUt3?=
 =?utf-8?B?ZmFjWFZiVUUzZXVaTDN5UTM0TVZwSUR4MmRvSTAyWG9TdG4vVjNOTU9PdmVC?=
 =?utf-8?Q?1VGVDxNhrlXGfHM68e9nEBs07?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55a2d8bf-cef0-4bd5-4a3a-08db68a993a2
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6460.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 05:22:54.2320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AXRwU+wpGt7uIcUZ+wvBP0ZwbIDSLqVKQ3i4u4CzZdHl5flOYQsjCTkbQEUzfnpFff9vHqw1m37syOauxZYkfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4036
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SCC_BODY_URI_ONLY,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/7/2023 7:29 PM, Arnd Bergmann wrote:
> On Wed, Jun 7, 2023, at 15:27, Aithal, Srikanth wrote:
>> On 6/6/2023 2:31 PM, Geert Uytterhoeven wrote:
>>> On Tue, Jun 6, 2023 at 10:53 AM Naresh Kamboju
>>> <naresh.kamboju@linaro.org> wrote:
>>>> On Tue, 6 Jun 2023 at 14:17, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>>>> Following build regressions found while building arm shmobile_defconfig on
>>>>> Linux next-20230606.
>>>>>
>>>>> Regressions found on arm:
>>>>>
>>>>>    - build/clang-16-shmobile_defconfig
>>>>>    - build/gcc-8-shmobile_defconfig
>>>>>    - build/gcc-12-shmobile_defconfig
>>>>>    - build/clang-nightly-shmobile_defconfig
>>>>
>>>> And mips defconfig builds failed.
>>>> Regressions found on mips:
>>>>
>>>>     - build/clang-16-defconfig
>>>>     - build/gcc-12-defconfig
>>>>     - build/gcc-8-defconfig
>>>>     - build/clang-nightly-defconfig
>>>
>>> Please give my fix a try:
>>> https://lore.kernel.org/linux-renesas-soc/7b36ac43778b41831debd5c30b5b37d268512195.1686039915.git.geert+renesas@glider.be
>> On x86 as well seeing couple of issues related to same, not on defconfig
>> though..
>>
>> ERROR: modpost: "lynx_pcs_destroy"
>> [drivers/net/ethernet/stmicro/stmmac/stmmac.ko] undefined!
>> ERROR: modpost: "lynx_pcs_destroy"
>> [drivers/net/ethernet/altera/altera_tse.ko] undefined!
>> make[1]: *** [scripts/Makefile.modpost:136: Module.symvers] Error 1
>> make: *** [Makefile:1984: modpost] Error 2
>>
>> Among above issues stmmac issue would be resolved with above mentioned fix.
> 
> I sent out my version of the build fixups for altera and stmmac now.
Thanks, tested with next-20230608 and it builds fine.
Tested-by: sraithal@amd.com
> 
>       Arnd


