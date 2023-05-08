Return-Path: <netdev+bounces-964-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42F256FB7C9
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5755F1C20A21
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E801111BA;
	Mon,  8 May 2023 19:54:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3FC1119C
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:54:57 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20719.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::719])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6469D65A5
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 12:54:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BV5raGXK0ArVKBBp3qPK1HX6ikLufS9N+rLIHNeAkcsjJeF6uC4VhnXbJHSEhQN8nJ44MOUMULiJ9ZwISeMIdA5bq+VTuBq6UipAhZ8weWNl3MSIoqtKCz3rI5x5ALWoHsQGhwnJuGz7aU8XAux9qsta3EDU4hODx2aVb29tkqAOfOOamwUtM2ROULnna1baJzpooaItDwizNr15HfS8xCmZip3O7A6HEg1e4d2+0axxaWbn5szEKYyKTXAckIURBhPohABsIYkyu3o2s9l3NtTQe+sF8Ll7Dox3pyc7IeA4w13t5gseyy8056IKicdGv8nXB3HyxNckSahkWzA+dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=73aoLLEUhu9JM6RvIE70p9QEgByIDtE+KnE7V16jGto=;
 b=i4VyAhATF3Ro5Mk0jvkNtvpN8jXodzVFmN80zWu1k9CVsy3lFFuQdh/QsqVTuS8ElK6OdAKdnZnf31muO8V6yWCgpnct7y4F4F+Yp6B8g32vmuAaMiy/66H1jCRg2JcMDhaX/XW5K/gRGLAR5ipsCtrzBdcW4vgGXPhDACtQcCAMYMIFuX9lD/EHiPZiKIuKOLDG2aPNJ8sRiIAwDL+OdpBezXCGUaZQ9OAvScOLWUomPTRoh2rYHWuzWgkXYwu1KWMxBofecYz5Ky65seoZBVFd8pqolpB+O0c2G36pw7hMaDWEBciCB57j5ZuFa3RJRyfJD8rLYEU4bsUDh1ahJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=73aoLLEUhu9JM6RvIE70p9QEgByIDtE+KnE7V16jGto=;
 b=QIRIeoFbfUBb09W5vhU+I046D6iU52yqt9hPrP518umKq0BQKrT6oQuJEdNoHHIGKIBeGIVggQYTj1DRxrpyY3eKDK1oQ9kSxwj9dO7wyaVZpC+WVC1p8/xH9lTvqKyx1OM5Mzs8TZuR1f2+1NqvJLJzkkAg52sYFVyFpAz0pIE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by MW4PR13MB5837.namprd13.prod.outlook.com (2603:10b6:303:1a4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 19:53:39 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 19:53:39 +0000
Date: Mon, 8 May 2023 21:53:32 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Piotr Raczynski <piotr.raczynski@intel.com>
Cc: intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
	michal.swiatkowski@intel.com, shiraz.saleem@intel.com,
	jacob.e.keller@intel.com, sridhar.samudrala@intel.com,
	jesse.brandeburg@intel.com, aleksander.lobakin@intel.com,
	lukasz.czapnik@intel.com,
	Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net-next v4 4/8] ice: refactor VF control VSI interrupt
 handling
Message-ID: <ZFlTPLoA9q0Kgkkk@corigine.com>
References: <20230508124321.2927867-1-piotr.raczynski@intel.com>
 <20230508124321.2927867-5-piotr.raczynski@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508124321.2927867-5-piotr.raczynski@intel.com>
