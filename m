Return-Path: <netdev+bounces-6382-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E66177160CA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E2431C20C45
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B640819E5F;
	Tue, 30 May 2023 12:58:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A320A17AC6
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:58:16 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2114.outbound.protection.outlook.com [40.107.92.114])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B697310DB
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:57:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SNvHuGEa/jhsOPsmTFQ/17bBkNjFwMbmXofwiYosac+Tm3PTYgxL+nAiCj0DKzCyyocvm3TyyGB95a5H1Edkxo8IZsuZNnoQjmE0ekZufLpJYpzAWDw1W7ykc6YeqTUPpnXbk7AqN6xq0kY5vBpFPNFLjEqeR+5OG0Qs3P2LZjqHkiXKTl73V/Nd8Y0EnTwXfv2dOIcGsbClQZnwnkBXuJ9RB5vravjtu4pmMkxP0h5jlkN9I+KIYoWhFUTQjVPr0DEAoEvCVGQB0g7noEy2B5T3Se69JMZ7YioD4xSDysiqw6ltb93nyf12OYySS6I2xi03jEKkiC9+VTJSzxkrkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/mbfgS51Jz5QCLLPUYEH72L6w9lmnMTft2Q1Njdfl/c=;
 b=n1C2viTKyltcHxk/CSW468K4F+qww8iAVoj/mOBXSDuRZKnNoS6HOYkOYTYszL9j8WwMt2MYyvQIMVrNtaPXBcw2rIZOxKHJnbvNTfTwvPKQ+RaY0+R+JdAOZQFNkv4VbXwMzr3lF8SY4V7z0cFW4x5EM63gUG9XkiMyTgCDBneBT3yQS4/dNhdH0A3PdUgCettdsedlaELQ6iEywbfznlQmHnXTwpjF1qSEqRu3FBa1VuHt1vZnSUH34d7xj+FL3ZmzK7kQR+yjtoh0lRE413eX/XUsqWMooz/AyqxiDFQOirCyPcX5PBlO62KLtcv9bImjCvPFq7qn98uQupMceA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mbfgS51Jz5QCLLPUYEH72L6w9lmnMTft2Q1Njdfl/c=;
 b=I0YW12PLTBUJs278lpxk6YR5RNA/Q5rkkvDhEOVUmdSxol2Dhr7F18loIjKmf8ChPmWrgYo5leHdf9twX5J9xmQrvfMXzKydJqew+G4MMhNT5zHS4DQSjbE0mABxvdHBNF7MAL4S4xps6eTTz0UCRL10ywj0bXFHeMvd8EoDu5Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4668.namprd13.prod.outlook.com (2603:10b6:610:ca::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Tue, 30 May
 2023 12:56:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 12:56:50 +0000
Date: Tue, 30 May 2023 14:56:44 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 net-next 01/14] udp: Random clenaup.
Message-ID: <ZHXyjD7EcjREQ7ra@corigine.com>
References: <20230530010348.21425-1-kuniyu@amazon.com>
 <20230530010348.21425-2-kuniyu@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530010348.21425-2-kuniyu@amazon.com>
X-ClientProxiedBy: AM3PR07CA0120.eurprd07.prod.outlook.com
 (2603:10a6:207:7::30) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4668:EE_
