Return-Path: <netdev+bounces-10961-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6418A730D51
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:45:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE62C281658
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 02:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CAB0387;
	Thu, 15 Jun 2023 02:44:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CF036A
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 02:44:57 +0000 (UTC)
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2118.outbound.protection.outlook.com [40.107.22.118])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A292126
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 19:44:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkqoGiFXM+Iq8GcfNbjSTXtGGi04hrM82ft4GKkDAdsa0LxKhpsYILUdCfBQJRgYW9m5OYMDOojMyI3ivh2mx+9ujmQE0IouXmQFDwMn8/39N4dW5Hhbn94TxucsSQr4jC/AbFPu7h7prxss4hhCePqDDuFX8b0qkTouIEB+Q1qy1Ni9BotdctFYjTIQcGTlb3Q4KiNZUcAik5hWYFid1X+cTgSvdjauvRaz+Nnbfq0Wq1llovtrZR0+Nwd8rwgUQ/QX9/b0Gx5rgdotTIT/lFOXvAQDA4/tMh08wRl/UbldztEUU1Mh9OdSHaeCy5Y5RoZxEbZcA6/cBDR3ZHXYzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cb/s6omw1J2Z+zxEcT3sU83SyqTR6uatSd3kJc8S7gA=;
 b=idOxn97SMUJ4elNVvQ+biWB4Rx1i7rsMO1iwWk9LIJnWTdkqA1NztMB8kdjG6zj+cNPzAszGDKgNGaQQTFWJ9sNuY3PshceuPd+500pr6w2uknODQWGcWENFX0v8Ucqhu5c3CRQi/c0PJBjitg71zf86zWLpFQotjCcIcmvFXC5fGYYin0l/383SbRuQiOk2I9YrcAQSXR/ckRmLOzeDZhA6FeHk0faRi7qkXfxXzuF1JA4+xAZwoD7piyjSktLN1qhiV9M5DWHaVtI1k6iyweEQxs5itOKHL9q5t1qKVwvFurA7er6hSDCHQ/5aTj2gmbFPiFp5hXTfrreanFvo9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cb/s6omw1J2Z+zxEcT3sU83SyqTR6uatSd3kJc8S7gA=;
 b=jLQPh+8OM10SnojfwRK6MHwM0SbCrn3kHNGyMjaXgzAPvewh74tzScu6dXgZgcgc3Gq+ZTGj45yVSnylg/D6lGQpGvT94ziIPa2qCwcBD2843qgI7wDVbPnhy+HcVl+uDZTAzcB2EHryxlnA/eiGzRNY8uru6aJ6OL14v2ZiBo0=
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by DB9PR05MB9527.eurprd05.prod.outlook.com (2603:10a6:10:302::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Thu, 15 Jun
 2023 02:44:53 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::e2bd:186:9dfe:1fc3]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::e2bd:186:9dfe:1fc3%6]) with mapi id 15.20.6477.028; Thu, 15 Jun 2023
 02:44:53 +0000
From: Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
To: Lin Ma <linma@zju.edu.cn>, "davem@davemloft.net" <davem@davemloft.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"tipc-discussion@lists.sourceforge.net"
	<tipc-discussion@lists.sourceforge.net>
Subject: RE: [PATCH v2] net: tipc: resize nlattr array to correct size
Thread-Topic: [PATCH v2] net: tipc: resize nlattr array to correct size
Thread-Index: AQHZnrihqTx3xwhrjUuJ19cSrbR1Cq+LKQwA
Date: Thu, 15 Jun 2023 02:44:53 +0000
Message-ID:
 <DB9PR05MB9078F5A7B924458AD75B1925885BA@DB9PR05MB9078.eurprd05.prod.outlook.com>
