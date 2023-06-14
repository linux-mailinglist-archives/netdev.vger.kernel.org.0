Return-Path: <netdev+bounces-10661-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E90BA72F9EA
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C823D1C20CA7
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A889E612F;
	Wed, 14 Jun 2023 10:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E03539F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:00:26 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2116.outbound.protection.outlook.com [40.107.21.116])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCABAC
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:00:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=js+m/t9Gh6FQcbAyv8o5EK7ZxDA/wmNwhwqS0o7h6LMFuuOOY4goIoCspV5UqURn7aYeC5ox1/9pXyFgXCdzQeXB/O+vWDwl31twksDx4P43PMjn1aAiRPLdWj7RKzT721M/A+oUGcY4BYy4upOspPa578Z07qbQ/R0V0M5SV/NyLQGc6LMGpRBDXBuZODefUMpTWsciu98z2b+QiqaqCjP9+PTjDYYNAFg91wxZLoUirkdeTJ53QSviWFfGknz6RedBZOmJaIytzhnyLDq6ER/AUavumo+lJFOntmC1Y4Txw9bw1AOiJ1VgFwc4mleRD6mbLjs8n+wpCaTyNnxOyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2y5EuBeTHx40oRme0Asv/8kapvKMZZQ9cj0s2lujvKY=;
 b=Mxe4bMCFPk1POdHzVUCMTMbLXUTh0END13W3/stZ8RLNaRk8PvMqekDkYjehPQqdT0nEySW7sdpHfS5ZliUmOKOqK72KS4omP+BrZCjVbAfLm9/jpppN3sKSXIoYKGT+ekQeMuVoH8gjQiNOX5ZFbQqaGYrMcHcUGZZmmsAU32yAaxHrqQdGB9hS4IHRnmNkMM0fYINk/4TPTm7aDtGS4UXXAxynAgI6/iyo4P07RcdWoNFBnUszY3WYHd+XvBlGgNMkIPjV5mZ8Rh/OliwpsRjhFUf8zSORlISVSwlf+rxZhZ4T2hi8jR0BrQemuhgKCnaj4ZKKuLXUjncuhv0a1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2y5EuBeTHx40oRme0Asv/8kapvKMZZQ9cj0s2lujvKY=;
 b=xCaYLC9Pw/1rpathwpOjHAMlPwGJfvDpVrtYh1GpUtjp/vK+sDghPNNOQbLcuRlkP4vjrfooNwJdMgcyigmGjz8T5TNLE0dO1OHz8QIeVRKDhEWhLjCD/i2cAOehY2MZzLGHMi6T01/C0aONbuKrpw+BIqC9fXV9MDYo1jR//zA=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by PA4PR05MB9658.eurprd05.prod.outlook.com (2603:10a6:102:260::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 14 Jun
 2023 10:00:20 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::e2bd:186:9dfe:1fc3]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::e2bd:186:9dfe:1fc3%6]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 10:00:20 +0000
From: Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To: Lin Ma <linma@zju.edu.cn>, "davem@davemloft.net" <davem@davemloft.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"tipc-discussion@lists.sourceforge.net"
	<tipc-discussion@lists.sourceforge.net>
Subject: RE: [PATCH v1] tipc: resize nlattr array to correct size
Thread-Topic: [PATCH v1] tipc: resize nlattr array to correct size
Thread-Index: AQHZnpZmSay5i65KEEOEHscxZzTZlq+KD6Ig
Date: Wed, 14 Jun 2023 10:00:20 +0000
Message-ID:
 <DB9PR05MB90781C45A3592E3962F6F3D8885AA@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20230614080013.1112884-1-linma@zju.edu.cn>
