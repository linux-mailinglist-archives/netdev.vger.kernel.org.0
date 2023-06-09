Return-Path: <netdev+bounces-9470-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EB09729577
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:37:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 075EA28187D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089AE12B91;
	Fri,  9 Jun 2023 09:37:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABA113AC1
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:37:34 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20701.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::701])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38C730F1
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:37:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzqPq3BJn33QfJPfnjji2eoJccNmtO/KRqlx1OwMF9y3MaIZG+CwiIi5QSHNNwpn8Awc+Q/MhasSddcA7+dXOXf903Mm0+mOGAZm99x35udrlK0BR7iTYr6nJQE5nNVsoBcNgTE1s2ke8UqS5Ar8Nmpm4QIXGW1PBgnqPyEp7dSgsVcRZ1zs/T9heVU4bDiQlt9LwVdza01IN4wsFuTYOOobmKplxE4mnYTFBBr5Pobd58gJjP+KVPaMFGH85BDEPP8pANsH54KwEXkQ4+eONbUUUa1EN3nNz9Hz+gMg/4HNCoknpTs8Z6zDWT79zYf0qUUr6sAFRwO8C4+ZXB94Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46ntXxNit37xFO4XcKyqFQxcGo+evHvNLjjElfg1aMc=;
 b=J+53EoBfsShaYnCl+QLBX5gGgJt7lcr2vLOPyv78mvhSNIQb4qOnLMX4T/5KzzTliWXpWGalQ7xTmHSm5EfRlalslutapnr68uaB1/lbt8RVnJghADIMvl8rocmtvBRhOhS3AlNcEC79vWJ8BukF9oG3PbNQ2vhv8P9eNfmXXZFkq84mqtRYO0G0XtHwwEoQHO6D2H4l3dkv6z2twjFZWLOEJ4kAcZSQM1LLxBklTg4CGbRuid1NMxj0MXHVUDWj9nhmvtSITcvObKiGIuFh/JuU1JRxu38iGaIGPoeFhwiVR5Q6a+BewO2vOcevou5x8zKg08umzS64kigzDcWXdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46ntXxNit37xFO4XcKyqFQxcGo+evHvNLjjElfg1aMc=;
 b=bVHZoDMgCvGD5iXaxejI5OHjglODsUXa7Yw3c+xYh9RoKSNTUBvrH/L8Icd2u6Ugc4Dz01X0e3KuwMymKAn/WIcBQC8AeUa4tgcEGrRsMuDiuL2g6QZEpMUaf1oB1HqCtVPxJBtV8xnfJptqED8jGiGDwIHcTzoIJ7b9RKbL48U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5078.namprd13.prod.outlook.com (2603:10b6:8:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Fri, 9 Jun
 2023 09:35:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 09:35:59 +0000
Date: Fri, 9 Jun 2023 11:35:53 +0200
From: Simon Horman <simon.horman@corigine.com>
To: edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com,
	Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
	habetsm.xilinx@gmail.com,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: Re: [PATCH v2 net-next 2/6] sfc: some plumbing towards TC encap
 action offload
Message-ID: <ZILyeY8Gcc6yqSA9@corigine.com>
References: <cover.1686240142.git.ecree.xilinx@gmail.com>
 <8664a34d8286c166c6058527374c11058019591b.1686240142.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8664a34d8286c166c6058527374c11058019591b.1686240142.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AM8P251CA0014.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5078:EE_
X-MS-Office365-Filtering-Correlation-Id: a3d4ede8-3112-4d26-fc6e-08db68cceeed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7jONaPHzawg6VPGaZ6oWTk+KPz2yBPF7XTvpM+zB9IPniZyGbri6tUAkI3ifTx3gQLkU1QkH2pg07dxI65phhl7berJrHlRjZorLvQVFpNaPWtHc8ccG8l1/uf35x8WpXCA3RFBp6cBjAKomGI2EXQbCUeIU+mPthFoJruhfIgpEtWOVxJP9pK8cFrJ0oNh74cJLxCMhhQ33ndSfjElgqdEHT7i0FRd3L7OKpiTkRhvFc9opVKdneK8zgjZMYnVmjLcDoKF7YOXW/wiM7a7pWjpGVYmQ/ZGq8zBf81fwLyDCDh6/9JmRHT1HVB4kv8lIUAkUxNDs5dyHhzye7RotosG5R4K8bztFLQTQ9vK2RdTtpYMvk+R/VlqHvjtn+UX0R+6DQMXDCCXYXxrHrw7YBfLBvSqLyk01X3pPIFlwjJVPL2yK+0yyqfnZIB/s1JghXCcE4VbwuUAvx+EBt5Ya5bBz9h3TBd8yPLuoUdK+yxlbpOOC5YO1j/wc8SBkNRz5Uy66AFgLtw5Jzqx6peMA13O0SDi7eD2FdDu7+DMYhrIOnuMTwIAI9iw4ilCF9OCye9/ChTXBj7epBphuPnRsAKKiIdebTRLRoIJI08fZNXo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39830400003)(376002)(396003)(366004)(346002)(451199021)(8936002)(8676002)(7416002)(44832011)(5660300002)(6666004)(4326008)(66476007)(66556008)(66946007)(38100700002)(6916009)(316002)(6486002)(36756003)(41300700001)(86362001)(478600001)(54906003)(2616005)(186003)(4744005)(6506007)(6512007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sA6OeoCl/IaqSLjFqyEjz5N+B8/dqFCQASYlXmj6fYheF3PSHuu1eTlCgeX+?=
 =?us-ascii?Q?ZELKtdNir2zE+9iVHAVUggIGyqfl4afIFhEP/5AGI97VXsXXOCYi5Dvt2KJD?=
 =?us-ascii?Q?rv+jENlf+A+Oo1O/tdJi0G88OxJEKPjCDiPsYRSUVlYWL2VUVDe3Q66KAKVx?=
 =?us-ascii?Q?XY3e/9xNAgZyYyzunLxNBXS+iVGBAvrAmE+nNHo4USw8tMq5Bg6GsjF9rxAW?=
 =?us-ascii?Q?W8HLCPSUbATSmWY1v7eFkbP7nBPstJegnIpJP2FxTdFt78xv7K342z1hgG4q?=
 =?us-ascii?Q?w8NOF76/NwlJgCgqhKWQsfrkdhIWYHq6JTFT1nUujgIWz2KmMcudUBAxpxbw?=
 =?us-ascii?Q?Ju+3Kl3dJmMM1QRzr1lC5QFzqTo2fRbJ1hWKa4V895jaCCMja3wrihz6MiIU?=
 =?us-ascii?Q?vWZVnmAtTUc52DoyxCNZ1OAF7KNgUAnOIH7SO9dq6rnKy5n4OMfUgmX6KFM/?=
 =?us-ascii?Q?+BYzByLz5jtGdaD0Ddr3KJ3rphkDy+lygnMXRCPD0jQc2EB5JqLqtNIKqCg2?=
 =?us-ascii?Q?rH/jULJlMGZoSdSOwXLss2ymsiyDYY4BENRsphpCUbSmJJG6l0EAbxaaV4xN?=
 =?us-ascii?Q?dnRy/pe231jRePL4EwZ7Xmstf/w8x85NdB6xkRlAbnu8no2qNYDM3mxBr4SW?=
 =?us-ascii?Q?eqfIPUX9OzdTe0XDlcwJ1+KEYpsnm+OetoUY29UTFyVOan3GDMiLXWCnuHCp?=
 =?us-ascii?Q?AJUlhn1h1Z6P1w0tqdyzk1eYtJumpNQGBVRuqkfuf00yPnofGaIxSy1aYjnd?=
 =?us-ascii?Q?w+OWFSNmWJrbvfpX1SHIoAep4WVbS++y5+AuIlH575DsBj4E3RXDCCPbPvoS?=
 =?us-ascii?Q?1lG1FXRNokmoOBr12vpxel6q2XnLvKjS0bpZcCN4LeLpxPkwOQ9W/EcBIPqQ?=
 =?us-ascii?Q?E80QvnmlA4d2o+RJAhWWwB6H9pHs69zyxg3SFDnjkBXARbRapZurUuAnrNu2?=
 =?us-ascii?Q?HEsZGfwEtBpdMFeyZMEaSFBeCz/wU8sFUaFHc8B24R9VfD01FgaO54weue9P?=
 =?us-ascii?Q?c7mIrVGTXnmopvXmfRW264ACj9oH+E0zx8Ieop9TtdZcfZmc+3j5NiOx88BJ?=
 =?us-ascii?Q?c5sVSNzUJPt74V8dvRTokaAmJRXQdHtvofX/U7AkoTPNH+eBItNNgkmRCjrh?=
 =?us-ascii?Q?3D2vK5eCGwnLIuIULyATMu+4oEERYtj1MMWEvbcqJfy92HhtTsiF0qJpd5xP?=
 =?us-ascii?Q?sIHo9KeNSs+r5BbnwVUlTvfSJgYLVaf8aPpj4jNSuAFKIORcdUGwW1C8K9G+?=
 =?us-ascii?Q?DUnlezycbcztYLkeezWQhDNybW+SjnfLUYR2/n6Y6/CrttEZleK1yAkaFUoZ?=
 =?us-ascii?Q?xfeoduBYxH+7xNcKzH4HAmsMaEorpyuW1qK5Wx7jDOwo/3SzcpvQdR4WQ9LS?=
 =?us-ascii?Q?tAEyUg5h+Rm1+Hm6O2BhY3GzSI9S+QLg77zqYN1Ku9iPWNwH16dRxW6S3wNK?=
 =?us-ascii?Q?2PEyfGM643GeNlRyqvDGYC2EOW4R6+wTEubfNXuwIlgR3b5nPUNsF4y7Bq6X?=
 =?us-ascii?Q?ThOpapDW+PgKZJQTQDdEL0SsNDyeD+2Dieu/bEgiQvKpVHt7Q6fomlaQaZpy?=
 =?us-ascii?Q?qDhcOWwXHotL3kf0Z+GoOQNsLkMfa9o1W9zjDTi6F8LQVqINgH9Q3VauNrD3?=
 =?us-ascii?Q?CzS6NaH/r/WUfZ/Z9yi5nj3konr9HiZno4hUJpgoKTs7dZsS+xuwMGYU+XpD?=
 =?us-ascii?Q?HaxM5g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d4ede8-3112-4d26-fc6e-08db68cceeed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 09:35:59.5316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /dnT0GyUjh2TOjL/MclVFX5gtUFWxcNM821ErLBas7+P3ci3UwBnjaDMxil+xzuwV4H+qCuIQ5dJEYJtZuLcac6Pas8kJX8ylK23UOc8/nw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5078
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 05:42:31PM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Create software objects to manage the metadata for encap actions that
>  can be attached to TC rules.  However, since we don't yet have the
>  neighbouring information (needed to generate the Ethernet header),
>  all rules with encap actions are marked as "unready" and thus insert
>  the fallback action into hardware rather than actually offloading the
>  encapsulation action.
> 
> Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


