Return-Path: <netdev+bounces-5604-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5849D7123D7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B4CF2814E0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CC80111BB;
	Fri, 26 May 2023 09:38:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1D010953
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:38:32 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2125.outbound.protection.outlook.com [40.107.92.125])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E2410D0;
	Fri, 26 May 2023 02:38:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=be/cBxAh0G7YI3qu243Z2p5r7vuwUwP/jJO1BN53jhpdj0TXhgVbKNMVEnGRc2Sqir0+B/tJ0oOQOt7R7f3T0yfz2l1gPLL6F0nwbxgI8bks9nxNo9SLj8iEwhuvSC+r+/corbvx7xMWZXstUnzu7HOXYs09jhX0ZwHUikvHRw1ZHirc0+URtRFO8W9Nrqf3UEXyTY8HIUw0IcLEOV2yoLp7U0irIRzBteiQpFor1UFBR2CLQKxKejeGHec/+x2tLClC6cw5Vsa6tVfOiMVvREu1K6/J8EBQrnvs5C9LLJx3K0SVkvvDYjvEjJiWI8EAyxQvRpOVuMn3TPjU0z8ZwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zdEEbLBnQAanxuurg4uXzFS0onDBKoeUcecHJU2RcSQ=;
 b=F6hJHPKJ7Qw/1cGvAcSWllheNGoIW3KVS1cEMu28cOQkj3XdOebDQviipC28RHWPRqMVk4Hf5yU6w8WvJikh7u5uKtO/EZubBLeEok7Bdw+9XswNM76IwGSlVIYNSB6NbHGYptGvpuvFw1HSZ7S/s7GMuewmNJEuPobELIskKm492RvRQXzSPbZh51mUhsQB7XTUzrTh6Cpdhutc5GUONAbytPMXDj1jLFN0lE+plVjvCONuQJyQpTstsrlpgOVLP4Wf/tV5r9qqZYJ5OJqszgQeN9p1DcTjkJhChFTqc4d+Afvi79hb5uzkIIIBYV+BtHTFiGl8ZCacMl9xi3u0IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zdEEbLBnQAanxuurg4uXzFS0onDBKoeUcecHJU2RcSQ=;
 b=g0K1ueUHU1NIeA1wT+ErgEJUnze/DmjtL31I+79WEunkievgPGPX7Psqkn3w0xHVkBZtX03PZxW0LjG6rgEWzwK6EEmMJGsPI3/XHadKiVahJ/RttN36xRsX0A27uInQ9EvQenNVHx48A4094ti4XntSB9kSQj7ggxe4DujfAvc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3708.namprd13.prod.outlook.com (2603:10b6:5:22b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Fri, 26 May
 2023 09:38:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 09:38:24 +0000
Date: Fri, 26 May 2023 11:38:16 +0200
From: Simon Horman <simon.horman@corigine.com>
To: David Howells <dhowells@redhat.com>
Cc: Kenny Ho <Kenny.Ho@amd.com>, David Laight <David.Laight@aculab.com>,
	Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Marc Dionne <marc.dionne@auristor.com>,
	Kenny Ho <y2kenny@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	"linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	alexander.deucher@amd.com
Subject: Re: [PATCH] Truncate UTS_RELEASE for rxrpc version
Message-ID: <ZHB+COAmd3CzVGaJ@corigine.com>
References: <20230525211346.718562-1-Kenny.Ho@amd.com>
 <223250.1685052554@warthog.procyon.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <223250.1685052554@warthog.procyon.org.uk>
X-ClientProxiedBy: AM9P193CA0012.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3708:EE_
X-MS-Office365-Filtering-Correlation-Id: 845e3bfa-340e-4aef-8549-08db5dccf352
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tZ97vpIJd+kD9Dyvd6l6D76559SvzRXEWBJmiKEoYq3wIn1sbSQ8/UNO3zuxMmsVcm5qzQzylcBbyiAWUHcyqdN85Ujkul1nXluvOQdiH0rK3oj5wQFC1Y9fyxBtKpFDN+RmjWpuI53wgvzVfULRWSHWsK4XKrIwdUA6Op7ZMg24mcjk0AEyVpynwxhQlFCc53s+0Tk652Xk7s81ZG0VKMvgV5rGMyGHapdjRuXNqBoy5/NrgJD9/3O6q3tmo6JvVgSeRc6CrOLeBVKC9uq7tIfxTvPy87LPEdMLsBct7kVBajZI4owQLbwVnNqiNRBt5r6xjre6dZS9I4Gy0RkvHrZZP0nrS4EIzNZ8kaSZBKHUqCrf+g+G+OqGwgNtQs8Jp7j/kc5SXZ1t9x5pxdjRtECiswCVK9fgchFVuFohq6oyWet/T1yMhKa8vgJVpYmXzOGM/SC/Xmo5i/y6LnHTg+Cy2ITJ4w/tGK80YsNF4SjMKXgaVidm5+n+TDfx5TH4bSoUF6Sbjp46g5RbIjLQSpvNnQwgbqTBQXsGw2E7FNDHs1sief88p/R0VkAClh0JUTK+JfSzH0dx8tHLa86U+5imU6pybajYjePOMx3ibdA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(346002)(396003)(366004)(136003)(451199021)(186003)(38100700002)(6506007)(7416002)(6512007)(2906002)(44832011)(2616005)(36756003)(83380400001)(66946007)(6666004)(478600001)(316002)(86362001)(66556008)(66476007)(6916009)(4326008)(41300700001)(54906003)(6486002)(8936002)(8676002)(966005)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7NrP5p18s+GVvlM+Uo31A5RgtXAAlLbaJ0B+8YHEnFt0TdRHRzbFV0ph8PBW?=
 =?us-ascii?Q?RcInzIfEA8WkWBCkD17P/Kz2Qtf7Hzgk1QKO9QIJ1Q444W82zjm7r/4UnVtF?=
 =?us-ascii?Q?kRF74yFk9LCdj0X6I5Zbx4qICCEFbJg3aofcgWCykToAq7CgJgUdyZ9/M9IO?=
 =?us-ascii?Q?Cnz326xMZ9lzdyxTPeaNvh4fYJsi++SOH+yjSXXLCGaTkmARDYKT4eMFIAMl?=
 =?us-ascii?Q?ewzWdK2UtjEdcU/m4410FNdhqMd9UB0bsxMXwRMC9t8sGcZt2E/U23EHldag?=
 =?us-ascii?Q?8E6vBn31S1ouZGGwHQyXyPnxV6CHh46xVs6qeJNE6vi8Nt23do0BspnuKnoD?=
 =?us-ascii?Q?AkWk2GiaAtExPp9LFp487kIf/ro8EspiusXKIxutvPGNH0Pr4MdWbOgnsdd/?=
 =?us-ascii?Q?+e97XwQzfYxAoB49iHX4Om0tqQ/W8hexpYOIWTLQjByJ4vzQfoXUrK5Mxf7z?=
 =?us-ascii?Q?KgFuHQQKGqGpoBMP/ES94Zw0zGSMvDEYjtEASswLHuY/FbEliJgdaYBYPQaj?=
 =?us-ascii?Q?EqtUodRxG0aRhSL51Cl4yy9zJiLVikhYQbVZIdjvfFVBhsiJBXK20xql292x?=
 =?us-ascii?Q?jctSV4ILOqx4100Ts5BGGvIG2L2+xIEyzYiO1U5e7ONYLZgjzTxFpdnqEv+i?=
 =?us-ascii?Q?dBUJY5v7WG9BTRpncQrxWbo8fo/4KNzy6VxqobEgRgUx+4aNhRTV6jtGktgZ?=
 =?us-ascii?Q?tdUmwFUSUqnkwT9qcbcbo6io+Xne7ugereGf2ReJ8pu5precLfUMEq6K3rBU?=
 =?us-ascii?Q?4v2eBnitJQNnpA9wghl/apzJAbj+/o1qY+GZd+k0gA8ODilznx3Saxu5Wqnd?=
 =?us-ascii?Q?53QC8OnjmYkP39enL+k2lQeLUYOk2zoOylXUuXHirmDCqOMlBHGcP2amG2xb?=
 =?us-ascii?Q?+Ftt6SBZUOnPnzeWZSnAkma0TfHPRTao3w3yaH8irAD1eWXfeM6HIL4ehV54?=
 =?us-ascii?Q?+bk+2xyhvrnPpqtZPCDk2CDVeYl31ma1MPk7+7uctj2TV/dgtoQt/HoMOzo4?=
 =?us-ascii?Q?5eJHfHHZCTd+lsG3h1gtCvJzLusDHFAGef1LRIICSCBdqdfbTKzasni+GJ+b?=
 =?us-ascii?Q?BexwCzrNixAw448n2VZIAi09Vm4ljzXdahUbC+TnChkNKNoeGK8Bt6JoPPKv?=
 =?us-ascii?Q?B79CRPgAGuxKeAI1IBhRnTUJjDt3miajOjPTaKdD8q85FEvP9IJxCO6TdDnE?=
 =?us-ascii?Q?OlYuqIEZz/Vf1kQEjPICfzC65T0mI6HL3HmuuwIU/WspmUmLVLRziNF2tpt/?=
 =?us-ascii?Q?OgIV7U37Zjq9gZtO0tQwhnv8EaYEy+6MNaAPS+UOJRaEMo01cxTXWSX9pJqq?=
 =?us-ascii?Q?HeOKKxOagUU9lr5JvETI8Kv+gCvEqLRvUjVVmCImyrV0JEtSNNX0hB0Yhj0Q?=
 =?us-ascii?Q?5Wa8J1jA02rAxPIIOvQto1tz28+L6/POSDdzFDM5R8EQoCiWEW8X9uxMA9db?=
 =?us-ascii?Q?8Ss7bgc/evZVhYxLz0jo8szRF8zcpEfe3Px3Qj2PQtAlcKIYGK7G6RWwH/7L?=
 =?us-ascii?Q?hgFL6jqu8PQ6yU+5fGqpH7wL2EHa/EIYh52rpfCcNi1C3r06bqanS90vBqSR?=
 =?us-ascii?Q?RMdBRKvQcIt/8a1ZuIFP2QZxA8eQH2kh9pig1UTXG4yF+Eh7jlvt/WnELovM?=
 =?us-ascii?Q?gF7vDhFniR44u0Y+RNvPg5usa0q61nfph1wa9bOme+/DuR74ugTmddPnlfzg?=
 =?us-ascii?Q?zRaN6w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 845e3bfa-340e-4aef-8549-08db5dccf352
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 09:38:24.1205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5fsu9Q/5Y3sphXHTRzZPVlSjR52Lsqb+JR4uGoCb7KgHmeLZIe9VfNDOfEbyV75L+I6vI0zInas2ApoZ/fsPSSSf/gWZTccKTJc3l0r/8nw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3708
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 11:09:14PM +0100, David Howells wrote:
> Kenny Ho <Kenny.Ho@amd.com> wrote:
> 
> > @@ -30,6 +28,7 @@ static void rxrpc_send_version_request(struct rxrpc_local *local,
> >  	struct sockaddr_rxrpc srx;
> >  	struct msghdr msg;
> >  	struct kvec iov[2];
> > +	static char rxrpc_version_string[65];
> >  	size_t len;
> >  	int ret;
> >  
> 
> That's not thread-safe.  If you have multiple endpoints each one of them could
> be overwriting the string at the same time.  We can't guarantee that one
> wouldn't corrupt the other.
> 
> There's also no need to reprint it every time; just once during module init
> will do.  How about the attached patch instead?
> 
> David

Thanks David ad Kenny,

can we arrange for a formal posting of the patch below?
I suspect it will languish otherwise.

> ---
> rxrpc: Truncate UTS_RELEASE for rxrpc version
> 
> UTS_RELEASE has a maximum length of 64 which can cause rxrpc_version to
> exceed the 65 byte message limit.
> 
> Per the rx spec[1]: "If a server receives a packet with a type value of 13,
> and the client-initiated flag set, it should respond with a 65-byte payload
> containing a string that identifies the version of AFS software it is
> running."
> 
> The current implementation causes a compile error when WERROR is turned on
> and/or UTS_RELEASE exceeds the length of 49 (making the version string more
> than 64 characters).
> 
> Fix this by generating the string during module initialisation and limiting
> the UTS_RELEASE segment of the string does not exceed 49 chars.  We need to
> make sure that the 64 bytes includes "linux-" at the front and " AF_RXRPC" at
> the back as this may be used in pattern matching.
> 
> Fixes: 44ba06987c0b ("RxRPC: Handle VERSION Rx protocol packets")
> Reported-by: Kenny Ho <Kenny.Ho@amd.com>
> Link: https://lore.kernel.org/r/20230523223944.691076-1-Kenny.Ho@amd.com/
> Signed-off-by: David Howells <dhowells@redhat.com>
> Link: https://web.mit.edu/kolya/afs/rx/rx-spec [1]
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: Andrew Lunn <andrew@lunn.ch>
> cc: David Laight <David.Laight@ACULAB.COM>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: linux-afs@lists.infradead.org
> cc: netdev@vger.kernel.org
> ---
>  net/rxrpc/af_rxrpc.c    |    1 +
>  net/rxrpc/ar-internal.h |    1 +
>  net/rxrpc/local_event.c |   11 ++++++++++-
>  3 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
> index 31f738d65f1c..da0b3b5157d5 100644
> --- a/net/rxrpc/af_rxrpc.c
> +++ b/net/rxrpc/af_rxrpc.c
> @@ -980,6 +980,7 @@ static int __init af_rxrpc_init(void)
>  	BUILD_BUG_ON(sizeof(struct rxrpc_skb_priv) > sizeof_field(struct sk_buff, cb));
>  
>  	ret = -ENOMEM;
> +	rxrpc_gen_version_string();
>  	rxrpc_call_jar = kmem_cache_create(
>  		"rxrpc_call_jar", sizeof(struct rxrpc_call), 0,
>  		SLAB_HWCACHE_ALIGN, NULL);
> diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
> index 5d44dc08f66d..e8e14c6f904d 100644
> --- a/net/rxrpc/ar-internal.h
> +++ b/net/rxrpc/ar-internal.h
> @@ -1068,6 +1068,7 @@ int rxrpc_get_server_data_key(struct rxrpc_connection *, const void *, time64_t,
>  /*
>   * local_event.c
>   */
> +void rxrpc_gen_version_string(void);
>  void rxrpc_send_version_request(struct rxrpc_local *local,
>  				struct rxrpc_host_header *hdr,
>  				struct sk_buff *skb);
> diff --git a/net/rxrpc/local_event.c b/net/rxrpc/local_event.c
> index 5e69ea6b233d..993c69f97488 100644
> --- a/net/rxrpc/local_event.c
> +++ b/net/rxrpc/local_event.c
> @@ -16,7 +16,16 @@
>  #include <generated/utsrelease.h>
>  #include "ar-internal.h"
>  
> -static const char rxrpc_version_string[65] = "linux-" UTS_RELEASE " AF_RXRPC";
> +static char rxrpc_version_string[65]; // "linux-" UTS_RELEASE " AF_RXRPC";
> +
> +/*
> + * Generate the VERSION packet string.
> + */
> +void rxrpc_gen_version_string(void)
> +{
> +	snprintf(rxrpc_version_string, sizeof(rxrpc_version_string),
> +		 "linux-%.49s AF_RXRPC", UTS_RELEASE);
> +}
>  
>  /*
>   * Reply to a version request
> 
> 

