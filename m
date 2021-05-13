Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D75237F6EB
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232569AbhEMLkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:40:37 -0400
Received: from mail-mw2nam12on2052.outbound.protection.outlook.com ([40.107.244.52]:59104
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232449AbhEMLke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 07:40:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kktu2Y5D2hZo0VEhoz04ibi+Iyu8SHxyDgN/gZ1D6ORLLBU06dM6phwHR8UnDFi1NvujIxv9L/FSOj0554jP5qKHq/XDqRKnRf+VsiCvd9IkBkQZfPalp56VhYCx2cbNQg87Xw2NHSjcUgx9ryteb2bF2L2S/ondKi1kq001d9pJHFOqM1dynwSa8MQoMYhv1WAGTRfNgR9akXfsb5WBD6RLMZYYNAL6lk0WniGUl8C9CP91FjzqarxoaUI3xbevStOMnA4jumGkFRiW5/b8sTSFT5lZB5pqQNVZKcFHr9LtK4BAO2T7YdKjDahKYx84DTnj+bJqOkvDZteJTiQXcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2NAw2IL+9UQ8hjV0lH7nPLMMbQL4XA9AgK+HUCn4Vg=;
 b=F2ON+5gHsSgKwnd9sIs4UHrxrY72XVQrNzOxJjD9/NrsxPL1hKFPlpxr4aDAtjrU2PdQASS8jmK6D3KWBKFO2XBZETd9vL39akbvkcftNEH4eWRQFxH3nZgeqoNUhrjxg+xV1xNnukq6Csqn/oncqgVs9DHzAGo8HP2DxVfJCIpabgfyqkZ1UebjfkrZLYdGJTlSMosb84JK7Egxdb+NngbNW10FBtxKuqoRW25QNBUe6ONYScFDx+XBKg0nrWOk6v3uv667Kcwp8nmuC/ONQaQQVK+mwwW1gzTNOVr1fPZ/CZ7syAXe8q8kL0AE+9n0npT2D7wXRiGsXKh2Dx54YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L2NAw2IL+9UQ8hjV0lH7nPLMMbQL4XA9AgK+HUCn4Vg=;
 b=Nor+EEXWve0RDJsd7DzVKtdAF2wXEW4twGvy/q3GU/ucSojfGJw0WgU8ZyL+QIZuLHRx0RIvFxQtOJEl4cmkbgqnJSyKM84r6qvc5GJO/KIr1WiMzcBbwXltimYFm1KZlF6MH7ZiHf0KgJKSxW1V8T+WXXqyP/gptNKc5ClVxk3o9ad5lXLrAazSFXwNzI0ruWkdDt1KGN0AJ7rJz4AAhcxohEViqb/ksCZyfJI7w1zSqMqHUdRy9eiJTMN+IOUf8XkHhJI80NHyUuwNyZLINYzGAz0/Hhw6JGVcBy/dfjDwSFA4IyCd/LVsbVILOGGzZ6RPUavXOLRx6DLp0GzbKw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5327.namprd12.prod.outlook.com (2603:10b6:5:39e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Thu, 13 May
 2021 11:39:23 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 11:39:23 +0000
Subject: Re: [net-next v3 11/11] net: bridge: mcast: export multicast router
 presence adjacent to a port
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
 <20210512231941.19211-12-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <44fa04ee-752a-34b9-d5d1-e6264aa859c1@nvidia.com>
Date:   Thu, 13 May 2021 14:39:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210512231941.19211-12-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0003.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::13) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0003.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.50 via Frontend Transport; Thu, 13 May 2021 11:39:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92088468-3871-4c6a-8855-08d91603c161
X-MS-TrafficTypeDiagnostic: DM4PR12MB5327:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5327281914F7B7BCD7CA06E3DF519@DM4PR12MB5327.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SVJHc/ZbP24Dr/WZyl13rr1lPcYtL3yUtK2PMRSMDOfHxBYJU/3wZwMw4EBau2dBAd0v7+OjGvoGoj064u2eXMC8X7TQo8g0+UdsKdVD7Z6JxEH3c9tAZ7EiySFZ98WAs9pN6nWZOfbBKaOlYl9AMO2WL+YyQqolnQi8ZO7BVHBqB+SVWCm4H2dVpboY6HBtZ3+D4mo56nxra8pmkRpUrD6HE32xgfLoFECGzEn1kKxZx6OevFTE7BNkRt5EvFhIinNyDW0f19JKCKMAnMq7pmnUZX9QtP/QRY5doE4SjQa8470rpcAT4dBtqDUbSdFQ7CZYe1g9vTzMzNJ0lsGujzifAMfpGiY9QKhiNlx6C76o+sfpWSI9xTiGTT7+wmfeG0c4UXMumBbhRs2qSXyO6UvprrdfuW8Tsk/Nr/1+EMLZRY/Vg2tjsLdDwAQeGxutwhf6QPFiypGpZeGxsNvAnmwDtwBE6N+EXlKHZVLrsA4nxNkXbS5D0mFjHXO7MB2Lbi9NRRIETBiQ973ZxhQvSy7BWCNVF4ukrsOdtKGQKXwjSiGTbMR9GqiE7/8fS7Df10byHHbaS0ByiSLj/W+j7aNbBhYXKBiaMtmthFQtJWQwfmGjDI2iyFyye0N1Boc1GMAdx3bVl3jrimIKTZkfkjDKNh6gdB6D2jrftFRMi6dhSUn69o9sQLlDokgeCKMy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(31696002)(36756003)(86362001)(66574015)(38100700002)(66556008)(31686004)(66476007)(66946007)(2616005)(956004)(6666004)(2906002)(4326008)(16576012)(316002)(54906003)(8676002)(6486002)(4744005)(16526019)(186003)(478600001)(26005)(8936002)(53546011)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bmRvRkNCYUoyUlRmNTlMcDJ1aGx2MFRnOC94bXBWNG9DMWc1RUlHSDd1RGR1?=
 =?utf-8?B?UmdFbmVXVzQ4eHVNVzhKMjNmR3h3M1JUZXVjbXlNM2lPOWorY3U3cmxQNzVq?=
 =?utf-8?B?bnBCZlhMa0ppZFd4NGpoVGF4UmhUVkowb2hNNXJkVzBLVnQzaWhqMERMcXg1?=
 =?utf-8?B?V1pPSHBTdk0vR0g0K1FOR3QvdjgwaUdONDNCK0Y1M1ptaG5nOVo5UzBWenlX?=
 =?utf-8?B?NXdoZEFBZWVQMnlqNmRWVmt3NlhTb2ZmeURvQ3pVcUpMQjNHdUhTMlFhTmFE?=
 =?utf-8?B?UnRyUVEvUjRkRTBEUjdzSUVNenE0VHA5VUt6Tk56Ym5JYmFiRGhkbkE4QUlW?=
 =?utf-8?B?UmFrWE5HQjA3WGEvRkNOdFdrQlV2UEFHTkY5djY5eVJTZGJlaUVMR0xKQ0J5?=
 =?utf-8?B?d1lZc0R1dDVTcjhpZjdnOEdma2FndDR5SFdGaGpnRGUwdjBHbkpLRWs5MUFn?=
 =?utf-8?B?WGlYaTE2QnJYb0IyWUhFdmJZcDd0NnNINDBheGM2aUhlcjd5Z0FQRnMyZTBW?=
 =?utf-8?B?enBHLzdLQ2Z6M1ZtMEZCRm1vY1BRMUdrbFNnRWt4YWoyeUp2eEVMMmRiNS9q?=
 =?utf-8?B?VXcwbVpwWWxOdWEvaWdqQlVIVm5SM2JCWWswb1UvZU9xbzVjT3JvelFLOW1k?=
 =?utf-8?B?ODlFTzFNUnc4bktFdUxzYXVTeWw3Y0twVEVLZHFDWGVBc0xrQVowY1FQYTYy?=
 =?utf-8?B?SHlGQ2hmUGF1RjNlREVlSHRRbjIvamNsWWEzeWFSa2FCeFp4YXRkRmR6QWxD?=
 =?utf-8?B?M3hhOGJ0N25MQkN5ckJZVGxrK0lQY1pkWUtHOFlBZVBES2FOT2krazNqV1l4?=
 =?utf-8?B?T1VobGtqZnRMNWZ4Rlk2cUhWaVA4WHJzQnkxcTZJUnpEVDR1UlVrQm0wc2tZ?=
 =?utf-8?B?ZHdMWkxqYzZxbVNFMmJHSGs1dVJxeU9YcWFZUlVFVE9ycmY1S0RsdkhLZ2o2?=
 =?utf-8?B?VTh6eFRXcTF5Q2NGMmZFOWEzUXROY0hIMldOeXpRTTVSR2dxN1grelhsazdK?=
 =?utf-8?B?QkQxYkV6VHQra2xOQUk5K0JEVStydUdRZFZaZE9JN3JYbUllR2J0c1dXMHdT?=
 =?utf-8?B?VlBFOElOWWsyZnR2KzVjNkNqWXZzMUg1QnNtOFhBc3hqaHFaenBGSmVIUk1y?=
 =?utf-8?B?SmlLZFdCYXJSZjlGRy9rTWQ4QmhReHdoeWRuUHhkVGpEWktmNGQvOC81VVVR?=
 =?utf-8?B?cVpNcDZpSUZQbXBIV25MbmlZVWJSdytnU3kxK01wSFlTcDNmMENxNXVla0Fr?=
 =?utf-8?B?d2FjT0d1R0tlTGNFWVB0T2lzOGtzWVpmY2JuLy9CcmdHRUsvS2djNnNHck5M?=
 =?utf-8?B?L2RKUjQzajJ0L1YyTVc0Q2hLaGg3NWhFZzlneTBTalFpOGxjSllKM29jK081?=
 =?utf-8?B?c3V2QVRDWmtPOXlQeTF5L1lKdlluRlBYWW1iZE94VEFLVmM0WktQTmRhU21E?=
 =?utf-8?B?WG1RV2RpR0VIY0VWWVRFV2IyeE9RM0hBZ2kxYzdxNkdia3BOWE45T0ZiT3NN?=
 =?utf-8?B?alRHMTlOU2xjZWwzWndMcUJIK0V2QjA1WkFVdTEvTCt5WlBDRllweHFnWGRR?=
 =?utf-8?B?OVdXanR3a3Rvd09oLzRrRlhIajFXVTFPaTlpWVMzdnRqeFI1OFJ1QVAvNUF5?=
 =?utf-8?B?RzZzREdyWlMweFIwNlk1UXhUZm5jZ0hXbnN2VWRFN2w3cWVpRk9sVDlQb1FO?=
 =?utf-8?B?dWRVVktCU2xnL2kwWEtBL2NjbHgySXZORDZjQ2R0VGNuZUZhc3FUNmdLbVRV?=
 =?utf-8?Q?Gm342w/Jpc/h/9bZWNA9dx3We7fUpS0DpG5qs0b?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92088468-3871-4c6a-8855-08d91603c161
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 11:39:23.6366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9jaH9PY85YFpU+d41prbjTDnnFwYz9Y/GPpqcQ5MJljLMWGACW9+uHLcVYmFlwSOl5WliE40zhvscamYqGAtQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5327
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2021 02:19, Linus Lüssing wrote:
> To properly support routable multicast addresses in batman-adv in a
> group-aware way, a batman-adv node needs to know if it serves multicast
> routers.
> 
> This adds a function to the bridge to export this so that batman-adv
> can then make full use of the Multicast Router Discovery capability of
> the bridge.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  include/linux/if_bridge.h |  8 ++++++
>  net/bridge/br_multicast.c | 55 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


