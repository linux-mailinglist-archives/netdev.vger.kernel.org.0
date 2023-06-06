Return-Path: <netdev+bounces-8497-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BEC9724505
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5C94280F72
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 720542D243;
	Tue,  6 Jun 2023 13:56:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6063A37B71
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:56:46 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2090.outbound.protection.outlook.com [40.107.94.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B4E8F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:56:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjsLgUyMripsiOR49zARQkf/15i+L1zb9p/9wugMzAJYKP1l7G0TqSm4uUh98U7zFNnStYbrcoWO95/mk0HNoQislPJdagNPUtuFEE6e0HV3u+KNNv0j81ht8wr27touqpGmdrFiDVrNUBk6m3HsOVFVgkXczbbi68VUgxa3JeqpKgCGlQbFGZKFZKp3p2O8mgpCgzJa/y7mZ2eoFJofglXSHrNia8wjRV3ztaO/Z/3nogOrdfrtgfA3aoMIkNZ1DEG8IWOXrJ/9tpBEGDoKs9M+5vkKW9jhDDPu2MNnngTsB4lyievTuJwU0aZBGPrRk7htnhQvusqYJraLeYPjag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwOPecwKK9g+ds/L8v/jtwM3SIhYNnSO3+uyDx9nS1k=;
 b=BOfdSNYrgiTTjTWTAXAMPEMBgSCKsvf37ZQiAYVFusnQtCKbiaQCfBUrAv1CNUruGKQ4FZxNRJXq3mv+expCwHccf8GRAg2I8P4K1YO/nyImG/2aP+DVGAFfF+TM0luWzqKYfRCppGr+tzQ/FzNFqR3amRwUFmkrtTJwxHbKHAlvHWJndTCQV3K3A7iRQw/8HmbGbNgzNY6XloN1RaLAkxX2N5FR+nZtuXJugb3eYaxg+cc+qrwXmQeFm2syGn5kU/4HR2OkBCray6HUappciePyBTNzqD61tEd3wD8FbVZJGy1bRe3RUDD3U5rB2qwWB4vXIuTpxPdFrPxNZ4VzBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwOPecwKK9g+ds/L8v/jtwM3SIhYNnSO3+uyDx9nS1k=;
 b=BtlYLTEOKHpF5xu8cYC3zETSSU/w9JqfMwRrJsMrxnR7GjRzdDZJNZsHdvD8etlZR2jq6gmtmWYA1UFk2BuhTTa77CX9h+2IFvUpMO7/lcuuyWEaYsHxdz68GXE3D8/yPKlkNinEIAjZKFj0OktfKgT8JVCi8dInmEuDCQ/8Qos=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4614.namprd13.prod.outlook.com (2603:10b6:408:12c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 13:56:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 13:56:40 +0000
Date: Tue, 6 Jun 2023 15:56:33 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Eric Dumazet <edumazet@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] tcp: Spelling s/curcuit/circuit/
Message-ID: <ZH87EZd9goHN2oPX@corigine.com>
References: <41454fc12506c2620d2dbc03e59a4ba28fd48f22.1686045877.git.geert+renesas@glider.be>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41454fc12506c2620d2dbc03e59a4ba28fd48f22.1686045877.git.geert+renesas@glider.be>
X-ClientProxiedBy: AS4P189CA0021.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4614:EE_
X-MS-Office365-Filtering-Correlation-Id: f0f7093b-f750-4074-3871-08db6695da1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RXm9ZdeNtNu/nrobUH7KbXl5+vHAEpl/6oWwPZKmerMaby3EIXtnFfIcBSrthTwF+WxUVaNtmgL34mniBdPqnJmblOMLrKG6Vtv9Qr5FEdE4f8k/e4ubx9ucWOrPpMSgX9bZ2qQVeaDr3LQ2Psyd0EggFVIdfHwknNCa3gI8Fc+u5TxIJrc8xicsWAmbMFijqLGqGN+TQ4ZSYZnOdbh7X6Vn8TkF2JhGGFrR5EsiXDaoKoA+8ZvDCxyZYxa02Wy9BxoSWkvMSW6kd2ePSj8qxYZ8o6PHTjQo4Sz7N5xavb9ZBd+LMw5+kcrKsFx0QGxbxFk+zAY+KSTS7FRXF15d75y/N7MlR1OxS5cLtBs1WQn9d1ZX8eV1TAJglKxw8BTDqhTQA1oMoCXOEhj6aM5GlcBcuM4nlv0eobJMJC+Mu4yCaBRk86ebWnen1AOEJpzn/U2T6N/FUtSpZuxj5u2V9pB3zekGyydnaFRXQK4iupwwO8cs0K0kEl02kjXzUTPSePX2+y5Hpw2pFz4oJE9zeTh1vUEEvWdjV9/Iipu7vyLq94P4qZJzbKTMZXRPJMiw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39840400004)(366004)(376002)(396003)(451199021)(54906003)(478600001)(8936002)(5660300002)(44832011)(8676002)(36756003)(86362001)(2906002)(4326008)(66476007)(66556008)(316002)(66946007)(6506007)(38100700002)(41300700001)(2616005)(6512007)(83380400001)(6486002)(186003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1foq6SWML6hfSBUUbNn5q41h3ddvFK0n0CvhNZvRlv7eErS2nkmAJ/BrUk6/?=
 =?us-ascii?Q?UsY1ko6WyQU+QmVnEubXMkl85Octtb1uR84aF1DzqGzbCOdo7A0KrTHK5v+p?=
 =?us-ascii?Q?unKrIJFGWuPgQbz4KQ8VR8z06pTh2+etnpvRGInrHYVPMQs5RE0sjHmBZ54n?=
 =?us-ascii?Q?vyWMJjIGJ0qsSFh4/7qheZv4JCGLErB0yN/cYuu81MZJi57yxeawxc3/1j2A?=
 =?us-ascii?Q?iybfLKGb9LC/u6o+2uIojH08mWNVf58TV9XHVsM6EDagrdKIG9YoyxZ/teai?=
 =?us-ascii?Q?MUm/ORGayX6p1jGR6BT3QndNmibCAjL8YVPKyXmWpnMHBa4S47MONKNA57SJ?=
 =?us-ascii?Q?KPY/QN+fIRGBXzMUc4STz2s2p5Q6U68bfJBb2AofJ34Th+gVsOtn1XjKjpiA?=
 =?us-ascii?Q?QYR2OgFGtrIua1Gobp6glAkZoInZDsdiqerQH7oawbKBWHDTNgYTTrWe3EEW?=
 =?us-ascii?Q?3K95eRaNKmHX4GLMAK2LYH3fP2rRbdi37OC0bHyBOLwd1uT5oy5PB3Vg0Sfk?=
 =?us-ascii?Q?bWpDzNRkX1yvBjMXQYsDsybkvikLW6BokGgZTeu8ESzXqZ+y/S84MiSpdbmy?=
 =?us-ascii?Q?PUGmUWWSbKeKSA8zY6wJuh257HGLhvIzsgkHZciz3RyHThiSvI0D9QXEm1f3?=
 =?us-ascii?Q?U8h4JbeciK35pLHB78eSnBYF4RCR4j+hDrQYJspp0ApcMQrD2SIJ7bTsQV8n?=
 =?us-ascii?Q?/LExAn5226enzzipisXS6HtiJhLln8GDq/+31flQCVxTHcx7IX+HQnmAVE5i?=
 =?us-ascii?Q?MCgir2lxmfyJ15XbxelAET9nYbJS4hRFiFRo0GAB6WlcDs2CmDoK3MEF7sUu?=
 =?us-ascii?Q?ACDwaQLEahlJLga72ByQeQW4yTlPX/tl3LMyXqxDsTVI590mr5Zh3EgNSzw6?=
 =?us-ascii?Q?91JK689OUBaifpfsLgwFN17O/tIKlszmNJzzSoiDgkdx0d1IFxGvX8ZSsqxb?=
 =?us-ascii?Q?hxrxFqMLPwloBDLotbgsDioUNFdBh/QaFpz1xOWHNdbUO1Tksq1Lxi2VU8aG?=
 =?us-ascii?Q?uZufMVtCgeBKn8Zs24rSeeTFCjCi3GhlugdE0Ql8JD/S3PxaxUSlRkfQCI45?=
 =?us-ascii?Q?aIkEekicJPkKjIjRBU6n2sB2TZG0jHhyN/Hndzl9APYBiAI6BBnzEqEW7s9J?=
 =?us-ascii?Q?w1R1K99Z42rwIsEgFWuMCQU5ZbymcAJ45zGSDORffk8odzdwLSN9ixT4dL3F?=
 =?us-ascii?Q?i7wI+SOiI9ij9t7nE9m5+1Y4Gv4jJ6ge6sXlhAfy0bkV0eMTSMcGIbpMaucG?=
 =?us-ascii?Q?eTIbtkh2hVYRNVYmxKaMUNb7tx+469dXQJXcUW2oZrutne0IzqKuHkEi1i7N?=
 =?us-ascii?Q?uM595A/MpTQUbMuHlvsILuvi2ieLvdFheYfGAJUipbBgNxySr2HWCWT6aDzL?=
 =?us-ascii?Q?aQ6TaB28WDxvfHzPboirz3D7eCdV/oEQbhtvl1YoG9XwuZItsg7lGkD6yPfw?=
 =?us-ascii?Q?srpZdieerepZdaVPuQG+luCTD3TDLUVlCc09XHAhm9y/GclIbiN0/DhtVScl?=
 =?us-ascii?Q?lBPdUcLVFEspS15MuZFps9cdCr5LDuEt+jF8pa0H6WBc77fgce2+8zwPJVGD?=
 =?us-ascii?Q?3ebxJeJH2/tOum+t1JGj0DfR6w25KI3XrHqzJmlOMeJ9YNuEQz/QRzUMs+am?=
 =?us-ascii?Q?nHp/xrIGwY1Tkp68pQZgbDZx5xE3PTYQBlzdezcBN1HEumz4Ly9zms8xKM0r?=
 =?us-ascii?Q?Tfo/Tg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0f7093b-f750-4074-3871-08db6695da1c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 13:56:40.0293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eS45B1vQYJNWoYhKI17mQPQbpayU8go0LsyAstO6PeNlckHvGV0NJsuKSxthEWJpRIy89PIS56haS7ifNq3crfNpKy+357H57J2uq3Wn9Y0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4614
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 12:04:57PM +0200, Geert Uytterhoeven wrote:
> Fix a misspelling of "circuit".
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  net/ipv4/tcp_input.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index bf8b22218dd46863..3403ed457baf781e 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -1131,7 +1131,7 @@ static void tcp_count_delivered(struct tcp_sock *tp, u32 delivered,
>   * L|R	1		- orig is lost, retransmit is in flight.
>   * S|R  1		- orig reached receiver, retrans is still in flight.
>   * (L|S|R is logically valid, it could occur when L|R is sacked,
> - *  but it is equivalent to plain S and code short-curcuits it to S.
> + *  but it is equivalent to plain S and code short-circuits it to S.
>   *  L|S is logically invalid, it would mean -1 packet in flight 8))
>   *
>   * These 6 states form finite state machine, controlled by the following events:

Hi Geert,

I have no strong feelings about this.
But I do notice that codespell flags a moderate number
of other spelling mistakes in this file. Perhaps they
could also be fixed at the same time as this one?

