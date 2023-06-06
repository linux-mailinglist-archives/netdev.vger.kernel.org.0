Return-Path: <netdev+bounces-8377-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 166F2723D6D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6EA9C1C20863
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6046E294C6;
	Tue,  6 Jun 2023 09:30:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE39125AB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:30:18 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92A2E49
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:30:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGA2OaYnl9oMw8rHeAN4ekXqH2R3HolieFrTKs5XnqCCNruBp25CEo5qiBlt1SYpxEfErCw7IiKCsqcNEPV2GerQvyp9PCPJ6JGtRKsaAbVWHxIgWPG+Peah9UVoBwUVLeMF3yiOUrDzUNbW69Ve4v3qUz/rSjxZe67ej+szo1hU7CIB7ZKbfWEYsfq6wH0om3tC19X4pfs917K90w4n1avbuT4WM9CMtoUxeG2IwFI1mhlRWInm3fnlzRtxu+lglyhveQI+Pi4uXcwI9ouHb+FqDQwV3+2wojdcaUAd2QWBs2SVDlptdcno7qn+29txeSdOLhbr+4PQExWJXIxRag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xycqGCew+BWENpqlFc+9PHW0Hl9yYiBFxBGO92/F2ro=;
 b=KBnaMEiS3RMDpHXMAcHteEXmtzsVGED03gBzhknIR8w+F7Rc7pbMbIXwg/8ZoXLMTXP9aawm0fFclJx3A3ZOQxNK9yESfHNtlYInyO0/nuw+jsUGhHCO2UXkbOqv7FiSsLd7G2bpMVrBvH2akeKNa/kw3GywMuT3sBso1LNNWCTArlAHKywAyxf3Dx+hr5YvpTCX5faiqTwO1JG9qq2XTRM5PcTIcw4k11T2tLzou6+C52XX1K5w1oTO9+/pN0H1YGWpBlc6BMhnsr7v1Br6h+xw4eih9BxRv2o3AKfpYrtJoDLkWZ30bkXnREfQb367r7C91rj8h5Cibd//D4qJCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xycqGCew+BWENpqlFc+9PHW0Hl9yYiBFxBGO92/F2ro=;
 b=DzxRtsWq+0SnBewEPhizLWgfkA3yBsvT58bkWgQiXuQGM8V8Fmok9IUcK804Ia088n/GHxMmzm9q3GhsyxmCnQnc5Hb//80TAhDT3XNeUN23L/TWrxmVZNRB0Y9pN0sqbVTq8/ucFAiO5kQhJQmwYw2IyvP9cq/wQaSqLtfw7Bg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5267.namprd13.prod.outlook.com (2603:10b6:510:da::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:30:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:30:12 +0000
Date: Tue, 6 Jun 2023 11:30:07 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc: Linux Network Development Mailing List <netdev@vger.kernel.org>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Benedict Wong <benedictwong@google.com>,
	Yan Yan <evitayan@google.com>
Subject: Re: [PATCH v2] xfrm: fix inbound ipv4/udp/esp packets to UDPv6
 dualstack sockets
Message-ID: <ZH78nx72BdFUYPdM@corigine.com>
References: <20221026083203.2214468-1-zenczykowski@gmail.com>
 <20230605110654.809655-1-maze@google.com>
 <ZH3cN8IIJ1fhlsUW@corigine.com>
 <CANP3RGfWATmOzb4=DXb=+K7iij4HPBp0Uq79r0NjxGyvAaKNgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGfWATmOzb4=DXb=+K7iij4HPBp0Uq79r0NjxGyvAaKNgA@mail.gmail.com>
