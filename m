Return-Path: <netdev+bounces-2910-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 861877047EF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BC4528144F
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B70B2C720;
	Tue, 16 May 2023 08:35:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D05B1FDF
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:35:32 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2103.outbound.protection.outlook.com [40.107.95.103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F6E1BF6;
	Tue, 16 May 2023 01:35:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXGq1q93g871ehp4ItL2c+X7+HJCx5Hchsf/p+c/XFfk4Dqktipuk4Gi/D0mPRFpMXqK+cQBE8w6CzTsvpPlp4E20we5ZeyYi20hOCs251MvsFUGdy0yCe2L7CM5RoYM8X8xFNf0GjIhHVVy5A9z+Od++OZZQXR8oX+BOcKed/3MlD9VK7joJgeY00C4mcTjiRfIMaP3I7GLjHh04Z4arI7U8b/p9WUCIfMaIsVOqpaBRmucU5V+JB31N9WksnWxBgZEJVX3CG+t/v9kdbwt39BN3PD5lGy78lpxTKiq6E6DFcw1rVqX+ZJ1q3d7bO7qEOOIwhy/lbeTtgC3qSS8LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJ5fLaD9YZwPhfgG0yOqlaAPkyGtSH/H7zf1YiquN1I=;
 b=hY2wua1T5cQl013vVqweibmUSx4DZ5OEOWIbSovTcBoxRtcn6CTpefccHPv7VS9j2CJx3UzsixXQo5kwen9iEaByBnSvOmHW1UQ/VDyBz70qYEOHHbfzjSbYcEhlO9RCWBWCWTQkyDYrykAjm6j9fb/vQ/GDBGKUerE6mjNapbNV+STSh68RZX4kGY+PEBH6Xcz61y+9SH7RVNgxGYJuGkwAQ/EYfkETIHjWf6G+FgMOrRzXk2wXR4RjLFWYSV4cRtoXM3eTWlhZxsHaqmLvzyhuoIF36PALRJ7jJEw8KkTzd+VF40xLYWuu96tg1SgBg2nQrVxwL0THqKUDhswtdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJ5fLaD9YZwPhfgG0yOqlaAPkyGtSH/H7zf1YiquN1I=;
 b=mdOnyoKu7+mNnRDDNk8+ZGKHUxdC5DO3+Q0em4Vw7nZZUQI6Nnlh6bK4E0PwNac91nlseuAE9KSRLgdCTWboQWQRGwn/Ar0vgfUavG7agXsVqh/f7UCutIAS1mfVVBq59qxn0eOIV4cX3CBZ2nzFoDSvWjjDc7iPkJxe24yL1lc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3669.namprd13.prod.outlook.com (2603:10b6:610:a1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Tue, 16 May
 2023 08:35:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Tue, 16 May 2023
 08:35:27 +0000
Date: Tue, 16 May 2023 10:35:21 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Jiawen Wu <jiawenwu@trustnetic.com>,
	Mengyuan Lou <mengyuanlou@net-swift.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] net: libwx: Replace zero-length array with
 flexible-array member
Message-ID: <ZGNAScmz4v7AUcm6@corigine.com>
References: <ZGKGwtsobVZecWa4@work>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGKGwtsobVZecWa4@work>
X-ClientProxiedBy: AM0PR06CA0104.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3669:EE_
X-MS-Office365-Filtering-Correlation-Id: e4cce5e8-54e7-4673-d268-08db55e88057
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	k92G2ntqVgGqCkixYaRWs9sikJeRV0MsywMVLfZxz59Cy6EQ4snvgTSnqBR8gD/2QstsYF3ugLvVav4/OEbPZ/stt27HxwOFmF/vl17N7gXjQrDq1OKDO/nlnNdwzhcWYv2JMlDYIfuqQGXPFPu9+ebOnSL7XvMal6+IkMGUpNH6uF46K+AhvJAIZITwHH3PEJZs7czy8UUxU86/IRx8xM1vK42wb6yon5wiVJWu9L9bmrH/nX659uSLU+bxtDwnr/M5TG4PWxXnEiQUAD9Ig4axJ5S20WIw1q4J+3AAIEpCuKxOiLvgpY9n03yY5TA3CVrInFP0PI5Mm3QKUDSys9o2ZmWCY6mxSGphGUTZclt0DSUpndal9FSmbd61Mp8JWSyZTL/++el1FtLt02WskyyXdUDeOsB9iBfN5odpp3oF1A3WcQNUjDAQf/6Iq53zaYjRq75dTJmCpl0x1bpOEWs3IBEIlheByHX2WVZrVB3EmYUsJRbpc8bvlT2kBNAKE5hQsDTiUviFiaFuPl5KsdIpH9hoMvSQqH+DxRD+qD0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(376002)(346002)(39840400004)(451199021)(38100700002)(36756003)(86362001)(316002)(6916009)(41300700001)(4326008)(186003)(5660300002)(6506007)(8936002)(8676002)(7416002)(54906003)(6512007)(44832011)(4744005)(2616005)(2906002)(66946007)(66476007)(966005)(66556008)(6666004)(6486002)(478600001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MLcf0YgP5X2e5a9JKkAGNJa6deorYvDMHCHtxowC4IlwrTtZ7I9p/nQdL/qG?=
 =?us-ascii?Q?u7fY6L5gnzphnnEHFpqEU4fy5a8y/2WqR2GiNxWHfR7GhO1pPbOx9HAW63c4?=
 =?us-ascii?Q?LsUgTlvvgByUVc0iXxlQDbhyhSWs9v0ZMIQrPBd8iowJ+ttnG+9bmNp7gDZ7?=
 =?us-ascii?Q?vh0FxI/oE0ybmS879lkyFdRUsWV6kme2tvOBn2nIGCRTTAouec+Rz5H77mqs?=
 =?us-ascii?Q?SbsGDxvlRMAdH34Wk1Jw647ZhAZV11loCKEkCxqmMzi2qWn+nVnJP1vcaPgR?=
 =?us-ascii?Q?QfkX2PrL/JW0MOFDb2TrAFf8r8qqYAjewsKzuFny5jqUbJ9PPYmBprQ11Hbj?=
 =?us-ascii?Q?6ICfiihYbAAgI2qv8K7qXm3d8Xm90ZYEhC4F6WeCQUV5c/ST9+0c4qpPZPFL?=
 =?us-ascii?Q?wZGTrbRg3r4UCk7nryGJnEk4AqzS0BceJaRG/amvvI39ngvmjCDWDndhEppd?=
 =?us-ascii?Q?6TD7vf9P1DHsC0FctHXDqCTlhUX8GTPuPyDgf6+h7F/xDDKUKHu1rRSS+mdz?=
 =?us-ascii?Q?CcDofEZnP2/pkI1G9rDCafxRMbIlaZJ/JA+ncOKdD8eogW/BXu8Pbbn4fgHQ?=
 =?us-ascii?Q?gFxEuN6GrL4axc23cC6yktLVQEuP3NZCRkLcPc+smA+9w9EqWeN/oGBL5Fo6?=
 =?us-ascii?Q?axjYcQpqP4pEY9jGzQpASBvvPxml7U0VzJ84jdbuwQkCqxDvjXupjCWlz0vY?=
 =?us-ascii?Q?h29OEI+YyolAgOzkgakdKV+hQTjdrj7+8qwxZoi2pPF4KoweGY1smoUq3IhO?=
 =?us-ascii?Q?G0298j1ieC08nWqUXilCpiqFxj5Lbarbwh51H/g0zg95YCGbbvsX8iY/oEpc?=
 =?us-ascii?Q?xaQI30yxk1VA5XnahS+q7nSBdqgbDClvQ3zpzRZuPOLDMQXRozYWaLjxpC8D?=
 =?us-ascii?Q?9o/iLKRgegSNnLPw3H1UY4HUMk36kB63WPByUGblMVFIzWEZrMteErF1sLqA?=
 =?us-ascii?Q?0LHZOtF6u9GGO1FAu5jBl4WAV0xp7mSPC67VL91e0SZ/P5iaEFO5+2raN8+D?=
 =?us-ascii?Q?ED0qLbdUZJE7xoQDqLtpw5MtCjbA7PVsrm9s1+GDOTqPDtXbmF/RtiUxjku0?=
 =?us-ascii?Q?EEQ05VB0d+KY2VKE8K5xgpGGFBfuFIoUi+KC7jHX5LEVu0wxpFO/SVDiQspd?=
 =?us-ascii?Q?BzNJ4fnEjlucRv5Jukg6ru1Gj4Xdo4k5uPm/NQAlIZk0DP0Hp0gN2QEKvnFc?=
 =?us-ascii?Q?7yGwkICcIkGfSygLyOmVwR2Phk6lGXoZRtprR0bkxEV9u3uuHdhFVRK5cnzY?=
 =?us-ascii?Q?hpdYChyxvXNQhwcd0mYCMOsFsNYJ7Ag61RbamlTwE0TXkiUqzI5G+3ACBYhP?=
 =?us-ascii?Q?KE1yIR5WsNUGeFQcIKbrCdjuyiResmbqKwteRNePO2nlgk5qYGE1qt0qpnxa?=
 =?us-ascii?Q?2D0ljEnRya9tfEH5aQ8a9ZwPCoGMbIJNG5M9Eb227MMe28fZH83JV13h34W7?=
 =?us-ascii?Q?1bL5elZp71syfz/V/bGSoPJ0/W1sjOX0Khp292jy9g66xu7l5bqq083FbdEZ?=
 =?us-ascii?Q?RCSwUmkwVKNp3QH4S8Kzhp4Spa4MgQKuWwhla7/bw73qjM9dVzpPEPTq2/Ow?=
 =?us-ascii?Q?3JGGvY91ehxzZ23OQZvkyeO7t9vZHYk+uUpRUxh4I1iiLUGN1SjKLmwvBgV9?=
 =?us-ascii?Q?XYyUto3vqGyEqyIUT4d3kndhbrwchYS7UU4WAw1xgTpQsrFjBkClgAcr0wdC?=
 =?us-ascii?Q?dcQhYw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4cce5e8-54e7-4673-d268-08db55e88057
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 08:35:27.8446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WIk2N8AImBFd62BF8ep9FDOxR/HCr5DkkwITWUqTvxTMWkdRUaNgjZYZmxdFW/N4FmxMO3/RgwPm0L4NBx6yH3ZjGL6SdL8oGKJe5I+Gwpw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3669
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 01:23:46PM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated, and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Transform zero-length array into flexible-array member in struct
> wx_q_vector.
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/286
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


