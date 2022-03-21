Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F854E25E9
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347090AbiCUME2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiCUME1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:04:27 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2115.outbound.protection.outlook.com [40.107.117.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FA42DC3;
        Mon, 21 Mar 2022 05:03:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4jHDO2kN0MfpU18zBQoVnwgQMgsDXKO1m2kQUn+fAD84F554J9wXR+jadjci6agmsGNmicXV/FZuS61yrUCH7O1dNeJqATzreBwIJhPzJI1L5JCK+S3SCNDyLIMHbHbjOh/Y13Tz7H+dEnegm468RaHXXfprZYPSo9fkH+4TruprGWnEK0SrGU6q3UrLteY+fhIOc4uJb9zAoWTgh9t8BkCGE/p7kYz8nfIzzJQ9Fj/NHDeWdnlrioAsSvn/zl63dKe2TAada2En1UAe2Hb6Z/7bD6bW07Mb1ElhTZfQeBOsbMqirHQwMqj7UpJrfBWpiDc1Uiayqv+gc++3Kx6wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLIhj/kfcmTyc96PiaD/b/4KuE8AevnfZF39zKRW8Y4=;
 b=BQh/ZCTgxPzWZ4lZiWcVyRtC87V1LUo0CdFYkRaRvVryE1DaxC4JSzEuh7Z65U8S85/GLbAx7JbTlUWbn3H2HIk7xTwzk5N32QyOCRHIY6zYz1s+tC3y3w0YBsvre7ye9foNRRfk6rnb+STMftMToUM2OnSMauL3AKOpVhNeywtqiK60AX2yxUmlpKvKD8LfjdkzhC5EuzG0/JH5o4VaL+CNAR4U4H6gmStX6RYGsdV9RJ2fxBqRhZQGiGs91foPUDV3ybNxKTCUcp9SFzDC2L/XwqdbXheiaVkgls/JNnar8y0r0tRchUjHF4LWoUI9u/4eU63NuqHgVQiNsYtX7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLIhj/kfcmTyc96PiaD/b/4KuE8AevnfZF39zKRW8Y4=;
 b=OGzq2FykAEjuVjVQaEkzIfGMWoeaU4Orsfsz7ZrZyx+RkH7eskoh2cLhUDgjZfOb01PCIaCS4geyBgEmNYz3x4i94ezTeOWPSwF8nto/CMO5KUVXhbzcDdiHbAbf0b01DKvxticZ1wShgJaGF4wCa5AU4MvWp3tVK4DIMRXvEdQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (20.177.94.19) by
 PS2PR06MB3590.apcprd06.prod.outlook.com (20.179.115.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.14; Mon, 21 Mar 2022 12:02:58 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732%4]) with mapi id 15.20.5081.017; Mon, 21 Mar 2022
 12:02:58 +0000
Message-ID: <cf2dd88b-908d-efbb-9d5d-7194e2ed43ba@vivo.com>
Date:   Mon, 21 Mar 2022 20:02:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [Intel-wired-lan] [PATCH] ice: use min() to make code cleaner in
 ice_gnss
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318094629.526321-1-wanjiabing@vivo.com>
 <8822dfa2-bdb8-fceb-e920-94afb50881e8@intel.com>
 <20220321115412.844440-1-alexandr.lobakin@intel.com>
From:   Jiabing Wan <wanjiabing@vivo.com>
Organization: vivo
In-Reply-To: <20220321115412.844440-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0134.apcprd02.prod.outlook.com
 (2603:1096:202:16::18) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f45b5d02-2d48-404b-cd86-08da0b32bc88
