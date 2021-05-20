Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4E038B7D3
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbhETTuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:50:51 -0400
Received: from mail-bn8nam11on2086.outbound.protection.outlook.com ([40.107.236.86]:18743
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236569AbhETTuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 15:50:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUIbKMhlxjgeiYh6ap0nbtTGbVWvTRfxODFmheSunhJ0izvaL9nqMUsnmD6CwmvC8jYPk/BfywMblfnCrqJ9D93Zse8pPgpNTaZe7HBFE2UdGBtLm0hc6F/Rv+JKgvZD2VydsNrNDK6bPJSW3ADflkaCSe10VNq04LJ9UG9UlHIA+9ZeS3M72tm8vBEo3+sN795TKIBsauk3YNO2CpgCH9ng9bDdEByqDfx6vqUmrDlv4cTPJGh/reyX9BQSNEifQGD9zxBWqyGOEdjDP2vadI8Lp9msLeMTHuRALlTJjr2ZlxsjJpxEV3VRM7x8GXuUqH1QkEj7MttwUvpPKDX6hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MY4lV/PhUCbvLXe2r7GFeC7G3RmlQvEd0Vy4pki/BkA=;
 b=bqCC/I/aMSfSNa8Z5YTyTPhK3QInziGqMIKGWFgj24hZOTvX+5OaziogVAKkHEelEW5OSlLSnqjLv+IxO1XQXDYK2Cq5+vpnM1wdchHjdcJQzkZfBARh+ci9a7V8N+u7LnKUm4jLLGMaQDq7d02yr907e5YymN+eib1AZ7IW6QhxJRC8a63TpT9UomkmOyGAVCy5uqPBW3qK/7zJY1Q1/pLWx/5Ned07fVSP8WG1gGHZoBTajn3fBZsCFrmrap9FNOfBWpsW6gK0H2JzsvFLKvAH2EQvNdnc1ChPBsiboJrA2DB6zcO8MAd+VWZ/Uu/OLiT29VxUf4zRjO4Q8jRmIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MY4lV/PhUCbvLXe2r7GFeC7G3RmlQvEd0Vy4pki/BkA=;
 b=Ci/Pw7sWXsv1rRV16LqINzPgQr6GD+G/NVoX5DykGnAg4wRel6L65MEzG6Uj97Ghw35eT15HZgopOepNNFvYYdyEo6Ly+mIc0NcH4ic6L7HYRsraIYK7XADGDnm7XcyRtPnNrKO8qGIbsCbm9nTyNU3ZPYqALtaCSGBy1fcnJVGKe4ydfBdjpOV5qEgK/o4FdAfwvl/k7WyUw0dE0Mu58M6Q6n8ZbO4IwGL99nlYsvWpuQVX/zK9xBCdhSuz1/7EPuu616fouIjxn3fhUd5e3NCRYaPE6KhI18prw3ZK8P6WlODSODxH/x2lbUqwy6cfciukVj9OZnZ7SjzpzcJcLA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4842.namprd12.prod.outlook.com (2603:10b6:5:1fe::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Thu, 20 May
 2021 19:49:26 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039%4]) with mapi id 15.20.4150.023; Thu, 20 May 2021
 19:49:26 +0000
