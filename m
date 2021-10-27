Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32CD43C531
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238633AbhJ0IdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:33:24 -0400
Received: from mail-bn8nam08on2066.outbound.protection.outlook.com ([40.107.100.66]:18369
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241078AbhJ0Ib4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 04:31:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSJ988YZoHVTA9/pIMSbX8llzOp20CISDK21biMpByTZcrQ/bSfBwuYoWwQGLMjfbQ9jtc6OIpDMWpWnOlrUFJ2Qyax3tAZjVj7l1jza/ZDSrMK56qDj3afb8ZazEBirSo0PJr5+Tyep/S+OtM114901VSP85wOTqt6dcLeh9MQfi3vK+QYbMM3K8tn6SVAuxNDa4u7yVodcfumiJqeCT9wZAVO6orSW/jmZugPDJTjaonV9nWg+u+FGfu8VvSd6xO1D1Ck2EBd+Dtz1qCIGoCNUV56cHvInjvU4TitB7wMe6SnLVHLBXY4nW4kCvgn62ac8/93goqdMAv3Rk08C0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SVBv4bZ6cxXZiQ8aJrhcPCjMjNul9geVLGtHW0V6k+Y=;
 b=bfSr3Diyqd4H9Z0XFQ4WbuYX3aw6XOaToIJqLfYpFDl+0XzBVGcQAEKk1nXRCxYOMIGylwYg+3cU/e3AcnGzOIdOWQf7IvHgp8roJy/2cN4+SOyZYqYy4Ypm7ryq6DOnP1RS4nrMajHT7vhSeG/2B9RyQgiC7RDTE0BfwrKBdPNqSWICm7z3hUk7w9JE9ty/O32/ep0sEM0OMa0HZLypk+H+3bd6DkvOMfdXBJGirR49iX1g8v3MBKeXPaHv2LpAaFCeuYe5weaYcnO3IObuaQQafZvko+eSg1m/xs1jBo+4kG/w07EX61KeP3FhUSA7Hhr5C5AuVpucbaKRMQ67wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVBv4bZ6cxXZiQ8aJrhcPCjMjNul9geVLGtHW0V6k+Y=;
 b=dBcqqeFGTJiAwoTw0KrngIGiNRIhOvWfKYqahp0WZsYvsUPIOuA7+FP3uLXiNPWHzJgRr9TaMYv/SWn+ljNw+U9GyP947tU+fLkcULK58gnrpO7zrU2mj6mvQTeeXUUSK7MC9JBsnzh+c+YzozDzQwjjBdE4pbm1Qded19/lvcIZvjBqYhgAWOoGhu7sGR+eHu4MP3jjbaJNopms2yn8d0808sorWgiTwjxYRo0k+3xQPiKGlAw8F4/dRXGnhUZUY03jzHVnfzJFJ7rbAvXycxzssybS6lCWv802myhaflrLCeAf0rpH9WmA/PKoWt68AorOaG796E9YI40ecJVncw==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5245.namprd12.prod.outlook.com (2603:10b6:5:398::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 08:29:29 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 08:29:29 +0000
Message-ID: <dee75ba5-cca8-4175-d812-b881a7a182b8@nvidia.com>
Date:   Wed, 27 Oct 2021 11:29:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 1/8] net: bridge: remove fdb_notify forward
 declaration
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
 <20211026142743.1298877-2-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211026142743.1298877-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0030.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::17) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0030.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 08:29:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bd5ce8b-bf58-4c0a-cc49-08d99923e499
