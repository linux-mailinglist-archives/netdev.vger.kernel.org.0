Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507D24EDFDB
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 19:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbiCaRnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 13:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiCaRnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 13:43:49 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2120.outbound.protection.outlook.com [40.107.236.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2354119531A;
        Thu, 31 Mar 2022 10:42:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QzUkZBT9qXb+ye4++XuPlpCZRoIZPeCu24sg3S6jJ6x56axx2gbe97Xf+iPlRgS4wDjM8V8mARxsnFIm4U21RSWDtuFu4f4E5igddJW8+Nf3z0w5thiRC7Qo7k6RtNClGZHgytGweQAycfA9RYVXt34lEIV+5mR4FTDNwN79Smu1Y8IoCx8TRcpSeJ4wxoiSGqMFo/Z5CRC5rZG+2HbgxpjXF4IURn48q6ZBIrFCURc5UWt6wt53831R+d2RB3UCJFdiiSkG5EHDMoNQRU6/6TnrRrJd7tgUVmOskLBT+l2NU4DQLIuJX/ITckxlzzeN18BA9iYez6LftUfz7FrnTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4nthsQUwwy3SNimEKVNm6gIuwndUaXEEPUgShVX0JCo=;
 b=TN9jh6bcibhPAi2e5mOUenrOuSIaSjWZeS0iMSJRorwlvhvGC8d+re19EAv71CYi24Rb6TcGzmtrmzBSW/oFRMjE/JcM3IkpN1V8oLGjBMBiT1oeWT7GUGEd18lMXDik29w6cv9F3LYUEBSHWLjs2VXLMfAu9GO9HI1iuSDxn6n2ejEwsTXjaKHzlxuyTZefaIAdjYbCt6/t2yqLrcY1l2T0tTqZtkByIzElkY7JrfMid4XjZSvIOHZ9VGsNxFhqYi+r4IWjwp1DA967NNR/PnzusFw4bvfvHfItqE31pynYXbeYl0tnbCs2IdF4jgbZdr2moM0biSC3icsEwjrbEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nthsQUwwy3SNimEKVNm6gIuwndUaXEEPUgShVX0JCo=;
 b=fpNynq2T/mBhlDBYRS9p+nXfBMfQBCmDd55tZJr4lSnD00YiRqPx/Xr1c2QWSK8/5Gl3tdDyXndVS5DinX8amr9c4VJRPkSIpEFSupNBKvssoPRCni3U2YysT+kuzQ0oFxtv/9KzfdrjgFhYNqRzakCIPqkevx2YAtjTevkhVpmDQ0cHSffAlCXlAQbg2BfDHyp3BSwhZTW1vhTtVVpB7sKy6h9IfVha6KcPxruJeeR0YNbK70KUGKXnBg/Z2q2MXNPmucwlKb3B9z9aEfqNcUps9q7k1s8HYADkwd6UJr4pshwSPL4FUgTYaCWDRj6/BqW2xLQ//uZ+94zg/aZIjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 BL0PR01MB4628.prod.exchangelabs.com (2603:10b6:208:74::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.21; Thu, 31 Mar 2022 17:41:59 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com ([fe80::98bd:3eac:d0e:875])
 by PH0PR01MB6439.prod.exchangelabs.com ([fe80::98bd:3eac:d0e:875%5]) with
 mapi id 15.20.5102.025; Thu, 31 Mar 2022 17:41:59 +0000
Message-ID: <865be9e8-3702-af45-95e8-1371dd6c43b2@cornelisnetworks.com>
Date:   Thu, 31 Mar 2022 13:41:50 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 11/22] rdmavt: Replace comments with C99 initializers
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        =?UTF-8?Q?Benjamin_St=c3=bcrz?= <benni@stuerz.xyz>
Cc:     andrew@lunn.ch, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux@armlinux.org.uk,
        linux@simtec.co.uk, krzk@kernel.org, alim.akhtar@samsung.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, robert.moore@intel.com,
        rafael.j.wysocki@intel.com, lenb@kernel.org, 3chas3@gmail.com,
        laforge@gnumonks.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        mchehab@kernel.org, tony.luck@intel.com, james.morse@arm.com,
        rric@kernel.org, linus.walleij@linaro.org, brgl@bgdev.pl,
        mike.marciniszyn@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, dmitry.torokhov@gmail.com, isdn@linux-pingi.de,
        benh@kernel.crashing.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nico@fluxnic.net, loic.poulain@linaro.org, kvalo@kernel.org,
        pkshih@realtek.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20220326165909.506926-1-benni@stuerz.xyz>
 <20220326165909.506926-11-benni@stuerz.xyz> <YkAMlurdV15gNROq@unreal>
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
In-Reply-To: <YkAMlurdV15gNROq@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR0102CA0003.prod.exchangelabs.com
 (2603:10b6:207:18::16) To PH0PR01MB6439.prod.exchangelabs.com
 (2603:10b6:510:d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f24229f2-4402-4b20-4bbc-08da133dc16b
X-MS-TrafficTypeDiagnostic: BL0PR01MB4628:EE_
X-Microsoft-Antispam-PRVS: <BL0PR01MB4628650EF23A2AF3ED0361FCF4E19@BL0PR01MB4628.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VC4OkeZou/iQix7LBPwrLXLVlnNgYaluNvLjbE7jgV/SZnR9KhuCNQcq38Aq4JdL6VwWFVMLgm9sJLJa4ef3lcl1VpuFjJ0IDWW245xDJhzLFVm0TnkYvH4+KPaQjeN7i3VeOZmK+1PuBnuJSPCTUvdVtdAz8iCWFIAlEaBXc+iJ4sh34vb3Zas6fudTLPicgkIsNFfuer3e2rSbMR6nzc8DgpXH0twFke955qurHK/vSgOkN2ikSV/KME30dlE6L/RyQwESzwAe0vTq1pIb0XX1Qj6qJ3SLIif1ZV62VV3g/qm9EtynLrxS/+TAIbLP+vbZIR8zGPHyovT7B8KshOfRGlJE/5kKFA4ZPv5vSp2KqMbjZ7xn8Dryz1d36ahwhYB8wodlj8HbLyEdgYVjQ5w2UgoN+BNpE6w9Gy5WaXXhBRLdT6b0CPLYYYf/2lzX8lgQnFWMalQw87IK1PCyHMovoPFKkBE24rvLd0yitpbtWFNKfOVDxypPMAXWTXYRT5V8B58A0Nrhk/gzASOcTFHUWlkRIxLEceUQurIrYn0bjsqbWp/cTypgOm3yOt4XUGSfrj4ymPk2J3YZCenNZGCa4/vQI6guW8OeUbN5IxPDFhT17UyFVFNrIHkaJ02GhEZ2Hkl/tXaqDuuRjijwRFYMKkl9uI9QNQlXpWhI1B0wNBsih0E3P/WuYesQmcvcnwPRUgI3MsAiqZQHJ3qRQo50KtiWKpEkxZK5vBljFFk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(136003)(366004)(396003)(39840400004)(376002)(110136005)(38100700002)(31696002)(86362001)(316002)(4326008)(8676002)(66946007)(8936002)(66476007)(38350700002)(2616005)(26005)(186003)(66556008)(5660300002)(83380400001)(6666004)(508600001)(6486002)(6512007)(52116002)(6506007)(53546011)(7406005)(31686004)(44832011)(36756003)(7366002)(7416002)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUNkTlp3bUdOcS9sNXFnNTRoL0M5bXNzcGRQRmNwb296bWlrYUp3MFFrNUUv?=
 =?utf-8?B?ajBOK3VIazlLMUx0bDd4Q2M3ZHRvREQ1aXNER3JSUXJZVk9TYmJJQ1FhV2Mx?=
 =?utf-8?B?bHUrZTJKdFNxYll1eGc4NVJHYzA3OE0zOFpZQ0piVTFNLy9Tam5NcUZaZm02?=
 =?utf-8?B?Z3NVMUc2bDZsdWlOUVVHbDJhZmZid0R2TEkrYTRGY25kdGJkMjBFbVloTURv?=
 =?utf-8?B?QSs0RnhhczJIRDJ5QmpCaTgvS2EzRC8wdDYyTDBRR2IrRnUxamFQSmEwNWZk?=
 =?utf-8?B?S2VLVFl0QlNUV3FBME9CWEp4aVJIZklOQm9JckZoenZMRjR6VzdOZlpnREdK?=
 =?utf-8?B?WEQzNnJBZDgzWE56WDNuNW5NdEtEalFpK0ZrQWhORU4wSnI5OXVKemtrbzNI?=
 =?utf-8?B?aTBCUjBDQUI2QzZONWgzOWxFbHlKbGJiWVhUd2VSYnhmOGhvWHNTbWRGK3ZH?=
 =?utf-8?B?dXlPeUxYNXZGd3dGenpiMzc2OTllR2RTQW96cUhjTGVJa0E3WXU2YTlMdExC?=
 =?utf-8?B?S3BYMEFVY1ZyZ05qR25rTUtzOWtjSHNSejBtUGdBQXJvT28vaXAzc0dEYzBn?=
 =?utf-8?B?b1ZWTG5FRGhjUjRxTlg1WDZuZnpNMGpyODF6T3JXTzVNLzVLNXNEQTMzY3R6?=
 =?utf-8?B?alFzTlVSLytzSXVHZTJxcUVFbVdmUloyelQwZG1CVG8wVVdxQkdoVUo3WjV0?=
 =?utf-8?B?N3F1a0ZHT2NuRlR0UlA1TnduTDc2YmdzUmkzSHRTNjQ3blNNUVVzQ0Z1cEdQ?=
 =?utf-8?B?cWZtWTRnWVllRlhKbGtiL0NZZUdLbUt3ekNTUndac2V0THdHMzZLYkxDVUZ3?=
 =?utf-8?B?NW55VWU5R2tYNlhUUjJwYnJaT2JTOFhpMzVpTEh5SVUzNXhlLzdidWN3VWpX?=
 =?utf-8?B?SmhXZUtnb2xNN1krbmcxSklmaUg5MitrOXJFVTR5emVIQXFtQVRXaEduNU1h?=
 =?utf-8?B?YnJvT0w2UmZFNHdIZUNVN250UlRuRHEzTFF1K1B6VVIwNDhtOXFtWGcxangz?=
 =?utf-8?B?NG1jcHNRdk1NdUx4ak01YXhYdEhaZlEweU5weGhHN1RzK2tGbi9DeHFWYmNF?=
 =?utf-8?B?L3llY01sdm10SGs4SjVPTEhXUG1XZFVyWitCeU5EQkJyVHpCNi9hd1JodWNs?=
 =?utf-8?B?bk1lWndHTEtBYndHMkhpRGRWbWVReE5SQWpHSDYrSi9SaHh2WGd6S2hsNlhH?=
 =?utf-8?B?dHQ1VENIZ3hPa1lVb3N1RVBFc3lUVWNzT1lQVHMxczMxRk5uUWNYMGtmb0lI?=
 =?utf-8?B?a0toMHZ4L005RmVhK3k2NngvZ3dTcStJdGk4ZFh2bGlHbjJ4S3B3TjlsMjlN?=
 =?utf-8?B?YXBnMHNBWHluaUtEalZPeW9wYWZxZGR6SFQzZmtXZ21GcHpFVEFOTFEvTUtC?=
 =?utf-8?B?TitDOWx4M0ZkVWZDTVdWVHpGY0NTVW9MTE04cTk4SU9pZklmZXhDSHZBVkNx?=
 =?utf-8?B?VEFGcTI5aDZoY3RCNlhHa2RYbG5KZWlObjl0Q2VJM1JVb1FMYVQzUVhHTkc0?=
 =?utf-8?B?MFdaR1BSaGhKWlRqcXl1K3l0K1Z6V3l6VVdVa2JQaVNjZnZsT0J3b0RVemxF?=
 =?utf-8?B?SEhYOFA5YXZVelBWWHd3dVNSS2lqaTMrY3k0RGw3WXhYVkV6WU1tU1lVSDhR?=
 =?utf-8?B?ZllReW9IcjdJZ3FNYjJtZFZmSUZwSEhnN1JPaDFoT3c5Zk1JSy9weDUyVWU3?=
 =?utf-8?B?bk9SNElDYkE0WUpYT1A2T2Q0ZUxXM2djR04zcWlkeUtMVGtzanQyV1N3M0Y0?=
 =?utf-8?B?c3BiVW82V2NpWUd2eE5GK3F0VVlTdkttWW9Lc0lCK0ptaDEvcDRQK2VYQndl?=
 =?utf-8?B?QzZIVWhEcmk3M3Uxb2kyRHQwZHZLUGtGVi9KbGwyYXIwR0oyc1pyUElad2gr?=
 =?utf-8?B?RTdTUEE1RFRUaFFSakY3aktVOWwxQWxyZ1Q3eE9QVzQ0aFNjZGJlZVBtREtC?=
 =?utf-8?B?WWxxOXJqczVhQXY5eUJITklQeXZ1WG5RYjkxRjBiU2d4aXJScGlzVVhCR2NW?=
 =?utf-8?B?WGplQitQWldRZEZyaCswdW1HeWNIV3NTOHl2Vy8xdVdaRURmQ3F1Y2Qxd2hN?=
 =?utf-8?B?Znhqam5FYlBMMFg4QllvWUk2VFEvVFlNb0E4U1Vld1kyVjkwWklraDVOeDZ5?=
 =?utf-8?B?VUFoUkpYa0tMM3A0QWY0OXBvWXBML1lqZmVmM0EyaitiaGlLQkVyZThTTnpY?=
 =?utf-8?B?bmN2d1NJaHBRVHhyZzdFQkxpRGdTbXFudXVSZ1VZaTNzZUw5dUFqZ3BKQ1Iv?=
 =?utf-8?B?ME9OdTdsNmV3WHo3bkxqdExuaGRneFRZY1JnaUlQTXpXeFN3MlNUL2xxSW5Z?=
 =?utf-8?B?aTlSS3RycEMzd0tlbTdwUitjMGJHcmpJSWRaRDJSSG8zMVFiNk9RODh4RHVi?=
 =?utf-8?Q?dTu9FF7dPua+g00boSWzEPduptu4VuScFaxp2?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f24229f2-4402-4b20-4bbc-08da133dc16b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 17:41:58.9049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u4f40gDKtLc5nZzWwBrJLy9psIKU+mR/YNVKGDb0V6uhEBWCLlUIPr5nOmCQVy57yz8R2i5+/eSDcZvZoFLmwTPRjb87ZaNrwTwDkbOEAsNpMSG/uNvYpx/JWg5CzBL9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4628
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/22 3:04 AM, Leon Romanovsky wrote:
> On Sat, Mar 26, 2022 at 05:58:58PM +0100, Benjamin Stürz wrote:
>> This replaces comments with C99's designated
>> initializers because the kernel supports them now.
>>
>> Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
>> ---
>>  drivers/infiniband/sw/rdmavt/rc.c | 62 +++++++++++++++----------------
>>  1 file changed, 31 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/infiniband/sw/rdmavt/rc.c b/drivers/infiniband/sw/rdmavt/rc.c
>> index 4e5d4a27633c..121b8a23ac07 100644
>> --- a/drivers/infiniband/sw/rdmavt/rc.c
>> +++ b/drivers/infiniband/sw/rdmavt/rc.c
>> @@ -10,37 +10,37 @@
>>   * Convert the AETH credit code into the number of credits.
>>   */
>>  static const u16 credit_table[31] = {
>> -	0,                      /* 0 */
>> -	1,                      /* 1 */
>> -	2,                      /* 2 */
>> -	3,                      /* 3 */
>> -	4,                      /* 4 */
>> -	6,                      /* 5 */
>> -	8,                      /* 6 */
>> -	12,                     /* 7 */
>> -	16,                     /* 8 */
>> -	24,                     /* 9 */
>> -	32,                     /* A */
>> -	48,                     /* B */
>> -	64,                     /* C */
>> -	96,                     /* D */
>> -	128,                    /* E */
>> -	192,                    /* F */
>> -	256,                    /* 10 */
>> -	384,                    /* 11 */
>> -	512,                    /* 12 */
>> -	768,                    /* 13 */
>> -	1024,                   /* 14 */
>> -	1536,                   /* 15 */
>> -	2048,                   /* 16 */
>> -	3072,                   /* 17 */
>> -	4096,                   /* 18 */
>> -	6144,                   /* 19 */
>> -	8192,                   /* 1A */
>> -	12288,                  /* 1B */
>> -	16384,                  /* 1C */
>> -	24576,                  /* 1D */
>> -	32768                   /* 1E */
>> +	[0x00] = 0,
>> +	[0x01] = 1,
>> +	[0x02] = 2,
>> +	[0x03] = 3,
>> +	[0x04] = 4,
>> +	[0x05] = 6,
>> +	[0x06] = 8,
>> +	[0x07] = 12,
>> +	[0x08] = 16,
>> +	[0x09] = 24,
>> +	[0x0A] = 32,
>> +	[0x0B] = 48,
>> +	[0x0C] = 64,
>> +	[0x0D] = 96,
>> +	[0x0E] = 128,
>> +	[0x0F] = 192,
>> +	[0x10] = 256,
>> +	[0x11] = 384,
>> +	[0x12] = 512,
>> +	[0x13] = 768,
>> +	[0x14] = 1024,
>> +	[0x15] = 1536,
>> +	[0x16] = 2048,
>> +	[0x17] = 3072,
>> +	[0x18] = 4096,
>> +	[0x19] = 6144,
>> +	[0x1A] = 8192,
>> +	[0x1B] = 12288,
>> +	[0x1C] = 16384,
>> +	[0x1D] = 24576,
>> +	[0x1E] = 32768
>>  };
> 
> I have hard time to see any value in this commit, why is this change needed?
> 

I tend to agree. This doesn't really improve things. It's a NAK from me.

-Denny
