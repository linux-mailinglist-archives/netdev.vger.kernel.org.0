Return-Path: <netdev+bounces-11317-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE903732966
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:03:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A2F82815D6
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4342944C;
	Fri, 16 Jun 2023 08:03:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BF46117;
	Fri, 16 Jun 2023 08:03:33 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2135.outbound.protection.outlook.com [40.107.212.135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D712D62;
	Fri, 16 Jun 2023 01:03:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGYNUfZ3GhTrkTiwnXSieSJ9Y1WVRiDR86DA4Eaa3sipFZEfk1VZ/grrui0vO3U2zEfKuiuQBXsIXHwO4Zz5kCCfVUPjelrhzow3ePko5z23WbpBRhVflkDgtW2v10OLINwHugJoLZaLoihNjqsjUh3uSCjJkazghBi15ixGeg7YDg6kaftDz/tSBUpShwLNuySeYWmmZ7i17iGOYmumORN17Rp2m/nhPizY8Ds8kZm7OlS/9tQ4/hXHpVeePZd9FcqMT9OtCUy8SvUrz7eYAP43SqN4WtHhu91x0wBJvraud1dmnifk8M24D6zeF6pCgRiNLgL8VoQiq4H0fENcDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=esWx+h2f9h/3Kl9nsAtZ9qtCBs05lm8pQgel7jARBUs=;
 b=Xeo+7tq1UgO8u5wIKyDLf5M8yL31ebt6vSVi0b0b9ScVYuPYTk+eFbphXNGWdjS9fXR+WD3+QIi+sE9g3klpJzXn5ofV7ij2/rGvyyT6fPuwAWPM4KZh1hv+7VfrRPYW0udAp+IK1Y8+AAJ/tqZ+NkATjEYnmZf/rkEqxI3UMOyhAtkUE5Qo/kd4q66hweq6WnWQ6XS76p55ODOUmNmngB63iM2iEJEaKpCsMnw4kzxsX4vxcxU7GFbzOoaNF5rpOVDsLvwowDiInE4kwE9syf/hFHf3MMBiPq411IIVwA4a3zG9FSt37yUrznFB3PQGF8/vSKVOghQ3IC+/oSLxkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esWx+h2f9h/3Kl9nsAtZ9qtCBs05lm8pQgel7jARBUs=;
 b=Aw+7TLjiLDbRjYs3UXoS+Kkc3wutLlJnIkcJ0XfwOZ+6DpZa9mQMuECVm2jBWudJx8LyGOAAvZElzjxlDh7+BJpmkvo2cwMqkXEyAaJirUsMjOfkkcp8mgsOeleAvUQTKzB9O6TzQ8LhJYJkTsFaDme54Dt1OuDLF2xiw7Rl7eM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6116.namprd13.prod.outlook.com (2603:10b6:510:2b7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 08:03:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 08:03:24 +0000
Date: Fri, 16 Jun 2023 10:03:17 +0200
From: Simon Horman <simon.horman@corigine.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: bjorn@kernel.org, magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
	hawk@kernel.org, john.fastabend@gmail.com, netdev@vger.kernel.org,
	bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
	maxtram95@gmail.com
Subject: Re: [PATCH v2 bpf-next] xsk: Remove unused inline function
 xsk_buff_discard()
Message-ID: <ZIwXRSDCcp2bmjMb@corigine.com>
References: <20230616062800.30780-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616062800.30780-1-yuehaibing@huawei.com>
X-ClientProxiedBy: AM3PR07CA0096.eurprd07.prod.outlook.com
 (2603:10a6:207:6::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: b3a38f54-e03b-4db0-7ac2-08db6e4028c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	K16gk9bOOMyA6M2gjXsm209OS2oXDb7gVl9zHg2yBB6I26QwVa42NlXv8o0id0XLRVn+cVPrLDwtwDhBHfXrgY+4s1FuJoVGlpS3LmHDWZn0o1ORFEdI5QnNKDCeQl+wR1KnenAB6Xg338BOjxxV5h1hL/lZs4mFmS7sX9zNh7KF7MR7X4WMxdNwNtJvP79ASJ7YUDIR4c4ql2V/8Xb5EERyxsFDvulTTGKNFtLXPqk6XOi6i4H42B1ialC3p2LdjCSOfzA72UH590xyVMxqkgwqdh7kseoOmLLQlCZpACWV4IIBJS9ycORNllUS82yRTSMAa2yWZYOOD2Zz/s8OVcenzygnK8zVtnkgoWmIhv4ty7EHKgSi8W5ipZKr7joWwmrNvt/ZUPjyyQdyxZqzMPZNPELBOzXrlxp3aE1olhZaH4BEdYDaRCgYgR1KlEdX7kpfTqbPDh1qfp5sGHH92hmNpvnIV9rjaUNM7a8IFH43F+Pmg01lpi6XMDNRn9UwDNWnqIwkHHZ/mYzDKCFbIHMWEZ/LbeuH8aHHTHTBK1+Em7jfputZ49Y8OdSqzPNmqd2z+xZmSXIycskYZBu2IIuHTmMJQqQTmKlCFfc6hnE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(136003)(376002)(39840400004)(451199021)(41300700001)(86362001)(66556008)(66946007)(316002)(6486002)(6916009)(8676002)(8936002)(6666004)(66476007)(4326008)(36756003)(478600001)(7416002)(6512007)(44832011)(5660300002)(6506007)(2906002)(4744005)(186003)(2616005)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mS84r7Pdpcbq/bbMuqoJHdRXA3MTfIk5YAKeu6+4jdEUfX8HWSbl3zxF7BRV?=
 =?us-ascii?Q?CKR/f0DiCYF+y2VauuqCRfh2/vAcvYBq8xPBVJuePm+68fq0raNwpXTVQWe+?=
 =?us-ascii?Q?meJ0gqSYhHrtuc+VYewSzVQlEzc5lqJCHNKkn2O16UespEII5+uDSpghyMMx?=
 =?us-ascii?Q?ZbNSx44VKbq71V6hRCLM9glacY9v3eOsOE7VV15SeYsx3jgcR8zivob0cWXv?=
 =?us-ascii?Q?7Y00VNz8lk1QvyYr1FAunrjO8c8ut4ISstJsl2C5ujM5mKg2l8G+SmLtn88r?=
 =?us-ascii?Q?dite/rWQ4Y/MCSBaBtZ+xEV56/EvQI76/CahsKHRihKEzYV/KdgkTzGtSYPT?=
 =?us-ascii?Q?kkh2sZvpRsYTO1XQksT1+4CZuDFHbJf0YeUwM5gjGoPYK+T/l/JlvINMuyBi?=
 =?us-ascii?Q?w7Yp+67EifyK+4jlrEpjNXkFIxtQexn+9tm5k/p3ZWFxshnoqHp55+QW9P4x?=
 =?us-ascii?Q?7ETJkH3x1wVorJvo4HDPcttTh42ZTEhJtqfILEjo6wH4O3eFaK9FgWc7hY6C?=
 =?us-ascii?Q?PIPCYE2uV/qnJl7BsxDs1mZckhcD2whuk+pH6hlUzfxryjU0xtkdvPGPKGuO?=
 =?us-ascii?Q?fj3PuG1t73CMoYtxzwg9ca+oZT4PkzUEx+9gMQyBd9eZaCm9nbsc28iysrhO?=
 =?us-ascii?Q?C3XxDdcicwqUvwQ2gl4rDMaRBoPX2B8HW+sQUMx0y4dvO0axuqWpIWhBA3Rg?=
 =?us-ascii?Q?A3y1px1V8QqkWuNip22SD2A0tkKzh40uxUbJZsI+ib41r9nPemKFpWNCL2Bf?=
 =?us-ascii?Q?JcwEVh8eCSIkgOVibDS9oYTYRNEa9Xov3KyybHrM/WCUQf2g3oWqYO1glCTG?=
 =?us-ascii?Q?d9mzKtjjU8LV6nVqb50as1pZh5qPn+q2kwNnYIqupZ/I/GsAiIZgYRnBT6jN?=
 =?us-ascii?Q?xknRhhyGxjRJcimpLG6dkWmvmh7OoUGllx6PCBiUfvJVBmoHwD43UI4MG+mA?=
 =?us-ascii?Q?cVbMPuB7aZjBO3PIdUCSegyqQVNhDnfV1gcZyzBt611usTDkHTjABHdiiKJf?=
 =?us-ascii?Q?yVFqe0aGHrCYugrtsPrBNk2ftpZQXfbHRhONB31IUP1VfnoGmtoCkzb/w4JV?=
 =?us-ascii?Q?y+BB00py82gzwCzyPwdwpOeUET3LxJlFR9+AbT1Xuk2fVCkqdRePP48W0CBb?=
 =?us-ascii?Q?Oxr52IGnMI7j4PAgeU5pmsJp8pSNJ5rj44nacveixO52fU7AGE/kqVcpR0dL?=
 =?us-ascii?Q?px+B1/xhDgoXbC3APszO6Jh3IxFGc6/nvezYoKFb7Z7zA8Fbx9pl3CBL06s5?=
 =?us-ascii?Q?tbke6XahYMJeClfc/UwO2X+ppHFGwKLoU7DAE7dkRiuskn568iXWcBCR1uPe?=
 =?us-ascii?Q?hDsXTeivtg729KKVbHlhIN81eGookYe/rfczk0fMUUa2p82nk1gs0tnEmE2Z?=
 =?us-ascii?Q?Swu82dJbvy1LM6TdFTl1HCJHnvncsrAR1SecArR49Jvr+A/Hd9hXjgVtA5Lg?=
 =?us-ascii?Q?MnD2U28htgIjkyAyioz4kA5PVlSG3wQ3vNTvYw17YwIQZJu9TGqiV89OZMP5?=
 =?us-ascii?Q?ffv1+nXY8bjfPIPr7i0HiPCF07nqPBvUKoVqqXxAK18fwGWwmqhS4Lnll6mr?=
 =?us-ascii?Q?SC8Cp2Gz8shmeEtPy+JW8oissgY4gPL/Xgke+LtjGshPT1wttOfkrNez2ygp?=
 =?us-ascii?Q?5XyNhycj+jXR3c5vSX4r4rFX9lRArM7qpYdEoxjGl4W7hcFFcGFzEy0a5/cF?=
 =?us-ascii?Q?cTLbwQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a38f54-e03b-4db0-7ac2-08db6e4028c2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 08:03:24.5255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vLB0gJNe3AWbvhpxeE04ujvrLxeIFTNHyWlu00K6f/2RcQ9dK0onymjArBm5h7N0tzhQNcuu/+Fhs7MR9c5R+02fq91R2Vxch/X52yTN09o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6116
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 02:28:00PM +0800, YueHaibing wrote:
> commit f2f167583601 ("xsk: Remove unused xsk_buff_discard")
> left behind this, remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