X-MS-TrafficTypeDiagnostic: DM4PR12MB5245:
X-Microsoft-Antispam-PRVS: <DM4PR12MB52457AC5719D469757D532F0DF859@DM4PR12MB5245.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ftpv/f/s8TPR4LjZZO93RbGBnVqsSbSuoXKKlNjng+9CavaxujV/Yr5LLqIqE9T0CheLED82pJpOEnYgNGBEG3Gdm9E5XQ57Ah3/osSopNcxTg+KzFdXA1br/6B76f4BtFYduegK9VyVh88Jw19XsNWqeFQZD2FAy0Q5VvWt8KtS0+dRJvvclYu9bTc/QzsgwsRkDe9Sq9ZS9YfsV7y+0iNyHjiNsdnXHJ+xstics6ebMxVOB3LwfHvAveaSn2Kzh6y8fASokANA9Pp1PsIsf7izAQxhVxtvRbd+QyzsF393sv9tzCg9fpvaz8TNxVTtnORYEbF8sXYYnBw3bVp9d4/j++mCkCi/4jrUYjLM3UHGOdpm3ZEzD62w0Lc1zhzolh3IXFKNwOMcLvQxhaTOfypnmCoRVYPNfjNo+68Io0wq6fsOw/tIXQn43Dj4VyZ6PzHdDTPnZN390gjKJDiyKROHx0YIEu4kbvxYkMVhRNY7879e9aYbzwSCPKIlFB4CsWT4adU53Hnxh7yvHztHEiN/aaP9PhSWG2XVSvCjdf5pUFaPMEbTMYTXwH8gUgenXNSUKJ9Y6W8qUvP1r5xkKB7gge5HVz/Ah+r3bkZfcNxCqH9lkbOw2XPhu4s5dRK+l+m0mFdTxFYIBekkQ2ywxR7On3EHxjuQwaXoPqKH97AOlbmUS+P4t50hTfVBj7Y9DD6opldpLwsSOpG4JkEh+a1lDm1ixL6dQZroYTUKZuk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(316002)(6486002)(16576012)(66946007)(6636002)(508600001)(54906003)(5660300002)(31696002)(4326008)(4744005)(107886003)(2616005)(83380400001)(186003)(6666004)(66556008)(66476007)(956004)(53546011)(36756003)(86362001)(31686004)(8676002)(2906002)(38100700002)(26005)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2R6M2xVbWpLL3ZXYlliZDlncUpXSWhuaExQSUVGdnA0aFl5eWN0bW0vdG9n?=
 =?utf-8?B?NTk1SXUxR2JEMkxnVUdod2JLU2l2MlRDNFlubm9LYk40N0l4YkVJQXV1M0hM?=
 =?utf-8?B?RDBkUG9TWXBDckdWZWVNSS9Dc3phQ3A1TEgwdmZNRkJzeG82aEgxNkNHL3hP?=
 =?utf-8?B?YklmeUo3cVpnOS84eXJtQU9sbTRGQ09vMmJZb0tLYitEaUdxLzltS3l1Qld3?=
 =?utf-8?B?YXgyb1BYREdqUVhXMHN3TzVQUHJ6bzNmek1FWDJOcDdXWWMxcnNjN210U0Jj?=
 =?utf-8?B?MjF6cW9tVXpXS2NqNUhvU0ZyQXh0TklCa1ZrdTlsRVQvVFV5ekZZV2Rsa3NS?=
 =?utf-8?B?elBDUVRzdEtBV0NDc2dVYndVYS9yU0I2Unpwc3Y2MDVKTzJLWFk4SzlMVUxi?=
 =?utf-8?B?UFVOVGZyVUhPUWdBQ1AzUzBNMmNjTEJzVDA4RjgwM2ZiYng2Ui8wZTVHQ2FV?=
 =?utf-8?B?K1g4dWRpR2VNbXlJZ0o2UDVwZFROZVpoc1JVV1dVckdTNWNGL250dUJ0azVN?=
 =?utf-8?B?MGhvTnZPMEMvUDIyQUt2bDJJU3AwT2Q4TnpaTm1yemRPWTdtT0hCSnhROXNK?=
 =?utf-8?B?WE5TUVcxQk5pbFpFY2ZRTzdGbmRoQXdGaWFsckYreUc4b0dIdHh4UjdTc0w4?=
 =?utf-8?B?NnhUNzYyWXNjTTd0SzNIcFhGY3BGeFFERkNTdlhrMUVpMHhzYnVTb2lLOFZE?=
 =?utf-8?B?SEdCeGZhWFVBaFZ2UXVzOTlCUkpLOGt5WUZPNW5GQTVwY2IzeUI3RXozRTkv?=
 =?utf-8?B?NmlvQUdrWVBKKy8rS0kvOHM1OEJneTlWNjY5L0dMTG03cllHWncrK3VrRE5O?=
 =?utf-8?B?MkI4ZitqRFN5TVR4NnNEWkRNeFdhME9vRUtxSW1weTBkNFJlZER0S1FZTmZN?=
 =?utf-8?B?WmN1bllBUkJJdUtLYUlDWlNhZkFlVk93SUJSc000ZnRuNUZ2R1FIQUlIT0pB?=
 =?utf-8?B?M2VyKzFzTHRaa3JFUzEwRTlyQWszUi8xd2FwVFJucWQrOTd3cUlxb3FlM0hs?=
 =?utf-8?B?MjEwa2J4Z3RWYk1mZ2VIZk5NRlptQWVSenlOV3UxT3hRZldpNDNvbXBiQ25h?=
 =?utf-8?B?NkZzemxNMlNhL2toRGtZWkNJb2xxc2lkcXdHbzhHc216cm5nL3I5bVB1Uzlp?=
 =?utf-8?B?eWVXTmJYWGtTYXpTRVRxa1RDRGE5TDJVS2NuRjR0bHk2U1N5eVNmeGo4QW5s?=
 =?utf-8?B?c0F2ZmFEb2tsclY5Si9wRTQ0OTF3UUFhWlhqM0JMT1NyR0VVbDlPRDc1bmxk?=
 =?utf-8?B?VUIrQ0FuZ2tnZWNIQTBQVDdQdnZSa05JSzhXVWNJWWM3QWx2dkFVRTIxc2FN?=
 =?utf-8?B?VjVYcXRwcjR4UGJUR1d5eDhwdTVoVk9hOFNpWnBkaktldkMwSWQweUZHL1Q0?=
 =?utf-8?B?SlU0UmtobXpLaDV2T01hcHBScHN6N3FLbjI2Rk5sVG9zSEZTSDVVT2s1ZnBt?=
 =?utf-8?B?WUduNTduOEV5VWh3emQyRHVYdzhHcnJGS0dqRmU0Z3d3U1BDNVRHOWhmN0tC?=
 =?utf-8?B?SDMvaHh4d2xUMmdDOGtWTTNGQUI0NUQyVFBjOXo3OWNUeVM5ZThaZnR5Qnh2?=
 =?utf-8?B?UldxUi9ud0xUVW1kUVN0T1pOZFBaMytNUm1obko4WjJSNUZJRkVlYVRMalZU?=
 =?utf-8?B?L3c0U0ZmNENhMTVjam9LNXpwMnlwdjh5MkVwaVU2NVlMZUhmckgrTVR3TmYz?=
 =?utf-8?B?TXFydmdNT3VJaTROYlJoQUlTNUYwbXFKZHhmZnlRaHpBZXJTcE9teWY1bTFi?=
 =?utf-8?B?OU1MTlprOUw4c2xZNnlsOFdiUXM1TXd5dldvalgwWjF6SEs4WHJsVXh4Nk54?=
 =?utf-8?B?cUxsNXVQemc3bS9MSmxjc2tqZitGT3RkYkFHN3F6NjNWWmVkY2dEUVNjTUlj?=
 =?utf-8?B?Um1sMVl0dW5aUnNkV3VpSzRjbkxYRWNSUWUvczk4MS9ZK1NLRStwWGw4Zzg0?=
 =?utf-8?B?WW9lQ1c4WEl3dXJ4SjVoUVRFOFZiRiszQmJEL2FEaGdmYlgzdEpJcVcwbzJB?=
 =?utf-8?B?eEJLVzlUMEZMdXBoY3ZDZDhLZTdXU1VySmhZRDhCaHB3M0RUUkhSeU0yYlVO?=
 =?utf-8?B?UTYvRHJpTi9GUEtVdSs1aXZGNHBGUWFIZmFoQkl3clBXQU45NGRJR2M0VGJO?=
 =?utf-8?B?SzlFNUlydFRBK1VRdlk0REJrc01EWlVrQS9aUHRUYkMzaHplSkYrRXJsc252?=
 =?utf-8?Q?k9P45xHDWxJLvhkULXas7NM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd5ce8b-bf58-4c0a-cc49-08d99923e499
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 08:29:28.9976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OM03s3PmWZdr+weUOXMxwWIfCSE2o1Xv7ekzVfwlNAFD1XPdkvmuq8ShizRiNn2aaWDVucvlilxQqoeRTGiyUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5245
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/10/2021 17:27, Vladimir Oltean wrote:
> fdb_notify() has a forward declaration because its first caller,
> fdb_delete(), is declared before 3 functions that fdb_notify() needs:
> fdb_to_nud(), fdb_fill_info() and fdb_nlmsg_size().
> 
> This patch moves the aforementioned 4 functions above fdb_delete() and
> deletes the forward declaration.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_fdb.c | 246 ++++++++++++++++++++++----------------------
>  1 file changed, 122 insertions(+), 124 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

