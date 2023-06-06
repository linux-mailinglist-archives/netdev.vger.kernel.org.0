Return-Path: <netdev+bounces-8344-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 613B8723C60
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78B421C20E50
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B697261D0;
	Tue,  6 Jun 2023 08:58:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A003D8A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:58:01 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2111.outbound.protection.outlook.com [40.107.244.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415A1E8;
	Tue,  6 Jun 2023 01:57:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BAg4/ksm0/dH8qy8uANhYvhDBn7EnKhzNKbb5stKZLiQq0IOwzQiyzurZschj/gOJoiFSIZ1Qhh84xGIGZCmwrXqijEnpiBTTxCMii9lCw68XHfVxYu3GNyTefr7q2wQBuVsbS7AWP1YDATlaGY4uxg070MRj/DDG3CzwnC0gmBR4qXJ3iAfSS0xC0/I5IjWGVkubw3o7KOTvSHAE8UR32lNuIt3p1ouQbVdeMHmyeeYQdYXwD+bLxIK3P7flathFMaCQseQTlc2jA86G0ZSDYXq+5ONAzyBEJATcHmQKlNRdBZ+97XkGJcCTKIWWCcvbEn2n83h4rHeBDANsSE5TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86WoxlMEncMyYRHb9J3Hwt/gPDJLV3PLH+4XNI1VUlA=;
 b=Q9jCp/YHeAeEb+oAAnkJDBBR/t34yMPwAc8omTJjsojB1ZPTuTHxUA5ALXwjrq2CuC6juYaOMFqm0cs8lsQlAM9buOoYt973OAMbObLPmuYlgxVerkJpCLXULzaDY1U7xsbK//ZI2281kuMd46tC3PvCkERkfBbcu+125QGEToGhdMxiVJxhODYYQYTlk5PotQaRJNygy/JVTU96YraBQCLX4u+csG3Mu9SBbIcwg4CDXRDEIpeoPSjYvoNeoznC0Ncfj7vN8VYe2vjLQdU4/dDUthRaKxU0DQI1xZjWCZc/N4SLxN2wgVW+lC0fkGH4NMcE6Dxxja/uKYusLID5bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=86WoxlMEncMyYRHb9J3Hwt/gPDJLV3PLH+4XNI1VUlA=;
 b=vcfL5UzmTeLt+fHbMZaY/m87YQreu/8m1lLcICNtTIb8rXoP3Mi9sZYDv7Wh6dHXa4DNv40y4zrSyalYuhl5FgJ6hRcXz7UxTetuRvIzEV+DFLZTziz5mqHvua8rRbBu9CPRQpSLuyt+6UYDLlNUjc7GPUvLDrd1DFcOPFY0r20=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4813.namprd13.prod.outlook.com (2603:10b6:806:1a5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 08:57:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 08:57:57 +0000
Date: Tue, 6 Jun 2023 10:57:50 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Duan Muquan <duanmuquan@baidu.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] tcp: fix connection reset due to tw hashdance race.
Message-ID: <ZH71DvVRewnmRdC9@corigine.com>
References: <20230605035140.89106-1-duanmuquan@baidu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605035140.89106-1-duanmuquan@baidu.com>
X-ClientProxiedBy: AM8P189CA0019.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4813:EE_
X-MS-Office365-Filtering-Correlation-Id: dd1bade0-412b-413e-250a-08db666c1f2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	a2/bdMxFOEFIp8mdIv/7vNjV1tzDsypei7/EW8vtujRxcxRqk5TyFRrxdSwFl7rEDIHDCZF0HV8qXw/AYt0JA8NDrUe4slW0I2tTwsZkFLir7+SMQ+CUc9c+8P0vMXYjyzbehOT7ODXK+bXmvXZZv/nAHwxIby1b+JGBNPvKRhphkhAHZwvT17GCQLyO0L1omBwgaSlDYM5PKYbW2vee75dkOzf9rC3QxiIFotN9dEzlp6QZ29namDar5B/4Br48HCKG0OG9BYoe8mLrvFltHCCYPp1MqZ46akd6cFx1nuXlFWw6n9zQBzZj0R+ZoDswUX9Jp/L5Z470Ia8rI0EhaMpAbswRymE0pEC91mEJ8/mbdMINu8RbVbP3nHUr8/pWHw++fhaVeT+vTnQC4gJksqUrfYoL0E7bWES6JNGntuzxLcOfSvyMlIEa4M31b1Y4suFVyj4lqTOpfDtRax8QEZrZFxrjDev7yYGBT0bGvn5r2HXi5+Wnliyjvc1DnPF/QvqKYUbPw6HVMUADfJsacaVxfAvRYZbr7OqlRv6H+aN4uZ7wj8GXEhkVKPoOtL8O
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(376002)(396003)(136003)(346002)(451199021)(2906002)(478600001)(66946007)(6916009)(8936002)(316002)(4744005)(4326008)(8676002)(41300700001)(5660300002)(44832011)(66556008)(6666004)(6486002)(66476007)(6512007)(6506007)(38100700002)(2616005)(186003)(83380400001)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ud08E3tZ0dAccYGGPs89DKdPlD8ykfXB5zkUeSgiK429do3ifjp7IBRDgGOn?=
 =?us-ascii?Q?KXMisZfMY6LLzSYzCiL056g1zT+YHDmBFUQA+AUlpWxcVFs07nivk/RgZtTd?=
 =?us-ascii?Q?/jCV7JqoxRyq8Ri2WciKf99tU5xvAH18O33OO4QqFV2wY5CZe5HQ1F08bs7i?=
 =?us-ascii?Q?YhJlpTOHRYclDY8XhGY6pPKyv5rnL7C9ctym6eEMxEeXNIW0gJhfkTdyz0aL?=
 =?us-ascii?Q?dsFazmpgDfOXsLrzbOfHNr09nSZeV7uiq4+H+qDp3VZoDCITHVPSe7lotKKA?=
 =?us-ascii?Q?AsDG3nnUczaXTVBB4cmcBOTZ97DTubtJPfH19DX4qLbSsHW2IzXmxMcTVRWM?=
 =?us-ascii?Q?0beWEZ+WgrpkfXRppX0YFMQtSowrdPGtMQ1EF947lZxPuNRnUjztQgOPWHF0?=
 =?us-ascii?Q?jV5XqVLFn/Ya0D56szxhMT7+Lq/QdBW6klwhuvBJUdKIw7HxoQTD6zTBCIHq?=
 =?us-ascii?Q?BzXvUOMib+jhopFBjt3jD6uZhEO0OzMnHkb+Ees7z1/i2jwz3uh2lkcizpsp?=
 =?us-ascii?Q?PK8/2p+1dQyQjG3lt/DhPffHBxuvnlqnE0GapEevaIZjCesUSqE8X1C+FMLD?=
 =?us-ascii?Q?3HfsSKX59RwxWcD3Lq6JjNf4jsDGyPZTv71/gl2CoaZ7uaWuNKBUeq/hLHC+?=
 =?us-ascii?Q?TF5V8U+dKqL/AG78hlgJ8LfqKw8B/7DN81krkcudGr4Lf0FIlLskAQXGSGGF?=
 =?us-ascii?Q?Cv61+aWUOaipaZOWhDJH0/9VlFqX68ELU0F/o4SBtkcIL1jGTqz6yDH23Qwh?=
 =?us-ascii?Q?c4bm7aSXhtceb07avcP5GC4urdVqKfmuKkk+/cDzx92/YySLCQPFgdHbv2pj?=
 =?us-ascii?Q?wY14eHN8N1Kl7Pysl0zDDMtl7rAMPPsWG1VBJBWdMzCO8Gh2le7bkRYYg4oq?=
 =?us-ascii?Q?geKn/BbLd32QADNcFldHUkwjRBZov8ufPnM7hPztXtXWigZKc54GTGYdqHVt?=
 =?us-ascii?Q?nY0ys3ZetFA09xHgeshOcyl8BojdVSDykFu+Vcl8Vxqaz/9El+OZARbU4gE6?=
 =?us-ascii?Q?jDMu8lT3DBBrk2jpQ0UyE3KtlWi8ooxN5klnk0NMJFAVWLr0t0lPKKtPRYvf?=
 =?us-ascii?Q?V/fntIXUuwfTDvO6ToweX0Si7M2Xc+LIn6D/1Hg0YHo1n5qBiQyfRdkj5rJG?=
 =?us-ascii?Q?d+A7/sjT99YvE7kTyX+hWSzyiOwhkp+oPpMqf6ttHW/BR+U3PvGD9qHccxIt?=
 =?us-ascii?Q?osF7naLrd6w0qy9Rt7u2f1yznjMBEoif15rlKZgnBJSHI3Vgm+N8ziqwOwNh?=
 =?us-ascii?Q?cBFDqomBg23Nb/yGDahVM7ue2eY+ELEDc6g1o0uo/C7cOMvRGq25RoB9iOeV?=
 =?us-ascii?Q?ed28usBb2h4xbdOnAePBJzRh5oI3e1VUY/NWFqHS40VXzbu1/TQ6tofzJ7FC?=
 =?us-ascii?Q?LRmN5kYoHhZATwKvXlGqCqLW/F5ASQPMHdd4sFLVvNfpbTcY1xgBU/fvFBmS?=
 =?us-ascii?Q?p5XwNxgfxZ7UQiUz1wwG1eEPQcDLvwrGi+bXeYvUvx2U4egS6rFje4+SNEvE?=
 =?us-ascii?Q?RoxVInKSO5AkiHGw5XQAWCGMN2oVLCZnPG5/dHODLFMmkZwPambVPiuCult4?=
 =?us-ascii?Q?d877fDxwUTPWrc7pBY726GaOQFC23PKULk/V4usnN9wZCfN/gPeCRPYUvbVW?=
 =?us-ascii?Q?Nbx3grT2wO/O2CCinV3WU0mJmddoRoTJQwg+5/haSMcnTbJwmra3kEvmFAON?=
 =?us-ascii?Q?XS/BIg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd1bade0-412b-413e-250a-08db666c1f2b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 08:57:57.0436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BIzAhANTTjMgwWgvuNK0MA5MRxOTH8VQlvWrp+vysS8QTbHMDu8OXAnUWeNpzzzZZuftxNllC+lp4JEU3JzT2kz4L4Y+tDsaUI8iVLoVDOI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4813
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 11:51:40AM +0800, Duan Muquan wrote:

...

> Brief of the scenario:
> 
> 1. Server runs on CPU 0 and Client runs on CPU 1. Server closes
> connection actively and sends a FIN to client. The lookback's driver
> enqueues the FIN segment to backlog queue of CPU 0 via
> loopback_xmit()->netif_rx(), one of the conditions for non-delay ack
> meets in __tcp_ack_snd_check(), and the ACK is sent immediately.
> 
> 2. On loopback interface, the ACK is received and processed on CPU 0,
> the 'dance' from original sock to tw sock will perfrom, tw sock will

Hi Duan Muquan,

a minor nit from my side: perfrom -> perform

> be inserted to ehash table, then the original sock will be removed.

...

