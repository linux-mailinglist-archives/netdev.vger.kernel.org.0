Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A45A36D7CD
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 14:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239628AbhD1M4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 08:56:11 -0400
Received: from mail-eopbgr1310095.outbound.protection.outlook.com ([40.107.131.95]:36886
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239600AbhD1M4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 08:56:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rdhs3vlYrxZBp/RvxQDdpqpntxABxs9QeXTye9I38ncQ0Rr9OVla/g9TVNC/m1o29QJ+HzupuKRHULkrMPWKBbSiDRd3L+o6tsIdw4eUiboRR35mDNu+r1/Qefz71STpMi1RIvSD0PdHqsby4K6eUXLfW57JC9ffnq2NVyVLxZpFr4LPSR35TRf02LTTQz8HMSExxbU431+Sh3olT35yZ7h3ZhKTv4ZJpzarEbGblzg9JWfTlxNZePDwTCqnR0wRZTXuqeZ5+FtUzWZRBTgAde7fDg+T6QjOAwrrk4DXOczfzQjps+Z1b71YwMYA3a8MYeRcrb0ihZLa5Y1ikQ+vXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvlAyR7Hx2POk5HKkNuOgYDZRpQntbX8a2caI3M6TM8=;
 b=H1ieaGU3zEc70VhpuDql7SSYmCF2YDsX8Pbl4YU3ZQfDh8Y+a2xLggyH0DYCncVxkzKEnQ7ez+yK+iqLgQJjr+mFrEUkJ9n00xa93n/WUpnPhygidGaNQwyPCRlX3588u/Dvqc+r64mVd/Kq2AAhzhx52e0fqTYWbU/C99QgCDPD2r2wNibuVxT1bc/1vUMkzf8OGdi36pzU0QpvekeLkmvAa3CekV09w5uGzTBNLDg7lKMl9tk2r9txLM2RJGmTZXIoTnM8y7SZR6MufbNlHyy/20oFoTzO9vhhwTshgOxum/cp1idD0hE+3WoBxFpQnbcw+8emff/1gpqLV/e9gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zenithal.me; dmarc=pass action=none header.from=zenithal.me;
 dkim=pass header.d=zenithal.me; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenithal.me;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvlAyR7Hx2POk5HKkNuOgYDZRpQntbX8a2caI3M6TM8=;
 b=N4k6ZiZe7K8woh2gt5PnZOl/wPAcq/OjXP9pUiKA2lFhU9ySH0gLsIC9eBX4VOgq0Es5/h+I4MzZWr6vroqeZRaOitt9mooBYjcaS3jpRy3S/rc2g5XjVUM6+pWf5QNUgtfEwq3qYS5ZGV+PINH/p1LfSb0jrZM+F0qmv5ZODWs=
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=zenithal.me;
Received: from HK0PR03MB3795.apcprd03.prod.outlook.com (2603:1096:203:3c::10)
 by HK0PR03MB4961.apcprd03.prod.outlook.com (2603:1096:203:ae::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.21; Wed, 28 Apr
 2021 12:55:23 +0000
Received: from HK0PR03MB3795.apcprd03.prod.outlook.com
 ([fe80::9174:738b:adcb:fc0e]) by HK0PR03MB3795.apcprd03.prod.outlook.com
 ([fe80::9174:738b:adcb:fc0e%6]) with mapi id 15.20.4087.026; Wed, 28 Apr 2021
 12:55:23 +0000
Date:   Wed, 28 Apr 2021 20:55:08 +0800
From:   Hongren Zheng <i@zenithal.me>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [RFC] add extack errors for iptoken
Message-ID: <YIlbLP5PpaKrE0P2@Sun>
References: <YF80x4bBaXpS4s/W@Sun>
 <20210331204902.78d87b40@hermes.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331204902.78d87b40@hermes.local>
X-Operating-System: Linux Sun 5.10.26-1-lts 
X-Mailer: Mutt 2.0.6 (98f8cb83) (2021-03-06)
X-Originating-IP: [2402:f000:6:6009::11]
X-ClientProxiedBy: SJ0PR03CA0202.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::27) To HK0PR03MB3795.apcprd03.prod.outlook.com
 (2603:1096:203:3c::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2402:f000:6:6009::11) by SJ0PR03CA0202.namprd03.prod.outlook.com (2603:10b6:a03:2ef::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 12:55:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d98b0be-fdaa-479b-f517-08d90a44e09b
X-MS-TrafficTypeDiagnostic: HK0PR03MB4961:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0PR03MB49611B839D13B41DBC7D00C1BC409@HK0PR03MB4961.apcprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kLmNo26ndppjnzs8LKANPcKZFXmBnNrxlbn7XXhROpets86zrk/MCseYTsNufeYEAdnmAfeoDe0X5i6WRXqSkAtgOo6qvgN87jSlPGDqoc0H2TR54zzuVtWNBKUi7MyOmirmW4tJK032Z7QDKeK8GynXtWug5kq8edRPWP7sXX/cpFXzC5xYwX24dNG1bQykfzeypY87+bysWCg3uPLTDcAdod9Mj1RLejPKFnMveLA3m9h1f5HT1GwOxB3PhOdHLNGrDazxdPOT9tf4E1uwgXtjj+31iA+FX598pojflqaPMbzaAqZNh2gqjoSuxEigXIvvOjmoKDimgkaumQbVIsq8OgMELNrcntu66hsPPCQQSmReu22CAehNOrIj8q0ufKGH/QzfU6WrFA8UWgEljLTK/mB5xtskgg6rHoIJMrNLKCs7kVR1kUP56fSgFn1WCwiLSpjAT0CVyh4WLAn11y4Eq5D1m+lBranLfkTLGPoD0QOtSlnBVXNYfEEQHiNXYE6fFWZCoDUAqMqbNoEtdV4xJmL99FSdKnzAAEEdOQO+ItkgpjRoGd3T89GTQ0YdQGyG+R4OIUS838LbI9fJgHKc0HEZ+31F8foacHHBS5j5xLMle+0DjWpbbPUwM9QnI1mO0DnR+gNuQ86Ci5PLxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR03MB3795.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(39830400003)(396003)(376002)(136003)(346002)(786003)(86362001)(8936002)(316002)(558084003)(6496006)(33716001)(2906002)(38100700002)(6486002)(8676002)(54906003)(4326008)(66556008)(478600001)(83380400001)(66476007)(5660300002)(186003)(6666004)(52116002)(66946007)(6916009)(16526019)(9686003)(49092004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QtTgR72OFQGC0M6HcV/cpLRbGPSbE7czvQEa0zu2iEY4ukEa0DymW5CH07Nv?=
 =?us-ascii?Q?+JPyMXNh1co2bHQJ/1XFtFPLDTtfrEa5zBnoPIBCOyFdmXBDaX6EVMW4xTwl?=
 =?us-ascii?Q?z03a/AJYqm/v1JnXcGhIhPWNfU5CWZeyqlD6LKXuMROGRD6KABqSdtmSow7Z?=
 =?us-ascii?Q?m8FpYPjqAtu3LjcAIl+WbR5/Yc3G3CXzjAJ57MJZ7EZfInIFAXIKEBrwozBq?=
 =?us-ascii?Q?xBj3m5pAoeDC0ehffJutXQAxn7OpXHQxUGjdvdgsif05T9DQf6nyAAugGO0j?=
 =?us-ascii?Q?nRedHVZKZ404OjSBZe0hGmPuQKiYh6ymtuWEW0IHDDZVnwORggGss8MKvYch?=
 =?us-ascii?Q?ZkFcXzOyj+w1mbOhN8Q4ZrdQ7Rt1gROhLlIn6w5GXpLH20icwhtUkPtDgv2S?=
 =?us-ascii?Q?AAmWAhE9K/TFSB6z5C35p+SIvYKefD+ngVzfKtU/01axDQu2XHRPCp4J5wUN?=
 =?us-ascii?Q?oE68rZPtx1k17NY5MfiTdA7HxYZ+tDYN9mBMdEV4hJe09QokePH6mljaZybf?=
 =?us-ascii?Q?0ap1syV7eq+wjiMx7WEVjT9mN3fmDw1AoGQsKtz2bqlBJpcHNs6nOGhwGpcL?=
 =?us-ascii?Q?QNq8icuP1uBUwvwmTkaNzFeAhC10CCceAbzB3MTtu4TEwX7YG5RPC5PWGWzv?=
 =?us-ascii?Q?km191sNSEPfzHS/2mdCbjpXyPf/t8WaegHVpJebFpnTFdjFqH7YQjvS0jr63?=
 =?us-ascii?Q?42y+QnjiasyWnM8GMtVFwcPiLQBya2rknjPbrxH3ryAfuzspST64p+roMJbZ?=
 =?us-ascii?Q?EjJnfBiYdLcQ3UX7PRU7qpsyfMjL+sKN293oDfBOKv+ysfTgFJDQoF3vjvFe?=
 =?us-ascii?Q?JDrG+UIfY3gLSac4olhePyP2xOedVXHAGsHRgCYcCEJc4f5AYy0BxCcfZ21s?=
 =?us-ascii?Q?8zYcM2kC/dCIRH3SlejBWmFrzVK2jX1FdDxynOaz/VM3xLJGPXeCSjRzfuNi?=
 =?us-ascii?Q?vm6Jhe5/Nx9K7k9fuzE289LOV6Ls0r0mstBzUWp8iRHY0uuTo0SKOVzOx9VS?=
 =?us-ascii?Q?CUeVk95LJ7rx8TobnilsVvGifSHkvrfHW2L/C47XFgqaevO+pOlW7/3MveXS?=
 =?us-ascii?Q?gNzLqdkm2sgDgpOqRhRGOs7ol7cTWjzjGGtOyEZowHrjNUWW/tOSLhKsC0jH?=
 =?us-ascii?Q?pbI+2PLquZ7y+IOFfQiJS+sTS6kshZWFm3ou57jdB0TjGpMVt2NnD//BnHu8?=
 =?us-ascii?Q?y+PbDdZDiuzJh+SjuCHDT2lt2frkPP4Liws+DhR3zJ0rwffQcu/ywv5eQ5Aa?=
 =?us-ascii?Q?BgUo2F5ftxW54XZ3fAkpKB+CIXOeMe1QuLs6iQip/3WO1/EJKEKerExa9pGe?=
 =?us-ascii?Q?tf+vxs14Hd+uFihlO8s6ZnjJe8ErC64RMARyKjJQ7Y4cBQ=3D=3D?=
X-OriginatorOrg: zenithal.me
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d98b0be-fdaa-479b-f517-08d90a44e09b
X-MS-Exchange-CrossTenant-AuthSource: HK0PR03MB3795.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 12:55:23.3563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 436d481c-43b1-4418-8d7f-84c1e4887cf0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eAb72FOSOY8j+E3J8jibgMgjIvVrbAsVqIIqMCggwToukzJZ5pfre5Yfdk8yp5Rw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR03MB4961
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Perhaps the following (NOT TESTED) kernel patch will show you how such error messages
> could be added.

Since this patch has been tested, and we have waited a long time for
comments and there is no further response, I wonder if it is the time
to submit this patch to the kernel.
