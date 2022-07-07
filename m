Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C4856A682
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 17:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbiGGPBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 11:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236301AbiGGPBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 11:01:01 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2062.outbound.protection.outlook.com [40.107.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7882C5C959;
        Thu,  7 Jul 2022 08:00:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0nd8juVVxdlIYphYSYKTb4p6hFAJMCJ4ISDk/oEUFvr04hexuWws5pqH2fHQJHxLEdNN+AWfS7wsmwA2meNg+FCyjDdKWZqqsU7o7sXiu6XoAv1uf7P2XD0LX8hc1+Pwl8bFbUbXy289WQehpievQjWQaX8eNC7nEM88uIYDB0gCTjQgCzNA4rUyfCWFrPkgdQnnmxTFwFYuWyduk/dzXWXQgQvbwBRzOTptM9HcSyZJ8HcfEdtGKbUe7pb44RitPUs5+xOL5EJoRXJB+NhiPxBEQLz20DmKC57BPPMZsNgJrKlaIRNlCZ4JTsTzXgG2lWTr3ZwUjClFszJLpvCyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ecedMdUa9UhAfpsTIqAEINcbcP/2xpTrW3vWneaE0L8=;
 b=me0tur5dCQUxaTzXUgFjOEbIdAwYN2cCi4zpEak2xBOj0fa4XKjucM/EZodKsmn7plxGyrm5iKuhIyYx4MIZ5tJLKnEn9d/sUQASkt6XlM66YpEq87w4GjiI9xnxIi+Jl+jB7nJIrjsu8IyTRRxWtsxzjX51ruj7xRIgd9oj0cmYN+nHBMS1q+PSY1NJt9KpfCOOqU7ArZmTBdYuKivQg8/1sLqfGsMUUQSvJZ6CvNlrnaHCkKXXIsxRyU74ktJ78Liyxsgo/cc9s5NhxgX0GRLbIEAiT6HaeHNLMr+1y/UPTn9S6uGE8kOCftIAIdKFNKXt5wIn/SnCzo5Juw48gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecedMdUa9UhAfpsTIqAEINcbcP/2xpTrW3vWneaE0L8=;
 b=qt4OcKo2aokeAzEjsoGJ2eqCu2yMAZzAWQpZWjuhhF2mX/Op/PyJKGujXmc1RNtcFuIRFhnXkxkpCkbmBlOZifUaiJVwX/VVjJnKmGORHKWMldHnN3eFPE/X8Eq76k+WHuernCgRs8am3IT2FL9w454cL2aMhPKWhx5dSGCgxho50SmQd0ci6QODH423l1s6jCYVutKFMQGaS4yx9t8siq5p9sPmujXDMOmOXTg6tGSd/s5ktDlFqQQouixsGPxCYwudmxEVInd/0NrZk2NuJovreUpjM4LF9lCmtRbv6bAdVmb0H8TwdfgL91ijRyZZFNRLXjPUOb63eJmn+dZ56g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB8114.eurprd03.prod.outlook.com (2603:10a6:102:227::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Thu, 7 Jul
 2022 15:00:27 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 15:00:27 +0000
Subject: Re: [PATCH net-next v2 04/35] [RFC] phy: fsl: Add Lynx 10G SerDes
 driver
To:     Vinod Koul <vkoul@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-phy@lists.infradead.org
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-5-sean.anderson@seco.com> <YsPWMYjyu2nyk+w8@matsya>
 <431a014a-3a8f-fdc7-319e-29df52832128@seco.com> <YsW+4fm/613ByK09@matsya>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <e4664a59-773a-cb72-3abe-ab4bb69aa9ea@seco.com>
Date:   Thu, 7 Jul 2022 11:00:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YsW+4fm/613ByK09@matsya>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:207:3d::21) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5a07ca6-7ef0-419e-5cd5-08da60296d02
X-MS-TrafficTypeDiagnostic: PAXPR03MB8114:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z/5/6arsFB73NafNvLeQO0ufNAX3X5WS6CSW71rH6X8+e0RI9QUuUT1fX0HMIm73wwKChr3haIR6yi3KdJVZTpBFj99MR8LYz3275CnIWBho9fNbWlFNXM2dnAtrlvLwdJ4LSZbL5wSZTO1lrUUaeCn25SF6dR/AaYIb3AOD3aXaa7Il4OrEtMEAoPQybnMsEwpqvFgdchqTwgREMJfXpp1sKDUmCz93QhungFVm+fLf8omXhcjGSKvmBozXv7xsByiruvVMbFHAMj/9ZtiN6G3j/v8w+k2chUv4TWb34/98GGXmNBoExm3XwD2UuTCmzSVPRYfjrrxsAZ1hAooPV4X2EoUEbd3Fljjpl1006uRWhIZPQ1gLlPSJn5hDuhZnqwssrKarOWqDq4Y0vu7dcQUE6OUs3GNQDpscEFpKO1W8Uaf5m3Di0B6wQU4cIH+RV9y8yT7MgmS0OYa/HhvOVgqGbqBp9T+qGFeQJqkcxyElnKPEAmN3GJeDDxOTm/z7Z2ISTI22MkItRcnRKAahJ6DYfApVC5LN8oHp9Dpoqz8kde5K3jveRJt6WVLYbGOJhzbT4CEO9eEZ+q0Ihri3iDrgjwnwCTbs4VsU3ysOKv+HW+f3mtNmNf14qe3cFrFUuveX9nOHLcDaXOw26k+qaZ/NhH6h3I0cxG6CL2syXooZjZ7k1B1lPckGrof1QLnp03MYGxc+AmKYbR3sgxV9mIFBC59aCh+4TMu/PQoPdsUdndiY66muWzaMKnRPunP+rzrrA92u216e8CNaS6C0+OuzHZ/uwJClzw4T//TxKRSN6PRlT8mxZTSCQOTyIToGzrQZoRlq5DMZ393ZL4qkG9hjdBlCAX3I+xCpXmH94+Qls3Wnln21LwYOQMRWOzq0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39850400004)(396003)(376002)(136003)(366004)(2616005)(186003)(26005)(38350700002)(4326008)(36756003)(54906003)(31686004)(8676002)(6916009)(38100700002)(66556008)(83380400001)(66476007)(66946007)(86362001)(6486002)(478600001)(5660300002)(53546011)(6506007)(6666004)(31696002)(316002)(7416002)(44832011)(6512007)(8936002)(2906002)(41300700001)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmVqNWFmT0JOaTV6c000SzhHRDN4Y2djWnBMOUVZL2JzbmR6c0dJM0s0emRr?=
 =?utf-8?B?dVJabXR4UEs0VFY3aDJpdGhBaDhCSkNvSEtxVVUvMzR4NU9icEV5UnZBVGVD?=
 =?utf-8?B?SUZzM3pBMzN3d0FUMjFpUXBoaW43TDdMR0RDSVhSYjRzc2JZbUNuZmh1WnFL?=
 =?utf-8?B?SWVCUlRPMzRlQTY2a3ZlNWE4dHdmL1V4S1VHN1ZnNml5RHVNYWdjTFk0RWFu?=
 =?utf-8?B?NjJKVzZvcDUxZXFDT2NWT2xGV2x0UXB5ZWpiRGQ2cWgxK1FBQ0wwYlJPcEVP?=
 =?utf-8?B?ZW5PZVZHMWFWeW1tMHpodUovWjhKeFhrdnR5Z1RrOTZtWW0xYTlWQmJUeDQx?=
 =?utf-8?B?aVBHMUtMTE9uRTMvZ2Y3VDRQTDAwdXZ1NTFBWmRLcUtCY3ZvdU02bG1uakYv?=
 =?utf-8?B?UFZ1VVhJN1MwTUI4SGFGM3RQTGRTQUUrMTQwdG8wSWEzUUFrMWpLRG1iaW55?=
 =?utf-8?B?UHp3RW9SRHJNb3dEQVAyc1JmWWxyYlZaaGhQUVZIL1RmQ1kvakZBSkhzK3F1?=
 =?utf-8?B?RmxocXlqQmxjSjhicjlGeUNYQ015WkZ3UGxMSjU4ZjR0RzQ2alhRdC8vUTlB?=
 =?utf-8?B?TWNsb1lBOFhRckVFZWh2QlljN3BlbDdGSm5DMUxnUDg0VCtoS3lXZTI2dU14?=
 =?utf-8?B?cEdXY2QvUXY4N3NCcEJhKzluOEFKaWRsTjVCSVhvWHVRM2s1cHF6dVBIRVJz?=
 =?utf-8?B?QVV4eWFyNlFXMW5BbUd2ZlBPd25VTzZESS8vaFJSTm1teGFydUtRS3FISEUw?=
 =?utf-8?B?bjlyTnBVV043dGpDN0M4bldDNGNLTGlkVFhhc3RiNDJ1Q0dMWjdQSnl5V2JH?=
 =?utf-8?B?TlVWdzNLY3dTSG1seGJnWUQ4bjloZ3ZyMjBVVGZCQ0JXQzM3d3dDcjJSc01S?=
 =?utf-8?B?SmZCR1VpQ256aFZJRkszSHJtTEJOejhxNWpsaE9sWFFBbi90SFJzQzh1NlFL?=
 =?utf-8?B?aW1MNTFBMXhteXErYk1KTCtjaGFNeklndEpHL0w1SEVqR0Z3dXluS2ZlRjNK?=
 =?utf-8?B?MG5La0lOcDc0Y0NUN1RhL3ZINUl0ZDRQVXJwVVJlOEFnK2VzYnYzVTd0K2F3?=
 =?utf-8?B?Q2NhZ1BMN3NWRlRzR2kzTkx1WktCY0hmTTlzN0w5RTY0RjkrdzZhdnduMUhh?=
 =?utf-8?B?N0RrOWVYUnJvdWl1NUJxMUZOUm9nRHhxVXJpNlMrd3kyNm1jaFpFSXBVUEtu?=
 =?utf-8?B?RGNLRk1XekxIVEEycUtaK3k5Kzlta0JKMHFkRmU3YWViR0xOWk84WmpFbHFN?=
 =?utf-8?B?ZU9FajlqNDUxdEExa0ZVZFptMUNIcWs5VUFSRG1CVFFXVzUrS0ovV2RnOEJO?=
 =?utf-8?B?TDVSU1FZOXNPbXUrM1RraDI4R01YZUUxQ092bnUzcFpWdktFN1poUFVmUHgr?=
 =?utf-8?B?NHYxZDVLVitYeTZMV3g1ZXNQWFo5OUMvZXllQmprSXN5QTFWTTJIc3U1RFhL?=
 =?utf-8?B?a2toUFFOOFViVk9EYmtuTlVjRkdSOFZqWEtaNUpHZFkrOXZFU1JtaGNsczBE?=
 =?utf-8?B?c1RtM1A3eGRCajhoTDFOamNWNmYxalJwYnRhN0ZGaHp0elJKUlhrVE9LSVVK?=
 =?utf-8?B?WXUvNVZLS1c5YkpMd0NXSHVOVHZKRUJ4Mlk0dmRGcG9yN3JEeGNYdHgrdFgz?=
 =?utf-8?B?QnJFUVBKNi9JSFFwczZmL1E2T2VhYkJ1N3JUejJtVVByVVcwVFNzSlZDT3d4?=
 =?utf-8?B?OHhZTlgvbk9ITldlY2g2dm1CRTJSVEpwV0l2aDlYRXRaMVZ0c01aQzdtclBk?=
 =?utf-8?B?aEtEcVRSYktSTTA2Nm5tKzVpVUVCYnN3c3gxSFMzKzBBVFJRL0dkN3Z5bm5m?=
 =?utf-8?B?dGNDdklVQkVBcUluNzVqS1RqUkxCdUV2NzRyazJONFJqUFpFaVJKNS83ck9Y?=
 =?utf-8?B?cFJMcmIzL2NyNGsvbXozdHdrcUZOalZtVDU1Q09GcGYrZlE3cEZlT0YxZWtw?=
 =?utf-8?B?TTN6QU5iY0dBL05UT3N0OVU4eld4SWpVRjN6ZTIzMjJjN2k4NlRnUFdWZDhn?=
 =?utf-8?B?cFJQRDdQbzBPRURWQVhtL2RYMjNtMlBWbjZvWmJJR2ZlaG9HVC90VEdBSWF5?=
 =?utf-8?B?R0xvNk1kcWd6N211YXNOZnVnNjdqT1hFV2FhYVJybnBndXM2UVd6bk12VDJX?=
 =?utf-8?B?RC9OOEdkM1NLVXN1cFY2bE5DZDl6QzB3WTY1YUlLNk1RVTQ3WFVmVElNTy9l?=
 =?utf-8?B?UkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a07ca6-7ef0-419e-5cd5-08da60296d02
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 15:00:26.8424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /r6MRSZA4GDwcXoooFqBO4bzNSVX1olrpWprsDsE7tbNFuq93n3or5MMWTzN0S+UgX1KNIFu9syjE27VU2+Vzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB8114
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinod,

On 7/6/22 12:57 PM, Vinod Koul wrote:
> On 05-07-22, 11:29, Sean Anderson wrote:
> 
>> >> +	/* TODO: wait for the PLL to lock */
>> > 
>> > when will this be added?
>> 
>> I'm not sure. I haven't had any issues with this, and waiting on the lock bit is
>> only mentioned in some datasheets for this SerDes. On the LS1046A for example,
>> there is no mention of waiting for lock.
> 
> okay maybe remove the comment then?

Well, as it happens, on the write before this (where we request the reset), we must
wait for the request to clear before making this write. Since that needed a
read_poll_timeout anyway, I added one for this line as well.

>> >> +static const struct clk_ops lynx_pll_clk_ops = {
>> >> +	.enable = lynx_pll_enable,
>> >> +	.disable = lynx_pll_disable,
>> >> +	.is_enabled = lynx_pll_is_enabled,
>> >> +	.recalc_rate = lynx_pll_recalc_rate,
>> >> +	.round_rate = lynx_pll_round_rate,
>> >> +	.set_rate = lynx_pll_set_rate,
>> >> +};
>> > 
>> > right, this should be a clk driver
>> 
>> Well, it is a clock driver, effectively internal to the SerDes. There are a few
>> examples of this already (e.g. the qualcomm and cadence phys). It could of course
>> be split off, but I would prefer that they remained together.
> 
> I would prefer clk driver is split and we maintain clean split b/w phy
> and clk
> 

OK. I will split this into drivers/phy/freescale/phy-fsl-lynx-10g-clk.c

--Sean
