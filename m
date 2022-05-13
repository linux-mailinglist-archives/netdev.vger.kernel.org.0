Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE43525CB0
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 10:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347283AbiEMH5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 03:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377966AbiEMH5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 03:57:19 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE86E66690
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 00:57:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdLqTtULfPAftyEN94ffc2gkCJtpo5oW7ytKoP2SgANzowvDlqbS+w/Q1bc+feBc/oAySpoHcNFyq87/y52yRs94KWopcqBCJjXKxqDEecTalEDIlDQlM2IuWcXqTEdj2MpMvbpIv3wbHQqJGvCb0z3eGnc8s+7NWhQRKVkAyNqOHB9UY3dJII/qHrpwYdPpx36D7/3a56k3YSiKan2cAJEPCkR0117wG4tgOmBD9LnK20OYJDff5fve6+f9GUclZYt/28B4KWdM4vsJuWqxSgiIei90E03bNtkwMm2ubbaOI3Neq8NlCbt1qkNn7w1a6R/gvdGHyWhGjGnyUAabXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nCQeAEk8GURrJJIAhxz3F0TpqvkibUUQMxsqW44j0Js=;
 b=cJgJdnn06LXvaxQFT8xxTw4xLGtNKO6Cnl4gF/e3PPvi3y3A0HGD1BUa1zvUZbpJY0fHIpCqR/Rt089hws0yRgprM2VSiNfoe81UaLuu7YazQd+6bpUVBO7QhPnlklJvzYEIZl6YmPWXQIu/2YASwT5m34PSFHNQ18MxVWFGBejmdTtqzj7Wnm8r4XyUNpeRVOss81sYyHvZTeZkLMLK/US7Gk173OzzXqv6hSJdfBYPT8WSTvagG61hkEfMh4o2lTpiVRNWKvac/+e/haYK99agpQpEAwyvWLU7omkedkuURm77hv6LGclMId3VxheQ+6FXxJ2rPybkESkBdyDfYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCQeAEk8GURrJJIAhxz3F0TpqvkibUUQMxsqW44j0Js=;
 b=KFZJqFQCZhkOMH0dkNaQIvLsUXjdBcKGap0Hkl6Ziv531sX3aXVa6tlC7y7d+ySA+4QPqN/VBCfdLsHvzEjk0xB/NVHZhlRfki6IweYtt1ROdk/BF2aTQ2GuNbQpHzy0uq5fWU27DAXQiX/26U4u8N3KOuAcFzZOYvOzX//4wHu3t4llDJiWOXyL1UEJ0msKBib3o48ZwXyECld8I1IbdL1I1Z5iY+suzuIU9JPMzgcMis6PqAhbBIQ8m7yeCEh/nPcnOAVGIqOW9BgKdRi1HEBYWpMoTqd23DIlr0T2SEsf6jJRYuAuuCuwt0C88SwDrQHfgj5nRufnAhBOeZEWiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by DS7PR12MB5984.namprd12.prod.outlook.com (2603:10b6:8:7f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 07:57:16 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::a186:70f2:4280:14df%7]) with mapi id 15.20.5250.014; Fri, 13 May 2022
 07:57:16 +0000
Message-ID: <507d2140-1f22-174d-f55e-16ebcf03f249@nvidia.com>
Date:   Fri, 13 May 2022 10:57:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v2] tls: Add opt-in zerocopy mode of sendfile()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, netdev@vger.kernel.org
References: <20220511121525.624059-1-maximmi@nvidia.com>
 <20220512163458.31ae2d13@kernel.org>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220512163458.31ae2d13@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0495.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::20) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d892d83d-7f44-4640-82f6-08da34b632a2