References: <20230614120604.1196377-1-linma@zju.edu.cn>
In-Reply-To: <20230614120604.1196377-1-linma@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR05MB9078:EE_|DB9PR05MB9527:EE_
x-ms-office365-filtering-correlation-id: 0c33c331-80d3-4d3c-fb74-08db6d4a7f50
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Flk749+tdad+MNiTk3xHaQSvswMF6BxZ6N93MqrIcduFHXa77wJrlPwyGOtNuEhOBiHLRXNa9Gn2HrmlowY1sPLvWtABMjYoXCqDWTechjxRh0+Qd0sMlxy4mGrF7I0x5LrqsXl0MEGASvKVmu5w1/zGtp/VQhSrqyQy/gDgbYxXlACi71al4UnMJgCVkurYNtgW/u7rwDwCPTD8zYbwobxqnqI6Smguyz+JxjGRLjBYgHRcafoBnKCK9Fi2vVEzRsVcJsm9600ppD9VW4mMclmBwy6oeFjI1zDTAZjxAcOlzn60CeXZE4bfJ+tLj40vLt+u8B4dsT07cVldsR5BJu+vqzvijk0K7UpL9ozEqbNQ0w1W8HahDwf9QuMicXJUAMfnrxaDZz6qdbdtjX/4ll8wgzwfRz7O9wOnZ69lNt9J/WXCUbx4PelsjOzMGrHaDUnxK4INTMZKRPRzfh9Vlm4BPJrtnKU9MAmIYr2swGHk2J9zZDDQH2TCcM5YVIZGQv9RWP8tiab83rAsW9CSZA3hTyB8kPasZQJgw1jDUoHnUXcK++7JOdaONXEBFKHUsffyd5mxOmqVMSQOJsU+eBuZ9p4rRHghbprz9x3lfrrKCa+GuSI6ztLc9ImIxBfI
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(346002)(396003)(39840400004)(451199021)(66556008)(66446008)(66946007)(64756008)(316002)(76116006)(71200400001)(110136005)(66476007)(478600001)(38070700005)(33656002)(86362001)(186003)(83380400001)(9686003)(26005)(6506007)(8676002)(2906002)(8936002)(5660300002)(52536014)(41300700001)(7696005)(55016003)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?YYjxtjhSYJyuVfdp44xOOAyhp2I6DmKEnvaeA7RqnYB4zXh4KHl3cTZznEcU?=
 =?us-ascii?Q?SV0oxq7U3ZNzxTzsV0ERDk7yXvTAz4nDY3+byxoExZZNOshEg25pynfn67aA?=
 =?us-ascii?Q?lqiWQ/UAmvlbTN9A3PNqIjw5DLC/DAcbpY9KmQAUKDqwewmxSEN1JyQItd09?=
 =?us-ascii?Q?X7kM6ch/qlWx7hu9xChZHzNPoSh+O6U2FM8rYjCq0mns4d/lCWrP934UZ7FV?=
 =?us-ascii?Q?LVcwcgRBPmNdCH7iNT6sUmHnHNz0il4E++4+QZVWCVhVM3Cp87+P6Kcifr7G?=
 =?us-ascii?Q?18DHVrNcv5EDVEChcKB/8NWWMoI0UjMVGOpOA4xn7STF45V5xAC1yOHaLX6g?=
 =?us-ascii?Q?APOwGcjy/5t4gAPNYNYqPHEXuHSERBKjhSx911Nqn2AmYQoTZ1bQDXZQ4BA1?=
 =?us-ascii?Q?4mTBjArRV18NYDrB42rH7EypROdomM9j3gnWCLp+yBDEcHg+6WYHTUSKF58s?=
 =?us-ascii?Q?MU2chhZ4XaVtqdvvyStsqQwM/R74qo8eA4NnPRSltM2NkAzcxn0GHmzfPec6?=
 =?us-ascii?Q?BaIRaouQOKKfkYeYRds4JCVxU/H6va3AADZPiViicgJ0jW6Bw1iU70f7jJtl?=
 =?us-ascii?Q?4/3XOtrPVLvOPy8fNiGXVzInY57ZXL6MQKuGnxDSPFsiwHHZHsxLwYSy5tVa?=
 =?us-ascii?Q?dm0jo9r5mKghAdRUak0QWVHgeRXTW3iBKgKvhJlK1wc5UiOc0a86hi64XpvV?=
 =?us-ascii?Q?UoqyxQlLuMUC2aDAmh5N11L6RdH/QwvQ5J9tlAVvcTjgdzYPcRyP0bbqz+tK?=
 =?us-ascii?Q?FcIheQd2qGW1PifylY0BGs97UIEKMedH48PddFfJrXfFcU5K1ophkuIaKH6M?=
 =?us-ascii?Q?sp7e9BKQiPPE8otRQA+mDpuRTfJALdC9N3ESxuKpOjNUlN8u/NCHzRSolMQV?=
 =?us-ascii?Q?Jt+SkbCoCt4f81uiLOVzJP1i9v+PrSrxU07I52GidLGPsEWlBoPXA5jB+znx?=
 =?us-ascii?Q?cKXVxQLTQ+9dKOHCBxklCcCJ4zWLD4cJ+8U+/wDI8dS5rfrg7h3f0ycAz3/T?=
 =?us-ascii?Q?ZdLSnfw1zT26U3HgjH7qd3AJldtm+GqKqMCGae0KKNtaardQPTCG6StGMBwa?=
 =?us-ascii?Q?iHujD5UyCDE5u7dRmZCNV8s/+fySxaYVuzyzjbB6xfpkUV2CVyjEnXnyazXD?=
 =?us-ascii?Q?7mE1T8J75tfOMR9iDX2Y8UMR8VkLmG27S+Z+hTg+khxD48mdcUGw1/6PlxR3?=
 =?us-ascii?Q?JD5s28Y8flo7yczQ2+vpiQCvNjU59KRZQ/sRP5htrC5aRIeb5G9mOmJLRSIH?=
 =?us-ascii?Q?+xugwNY00SeP1cjswoLXH7/Xqv59tRPPRjHxJoIGBOCwH6NTkyVa3e05Xc5d?=
 =?us-ascii?Q?q4DuKKZcD64uIGoezxCJz0EwGYDiIHkNk7ahA13JuCmAzvGiRtqpa7XWJR63?=
 =?us-ascii?Q?NhH15bgwjKr+EUwLk3UW3enFWaOAOCn8awKwknQQdWxXHHkFBfTamqAZG6Qf?=
 =?us-ascii?Q?J7yo6GnrP90LaGak2TtF9QT6d+yCSvIfDcLYDA91sxO4QLI2KJyGwiba++Vq?=
 =?us-ascii?Q?7vQORlAZfqbi85cgm6LOWDXYsXEFH39ypVhmMDYqQE6F40FAFku94qfGgY1H?=
 =?us-ascii?Q?R4SoSInJTD9DcZ2mXdJ83YRibm7YYLrlifZ3a/uk?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c33c331-80d3-4d3c-fb74-08db6d4a7f50
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 02:44:53.3781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TcBBqqHXt4g7w+frd3qUxN4noocy++mL/eRKfTe3eTSf7spJitg2YlmjbrhD151EmjJ00BF1SaI0pPnED0/v4+Z6ZbyCnRQpG+miMZbuQuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB9527
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>Subject: [PATCH v2] net: tipc: resize nlattr array to correct size
>
>According to nla_parse_nested_deprecated(), the tb[] is supposed to the
>destination array with maxtype+1 elements. In current
>tipc_nl_media_get() and __tipc_nl_media_set(), a larger array is used
>which is unnecessary. This patch resize them to a proper size.
>
>Fixes: 1e55417d8fc6 ("tipc: add media set to new netlink api")
>Fixes: 46f15c6794fb ("tipc: add media get/dump to new netlink api")
>Signed-off-by: Lin Ma <linma@zju.edu.cn>
>---
>V1 -> V2: add net in title, also add Fixes tag

Reviewed-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>



>
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


