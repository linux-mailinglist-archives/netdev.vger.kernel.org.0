Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B41C6ABD94
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 12:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjCFLAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 06:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjCFLAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 06:00:16 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2122.outbound.protection.outlook.com [40.107.101.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D9893F1;
        Mon,  6 Mar 2023 03:00:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ik9hDRumxDwtmE5Eh+BiZZWxKpqkeQmQFAeRfc3xGretPkqf6j1ykSOJKEplrZPyr+YY+O4DjKm4WVvws1u9AEWrppLJfpSaql92xfswWQMD6m2tDjAJcZ+3DuKRbckFc3uxYQf4XYC1Kw32k6vXRJx+QYEUjJvmgPEm5ETrm9Yww5nciaO6WL4E6+Xkox4I51452RVBM67oMW6tlefru5b8Dp3+wx8wnLSHUP3bd3/EYs3kvFlDY7OxVKz23B4EGFEd13+Fk0o7ozQiihVncHgc7FcOhEVvcyMcw6tSxDdddj7rsphJ/qXfbwk+BvEzBIvOEL2/KxA1PsGRvtz9hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NErjUpAdH47H0dk39e6qFfX1x2szQH4h3c0TqOPnkjI=;
 b=Kzy+MLODN49EukrBtVL9c+TtVloySz6QJMOnSaj2xG754MOAjgoCj48PN5hxGckWTQSeHtQ6mAJxujts5wMPHVIhqEmAgC5PHFmS8zWisoAxQchjcS9W9Zktgoc034EHUlmsSHpXYGa/bCYkKdAbTUq7Y7KM6p7z50l4LD8izx1p1EXMf++rhlt5SjC4LkHo7ZntGRHIIwPlHyysM4X+jUUVQm63/lt463mazAdggyQYI7xOVPtG+GRll6+uWvii3aDEL/TyYiloIfHOLGhY1/JYOguXbb/5oSqWZgma+7AZz63l08FxelkZkWLsx8cCC0g1pzV8N5BWyhAlKu0HZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NErjUpAdH47H0dk39e6qFfX1x2szQH4h3c0TqOPnkjI=;
 b=NYLuqgWxXnltKkKic9uScgXMU+lauWMoPSvPwaJ2LFHLX3Res1RxFu9hZXjJppr0wyxQ5mvwj0Q+GhPZKVI4DXtpGFsRTrgXtBD/xkDKe8HXzLCpZbEb6erbjpun38Kkck7rXTtJSs3tQQXqNQC1wT1So4gFh5nab85s5XzfoHY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5598.namprd13.prod.outlook.com (2603:10b6:a03:425::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 11:00:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 11:00:10 +0000
Date:   Mon, 6 Mar 2023 12:00:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     void0red <void0red@gmail.com>
Cc:     lorenzo.bianconi@redhat.com,
        angelogioacchino.delregno@collabora.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, kvalo@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org,
        lorenzo@kernel.org, matthias.bgg@gmail.com, nbd@nbd.name,
        netdev@vger.kernel.org, pabeni@redhat.com, ryder.lee@mediatek.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com
Subject: Re: [PATCH v3] wifi: mt76: handle failure of vzalloc in
 mt7615_coredump_work
Message-ID: <ZAXHsidkn1g7YMeo@corigine.com>
References: <Y/y5Asxw3T3m4jCw@lore-desk>
 <20230227144823.947648-1-void0red@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227144823.947648-1-void0red@gmail.com>
X-ClientProxiedBy: AM0PR02CA0180.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5598:EE_
X-MS-Office365-Filtering-Correlation-Id: 79845b12-52ae-4238-66ca-08db1e31f3e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nrpRHNdw0GwHiP0afrE2iZvDpHLbWGsPXu7DE0pAmNp+cf35rSNPpZ3J1DAQO5PeSyt+UvMPB20FL5rZhFx3EjcnJ9IknEvvAzFkM8D0oj+twqjTivcF/9S2mMYu8fv6O0Sm+heYaOX8I0UjaOsLhiA8npH0nHf71wduI4zWCXeZShRh99ryQCO07o2sr+z2GJAdhF2yAjot5EoKoQc6XkHGvglitmSbZ3Ia3p5inX/YF7SF8DoXcvarZVjSbAwSJmyuUoHyXRYi44AFUXCZS9bngk65MGbARmifArjrY+/tVPiHdxLp+0848gvf8+uz+kozJooxHb3FLJJme5ViMPBw1mg7I6ERZKIb0zbDpmAZeD7XY8JJf+t36YGhW6Xfk8xZFmSmp6JyscbcU/b8BFPLy9Mdanzl0wKMBaYrRrRV+bL/zDlDD77Ffd32XDRsS1XhNaYEvgc8JjV4i7q9wts3Yib4kixkQlafl0DEET6ws2z/hGBjSrv6j9x/JLCKZIRSVEyPXRfkicMc+HA0JA+m2V5wLLYA95ml+AdagQVLd6Gi7To/Bo18o11dLrxbqtmjpwhVTP8IHOrwgzlQAB4za5+TPSSubkjItNHytnjeh/WHu+Adr5qW3q4t0TfI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(396003)(376002)(366004)(346002)(451199018)(36756003)(4326008)(66946007)(66556008)(41300700001)(8676002)(6916009)(8936002)(44832011)(2906002)(4744005)(5660300002)(7416002)(86362001)(38100700002)(66476007)(6666004)(966005)(6486002)(478600001)(316002)(83380400001)(6512007)(6506007)(2616005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gDfKMZqYcAJd9BSKJcLOXrvKWWqF2eSfixVPQ4bW7ou2+dk9lp4zWskxj7BI?=
 =?us-ascii?Q?qUa/XHSkTvEIlnl1sL8s6guk8vYRdTB+9VC62BB9ZfOyfSIbQZPYK7qQQ698?=
 =?us-ascii?Q?AyizLgVpW/IJrT6kZ60ToT9wHNBx59JOgTpWjtBE4K69P1gW88YQ/EG3YADj?=
 =?us-ascii?Q?SWV9SR89O51MpeQAUCFxqJ3QsM0Pz0VtlESbXIImO0eZV6e5d7bjFkZ4J9WX?=
 =?us-ascii?Q?7gVEMSwfHt+UIGre01n4klAQODjJz6bHMR5bh+SoAdWIxYTc9ZM3qnlik2d8?=
 =?us-ascii?Q?ufHn1GyPEK7VdmaZlhHUoQc2ixF1+ZUOB0nQjxLiYz2u3APAmvq1+gcjwrSO?=
 =?us-ascii?Q?/LJn4oy8Vc6oNNWq1sR7WQ5cT+T1X/j8nEZO4vbPtP1bCBZP+fMwfp8huyyu?=
 =?us-ascii?Q?FgtV1Fta7bo3VPXo008wVnqkfQ/YJBbPKzEmKYV0nzeXj0ox1GOeifwjRrJ9?=
 =?us-ascii?Q?zY/D+Us0cEM9Ux9E+w2abCAAFAhqztoVk80yqcQXRJATuXCy1AL5JdUE00aF?=
 =?us-ascii?Q?c188z6ZvW2HpGoMkOJFIfQkSLvZTT8ylf6Cw/ZfO/b4lnIOiTw1nGnHWcJ7b?=
 =?us-ascii?Q?+YVrkHV3hJDVlnYMlTAy0YR87/Tk4FCeo7WOjTtcYGNEWfmNsUXOn7GZDZ21?=
 =?us-ascii?Q?cRCyANZ158nFsA/IEdHHd/PYTY+TMkMA6YgEvMryNgStvO7sJyVWqra1yS2Q?=
 =?us-ascii?Q?x1gaFc41Mn2T4y2qLQw9/TdfDKWs0W+QQqcuSMCWpFFV6D3zdejEoIeIIQSO?=
 =?us-ascii?Q?Uo27mxuMmnYaRsF6uK8tczB8YlgtEsMrYrxyM5mqDUMVK0Pe0y1OgzberZpd?=
 =?us-ascii?Q?8r8raQlUfj5aWP0yJIo2PAc23zTxtO9R/dRIzF9tOJ8n1RCxX6USoXMWMvk2?=
 =?us-ascii?Q?WlZ8koJyGAlwcKc77evH9EC5n78QcglHgr1pn98nj69Afnqzzc/uSIhDSFzv?=
 =?us-ascii?Q?NV/a6KZ6ATt6cRGTV7/G0wA2syaWnz209N3bDEej6xJ2hCbonS1QpbUitK4v?=
 =?us-ascii?Q?1aWFjJ5L5uitegG09nDNVoK9xAsGNd4QmotXGSTFni9ZJLf4tnLuyO4RQctu?=
 =?us-ascii?Q?5WF0iCd4BhMXcFPMKPYszTNuNtKiDX+kc+43xB1xlpgudL9aGLPGjDBaO5Ms?=
 =?us-ascii?Q?0k/xG2xDibEXvqUEf8kvGF+zFn/Fd2i3UtH0ma6kx43Cp7v5W9/QQ1relVJs?=
 =?us-ascii?Q?md9KrmczMh6s6aX6zArZN6+Qo1npTe+fseS5XNw8dQVtX4OvLszK64TZ51St?=
 =?us-ascii?Q?UxYYNuihzsCRX4BXB9lUtN9Vzv/vl5M6spIPHXYneBhQ6Jt/l8ILTo82Qpxq?=
 =?us-ascii?Q?U9DESN4a/23sP2n6GxxSSxsYRTzMqb0fV6JOQtnwgg7AV7W/yJMef79jp3VU?=
 =?us-ascii?Q?V9LVgjFDTeih94cnDNn7qMO98U5CiRmNQ3Y6Hm6HcZFyC+WSuFvEWZQAh0rZ?=
 =?us-ascii?Q?Z+rgG6kaz5uizbFRG4P+FS1mcrfrX1N7C/28w9BcDX3RYkb42GhwgoBD+auz?=
 =?us-ascii?Q?2PeN6j++oXwyhPDewnKfAdgcM637tNa9qJpw3/8G+En/4A2Cu9WL0EqaZE7F?=
 =?us-ascii?Q?/9Ilo4tcUVePNzTlVSIe6N7zrakg172m4n3xzQTcQsObMcqMTu51UYe+tT0i?=
 =?us-ascii?Q?ibZ6KKNSPc8b9tQ3FO9i2GOhcJaVpzjA9MQFDK5voQ9TF5NAPPCiT95XAMDv?=
 =?us-ascii?Q?JSbyrg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79845b12-52ae-4238-66ca-08db1e31f3e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 11:00:09.9281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3PNi2M9inz4YktUv1FIXAY4DU1fTXDdU6EjpiBhOrEq7w9MQtRE0aJBoQBBT9GdPZ4dVRjJxqdPQ60VlPVphsJTsZYf1q5RhIwHWTeO9bc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5598
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 10:48:23PM +0800, void0red wrote:
> From: Kang Chen <void0red@gmail.com>
> 
> vzalloc may fails, dump might be null and will cause
> illegal address access later.
> 
> Link: https://lore.kernel.org/all/Y%2Fy5Asxw3T3m4jCw@lore-desk
> Fixes: d2bf7959d9c0 ("mt76: mt7663: introduce coredump support")
> Signed-off-by: Kang Chen <void0red@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

