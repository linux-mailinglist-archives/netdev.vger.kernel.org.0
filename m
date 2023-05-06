Return-Path: <netdev+bounces-712-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39B616F9305
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 18:07:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D161C2811A0
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 16:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3BF4C2D8;
	Sat,  6 May 2023 16:07:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBFC8485
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 16:07:46 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::700])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D14C3A81
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 09:07:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0KP1AYlRzwP5QOOBQ23AHEz1W6664iPfM0/rGtwu+F7Jdz78EcAX7ba5z37S4h6kXsZvFQEBgH6ifjBilKKxoDx+NCY2Hg9JLGeGmVIYf6HKCS5Q3B1VAxsQrOC+f6Bf0Ol7EraEktNwlcJu1YSIRd6VgOISFkQNAqylGDpcb81Pffr7Fz2d3tL8e6rAsO/opnMMUDgpIdHQicfnc7TQQVQT1ss4eeXGW7Chbmza5vC3hxHIInZV8gFcA3myOSS33zsFiwRpCTMhEsFEb6JWldGFgsyOL6rPQ3dinBYIUbzdHruSDppTLgoQDZHL2SH5gMkn6dQwT9vR8l4jLTyIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vgf/sBVNTYvMrO2z4g5kWktfq8Aejaulc6cEd1M7Kxc=;
 b=FBuKXHH/c1hx2jEQKgtthSRDClhAkkRReBTeDohBl0Y8yg7wpktlbzuoqffrKPudtUV/NyBz9SPW+pK+kXv8dJbLNusC/CxsCi3t2mmmhLGG3hJwVF0dwuCEo1DyRpA6cBhNwxEKndFJsstTzxxew8MzvEO4G3Jo+ikfN61PBDJ1KAnBThWzmko+cGh2PdCFuhIEGYP/mwc+GG4o2q/IsHIjrOy4A74YJsJyK3QVL5Vv0tSAD+Y66+gUDNq1qp0DUeYGGcHDMdJIetTNW7BpIk/HsVKqI6oDknJxTe0sdD4ZZqZSzxRPIjgfLjMViGnDn75D/u7zRgnvasf4sK1HEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgf/sBVNTYvMrO2z4g5kWktfq8Aejaulc6cEd1M7Kxc=;
 b=gTwoYNOcfdKvgbKoph0KVvMEC+VBgWfSpvT9LC3eOHcDmiXYE0u5awo/u8+ZXO+4gDzkgLekB4kJUgdWAUk4BNBZSO3h0tOWepV1OAfy+4h1+Yd6gQuESQja+cHCIKKdKW/bP3FZkpIHbMa1GuE8VI91OvO2BwNPI/PLeqwGukk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4545.namprd13.prod.outlook.com (2603:10b6:208:17d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.32; Sat, 6 May
 2023 16:07:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.029; Sat, 6 May 2023
 16:07:41 +0000
Date: Sat, 6 May 2023 18:07:35 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v2 5/6] net/handshake: Unpin sock->file if a handshake is
 cancelled
Message-ID: <ZFZ7R6s0V/FDqZrk@corigine.com>
References: <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
 <168333403089.7813.511134747683134976.stgit@oracle-102.nfsv4bat.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168333403089.7813.511134747683134976.stgit@oracle-102.nfsv4bat.org>
