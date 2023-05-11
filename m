Return-Path: <netdev+bounces-1836-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83FBF6FF411
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F5F4281621
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E181D2A0;
	Thu, 11 May 2023 14:25:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5685C19E69
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:25:57 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2098.outbound.protection.outlook.com [40.107.95.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7ADD11560;
	Thu, 11 May 2023 07:25:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyzWV1D/Ej6ZdIYqNW0M1u+kclk3nYUXXL5mSr8G/AqVbt+eGXB9hzKm8GkGT9lY1uWVEfJUURtv0IwaYKNb1LNffoewTrnGTk1L+iLQab25k5yn53a12qZhzkpy6PNzgLXU/GVhG06x7tyZ/dv/lpn3/2hRi8nrCDT9e27grf1LYiFmFam/FZamKp3g9QEa+6TOh7uGzEonjaECUlaP4NCrl4lTHmGfOvsd4Lmc+/s8PhSww/nwD7l4xu9arJt6CcsLHz3d1n0v3041hXs333LlhpZZrAfuFQkYQjxfioBuEIIe0w2IksBNYGg+wNwS43HfjvfFLaB+5KuFtLDorQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9U79cpNmwvm6S3UJXs8MwGghonS9fR6yAEI+zHP42Ls=;
 b=WXpMpxKOytENBNFvlW6QgRByz3Yl3wZePD/h5I7GloOUW21Ylr47ZDejwXXkiz4quKIuJH2gMWNZfsnDprI7JHpVw+Yajw+Tov8YjW3JHYdRjKu+F96SS5IAeB4CX1KVpMuKaBepnYiX40i1whkjrrLBpVrmWGqEydEEKbNHME3XWoPxDrPZm5Tfxir+SCKjfEib0fsjyfyuXDuflEs1XzU/i96MPuH7Xdb/kjD22DPOpKE3gKkBEWg5Eg0H+4mFAklGbd6jm+eU7XBUBfI7ziOrSptnZ8NAk0EAjmquy8a0ZLBd2GqhLZVjfQN+ugn8DIMVHZb/VyJdHAUlRof87w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9U79cpNmwvm6S3UJXs8MwGghonS9fR6yAEI+zHP42Ls=;
 b=pLJzfq73NMguBR4vZNGHJcQGwCnwWK0QL0NqJsdQ7LtjD22rIy1YoRsiQwS8NDYUT51tYDDItULQQh67mSoNsvkQDrULPd934bJ0T7JR5FNqXKWKOsAwxhxxbKoZv/ccKLI8CMduD8O4lLVKZXotzupuQxIAQtVhYYDPCeHuFGQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3637.namprd13.prod.outlook.com (2603:10b6:610:90::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Thu, 11 May
 2023 14:25:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 14:25:50 +0000
Date: Thu, 11 May 2023 16:25:38 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux DRI Development <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Networking <netdev@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Staging Drivers <linux-staging@lists.linux.dev>,
	Linux Watchdog Devices <linux-watchdog@vger.kernel.org>,
	Linux Kernel Actions <linux-actions@lists.infradead.org>,
	Diederik de Haas <didi.debian@cknow.org>,
	Kate Stewart <kstewart@linuxfoundation.org>,
	David Airlie <airlied@redhat.com>,
	Karsten Keil <isdn@linux-pingi.de>,
	Jay Vosburgh <j.vosburgh@gmail.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sam Creasey <sammy@sammy.net>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>, Jan Kara <jack@suse.com>,
	Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>,
	Manivannan Sadhasivam <mani@kernel.org>, Tom Rix <trix@redhat.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Pavel Machek <pavel@ucw.cz>, Minghao Chi <chi.minghao@zte.com.cn>,
	Kalle Valo <kvalo@kernel.org>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, Deepak R Varma <drv@mailo.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Dan Carpenter <error27@gmail.com>, Archana <craechal@gmail.com>,
	Thomas Davis <tadavis@lbl.gov>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 03/10] net: bonding: Add SPDX identifier to remaining
 files
Message-ID: <ZFz64scVmh8uN/wM@corigine.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
 <20230511133406.78155-4-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511133406.78155-4-bagasdotme@gmail.com>
X-ClientProxiedBy: AM0PR03CA0039.eurprd03.prod.outlook.com (2603:10a6:208::16)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3637:EE_
X-MS-Office365-Filtering-Correlation-Id: da5a6976-e4f9-4f30-7d25-08db522b9eca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wltKjp7WkHO3K7pXD3W/0K5rT597FOWCj+i0W+WvFVdEaHyAskLvv92HSd1hLgUpJVIt8w1EnroFU2spwPo8ER7lSB+umanU5WIFj5xfTBgTABvwTDwLVNDobmgn/4vlXG3DSnNZkjxY2WKkdDqouek+Iv81xpyoq4zJKUdPD76rsrvC/uJpPUnqJQkc7s7WrwxmQXqjYg6Un1+H797vHKlXTx667pbjRFJu1+eWJH6JJbBhgbidZK+YbSNLzQoWcnEY0NU1Bbpiyhj4nTpqCg9pZdlwV7SWS9pzKbFfv7RG9HL53AXX3TDgWIxQA9HXfwoXgfRsA4yJ+iPp2B3C8MzQK+HNfj31KtW16veJTxh6WrGTngneAMFLLbplopUX/AsrksY4bI6/7xgUFpaWvhO0pzTII6gXe0S7/2R7XlafOj06xtLX9nJK9PwWZdqNfU8r6C3ljJBykHj9+ggchPkWmEkNHcMa+06EkWfW0PwD5gGDdFVKSSdJWC1RugCjUgCPS5+v+09N8Dg+Jkn5YxvT8UsdJdGcc2c7QCZwpR7uhiMTVjipPIkNO/QIVY16SQCVRz+Boojq1T7md4xPl4IOq9C8BfBC2mcyOuGZoL66w+qXsrn+scgVQOaXVZ8b+0Kvy068ahR+QIjfyWXze2PxuzZKcbs0BfCh6V3lG4k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(376002)(136003)(346002)(39840400004)(451199021)(38100700002)(5660300002)(478600001)(6486002)(6666004)(8676002)(8936002)(316002)(6506007)(186003)(6512007)(6916009)(66946007)(66476007)(66556008)(4326008)(41300700001)(4744005)(2906002)(7406005)(7416002)(54906003)(44832011)(86362001)(36756003)(2616005)(41080700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wfdUi372akd6Dlev+CNPWCjKmUUQkKLBKmuqlj/4HMg/n/XFGWiuQyzRRJ6n?=
 =?us-ascii?Q?FsSNBhzs7hYqL5pNXGLoDuSYxSKKSWXiyg9badAhyX515WHsGMjHnzwzgr11?=
 =?us-ascii?Q?qRRBaGIJ8S1Gl5OsOA3P95U+vqk+q5krOFvssHRHrsk0c7sxcqavw38KhcBM?=
 =?us-ascii?Q?Pmh13k8wsaQ2jdgNovQXFTb9DRxcfglnarKK9yjj/GoZK6JOetPGG+NmkDpU?=
 =?us-ascii?Q?ySbrfHLORrYplnJJf+z+CxSlsB3E/bYhMShNOAvMpo8HmNhPQHFDlXl4Sjag?=
 =?us-ascii?Q?TghOk34n/l6VfYmOOhD655f5bOG9uSivZZsIXs008GTOLy3qH9fzaNXxIoCg?=
 =?us-ascii?Q?Pa4LabvrsRNKHQIVMqjGx9JyO/oadSzi1VdDJ4679adDMnDgDqmPMUM2gm9h?=
 =?us-ascii?Q?O7ADbz0CbQogzBhJ9KTa3Bqv1w5jITjP1/xlEMw/7kmQED0hIkvo01njs7+p?=
 =?us-ascii?Q?GODn13o7EowqF4K8M3mmgccnZ1090J7J0sA7GsIPBjeWyXu5lYMVAGjrzbwv?=
 =?us-ascii?Q?lTVCbKI3ra3hMC8dyjwXK6DWU+sJM1Ce2AHY3BsyjFfsYtVpTikDsDGKAdTB?=
 =?us-ascii?Q?KYSaHrRxn3UtRfgMYnzApnSNzE/iIOZMiJ88inP6AZ3wSuJZcLq7LAVJXbEp?=
 =?us-ascii?Q?P2GTMBWXvF6UslL2Jf9qUd1fUhhLZcQL+AVKDxz+yrZXqG8nV6gijIbfdeFR?=
 =?us-ascii?Q?aOWMCuYRnrvQlCQsg0ssC3EFlS+pjHQL8kzDU9cdGhD8huPWW6wdzA/r8iF6?=
 =?us-ascii?Q?JmhWisdsx20EVuR4LMXphEuYzEylhpJYh8tzat+FiR6ZQaNk5qQOvQdFocSI?=
 =?us-ascii?Q?G3uJwU7cpTdmceylP8ME/DX8+Ir4X+4jVXQ0cn+bs6chpbiv9SDvVkbdgMjW?=
 =?us-ascii?Q?eGiFrSjka+n02pS54HR7a4k/9pLKh5Z07B9ozM83M0m2GCkG5WKI3TaPSz+3?=
 =?us-ascii?Q?PaxuMnAj28S21MOSE2mCwQKmvm2aqIMjRdMrqXZzGRzqOvQEsMvP0zXXUjht?=
 =?us-ascii?Q?qHezG9Ni8uSjjCZD5olP+xsz0oPRx6yggMp1YtjNN6tVASxvttUZ+PiWU2IK?=
 =?us-ascii?Q?NaB2alqC/BZU4e6CjDyT+AgSjBkRlM6gZueA9xwkv7cdJzoopqv7KdbQ664J?=
 =?us-ascii?Q?XWIZlT61Lv962zoJQrO98ClGOweuUcH35V+4n9USwU6KIEeCA2suvODKaIDS?=
 =?us-ascii?Q?IemKcc68G97ax5chZeobOQEm6cYpucYbBgAt1A6Bn0OKKCd2IT3iDGg3cgTk?=
 =?us-ascii?Q?0Ur/yElzXlMSCxBaAN1yeSi+eSoJhFClGELTS5yGoZevD/QD2DusSMxMVghj?=
 =?us-ascii?Q?jRWKf/a4heeBFLYAgpyGTG66PsCECjoqu9G8AmEVBVYV20vrifh7oMEkWbfu?=
 =?us-ascii?Q?BhSx4ypP3VKqQ6GNed5bREMItbWsW6xqkLWFBqOLp0YJ7ti8Z4bm16zTDmva?=
 =?us-ascii?Q?tELJreiRwCz4mRuNhk3HB5+ymhI+pKc6e30JIAM9xvm3HHbIKgRhHE4w6SO/?=
 =?us-ascii?Q?de3Plr7ZevqCgpfY9iTOzB4v9WSKGdwoVffx3CRRWamxJPqS99qGxtcXNc9g?=
 =?us-ascii?Q?pZZlYi4hirYpjtyeLjr2UCbUTrn3XMdcE3Fw+nkv3+SSud1P9ksxTYipiV+1?=
 =?us-ascii?Q?Y1+XBVo8zc2F7IFwnGXSC0Iw9m56aRWBoelopRDWVKcbRx865vpfBooFX6hu?=
 =?us-ascii?Q?FHlfVg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da5a6976-e4f9-4f30-7d25-08db522b9eca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 14:25:50.6995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hF/Dqw6shsXOj3VyXj1FShoV3VwTkV7WNKDi90Te6ML0uPTW9yAtLoqOGNtlDYUSw/KRrmIhrIAmsDuY8dtWd2FBRTLFSvn0iUd5w8yTZfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3637
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:33:59PM +0700, Bagas Sanjaya wrote:
> Previous batches of SPDX conversion missed bond_main.c and bonding_priv.h
> because these files doesn't mention intended GPL version. Add SPDX identifier
> to these files, assuming GPL 1.0+.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


