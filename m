Return-Path: <netdev+bounces-7886-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C83B721F82
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 922682811F6
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8D05AD42;
	Mon,  5 Jun 2023 07:28:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C45194
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:28:16 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD4A98
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 00:28:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ht6x+EQ75qnSE51DFArN2dQ+1H0yHX9703G25m17TqIJnH19+bOdmRBR9D5CrqFtcyMDK+8/tPmSuRNlfGxJe/Wm+O/w5NySpfuNBwmZfTFmCxu5R79/PbJVeQ7p45aiXPboiZEA7G1nZMmmXFBctuW9uMPxrCXoG4dSS8YREPfMuSE0kCKP6c1tJqVjH7l8P2brk7TyRpoOSuTCQr5Bri1mBPTBajlZ3HqxTvzvPZEZtBASi16xqC4zYpCAIAN97FO1/WlLCcYU7Bno6fpCaJDWBe1Sou4jo2XKdCzRsbuk7hYeSpCT24J7qUY5MNpmg3P+CKo0ARHU6o8TN8BsCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4kkqp3a5vqFogNb5wFM2tdH/BB14qrDiHRknVB+Hr+4=;
 b=dYmD+S55S5pdpEYGHt8KMbGFgIFY80c6cIBOh+oB6zVBTeKKQD4gjpt9YhuHWNbckpvgGGeudxGNvdWfOltyt/7sF18mADq1t0FL4Dwc8pjzPy6jSO1EZPKWWNg5/ffuEvRcB7kAMUDoZboTY5zAoZcgjhCIV2rtlshZGex3GjkoK7JmeKsAskrgdXrCs3zcfIF8ly/Cm//9b3K6LqY5bWwcKFlND2C4Nt3pcK4n1k/qIryVaAFqhcPXdhy3lIf0SBUXVAYmlNfVR+/K0rUYljKHNF2pRjHxdsqD1BYnXQ2fYsSD+vyep9qmWkUfnly2SK8a1HlZPq5bAk0c2yO5Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kkqp3a5vqFogNb5wFM2tdH/BB14qrDiHRknVB+Hr+4=;
 b=J+NvT4V6Mns8BAhztc89rsrzfbb8fZ/iIZT09z8kAIyGISVUJy0c0Di3i932TfjiL7MNL0IGp5txazQHPEM7UG9kzYkXjiwvIGOjY0BUYRgF50ZmChAdBzeSMxLrtlBfOjHVUhBFx6WtPoq2QN8j0l7+OoAQFlHDeJEH2elrTrb8BECgOUq9Je5wSwSb+vAY3m12gHoyfjqy7lLfKl4duWGrDUOvvI/uY0IyjgamYaXr27LlX+mnHf8sLcmg9mVUbPoxzTLHzUsFMA/S18ppZ63ZkLrCTKPgrkJUMkEzgRlkm1/d07+exQtwgXkqee19JSo/mA4aLtF6rWgTmuvIUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 CY8PR12MB8213.namprd12.prod.outlook.com (2603:10b6:930:71::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Mon, 5 Jun 2023 07:28:13 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::12e5:730c:ea20:b402%4]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 07:28:13 +0000
Message-ID: <cdbd5105-973a-2fa0-279b-0d81a1a637b9@nvidia.com>
Date: Mon, 5 Jun 2023 10:28:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/4] netlink: truncate overlength attribute list
 in nla_nest_end()
Content-Language: en-US
To: Edwin Peer <edwin.peer@broadcom.com>, David Ahern <dsahern@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
 Michael Chan <michael.chan@broadcom.com>,
 Stephen Hemminger <stephen@networkplumber.org>,
 Michal Kubecek <mkubecek@suse.cz>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
 <20210123045321.2797360-2-edwin.peer@broadcom.com>
 <1dc163b0-d4b0-8f6c-d047-7eae6dc918c4@gmail.com>
 <CAKOOJTwKK5AgTf+g5LS4MMwR_HwbdFS6U7SFH0jZe8FuJMgNgA@mail.gmail.com>
 <CAKOOJTzwdSdwBF=H-h5qJzXaFDiMoX=vjrMi_vKfZoLrkt4=Lg@mail.gmail.com>
 <62a12b2c-c94e-8d89-0e75-f01dc6abbe92@gmail.com>
 <CAKOOJTwBcRJah=tngJH3EaHCCXb6T_ptAV+GMvqX_sZONeKe9w@mail.gmail.com>