In-Reply-To: <20230614080013.1112884-1-linma@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR05MB9078:EE_|PA4PR05MB9658:EE_
x-ms-office365-filtering-correlation-id: 0e53cc51-957c-497f-4374-08db6cbe29aa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 zN/SG+Nb+j9wFctiQlPrNiPKNv9kJOpSyboJ7NWiAATROzAYUpKd1snvEzOieF306lL1etkRbrt0scjMBnEibzcR6+pwl+UU7pHOWonH21OhSjsOHT85RhU6h7BMmVQlNlxQ3WdWwDfFfazbH0iwjUtaOiy5I0drqF/h8qGCTr4SI/WYHfDul3I383EwIfrb8HsDwHHmJgkMvi3o1gHNRyseYDX1PtHHnFojd3viwRdNaRXhe7W4O8wYriPLmo0Q8zeqc6rOWNrvbp1uTG69x15rJ7B9Zlc9bYhbU2unhqrAbvtP0mgXdwygypzrkS3mRJRDaO7Dy6225K0f/e2n6pUAxmdqPE6zam7g+R0R+43j7B8+yfRQDZScI80xlz+q6o2lTYytvOmwvYpi6HXAoKe2B2IpqnmsJYXWXi5IIAvinzsjHLfo6dR8VQLTMHDvuNGYf+V5MrSQmJSBmfNYgyAKHl/3xMfeXwa1m8NYs+Zp+rLmuw1FG0BToVI9DfyI00gfr9y5huX22s7vR+vO8zY/R8MeUkntZkwdV8I1fKyfUqWDES6oPC6PFyluSqV16sBtveOewFa0sDAV3+UbG+CcGXFfgW5U6JYX4GCreNlVCRZXs1NcVwGlHfOImrJK
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39850400004)(346002)(136003)(376002)(451199021)(8936002)(52536014)(5660300002)(66946007)(66476007)(66446008)(76116006)(66556008)(64756008)(316002)(41300700001)(8676002)(110136005)(2906002)(71200400001)(478600001)(7696005)(9686003)(122000001)(55016003)(186003)(26005)(83380400001)(33656002)(6506007)(86362001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?2Nq/9eJu1TCHMbf9DdWfDNz3hL6gfaSDGc3LDiFJhva0GXaVwcTSCuCW8A/D?=
 =?us-ascii?Q?UaEUCUStpd5aCCthdshwXbOTd+ZICmfCzBYhR2gKJFWrKcJ7bhH3MaMNuFDr?=
 =?us-ascii?Q?gik745iY9BY8VFy/2FW69qkzw70NIgCrrN/MsbPSsDbW5CPgFV4TuYvGVYwV?=
 =?us-ascii?Q?dc4Q3m1OWh3wFvuf+0V01Ey7eZm39GB+4LZblwKSL56w+n7/pQEHlQaKTo3/?=
 =?us-ascii?Q?Bb9ECA40ksUq+vDc4wL4Ju6GXZJXWDIhFthpXwZ5UtPgfN/Q1xFdxG/Bz+GO?=
 =?us-ascii?Q?2j87FSIKNvQmt5ElvdyHe5z6c/ZKyyj1+Nj9vhDEoKjnwPXldavg1a9sReeg?=
 =?us-ascii?Q?Y7lyg6WusWWFYPtKZVRZTW65W82pAy/epronXc+xldJvK0Zhma94hzt2t4L2?=
 =?us-ascii?Q?snTIuUAvVbpksX3LjYJIhk7EJBOPePmxJKNyuekF2UvIE5NtR5P/hhhlV1KX?=
 =?us-ascii?Q?NcCStETQn1ZV5TQ33KLL2f4AoZc/spjRMjTCjas6mXwjQxgioV74shCrz1yW?=
 =?us-ascii?Q?5kDJYSycwWhYWKnecwZTWh4+KN8wnf/O/HT8GxtG0+imKt8qkGzW75EoN3Fa?=
 =?us-ascii?Q?X81+atf+sElYLWBiF13f7Wqep5zihtiMNr8T39ZdnKkcRSOUaIeduGZVZkPq?=
 =?us-ascii?Q?Xn6q/zhbKZV+lhbiKd2mDVhLcQwUxt958IMUUZgNzucKhZjEQmgtXjQ+w7rv?=
 =?us-ascii?Q?bpup7VFGwBkPIdkfM3ZgYl9k+fMFCeBiDl4y+kPzxN+drnB+jpXHE+73JOcT?=
 =?us-ascii?Q?RfjfWM5HCqEVHhlW1SSLsFuJwcr7PUYfu0f9jXhcnh2FpKijFVZ6TRKIFzKk?=
 =?us-ascii?Q?83/AasJaRjlJjvu4J2FtVG8GKe8xn6IJIzUQUifILLNFCoi6beYtFaclNjRb?=
 =?us-ascii?Q?wOdwGGnzsaBCj4GoNLsTNo12PFe+3ASb+OijtKuVXLTwDrzRVSVGsK2loqHK?=
 =?us-ascii?Q?5NGJGMGrJBf+PeXisStNEjTB7xMQGMWTXgSyGWODZVrpXp+LOo+IqU13T799?=
 =?us-ascii?Q?5P6/MlFrDrD2CnUa6zxyKM7C1fqP6enjeMp++d4InOTi5YvdjPYZhPU6Tut0?=
 =?us-ascii?Q?XEvLvaiZCYn9cyb/hE3QYUZhZyg273qmiu/iNCeRCEO/h9HAf4uMhf0hQdgg?=
 =?us-ascii?Q?Ieak+DBaLWtxZ6Al74w8HvkqsUg30GT1QCJNXUbL9qKebeR23h2dqw0/re6+?=
 =?us-ascii?Q?Zd07inULDncbJA9tPOiQbFR8Vp4BmH4phrlaSFwA/C7PUG7Fmeqmrc64ja7E?=
 =?us-ascii?Q?Lq5CWbDJHlZApB5LRnC8RNtSiXtvlUnuFyDMWpFsH5SKKXLKncJcPfBP6iRo?=
 =?us-ascii?Q?7Q13jyoqWtcs58YpKJdnAZwSFMg2IuF993sAS8GyakiuAUbB1hUGBmuHOdTl?=
 =?us-ascii?Q?maRLyTynchTNYzqLvttwati/kAfXcj8jfpd+NFc9eb+qgcPHvesb7KD+h2qE?=
 =?us-ascii?Q?v7Fqa7O85HsvoEXOglAKYevKnpp74IT0C4ppcyMEUBagNTGVXYLvo6OU5Gk8?=
 =?us-ascii?Q?FiB2ubCadiIHYaqgdZW9AbEjXUnrlK2q1LGQtolPypnco3IqMHxBV39bV10L?=
 =?us-ascii?Q?5O5JYzRLkdiv6W/RsNKstL9lUbENb6Z0PGLoVGlM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e53cc51-957c-497f-4374-08db6cbe29aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 10:00:20.1337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qqn76qRNLPy/HJ2S2xc/sSV8MAUAG2dmqXzIoab1zxPWkDXeEhtDjoG+uglYIRdt+R2jZtfjLwYed+A0b0ovvzz/vCv8wcnmmLnpljFMr8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR05MB9658
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>Subject: [PATCH v1] tipc: resize nlattr array to correct size
>
>According to nla_parse_nested_deprecated(), the tb[] is supposed to the
>destination array with maxtype+1 elements. In current
>tipc_nl_media_get() and __tipc_nl_media_set(), a larger array is used
>which is unnecessary. This patch resize them to a proper size.
>
>Signed-off-by: Lin Ma <linma@zju.edu.cn>
>---

Which branch (net or net-next) do you want to apply this change to ?

> net/tipc/bearer.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
>index 53881406e200..cdcd2731860b 100644
>--- a/net/tipc/bearer.c
>+++ b/net/tipc/bearer.c
>@@ -1258,7 +1258,7 @@ int tipc_nl_media_get(struct sk_buff *skb, struct ge=
nl_info *info)
> 	struct tipc_nl_msg msg;
> 	struct tipc_media *media;
> 	struct sk_buff *rep;
>-	struct nlattr *attrs[TIPC_NLA_BEARER_MAX + 1];
>+	struct nlattr *attrs[TIPC_NLA_MEDIA_MAX + 1];
>
> 	if (!info->attrs[TIPC_NLA_MEDIA])
> 		return -EINVAL;
>@@ -1307,7 +1307,7 @@ int __tipc_nl_media_set(struct sk_buff *skb, struct =
genl_info *info)
> 	int err;
> 	char *name;
> 	struct tipc_media *m;
>-	struct nlattr *attrs[TIPC_NLA_BEARER_MAX + 1];
>+	struct nlattr *attrs[TIPC_NLA_MEDIA_MAX + 1];
>
> 	if (!info->attrs[TIPC_NLA_MEDIA])
> 		return -EINVAL;
>--
>2.17.1
>


