Return-Path: <netdev+bounces-5890-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD8D271349A
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 14:00:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F41122817A9
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 12:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF808F9E2;
	Sat, 27 May 2023 12:00:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55C2F9DB
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 12:00:05 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A8D9C;
	Sat, 27 May 2023 05:00:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbholruBdVlE2Gu0NEwi4CKud9EEkF36rulcYg4NDOg52B8H7ciP6WcHqPNGam1ZvddVTuJHVYV8eMiNApqWhKSpfCd+OFeY+MaFmfE91O3ALVTD1SFqfp4gyggnUBxaUqauHefrajPmBMWWqBgINWnsdgJVOe3ISagDaK+J+6wqc1q6FH/x2NcQbC1fqmhKPnm19H+l2kLdDtJ9C71aVf4xgjRwW/c8lA8AXkfxr9uPl8T+MVNE4JwH4PDT1AkZhuJ3moJ/+28l2nE3NqG4S6ENOeA7vgu2Oknk6qkQGrOTHXrNfLwsp5bFN/p76EUwEQAPhv1TukhJIvpksaLrXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=maQqIPdSgN9Tu09uprFT7zmFxrkmYWUW+S1vRlvA/uM=;
 b=JrPCzvbI1LGFr9b4Wyzvy8rdEkPIJPOkxnFN32rCRtRQYV73R4QAuDh6A/Dtxkvtsh02Sv0Bpf1r+BBju/UH4TGjKfKj/79xU6ofMLmfqEMmFdQffwz6iuLWgu+86+AclHrF+rzAhbFfL9PnsbL963nAhwDGH2n8s7BrgB14CDTHNFGqRGcA2XqoZe6TBBFHJKnQzIie0suv4f2D2u2eZDaza+N7pnS8oYiknIK6XTpdsbGIMJ4AE5pofObrEFpedKusOqGvRabooN7gkKmV2JXqDaS4XiJgUw6xkd0EeKnht75V99wXM0Ae7x6QzqdJH9sjv4WnOjquBv9f7KniLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maQqIPdSgN9Tu09uprFT7zmFxrkmYWUW+S1vRlvA/uM=;
 b=OQ49p3ARuTwfjcNKe9ZuTAutH9XyrNWH7GsVJelYtRtZ5jIhIrKEXQbnVgbg7TkaqtbwvM0ArTmM2wJN1zo4v/8EHfXcyliScaLYviHV0Ljcu2I97xi/MsGlpvkLGE4lBlbWBNv/FqEassqwoJ96M6jdo97cKU80o1mcW5AaI0I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5008.namprd13.prod.outlook.com (2603:10b6:806:1ab::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.21; Sat, 27 May
 2023 11:59:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.018; Sat, 27 May 2023
 11:59:59 +0000
Date: Sat, 27 May 2023 13:59:51 +0200
From: Simon Horman <simon.horman@corigine.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Kenny Ho <Kenny.Ho@amd.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Andrew Lunn <andrew@lunn.ch>,
	David Laight <David.Laight@aculab.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Truncate UTS_RELEASE for rxrpc version
Message-ID: <ZHHwt5hnna64Vpn4@corigine.com>
References: <654974.1685100894@warthog.procyon.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <654974.1685100894@warthog.procyon.org.uk>
X-ClientProxiedBy: AS4P192CA0040.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5008:EE_
X-MS-Office365-Filtering-Correlation-Id: df13a201-0904-478b-3f92-08db5ea9e4ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nr4gKrf45fcrCsyYj1IHDeyESS9lpqFLqW+N1hvRpHUzMryrxI/EuPWEg6sRz2bLziCSLv2JoalWCyCSm+7G1BUDUh4sGFKWT7UUx80LktHiCRDzpcEoEdaog/Gr36Bd35CYB9p2Fkjesfv10ZQSkNX9g1rntdxocC63tcl23vFEpXo4j8G+0DKcbaiIcXOsN3ueKlUNCdhxgsqUh9Ozhspkyd8N+Z1UmhrLYpoxew7oXqTr/l6KzsfN4f1HhZ7jIIMHx2lIiCtdBpNfqM8I/HGJMexiFI5CzAPcT9eZCjiPsofoiVMj67JH2Xl0b9KtiSbmiNejQ5xngW2cp2w6r+LVi++8FCgbYBRJrLdLrMI5pawHsP/4jbU81CC/q7mZ/LDwSyPfT2qqXc40EzEcQDhS7pylYufT278hMHp9PyWIc12RBMmf82IREOEFmDAnjSmd2kHEAHHA0uA/kiQNiKa6+IXO+7+CoruTqK42br4/m4qwsB7MJwnsvrP6Ty6UHjWhtN859Fs5MIvA5uxXQAyGQ3Bf8IWAR8UqMpYx3l8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(396003)(39830400003)(376002)(451199021)(8676002)(8936002)(44832011)(83380400001)(5660300002)(7416002)(38100700002)(6916009)(4326008)(41300700001)(2616005)(316002)(2906002)(6486002)(66476007)(54906003)(6666004)(966005)(86362001)(186003)(36756003)(478600001)(66946007)(66556008)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3oN1Upr2b0C4oMqaUbiFfAv4u44+kbStdx2u3id9hPXiZN+QV1YNTbwRZAP6?=
 =?us-ascii?Q?vu2aTBOw3/MeIFcbQxLQDMiQjp5SGasgiBnLvnWpnK8YgJDSlyhSxqOi42qQ?=
 =?us-ascii?Q?yBI3v5DXXTNrXkJzOlVgxcrvSX5u3DIYMFN7IxFSaXmJISbJeSIulZgQuS5j?=
 =?us-ascii?Q?Ne5kuJJ7f+1VNXgnHsTqjPF+3K6cxl+WMVBH+LAJ7wgeLPT3uOJ9qib6YNxY?=
 =?us-ascii?Q?u21ZptXb1nV5BLOHMnV5rtRu7XzAhdmVXOJs3nRm/pRWEVBLei4dCed5l1La?=
 =?us-ascii?Q?OgAX1WOwuWzlcu5QRiDx522rlcNZUbaCbwRuUhilfC1JR+RFir95AGAjWqns?=
 =?us-ascii?Q?wpjrMQeZqRWVTm4zzrHvlIRp4Oh5aRJzQkTajR6ZCocvIxHVUkF6LJJeMww6?=
 =?us-ascii?Q?OHs8cPd5cd3RsrEjV6RQqEs98srHTYfRhpKMAxk9nHSgUeTC2zewRMsbXo+F?=
 =?us-ascii?Q?4ixdN9Sk+CTg+dSUYLiF7lJA3k47DYO+uxkPMu0FsBktW/tpg0i1ttt24c0v?=
 =?us-ascii?Q?sorh8OfisAJ09LRKTiypI8t2g36vyNfTx96X9NqYYW8/FHUTjDAhHzy5RUqv?=
 =?us-ascii?Q?UWpC8C8egEEfXywiEOtSWTsqV8CZazaw18vKm/XDE+3bWvkBY3VOshLmEtbW?=
 =?us-ascii?Q?6++Idf1wwsMRv6w84tPNh7gCKXzoUsVVR/5FYJ4Un03yMENs3RKo3ToIxTz3?=
 =?us-ascii?Q?8O23xmmWu6NvweUqV3OEgmu9iAz0VqFCAU5nRr4C9iWlWLXpK3D5dJfsk+jf?=
 =?us-ascii?Q?dWALR4AA2aUPiEmHzH4harFSznhpmEcQnEpZsST23GfrsaKI+FgvKORezjm+?=
 =?us-ascii?Q?3ufPlL/o3uWquNaysI6P2Y539pWS6PtaEg+l/ywlSwAtB2YFnIpwYnFU6xFF?=
 =?us-ascii?Q?kT6oxizdvJHZWgs6+bbcH8qvcyL4fseq9j4mxq+ueU5vM9bcvKuXFnLNE+4d?=
 =?us-ascii?Q?joZKujnF0swFPBiSDJPGLUJUAbgM3vhtPwAZGKL/3qA9PDjFp1bbVEbDztwH?=
 =?us-ascii?Q?Y2YRpe9ye/Ym2Tp4+agc8XEFO9ilOCOy78X9myj64+8PfBkkkbdXZ5Hs6S4Y?=
 =?us-ascii?Q?zORWdD9IJA3cn95VZxW5SU3AyDU598SeKS3zNzVk34wM+e/mElcQp28l58Dp?=
 =?us-ascii?Q?759YyBzNUo72xtYzyAeJt/Edd+gds70yobGfS9lVorWMq7VGgsuI6TlbiR0q?=
 =?us-ascii?Q?N4CDNFiqKzabqH2e9IQcQkFOLm58EUBFvBHrCcWGndyQHpy1PudR18813byP?=
 =?us-ascii?Q?VWHavmeZ/f6EFAB1WQF7e4VU3BY6ZcBbWwj9aCtKPXX+kU+tJshTMGsVWxjE?=
 =?us-ascii?Q?Zqv6gMgibKvciSweMKbY7fU4olKaRUf/LH3xtJ/pZj7bB4l/Wn+hL2WyhqBV?=
 =?us-ascii?Q?4pLx5vN2l5Cdf4gsIogK3vNVNnD1rzs1G+BzLZEMDMS0Qdld7+tPoQfmrI8V?=
 =?us-ascii?Q?wNixz4ecGHCzoNRcUjY0M5I2ig2jDiMtcisVQVqldyUmMgY9MCrRvQUDs+Tv?=
 =?us-ascii?Q?r6qEcLu7Sf1nhR0x/kZZjPu6xqBUZWQ4yQBxikhSeXc7k4MDK1Hw7PWiVfCm?=
 =?us-ascii?Q?96tyYBrwa8xtiW/dMXtg9Lx280c48szIPHF8jFUS05pWMEH5dTQyonACIqVb?=
 =?us-ascii?Q?Q9VPCs8IuzmpkI7aSTGxVNS3Q6tr9dH0QX1skhEvy6OAcCY4DnojeJ1LYSXu?=
 =?us-ascii?Q?c0Xbdw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df13a201-0904-478b-3f92-08db5ea9e4ec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2023 11:59:58.9723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VHzpMLspaKsiU0GyTxUwPxkFfH1cGr2L2qVcuHBPzxKZcWH4+RgAEdDE1HaTyNB+FJudjA76Ul5NA393rI3b/q5SFVLSW86aKjzDLA7EgDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5008
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 12:34:54PM +0100, David Howells wrote:
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
> make sure that the 64 bytes includes "linux-" at the front and " AF_RXRPC"
> at the back as this may be used in pattern matching.
> 
> Fixes: 44ba06987c0b ("RxRPC: Handle VERSION Rx protocol packets")
> Reported-by: Kenny Ho <Kenny.Ho@amd.com>
> Link: https://lore.kernel.org/r/20230523223944.691076-1-Kenny.Ho@amd.com/
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: Kenny Ho <Kenny.Ho@amd.com>
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: Andrew Lunn <andrew@lunn.ch>
> cc: David Laight <David.Laight@ACULAB.COM>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: linux-afs@lists.infradead.org
> cc: netdev@vger.kernel.org
> Link: https://web.mit.edu/kolya/afs/rx/rx-spec [1]

Reviewed-by: Simon Horman <simon.horman@corigine.com>


