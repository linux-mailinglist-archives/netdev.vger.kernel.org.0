Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6572043DD2B
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 10:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhJ1Iwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 04:52:36 -0400
Received: from mail-bn7nam10on2053.outbound.protection.outlook.com ([40.107.92.53]:12961
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229626AbhJ1Iwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 04:52:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4QFt2S7P4C9+dWMdGoQIK3qLA2iHVF7BsUr7NHBjLnwdKB+zsIH7v657uRbx4GgpnwjsMyGk5M8MoOp8Vl0I8KauVUEaXuwVa7Uj+JvSVdbpr4N6RRlX3nDGkA7Ka3tai9jS/CSm6+WONs9E6SO3cxWZE170/t49Lk+9maP3TOFtOtkSP3nU3dKWIC+sSU6EJIoV0g+GkKyUzPCit4aFgNwRQgg4Onzr6UERPSHI/kCY00VzopLM106vPDGUmf7lTXFWe5DJmn5gnGfSEEsXQ/jL6ej01UVAsmPesxrqzdj9IjDctLtVDujLe0MRyWvWEwA9oFVIqkCaXuG5CjxJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oU5lWirJXRyzvYVIs/2rXlqREv4LSFxxEUMI5yjTOdM=;
 b=irNNCi1kl6lVwKaWC30MaSPy74S8SWIh2vo6NWcdZULeTe5YKC5kMYvwpwYjwLH1ljvXHZnx/NAzAuvTnLxv0fFZSSTJ/aUdm1/urR8dAnhMBpM8K2oQU9l0opwTVsf0fLgzTuAvO9EL36fl1Mj5PsNm0RRz5fMKq4pOPpFp8Or8uSUnJRytmfr+ENK0IS6uMhOWDgzPIhInHoqASZdm6hz36XxGo/RAgESMCyl48/LroDbNj1m/XrMJJly7PgdLmMuB8Gzsf8f6wZrF733Au/UjeUY7XHUgpcrNwN4JoFmqfMktNcQ/nvfmth1x7alWGOg/YZj1ypxYrASCPcncNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oU5lWirJXRyzvYVIs/2rXlqREv4LSFxxEUMI5yjTOdM=;
 b=tJ+qRZow2+7gGUbtfvoh4e9wfKmbLfciKchg/GiVKFXMg2PYua7D2LUEcWwBuFR6p0VRGq/3dPs4Q+Pq4d5JRCXU3j8ywHJ95w0C3yMsN0VHo4OjW0yQPcj4gnXEKnQFG3wbtpQ3dfapR8JqdiWU4icKLgHVHPmVL5IyqVGazGeUql32lIFm+sNzLxD/f1TI/ctzK3L+nMY8c9x8HDqfv1PpCXs1NgRvaRHoCC9fBTzUB3DOrt2DzADspmO6nvHL5j36OkE5+RKrxAGgLPyPhWmelJY1HUX/KWj87ERygPwoTjGiqH0k/JgoAVB7e09sTL/yFng/1AcE3k318Ho2mg==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5360.namprd12.prod.outlook.com (2603:10b6:5:39f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 08:50:07 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 08:50:07 +0000
Message-ID: <2212b070-a0a7-21c6-e157-573c432fbf3f@nvidia.com>
Date:   Thu, 28 Oct 2021 11:50:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 4/5] net: bridge: mdb: move all switchdev logic
 to br_switchdev.c
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <20211027162119.2496321-5-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211027162119.2496321-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0026.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::13) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by ZR0P278CA0026.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 08:50:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cbba418-09c6-4698-b4b1-08d999eff10c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5360:
X-Microsoft-Antispam-PRVS: <DM4PR12MB536021FEA41AD463F5B0419FDF869@DM4PR12MB5360.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DT6ROL7WXi1fSnV73pNuJDAFeoQgpf4CPvi58n2ZU3c+nb6sj7M7jRWL8C9U5y1i+PEJTHk8mm/RGNWh5BuCUhFIA489UCAVQHgi5ncNV6nLZgIgXGNO34XpTbZn966xJDlcf1WPRLeFh9LdqvQl5gA0xNDTa58j8fY7X04h7sfgXg+7CZuibgWfKBg5036qkX+RXjXFQZmpU4HimwABxoUEGDbPBh0rWDdEymQDiVNVyo0dtED/c/or1z/5ENOanNAUj0XaDT93n6qLT62iQTDSR9QILqb5ouM+CMhJpj+OIraTgEQBpHY7V/TvtoZwufP6X6J2BiY3R9TS/fqy5DX7LHRm1JNKe9il7KixG81MVF8UiTo1une/XZBumJrm9ALKbLdwEXIm2vVYf7ISFs+2+ChRWwTgBIP9qSp+vGuGKVwK0BxPryePeOlrfFfvGl8M4PchD4jgSI/1Jv5wWnMNVdmSLHaro0xinuEeI6ln1+l5hiWLIN3k5DQNTHZhA8BZqCjCUxnFtYg99HBMMT3mkA4+98g5V7WYIE8Ovt1VK+BgmMtk215Kal5CzcM55GeJqaKsQ5WRNRRILDFglyynD/HE6sILT56ew9v2VrMBEiQaAGsFMkcILGinZT5e8TaDN2iP7dfM0efj+JpVKesgByRlrJ8WQSY45mGDniDWuACTZH6r9sZTFpFM+OHBUpU/x3dj0FH4LgFYDKCqu9aJxAUNOmhWn7D9b/tHVLXawAfA6zv4nRlw49DvNKQ2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(508600001)(31686004)(186003)(66946007)(2616005)(4326008)(26005)(38100700002)(53546011)(66556008)(956004)(2906002)(8936002)(16576012)(31696002)(8676002)(316002)(83380400001)(6486002)(86362001)(5660300002)(54906003)(107886003)(36756003)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3pJY2ZHeXhqd2wzaWlwQVNrbk1CN0h4YitqK3h4WlVhUzNjalNRa2VNV1Zk?=
 =?utf-8?B?SUhZTWdJTkp4Y3NacEIrVkxGMVZxSWFhZTE0OVg0NlFVendlb0EwbzNUNm01?=
 =?utf-8?B?bjZmdzY2Si9pUTRaVlVWY0dmempvRGZtZWY2ZUtwU3J6L1ZvNlpPTThnNWhO?=
 =?utf-8?B?MkpNOW03QWp1REw2UWZVNTVqTVZhSkkyU3IvUlZKamNxVU5jVkkwNUZUMHBv?=
 =?utf-8?B?ZlFxZGpqVEFxaUFoaFZ6Zk9XV2o3S3IxanE3MzBvaHRxT0FKckRoWC93TUpN?=
 =?utf-8?B?VEFESExMSGJKR2FnYitjWDV6aVlIbEFXY3N1ZkpEVnZORC9Sa2Z6OHhCNzhp?=
 =?utf-8?B?Z1c1c0VMaDIvT0FWSWRnT2RLZ0xpb29La1NvbXhsK2l0ajRQVVRyMFpOV3pJ?=
 =?utf-8?B?aXZBMnVncDRyRmcweElZN0NSWmJtMkwwa0NSU283R3BnVHE2ZkVybFRuUXQz?=
 =?utf-8?B?akViOXpsYUZwMkFhNm4zVS9QUEx2QzY2VkMvd0VXWTVRM0oxZkVydUZ5N3o4?=
 =?utf-8?B?MmRoUFRtTjN1a3NqWG9hdHFUUDFJUkRVWitLVjJFQTUwSzMyU2wvS2FXdUtD?=
 =?utf-8?B?WVMremV5aGtER2VpeVU1L0lSMndSQmUydHdKV016MVI4dU5PTzlqNmR6V0p3?=
 =?utf-8?B?N2tRTFk4S0ErZXFBQ3VIQ3RNMThMT0xHdm1qZlFzODNEY2JjWStwdnpPalRn?=
 =?utf-8?B?emJwZlovZ3V1NzRnc2xVbnZITVVtUyt0aERIQ2l4K3VKdXZBN0YxOEFLbmxl?=
 =?utf-8?B?cTJIM2QxRkI1TGVJRGh3WTVldTRtd25odks4MzFkczgzcE9kSTRhY0U2RE8x?=
 =?utf-8?B?YmErSGwyWDBmRlBRNTQydWVwT1k2T1VSblNVQ0lIbTlRN3daaWF0Z2diTkZX?=
 =?utf-8?B?OUVBUFhNVTdEVmJDT2xzT0lJNlZwRHZhZnNoaHltbXZUMmFBLzg3REluN0U5?=
 =?utf-8?B?TUUwNCthWjNmYklVYnN1cHo4cklLUkY2RVV1RFFtaE1yQXYvb3I0WURWUVY0?=
 =?utf-8?B?ODFDNk9PWmZOZmdTV01DRktDa1lWUlpBTTFSTzhEVUVGSHdib1A4QUhLQ0x2?=
 =?utf-8?B?TmhDQjZlQUx2Mlg5WE9ZcjhHcXZOc2l3RTExbVZXKzk1eUk4cng1WXFxRDVM?=
 =?utf-8?B?bXdNQ1RKRWZMV3A1djIxRmFrSVN3dVBwdlBtTlpra3pQVng1dGFURW4zM3dm?=
 =?utf-8?B?V3I0N1JIMmNGNmNIcjNRRWFCN0Q2cHBWZDZ1QS8wK00yNUZMaFRPYWV1T1pn?=
 =?utf-8?B?Y0Rod2s5Y2ZqWWpCZGtVMk45NzY4bFFwdFVIN21JL25XVk1LN0NxU29OUWNz?=
 =?utf-8?B?MW9MT21ZZ1E0M1ZWdklzMCtGMXZNUnViUlIydWU1eElvazZPcVBQRjhlQ3py?=
 =?utf-8?B?SUUrOHlCNDJCcnVaaHVnQjQ4RkhXOE9VOHRRS1dHa09zUmhUUmt0YVRHRnJC?=
 =?utf-8?B?YkxpQ0o0SHdPb2t6U2k2WXFyMkVKQSsyMmNkb0tFL2JUUEs4ZTloQmRzM3VR?=
 =?utf-8?B?T1NBbkxJY3V0bXRPWmtnSEErM3Y1SWUxT1NFeG4yV2Z3cWlGSXBzbk5nZWxv?=
 =?utf-8?B?OWVoN0IrcVJqUDBXdkFpY3ZtUDREb2VENGp5U2p4WHVFVlVTWDhINVlpRmJp?=
 =?utf-8?B?R3BTWUlCeEhEVTV0WllhOVVnQUJ2QTlqS0NqbDdEYmlGczdsbkViL0plYlZp?=
 =?utf-8?B?Q2JuUnRmUkRIWFAvZEZKUWFXcFpmQi8xVGlZY2tnQ1VaeG9PSnB2eFhFMFQ1?=
 =?utf-8?B?cDBvR1psYTYrSHlYam1NYU42alYyZXc4aUZ0UmNDMTNhcHpCTnJkdGowOWxk?=
 =?utf-8?B?MEhxTjdmMHVxam9Lc2RLZm5Jak1ZdWd1OGxabkFwalo5ZSs2b1RPK2JBYUQv?=
 =?utf-8?B?WTM5cTFhYURNWHpQZE1ITmVhZDVPOG9Md05sSnV5MWZSR3ZzWEVVV2tKcW9m?=
 =?utf-8?B?Z24yNFBKUEVSZDVHZ1dCSEFjK2tlZVBDMytLeklRWWxQem05eE5Rbk1uNnFC?=
 =?utf-8?B?Und6RDYwNDFKbUZLU1dIU2FvZlVNVTN2R0dvNW9ITm5nN3ROYk1KanhIc2NC?=
 =?utf-8?B?OGMvSUVGZVVTK0h0K3ZPcW4yNnp4TlZYa1lFSXBMUm5VREJxMnpETDgvN09j?=
 =?utf-8?B?eC85eDVLSmRDcmtnTXMzc1B3elM2VkgwL0lnUEpITWFQd2cwUWQwTUMvQTJX?=
 =?utf-8?Q?yG9qyUX61IpOWDnn1bGa0y4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cbba418-09c6-4698-b4b1-08d999eff10c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 08:50:07.3535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yAtWt/v7LgwgVfBXnUqp8TrY7eKx3TvW+JtkYxNB4mhpV+rW6wO/RI9RZkLlgtUAS0y8Yy8uTBITUyu2ljcc/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5360
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 19:21, Vladimir Oltean wrote:
> The following functions:
> 
> br_mdb_complete
> br_switchdev_mdb_populate
> br_mdb_replay_one
> br_mdb_queue_one
> br_mdb_replay
> br_mdb_switchdev_host_port
> br_mdb_switchdev_host
> br_switchdev_mdb_notify
> 
> are only accessible from code paths where CONFIG_NET_SWITCHDEV is
> enabled. So move them to br_switchdev.c, in order for that code to be
> compiled out if that config option is disabled.
> 
> Note that br_switchdev.c gets build regardless of whether
> CONFIG_BRIDGE_IGMP_SNOOPING is enabled or not, whereas br_mdb.c only got
> built when CONFIG_BRIDGE_IGMP_SNOOPING was enabled. So to preserve
> correct compilation with CONFIG_BRIDGE_IGMP_SNOOPING being disabled, we
> must now place an #ifdef around these functions in br_switchdev.c.
> The offending bridge data structures that need this are
> br->multicast_lock and br->mdb_list, these are also compiled out of
> struct net_bridge when CONFIG_BRIDGE_IGMP_SNOOPING is turned off.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_mdb.c       | 244 ------------------------------------
>  net/bridge/br_private.h   |  17 +--
>  net/bridge/br_switchdev.c | 253 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 262 insertions(+), 252 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

