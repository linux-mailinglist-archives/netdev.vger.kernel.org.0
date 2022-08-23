Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCF459D2B8
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 09:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbiHWHx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 03:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241387AbiHWHxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 03:53:22 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2060.outbound.protection.outlook.com [40.107.22.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182F0CE3
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 00:53:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e8NOqy9jXOOlKVPWMpvKdPvuWSFGHOqN5PGnZHcFM9mseN+I5GfCq2JrU0/nNQyshWXp//g/sBOysc2lF2HDcWn1GDdvlWoDbBR02BW0tiXV4l30LQUkRCiFE4UBvD+m5GDs/EVlN6F/Ugb/Y9Qhda7yz3I91OttzZn/cmruh13YRNAJe9Ch3XFPPk9XMX9QCu+h0mndHjjA9dc4i5uelgyCs6ZQWOBxhoUvdihYDXXPPHiLOzBX0q1k94KbfU/+EE94gw3aIgx5W0t6SRvyQgyHZJvSUkIQ/FDXKzCXX6uyBb4cXLcFy4h9wvMgJT0rNs8JnzGEmuMpsTo0eYBing==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c8QfaocNRObHGXAdfPmYdY7cIBJnS3t5F1AUvgGaDRQ=;
 b=kujKc6MIWkxgSn5isH6SfrMQyAHJvfyWQRSIHhhmRRlc5z4be7fUqaMWT8OXKa01+tQAX2Ad4mKx2qYAxB5celIgLMRVIF1mT7B5uy5lehgdvTrNraO6kDbLSHEjB5AOv2QWcnYo2R/yioBQbqq9Ds2ImKd9fkJN0DTjiWu+pYj1fF6+pqdnjJQodN54oP3oHG5VSwdgLpYEf4t2mrOcv4+t+fzAp9eggL4UNvjc3e/KmyaLOzwq++XaFtTB99ZTc8DfsIQKGaYHRlCbMj+vwWRmfno6oLveYXz3M+QJiRfOVlimD5nFvilsvi5L2wcAZ0JQTvbqDPIbTCJlQlS0Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8QfaocNRObHGXAdfPmYdY7cIBJnS3t5F1AUvgGaDRQ=;
 b=RreDweEHAS4IIaDGhSU7IcvVooOh8uZP3N5GGIif15ye8tUtWybeiyHHHrGYZgWZOgdUOZHEu7lVf4Ecelrvpo6wbP5sw1UkhGNuXXPxlRFNxgMpzKhv48SAznW29Z4g2mTWMsxbqQv/Ps6xVruZDvvDA4CoWo5RziVCcCuNEwvcJTGlEiP6RJrWe5dhWt8qjXiBeOlpTNhAri/4nsQzZrCHuXLGK8d6VYRmY+PWsepzDoBlCdszYK5muEdoy+9mTouo/sgDI3Vpq++aS89h451RFMtNKsrApzMJGESkpHRihdYqs+8GN2zPn/pkV2QL6dCcTrcT3ijDLFmnw2yfDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by DB6PR0401MB2616.eurprd04.prod.outlook.com
 (2603:10a6:4:31::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Tue, 23 Aug
 2022 07:53:10 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::7ccc:8f18:a9e2:e1da]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::7ccc:8f18:a9e2:e1da%12]) with mapi id 15.20.5546.022; Tue, 23 Aug
 2022 07:53:10 +0000
