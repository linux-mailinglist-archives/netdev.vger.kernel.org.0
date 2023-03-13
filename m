Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FE56B80FB
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjCMSoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjCMSof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:44:35 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20725.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::725])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307897F024;
        Mon, 13 Mar 2023 11:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=el/6kz1arwAiRR+jb/wIQRpwqWDPabnbk5uwlS+ZkyBo/6OqtbtFMZmz2PI5LpXw38cOoMrJ6eNLRabKtXkZpLn5btrM8uCLOh5+1g25A+y9P9xFGlt7kor3LX6qbtjkpDB8OpgHcL23eSweLLNe/Yq+jkECk9B33I/PozZ0Hv+xVFbcJ0Vd+LOgj0//tLAA+O3BefVBP0yeOdMLrVjP1LsfJqmZRkNV3AN6JQfc31FZdAo131WWduiRs/NhAQ0zRuG/04K7n9HF9zza7N+yOR0y4VfiVo0Or+//iy61d32+QjDcmA1lWL/lYl1AuFLuoe7615IAtK1DV+hrnboRSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtY5Ncp8w6rTRdFzbDJ8YosVUDDzAgTiu3P6To0P3J4=;
 b=a3mKCgNJzAoYzlxvS/fEhsXEzOdNYXmDfKhBdklo64etD7xpml30TBx8p/DMtkfdY6bZb4ygo61BFnnsd05kowr+LlaLoxx+MqiBcX7Dom0+0LfySfcjX5B4XaszwZrR8gZ3GNUw9U+cW0MPSrfPPeRcJtIG0Wkdt3poIM7VWE7WY2svaslwT/wAQqJTBC6c/zHGtaqvyn9rDmRdtDAeHw28LQBbif4jFNB+WZHUBbYMHSXK3zsEsEa8LJo1Fu+QBPM15GBW0FgciguxsHLka7GujfLr/1OizNs+1lK46XDO8Cj7gbRRZSd2UNiu1BuSDevMxopjhHwqSz/LjapGrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtY5Ncp8w6rTRdFzbDJ8YosVUDDzAgTiu3P6To0P3J4=;
 b=FvQIr263yJnSTiB5ajxt4ihu+r/yXCRePo93/qLhYXVkgegTwfJPGGLk16Rv5+Lc+fiYcdzuaQ9BYgGzST7qZBcMhj/lNEtXafHXqzwXuLE6WFOuXcIYjD8TxVl6UVJcCqo6wRmjgXEDm8nR/lgV/AH70pA3PFBQeS2HWyIrCFc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4999.namprd13.prod.outlook.com (2603:10b6:303:f5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 18:42:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 18:42:54 +0000
Date:   Mon, 13 Mar 2023 19:42:48 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Josef Miegl <josef@miegl.cz>
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: geneve: set IFF_POINTOPOINT with
 IFLA_GENEVE_INNER_PROTO_INHERIT
Message-ID: <ZA9uqAPhmUyYPcdo@corigine.com>
References: <20230312164557.55354-1-josef@miegl.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312164557.55354-1-josef@miegl.cz>
X-ClientProxiedBy: AS4P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4999:EE_
X-MS-Office365-Filtering-Correlation-Id: b17e30b9-4c0f-4c9a-6901-08db23f2c186
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZqtFejp6/sUR+uyBXuXFr7KV7IFKIU4tb+lAkYzgOK5mhfWgcTEcMVSIWF32b9WG47hClQ7rj5AClrgyt128iHXF8Qs8MZnImJSnRTpE3n5uHDkkPVNWx6IEuNqlmQEbbHRF0PXcgrBRoHm6AubjSLU40eyOKJycq6Tu1qkanyi82lEEB54kEiuWAi3AUjtrDZeLrgDjSOZhClVf50dYscf0rWcCZR9f+t+FD8p8GXOZ91NbpbF5mBUxzX/+ZAFo2qsxCZ46HRtKwaYXel9uo88eWMa4rlbDzLTZjVkP7EWFx1UftEBhtRO0PFdSoVoExCnPbXgzFI5iiJpTdQCZLhgbXT/DAty3QR53Vo5Yb0tkECai6d0Cvtcd4kridcGFj4HkpG4jhYB70UAnklOueFIP2akxwF1WK5AfMvR4IlhR9wcDQXXC4EYKQaUUO/eT/WZSiIwnEaCl4lGLABJjabrt3hP4WGddelxofnWCPCjjvmSzXv+7XwLDp/F4GhCH7BpgAtGSxL7F8+US6kPC3nPeFp54EFRjUvl/C+r1AtOBhF+bEXZw1fTxAL8RPl2RE1BOUA1M3IaNl3UKbwiEPnV5rGfI5lLrihfLRy+0xheLFm0BjJtUQ7l3ja4S0pwOdEaKpvesFJtx8MGgn8zXnXLutwEsqP1SueCt3OOiPTDlYGs5Q5lem8rxf5/JXiaC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39840400004)(396003)(346002)(376002)(451199018)(6916009)(4326008)(5660300002)(8936002)(2616005)(186003)(41300700001)(6512007)(6506007)(36756003)(86362001)(4744005)(44832011)(2906002)(83380400001)(66476007)(66556008)(8676002)(6486002)(66946007)(54906003)(316002)(478600001)(38100700002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cLZSiKG4UwQBD81c+k32/QIbVjapwsUORxra33oAzhwzqOomoVhi8l0CLgV1?=
 =?us-ascii?Q?x4R8TV5ovxcuBdvBlPw+rx/EAl8W0vKvrxuieuA2+WFpCeTIoYKSmwwwlgyr?=
 =?us-ascii?Q?EUBrIQNGqvDMAyb0CLBXsab/IOrK9fMyMKUO2Ix+NFtdbgb+D+0OIO8wchpR?=
 =?us-ascii?Q?qAqX6E3YVb+ZdKZNmhn27EkG3Q9e2v/W7SJMx0xVNDDnR1mDw0mqfQRD0X25?=
 =?us-ascii?Q?ltR8jfN6vqOt8FeeqeETr04e6bf/4Z2q8puCZcMqzNPsGZhWQq/n7UokEvr/?=
 =?us-ascii?Q?Gbigzh2ZEk1lLF7CzF1z3JGrDURytHsQAmjRLu1loQuwwnKgIeec2r6ap4N0?=
 =?us-ascii?Q?/yT+TZcCHMpUlz/yZdVu/B709ljC9h2flNdbkKmobVYYyP+b7B/DnPepKeJH?=
 =?us-ascii?Q?yeCzOypGQY0+DSzno39KBzkoaFnI+zFJh2lbhXbPg+RJmE2Y3srbjgXtgewQ?=
 =?us-ascii?Q?CE4y3VjrMWmYaJ72R1n9TgqAR9DsvDqvTCKqDUydBH+Dtev1mzv3KtmbEN+K?=
 =?us-ascii?Q?6696CosG64uapFPQZhiLhilUr1NiJzZVWsx+82TM5ena+WDYz5HA+LcOT+IW?=
 =?us-ascii?Q?QMPE2DU2sAo+70ysIMbBD3t9Z7+fmiYhFY8i2vcxnEG/wR1ny52IjptErYIo?=
 =?us-ascii?Q?xAGsS4x6maJafIdCLhv+h8xVygyf+swI30jwJ1G4JAXQAVrNZhXoDvzCBu2u?=
 =?us-ascii?Q?GjXy9uK9dXTdBiYVIJ+JWc3bjCymVh9j7VQFQYqTZH+Xa3vwpIAs6lGxSVbc?=
 =?us-ascii?Q?sO7n94jWQHXAr9G5GcAQHnc9mV6jqag7cLVGUn2X3johpnw7tc9WuPMT4O8E?=
 =?us-ascii?Q?wRQsv4T8KjRzaxrewWm+zXY69v/qeX7NpuKX60IGUzpStJu7rxgLux5DbCiv?=
 =?us-ascii?Q?+8KtQ6fjRkdql7uJD/YinQJeMLNgDymCdTJB0rjKv3Gd0N15S4EYM4PqJdfh?=
 =?us-ascii?Q?tR9hBvuGAxoyail22dFl4ZRnfZVErxkzforW54/BH4Cdu3cFvPq1Nt1ot8jH?=
 =?us-ascii?Q?8u4q3Z8fqsJWrt99riWvKbm1FxJAxerP7D1IG5haSiBvmGMiqAQom3O0eNwR?=
 =?us-ascii?Q?R9feoWkf2+YgtqOIhJM8FJSK9k1Qn0khDJvEbR2ztCUGi7nejChiMc83PI9w?=
 =?us-ascii?Q?StoqlRxUw5Tl+EtZO8/thB+21ukNlrOHls+8MHmnaOd1Yf+8n6jEz5me8P53?=
 =?us-ascii?Q?z3X52HmiXFiDnCQYQbJEMJPV+vpJNeMEGYkDTPOwJQ8NVgk+8KhucexwKSw4?=
 =?us-ascii?Q?06R+F+jX3bEUSwhgwVt9iw/Qbk9KqOASWQzmpwFN1nt7yUfNbKTWNuuOfL3K?=
 =?us-ascii?Q?WKpnf8tjrpyzkIe69FSpWJjZWMqZeNJaDuW9/EXLSn7sK7IG9uYHIr2Gbw4O?=
 =?us-ascii?Q?r8CXhBANSpsltud1IGva8oKYmjvW5wJm9YcjhuOtNs30W9WxNXuUcYU+NJ/w?=
 =?us-ascii?Q?mvEeEpMGLIgW74p0/ShbasF0SYMqK/nvv+G/o/9ODPArpm4f0/4eXzLFvQjW?=
 =?us-ascii?Q?yBf6sBmNATKy4DKYTU0BG4fh64BeofyilHfnAIMElm1gLOiuCmnk85fRESD0?=
 =?us-ascii?Q?uuSilrnKaFtjBMcegH+u1XG7ykX9WypuT86v8Ij3UCp1a6PCkVNWsMNW9APG?=
 =?us-ascii?Q?cH1KVEKHWvFjfX6hjN9SPzl/bHb3oXI31MHMgKz5FTurP+GycjFJ8gsmc+yf?=
 =?us-ascii?Q?hraTPQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b17e30b9-4c0f-4c9a-6901-08db23f2c186
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 18:42:54.1269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aTi+IWQXml8mz+vBoXqczoK1NRDNfOAI59k5n4ag/1wS4KObbkHoK0F9Aa6Pf2EfuKZ0PpxzZwntVPrDe03Xtu/mQi74bw1zUz2T9Qf5vaM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4999
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 05:45:57PM +0100, Josef Miegl wrote:
> The GENEVE tunnel used with IFLA_GENEVE_INNER_PROTO_INHERIT is
> point-to-point, so set IFF_POINTOPOINT to reflect that.
> 
> Signed-off-by: Josef Miegl <josef@miegl.cz>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/geneve.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index 32684e94eb4f..78f9d588f712 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -1421,7 +1421,7 @@ static int geneve_configure(struct net *net, struct net_device *dev,
>  		dev->type = ARPHRD_NONE;
>  		dev->hard_header_len = 0;
>  		dev->addr_len = 0;
> -		dev->flags = IFF_NOARP;
> +		dev->flags = IFF_POINTOPOINT | IFF_NOARP;
>  	}
>  
>  	err = register_netdevice(dev);
> -- 
> 2.37.1
> 
