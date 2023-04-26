Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B7F6EFB41
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 21:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbjDZTm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 15:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233549AbjDZTmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 15:42:55 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BE02684;
        Wed, 26 Apr 2023 12:42:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rawhb8i/vwkvqEGYg8MXjNR70+Qght2EIrnJxFDZTrJ4x1NfahuZQsqHnICu6DiwDi/MKX/AduWPVbPRcMTmp+t0XNTNFXVCg1VFD7nJk3vCQUOU6gtajKMp30x1tk144h4L8DM7+5cJFCnu5OjOYSZJVQqVRa4qUqWMOmDQnL9/ZEmzczLVl9OOC85UoNojww5aw0TT5tn586pU1JM9Xia4hbLcS5gRyYpBCkmNTsCu7avMYM8WgNqAt8sD4EjsgkwTlssLIqAeR/0S3H7ZLckdkUf6hK4nQr8yYmrdvT393e/T7es2e6KLEk5d8s1eXU6DmO9IjvN9HaveS11kfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kDI3JCWgHZhcNmb7r70ZrN+XPtcurxwozUoUKm7QvHc=;
 b=cqmpIJ3c8KHkeuFu4FmPtNkT5WKggPh4FGcBYEnFMbnqShu0TRgpu2+QCwyL7a4dnfZ/7qfQZHcBc9S2Bm5eR+fp0Xum1JCj27+ihiYSPsWz+Pa5J8EShBog/jJ1nsi4Q1NsDoAdKeZzyBmnsByeHEQObe2P7zpAZ3Ajt7O92Qr4evAO6q6wS31oMN2Vt/B/iJKwRJ8jOD76P0bJamYrp68zo6mZ2WW25K7cuENQcxk9cRjRzDCoSSPhEt1MXK48lYiV3P5l36OTy1syb8khKYXAelZHZ+8ipHlj4JSiwkwTzzCpGZ7YEjKGq+HivHjNNxoshZCEhS3TlHblrmt5Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDI3JCWgHZhcNmb7r70ZrN+XPtcurxwozUoUKm7QvHc=;
 b=qwI77SiQaFFZ5QmQG7G8Ph52Dlr1Yp2A0DZkEGi7giUIqThQZNnK2Qp/PqVnLQk2YLZHQ7JUSCOJ5R8OBFmJtyJbHpARuU4jNm4pQZd96MIQ3Sl/I6CUnWPZLKI5E9UTxMVdjbDlgQ0hoAPGxkbYN06JEzE7jS5T2NHwWpfDolY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3803.namprd13.prod.outlook.com (2603:10b6:5:244::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 19:42:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Wed, 26 Apr 2023
 19:42:46 +0000
Date:   Wed, 26 Apr 2023 21:42:40 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>
Cc:     patrick@stwcx.xyz, Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] net/ncsi: Fix the multi thread manner of NCSI
 driver
Message-ID: <ZEl+sL5TMmOaqZNa@corigine.com>
References: <20230424114742.32933-1-Delphine_CC_Chiu@wiwynn.com>
 <20230424114742.32933-2-Delphine_CC_Chiu@wiwynn.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424114742.32933-2-Delphine_CC_Chiu@wiwynn.com>
