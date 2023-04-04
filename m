Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984DF6D6060
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 14:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbjDDMaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 08:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbjDDMaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 08:30:22 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2053.outbound.protection.outlook.com [40.107.6.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EC7B4
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 05:30:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2LvBGsF/sbnfpE6oWxgyunCTp4vdol16D8KH8gUyp2QLv31cG47hwIggDyTrPdrkqWDVci0cxqj1D45Pq/Uzpe+8rWdZGuBilqk/ZCXbPULQ/99i91xHu5i2ppUM1XuDMfHBSADmdpCYEw9JyilGNGVcy3dRJojIyH2PIomN/h9HyKEdm+K6xNsaS5frxTHmY6CNuXRvz6Qq82z/iV6cshORJhiblF4ZkaogSLY+QXZBmRI508heDfwT+dcVSUGLuZaGNBF9LIM4m+OKyI0T22kI2MXHblABGkkGFOUJ6AgzPKKkF2lcMY9quwtzK5QTXZD+Y820/vPrVXUh89/TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkKNAFavfPboWSZcxwZE4GsqMm3THY7hW/ZqjMOoqdY=;
 b=Auy4TgbVRq7QtUj29G8O9mJDmClgRaSx4celRl3rYZyIe6nKeLM7zD6OX5h9WXOY/Yf8NkfXji4hsvT8mgQbDb7imMFqNHRJDJ9HjQ7rZSFMBI8+yy0uJ5LruaQQOKIgp4S0g73H7C87bihS9EEJzVRKBELYjsk321HnpThmiYRyOIuCmasnDlVJWFyjlL0bcRxGomsK9PJ3SMQ/hj0GRPCCu6hCZHjop4w3PIoGkEiVVh7feksZ15Qdt0Rlvzreu9UBrIe09CVjUlgYX2lm2hVwMQzaqX4mqmDz0riFyBCj2zH04f1Ff9n/FIzFfoEvXeOfu3n0K1F4rZxx82m1ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkKNAFavfPboWSZcxwZE4GsqMm3THY7hW/ZqjMOoqdY=;
 b=JKeTJFFmcVIyTFfYNe/K1Dj1t6Sd29xEDuYxHrtrE4ftwOtMZdKbQGLn7iokzTViNV7y8rARUOTOOtPXKJzVme6FYZlBtH08JeeD3QBMCKhXwo+mzS5uYwVClCYG6a97pBF7uzPDfe6fOMiGiz5lDvbfr2h2DYw8xigOH6QbUVY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7454.eurprd04.prod.outlook.com (2603:10a6:800:1a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 12:30:19 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Tue, 4 Apr 2023
 12:30:19 +0000
Date:   Tue, 4 Apr 2023 15:30:15 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     kory.maincent@bootlin.com, kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next RFC v2] Add NDOs for hardware timestamp get/set
Message-ID: <20230404123015.wzv5l5owgkppoarr@skbuf>
References: <20230402142435.47105-1-glipus@gmail.com>
 <20230403122622.ixpiy2o7irxb3xpp@skbuf>
 <20230402142435.47105-1-glipus@gmail.com>
 <20230403122622.ixpiy2o7irxb3xpp@skbuf>
 <CAP5jrPExLX5nF7BWSSc1LeE_HOSWsDNLiGB52U0dzxfXFKb+Lw@mail.gmail.com>
 <CAP5jrPExLX5nF7BWSSc1LeE_HOSWsDNLiGB52U0dzxfXFKb+Lw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP5jrPExLX5nF7BWSSc1LeE_HOSWsDNLiGB52U0dzxfXFKb+Lw@mail.gmail.com>
 <CAP5jrPExLX5nF7BWSSc1LeE_HOSWsDNLiGB52U0dzxfXFKb+Lw@mail.gmail.com>
X-ClientProxiedBy: FR2P281CA0180.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::9) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: 271b0cf5-4856-42f5-083d-08db350859f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y8HtZZNG7kCejVQYvvKY6OHQLsdSnqT2Reo9kTO8wBGa9U7QNlwZ8H54TfisYo/NwMGOXLf7I8hgKZsqh5YrI/EAC7IlgflPwF0MOmKhixvV3TyUJaMGiusIDol89dyqznCfi/Z+a3JLr1mFNtcJUjdOuNxPV8SlYmlUSXAWGty1QIl/YzqUClWb3wmQ7MK+BDxXKVSPDgjjQ/VKz6QqR7pEnBtHpD+bvvLGgVAZ8rJF67LRKJbZE0iw/gDzURnYCZhAq61pl5sw4kPap3Q/tG4l5eEsAvm+jUfGVq2H3rtUJbB5Ry1phi10rlpc6NzHDkQuCDAd1w5+UimoOi6QAbkDgNrTDLXco1jEaup2VJ+eNkfLradLImfCMRUSDADYRlMTX3ZFG1g1FWCnbyFhI1IgpWLpu1BBg7U5oh9B8T38IOI/gT/ktTaWqPbKxgBdl+wg2vR7uqJXdOVR/Juxkx3ujU4mjybVWvZ+jInb5dT+qfvOA+PM0CHJceiGV3Na+xM+IcPUbdyUBogpOnPwnVbf7WZtQeS1RC9jfgK0Z7ir6Y3NMMnD1SGprDqG9Up3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199021)(478600001)(316002)(54906003)(5660300002)(8936002)(86362001)(2906002)(44832011)(6916009)(4326008)(8676002)(33716001)(66946007)(66476007)(66556008)(38100700002)(41300700001)(186003)(6666004)(6486002)(6512007)(6506007)(26005)(1076003)(9686003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dBSderQVLjjMi8pk22g/L/gmHEMR4N8FnK4pyXQJ2HxexqVzsWEiZBR67tpj?=
 =?us-ascii?Q?UYZxsiyc88YtB8uK481hh9gSZuCRRWZ4FyCa8L7Ls3Nv/1HpTlekEGsR5Sg7?=
 =?us-ascii?Q?w4ppbBOczvok3/6unbRJOsLcYHonmUymAgPIiclIhVBahd7OGFtmtCOYML5u?=
 =?us-ascii?Q?6eQk+YbskRqlJT8JrLD8z29biFfy+2Xj14IaIrAc1cRFT2yDQvRqBvwbDBd+?=
 =?us-ascii?Q?kPdLJUHjBwhfmJJHnrhinv0yqXUypX8hLux2RA48Mn/z9y6teS2KQJeKuNQd?=
 =?us-ascii?Q?X1vWccQjSjW8hYcrlMFX3GcB+PqMXrRmZDeuIVHyCAYEl6/3USz+8ZIPCQ4A?=
 =?us-ascii?Q?6F0XjibJY826Cj5nHZXIc9UqmmRJonOiJ9B1Phwnm54u4jWWZNfwB0tg7UeD?=
 =?us-ascii?Q?fxQQKGoXBm+czJOG+SE3+FppeHISny61w/B0Op3+5vJTJgJ3fiV0qbSfH6MI?=
 =?us-ascii?Q?+TwObt2jemPWlcU+Eb8b1liK0WORFlTmXaKkn+RIHce36vY7cTudl1DzvGEe?=
 =?us-ascii?Q?rBipvcGAx5a2tEmQx/LSixxqd7ye6/jyGd4ZEGf71dBeafUB5LRvpqo0bZ2y?=
 =?us-ascii?Q?mFIm7glmkOBPCENx+Xd3j3RijJjIw28e0CAiM6cXboOuHn7M2BSFILSavY6p?=
 =?us-ascii?Q?P8c8zuD7hyKcceOUJwnkeK4K22iQTx4kq1FHk3immnV7hw+XQ/Vko2VQjid+?=
 =?us-ascii?Q?mFvZVRYgjjyH1kJFiSuEe3bzruNy3eRtd2p60VHjx6s1RPt0YWyx47oG6tSW?=
 =?us-ascii?Q?eOdG4EcevjdkAkMcORqTLkXEE7qKpgDL4+MQkYbhQNDDJ0Z+prFIBg8LhUyK?=
 =?us-ascii?Q?s6lh5IsPnityfxebUl/OlsxfDPn1JfHg7mto+ptkkQFhXzMfxSUySOPvRt2d?=
 =?us-ascii?Q?cDzwd2FNFH9z+gzSR/3OUan8QVG8/c6+cgHdi1WV8Kod+2wy8f98q/0tuYju?=
 =?us-ascii?Q?edKK/EMc2VUyQij4fX54vVWAPFYmI3tuzmmJeB7+uCkOXERHV1toDhgCW8qo?=
 =?us-ascii?Q?WUzlIHT/QqWVI3t+JCt5KbuusjIuuf2qbJ3GCzpvxd0GABgaTI6OF9hZ2aE8?=
 =?us-ascii?Q?dGTeH60iZGmZRMc4eFubiVs8yJzTUBSvN8TDCC5qJ28Uc5Msq0sv+pTbkmoo?=
 =?us-ascii?Q?wEiIMLqcTQLsVgKbLLuMxU3gwJ3q9GjIaxwKVYGf2NshKXuktK8MPwQEP7K4?=
 =?us-ascii?Q?DMM5/0jZN2oc8lY6HTR7zAY7UuQ/r8VkQzrgRYzR39K4Dc9iQi9dojtZCBkb?=
 =?us-ascii?Q?ctvhsnQjOTB1fD0c2sv1lDTjgqhLG0BFEy4j/ps9TCDPkCXjT6DMJNGdL8YW?=
 =?us-ascii?Q?FvW/P/w8fkbhEUc+uFxNHZlfxkLKbGq+IPtX89pKVmzDcCX2ax/jcl4XPft5?=
 =?us-ascii?Q?l6czbVThtVWMzREbS6VkGsDbMa6IajvYe5GbYl3nZFhrKJlQXy9MoZ4bMvdq?=
 =?us-ascii?Q?gIOlCAM0fY5b0U3oRQ1tW8gQ6wf9ZwxVT6W/V/pMn2MIOEZgYY34DnbmWKOl?=
 =?us-ascii?Q?YWvPVuCFmo1JCTBy+E/b1eglpu6qYJQ9QInmsRLbhKai9r+/GDtQJVwl7tkC?=
 =?us-ascii?Q?psB561MJfpbkj/PU1NotzACwlzkpXF8VL5YwSCo2fHAI/wTwEsKyPaQXbUQC?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 271b0cf5-4856-42f5-083d-08db350859f8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 12:30:19.0511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mwmpy4OAk3eqgHB5N3wXF1Hun7GMBVxWbIrb33bC4+AyYxr++YSfx0qILXI8hPCLr82lXIU/HLU4XYlbyQhD0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7454
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 09:42:09AM -0600, Max Georgiev wrote:
> > The conversion per se looks almost in line with what I was expecting to
> > see, except for the comments. I guess you can convert a single driver
> > first (e1000 seems fine), to get the API merged, then more people could
> > work in parallel?
> 
> The conversions are going to be easy (that was the point of adding these NDO
> functions). But there is still a problem of validating these
> conversions with testing.
> Unfortunately I don't have an e1000 card available to validate this conversion.
> I'll let you and Jakub decide what will be the best strategy here.

If you can convert one of the drivers under drivers/net/ethernet/freescale/
with the exception of fec_main.c, or net/dsa/ + drivers/net/dsa/sja1105/
or drivers/net/dsa/mv88e6xxx/, then I can help with testing.

By the way, after inspecting the kernel code a bit more, it also looks
like we need to convert vlan_dev_ioctl() and bond_eth_ioctl() to
something compatible with lower interfaces using the new and the old
API, before converting any driver. Otherwise we'll need to do that later
anyway, when regression reports start coming in. So these 2 are
non-optional whatever you do.
