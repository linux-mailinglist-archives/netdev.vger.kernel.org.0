Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA516D3913
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 18:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjDBQnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 12:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbjDBQng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 12:43:36 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2093.outbound.protection.outlook.com [40.107.93.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D639DBD0
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 09:43:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMMJPOWqojntiF29+XTmhptZ7PzbI6uscWmzPYMR76+9du+7J0qkIbDv0Ot0QCvLtxgAqULieDx8hAB+V1jPjr8teMkbWgnH54wPby25ezAfw8ieL+aI238tGzMGC91q3NlE9dmxNAFpIujFdFSmq5U5qVz4ego0BRLOsAxZ0a47rYpEAbTvpBxdK3yuUodJwmXUoA7ETy+noFmoazfJCX8mwRLH+ENsmXuqo25VjVdAX7NZjvV/spTR2zNcoPoBsGGnH3fy7RvCGGHaiNv4m4b1Li3bpSWH5uE0TFc0TYFybPXCdgmsptZG30OVsN2ebgu8yZQrXkHNySNc/IJ0Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qq0xutjcZR8wyl+iIbI35vtodCaB3hOL2bbwyJdRqs=;
 b=hoqMgSE9wKwxYXWknyE8X9Xk1tIEO6UZ2AyuwYoJwEVg7WjI6HD+S1bl84zwtvx0CppYpAoLAMF6VhKl664Lhf4VXnDimTVRp1eWm13xZVils8VBJ1/Aa8CC+UONJaA4aYMOXGsWSE8Nv1AzIe0GpHr391L9WzqNq4YLTNFLr0w9squncs6M6lUdVr8XdlRaXEgwTYCIo8/ICixiI1Lsqq/sQTzwGDGuFQNVk9NuD0r8dTFHXU7Rt6EjAzu447zIypVfVuU5Tf9oii23urwzyHBNYVsQSK381aB+15Tb289/ZrisfISNTjU3zzfmD9LPx6eHeGOOvFacoPoJeGIUGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qq0xutjcZR8wyl+iIbI35vtodCaB3hOL2bbwyJdRqs=;
 b=fi7gNC+d1iH5xnez5wTmqctSql1oQEjs55eqwjkvWi3Nb5LAKcvCnIkx5Nb4Rc6amCCy1f0XpaIi7uQXJi1AKR4TtBu+ff+zAJk3ywchZAOC5LW8TLXNGIYGpdKx5vUIEEABKWApRIXNAScocHayX7nqAqtiqABHz8Amocb7QEk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4160.namprd13.prod.outlook.com (2603:10b6:806:93::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Sun, 2 Apr
 2023 16:43:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Sun, 2 Apr 2023
 16:43:32 +0000
Date:   Sun, 2 Apr 2023 18:43:26 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Healy <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 5/7] net: phy: smsc: prepare for making edpd
 wait period configurable
Message-ID: <ZCmwrueMp4Z2k4U5@corigine.com>
References: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
 <63c73df8-c1b9-7011-8490-2ab6de79d821@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63c73df8-c1b9-7011-8490-2ab6de79d821@gmail.com>
X-ClientProxiedBy: AS4P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4160:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f3544e7-13e8-4d83-a3b9-08db3399652b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pa0GcJK79vtwAgmGYEC9B5Quqn0varFHbTuH2u1TU9HqKNYGWedJ1tC1wO/w+D9oosAeDqHfqva+sKf/DKIWs08xpWXxOCWs2GV0e0CoXwpHCJbmexRxCegPYzMcZX53WmjocrsSCi+yHCbDiN4URRjHgK9DkKcl47d5JvhXgYD3aOvbnv1rVP3MNOAitxTkeVpDCCjEqrmVPAjXMtHDBUIEEGF0KMwok483HibDPT3CwyCFgPT0cTEGOrDn+5zVSPiuk/YA9whwk3UYHRJCYNThJzIU4I430qaA2gisX0OhAO2lYU0g9ZSKvkzQImpIgB1hysyvKNHeKp7TNNxEs/NBIjQDdXCm9ExSyyOF0n0M4eP0seArOd/RCfN0VIJHO10oRXpCRy5oUUkRHQkGdSOVdDJC1pK6wJJ6+GiIZiuGd10Wcrp4UfmSiLQ3G0MYjtHA4fclfGz34uNqB/W45J4WSw4fUEm7bWxlyA6iTrhTqfvQF/iCeQTDr0bpaVvh+vKJt3tJfZm0x/0OxaAJAJR9R3RSZap6Ybdv9IGw4/IZyAwKsm1sVQzXHJIFAP84sOGPT3OeCa82J++MHGySHywt7QeHHz6gVymhU0kBMNM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(396003)(376002)(39830400003)(451199021)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007)(478600001)(316002)(54906003)(8936002)(4744005)(44832011)(5660300002)(41300700001)(38100700002)(186003)(2616005)(6486002)(6666004)(6512007)(6506007)(86362001)(36756003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3yqK22ef8q3KN6HUAWpoI2EOrgpJrHzPzj2wifoTjdodeXEIikYxKz/BH60Z?=
 =?us-ascii?Q?D5UR25Sc55Z3FpuJYqsAN9lF4jlhmUK718WmIcMwRenJVK/FNbXCiKi4M8gK?=
 =?us-ascii?Q?0bMkaAmzwypyq+LTs9KIlPiF1V+M6FAdMdZ3SY75T9u9fCdOZUua3FqIzqTN?=
 =?us-ascii?Q?Dk8vyEuaul+XzBfhnynWzoyZE0ugY0ICrWUt9acAE3PTepjTfMJ2i3x12ZPM?=
 =?us-ascii?Q?UAsqAhcIk49J1999LQP8tgJvwgUGLSsVref4SiTOTO10oX4NaLruMtoIq9xp?=
 =?us-ascii?Q?TS136hjXKA8rQZbAbJJBp+2+P+AGvQHzB65lMC7pAYRmuBrl8g1MqvW9pECt?=
 =?us-ascii?Q?b4Kr5x+ZkPZFC4qR94VKt7YPTx7dYHoNqVt6QarP15pFJjGxeoIdBFsQxEtz?=
 =?us-ascii?Q?N6NW5svVLtnzepouk8kczx4tbnwFeZBInpQkZ2if/oULi5qsbWuh3F6HE0mn?=
 =?us-ascii?Q?hyio12HqtC5++MxHD24XqV5HvQiu8kYUQsAMLKYeVX1uqGQOXxY9LgXEloGR?=
 =?us-ascii?Q?NktVzS4gAyMBLinRtHr7Fa8YzyhSYw8esXrXLX8CaYjsyWzAKcwE1Fy7Ng1Q?=
 =?us-ascii?Q?G0gjmeDgq7KA8oGgUxLkaS0H3MF8kKdDXq1mPgEdRTorVvPJV89AdOlUTZk5?=
 =?us-ascii?Q?v4oB1DuIbbA/yCzORAyQuuDDsQGbhKLnGYnbQlZd2xRKdk6xOK6zGUlCcnf3?=
 =?us-ascii?Q?JdiuvumwNqEgUy8Yr/qeLNtwHBM5FzT0GbQBeASMS5ul4PGdNIIAj87ozNQV?=
 =?us-ascii?Q?BwXojTGAAHGylmV8y9OL0Zdb/Wu44tZh0KVB02jkjwEh73VO6tVWkezDQP7l?=
 =?us-ascii?Q?iXXURlqieSITPD9C22aIYhqmrG3QVtWUmjAgOWMv1snxYENaDy0rwN/ca/7c?=
 =?us-ascii?Q?/QdzXEHE4PiAWDDtv3d3h7Mr2hxEloZ6iKH+MJJ7i26f7zu9UadnIWlLf2S2?=
 =?us-ascii?Q?7zAIgqUcK1qdu5jEbgStjh6hlScfjIJCMtkrzcYocvv0RJl4a1T5nU5rDrz5?=
 =?us-ascii?Q?URroS8hf16Fh8rUG/380kCSi+hV7NA59ooZWaUKbFYVnQ8L85UxLSvRywLcK?=
 =?us-ascii?Q?Q9DpePJV70wY98s23fZP4tVZPTONiMoB4PXRVmtKJ1Lyul+ETO20NfZxhKos?=
 =?us-ascii?Q?KqEdvLiJNkHpTQZZ/5IZh3fg6VaffYX3P8ggKH2i7GfGGFZIxqFi3/lgSgno?=
 =?us-ascii?Q?PbaItyL6/1lrz4xVS+QNtTcRabPXV2UpT/cKd1IjtMCKdh42qbM72VeRbC4M?=
 =?us-ascii?Q?DGOm+Wv05XLasZVAY2LueKjFKi9nvxoWeis8VKr9hDaGyjs1idt4lBZ+m7FR?=
 =?us-ascii?Q?fvwigdp2HH4T0rwXMtCZnS4HthWwrC6uywd6vZGP1VYRw2SwazbwVj7p73yM?=
 =?us-ascii?Q?s31kd4oaNAkBwv5R5kEI/2UR+zNr6HThkk8UpDLmUnXoPtCNi8pj8TZlxi5A?=
 =?us-ascii?Q?Vf97lboIuasaMOpe/s/IsvxgnM0L3aj01SmJqF7hqySrsgrxPGGRrP2jLzL4?=
 =?us-ascii?Q?vYGRC/Gcw5YRCX4kEOlz9AjNg7skKlALxexhognHygU7/55n3HSvlNn3qSpT?=
 =?us-ascii?Q?m4U3TFVjUWFFqlj0n4dVFwBEQXKaa+M9Uhvmsnhr9wQ/F2zCxjyee9vXBZow?=
 =?us-ascii?Q?zK0DQIjXIgSlwLqbq+l4zZjSTNIDQl3kqdK2NxXaNUNa3GlI6Wbd+fWNkYHh?=
 =?us-ascii?Q?pnWaxA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f3544e7-13e8-4d83-a3b9-08db3399652b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 16:43:32.5081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZB1V6CyCptiVlogB68nRIre3N7drV58hzlVQoN5NErEX5JY09BGW6ZKEUXDGGkBlFSbDq7CwgjpixHAc2gG1J0zzdV0SAkz7aarWzIBCtaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4160
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 05:14:35PM +0200, Heiner Kallweit wrote:
> Add a member edpd_max_wait_ms to the private data structure in preparation
> of making the wait period configurable by supporting the edpd phy tunable.
> 
> v2:
> - rename constant to EDPD_MAX_WAIT_DFLT_MS
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

