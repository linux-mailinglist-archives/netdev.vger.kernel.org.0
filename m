Return-Path: <netdev+bounces-1407-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 101416FDB19
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 356C61C20C6E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332A36AB7;
	Wed, 10 May 2023 09:52:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD8920B41
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:52:58 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2104.outbound.protection.outlook.com [40.107.94.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53187698;
	Wed, 10 May 2023 02:52:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k25cjRAfZZ9vQ4oYaSKVqGLug0HkjgIUj5E8T2YdzdJ2OSNVlj2c+p/D/JcQc9qFCL5xt4fAiZJPtK8cNBZZViD3I+zDkyygMwNEJJi/uNELSVw/je72CoE5qwD91AKNqr7dfDU1HqcWGoxjaobjLyUTw3aXjvRAaQMP/h7G/uF8nqb4Z3qvtlrvrIcsfsKTPUIwnF1BbH+mb6zJMmMT8VdHZvJYrZtRTmKYOSDU6EEy/R609dTKVTjnBAmCoqMPiCPWuaRhDLgxe+3JH3llBFWkjQG+WX3hzH9+oacIsonaT9Dv9V1hL1t1PBpgRFQbJu1AkhzISA2L7BIsxnmKdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SN8Al/ebtNDYMvU/GYW1nUMlgg2cySBoHeTIpGLLEXw=;
 b=avgpupX8uqy4qu06bFgfdZtDJwN1LsZWQ7w1p6GFauMxDNbyrmPgGi2qFRo4sYE68VWL2P3SaWvJWdIHvRfvQCfSCWudDi1ZznEiBqaLI+Us75i2SBj04iFtl8lr8yLD80AlCbGzQc+FGjtscsBBrd51BWS3x9HVd/UOQEaD1QaXhffSammDXmXG/8Vg3NB9Koj8H2FQ3QBdB7SZXqcsm7s6xfORP+MNIFMqD7tLxSQzCMoD8z+TZmY1NQRo9nSFla8MbvLrBc9VXFaxJV6ty0S4Kr4WSfp+ybfB4cO5vHSWsHjP1HG93wKgBOmBIJDUijIO0ZMEgoH9PhPc5PZegg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SN8Al/ebtNDYMvU/GYW1nUMlgg2cySBoHeTIpGLLEXw=;
 b=oDkrnF3U8PX29QOAVIJ8kDoKU51vzapeha15phwz35Yc27+uccFsNFLSdmvPzmxp7yPkclSSwLa936q8vGS62kCsT5549Ib4p+3VWJdksX3+ZYgVxwDJMdXvEjJGN28nqo+C5ngqBQssQI7luuoKen+eOV1N6977MFVqBY1Mnas=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5148.namprd13.prod.outlook.com (2603:10b6:208:33b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Wed, 10 May
 2023 09:52:48 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 09:52:48 +0000
Date: Wed, 10 May 2023 11:52:42 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Networking <netdev@vger.kernel.org>,
	Remote Direct Memory Access Kernel Subsystem <linux-rdma@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Gal Pressman <gal@nvidia.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net v2 2/4] Documentation: net/mlx5: Use bullet and
 definition lists for vnic counters description
Message-ID: <ZFtpaioobdtM8ZXi@corigine.com>
References: <20230510035415.16956-1-bagasdotme@gmail.com>
 <20230510035415.16956-3-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510035415.16956-3-bagasdotme@gmail.com>
X-ClientProxiedBy: AM0PR02CA0136.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5148:EE_
X-MS-Office365-Filtering-Correlation-Id: b2e12ff5-5d29-44ab-0c17-08db513c5006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	spwFxoM+ztoFTSdHDJE5a+nKhnFopzdwk1xBeLGd9p86hBo3NMmfpdr7xGQmqlejO76x8rUcoZneLVhM6l1CvUHNpq0cZI4L7c72kVYIwHHTXWN+fp//nISQeAXauJiTipuOkae+2tos0lHX/OI1mZHYPuzcp7d5iXwXMLr8Riet4yYHxdZjAi+XJYiRr14tkGw83XVon8qOflRy+eM/MorG3IQUOlKR8xRu5WoQfjqq3blMEB7HgvKYN9NoWF6dcHlNM3V4mEmGN1XezstHM8bn8dq80GRUHl7QBBwq9lM+on9oCRcbCuhjsYOieHfeJUVewL4nE/IwG034txBJ4uWaYC+HVgcoOLmDpRgTbF4likXkXAtHmJzvrstyx8gqE0McrKwja54JltUbjqAaepw3fvhOhjrb86kkUSlQmpIef/hJ/DFTSx1R9NjcEFRQvMQjIi0FlH4VUVBhLskAIFl09S2t/8WeCk+VnmXv4+xcezLZIsMcp1jkWJxR3qJ3YL++n0d446wMxxGWSkotfzCHve5EF67vYULWFAPK13daBM4Vidy1MEBn1AY/ecEf
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(136003)(346002)(39840400004)(451199021)(186003)(6506007)(4744005)(6512007)(2906002)(41300700001)(6916009)(66556008)(66476007)(316002)(4326008)(38100700002)(7416002)(8676002)(86362001)(8936002)(44832011)(36756003)(5660300002)(2616005)(54906003)(478600001)(6666004)(6486002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Msc+CKuNMtrMLLbFZZx/4A1fEaZA8zDxnWwlljQjLgUVWGfREC4NrB9HIpFx?=
 =?us-ascii?Q?mzSIpWtbjoM2VtQ48PwKaiCXgfki6sGoHL0tAAg6JiPze+WRss4mqQHObZ5L?=
 =?us-ascii?Q?HNLk/9Z7e1jwWahYDCWVtKVbSiVQFI/H9MH4Bx1ct4co5pdLm2f2pRbHgU09?=
 =?us-ascii?Q?nLFS5qVmIUJb0bE7TFmEulwxAi6wazg8BpEgyenieFvH+Vwv83CabJQaUw2V?=
 =?us-ascii?Q?AWmKi57tai17TqyGt49fT7D7F5papERXUgmKVMTOlaV0XBc65OzjGCZ8EH1+?=
 =?us-ascii?Q?qdis+XoncP/xjFVJrwRhgRJY2OA2HF/qitvhzcUqQPKRGK/yPmYKB9iFhuU2?=
 =?us-ascii?Q?sH6BltNRd7AtVRjNXArY4IFcTGi1VoKiZAOj3uaOkPz1nLXRlN8t8i5ARwh6?=
 =?us-ascii?Q?dKQHiexobBw3LUAO5YGmVvONiJEn/oUXdUhZyKxwtSNZZmYo33/HOcb/kWoQ?=
 =?us-ascii?Q?T39qs60WWtpvx3KJprF0Xb0K4KPUMoIllrPBQIn+m4a2Wfcq2pVhyqOP7mLg?=
 =?us-ascii?Q?MbA3SkbaWP/YeB3/Hw9hxBYam3X33zj6IYi/8LMi9WDkwR4PAti1W3pA5JzS?=
 =?us-ascii?Q?pCK8m9f/zn50ohGkEd1621QMVTtFtDEn89+cQurk6bNl7pe/llGpndjQrckU?=
 =?us-ascii?Q?GXMo3854Xd8TyaOhKc13Odm9WHX16ZuEMZmVE+m3fOv7NIAa9gU+JFXdC8Rq?=
 =?us-ascii?Q?RePIsvBxnK+EJDxFmc16YlSU14vPniKflLRe9RKmrKY1aBb0nzFPHtTVqJc0?=
 =?us-ascii?Q?B9KNzYx8HNTwdKArm0r1nc8GOogLN0fgQd2yhg02MHMo55mW5V9CipDjPaif?=
 =?us-ascii?Q?F8BaWIWv6cGQoa+kMS+W3R+I6BZoiwZVPh/taOadRVEk/MZnANVSNxDk6NrH?=
 =?us-ascii?Q?USoVCjPnei616uUyF/AuOQg/RXWdeqLS5xBR9Jd20LzXCb9VxshJ6UukFQ+U?=
 =?us-ascii?Q?PXSjHeIJcRw+nEMgEuRGkjRw+MYK+KjtkvmrqBoN3pFTaz8V03jz7zmXL/eD?=
 =?us-ascii?Q?C26B1+ZKXQsJ5Ki7ub+6WrQYR1JUfIYqz4GpsB7e8EYmowl7MSbJsIMC1El1?=
 =?us-ascii?Q?52WyO/ICALZuvJwaNBw3pySiG4Q9A0Ps4R2sJBBmXEqrA92TVQ5ws2MaolfH?=
 =?us-ascii?Q?5npekcK96Yo4XAHC+CazC7k3SDMrnF2ot/JeGcupAeVS9mqsfhru8zqTu9Uo?=
 =?us-ascii?Q?GP+9PwEdzIL1Lu2cpUMtiJo/EA6T4iWw9tfEYnObs3psHMvREDRbEv4/1Vmu?=
 =?us-ascii?Q?eOnVjoOmw/KjeBgkop6zHhMzrhQR/udxl53jXo3xfH7c3b4VRXT9IqZNkAQp?=
 =?us-ascii?Q?sNmrnpHZ7RFMsxEpwQ5J3Te3V8DfkxBnC/yLH1az8wPwPY2aT4R9sIlqDcuq?=
 =?us-ascii?Q?dSixH2ZZ6EFpYHNIX57N3YS8F+QsrgOStjtdUW+OPIu2Y6MJeKa7UJDsUL77?=
 =?us-ascii?Q?CYrMopso39TYkPRpyc/y/8S95Eqlu5+Jvt5D5EXVptcovayZ2+ByqSrF6sf1?=
 =?us-ascii?Q?Np63vRbgwUH65kzEche+5x+LWvLQOgya1aIJK82LYGqQ6VbsE44Eu5FVJ/dz?=
 =?us-ascii?Q?XtyQDMI4DQSvqb/jKAGod0QzAHL0fctTkts2k6FBONE3cImWz4cakpA7YtI0?=
 =?us-ascii?Q?SR1XZY15fPQm7akGH/ZW3Ve/ji11rr/k71DyNWdHygDSleSEzPxQ2zr4LVrp?=
 =?us-ascii?Q?FpLCsw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e12ff5-5d29-44ab-0c17-08db513c5006
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 09:52:48.6952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RDQsAX9h0AMFubkMOpHGuikqOmad+QAfvlt/CCHckW35odWej2n9jHybAP8QA7Pm9N0qFZQXYyfA0NOii0l7co5ltKjQE5aqCE5Xh1cY/gI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5148
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 10:54:13AM +0700, Bagas Sanjaya wrote:
> "vnic reporter" section contains unformatted description for vnic
> counters, which is rendered as one long paragraph instead of list.
> 
> Use bullet and definition lists to match other lists.
> 
> Fixes: b0bc615df488ab ("net/mlx5: Add vnic devlink health reporter to PFs/VFs")
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


