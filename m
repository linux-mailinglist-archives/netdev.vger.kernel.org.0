Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60B66D84EE
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbjDER3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbjDER3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:29:02 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2081.outbound.protection.outlook.com [40.107.6.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06296591
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 10:28:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AQXPuTI8U+IKjTUCQmIeCuTAVrL+Gr6pxM+J+mjDWmxZ1zzKuXPU7yKfZ/1wTNZ6DS8Lwssr8v5LHSq4dw71IwMOWXlTc7uu/KSMoYZokoml+tYer/3yttMEOQ3RlWCz2BuiIJzAbMLBv4WWnVTLZCRLZiPOq2Y1NFA3NxAY7Fqk96mthWVpAJT/yttoLJQQj0GQ1BE66eimAg/WIZHsLQz3MfFIU6OVjc5BMwhob/+sDo0RSlWuTubIpoRu0tcl0FoFU1llAdmLANGpebaRaypsKuQp6ML6gAgvS1M4482Pk0ldgr+AXLo/KhY+3o/ydMinLhKPB3qldTqiNX6PuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kbzcWSlLchm87a8gWUdM5ziGVDbH/Q0gl5su4Hj0Yh4=;
 b=VHO83G0s5oWWxMeTcRLvd+uyAkq6+clDmzkv76lGfzNF0iaMloZyGx3Y9OuFzS1tctyFZ5eH+j0UFbbUukCF7jXC2mO3DqnOhcC1ni5JjPwv02/ly0RZjqlt4WC3qlSyPkrU+b0ZINw4BTpc6LbUjtOvxa5GoKYPRaLmcgEMTZsU3DQNDWOR/4BRhoUCiUM4wL/dCEce4L+t0AxR0wtuIYXPPa249hxuxRvJAAe+aBgCMF4cUNt923jTGie177gqBfoLKLsC8RjwkIeFrHfqMlgEVmK5rO+T+hSzZwNVtcsj7Ew+VxUNiGfSSwYAEkhLggyTZnYLlpPSiLbwmqkUcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kbzcWSlLchm87a8gWUdM5ziGVDbH/Q0gl5su4Hj0Yh4=;
 b=Xt0x7MMiD1rpMAdG5nEQ+58T7Q+a72Tub4+k2zXPJmdq9/xwekgyWRuZJ5HYwyY9vgFFiRQJgK28Ash1yILouwHNUy6SRHcSdXrH3LRiSuvPkQ3hSh0uIWpAMWyPwhYtV0tb1Jb1SeTue6T6e4v03Fnb85WLW3aqdmxA/FYH1l0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB6957.eurprd04.prod.outlook.com (2603:10a6:803:135::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 17:28:44 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 17:28:44 +0000
Date:   Wed, 5 Apr 2023 20:28:40 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan code
 path
Message-ID: <20230405172840.onxjhr34l7jruofs@skbuf>
References: <20230405063323.36270-1-glipus@gmail.com>
 <20230405094210.32c013a7@kernel.org>
 <20230405170322.epknfkxdupctg6um@skbuf>
 <20230405101323.067a5542@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405101323.067a5542@kernel.org>
X-ClientProxiedBy: FR0P281CA0014.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: c99b5d29-ebc0-4967-d6e9-08db35fb348f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KBXLJoinYMQwKyailLBDDkQe/NyWnF7Ky1lcvCVLKHdcqiLlFxjA+jKHvi6Nsk0XeXGyJSS9GMLszWC5CLGJDlrzkkiRilZJoX4zbgm8UOB+ldf33dOdvYNxFAee8DexkB/U5rG8f8K81HUSth43igoDhJ3E/k/nk/8MKpfOgH8yC0Nl0kUrRox42Zd80yyGglgG5qGEq/rfARqrxg7iL1q72OsZWoqH4DwntSQZU7rhxEfXa9GambI3DMVng1t1qAdVi90RY8iFyC3AQYXZECkS0tJrsogO4WvyCvxvy6oReUzhnH7l9DGxiK39qhK2NFHspJQqYhNC+tq1EFAdKKAR3UNB0uSMEd5IES855rjy5Vueu+wj3NZJ5fyc/WcyOfwcw6Ikm7f4ySfeRZKXXMi60BOGaAxhtm9cGS88J7PB5ijUKEJq9r4FSAuK51DecAuuuzPcgf2FWhbKSRJWdkiRI6iXb3mdoToij7sXgLVfrGSE0wQdhvxb/PJpGF+Y30cR2R4wi4AxOF0CX9bfD+339Augp9G1zh2exXtyJu4lM0vXSmksilS7W0FM3jS5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199021)(6666004)(6486002)(83380400001)(86362001)(38100700002)(33716001)(9686003)(1076003)(6506007)(26005)(6512007)(186003)(2906002)(5660300002)(316002)(8936002)(41300700001)(8676002)(4326008)(66476007)(66556008)(6916009)(44832011)(66946007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?orYILsyq9aeEUHxUvEycUq5sNbYOb6QtPYOrO1H+seVX+5UwzoBlC/aczA37?=
 =?us-ascii?Q?oSC5/kU82d0zSjaW8mmG+7+3mbim17hget6H0UbRwirh7bJiVMuArrlofAEH?=
 =?us-ascii?Q?iToCjZsS2N5Hdq5sGZ4OzooQlVNL7yO3OxkvZ7cG/CrFiD4SnmS2bK3if18T?=
 =?us-ascii?Q?V09wdTbzPBBtDgAzwhZppoNHF0m2RJMsQOWtrGLWmn8iA56TY0EbE4GWe5hD?=
 =?us-ascii?Q?xDkIG2yCzVwh+e7/QrD2HjD+oySl+pyxVMjmnJVkSqhLRfcC3KcqsbdeJ1OG?=
 =?us-ascii?Q?ccnAnqSqlKILfE8oOQGImzbMjuIdSuFXfZXslnoHqzEQ0iVJxGuZsrH09m5P?=
 =?us-ascii?Q?Ptcc8CKTwWi0pvuIeQJNx+QuP6TTDYDcECs8/fJBorAPrAAs1Zq3T3NBXK+Y?=
 =?us-ascii?Q?dKzynmMqnJIRzX5ZwtU3wYxK4gy96g1BVnOCk1zBY6VWRmo3Vhol8guiwUSj?=
 =?us-ascii?Q?rI5hsnzcal2oburtfxq6Yklj70W4F7L9HlYsjDnvgY1svMGGUoyWzHnjHBYK?=
 =?us-ascii?Q?jJ0P8huuvnQwnXgJdYXhR/HIoHVdl81QA4chA6LpLFQkIUg3a4xQVq/ddfyI?=
 =?us-ascii?Q?bnpaZHj4mc67yEH6Z1QAVWCdey+OQGkHXP9VuIASrpbkR/SikMCcuVCTdnDe?=
 =?us-ascii?Q?8LVcAaLsM1kcNB1Nm7Kn5iLCtXvNlh8XJhh7b2w2Y4KZHIlziMxoMm7XXkVY?=
 =?us-ascii?Q?Z7y7G6L+o+g+XPnAOL3HSbzXbnWyKSuetDTAT4RY9Nd+sXHO35Z1/AZG7xv9?=
 =?us-ascii?Q?ZyUvyJ4ePA5B/hYNPcBbJX+BwlahatT6dpTG+ojWvvR+mRM794Y+tC8iVcPA?=
 =?us-ascii?Q?MXA39hxU+YqmDQG9fmtOTgG9HVg3PR2RI5xYsgv4iIDPWe6Izl6alxHI1Sim?=
 =?us-ascii?Q?tY4nvlGhE7t26YIUrdmb/zbM+Nm/UVXyORMOUvm77NDFW8aCgAZ3isagPPfP?=
 =?us-ascii?Q?8oWGZM6Vyg92YSWzwNoR7hHNesojKFRrEUrr75PQq/xa/+WqV+wFqFtXL3NN?=
 =?us-ascii?Q?ZMWOIBAZlEqYN10ShRpoXHMejaprR/yxVlxriAN0lVT9RV1JVXxXa8wFlC5J?=
 =?us-ascii?Q?Qwb4klJ6aBh8WMeXkDq9CJHfSEZsmVsoSVlpK9T6IipZd6n4WcgNvcA4AbLY?=
 =?us-ascii?Q?g5Hdo7x7x639l9g3eloqgd0xFSsySJSAcsZMw+SZbNxm/TVPfzp0jkYG+6nr?=
 =?us-ascii?Q?FO6vQoRd6O98z3V52zRzsseiELOx0K3n2fLlrqlYwY84vVkORmOa3SBACjfX?=
 =?us-ascii?Q?cdVk1Av/2Xu06KDSBsQvSArtcJrOAWDNgYUWCGllK3Hv8VqTjDUgaV8ytwpL?=
 =?us-ascii?Q?6BXdb4KYoz68Rx0F0H32BC7ItOurrAiCrQOwmdJcWBuvUrQl5thKhSP6LeMZ?=
 =?us-ascii?Q?LtU97UV+OLUVaPc8h4iqPZEFABqnmQ3t7ktKM8s5AA8hqIrwOxEG0aSsvGrk?=
 =?us-ascii?Q?tNkAzCzQxXnXgKiHD0JgGVnNJFk38w7zolSi7B1rXUrugBaNcqMXiuBDQwkN?=
 =?us-ascii?Q?+d/dwBn8mNagSO+WbJ188PowAxYUKZzt0n/CjTv0DEk+bKCaYz3Y3cfrnFMh?=
 =?us-ascii?Q?FNSagrEogrkTkcGyGXBESbgVR6wLkM2tg4GYiMenJ6ED6aHE8HiteoFmqZ8p?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99b5d29-ebc0-4967-d6e9-08db35fb348f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 17:28:43.9675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z9TtNuQQL/sJNUKnp8U10pDxcsmHM3YB/IKVItfu4G+C9sr0H9zr9ROpEdDo5eHo45Y4ldgOmdaJS3TCbxXglA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6957
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 10:13:23AM -0700, Jakub Kicinski wrote:
> On Wed, 5 Apr 2023 20:03:22 +0300 Vladimir Oltean wrote:
> > The goal would be for macvlan and bonding to use the same generic_hwtstamp_get_lower()?
> > How would the generic helper get to bond_option_active_slave_get_rcu(),
> > vlan_dev_priv(dev)->real_dev, macvlan_dev_real_dev(dev)?
> > 
> > Perhaps a generic_hwtstamp_get_lower() that takes the lower as argument,
> > and 3 small wrappers in vlan, macvlan, bonding which identify that lower?
> 
> The bonding situation is probably more complex, I haven't looked,
> but for *vlans we can just get the lower from netdev linkage, no?
> Sure the drivers have their own pointers for convenience and with
> their own lifetime rules but under rtnl lock lower/upper should work...

So what do you suggest doing with bonding, then? Not use the generic
helper at all? It's not that more complex, btw. Here are the differences:

- it changes ifrr.ifr_name with real_dev->name for a reason I can't
  really determine or find in commit 94dd016ae538 ("bond: pass
  get_ts_info and SIOC[SG]HWTSTAMP ioctl to active device"). Since vlan
  and macvlan don't do it, and operate with lower drivers from the same
  pool as bonding, I'd imagine it's not needed.

- it requires cfg.flags & HWTSTAMP_FLAG_BONDED_PHC_INDEX to be set in
  SET requests

- it sets cfg.flags | HWTSTAMP_FLAG_BONDED_PHC_INDEX in GET responses

Notably, something I would have expected it does but it doesn't do is it
doesn't apply the same hwtstamping config to the lower interface that
isn't active, when the switchover happens. Presumably user space does that.

So it's not that much different.
