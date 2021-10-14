Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD6AB42D64D
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 11:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhJNJoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 05:44:12 -0400
Received: from mail-dm6nam12on2105.outbound.protection.outlook.com ([40.107.243.105]:26305
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230018AbhJNJoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 05:44:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpLJQq7zifPyBwB47ENzszQxv8jop0zFAsy2FQOpu8CU9vgq3RIqyfCJ5ctnc0uxcpIMhELBSvtlc4eaUKRXUuCy8mg8tFuO0cKt2NXnv0qDnDAL1J9jns6HxHixknSA6+QE37BHfyvFvFS9s7QOHq4OBxeGMVccqxBmrd3RSNcoCfeq6BqBi0r155/qD147AaYKoLf1bjXsA534fhe6os0TSX2g5Hbaf53gXZVcj02CoO4cDokFxMSQ1Vh7Y6U8Yo6kcRAJZLXdaaUN9r8B1dIViat/YO1UhaZ8AZk5+kqTuQHXC3vtDPgXN487rWQoppmIYiM3zHEpnd3QAD4OOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4l9BXnpeeudF8QWQ9WJCxKApjNAVlIDWDIjk4ZcGqxk=;
 b=lwjIKB3MSOy15mRpQX4qWwqt7IDxpx5pnSjveYlEfK1x+blZYZ9LPK8ZiEzfUzLCLxmOwJ22eQU4m6sATf19hC3LFz7FOXKE/z0KGb+jxW5gbABYT0NxyOd7IsbXZRwem3S89VWh5JZY49VZMJdal60B0YI9z/1NCqgtgeGNqLJQayukfTBQpAmvTwbkHlaf/f5t/U82XEAZeF7JU0KV2D9vNluPr4QqZsNFhXsctYws2OekqsH/30YQ51y9yUyM+n5+ma64ThTHrKFWJgx1A6egeGhQbKDt5jPco3BaKYp0Twe1WIpzKrlY5picXc2t8OhFBNdG/OOSZzgcZvw4Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4l9BXnpeeudF8QWQ9WJCxKApjNAVlIDWDIjk4ZcGqxk=;
 b=Ugkgk/vrAU9EIlzrlaxZVZcojSIy24C2okPKf2ZN81k70XH+UFwaFYOET4mpcgcGfXh/3cXMxPHJLFdXw8euA9HKkMxANjFeadXfGEKyAf6t20cWzg0ok1CONbDk2jbQnHUbuTvuAPAHhYpYc3bRLhHEaBUUgUL+GQUtd7C6QW4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5316.namprd13.prod.outlook.com (2603:10b6:510:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.10; Thu, 14 Oct
 2021 09:42:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%7]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 09:42:04 +0000
Date:   Thu, 14 Oct 2021 11:41:58 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        grygorii.strashko@ti.com, vigneshr@ti.com, joe@perches.com
Subject: Re: [PATCH net-next] ethernet: remove random_ether_addr()
Message-ID: <20211014094158.GB20127@corigine.com>
References: <20211013205450.328092-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013205450.328092-1-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM9P250CA0015.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM9P250CA0015.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Thu, 14 Oct 2021 09:42:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db369ea3-d1d8-4170-3b20-08d98ef6e155
X-MS-TrafficTypeDiagnostic: PH0PR13MB5316:
X-Microsoft-Antispam-PRVS: <PH0PR13MB5316E54CB5EF53DF9EF1A392E8B89@PH0PR13MB5316.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k4mEZ6UtUekYXLr5GLaphuLjcvYuzE6d2UO7gGOXnbfmi7pMuPTJe/MLmLQYvGqvqsfd3gcS0YLDh2TBkFSpAso8dJfYalc73OJbjMY7QZX2GcwlQGPDsF8mKPhljDE7fxM0BGxqjO1VMWaoFSeQ4ta4r6kTtfiqzcrv2BlOZ2CuocRpBTukLs0goE+3dGK6u9aMg5wmfsV32Hbe7mDTBq0jucrOeudt/0JrQXgOcuU0hGWsNfOn9gI3/0pdkbY3nEOVe33Wnx/EW0kf8ZXH8RqrgEGdekcsJS4DY023rkxHaGtjPsJaJZObEYjdEkyiX4UTxJFcYjixSv06hVBewfAQubNBSGn78+AoOaSirlPLLxCuBfnsg0xA7otlzz6UJS8a1EOzCb1jHfZGP/J3B/JpIJHNLx+OfeiSiFR1OILJko2SO4OqYIDghIF1gilAfZHtG0l5GAWabEpcOeFwnnX8tdQ94oVSJrmX55o2wrH/eSwAtLkcuSqSaQ9HrLhX9csbp0L34WoQEsjvvVeckV0LCoP6QkDsIfc5+dfOvoWIVKVtr76fDo07cL5/jp2rstcvtXtVh/1nv+PX1ETX+qPrzNncilhRLJVPWTxtRjb7+mzzFsLvNlEss6tBGYLGgAhrhMS4SB2AixbrTmaGAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(39830400003)(396003)(6666004)(1076003)(33656002)(55016002)(36756003)(38100700002)(44832011)(2616005)(8676002)(8936002)(186003)(6916009)(86362001)(2906002)(316002)(5660300002)(4326008)(66946007)(8886007)(66556008)(66476007)(52116002)(7696005)(508600001)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YLdfq7kwQTmXGJfNs+twclGLewphC06Sv7i7lakrXBMq6SMeL7l2rsEtb00b?=
 =?us-ascii?Q?gW2tYytedUkiWmExs+SvMeH2OaJuozgdmGbo4SlmkRc5zK1gojBzanWbkKLv?=
 =?us-ascii?Q?ey0inmETLijThXFpn3sW3/MNnRnkxHW2bOmTSXu0zV6sacfWpRVyfr/j+6GU?=
 =?us-ascii?Q?OIWzPt4WB6BWTzs/Z9bjKUF8407cVpc4OvO7W32OlRpjEHFvL0kEsJM6OQPn?=
 =?us-ascii?Q?7VFE+b+zJTNB54cJC9CTFPXjNIutakqndrW8ac7D53l41KDR1BEa2j4tvZKL?=
 =?us-ascii?Q?iEExbKAct6Cn3JxfIalE8mEVCY2In7AlMnHYDu1QEMXbq3nG4hRAcCk62A2O?=
 =?us-ascii?Q?p8BiXLzLJ0QAHqnliUYbOQHG2t7TNu6yPNAl3oQZGf2uTYzqCamTgEgPbEra?=
 =?us-ascii?Q?zClXQmgvfbWvD93TjvZ8qAQwaAoOrUyM7l40TJuEBcSoEuYBDBPDNTOdOPPc?=
 =?us-ascii?Q?Ur/0rdQEEs76Pb23iIYAAynd20zRJr8Z5a2jcblNr04JI3CE7FQgof1ukyaG?=
 =?us-ascii?Q?Avpk0JT18mHT6qpbM/qV04sgWH1i5vcGJ7sGy7lHc+3J9RteNY4tlSSFqCvH?=
 =?us-ascii?Q?Cp57EYpPguM+zD8Oa55Hr2skLccsUlHumXRdUFsG7tgcDv8uZ4itQfFM1lJk?=
 =?us-ascii?Q?sHO1vGRlhFbKHo/LnSm/KBtLVnI98bG400RjhdSL1h7mNxVjqLtCtq7BEmDG?=
 =?us-ascii?Q?k+rw0dM+F6zzv5Rdn814heBQ1MsghtJAYQ5iOo6cEBBpH9rKIYl1087JC/Ft?=
 =?us-ascii?Q?kr/ziz2YFvvWYQWqN/N1ZEmsEoqQ9LEjBdlMypz/vIQoYX7m7KeQ43h8xTks?=
 =?us-ascii?Q?9K+mSuqOP0FAZBySKl02c8Po8zNQAaS5FE1y/GsocO9/Empxz0F4dysVN4wU?=
 =?us-ascii?Q?woqvByGydtu5QYqMk1bn9Q0jJcjBTNBmyg9yLWxQvK1lEx6UuUywS48hXE/9?=
 =?us-ascii?Q?U+M3ar2ZtEELToP3rSC6kDcRFknUL85U4q5+TjcLUjh5vLM215/3LanhPaMT?=
 =?us-ascii?Q?atUmvwOxKrKvOAzqFCYRqWwavu3mS5qXUbtOfBph7fMgyu6U/gSym1bfcUHV?=
 =?us-ascii?Q?X4fGYVUHJyF6gJNIzOpf2Mjn7ZNJydOscC/nZtpZxFSU2W5ps8iHPAt2WLTr?=
 =?us-ascii?Q?ItOLQ5XPI7CNnD3veA/nN3t41DLjMHS4IwsGMhnF7C5l5uVgOf6GR3p5lBhI?=
 =?us-ascii?Q?NjeEYY7AhF+o4ZWXwWZuTlrVKvrXPHHIk5dn1Y0AebC61Ft7pHxtMynneAAU?=
 =?us-ascii?Q?t0lU4baOb2vOflaen8hyZTaoIDYI57cKxlxDjfsebX5uwQ/+JwWMptVkGGtK?=
 =?us-ascii?Q?WFQYpkCA6Hkduu/rfE93Gg5KiWVxI3JbR3erR+b5DXl9KCtnPzFVjZ91KuSE?=
 =?us-ascii?Q?hI3356KSNCcNHASFC/5Xv+MuRCyG?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db369ea3-d1d8-4170-3b20-08d98ef6e155
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 09:42:04.4149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D6v76YkHqJVc2bt14e0kCG9xwPAb9RguZCYMfxQ5DbwBVmsCA+onASyT/v6UFAYylL6kaJ9IjDfT4zTpt5hfFosLB1iqDNL1T4wmFkEevfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5316
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 13, 2021 at 01:54:50PM -0700, Jakub Kicinski wrote:
> random_ether_addr() was the original name of the helper which
> was kept for backward compatibility (?) after the rename in
> commit 0a4dd594982a ("etherdevice: Rename random_ether_addr
> to eth_random_addr").
> 
> We have a single random_ether_addr() caller left in tree
> while there are 70 callers of eth_random_addr().
> Time to drop this define.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

