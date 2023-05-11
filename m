Return-Path: <netdev+bounces-1835-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 859A46FF40B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:25:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9387C1C20B05
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6B419E69;
	Thu, 11 May 2023 14:25:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A001B8FD
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:25:32 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2095.outbound.protection.outlook.com [40.107.96.95])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D19100D9;
	Thu, 11 May 2023 07:25:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNs7I5nBMxAW5kOVm8mrLxZo9hB6vJ3kYhV3a3HFu2q7EH6Taynjxr8VztkJpB9BIqAsZiXmuWizcxMqO2Lw6e9YOc/AbkTKaUET1elZ3YbvyynaQIiTzVG/6Kxx7f9et8bei+bUtT/Wz4QP8ReY4HHgVG6Emaj0Sf2QJGYRIQI0wtxNtextTk4q/wyzkW+00uOxFf7OJBRXxUqgG+bOysZ5nZDAOS4phoU5jo30uiqtT3/vFIpl+/Y5Eo7+T4ejFUrjEmN/m8Ju/TGQ92T9WAtxuV0YC1IolSLJD2gysLPe+nX9GZc3JzRYoLVnf5ticXO/5Qk5SxVF9P+sU+Dr8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JserVRuEy+6K0aBtxc8x2wewn2ouP72b1YRM8gMc9Go=;
 b=eXVTAXIoYX7+Bc4vBhpA8dQywhqIF2KEpCiup6kEitV8VhkILtpa0z1W3fJTZlcqEaghIGHTVRrMrf31HF2XV9iHXzm4S/M0h0OVp83opPVy6ns5s65dC4QWF8WApK2MSez2Tx/ZYk4qcXbjzn023xDqfgMInWZBLPZ1EFs+4c4jQVWIwcIEbBLnbKKL/TSON+J3lqvefW7tRP5hb+9E4C4TcilLt9bfNxSrLnoNURK0H8jjY65Kt6XOYg8HdqYhMQK7muhQ6oI64zmQcj8tNI2oCL/geSi1xxqdbFZLaL0x2aG6sn5SRYOJeH/Et/PeMz4EyksI5S7LTr0xDfPy4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JserVRuEy+6K0aBtxc8x2wewn2ouP72b1YRM8gMc9Go=;
 b=PrMiz7t1LqPSlBJyPdNMFLJ0ZUlS4wKrqfbustoXefJfr30Nl7UInjmJ4IGboIlaxthgKfR/C9Lckwg4QeCFQliFIpJnFLOQg5BdFFAC2Nb+1fhUcJ8Wur+vXAM+Vz38pAkQwPBBmJhqBNZ4x6JENb62fGeGYN98cO1f+Gal6VM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6522.namprd13.prod.outlook.com (2603:10b6:a03:561::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Thu, 11 May
 2023 14:25:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 14:25:26 +0000
Date: Thu, 11 May 2023 16:25:14 +0200
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
	Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH 02/10] mISDN: Replace GPL notice boilerplate with SPDX
 identifier
Message-ID: <ZFz6ykUp7SJEJCSm@corigine.com>
References: <20230511133406.78155-1-bagasdotme@gmail.com>
 <20230511133406.78155-3-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511133406.78155-3-bagasdotme@gmail.com>
