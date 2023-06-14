Return-Path: <netdev+bounces-10703-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 82C0C72FDF0
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:10:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20453281403
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:10:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E4A58F4D;
	Wed, 14 Jun 2023 12:10:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5887476
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:10:30 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2132.outbound.protection.outlook.com [40.107.244.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0251FEE;
	Wed, 14 Jun 2023 05:10:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnVQIGnxEXMtkeCSZe3921uZnI5tkZ9Y00JWAZ+gf2d/X0lgBTgsbns3xrlvY5xCv+LHiOjd4aqP8kGT7iHnfz+RZ8fdPxvRjJ0Rge1WeO4jIkfWi/wdbWC7cHjNwSQDJXTCg0ic2Lx3an1F2hNnth4ASp7iXH8iw471ftXBVmrjRuWminkftQBCngXkNNV7gJHFi5gsVg2WotgrfxgtnFVHTERdRVwOGzuIr9vZYVIiKJ9mD3V8rjvH1IN+Xz8fhnGpsnHo0Z+22wzN/VOdYdxTmaXtXuED9PXacqfikK8PVCec+QHYNC+VnPswOVEjos40V6pDB5bXNvmF9nvYTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0eHxTT+Ji+UZT0HXQ6GDXXViUbQzUppfmzTOYnogX6o=;
 b=JA+VJXA1cgRjf0YgX93NHwXZ75VfSLrWY05zlPnf63SQ/LPHVxnw1E6MW8rfdnHrJ15TiQh5wsRJwCZJBEiAhIf9jgsj/BD8bHk5pX+afcmAVDGxsM2yu4oMOH9tPUP98m6yxx/HdCzKXm8GtynOKlWiZzq6Z6v0zAG/49L7njAZowO/dz+angtD7Ytcuu+bnw0LdvtD+vurlXg3UrsQP1OW27OP5bbeO1dkPMceqUW2A65+HtOS1oU5ANGwAVHePY+JjsJosJBwJvXBpwVDHrYEthnzwKiVLjCdBQrWy870mM7zCJGJOiOFJnGr+7gDdZjJvpbK37pSC56Gpktvbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0eHxTT+Ji+UZT0HXQ6GDXXViUbQzUppfmzTOYnogX6o=;
 b=R1PKPL+05l3kiNhzRSk85zU9b69mU8AYVmDaCsdWzgEIFVXkgN7fmhIhZSRGtjSBLQajvIflMHNp2C9Cm/XY2IWdohoPIgwORPwXoyjpprKFJhLTDBFBVBYRCI5OKlWxYhTL3+N7u114nsDfsiXY/AD1kjKXzuclsKvg9gFyMkM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4043.namprd13.prod.outlook.com (2603:10b6:303:2d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 12:10:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 12:10:24 +0000
Date: Wed, 14 Jun 2023 14:10:17 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, linux-hardening@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: Replace strlcpy with strscpy
Message-ID: <ZImuKWESPMLOiK/l@corigine.com>
References: <20230613003437.3538694-1-azeemshaikh38@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613003437.3538694-1-azeemshaikh38@gmail.com>
X-ClientProxiedBy: AS4P192CA0035.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4043:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f4b380c-776f-46e6-f37b-08db6cd0554a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ewnene6ezShwz7dmkDxzw49veDco2sPQi90aTvxVrIeU/hPpqtkjRHPNoqT72E2h2bTLYXEetO5hws6tzi+lwrAwQmHsjrMMLGzeSL7QrmjP5DPOKKAXpLO6T/bRfCfZqdwhxSa6T+E3Vc1Xil7nLJxX/c+2layDE3oLuK6eCAnHE31KqLwV9AUNUNQ9vK/LXcWOpzF10d/3Bf+8vY+AHR/9SS/PZ1iIEGv0ccCxMyin4nIirXIWmwAdgua1ZBVcWDBOWWp/mrYDoy3RhGPOJkuPc9TIOxTRe6OSknRNKyyG7S/j76dATjiYLou0O9o9LCNTdthle6s/NfTYpxVlOb8jC6FWYDveeo0mnbFueSDHitoAEXpjJ+x8/h0/9p5KbszPfHmqtZEpN7WCyiDlVf8E4QDApldjK9cGdxlItwy8Ym+Xypr5KGezT+Aa3nndpdlUNgIRghFLB4F1upTkMDzeZhCmWCccATdnTrjgdr0Pqt3Z9ELJNWXj6mWtbT2giDGfjL7H09GqXTbh5KqFf9Ip1mj8bkDQ9Efe1f5luYa8V1kEt7bBDf6R0VRhIguTUkNCkhLXoJSMqkoU8Ug5JLeSXEiedv2AjtfAQoUKE+lLeEHPHzey3VaXNCzVgKRDJJwORxy0b9o+82SOszIx6A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39840400004)(366004)(346002)(136003)(451199021)(5660300002)(4744005)(2906002)(7416002)(8676002)(8936002)(66476007)(66556008)(66946007)(54906003)(44832011)(6666004)(966005)(6486002)(4326008)(6506007)(6512007)(316002)(6916009)(41300700001)(186003)(478600001)(36756003)(83380400001)(2616005)(38100700002)(86362001)(156123004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wOIIV9mxHZPkN5NlbLxxEXbwHaa90tuzGOE4xNZD635M/QsJktY/rziY9O4A?=
 =?us-ascii?Q?aGvL/iPRKOq0f1e2XzL9m5+CCAwKH5Byq2NjQFCV1oJMXCZLO2zbBJ/Vj8xZ?=
 =?us-ascii?Q?U2pzcvSemTI5PAXdAtE978ygTJpb/e9CPh7tZMBt0f9MRnalHhc0rPABGSFZ?=
 =?us-ascii?Q?vYYeMdSUvjTgAudaFBVLLL0OK86ZlJrUaztbWVp07yLcHRLuQqMJVcx5DO1N?=
 =?us-ascii?Q?pj7OCVqLrojDhXDXQltNEOIbpPGrKsUxqVXy6Qk7lZzX9kdnakXWpzpfYGBE?=
 =?us-ascii?Q?HqmrDE0zIEKr6fV/AYPoqqOcOoZ/ZWt+m3tky7c1byN4EjrB7FVTXt+75MBC?=
 =?us-ascii?Q?njiFENKRfMhEB8UBi2FDGCO+V1xKD78VjEbyrUNcQoDrh+0lS8tfCo9eNkFz?=
 =?us-ascii?Q?yUGce+BXzIBauV4s6gSJEOwMmrgR/uKKnRpl5cZzaeJ1KlCfOfvQTI/QyXXZ?=
 =?us-ascii?Q?X/clK1FZpjgD8lZ+NozQ0GPneJ+3radDy+TPCUT6VUDKloLx954JQHBusr4S?=
 =?us-ascii?Q?MZVxZzk+QWriqK2NnCasTd+lyuKn/FIB3Te+pOBaxVYEfsWC2WwibGyk63UC?=
 =?us-ascii?Q?zioeZmqcKZ6rVRberIiUdYspTP9MFxr/Jv2NL3EZobhXX8nQCQ9jLO5vE4n8?=
 =?us-ascii?Q?1Ilzrq59+06SIYYLn4VBxp6InjbCZncYrJMxrCkNGemh4vlUvFaDKLJVh41y?=
 =?us-ascii?Q?2sh5Lz3aIG4qhPde98p4ev7rNvCpXZ/YCHDI7cI9d4GgRZQ7W4ZnhMtuKSw/?=
 =?us-ascii?Q?LXLeXxQJBwMCDxXDNU+nzOiWpAuNKSC4/sSgFtcAOnTXQBceGoysUPtfuHeJ?=
 =?us-ascii?Q?olxYW9VcCJPHRv1AI7vuyJRM5z4sRrNcu8IrfBNKE9XcreuqhXpNfvYebVOM?=
 =?us-ascii?Q?VMWPcabeySDmUh9QZ7COjzkzXrMdYR7DKZ23VbSK4KW/qLFUJfDW5Gpc8C0F?=
 =?us-ascii?Q?jKC7wrElTtRLCbAVpEL6xXB8vtdutJAcj72s9XImu+OKcLTnwV7lZqnUIuJV?=
 =?us-ascii?Q?kIa4262LoH2TeyysQAZREvLXLcLv8Qn/toUuD/D09ZrqQ7+E94Kt0dXxyODC?=
 =?us-ascii?Q?KRxmv8YzIU7cF5PCvDfTU3iKXf0W4Ki84MmomQsQfLoMz3AT1k75+2TbAFVo?=
 =?us-ascii?Q?XxOGEm5FK8eMOxSWB82qrYzsboqypCyqwuWFMs4obQPNGFv2CGlIUYKiq6L4?=
 =?us-ascii?Q?4awsj8KPGI8z9PS2Z/2VhhHrxIgJdmbQ+Lrjl20BKjXyMJyRFYp4V26HFWVn?=
 =?us-ascii?Q?m8TwZm+/t02P1lMwA+DzuYDgwHS1YKuIvQm1BtcPVMnWRCNJB0uDcbQu71ZB?=
 =?us-ascii?Q?2QMHrxUlxxaAW+YfypONiuzOzcpPeexI8edGQs6kPSX+CIfMhFQ4O17VJKRq?=
 =?us-ascii?Q?+378D4uCFpP68fN0qLGjgPWR4l7D/KkZeGpckA6lVyTyqcyGvCA8johLamp7?=
 =?us-ascii?Q?EwHp04cYkLk/vn8NCgVvOFAOjPR7rJaqmYy7SLW4ybHcC99Xblwm4Gx4y2+w?=
 =?us-ascii?Q?1eyHmMDrvE6YXqOp7Og+PmyRPDer8VOC9fjPCuSImt2LXUo9gj4Ler4b2QAF?=
 =?us-ascii?Q?DzFhMV9XUoZ5Y52YHCHXt+0oNDG7Q7/+KpVVUgib+aCJdrpcphG6qxVm6txH?=
 =?us-ascii?Q?VaQiABh7r/oDRFbGSBcxd0gQFHWfOVz1NEVR9Bu3WBW/3y2bZ9cK2r81Y6nt?=
 =?us-ascii?Q?AtiiXQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f4b380c-776f-46e6-f37b-08db6cd0554a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:10:24.5232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lz2hXQiOuNauZgerJo02Q7hAkPQ067oaq8+zEjC57dsDwUAJBbRQlZo0OFOI8gigUPR0ZwQ4gH4qavPtRebBQR52clS8vfTtQcKwhIUN6hs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4043
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 12:34:37AM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> 
> Direct replacement is safe here since return value from all
> callers of STRLCPY macro were ignored.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