X-MS-TrafficTypeDiagnostic: DS7PR12MB5984:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB59844CDCE3E1023F9356047FDCCA9@DS7PR12MB5984.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C/jP9XBOgVnccdMlLRDmKqs1QFb1kVkcml+D7aSoHtFv0wbOEzAgKiwEzZizdnl6EeW/rsQDJfjV2+otEMua1hNZPxbmN4PdbNqglg+nSEs8F/PdtP8zK5oUfLLG/7/Z6D1BI2gRCHPYJoZW61lf+74sa9B3xYka5GnOfZjsR+jOhBG6xjsaDx07K9ZWorL8QrMq68e9W8wPWcxKkEx0NO0UwGbeH0dVXaIjnpD6NmRzaOSLCxnVVwoaiKmekWK7heVvHE21ENIPgeHQctUJ743bnQZW0eBAkJUmVdD9ARx5DFqGWCbUJegIjvVa9tulPn9jhe8Rc2HZ2NnbV/ZKnMn06btSTjeJVX540LUgFhLUuWuAuMIDkU4rAAtG4wZG320GZCqvBFghmDwltQZX7Pfbk78fSfectd7lAFCyD0Gs8Vl+iQNEcxsgoDCbqcoMsa/iBtdn25It6CC2eZtOQXRxKTSI539t21r1tb2HMQ3gNlw2452/zsgfrnoyNvjHpMhQVJdchqsx9Tt7EiRjhTW4jA9UgYC2WZRJOEmvFqh1N5BQiHM+fkRlNG3WIkpzejKCQgNJIL+EO9Z1z4p7S4btnpTWmYoS5W6LIJ9sJ7aWFr0j56eSXVijKAvwqJ0agIMxvDpaCVrvUYb5/RS2pvY0MtauKv2YIrQdVnB9aPx1xucSIcGRJmmpwE432DlOtpS9i8PemjO7sQE+mr8JfH/nIieuybHmtp4MBWIrqWs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(31696002)(36756003)(2616005)(66556008)(6512007)(6486002)(186003)(5660300002)(31686004)(4326008)(66946007)(6506007)(53546011)(6666004)(66476007)(316002)(6916009)(26005)(54906003)(83380400001)(8676002)(8936002)(508600001)(2906002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkZQaFlaUnp3TTBmNjZKbkRLRXdUOVVWZm1iWTN4Z1hhSXE0SmtRcXBwSWFE?=
 =?utf-8?B?blFIMmRvb1lnU0k3NS9WMzlGUk40eHBvSzlIYktYWXE3MHJiVmxZdVJqOTRP?=
 =?utf-8?B?eThXMW1tQ2tUaXc3NXJBeGtSMDVqOE1tZENiMDhJVlRmR2JVREttUDhTc0la?=
 =?utf-8?B?bHhnclIvbkVYUFpMeXc0QWkwRU9vMVhOaThVVytzaE1jSEpKNDZKNTZURlJo?=
 =?utf-8?B?NWhqOFdUeklZYlBEdGkvTDlLTk96a1ZwM3NnbUxsUmIyZXdocnRHUXhEOVB1?=
 =?utf-8?B?N3NWaWdnRUR4Vk01dFgzdDVFS1VEd1U0Y3BYOTdyb0tGblU3TStIQ0srWHZ5?=
 =?utf-8?B?MVFBR042YzUrTlZGai9QWmhTb21KOWQxYUJIWVQ4UTFHVXNHQVZFeWdlMzVS?=
 =?utf-8?B?UlRDSHNCWE1kWldJODVpdEdwUE9mQVZHd3JFTU45MFM1b3dkNHd1TU9WWkdx?=
 =?utf-8?B?VHBZTHlIQ2NnT0pOZ1hYa2txT3A1YjlvelVHY0Z6d1NNTnlpZzRZeDZOMTRW?=
 =?utf-8?B?YTFRZnVBZkQybTJ4cEFBWG5HN0Y5blhIK0dIQ3NFVHNyNVJnditGUC9OSDJP?=
 =?utf-8?B?eGh2bFVJUmVobURMTVpkYzBBQTFXVmF3VjNna2FrTkdpK0J6c3d5ZTZvdG1a?=
 =?utf-8?B?VEFTbWsybHJVU3F0TEZnNitBMFNmQ0NuQXozb2kzdXNueEFwUjZiNFpBK2Rl?=
 =?utf-8?B?UjN6Q1RVelVTTGdXZ2lxcHFjMUpVVGtxZkl4a3JTUEl0VWFKSERMblFmWDNW?=
 =?utf-8?B?dW10Z2Fzd1ZVL0l3RTMxK1hRWCt2KzY4a1FBR0pKSjdhYVNHV1NEMmxUWTE3?=
 =?utf-8?B?Q1NmUzh5N2xpZ3F6aGtUaitlRmVrNFVWZ1BWbURjZ0dNV0pIbGlRYmFxcFRS?=
 =?utf-8?B?bVlZd3VnYi9JNGtMUCtaMEJDd3NrLzRNQ0wyQVhZNkdCU0FVYzcySnU4S09R?=
 =?utf-8?B?TXRTd0QwS0o3WWJ1ZCs3WDRvczQzTEVUampHQkxidUFDTEI4aUVoeHlvd0Nm?=
 =?utf-8?B?U2NBdUpscGJhd2lPY1NoRlZjazUvSWoxaG9SZC9JaU9KSXNOSmhLTTdOL2pW?=
 =?utf-8?B?U1l2WFgyZVRXTVpwSDVWMVRGVU0yWCtCeFIydHNEUzRWenlaUXdSRDZqQU5s?=
 =?utf-8?B?VkFab0VmdHhOdXMzay9Ka2JZV0Z5R2FsU2k0MnA4MWVsNmdjeDk2eDZlMmt0?=
 =?utf-8?B?VzYwV1pTNU9mTVR4YW1sY3h3bUpiQXV1b21hK0FETnk2UXQ1VTdndnBVWlpG?=
 =?utf-8?B?MDZiWWF5Mm5ldEhkR3hzdWhaV1NRcGhiQ3FxUTJObDVJQUxKR3N6ekNjaU1p?=
 =?utf-8?B?K004bGx4OFk4aU1VeFVaU0U3ZFFmMDJLQzExNDZYTlZXY0Z5WGI4RXFneUxC?=
 =?utf-8?B?M1EwQWQ4Z3kvdStabjlVc2M2YkVxTnRmT0l0WElPejJBRXFZcm5vSlRnU25v?=
 =?utf-8?B?WDJQRVYxS2tsOHphZ0w5eWEvend1WlFOYlk3TXhUTHZMTGRnMzZmTHpzYWxZ?=
 =?utf-8?B?cW51SHlhNTcwTmpkdDlUYjFWQWNCL29SajNWTXhCTXlVeXRrL1NzM0UxbzEr?=
 =?utf-8?B?bDVxL3VJNjFjNDJtY3hyaTRXMjd3bE9OR2h6aUJwcEZoN0EvSU53UG9ybEdv?=
 =?utf-8?B?MjF5T1kwbjFNQzN4Z1o0dUxWaFlmQVdWWWVqeEZpY3lqQWFGdUxGOHlKMmxC?=
 =?utf-8?B?alMvdTI5Y3B4d29OM0cwcUZjc2grWE9mZGJNanA0SkUvQmpLOUV0akYyaUpw?=
 =?utf-8?B?cEFqemZhVk4zOVVndUxpZFBzeHE4Rkl4dWNMdG9POWVOUERtRTYyWmpyRmo4?=
 =?utf-8?B?T241MGgyZ3VRZlBreEFIaHdLdnhTREFxUTEybHVHY0JnZmpXS0ZabUFhazVS?=
 =?utf-8?B?OUtiekIrYUZtZE5Ud0swUGFmSURaSktDNHpjWlJjZTBGYjY2Sk5XZzFRMGZa?=
 =?utf-8?B?TjVpN3J0cHBlMnN5T0NjVjRHYU52TkFJUWpBM2lnUExsREVTZ3E5ZjFveUN0?=
 =?utf-8?B?VlNjQzZhbEdXQ0RxUU44UWNteGhwRXNNOGFLdUNQcjVEbW5YYW9zSjEvQ1JQ?=
 =?utf-8?B?Mm9YQkNJdWR3VThEWDZkRXRobkpYYkkyVTk4SktydDd6aDZ5eTl1NnAxWHN3?=
 =?utf-8?B?dnI3UjNQL1h5U05SeUhUWlRjQ0hlU1IwNzFNeG14VmpsK0c5S2M3RlJCeXdS?=
 =?utf-8?B?cVJyVVdrM0trL3ZNdkZSQStwRU5WTHlPYVRYVlhxamMxV01yYjRJVUoxdWtG?=
 =?utf-8?B?c0lwUjRGb1BKL3FnQ0ZLb0k0TURka3pRczZONlphR1BhRTEwdlBaL2JvSFhh?=
 =?utf-8?B?N0J3S2NQclAzZDBOSkR3M3RSRmR4U1R5c2FXMFpxS1V5NkpFTUZSUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d892d83d-7f44-4640-82f6-08da34b632a2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 07:57:16.7518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EL1re44+FZbC5PzHgkNrNBGTlgK+yP359jZiQvDm9dqWLpKZgTvpmHSHZN0D/Sfx98kg9FCGpL0drNtDI6I/1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5984
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-13 02:34, Jakub Kicinski wrote:
> On Wed, 11 May 2022 15:15:25 +0300 Maxim Mikityanskiy wrote:
>> TLS device offload copies sendfile data to a bounce buffer before
>> transmitting. It allows to maintain the valid MAC on TLS records when
>> the file contents change and a part of TLS record has to be
>> retransmitted on TCP level.
>>
>> In many common use cases (like serving static files over HTTPS) the file
>> contents are not changed on the fly. In many use cases breaking the
>> connection is totally acceptable if the file is changed during
>> transmission, because it would be received corrupted in any case.
>>
>> This commit allows to optimize performance for such use cases to
>> providing a new optional mode of TLS sendfile(), in which the extra copy
>> is skipped. Removing this copy improves performance significantly, as
>> TLS and TCP sendfile perform the same operations, and the only overhead
>> is TLS header/trailer insertion.
>>
>> The new mode can only be enabled with the new socket option named
>> TLS_TX_ZEROCOPY_SENDFILE on per-socket basis. It preserves backwards
>> compatibility with existing applications that rely on the copying
>> behavior.
>>
>> The new mode is safe, meaning that unsolicited modifications of the file
>> being sent can't break integrity of the kernel. The worst thing that can
>> happen is sending a corrupted TLS record, which is in any case not
>> forbidden when using regular TCP sockets.
>>
>> Sockets other than TLS device offload are not affected by the new socket
>> option.
> 
> What about the reporting via sock diag? Am I misremembering something?

I recall we discussed that "zerocopy is active" can be restored as 
"hardware offload && setsockopt flag requested", and I saw that 
tls_get_info exposes the hardware offload state for the socket, so I 
thought the existing information in sock_diag was enough.

If you think, though, that it will be better to have an explicit 
indication of the zerocopy flag to sock_diag, I can add it, it's not a 
problem.

Does the rest of the patch look good to you?

Thanks,
Max
