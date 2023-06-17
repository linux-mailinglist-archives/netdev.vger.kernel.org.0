Return-Path: <netdev+bounces-11738-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CBF373417F
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 15:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9997028173B
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 13:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAE65946F;
	Sat, 17 Jun 2023 13:52:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F601117
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 13:52:17 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2122.outbound.protection.outlook.com [40.107.101.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BCE10D8;
	Sat, 17 Jun 2023 06:52:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhXwocKAUS0PQ0T7UXqroZBn8v+jdZQPNba4YxGAz3dG4F6kKTnL62z0E+P9Dqa45ZtrivIOg26sqrL/q0z2akVxuxqULEWA/CN7GABFVUD7+XUMnmZNPXVXMouGHcE1jLTqXVD58Z/CqaKNdZFwka2yO7TCbRV+AO9sp95anNZD69/t7hZHEnVNsSR7Wu+H6eKrMA5W97zrBTzu1dJHxU8L2Xlfso/ncWy55OUI6PmFiAdEQBNOgcfuzdQNdWk78oaaJL+FOhqZ49oPDli3KVDefx3M5wC5tMRxNNx8/yh2yHaZR/YQWjnAqkd85ypEJu5ETC1mKdz1yxbtLtD1XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j3MyQXE+WTyrTmJiiIsKyRKjMCACTEohIO4bjRx76IY=;
 b=BCHZHmXNV/svIPCtPqXOdNLG5wOJPXJEsasgTdJza7qeysdaPudke3kNiKqh7vVnAJLMVp8P26TqZnC/8tlza1VVRpfRPWCbSNvBLpVyA6zlZtT1ziwmAOnI7F84LYgtW3QjpGkwFQqPwHNWpXRJGnatjs/FptMcsidYtww5+L+PNTFa3pqjVs+bKMeZ81q/v1r8Voq2ZX5Se7doECndF5Xp1bmUhTA/epuG0fmfWY/oYk4LJeRCutjgvjSaI/tb9kO6/bH5QoRyFlsOJQvw/txVSVcYzxgK7TjC64XMGSDRNQOBvEaMNHfBWgT6bVYC2G6rRD05baihEZsTFfIsmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j3MyQXE+WTyrTmJiiIsKyRKjMCACTEohIO4bjRx76IY=;
 b=aJrVoKQpcKRzRVMlKFzHLWtllPwdtbMx4jgZVIUvvzpo5/OMNWEk9h8Deb9BdnNeuRjdT7Pt/HGuZTxaOs1/JOX885pKw5WJHnny2Vhuphe+RzaW8xovwYKRwHflmSKKQ/qlAvkaVuIvY7dYlciDP1sPaLaUE1teznsKnaNJ8DE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5757.namprd13.prod.outlook.com (2603:10b6:806:214::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Sat, 17 Jun
 2023 13:52:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.031; Sat, 17 Jun 2023
 13:52:12 +0000
Date: Sat, 17 Jun 2023 15:52:04 +0200
From: Simon Horman <simon.horman@corigine.com>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, Alexander Duyck <alexander.duyck@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH net-next 01/17] net: Copy slab data for
 sendmsg(MSG_SPLICE_PAGES)
Message-ID: <ZI26hJuixlQHOjk4@corigine.com>
References: <ZIy82RjpmQMTNafS@corigine.com>
 <20230616161301.622169-1-dhowells@redhat.com>
 <20230616161301.622169-2-dhowells@redhat.com>
 <708510.1686984195@warthog.procyon.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <708510.1686984195@warthog.procyon.org.uk>
X-ClientProxiedBy: AM8P191CA0002.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5757:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d849ec3-157d-48f2-793a-08db6f3a0cee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iBrRhrBaweHwjFzrsHXEyeDMB4ntSM0gwO2xJtEWfogja8+yAWNhFEhTnymgfWlmIVtiX+dPlBAJZkBu54YZfu9Sclpvq+K3TsPp1z6sF4LWurf5vfRkiZ7ZaR1cxEimmVzP7OpqzKziuPY/+4LSuBwCqTfnEVB4LxZ2D50iiJodpude0H65gR+ViyTA5RRdU2FBRQefsIBHQNNgDoBRADywf4dqbx9kdJA+/RT12qJHUAwS3K4LKt1UTShlX8wjXmS67bbMBf+OaD3t8IHq5zSmBP3rKlj18PrhOMKB1X0XIiZxK1w9Mfg7/iBtHvRKTDdzu/DYPE20xfhv9ZMhb98Uqn6pg4trGorEi/jB8dEn3wwyX6Scaty5sHnXc31sX5KT4J8o3r7qSgKF1RUVjdIfND78s6rSS5mE3irgQz6yToXR7zJc4uyr6vH2GcNPdnI69UjsUlZrsvLVSOfk2CPIC0f6yd0lAQREl7BCDYy6/7AlUZkcMWv66Vz78yCYaSGpJzHgbfYMN2qnZ8yhjaqg2/uGXUfR73+3RUTEPtSF7JjXAxq5Pm4lOechqHAm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39830400003)(396003)(376002)(366004)(346002)(451199021)(7416002)(41300700001)(8676002)(66556008)(44832011)(4326008)(6916009)(316002)(66476007)(5660300002)(66946007)(8936002)(54906003)(4744005)(2906002)(478600001)(2616005)(6512007)(86362001)(38100700002)(6506007)(6486002)(186003)(36756003)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mtPZohzH0O+JI8bXeCNy6gtpd5KI1MrCMe+kxfNtcv+DHZ+DKWE6PvrADmA1?=
 =?us-ascii?Q?iUPG2b4cFttv9GU/v/ducOn3dxl1r+H7BK29CXOa4514iqQ1mTxQZiUaNqyj?=
 =?us-ascii?Q?XSnpng2vvi3aj9LvTbjogySe4ST9OCFOu2YYS6bTF9Hx3G3G5lJZSGfGOduA?=
 =?us-ascii?Q?DQLnE3LCWrwzlsKv+qjDkSp1ehTtpcsDbQPVpbDoDPWNfjJ8d+HsPTZoeJrg?=
 =?us-ascii?Q?j4rZZFZsn98kOunhscixa1MPiTYuuEfZ/gXPzlvKC7uN240QH7PgyTRdzfu9?=
 =?us-ascii?Q?96qSOgb3iJgeNAeSZe8XqhRurIhLhYqOxZIP1yV7+SptoWWRD6jT21uygQAs?=
 =?us-ascii?Q?VWwDIJhsyLePujDBjTrecExhviBJgyofmRFANdP7eQuRAmYa5YakGe16Jdbk?=
 =?us-ascii?Q?PJ1OedZGP76PRIBPr2jtlEatg6vJi6SLgdbSPNZHPXDumogywg6bNfSX+ZGo?=
 =?us-ascii?Q?IrwosCKvEDIFf5ojL1L7HaoVLpQ4rj6vbBq4LrA03m728EcQJrVfRXhueHzu?=
 =?us-ascii?Q?6IE2mJXB/2ODHu5/EFvZozMFnCSRiIP6B29LEpdq97Wy3/ItClf3QFNtU8VG?=
 =?us-ascii?Q?uEx3WZXedIAWN7hIYdvIJQs3mRT94MqNR/j4Qyrk6KAL8P12FBg5oSeZ7sjE?=
 =?us-ascii?Q?wBFpLmrnBh/m9YvETv2wtn3KWuQFDOohvmSd7uafdUQ81RoL2kHpfPtc217h?=
 =?us-ascii?Q?wDR/OGGIHz6W+D78YRykeY1PUymgTShzDFtqjlIZ5qOPO6cFOrP2/a6jeNPm?=
 =?us-ascii?Q?LONbdX1lLASRiApIZw48U5qnaCEpjUI3bzbgQSaXbV7Ljn9gUNqgcSKkEp6I?=
 =?us-ascii?Q?At++0XUVTxEu2KD6J6MlNzMcwbHmHJkBowEgUN3KFJVnM7If22Ql6gCbeu1l?=
 =?us-ascii?Q?O0kTMmelcrnOROC5Ca0AeqBb0qX7KQO1aRgteIIZt6ZTuFyUm4Q/TK6pDOcZ?=
 =?us-ascii?Q?xlVAW7fow7BQmIA8ejjiLHIfxi/9nGAlji4fcM2OzxoqzHsPF97uZVEU/GsN?=
 =?us-ascii?Q?Oqw8J0Zt8xrH/T3yQ1xCxQp2CUX14PNj1SX4jkTpIOKJYv7pPtDKa2frYQJS?=
 =?us-ascii?Q?0QQ/8Lv6t0Lfr/6LFPjARC2+hwA3YxgymJposUNuqUZ8K3PL9SVFdz3tzcCv?=
 =?us-ascii?Q?qGGs+FLzmkz6iThamTs/gSPro6UbueJD/VWLBx8c863+Y0emW259MLQtKzKT?=
 =?us-ascii?Q?7OCWKzst4gZ9dTDLPGDGDO9yo0xTSsSUgswBzeh0et/UOtO08zEoD7DF42iS?=
 =?us-ascii?Q?sG0X5RXRUI5k91Gs9uk9ba/y6F6LHiolp9BWNiH53ThLt0hm5In3V/YP4v5J?=
 =?us-ascii?Q?q5IT1dbDtdKSlIdnRSDT+YX3eyKKeRBlK5hHO3RPASg8CJ6p6Wjk4/AqeG+6?=
 =?us-ascii?Q?MTpYjiM05wGBF8lAPHZbcGBpVMUnmiSSgv3/47M5p2QnAYSzbWGhzevzaW/M?=
 =?us-ascii?Q?JCSwIm4kYLPyuC7P0aFTJBeFToSGs1TW2/z3ezjXbWXDZca/F0xkhzbn5uu0?=
 =?us-ascii?Q?kh52M71rIVqjj+9z3QRz4LZ3CrLIUMneFGyQx5KsCVdWnqPlmwWq2gM8tETd?=
 =?us-ascii?Q?p9BbA1FbSB8IQs37D0VbFWWx+ykVesLkkvvuGcYiFXphapueWnwPzIRW4yom?=
 =?us-ascii?Q?jrja4demc0pj2Bl/JNLH8CHRKPJstuJjlynp4Cm2qBKK0IY9oXCUfErMMRba?=
 =?us-ascii?Q?XlBjSQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d849ec3-157d-48f2-793a-08db6f3a0cee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2023 13:52:12.1201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RvbFXz52/IleX5apN+ltwsJjPJxre2Use8mmnB96xDLXiocunECEGwaVMGBZQ3P0gJH8SAvuv0YHyKEPnquoopQpqluUNVSfzqd0qnFOZiM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5757
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, Jun 17, 2023 at 07:43:15AM +0100, David Howells wrote:
> Simon Horman <simon.horman@corigine.com> wrote:
> 
> > > +	cache = get_cpu_ptr(&skb_splice_frag_cache);
> ...
> > > +	put_cpu_ptr(skb_splice_frag_cache);
> > 
> > Hi David,
> > 
> > I don't think it makes any difference at run-time.
> > But to keep Sparse happy, perhaps this ought to be put_cpu_var()
> 
> Actually, the problem is a missing "&".  I think I should use put_cpu_ptr() to
> match get_cpu_ptr().  It doesn't crash because the argument is ignored.

Thanks David, I agree that is a better idea.