X-ClientProxiedBy: AS4P195CA0016.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6522:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ba0c30e-58b5-486a-5fa4-08db522b902e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pdo8fP3oGb7RB0fRrJniTjRud1DwHG00NIJtAv5NwFQChUbX2pqX7DBOz2HmNWVejg0vjGOdN4fHm7WQk26TYl2LuQUHT1bCnagdZhz1rQQMZUX4eY3uF/b/QGOB+XxJ/TRYXekwG2VaUuyBLKLqvRaDlC22rlsuoDgZRj91fp1NAoWDBBafUXELDA13cP6W+bpLFHJHnRH19wNL28+9LGxUQcFeRIzS+NHvSFg1rqcB3aBcF7UvO7Hfo75SCG3KIEyaVZzWmnLkGZ5Yg8kNr0u/Av2Q0qm4hiz2Xh7+REjU7mOmExsJu6gIzgqh7gKAES+tLLfkRoW/bLbSk6sjTSEyoNTZiYlv0yHww2A7lzm1ZgjH5iCyX6zpZVjzdO2YMXZM5/GeK1CR+AmnjS+6neiMph/Zr4Z48Dcb6YJg2KGhyCipTSMnEDMkYsBDNDnF+IuUFUnsOjUIevhACx4EjNaIjDw5FGn4gdHC67uDTKgxhNOXqIJk/Pv0ip9aaxiwmGwRh1CPDd7nFDj+q1LKj4NhmPyDuJWwCQzPzq9JMWPNz3Byw75SmgRWCVYPzQk7L4oMkq1raWaXI8q+SOtFQXh3Dw1UR5yYl6kclobZRYRsATBOYjfeqQJNww0NHMEC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(39840400004)(376002)(346002)(451199021)(186003)(6506007)(2906002)(41300700001)(4326008)(6512007)(6916009)(66556008)(66476007)(316002)(558084003)(38100700002)(15650500001)(83380400001)(7406005)(7416002)(2616005)(8676002)(86362001)(44832011)(8936002)(36756003)(5660300002)(54906003)(478600001)(6666004)(6486002)(66946007)(41080700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9tzuQ2jlyp1AUwFcJ+WZlZsn1bx1lbmVNEiO8ZaFKL25egtM2NhVMJvBE56B?=
 =?us-ascii?Q?yiFKh/pRKJHX3tWkPZskIwVF4Xy+AaWgxQh22Cxi/HJ/n2mZV/AvSY0vLAdM?=
 =?us-ascii?Q?2Z+MPV3eaJZY89G1mGk06KQwFjY6P/eDXP66ETp1bK54GqKadlFh5b8Vs5uu?=
 =?us-ascii?Q?lWafvtZacB8iW5VUvYp/A7OmxulIr+CcCTPbvTXfM6BIErTDOOX3V3eYuDI0?=
 =?us-ascii?Q?M77QC5Y/6RAwVc66zEKX4G4mMaTaNDQEf0dxi6FurNCg+ISW9fs/cQeqbbaP?=
 =?us-ascii?Q?YEDoMw7JruiQNSOzp/V3tG8R1y7ictoYTKNvexKZdLs0HU94Iaopdkq4T3yu?=
 =?us-ascii?Q?L5WJRXZaIqiktq/XwRraydGQG8vXmBfPYtmwAv1gh8qtsP4TtfAnq/BLFH+a?=
 =?us-ascii?Q?XcXdhIMGyQl66dDoUdSBzhEsCEGC58d+nxjmTgNLyoBf+JXKSdnv8JMQLYKC?=
 =?us-ascii?Q?x5n1cu8IGX1hegipqsAmEfMq5N/b5qgy9o+0a/XUFAEv40/EGD/YiULmKlaz?=
 =?us-ascii?Q?QjcMMj+xN1BJCgA73sw+6hKHGHzTtj+v7yKxH8QzpSkB0KJlBgq4V6RA1lH4?=
 =?us-ascii?Q?IdrXbLizhbtGUcN0EIgIgSOO2JvTDZVYEFoz0sM/NFvaR0LP/c/oob7f1oYy?=
 =?us-ascii?Q?akjxBDXc27z7ZMQ6JOH6MQR5fLzhf0ZKn0ZVvt0A1DZ+BTvdJiXaDShvBl++?=
 =?us-ascii?Q?okaq4gJEhFy2muJ7LxOvqYk/jxTCQbhxqLOhThtitPzP9p8TCP8Mj3NhHtwk?=
 =?us-ascii?Q?yLAoXK0m+x2GnlnlsJ4bUNxNzJM8F7HxrtDsSZAEf785nZPGkVFgrjFQYdtD?=
 =?us-ascii?Q?dNkKOl33M2EmFGOle5v35oMi19kef06gDl4C5tXu2cmOcV2J2RNxu5/RcLMY?=
 =?us-ascii?Q?zqQys+3BpkHP1fAmt2lEyvXxoXJb6j5G7qAban3zx4LFEXAd+dbAkjv2EUoU?=
 =?us-ascii?Q?7oYMJRmH5G2ZWU/4qW0B/8OOS/kSzfuuJFu6pqTy9wdWyANYXEBVwQ81nD/u?=
 =?us-ascii?Q?PG3CgRJmDQuRknclmwjUT2Vcj/D7x3gxW8lmqZukADVow2xhLCPMmcuBc+We?=
 =?us-ascii?Q?Ql+vQQe99oY68bpkb3LHP8DANt6UJ+eyH73OV/05+vh/j7stQcosh6xXRjWg?=
 =?us-ascii?Q?fjDIcgKEum08V1wNPLSAJ6hDJQz7IHcLLF5uLKwu7spMQXw4F/OFkuRCC7tv?=
 =?us-ascii?Q?GjAloKU84w+JLYkcciyLAPhvSI9oJuxmotEhVJL/2QxL9rvRSCLE7vrmEX+8?=
 =?us-ascii?Q?A4ereXI12DRa0un8/yKkrg17pGHIe3fJRA/++kjJozndqnxERq4TX/viGCxj?=
 =?us-ascii?Q?8jB+zxh00fB+HziE2hOKiuCPnxqYj+mX0X2MySKHMsuFJjti2Xs/6VL5w3m2?=
 =?us-ascii?Q?SliAgRIzf/+CBjgHpWZWQeKkQ0ih174yjvj2t520tmUoX8COHAlwR6XInu4R?=
 =?us-ascii?Q?k76FIeLkQbwPCsLsU1VR+jSzxJ07icUt5xKoEoHPv+u8ZRR2R3QnY6apm6Ma?=
 =?us-ascii?Q?ts6oD3cdKE5wi3RcT6A8gjt54c9xdzGXZRbr5Wc/WCppEiuGMI2zeBSz/LE+?=
 =?us-ascii?Q?3c+yxz+gCI6CY+Spr6enI10IjrcnCytq4wWzMaW4WUOUQTqxAvYEfjw+K6vh?=
 =?us-ascii?Q?m3JrZkiRlIfehJes1Z8U2544CMEk4cC0xXrobqR/Gb1870JSwOyZi6odk+s0?=
 =?us-ascii?Q?B4yRdQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba0c30e-58b5-486a-5fa4-08db522b902e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 14:25:26.2016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nFBPjg0R5xMiMNDLn8uZDFiZ/PYehyZWBRaP0vsTKVVrGlDIRWCw9TPlKLwuELWBVzLU3SquxzfyB6AkdagXzcfUKq6PRQYxR142nA/Qggo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6522
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:33:58PM +0700, Bagas Sanjaya wrote:
> Replace unversioned GPL notice boilerplate on dsp_* with SPDX identifier
> for GPL 1.0+. These files missed previous SPDX conversion batches
> due to not specifying GPL version.

Reviewed-by: Simon Horman <simon.horman@corigine.com>