X-ClientProxiedBy: AM4PR0902CA0019.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3803:EE_
X-MS-Office365-Filtering-Correlation-Id: fe8d9cca-54f3-4d51-a801-08db468e68d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9p4IgJVeSlo/HXcDmOpafuTreLTx+IvOaXVF6Vg/1+Pa49+8hBnewhTnXn5g6wMFfT+zCgn/1sfMAelYLPJOr6UMqyNqx7Z3ePpQQFlKuzUpb0xkxH2hN4umM5GnnbqNk2pOeiM7DQbdxqVkqO5u1RqdD81mr0N1U+Df6T5fTDFKFjUYSrUfFSKVWFQvBWEKiFlCpml3keLisQeFhg/eM6QUljRVhLZp6X2PgyFvGLOA7s9JhMXrP6skfLp1y56v8ovo8so4iIBEuOkIYEAL1WsmuB0D0VOom3HNU+DqMaOc9IVGdH19M023Un804FqaFjM40O/69nXuIyzN4vp4OQfeJEywzKU6l1qWB6L1MTOlZZkZz4gwwm0L2W6ezVx49MEvtjjYMm2C4kq7XF0eThn1Hev0jD29z6ul6d5THT7QxU12onxvOIMhUjUDSSatCZ9Jdn+naVbGGXW3HKDeXmG0Hc0PJLRMf3X4PZEQ9ZCK1RuTZCcWQQJTjU56wtFv8CoxDU/2tiN+LZGy2Y+X/lFeW2CuOpYMN6JzrjzL9PHTRXgR9fmu4/lGv/XQV5pNwKLicH9uz72V3g4bKQQ1iuGF2cMISfDVa1TLQ4tmrFU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(376002)(39840400004)(346002)(136003)(451199021)(2616005)(86362001)(36756003)(6512007)(6506007)(6486002)(6666004)(478600001)(54906003)(316002)(66946007)(66556008)(4326008)(6916009)(66476007)(8936002)(8676002)(41300700001)(186003)(2906002)(38100700002)(5660300002)(44832011)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ml4k4tzQDqQvp4UtQAfcYpre78TdOLkHYysV17hJqT6KaOPNka1uZC0/gI95?=
 =?us-ascii?Q?AJ6Ea1HWIHF/W+2tyDjZBtPAIBLntO1R5e5t4a+pNl68brqi8D2EMlyHmVCz?=
 =?us-ascii?Q?g1KtJxnA1zyBI4gvmF3sBk4qexqWthVc4d4UT7MzdkhScUOlIB6tvCPSvy9Z?=
 =?us-ascii?Q?INs/7SNaxnACJUycbwQFd5ezMNKWodtvAnSXIBiHdmOr7e991+H/TG73JJTv?=
 =?us-ascii?Q?73bpZbF4L4mGY6gvYzq4iNtL3cFnjMW9+pRZCvIVwiKLFHhmHl0+w7OBL1Um?=
 =?us-ascii?Q?CmkCd5QChBNpBB83hFSJfQJ/9Nx++e/SUfgB6SyfT3a9a9f8eIzS8AnsV6hp?=
 =?us-ascii?Q?cwvYb+pGyT7azjK/Sk59dN1CkWBuavOknQmgNALzwR1l2imNCMbwhbPgY9H1?=
 =?us-ascii?Q?jL3wEh6Agi2vhiCrXCP15FHbD7ZlZ0KU4XYU6zyJAmtVJjSzFSH5wBYe+RuB?=
 =?us-ascii?Q?3Qf2MaUnXnYBpRLq2MiEYNc5Y9yRLnHUcGBqz5lNK1lK3sN+UA/2B9g4lH4d?=
 =?us-ascii?Q?oxNawJvCty89eTcK6G3IjH0IfzUrj1osN57t+fx8klIqEiEOP8ZeSqLAel39?=
 =?us-ascii?Q?ikKeaKJBbVGQcAw0oULpVJoYGTeb0edumooF/pciTC9sgNh5rHZWKPM6U9Io?=
 =?us-ascii?Q?/GKvSEzJtAVJ/+k+67zvzHD3GJXXQyWfdNeXKOqdTrC/+J1zFlikMp/dNuDz?=
 =?us-ascii?Q?tBlzfBwqYh4fxL+voktYAj+bX0HtVSz4Fr5QGpQpVMXbyyiwJIRmPrmjj7qW?=
 =?us-ascii?Q?9MCbScRc/QwJtGpn6j79rJvrrfosSx90lAKgNTbcEGRzohG20PX3rd6T89az?=
 =?us-ascii?Q?2w//LTnsicS7iSo17LFcoa1H9vEhYD1qZvP95RvjtD5cxAwGm51ICZy+EbB6?=
 =?us-ascii?Q?FsSlPTPaRLzEJ9BykHKgzlVi4KX/HRkt2Y1DYCEW7R3R//QO+iKrdzphFpLX?=
 =?us-ascii?Q?RW67B4AwSP374menpPOpiNVQUep+wF6q6AiIJHRQ6b2zVUuvSD3TLD0SwisF?=
 =?us-ascii?Q?e5ZbPfCUxXPftdtPBjRGe/NTGcl7572JFoISzHHvHPbC2MHXGpJ4yt9CMT0K?=
 =?us-ascii?Q?G546ceUKel/fZjtbbG+GQRaRmcxE7Hqda/XVUFncsZtBIkM/aqQqkYsWvx0d?=
 =?us-ascii?Q?D+gvrcdKheqXBV72GluNBGw8xwy7LNKdh/sMRQ0q9cV+iC3WwtgTX8IiyELc?=
 =?us-ascii?Q?95sxuAFJEvlS6moRJ1iYYvHSDoO1/Y0tWvA1kHtuEpx07u1jakoumzaLh6o6?=
 =?us-ascii?Q?WwvS+2zdwCfOB4Ce2cvCtuhFwb8+buqFhfgz0Bz99huzv1qlInfyE2XXmYl4?=
 =?us-ascii?Q?7k5WMMk+DzP0PKpNnh6qerTxxfLXMM/YEC+CXLDvm7sXCKeq0mLe4FSs3Ahq?=
 =?us-ascii?Q?b8sETp7Xl0vdzJD4m+k46JiWmnc5ZEo0SIFzPpNRRFNxOT5QJcvn1ONUWQUe?=
 =?us-ascii?Q?lPHf4ItyolPqTbhnk2//i+kDJ3omI3XqkW5FW/qflabaNHxB16yJJ3azNzos?=
 =?us-ascii?Q?a9ya1ZJs1c1qfvhYsyNXRlsn18mnFnLH5eY20zwHmZWF71a/cKHEcXbua8Qz?=
 =?us-ascii?Q?ZIGpKj0bkyKwvj0KMKbTisJayqMk1BI9Z5HTXN2oFg5UazM1M7FGOANPkJm/?=
 =?us-ascii?Q?fxd6LggEU1cG+Ya/6YkWy7wx16XqGKcKIPSPaiNdtdppvn/gAC+59O9XXMzk?=
 =?us-ascii?Q?8H/S4Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8d9cca-54f3-4d51-a801-08db468e68d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 19:42:46.4191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5jS2M4+hEbzf0t/LDaEpopxDj93735b+sK8/e/EcL/YGfoyqhsjUCpM3nFv3moz2xkGpGAB3ApcRj7GvzHYIWE06nOjHiE68Ej7DoN44iI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3803
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 07:47:42PM +0800, Delphine CC Chiu wrote:
> From: Delphine CC Chiu <Delphine_CC_Chiu@Wiwynn.com>
> 
> Currently NCSI driver will send several NCSI commands back
> to back without waiting the response of previous NCSI command
> or timeout in some state when NIC have multi channel. This
> operation against the single thread manner defined by NCSI
> SPEC(section 6.3.2.3 in DSP0222_1.1.1).
> 
> 1. Fix the problem of NCSI driver that sending command back
> to back without waiting the response of previos NCSI command

Hi Delphine,

a minor nit from my side: s/previos/previous/

> or timeout to meet the single thread manner.
> 2. According to NCSI SPEC(section 6.2.13.1 in DSP0222_1.1.1),
> we should probe one channel at a time by sending NCSI commands
> (Clear initial state, Get version ID, Get capabilities...), than
> repeat this steps until the max number of channels which we got
> from NCSI command (Get capabilities) has been probed.
> 
> Signed-off-by: Delphine CC Chiu <Delphine_CC_Chiu@Wiwynn.com>
