Return-Path: <netdev+bounces-6716-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF328717983
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:05:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8ADA3281362
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810D6BA37;
	Wed, 31 May 2023 08:04:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD45BA30
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 08:04:58 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2137.outbound.protection.outlook.com [40.107.237.137])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17651A0;
	Wed, 31 May 2023 01:04:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdTAHs+hhbYt/ilJEw1HbSh1vaUaTvt8BOgbDC1STKfJGh4y68mc1RobwFrYfmY1fBR2L50Xn3R7Mrlg9XqSz0ssLz4aW5fKr0tmYXQlyOMVRdjghY/AjU5UaHzlfCud+tvhowsIhNvbciQ33DVjHcnJ4a+p+sGWTvA9tqwdGs2YlYppZbFPKgKuycZy0k4Awe9T9O5FebdzRQY24Q18cCasFGS1IfpI0LWnxaw6UZ3WvoODdSxh39Op5NZw/ie7CnEDBjjCDFaDrglPTIJUPHVCToNqZg2krC8QRfdf6Exj4Qa+AtYEDa8JZTOI6Z1PpN7+kGNrySAY97tSDO3ecg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3S3ko44cd9aNqQslL76e7zbxjOrWpkJNvp9l00QlkI=;
 b=N5D3Cz4khWohCHUC88mJjh3zGHiYmCojoJqTfUctAoKgToMlD2Vt5YlZA3oKYX+kutR+Z1tTkajrN386jlhA3z4SuDFjSLcTlgPzM6eYTm9d1rgiIkRRDxCZoqp70pxOcsw75xBkklJpMh0+llyGQnqAZw1evc3EZMRzReLu/HD5TkXwTzD3YgDfhA6e36XX/mXj56NJwC4eSz0PpLyXr3tzzKA81ptQd4JiYqjwgVICfnWeTJyultmnRhuS2qa8/xu4TgkJIylHkHiXDpiBjXbzSNBbpnQ7UKH4z7PaJjDDLhCEmr/7yl8Ruj9nyxrYXCXrreyK8ejPbKFdlcg4mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3S3ko44cd9aNqQslL76e7zbxjOrWpkJNvp9l00QlkI=;
 b=A2buZ2i1xHFUviqAW9w1Ubi+OgURRDWs6rntzVqrICPrjVxTMZJycqXvCV9Js59nkDMXGoPAhLjgOghaWcZmzj9MOdiORPuPYXxljaskBBdwve9Zt5tNOEoNt7o810cRs4hDh1Ma/NISLjLWKOv80qQewKcwRbqcLnfDVwAe/uk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY1PR13MB6190.namprd13.prod.outlook.com (2603:10b6:a03:52d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 08:04:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 08:04:51 +0000
Date: Wed, 31 May 2023 10:04:44 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hangyu Hua <hbh25y@gmail.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, simon.horman@netronome.com,
	pieter.jansen-van-vuuren@amd.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sched: fix possible OOB write in fl_set_geneve_opt()
Message-ID: <ZHb/nPuTMja3giSP@corigine.com>
References: <20230529043615.4761-1-hbh25y@gmail.com>
 <ZHXf29es/yh3r6jq@corigine.com>
 <e9925aef-fefc-24b9-dea3-bd3bcca01b35@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9925aef-fefc-24b9-dea3-bd3bcca01b35@gmail.com>
X-ClientProxiedBy: AS4P195CA0031.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY1PR13MB6190:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fdc75a6-3d99-4d22-75d6-08db61adb611
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rff3UqobKGx0dSvN7Htrmski5B3JY/Es4r4/AXj4wPEvCrYyNV0r8EI5+APz9okXOC+Mp9PGXOdvSL7WT1B2Gybhh/hHrOgW/BZNiSu3fUnXigjaEph5/M0a9kh3hzV4wQvUCAKqCoT62NTrt0AHuDzww+x98kqhBA5Vj+jlGu+BTiK65rWHtP0BkSw2GrK1mgZ1gpN2VNShnuocoP6tsEPVLWWPwhZ56tJOQE6wDSDD0OA/ay7dK8iQKJs5dHL5mxD99QSiiz0WO9CFTDH/FY3KF81z3de+KaFbYTTBp6vhmUEc9O7xaC4rpVXNPeb9m/auDTxPrnY3RJsa8VZ7v28txZFYWwmfyEwq76zoltG06ooIpUzqRzhGDvOnC1T2fGWcbIntF7Q0cRLyL/2UWIl92gyw7FMYbEwHvVLLzsIc1TCNj7SwLhDGhUebvfwvH5ysgU+LVKHsUblk+l4lh+9akTk2VuEvUPM9vOYYNnWPsmIZCo7FydDnCOrqUKj/YjnAbBb82jnW73+SLR/Fd0dUFrP/C38fAAkhd5TGA6l11HtGJDLj2HcjcK6YCXXd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39840400004)(366004)(396003)(451199021)(8936002)(8676002)(2906002)(66946007)(66476007)(6916009)(4326008)(66556008)(44832011)(41300700001)(316002)(5660300002)(7416002)(478600001)(6486002)(6666004)(6506007)(53546011)(186003)(6512007)(83380400001)(36756003)(86362001)(38100700002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0O53j3kg0rSNOgso3MGQ4+bpskPeHfW9NkXMLkGi6DmLVvz8Cm/wsSkvKtQ8?=
 =?us-ascii?Q?G7CYyytRHk2Zg/KLsJh31WMN/W+uzUzTdvE2/CKbrfZGglvP+DaIMMei8j1Q?=
 =?us-ascii?Q?UkhObVIoueSMpD2WVV8QZ595AmawtBgHaICAtEQQTbg7aL1Te7qHEJNcC0fe?=
 =?us-ascii?Q?OuRrkxgt8wj8GHzV7D/71HdXFhIgORNMbdwTfUErG1QNWDb8OAquDNLDoN8+?=
 =?us-ascii?Q?jy6fTOeQs4hO77+5F81wxwDPFQ2xisxHzAuRcoo1mUbmP3nABgFyFUf/rJ2w?=
 =?us-ascii?Q?eAPrGVLxBsADBBO7m/K4rAJX4AvTkaSSl2GfodNDMl01ksT5RZtpSTrN8Kcm?=
 =?us-ascii?Q?vXwd1DvRipQqxjpAAGvfqBPQYGpEqO0lcbVK2Vef4EYI1vUWMukMOAbAiK7x?=
 =?us-ascii?Q?hiY7wvwM8nhFYZAsGVQFXi/GJ2MK4aiK9WaFA//Q9Lf6FVFwZ1v4/BA6UjCY?=
 =?us-ascii?Q?sOv+497uPRt6YKIP85qj5Xi+xnu/6DRyHbsUM8BBrwEjEO8LrZCj3ucv4K51?=
 =?us-ascii?Q?KqbzkRVrcba+xHAxdlpE1u1GebmBPHee9B5lyyWp1ewVfS2SXqcf3hcZY8hg?=
 =?us-ascii?Q?oMrzJoNuuKeWvo0BQN0OzIBegYW9jL5EOjMmfv+TrLhB4GDl/L787VFuZHkd?=
 =?us-ascii?Q?OoaAqJz0WUV+fb4Ct8FLPMdZhsGtv0ZBKSbjDCxrEFyqWSyGygdLSULSSuFY?=
 =?us-ascii?Q?iGVzxTo/ek3jVbs4qQiVdtxg+0aD9F7/5Ot2JL/syXhU/xEyQZQdPVKCUGdB?=
 =?us-ascii?Q?CkoX5JNuZH0d4fq55b6qdLRv/hCeRLiQfYgljjzZfinB8+TwRaeFbpfwU1Gz?=
 =?us-ascii?Q?2Ry9peIy8e8KU7Lt46MEAy8W7dJuMc4YKdsanFDu3j9xTjshAe+HNSVj7jYT?=
 =?us-ascii?Q?Cj5fTEBx9fQW/LbkZHapF8NCaa+rwK5S/WxzD8/GiQJ7T8j4YQxkx2x3W0y7?=
 =?us-ascii?Q?GtJ8gTElQRQi23WbJGsw8v+OCdwqxeMGv+vcBTtIrdlAikZv/xfcJJXc5tgL?=
 =?us-ascii?Q?WK0wS7BqudNlj862dn7hWT6kxa38n7TyiXYPyrF+d2WGgduXUNeZf0/b5K2M?=
 =?us-ascii?Q?XRpr5gwwc1vcMihF8MbCxi+FXx6nHq0Xyp1g4gVCSNgPBDdPyGCh0fA+sfX7?=
 =?us-ascii?Q?DDZpuxnp9bQw4fql/jxp7QRTsHuu1+Irzpo9SGig/4kYZzYJA1kgV1a/Cyj6?=
 =?us-ascii?Q?352VjEBOJoF/j3K+uTKfUV4hbfzGHX6Z/tWjq4Kj4HxtCAtgiz8vM2Y+qooI?=
 =?us-ascii?Q?5BQrmbWYShriIbextcBhW1CdqcPX/J1TN4g2vb5A/AxcF0NQH+8fH0IVjC1C?=
 =?us-ascii?Q?N8kM9mR1U2LEWA/FRbiZJrpntp+8bmCczkMLS2ouvYiSqxWr5fGq07WTeZOw?=
 =?us-ascii?Q?eBB7XU5D0nJj9gwH8TEvyN4ATTRcsl6iFrAcDuh+zMSqPV3zZwWcAoOEeAVH?=
 =?us-ascii?Q?okTLll9O58JEmOIRR/QnfnyqH735dJSJ797fHbuKsqcZMTyjaVFlBtrLmfVC?=
 =?us-ascii?Q?mS2GHSPu/GEGhtyOsnZzP7O5tJe2DarsrnFZVYUme0R6NxFTuqlxUFKlNJBe?=
 =?us-ascii?Q?RguGzrQPcBIa9mq2yBQQDfHXEWsufl33ZYJ/EVwm2ZmYaZpCdiQM/fQhqpxm?=
 =?us-ascii?Q?bJe+VQ28EFDfArdIPakaryRIrH5HHkuyZnWozfcR0s88eWf5T23p0Ajahyvk?=
 =?us-ascii?Q?FapMsw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fdc75a6-3d99-4d22-75d6-08db61adb611
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 08:04:51.6680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Idc8s2f8D3Fk7z/4+hZhNnK2N/+C707rgbh6+GFOHMhsbVPP+FUl2ZkIWOXOa/2zYzGeVeeij53DIAGivNyRkI06k4Td4iGF1Ku4wT4OC5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR13MB6190
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 01:38:49PM +0800, Hangyu Hua wrote:
> On 30/5/2023 19:36, Simon Horman wrote:
> > [Updated Pieter's email address, dropped old email address of mine]
> > 
> > On Mon, May 29, 2023 at 12:36:15PM +0800, Hangyu Hua wrote:
> > > If we send two TCA_FLOWER_KEY_ENC_OPTS_GENEVE packets and their total
> > > size is 252 bytes(key->enc_opts.len = 252) then
> > > key->enc_opts.len = opt->length = data_len / 4 = 0 when the third
> > > TCA_FLOWER_KEY_ENC_OPTS_GENEVE packet enters fl_set_geneve_opt. This
> > > bypasses the next bounds check and results in an out-of-bounds.
> > > 
> > > Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> > > Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> > 
> > Hi Hangyu Hua,
> > 
> > Thanks. I think I see the problem too.
> > But I do wonder, is this more general than Geneve options?
> > That is, can this occur with any sequence of options, that
> > consume space in enc_opts (configured in fl_set_key()) that
> > in total are more than 256 bytes?
> > 
> 
> I think you are right. It is a good idea to add check in fl_set_vxlan_opt
> and fl_set_erspan_opt and fl_set_gtp_opt too.
> But they should be submitted as other patches. fl_set_geneve_opt has already
> check this with the following code:
> 
> static int fl_set_geneve_opt(const struct nlattr *nla, struct fl_flow_key
> *key,
> 			     int depth, int option_len,
> 			     struct netlink_ext_ack *extack)
> {
> ...
> 		if (new_len > FLOW_DIS_TUN_OPTS_MAX) {
> 			NL_SET_ERR_MSG(extack, "Tunnel options exceeds max size");
> 			return -ERANGE;
> 		}
> ...
> }
> 
> This bug will only be triggered under this special
> condition(key->enc_opts.len = 252). So I think it will be better understood
> by submitting this patch independently.

A considered approach sounds good to me.

I do wonder, could the bounds checks be centralised in the caller?
Maybe not if it doesn't know the length that will be consumed.

> By the way, I think memset's third param should be option_len in
> fl_set_vxlan_opt and fl_set_erspan_opt. Do I need to submit another patch to
> fix all these issues?

I think that in general one fix per patch is best.

Some minor nits.

1. As this is a fix for networking code it is probably targeted
   at the net, as opposed to net-next, tree. This should be indicated
   in the patch subject.

	 Subject: [PATCH net v2] ...

2. I think the usual patch prefix for this file, of late,
   has been 'net/sched: flower: '

	 Subject: [PATCH net v2]  net/sched: flower: ...