X-ClientProxiedBy: AM4PR05CA0033.eurprd05.prod.outlook.com (2603:10a6:205::46)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4545:EE_
X-MS-Office365-Filtering-Correlation-Id: df48b009-9dad-4c0f-b16d-08db4e4c0515
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oMtkSUNQe9tLUhKqMuRHnJb803O18yWBcWXZbtV6mpqx+FVbr/ALkRgE7In9dfBzmGXj7WoiL7A5RATIi4LxqAzj4bWoAIJ5cs1ZhJoApVMGDNZL1ybvcP8zCEQ03dqhizx7nUmlrpe5+z/a6JyDkUR2WtErShWzD/jLoFdYTpOYMafa5T2Abv2BwEDwM5JFa+VV2+2CnFN/+KcG3T2S2DgZKYEkkCxWzpm5e1HoCA3CGzSwewmIE/W04Ve1p1URxiEZprn1b66+LAGu6a3rGEEXgvy0GHq8YdN/2PgosMBlGotqReT5sd0TDggflOP//q4MEqQiCviAch5MsFjeestGtl0SNzTZUMPWO72lMAMH1HKTpZ77OY7n8bND3CHwT+OxftIAV+qvvT7ybYmuaPZuaZcDG+oJoY/7mbpl6KaOYYW4jtYqoF8fPmdGU+9STWDT9b9ns4oo/KzRngcQKUAJ4fxo5sVet//i1kiMiZ59ULZpVh/BYuPYTeJKK2rB4rA8UlkHAWMErWWriTt/tNI/d3Evtilea2oIF2OvYBFxOFp34E9cvQmO8zYEKQILOvn1/fwP/nLjlp+FgkFRPWAxWsdYL5Ltg4+2ZwXiWEE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39830400003)(346002)(396003)(136003)(451199021)(36756003)(478600001)(8936002)(66476007)(6916009)(66946007)(4326008)(66556008)(44832011)(8676002)(316002)(4744005)(38100700002)(2906002)(41300700001)(5660300002)(186003)(6666004)(86362001)(6512007)(2616005)(6506007)(6486002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F4DTadOY5jNH7G1MDEmWynfUdUkT7x84XMn/S4hYXaIgEzWYPL68YNjuus8q?=
 =?us-ascii?Q?CZpZNlV1lqJHxzYsEKQ+YZjZ565kRuRMfk/er1gYulSEImZ1sThTCH7MtnJS?=
 =?us-ascii?Q?hAZbyUwLqlpkN0V5q88xghtMuLsDMYLq3SHoKg+GgCdrgi0pW4kqqXi7Q01q?=
 =?us-ascii?Q?xWqfIjPEnH7rs35l02JGleCTvLMjDmPu4f4dg9K5v/7VsP3pCTyes10efuQO?=
 =?us-ascii?Q?eemCIpWLcF5onQeuQjF98TVYJFFvjLW6QgbXGX9HBsTb9VNPJM5eUze49Ad8?=
 =?us-ascii?Q?YCALJ78IPshnrZzm93+UGd7dOeafN0lijnqHhDphys8VsayWWxNkY8bZ4BlI?=
 =?us-ascii?Q?UueNWHistpOKMB1eqOLJ02fqUdUG+b8uFjm9bM5Cc+TS0jYy8QD7SRFRirSZ?=
 =?us-ascii?Q?6zLHdVI+hhuEmetKephClHD1KBG8m82LIbHXcCSKPC8nGxEKVLIuaOT02SKw?=
 =?us-ascii?Q?ABEOzDu2KZQjSAj/EDUHqUPJPrDYl96MWCdbOWXlNUfeSaeQmNSOP0BWp1EV?=
 =?us-ascii?Q?lhTPZvmjN7th7uwizDj86l3pbRWRxgnjptrLtybdK2hbFY7wlWXiF0r/5awX?=
 =?us-ascii?Q?wkrBVcGhiL0FTiJmXvGxdi6Y0Kg2X346DpZRBD1quQyoDsacM/clgADXT9E8?=
 =?us-ascii?Q?UGOdpf75pJ7LOnR01VkZPr+CimtRPqTqEKF+CdPjqyOhUO7dgtKgz6l0S6TE?=
 =?us-ascii?Q?VEivjtrJMGJRBaatfRH+nPvgrjbusA88b89FTH6N5AOXyaY9SCFFBsgvAxNv?=
 =?us-ascii?Q?cqNibinuV8piNu59LVrJIEOU1MtZYq5A6a8RS8NzsAfuCUL7DBAcz8PhYgNL?=
 =?us-ascii?Q?O8UUeDX9X7aDoNtzNrqtVXGERG3gPE3XR+uEz12Go54Y7AU77TPwdj7LKEeo?=
 =?us-ascii?Q?z5NJbLoWvikELDSB/6kBVWZpwFvLzFOpBQQ+7bUWYNXciDXM2ddPAgpTXn9b?=
 =?us-ascii?Q?DYZ1vBcXQ5A6wZBRnRP4EVuB7FLL+eNMViwhDBHtQHCem7bos4Ucoe/vJTAX?=
 =?us-ascii?Q?q2kQfl2bpxiPQPPvj4pVQOza80XOlyUjZpzfpnuvbF+hyXtfexe5zCxdRxQO?=
 =?us-ascii?Q?EXH4PoF14MtEnCHUZArsrhug8fJ/DB/jVxDeP1cgJjLityKkXGoM1uvSfO2S?=
 =?us-ascii?Q?ejpPlUVy+MMkIiYfyaeOolO+b/HoF8J3t36ZQhed+lefqgut2t+MKSc3tfWr?=
 =?us-ascii?Q?eFIwsCQQnUqAeM6Y3y74lK5zWfJatLj7YR6CtSohUqY1R8PKB5LvVXY7lGLJ?=
 =?us-ascii?Q?7D0iPeMmyUEmjDjTxWZTK7oetyNcRPWB6I+nO77lzxbCSfQFP80yqB42zYBk?=
 =?us-ascii?Q?ov7wjrcL4vvFQbk37p4qPrhRF8EbHJWcR6iGk79d57Bt8M9i4EmpEvXPdeMM?=
 =?us-ascii?Q?AfeztNGzxF4q6879OV8uVt9TXE10hgJaUIrApVZt8S4jUnJZ/GBLC0MxDCDv?=
 =?us-ascii?Q?BlJRgMxbLSIYR2T7x6dG2SKQI8JBmjlWQTM+qeJ5z+JhVtR/PILESo3SsNLG?=
 =?us-ascii?Q?tH8OCcrOyAgLGUEdRjcfS7LUikDKITijhuOQNMyhAtlL5nk1dTV32Gm1eHFB?=
 =?us-ascii?Q?fbrIyYzT3aLJufjyz2i7Xr7K7ao+MBKRQqkxwL3vEqr3JqlWB8JiGHoxTEGq?=
 =?us-ascii?Q?k7VqxD7V2bsRxGxN+Q5E7Ob7mi5DBpWC0n3BY/BzUHwIp7B9tOY8tcITbcYp?=
 =?us-ascii?Q?wcFusQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df48b009-9dad-4c0f-b16d-08db4e4c0515
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2023 16:07:41.4614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BmS18/1gaGrAe3oGn4tSU4YdyzOgvvvb4sACHZ2/MzQzFx+vAQt9tD3ap0ihSoJ3qCY7krwHG0K2gXa0HvDyFB85vcWs9KF3nNvTR6ehpYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4545
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 08:47:13PM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> If user space never calls DONE, sock->file's reference count remains
> elevated. Enable sock->file to be freed eventually in this case.
> 
> Reported-by: Jakub Kacinski <kuba@kernel.org>
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


