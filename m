Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15AA16C6C47
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjCWP1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbjCWP1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:27:35 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2065.outbound.protection.outlook.com [40.107.105.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8D830189;
        Thu, 23 Mar 2023 08:27:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Og1FPF6f5kti9SKOXekMpatvpT5Yw8zIGptfwSCkWMal+wJTp/VD6MlpB6qf6+Cz5qoZ03gNNh/kcofgTvookURePFlq3WUDcJHUJHlI+ozIc+wBBSfldBSyBiKh3tpBSPHHaIrwlThvoCF8Cgo1Qlahj+X3Vmh5McrNeIT/5U6+q7ofl9YE/wLOTVp5QyWj/zEcTYyDmwvpdw0bjBO7JV3F4JkhkYAgnqMUJpPhXMd+xbn+W4LJB4exg5WpP0b+rSRDTY0PRossG8IrD0l1d57IXdRajn3+hAZRYAoX2gv02DTHZartQdO1gIG7HIpdWGtKdzUIufTXpDEpxRyX9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHK7zx3js28M7M1DqOqrOGmS24E0ylrz1lEDJti9XSY=;
 b=io+1xZ9f+YogFXfqHRTP9qgRJtqj4J8tipqKy42lLi2alO2BvcfxgctsIc19hlF2Hpm5e2f/3m9Yvb7eRLuqvbOD7lwFIP3iieTI2vxnE7EVvz5lIu1uvIdlsDGVLcVlOrk391rOqFxkWrJRsKwQtlFXgQKAkGz8G0xPsfbcdU3pMIK3pyNLa/ZheHWj4MGZeSp2Wni/fnnEylWiWkFX5NFG0AZstv4+PNgSCg6dZ8/HXg782bDSSNjXFdM5gaQmQhv5Ff4uma1F3gfRz2Ek9hAqDyLj7B5mRSBJ81SD/WKFdzXdMw58b+d9lulJCqrlMpueRff4Aw9Vy3Xn61qKPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHK7zx3js28M7M1DqOqrOGmS24E0ylrz1lEDJti9XSY=;
 b=TC6dz967Rd4XlwZZmhZBRvCPDTZ2c8UEjcGXtd2EhmBMCxEzD/L56a53l/1GYVccrv4znaRz2iFLoRpxUQxDvUi0bvdI/rqlibgNtmuB/YDNQlGTJF904wESeGirxlTYcPuTy3ZSMgxcWaPf3tVytEWdkPSZLFlbFyuQ3uauF/8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by DB8PR04MB6796.eurprd04.prod.outlook.com (2603:10a6:10:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 15:27:28 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::9c6d:d40c:fbe5:58bd]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::9c6d:d40c:fbe5:58bd%7]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 15:27:28 +0000
Date:   Thu, 23 Mar 2023 17:27:24 +0200
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v2] net: dpaa2-mac: Get serdes only for backplane
 links
Message-ID: <20230323152724.fxcxysfe637bqxzt@LXL00007.wbi.nxp.com>
References: <20230304003159.1389573-1-sean.anderson@seco.com>
 <20230306080953.3wbprojol4gs5bel@LXL00007.wbi.nxp.com>
 <4cf5fd5b-cf89-4968-d2ff-f828ca51dd31@seco.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cf5fd5b-cf89-4968-d2ff-f828ca51dd31@seco.com>
X-ClientProxiedBy: VI1PR09CA0088.eurprd09.prod.outlook.com
 (2603:10a6:802:29::32) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|DB8PR04MB6796:EE_