X-MS-Office365-Filtering-Correlation-Id: a6f0b50c-190b-4d9d-84a7-08db610d55e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	r13i6KoZKq/qqLYt/prC4bVa5E+h/23+8an9OXgtT+swe3B+FAuMai3yugs7D0jFWjUCWB8TDvQeq6jTPwQR4QDbnOWJgGL4/I5cJcyxKZsthWsmLh2m1YzZlP9QETjz+3mUqtI25G6v8sBgowU6TYaAWpju/MK69XC9GWddisi+wRd2VX5xHgO7t8E0+RNnSgc63X5C6nQHcrCrslzvoMoqfF2EKy1mV8NbWMhuJw/5oaw1w0gUl/hyh4G/vVdfn0LOcpSCNzwM82IRwkPAWB0H21wzAwooig0hEhsJDd0k5hvSOLL9NaA/QHIiGtble8cNWNHtsd/P7hmN47KDb1ALAqB1hpP9P3nwTkNNZyIiFr5ojb/NfahiRB0qKEr74/AMCH4FZMl62I/z/7v9e/v4BEaCUh0vJ/+ZwOKFEyloy9ENFKPqopgVwB+DPRrV/oh93BNDFHsLHDCWRAbo/JEJDc97VX198nViFYmaMVE024zcyxFKowyJGVoQtZGABN2SNF8VXn+KCVHGPDyBhAmiMM8w73Yp6TipPnIusXcXNML2zxGRvlq2drG/NPjv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(376002)(136003)(39840400004)(451199021)(2906002)(6486002)(4744005)(38100700002)(186003)(41300700001)(86362001)(8936002)(8676002)(2616005)(478600001)(54906003)(6512007)(6666004)(6506007)(316002)(83380400001)(4326008)(66946007)(66556008)(6916009)(36756003)(66476007)(44832011)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HHLpNZ7FVSQMytQmF0EOlrni0C9DT92q63p9SCGkyyhDRTPXvPjGiyYqSDTO?=
 =?us-ascii?Q?s9FhqwuZVvghmHxP8divZlyc9h3a1zd5WqVTFkwMD03Pe18QGYgtURbYHjnv?=
 =?us-ascii?Q?+Su5itdmTHnQGwomlsDgKvCh1HdwpAcjF8eqqf2IS6SRdZCOK3tqO+dB4YIK?=
 =?us-ascii?Q?JYmaDY1VfuKrVublxW7OiXell5Xh/37Sq/w96yT2yU4C6Ubkch7nVuZGrwra?=
 =?us-ascii?Q?W9RWeggvpfpcWgyDPgF4NcFZ1VhPv2kfwGM/eT+YCm4ZBWEL0GgyDHRdz9Yb?=
 =?us-ascii?Q?X+1gzQiKLg/AxvA4kOTz/vjWbodLIdD+3zh2DCZrg/EvXQkFfzYnrwOpyHF1?=
 =?us-ascii?Q?0ISF5CuHBgNj+Vg0tODG+/BB10z+BMKodU7N7RK2axqWG7CsOzPs65NkmUZm?=
 =?us-ascii?Q?pYJiF+5ShiEI29RsrLt52+/mQHX7NH1hLwRB9l+QAo0qy3HkFJJq+ppNwVMW?=
 =?us-ascii?Q?y88cX1MWKDnYqzYU2lc+huSkULE//LjUPBURlvMD9AZARjs44GgCgebZIeey?=
 =?us-ascii?Q?suVl9avzF5lKvrrqEIr/HjKkNgTPJ6oiPJSuquwjapCTC9yMTiVz98qBn8g8?=
 =?us-ascii?Q?Q3DYmLQ6FjVLZl7Mk5PGRLgccyLmToaJclVSYJTlKcL6Fua8j6eGpAaw+DG1?=
 =?us-ascii?Q?8iCDZvpO87oWa6UpDC9S5btRPYARLrmweoWgDc/4Hke/7zzdIM2dIgak70f1?=
 =?us-ascii?Q?04U2Xgr/VaOkrfE2fr/STAdgkxybLPi4UsY31Sc+EtrEEDp/xVm8UasiNVMq?=
 =?us-ascii?Q?VgNNBkWJorvKYnlQmv+y0CaOLqkGFEqziX3Gg10fhF86uPiyfSv+378FIlIB?=
 =?us-ascii?Q?90eW7AWI7mK5aCaQCkWjwMWiUH7kWZ87OjjVjStMO0NhKvkF0Z3on90jxCSe?=
 =?us-ascii?Q?tsVnCLSp24IQW6UAPUvJsFLBYLc8v7D3/qoVRH2f1JNyVrEH9PLl2pQfWGLs?=
 =?us-ascii?Q?bjknNBt7sNh5H2TS0D5G9YtW8Z4op9VTOW2WQXQ06lmResC9EV19SDIwdQMz?=
 =?us-ascii?Q?GTMZrVg5T3u9kj7oSmS0/rw5PqloM3mHvhsls681LLjWnAzfUlXU5K8Y/c4S?=
 =?us-ascii?Q?YXlk/2ThW5ZnNuGijiHXyDnvLzRduEyh8bv4An85MNVJw5DIiPtaRktOl/bd?=
 =?us-ascii?Q?BAfzTaOHcbfDjr6DTBoDjYDjky1ahu5nEas+jJLw/z7XKBiAEVysRzbyxoyK?=
 =?us-ascii?Q?QMVJrgOsnrOBwRh57S0L0yuHEjtPc8taWo92UQ97dJa12uy1avgBYi6P8ny2?=
 =?us-ascii?Q?D3Fsjdtgj1KLelK8ZVzyy2gHX52i9JYnzplRw65TYQhBHNhhm/6K7DbKtsi0?=
 =?us-ascii?Q?gro876GKKbKIOfRXCsv3kpPhUlar9FHatKjyQyMRgTgZiaJXKwYQLtGAo0Pi?=
 =?us-ascii?Q?OVjS0tdA8unKQ2Ryqii2wI+SifG59OSmMO70Ii/73f3glOC5sNy2Rd8wbMcf?=
 =?us-ascii?Q?BnaYjYFbSkNtsEL/xLn3AKJ0N3UO1cBiO64fb/Yv/tuCjSUVFLA2J1gKd7m/?=
 =?us-ascii?Q?vCXXNKs/FQnddMJmVtQ1HSZEg/O9s1nWKAL9hSfG6w6WBXD8fk24J1ClVOka?=
 =?us-ascii?Q?hW8sfMkCLHk73xNqdAHXqP+jQ/oH471C5P0Ep0QcrlpM6UedgzXGXbciUOeA?=
 =?us-ascii?Q?yIdneJex3Oafrp5wfQA0fxUA5iFfoRlbMzNBWz3/5Jmm3Sjht0IVPoetAOIH?=
 =?us-ascii?Q?0/+VgA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6f0b50c-190b-4d9d-84a7-08db610d55e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:56:50.7914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bup9RrURFi3X5QbxWVTORhYeN9w5mvnlLGZCkFFslVVN0Q/a4EAQiRPzVi3a6y2xT17QeKmnOydlRL5eCLA49MNBFLFHqnIVGamAYyKUxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4668
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 06:03:35PM -0700, Kuniyuki Iwashima wrote:
> This is preparation patch to make the following diff smaller.
> 
> No functional changes are intended:
> 
>   - Keep Reverse Xmas Tree Order
>   - Define struct net instead of using sock_net() repeatedly
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


