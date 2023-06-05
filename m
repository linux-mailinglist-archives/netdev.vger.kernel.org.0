Return-Path: <netdev+bounces-7983-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F0472255C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78737281101
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76F5C18AF4;
	Mon,  5 Jun 2023 12:16:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF6017AD1
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:16:29 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2122.outbound.protection.outlook.com [40.107.237.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8ACA1;
	Mon,  5 Jun 2023 05:16:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxgUGJOtDdBALgghdhqHuILaxh4CklS6k/PUyH4R9hqJYA6rFXHOfEKdN5HeBjXHza3DIqm7jvGoetSXBKWKZPp8k67Y8Bt5cBmjxdOJW0t9qS4O1o1KDb2ElQBeiIgMwggA372f0I2ftg4uhKOHpc4IFLChQvwhhI1UvSveq1jrs8XY2JYCyz5MC9wPbkLmSFrUJmonUtF2AbtGhha794jufKCAlEeAcsVVSzk/s2N2YcwS1YTh3P9BbKFYv8nWHGAKXz0ztTEFwq0CvalUqESsM4UqpCf3Ry+Z0RG5/C/2i2SX7vSdvN+sN3KibAdxwQktfn7gWRr8MisVs1VBng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l1HvLdXBH0y+r1Hw5HIXjyxJMPUU35VHtgKR3IrdTTo=;
 b=gor4B2ewo29tOI1zAVM3alQHdQfxOiKaHz8J2tOBAqX+8bOSJptrl6dhUpaqADVRph3Ijg+iTbntPHd73ALiwUX1Rm0g6FYaqEAB3pzxIf7NP+829vtVCIPNUKCHVWaelorkehRrQaxBaNwFafgV4pMhfhbXDbkcjVvaa42kmbg7cS86L+0LvYy6+xQkyaBALIskHjf/GKx6/tV4BDcJs2G8FkdsPe+3uljibdsji/lsUqCoRsAy0hBxuheBk5AuVnIvHpYsWoUDJih1lhCrK8er+Y67WhD5517ahvmXLH6EYZYVF0qjh5ld7akb153LfYc5k4zu1CcdlWvo0M2BcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1HvLdXBH0y+r1Hw5HIXjyxJMPUU35VHtgKR3IrdTTo=;
 b=GUCqL/behykicqbS+2RwOYc5TC/QHt+ImkjzvFOQknpuuT7Vn36+Y3v/wF517l9LqBtGv1G2M7NJIbj98HaJ0oluQdtVrCDAsgQuYMSUpSwZEf4NMDy0RoIGbt1JexmpPdmLOPcC9mRiTYfC4ab/JJJ5NVxqyRl2o9k+Zr50L00=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3833.namprd13.prod.outlook.com (2603:10b6:5:22b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 12:16:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 12:16:24 +0000
Date: Mon, 5 Jun 2023 14:16:18 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Jaco Kroon <jaco@uls.co.za>, "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/pppoe: fix a typo for the PPPOE_HASH_BITS_1
 definition
Message-ID: <ZH3SEl7ZT+MBI7V0@corigine.com>
References: <20230605072743.11247-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605072743.11247-1-lukas.bulwahn@gmail.com>
X-ClientProxiedBy: AM3PR07CA0133.eurprd07.prod.outlook.com
 (2603:10a6:207:8::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3833:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bdcac3d-e755-4473-684b-08db65beae1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bWUF6UupqkzPFBxq+Z0muR+kRnKMTlJoiMYLNUBDCsSwWSrV6QDdiKlhyhWUN1CgasxH3z0MxxhaAg8dolG6c55Pu8lduOmcHnC41lTBfF0DpLiocGp4fGSJgQFCnG0Q08pm/mabmE682JiAOq4/AVEKPYbZjj+qs3wbUzG5MECeaSGdjqX7THzs78ibA1T+Jn7MI82rY3ifPCkjYgvmB2RH48MgwA1bEDU6Ewv+5TOcdZgIdKy7G+mVC888o7tVZqs01REhydXHeafmOA3iEVBsVCEYZn+ytVzzm7eSnonvRqqVJe131GFpq97M8r06kmBnlXDoZ1H/JIRutkhpGjp4QJEC371UTLP1ZETeVrMBlwT/M4ZtfOx0cHgn2gWRdtHJW1crX1EwPzmpeidU3jrPcwi9sL3jsouvJ+93E6/+i9l++Aq6Er4WFsAoFTIWVFW58wHSrvJaUZMjv2mx5UpTudGfueSe5RfzuX3US6qxPgLJxTPOpba6pUAX3a4UZbC2mzkTSfVb74rR4NCPqrktQHj/GsPCjyCz/ldGcC0ZqWfb6xRjNTxQgXQ7ByPT3Bkrv4qS21Ja6JwuJqC8IQaTWbO5+UWcIZYu18XTSCE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(376002)(346002)(396003)(136003)(451199021)(41300700001)(316002)(54906003)(44832011)(5660300002)(2906002)(4744005)(4326008)(66946007)(66556008)(66476007)(6916009)(8676002)(8936002)(478600001)(6666004)(6486002)(86362001)(186003)(36756003)(2616005)(38100700002)(6512007)(6506007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZJJED86+VRYbCQZDeVAvjNxrXYQAQW0fLva8NzRKEIQOg23CGmpn1vCgkgvn?=
 =?us-ascii?Q?1osk+MWADcWNMNY0iqDEa9g8i3csfWYry+fneOncFhQ+8VEwlHYEL5xOM+Kc?=
 =?us-ascii?Q?qRb47t4uXOG5aC11ceh3JYQNZ8WuOlCpkw+4xynkPzArgO2jpkbjQhj3DK27?=
 =?us-ascii?Q?ia2qrSIQ/QO4vuQqQTjBugdfN1EzuRA54KLr/uuZrNVA2NlhJ3ezx9xQMujk?=
 =?us-ascii?Q?3xn8P9R0IXBP2YuXUKY7CBvTt4/z/Q05+jyzJBoCDRbUlCnLQzTOTtirRLsp?=
 =?us-ascii?Q?IoLjSRIEp1E/XtrcI3CNhhr202mpIgu7xo7v8/dgaId3F3xbZR0rnuoby7c3?=
 =?us-ascii?Q?1kUMwFHU+ofplvJSqDmXvnCwbdxUPgx5C1P9JvF1VW50K/JQoyCXbPg0yATx?=
 =?us-ascii?Q?bAvvvMYUNzfYjSV679zd3ClX+WdNYEniDaeX2U/3ucg84z3L3pYtz1c+DNTT?=
 =?us-ascii?Q?oLo2He+9DqdFv3Cjr3pWquMsALtxwuRb3BJjmwDZHiVVTZnz85jJI0krp8Z3?=
 =?us-ascii?Q?WMq79u2OoDK2ONKXqS1A+gJXOzgbCMx8p7EASUlY7ny2TuuD3REl20LN0J6z?=
 =?us-ascii?Q?TcdXnSS/bod2yJfazHtzcviLTfNCu50GHIZYcjcrDQnS7RieZu0Zn1uhaSEz?=
 =?us-ascii?Q?GB/8p4tt+UF2i6TCKvWVOTOF76L4Dzk/Hxz641aXkpYIh5J4RMVkvd7bwM7R?=
 =?us-ascii?Q?7U6xPpi1aIwYTH+OJXIfFw5SrtuSq0whcgMXtVg5LiSBEQPqJXtmBQaFuw+f?=
 =?us-ascii?Q?uNseHceOhi28xUqcyi3J0YbaUgIFg708mYNMXWRp5nLF+L8zbLref4JkoAv0?=
 =?us-ascii?Q?EEqZu5DJjK3faweMT+LuZTv1JLltNG7MCOBSwN5VN2T/15pKwvW6Cw1yeWh+?=
 =?us-ascii?Q?TNNuhEPQTJPShRCd4Q3K9Ge883tavwyvCWBctBu+xmYk59HsrKkmUIUp/wry?=
 =?us-ascii?Q?vh+asB0IFqdFrkHhGObWgzoKnvVxws9RJqT0CMMpYny9SKDe3LJ0QCX7AVFx?=
 =?us-ascii?Q?JUgDBK8bRQ4/lbaiTt3X6C6+ad0UNjz5egnrZdAJwxFyOeI7dQy62OybBMqt?=
 =?us-ascii?Q?Tn8c3qFaHJwXayza/of+ww3SjLORCRsGECQxt3gvqRTgLh+cCurcnkYxakDA?=
 =?us-ascii?Q?+QhoJocw5uSXN8EUbusWMA8YcEn8SnEHM/gE9ENSiuBIHJU/tM7+olr16QKO?=
 =?us-ascii?Q?AB58lttz01CjJsX0obj8/vye1D7b4dyzAqs3YWfMlNUodqYyFDCJGMSd5/n0?=
 =?us-ascii?Q?IJJL0NqRcjWTFpZP85ePHgJp8BYW9FuENwlHMwgb4DwqZwtx8peZZCrucY2V?=
 =?us-ascii?Q?1DUbl/UlUkw8w0EYU5C4o96GT7QgnHGQd/xIdHP7RJvWXczKhg6Ke73v6ZqA?=
 =?us-ascii?Q?JAcifCrhrO8lgy/of0Uo1uPn7OdOSata9oPm5GUmLUFh6rcFbvYidHyMO8vR?=
 =?us-ascii?Q?AWVBneTyeIiElmDfa/98cii0M8tyx1wjPsK1hsnbJjzP9GJLr0RYQEnt7O6w?=
 =?us-ascii?Q?KBSt4DTLIvBVqhh0gQUyiftd9+PGgrExpkVvs6nCXVLmguD6FYbrop4/tubj?=
 =?us-ascii?Q?EZI0txxp7fHvTUDIceKrhvNoBDwqd8NbS5uFvjqegYbQHAife5jy9dKm7nVF?=
 =?us-ascii?Q?ZYxpcYJExgdcsGeudr43BF6TlVWLC482VKrFLYdZB99xXOdJ+pChM7J5a5HF?=
 =?us-ascii?Q?OHUnww=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bdcac3d-e755-4473-684b-08db65beae1e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 12:16:24.5590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLZD2uBY8XNvqj4HgJbmibkKx9gnv5BIF8J37RYSh4AzcRTymvneKGz2s23lQMh60tdf7i3wPqC5w8/nsG81mrtSL8R/ek/YCF4CMaGOMUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3833
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 09:27:43AM +0200, Lukas Bulwahn wrote:
> Instead of its intention to define PPPOE_HASH_BITS_1, commit 96ba44c637b0
> ("net/pppoe: make number of hash bits configurable") actually defined
> config PPPOE_HASH_BITS_2 twice in the ppp's Kconfig file due to a quick
> typo with the numbers.
> 
> Fix the typo and define PPPOE_HASH_BITS_1.
> 
> Fixes: 96ba44c637b0 ("net/pppoe: make number of hash bits configurable")
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


