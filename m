Return-Path: <netdev+bounces-7975-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 999027224E9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:52:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 837962810D8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A61417AB8;
	Mon,  5 Jun 2023 11:52:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D0B11C9B
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:52:04 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2104.outbound.protection.outlook.com [40.107.96.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1492ED3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 04:51:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNIiKHN3xhJWP5RiuC33KKqnRIg50uLoF+ta+lyLeEcROiMPE0C0qEBFlmht4bLyYHZlt0kvdjEnu1ptpBc9jtMaYhiRY1EDttG5Wd5wxeibMi6EBNmGBDDAJPEiBTw5lDpAE4RYLh0WlsNEA+F4V18xoy9/61lK4qO5Sv3ogjiiXvIw/nyfp2hkxNwJjSqnEty7SqA2nrZQEhlgLXQgoKb8jMubcfMZ5DHpHI2bGCYTyyEzPjLh+umPuM/fia25US1bTlTXL6jAtz9l2g08BegQ29a0m4cUrGFKgvIspI/9boRydHogaHq41D5+XF1g3b/3e1Em1H32St9ne91O+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UxlTuSqthydB0Y72H5ksX2bPClzyaZ7ILOrci045wVg=;
 b=isIVw0BBJuySY/tKaFC5HyXWgaJFu+xEWn99HmHDzN7hp1yJi8bSx2koQstKI2Y9V4IugRg88teTpVrfEvJ3Xpb2yYFrzq8rm0EYiORy0FeTFRhhmmmvey24dCcbMHv1PsfNvnmSMMw6kzUzSxjzUqEUvzFZD1ph31uWZDN+3FjBFSV9OWBY6PKpU2M1HFUgjP5S1tIZGviBqi1y/st9fVxfQDFclVX3AlTFUsJl8DvMTyeFF43Mee3hW4bRpGPeH+nZg0uTiJk9CIh3tpWUGYNMLUquhQ7jNy3tTSertzZjknmJ3PswIhnFHjKdjoVV+p8nS00Rfme26XTsh5t6ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UxlTuSqthydB0Y72H5ksX2bPClzyaZ7ILOrci045wVg=;
 b=u99MKq0LfPx+S5v2ynYZwJaGVr2ESRMOPt2UEpyIw7mTp+LsJ7VsgpnfREb3P72ma6eLjOEod5PfcWT+ecqwrS+krz6dyzwlw20yf+EyQqi6DtIpdgcOT8Yi0fgoApeagDXb8HtWoZ2Xl2KZWNvlQD2ipY04DDM0vguxY3BkZIU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4424.namprd13.prod.outlook.com (2603:10b6:a03:1d9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 11:51:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 11:51:54 +0000
Date: Mon, 5 Jun 2023 13:51:48 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com
Subject: Re: [PATCH net-next 2/4] tools: ynl: user space helpers
Message-ID: <ZH3MVCH766QotC5K@corigine.com>
References: <20230603052547.631384-1-kuba@kernel.org>
 <20230603052547.631384-3-kuba@kernel.org>
 <ZHtSbn1oHl4KcfUL@corigine.com>
 <20230604110034.08015f1b@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230604110034.08015f1b@kernel.org>
X-ClientProxiedBy: AS4P190CA0044.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4424:EE_
X-MS-Office365-Filtering-Correlation-Id: 896cba1e-c45b-4218-f918-08db65bb419c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hxK2iI8ntUdm69ges8Xu30la/QrrzEeqVxbT0DsX8EKBgLakZIait5nFGmfsGCQOR+z9dVbcOtuVZk1XFD1LOVPAbnWCX2qYFd+F+oYnjLjsiFravSawSyH/NlY3KWLKrxIRi/a5FrT36IPDw3devmDj64fcTHN1xh+6rlTeATPD9Go/Ak25gYX6XN/WlgLPw9QJ66OxrgE02lltqdDrwi2uBk1SdhyBp6Zv2hIwDuG7Ucz3CBya51VWZVWZqLG/p3Yy6r1iUdWYR79JOYFI42NWNc+dam86crRBLMR9Zgpk8hXvBtcY5vB7uf6ac5EGlJdaNPgB+sUd3ZG7vAUZPq2HsOK14Sa5MJoVpG+k+DpVutDbTTqBkntL3V0EZ3TWJV3hpTMyDutqYnrgvlFUfz2TC9mVvgwFUdn40wiamiM2szfH1oDnEw2ArmGCUSTBZmIgtD6ywjWGyvlpy+++NDCLB7bbZYpmQ9ArbmTweMkT9cLlWO9pIsMNIZ0e0iVTGGVKCxFGhPSZ9McGoYSMTxAqkZGlxHuCuNcJCAcs+gvfcIGTfJStJyI2EE5mOkvN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39830400003)(376002)(396003)(366004)(346002)(451199021)(36756003)(2906002)(86362001)(44832011)(5660300002)(83380400001)(6666004)(6486002)(186003)(6506007)(6512007)(478600001)(6916009)(316002)(38100700002)(66476007)(4326008)(66946007)(66556008)(2616005)(41300700001)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2zfdEx/QMP37mglxe7JDZkKrHb60YE9h9Bzr8E8J5Dl/LpTs8Q9gu6bvaHbi?=
 =?us-ascii?Q?eR2tUJgPpMeLuPIJiDKjTdvNeLmWvauGO926pVJ1TfiXRzwWoo+ymIXtdiAQ?=
 =?us-ascii?Q?nH5S5EzjqtsnxzjPNR4fsAUisIYb3PTeQh4l0PDJR7rg4zZay+uZN5NEYWCp?=
 =?us-ascii?Q?Vi7rfE/pTCROebgpFA+dYMMc4mBi0lSA+Sm6u0XKysEyAktAO3t+7vV1aY2T?=
 =?us-ascii?Q?n7WWz3nGdhUa2ZrP33/A5zQvMqx2WXEdJTEtY9wBWKHDNqbJACd0hGk3Js03?=
 =?us-ascii?Q?PAgzAjINwiDRoo8kP0ti6pvor4VoMymqXyLQ4kGXatuTvfKYs8uoiCEzv+mF?=
 =?us-ascii?Q?aGN68hhoglXwNpvld0SyVB57SieRpTH5WkzO5oxb7rWGMe2pvybj4NoR03Tu?=
 =?us-ascii?Q?KJ3yizhP0gzB75f10umLUFby5tJUeq1oKdWCLtt9fB9RuX/0/sV8woFat71d?=
 =?us-ascii?Q?xvc+gIBc6tVPMb7VJ6ZxPF6tMdHhqBymYkmMuiB4dVwdERI0lTw01FPhiLCy?=
 =?us-ascii?Q?tvF9j+n7VQRxHdbmf4hI3q95OrHpnzAmdWkD6j0Rzu10faMoTBKOjd8eMtw5?=
 =?us-ascii?Q?MpX10R/K797VzjG1YJXOUXJOxYmZ808Xexhg4XzpKn7vsOdu+rAeBWe6lEOO?=
 =?us-ascii?Q?PgScvQ1YKQvO6eMQtSfYGgRZSCs6eAvOc8F1gpic21s4rXnKjjymOOYppHM1?=
 =?us-ascii?Q?iUJVROfQ4ROB3P64xsw9s80UL5K9odgIenc1lh9ZewL3oRq41J7SikXWC13y?=
 =?us-ascii?Q?hep3BvyMzqZAsWDFSWWIZt9999m716UC6mmNEZ4YYRs4bw4I3YeHQ/6nUQTr?=
 =?us-ascii?Q?KL3u3yF5L+GL+X/tx6gU/E7fSUPe4fR2pAMwwEmavvl8VJaIXrUcFH9b40Tq?=
 =?us-ascii?Q?vQAP4QRSE6pKD2Vt9h2eAeu8+NClw6ildSrF0JI6974EB2TF9HgJYdnNBouN?=
 =?us-ascii?Q?78c8C7XQ8nehr6oOKKIBG3E4q5OEuPRQlfPf57Tnax7+/1JFH5pFXn2NOv2P?=
 =?us-ascii?Q?x6a+nWjPLKzmT2nvNm+sQ96mDCAi3z4ovJBBqLwEL3L8KXHPTl0MaaNV5t7u?=
 =?us-ascii?Q?884McHP4ijiuXwrDZWwK4K5zYlYnOu+2w4tin94dQOPIq2h4g6oUb41v3qQp?=
 =?us-ascii?Q?CDK0bOAo07umSF+dzsQFJQ9BffVsVtGrlonEPtuuA2QtzAQXBukHKoLFfoT1?=
 =?us-ascii?Q?o+j05lMa14ECwhg/GpwytuffZrc7hXjyKDhCmfd6SgLinJiAOBVeXbzqvzA3?=
 =?us-ascii?Q?K1tX/+EAooNVR/9lGX7cleAoMrzPqjNkOmrpFNE5fWVuMzS7E5rqd+3h/7jW?=
 =?us-ascii?Q?IOpXKiQq/EU2EXTmF8nnw91WZBzDijgX1gPiUljMJQj5rLlOfwMHWqi2Iekf?=
 =?us-ascii?Q?HMDuV/dhgnw29N005EFhSYnfSrLY/Avk88l7qfFXastZOafxMPhubXSAGuAW?=
 =?us-ascii?Q?HlDhwdYuzC3qRnnQyQ+ILJWvQW2GoaobWs1lUDAQi++QgJavNAr8/cExXrQo?=
 =?us-ascii?Q?u23uCbRoYYabOdWkAvnj16ggwkDoZFuNLcMYcAvobcebenGnQhuL1viFeNQb?=
 =?us-ascii?Q?LOduOb9/2SPjru82yFMJzPzLQWV4g9c8pSCwh0XpUtX/j65EMiNeP+s0BCE/?=
 =?us-ascii?Q?yB3pUfcQizXsZRtSjv2yEpr/Uhxgl+xinbSMkfxMCRDKTzFBJC7QdnnLBHp9?=
 =?us-ascii?Q?+wCJdw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 896cba1e-c45b-4218-f918-08db65bb419c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 11:51:53.8702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XyaQm2XWUHUv5qP28iSiGmkFcoxvO9/UQpKWOPtn7j5O0onW3coWomLjHFo03VqfZAWXC0hEk2s6xRQ7vk6/wj6KNwl/d6mRViuKyAhEBmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4424
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 11:00:34AM -0700, Jakub Kicinski wrote:
> On Sat, 3 Jun 2023 16:47:10 +0200 Simon Horman wrote:
> > > +/**
> > > + * struct ynl_error - error encountered by YNL
> > > + * Users should interact with the err member of struct ynl_sock directly.
> > > + * The main exception to that rule is ynl_sock_create().  
> > 
> > nit: As this is a kernel doc, maybe document the structure members here.
> > 
> > > + */
> > > +struct ynl_error {
> > > +	enum ynl_error_code code;
> > > +	unsigned int attr_offs;
> > > +	char msg[512];
> > > +};
> > > +
> > > +/**
> > > + * struct ynl_family - YNL family info
> > > + * Family description generated by codegen.  
> > 
> > And here.
> > 
> > > + */
> > > +struct ynl_family {
> > > +	const char *name;
> > > +	const struct ynl_ntf_info *ntf_info;
> > > +	unsigned int ntf_info_size;
> > > +};  
> > 
> > ...
> > 
> > > +/**
> > > + * ynl_has_ntf() - check if socket has *parsed* notifications
> > > + * Note that this does not take into account notifications sitting
> > > + * in netlink socket, just the notifications which have already been
> > > + * read and parsed (e.g. during a ynl_ntf_check() call).  
> > 
> > And the parameter of this function here.
> 
> Thanks, not sure why my brain considered this "not really kernel code
> so I don't have to obey the rules" :S I marked the innards of the
> family as private, and tossed in the other descriptions. v2 posted.

Thanks, I assumed it was something like that.