Date:   Thu, 20 May 2021 16:49:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shiraz Saleem <shiraz.saleem@intel.com>
Cc:     dledford@redhat.com, kuba@kernel.org, davem@davemloft.net,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH v6 06/22] i40e: Register auxiliary devices to provide RDMA
Message-ID: <20210520194924.GA2852888@nvidia.com>
References: <20210520143809.819-1-shiraz.saleem@intel.com>
 <20210520143809.819-7-shiraz.saleem@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520143809.819-7-shiraz.saleem@intel.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH0PR03CA0094.namprd03.prod.outlook.com
 (2603:10b6:610:cd::9) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0094.namprd03.prod.outlook.com (2603:10b6:610:cd::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 19:49:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ljofc-00ByB2-MR; Thu, 20 May 2021 16:49:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7ce8b56-9407-494c-6023-08d91bc85fa8
X-MS-TrafficTypeDiagnostic: DM6PR12MB4842:
X-Microsoft-Antispam-PRVS: <DM6PR12MB484240133EABE808CD435ED4C22A9@DM6PR12MB4842.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6DjXkRBaSAPi3ADuHi5zZuBalcaMh3YoSb/7cGyvAhCzeef3WvQzt9Nno0CXkzijEAsz5u1mG8kxe/WWc1uLqwWi5/Tsmhvn3UeTZsl77OR6Vb9VeRwXXrQepbxdtTb1Dh3BmKiTar17NP60bUesBHRKolzQjTGrAt5LnmH1YYWahejo2wXXFpoGL893TxwiZaC4KPhJXJtpULeBTXNBjBdw2etRKGycNATQ3tj4WRWtNrNFhACZS7d2CD015iC+kyjcaQllwV/5Vg2ImvsaHutSx8oTm85qUNe37Ly+AVrz/9M5c6OYQ2NxWvvVNy4byf3zg6RKXPoXIhsxQnjIXlQBBb8fL41PG8q4PUNQ8dNIbhB0rQr3qPk5KynOssf8R4gX620/+xFKiJqZKYC4CSyR1USKu5CHVSIQbFcjWK52HloKUSRJ4pclBUG0elPwxZSNXaKl1rz6jhv75oWuX6HhNQ2OiMOtRGq+w+3k8TNMqXoHhIVkBdVZVJgHqGXd/+0fLhhQBzDogoIFRW/mcjfETyCKEeEXgEPCHytjq0c3nlD2/6GwOcjjzEWBCOQZnrBOLud3rX4J326loNxm2JGEaAotVqj0rjEoAkQCTv4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(426003)(2616005)(558084003)(26005)(8676002)(6916009)(36756003)(86362001)(8936002)(9786002)(33656002)(2906002)(186003)(9746002)(4326008)(1076003)(66476007)(5660300002)(66556008)(498600001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?OcHCtd17o+EiWWRJNBqQOoS1HzPO8S71z5aNbVaY87xj1FOJ5EcgrgdQ6oFS?=
 =?us-ascii?Q?yBdlHDZIbt6L0zKY+qjqa1kZE0ajt17dsoE2zAYFjTMFQnkm1lOmov6VzlDp?=
 =?us-ascii?Q?je9SKX5lxYqSz5N3aHKtZ1P1pt0+afbG+xL6CQHNHHC92XVAnGVrUftnJLoa?=
 =?us-ascii?Q?JdEY70y5VvMSiCkLjOKh/uUxz4uHXZB2w/cnj4mlaiiB35FkKnWpTRlQXNHc?=
 =?us-ascii?Q?PNt3r+BmdwPIQqDlRMzmt2+zKW67IiT0U0Ii55BAqS3V/ye2Gw2P1bD61y8R?=
 =?us-ascii?Q?XrelvD/gHIzl4+S5VIINKCiurjoSAEv/hR8ObgDZo3hjq9/a9mO+Ij4F4gv8?=
 =?us-ascii?Q?Qhw9XeI2LWmW9+G3hlzhJQLi1cDqAHzWXF+4CBU8Dh6elo8tMo8yp6X0Vk1Q?=
 =?us-ascii?Q?0MAJ1jPsWx+vDdJ8G9M71AdOMwPR3gq2TlH6ncntaOE8Aqad4cUQd78J9GDt?=
 =?us-ascii?Q?P/evcYBXjdMFLqrj6qQ+ZAbOURs9AjUfrt4u1wS8SsXUJuMoiB6bdEWsvzZy?=
 =?us-ascii?Q?ZVnmbkIJPMo8bnag2+An9cPxqKEw4xhdtAfUeepY8XPFMz/9Nu5+YP4CYWH3?=
 =?us-ascii?Q?pLKp4WYObXJ7GCQG1Sj71BEJAucE3QL0aYkkArvgE8ECP8GQUri+pmwz+H1T?=
 =?us-ascii?Q?q5FgHDmVkpd3B/bVnsuZMC/PCNm+PUsDqurxr64xNAVUvNd6IDqrpG0hs1ol?=
 =?us-ascii?Q?ke/Z/DVEs4ch3Ak+FTfckyK8lGvPrggfC+A3domluVJd2m0XVoI17gOhiRvM?=
 =?us-ascii?Q?MAQXFZeu5XIxC2mJt6wJ4FPiVl0Uz0c41Q3bI207F5u9rxLB2QCWaCsRneyF?=
 =?us-ascii?Q?4Br+HY1P26uVA9ZX5JfYz0aqeD4+TxlaSHwIwnIxtb+3MbA1bLSqju0mwVZw?=
 =?us-ascii?Q?ETwBcRuZMNc1QylEyxrihXc4Z1zmReVdSR1EBZVR2+g6CVtkTXVGgbCVJCYd?=
 =?us-ascii?Q?zUXu3ywZ5qyCDozj2XWAPFrBGXeSimkcZ5TShWqp5R/5rYlbFFqkxXZAuzCf?=
 =?us-ascii?Q?uAxETMF8LZ97ubeyXiFTEwseAbcAwMV7clpKbhJyKNdq8CtRwx3BEC8spChz?=
 =?us-ascii?Q?6phGQ3SbxURrgs8WzYodAxR08NSIzTJtV3ZGkX+a4BZlIVFjwLKEoAyIDUq5?=
 =?us-ascii?Q?gyAp4DrLAl4OWmnand/EXaFzviV6umLXAawKd+8GkOzo2erU92ho6ZgFfHaQ?=
 =?us-ascii?Q?vLGl+sKpCw0LWCixR3Qlb/xXJoaQB9AW+h1dLn1DqjR0i5IPgloLVwHc4rk4?=
 =?us-ascii?Q?a+H4dbBXODNptBfN1D0lUQMDhbnHXwtRZzKWoDFURhs13bwP38uPAptuRlsd?=
 =?us-ascii?Q?Tl9CxS540AjZLVhe6PQ00Lbt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ce8b56-9407-494c-6023-08d91bc85fa8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 19:49:26.3754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aaa6hA/w5iCTuOEItYDcisVjNq1OtRxppcWG24mcsnTtozP7seT2D+lsRUsgwavJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4842
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 09:37:53AM -0500, Shiraz Saleem wrote:

> +/* Retain these legacy global registration/unregistration calls till i40iw is
> + * removed from the kernel. The irdma unified driver does not use these
> + * exported symbols.
> + */

Patch 21 should take care of this too

Jason
