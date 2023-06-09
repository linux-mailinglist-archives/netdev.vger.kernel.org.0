Return-Path: <netdev+bounces-9545-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A394C729B69
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E311B1C210E6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE29B174D9;
	Fri,  9 Jun 2023 13:19:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D061610785
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:19:50 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2097.outbound.protection.outlook.com [40.107.100.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E54835AA
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 06:19:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QuwYvSXKLNQxqwiWpBuOhKJJ1fLdHGw3e2/SLHgs/AfHz2oRDw8p0IlWYWVuM2t53wFqQE6kMS/Vuem1qqP+YxsA2vnvnBQLrl1FErJJMFeHI02odOhwxVqCWM9n88GwzBN+cPR6cuvdrl7M+zC/SsO2FXg4YiSrGZgdsot+/YZCMkMZidg2W7sbyZBYb5StEya9ERIJDlB7W6/VP+uNsdAkiLQ2vlcdBXtBK2+p4wj3Gl7/YhMz1HeBV1LwE9Yq78CK9n/3TUnPmWpo7H6AXuOFU4BHvNt/fVnjH5LTP98IGNcJZqpn9JGcmYo1LowYPxTbyped2Rk1p3ACUh72KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMGcN05+uUbZcT8DYfYd3mULgrUl1CfBwc24AFAzVII=;
 b=DvOTNdegQBEJXkb+/hg8tl6/+1VqTyGI++yOJcBqTNPr3hQ1jQCjPQuG0i7bTK1AIs/2XoLSOEKdJw/RLSJhowFoKFx3RW+/fLb8zX4F4HqPLfeL7VsLTAni7HSVENOwE52S4bkMsYUcpW1CRi8EBFIwYdqjOEeHCQSd1GmH9PMv47poydGwazVLwlxWaWl3m8S0OKldrsBOMKizgpkhsivMWFoYLKtXGfV5fZ+jLmQH2a1a7J8W1fJ+QNYdm3kiJCTxAQU7vG0pQVQjVSVKVJUfdBh4kGdv+PwS4/QGGoRhxuwnPDpIQCCexYHb55CbsgORL2eief4gFpKptiS2Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMGcN05+uUbZcT8DYfYd3mULgrUl1CfBwc24AFAzVII=;
 b=MJkjYd3JtS3BHVABA0q7D6D0+O17TcmbZLmn7ivSbngbt1ihxkdHNnsVwRKYvqnQkDhwyvBwveHE7FS4TOaPw7uxo3cHMJw6L4S8ShpwOdhQDBX85zwrsllvMj2j5N2j3QcuxiHfxun+NziaT8L78uvZUyOiB/7cQV83dqSNDZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB5204.namprd13.prod.outlook.com (2603:10b6:610:fd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.37; Fri, 9 Jun
 2023 13:19:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 13:19:41 +0000
Date: Fri, 9 Jun 2023 15:19:35 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com,
	Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH net-next] net: move gso declarations and functions to
 their own files
Message-ID: <ZIMm51dRPqveM4Ry@corigine.com>
References: <20230608191738.3947077-1-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608191738.3947077-1-edumazet@google.com>
X-ClientProxiedBy: AS4PR10CA0018.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB5204:EE_
X-MS-Office365-Filtering-Correlation-Id: 5954f6ff-8d4e-4aa0-f1ca-08db68ec2f02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aWeKdyMWpACGQkUhowDzDuSmEf3NLMP4gszJWOQATXDWfRgXxUuglGLLM0vr4WTCW9NmvOxPUEnWhQ2sds+i06OZh6Mb4dCmoSJmiyHmNeKauGp2aZ12dSRGq5Ev+j8gt994ybBx9y1YghXQe4uVHn+oFJUCZySNYr+kbDNTFwW+ew8CgJF62qRBignNczJtD1vsABnC8/ix6/DggiznjEU5KjfWc8SnmIXUMoKi405SIrw52bnoHS4JJhdd4hh7q8t2Q0WTmtRIKR0WPAhMeruA61+ylR1g+OnYOjeTZBymG2Aqa5yTucW0bOUd8aReu/rSbki4ka6NZr0TstZz6aSfl3kZ+ZPGrmd0Derz1aIcnyvep1vU8pfQw4eL6Yr3nGEQUEXp5aK7qZN9Q/v2za0kggCMF1VOchI8MOyvNK/PsbLZIdehtMp0hSpZ1qRKOzh183vguW1oKbgTnLlkh494k8b5kwUY0JCmJrUZzwAigR1jsdqMmrAJ5J5oI1e6I6qCFKt8c3rckt0uOSzwUyNiCUPya07LewNfk/hUp7FayCebN9i+RUGX3J4C2nrEmkS0sh/bQ+9hUpw8D+6lH14R0j30Pk+9FYiR3kzy8dA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(39840400004)(376002)(346002)(451199021)(478600001)(2906002)(2616005)(6506007)(6512007)(558084003)(186003)(86362001)(38100700002)(6486002)(6666004)(5660300002)(8936002)(8676002)(41300700001)(66476007)(4326008)(316002)(66556008)(36756003)(6916009)(66946007)(54906003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WJW+ZsLmaUqEdnh+SVTrmEaZTb2DtbBEsWQE5EoFg/lkGx3g1mbJeEcZzZC2?=
 =?us-ascii?Q?9VtaYD7EPPJgALHm+bIAC0Yny060AtnYikKPGqAt4ioQsEcIitPI3787ww6N?=
 =?us-ascii?Q?aMSrjhiIjjIxRrYKsOTyKW/zIcC4Y5SchclZO/1TbEaq8hTI1YOqxR8q0xfg?=
 =?us-ascii?Q?KePF0uil3DbIsmuUiXvdjYLqpEbwK6D/xMbrn7X0J7YnAn8/HOhKgak7+q7j?=
 =?us-ascii?Q?Ps1I9gQvTbpA4b1s3Cgp2RQ6bpO7rEUqJpUlM402xrHgIk+z3zibsPbwbl+G?=
 =?us-ascii?Q?9EFo99MwQPdp1WhV3HoP3j/IDRQDQZli0w7asWUu3GTdse0+cwAPjZ+6BA34?=
 =?us-ascii?Q?sDmOO1WrRn+hQ5ou9plbe3dP56/eNpoI7nxr3ewhlH272QhGnncHu9dETMlm?=
 =?us-ascii?Q?Kimy1shvlY5UXiXcRr+pl5Uo330+vfYphPzYZ7hvJMG6TMaWnNMZ0cuQ72su?=
 =?us-ascii?Q?hYSD4GdWGil6QiC9T9Vaz9HKmBdVFRmC3ZFwElomFBZfUr25xCfC+/PibndC?=
 =?us-ascii?Q?G/eQfLVxMyYvafB7i1sv0AL5kEuEQi9HMw8eL+lrP2199geKM8VSNrHsI4J5?=
 =?us-ascii?Q?6S47BQvKWakBxBDm78SefPiyJiYqKgytyT6lcP+XjPDcv53CWtPir0mQOBsr?=
 =?us-ascii?Q?/REiM3sN4Ruv20lK+FB4TVvh+/RucPT8m8MA3jIWczRU2n2wVw+USGkGOS2X?=
 =?us-ascii?Q?CLQs0nJ5wi2nT4EdlxIKlToExtCH1OnzTIVjY5LUvQ8Ab6XTz4OFhI4iC85Z?=
 =?us-ascii?Q?sbwwdcjNIFWwnMJUX2gBjAlvrMoETiBFtonOlBK2HcdOFK1gyVb+31FgMJR+?=
 =?us-ascii?Q?N+0PrarX0/S20ghNEALKOc9NDyhfwPcXyKLyvIqFO8QY1dxRBqxmrmhZv7lq?=
 =?us-ascii?Q?ZoTcNtCe82wNvfEacZJkOw7fHvDJgc0mJFEBIAxj/uvCfKGZqDiIVbSisp+x?=
 =?us-ascii?Q?ioSTRJBzfmqxAnG75h4PvH361QU4+TxINoFjw0u9UJYINbHPTttdYfRmjYrf?=
 =?us-ascii?Q?TNBJFUgEFzX6OEzwf0vM6474yoG76KiFgW0p9AShjRtFGBBAtlscdWECJDWp?=
 =?us-ascii?Q?3elZ23kQGLrLKLNd7mA9sP8nM9R21rh0JGnAgzElshrYdhppplCiV0JgTQmY?=
 =?us-ascii?Q?pY8lff56nWwnk1n5qIYkOCbkXWj/bKysDF6S+AK5/AFvXewqNE9Z0gLLJWcs?=
 =?us-ascii?Q?XsYUXcxEu+SdLaClKYjZBzEIggR1Ua9sFz51bZDzw+1kRY6/PyGBCgrcIxyV?=
 =?us-ascii?Q?s/tWyx+qZO/aNsnVNsFVcl8vBiVOoaUhc2yvI6GH8QknNZgBUes/A5ddH0fL?=
 =?us-ascii?Q?cqf73xG1E+yNns/7xTMMiglPCoKc+Xqw64kxmCxJ/+6noTxgsIpRdkEUNV4T?=
 =?us-ascii?Q?RlRrE38duTJxnopfS5AuRJ7+9z4HNeJewXlAnhZFxm/krrafNzoej3Hm/5bn?=
 =?us-ascii?Q?MX+aaWCJEnL3kaNtLAwRMEvlwTPAfBBy5chT83/CfMjLMBEjZIvcpcY/V5Zc?=
 =?us-ascii?Q?TNhmJ30fwLM5WvL8stvAiabGEBWzWK0f+j6z32G5ynAo9BgKgWeu9hCaTQN5?=
 =?us-ascii?Q?elI0wHh4iMcrIt8Z6Wguyt8Tuug3+Z0KqSsYmZqml3w6rfuNenDL7XGEDp/d?=
 =?us-ascii?Q?9N5gZcex+X3/GL9TFwZuC1b5pemQZXNacSSrwOwMSJPaORSaZss4vAQgROJP?=
 =?us-ascii?Q?HN1BKQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5954f6ff-8d4e-4aa0-f1ca-08db68ec2f02
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 13:19:41.4826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxsAHZcZrrJj1PYL51am+4L6YM7PIR6q+d+KjMs3YPSsswCjjuvRlAjYGDPvrJDlUiCGk1yx5sBFIZdpTsoCndFfXe0cBawI1X+JlwM/3Ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB5204
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 07:17:37PM +0000, Eric Dumazet wrote:
> Move declarations into include/net/gso.h and code into net/core/gso.c
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Stanislav Fomichev <sdf@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


