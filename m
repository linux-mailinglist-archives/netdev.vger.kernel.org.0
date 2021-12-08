Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE8146DDDF
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 22:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237618AbhLHVyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 16:54:16 -0500
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:40142 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237611AbhLHVyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 16:54:15 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-he1eur02lp2054.outbound.protection.outlook.com [104.47.5.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 649EB4006C;
        Wed,  8 Dec 2021 21:50:41 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rr88/NcwuZcAR/+ZOt8KPRxxIFI9FyULHv1BITR/0zP5dZed44GgjBOaCNslAsM5VLT08DD9LOwu+DFh0eAnIOstDaEY/LkeQSvsF1MzFXFiZTKoLjr0fmqTYRFUzjzp+4VZ0N2Fs4mAdbNhbvxS55WczK+vba8GV6TSpZUB/LZO4jOB90/xih97tIBtzmG/7xS04NLGIVFA64Ppn0JNRRIJMX6A/Brm33xxHFqaq0YcKTcCCVXE9a5C2ZFIDQCcGKiMs8h0uw2WDM+2nAU+ciCn4UaBSSOAxApcdGrG+XnAlzJvtw5uIaaSANRm1QYJ8mFyjRrpbEo+PbRMpjEOMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIZecDWgHJaKZLwQZw5VizY48UiPu57qODTED7JOsuI=;
 b=USjYuGhXIbQtI80gqcXjSnezUz0dWTdsnF7jwfaSC20jNGBv4IiKRggygC8Rd1ncMeftwvKI6Cux6Eyf3soivu7DVND1pYrWPplS4cHrfYcNyVDgZXadpXgcmsLbc2wicSiZarLJ8hxR6jKljZQCmw/1XvaZHAKNjettsNBh0S5kFrtnJAI8ht41b9zCB7tcDOETEtDvoM4UFLQ4qkkAq7wVoxZ27wEF4DHOVPwe22i2aVvIpfMXf5nEMppSEz6EO2fLTAQtOGKmAUIpW0HXG7NOCnw2rBCq/CbggEcmig/UQSnC2O1/BwEn8drqQqBTcMp2RCAnU43WFOnXdnfghg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIZecDWgHJaKZLwQZw5VizY48UiPu57qODTED7JOsuI=;
 b=UI8JrgDN76cNNHtHD1MCuce1VkYSnhBzFiLPnmHCrR6TEG54lDoavxiOVYZTgGfHqV758zGYgBGWzxsR9Dysz/OdeUw+7bF0STegHqUv7nj8k1/STvctaxkOxaIF24TSpq+SWzbwpmZOoEgZPG38fc9Vk8MoLvOiwp35YxObEJ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR0801MB1983.eurprd08.prod.outlook.com (2603:10a6:800:86::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 8 Dec
 2021 21:50:40 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::28b3:9174:b581:3037%6]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 21:50:40 +0000
Date:   Wed, 8 Dec 2021 23:50:34 +0200
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        nikolay@nvidia.com
Subject: Re: [PATCH net-next v5] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211208215033.dston6q4cvpxsjxq@kgollan-pc>
References: <20211205093658.37107-1-lschlesinger@drivenets.com>
 <e5d8a127-fc98-4b3d-7887-a5398951a9a0@gmail.com>
 <20211207073715.386e3f42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207073715.386e3f42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: NeoMutt/20171215
X-ClientProxiedBy: AM6PR0502CA0072.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::49) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
Received: from kgollan-pc (199.203.244.232) by AM6PR0502CA0072.eurprd05.prod.outlook.com (2603:10a6:20b:56::49) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 21:50:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bde93d72-d1b8-4939-27ef-08d9ba94c650
X-MS-TrafficTypeDiagnostic: VI1PR0801MB1983:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0801MB19830B84902713A1989B90E8CC6F9@VI1PR0801MB1983.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 72XB4F8lFQ/Au9O9zRg2i2N8Yy3YqF5Ij0YnKBUrTdmXdnl+W3+xTAmeXqFYpxacGrnpl9y6QU+rFni9GeL6AoKty0W0+eXECXWkQyxSSsiE/3YWWXIaUDoSnrYYRBpsBOJzFGG2e81Y3S+X16vTcAS598JuuH9cShmH5aiEt2+A5s+11keskq3sW0KEQi3Iiwlbwhs1GW6NQYlBTxJZgKAlPUCb5qJgsKPBeoeKXwY+tLLtCM5LmMjCnJweU/mhjCTwUTV2gdJoYiZL2w2i+qwqnee2OsUelQT/+EBT7rn5NmhzW94ndYctOYOeo8bVGV8pL49hNZBojHY0HnCyQGNIUGXj91/lvLytdq9x8LMWGOtNNkV5B4u8sgsXSUSjqh8plFEpKzBC/4S/8sVX5ION7CGA6WuMFH6SBKnLx06iIKzC7QIWkgGvqp6iRnmX4cAC8py6CvAV6b4FDmRfvUSHiVP6lv7ZSr5BrpiM/z/eQPzjWFkMa81RUkw+HXHaLmcfqpq8eU9zWuVPP6RUXTT18rHLcu9qcF9M19F85f/tExSIbz7cuSf9sWWsPe1J3n+Bnn5pPr2azMr+0BfhlrTU7D3b2crUxdbpvah/hNfIKGA6z0B0PJ7cSvSfkcYnOkL8X1hOa5j2YdFoXY02Ob77NXcjF86m4KhXzNi5E3VmxtNfFweJxL/4wRpobvJFv+OZFx3P5WKud5GR1COoNmfNxtZmMPcX2opMfXO1eVQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33716001)(1076003)(8936002)(316002)(66946007)(83380400001)(6916009)(8676002)(4744005)(66556008)(66476007)(956004)(6496006)(2906002)(26005)(508600001)(6666004)(52116002)(9686003)(186003)(5660300002)(55016003)(4326008)(38100700002)(38350700002)(86362001)(16060500005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uTQPuz1OVCnFLPJkJp2BTKJ48Uk956IMgm0z3IFWrFpgYh0k1xYn9vFFQU7F?=
 =?us-ascii?Q?6eqxryY2u3Lzb1wTxaGrPeeGnVXdtINSowT5o/dX8iKa1hxjvsrYF9XQnqFW?=
 =?us-ascii?Q?B9F2L9xBt3kOGak9mJR/HmwIdBGIM1YF9g49X2eL7G4klyrYJ+MMi8hAPt6K?=
 =?us-ascii?Q?z0BWr0U/SDDT+dzhE3Bk7hDnAEiWZwuvDsmjw+BLZgmoeaJTXHcO3BnqovD+?=
 =?us-ascii?Q?PYN6CF1PFZtZCyNuPgic0YG37X4UQEnLcDV/TekAWfOSN19yw6HzX6VHN8S1?=
 =?us-ascii?Q?oJCsia+K/ZATbfBfwJYd2z1mGAkJPyjDfphKP5QRz+dl97Ujwn99upCLNoCJ?=
 =?us-ascii?Q?5nAgdqpuV71dftV3HkePQinoO9FJFE7pcPS8oIT4ft+Fo5Xnqdun/928+Iz6?=
 =?us-ascii?Q?mTukoFfNJH/GpiArSf8piQrXdxFj5WTKfa5p3+IGkz6NFTxZm/bkIwSxmAdm?=
 =?us-ascii?Q?j9DfjKU8Dd4MJqAWUzhpOeDOqnNb3SnmaZVADZLSsTEhIVKJbEQjsB1gxlbi?=
 =?us-ascii?Q?HBo4agFff4SFJ8FEbEzxx/ILdu4zd5ufgCkQ75nq3++XmriKk3msAM208a7N?=
 =?us-ascii?Q?rY+V3f6/b9JJtX+ACGHD+xM7uz9gozeuGDmDz3uIN2DraiGpy9JpNqo/dchh?=
 =?us-ascii?Q?/GIyEzb4BIv340sacOrdFeNrIMCu57pzMljFKviMMi8eg5lExTGZ8KRt8WLd?=
 =?us-ascii?Q?4/Gc9gCKlf8slZZolt3+nGRph9aFo6gCLSd3OAEizj4Lt5kA1uSgUi52U/3+?=
 =?us-ascii?Q?c9gXPCOoNlyCEtliBBsnh13A7wJDvUyA4gnH+ilRV0+8O8cRjr0EY9qYrsse?=
 =?us-ascii?Q?bjLunW8SWQ+3VzJzyeTKyTL7lM+Ki88GTbB8iJKGMUUyb7OcHRmYDYrouzc1?=
 =?us-ascii?Q?17Gpwi7Ar+RtJFXTL4kWx/PcuZEGY5WkzOKrQ/6n6Q1uFsjP2iMZ+WxiOALK?=
 =?us-ascii?Q?j2LXpNNuc1kQMdhSt6pJCb7Bicw1R00tNcuCiAWP/xu1JBwTEWoKWlY34Cx8?=
 =?us-ascii?Q?i8qkT7X+S5tRvnUh+PlvTY1BkqRyq4uPgEHKln6TVVWx5kk96fpEpQOZB7aJ?=
 =?us-ascii?Q?0f8sLBw/8jerSs3awE+lLWmmaei2Ub6+ZPbsOm0N/TieLbUHcwYQWAGU3t5R?=
 =?us-ascii?Q?IIWJ9epkT/LTBhOBDr6VfkbnY8Jy9ukWtTqHgdO1TVyK9wvNCgb4/3zduunX?=
 =?us-ascii?Q?Vk956EREjF8xf2KHRDgPsJcJhZD46Nyjj+36sY8Kk6w9ZU87KFRcapvKnkoD?=
 =?us-ascii?Q?CdbMqdFy06cngOXfrLnEG+6sY7ctzMI0A6g51Jz8T9dra3otIVci8T4rwsAn?=
 =?us-ascii?Q?bwTqhff1WhxgluordaKhOzouAnpKRrFB6wrsyp1FLDD+lglgO3xseSEG6GFB?=
 =?us-ascii?Q?9mBS0Un0bTJiCtkWe7yDDBlZQPZZtJTOMdkmoyVji5kOhPXp/MqgQSCW7EgR?=
 =?us-ascii?Q?CeCMvo01jnWlh0/Cc+4jRfPDvUcJr7GSju5tmPYBqzJ8hX/XVgVkYuiFbBPk?=
 =?us-ascii?Q?UfaVcFo3Ubnmqxiakz42uD5cGbLyvQR3D0cXAE7kOt9J6RdVlQBKvuNIspPN?=
 =?us-ascii?Q?2Ga/2cbzACFTc/IY90G2XpJXYMb80TduNwT0qpFPfTkATM1IXlBa1Jd+j4Zp?=
 =?us-ascii?Q?giOz0WhT3cnoj9d+i9Fc74WEjeZqYrUpmtFpGcaQ5KW9O/3GFjDl3duMG0Tz?=
 =?us-ascii?Q?iaatiBkwei+ikUXirzpg9yerrK0=3D?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde93d72-d1b8-4939-27ef-08d9ba94c650
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 21:50:39.5573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oIYisB7YyxjOyYq1kle38Q6y4rJ5svutAjm0eCs2OXO0qLTq8ksnj6/x19h0IPs/RMo/Gty/YsTqCw2eml88+yAZotSElg25sq9St/FgpgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1983
X-MDID: 1639000242-uXeEXyxhmSlc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 07:37:15AM -0800, Jakub Kicinski wrote:
> CAUTION: External E-Mail - Use caution with links and attachments
>
>
> On Mon, 6 Dec 2021 21:12:33 -0700 David Ahern wrote:
> > The need to walk the list twice (3 really with the sort) to means the
> > array solution is better.
>
> Technically the linear walk will be dwarfed by the sort for non-trivial
> inputs (have I been conducting too many coding interviews?)
>
> Especially with retpolines :(
>
> > I liked the array variant better. Jakub?
>
> I always default to attr-per-member unless there is a strong constraint
> on message size. Trying to extend old school netlink (TC etc) left me
> scarred. But we can do array, no big deal.

Thanks, I'll send a new patch with array API and all previous comments