X-ClientProxiedBy: AM4PR0501CA0044.eurprd05.prod.outlook.com
 (2603:10a6:200:68::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5267:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c7d0bca-4292-4fb8-6e53-08db6670a10e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZXqYE/s7U7wsZk63zoVtGXVOxRB49fSuI9m+a8xfn7e6X2UMuJ7KW/hLkf8Nf6x18uY6RgyVsFU1PN++DQSTm18kaiJL8D676vU/JwDnD7ml9giyIffrz9L8Iuf9osfIi1Ibezva9kPGI8C/OkI3HjDg1Y9zKvYTQP9sxKebUZQtQOFmGhBmMcJ/10g5W1lPrArsfZX1GIp6KOce7aKFQUUaZW3ckCT/MsElyQ2xNNycN55ophzUbFfgGcXuDc9SB35w121G+TF+XCQshxfcFlbjBUFeJnMo7B/gpFNU5LarL7FCDWXHwyuJLBR3waHSYXbs7N/JSnb5OO2pALIqtF/bKqjeTOqlB5DTmqGCmtiS5Du9itZyMLTUchK1xHIA/Ki1TZPJVFuOwrU0eiN9m9T/Wzen0ylpmPVHOURvchGrX6AxymD7vW2sG9MqgubEXteHaO+K1P31sIAc30VydPKz3Y0ErTRem/k/PxZfa3nvFtWI4VPXUkNghookTmajZQXhSusvpN4GYPUzfqKHf6NixwEp//a4ycw+BYj/VB9iY81fT2EaEe+al3eaJ4gb
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(366004)(39840400004)(346002)(451199021)(36756003)(44832011)(2906002)(5660300002)(86362001)(6666004)(186003)(6486002)(6512007)(6506007)(53546011)(478600001)(54906003)(38100700002)(2616005)(316002)(66476007)(6916009)(66556008)(41300700001)(4326008)(66946007)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2JvU2IzOTFHU2c4aXJkOTltTnlyUVM3LzNHZHRnWis3UC9udjZTdnZ5Mndn?=
 =?utf-8?B?bk5qTEVqa3lJY0FUc3lncHFLZ0o4T0NFR1hSMTI2cDViMDdhaERxZzkzOHZD?=
 =?utf-8?B?cXZvNktvdE01YUxxelA4eWN2Y1U2SmlFa2JGME1jNGJpcVgzQmdRWU1VL3BN?=
 =?utf-8?B?TWVWT2I5QmIrVlFsYTQ3c3FIOEU1dEU4Wm4zbTg0bW8xT05iclViQU4zNXFW?=
 =?utf-8?B?NE9NNDJsZHcxcnVaZHpwSEswMkRMd3h0WFV2L0xYQVRXMy9DekFoYUo2N295?=
 =?utf-8?B?a1FNdlpvUWJMNkRXSEFYZGU1M0tKdnZEYklaQVhvMXd2aFBWbkV2N0hyN0Rz?=
 =?utf-8?B?U3A5bHdmNXptVXJIQ00rY2pvaHE2ZU1SK29vQ3BDVHZnWmpKZG5pb3VqSFhp?=
 =?utf-8?B?eHJBTG91aENhY0xmam8wNUxoWXZQWHZydTYvRzl6K1BOaS84Q0lzYmxwSGdS?=
 =?utf-8?B?aUhBMkZ4a1I5QzBYV0hkaWRYTkw2Y2Q2TW1mVTExUnZRUStrUUl3M2VidkRH?=
 =?utf-8?B?NitJRXUxUjdDWnE2cFhiaWIzYlFRZWpSMnV1aUI1UFovZElma2IrdGFMM3d3?=
 =?utf-8?B?R3BQSUVsdkxzdGJ0alV6bjZmRXFraGx6VFVQd3FVc3cyamhHM2RtVFphbGJO?=
 =?utf-8?B?Nk02MVlUcnpvbm5ZOEZoOEQ5ZWZuR01GM3RuUHJxemlKOXQxa1hMRXJSTkFS?=
 =?utf-8?B?ZERpYXh5RTAxVDAzWlFxOGxqUk0zK2ptK2RnbTg3cTUyUzRXSEhBQXdxUUY3?=
 =?utf-8?B?UzUwT2JhZWRyRmpiRGMyVVZOYnhLYisxVUJZMENpYUhDV3RaMFVyeWpTOFlq?=
 =?utf-8?B?Q0dzQTJhNkNWcDNoYlpzakZTMXc3VmVyWmNEcTRScE5SU0xHcFNrZm5UaExr?=
 =?utf-8?B?dWk2V0QzYXgrV2tIa3l5NGpHWnROaktZU2R5L1plOEI3WE94SWQ1UjcxYk9P?=
 =?utf-8?B?VEs0NnBiZkhHdDBDM0FtT3JCbVlna3VtUjByMTV4WEVqZWdyNEVGWXZkNFBj?=
 =?utf-8?B?Q0wwYUIyTmdjb0srcTdWUCtTeHdEZmwwekNaN0dBVGZNUGNGYStIQTB0V2E0?=
 =?utf-8?B?dkh3d2xONmFlYThLT052dHVyM2IyR0hjK1BvV01Md1krMzNZMVJOZEc0c1B1?=
 =?utf-8?B?MWRSekFGTXpaQjBqbXJvVERDRGVmMXBUbDBaNHdiVlR2Ry84dGxYZEI2aGhK?=
 =?utf-8?B?ODBwRFBZU1VwdldLUW40ODVQV29oNThDVm4rKytjM1ozTk12OFpmOVBhMjZV?=
 =?utf-8?B?RUlxWk10NXM3NlB2RTc4TlN6NGgwOURwQk1idDFxWEpPajU3bEdvbER5MW9O?=
 =?utf-8?B?cE10ZGpzcW16aVpveGhGTlo4K3BBS3BEdmVzU1BCSnZocDVKN01lNXIwc3Vx?=
 =?utf-8?B?Y1BWOE1XalFEa3NsQ2cyYUZxMTdjQkVnWVFDZ2IwbVpSOFBVUHBLakgreis1?=
 =?utf-8?B?SStITjVldklYbGhVbnh3Z0Fjc1VvOFgxSEVReC9WdzBCcENyNlQ5cTlrWE5W?=
 =?utf-8?B?SkkxTWttbGJZQkdpQzB5cGVOeHVFLzM4bDFrbmk2ak9laTVRTDBQTFdOOVM1?=
 =?utf-8?B?OUYwaExwSmFST2tZLys4NHhwYnQ0c3gwSGsrMUJaV0lMRC96Y2x6K1VEUDVD?=
 =?utf-8?B?TC9Cc1IrTTRWU3V2SFVnQnpnQzd2VDBaZWJvSU51c0hON2dqSzBUVVpndXd2?=
 =?utf-8?B?K2R2OUN2dlNaZk1BSnp2MnFEQTNVY3JRSVZ1Z01zUDFpaEJWVWFTS3JwNnlH?=
 =?utf-8?B?TExtaFZnS2pCZnd3RElyL2VBZmpUWllCOElpelhYcUVuRktDVU1KNEdZclgz?=
 =?utf-8?B?RDRrWFc5dE1JSlpZUitBNW96VG5QcXBobnZHWjdPRXJyU29HbHJjMEtFSEk4?=
 =?utf-8?B?TEgvS3pRTlYxdms3RzZYaFBsY1NSM2tjaW5ON2xFK0hJcHJOOC84VnhyS2do?=
 =?utf-8?B?Tnl2ajNncWJlY3dFMVNWRU9PUFhCWWgvak93YkVwZ3ZickllU04zTG5aeDBM?=
 =?utf-8?B?dStDY2tmYnN6YWRTblRHNXlidld5UUFwaVhCendGSjY3b2tMQ242UlhaNS9K?=
 =?utf-8?B?elVycDJIWVQ2R3lmVDBUV2JRU0JuQ05TMDU5bHRmWDNjWGp2anRHOG1oRm9Y?=
 =?utf-8?B?K2MwNkp3WlZvMHhHWDR3SVBSZ1lERjBJN0IyazBEOVY2TzNxTE5MaVhvejFR?=
 =?utf-8?B?N3hkRE9CYlpvb3ZSdnhTQldGNmNPeURIUkxUTForRXZwOTBSZjRIcWkyU2hJ?=
 =?utf-8?B?dTBITTBicFNTRDlmVXhpZWc1OXJRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c7d0bca-4292-4fb8-6e53-08db6670a10e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:30:12.8620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ej0RL25MHXfTF1klXMK1oves5zwy63R4QYlfhpEKtsPkwqVjRnw5hfEgJvC+wFCC+UH1oSGN1n7Sn57R+Drty5hKgoPst3yp2CbGaFKlY5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5267
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 06:38:04AM +0900, Maciej Żenczykowski wrote:
> On Mon, Jun 5, 2023 at 9:59 PM Simon Horman <simon.horman@corigine.com> wrote:
> > Hi Maciej,
> >
> > Does the opposite case also need to be handled in xfrm4_udp_encap_rcv()?
> 
> I believe the answer is no:
> - ipv4 (AF_INET) sockets only ever receive (native) ipv4 traffic.
> - ipv6 (AF_INET6) ipv6-only sockets only ever receive (native) ipv6 traffic.
> - ipv6 (AF_INET6) dualstack (ie. not ipv6-only) sockets can receive
> both (native) ipv4 and (native) ipv6 traffic.
> 
> Ipv6 dualstack sockets map the ipv4 address space into the IPv6
> "IPv4-mapped" range of ::ffff:0.0.0.0/96,
> ie. 1.2.3.4 -> ::ffff:1.2.3.4 aka ::ffff:0102:0304
> 
> Whether ipv6 sockets default to dualstack or not is controlled by a
> sysctl (net.ipv6.bindv6only - not entirely well named, it actually
> affects the socket() system call, and bind() only as a later
> consequence of that, it thus does also affect whether connect() to
> ipv4 mapped addresses works or not), but can also be toggled manually
> via IPV6_V6ONLY socket option.
> 
> Basically a dualstack ipv6 socket is a more-or-less drop-in
> replacement for ipv4 sockets (*entirely* so for TCP/UDP, and likely
> SCTP, DCCP & UDPLITE, though I think there might be some edge cases
> like ICMP sockets or RAW sockets that do need AF_INET - any such
> exceptions should probably be considered kernel bugs / missing
> features -> hence this patch).
> 
> ---
> 
> I believe we don't need to test the sk for:
>   !ipv6_only_sock(sk), ie. !sk->sk_ipv6only
> before we do the dispatch to the v4 code path,
> because if the socket is ipv6-only then there should [IMHO/AFAICT] be
> no way for ipv4 packets to arrive here in the first place.
> 
> ---
> 
> Note: I can guarantee the currently existing code is wrong,
> both because we've experimentally discovered AF_INET6 dualstack
> sockets don't work for v4,
> and because the code obviously tries to read payload length from the
> ipv6 header,
> which of course doesn't exist for skb->protocol ETH_P_IP packets.
> 
> However, I'm still not entirely sure this patch is 100% bug free...
> though it seems straightforward enough...

Thanks for the thorough explanation.
I'm happy with this patch.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
> 
> I'll hold off on re-spinning for the ' -> " unless there's other comments.

Ack



