Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C506EFC30
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 23:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239021AbjDZVIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 17:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234643AbjDZVH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 17:07:59 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2077.outbound.protection.outlook.com [40.107.13.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3147E9
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 14:07:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtbsOsXyDdI8GZ7M8McHEJj+vhJLPQ97MurNsUZVHEZzSLzGZX+uj/jB6YulomSCL+lt7y1fck+iNrS/UzdsPDYzKC0jLHnyFbshb2mDWmPXObUVjIAp6GR9pjDXXKpfILvDNt64YK+QV5jTTVr2zlcscyYdzz8+0nkO+ID0ZzqBshMe7kTg5xAMrmXYPfeFYs1xiaJVYfhqbswHXPUJi68mCIFkDcrane1Nej2zOcu2z+8ChdbEASogm5urESr/YUCWCySVy42Ih6ES5bf+t6Ng5a+x0LCF5qE9EA8VId7PwBy3PBOSjNERGpIUh2GfwZsOq5WXhMOWlCEFC1ZESQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XLK6e5n8J85IPQPm4PZShMU6nN4fPB2A0rcJC5Us850=;
 b=N21jyxiKmufuMAmtnacqOPrG2PiiE4lk/RveM8JJgTxi3d1ntLIpU9BouZQv3kcJ7jXRr0ZeNph8PwXG2PliFdGiULqJNDEOfxvOkvEOeOUGgFQxnZN7BV1N/JUwZOIByk1a7mxc5E7W32S2bF4v7gwqvrbYS1501npEOaudhEkf6eck594ydJUeCTjhV6xPBi4tMQe/AQnFWOTU12AsWJpRUKbYfahaCe7ikBAwcsKCw8tnoMv0dLrgoQaPqNodosLd9wWLLTPFstpf3TIsUBgx0KuuXd61UU008zjDPYx6k4ofIpAlqqAdDukfduk3GYK8Q6JHy04kOVr92HECTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLK6e5n8J85IPQPm4PZShMU6nN4fPB2A0rcJC5Us850=;
 b=DTuqhj/P/DbGsbVjHd3C07El8d3efpK+DLuPJA8iX4BdagHvdDd7Ozq4sIUfaM7VuxWB2Ennvlp1oJDxnGt7rNWnkCL63dcUzkzi48XpN/FZ4pGIEo8+xBiX5t6OjEcmoedwningJyWot9DZ6udwcMYR23goV9xn1eMAKHbnDfk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB6880.eurprd04.prod.outlook.com (2603:10a6:803:130::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 21:07:54 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 21:07:54 +0000
Date:   Thu, 27 Apr 2023 00:07:50 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 0/2] DSA trace events
Message-ID: <20230426210750.tonhsstc4xhrzd3c@skbuf>
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
 <d1e4a839-6365-44ef-b9ca-157a4c2d2180@lunn.ch>
 <20230412095534.dh2iitmi3j5i74sv@skbuf>
 <20230421213850.5ca0b347e99831e534b79fe7@kernel.org>
 <20230421124708.tznoutsymiirqja2@skbuf>
 <20230424182554.642bc0fc@rorschach.local.home>
 <20230426191336.kucul56wa4p7topa@skbuf>
 <20230426152345.327a429d@gandalf.local.home>
 <20230426194301.mtw2d5ooi3ywtxad@skbuf>
 <20230426154713.6706865f@gandalf.local.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426154713.6706865f@gandalf.local.home>
X-ClientProxiedBy: VI1PR0902CA0052.eurprd09.prod.outlook.com
 (2603:10a6:802:1::41) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB6880:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b654a83-ecc8-45a6-a646-08db469a4d0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yQA0+r5rA6hla9NmcpZuCqnH2RqQvctqU8gWosf2Zx43cap41kUailACdKbVoW8aCh2MQrztbE4MqIhk5g/Rkto8dTXFq/5ZD2OxoEEJ+jOKFnqhutweeC7HDJmRB0jxq1bQDaeZYsynpf1eHwLz4kdiXcKf/4Y0K2v3qN2JWNIoxeaf0V08UcUR3n5gU7v1k8wREX+d/vMMMnLlVhzw1kluSK0TvguEssDr7To16gUMBHemKej/Q4Szn0rEjiJkEe//sbucR9b/Dg7OaI3o3C/IYq34PQjSA8HLxwN40i+xz14WQs6N59eth08WCMxpRGUwMwNGUSZrasS5pIJPyDMyTIwkhoqZgtICjEfMucUdSmzOqMdshJJGk4rMpLBHcf3emhoDv4iJ9mK6SXqADD0KRPE0zxLFFEpn5McWta0jGmKYx3lEpAfO5zdR0S5JOUh4dwMpTZAr2kPwslFXQxqoGOhFOJHWgem+ondije4deg8biY26WTafFpq9SkLkVQ3I1fVyYRf4951W8jAUE/8+I7zKn0TnwLxFdWy1R9rNZCkuw8HZt2mGF3zioryg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(136003)(366004)(376002)(39860400002)(396003)(451199021)(33716001)(8936002)(38100700002)(8676002)(66946007)(66556008)(66476007)(86362001)(44832011)(6916009)(4326008)(316002)(5660300002)(6486002)(6666004)(41300700001)(2906002)(478600001)(186003)(4744005)(54906003)(1076003)(26005)(6506007)(9686003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?92279kwTe0MobVwblx5hSq4z62bTWfGR96MYhjhG54okm3RMcTTdrSvjeuD4?=
 =?us-ascii?Q?+nr4Qv2pUA3gFAeOofLFUTsAAdxEPyETG1/0YpAxVTHBWB1if020QpHUsaYs?=
 =?us-ascii?Q?605WoQuSzLsxMMJSlMf/Dt5EY4/0uOcPGf7f+Bp/NLco5v3sdTTWQypxjFLT?=
 =?us-ascii?Q?vnwccUzqARNMVf4PthB0E1u3b3IKc8hKRWp5YFL0vclP1d6PmPh6phzeAuPJ?=
 =?us-ascii?Q?5PIfqTR2AS7qitUiUP1SiTEihMY/ZifhdjogEZbmuCdVlI+jOVpguYDpxKa4?=
 =?us-ascii?Q?4VwLeJPdIZqXCsM0FoDgHi6Vr+JfQHdI4r0StgMiQDcubPpW0tmTmBq1mZhl?=
 =?us-ascii?Q?SjCWt8eARRJzii+fh5L+oGbJ2TlqtWUSadZk+yXgJSa0Tq576g8n64ollLGh?=
 =?us-ascii?Q?RdgxVCV/GxRia7+YmWCyei0Fif38oYC2WJ8Z7/NPnnOOS67oVwtos7aFFnSZ?=
 =?us-ascii?Q?4anKS+yiV3N209JWmgjpWMzL6wnYb4HjltyPM5fhbg48Uj9pH88nCgbHj+Nj?=
 =?us-ascii?Q?FupWGawNhjTRLmbokcj3mk0LOuYkMjMyQ6wQ+fFez9ak5PBfr2gv7ZBU347t?=
 =?us-ascii?Q?DE3bhIqHllpjz7L/UtDttBh5reQ2t2j2NnbbTjb0cbm6ZVN0ZUu3SwUjLGQn?=
 =?us-ascii?Q?mDeOCRXof/F4/6sJ1KWuE5b4gCcm52xLQEbmGvn99V3oWPovXrVk4+Vr/yCF?=
 =?us-ascii?Q?lKriyv0zpzwTrpxvPDVuQVYogq3o3ic9Xj1pyEjmMxrci+FTP1GfEGzm5EZ1?=
 =?us-ascii?Q?Dfb08s23F9Wk8pxDRAEOy0vhq8j55Tcl/YlW4nFst6MDhZ6GTZEUH9S09prX?=
 =?us-ascii?Q?cvBCQ0ZebHDIacf/r/idFHb0hwwZPvEbMHmj85co6x2YC5ikgnF7Xqv6JPGX?=
 =?us-ascii?Q?3sxuqo/DDu2vaCioKWc90pDcLUW8qFVJYtrgOfAP+WpnWrbkl128IN/4OnAE?=
 =?us-ascii?Q?DsyxsOFoLPEu153QqnOdXcD1+Fwt9y4GfdLRPjekdfDWnbZFbThQr04WyeyK?=
 =?us-ascii?Q?EscksdCWnRYUrcQPsXKiOJWSQCwRVlIw8rIka1a2LDti/R8rq0Xv0vn8tMbb?=
 =?us-ascii?Q?/GP7HIwptE+0+PYQ7k8x6uvHQyoaZDfL/j3alZlOsF4tOgv+4HlBVqKm0tBC?=
 =?us-ascii?Q?+oW/Mr8VnCKvPlAt6Q0x2a1ws7yHDflRu0OrmfxM/ZVo6GW117+brgrJysId?=
 =?us-ascii?Q?pUeAMuUVJk07/L+S9nlWdHVTdsPRQVJtTEBcxPa3ucHa7ecnrLQ6VXGZDkXA?=
 =?us-ascii?Q?l8jgt78iPUj7cH4Nmx1EHEs2oqZt10XE3o+Wp+2RHxeZ19tTNQBr+waESotr?=
 =?us-ascii?Q?lBTwzkQYctq2bheUXKELpQ8szD7YL45twl0DV0DFe81lkbv5m2pwCJb/dd9d?=
 =?us-ascii?Q?TpAuAVO9bKIoPrLAEIPuERMq3Hiz1Qv7XcvAcCY0eUaLIsLAP8v773sY6eOn?=
 =?us-ascii?Q?mT1gAt5Bhha+ZbP2osbrFI7hag8UmFftnksTPkLUwyeY7/psRGK3m+45Z4xQ?=
 =?us-ascii?Q?adBr5czEWGxSjaL94WL252hVKXWxy4RjshedA0Q0CsRCnanwn12J0I1zBLSU?=
 =?us-ascii?Q?E1RaU5W/rnKshGbFNSI6kHPM9bEs+Ydm0RaOzA87XffyYfSp8G4Yjvk3OSlh?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b654a83-ecc8-45a6-a646-08db469a4d0d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 21:07:53.6584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kg8KpIrJJtaWzljXn1yTQXMzqIVph+TzMUhYnTzdacJ00VO88kUKAw5bM23VR9zyAR7/9hnDDZWGlYsCRoNoYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6880
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 03:47:13PM -0400, Steven Rostedt wrote:
> I also want to add that if a tool does use a trace event that was not your
> intention, you can then fix the tool to do it properly.
> 
> I had this with powertop. It had hardcoded events (did not use
> libtraceevent) and when I modified the layout, it broke, and Linus reverted
> my changes. After fixing powertop to do things properly, I was able to get
> my changes back in.
> 
> So even if you do break user space, you can still fix it later.

Thanks, this is helpful.