X-MS-Office365-Filtering-Correlation-Id: a0064ba8-e0b4-44d0-088d-08db2bb31c78
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HSEv9/0kTun8pGcLU0fQBZTSGKFR0YxvyIaYnk/PnQDeN6IceGmQvdMzjccFJ75VZEaC2cPh2F4CG3Odt01iyupYsiuWnpABQcWgsAFkmx3Co458PQdmR0bUmHppE8xeFK8XKk6lzz9KHh0Isv64dsyS3Ph4jfwvgk+dMQQxs67jOLakFseazC+q33rAfQPX07g2OwiKQqf8TTxarY7WYC/wdhjfB+mVot2EaXPZh0cRi2jBQHRBPsNR0y/88jqUdTqv07w7fFlPccJtnRZa1t0RLgmNprZ8SiegCl7YMjX97UOupuWenBFOpvMQ0mK43xL4pZd/579na1HGCaGeoRRtj2vJiOKzutLIrpOq7x5DwOQB2F6AxQTyF2u3bwnbSCZPXNbO62p/rxLUXlkejaArIw6x6SOOeOKttGIir6zw3RVpNSsliisTZjm8MABT7fI2g2gJDrVHZSDG7zDySRVvT5PkZOPxPYjQ848roQFKYM9/FOBWwGylcp3GyGkFQ0s1oM03oVdLnO/3Q4YAJUg/Esh8Z4meej6Z99t+265fNorOI7GEoLk76oiFNJJi3t/S/Glu5XcMY79gwL4KmvKNwDg9MYUUyUGURWFIGOIOyIrZjV/kJBpBZMs2EgkapUm8RVs8M67tZMeQzJaArg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(451199018)(4326008)(86362001)(8676002)(6916009)(66946007)(66476007)(66556008)(8936002)(41300700001)(478600001)(6486002)(316002)(54906003)(44832011)(2906002)(5660300002)(26005)(38100700002)(6512007)(6506007)(1076003)(53546011)(6666004)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SVosBOOv9u6kR8vJI5gds9nOORJ2B3U6tjIv9f357BEgqkOFFfG2LOiB1eyu?=
 =?us-ascii?Q?RGzVgoZZFkCZAoCt+iBHN2yMzCyz598+wcNdNRWEo+VRBFn7WWiO4+e7zZNY?=
 =?us-ascii?Q?eEKDPduKTLn0Jzkx2LM/Wh04CnG3+lHjSFEOqVPE/EbMz1XJNi7uEHqh3Ha/?=
 =?us-ascii?Q?KgKwGZhpNJzE9zF3xIAQaxS18drdVH4SzTmML7nudJ1zBU53Ef5UXPNZ6597?=
 =?us-ascii?Q?XYZZJRCOg8G5dEK7vohW+THH9HdWzd9FK2P2y21GMfz8R7xGDzQgLNUa0+sq?=
 =?us-ascii?Q?LV4qEUaWw2QfbHV2SP5D3VEhvgyLQetsTsFeGCtoc2H3ZntLiRB/UmREt2jf?=
 =?us-ascii?Q?gVfI5zCc5Bq83ZjkZgDPhB6/p07WZo8wKhKcMzNqpjotan1ca34Sz1dJPLdM?=
 =?us-ascii?Q?PyPbVh2nDM9ZsJL4YxjuWhA1XIti7yfCI/fzZXquClb1QW963ibzl3/OrOqD?=
 =?us-ascii?Q?A2sZC+NOyuFQ1xglPewcQZE9MOPOTASRgKgzqu/RXwOhPwPGSI8edcicNZUb?=
 =?us-ascii?Q?86TQIkGLEW0+6aGhqf4utmTwCuwlDajRN95OgcNVDUDbHqXuxnQTC7Ehi3a1?=
 =?us-ascii?Q?kqSq8ieeGY7FnBBxd7lXJZcskX7G7YVnb1ZAV9TgZW4Jni1qs9btYqKG4A8p?=
 =?us-ascii?Q?PGgU1yPMwZ4qFilv2604bjgxTRoALeJMl+RQQmKati/5hTijLJNoZpc/zAsc?=
 =?us-ascii?Q?IVmN13Lu3uqNGAF9ZOSL6fi5n5pzFzj8nEensty8ABD5RpRUDEoRVx+5cC/K?=
 =?us-ascii?Q?UjGbV462v+O2ngTGpiCUAFbLcLiHN1T6em2UQgxkZaVw7xuy00l2/VelbKIj?=
 =?us-ascii?Q?3SFObaykBd7FNApO+m0zuXndUgIZNcBXXuKDEU2RfkF8sgBU+nGPuRJ9v7c4?=
 =?us-ascii?Q?067mKnaYg0glzJL77f2czz67YW38yf+YQGiLFhSlea/XkNYg1HQZpU5nPgYF?=
 =?us-ascii?Q?rO8U0BjGFZYqNHIs26s1B3CT8tlIuw8YU+yuKfJsldfoXroEfFh7cnrtnVRL?=
 =?us-ascii?Q?WoU/T56Dq2E2Uhpv8d1DE9Rd64q+87SHHRt850lcU8aCq2TCocXWQmku4Tmu?=
 =?us-ascii?Q?BMfzyMXWQ7sAslmIt7oUGsUDeXQWMJMpaZ9oN7ZbrKyii00+AuVmR4Qq4edn?=
 =?us-ascii?Q?AtqarOezRDBKzC7UGbAfop0lEhHy+mkqe9pc6A4IBPFhc7RNl18Lg3Qet9yf?=
 =?us-ascii?Q?eAyI8AG2yQ96BA1Bh838Xpl4CnVKCHb23w96rkb75n8zVoqUEJXxPTkK7q2Z?=
 =?us-ascii?Q?8DeZot80j+Mu/2SuXdFMBMRnC1VxvYRo3HRoIqlvUZgvDaBmOuNpzYEnJfRy?=
 =?us-ascii?Q?L23oGZxx+g6wzfpMj9T+vEoinppwtDdyO2Kp+kyIMjgLLKwyP9CW8hqc0/hT?=
 =?us-ascii?Q?wrpgKK/LsL+o86pNh/hX7OS31FEe2/vWEAnSXMv95N9CLaxoai//g5KAhyP5?=
 =?us-ascii?Q?xZ1UhO3+wOtZZyw8jeOiT7YtVhpV1fZBbhx5bgl6DD3cECMUNDUtUdoTUYze?=
 =?us-ascii?Q?BN1l0CF+D1A3oaWIKDc7wl2ufEcp7dxWOMb9s8M2SIgSfPXlMxnNlqucDmyU?=
 =?us-ascii?Q?IO0pVYTTALQ4+HspYPmBJzLz4m37+tvJ/QUv5GopKty4QPpL4cGiAI2GQT4N?=
 =?us-ascii?Q?CQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0064ba8-e0b4-44d0-088d-08db2bb31c78
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 15:27:28.2794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PAF916Bvk5cTWo5sbERmcweLpjheUq2BXImRY2Si/HGUy4SmBtf6MIwJoV9Dew9KVj+lFqOjuKajwBPQuirujg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6796
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 11:13:17AM -0500, Sean Anderson wrote:
> On 3/6/23 03:09, Ioana Ciornei wrote:
> > On Fri, Mar 03, 2023 at 07:31:59PM -0500, Sean Anderson wrote:
> >> When commenting on what would become commit 085f1776fa03 ("net: dpaa2-mac:
> >> add backplane link mode support"), Ioana Ciornei said [1]:
> >> 
> >> > ...DPMACs in TYPE_BACKPLANE can have both their PCS and SerDes managed
> >> > by Linux (since the firmware is not touching these). That being said,
> >> > DPMACs in TYPE_PHY (the type that is already supported in dpaa2-mac) can
> >> > also have their PCS managed by Linux (no interraction from the
> >> > firmware's part with the PCS, just the SerDes).
> >> 
> >> This implies that Linux only manages the SerDes when the link type is
> >> backplane. Modify the condition in dpaa2_mac_connect to reflect this,
> >> moving the existing conditions to more appropriate places.
> > 
> > I am not sure I understand why are you moving the conditions to
> > different places. Could you please explain?
> 
> This is not (just) a movement of conditions, but a changing of what they
> apply to.
> 
> There are two things which this patch changes: whether we manage the phy
> and whether we say we support alternate interfaces. According to your
> comment above (and roughly in-line with my testing), Linux manages the
> phy *exactly* when the link type is BACKPLANE. In all other cases, the
> firmware manages the phy. Similarly, alternate interfaces are supported
> *exactly* when the firmware supports PROTOCOL_CHANGE. However, currently
> the conditions do not match this.
> 
> > Why not just append the existing condition from dpaa2_mac_connect() with
> > "mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE"?
> > 
> > This way, the serdes_phy is populated only if all the conditions pass
> > and you don't have to scatter them all around the driver.
> 
> If we have link type BACKPLANE, Linux manages the phy, even if the
> firmware doesn't support changing the interface. Therefore, we need to
> grab the phy, but not fill in alternate interfaces.
> 
> This does not scatter the conditions, but instead moves them to exactly
> where they are needed. Currently, they are in the wrong places.

Sorry for not making my position clear from the first time which is:
there is no point in having a SerDes driver or a reference to the
SerDes PHY if the firmware does not actually support changing of
interfaces.

Why I think that is because the SerDes is configured at boot time
anyway for the interface type defined in the RCW (Reset Configuration
Word). If the firmware does not support any protocol change then why
trouble the dpaa2-eth driver with anything SerDes related?

This is why I am ok with only extending the condition from
dpaa2_mac_connect() with an additional check but not the exact patch
that you sent.

Ioana
