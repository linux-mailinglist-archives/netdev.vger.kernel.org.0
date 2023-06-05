Return-Path: <netdev+bounces-7957-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2251D722360
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:25:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCB372810AD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1960168B4;
	Mon,  5 Jun 2023 10:25:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAAE154A4
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:25:13 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2105.outbound.protection.outlook.com [40.107.244.105])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA623ED
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 03:25:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MN7SZCeqYC27ku/Z8lQv/aj188MJakDYHWUvRvM3vWGO2VIfMh3XZjVTPBzcbF3xrX+vGIyQzGW4Gw5twLsNlWohhbjDycvvOrBa+mm0YXdDAUHnCBjJlVIO5765N+xiTTXhrjIYIqcSfJJ5tbg0et5eABnuyiwKKxQGMeNsAEuGyuE0NfhbwWpEtAQCTIp7d4coBWglepiI/Fzf0/xl3So6LlGXngVDHd1ppA/OVhfOFGXoXY3RbxfYmdTWK0pAiN32/eq1PNj4Z0no8iXZmnybjlhy3ZrL/K02w8bgJcag/gVOidWmT/7j+XGvNXPynyfRrfiCUsFeKQKglYw6/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5StSg7iljoD1BlJQOuyrLbN1zbQAK0ymY9x9zS5wQZ0=;
 b=c6TJQDW44hzzdftU7C029Ec0B4G6bjc22Hl3IxSwNMEg4IbYsWd8QkUAlgxNJ4sspxtiuV+TFccZYtLPEg8oGnmB7NHxCLC63lLH6NXJfh/reUXKRnCUU+A8ULzNQ4420ojl0AyYS+Tb+3qNBdx1wz7ApH6838scXIkrVvPrzZCGKpw1WUOQtQi9c8N1D4f7TGQZoHscCofxnEL7V7Gx6XFQs79flUJKLqdadbd1iDUShTXPzom8MIz+jaKIZ3p9QLcNZSo+nF7FPLCKfo6qz+Jcv4TyChgJNrujrNctzUhORi+QaH27YHV33g+VI/kh/6CNjxZ1ZwpI6XjHViNUAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5StSg7iljoD1BlJQOuyrLbN1zbQAK0ymY9x9zS5wQZ0=;
 b=Cq3tsTBTCy7QbmoGj8v7VrPTQB8I/uHq3iRcbr7CoYrfYoZH0OLx4DPLgcHJ9d/TDhCHfLwvQDtutmTeIDG7eABhvBh4ubKuTfGYE7+HM0qqtQ3rt2Yf4KpU6s9aNdnbLNiM+6k3cIYKRviSTrust2zi43YVeBSNL8uj+DUC/z8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4648.namprd13.prod.outlook.com (2603:10b6:408:116::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 10:25:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 10:25:08 +0000
Date: Mon, 5 Jun 2023 12:24:59 +0200
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
Subject: Re: [PATCH RFC v2 net-next 12/28] p4tc: add header field create,
 get, delete, flush and dump
Message-ID: <ZH23+403sRcabGa5@corigine.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
 <20230517110232.29349-12-jhs@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517110232.29349-12-jhs@mojatatu.com>
X-ClientProxiedBy: AM0PR08CA0002.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4648:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ac2e8e7-e06e-4b8e-cf1b-08db65af22cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fdm6TTnLbVC4LAPkn26xTozULFJW59SWiK95j/USy4C/ZdFnQOUqVK9tWvAJKNmjCS6wcb7dw1SRgwKacKuJ4x14jSTErzvA3ocNHBYDgYVai61xKgCm/33GTnNAt8aiDQ+0KewrJTI5wv2MlyD0X+8m6gdkmCz7zqNG2YSdPDk+oZLMeZlE9h/na9u+TZlZdy30n0vo/JfdLXU4Eonh9lvRnuo8a1G123slc0w94XkXj+jX6frWWLjyFz+hmmpiUSfKQeiw2+m9ouB99xetkvesntIxzcayhxCuq0nRk3a6e2Lwr0TYsF557JZrLhnsBbEGLwbVS8WmASt1Xv4aabp40fJCO92S+lb5HlZVBgncLqyVX2QqSSX8OaBMTKrRnuDc8HMnvo8pyJHQaOyzzmVSbjDPwJRlzFpE/7si5u9qo4AEhyYbKTtTNdXhvRhS5kWgzPQ10FGIchte92rqDA+xKd8PvRMZ7sxx3pawPw2WI1gMeAMg1guUjofCTVW82YpBDjUhP9DSsw1q5N1B083G9P1IDIdc3MvYcg7OrdvCprQ+l0EV05sbamKjvp0m5nAa7P64Amh87NJZS5bCMXGzpIkwjYomEhEPyIEL3r4PkIVJBMsOZt98SkCas6gPNkKQOw+CSgKhKLLUD4ocPUqfLaB8+0D+lOWztPuAe3tyM3E/g9sXZESrYlEaPK71
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(346002)(136003)(39840400004)(451199021)(2616005)(6512007)(6506007)(44832011)(316002)(6916009)(66556008)(4326008)(66476007)(66946007)(6486002)(6666004)(186003)(478600001)(36756003)(2906002)(5660300002)(8936002)(8676002)(86362001)(7416002)(41300700001)(38100700002)(32563001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VEggXJGCasvb9qIqPL49Got0AmMIt/yXcQQ+fAl7THF+qR3DLpJblesG4cQ/?=
 =?us-ascii?Q?PH48aTQzKxDnWaG10iPyT+/Koat7zshcuEYkqfUSuBaHekorV6aASA8e41oc?=
 =?us-ascii?Q?YlRKfp8YjVXWRv/PrAg+Q4bnOvYUxDYKt0p66Lj5NUFUhhpd9d4tBj01WavR?=
 =?us-ascii?Q?sFbwKqleFHyO8YlfH4rweb/dO+yeEaqV0AkHhg5R4pRV/jN/5QTmIynzju3W?=
 =?us-ascii?Q?WnELAcQ2Ov+wlZhNtyijcoQZqJxIuTwU8tc/ZEDWSfrfm4cSysdxx9EUTz9t?=
 =?us-ascii?Q?vLAMNrqzYeIE3toEupZuiO493+ZAzkBQtka4ntBmBQYrKVEO22HHp4JPabsA?=
 =?us-ascii?Q?QgAIwGzJQIAB7VH1Z8uur12DSOf40b97VaSXhQiMLgTYdXpuf9MyBewDDvfM?=
 =?us-ascii?Q?HuWBiPSfE1GgZTHrdMG+TmkRKQ3lTuovOL4DBGyXzT2/uypqalZfs79KX/WD?=
 =?us-ascii?Q?dN3tJQd9xmxD5Mr7jvyFcbT95gviR7AIx73WLG2H2+8Oi1PtkrZlctFoxY+L?=
 =?us-ascii?Q?wRycNSHRveO3xdy2u7zF1qa93JbWSjzPw3GazhlpoT1kNNHhePYGkz+WPYZZ?=
 =?us-ascii?Q?KrlNlEcB4rDJtqdTG2sIh2eOZ3RMU+WTPazT7tGvskOvcmucjquMLsHkadB/?=
 =?us-ascii?Q?PMiPD9mxLuhXxWqCvJgxbpfi9pM9draDtN3SH995vO0I8PmJg0S50blWs6f4?=
 =?us-ascii?Q?1EDSkfXcH68ZDr0aZNPSTDildWUa6RhgOxyQQeYsZqVWA92R4oLnOOL9+xkf?=
 =?us-ascii?Q?72z8kXFjXkR2ougsc6e4Ng+j742myiukD0l55vDMum6ZFeJ7QLgYzHN9sBnd?=
 =?us-ascii?Q?9FV82pv5qso6UIoASr1HmyHc/0Fb7crZ0Fh+X3YF1N+xB41a3yBtEOaADklD?=
 =?us-ascii?Q?14gQv1EPzE39EJ0siqmzA+bcATKlYRTIAHYEw+8EvACTQ3sh67s1ncWUYjLQ?=
 =?us-ascii?Q?b8tcxU1GHZkW4go2oDNM86P7I/bIulzxOIavGfOXL38u1kwXGgyecSnggkPK?=
 =?us-ascii?Q?zZ2pBZL/kbwWblPDRmm+zYn1o0cVsgo8NPmCnNeRNKkDvj6ctdNrr5qhjZ+w?=
 =?us-ascii?Q?hmYNXOABQDXOONcpUtvZQg5LveuYl6wqS5Giho2dDc8MJEP1JecHV4/qMCro?=
 =?us-ascii?Q?+rT1vQkqOYtpfCsNnc86qeDpJ3xeq6+A1NaaKlL28CZqvA8dWy9qjfY6mab7?=
 =?us-ascii?Q?MGL6B9KEQVaZZzXw3PcSk/4KoyaLbVsUPAKyHgNEHsdRbbniTyF2oWUIVHHT?=
 =?us-ascii?Q?Ojof5dRWYU2nuooH22KeiN9wKErrtQp9YZrZ8O76DTkpNcGoYerUX8m8f9e2?=
 =?us-ascii?Q?xCufLoLVoQ89spRI1baXwmm8YzE50XrFL3Ag8z5UPYMjTNM+n4wE4AOmhYj8?=
 =?us-ascii?Q?oNYY0iA8NLpz70ckBvTYO8S4fZlMfvP4psW2PxbFbTeA9oVil2kZpUAwBXCJ?=
 =?us-ascii?Q?1iZYDIuGnU5lFEo5oGvjlgKXmyiJfpdgXrQtz+RT+8V4jvxqDXImuee6squ5?=
 =?us-ascii?Q?2eA3di/upGlbc9Kvxfwhvj3ia79UnDMrx0QjNZJ77PS0AT4B8fN3wDOZM28G?=
 =?us-ascii?Q?n63tRbUEHWufzaSVKnLrzLJ5LIdLfnRpRb3niayGeFJpsTWvV4563kE81bwQ?=
 =?us-ascii?Q?WTPaO9Tevs7TXqF7CHMx7JlrANZkhaBNU4y6BCCFTMWVCxNCSU23+Y9QDiyJ?=
 =?us-ascii?Q?Cc7vCQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac2e8e7-e06e-4b8e-cf1b-08db65af22cc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 10:25:08.1599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LkMHbDr8r9SmvzmQGbraTikHQl+3Xy+UgA+rPUKlgXCKEak6WF+j1+lqfSsidh/OsLuEoBgFACN8HphT3qe4m4SvurvTU5qLP9856LGkd70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4648
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 07:02:16AM -0400, Jamal Hadi Salim wrote:

...

Hi Victor, Pedro and Jamal,

some minor feedback from my side.

> +static int _tcf_hdrfield_fill_nlmsg(struct sk_buff *skb,
> +				    struct p4tc_hdrfield *hdrfield)
> +{
> +	unsigned char *b = nlmsg_get_pos(skb);
> +	struct p4tc_hdrfield_ty hdr_arg;
> +	struct nlattr *nest;
> +	/* Parser instance id + header field id */
> +	u32 ids[2];
> +
> +	ids[0] = hdrfield->parser_inst_id;
> +	ids[1] = hdrfield->hdrfield_id;
> +
> +	if (nla_put(skb, P4TC_PATH, sizeof(ids), ids))
> +		goto out_nlmsg_trim;
> +
> +	nest = nla_nest_start(skb, P4TC_PARAMS);
> +	if (!nest)
> +		goto out_nlmsg_trim;
> +
> +	hdr_arg.datatype = hdrfield->datatype;
> +	hdr_arg.startbit = hdrfield->startbit;
> +	hdr_arg.endbit = hdrfield->endbit;

There may be padding at the end of hdr_arg,
which is passed uninitialised to nla_put below.

> +
> +	if (hdrfield->common.name[0]) {
> +		if (nla_put_string(skb, P4TC_HDRFIELD_NAME,
> +				   hdrfield->common.name))
> +			goto out_nlmsg_trim;
> +	}
> +
> +	if (nla_put(skb, P4TC_HDRFIELD_DATA, sizeof(hdr_arg), &hdr_arg))
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

