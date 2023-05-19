Return-Path: <netdev+bounces-3921-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C638E709900
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83E0F1C2128D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76DFE107A5;
	Fri, 19 May 2023 14:09:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0B8DDB1
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:09:01 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2130.outbound.protection.outlook.com [40.107.237.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C553A3
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 07:09:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sqr/j1rVCvlwgSokEw2/1UNGKMvVjfjduAEmIdpPAlHNrO1maBUTvWKmQvL3fDfLXDSV2FbbUd7YHuC7vZ+5sSy44kczutZhfrlJ9jkGjBFjFXi6lySSa7e5xB5OMOBb8c35TLQ5M37IJr/HZDxbK1t21vu0ldthBbPtp0vqLCK04m/mHwiixGXmRFA6xnv9p1O1F+neIm8TGLkV4E1eqYdKD9TQJGU82Q3WfUrgnMu2OKBvF3nEnQ21Ir/c1AtzG/vEPw3JGku68RyiY/ltIKzJJGPZejssBEr6J8x3OsYu/mCI3qUUf+Wd6r4O+C15YXOMWJlDemrHZP/pnFeATg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iK/JZ5S7UE0gETRXcq0OKycY/5GOGtt2xWA2YfgiWWU=;
 b=aWoU9U74Cry8674bshpB1+UGURAmSO3o0EPRkXDGqo0o3A10Cg+ZX8dRyRi438rhwFegqqAdF0q/qBZdima7/+oAd1FVgwM6zm2HLYHpeA0RqRHQM0vBpr4uKgE939djBvNyoJ+wb+CS/SJ8n9RJFecrnWhscGSGFjOjfNaoUCSXuH1ONADwwEL4LRFwncULvu2Xs1buqP/xtB6yHhps0051+xmKOGwlNSNG5reGDkF+W8iwD3aMayXOsjSeTR65FhbtMYu0z4etSuZhiLNFmz9ku6CKLCNIEt+Bnj0C6Jv7r6kZITp9zsp7YM/3KPxEGNbmEVfCHJV8mHVlcviq2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iK/JZ5S7UE0gETRXcq0OKycY/5GOGtt2xWA2YfgiWWU=;
 b=m8kNE9yDWjOXaXZKB5ytPs6RTD+Ss6Ji8LIWRdDMl0Wvv9sDYVoJMmETGDaQO0Rhm+u0PCyhaTk9EdWG3v9okWaJNB/YJZghre5ALoLwY+bZITgCNQO3/uRxf9hFcivYR9T3UUbOQRpup2ECYeoqrDWbOEXIm8YID/5Pf9rYtEY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6204.namprd13.prod.outlook.com (2603:10b6:806:2ed::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 14:08:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 14:08:57 +0000
Date: Fri, 19 May 2023 16:08:50 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
	dsahern@kernel.org, pabeni@redhat.com, kuba@kernel.org
Subject: Re: [PATCH net-next] net/tcp: refactor tcp_inet6_sk()
Message-ID: <ZGeC8vimPwUwJ9wk@corigine.com>
References: <16be6307909b25852744a67b2caf570efbb83c7f.1684502478.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16be6307909b25852744a67b2caf570efbb83c7f.1684502478.git.asml.silence@gmail.com>
X-ClientProxiedBy: AS4P192CA0027.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6204:EE_
X-MS-Office365-Filtering-Correlation-Id: 28a1fb12-5b0d-4f59-eb90-08db5872966a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SRb2G9RnVhRtg08Aoassf/dat/klDECPh1jn146/2ap9YSVgfl1SmIbwgBGZ9zPaVxqsgv0GHDqMzcuo61lNtU+2CyU7K4pFaPEz3w0WbsjAxjolUiAWGcj/bCPEupi36HG2fvbR3ygxMnkHjAgk4ceUC2DEb2uQtS7lz4E/euihvERtUsGaakdncCmhfloLjBPzmu1uWQDGfif5VcubHq3+9IYOkAjaJc1X3g92DJu7dzCNiV+sxKT5T1suEbGyt5t3LqbuNhKLRu2iEVjP1JMojQLN3emL+2voxSP1MiOpPLkAZIlvvbHUspjtIA4r+bXXbH+u3c/edptqRqpIJwW2g6gW9u2IMXRhRIZ4PFJT2/OVFmdJDHYahOcUIpg1d9EbH7wuzDrgtdqdB44/YaRM5XPwBy2bbSxHdtHde6qxy+rk4NpgFxc/d4yq2Q311ztGZlx7B8elC0MEWF4OQP7Q0OtBxE5/CXZXdUHlj/6LGMu8uTXKOGQBbf+sxmziUeonT4Wqq6SYSZdOhCnt8BroGjgKDmAUrUjh89pzMSIn3YXmlsIv06kdoqPDapQYUJRCcK51bFFLDdfeCIpMsrdI64Ea0rbmmidw5qXG7UI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39840400004)(366004)(346002)(136003)(451199021)(38100700002)(6486002)(6666004)(2616005)(6512007)(36756003)(186003)(6506007)(86362001)(66946007)(66476007)(66556008)(5660300002)(41300700001)(44832011)(4744005)(316002)(4326008)(6916009)(2906002)(8676002)(8936002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v+Xh3aFBRJOdoWIrf9uGZ6ylHtoc1zLeuwTPdzo2U+vIIhMEh7V7gMkSfdEn?=
 =?us-ascii?Q?ck0awyJQN8iIFktvjouaYJNsb8APBLE8oO4oPTkiZRpXqJgVBj17FWWv9GdB?=
 =?us-ascii?Q?JrYuKhdIKAAUYRx1+eoZIVH0jLoygFURfgM4FIVIa/kBlg1bAHojOoLXjm10?=
 =?us-ascii?Q?vzq2ucSMV7Lj/ODAzxMzFrveihLGW0HZ/coRND3Ge9x7PYLO9LQ9TY9ZtQ8F?=
 =?us-ascii?Q?vyIvZLZHvqLuiVL5Chxs0SRttUJ2I1fCx6TVTXl7eNyrOk3K550Y9YxMvVTq?=
 =?us-ascii?Q?lRhKIccFHJrllakXXeVCL8jSAcVpKzxAUwaipduhfgreCfMu97q2Fo7DcGLA?=
 =?us-ascii?Q?uBZ2xaHy6VGR+89gBvC6X+PGo33P9DwhVCP5HKDOe8a62OsHRd/yxlmmWIKh?=
 =?us-ascii?Q?Nlk65wNgp/fG6c8xWOeVOtTVLHtH8lWPiFrcHYoxvUEyHfbgA6lVQBcD1Pi1?=
 =?us-ascii?Q?ivcDVGZjjNJ/3z730gEsKCtZJJgVcShwnmLucpPYcaXbEqlPvjwjq7FEESw+?=
 =?us-ascii?Q?nzdW42dnkL11LHHPe9bbtMBixWSY02wEAQixvIcR5XzC1ePi6sbdznHrKT4I?=
 =?us-ascii?Q?NU4wB6u5UNbYakQPpi6ZaTcecHwzQBSsUjhx3EMaZZj64P4s706x5fNvad9g?=
 =?us-ascii?Q?utB1NdX3F39JYb1Odl4hfEpMp1TxByTIQcltdvvrDHx06ZGBDCzFfd1qh23P?=
 =?us-ascii?Q?C7LnI/igWw2pKWhvch4Hjgz3JloNZ7g1Kiut0eXOTl42a173PC7Pcd5agWxa?=
 =?us-ascii?Q?5Z1tNOxGTjBdTBZAqMbN67Ap3S9ZPTtC8G1cIcFUYYLcSVBUAj0rq8COYAd3?=
 =?us-ascii?Q?OxHF/PVb6DExZzVgE667ICn13a9ZWOGbFm7tPpr3Ra0TBInVPGm69YyWa8jD?=
 =?us-ascii?Q?wmiVFdrpt8NSwMUXBNYrujflxReAlu/90d/rp8E5Sq3wuekxpg2K9wOC9Br7?=
 =?us-ascii?Q?B7PazpbVJgx6PspEyXsHWsaokg8IiptNVi/DugVWDMXNKPVmTnMwjUn8oyRK?=
 =?us-ascii?Q?vpCvFqngWA/CNlOuoMcAJhDGivv/hZk5rdbCZXg/JJgtOYhVt8qXy542jTUy?=
 =?us-ascii?Q?8MK/nk17ra/sneqS/lREGxHk7slisxvg/BGo32dbWWmZ8+xUzR/rZAkz7K83?=
 =?us-ascii?Q?3K+QvcZ9iRP8svSuo4TYhXMDP9/+Pp+VrVqQSSe/q5/IIcYD6hMo8rsHsOqI?=
 =?us-ascii?Q?hd1MKdBWCm42vepwdDe9X9nMunu09DnWPlL5oDbNgeXjya/VLJobLBgn8UU/?=
 =?us-ascii?Q?m57OaJlEGmMvQiPSi4yJ2bpmJMZuhklP3JlshNMwmxGpxGvOqDuEsF+FWNgN?=
 =?us-ascii?Q?OrSG2z6KAtNeAGTi+ELKgcnbmUPad0sUPU9wen84SbesBz2UGmFmvkWnzEh7?=
 =?us-ascii?Q?msaszjmzz3YKzwoOt8/E7YjsgTsZd7STG5QNyjEv8TyaLz//4iDonivYLIcO?=
 =?us-ascii?Q?jbN5R/tKREPI4n4Lwa9ix4JltHlbstld6AgPxgcaKQiIyrZr/ceCtQqwuYQm?=
 =?us-ascii?Q?HeVf3BR4/Nuv5AZMjtacnZQRtsMviwIrEDUDBElu4sbInGc0d8TIEdEF4zTE?=
 =?us-ascii?Q?CeR0zlAL+cvdKomkgWX0iOL7dMFp7R9Y8fzAuZ7dIDff6k1PsFiZagMEGx1P?=
 =?us-ascii?Q?sCBrVRF10+UTUDG11CQNk9Mbo66zv6AwdVUENdnRMeiykbeBOr38ct09/ydP?=
 =?us-ascii?Q?RL2ehg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28a1fb12-5b0d-4f59-eb90-08db5872966a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 14:08:57.8308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iFbfwJhwF7QbH853COHPaQrRgss0l2egXsB+Qe80KPCfbCEc60+vjo/4oJ6eRTIawsM7VxtYBSz9stigU/1j1zThWHJz49QLurqn247cK48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6204
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 02:30:36PM +0100, Pavel Begunkov wrote:
> Don't keep hand coded offset caluclations and replace it with
> container_of(). It should be type safer and a bit less confusing.
> 
> It also makes it with a macro instead of inline function to preserve
> constness, which was previously casted out like in case of
> tcp_v6_send_synack().
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Thanks,

this looks good to me.

For the record: looking at the x86_64 assembly (objdump -d) before and
after it seems that the offset is consistently 3064 (0xbf8). Which is
consistent with the layout of tcp6_sock reported by pahole.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

...

