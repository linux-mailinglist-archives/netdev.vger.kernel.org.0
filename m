Return-Path: <netdev+bounces-11000-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 523AC731070
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:22:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D01E2816AF
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D6C186E;
	Thu, 15 Jun 2023 07:21:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB34375;
	Thu, 15 Jun 2023 07:21:57 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2115.outbound.protection.outlook.com [40.107.243.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3885E69;
	Thu, 15 Jun 2023 00:21:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bU8u7tosQ0Aqh/wyvh5LBd61erTnJ+SbnNKLLvYfGnnf/Z7NSU9cFV3nmBO0pTWHM+qInTNlpQTdi7w/cPRE65MSVO4mmH+eSYnRp9I9lZxRsIdAGlM3cyWoUpa55902CDVCJHglBqgOW3DcQaFBy3ZIqtpVrqa3yObVxgmM5LT+JXEbIcA87a1v54V63IhchCuqFv3brXyXZWTsykLrjgbzzAChAeNDxtQZVfnpiuLjvjZxpwuNkWWqVbpUJ0cHugY/9in1UZjh4ObHS7egSk1c50iOYwVUCjC70pJ8TOwbm+zCQz6Xc5dOaW4tjAEbzxONTXQdhk3/Mvq2IJc8tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmfY233crHUrsMQn9W1dcmnnhnfjX0ggIKiDjpei+8I=;
 b=jicHL6Y+i3XydtWozSJn//m9RjuEh0osdLF488wTzU2XvBmSjImWeH9JDQR9M2jPXV7Z7uzWxSJmHz0dNr4JLGvUDpkyXiZYK8jKgBVt6kIltKHZHYJtJpg1d8obTzLq6xAhBXlKTDI+DCIa5ppbhxa1on+OCqGVZoZHDooSaz1jvbFYWKAmAb2lTPmtdFhb4NtZaGxSpHC88J9EDwK5mRFt8Vut4IBbY64AWATf35a2FvyZpVXA+8jwYYWkV/D2Cr1j3CUn5sGW8COjVmOxTScg1kfsaSLkHbzwwZRndZDMY5HGlXp0rfnBlx5Ylndk3kZT1X1e1qqDEDgedKYaYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KmfY233crHUrsMQn9W1dcmnnhnfjX0ggIKiDjpei+8I=;
 b=DplhG3l2rQxc6npvt6l5q0O1uQ4VsfFDQJwoRKDPvwABOL/X9O6+0J/yYwoE0Mb8XMuB+zQBgrx1leToVzk8O4NZY2D0bgcgVwl/GzMJ5JpS3zTkPg/BUma4H3WqPsxWvxHaOP+G+yK5Inja4aBXzSi1f4fFJEBsShwixMAiZXc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4758.namprd13.prod.outlook.com (2603:10b6:408:12c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 07:21:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 07:21:52 +0000
Date: Thu, 15 Jun 2023 09:21:43 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Lorenz Bauer <lmb@isovalent.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Joe Stringer <joe@wand.net.nz>, Mykola Lysenko <mykolal@fb.com>,
	Shuah Khan <shuah@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Hemanth Malla <hemanthmalla@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/6] net: remove duplicate reuseport_lookup
 functions
Message-ID: <ZIq8B2ie8k4hMFa/@corigine.com>
References: <20230613-so-reuseport-v2-0-b7c69a342613@isovalent.com>
 <20230613-so-reuseport-v2-3-b7c69a342613@isovalent.com>
 <ZIiMKgt6iQwJ6vCx@corigine.com>
 <CAN+4W8jTTQqz2Fgzz4AndzpEo=Xteqisv88HqQu=j_VPcu3OVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN+4W8jTTQqz2Fgzz4AndzpEo=Xteqisv88HqQu=j_VPcu3OVQ@mail.gmail.com>
X-ClientProxiedBy: AS4P191CA0021.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4758:EE_
X-MS-Office365-Filtering-Correlation-Id: af04220b-3f76-4086-4fca-08db6d7130e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0X6JaKkp85l8+tYA2n2/LKEXe7ZLO/5OrBjESho0ruJCr4654dThm/ar9YeuwEHgjzkrepLqmOzxHu6Aa4bKPfMNT3Kp3Sl+s1yTb9Mmo7nVHKGYwdkjagdeG/4pcmZ0fMqyBts1j7Gva+a4Zu/3aAciGk4glmI6KoSNVwnHgBk872Dbefo/fEUIJFgPxYp0WcpJ7hV6fdhummWjBAJR+H3HTomgjpxDo1Xgca28iAS4pOO6dVgW5zB0ZwTNC7lNgtBUzv75vC3GjU1mdgIGUk/8EdImdoeMzIw0lp5qjCP+ez9kVozSgFtwgHmN3bVW/uhRsx22hwLDmAk/jDGOv5NeBIGzjVOgf2XQkj+Nu9klIYbnm6+Bd55DbrNi5HaxEXi9m/JsT5IsfJ0a3J5XEKOU06cT+MNR0XqtUU0kknYo/I7VQFYTPCIXMYSl628pTzBWaJZwz2L9TzFpwU1326qjQCdEsm65rxBOV/y6WYZMLM1JaeskhS97V0/d5s8Hp1urUPFNNZI5bNlmvUt31OmGaIdtawOlU49UAPIbz1WxiacoYj062lR0wGDyUdOwBM269cC8Ri+7udrfMQygQomEcvnQ7NCF7nwJLWvoDMs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(136003)(366004)(39840400004)(451199021)(36756003)(44832011)(2906002)(86362001)(7416002)(966005)(6666004)(5660300002)(6486002)(186003)(83380400001)(6512007)(53546011)(6506007)(478600001)(54906003)(66946007)(66476007)(2616005)(4326008)(316002)(38100700002)(6916009)(66556008)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUdtV1pwaTgrcUtFb24wdW51bmhocXU2UXdHNmJ2eFRXSXNOdFZsMXRQUzlu?=
 =?utf-8?B?VUZzU21iRHZyWGlyN0dIVGFZSjF5K3NPYXc1N094VFpwKzZaNklrSVRsZXhF?=
 =?utf-8?B?V2dlbklodGVVQVkwRHN1YUkrVTlvU2FzdzkxdytoY3hJY25vZWJwK2lSTVVI?=
 =?utf-8?B?NENTZ1YzVEtEZG80THIwM0FMcFM0WTMyNlhTS2RJSGt0TkI0U08yRFRKcHJQ?=
 =?utf-8?B?SGtXN2lZUG5HRjI3VkJBbSsrR2cyQ1R5djlnSjBjOU5xZ3BhM0JIVHQ4RnJL?=
 =?utf-8?B?ZEFVWkpsV0dnK0NaaS9mdjRoM0UwdHJmRUZqSE5EK1ZQQi80UGhzeVdYcndo?=
 =?utf-8?B?Mi9aMFF6V1h0ZUloVWk0V01DckdrMjdMNnNaZUdxd1BjeTk0cnkwdUdkQkpW?=
 =?utf-8?B?eVV5WHh5T3NraDdwU1VjdWlkakloT2toVWtkTVZyQ3Q0ZGV0TDJnSDRLZURw?=
 =?utf-8?B?dmRSNVZ4NUd2K0JTb1Z5ZGs0QzJaZDN4M3Z4RHpWbGlWR0Z3eXJSeXZLWkk4?=
 =?utf-8?B?b0pwYktXcjRaZXBXWElrREJrMjVQMnArTjJXbFZ5VWF0SFV3UUdkWDFaNDEx?=
 =?utf-8?B?ejFBQUs1eW80V280cCtDRUlTTGd5dnE2UHV1bFVVMjc3YlpQWTdnNXB5ZkJ5?=
 =?utf-8?B?Mjl0YXFWZnB5UkJtUk54WForLzRzNTUzeDNCeUZIOHU4dFFBVk9DbFpxVEtT?=
 =?utf-8?B?VXhrSHVwOUhkMXFJRytmbUZscHdSdXIwdDJ5VVZtVXhZL1U2TitQTWJvUEt0?=
 =?utf-8?B?Q3ZaWDRHUko4Zm0zeWtVN2VtQ2tYVVdQMnZkek9VOCsxa3p5Y2hvMWZrSHJT?=
 =?utf-8?B?K3dLL2QwMXVIVUFMQlpWUGQyS1Q5OEYyaHVzeXpXN1BzSmhlUXpVbkhTVVJB?=
 =?utf-8?B?a3FsYmVoYkFBbXZ5aG5tSjAyam5SRHBBWVZFRm1kcXBiT1F0aktJdGkzNm1h?=
 =?utf-8?B?QXdMdkkzekoxN0pwL1hFWVQ4UGVQTzhtRU9SOEtHU2ZGRGU3MGF6b09hQkRB?=
 =?utf-8?B?VGtsV2loWG5JTDVLZGcwcE9VSzRuSWF5MzFPM3V3cEFFNVJpaEJKSXNtNU9t?=
 =?utf-8?B?QjNIRFVCSlFJN2Rsalo0bWRibnZwYWNURFR3ZFRld0FIUFZYb2JLTDhFQy82?=
 =?utf-8?B?UlA1SzIvcjhGNlpISHdiRUpLNExmelpzWWFmM1JTUSsvYjltVDNjaS9rS2k0?=
 =?utf-8?B?dzlXU1FOZTRpbnNqamN1UUNtRWRZaVJ1Rm10UXg1Q0pFTytxdmVIcXZFWGd0?=
 =?utf-8?B?Zlphd3pKZGNENmxuRUo3THBwV3ZxdjhjT3ZMU2RMK2pQeCtCZzlqN1VqbnpM?=
 =?utf-8?B?cUJFSW1pRHM1ZVdVQjRMRTZ3WTlVd2YzNHJxUkpRT2ZRMHFqRm5pSlp6N3dl?=
 =?utf-8?B?L1ZtZUU3MlBqMTR6NncyY1p2RkRjRVFUSVlGckd5VG9lTkJ1dVpYV1ZyV2Rh?=
 =?utf-8?B?TDlGcTdZMnFoVHRUcDdMMUd3WXY0bmdkTVdjYVIvRnoyZksyLzdSUDB2Unpa?=
 =?utf-8?B?dVA2VjBsNEQ3RUY0M1hZRlVlQ29oQTg1eXk0ZDY4OHM3S1pVZXBuRlkyVWln?=
 =?utf-8?B?U3pic3FzZFdOVUlLQ3c2Y3VXYUdIa1V4TU5laHhRMDRnRzdlVVRaUlNicitD?=
 =?utf-8?B?Sm9QNVZsSkxyZ2NvZUVMRTdwT0hNb0lNV2hvcVJicXlPQkFkT1NERVR3cWtz?=
 =?utf-8?B?VDBoYmp5MGsrc0hraEhwYXFDRkprZ2RUVmdVZk5jTld4WEwzbWp0QVg5dktt?=
 =?utf-8?B?MGZ2TThkYXU5M0tmdlVtWVhWcTFGSEVjQ2RQTHN4Z3FBNlF4ZTl6ZjNRNzk3?=
 =?utf-8?B?VEZPengxVWtyTEhaVUlLeWhoZG85Yk9DREdpUnRKYStWNVBhYk43R1JqZU9R?=
 =?utf-8?B?YU1PR2lhTGJYendoYnNnejUvdTJzVEkvQkZWZlYzVHpScWloaXU5WFBteVdt?=
 =?utf-8?B?RDg2aEIyMmJiakZrZXVCWGs4NU42WFplWGx4cVllYXMrbW9SRk1uWkg0VDB0?=
 =?utf-8?B?YWwyYXpQODcvSVNpS2RzRitvNWhlUlNmRmV3MS9nQTlJSWhoZDBDMEFBN2xh?=
 =?utf-8?B?NUk4RTBaTDRPZVZnVWVjV2N6b1huVjcxVlM0MnVPeUJqcUNwSksvbDJySzdo?=
 =?utf-8?B?SUdzazZwWUNwakJGNHZ2NFBHbzVvdG81NjlTNHBYUHY5S3ZhRlVwRzRQam9l?=
 =?utf-8?B?VXk5QVo1S1k1MDhYeW1YTjd6OUtiZTdxVUcrS0hZL0ZrVjZLdXRVYlh6ZFFZ?=
 =?utf-8?B?YXd4ZDBoYTU5aXJDL1ZzQWRXdjhnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af04220b-3f76-4086-4fca-08db6d7130e4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 07:21:52.3646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aBd2YQ5Qx7xU5uZ8vaPcD5N5Vu+L5/9qBM3Pt5edrkRMx8OWiFxSQ9hISQdapfYqOUQXv1ChjTOzRwbXzXWSZw+/mHv+Ye5NoCafuZYk99o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4758
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 04:42:45PM +0100, Lorenz Bauer wrote:
> On Tue, Jun 13, 2023 at 4:33 PM Simon Horman <simon.horman@corigine.com> wrote:
> > >
> > > +INDIRECT_CALLABLE_DECLARE(u32 udp_ehashfn(const struct net *,
> > > +                                       const __be32, const __u16,
> > > +                                       const __be32, const __be16));
> > > +
> >
> > Hi Lorenz,
> >
> > Would this be better placed in a header file?
> > GCC complains that in udp.c this function is neither static nor
> > has a prototype.
> 
> Hi Simon,
> 
> The problem is that I don't want to pull in udp.h in
> inet_hashtables.c, but that is the natural place to define that
> function. I was hoping the macro magic would solve the problem, but oh
> well. How do you make gcc complain, and what is the full error
> message?

Hi Lorenz,

sorry for the bother.

With gcc 12.3.0 [1] on x86_64 I see:

$ make allmodconfig
$ make W=1 net/ipv4/udp.o
net/ipv4/udp.c:410:5: error: no previous prototype for 'udp_ehashfn' [-Werror=missing-prototypes]
  410 | u32 udp_ehashfn(const struct net *net, const __be32 laddr, const __u16 lport,
      |     ^~~~~~~~~~~

[1] https://mirrors.edge.kernel.org/pub/tools/crosstool/

