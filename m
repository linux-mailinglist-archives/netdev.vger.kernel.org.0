Return-Path: <netdev+bounces-2645-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D870F702CC9
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84E1E1C20C0D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0374A953;
	Mon, 15 May 2023 12:33:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D653A943
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:33:20 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2093.outbound.protection.outlook.com [40.107.92.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E4A1738
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:33:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SErqh+db61PArhUARmfTBRce/48R/YVzksDo0Vix/kyKehq3CFSZt/sEL3gc3HbKsSHdFamj/3qcMh3CX8fprZQRaZZbVL7LDRXWYxzi/sCnODMheBgG3cs5eqCaq1Gz3qn73YxYG4unVDoCHDpHQa4LuhRojQxiRDysPb46ld8yuUEF9D7GUIWYHdyeKxQVf8Xy1eM9/fd2UM0WGu15DiBxVCZ1EIWy04K6cJfAdX1kzh+tcgCiU1/ayAQSDORgjWvve4xIPvnfwhflQ9WIhwtOKlyuNCdfIqm6Ayk/Z94Q8Xc6WpYxTP/0KbsuP5ETaZz7VmfuvdHU15iyzEmLaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UwNCSzBtVDKHqRg5Z2IeJ4975mNsmDnHmRwadIvWfc=;
 b=agImvOGVckKbhyopBctwOSX6qMMsxGs3YM4kxR7BK7wOtYutmQKv3kUWS3IwUQ6fEXJpoanztR/ajcJXh1TuaGpCGE1f32+eonM4GYq/sqAHmeF22Dlr2WwHjPSrc7j9aeJj0uw+0G1o3TEziaNTWETmMaf3M3dGXbr55LXa+Dlbvu37+yCbmIb6NYP7BeZKBMOFL9RG5e+AiG4ptzcDtwKamOtcQi3HgW1GmXR0v3L79W1+NC4+53MFfCmBhqlD9Mnxuv/SAfUEV+ce1HJXhMExchQI7bdeLQyNZ569HyQh6MiIGa7HtWPsVIepDT9aiivw5gJmBWMB8XbS8Vw0tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UwNCSzBtVDKHqRg5Z2IeJ4975mNsmDnHmRwadIvWfc=;
 b=QRcnByuSP4aTlK0fnfKrIf+WnnxOvOfcRyUeD7KzezBYdv9D5of7H/vvDhoJW1Gl4KypXzfLhmhsl/nc8wpeRNUS0gkHGHFdd+8PjoPWOXKt61Zuyi9mikKFaTmHy1cyWxRJ8mpdWtrTr20ZultGf9AyIGgBcSmk4sXMI1f4BEQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5880.namprd13.prod.outlook.com (2603:10b6:303:1cb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 12:33:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 12:33:05 +0000
Date: Mon, 15 May 2023 14:32:59 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Sundar Nagarajan <sun.nagarajan@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: IPV6_VTI config declaration: tristate line is not indented
Message-ID: <ZGIme2Vv3NX3ht7s@corigine.com>
References: <CALnajPCmN37AU0Dz8NuwZdW3MX2QWiSdyoKSAHGbD0B+dvHoCA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALnajPCmN37AU0Dz8NuwZdW3MX2QWiSdyoKSAHGbD0B+dvHoCA@mail.gmail.com>
X-ClientProxiedBy: AM0PR04CA0012.eurprd04.prod.outlook.com
 (2603:10a6:208:122::25) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5880:EE_
X-MS-Office365-Filtering-Correlation-Id: ebadc80a-f357-473e-f125-08db55408808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MdjwF8INjZjme+mj7FNdCx517Iq27qB3cEb5hb9Un+QHs6QhMhr+CWnFUEoGeWI3VGnjbUZ0kJ4zj7Vqewf1bs6gHdvWs38A7bjfiE4s9ZH3Xa6gjfRH7weC/KECniXU+rZp2MWxsUob15/4Qw4RHaWcEBTKY88USMAjLlUup5kJfrk/T70Cfn8sBYOk3IapQ09hlq2lVkfVkZFdLuj6/SD4rAMdv1Ohlh6XlaB7JIlWWY2yS/+ZpggrLkBUi5vPWOvNwHvvHOifQaj7fZTw5KUz9LyjvxfOLrYOEGYlxS1BJRjc3e8cish4c0tSHpIdAaimhMLkxqxdLZqEbfpP/sKlli4SOtuuEdnf/AOKRHCYxhmYyAQSgsLc8naJScUNDcDjOU9sqqLHFrST0uAf5apL/WJnjFHOPKId+EL2ejO/JekQ2WUMF3W8OwdmVWshej4e71qcVEkwgBIv51wjMrBUq3qodNctjuYATbAa6nEPWUZr8pENadVLWfIz8dpweScjVyQVyvwz3hMcUdG4S/3YmL4+DkZo5/QNWqIZp1e9THXJULdFw426bCQHSEP12UeGNE4RVjOJ9mKM97FJvDIxvgYocezhEeFM+zkXkio=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(136003)(39840400004)(376002)(451199021)(38100700002)(86362001)(36756003)(316002)(5660300002)(41300700001)(6916009)(4326008)(186003)(6506007)(8936002)(8676002)(54906003)(6512007)(44832011)(2906002)(2616005)(6486002)(66946007)(66476007)(66556008)(966005)(6666004)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wCIj+vjC3u0MBSH4DPdXNVXkt0D5hBuTabbXQt8wL3FUk8AmalrNt6wEcvRo?=
 =?us-ascii?Q?a3sOhULk3YrTm7DNg+wilCCqk+bfX7BFIi5+CmjhSUgS5Oqx3ahHu4/xdUUy?=
 =?us-ascii?Q?Hj4ILFhtJS09DGIhOxayH1R9zBdAchQIu6VZhiQWokG30sr6KD6un+yJ3Bz7?=
 =?us-ascii?Q?UH7BJzgBiLFXGmugZxEZOUMeskBym0wH72JqNOZ9V1r8PjXSyj95pnJIVbkd?=
 =?us-ascii?Q?z6VTHRsJOp+O7DeFaQ1rG3sx9vmCO9yTK/wfUqUEfShFenYqa0KxfFuHQQK1?=
 =?us-ascii?Q?RGKaKTsjnKvV53Q/QKHZ8wogmsSRBpZsBz+IvTYfyJOdcQZ/4lF2/2siQiiJ?=
 =?us-ascii?Q?gq+I6rrhY11HrZ6jD7o3SLR7zmQ6w7mUcdhEQSd9Gt14sBP/D5EkzNtERMmF?=
 =?us-ascii?Q?6yvpf5i6uu0Mtv87XJaM3EKb3QEUm+kEvZfI0A7YemDnfY/iWs93k3PaJhJC?=
 =?us-ascii?Q?fJiw2udO+MhSy0upIZIHzgTZy6LqHbMtH3OCQ9lQPXcdUkh1g8coDgQw6E6l?=
 =?us-ascii?Q?HoZqb1YDYrAYxIOFkB4fvOAQDvsbkuv6zbSjkaoH44esnZsIQiMzXF6DL3FS?=
 =?us-ascii?Q?StocPMLbCKht+dYNh5T00oCiGPlWIpzidrBAHoFKhSy8vQfstGylZJDWaXdW?=
 =?us-ascii?Q?JabvjP9r95+pM2Kqlh+dixcMQNSykXPmOG8sHBspET+IifitBWN3qHTaBK60?=
 =?us-ascii?Q?0vlx7ScLiYTJ2ki/6LtNXZ/8B/6Rvi9gQXF22uToSiiVJA12JfX+hGY857nW?=
 =?us-ascii?Q?WI9Fa0i9lk2yIbPVDmdqxcA77iuGRBdLAxZm8q4MaOuWKDIavnmiE/sIJGcc?=
 =?us-ascii?Q?/KPYdtvVPighzZ0kSZuduT6SsIai/jFvpjELC5BXkf94pEd6cv6AQz5tn3ZH?=
 =?us-ascii?Q?ZSlJnMyFvNvfOzHwbSaHTbIz8KO14l7scsKvvTYcbn810lYP7fIHff0l217K?=
 =?us-ascii?Q?4vwvchOfAu/UWJwxVwvvQ4w070lRlCuEZbXBBjgJrJXddcxUK+W6N61Oje3B?=
 =?us-ascii?Q?iJxFTPGdlHImSAijXWujNszMrz9Qfb521ZtgXzrgd7fboj9I9wB//3qxImei?=
 =?us-ascii?Q?4qb712z5CLY1Re9U2hDK4zVGncmyZFBE9QVsYxBJOIqRbGVo4qkx/geHcGMp?=
 =?us-ascii?Q?jisRG0TqgSgFrEjBnw3uMLak1ln/n7MAAKHFrys1RCdvTwdYUdlC9go++Y4w?=
 =?us-ascii?Q?U5H7XbLcHDnVMUDqn1dqg4WXw8AUI6WdBFIkeEkpGppf8C4zBA1sHQw5PGiP?=
 =?us-ascii?Q?IwJrNJwdXglzjZTIoE76P+q0EizmxKADNwVqwFIVyvSPGgNdskt7eyq4gigJ?=
 =?us-ascii?Q?VAbakS+YXadlEjf51LGzY46jg1HcP5QTz2PjvZhpSJUsFs1V57Q50HYEFP+J?=
 =?us-ascii?Q?ISlp1UxqySreAj9Ll/WakpUKgIe4A4UCawyqIzdbrTyxHPz3gcyelLgBddw4?=
 =?us-ascii?Q?8gIT8RVAnRwJqc3nIeimD+ciL/qbTRUs641p0zl5nDTxxEInLjJhrcggih/R?=
 =?us-ascii?Q?80lx0DHl0wGaZAqEhzA4N6kWSMKrDfDdWlL7munp7B0kOYn45wrv+y2BJXcQ?=
 =?us-ascii?Q?QDJJ49JMfABAHVhqv2apafG31cjYMgseNQGb1luLNg1QMMYjFxKmTolXgEQ8?=
 =?us-ascii?Q?iAPkcEMvUgPxwV+YPIrdJCTgk/ZKLjF3r2ZP9T4LfXht8+qDZHY+nsZpTRet?=
 =?us-ascii?Q?gEcL+g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebadc80a-f357-473e-f125-08db55408808
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 12:33:05.7163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5SSCV+7WdTURqS4btSEV13QutVZSWgPa145cFrl6K0y8nxHmM/em3HBkzmXHaNul3yr85jFsM5JA1+A/cF7ExC78NrSeWISWHMYP9AJRWaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5880
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 02:36:08PM -0700, Sundar Nagarajan wrote:
> diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
> index 658bfed1d..c4f6bfd20 100644
> --- a/net/ipv6/Kconfig
> +++ b/net/ipv6/Kconfig
> @@ -152,7 +152,7 @@ config INET6_TUNNEL
>   default n
> 
>  config IPV6_VTI
> -tristate "Virtual (secure) IPv6: tunneling"
> + tristate "Virtual (secure) IPv6: tunneling"
>   select IPV6_TUNNEL
>   select NET_IP_TUNNEL
>   select XFRM

Unfortunately this patch has been white-space mangled: it looks like
tabs have been converted into spaces. So it doesn't apply.

Using a tool such as git send-email or b4 should help avoid this problem.


A few other things.

* The subject should start with [PATCH net-next], where net-next is the
  target tree (as opposed to net, which is for fixes)

  Subject:  [PATCH net-next v2] ...

* The subject should also include a prefix, in this case probably ipv6

  [PATCH net-next v2] ipv6: ...

* Please include a description of the patch, in the body before the patch
  itself.

* Please included a signed off by line.

Oveal, Please take a look at the netdev process document.
Link: https://kernel.org/doc/html/latest/process/maintainer-netdev.html

Likewise for your other patch,
- NET_DSA_SJA1105 config declaration: tristate is not indented
  Link: https://lore.kernel.org/netdev/CALnajPCaJfR+N=vP0R6bXoUwMbopQK6JsJ+pXxS=T6KT5NXswg@mail.gmail.com/

---
pw-bot: cr

