Return-Path: <netdev+bounces-5265-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C25B0710753
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:29:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DF5E2810A4
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C895CD2ED;
	Thu, 25 May 2023 08:29:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4947C2C1
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:29:11 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072c.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::72c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BCF18D
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 01:29:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X21m9HyQYd+aUMF9GnTpHbOr60eGvlsRjga9cOpeHMDOVb0STN1OL2rjcWRDg0pELBu8sZPUM2mVXOr+kpT/LRmdbEiBK8X4THMY04yGXIWejgLqq9u32e/sZgmnB+wQv0yYPtDLK+JGNKdDXidS+RQhtolYPV/SRrjePoyfTrAawtHDwJ6BnRfYhMlO47GEB1F2kGyzdqHKmx9In5a7koXbsSw9vXn+8NxCftmybOy6ZO1pAXy6y12Bkjh0D1s+bUVMll/p4aHuIYlTxAhqh/+wZl6ofled6FPhIyDlpxv1ToZqnCqp+6iNwSvlySoFm+vzKjZyPD5ihWmSr47qHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kiConE/0tKaYOUWOyBbo3z2cPsD/EVJRwgGeqRJGcxQ=;
 b=G/SVZVsUAouVOp80hXxztUJfmjiQJi7qmShmklvASRvJHlc4Ns55UPyCUK1TAN4fnVQZPnDOvqqIxNdO4MG2eoVO6dE5J9W0HESoM4b3WbD9WX23UaX2JOMjeHkMwDH7cD0Bgbi+LkcTUvgdBXZf1fZdXSJVcRKuGt6n15ioDdCjgJoHG45BmQALH9SWb/11kpMayV8NiU+rFJdwKKDAZxUD5mLJCryED+geLlMQnv/Zxt8SyPRzi7uNQg8wXnoDdtuqE3AUKoZXhdQ2V8lMkPM1QcJ5wQKL+6zLlCZj5h8G8l9hgmP2srjNskhz2IfLgCPqmpU3gANvUL56ggi/eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiConE/0tKaYOUWOyBbo3z2cPsD/EVJRwgGeqRJGcxQ=;
 b=UiqG6regPLZ9oGyFDOXF2h9mR0yjhnKBGSNTh8/e3px0pu+qFQBV7DbjXPDX6NXJKjpgLxdyndX0c1xE14nE7QV8g7N5YBdVqEBUDXcZuZJWNnEm7Esatr38kW63BMNIXoa5S0v40wllvthPsa9klb0xE6+BEJtYa+lMDA8I8Y0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3651.namprd13.prod.outlook.com (2603:10b6:a03:22e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 25 May
 2023 08:29:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Thu, 25 May 2023
 08:29:05 +0000
Date: Thu, 25 May 2023 10:29:00 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, donald.hunter@gmail.com
Subject: Re: [PATCH net] tools: ynl: avoid dict errors on older Python
 versions
Message-ID: <ZG8cTJK37yNkV0wo@corigine.com>
References: <20230524170712.2036128-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524170712.2036128-1-kuba@kernel.org>
X-ClientProxiedBy: AM9P193CA0001.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3651:EE_
X-MS-Office365-Filtering-Correlation-Id: aa48c30b-880c-4cc0-db1a-08db5cfa1a50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pIJNn9A3Q6VFkxVpuHsiqlhuSVgJOz5zMOm9ut4YvviRf+Q3IUtaNDDQCqaGXF5j7Gkgox/tSyh/dXctsN6BMvXbsktaSMscF5m6R39LiW5RZP4tTxnKbBr452sgTms3n9J9kfu4yXGVEwa6XvyrMU+Hpt2qgGziZ3Ztq5gqsWj+81Z7Yo+KAvpJEwCv+9O2p4p9HpN5NIXHuQoXC520G6Juej6LqQr/2Ma6bDIVrCFdliM7CC+OzWWcW3Hb56DDm7DEohcOsUkzZKXhcEZWBa3WqI4L9L7Yjlm5uqipOsCp8wfG8ipXvp/9pgLgkce7TdzBqrjVbLPhRlXuFGWd0Ud1+oQnfjoo2IsLt2cOArFq8S2B+CELaGlm8GfBVNUw7HiIffDWvWNiPXD+6g+hSbbef03yFF862HecQU95Xwt1vIRDjvDxIluCcA0LSUDKEnU3plLJ3WSgVCa5L9UWrqv19o03a/mndW+R4KaYsDt3lxh/U7xMPo8zW2Ku24CnLy6YP3rPfRZfwKgK2mFN2dGFiwZC0mPMsm4cvjhSNX8zk8UG6q/XPU6lumL4sH6v
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(366004)(346002)(39830400003)(396003)(451199021)(6916009)(4326008)(38100700002)(44832011)(66476007)(2906002)(66556008)(8936002)(41300700001)(66946007)(8676002)(316002)(4744005)(86362001)(5660300002)(36756003)(2616005)(6666004)(6486002)(186003)(6512007)(6506007)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0pNVkAcq+EWELG0s/s+ZS6IuqIbDSgxSluQ/a6lgqKk8FZUQD1RX7k5ygXmI?=
 =?us-ascii?Q?76HQP118t5vWttu9vrMcmJfwNbknsytk+VkYpS8dShrhOIUZ7Oq2OJ/2iyhI?=
 =?us-ascii?Q?RSg+tCXVOu0SGRJtDaxqvQcz5Y/65C62djpkvEWB6DIp6HtGAcQRAM5DnMeh?=
 =?us-ascii?Q?Zmjt9DGkaDe5hvdPHTi5N2SsnMScf4V1+dyISI0DZd624sFDznwACJQfJ8Yc?=
 =?us-ascii?Q?Bro7RHoarUL+8l43g1WOcel9K8rzybJzVMFVcROPfydyHQ4TxUIdYjr9k9W6?=
 =?us-ascii?Q?jcwSSitPbjz0Yb9DQPtbo0gXp5iOsUD113Pxp2Nyki3sJO5Cft+eFnGcPXrB?=
 =?us-ascii?Q?4cROYJ8osaIBvpy277ufmp4oMcvHrzwMjEDcrId3AF3RDI0hbPKXI/AI8soq?=
 =?us-ascii?Q?ptK5xNFLLp2y/z5IN5JaXYCCwLjwUS878ZyIZq7o/R4FDR01W+OLOnXllMHU?=
 =?us-ascii?Q?1bJ1s1gNtkf0yQfDMX9BFVL0HQDedaaz2+x5t93Nus4zRd0JeiauDOqI4wTv?=
 =?us-ascii?Q?LvndkXSOs0/3un43DvRO+mBQLov+EYuelnuPCZ60xa/GyQrmYaP/gwKQu1mb?=
 =?us-ascii?Q?vKYRgo3K6qa9bIFG1V/n6fufOe5YS2upQJa9fOE89qoQYYyqgTQs0ZlMUdaI?=
 =?us-ascii?Q?/uRTM9e6ZUzx0iFjY8EDRC9EsV8NvzSDRcmsRoynvEWuzWPva2ZX7OwJBkZZ?=
 =?us-ascii?Q?WT5KWDWd6hVODUnimv4HP6+0IRs8GsuPYSWGbvKmDR76QiJuGBLzHo/F8e/L?=
 =?us-ascii?Q?77DE9xtqXaGT2PNsB0hUv6VgRD4sTH3YG4TRQsDqEUksfQ8Az863/0CaC+zh?=
 =?us-ascii?Q?2V6RFUuqreWygVV1mz4vA/8UjVDONaRr5EVPWxcnPYiC0lsS7yBV0ywq+ixD?=
 =?us-ascii?Q?C14r0M2GKj34Ace8CKxyzPlGspTlMv1vt3g27Bc4bwjisWloqZVQL2hHCxQ2?=
 =?us-ascii?Q?6q61xX7zHVaWd4u+5kxVdOQlax0KiNlmE575049bhFlF80MGVwnCiHKn680/?=
 =?us-ascii?Q?XjIaj8asJd9SOYarDSAJNn26qdNCHQuZpqqcTBrUVMf6K4crm/k2mCbue36r?=
 =?us-ascii?Q?+9lwMH9syAB0IvTTeTMWgGEzKPUQG9JdwFxKodqULFPH3O5lDhisJOLHpog9?=
 =?us-ascii?Q?YFgSXh1qzbXGbx4s/vWW4a06gmHtLPgAmxMptq9k+1iFjUOlNsQkwv2yHRX3?=
 =?us-ascii?Q?+OD3cOw20/5tQdkQgSyR8vCSHKBLsO8IscNPspofMRKZdTM6zSx39J15Wqt5?=
 =?us-ascii?Q?diYmw+z5I5EgZ1sDL+iRPQHb/QRfb4G+/g5k8HkV6OmLVk9jtRINph5OKZ4H?=
 =?us-ascii?Q?jthxTvZFfcHVCW+5hPx8BP+3mnQfyzcaWTqh71Y3JZSrRUFo81PPx0tR1rbf?=
 =?us-ascii?Q?sVgR7hGstnZGWHMatATub8Fvce5yCuTGUg9OH2gb4tzTCDoroW2VbUIPsZ9k?=
 =?us-ascii?Q?G1h2FQc2aQJzlSpPwZoX2m8i/1/QgNXB+sP/XhBgYfIRpArl5d89K/FeP/3X?=
 =?us-ascii?Q?zK/FFFWYQJJ3+ma1EmveD1Twdq+fsw6+Mba5KVjBOLyjKy1eAGBDYgl2ulCg?=
 =?us-ascii?Q?fQc9j+Bd/YXHsj802DzGtL9+GVfay8etMgmcTaEY/4yyREiJNoLSOVfdF8KV?=
 =?us-ascii?Q?A3GtxwkNud0U8BNPxDllV/GLrgE19xQzpOaH0rNIW8dASyN3xGYEDRor9pNB?=
 =?us-ascii?Q?divwjA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa48c30b-880c-4cc0-db1a-08db5cfa1a50
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 08:29:05.7212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ye4L8afMqfXkdJmuMQSZIzPzoSk4MIN6StSQErt/e4FYvOYhwtyCQc0uB+mP5FpILz0XoxNvXHP8BAFIhK4AYkzkImFKgEbsNW7qVcpTATk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3651
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 10:07:12AM -0700, Jakub Kicinski wrote:
> Python 3.9.0 or newer supports combining dicts() with |,
> but older versions of Python are still used in the wild
> (e.g. on CentOS 8, which goes EoL May 31, 2024).
> With Python 3.6.8 we get:
> 
>   TypeError: unsupported operand type(s) for |: 'dict' and 'dict'
> 
> Use older syntax. Tested with non-legacy families only.
> 
> Fixes: f036d936ca57 ("tools: ynl: Add fixed-header support to ynl")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


