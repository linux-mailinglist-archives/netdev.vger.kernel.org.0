Return-Path: <netdev+bounces-6849-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57136718691
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB9AE281523
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86D5174C1;
	Wed, 31 May 2023 15:42:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4674171D5
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:42:48 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2130.outbound.protection.outlook.com [40.107.223.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2EA9D
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:42:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gM3XZ+CYGh7R3j7uvLXDEYnNU+sWasBiqfYp6Dfp02nw9piJxKbQaQzwrCzruOKYhWL/dT1KgvoJ+LnIxeZfJMj5xQbZ/jB3VjgTdz07eDDc2gTQIj3k1tjWXrm1hLK1b6qBU1DFVs+nwfeqgYaglRIBboGe3Ca0ZLGdgH5Y5XHtxqml/QBYvYZL3i5TrFeFOUPmDIYlK9Fu2yApN0F9hHIbeknwIn4qw09aE7sK61nC9y3Zs1taWsOku6JyuU7ho05ZAtQ9kirSGgIIAC1b9u8ZSFqhi6HzGYF5LEnKzxGfNfzoZwJc2Xd7k+KkpBHMKQj3WvIagZWkOijmMzHIEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0y9x229C9OpK3G66HQP0x9gYNInMXo/wQPSHyfJSCIo=;
 b=QApQG4lvSMVNyi26jjwYrqvnCwIWQbkr1bGbBzCjSmGOVuz6D5LhL350OkuN7SjgObffLgxF1/1ST3FXqDcbm65dEP22JcJwajmmY08W4rwgdsMUYdYEC15/pxo7vk8mJhA9/cnSrn0uKeiV7tWFf1YqBvFiCal/Ug0z8xtlDJ+mOwsM3L4NAvtDfe3Ppa4h02w/hGzpgDfhufP6zioN4rsyvFK+O/m2ysEcRn165hvaKXcorInvbaQRRpsuG2BJWe0QtnAJ57uJH77gfb+XDsPZz25GPRu4bEbU4BH07+1RQk4oMQRqcP4/FxOHzV8LAMrIz510vR5iB52X0dFotQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0y9x229C9OpK3G66HQP0x9gYNInMXo/wQPSHyfJSCIo=;
 b=wDl8ULAa2dMQVGOLW+fQ5BaOr75jQLRcomlqE81BLnRTwfOwuul5NuEVWqijhrbDZNmz7ZSMxutnXMhdY0xUrwaAHVMsZBLEUKTq0XoXQGjKXYWSTdpT5x3PKXhj2OGNVICaTmOLEOGm7WawSoULmu5v2mDzhc7SNfjIaNWRXHQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4780.namprd13.prod.outlook.com (2603:10b6:510:79::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 15:42:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:42:44 +0000
Date: Wed, 31 May 2023 17:42:37 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	davem@davemloft.net, edumazet@google.com, leon@kernel.org,
	saeedm@nvidia.com, moshe@nvidia.com, tariqt@nvidia.com
Subject: Re: [patch net-next v2] devlink: bring port new reply back
Message-ID: <ZHdq7QG2at5ygtfw@corigine.com>
References: <20230531142025.2605001-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531142025.2605001-1-jiri@resnulli.us>
X-ClientProxiedBy: AS4P192CA0026.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4780:EE_
X-MS-Office365-Filtering-Correlation-Id: 88205816-db93-40b4-44b3-08db61edacfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BOoUVs7r/Qy4Xo3tWOlsTSn3sgASDt7NwqmAmZzR2IsI/mqWjt7dQhBQp3Id+GmycWr5n7U2PP9g3yjRa5ei4eZkD3nBxcPVhTK8GWyBPyK1Q2iZrbxtpJmqmHnDtVa68BNgaTvB4tO1ovoO6UPHwuh1N4og2O9wySs4o6VyobO3za5WnZ8034sdjv5A9FeDHCXWecheAQoVvK1wiCKctiyXrdqrAzJlbtSeogSboWn3WJmY/f7nUFcnMYlENHAPwMLEyTQzD3rapOguhhSu1dqOm4KUKnqm2/2p/f3H6QtEPAF+8stIuQ7OGpEpSHNb8wpOr/QYhyRMNY5/vavNf/ntujqhyAUJTb6GLLJmxC/x9TWxzlVWgNA1Cq6zczJNHiZdyt0KpjaS89rTwukJux+8AWl+bLhcpVuaSfDflrNnN7079XmX4WYRLclLUzdSzX8EmM3NPqKmF2EDAhv+J+n7yGGUJSKRGtr+cVUYGxFMk2GI6x6f+Ylx5kaRGMdJfdtTknHz7JndDrz6lNE73Dm1qr02ovA8Ko7YyEIWzpxrI5Ork0qKKeXWU2+dW41N
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(366004)(39840400004)(396003)(451199021)(186003)(2616005)(41300700001)(38100700002)(83380400001)(6486002)(6506007)(6512007)(6666004)(478600001)(66476007)(66946007)(66556008)(6916009)(316002)(8936002)(5660300002)(8676002)(7416002)(44832011)(2906002)(4744005)(4326008)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FKmbe5pVxnXwKWKRsqSCKc88pJOjV8SCrZCx1WWNI7imXE/FymFR4ORes4E1?=
 =?us-ascii?Q?nGD5JHifoxOYsunFBL6G8kuERxSLuhAQSVIHfnR3AlXB0UmqB0ARdMWtsN0A?=
 =?us-ascii?Q?WArZCH+OG8I9DJSXoTp04KzlEufHYwaYus1yDZqX0GopHQtO4N9bX73tp9rG?=
 =?us-ascii?Q?DnbUPvaOtlCkGf1FGuVJ/620WljOV6+3Z1BYp2GC7BIs3H79KvhDvZ/7Eq7z?=
 =?us-ascii?Q?bUBuZEf7UjGxqmlzc2cA6fn+i082m3gk+mjXA9tOpWT9VeUkFlkI3aqoJmvB?=
 =?us-ascii?Q?/oieYoZpt9GT/ZRZxdGBC9gQgHRZPkWP40gTyX5MDq+HXlgRCuuayQSv8VUM?=
 =?us-ascii?Q?SIX5Tkmisdslo82CMoBlhhlf80A/yxd7xlBaARNftXiPcv5NvNGzitrJobfc?=
 =?us-ascii?Q?Z1Lw1Yi78hU+M1mEDuL6st/UcoXFprLPl4bM3R2AxefOBe0s5v8b+qdyJwqM?=
 =?us-ascii?Q?AL/0yzsmO2IPO8dy8OWQmNsn0IxhNJHtoh+7Z5MVGcHXu8+TVqh/UJsYuLhO?=
 =?us-ascii?Q?BLlS5O4uk+AoI/QSCY882zJHGiUN5P+PAL4ri/GYqu5hxbyNIc6L0MIXBTNp?=
 =?us-ascii?Q?dkquTLOXodXHQ5nXAw9v8Ki5tfZyjnilrXA5dJ6zZ41MHQl4jh1phPkrODh4?=
 =?us-ascii?Q?43kLF8cqVox8d+9Vl1sFivsmOL5PHdnBg6ICHdX4XI2etIO5wIHe8srdWwFj?=
 =?us-ascii?Q?cEnUuOkkSV8uHqgeMYfd9irIK/8pdDAfYSvYivuTLrpbClN5Okqf0TVkvc/9?=
 =?us-ascii?Q?wLfmtmAaPAAvUz9k6ISDEwdapk20aq3kz6uV/jSzT0Ucw4PLsoxiurkBXkFn?=
 =?us-ascii?Q?6rxovh2K2fWeFzqq9qljtb2FWxiz2rcWIPNog3nqGvfgi55RRSLtkiP62VEs?=
 =?us-ascii?Q?LBKNl/Z1AEdF6RdjmZBvcn4zVNT9nVzgsxFgOTggxixTPsaE1XZvSSS3LeZX?=
 =?us-ascii?Q?C6z2aRNu/rdxJ9+W3OQgXH/0oCiIcEjbLu0IhPH3HuxfCIgZNQcs5DXXw/AE?=
 =?us-ascii?Q?DmUX0yXCBTPwPdCi91u7ZLQamKxe+yLdvyV74xcZLsuUlMBk1ArznB9MYeE3?=
 =?us-ascii?Q?orc/0RmyRJQKEQvYQ+NBAjM3xBlL+xPvvR4HJ7YMESduMu9F/+IgEoQCkMdG?=
 =?us-ascii?Q?W6Sc2GUAUndKvTz5FyhLrao6XQxOzSUvzx+3P07LjFD2aYsF4Gqn+SWm1pQB?=
 =?us-ascii?Q?StuYcKZM5smjqyKksmGmO3mxk/zmk/Q1w+vYycXvOt2jPKDt63SjMiCv5Pe/?=
 =?us-ascii?Q?+LpryOmr7OCQggtRl/n+xY/da0tqXu8J3rBdEx+0iBOOL7tDoVlH/4lkkvAG?=
 =?us-ascii?Q?q6PhLKS64Nc3T53xbEPJn98kSq0DMf6ljs9p4z6GxfD26ZV1i8PmDsdltLI3?=
 =?us-ascii?Q?BzbwNxwlz55Z1UkWGhPyLebNIQ3TZuqlY1NwRv7ORJomikjB7SyyqVpEZ7ON?=
 =?us-ascii?Q?JuzXKrULBEN3jZOCm/Mnr8UOHgh3HB2STuAKopoT8ruWo4apl3vjZbwzNh71?=
 =?us-ascii?Q?rmHeQRpMornKExn2/K8mFm9nCfzItxx0W6Ollewx8+dcCCGoN9KuwTyPxsj5?=
 =?us-ascii?Q?oZZiMySCxVeW2f3jXIM+jFNS/XSPqTDnFhRToTJlu2A48J6rQMSKhVJ/Pnim?=
 =?us-ascii?Q?wzPFtAITaXnos/NWDphRYGcsqfsQdLJkun2GINTeUI9/1v5gyftgJMJHkaq1?=
 =?us-ascii?Q?G2Y+1Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88205816-db93-40b4-44b3-08db61edacfd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 15:42:44.2819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAol98LvoAcnLefJYCVhvuNvKaREqOrAOHZQURwQI2FC7fGhqWJI8mrczr6VnWZrxSB2IrYtd0+5W4Bp0hH9/LvjMfKIeRy4iZTtJVNT9kM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4780
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 04:20:25PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> In the offending fixes commit I mistakenly removed the reply message of
> the port new command. I was under impression it is a new port
> notification, partly due to the "notify" in the name of the helper
> function. Bring the code sending reply with new port message back, this
> time putting it directly to devlink_nl_cmd_port_new_doit()
> 
> Fixes: c496daeb8630 ("devlink: remove duplicate port notification")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


