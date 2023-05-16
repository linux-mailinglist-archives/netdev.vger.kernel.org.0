Return-Path: <netdev+bounces-2965-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 352C1704B60
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:01:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 267871C20E1B
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B3D034CD2;
	Tue, 16 May 2023 11:01:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00041773A
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:01:08 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2096.outbound.protection.outlook.com [40.107.244.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6962D5F;
	Tue, 16 May 2023 04:01:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzeVeD4DRzOD5/SZjUl87BNOrjA0jSiG1V/VBmCkf6acskBcv4GTMNIe7IltSlfzsV8wd6PirbhiLITaf32+k1vblb3SRNf8DuZCnswev6rxFeFSRgzVUpOg3SN2+GF5kFcEu3Rr+2DCbAvQT+no4iNgZaRGypbxhAEP1nz6M20Al4qc3uDAR2HNTxsBCS3mdkif5Tu8HU7GkngMJprOMPfjuVKBO1LA1cXcSDvJ2d1ubv8RCQsjCBQvkDjgMpszhTVE1gwaOvqzpbN9JJb+aWKG75wbTxvZ8eJnUEfNuK5vEhOdpSgjHlAq+T36wdj0VhqxZauk+/S7FL9ZEbAfWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GPFfczXO6aQtrJlHyU0VonSDBiXmqaUdRdAknMLYE0g=;
 b=l+PHdqm8bz1BIHiKApkhE27ig1oaGtf1ZTK87ABGiQZK2jCiiwugwPEGEGBMfXG1e4s+kV5CsWmYIWvVm6njagOkUkmgnmTjhMaG9N7qE+L3qMM3aYTbqdEiGqmkvPLd+KvsiG3Dg6CtysqGwpPUyvs23uYWGivalVhM20z7/NLXTzx1dnmm0k5ZlNPwO9hh7Lewg76bSoSA+xdwXmbpfBihFZyy4aIQZ8ZQ0loUdnRhsyygjkML/ZJ71f/I1qzn0jzf9oq24ZcMC1bnN7M7UlqvV7rN9eBnDy1MX9Ye8wgwAxQFHtI7vFUUAqAPbksB0/iByyytjzcUYr2+UO/VAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPFfczXO6aQtrJlHyU0VonSDBiXmqaUdRdAknMLYE0g=;
 b=CdWA5V8qV42lHsAW/+dmlMaGWXZnn1IFu+9/H1AvDsAQkxBqH/7rf/HC/nZ2XtoLJf4vnF5U4xWtyULhoRRA58uFb3UqLw7rYhQi4trBK0I/eRVQQ8PGrkHVDlnNCT7Eigy4w85fwrhVverOPXyQ99chKAiP0DKy1ESTUVbd8XU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6367.namprd13.prod.outlook.com (2603:10b6:510:2f3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.15; Tue, 16 May
 2023 11:01:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 11:01:01 +0000
Date: Tue, 16 May 2023 13:00:54 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] wifi: b43: fix incorrect __packed annotation
Message-ID: <ZGNiZtG38Kr5M2uW@corigine.com>
References: <20230516074554.1674536-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516074554.1674536-1-arnd@kernel.org>
X-ClientProxiedBy: AS4P250CA0019.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6367:EE_
X-MS-Office365-Filtering-Correlation-Id: dd1f70b7-b42f-46e7-faee-08db55fcd5b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	J4NEBrztmxxe5wA777h6Vd0iqf3lWa2Olj5Gnb0c0so2LbGdl1Wy0AnwuPzQQqA2mjWAj0D1DNhujb8rmXjDOopfsoBD7JWO79qm91FgNOqrcjjch8vLHbBCFyuO8OsSGaCBoevtG7ejaoHNobHzkq7T5tRAbIjpisz2XHA1xXe+U91RBYFG35n2I7Cn0orf03eP1PgdLDfAzgLaNxIXgh8M05m7ocHEMy6pMXoKc+5oFd9Eq/ghHcwiEGYLhOvI8WwajgKBe8EXv35KMU+TwxC9fcTDgsUsnN75HGJtzvD7L7rSGznC6OTT/TykKdz8eRZ2DWw1Jp3H33qa2XUMpj/QeTpU/SQwIR2Whs/L3HFIAdKoqSGECEtXEj3tL+ydxHp1kDZ5ZV1fodBb/mnd2nmt4kaayJCr4wCPYmaULEmvOY1T+3Zl/zRNSe3Q3AkJ4S2i3LeZqw8dEPaiKVf1Kv2GK1okFTknfatkQ8vjQ+ObpfF2LZe8zP43ELfcCNxwZMQpxu73VN/IasEHRHU5K6XMeKLnTVrwP1fwhod+/j2QNC9cNUIdF3zHCbVg4P+m
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(376002)(366004)(39840400004)(451199021)(2906002)(6506007)(38100700002)(2616005)(186003)(6512007)(83380400001)(4744005)(44832011)(5660300002)(7416002)(8676002)(8936002)(36756003)(478600001)(316002)(54906003)(4326008)(6666004)(6486002)(66476007)(66556008)(6916009)(41300700001)(86362001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OuoNnM5b2PD1zqkejDEok07By4V0XdsM92fAHBzoUPxrbmiY4TQGVkUKoifg?=
 =?us-ascii?Q?XoBviWkQ/HcrB+BJkaCLEZ+edEafyNaVsnrlRuc0aQ0r64JAOcWwo0so0naE?=
 =?us-ascii?Q?yu5puYBgHKJZwcZycEfksVnAxT8F/87XbNnBGgQc+pTbu6vQZzDE06Ky0bUQ?=
 =?us-ascii?Q?xgxCDDJRrxcYcCTzg5H8OtYDzQybBL0IygL0WHJGNESD+S8Ktkucl01kOInm?=
 =?us-ascii?Q?L5eeGiK7GWjkx/W2zMWW6LTam3w9GjJmhiMVYIkD586SgFUiWs6mrL1Jn9fK?=
 =?us-ascii?Q?AWIuzqP3gcZ1+mccGK1cSa90cp+2N06EW181uVn8AMUW/iQNKpXWy8O8MeBK?=
 =?us-ascii?Q?fhH4H+m8lhuKf9mNqrkdi66t9yrwMqJhm1Qm7IiFmiHgVuQ6a6R7uF3cm56Z?=
 =?us-ascii?Q?+DHbFkHWmYGwVrFEZiO/9Xe56Y02PB/qspQfLp9LMqQxvwIG3Shj1Zp1krVS?=
 =?us-ascii?Q?veg1he7MDRaNf+gurXkxQBCKUKfoRFArzn737PPHJ9K82B1DZC6EP6/fTDQV?=
 =?us-ascii?Q?nSXG1KeM9UEjgbzCAnydSBNgb2cZxkhqPIcPXsVVCoslowLtBIBPEyhxNkVs?=
 =?us-ascii?Q?Tt7Oj+Pot/53Cu5L7ZwDPcrd/3aGtrY6xFj0o8xjRt1w66GcekDkOk8hZiYT?=
 =?us-ascii?Q?gqwP9VtQ0jPybrA95sPUCwUBW8mWlsBp+sny5O1DWFhdEv9iCS45oNAagkcJ?=
 =?us-ascii?Q?uPyu2PZd3RJYYBd/3F43IAKW2QEPenNthNx9DRlSuwnfS/vXPXmleG0knSFM?=
 =?us-ascii?Q?6F1GkUuAB4uBu/gZwGQ80djoY5OceJwsINz3v5oUAAG8LdRbUqNbA3nMQXkh?=
 =?us-ascii?Q?WLOoKLi3IgV7sf6iYmLJD4wLXnE6u1N1YG2FhEmwL1+5kYXhK/2sLz7/aF+4?=
 =?us-ascii?Q?Mpk1C9W8fvxX2qdNYlFbXgIecpI4kxmJ2NL1S5jaJTDkXxYDtTt4TH3b0fiZ?=
 =?us-ascii?Q?D+lx/64H5Vrt093qe+QcY/jmo/XlFNijpHz2OwbZKpSqCx+3xzvFeC0i5DZY?=
 =?us-ascii?Q?Lv5zW5IZpcJjHEFcBw95Gdgkc6+D1vy+M8GvsrZQtZvMNF//hZ4tAOSFG0Dp?=
 =?us-ascii?Q?z7CIN5vVc3No2RKN8OkYyNjMpVmjrOjNALyaY+UmlSVBFF9PhjFMASp6qZKq?=
 =?us-ascii?Q?wLpHJJ0I00qDBowYncRCSflPcH8UrF9GMBp9WwS9YAB1zqtYQSjEBYU5bLj2?=
 =?us-ascii?Q?hGhxeU0nzgfGj3whpoPanMlbGtK6zaVlRohQRheBtWuvMq+iN5LLIkWEdEvh?=
 =?us-ascii?Q?ZgPflJmNlJAjwLRvnGSJZfRzueU1zBmo0KWox7igsKSmsgyKf2vuM0kNrfxE?=
 =?us-ascii?Q?bRyQoLHhKjEM7kCcAeR8Ug+rgL7ubMSHlhgKj/5ZCYklEzvDJGmfkxN/PFA3?=
 =?us-ascii?Q?0h+WStf2m98L3+KK3lbJEov4wfxXM3kLdk35X5gDZnVB2XBqVujM+wN87Fp5?=
 =?us-ascii?Q?Mdvm0A2Bq2RENaMe2lJMC3311yLdsOjedaQV8stwdn7CCaPdyWvtrXzREyKz?=
 =?us-ascii?Q?zCUvM7HxH3GnlereU5KYSFgOLu8FZN94zdM06jvWj8aTdNT5VWe27vDAOIsT?=
 =?us-ascii?Q?VRC1Kh/q2FehajNy5JDxcSKmUdLTDGmgvKWSL38FjpAmOVHeJAPBpY2sEfiO?=
 =?us-ascii?Q?EcEC0EiZ4Fe5xFHf5bdGeDqxP6rl7OAIxbsorHYFDci3alwBrt4LhIWVK19g?=
 =?us-ascii?Q?2fjmsA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd1f70b7-b42f-46e7-faee-08db55fcd5b7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 11:01:01.0655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvdLRinW8ZZk26eZSGrI0ZZe7vTAO78P6dQDbF0TDKx+PVQAGM1LnFwcnbfyrQ2OCIqFlUXy4aOMXjMKLJOmoIj3G/so5tsAVP8mXFUXpiQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6367
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 09:45:42AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang warns about an unpacked structure inside of a packed one:
> 
> drivers/net/wireless/broadcom/b43/b43.h:654:4: error: field data within 'struct b43_iv' is less aligned than 'union (unnamed union at /home/arnd/arm-soc/drivers/net/wireless/broadcom/b43/b43.h:651:2)' and is usually due to 'struct b43_iv' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]
> 
> The problem here is that the anonymous union has the default alignment
> from its members, apparently because the original author mixed up the
> placement of the __packed attribute by placing it next to the struct
> member rather than the union definition. As the struct itself is
> also marked as __packed, there is no need to mark its members, so just
> move the annotation to the inner type instead.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


