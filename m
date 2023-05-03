Return-Path: <netdev+bounces-90-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03FAF6F510A
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:17:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE63A28103E
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 07:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D061C15;
	Wed,  3 May 2023 07:17:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996D5EA3
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 07:17:41 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070a.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::70a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A080422C;
	Wed,  3 May 2023 00:17:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUNNbZZzE6wl8R2/dThxxzOQYTmnda5A0zZXgh/YcNXdlLBm6J6qnzpYiYlEPmQGhwLOi3l9hhf10qRpcTy0a8nThOn7FCzxMsigoJAN0RAjbbsb73mNZp9wLYI/pavqFKsJ0Sb5Su3OvC89+Oa3aCGhiRG/htTo3NnQnYeMtFmOB7ffe6l4A6u4+cFt0IGM4L8BW1ZUrO2OGibV1yZLLb8ryKJNqZJU1Kmn76OCBVqI4hjda4scB9TIO3lxXV0CyBcI7WS7b+nED6MzB4gy/jOn1wO/rmOjikI7uaJXGFvAFu4zB1VfXU0OLDeYhSU5OuDptz6Ya980JkFLGFjEag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqwul4Pv+n2by0CX8OtKH2PVhTTeAQ7Qmh+FfV2rJvc=;
 b=f+b+NmG3zGBmTRGx0djARQ+62lpmS5CrNut96ygEz7hIfibu0983oDuCnn6tK24Me5DkGQQkuyAnLz09swYJndLk9N79u/bGkWl9u98Q+/0Z1toVM5IeGOnPQG+sEhDWKAonQwIlBhKvkf1GATRSdSi+8Rrgd/lP34cFihNrSMf2ELuql4Gma9xFrLupabx9Kr0x/ZGOo+Ng53GqIJLtac453FhHsAEK7K0jEbhZquBPX7RrIxSwOopLm3peJ8BRsuqlf583KR9QIEDYblzCWUq4xPL8SsAEfl/8SUoMEPeiS7VXIsXvMnrV0302peR6ZA29FMu7p8kkXjNg6/dfhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqwul4Pv+n2by0CX8OtKH2PVhTTeAQ7Qmh+FfV2rJvc=;
 b=IVEB6z0rkftXuVM4w9aYQUMs9cnodh6whDDrxMmGJAHwYxzoTjRy02QNdYkS41Mi4zts0kc5nb6GLJWKfzAfZ89ap0aSUSAi4XjzDO4lEU2YcXs4ko4XPfqw88dIv8lkBaYezvkd/xyaRAtzaRm7fWFFv2cOZ/HJVFfn65o9ZSY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5972.namprd13.prod.outlook.com (2603:10b6:303:1cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Wed, 3 May
 2023 07:17:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 07:17:35 +0000
Date: Wed, 3 May 2023 09:17:28 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	v9fs@lists.linux.dev, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] 9p: fix ignored return value in v9fs_dir_release
Message-ID: <ZFIKiBXbgtFLymLg@corigine.com>
References: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
 <20230427-scan-build-v1-1-efa05d65e2da@codewreck.org>
 <ZFEiOdK0/UxKiPQQ@corigine.com>
 <ZFGdob9PRHSR-6ff@codewreck.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFGdob9PRHSR-6ff@codewreck.org>
