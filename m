Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F78340BFC0
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 08:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236452AbhIOGpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 02:45:15 -0400
Received: from mail-dm6nam10on2119.outbound.protection.outlook.com ([40.107.93.119]:10328
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229484AbhIOGpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 02:45:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3juNZDfwAmSOJqZmEvBN04Kdb+VznUzLougloaC39Tcf1vxrpPXmOQCzc5W9K3TV++9IM3Zbspp8IRSZGcEbFXEO3HJz/wP34ce9EYBe/MAgpko9+KAdfC1KwaNUBTtxAv/qwrV57o5wIlIyIchMqF3AXcNBUwXUx3f279aKWYuveY4T9aEoQfFeQY37XXv/Zp+0UYU+VKPVMnkrLYKRHA54iAN3EVlsNAFk4Px9AsNTFONLBR/MeYrM/sqz+sgMjsaF1sgDoFDNnEArwyav9qo3WCkZMzuXy0efPhdrs9KSdUdeRHZ/yKHmeu/fRN+nGUUekZF8/dvSKOChNVATw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vsDlXIHO120G+38rcq7fVomsXKDrUCwKgC1eZdeNUeI=;
 b=NP4kJUBYD8I0exp8I6EfZB/Qcg+Ko6VmZVr6yZgfGflSd2Ge92SpAb3XqMXTvU3yy0xVYfZWp7CRZ/u/SZb+o0Cua4dx1cSDZwURxKBD4cpy6rDwI1TtgrnhhwgamqLxBZ36XUTvHIJi4KL/idBe3NvJu1SffUoRvPRnDEPPccefXisC13hK5erjTQeW1n+wF/DvzPAdBL/8+Ten8mJLVtoav/4aW29p0l40fGTBppWESoahjl3keiq9Zw3pWOA2tHDJSsjQNzKb8SnBvtMOJstlyVd+WuBVq+0LnyfKFpFMr1d+rw5fD1rF0NXl5cK50C0romSmDxjQ0tFcC7kRZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsDlXIHO120G+38rcq7fVomsXKDrUCwKgC1eZdeNUeI=;
 b=JjJ7xEKtGfsJreVOvznT6Y2HFTyshidckwBkLb6pnAX84SRv65T6J7F+6glnZGEUq4DRF9qx3SxluE1BaZ1HRvJDT7TJJiZpnaBovGomK3MAu1wFi94XrKRVF3aL/JRCmGwbkVs9UpV07v6r4kSM/CxpJWSJIjcacpBNpHYMkLo=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1759.namprd10.prod.outlook.com
 (2603:10b6:301:8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 06:43:53 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93%7]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 06:43:53 +0000
Date:   Tue, 14 Sep 2021 23:43:45 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 net] net: ethernet: mscc: ocelot: bug fix when writing
 MAC speed
