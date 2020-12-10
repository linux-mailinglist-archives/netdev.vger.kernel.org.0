Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA992D54E7
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 08:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbgLJHxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 02:53:13 -0500
Received: from mail-eopbgr10116.outbound.protection.outlook.com ([40.107.1.116]:52718
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727567AbgLJHxN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 02:53:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDlbuMIKY7V1/tvpgDBzov0KqiqY9+we7qbrKGXVT6UfOzH6ho+bVoIqnB0XVAhgRI9rLkWBqFTDV4+XsmFz8oRxsqGbcUNao77UJ4AdfcnSLHS8blMjots+zzjU4F0/S4PmF8R8PA1Yxw6Ax06HnBBXDcMmY8YPS4qVSr9ciTdiHEDZbVhNLOmgA3Eim+cipzNWoLf3iEd2H9dSWUEROkpv3yq5cHEhuBHb/1uxMvuvXppnBNbA4V9uWhEhRjXmvdViUe+nJ+QIR/a0kOelGO6JaPY7qa+yTp+teUg13IbPMjdKH4MPLOYf7JIrgqXQPKIMoPbi78CGHxuxA4kLFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRvR2u6LzjRu37SUjpWrSK039HPQ11IbCLrjpxZ7p4o=;
 b=EJwJCHEU1zwh1Fh7SeMkTM95ZUnVrUSjYTC9WYNon9HOKCK9zA2EXQz7LvaRh7pxAASPIwYku3yhgj4K8jeEbuPdog3+5Dlsor/GdUiYmzQ3Our4hh/ClzescuDKJdzNrg5NFPmdCuWiAPp6MNFGADET+ZQr9u6NYcl+rhoBN/m6R+0X5qdEKdf8n2wu//HR9iE7C0qjA2S2uidzCrWCO1v8/IzW1f7a8iOzsE/NcjkOreg1+VbGGLDtJq5Llx0WvuxNUo8X6nbaObbHE1KCqH5DR+dSGpQPrymsf97Qi86LOyAe/+KIR3JJHDCo9MonJEemtCUMtRY0AuCcX9T8Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRvR2u6LzjRu37SUjpWrSK039HPQ11IbCLrjpxZ7p4o=;
 b=VHRa1WyRNZiMQ2E6etlHT1F/L5OSj1lv7ZEqDourQcbDogm/HPVRudjejyKuyQNlcc+Pb8c6ASJIvfWzh/NAHkQ4iFkVpC3MdIRt6Q4NI8bvwIoRRAxB6sWNnww46t6dSCGvs310l9ejr8y+9lTYfU/DnKGxxqV2rlE64zW4cI8=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1252.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:90::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Thu, 10 Dec
 2020 07:52:24 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.026; Thu, 10 Dec 2020
 07:52:24 +0000
Subject: Re: [PATCH 00/20] ethernet: ucc_geth: assorted fixes and
 simplifications
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Qiang Zhao <qiang.zhao@nxp.com>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
 <20201205125351.41e89579@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <7e78df84-0035-6935-acb0-adbd0c648128@prevas.dk>
 <20201205132716.4c68e35d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <0b4fa89e-8dbd-faed-ec26-8ee2e6e1268a@prevas.dk>
Date:   Thu, 10 Dec 2020 08:52:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201205132716.4c68e35d@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR01CA0070.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::47) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6PR01CA0070.eurprd01.prod.exchangelabs.com (2603:10a6:20b:e0::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 07:52:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 623d60c6-ed23-4d7d-d453-08d89ce08838
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1252:
X-Microsoft-Antispam-PRVS: <AM4PR1001MB1252019A19347DB48F60865F93CB0@AM4PR1001MB1252.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6JMPbtNi+k4ndik4jAHCTxaythIU81YKsPpcgZlKqGNsHjUvN82Le30qFap7OdDqdty8zlUpb7lJM/TH22nHonh+e991aCRHj5OuhyXNTBkWIfgi7TWvAhIeT4waFvF1z3dNgUvTTqpmPhZRwWGzccGb3fKp7x+nnuedZJiqe1KdSzAdYiGiZQRnDp3JyxuUjvH8lWtBI/m2GSysSKvTRscIM9tKs50CXhKm7Cq3GSsUTzr/H9K42rQSsl1QCbGSDde2fJugXixY3AyryqTDK2F5TVKKfH2hmjnGWbIG+/wY1I5Vi/qrozHcM5SXjFCk/+xabn1goqC6lI285PQrg0Y9/s/QpKGxM64WG0Tz/DIdg8PzfuTZh9A+y/UhunRe/PB6d9q8lXlGi/YVFCTuTSEl9RyzQgtZXee6ducxe7vXbUeA+yc7YtGj3onHRDpE8+Q10W+z/NG0voueprx3uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39850400004)(136003)(346002)(366004)(376002)(52116002)(66946007)(8976002)(8936002)(16576012)(36756003)(478600001)(66476007)(186003)(966005)(316002)(44832011)(16526019)(66556008)(6916009)(8676002)(54906003)(4326008)(31696002)(31686004)(5660300002)(86362001)(4744005)(2906002)(956004)(2616005)(26005)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?AjI+iP+d5haED/CLEvu8ayxn+N9NRgkvAf9EtKOWsfN5P/OcFzZuxGR5?=
 =?Windows-1252?Q?Z8A/L7RL3oXAFYlyIp8wX+Ykkxs85Rum+89B1f9i6A7AHDz0+IzvcIWk?=
 =?Windows-1252?Q?geK4LM9gdsywaC/6gHltMFcIX/htauE1tyOT3SCb2RXIdqjfH/tCB3PH?=
 =?Windows-1252?Q?0sJ+yQZCQvie15LmDDr8KJfchAN6q1NN/Qu3/7UhX0kiHlhtycJFuhem?=
 =?Windows-1252?Q?CMdoXxvueMwbQ+QfGxS8ns0Uy711JQe7HI/4CU2qjYVf82hnoDOGIyKp?=
 =?Windows-1252?Q?mNaDwHVLUyzA4LbymYWOz30tJ8XhY8he7ITYB/73lAikWbEdHIZW7MFU?=
 =?Windows-1252?Q?l6XZ9vbThCmhnCBfVq+Lhkgr3ewRkR1DdeUAFpTyT0ZXGVW7sAhc8sak?=
 =?Windows-1252?Q?NamQ2DwtMlRru8/0hicfdiZBh+VIaG+ThqkJM04QkJFUTgknF7inzt0n?=
 =?Windows-1252?Q?x8m7qZCBYjdZxBAfYzP8yIX3y4uBv2TjqthJDzQhYAWYGxqLKwLzb/0c?=
 =?Windows-1252?Q?fuCjV91IDH1k8FwprdgRTqI20YLq4eEzfQbyI5NhC0KICoAdBCMtUQ9N?=
 =?Windows-1252?Q?tE9gLkS/8bT0nu8xieJ2xL13YbOK74BnhUQtlx1Qp3QXJ/t4cw/wZUGB?=
 =?Windows-1252?Q?zsbKmgZQnMY5fJ7oiglet7nxJINwmxNua4SzIEqDdREd6s4a8vPQ07xS?=
 =?Windows-1252?Q?WlNjv1qBur0NF0A/2vUww0evZ6CG/qAL7fJ71HQhwEqZ6PudZCR9rqsI?=
 =?Windows-1252?Q?Uk4+n2/VvOSgQ7JwXuPC21yPFLtp0LWlWqlSwIS0rGfPp+vol9RtmjNW?=
 =?Windows-1252?Q?JKrhodrODlxxKLbTa12xudSHmOXQK/Z5O6GXNo8A13jFPKzFpv5wc9Yp?=
 =?Windows-1252?Q?DgssxpEGxzlohC5pVrtbxGvxcJlNgDlnq2Qz8/sczeWdVdph8Qc8uWXz?=
 =?Windows-1252?Q?Gzpsp1rV4YC/AVjunlfEAYCF3C823CENT/3ERHgp1JXRzjkT2Zqa8Qhf?=
 =?Windows-1252?Q?VVX7/TYMQzAvwmPX245UlS7mPc7f1/pzsgxq+oEwoQIy5UBUE692kNAV?=
 =?Windows-1252?Q?GHnp2hw+H0Q1zBO1?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 07:52:24.3918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: 623d60c6-ed23-4d7d-d453-08d89ce08838
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +il4/XE3zMe3YUYrA/rXP6SWe9pjRxuz2oY3wou9fxO54RBV7t5HO6gR0LGeDtbdhCFtDXa4aHs5TuYQKlHm5iyKs57YbKkxC2UFP0Wr/pU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2020 22.27, Jakub Kicinski wrote:
> On Sat, 5 Dec 2020 22:11:39 +0100 Rasmus Villemoes wrote:
>>> Looks like a nice clean up on a quick look.
>>>
>>> Please separate patches 1 and 11 (which are the two bug fixes I see)  
>>
>> I think patch 2 is a bug fix as well, but I'd like someone from NXP to
>> comment.
> 
> Sure, makes sense.
> 
>>> rebase (retest) and post them against the net tree:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/  
>>
>> So I thought this would go through Li Yang's tree.

Li, any preference? Will you take this series, or are you ok with the
three soc/fsl/qe patches going through the net tree along with the rest?

Rasmus