X-ClientProxiedBy: AM4P190CA0019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::29) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|MW4PR13MB5837:EE_
X-MS-Office365-Filtering-Correlation-Id: d498954a-535a-4d34-72e7-08db4ffdeaed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VPQPh9QU1VshtbbW8JrtO09qhiYGlF8j5fZTfhppff0S2c/qLYkkTHoWQ93XnhgqfgeDW7t3pqb6O99uo9J3l4Yw07kCotXtMO1fVnJ7X+I5H6NGkAjq7tD1O2Im8QDPJIOYKrXjGJ5z/M5GNjMfRqfWSi275lpzZGXsrwcbV7izONtlStbPoanjdj4T/pJz6xErr+JvVI/Ehh66n0NygX33ruwNix/Tq4k+9XADgGHbBuPdQRvbi5XzVDuCl0GHq60/FR+5+6MnI3DFAznqjVtRcRdTde7CnRZ8TY/AOH0opmwIRevWjOi/DoK/vQf3pvgJ7667viYNB68sXpL022pBzA6PL8QiuErQZTQZaOS6zkCOomFResY9+uOrtKYFbYjL52jJTe4QJ21KnpFo78KDyHpWmgQySjn3rReXap46sRh1+VdpIxAdmyVk6J2l7BCcX1HxdFZvGAk8jID2c0DXHXXi4AHcNor8wLPvIDbuzycF8h6B51Y0TAnNLicGQIm1FyPmy2K8zTdZ76FmcWdWhpojP1EO1SMyUnKSavZbc+3njKozIJtF1yD6U9hZjVHsj+zjLfJvcsd+VFx7/lq+Q3YIDMMi8tIrL3DXAQQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39840400004)(346002)(376002)(396003)(366004)(451199021)(2906002)(4744005)(478600001)(316002)(41300700001)(8936002)(8676002)(44832011)(6666004)(66476007)(4326008)(6916009)(66556008)(5660300002)(66946007)(7416002)(6486002)(6512007)(6506007)(186003)(2616005)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eZ8tnkwt0hGAALM+ETsLm3BzEq9ys0twKQ1nzXEFalkez7/jOM3uaoMS8pg2?=
 =?us-ascii?Q?hDVSCL5pv1Uy7JCqi/U7ufboGYT+/gPc9TSjNe1uaqhWIOGuAJ5dP63f36fr?=
 =?us-ascii?Q?jiepJKNnavi5uvwd36evIBDJtGpLtvcToGpnlsK4YcObUDSqYxCx8RvrsvyY?=
 =?us-ascii?Q?obzDOJxck8SuDXRdKZiYu1Hs7DenKCOOq5zR2GZHZ9BDuGdv0E168JCokVjx?=
 =?us-ascii?Q?+s7FdrEnnl1oe+q6KVFp4fIwZsn6QZvx60DinzmS7xEloHZNxZXI3qfXzREs?=
 =?us-ascii?Q?P6GrWArl4pEKvDYOh7KEs81Ib9ccgLWEpc71CE9eqMqJtI/43k2e4Hq9IztG?=
 =?us-ascii?Q?c+ICK8pzp8j0xFLV5Rqk9wZDm8xhF/w4DLXwf4tRlmZ+c5zVPsif4VZ8rPyl?=
 =?us-ascii?Q?ckhRfG9vuWU5WwvIFEYzKJ6XJnGgFkm+NERvFdQuybXwSlAzZTscC8eEZQ7e?=
 =?us-ascii?Q?K6qCdeE03iPPDS3HCCiZasEC98YSUbRX7hefspweRn8bXePnILfuCzcSR6Od?=
 =?us-ascii?Q?m+jw5L0Mi1K19G7XFIdbeggYfcttcbyZxdRD5MvgYFIV5WquPk+LYQQoyAVH?=
 =?us-ascii?Q?0M1PGDajf/F1a8AHKfHWXOr/AbTDKlhRdpKK19CYKGVJUw79ymVU/0K1SurB?=
 =?us-ascii?Q?LGRYXELbIFANGW1SNIqIY4YUaF8Soht3hHVlWyHPsXKCOWGxI5DXdrvOx0Nm?=
 =?us-ascii?Q?wxRpvC8hBHq+wLSvLEbJ3UlDhvp6t1yzdQ73f3PBfCw3U1J7V6wvHLQX8xLM?=
 =?us-ascii?Q?ie7bf27sBNrpuRuravClMhZdMRtLNP9QBxC9Rv9gaUw17xdODg+M+YScqPjK?=
 =?us-ascii?Q?oCGVseEIBuslf0j6DFNKkqjO8T7TYul9RwF2gqPIPZkqy6Dh6650rnwU5rWz?=
 =?us-ascii?Q?WQPblVcFN/iwSSz9hRjlRLZggH8TSyYBr7H4+L5w66C+RHYLflqU25GPVMlg?=
 =?us-ascii?Q?1ZT7nxgbsLsC43qpgY/gIiO0beZfDvTQ31L5OOiarrnuFSJgwRUkB8yoX5oP?=
 =?us-ascii?Q?2G+ZD3xdeJk+YwnE++hdrygJDLqkOVvcIoHR+KFO9Ezw2LGfAthjVbKA8bPY?=
 =?us-ascii?Q?sx7ekjIeWA5ENrhAVek5qMNZwgkb510JzNKODgThWU5yA8iiJebPHq+VZKSe?=
 =?us-ascii?Q?M9wQ89w9fJS/+gXi1nJjOleEi6m3eIgQ9iF/O+aMBudvYuKM08HuS+ZBuXWE?=
 =?us-ascii?Q?qRFV5vv+ou2tLrfuQXT6H5sFeK48BilgGsYJLoOzwMscMD91E1d+0fBjYHc0?=
 =?us-ascii?Q?BCY9YXFwsdQrt+Uc3FmvhQa30zss+PLgCD57QJyo1+TVjONRJoR2fhiL31BT?=
 =?us-ascii?Q?7ooaHqDflERXTC+z6/pzGr5e0r53sNuskYAh9QmxrCCpqhrAbPo+OAS0sKjU?=
 =?us-ascii?Q?9x/BmLSMqtGVY/28lU+hcuDq6+EOuzO4+UmEr+vbcQqfSPfXQNWdDB5a4d6o?=
 =?us-ascii?Q?Tf3uRjB5mUSaIpYd0HZeXBI4ldcRJ0uR7ZwtqpHlhKCjvFRQel1s0e0jFA1I?=
 =?us-ascii?Q?dRRX6bZS0kO+3RwnYwKn5JkYUmj42BYKkUxx0okfAtJ1JwH8qHOzbpVQojh0?=
 =?us-ascii?Q?e0ZheKdG2Y9mLxjDuzOVkaSwn7lwYn4YRVrDFL22AiB4ApKW9X94hgUgFOUN?=
 =?us-ascii?Q?6WdsiGlocKYAU31QurGJ6SQevMk4qBvgKzsITIlKh3vKgxeMTmRGP2lxQrn2?=
 =?us-ascii?Q?0ktXzA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d498954a-535a-4d34-72e7-08db4ffdeaed
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 19:53:39.1217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8yu4UkY39380pXaKBfE5NRvwihQP2kb7+BdVIHuB3L5L7UCtb7dRrnLT7K5EHOc6u/T+fkkVE17uvASb5MozBZfZZNx4oZirUfFykVHIDA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5837
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 02:43:17PM +0200, Piotr Raczynski wrote:
> All VF contrl VSIs share the same interrupt vector. Currently, a helper
> function dedicated for that directly sets ice_vsi::base_vector.

nit: s/contrl/control/
> 
> Use helper that returns pointer to first found VF control VSI instead.
> 
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>