Message-ID: <20210915064345.GA209923@euler>
References: <20210915062103.149287-1-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915062103.149287-1-colin.foster@in-advantage.com>
X-ClientProxiedBy: MWHPR11CA0037.namprd11.prod.outlook.com
 (2603:10b6:300:115::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from euler (67.185.175.147) by MWHPR11CA0037.namprd11.prod.outlook.com (2603:10b6:300:115::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 06:43:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbb1ab30-872b-4ad8-e16c-08d978142eaf
X-MS-TrafficTypeDiagnostic: MWHPR10MB1759:
X-Microsoft-Antispam-PRVS: <MWHPR10MB17591A5D1C1B65D08A4C1739A4DB9@MWHPR10MB1759.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nhlZpNfa8csItbPFJxNdC1Y38cQxp14/BKW82nBpYVc/EQtQd9u/uFy0SJZD5ZY8uU5gx4xFHAd+BlhdxWttIsYKCTCq838tlksfohZhTbafcWhwNHvtwuOHkY5YoOPY9NdTmGZLcDyOsxQHhsgfkaoeYjSE4hsnAeT6R/HjOWjI4fHAYSyEfsGuKqGvhPeo0tmZSGWohUkP/QPNW2MZm2noUKoEWV69cTUEiXKVLpfHTkX9/tXwgS1IQLTmDAVyWCtrBcJUNeO3PVcGAuH8b17xgMtYtSnyNenjWgg/mqyWg3m/PWPweNQbn2LQFHeUFII0k1QUvqfT4CXgAg/P1ZwMOBxlNS41mpeEipjlz7cF0SRok4oOqsb8zkyNVtKfmpinsL/rLQrjuFlBgR52QCiEbAdT1mKW1cunbVfdWJnN4r5ERkCu067sDxOxgqmBNvps//lqwXrQ0pRPl0EmHM0uIThxJVuXLNFZgJqIRVQ1zJZ8k24WXbxEqh3KCwCJWsTPeQa64YGkGeg/vPZ2sZPuL+jseS2W6OIyi7TtKnf3zUkKOZCxEcpW2uyFvZtRw38s/4cE14SJv/tYR8Y6ZApOC+I2VWRv3DzDELd3htPOohgQnlsx0RcO3IaIuyJz6YfMKKQek9TJn8rF5bwCoN/WYNnQWL3d07DEj1CabRLOrVj5sMUEuETMZWMagacWY1aYLORKpKE8P/rkB/c03Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39830400003)(136003)(366004)(376002)(33656002)(2906002)(5660300002)(66476007)(52116002)(9686003)(44832011)(83380400001)(66946007)(110136005)(38350700002)(956004)(33716001)(38100700002)(55016002)(4744005)(26005)(6666004)(8676002)(186003)(66556008)(1076003)(9576002)(8936002)(478600001)(316002)(6496006)(4326008)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UHWQrxmVhyav8DEsn93gU8BE5SP1ImdR8aiwdZ2Vr8Yw1hRftjcUOleJlquC?=
 =?us-ascii?Q?y2adFCalyft8zO66Pwp/iRxpbWbH68wWOYe5MPE9R7ca08tydWpDLVV0gUhT?=
 =?us-ascii?Q?EvaEgmVB5sSKFdjqcrlziCV9mMCb0dt+b0S/mAD7QhspvPl5VA+yFYj14MO4?=
 =?us-ascii?Q?rk74pkAS4qCxwOC/mpHLhjSQhk/BGZ8Q09beB83k30cLMOxP4zpb3ju6YTxG?=
 =?us-ascii?Q?tqWbGwsYTw6qy2RQwDp8hQ67vODoonRMnmGzuKMBw32unALlHYBxzD88BSZb?=
 =?us-ascii?Q?RKAwQa5nIELPvv45yJRt7Vsi5kymsy8rMOHQ0r3rcbVTSmSJlD1r2Gv75FBC?=
 =?us-ascii?Q?b1sKb3ysSEZsKr1sX2bWph+FDBqNadZjR8LJHOwcLVTeJCyLZg1tgp/zGegr?=
 =?us-ascii?Q?o+hqgv9dM6xgk6fFXx4fssGDt0OuMTaVkeRf8KD26JDLfGMvADGAXz7x/4Pp?=
 =?us-ascii?Q?/Gb26q9YHU4Dg/7UjMwhZ69wzgF3RASp1krbivIUwtMYxcmUFU8zbp299udb?=
 =?us-ascii?Q?Uhos0zYl+ibMF4QBE9KIF/d0mDmS5OyVOeUZ745Qsbf+XSpINJ5EDv/Ym3fx?=
 =?us-ascii?Q?OeyDuDcxXZAmiMayMZzzz60FctKdtA4cZF8dZfNPja/Dgr9xcdEJ3ltCiKWb?=
 =?us-ascii?Q?378WWITCBoNfgRjGAboctqcHlxcipGmKBkA9Arapul/acgOwcY0G7H3k/uv0?=
 =?us-ascii?Q?rG9LcIIcLd+IecyFFwFMqtG7kdDmzzlSVFc/S7/zT8YtPNAM/5vNZPlL1x39?=
 =?us-ascii?Q?6zN5alYx+DWu3EPrim3FwPFcUbsjdy1fry8vRS1XcSPkFvRqCvkdX0CqH7Sw?=
 =?us-ascii?Q?xmsldTjlZeKsRPkXsOxiB9+TXKXv3PEDQ61JMmLAclaKic4gS6H6OZjCyvV5?=
 =?us-ascii?Q?TiP8wVO0VNoB6awqEam9uXVNQQPSxpAk9zsfWf7jIpSJ122lbUfgMsVqtAx5?=
 =?us-ascii?Q?SNVnVszW4Ih5TMIX8ZtX8GB6zWKgPprhaUkJHPx0M5MAAQhqZlcZL07S4wPw?=
 =?us-ascii?Q?FYXBQE4WhZASpsE/cykJppfYlOxGBhflnry/LWYoBCFr0i/MxneixM5/uVXn?=
 =?us-ascii?Q?etGcTGc724berBTg+2OcRTBR16leEr/BRCS5MWQbwAWIs6xVpcT/AkXGez7h?=
 =?us-ascii?Q?HHyH+QUr6XY0jSHd1LBP8xAfFCoPcVgu13aivOXEJPgajHQhqy+yU9ynd15W?=
 =?us-ascii?Q?SKVIHjDHYb86pKZ/gVFHRz95MasqaPY0w9pzjpT2dUhJkk3x052nMkpYDM5W?=
 =?us-ascii?Q?AIp4Xj+UR+gqZL3Cqtpyqe/AOYltpC3AG3lmCemuCHlkFjS4x4z81oJZs/6i?=
 =?us-ascii?Q?y/SbbH2wzT3wjDlgBOH4xAu1?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb1ab30-872b-4ad8-e16c-08d978142eaf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 06:43:52.9182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/GkduLJXEg38ImNXGm7hZZKFWVpSRjHEGWTaEupc/6o4IyILTuP5Y8pME6EaLlo13uYlDVBz1Zsp1WvVeyeXeKHdiVJW9oQ2vgIspCfTyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1759
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 11:21:02PM -0700, Colin Foster wrote:
> Converting the ocelot driver to use phylink, commit e6e12df625f2, uses mac_speed
> in ocelot_phylink_mac_link_up instead of the local variable speed. Stale
> references to the old variable were missed, and so were always performing
> invalid second writes to the DEV_CLOCK_CFG and ANA_PFC_CFG registers.

In my negligence I ran check_patch after sending this and didn't add the
title line to my reference commit. I can resubmit if everything else
looks good.
