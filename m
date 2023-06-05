Return-Path: <netdev+bounces-7956-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78995722351
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3CAB1C20A06
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CFFE168AA;
	Mon,  5 Jun 2023 10:22:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC2E15494
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:22:16 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2120.outbound.protection.outlook.com [40.107.95.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71869A1
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 03:22:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5grrE1mpXYzwaOiHj0PF/ZBDhzLMH8fbSfR2wCh37Y/8fbUfF7Sklny/ftPj2Z4/fU5FcJgq9/5CBEOjhUbz/Mt/+5OwYIXfEwj6yDKbzAOPo1cdoHxJXen1/f2YCAk4CA4wU/j1jAit/gFtb9Xcp0jiWuFcuY5alLJ/P7s2JrW51UvgccbUdUQnTefkWg7uIJuF3B8ojcFzFA8QrIplrqbDNXoA12nHFyBw9AY2H28ohZZwBbNXmGn6lpCjZqrx/A8UczKkEArzeUl5OkROUI1oWbYvpMGLW1mCxQNhtMt8BIT5WMizhWLxsTzdCzO3qCwUddmOpFiLW5Ob86q9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4RkOY3nLTYQgLFhW5q2Fg/0d6zjUtnDPtd+55OMqZAU=;
 b=GVePlsISN1zalxwfrxvxTyYUmDHNhBwrh2M8NQe1t2JLIrjJd2a5rLyAoDXL79FOJ1j4ujoLqg5aRQXMtfi8ddQ/GrdZMkQOZzZqq42fPglcbahmRDbt5FUCgpxTOWqouvZXVvKg0aXacTCPG/HMsbAKpcHA/8UlQIHVn9WYbmCZX5uWvRKV69A0lE7xcbaGEqbYTxCuh/9/tKXS6jWx785SgdTfNjl4VpfKVe+kDim/vKxvSK02wXBFQU4Zhg8PqqzS2jN6QnVtU/WTywi2Zdp76X6aLUhpIkt3ungaKAdD/nZL0FupFgDW++CqllrT9nb62P/DLJpRe5Ogt760Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4RkOY3nLTYQgLFhW5q2Fg/0d6zjUtnDPtd+55OMqZAU=;
 b=jAKqFQ3QHmufDrn8GSIMuyL5e9ooHvelL3n4NyKPOySGGO2Q+Q2vHYUcTXsyw1yqJySbjwLRVlNp6/8Sn1V4OjCg75eXBi8Ns2emYgmyObyzHybtRPMlDWU8QPwgG8W66ocXXht+tboTS6bXMoPF7boqsHYs2J5pqkZif9DqFUI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4648.namprd13.prod.outlook.com (2603:10b6:408:116::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 10:22:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 10:22:11 +0000
Date: Mon, 5 Jun 2023 12:22:03 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, kernel@mojatatu.com, deb.chatterjee@intel.com,
	anjali.singhai@intel.com, namrata.limaye@intel.com,
	khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
	jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	vladbu@nvidia.com
Subject: Re: [PATCH net-next RFC 13/20] p4tc: add metadata create, update,
 delete, get, flush and dump
Message-ID: <ZH23SwFoyHuQ4AIx@corigine.com>
References: <20230124170510.316970-1-jhs@mojatatu.com>
 <20230124170510.316970-13-jhs@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124170510.316970-13-jhs@mojatatu.com>
X-ClientProxiedBy: AM3PR04CA0139.eurprd04.prod.outlook.com (2603:10a6:207::23)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4648:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a9fca37-4a4d-495d-e972-08db65aeb940
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	25nK3vMWdEvTv7SD9VE/MAjbINHc7G05zvDszqsaM4JNEHVggafl8G9ELj5Tj1meCr48ybG8LZ0xLJkIqQ0MmpqujkHblzrD9XtW21R8josdZJ9L0AiHAXNlpTDacD5yIsNhtZY8FfBwyW6k9SlfyC2SXtZ3EaC6Qe2zpCY/scFIQBpjq6GgeWnSR28bdZxEiwWf6f6qzTMYn0BXGOsT0tsfJkFmHQQ7lWRj/OX5KS4y29WouR4kDucgbuz4PwYpqB4QnKDH+6jPQvoF/+8A0ytrgo8RDYqZ7hWRPWocdXXgibA79jcgWiFs8bI5ASCu/9smAlorZSMn0u1stf2KwnbYB/hR71TmmpCQ3cE1ZczvW5WkrNvdRnBHW8re8/Ywq4KfutvsC5ulMYOkyptOECmYXNp/czwGFK/WyD4ubICCRDemTZQJxKCtG8ThX3gYvcURMzWFSjI5Hjq0vlFOULwqBVY37F182u72wH4RZ3TY03aBSSudoBpaXpD5ZiJujvw70x1xRbVaFBm4scQe33+07CnrlKI95eWPxzKzZTz4KYLwDVsRsNjsb67oNEc75mTBYrqo7opWfUciaZTVayc1lNa+lrt4FPwkU7J72r7U0btFgqY6piqwIFYjrgABPj9lBsz3IJz2Y9vU7kVgbDcC+Pr4Zzap87Iljh35ww0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(346002)(136003)(39840400004)(451199021)(2616005)(6512007)(6506007)(44832011)(316002)(6916009)(66556008)(4326008)(66476007)(66946007)(6486002)(6666004)(186003)(478600001)(36756003)(2906002)(5660300002)(8936002)(8676002)(86362001)(7416002)(41300700001)(38100700002)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1q/Ga0gASvWAMvlc15Pqfzs0OI8NjcuRxxqKkC+s3wkm1SBhyUPZDd8wPwsS?=
 =?us-ascii?Q?NSdOzTihNhyAQXEitrXI7kkTjT1Ey4VYFqibdkziSR0RJ1AXpqRc9nYGmRpp?=
 =?us-ascii?Q?sXj1pc+JcwJ+h6CGtGphV44iYcl7jr69ndDuVz5EAifpDlcvhnS+q9ZlSsmt?=
 =?us-ascii?Q?LO1t019gcfgbCX/XulWELUvrC9ljekfzScK9HQNvJXsUJZiG0tU8VAOa/cgm?=
 =?us-ascii?Q?D5JkUlPYvy1AmBYpHv+Vu+uhfP4HgQwVHs9vvuXc5W8n9OPE9oL39bpviaI8?=
 =?us-ascii?Q?euA+pyAC+mESVgyPj4B+Jb+yn2ykKpVbPHSQATdfky1XzgquGyuTPho5p+jB?=
 =?us-ascii?Q?PCBRK0ywhONeEnGP3NLxdxX/uuLVa7OnOVvEGjQZidGiQXvzg/CH/vvr1xOh?=
 =?us-ascii?Q?r1wBpWXxUb4u9pKuUp5Bb5pVsRVGgax1XhsWzVI7p/e66mUNuLVrdzjg3G3k?=
 =?us-ascii?Q?m0cZndB5pAjMkFQmCyqSX8MDvi939py2mhmNRHpbJ0AirA90DI+s0hUdk85p?=
 =?us-ascii?Q?E5K6OiuPVaWxbMr1PoMHACeQOukZ0y8pwTCxfo6VZkPKUCWC3NBk73si4mtU?=
 =?us-ascii?Q?mCLm2dibUUroOIKpLauW+JPs5x69/mPCHajglMf8LzeZhgiXo9esNpGao/cl?=
 =?us-ascii?Q?hypQnKib3+6Fs1h3BhVEvcepo3odZK4VqIm65bgu22mq03DVsYc56kWN8pJ5?=
 =?us-ascii?Q?wrl3g/eNyCcfRTAacsja3vXZrYu25SHvOrBRZWgLs0jbSwXtqrAhwhVXtJT1?=
 =?us-ascii?Q?rFnIsZnSrruddINAo5gX1jqCQijgYFnL0CHguVYD7YYOuIxB7xubZJtCHQax?=
 =?us-ascii?Q?tSDwtdNUzlGdz9roThOuTTNeTzbi8NjN3LGSJyjU9Ge1Ho9QgIE2lBpJVS98?=
 =?us-ascii?Q?zUyMp0BNwOs8uBwyZwthS2DYNXtgOWKNypvFxy6P5DfRHaC1CjWo6oYz+J4d?=
 =?us-ascii?Q?st+IgrdR6QYxmkvT6E8NMNYoiYvt5M4tV33k0h84msh2/U2FtCFydsA6NVRQ?=
 =?us-ascii?Q?czgrdN64LOtOPKFg6ik/UCIOkycr1vh71ms+IiQaQSFfgzfonB/hXxu6ysw6?=
 =?us-ascii?Q?W+/AJOVqwdDSSivFeawGFKekIGKzF9My7rYmJbqq1BqIYtmgFp25m+YV/Sql?=
 =?us-ascii?Q?Jpd4ViMevbGA23BDRAJPja/1wtTM9MjVbxngmghaOC+tGNjtQAVNDQZjudTI?=
 =?us-ascii?Q?Tltxzit8M92RL9dudUn5skIiF/C7OftpvOAZuU5/BRoYNfDy+lVr0PZi1Rr1?=
 =?us-ascii?Q?fxuhsyG3SHDorKmWVYfop3DBwCuPjaRIRT3g/J2ePcH5MfLKYskAn9uRYa2s?=
 =?us-ascii?Q?kUND3TCoQowfsKkWqKY8HaWc3RvvMcoHBR8/qgslatE0yF7dV6nSKmpJPELV?=
 =?us-ascii?Q?lpjqrsCxWAeiAy/7zkyjP2eVB6KyRtFXvte9GuZdrTOkFFABYmdmHaDQskoU?=
 =?us-ascii?Q?hzEIqwJZLmKgk4WvMZNV2UrHprXW8UH3Ytj19YWnpqNpmOkrYUiDU2RxOzu0?=
 =?us-ascii?Q?guWboMQKldk9l+r9JAyaD6wfvNF1TZynSL7JMEtsID6hdtgZyMvD/nAUIysX?=
 =?us-ascii?Q?rEIwzkA3M3Ncv99fVOCOwefwbnfawy9C88g+5u6rHheBGoNzXbNA3r/pC+cQ?=
 =?us-ascii?Q?To4ahXulduKFxa8ze/kcYbl8FqtvNWKWRRtsCdJj2uksxgLJv3o9XFyIQnmJ?=
 =?us-ascii?Q?O/XXRg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a9fca37-4a4d-495d-e972-08db65aeb940
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 10:22:11.1181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oPu6wgtg3cT5wDAhkQWqi01Au3CpsvxwmE2g4jAurv0L/ha/E6LxUfU47fOs2BM5t5LldhDLXL9SKutO8FkHHHjOAnvrKFjZXSCDO36ayQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4648
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jan 24, 2023 at 12:05:03PM -0500, Jamal Hadi Salim wrote:

...

Hi Victor, Jamal and Pedro,

some minor feedback from my side.

> +struct p4tc_metadata *tcf_meta_create(struct nlmsghdr *n, struct nlattr *nla,
> +				      u32 m_id, struct p4tc_pipeline *pipeline,
> +				      struct netlink_ext_ack *extack)

A gcc-12 build with W=1 suggests that this function could be static.

...

> +static int _tcf_meta_fill_nlmsg(struct sk_buff *skb,
> +				const struct p4tc_metadata *meta)
> +{
> +	unsigned char *b = nlmsg_get_pos(skb);
> +	struct p4tc_meta_size_params sz_params;
> +	struct nlattr *nest;
> +
> +	if (nla_put_u32(skb, P4TC_PATH, meta->m_id))
> +		goto out_nlmsg_trim;
> +
> +	nest = nla_nest_start(skb, P4TC_PARAMS);
> +	if (!nest)
> +		goto out_nlmsg_trim;
> +
> +	sz_params.datatype = meta->m_datatype;
> +	sz_params.startbit = meta->m_startbit;
> +	sz_params.endbit = meta->m_endbit;

There may be a hole at the end of sz_params, which is uninitialised,
yet fed into nl_put below.

> +
> +	if (nla_put_string(skb, P4TC_META_NAME, meta->common.name))
> +		goto out_nlmsg_trim;
> +	if (nla_put(skb, P4TC_META_SIZE, sizeof(sz_params), &sz_params))
> +		goto out_nlmsg_trim;
> +
> +	nla_nest_end(skb, nest);
> +
> +	return skb->len;
> +
> +out_nlmsg_trim:
> +	nlmsg_trim(skb, b);
> +	return -1;
> +}

...