From: Gal Pressman <gal@nvidia.com>
In-Reply-To: <CAKOOJTwBcRJah=tngJH3EaHCCXb6T_ptAV+GMvqX_sZONeKe9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0125.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::7) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|CY8PR12MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e2516eb-ba8f-427f-07e4-08db65966c00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	L5waSq8VkjjgSNSHyo8/61k1ytrm9yXv2TgRTKDnNwonX5bGg9Pjhn0GNgwOKIALk4FXsnQP6C+z2pXY3clIoN6SZh9e7wsTvdDmjcgm7dqYp0O4rC4OaRkxgfaS3pXRVZYEs5v9yuH4MwCdPrt/uK6AH8re01GVOV+NUsnOkUMKBzd0dtDjti2UUdPRjkzBPcPWpzyLhDPRE4KUSvhKKL+1XKBQGIhHqkfhiBDKhpS6f1/KR5yPu8U7tziFy3R668eJ07yyQaH5lEJZev7d4sVnTAw9ZQdHnzIZ8R9+JAb7DBBMEAEtbJLqKv6k3xzLtWCjBpyuB0S6NVzEzfjCSxqlqZMfZvn796sDA9Pe7Rt3ZbaQ520phgnXYHqGDwYfhereEfD6iaYOLpH7Y1Kr7FJp+WW3nGYpx4hWILtjNY9FtAMTjH0DcB5hwyVs1sf0i64zYP5yQmwPCLOx1iwVWk9XH22lvb1CqCW6pY8ArsopZW4VuiCpgOacP3ej3C3AtNn57NQDnOjfOx17KYbGnAIKkAjFNmj8c2eicrP2fmNui6cGJXo8JdSEMm/0bnF4PCvp71fkwpUrU1DgqE/7jWC9QX31Stg541P6z4j9hyI06jlkZuk8Vu4scG31VN9vsEiH5RNmeHDNCpTYtrL/xCIYGuD+89Q4QbhO1kcbaEfR+gLRjJFU10Mf7apCkvq2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199021)(8936002)(8676002)(478600001)(54906003)(110136005)(966005)(41300700001)(5660300002)(6666004)(316002)(6486002)(26005)(186003)(31686004)(4326008)(66556008)(66946007)(66476007)(6512007)(53546011)(6506007)(2616005)(83380400001)(2906002)(4744005)(38100700002)(31696002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlJuOHF5WGovVTd2KzF3ZlUrYjc1NHVCMGlDK0VRRnBzN1dQVDVJSmNoNGFG?=
 =?utf-8?B?aTdlRFZ3TmxtdGhta2ZySFgvbDl5VXZydlJsUWVoeHNMSEFOSHFIeThZeXlz?=
 =?utf-8?B?aVJ6NGp0bm5Sd255S2h1aUZCL25aNDEyb2JCQTdTY1ZtMkJWYXV1ZDV4TkMw?=
 =?utf-8?B?VXFqU3lHMm1scTZKVnF3RDQ3OTY5U1FBbjB6Zk8zcmY5eldjbEFZSU8xNXpi?=
 =?utf-8?B?QjYzYzlhZ0o5MFQxdGJKQnVuQW5EaWxDaVVKOUJyaHdnZVJUSXJxUEtiZTZh?=
 =?utf-8?B?U1ZEaHowRm5nWnpqdk02ekVtQlA2VlNGZkxhZzdOVy9KZWRWeEE1NmxOaWZ3?=
 =?utf-8?B?Z3d3ZUlTL0dJUFY1Nng4cjNlUEpTeGFmSGNyTkRkUnZNNXdvWjE5cnFFNU5D?=
 =?utf-8?B?eUhNT01EdHJMVElYd2s3RVpzSC9vM2krMjZRWldlYlpEaGY4UFl6dENtbUF4?=
 =?utf-8?B?dDhHVHFjUE95TzJraitQYTZjci9lSFMzeGhZVFIxTnRXRkg2N1BPVTV5K2I0?=
 =?utf-8?B?RVEwN3ZBOHVhMjdLY1oraGc5bFRXOHVsbmlMSVZ4TU4rREtSNkZwYmNsb0NQ?=
 =?utf-8?B?R1FLbEdxRitWdWQyU2o2Z0Q2eGgwbHRTb0VmbVV0akROZFVrR1JmYkVjZHJJ?=
 =?utf-8?B?WTJTOHZ3eS90aVQwYkE1UHhVY0NWWkdpSjRQTU1IMG9FcllHc0hBYnNzM1Q0?=
 =?utf-8?B?OEtDQTRZUjZMSzN6Nzd0bnlxM3pnR3hWQ3RpR0FYeXhYTVBuTDdvVlR2dVZo?=
 =?utf-8?B?OXRSWnNBWGVNbngzei9iRUpRL3YzbFZEQ3BnZEhMMElEd0JWS3FSNGtWcmx6?=
 =?utf-8?B?RW9WU3JqQVpIK1NhMUVFZUNCWm5oQkcwcEJKRUtybGh6Yk5MWGpTWDRPa0xs?=
 =?utf-8?B?WVpPYWlwdndlQ2RjVGx0UmFIVW85MjFiRTEwSm4veEsyZUlsTm9hTmNLQTFI?=
 =?utf-8?B?Q0gyRXpTb2liQ0FLdWR4b09Nekw5cm95THRCbE9YSUhncHdobTJ6dXFqdSt3?=
 =?utf-8?B?Tzg1UUdnZ2l5S0F2QjI0WHpVWGY2d1ZUbFJTR1JTblpYeEpQSWF2cForMmFP?=
 =?utf-8?B?b2E1U1NWdTlUUktNYWcvSzdCSW1RNGVzbS9xRUNHQThaWThIUDRxQUhZaW5F?=
 =?utf-8?B?blU2NmpWZnhkVFcxTFRyQlFnTVByRUt6cXowMG1FSXlrb2FzWEplU3FzaUhz?=
 =?utf-8?B?TUxuRHFQSDc1YTJiNERhcTYveEI5NFp3UmIzcjk1VDlYbFN3ZTBaNUthOGRE?=
 =?utf-8?B?RzZMUG53U2dmaFl4QmNXV0JWK29aVmlnR1d2K0RsKzl6dE5sY25kK29acUVS?=
 =?utf-8?B?LzVISTBEYWY5NjhYeWlCTWdPNEx5dzhPWTNuOFNZekw0ZVBVS2xkQTIwUHZt?=
 =?utf-8?B?eW1EUGVMVEtuOHdFOWxwMFpGT285WThXa2x2cWY5MDR4aXg3aWFOSXd3VzU5?=
 =?utf-8?B?UjUraGVxcVpuNkNtMUlQMWxINjZId3VXRHlGZndFSlVVQnBrbkIrVGdwbjM2?=
 =?utf-8?B?MkNzVy90R095WmdwWVJFaWUyKzc5RlFTSTRSSjZyZUd6ckU4ajAreFVjdlZW?=
 =?utf-8?B?eXNuWTl6M0FLYnZEZE94TE82alZyU1Uxd3pvdjlIV0dxRFFHNk04WCszbmdu?=
 =?utf-8?B?ZG1qc2E5NDlUUjFIOGd1aWw5WnF3alpjS0gwN2ltK1hNWjBGcGtPRUpzU3Iy?=
 =?utf-8?B?akJHQTNjSkNHM1hhb3ViaUxReTA3eDFFempnemtoTTUva0piZGdTTVlVbExm?=
 =?utf-8?B?ejdYUTZ6VC82Q0RIVUR1cEZ3dEVQOVFJaUNQSk94NWVXa3lMRWd6TUxKeDFZ?=
 =?utf-8?B?cVYzRzNOWDlubDRtR1N0Qk9NdDFCWjNWbUxlQ3R1Y3c5ZEdHUUJNdDNIeDVx?=
 =?utf-8?B?Y1JGS1EvSWxRcUMrend3dDhYaHIxZW95b2hNZW5YRWpBQVRidGVMQS9JK3RZ?=
 =?utf-8?B?WUdOL1FzSTJydjhjdFhlZS9IUkdwRTNWVDl5MC9OVGtvMzhjTi90QTRRc1BE?=
 =?utf-8?B?VjNiTzl1ZlZ3S2UyelhncytPYVdzaUZRNlAvY2c4dkZHZS9uOUx1S3BzUi9p?=
 =?utf-8?B?d1RyNHZzd3F3SkxveFhXVGc5SlR3MVpkOEl3cnUzUWEybWNPMktpbWVocWlm?=
 =?utf-8?Q?gSUIvCeUutSQr5ln7Yvv+7/l2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e2516eb-ba8f-427f-07e4-08db65966c00
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 07:28:13.7990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Pt5Lepgq2QVMWJtRf0eZJpB2kXkuYRqLnmKYpenDTcuH2US4A1SZ8bq4Afz5FuJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8213
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 26/01/2021 19:51, Edwin Peer wrote:
> On Mon, Jan 25, 2021 at 8:56 PM David Ahern <dsahern@gmail.com> wrote:
> 
>> I'm not a fan of the skb trim idea. I think it would be better to figure
>> out how to stop adding to the skb when an attr length is going to exceed
>> 64kB. Not failing hard with an error (ip link sh needs to succeed), but
>> truncating the specific attribute of a message with a flag so userspace
>> knows it is short.
> 
> Absent the ability to do something useful in terms of actually
> avoiding the overflow [1], I'm abandoning this approach entirely. I
> have a different idea that I will propose in due course.
> 
> [1] https://marc.info/?l=linux-netdev&m=161163943811663
> 
> Regards,
> Edwin Peer

Hello Edwin,

I'm also interested in getting this issue resolved, have you had any
progress since this series? Are you still working on it?