X-MS-TrafficTypeDiagnostic: PS2PR06MB3590:EE_
X-Microsoft-Antispam-PRVS: <PS2PR06MB359058818F5CD9EC9B13A9C8AB169@PS2PR06MB3590.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fuH454rbmb4bhOt0slPSEaRDHnUQrs5w7Rk9jlckU52eErrGVdwg3fQ4WYq3gXYro/MKbZw0fRXaR0Zv482eiwUgzTl/JJpkLJf9F+UAbM1nI+D//OygP8hSPz9DQL51leFCWhJiblCy93Lp7HfY0YyzRxEDRl30zunaPqkjkNtpMvPLeYZJNAUm4NZnbW2PwjhMEMhEvb8IXef3dyVc3CthwfhoMLwdzYgvd437BODyjZTxaoXpTCJTrbOjReyB9Mw6/6Fubvsi0sxJiHhrBhS+ughNMlH4JPk0UpQbLOvEv9mNcCN1cZXz174uUGYmMjqYmb53Ggvwh3X0O5Js4KCMe6VBdByp+0oVfspr6AguJO97AkStJSWnVF2vTWKhYRtyhO9Vu85/SVWxkq4irtfXTkNNqDBJhW2eNSFWiRP/3tj8V37RGy+U+il6b0t/39kYqwVBSI+Xx5o1svENNx65QoTvOVPgb6e8ai55M/0+X8rxkEN0pzdv6AAecm8czxirUXOrqyXMO7dBaJNm8aQc/b4xqnT7E3qCnr7e4s5r7Ie6Vh8+gFc7qRYGlFK2u/3hzTaqMy0vopnDrADqzO5+TNZ6US8Q37cRyupo+IF/8KVjBGMEz2pZ8olYkO/PBYfTv65zvMCdrCVv8TbiGqiKn5Fs2OpkUcNymTXbY596VnWwGWZDj68GBii9rJtn1/ZOirD7V/4X8J4iSB20Xu8e4PWD/PVS/DK03zV5SMa/GLMT3KRk6K4+wRaNEB4ZBZymrWZ0pcR3BowlUqD+OeiUWGHzgVu7JNaI531JRwU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(49246003)(8936002)(508600001)(2906002)(6666004)(66946007)(6486002)(54906003)(186003)(66476007)(4326008)(8676002)(316002)(86362001)(6916009)(31696002)(53546011)(6512007)(36756003)(6506007)(36916002)(52116002)(38350700002)(38100700002)(2616005)(83380400001)(26005)(31686004)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjJ4MmZrMTRWOEpBM2pjYks2N0tZazQ1T1JTeE9sdUwrbm5VVW9SaXFVOWVr?=
 =?utf-8?B?RGxQWXFVeVc0NkV1clkxNlBCdjg0R0hlMjJZY2Yrd1AvdjJucmZ0VHcvY0xS?=
 =?utf-8?B?azlsMEVqMkdRYXBPQi9wYldHTVlLb29yRHk5RXBVVW5WMDRXaXEvV0JuWFMw?=
 =?utf-8?B?NklrYW5ERFdjK0NoOC9zc1FXZXByTTdHREd4MUY0TkdUcHJ4eE5PNCtVQ0ZL?=
 =?utf-8?B?ekJwS1ZIYlAzWTVHU3FJeDNEUTBLSDlybkRpWHVlbFhHRURLMmwrUlp3VnA2?=
 =?utf-8?B?aWx4WmZjVzgyZ2ZSR3Z0REhrMjkrbmk1NHdNdTBBOERhdWJUUllPZXhUWlJ0?=
 =?utf-8?B?SlJLR2RXOXNYNk90QW5GZkIyNnpaZEltQkovcTFUL2o5M3NFRjRzMzZ5b1pL?=
 =?utf-8?B?MVNVZVNMV1hieUUxTGs0dEdPRVNtdWFZVTlPWlhMRlc0UjBjMnZ0S2V1UENi?=
 =?utf-8?B?bXpvelI0Zms2VFBvY2YrWjFQOVpkazRiaFZ1RUxiYU93bXdWbUdOY3o4Zklw?=
 =?utf-8?B?akVEamtZOWQrWWZ0dk5WWFpybjJraXFhekdkQnNKeForaytBWGlUdUxDdzRo?=
 =?utf-8?B?a3lwd3FPVFJ4YnJvUXBPNnBOSlRYZGw2Y2lwdHZBTDVQM1pLdFJHOXRBWGgw?=
 =?utf-8?B?MStDZldUQTFBMGxYMkJZRGh1OG1IRllUUkp1NzV4N0d3bC9NVU0zOCtLRWpO?=
 =?utf-8?B?eTJlZ09EY2FwMEM1WDZ4K3N5U3kzbEVscXFNOUtNaEtGM01QdTM4MkZRR0ow?=
 =?utf-8?B?WFpLOFZnWGVSemxOODB1ZlRNdGF5T0tydGtOTTNYY1FmUnpNbmgrL0ZESEJS?=
 =?utf-8?B?UnMxVGFFZVFURTMzVzJVeUZXREo2NTg1QkJoRzR4ZGUzNEc5alFIOXNlRHEy?=
 =?utf-8?B?SFZpc01ReG1zRnFpd2F0SjhJVE9CMWk3S05oOU5GK2VKY0p1YjB6eDZ1REh2?=
 =?utf-8?B?K1VVNVNnbjB0QXlQOW5Gblo4ZDZBcHZ6aUQrcGU3cWpOOGFRcVVkSzdhY1Z6?=
 =?utf-8?B?THdCSFI3bHM1Q21DM21MdlR2NXUzM1NBdTdQY1FlSVdHazZMMGdwUkpRNi9p?=
 =?utf-8?B?NTVhT0dKTW9CVkNNUVlvZUtnMGwrTHJjSDJ3OVkyNmZjclVDRWFoRFlYeUN5?=
 =?utf-8?B?V2NQcU9IU3V0SFU0bXh1Rmt2SWVlYlFDNkZXM2ZTQmpuVU11VEFiUHVoUTkv?=
 =?utf-8?B?VU1neXFEYlZjZ1dnZGU0MEszK2Y2Skl5T0FicjVkS21ZVGljdTFBZ2xUMUZV?=
 =?utf-8?B?VDJMZmpLZjhFQXQ0VjB2MVp3VVlqcDhOeG85V3dlcWs3VzBadDNvbjVpMmQv?=
 =?utf-8?B?SFFHM3VQb2lidHRldEcwTnJsUFZGd2h3ekYyaTlmek1iNnFiV055TEVUcDds?=
 =?utf-8?B?b1RzZTFGWkNueFptdnFIcjFhaldmU2Q1WlArMGFyalNRYXd5cDhZVyt6eXcy?=
 =?utf-8?B?cEVxMlU0M3ZDdEVKUi9NMTAxaG1xNVdEcDFqM1M0Vll5cFZqcENSam5KTkU0?=
 =?utf-8?B?RE4yZnpVL1pRbnhwYWFWZG1ldTFtUEdaSXFzM2htcy9kS2VqeUxVM296NkEr?=
 =?utf-8?B?eHM5eHJrQUdNb0tKeGZzTDRnWk9UUHJKMFNCditMcDdoZkc4YWprd2dZQ3NW?=
 =?utf-8?B?Mm1PVmNXY0pBN2NrVEFORm1wTmQvTHNJYStsK2VlSGNGd1RjaGpWdGJqVDJR?=
 =?utf-8?B?QjIrZ2dJRUFIa2NVQ2RGVmFZVHFJRXhpMFlmZFBMMXVnb0FIc3B2WU14dzNJ?=
 =?utf-8?B?RWV0WENvZ0JMVG9NNkJyTEJib1ZyT2NDM2REY2l3RktCdmZCRkN5dXhYNU9n?=
 =?utf-8?B?RE1jYjQ2RkdBcDM2Z2QxTE8vYXZpL0tsRTY3eEFGenEwN0pqTC9QUzdjR0th?=
 =?utf-8?B?dGliNnc5QkFheVdoK25rcVNnWGhVNDZJY2tnWUp1aUpRSm9tVy9Ha0I5MFBL?=
 =?utf-8?Q?RUkwEofBbjSFM+X8aTRuNRXbAvo/9/9m?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f45b5d02-2d48-404b-cd86-08da0b32bc88
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 12:02:56.8823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bp2Y+gubj3zOi7gtq2a2XJEX+ClYmLTXx7uqSlDqz35bCHlrKmieUrIfWfQ8kXixsNPS1gPrCBZZEIMti+oRLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB3590
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/3/21 19:54, Alexander Lobakin wrote:
> From: Tony Nguyen <anthony.l.nguyen@intel.com>
> Date: Fri, 18 Mar 2022 13:19:26 -0700
>
>> On 3/18/2022 2:46 AM, Wan Jiabing wrote:
> Hey Wan,
>
>>> Fix the following coccicheck warning:
>>> ./drivers/net/ethernet/intel/ice/ice_gnss.c:79:26-27: WARNING opportunity for min()
>>>
>>> Use min() to make code cleaner.
>>>
>>> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
>> There are build issues with this patch:
>>
>> In file included from ./include/linux/kernel.h:26,
>>                   from drivers/net/ethernet/intel/ice/ice.h:9,
>>                   from drivers/net/ethernet/intel/ice/ice_gnss.c:4:
>> drivers/net/ethernet/intel/ice/ice_gnss.c: In function 'ice_gnss_read':
>> ./include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast [-Werror]
>>     20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>>        |                                   ^~
>> ./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
>>     26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>>        |                  ^~~~~~~~~~~
>> ./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
>>     36 |         __builtin_choose_expr(__safe_cmp(x, y), \
>>        |                               ^~~~~~~~~~
>> ./include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
>>     45 | #define min(x, y)       __careful_cmp(x, y, <)
>>        |                         ^~~~~~~~~~~~~
>> drivers/net/ethernet/intel/ice/ice_gnss.c:79:30: note: in expansion of macro 'min'
>>     79 |                 bytes_read = min(bytes_left, ICE_MAX_I2C_DATA_SIZE);
>>        |                              ^~~
> Use `min_t(typeof(bytes_left), ICE_MAX_I2C_DATA_SIZE)` to avoid
> this. Plain definitions are usually treated as `unsigned long`
> unless there's a suffix (u, ull etc.).
>
>> cc1: all warnings being treated as errors
> Thanks,
> Al

OK, I'll fix it in v2.

Thanks,
Wan Jiabing

