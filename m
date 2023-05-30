Return-Path: <netdev+bounces-6353-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B241715DF0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:53:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7B241C20AA0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FAE318015;
	Tue, 30 May 2023 11:53:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B56E17FE6
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:53:17 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2116.outbound.protection.outlook.com [40.107.220.116])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2CBE66
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 04:52:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7H+fVV1xdhHDgIBL9oLP5Zsu4WXKD3B/GOmQAOiYXhzD4GFJoJDhVuuXMJADtQFK43bn0J+1Rv03ZafTjj4HuRDgVaGNvPujMu4mXo+eSeCaMaIayQskCkdGcSReLlhGNNPJAAaFKZS0InvXwks9Wy+KAFw84PwnGsW7c9T46eVoIj9T29pIQ2b00vZ8P4NGQO+GJ887jxD0YLITT+bbDggbw/P8hBt4wbeQbhx08aYSgC3kiBM6fJ7UyL4DJ9nDXER6NqnQ4as7t5QIWGDR7U0vlM938k+n3D2YB5YP5XL4SJleQ0SP00rELvnyJL5eDPDvFAiVhR1pthFKWKaFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5T6YV7kTgkOBXOUFWW8KiEeKHCfU8VTU8IuQuuwwnQ=;
 b=REP/E5f52gtgcGkOEeqgg+vzKQrVJl5SfgzYf9GO32Q/a9AME3CV64WLJF4nGch/AcUmcM5PQVe7iK4g1dMt1rRGC7JA7Ew4NUNb4zf3rqEIHmXq04EZSOyqMG3eupePlDtOmLnCPwO4cPPkfFu4C2Zqq0JkJHnCzoM547Hs2DjfKxENJgfHb68YLTJUzDBqCI9hdaSikXxgSS7KlwDf9ncASvi6lu3hqFPl20H+uRCJMOWYC0wta+22s0v+oS5970Q7xIH0MuGPIZmfcJGymcygTStp3WbHBC9IabuOdcKbv5LbHbAzDbKS5qxFRaeTW7ly26A/l+/FF/cI53aDxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5T6YV7kTgkOBXOUFWW8KiEeKHCfU8VTU8IuQuuwwnQ=;
 b=YyLYZRlMDAOphqklBui9xZMXyHrgVIT9MPkC3KblfY/OUJZfclrklWXnCAzHKjNRzqschVPqBEOlkIG1EAH6fZzmsHhtYaHO7Y1wpgkU8yYhewhpXm5vBbmva/uVO2NWmGY3BvzLyn1VOUCl+3QmY2MO/I6cfHAnGuVVulr0Q7M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5088.namprd13.prod.outlook.com (2603:10b6:408:14b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 11:52:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 11:52:42 +0000
Date: Tue, 30 May 2023 13:52:36 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, kuniyu@amazon.com,
	dh.herrmann@gmail.com, jhs@mojatatu.com
Subject: Re: [PATCH net-next] net/netlink: fix NETLINK_LIST_MEMBERSHIPS
 length report
Message-ID: <ZHXjhNvLCbxrWK01@corigine.com>
References: <20230529153335.389815-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230529153335.389815-1-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR02CA0013.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5088:EE_
X-MS-Office365-Filtering-Correlation-Id: 214d229f-fddc-4c33-2810-08db61046015
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5brW+kSIpB/4ONFleeMhFUorgpIQoDUrGuSW+FToEgcnfhOX2LFVmXCEfqqhSnU5JqSd1CLb/Wjcax9xFxXyWSMSYn2GEluXxIK5WXc1esQKq2q1yK7xrP0T0dghHqBa74c3LKzTjWz4czAGh3PgWq2TRVCKikYaVt5myKx/ZZKDUlVZXLwtt/iQja0qiofN80x4ZM8JQyz0IV0+keyC/h6bonEAk/wfIj2oru80ydtPvYNPQWvfD5y58PKfCiNvEGV21p1rSfPd5ADh2Ucv0MxNuwnVAcpSVBGDQYQeXcG10nBcT/mJrL7hcZrn4SFu4BLRCUtc7u/L12VJkjX8gUUVSRImfDCly4BExWLrnxra1c2COdlWXx42bkKjDc4Q1ZFnxgPj6bQpD9qpKqTGsTdEdk3Eu3BDlv7MwrUuZgfdzA3+iMh/5zhHFXqtHJv3Fl5vVnEAkp/8Wqti2HpzyNN+4sV5UuOs0Os/owZY3uyT/1hOrA7XtnO5HTi2JoqSsNSWKeiTIGZQtGpoqiV9cpHEv8Bff2tKMoebe8cD0xNV0Qu+EZQbVgxSYYI4aRnhECVvQFQDJNe1dthq4o95ZqDtDHOMWEzQ5P4jCRsIKss=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(366004)(39840400004)(136003)(451199021)(478600001)(44832011)(8676002)(5660300002)(8936002)(36756003)(2906002)(4744005)(86362001)(66476007)(66556008)(6916009)(4326008)(66946007)(316002)(41300700001)(38100700002)(186003)(6512007)(6506007)(6486002)(6666004)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vFMI+lytE3mj/M+l1W0UEPROfQJ7TvSZXNVJS4vFHk3CDxzBJPdgfBAQoWAC?=
 =?us-ascii?Q?QnJ6bhjpl1EgCctjC/4VLPUKqI+VM9J8Tx6aP+VVJV/tRx5Up+Dw8sCAkitU?=
 =?us-ascii?Q?A00ioFyXP6ilTxVoKebTbOpu+2OYwpfo07ou2z5OLKOLJDF2cGH49E3F7mOS?=
 =?us-ascii?Q?oHegZ4F3T+joUNeJaxfZwiSMTzfo6wKRncLGkgnA/QrS0uMTEwdRMDGE4vCl?=
 =?us-ascii?Q?YMllfv0N5iJ/k+vt6ShuSGzymWSlZlLkCZmRkFuAm2SNxynN66FXRnxOIYub?=
 =?us-ascii?Q?vEL3MKbBGNwRQw6z78Dj+yIx3UPw4ErmASyDYsVZaTtsg6kzKGP94Gzt4VMX?=
 =?us-ascii?Q?yQyfkIpSMcXgstyi4VpHiivF0XugpL0H0ScOm+xRUj+evQ2T9lu0R62FDR9r?=
 =?us-ascii?Q?59hhLOgDUmE9KIaZb4xca7MZ3o0iYpxpmcRD2B1DaP77tjAPfX7Na/SbVu//?=
 =?us-ascii?Q?Vro+mZKfH0+pdeiT1394hmhrdfRofXXmKVwLZNivn8F/N1LqZSlsDYrNWRkQ?=
 =?us-ascii?Q?O+2F7kMIAUty5waDe+SUkPn8Lz7SerwuLR/bpFjhinpsb8IF61cAZKyiN2xl?=
 =?us-ascii?Q?Cyox7vgfy07f/7fk0k34Evvu7ULuYZXU+GSovrTgUDE6Fj5axD3Rs5SGd3If?=
 =?us-ascii?Q?G8VXMq/0PRa7lU/WhCObrjFfeh8HCo2mSDE1nIyXCU9kn22sMl9dlVI5sz7x?=
 =?us-ascii?Q?Yat+zQ8SMCTDvVBwDGTXl+qLOjZpkY57pkhi+48+CEInt3BwiXEWVMqiQdOm?=
 =?us-ascii?Q?grGFi0r/LgwctJV0Dky2e09LvQnXHx/JEKLl/v30jfjdFz7BaqC7WbPuk4z6?=
 =?us-ascii?Q?P4B7c2rN2zHDzJMEVCtpgXzEb3TWkRm7CdCSConZ9cEzMcMF0at395IWpSaR?=
 =?us-ascii?Q?RPLoA1AQF8PIUGb8MzNp8ts9GiG7cIsy8ENFbHmbrKomTleGO25FoRqggs6Q?=
 =?us-ascii?Q?RcoHfJ494Sr/IPuGwNXHBnD1A3K0F+7KjtMn2Vd+1p87in5y6KSe/alBC1jA?=
 =?us-ascii?Q?DWubMziDzEZewkhFG6hdlTQR+OxVsROriUOiDW13feJ18Te8yUQSTAHiw6vO?=
 =?us-ascii?Q?W7GcqEObfx0BZVC3FwCMzfIjO+07vWd1DZ7pHInOmL8SNKJFSXdxROOLupq3?=
 =?us-ascii?Q?5IBHEx7ashEAa3KXHTJbLARv78dLHe3wW5AF7wKLlKEimMyo0sKXJKK37UIh?=
 =?us-ascii?Q?dbNaM2Ct+QQWfOOhe0LYvKxLthfv0ChBaVJ2z2+d9mGYHJbeamygXrsRQxqF?=
 =?us-ascii?Q?9BJj327vvyvPYWaC6L7PHbHLNLa9UfNhPyySGp/mvk07zxK6sBSWYVs8MNyT?=
 =?us-ascii?Q?prIaKZams+GEw1U/zLeEVnZ+rarYP/x/sHspsJ+pzWCfHamk/GrV16Z0Y7n3?=
 =?us-ascii?Q?Bu7hFk69RiunALOY5VV95aCzeyhupqE1CbdUkUY70rhf+YmKVvjZCy41ZNhn?=
 =?us-ascii?Q?PeCXHuiLxIikeVad8SOeYVuFasTQH3Fayb2PKnC5dmn1E7+AAkgOBl4JJIBg?=
 =?us-ascii?Q?vuPpT+UB/D4GcgjxdR6YNx0Sym7+GPR92ekCmdxzlqDiepkiQ2LrFazcL/0I?=
 =?us-ascii?Q?aBDGc5s/ooxkWeJdhaQ3C5CnmAwAR1Y1rl7cWYN9UlxnkU9FJjpkUzJz+lmH?=
 =?us-ascii?Q?/fqadLljYQK5sknSEr4ukC/QXw3TjjwYSY8EZN4ioOTJiXaDL8IxN4kmFQwE?=
 =?us-ascii?Q?4uT/Gg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 214d229f-fddc-4c33-2810-08db61046015
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 11:52:42.4946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w8sXffYo3wmA6ANbqr7b4dqYav/oBdYMhe6fsDxaS0li3FjzjuQWl1kChrMINLUZ7R/xfNI+3e0iAkZF3zDfeaEiSaoZoPOfGtuTLq4xXII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5088
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 12:33:35PM -0300, Pedro Tammela wrote:
> The current code for the length calculation wrongly truncates the reported
> length of the groups array, causing an under report of the subscribed
> groups. To fix this, use 'BITS_TO_BYTES()' which rounds up the
> division by 8.
> 
> Fixes: b42be38b2778 ("netlink: add API to retrieve all group memberships")
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


