Return-Path: <netdev+bounces-11124-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBBD4731980
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 976B4281822
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0618915AE7;
	Thu, 15 Jun 2023 13:03:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B1B111AE
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:03:29 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2110.outbound.protection.outlook.com [40.107.102.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C23E196;
	Thu, 15 Jun 2023 06:03:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AhxMumBfl+WozhvewpMKwFjkx515XRcToCWboRxxwYjKGoM7MdOcEHurT+GGdweJoZYu4HWks3qfloRwzHs86xr7DLsBzhdJ6fuvyP0YhiaRlpoBBnzXLtYz1cfdm2eUSP+3jPbk+MFUVqswljNio3qy6h6H3dtovUctyquJ82ezyLR0DCkiGacAESv6V/+UwXyhX3FPvijGTIp5Za17oqHTl/frYCe8RFmOC6pSyhOhk/1rVKBP8JutTa7hmc4nfz5biY4jBeE8Sy2wv00PybHela6sMDSoXtl0GIlEZAwT7RgYYz3xsLNSiYFRiOhxeU/eC6EWWRljp37uQ4k1vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iEIqNAyUuAqS1FF6nqivzHYq/i3+fyAT2QviVPadQvQ=;
 b=C3AU11nzaYfC2EIi6xaAnVLSc6nkwH31SscLEIzhT1xWScKcLHtf9iGKzfLbhOtfO7IaZXOGHXxCY6asrnXZcj+jwicNVcu2qJOwwv30qfcrP1/Am+hzyJrk6EyBBQNRmZ4z9jFYiMpoDqiwDjfqS+zgOq2UEGyUdIthhbs5UHKRQeX6NL/Eln7ffWxj5Rvip5XqxuTWJmt96n+IpoqzdHEb9rZla5zlj84E0L6l5SS8Wg3hEAGk09+iXVG3zEb8dXhUutcLdcJ2w/zNIS94T+yZ8VShx+vNn5LGBf73xjHMHOEnJmkIBSlSJIs+TEtGed0Lv9E9rfEU7pmbRpZI9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEIqNAyUuAqS1FF6nqivzHYq/i3+fyAT2QviVPadQvQ=;
 b=VLh2IgpC4Iaw5k77pSO96vnl67/uUwFJirGoBTMJbr334Rjq+biKeWven8Tx33ZPUoK1yfqPdn4QJ6nJkmv7HXnQXDtK+sNKE5ps2ffDCZz21mKvaN9NVaYc1fOY3arG1X9MGB83MTlsmTXgOBZ1ZEL+ysmWQWV+dksJl1epCV4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4668.namprd13.prod.outlook.com (2603:10b6:610:ca::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Thu, 15 Jun
 2023 13:03:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 13:03:24 +0000
Date: Thu, 15 Jun 2023 15:03:15 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Wang Ming <machel@vivo.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, opensource.kernel@vivo.com
Subject: Re: [PATCH v1] drivers:net:dsa:Fix resource leaks in
 fwnode_for_each_child_node() loops
Message-ID: <ZIsME1gwEWEyyN1o@corigine.com>
References: <20230615070512.6634-1-machel@vivo.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615070512.6634-1-machel@vivo.com>
X-ClientProxiedBy: AM0PR07CA0006.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4668:EE_
X-MS-Office365-Filtering-Correlation-Id: 93a7784a-f065-4021-92e1-08db6da0e6be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QYA+RrofgZwclxSI9xmE0JMJNNisZvaa0J07Fy2jEwJDc+l5prlSilUhnuTLqz69l2Zn2wdLddComwDbgCvIbtM9YJGwQpgcJQcjsOOq49+GrKZzmoZPGbV2+4OWIT0ZlUXM6cEheqAJXqqHz+6ZCeifKBDjB+vjgrzAReb1gGjzlAie+hIGqJmocyiMvD24luXE4VUZwFdfamBSVwKct9EsHrKF2J+nagPJosDRNGtySw4b+M64snfsQpG2tbx6UyhJFT/8qwnyT8J96Bd+F3Pcen5v+fC0lvYwhreDwNsmpav6Dw6z86o+L48RG5kEzWgX2fJ7YMnRrnDgpe/lqLyzrIeeKgAykgTN4CUOFaEpVDl7am+CKg80hc1S7OYS6s9yuOd5GNuloOJJSoNoM42GzUL9b5D1IPSp6xed84mP88+tUgx5e9lhqhUTVLJK0GprcROwoI57vdxz7c9UIXm8D6AafllQWQ/mC0QYxPav/wGjjF6u2o3EjTmrJDQvTLYXZTHKeDlzGFpsjsUSaglx4uOgwWTrSj1qJTHMs38K2FqNvi0tABV3xWKIwnzdyJC5PVq321XEvl8d+Htrj+rjOlGhe+voOjKuMuXbPhM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(366004)(396003)(39840400004)(346002)(451199021)(83380400001)(4744005)(2906002)(2616005)(36756003)(86362001)(38100700002)(54906003)(8936002)(8676002)(6486002)(316002)(41300700001)(5660300002)(478600001)(66946007)(66556008)(66476007)(6666004)(6916009)(4326008)(6512007)(6506007)(186003)(44832011)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ivh72LCfCf1YRPEvEujM0WjKPDYYqbwb9TACy3C4mgbSO4YWzm2EkHeDNfHR?=
 =?us-ascii?Q?bD3yfrF0Ne2ciTqF/y1uYOTeK4+yUoaPlL546kFp+4f5Fb4iWqn/2XQOtpGs?=
 =?us-ascii?Q?NVQui3HO6WbfVMiNPFlfqttKvM/BvNu3wyL5sCGdr6xrap7bBKH6j3y6qjmD?=
 =?us-ascii?Q?GUCp6VkTMoIfxcz1bQRFB/k4QHF34rcw+0UAjgAdp1htFON5YbpH/tkN3CoM?=
 =?us-ascii?Q?5ZbKfCKyVRwshbn6MVtj5QuJpTrz60Kl7sjIfvCx5Is95tDjQgiFGQZOA25n?=
 =?us-ascii?Q?3zwnCgfGqmIatLFsCcQQ0ZokY5kPmQ96OlMxcGeEkWctEv+sr0UgjnCGvKiQ?=
 =?us-ascii?Q?pFqfVuqkLiDuJod9vOK0HUsUzynjEqllxXXxS8g5P4TESYVV8IFhe/B/q12l?=
 =?us-ascii?Q?uKeRaX7uvB5PoYMROl3kvlZo6uOeqD3c+nrAwnHNwBU/Ve6SXothFzXoNTdi?=
 =?us-ascii?Q?GTGx5ED3e+YTGdL4BwpeMZrYxaICtHYceA5xIFMh151Wz3gglDqSqsPqBOH4?=
 =?us-ascii?Q?1zvVa/jLzZ0V6TtLMPE1KA8jvV5wBX3gHiuk9BqNrjJkCFcY+lRwL57X73uX?=
 =?us-ascii?Q?EWnb49IjTsi2yg9oFOm0BbpA71q5To07L542ygrT6v5XhniD3oummTWyUFHf?=
 =?us-ascii?Q?rhA9XqBSL5pG9KmNOP3+rkEG+ikE6xuF0s4eAGzmDnlxB6lMH7/qVyUCXeJ4?=
 =?us-ascii?Q?DKe9aqbjuQzt/aUaaOoZb7z62dDykGRv7WKHuHjetW+DzrR+MVekjFKZTKhv?=
 =?us-ascii?Q?VHzpYkPcMXTJCxAiGvLecndLO1vFnfPxIsb4wYKRvmJGEVE4gV1gHIaWsCoO?=
 =?us-ascii?Q?Lx6Op+CMVbn4YBYyJA//s68bY+YukCiNcFRZIszMu6jrsBSJNmnWEp/3IbYF?=
 =?us-ascii?Q?6tjEFtcFaf5hdUFOOzzQc5J1VKbPvWyZsWlAHnoF1yLztBC9HIS/dvy3UHPd?=
 =?us-ascii?Q?A+hTjdi9lYbCWivU7/QfgANhJTgfc/TmHZsAtbYWtjA+iFUxfEtZTu3r9mzS?=
 =?us-ascii?Q?emPAE6WZg1MvXnkHtqnR5fjCRsZZmzoViANU+mUPmsToRGVdy1jK3zD9CyN8?=
 =?us-ascii?Q?IXhUbYijHVLbPTVr/+4gzIPNSgIsHdlWsvyDzrmdZR+l2bkdLPOrwOroGj2j?=
 =?us-ascii?Q?4zI+lKM6xEwI/AqayVRSVG2k73pltac8iiSD/Adkqyiq8T+9eOUaeokEMdAd?=
 =?us-ascii?Q?sg0ejJGe3VjijeAqmFWZElFjoARylGUufhFmeQts3FZyRObFRHD2R9I3qkKI?=
 =?us-ascii?Q?/PF38FcUWhjkQjC/0tu+g6CSAMJxniKea/kDQyf26jlPDEhI4ljcYhOegV1C?=
 =?us-ascii?Q?Uf/dKpxZjL/rPwmjvNVDUcek43e0i7b1HEvY/7IAyhbLuen/YLLypPLMlLp1?=
 =?us-ascii?Q?1BY5UrHspfIdxIa2OnuZWUUlJAeSG1MU2PiyiWnvpZ0yzeHqPPaLtvguW5lO?=
 =?us-ascii?Q?XjN//8i4pnnbGmeEDndUh6HgDPzHDSSMCe80NQ+h9wL/eni7mUcbvYLVHiLl?=
 =?us-ascii?Q?EHjQBmbaGgPTd+q+604mXEnl3qLTnJFlPTpKolG+RK6cZXXH8U+L7Gxote6N?=
 =?us-ascii?Q?JPZimAX7g5xGC8iteyJnEty1ebLI08Ck9nO2un4h9nBaVF24ClD80pbo2ixG?=
 =?us-ascii?Q?Kc1vrw6c7f/ZtTRHlZDH4F0c0htKXLofJWI/lz5FSLUhi0pZKFtYlPH/Cz5o?=
 =?us-ascii?Q?pGcfrQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93a7784a-f065-4021-92e1-08db6da0e6be
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 13:03:24.0144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1UeRvtf0GWAYKfx06CDTpXipY59sGF0wf/iqW8iZgvqA7rcOJN6hv+FY1l4UoHsAGW4BOQsYJVdo4D9IJPCchTFdUfVcVJ9q5ocTYd4YNq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4668
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 03:04:58PM +0800, Wang Ming wrote:
>  The fwnode_for_each_child_node loop in qca8k_setup_led_ctrl should
>  have fwnode_handle_put() before return which could avoid resource leaks.
>  This patch could fix this bug.
> 
> Signed-off-by: Wang Ming <machel@vivo.com>

Hi Wang Ming,

unfortunately your patch has been whitespace mangled - tabs have been
converted into 8 spaces. Possibly this was done by your mail client
or mail server. In any case the result is that the patch doesn't apply.
And unfortunately that breaks our processes.

Also, I'm assuming that as this patch is a fix, it is targeted at the
"net", as opposed to "net-next", tree. This should be noted in the subject.

	Subject: [PATCH net v2] ...

Lastly, looking at the git history of qca8k-leds.c, I think that
a better prefix for the patch is "net: dsa: qca8k: ".

	Subject: [PATCH net v2] net: dsa: qca8k: ...

Please consider addressing the problems and reposting your patch.

-- 
pw-bot: changes-requested

