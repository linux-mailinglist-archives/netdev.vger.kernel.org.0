Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41EFA6B51AC
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 21:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjCJUSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 15:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbjCJURv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 15:17:51 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2098.outbound.protection.outlook.com [40.107.94.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD54B12EADB;
        Fri, 10 Mar 2023 12:17:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c2v+oe6KXvX4zG0G1fKD+rlu2rmR3O2MvcmksN/+V9yzaBYWjiXve/r26NVuSuVcuoD4DfP1LUnBZgL+PuP7OLkVkT2oWb369xoS5/KR1eOfpWmgVrVuHrgObv2tcQs/cDVTx1W1fHqn0NyTCLpCly0t3YbgLSpEIWoTRL9YRZeymbUP3ifJzBBu2Vf0Ia3YxOT4oaf5E548ixwRX2gQy1RXi6TVYd42bmtqtyTDRm6qhJelekKCo4uEAEogVXDB4peNXbY4UmtevxB1oWRkhmSJ05h2SJyT7SY8EbqfZDIHFRdXRwlc5FzQuMpIy2uFc0z7nOkxsu+0lA1hOt7EFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51bE3cYjroD6GXM7Ul4z/bSGxWq6XWcv3ZjijxXkm9Y=;
 b=WKxy4VNoUN7ejtO6WjWtt92SdaEiXtcq9S6xjKKd01Z6telipBbUfaPwhK4+WGRth4X2dBZuXFBd3cm8HBOXh2awQ8tdknHdQHgz+tv3+bSKvMrf9o/ysiaBl8y1Y55Tk0HI10XjJIA6PaLpSyni5ToVh/MItHFrRh3jqy3AtKc74qZIYGK6ZXoT2ttdc7XHDf5x/XxtuVazf/4Vl5TF/gYY4Qahw5FJHXVGBYkDuwXol6f9hMlPQRp1e11Ad3MkokAvWifaSajXBMR2RoQbgU8fSdJdluKm8VGFErlec438pU7dkh7LQ65ZGvqQuxgDDr3gMNAV50Ub9IHtpfxLMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51bE3cYjroD6GXM7Ul4z/bSGxWq6XWcv3ZjijxXkm9Y=;
 b=hM4Aryx+xz8Hp4ZSRy5kfvEZelU5PqfoMyfJ7+eraf7Bkld+JIMAlr+AtowOUEF8g8dnUO6pDYLp41bxwkiAuwLcwpE9bmKAP9slOAO1rFbO0aN1KRTjs2XZHHdJ7RC+pMhcyXpx9UHJMHKH9aKDaVvbp0p1nf+Ymm9wtOX/RAo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4863.namprd13.prod.outlook.com (2603:10b6:806:1a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 20:17:14 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.020; Fri, 10 Mar 2023
 20:17:14 +0000
Date:   Fri, 10 Mar 2023 21:17:06 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v5 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <ZAuQQs8K2CJbs0oI@corigine.com>
References: <20230310163855.21757-1-andriy.shevchenko@linux.intel.com>
 <ZAt0gqmOifS65Z91@corigine.com>
 <ZAt6dDGQ7stx36UC@smile.fi.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAt6dDGQ7stx36UC@smile.fi.intel.com>
X-ClientProxiedBy: AM0PR08CA0020.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: c09f2080-28cd-419d-f0ef-08db21a47015
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: StwbsxYbbXJ5FZzuSAToIn5G6dKiBwR5epk5YKTJJb18F3ExEh7EXdycGHXUrcLpHj7zNCkVzdDrSHmaj8mQ4aqrdfVneywC2L/sFJO+HPVav5IVk9LJ48jMpxSXsndE4ie9tpo0HS8mCKShPczyvz/lfc1vxlfnIBHWVADm7lDYlReS4q6Rny4g67ZnDznM/geabuFCYq+1q6gtY4vI21PyGcIA978Gp27Hky3VUIpA2+wJbDWau+gFNElORwKTrNxRSoc9MjqGXSlUzgpqi/QztpmweplT99Ibbi8gYTwfuQniYlwgf01sZhlHNiF1j19MOkpCybKoLMc5fFcFFMEx511CPXe9ZjTAjc15aBvhtndvpv2P5o+F/wCs0AJUqpGw8iVZzqKcS9cCtCESgrKWgeGYbCOMHlSnsIeN/k+MBc9NFOeqEH3FK6iuZmRzNkiYZkZ44Q17TINtM37PjmEa5+gSVEjqoxC9JwAutPzSk/q1gbz1nuuOCk1fXUN4dBFGkhiGCetBcjSUWRzBKvqZO2ZvKRZ6wd5n8BzoZTrMbP2xKbq0fv6lDyhiytIQYZCoXE8X7h1Nx7xeXI2ZU5+NpDORMg1c8ypMBN8bfG9RdKzBVIUbmm1LPnMvyskFUu5w6fuJzjpkuAzSJ9n03XirjGA5ELndpH8M8P49X+WrkHt840WjWck+bJ434KmeL9si88Vt/ffMU/yPVQY0j8DVCgj93jWR7jlR25OlU8eYMzvvrIadSBPVfH5P+auz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(136003)(376002)(346002)(39840400004)(451199018)(2906002)(4744005)(44832011)(5660300002)(7416002)(36756003)(66946007)(66556008)(66476007)(41300700001)(8936002)(4326008)(6916009)(8676002)(38100700002)(316002)(86362001)(54906003)(478600001)(2616005)(186003)(6506007)(6512007)(6666004)(6486002)(26583001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?10Sn1Fp0xGAIUNGaG+x4ssRRbnILlLIfZa+T0TB4mm/qOUBcXKXKhGEEZYqh?=
 =?us-ascii?Q?G2Z7mFMi+hx8zldm+nE+iNVKORImufyXXhRt+Rb69i5DLXdkfSZHYLdCCKZH?=
 =?us-ascii?Q?zf0g6+byfAUi1tnRlIoXyKxs+cUvBnP0lXSPGUqGKe1IV9h2dshlo6V5TAd6?=
 =?us-ascii?Q?X9G6AfSOHNgtMeTq470x67VmfZtJl3KGTN37dTGlzJsvGmkM6EoJftAFONgN?=
 =?us-ascii?Q?2QTxw6bm8kxfxwG39nNJIA2EAQU/OJK1P9z+D8UxzLvIcNCgFxI9OGELTpwW?=
 =?us-ascii?Q?cee/wyq/4Ljh6ngYX7px9bRXLUGmJCVCwwa7+hQwiQe8lQNKQk3HWTKXRgNW?=
 =?us-ascii?Q?6w8VlL+y0rU7dlUnWYVW4IdgeEk+YF/shZS4m4gsFAjHSPPBMRBQNsdLLQ9G?=
 =?us-ascii?Q?UX2We3JWdozLkKb8OS6G5NvHj7+L15DAoFZYv5+APulWZWpU5o/vFKinefBK?=
 =?us-ascii?Q?Z6FKh5uWNcq14Z5XVJPdy48o0O4GWU2SWkeKxCB51OkQsl7u0aWJf/4dMbw+?=
 =?us-ascii?Q?jG+/qLl9I/87StNrpOEgbSbb+sBG7OS5tG1NByXydCcUCBJ7jaz08V/xw3Z/?=
 =?us-ascii?Q?hoZ65d06gVSG8rD2Nwy3YUCCmisa9YuwthzxfT5X5iIIlRqCN/cJjOQCkeCL?=
 =?us-ascii?Q?ANGqpobuDbwdeDoE95nR+o1ZRK4d1gb9yP0+fEAcsc00dzWJCceML9FwyWHU?=
 =?us-ascii?Q?ybTpvG4odWrN+Y0CjJqKQgwScqH69A2ef1VMeAXtc2gVR1s5D9achB6aWIlx?=
 =?us-ascii?Q?Pk3f5zAv7K2OqFUUaehMIsaU9K82MgzXvD9pVdBwYtVNRIegnImUKZghpIph?=
 =?us-ascii?Q?VwBzCMqRH+qZHTN7o6EOb2jweV0BpBSEcpfyCUP9FhiGjdrqrQFSj7hEQgHv?=
 =?us-ascii?Q?rcEMwXa5dFq6emizbA3qB/H83Dya0Xiymy7yiewRAOm3m+T5B+fmyy79dpam?=
 =?us-ascii?Q?dLxIp7sEQ7kVArKu9Jz41AoNa/AND5Ni9eN5qRwbghFqE62YdgrUoWHsXase?=
 =?us-ascii?Q?4LiC2O/lmXL5Gd7xnIQGiHuvZOeyr/ncw3tYXVKp5KcsnwfyewNO+ayno9BU?=
 =?us-ascii?Q?cBOiuK3XALUI2jLN4fYeV6PSnKuCWmDeiSJ167E1/qXyliEdLxAG4sKp8PzU?=
 =?us-ascii?Q?iKd9/VV0FGm5VjIXCtwLhAw7jCAXeODSdWjxL1U29f3nijJcd9MauJymaOjB?=
 =?us-ascii?Q?7X/5Kltfit07r5XWIGZ+04F5/oHdAUu0zCSCufpz8R2FTlvX8uFKc2UXFJHv?=
 =?us-ascii?Q?lU6kWhQY62I69HJ5bGOfZzgvcB3HXa+71TyUWpp8hwPjxq01XRVV5qBkvstg?=
 =?us-ascii?Q?mB3xgawRSgnUkJlluiepIG66p2/RoreMaB6qT2pPh58p87wDwOfmWIvdtoOO?=
 =?us-ascii?Q?ruPfQ88pjZFkpyKQk5QCKErrT89CfBBCE6BNY6Qk7/yQD2B8HqWb60sFT3uA?=
 =?us-ascii?Q?EF1Ybj82KhwpQeQlhFT/EtqnlgZH8ap+pmqE/QNamxYnt4A5QkS5XJI6Kr2L?=
 =?us-ascii?Q?UtYG7wSHER0JRB+xyK+OmgALQfO7H3R5XV1PUpi5ejJNiWr/cw/Z4r6pN++v?=
 =?us-ascii?Q?ikVQP2fXWfk08/EowwT+CAQj1OTsdTL5lXErePwTVqRhG4zziyv6I3U8q5X0?=
 =?us-ascii?Q?Dp/Izy8caLl0MmODBaiwc79I2R6ux4JZNNgcdk5SSJBeSrk0ZXMaFAK9mk4B?=
 =?us-ascii?Q?kpzaiQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09f2080-28cd-419d-f0ef-08db21a47015
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 20:17:14.3471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FL0AdY0W0zkDlzfrmgWfb13VlgEIiivcTQ9vkUXrderFpDLGfa2YIcUGW4vPVEdCksRU6bBdW7M7PeuZnkj2Bxvl6oh1vj4DE69NjvFjmw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4863
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 08:44:04PM +0200, Andy Shevchenko wrote:
> On Fri, Mar 10, 2023 at 07:18:42PM +0100, Simon Horman wrote:
> > On Fri, Mar 10, 2023 at 06:38:55PM +0200, Andy Shevchenko wrote:
> 
> ...
> 
> > > +		hellcreek->led_sync_good.brightness =
> > > +				hellcreek_get_brightness(hellcreek, STATUS_OUT_SYNC_GOOD);
> > 
> > nit: I think < 80 columns wide is still preferred for network code
> 
> I can do it if it's a strict rule here.

I think it is more a preference than a strict rule at this point.