X-ClientProxiedBy: AM4PR0101CA0060.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5972:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d3ff749-f42b-4a6d-3c46-08db4ba677b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	K+pR8saCZeOIybje6yfk/bYLEgy/gn5SSlOJl6uDyHLYMVcijqWmaTeKFLpuXd98No7/GetYX4yEW3L0fkWaR2wCw/R/Q+IvEf7bELgXBNXm56s3Df7I3fQYJDBwBbjldZLLBxsbtoqk5xI8I/xIpVodZqnUumcv2YxHZ3fVLek2FROCsO7ZajA4rLllVyQ7cF/WSMQUsFWkDepJqogo2nZR39uECEXRwHleYvz5xP3DvX+ZX0Mts+kKSkKiG7afjQdF4LeQKgVgW2SSTB10PgTq8QHLf3QerxwJuZ1w0pxPvJXSYHyAFBwqeY4EXypIJ7W1YnP9Sjn5lbc9SsGLxDZWH8O1epEmnVF1b5/MZ9CkGtTpSyiIyhtmw+6XSDQXdt8NfpvxbgPA571LIFhwe1X6cqCZ/3JIM8wOyW57chQPaek77ha+owugCK+mHPncXL8C2TMoNvNb+Y2bqfePe4UUTkt+MXCs2TelTHJJ7AAbI7LUdDgH9sVpdT7Z/+ZQvQv9BI7xf8o6iuap9AOglnXK5tRf8DHW4y5+12qFU7PmdHJSRpaiopBt3xJWiQ7h
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(396003)(39840400004)(376002)(451199021)(478600001)(54906003)(83380400001)(36756003)(6512007)(6486002)(186003)(6506007)(86362001)(38100700002)(2616005)(6666004)(66946007)(316002)(4326008)(6916009)(66556008)(66476007)(8676002)(41300700001)(8936002)(7416002)(4744005)(44832011)(2906002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+mZUB9CcoB8ZaoyVB4PtMPNpu2lJZ0695WnczzDjGAE6RA9qIRTD8jFcm+NS?=
 =?us-ascii?Q?Gr2w9pMcZnAfb9xiXP+aGFFDjtvOJBh2kZq0vjV0iYbR9wdlJfMfkw3Js6dT?=
 =?us-ascii?Q?3yGFuYj9Wjj4mRRUnK1pcNyI0RJZB5ZFUyDsXU4MneUAC0yjfJifdT5xQqNn?=
 =?us-ascii?Q?FBWLeuK5m+tfBNfd9e5lr/pJvzn8biAn8PooU8d8Hp+N8RfymKadDJjpHQLl?=
 =?us-ascii?Q?S4Y/DxPQSOIFifi7IFr7jU7vGsFT/qQNiqCmSFuVW+6gECIwOrsrx00zOYrf?=
 =?us-ascii?Q?ZSukoU1LWUSn504wI8Lfq3AaqIVnMp5lgaSLKIYB7bQrLcCw+acYawC2RmnM?=
 =?us-ascii?Q?hdpWRXKIPJYtG7fBtbjHDaoY5fF6pOtPX9FppVCe0DQ4J8FLWQhiDOrm2Fi0?=
 =?us-ascii?Q?ILvrxEPTrj6ov5wBhDQayLBaj6FFlZKkiACNnajsXf23/+uOPkhc6JnntT8l?=
 =?us-ascii?Q?pfndtFq7Tae+PY1mneVYjq+a/HYtlcVTQOnexzavXxvw0pgAA/mX7ZGYfEow?=
 =?us-ascii?Q?DTEvSQh7d6sl8aMbTYDdrSvxGuB/71yZ05MlRygpBojTioXNIlWEktgtn3Ge?=
 =?us-ascii?Q?sNeXpw3rvY3yj/XX5oCra0+u53UDfPG7u/+U8GAHewhvYnCBNpSKaBZVDnDJ?=
 =?us-ascii?Q?a8HTYODYS0w7ueNeC4PB3K+nGku2SbxGsfBdEmDGqUdlTXRedsu1HPjA/djW?=
 =?us-ascii?Q?5eHx7kE6sjDmjCSUOBIjqNYQpvzUKcNhIj5zxDEclHqllnicyWmHbuQzm9Ed?=
 =?us-ascii?Q?7ELAOBKEoPu9hIU/BShfB2tP/L+P20qpsyzKHavmdVkk+ZmxTiPNdnLIgFV8?=
 =?us-ascii?Q?MHBW3u5mnZpDSfFaOucV2K0vOON7D+sydtl+aA4+tGh/Zc04shNfmvODMba/?=
 =?us-ascii?Q?1cObK3yMj3QKdMQPv5U/pgxvZw5PHbpWG1qIMQ7Q3uhrZ4oXYu5PxN57Tzt8?=
 =?us-ascii?Q?auYpF+rPKd3WXAVXwtA1D0Dpug2GH84LH1C543i/YGLtqLPz3RWFH+VWX/p9?=
 =?us-ascii?Q?yQkvjYhx8M7VYe1AMTNNlmk48eOJeJRQlhkTEouqfsrkpOaEr1Ikibgn7bB2?=
 =?us-ascii?Q?nW8KUIDCKhJGjpoUqJI3i7PRGeFsTUwwbwNL4R1qDpNzUDUlnhW40DV8hDti?=
 =?us-ascii?Q?bimBTwvOt14vnpP4ocIKIgWooIYNAkRlgFMwpwxhsQWiELQb4a2eJY+fkUEN?=
 =?us-ascii?Q?Hxzwfdj6hSRHOTo8G07mtgPoSQXTUx4yZmFqAcLC+a0HNpoHxhU/maARsNKy?=
 =?us-ascii?Q?syQlSjHh1cGYajM/S36dv/41hb3cGCXRGmo476S3XegyT+guburOzvOpEUwy?=
 =?us-ascii?Q?734Sb/WzjUdG15SkPeY+LMiLbMq6M9KJas75xCBSYBM0epjL65bfQhHDcEya?=
 =?us-ascii?Q?jTqws/uVCmak6Dwv0vJBUQxxjPU9EBKgDvFcVMYA7B5lBzIevTVrfvKysu26?=
 =?us-ascii?Q?b3KT/K0q4P8aC30WQUu92o+npBYHIlZR7Q7TD3v7II+IZ8MDF1NQb1YTq3Zf?=
 =?us-ascii?Q?BnWkFhGiSjz4T/ld//NH93KGQsqJ//iF+1G8/NpaOdCE/HCk59K3urg4F4Iv?=
 =?us-ascii?Q?SnZgdTvoU+JKJVcP0eKoQ8Is4GrvlnJ1mP+5K/laSGLRgZsmn0FJb0cR9iKm?=
 =?us-ascii?Q?z+KFrVETTls495Zc2eiTRQKLnF7A7Ez3TFbtJcv25bRn7ZvCbDguorUQd+2D?=
 =?us-ascii?Q?Owaezw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d3ff749-f42b-4a6d-3c46-08db4ba677b3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 07:17:34.9285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tbQhf+bE+0pFuZZ4jx7DTygxt7G1dK69JiqkLvoCTbVtVp0G+/Bh7aqvm3AHSK79xRl2LesD2BnwsHPL30l5OaK0k3rcLCtSn6Y03RIvRJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5972
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 03, 2023 at 08:32:49AM +0900, Dominique Martinet wrote:
> Thanks for all the reviews!
> 
> Simon Horman wrote on Tue, May 02, 2023 at 04:46:17PM +0200:
> > On Thu, Apr 27, 2023 at 08:23:34PM +0900, Dominique Martinet wrote:
> > > retval from filemap_fdatawrite was immediately overwritten by the
> > > following p9_fid_put: preserve any error in fdatawrite if there
> > > was any first.
> > > 
> > > This fixes the following scan-build warning:
> > > fs/9p/vfs_dir.c:220:4: warning: Value stored to 'retval' is never read [deadcode.DeadStores]
> > >                         retval = filemap_fdatawrite(inode->i_mapping);
> > >                         ^        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > Perhaps:
> > 
> > Fixes: 89c58cb395ec ("fs/9p: fix error reporting in v9fs_dir_release")
> 
> Right, this one warrants a fix tag as it's the only real bug in this
> series.

Hi Dominique,

Yes, I agree that this seems to be the only patch in this series
that warrants a fixes tag.

