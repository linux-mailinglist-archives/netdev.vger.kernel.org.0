Return-Path: <netdev+bounces-8339-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3B17723C45
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:55:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B192281515
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B2A125C0;
	Tue,  6 Jun 2023 08:55:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D540B3D8A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:55:51 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::70d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709368F;
	Tue,  6 Jun 2023 01:55:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNwjkVkA7clxwlgSebeKJlEPRhsPieykU/DInlKNvcyrEApnCh8Voxu83rbadx4UPtpGjy5s5hGhWxUfLHu4RJEHRIypR8SVyoF0yyqZG36IG9CEsRt3dcrSH0cFpmMKHCXII7OqvpxqvhrWDbdQfXsU2HzGE3OQvQks63DVMaVmWAVAtE/5q/+0LNS9iX+ryUzLtpZ0YoxsnMhm8PAVz7d7T370oRYfg29DtUhKXLlZNSrw1jIfpPdEiE+9/pjK1Q/TsyCoXuURs9bPsYciBX3s2KtU90PXLKx10l+9/CA6zSLEJVUoNDdT2HeFWIL/WfHOjV4YRnaIbcSGtln+1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmM/1BcUTGhGz1Kcbuz9V7gLGN9k5UpxGGUW3UYoZys=;
 b=kLpZ8UGzpVwmWEP2WdR+g683PQ2oxM0bkG8+Lfpw98hlz+JTr07sXdZ2mWISHzvj7Wa+O9+PlcROAriCy4GUoT7S5gjcVjdoZdzgQ+lp/Pn5yLuoujbGNxlA9PHYjqFmziTwzFFUIRmAPbWJlETOEateELfhrhLkUS81oWdqKL/1temp0tV7cChZbbG6uqw+m6w4Jn6CoeXGNEtvKCdo0rHtOG03tOjFkb/wNiNY8V4dXpskFDw6e3ldBrtA6Wr5rMM4iWPKdpMofFh7hyam3WP1Cr5xk1JmseJuwMOfYx+LdIzj1fUiqUqaYXDh0ObbhBqFEAb+fEW2ykNVC3Wosg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gmM/1BcUTGhGz1Kcbuz9V7gLGN9k5UpxGGUW3UYoZys=;
 b=Wm2vot+H8xApqy9Chejucb6tTyUvK/snGpWBJ050yzUj6dmRpAeGXyA7jODV8nrY8LUi1jivzkBBn9SNKNhrEXVcV4rZzv9jJmwWwo/bFT5kRw899Sycn74LzZ2GvLKuXQJjDI7weoQbAgk+ThuDH00P4Nht5O5TKH31CtW762Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4813.namprd13.prod.outlook.com (2603:10b6:806:1a5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 08:55:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 08:55:46 +0000
Date: Tue, 6 Jun 2023 10:55:32 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Derek Chickles <dchickles@marvell.com>,
	Satanand Burla <sburla@marvell.com>,
	Felix Manlunas <fmanlunas@marvell.com>,
	Eric Dumazet <edumazet@google.com>, Nick Terrell <terrelln@fb.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: liquidio: fix mixed module-builtin object
Message-ID: <ZH70hGgOVQ89APjk@corigine.com>
References: <20230604043213.901341-1-masahiroy@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230604043213.901341-1-masahiroy@kernel.org>
X-ClientProxiedBy: AM4PR0302CA0034.eurprd03.prod.outlook.com
 (2603:10a6:205:2::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4813:EE_
X-MS-Office365-Filtering-Correlation-Id: c3b10b50-446c-416b-433f-08db666bd15a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ud9bAJ9xYVPq0tmJfzwBuWlL9PXCshO1tPrLdlMAhvjJ+yrmZIbO+nw/dGhB4jNpT/B9VsGeyBLpgWb8aq/QwS700oKoQ8JLvhk1We4hBJVyXctIRwtzdnoA7OkJZ7tqnOop5YEpj3NUEwpRm6uLm3e1n3cDA9ZXmbueeU2iqPflzr76AqIzHUuLepuUNh+Ln5Q0bd7KdmZPoivDSdTiODEHCxIy3FAwbmFdRMJF59xmVb4EX+dzoxNLdactgR7tb9ObG9tWLPkJVj/c2aOFTQV40v0xVM7KLmAufsDHoIR37hePZjDPqjrWimThLPPVZyPExKHRs8L5d+niHtDgRDka0uRZpjhP2oUhprdNOcc9vTkl4DoNSisNSXSrp5xbeHesfa8rwHvzZXPdD/VIvr/sACqwwTFVhL9kanLhU5HY9pocOHxc2s3W8JQCdaE/Ob4nGU/8XBQH3S0yp36KP2c84c/AqrkY1IPDcYeD46ExQ0jQNkdsUtk+EKIPHdOXJVpYuex9x4qwldJ0315//tQRelUGzOQRYPBYWSokpdbYvFMwV1tjpi03NH/UsQeO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(376002)(396003)(136003)(346002)(451199021)(2906002)(478600001)(66946007)(6916009)(8936002)(316002)(4744005)(4326008)(8676002)(41300700001)(5660300002)(54906003)(44832011)(66556008)(6666004)(6486002)(7416002)(66476007)(6512007)(6506007)(38100700002)(2616005)(186003)(36756003)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?esr7QGqAs8cQEhFsPvu8MPH9ul6iRUzXvnLmUUNHQjZ0znYsCIC+RcqNRqfu?=
 =?us-ascii?Q?1SGwL+IYjSvYaZvc4gAkJ0OEiLT4WYaqilOlXB2jL7GKT/vvZF38r5m53Zp1?=
 =?us-ascii?Q?3HNm1O1vraDI3kxHTD8DbaRMOVpRdP3GSJv4ENdHgdsyIeM2Cdmc5eS4kZxN?=
 =?us-ascii?Q?h32cdxrS4ny6KBOk2ZOtRbWwBuBis8r40Wn37kYS/SsIH8sUSK0GNvTYAGbq?=
 =?us-ascii?Q?pnqxK43lfaW2pOVXKZQhQuIzUt6fRXl6TWBNUzB1GQNC/DwhFFmTwpKVICCY?=
 =?us-ascii?Q?AgMHYkiioqLIXstjOAOy+PcB5JZbbDQv5aD/TlkuQ6oDZVn4Hf8JsDuhX+vu?=
 =?us-ascii?Q?mfeJWBarB6OCcPQw5ONh2IN7D6jSjxSNdmPBeXI0Q+e6HmBxuOg0aRI4g7i+?=
 =?us-ascii?Q?Nh/W9i2lWGnKrZUlab/hAFUncDWBd4Kc7Fs8Gr9WQbkU4Cq3DUeGEVMLRnyg?=
 =?us-ascii?Q?jJAkeM716OAwFKAtZBWPHRfXQ55Cetsd86SE9xZFWeAddk5PYXVy8oI8RRO7?=
 =?us-ascii?Q?ZFm5mssLlso1MDIsPmxDQICGqm2s/CILG1jbxpy3GZSsxMj/+21LPlbdeFp3?=
 =?us-ascii?Q?75vXTecgXZbhPGpiHf8d0cG3jcyTdaPZG7JoGJBr7L+6PXzfHa2iUzPcQq47?=
 =?us-ascii?Q?GKpgVJlL8xZ1tmf2/atbsGESybqs+KETXP+pe49QiMzPvPYZcTwUJLILgc0k?=
 =?us-ascii?Q?RJBfCqSD/4nyzfKkYJ4OMJxW28dLtIQx5jR6gxp/C+VAGnNt0EtN/0Zbzeg9?=
 =?us-ascii?Q?2hsBLlrkiYVpD1BJ+cQo0BroTE0ppbTxTodsncuGkqyloEaeneDBGaHEsAm+?=
 =?us-ascii?Q?XP+cjqxWTB4bJQ3p3HGQeEIiOf9c+elGVSu41Guu4t83O+CmhTFGyCdwfj9q?=
 =?us-ascii?Q?9OJyAoSueN53H/mR+Wv7fQREU1c/8Kodk/wAkrfXqGfQsq4nv08hDw5zr91+?=
 =?us-ascii?Q?7jCPtTnYx1dqx/WdsxpVLhTsVYXvfAGzc0505qi4Asu1SczX7kVJ+d/e9HaK?=
 =?us-ascii?Q?F6XsU+NKuysL0iuftQvD/sMBZBgMVRTK9GVsSSv4tF6qtN91HAiG4NxMvhI5?=
 =?us-ascii?Q?1fzdWU2yVFEYGIVcknSW93bCp1lSha8uix8hKvuT6Byv3SD6GS/owsNRcd/c?=
 =?us-ascii?Q?uVqgntkSsfmk4M0ME8xR3ZTsfpJ0NpcuIVv7nVVDPUelJxF9Eul2KlZq7Vbe?=
 =?us-ascii?Q?+gPjT2bVB5K6UrKjPyj3MrvtMUoQlHJIE67k8jYS14+Z0XDQISSdZ2N+9xDg?=
 =?us-ascii?Q?Vpb/EeG/PW/YDzSSBDLaU/1vXE7f7qsuUIrHfpIrr38qNgr4XLOwA1tXXE9p?=
 =?us-ascii?Q?rDLlVNLirq13o1f6d7LK3MNdtpIRHAVnyPam2zP2nhg/qftZpPnZWgGNt66k?=
 =?us-ascii?Q?B7qUy6G+TLnAhCRtpv+rc1mb/rLzt3JSR8vB7OIgL9dB0nlpE4Kvn2ZyzvWH?=
 =?us-ascii?Q?GxZ1JWTzgKKGNnP3RSOXoXxhMPdl+2Cn7coudXxTyE79xh+udmp22OZkeKDQ?=
 =?us-ascii?Q?tCt62ntXydynr3U57L96XJhtQptPE/4a+HKftRFGycFqNWF0f9dfDoh1G7/3?=
 =?us-ascii?Q?3p8GisabOyotXS1wTVp3hQCM1S1rpgrNP+fZILOpxVm7mIUfwqttFLbUpCkg?=
 =?us-ascii?Q?O0PTrGzV5OLoZAPw859GuUADabvyoD1c+PGKcYb9VaWC+zcRB3qEscpZ6LD+?=
 =?us-ascii?Q?vkO40Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3b10b50-446c-416b-433f-08db666bd15a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 08:55:46.4369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TSWJHejOVW5IJ1Vrf9/E/MtmG0DwotWplUrSwUjAb3yoVZ5PuWayZE9wGssVlrn5qtMPV/YN+alzTt30Rq+kwevSD4JmASe8wH72pmHpjAA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4813
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 01:32:13PM +0900, Masahiro Yamada wrote:
> With CONFIG_LIQUIDIO=m and CONFIG_LIQUIDIO_VF=y (or vice versa),
> $(common-objs) are linked to a module and also to vmlinux even though
> the expected CFLAGS are different between builtins and modules.
> 
> This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
> Fixing mixed module-builtin objects").
> 
> Introduce the new module, liquidio-core, to provide the common functions
> to liquidio and liquidio-vf.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