Message-ID: <798b00fd-a888-5135-0396-f846eccc6510@suse.com>
Date:   Tue, 23 Aug 2022 09:53:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC] r8152: pass through needs to be singular
Content-Language: en-US
To:     Hayes Wang <hayeswang@realtek.com>,
        Oliver Neukum <oneukum@suse.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220728191851.30402-1-oneukum@suse.com>
 <0f5422bbeb7642f492b99e9ec1f07751@realtek.com>
 <0c27917c-572a-7e70-3512-9357fabb458a@suse.com>
 <ee294e719e7b40acbc760eed8f781ba4@realtek.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <ee294e719e7b40acbc760eed8f781ba4@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0024.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::15) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aeb7e2e4-b6f7-4611-d04c-08da84dc859f
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2616:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gR52+TlTQN5E+K48PG72I70bS8DgeBr6xyscCy6fDcz5p1nJhIglcSSYFKETUfiDO/5lFr6ZYK/zSCu1hwTBUCzbtZcbzEMmdxlINdP8KQ/3FkE4QZO/fXVkgfaq9a5ykgbduoaAQxR7q3f95Yw17R3nELVAGbwcKCpl+EhKT7Kd+ES8vWM1MMgzvSEtmLei2SLO1H2MRujfzXkjXdONiNvBeLf0PeTTmMXuTAujgPTsXTthwqmcsxqBCN/Ilqetp8NEjeHwYsx+MJbE9l8buuC1UIdQvUjG2j/247fRI6aAsyTlYcQQ+Rsar7Jm2sJR8KFyz2Zq24rgJGmZsAh0HmA1KG+TJ0nj5nQRu5W6u1T64TLYo7mdIgE81OPlboxvTUISRsEjOyWKwV3+Mys9zLKa2W8HVQ+fXvWUWH5ai9K/nH8yowMeTAbogcDNx3om0nv0n+HZEGsqz25iAnu3PO3RsgW7n6C8yfWdeCGGHYZ9gUs8epnb5+9Vf6vVP9s/jSxGvdtZ4MYtjDTVBl3ZfL4EoS4fvlxC1ZcUakUjvFEeZRBWJd6rdnJ0lQfrQY+nlLO8Pb4BqRByuD3cjDPe+swuGUiWTWUnp5QfWwYzythZAfQUHlw4WmV19/3qveyZDxGK1LAwye4qH4vL1gLL4g6avpHYZFEhmwJu+Pp6ZvK4jBIZ5Tyt9ideW5IkyErZXz5Yq2ebXXfW3w9/wx7s2QZoHIwAvGLsdrV6FKQHPoysFcsZyo3R4NIrtkSQtTtNfD6LeG2ChIM4Dc/yPSkslUPKzR6Vvymlv3/T5ZtSHUs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(396003)(376002)(346002)(366004)(53546011)(6512007)(6506007)(2616005)(186003)(2906002)(31696002)(86362001)(8676002)(38100700002)(6486002)(4744005)(66946007)(66556008)(41300700001)(316002)(66476007)(5660300002)(478600001)(110136005)(36756003)(6666004)(31686004)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rm9lWTdZL1BvamZXeURiVDRFUzNycHQyOC9nRGJmL0JpUWZNdzhKS2pKMDJN?=
 =?utf-8?B?U2tvSXIrYjI2elQ4L1d2R1dTWDNPZE5vU21BOFZ6aVRrMTJXWm05VExVQzVC?=
 =?utf-8?B?cUdJUGZVZTVwcGh5YUNEU202SllvSXZBSUJYb2V5MnlsdzEyd3FDVytEbnRq?=
 =?utf-8?B?RVRLMlM2d1o0NU05dDZZUklXY1Q1SkZOSENGbmNyblpNL1Vac3lVSFQ0eXA5?=
 =?utf-8?B?QnBYK0Y0Vm5SOU9JVzFsWFpoYTRjZXBlN0ZJL2EvK3VCanVpYTRHWXQyclE0?=
 =?utf-8?B?ajdDMWtkQndFeUhRaHZhV0x3MjRpTHZjcG1wT2Z3VVh6VzRMNmFLU2tTT0pQ?=
 =?utf-8?B?a2haMnBVYWI4UkhPZk9uV1hmU1lxYTZ3VlpSSDMwRFdmU0ZoMFk1dDkxbEFj?=
 =?utf-8?B?eEpTNzd3RS9DdXZFUHJ5d3dldEpmYUtGTThDUHpsTWQ0YnBRUjc1L1dCV0xE?=
 =?utf-8?B?VUtScnh5alJjejI1ckFuUXFFTU9mU0NLWTZvQkRNWlE2T09XeDA1bXJLamIv?=
 =?utf-8?B?dS8vMmtjSElXaWFmWmhIYkJDRVE4ZGVNWjFON0tkeXVtaVV4MVB0S3FwN2d6?=
 =?utf-8?B?U0pBempDMEtHUGFIcFEzZllOZm9uRldLdlQyOEY3ejludGRvWWJuSUw0eGxN?=
 =?utf-8?B?ZUNwWlN1emJIYmpxZXlyTjZuNlFBTGd2ZTJXY1lQVjlqNE4vQU1YVk03M21q?=
 =?utf-8?B?Sm1QQUk1dHFTYUFnVjR3M0JNMkJOMzZJSkJidGUwZlQ2eUtJSkZxbFpKR05k?=
 =?utf-8?B?T3RqdmlGZDhRbWNhaUg5ZXdSZEZ0ZkxmV2FlQ1pLdVJXLzJpSUpyUzFqY2J2?=
 =?utf-8?B?UGRiZjhaang2N2hzUDJ3dWVxVmVKdHF5dWRnMmxKNHdyWWpRNTM0V2MrQUh6?=
 =?utf-8?B?aE5MVFhaNFBlRWJWNTRpbHVrUVlpTWRTVytBZEtPbHBtMFdiSVk1cE5VN2Ja?=
 =?utf-8?B?YUo3bmVxSExpLy9EUjZTWXhNSSsyTWMyOTdZQmRUT3Vhc3lEOGREdVdBMnVl?=
 =?utf-8?B?OWNpdnJRL1FnY2k1bWpYTmgwMjVwc1BCMTFHYjV3SmVsUzNiZkMyVVJVSHRH?=
 =?utf-8?B?dlJFSGM5Vlh5KzNjSXBRMGZMVkQ1c2pPOU5vQmZOSUtWVkFFSUdEUzdhakFk?=
 =?utf-8?B?L0twcnorbjBtWk9iSll1T0NSOC9KNHB3T085eWVJbzV6c1NrTldSTTFDaUVy?=
 =?utf-8?B?RFM2TUptSjhLTHNCVVdESVhWcVVQV3R2cGxuNUkxd2QycDI5ZkpUK2lzYlNz?=
 =?utf-8?B?bzRYdWZvK2N0WTEwZmNjUW90cWZ4dUswc1A0Q080MDRZVG5ZUmRRVUd2WitL?=
 =?utf-8?B?WGpmTFJVYnQwejNJOG9wTE9qbnhxbnZVNXoyZ0xpZDMyaWpRdEdWSHM5VWoy?=
 =?utf-8?B?bFRZNzVEbFNxRjN6WUV4c2pxVGFpNitqckJOOC9zS2ZyOTgxWkFQQ0dNdEU5?=
 =?utf-8?B?WVpKYWt2OVp6RXovdFRWZkJXM1lLTTlvSDBSYU9QclNtaVpVVjdSaU4zNTFD?=
 =?utf-8?B?UDUyZHBQcGhWSlRqZEFOc2F1SlpRTzdRRTJNdlBoK3FPM0xwZzViVGxpVUNn?=
 =?utf-8?B?V1Jva3N5M2xPdEE3SmZiYWRTSFpBUkhSaHBFaXppRk83NzdVTnJ2aDNTMVJq?=
 =?utf-8?B?dHJNYWM0Tno2cGlNa1NOZndKZFVkQkdOa1BRaUdMVm02ekJHdDFIRDJDVlZa?=
 =?utf-8?B?Sk1TbmRTU3M5UkF0VnRHbDVvalFpQW9ybFdoUE1mN0xtZXZvVmhtOEFYYllP?=
 =?utf-8?B?ei82dC9kNGpwNU1pNnQvcFJ1R09nTTd2MUFpM0NLTjk3V2RyZ2tsc2FIbkdT?=
 =?utf-8?B?cHg2YitDUUlKUFBJbW9mVzNOTkVTelZhcDBOQVRPM2VrZWtwRXdubHAyUlhL?=
 =?utf-8?B?SE1TVG5TQjlnWUNQMFRnQW8zaGNGdU0vUkZySjdYUmdoR2FhdC9yeXJoZ3BW?=
 =?utf-8?B?Umd5UU5DbkZzbEV3dHV5anE4Y2xOOTliK2xaTElEdmova2oyTmtkemp2WXMy?=
 =?utf-8?B?dlRPb3JhYml0eFl5M0xCeDZqczN1T2tKaFJ5czlFU09mcHVVV2ZSSnhKNlhD?=
 =?utf-8?B?bS81QzBpSHJ5bzB2Smt6ZFN0RVVHekJtcE9VcTBSQ1N1TjdsaWpGUjNTL2k2?=
 =?utf-8?B?UFp3cFBYd2trSERmTC9iRHdIUVFpRkxtNCtaQU5sbWRRU2tPeW1TdWFGMUZh?=
 =?utf-8?Q?H4R1ilXhJdA6BxCH+lll47c=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeb7e2e4-b6f7-4611-d04c-08da84dc859f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 07:53:09.8986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kkHhtuQ8V3Co2OcAUbCmsnpbYapYcdrig1oL/gjjCXVyxtE54gQ3wgyV8AuieHvJPYr1LdkhBoqG7AWkPJ38xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2616
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08.08.22 09:04, Hayes Wang wrote:
> Oliver Neukum <oneukum@suse.com>
>> Sent: Thursday, August 4, 2022 4:58 PM
> [...]
>>>> +	if (!holder_of_pass_through) {
>>>> +		ret = -EBUSY;
>>>> +		goto failout;
>>>> +	}
>>>
>>> Excuse me. I have one question.
>>> When is the holder_of_pass_through set?
>>> The default value of holder_of_pass_through is NULL, so
>>> it seems the holder_of_pass_through would never be set.
>>
>>
>> Hi,
>>
>> here in vendor_mac_passthru_addr_read()
> 
> I mean that holder_of_pass_through is NULL, so you set ret = -EBUSY and goto failout.
> However, holder_of_pass_through is set only if ret == 0. That is,
> holder_of_pass_through = tp would never occur, because ret is equal -EBUSY.
> The default value of holder_of_pass_through is NULL, so it has no chance to be set.
> Right?
>

Hi,

sorry, you are right. I made a "!" in error.
I'll correct that.

	Regards
		Oliver

