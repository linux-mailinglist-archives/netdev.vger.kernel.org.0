Return-Path: <netdev+bounces-11981-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FF273593B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D34131C20AA3
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB787125A9;
	Mon, 19 Jun 2023 14:12:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A8D10955
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:12:25 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2099.outbound.protection.outlook.com [40.107.243.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7C3E55
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:12:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWE9y4LcXVafL7CptFm+9+3FDFEINjCWB01YJCrxbiCc2CJonb1bOgRRuPs7AX5gmMdQNC7dLju9CyUz9+OQJJQFXhAvPkdtzErUhWMxFMiOFEJm3JjEzeG1j28vp9dRXxwpDHTeWBZ3uKWGiayq8St/wAPSFjT98KA58bzLihB7gjxpb8j6NPfOyDa+a7yVBWZX2s/eDHuZDLLxKsm93Eo16fwWWDNH0uWjFEw9NPzIxQsjEUDZZt40kSXzDO3HEQ4HedFYCvo7wDHGJhukktMYIkbpBQASnd/7Hjqjhj0gW0S4yo/Z49WMOSxJ3ZK1vOKoR0LkdZxNCJX+xD6pyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LpWPt8kwxJ4RmXCVyGca0z8S7a7DH3dFGKjeVWo9YtU=;
 b=WLrF5BYreTUhTHJjgghOJkDIJnNaEpXEuyRhqlbOGrdiXH1VdXLhYQH5O6fcpCx2la5Oc9DQBFpvVmlMc/98/HImEVIkaUWf5gUNidub1bfGyEJZyoMFClrNWxXBqdwBBYT8riKOgIePPKWEcvw8b5VFFHkBOtZEPHgjtsKmmOI+0Z7bZkHCfTP/feJluAXOx3/ybUsJx1cRr79qhWXo1Wegr/EU8CcjS1BX1PBwb4OsJu4ZUEHOJLM5LK4hI+QYZn1su7zm15zjqhbrIm8+JGfOhInJfDvtedyG1kJiV6UdZxV6P5x4A9GrGc+SZktDWk+AFtGkjADR1XMJE7XiZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpWPt8kwxJ4RmXCVyGca0z8S7a7DH3dFGKjeVWo9YtU=;
 b=F0uvF1/tFDMQopAwTEXrLU2IgD9wAjIhRBIczkgLX8jEFSEplCBf2Z7dQUp/Kh8V1ANaelo0/EQStebp+3ZoHAvA5dv1MjkxZ1xubuzq/FDxM+6MA7Tf0OpjZpFZyx7QeIqRqEYNrclsh81ZsRIoQ8oxMdgzTs2nEcRarp4Ikus=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB6079.namprd13.prod.outlook.com (2603:10b6:806:33b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Mon, 19 Jun
 2023 14:12:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 14:12:21 +0000
Date: Mon, 19 Jun 2023 16:12:15 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
Cc: Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
	Linux Network Development Mailing List <netdev@vger.kernel.org>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Eyal Birger <eyal.birger@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Patrick Rohr <prohr@google.com>
Subject: Re: [PATCH net v2] revert "net: align SO_RCVMARK required privileges
 with SO_MARK"
Message-ID: <ZJBiP//34udiwXML@corigine.com>
References: <7915b31f96108bee8dd92a229df6823ebe9c55b0.camel@redhat.com>
 <20230618103130.51628-1-maze@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230618103130.51628-1-maze@google.com>
X-ClientProxiedBy: AM4PR07CA0002.eurprd07.prod.outlook.com
 (2603:10a6:205:1::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB6079:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c05a798-b07d-43bd-b87e-08db70cf32a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	24zSbd9PYILb0k6ofnEmq/cRr2nnISgimqUq6Gg9JAhSze2ESmPlj06ae2HwU/J8TwSd/3KzgBUoIFkowEodaee8vV9G7Zm3AEyiBWX924VfUrkfQ6xkhbI1lMWnhwuemKyVxionGpK7JRu0FN0M5fcrsQQn5H+kWaSv4WBfD5imgAvBUzP7QNK5TrpCYBIaLdLj0LvaCXWO0zyUYPHphcUjpEx4EORBnhfqH2J2VPfBdUBHDw5usu0DOvIBPF7MKfZ0ueHCe9a8FgMxfJeZxorPPGc1Su2U8ftCK+4oJEfNs9mIMshGapGGDVcSUKUCYiZnBoxU+JakDBcLhfWo2HKPI7lCM2rCl4pIYSobXDx4vsDz48dtxxde9pqgfP/Fubx9SXozGnCYLHRidPNItpzyXosywic77LJOIjMhB1dsuqFnVlQsof+XPa4fiajFe91adWJEcFne3KLW1d+m3VVMzCUxlNSg6YsqOGti0T9lRLhwSgZ4T2r82jsoTpPEdNjQJFDsUhDKcajXzJ0EuCyRvSP+laWn4YapSYZM2CsWk2Y8jvQD2TRYKetg0hUGj4YseTnnmN2qbNr7UqKIn5qNVqFe1HMTiXX9ytrI3SE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(346002)(39830400003)(376002)(451199021)(6512007)(6506007)(478600001)(36756003)(186003)(6666004)(6486002)(2906002)(316002)(8936002)(41300700001)(8676002)(44832011)(86362001)(5660300002)(38100700002)(54906003)(66574015)(83380400001)(66556008)(2616005)(66946007)(6916009)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1krYTNiNGtZRmhBdCtIQ2lpOVBFVyttNGxxNmU4b2paRHBZWU1qZFIvZDlh?=
 =?utf-8?B?UEtWODA5U3ZDOFNIVHIydnJuSTJ4bmlsSnRYRkYvNWJpcDA0SzJpb3NKWUxW?=
 =?utf-8?B?VmtVeUE2ZjNBZ1NNdERLa1ZUbWUzSTVaUzI4enYyUDNTRUZkTzhvbUdWM1hV?=
 =?utf-8?B?MkJJSWdOdkYrSy90Ni9qazRSbDFuRmJ1RGVRZWwvUG1SUThWUno3QUJIT2gr?=
 =?utf-8?B?SnVtbE9oUXBKcEJNanhib2pLWUZKS1FPZVAvRDE0bmNVNlBaN0xNeDB0V0Za?=
 =?utf-8?B?Z09JUThyQnVIbzFoUEdmeU83NldBenJJQ3NUUEF1b1NWRysvblVaZFRNSmJY?=
 =?utf-8?B?YjlGcjBZVHVkcDdyaXVBYTBzNGhKMnI3dWJjYnE2TEVSNklRYU8zQVRBSXpa?=
 =?utf-8?B?bzM0TUNhcjlybzc1ZTlRdXN0UFFUa0psOVMrTGU3MUFpVFZqWDE1cTNQTFZC?=
 =?utf-8?B?Ymw4T01RYU4rOGNyZTlLdVpMUEdWaUJQb0tURUhaR3FyVDk3OGlQVmFORDNt?=
 =?utf-8?B?TmpXalNhbG1kL01EQXFZSmY2dW1Hd1BqU09sb05CbFJjL01rZE43a3ltcjhr?=
 =?utf-8?B?eEUzbWRySUdpQ0ZkYmplY2Y4bzF0L2tSNU5kdDFoSXg1UHdxVUdmSUpVdElP?=
 =?utf-8?B?eEQrQW1PSXk2KzBFVnhWOWxDak9sWXM1SkxJb0M5VzdBZ3hGVzVYb0x4SnlP?=
 =?utf-8?B?bFdNdGtNbHU4dlQ5aUNweTlOVEdOemhlckJoYjdHdFpENzk0NUkxWnZjV09i?=
 =?utf-8?B?cHpUeVhtVFp2MXhuSlpPOFZXNnpYbTJtRFVIQkswdjJ2anhyWkE2UzRQMXlv?=
 =?utf-8?B?K0EwR3RwaDlnR2RsbVlmVFoxUEUzNDZjU0hPWWpzYkE4anJ0WTM3VTJIb3Rw?=
 =?utf-8?B?ZnV4UjZ1MmZWd1BCOUhZZW9Ta1FGTEhMOHJsYkRsdjZ6M1F2eFBxQmp0ODZT?=
 =?utf-8?B?SzBLUGhjci9kVkFlb3FIaXRXYVNSZzBjbjNVVmJFYU5wUEF4cFNQVjllVGVS?=
 =?utf-8?B?L3FQMmVpMEtHRUR0MUtZUVhVNDNFcG9YU0VCYW9jazQ5UmlxT0NYdEFQQkQ3?=
 =?utf-8?B?NFZ6TnlQKy9VV0RHWTZBTnhwOE1MbFFaL1p4bWpXS3BqOFEwdk5pbktGUmdI?=
 =?utf-8?B?ZitUVEx5V1JtZFRvVHZtRStkdXdyNUtsL2NpNGM4SGlueGFTL1RLTXYwbUpF?=
 =?utf-8?B?WllVTU9zL0lJSFV1TTd4Rkl5ZFk5MUJPM1hRM1A0UXFzdWhoeTYvMFoxYURy?=
 =?utf-8?B?K29YaGlDVnYxL1V0UHd6UDRLK3E0dklCQ0VDcFdvaGZZYUVNeUtmSDNCWmor?=
 =?utf-8?B?T2l0eUxaRnJPTUlEUm1yYWV0Qit2WjRrTEZkUG5MZUk5REhMWGpTNGY4L3lD?=
 =?utf-8?B?QVJ3cEpLYU9qZCtBZkdJMjBDN2pibkJkbmM3UkxOWXRBOU85TzFzSzhCNmZB?=
 =?utf-8?B?cGhac3c4UTFLK2RrVnN6b1AyUjJRNkYrTmZ1TUUrMS84NDl1Ymp2eFdoeldm?=
 =?utf-8?B?SWRjTGlhb2JYNkR2bVlFcDE0bEdqV1RLaHBwSzZpVmNwUkJiYXNWWll1UC9z?=
 =?utf-8?B?Q1pZc1BIZDZXYjI5OU9CZ2lhQnF5NEJ3YWRSSGJGNkhYQjZnQ2pzb0x2elBK?=
 =?utf-8?B?dE9EUWM2YzY4aHlCeFJxeXpGNVZWQ1hTREtQei9qdFQ0MXg1SmpGL0NXS1VO?=
 =?utf-8?B?Um9UVjJWUjlyZFZ3cjJicGZMTXlMWmpzcEZIL3UwTWh6SUppMHUvc1RIaW02?=
 =?utf-8?B?WmY3R25kazdZa2FyWVBtTzB2V0E0ZmtwTkxrZ2tnWUU5a3ZjVGgxQmVPZE91?=
 =?utf-8?B?WDhrQ3FwNW5GWGoxL3lWQ3dBYS9qeWljWnBLYlJHRVNkWElmek9hWmpOZjRS?=
 =?utf-8?B?RndPTjBUOHF2YjZrZlJaN2ZBMGxVNjhWSWRRbUg3clhkOUZ0U2FuU2NWaTN2?=
 =?utf-8?B?SzVNNEh4MXRyaTI3b0cvUisxS2d4T0JYU0NBLzlSWVZmS2ExMEVTMlpUN3pZ?=
 =?utf-8?B?M2lGWk9GSjUvUmRpejNZdnBIcmxuTU55K2thNHQ0MEdOTW92TVpKckVVZmV5?=
 =?utf-8?B?ZDZwc29kWW1HUkxQWXYyM2lVdnBGbnNqc3B4UkFZaDVzTFp1cktORzdiQkRi?=
 =?utf-8?B?L21uSGs2NkR3alo0K0NBa3daazlJRmVJUWxIT0VoVkdLZUhacUVsTlBUNmhP?=
 =?utf-8?B?MGMxbDhDY21jejlNZS9xQU5kVm01NCtiVXZOZ3g4UGlmOUhLNE9vekFWcnh3?=
 =?utf-8?B?RUJpOVJONTgrcGViM0czZlZJOFdRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c05a798-b07d-43bd-b87e-08db70cf32a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 14:12:21.4534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0EcWExeZqjKKDsJQuadIzSql6BoDRqpbZ8jz0dP6726wxkuWUucNnvd0ylM4ghCfneATcZ6h34AfepYzRg/cjX5j52c0b2odVuuTaIuYCNw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB6079
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 18, 2023 at 03:31:30AM -0700, Maciej Żenczykowski wrote:
> This reverts commit 1f86123b9749 ("net: align SO_RCVMARK required
> privileges with SO_MARK") because the reasoning in the commit message
> is not really correct:
>   SO_RCVMARK is used for 'reading' incoming skb mark (via cmsg), as such
>   it is more equivalent to 'getsockopt(SO_MARK)' which has no priv check
>   and retrieves the socket mark, rather than 'setsockopt(SO_MARK) which
>   sets the socket mark and does require privs.
> 
>   Additionally incoming skb->mark may already be visible if
>   sysctl_fwmark_reflect and/or sysctl_tcp_fwmark_accept are enabled.
> 
>   Furthermore, it is easier to block the getsockopt via bpf
>   (either cgroup setsockopt hook, or via syscall filters)
>   then to unblock it if it requires CAP_NET_RAW/ADMIN.
> 
> On Android the socket mark is (among other things) used to store
> the network identifier a socket is bound to.  Setting it is privileged,
> but retrieving it is not.  We'd like unprivileged userspace to be able
> to read the network id of incoming packets (where mark is set via
> iptables [to be moved to bpf])...
> 
> An alternative would be to add another sysctl to control whether
> setting SO_RCVMARK is privilged or not.
> (or even a MASK of which bits in the mark can be exposed)
> But this seems like over-engineering...
> 
> Note: This is a non-trivial revert, due to later merged commit e42c7beee71d
> ("bpf: net: Consider has_current_bpf_ctx() when testing capable() in sk_setsockopt()")
> which changed both 'ns_capable' into 'sockopt_ns_capable' calls.
> 
> Fixes: 1f86123b9749 ("net: align SO_RCVMARK required privileges with SO_MARK")
> Cc: Larysa Zaremba <larysa.zaremba@intel.com>
> Cc: Simon Horman <simon.horman@corigine.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Eyal Birger <eyal.birger@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Patrick Rohr <prohr@google.com>
> Signed-off-by: Maciej Żenczykowski <maze@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


