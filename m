Return-Path: <netdev+bounces-3722-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 834417086C2
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 19:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 622111C210DD
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C05B271FD;
	Thu, 18 May 2023 17:26:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F01418C15
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 17:26:28 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2121.outbound.protection.outlook.com [40.107.220.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FA7136;
	Thu, 18 May 2023 10:26:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S7GTWNXpcvZePhOXjFotnYcj8lejKv0+3mbHbPzL35KFtJ2zZac0bD2TjCHehpNurefDpgMxZwG62sl7PiUH6JJZULR4tJm97mHzBnFKhoscAbn2KH7fuUcViq/4jsDD5NcIPO4wCS1tLSaxMm/PmTutwrMwX/ecb/DtxtXMAx9rSoPOiji1rD/O1gNt3M9gNsN0HaifYqnTCnJpt4SN2SpzjkuxJzYemSkhdqPJMi5giIjmv0OdR5tYNqG2UEMisCRPu0mrquu//v9WQGk8T677CCjcLm1kN+/l+fI5FVlUhAIsiCSbDKN1yhyQlthV3IVlgtgB1cIkFBKFBTRv1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NofiKyrLAR6E282D4kaVXdt+NtF8LEK8gL1gGJf7SDI=;
 b=O+bSmPLlUE81mXJEyzY3DavK2UnY51KVOmcR1VxkNzM9qIMZqwl3zCi9rrOeSIe/B/Sgh4/9LZd6XRHlCQA6IkwrqmJIxCPU973juD3wJGExg2l+2Zyz5d2JjM49IQtrxkk7ODRDNPKHyPyYgMqisp4r7d8m/oeKzdBCJLPe185uW5YndIx4x2TUBNwQ8wWwukLTInMpbgHEH0p50gHp85OcLO34EmIYPXNyj3/IEElwBjw0D9VKq3LYIwp1jrv+gQe50CHdA8JFvdxGGwLdlhgLBxLQnw81ZCLmznZODi6Z8+IvwFnh1gJt+xePm65MEwGGFvlYNHgXFnvGRvm7vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NofiKyrLAR6E282D4kaVXdt+NtF8LEK8gL1gGJf7SDI=;
 b=ZCrN7B49x18Qb8BaViPGlRE8IUnhlyy43tcxTTeDIFUFr1ZC9TB4HO7ZewuAmY7BFZwGiNKk7NE+upDVhQJC0/+Yj0CnQRL1ZwwcYkegbPLWA7f+iwyFyKzPDsnlZ2KDDC/X1cPsotm5OqtEv1vNiFiVH/4xFn1ziVCDsi0I0PQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6219.namprd13.prod.outlook.com (2603:10b6:510:248::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Thu, 18 May
 2023 17:26:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 17:26:23 +0000
Date: Thu, 18 May 2023 19:26:15 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	netdev@vger.kernel.org, roxana.nicolescu@canonical.com,
	shuah@kernel.org, pabeni@redhat.com, kuba@kernel.org,
	edumazet@google.com, davem@davemloft.net
Subject: Re: [PATCHv3 net] selftests: fib_tests: mute cleanup error message
Message-ID: <ZGZft4ydH3p2+aNU@corigine.com>
References: <20230518043759.28477-1-po-hsu.lin@canonical.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518043759.28477-1-po-hsu.lin@canonical.com>
X-ClientProxiedBy: AM0PR01CA0077.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6219:EE_
X-MS-Office365-Filtering-Correlation-Id: 28805ac8-dc5c-40db-125d-08db57c5008a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WzWH6dysDAhRzwIZdOkEHusVFVoO4gFzlHjwnAf8PAu71v7fc49UsiyA7iqt/om3dUaQv5DbxVTFeHrDWuhRzmSgk2E4KW4yg0OgYOncRPVkr2mPri1mhsbRASnPVTqIeFeuZ6uQtEyJtjFjEJTRpKgItQJKQDtc7uUUa/ZP29WKpUBxHdlF3ItpZ0kSu2a5MHaIJbfELrpunEEiYfgEO6wsakcRhLBDZkrTn80Xp0x3wpGHnFPkyAOOa5B9seHBs61lyoXJdKV6h4ODpVevMKFqQj/DS7IyOv3zuFoy2mESEl0WVjJETfbWnGNnp0htPrGWFE1EslZJKhKxke96U1k7ZufNAd7Lc0q3NqmAZ6v+Q2+ssKU/d1TbjPGyZZ2zGOmAZYtdOPctyHMXDjMbBUA0CFAqG39C2WFdd3H5sbI7q/CBbsjQUjK77+/5C3NUWVOlMgiMLSrz1t5IhrNq/iNWcyJpN3PoVHxviE6X1yLAoKTZZKz92Qoj/v0exq7KoUYVG+Szhl8U1Bzo5wCG1/JgwvJ9RO6RymkAqF34ltFiOakI9Scnmq++xP+PZWc+/Ch8DjB7UQ3AgUemFj5YR55oNkPEjrvyk+QaxzE0Ovo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(346002)(366004)(39840400004)(451199021)(6506007)(15650500001)(4744005)(186003)(2906002)(86362001)(6512007)(2616005)(83380400001)(36756003)(38100700002)(6666004)(6486002)(4326008)(66476007)(6916009)(316002)(41300700001)(66556008)(66946007)(478600001)(44832011)(7416002)(5660300002)(8676002)(8936002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0yDJF4x9V1hM3EHIvUfKKPscZq8G7v0TlY2RrwiYbhMk1xlPp3WKRR8QKLy9?=
 =?us-ascii?Q?NswTpEPBLukDHLm7DfUNOOr4ngZpF5mX6KIlsOIRneXZB95uPEOZORWUslw9?=
 =?us-ascii?Q?Q8q1QIYygWdCytx5OO/ah8SGFEnOWLTWXpnVlrF2Puk9Hcv5oukKJF6uy4Yt?=
 =?us-ascii?Q?9t0UgEvRmIHC3PAgYJywGrYwxvvR16r5y9moITBRaILirkbnRNPr5S8oN/Lr?=
 =?us-ascii?Q?hG+grlsbcTXm/CAw3gxn4cAd1Mashi0+5r0lM+/2lguUxr+IUeXnY5gYrSX3?=
 =?us-ascii?Q?0aKHTVbIKYZ6DDKzEAdH5eq/tye0vE8YmGkBlHzXobrbMkAfoXSGF2KKij5M?=
 =?us-ascii?Q?ENTn8HUsXyg8z+QuwH3U3wbXWlYtE7PoGZIoOM1J069prRXskn2KZl59bXqq?=
 =?us-ascii?Q?b3eL/rHGdyyAILOPau30g0MhC9mh1dHPfSWEifhghL88hLjycdq5EOOHUuBh?=
 =?us-ascii?Q?u2gQKdSc3s4Ws/J+wYSJcbYJVo6W58sr/Imi8nMeJoNGmlzaSKQfVbnDvL7s?=
 =?us-ascii?Q?woDCDxH1txLgzCJVXCW4UIoLcH6huiF2IbXlZVFWLXoz0BWvr9Yx4hdEl3TQ?=
 =?us-ascii?Q?smvQ0xYBWB7cSLujaHrejAsNv/nCXMBHRasRseKyBLoaJjl0kwd+yCnmT80t?=
 =?us-ascii?Q?BxkjEbE1u5754CRMk+XlOeHZLvdPNf8kUa5fn8hCX4vQcJ+dfg2EukdCeiOT?=
 =?us-ascii?Q?uUe/vtIm3rMO1UCQBsrfJciNN/n5qZbZo5+/Xeq96Y2XCDjxyI+rRprvCShV?=
 =?us-ascii?Q?wP4asre9WjSAPyR2uBgpLopuHSwrQJNXd121vuuxdy4uPwzjo32pWKr0/1qY?=
 =?us-ascii?Q?C71QYF3ubULKfTr6TGTIYIS8fDrQuAK57Hp5vSPPa1F4I4kaFe1Rs0H8aUfc?=
 =?us-ascii?Q?0NbmwV6xrBEx+QNj3nQGhP86ylk0PWfvS1IX2Dp64zwqVnLB8lzNmad5n432?=
 =?us-ascii?Q?urKVfIHtP4QmkSpdeqvXJD0Nunt7SrjTg/eWoCxcmhu2jvp5rN3EOrbF+mo0?=
 =?us-ascii?Q?ue46jmLVTjt8/iV4gAxmnaEjKIuoIe7pdX9l4ruEUHwNWcPbWh+rVBVKSAKJ?=
 =?us-ascii?Q?W6VJ2mAIyFmUeC+cQpVKOf0wUYEnq8vhs9XLFvjJ+GDsuflgM622xqzOPVOD?=
 =?us-ascii?Q?0RRzFo+5tq8Jvk2DZjFgLURkJGH2UvmZxMkqJBRpL73IxHdCYK8n4dkXr8G/?=
 =?us-ascii?Q?ZwHJwpIyrK2SlVQ2rBOVuJI3kGwE6v6fW5Y7RBut5FePw6HUmgo3wJypVpQl?=
 =?us-ascii?Q?v3FF0JwZS2JpZps34clxzvtUn9hbrEzmt5am7vUeGEW/PFhARdLwCCGmFR/K?=
 =?us-ascii?Q?RyXw+NmlIWQ+BUBivNG8LOc/Wls9bh3KvQe24E0M5q3yThBjHyDmvZIBAm3U?=
 =?us-ascii?Q?92Zj26yoMVj8+bnWEQiBvQC2DgqHATGfzpmy17/uKoKVWqT+rFYY1cic8AhA?=
 =?us-ascii?Q?eGuE1eAgIPu7hAkTUrHPCr9J6+elJuqvXMax1WBXU/drnzSd1h/afCMibDL3?=
 =?us-ascii?Q?D9aJ1e/NWvOCkbVto8hhrHDwx+rAiBOAuPUppaAxbv9YuONDSmCvPgebV6Lf?=
 =?us-ascii?Q?Uc9y74pX6UlTzEcsSmmhO9U6T5fhVFNIpIyOHfCntF1dEVL0uj9UQLn6iFem?=
 =?us-ascii?Q?nK8Q7CFJjjnaPmMYSUQmIrH1/73UhWjSeJOv34nkfn3c0NBRBStoy2BiAosD?=
 =?us-ascii?Q?65RJtQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28805ac8-dc5c-40db-125d-08db57c5008a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 17:26:23.4230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4EZm6JpjHKmde69PNrD3aEjltDRlv8xLgt3aJWZRXg6Cwn99UFj51VvdRG7361QSp0i1jTbN7VmXAwmAfTJSk2Ya62vpaqH1TSaTs8msz4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6219
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 12:37:59PM +0800, Po-Hsu Lin wrote:
> In the end of the test, there will be an error message induced by the
> `ip netns del ns1` command in cleanup()
> 
>   Tests passed: 201
>   Tests failed:   0
>   Cannot remove namespace file "/run/netns/ns1": No such file or directory
> 
> This can even be reproduced with just `./fib_tests.sh -h` as we're
> calling cleanup() on exit.
> 
> Redirect the error message to /dev/null to mute it.
> 
> V2: Update commit message and fixes tag.
> V3: resubmit due to missing netdev ML in V2
> 
> Fixes: b60417a9f2b8 ("selftest: fib_tests: Always cleanup before exit")
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


