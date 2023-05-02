Return-Path: <netdev+bounces-3-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B3446F4ABA
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07AB41C20909
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9EE48F7D;
	Tue,  2 May 2023 20:00:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0528F7F
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 20:00:48 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2098.outbound.protection.outlook.com [40.107.92.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33554E67
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 13:00:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biyyZZ3/kYnJkjUS6qGvbU2pwu/oV8BBBJQjFPSNDBdFw/5A2Nylt90Piik5XTzspHOzGB1H853yObOo1vVWEMhF24vPn1ARtfruADtii3U3+wDOKsn7FEZ81Zsw85z6Ce6YGYyGYYPd+wP2t1AU5nep9bC1Rt43rpPxi6OBwI/uzFj9z3XizkpV4zQWHfvHBedbncYVZnl7rftwXn/F6Bui7uQa0nbOa8ZP8Od/LRFK7EZRdSHAOuX/4ZLHp77zHB0jvs335iX2X7Xtf0Og5wDNo724h9w+H/7KIaUUCxl69Z9fDCxeI8568KVoSY9B0yezSWnCWZkyYajyxgZcVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qTTeuj9pI0vZnoBIy0iPMOulTc+GviOA/Pi4Wy59xIE=;
 b=RVr3O87g55nnVl/Z+lvN6atEg+v8IrpPULNynACk9aYlzOopxiMvfc1WjNI+UDbW8EjCQVcSJQ2z4wsxM1MxGc8xFlD5CcnqScZKpUdPhRvEAnoZG9Hpec2Vmih0ZcwF2Rx/jyfz3ca+DpABsrgLWZEogS1BF0B/tDWhjRPoDdfXr7kyEZIJmH0YoPnIWoo0dYj/n4huoL6pRdUvCiwhnYhsE1p6oThwmx/zHox2GmTHygGfN5LxxLUh8u01eIv7SEow7Rdd7UZmxAHirMoRIu24wa6uFDa7dUh+IlW6peBqbXMB6BxkikVTVjFhzVrny0fnVwziHWcfl8gd2tiC4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTTeuj9pI0vZnoBIy0iPMOulTc+GviOA/Pi4Wy59xIE=;
 b=b5QA4u1kVnJ0e+0ZAnSGTxpM3Tc24D2feB9lcANg3PAKA0iR1gF3sLC4zLEndgtwO59cvSPSJsDYui3AXEYJmeZLVzd4s9wM8QA4PZsDh8QKkMeESXrFWERoXqmPyQSbuPQKYuS0YlEGsmH4wilcXS+gjv1gsJMX+9xlbayuwnk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4135.namprd13.prod.outlook.com (2603:10b6:208:260::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 20:00:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 20:00:40 +0000
Date: Tue, 2 May 2023 22:00:34 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
	drivers@pensando.io
Subject: Re: [PATCH v2 net] ionic: catch failure from devlink_alloc
Message-ID: <ZFFr4pBcOxbQTVPK@corigine.com>
References: <20230502183536.22256-1-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502183536.22256-1-shannon.nelson@amd.com>
X-ClientProxiedBy: AS4PR09CA0021.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4135:EE_
X-MS-Office365-Filtering-Correlation-Id: 16fd4908-1eb2-44a7-b5fd-08db4b47e7b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	g61blx8gYwohtSTQoKrNDt9IeBInRekx+NW9SFkYa9sehZTyeJrEZrbKS82kg5xuLYYd7igZW0Bs/q9Ll2OJWsJTKVR3bvVMXyZ7wxQpK8kDjAFvL5S34Hnkgb1N4LUQqAbjMAKYUnaGE1ZFbl9V8bs8+XEgGrKkklhCu1ZdZ8/ZyzDuTkrXmMXFbaBqyPcjmBRPF81oURs7Rf6csOh+f8v2m/T05YjzPw3wMVDFtY9aV1QRQAw3hxFaZAm//ZqlORBYprWm7nCg4N3yOfHQu+Li3yvfycsl8soGWL6juB39xb7GVivSZV5iMOuOKk3YLEC0ZrLHWjI+Ysp9tR7iQYRuRBixbJSSlLXkdv1jDxaYWlWmjBDyu72lWrKXcV0nxkOENGp9McgJDciJ44tRnvHWzyKWO8aGme4Yg19mKauoUGil4+AIXBO/2qUsWC1jRZejHSJVwknNGwJKbfLo5WKe07+OYO8KScxP3Au9v1wcu2M6zdKhM45UzkfZZI2hsbfM0bga1ZP3Rv3ouev0qgpWo853DrTUcEPps4vsQrc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(376002)(39840400004)(136003)(451199021)(41300700001)(86362001)(6486002)(38100700002)(966005)(2616005)(4744005)(6506007)(6512007)(186003)(44832011)(2906002)(478600001)(8936002)(8676002)(66556008)(66476007)(316002)(6916009)(4326008)(5660300002)(66946007)(36756003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZBM22a7IGSJ7QmHmMEKBREE2NhflL5jOeVqOHsEFlcYXGDTRyI7UY4NweFL1?=
 =?us-ascii?Q?1Eg+VkAJsVFW1+1PBlzVV4iP+gHlPqehbtMcafIEHbhCcuZhzYDBBcF+UPGR?=
 =?us-ascii?Q?ppETq6jU8J8rfhDW2x63wrbadKsvkZgPrxtC/wa/wgMFFGLaSEY6ylvFUWhB?=
 =?us-ascii?Q?S83s+Gc4umwbKt4/oUm9ldOKVlFVasaFTfaOVwwEuTceZWSJTUBkD6H98NFR?=
 =?us-ascii?Q?UA1rVoU8rLb2DCwKjnEedcNkIxIiduNfznclMxeQ+QI2P9QfwFvT3hDzw6SW?=
 =?us-ascii?Q?VKu1r7DoRHu3OMqjN0NkfIL6mKQOzQrwnZbd3R9vxInd4bQgxT8f+5Twc7MP?=
 =?us-ascii?Q?MkrLm8CfTbiGB4FzK2LV5fdez8pCPCdMZ8Bwc3FREa0x7WUS4+BpdoLkYAKP?=
 =?us-ascii?Q?y2Tv2TRdjylD0KV69jkoLlJG+ADfUQPjjnbLQo+Y9gwcDbwPmcKzLmAImKAB?=
 =?us-ascii?Q?RccA8t5YGuItqBLnAV0LHzv040lNrU/GdKDP97QluKr8H95y83wvUn0Bd+mT?=
 =?us-ascii?Q?GjTm96wLcPssNXHXg2CRNnHaFERTgxz3rMOZn3iU96zDx/yMYHAB6ST8vQOE?=
 =?us-ascii?Q?bxUxo0QIIZT9kKu2xGN7dWsqsxmHdKRe2oUxdgMQNrx9Y9BOZsSxOAsxAfKy?=
 =?us-ascii?Q?A7cw8h+P+6qIpm3tvvsR6JowP4bUUOjQDkHDNXTuyujzGtYWGqykXimHiuKo?=
 =?us-ascii?Q?OTW+ZTVHWFJps+DQQhz7dppQNmYIl/ufqOzeuo1BLMSlVqBAW5F3fK7apnnY?=
 =?us-ascii?Q?dzEivyHaaKOk9PbuQ8jAZ+nTtrAl45nT7thqYMjRCQwVP0wslYiTBIs+q2cY?=
 =?us-ascii?Q?JIaETcUXymn6Xw+/CP9tMzG/ZTigBsVs9U4klbj07aBuvvnENT5SCIKltjsv?=
 =?us-ascii?Q?zJJYr0nFqT0/eElLaeL9/Os80frAFFxKjwVPy3plsimoXFk9qFMaftsRRs/t?=
 =?us-ascii?Q?bA3VY2iTAw7FBY/gDjQ3gXHky1wi8EQYazXP59TC6GnbTHqvHUAdsH6ewv3N?=
 =?us-ascii?Q?S9iDN2bfLU2KWN9+XRzLXM8xsv92fqu7WxugqevgtXKcP3kHGeBMlDC89ZXX?=
 =?us-ascii?Q?HtxswhOF8S6CghnnkPX2KC8xFYilBDqNauw6BE27hwiFOfS1LobW7mq6mmYo?=
 =?us-ascii?Q?lGtxBNrnXtevg3Paai5Uf9k+M+DaMxQCBdh8gBM+WnjMnJBdV+MgGI57D0n3?=
 =?us-ascii?Q?JH8ifdSVDEk8Kv4EAcr/NxBYUK5x5KLlkxMB++HPmQWtqVkSOcz0Pwa0xooq?=
 =?us-ascii?Q?+ZmEroQZ1Q+wqbWVJKEQoK9EId6/nSCFzBP2b+kaleYosxTalqROBou5sc+h?=
 =?us-ascii?Q?wuqhR7sdXXWQAJAXqrUp3vOq9g8Ct58QyNjkfkctgyMyspp4/yKdDVyHX2ZR?=
 =?us-ascii?Q?8eah7e7nwnHeHQbc83aSnz8vXNxt0kJwbXMGMjc62eMp9xN+2hje0jNVAleC?=
 =?us-ascii?Q?WLFARL8LMx6miXPkUIRsuPhn6JmtE7kYC11Ib5hCA9xdK+E6tk/nmPKbg0x9?=
 =?us-ascii?Q?Sf0Bwm6g2Rlngw56mTwAfCM46ZXvf0Ti6o/6PWbaUPOU3/DyRZ6dOGwHv2aP?=
 =?us-ascii?Q?qXfgx87uJpzWq5bYLgTixvUTic3cZIlJ5J+kLeSS61LnC5dh0qy3PFHfHoy6?=
 =?us-ascii?Q?xp8leThzjg+ECQOoDm3MqHZHChb/ziRBiIbaqY2TJ8IUrVKs8QXPYFTdxDNk?=
 =?us-ascii?Q?zBi5AA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16fd4908-1eb2-44a7-b5fd-08db4b47e7b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 20:00:40.7792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ujxZL7UO/exH+KrkyroNh/HyejCFavSyjeBTR6gjMXiGO3OQuJOqvwEqbYWVDqpXt5VkjM734IHq+YIGBiqP0YLZy3asURX9cyHNk0+/IzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4135
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 11:35:36AM -0700, Shannon Nelson wrote:
> Add a check for NULL on the alloc return.  If devlink_alloc() fails and
> we try to use devlink_priv() on the NULL return, the kernel gets very
> unhappy and panics. With this fix, the driver load will still fail,
> but at least it won't panic the kernel.
> 
> Fixes: df69ba43217d ("ionic: Add basic framework for IONIC Network device driver")
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
> v2 - fixed up the Fixes tag - thanks, Simon
> 	https://lore.kernel.org/netdev/Y%2F8tj+bqGG1g5InQ@vergenet.net/

Likewise, thanks.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

