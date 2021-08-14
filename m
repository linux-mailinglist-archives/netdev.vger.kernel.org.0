Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3E93EC3CD
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 18:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhHNQ1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 12:27:01 -0400
Received: from mail-mw2nam10on2129.outbound.protection.outlook.com ([40.107.94.129]:8710
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229818AbhHNQ04 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 12:26:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjml9zzI9lchF7c1wjb80feOc/kcemYfJgifkHge/mlT2+UaG+QTQoF+JJu2ShB/tRxR/u6u8tkAuu/rKF9qk8KCPq+nX2MK9kmh6uc7Wuhmfyme7Zb0XiRxUw8BgEI0uL1Y428J/x2T0Xzdmcxapwyoc9P7Jq63Wn5hQZN8e9IUWkJUVZwVqb2SmPzNANi5RV+G38u+qmVqpLXc3I9E8cD4+xRwL+AZYJ5w2G6XVBtDFE3QPI8OCP9AypKkju1L8tAfhc427u9u4ypnUXIloqRiOdxaYyYJF0ecouLVCl+eHlH2NfwPvusJMzuSmQNpDa2rEieac1K3F6oMhHu+tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FIkCqxjnv57+iVG8jlUETRIxBW8So0QboH2bYMp1yA=;
 b=c0vJANZRzi8+fHiKCbWuDp45JwUibaTZiyx8ilzAXP5aZx7ikvHBBW58DxlaLpetVJEVx1dKy4K6QikV7X31VmUtrW4FvrnCJiMJ1ADaYlqAMi+YTgHqL6RFuunm7t0d1WhyzZRo2LQ1yuwz+wuOCDc4G2iOj1wDxKZI8pfobqzuMm2Ff0WJzAy1LagAxhYeoCm2aHa3+0ThOwZIWMJBM4ijpvHi5UAW/B4DVsWjGPqog0Cx0viwRSiXK9j09En3KpkZF04GxSdzZuLhNtAq8bP6rjNGtt+Yiboc4asuK+dXrlI6apVRtA4zN5sGr0/6JvkJdLgd774Fj37DHgtiag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FIkCqxjnv57+iVG8jlUETRIxBW8So0QboH2bYMp1yA=;
 b=GUlunrmNtFE+ceZ++k4yOGJ+YLhcn+1jiNwWObKgA5O9Mt7q7HkPBtdDimxzP9rNsHP4sMVYRb7EMkseCq1atQtj8xYTDkoSY5e1vCMEIUAeHpBVIhae/Gg5uXT7iqkNbQ/d5MHReggwZHfw5vbhVSgWjeht+fxAN3FOYdtOgv4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1856.namprd10.prod.outlook.com
 (2603:10b6:300:10e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Sat, 14 Aug
 2021 16:26:25 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 16:26:25 +0000
Date:   Sat, 14 Aug 2021 09:26:17 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 01/10] net: dsa: ocelot: remove
 unnecessary pci_bar variables
Message-ID: <20210814162617.GA3244288@euler>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-2-colin.foster@in-advantage.com>
 <20210814110705.yf7cy7ae2u6l5hcn@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814110705.yf7cy7ae2u6l5hcn@skbuf>
X-ClientProxiedBy: MWHPR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:301:1::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MWHPR11CA0010.namprd11.prod.outlook.com (2603:10b6:301:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sat, 14 Aug 2021 16:26:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c572312f-9b55-48d3-dee7-08d95f40425d
X-MS-TrafficTypeDiagnostic: MWHPR10MB1856:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1856CFA8E42E6ABA9B37A3BDA4FB9@MWHPR10MB1856.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uR6dw6vQj2g3YVjA1vah+C9dtqv6RF4MudnWkGr2tSdj1nL7TZwEHUq53r0QDDf+kkv8MjSBG0V8JJXrEM9Z1f1jLIVZ84rM2zc3QiUr3h7f3pYE8VeEW/wXrsL16P5FlEnHiIHcjgrjintb4K5Ac+ott5PjgiIiyhC7gEog92LZoztOfvo9HFuIXifUy+fNAJOtxHYG30uFIavrgFTMpOBfhI1FsiwPlwqHJKIMXq3Te6a0ae1a4kaMvb7C7LZCk42pdlVcXkYUpQTaxQc2S+/eqFGgY4198M/qIJz8P+WycoMi5T026QHznxfyKngVD7QAQa+UD4iBWWfxUXiEmx4f2qUhqPL26O2HA/BP5IgpW+vJb1sfIlKgLXB7QtNpG6GNd7MxPp0Pl7VO0t+rWuNjNeWKzvmxmb0BnTWpceoD+PykqRo9IxGXVGYeXTOHMpKPujOUKSF8B2dRKcPWNJRdG6vP+QsS43+DYbE0qWre7GMExAU7ixKCe6v+nP4LHaN09YG7h1ecO8GEwEU4FG9GNi5bvzq2ea58BbAzgaHkBrsAqET15BLJuF0etH3y1OHbX7/cvKgTpXEhfsGpwBGorDeixL/gkpZg0c9Q0EKd1x7zvgWEo7TdkFXMZrsJpGuCWq563/9JsJrk7lXbXeidTUVwHGZzXBA33ShIX4YcyJskhXQeDjTvcUBfwLbMiDDsn0jDZK6PYxHesUIBUYogGbJs/SkJXfsIQMYJWeJPN5CrHoQ/oFdJ+qmIG+3TY61arGtGXiKT7BQ5Y7hveQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39830400003)(376002)(346002)(136003)(66556008)(8936002)(44832011)(6666004)(66476007)(6916009)(508600001)(1076003)(33656002)(66946007)(83380400001)(55016002)(86362001)(966005)(4326008)(9576002)(316002)(9686003)(186003)(956004)(52116002)(8676002)(5660300002)(38350700002)(7416002)(6496006)(26005)(2906002)(33716001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k7a45KuRjJpXhkWbOqHM547AXHothVitGP/rb1ffurRDU+nMrF+a3QXlOBMg?=
 =?us-ascii?Q?vadmKaAsfnXL6oHaQGuUzIjadn7GYF7DnvaG/vq6QlCqhg/yr6nB3Ciu1BiH?=
 =?us-ascii?Q?iOGmlPZEVhGlsU4LJUkTPnEJ510T37bI0KKAeSgMR9XCXxc0OwvLgr8tv+ho?=
 =?us-ascii?Q?HUDjzv5nTat+SjCr3+YCZoKMO8gUeKTWdNYpS7/5xSh543biF7eztKG0ZHli?=
 =?us-ascii?Q?Cm1qkNg+zyIUzvX4gxo3eBjvD+VSAOpomeTdl1kWWwL5IfdWN1nyLRlzpUkm?=
 =?us-ascii?Q?PTjhuDQd5pw6uwbMGpq/OuIY65fE4NVT7SNf1tT2lYLtKJ3xKIUR6juaPbcA?=
 =?us-ascii?Q?BSMyfrCahvNuHMb43qBNijz31F7zD+HWwk1w36RGKDEL8Qx63wjVZDdsHBdz?=
 =?us-ascii?Q?UKldbDb9saTHTeWYAa8yAvkRvoeVYnwayyD6ECU7IfindUPm0CmBxOeHSH29?=
 =?us-ascii?Q?146eUQRqYs6Qm+/3ZPLSJzzSpcv4ieUr/O51YctwQ3yVO+piUuTJbz6UYLP5?=
 =?us-ascii?Q?pIGTZ7ogzjTMiQJVzlwWrv5b5cWsOrNUJlihgh2jbZsHc2Nhwcq4pamCdXXG?=
 =?us-ascii?Q?QLfKpLzVjxFywDkamjIt6ow7RNYrwEEXxTSFMGWq590hyRYbgKQlPgxJAN/Z?=
 =?us-ascii?Q?/Ga1QiWFpV/VzSh/OKUavjR4Vz+D8aiNEPuTJ2GFmiCLGDQWevaOo77UQ4vC?=
 =?us-ascii?Q?9d4cng/+c6hwYrKPQi5Sa8IJ5p6Cmeo19enJPlMwb7bHbzd4w1u7kriak7RN?=
 =?us-ascii?Q?x8mkDFyY+khZEBPPuPg+YSE+VH2oGZ9XrVepk1lApuTtUT5Qc8zMpLwewIEc?=
 =?us-ascii?Q?r9BM4sLxDJMiZ5z5w+SoHnvvF1Bki796gN+21Muxfh52fNJalOdsxgOGx3GB?=
 =?us-ascii?Q?s4KKWVFZEH6cwcTbrSq7PBgiAw5tsJfRUkY+Wk+nebOIzpaum18h1ybwN8hs?=
 =?us-ascii?Q?LV2CHmsc6lgR4qCVaR26AZfb29z3NqmewmBGEqKG7YMgbkq5PsTHjNyttKqu?=
 =?us-ascii?Q?8qcN4FQdtgyO6wiL3XDhXn8jiJ+xhCbSnQugEnXnELJlPc5k8f2YdZgNNoz7?=
 =?us-ascii?Q?Vp8XN8bTV6fFHI2hXf6ysmMII6pq8lWTd5W/7YPZ/MkDSc3+E5BBuTlURGBn?=
 =?us-ascii?Q?8QIJG42VnbAKzuJeu7RznRynmSWha3T8FopmlKE4+RFL9D/ePzNPqOUOv28i?=
 =?us-ascii?Q?vXKS9LdXnveRbmQOVb4FZIqp6sNx4xzgqFpAsE2dO78AXQwRwo//gwZSklkj?=
 =?us-ascii?Q?znkwI4zrTJ/rkW3wG9UqeQEuZgPt/6ja8KXKIoHYClYr+C6FNux5Rw2eJliT?=
 =?us-ascii?Q?Obx4atmVR2aF9EyHZnRUn2CP?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c572312f-9b55-48d3-dee7-08d95f40425d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 16:26:24.8797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H9k8f9v8hodVbHqEIsZ9Elpaicl2MEZXvu39tt8BFISKG8m60+eMufvlL/VvbOm9BguZmI4QffgY7OUdkiP2bZrryNYYkFCu1np+7PYZ/RQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1856
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 02:07:05PM +0300, Vladimir Oltean wrote:
> On Fri, Aug 13, 2021 at 07:49:54PM -0700, Colin Foster wrote:
> > The pci_bar variables for the switch and imdio don't make sense for the
> > generic felix driver. Moving them to felix_vsc9959 to limit scope and
> > simplify the felix_info struct.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> 
> I distinctly remember giving a Reviewed-by tag for this patch in the
> previous series:
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20210710192602.2186370-2-colin.foster@in-advantage.com/
> 
> It would be nice if you could carry them along from one series to the
> next so we don't have to chase you.
> 
> If you use git b4 when you start working on a new version, the extra
> tags in the comments are downloaded and appended automatically. That is
> if you are not ok with manually copy-pasting them into your commit
> message.

Yes, you did. I'll do that next time. Forgive me, for this entire
process is very much a learning experience for me.
