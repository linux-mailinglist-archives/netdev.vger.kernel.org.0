Return-Path: <netdev+bounces-7947-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73AD47222F0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:08:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D15951C202F2
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA2C156DD;
	Mon,  5 Jun 2023 10:08:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0146156C8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:08:47 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2100.outbound.protection.outlook.com [40.107.101.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8C9E9
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 03:08:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M7E7E6L0yPUwYEvVPAbrafpEwSuXdnaUytjZa8k6B4qCuynd7x7rsc5DDsxbtVW9sz49875Myk3BYE6o0E0Q1ffOVF8o2e4hJmoZRdescDnEw9bjXw3vOAlTQlqGZHvcq1hPDlP+1taHlPtQ/7/b2A/oWEwysn1fEZXv+hC0FxgCfsSXt5fVKk099YdVFwwT/iLnXZz54w5xtebUd9aFsyG95BV4HI296WVqB2JQ0WRfOoKS4zHcFz72DFdGZuPXhyn+vGdQO/Z6tyNZ8A8VKYhXayfAEI3HEvPl6GBSGi7Af0WVIAH/BrAtVdeBAQPe6GNe5a0AzQcZApCGgJbjjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jgxDgLiEyEtoHy4sSSHgbHRWAMver5RAl2Fc3bhETRs=;
 b=N/emlb8QFNCg5hd2oyNQYUkgnkyuvMLA2iRj5UY7B6/AuUtIMtHlDuBa/fk+7Q5smTcMmmcK2zgNLiUV+b5Pjo1rwVp8eOYPALQyIOQXmXZHasb7pW+lDRbjRIsiWhtWP5o8zeTD908WDnQKzElCq4aM0b0bXK/uml/QblNqhOu0iZietqknht5JMG+dM7Vx/PfOu77Frjss/bd79ApsS4ZAIfMJWYW+pjlO4f7TLKTUJ/+GHoYrfb7rGzUjKkbu0x4rpV4948J4OCPutXJw9T4qTpxNV0+nwF+NiCCLq/YThQY8HjEOLllMK2TA8j4gTlD2X63R67cpRuXqRT+bbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgxDgLiEyEtoHy4sSSHgbHRWAMver5RAl2Fc3bhETRs=;
 b=eQfqcBFSG574CgACnljs2k1Vh6gNviqd39Y5lqwNiMwTqxd/4RpDAnKMbpedRawa1ncCgQJiiIbUbehAIBYONYmuV8dLSSoobBXMq8JIcfbbNJM7SSd5c5Tbpv9uPKg0mhotn1Hc+xpslo45hNjsCL4C63fXVU7ZIhU4o/OKm2A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6534.namprd13.prod.outlook.com (2603:10b6:610:1ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.13; Mon, 5 Jun
 2023 10:08:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 10:08:41 +0000
Date: Mon, 5 Jun 2023 12:08:32 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, deb.chatterjee@intel.com,
	anjali.singhai@intel.com, namrata.limaye@intel.com, tom@sipanda.io,
	p4tc-discussions@netdevconf.info, mleitner@redhat.com,
	Mahesh.Shirshyad@amd.com, Vipin.Jain@amd.com,
	tomasz.osinski@intel.com, jiri@resnulli.us,
	xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, vladbu@nvidia.com,
	khalidm@nvidia.com, toke@redhat.com
Subject: Re: [PATCH RFC v2 net-next 09/28] p4tc: add P4 data types
Message-ID: <ZH20IH+yHMk5kAcb@corigine.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
 <20230517110232.29349-9-jhs@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517110232.29349-9-jhs@mojatatu.com>
X-ClientProxiedBy: AS4P250CA0030.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6534:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b02a50a-08db-431f-5d60-08db65acd6cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GP7CB3KowAX4AGjYxf7ocCb3+t21Iv/scEbKGDFr8zaCMH562Q37GYfuHpTpfGsi2R3sTKU3unlbES4rIydh8V9eeyi7suSxNw/cSI483MxvSHP5Lwdn7DzGkzuueWdciCdRjEjdlzuztUFgpS0UM/f98cuO8oOzYq+2qmQEv1lXlrybvNk3oAI3TRkMLG2J5QlaskNjEUDMsO+Bd9va41XtwNRWTupw0nPW/M9F9aqBQliSA21bdZ7DM0TLhh3ZeUbW7CCRpdDGDBzkgq5PMd/z3pyvEH62jiXq/00EpK6NFrEZrY0r0MfBm4OJDadeMMyHRqiNPMjQMEUxCoI9Q+2MtwYsBnI/zTtEzFf2E7qpElsq95nXVqXOFb1ooi8BxmKqhPZ8IhVGjuc7Q5/Z2Y122cvamHZUqZF5/wA5Izsxpf6tQxjwXAoK2ahSe7ncl0/iG5eD8DJUiZOLuwvPma8GyOmLfy6kXOWkKMnFOHHfmNcEvdT7SS22S3ZZPNCBAZvGta0TzevuvFV4ADlQNDEuHTR+hI1rqPPi5TDRgcICUFW7a3W7ajTisYirHDIH3N8ZHjoVAvgkeBBnJVH2SObOKRuQ2/an2LcTFTpMiOyYDRBzO61K8c2Rpx3WA0CgyvL97ZI187C9re1s/LQLc6Q52pkKMGnyh0eoJuuPq7A=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(346002)(366004)(396003)(376002)(451199021)(8676002)(8936002)(478600001)(966005)(41300700001)(316002)(6666004)(5660300002)(6486002)(186003)(66556008)(7416002)(44832011)(4326008)(6916009)(66946007)(66476007)(6506007)(6512007)(2616005)(83380400001)(2906002)(38100700002)(86362001)(36756003)(32563001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?13B/RsFaCNY47JUz2+4Kvo19mgM5jH9YYFzAS3UwBy8P4u7OWEM+fKc4jbSb?=
 =?us-ascii?Q?A8IMdpT/yOuMcXdqukKCqkK4pt8DF+sCC+/DpW2+f1OPsr0V0Hjvlv7l0LjR?=
 =?us-ascii?Q?Rdok9mLgL02EspO4cC/+Fek4RJXJFmQEA4kohtxiq0ywYtgjlYKU57NEg1Q2?=
 =?us-ascii?Q?sTdVUj3Gg30oBbyA1Yg3fQ6ACsWxENnogn5b9UsxQCo908Elmhcwi5p6IsE+?=
 =?us-ascii?Q?Ms88N2d9VfZiufv4VKLjPdWzU1tlGWo+T8hgFUubqJDALRgsohjqOhdL1MGf?=
 =?us-ascii?Q?Wikca/fHyV9P4GV7GQ57Tjz1QB3YToEhO6RcVG9ddBHhALvvzogeoooEvvx/?=
 =?us-ascii?Q?8QKPXEP4UxyTQlMRl/xNrWeXGkCDZlaE5BT+V/SEa1hD1utDBIY2PY73j0Wq?=
 =?us-ascii?Q?oySsHEsHrV1OtqKboC7NkjsXATqaEGTy3wep49ETdQNLhl1HwMmib2EeHB4V?=
 =?us-ascii?Q?FLQRrTib+gu5ENZU0tjQl0vGTiawz4Wb8iQ3H6BVokaHjDeqHQ7DJqhV1HOm?=
 =?us-ascii?Q?5vl91SuRTiKStINYnwHWh36o35YfXf/tw8nhuNRTUIXJ7OMpTCgyk4/5mIcl?=
 =?us-ascii?Q?302ccRYUzpXTU6J220Tv+jnMC1reOJzXkm4hLcB47dD86FapjhGeg+URbF+V?=
 =?us-ascii?Q?ucaXXKnOfznzYwR710Y29rBGZkgTwX3nzrJ9agIB8cOu9t9Xg/kyJbY6jAEH?=
 =?us-ascii?Q?8hzxSsWjRFeCTsFhg4/TtOZ0T309LA9obP3lfmXXFULmTO1/G/kV3XjUXyg1?=
 =?us-ascii?Q?iM4d98v1H1IlccnQR6uYDnlslcoQZF5Z6W4zj/FlEutEUGFOxMwJpLIPjZwC?=
 =?us-ascii?Q?eavQ27Nk9D2OkUfPNgZPLQ644pUO6iKJcJI+JCYDwWoD6iLYY3oTeNjj6/pl?=
 =?us-ascii?Q?wvg59h/GcFZj05XfpW84ROYSigEiwJyny0FZXk48xHjMsI8kqa7nQDR0NdYt?=
 =?us-ascii?Q?1yHswxf1yRydOQhrLxUHwv75mDn41ImcRc2npRQaqIL86hAU9QtneGwInubZ?=
 =?us-ascii?Q?CBJ2yYS48UysWOpae2ibRqYE9VeK7yI++BEw8Y+lBgDPYGoZE5W2Di9HjJow?=
 =?us-ascii?Q?gB/HJmxvW/eau+zZPflpq4HQqPninw5QTgtBsSXqMd1HhogJglp6F94N2Dop?=
 =?us-ascii?Q?lOYTMC8IZVz5yCXpyFzfRrIeiYVb6SqSz8gd5PUaOvo1112tiDT0Gq0NJMnZ?=
 =?us-ascii?Q?vDz3UHRxVqkkqkkOqfWvS3+oktGeuUnHXwOOqPZ5jLGXFKWa+/7de7LAQvns?=
 =?us-ascii?Q?yaGtfbsmQvz8Lcia3Qu0UHbKWx816W7eqZZ57hYuLw18/uUYm25WXD+ECqs4?=
 =?us-ascii?Q?Y3YRQBxXxUrFUlmFZP6Xt247OThjAQXD9MVBhzzhCAPdT81gk6XJMKgaazB/?=
 =?us-ascii?Q?xK5RiyA1aQJMFz1FgYB5w2izpaiR4FcK2OOeE/cR7rmYStoXRhq5o3DgSFTR?=
 =?us-ascii?Q?PmsGil2R3kccWKorBEimZNwr67tptu27aEVGqhwzlBYoPozcz3ekNKADNOu3?=
 =?us-ascii?Q?YwUo7FLnhSxcN0kOBTOCFczN+wGP0/9GouzdJnMqhXueQw68xSUs3dU6QFdU?=
 =?us-ascii?Q?t4WOg9e8dQu8iwozmo1sI78RVODoudrIdoVwZNAhhO+FGsVg11FQaIMfssLL?=
 =?us-ascii?Q?BPUZJlK+QNHjvk/g6DvARyGlRRzI8Nz5gp0252VMquuz5cOQ2UFw7FWlxARC?=
 =?us-ascii?Q?NqvpzA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b02a50a-08db-431f-5d60-08db65acd6cb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 10:08:41.6705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7HEfndtxG72Hh6QRLN8wt5atlaZtp0UnshttbLY4Mb2awKfRZM/aDq07jXcq+JjcVAwgq2YuKdBlyaC8F+yrv09trVxRvBymGIqDDBw7QiE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6534
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 07:02:13AM -0400, Jamal Hadi Salim wrote:
> Introduce abstraction that represents P4 data types.
> This also introduces the Kconfig and Makefile which later patches use.
> Types could be little, host or big endian definitions. The abstraction also
> supports defining:
> 
> a) bitstrings using annotations in control that look like "bitX" where X
>    is the number of bits defined in a type
> 
> b) bitslices such that one can define in control bit8[0-3] and
>    bit16[0-9]. A 4-bit slice from bits 0-3 and a 10-bit slice from bits
>    0-9 respectively.
> 
> Each type has a bitsize, a name (for debugging purposes), an ID and
> methods/ops. The P4 types will be used by metadata, headers, dynamic
> actions and other part of P4TC.
> 
> Each type has four ops:
> 
> - validate_p4t: Which validates if a given value of a specific type
>   meets valid boundary conditions.
> 
> - create_bitops: Which, given a bitsize, bitstart and bitend allocates and
>   returns a mask and a shift value. For example, if we have type bit8[3-3]
>   meaning bitstart = 3 and bitend = 3, we'll create a mask which would only
>   give us the fourth bit of a bit8 value, that is, 0x08. Since we are
>   interested in the fourth bit, the bit shift value will be 3.
> 
> - host_read : Which reads the value of a given type and transforms it to
>   host order
> 
> - host_write : Which writes a provided host order value and transforms it
>   to the type's native order
> 
> Co-developed-by: Victor Nogueira <victor@mojatatu.com>
> Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>

Hi Victor, Pedro and Jamal,

some minor feedback from my side.

> diff --git a/net/sched/p4tc/p4tc_types.c b/net/sched/p4tc/p4tc_types.c

...

> +static struct p4tc_type *p4type_find_byname(const char *name)
> +{
> +	struct p4tc_type *type;
> +	unsigned long tmp, typeid;

As per my comment on another patch in this series,
please use reverse xmas tree - longest line to shortest -
for local variable declarations in networking code.

The following tool can help:
https://github.com/ecree-solarflare/xmastree

> +
> +	idr_for_each_entry_ul(&p4tc_types_idr, type, tmp, typeid) {
> +		if (!strncmp(type->name, name, P4T_MAX_STR_SZ))
> +			return type;
> +	}
> +
> +	return NULL;
> +}

...

> +static int p4t_be32_validate(struct p4tc_type *container, void *value,
> +			     u16 bitstart, u16 bitend,
> +			     struct netlink_ext_ack *extack)
> +{
> +	size_t container_maxsz = U32_MAX;
> +	__u32 *val_u32 = value;
> +	__be32 val = 0;
> +	size_t maxval;
> +	int ret;
> +
> +	ret = p4t_validate_bitpos(bitstart, bitend, 31, 31, extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (value)
> +		val = (__be32)(be32_to_cpu(*val_u32));

From a type annotation point of view, a value can be either CPU byte order
or big endian. It can't be both. What was the byte order of val_u32?  What is
the desired byte order of val?

Sparse, invoked using make C=1, flags this and
sever other issues with endineness handling.

> +
> +	maxval = GENMASK(bitend, 0);
> +	if (val && (val > container_maxsz || val > maxval)) {
> +		NL_SET_ERR_MSG_MOD(extack, "BE32 value out of range");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}

...

