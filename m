Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BA945462C
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 13:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhKQML6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 07:11:58 -0500
Received: from mail-eopbgr10092.outbound.protection.outlook.com ([40.107.1.92]:26243
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235835AbhKQML6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 07:11:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ax52uxcIXEBgSfpNcDiFrBfq46pXH3KTKy8M7kgXCdqDxDeB8x4EWsCxfeoax8oRUj4nOwdEvsfVvYNAGSZIAr3A3Hr7qxGt7XsE8M4tN+Mx3fmjaFw4itcmkRt+e4Z2Eqd/AzLSjhadJ56NxkZWBEXrS0pHgABGiR/gMW1rL8hookdTbDY/j0I4uc0lUZ2IvpHeFHR/Mcz2McvfLMF2c2eikeGXsOYyVOjMwIAmGJ11wVxHswUVtFDyQSRKG8I1vg1a/O1xHMCeS6kKBQXoT7rXPveeWO8nGa7g59eA9lP0NsKGvoT0Ud0AAlLaeYUIUHzJK7thFMb6V+1LWjPfLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YwZpIyaehbWqHdZW/a+AX6ZfsmG2Xz5sjK0vhq3z02s=;
 b=Ozw7R3hc/8ePDqiXnVXkrrpvrRys2X9sYVvrtRELxexSNQVgEP3u1Vnt79cnKinK8zCOVzjdg9r686OOS1B/9UrWrCxkbOuSR7+QwD7YjKR2pFt+weYizPji7Vxr1IzSsEiTxr8bIxqZVLgwJFohxKeSZUq1DfJMOxhezLoWazOvLOZV4wxpmfEzFqiEoXSnZjKTcuuqa0cx34YT1JfbRi8tTE+poa4RSnPQwe6vP+yuVJ3tzZUIIuqJhAMZkR+fZAdsvBbjbZy6+/kz04idU6BkBp1zKeZehjSBLDYKSEabtAWGQUPkqdn/AOxXjpKRm2ZduEC2duRfdooayE8O7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwZpIyaehbWqHdZW/a+AX6ZfsmG2Xz5sjK0vhq3z02s=;
 b=SKbz3hjbS1gl/n+kEEBiVcT8Ph4PXizoapWGEPq9X+QeBJq42qebJbTwGLPNBJaxAXwynkX4kZJU2OBaCIem61ghqeZICU+UqOXxC3v50oXo/yfo4dRkXQG14HQ5bykrxcS9ep97o21PXunIEm9wSIk5Mx0+K+p3pg6visg+eOQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB5630.eurprd08.prod.outlook.com (2603:10a6:800:1ae::7)
 by VE1PR08MB5182.eurprd08.prod.outlook.com (2603:10a6:803:10c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25; Wed, 17 Nov
 2021 12:08:57 +0000
Received: from VE1PR08MB5630.eurprd08.prod.outlook.com
 ([fe80::f875:8aa8:47af:3b75]) by VE1PR08MB5630.eurprd08.prod.outlook.com
 ([fe80::f875:8aa8:47af:3b75%5]) with mapi id 15.20.4690.027; Wed, 17 Nov 2021
 12:08:56 +0000
Subject: Re: "AVX2-based lookup implementation" has broken ebtables
 --among-src
To:     Florian Westphal <fw@strlen.de>,
        Stefano Brivio <sbrivio@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        kernel@openvz.org
References: <d35db9d6-0727-1296-fa78-4efeadf3319c@virtuozzo.com>
 <20211116173352.1a5ff66a@elisabeth> <20211117120609.GI6326@breakpoint.cc>
From:   Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>
Message-ID: <6d484385-5bf6-5cc5-4d26-fd90c367a2dc@virtuozzo.com>
Date:   Wed, 17 Nov 2021 15:08:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211117120609.GI6326@breakpoint.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0024.eurprd04.prod.outlook.com
 (2603:10a6:20b:310::29) To VE1PR08MB5630.eurprd08.prod.outlook.com
 (2603:10a6:800:1ae::7)
MIME-Version: 1.0
Received: from [192.168.112.17] (94.141.168.29) by AS8PR04CA0024.eurprd04.prod.outlook.com (2603:10a6:20b:310::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Wed, 17 Nov 2021 12:08:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd217aa2-e0d2-432a-55a6-08d9a9c307f3
X-MS-TrafficTypeDiagnostic: VE1PR08MB5182:
X-Microsoft-Antispam-PRVS: <VE1PR08MB5182EFB703A02287347869ECF49A9@VE1PR08MB5182.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DFBUCxXu8kpqQbloefKVtbD6mX9UHiWHezfkLiSrFsW4q++fkuOnqHHXlW0fH6G7Ss1iFMA5YCpqEaY6spsESVjAmMGEjz+m+eS5Ju7FEMT5Ixpfw3Esd/BNLj8SvoWYlu+J3YkbUA19DmW0G729x7WVxBGaLnD+qty1on2lVZBPsqF29k+687U2Jz31xXPmFyhidERhwZL8nQYSl0JNR1XPgX9uQZbTpueTJJB9D/znJpUONwpgtIiLTpcy0yXipJit0a+SUmdbFyPym7JqSj1a0+x0gotXauNbMOOyMNDCF7ZpPNclHXK30S9Yw32SJmpY6IzLmVIOyzxZvSAUR2ujPYJV+cOl2SIKSNFBrSHZZpl3XkrXBb0YBvdp+eiFWOwEjczj5uQ7a5+y6Ek/r9wdCCz0Y4Sj3C11RL8lQCSpYCGEYcph7LLtJr+5sPFD+D9q9Zc+NDBCNV28914j1Lf6gf+72eEbMRYAUMnj3fN33GBHD6gMim4RoQG5ecCY1YU7PeLeE06Sf6iUczBE64CuVggUJCNIu63au4pah36q7fiMsjnl4sUuBJn62jeMHWo5jc6r9SXjROxsrhUBzw7lgnsPbJhlYx3y96Luvvkv9+3GPVVLyhPtu5hN2EsKdlbcq0Q+VqvJIjhJ7gFJmW+VpxmodHtq8YoOe2MDaW1gj/z6occJeFKGRCj39xgkMUSVsDepBNUcgXQ4gAsClKHywyCL5ZWnACjZtpR2l2Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB5630.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(86362001)(107886003)(26005)(38100700002)(36756003)(4326008)(2906002)(4744005)(16576012)(316002)(110136005)(5660300002)(31696002)(66556008)(66476007)(44832011)(66946007)(186003)(8936002)(6486002)(8676002)(2616005)(508600001)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVl2MU5MbG8zdnhvck5pa0FBcEl1dGxoUFNyVnVxMkN6VERZM3h0Uys3ejNs?=
 =?utf-8?B?dHRNWFplTTc2bjZMQnE1YURrREV5eFFxVXJZMmNwVDlwZS9xdjhCc3oyYUdN?=
 =?utf-8?B?Sk9WRnFTdjBCbDBLM0RVeDg1RmpHT1lOaWdmdWxCWXdYTGlueTFQS3JWTS9k?=
 =?utf-8?B?bjNvL3l3TWdWT05MUjRGRUl3ckhGREo1dnZMMENVTnJiOWhtSzQ4T0RtTnJp?=
 =?utf-8?B?U01hYzhwcE5NWERFNTdFTFFkMG91S0k0VXlLV2Q4d2ZWYkgveUM5RlI0d0Jw?=
 =?utf-8?B?M3hDdGp0TVN2ZStXYjRlRGN6WWw4Q1JHbk9xaGN2YzRnRStpMHRkUUFiTkM5?=
 =?utf-8?B?V3l0OGs0R1pTZ0F3T1czU1hFclY2YVB3MjZEWG1IT0Q0UzBpQlEzd2N3QjN2?=
 =?utf-8?B?aW12UTFFQlcyVGJsdjY2WkZqUnRtRnNaNFQvaDhXVkszdWRoeXZDeU9Vcm16?=
 =?utf-8?B?TkFxeW9Fa01TdktxT3paU3lNSHdmOTZwTWJiU0dJdXE1ZnBJa1pPemUrTEY2?=
 =?utf-8?B?NVFwSGNmYlJhQmJaYW5KcG8rQXZnOGllSExmOStGeXkvOG8yejV5aUM4a2FX?=
 =?utf-8?B?TUcrRWJRaEFJT1hTOTlhODB5VysvaGlLRm1nL1JYVnRhc2kzQmwyTTZHeFgz?=
 =?utf-8?B?d0JESjE5Q1dqcVdVQmc3Q0xpaFFDeEVwaWxOMHdIR1o2Y3JDYXE4VUtyeTZw?=
 =?utf-8?B?aG4yZDN2eEUwRldTVE5BbWdZTmZNcjJRTmt2dWpsVzJHK1p6MnNucVdIT29S?=
 =?utf-8?B?UzZucS9YMS9xVG5CNXErZi9PeitvVlhEWHBWR3F5aVpoWlFHenF0eGdkYUlw?=
 =?utf-8?B?WDhaOUVjRWNmTDE0bW5JQisxUDNONjJXRlV3bEZEcURxZ1o1STRuYlhMajI0?=
 =?utf-8?B?cmhDdVUxQ0k5VEYydWlBVmhNcE9xYTJDTzVkaytjSUpqWXRQK0h6VWRmeXN4?=
 =?utf-8?B?d3VhNzN3VEYzcE5mbDFLeGM3Ty9QeTdHT1dxUGY1eGl1K2JseGNHZ1pYQlRO?=
 =?utf-8?B?aTNsUHdoZTNpb2EyUStId082Wi9scC9DbTQ3djdqQlhFV0syeGtHQlNuL2Za?=
 =?utf-8?B?VDZ2UVA3ZDJBbmFkWmpsT1BTUGFLbDVseHl2OW4xeWJMa1h2dm1FNVp6SllN?=
 =?utf-8?B?TUpoUlZSVWVCcG9udU5XRWF1czJ5ZlZWQlByRmtpNncrSG54eVVRdC9aT2hn?=
 =?utf-8?B?UlA2YlY1Qm5lVkcvbGxma2hpN0hhODZkeDlrL3ZaaUdFK3Q1eTROMXQvVnMw?=
 =?utf-8?B?eGdTYjN1ZnJ2b0xWNDJDT29jSVRkNmJuRU1ScG5TK2VlUXVmK3RJYWhyUGVC?=
 =?utf-8?B?VkxpODVDcWZhY2p5aWtUTkhucHg5TFBISWNwSHdQTWFpYUo4eEwrMUFmUHNE?=
 =?utf-8?B?OUNsZExhbURMbFV2SDZsdGVRTGtxb3A3UjVodFFwYnQyazF4Y0ZzMHI1UUxa?=
 =?utf-8?B?eDdHb1dNTjNPaVVnTm1lWU5KNmhzZ0VHcytuOTdIQkN5Z29INkZyWUVlWkR6?=
 =?utf-8?B?dmxWb0NIYTI2Y1JPT0pRZHVadTU5WGI3eWYzYnQwOXQrSy9yRllSUHJ4QlJQ?=
 =?utf-8?B?bVJiRmNaTjJtTDdBMkdab3prSXVKaUpDejRQcDNIajc3RENNZjZKN3Y4aEpo?=
 =?utf-8?B?bHp4Z040Wk5rbmREem9xU3FxRjBqcThKbDZUY25rVUhtV2doNlZoaUlucSs2?=
 =?utf-8?B?QUV4SnJsb0c5bFlQaXdVb1NmZEF5WndKVS9BNEw0QkVBenpxWkM2U2NyTDRw?=
 =?utf-8?B?VW84L0pBQVdJZ3BlM2U0TXBCWTJoT1lKSFlHMXJ5Szh4L0VrR2xTbjcxWC8v?=
 =?utf-8?B?UWIzdWE3WlZMZVNGYkVUcUptWWJ5R3hDUGM3N2Jjem1FYVdicGMrczNHRlE0?=
 =?utf-8?B?Z1o2ZzNvSjhleEp0anlSanU3VG5zRXpGVDVYWUlSaGVVbG15OW4wbUwyTHYy?=
 =?utf-8?B?T28yWmFkaHdKdlNkaUp2K0kvaXRubVRKalBkdldPRTVGbmtNd3ppZHhHNUpk?=
 =?utf-8?B?WDdySjM2dUloMEM3QWtGVHA4c0JGdWlpMlRSMGxQSW9UWTFub29rYklSUUZB?=
 =?utf-8?B?SXB6aHJ1My9nblg3UWRwMy90VUZ6SFVRYUZWV0c0bUlScU9uT1JueU5zejRl?=
 =?utf-8?B?d3VBekgrQVZ6UDBpMitJL2VHbXFVdWxhVHRYVGsxdVZ4TDgwWmUvSm5jbS83?=
 =?utf-8?B?SCtLUG5FSm1hakJzaktNeHkzWVFZWnJoNWQyUGNOU05KcnRteTFHWXBHVG8r?=
 =?utf-8?B?ZGNNUTJzdmVmODRxMjRPMFhMdVd3PT0=?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd217aa2-e0d2-432a-55a6-08d9a9c307f3
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB5630.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 12:08:56.8363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZqW9VDUweD2GykvcOBqN/ZQetIhYwlp7MBMtmc0EF1DsE3qGX/Fe6lUFxZ/ih7uwFu9Rcs8XcsgrSPz5hOJPuU8Hlz5I7l90qHnwOMXKBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5182
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> Looks like the AVX2-based lookup does not process this correctly.
>>
>> Thanks for bisecting and reporting this! I'm looking into it now, I
>> might be a bit slow as I'm currently traveling.
> 
> Might be a bug in ebtables....

Exactly same ebtables binary (and exactly same rule) works with kernel 4.18 and all kernels up to the 
mentioned patch applied.


Nikita
