Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1204B56457B
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 09:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiGCHAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 03:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiGCHAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 03:00:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21ADE65A4;
        Sun,  3 Jul 2022 00:00:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iskHmWPfYkCs6aI+AvKWyF210H+viZ06u3WVkuQsDnqYyeszA4BvS/kuS5D1WHKKMR/Nlvno5QMNL7QkJyOkh0ZKT1avOSOFp5NDxDh9uYI9pPwf0J0EJQKmyZKxLaHX0O8o5uhLQcWG9wSGvyCRx4rWwwRlmfr9e5Y/17STWDdJrH1mSWmKx/JZtAobhniqCGLvGBJpUpwPS0YUhZVUWEsP+zD2LM5SJ/sYS63WRV9gplA9p2Q8H1l6DgMTgTmwXUue4Wx06Ez0+oe9OszxyvjR/SQrSxEcjWv/iy5CO2i7myDuDQAb7BsgcUtNBi0vaXRD+iqLXJJPGtTxgHQqIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXYlR4I7hBAnJ9i4IMa7UUQGvFFzBvopwDjKmtR/h9k=;
 b=F9sywGnH3Idt2bu/XAY1UP002Gf0SPdbXq/Ti/BPDvbp+Hr/ALNosgUouNs/ZTvXBeI3kfS3ZvSByVX0wJs2/0v5lZUfi8noceOwSJB7RhaJIpq5FnAL5uX61+G35BCM2N4aWDuOwANsz+fNoydz3x0wTiknufPW+stjhmqQzesJ76b6KxxLtjQkttlkuecUUGnQRP5T+go/XRliOohFS8WpU0p5Y+Uq+ujjeRGuoQykQc6gSML/kLnfUhSKRPZovJxHkvYri3g/sZa6LSRb42X6unJUb9ZNF2e+KwyGroI6aPykKkevSl8RotfQukCAqXTokcvEML0VIKe7DPNFvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXYlR4I7hBAnJ9i4IMa7UUQGvFFzBvopwDjKmtR/h9k=;
 b=KQsAQK8rQdLEAZynuZ68QIsmEvMYtvCinBTf4+S+exO7/8INlKDUyNCqPcYKfyazDrOzgHJBv5EBmaX2lInbOiCT3KRQTDSc0YBq8vlXV0uNJ/nBVzEy1XwICdJlzB0kKfCSxWGXNWlsnxfB3SCsrn7Yu3UINmJ6e7J2VbSDoN28Z5tV2874lsV9bui/LNv9/7DLgq2lIEr6YqZDyrL87/XoEngDl3jk3RJfu2kRRQd0PNdE7224xnW7qlYGkyHjk9R1C3k4GoG6E/AaPcyLfbTOs+/hxSxEriPc0YtwikLb8eydZ92m0GQU3xmuBrF6/4Ceoof0OO2ENhvDy2ii8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN8PR12MB3524.namprd12.prod.outlook.com (2603:10b6:408:68::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Sun, 3 Jul
 2022 07:00:28 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.018; Sun, 3 Jul 2022
 07:00:27 +0000
Date:   Sun, 3 Jul 2022 10:00:22 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Hans S <schultz.hans@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
Message-ID: <YsE+hreRa0REAG3g@shredder>
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder>
 <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder>
 <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <Yr8oPba83rpJE3GV@shredder>
 <CAKUejP4_05E0hfFp-ceXLgPuid=MwrAoHyQ-nYE3qx3Tisb4uA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKUejP4_05E0hfFp-ceXLgPuid=MwrAoHyQ-nYE3qx3Tisb4uA@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0545.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::13) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 261609e2-8a8c-46d8-5611-08da5cc1b5cc
X-MS-TrafficTypeDiagnostic: BN8PR12MB3524:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PsmlmGe3Yy8+PO5Ocu60tdyijZfPnsBEQ8so4T3ooj/AIEQbauSLHq4LDnQbuSAQoPT3cor4zVzZNjRJEad4wDvAJ62dhqAtTsIZoy4CEGNstxWWru+y4W1aFgoaBXe3h3R2E5B2S1qJUvwfjsR9aArOU8Xr+zB0pmErv0b3N8/MPv4hTuJRG4TxHonlg6KKoVHk5UAjGizZ+muWiCafxJ2M0R+AMfeB1W4nIXxDBQ57R6igmiui7Qb0ZjtjtPbZzM+xBiKzKH850SeDQqEa+26W2HEAILZexeW8zGp7TyWrc0WL21m9j6Q2Np1CABzQxTI9LSeFpv/C9GV6HYK0lZoPfBiPTRAVGj18be1DVWx8y/6hxabTMIQSBOBr7RvRGCrs5M0Q6XqqaZ2kbFj6/qvMd7XHc9WODyRopK7uF+WF6yfgoGZQSousHpxmsJkUv/z35qb+KRBHlF9rlEeoXLwbi9emyalJYPzBiwhOumvZJZHroHplcLxxi7hndLkJl4q29L+lyt+Hzk/6NNcLyzwNxYkbWLkhO8+SKPgSd4q1dmldXHLdIrDM/f08v/2djuajsD2Dr/ePO6MVwIiNypO9qQEfi4ADgSqZQhzTJmwZhLad+8shu0qB5mK12+AkOyXbEDcAath6CA7kDqh0kAnusmMlSeymdxurUHmF/6mKQpab1crsfCwbugdlAlLXeCQsoskMoKtm1ZvlX8UMjBKTyPZ0szS4v2OLB1CgYZyndVG0Zdz55ArGdu5iAx10kerAIWEcugOICPyTR/fLGnrBSj2l5J+5crzivbCezWXpoPquc2AXG8iPqzhlBqfz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(39860400002)(396003)(376002)(346002)(366004)(6512007)(5660300002)(66556008)(66946007)(6506007)(66476007)(4326008)(6916009)(316002)(8676002)(6666004)(86362001)(54906003)(2906002)(26005)(41300700001)(33716001)(53546011)(9686003)(7416002)(8936002)(186003)(38100700002)(6486002)(478600001)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u4P++JnSk2Q6bbGLEaem6UkkiB0fFZ3KxOPXbdAKEm1Mtl/4By5yLiK+OY1p?=
 =?us-ascii?Q?UCV3WcL42/X91uH+A8MvE75lPlsspLyzdnaArX/VCPEiML/tDgvUKOYR0RaR?=
 =?us-ascii?Q?ZIieSb/la+Wc983E1SwrvuQ9TWlbArgVJVkawbW3i9WL998aRcRGUzLmTYTi?=
 =?us-ascii?Q?1DcoA+V+JAFaEUgmXaHxqjQfhLdfF/vvu57iheZ7tLlExfX/FYcvuv0lB3cy?=
 =?us-ascii?Q?8eq4f9CwYQH7CoNLJXlP0DsUpHi/ShHKt+WCyMmVXHwrVKIgDoYqrmEhulXw?=
 =?us-ascii?Q?vAkEdcnM2dctKe/R4oyGHJEBLhCch31HdLuUdogshEfbeghN4+zaRBBTxx+8?=
 =?us-ascii?Q?oCXmwHUgAUVZ/Hm73QkHA5Cafk+c8G2fT5F+WkRc5P7gNWSs1forI9u4RWMU?=
 =?us-ascii?Q?lUhvF0VKACWAQLN/Z3YNQuRSIjmnSFTMlDRGg7yNdcPvx73/eHtemahoZTxG?=
 =?us-ascii?Q?Yp4+Tr7kp8V18WAlc6D+8/G+1iLDu9QcK6YorH3M/KS19fUVIa9+Prwcf7vW?=
 =?us-ascii?Q?X8W7/JSMG1rBAzhmiVOnp2D743x7xP860CCSntCsNZnjgfFN1VX0DJGvVFnp?=
 =?us-ascii?Q?mfQTt7W3ytFnCCaqL05Om+an6lK2orLxYS7qP/UaAHDr5jNXIJ4o7mSYrttS?=
 =?us-ascii?Q?E4V7jDfBtdxjbRwUuI1GMYacAO/Gbb6mLCdIvS+T7j+98FvPgtnSXtEPCFsU?=
 =?us-ascii?Q?NSRYygOziz6cXzw3c6ozQU2PAOvlaPij2gfBY9EA51XGBhwefc+6hZi4YfXm?=
 =?us-ascii?Q?DwKpf625Nx4ftnaimP4St/0TPO88jPQ4cLiZE4rTVlqb5Td58csySZtHkg+d?=
 =?us-ascii?Q?cSlkE60zuhKl1bFlsH8fGlqRSXA2qpQdtHB8cebY8rmA05rJuPJSTAh+8xyn?=
 =?us-ascii?Q?H1Hev7ZZdCwY6IsogWoLny+EiuJHnge7B66q2BS8ppYC4ETkbLYciYhKj0JT?=
 =?us-ascii?Q?TaedK2QKuLCM3CKPhOUFiM27DYgb4wihn/FRuG8BvWAChw2Wxd7ygYNS1RMb?=
 =?us-ascii?Q?NjADe/RNz5rrUcyUXr0tJYnGRD8yIc+Qo7Hr6VVZc0cl9fQGkinZqknVj/Eq?=
 =?us-ascii?Q?MJEh9RBPhy0jE4Y8abKpa0ODnS0FB0yDMueZHPPiojFtoUlRTg/sptMoCwOR?=
 =?us-ascii?Q?o02hUJQk+QoJ+NTMf3Ds6kWlL/VUgkVmnHcQdIUVe/4ewRUhn8s0Obr0TW73?=
 =?us-ascii?Q?wX0cJ6ylQA3AKYPI9gt+Goqhzla26aKIGBe1b77FGpM2RRV26nwGHzh4pML5?=
 =?us-ascii?Q?KT32V5i6YcArnxDKpCaSFecas2O+3P/dKx+QGewbvQCMLE+qfPY5bCINsDLU?=
 =?us-ascii?Q?soj2Hap3eHsqLxvQsTqZ4Se2rgl0ARzc6BLppnvLQZkRO/FyBxxkqRDa3X+g?=
 =?us-ascii?Q?M41InVQMVZrRBTzlBYhVQfqfyRJxUjiOxNYkC5vAOzJxPsMiJd+sl3r0eci1?=
 =?us-ascii?Q?TSSnttJqtm7BrAuplQh+e1dVdJAIUlAmdZBddJ0YHXzsvBxEnnt2tI2ej8A0?=
 =?us-ascii?Q?ziAXaAwdizoMwDaf4MopRFiDQHhWxFxeKxb2ZUO+WDciqyI5Zj7bRApCUYUQ?=
 =?us-ascii?Q?jQa6Ge0AeSGvyf7iWlZY0cKrXCDgQeMZD/qfGuAC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 261609e2-8a8c-46d8-5611-08da5cc1b5cc
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2022 07:00:27.6273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XPsNI01hM8ai2y14XP1opK2Fk4fdDC/8tLsOm5JP20UhRbz6EUxHdU4LzffqWF4cEA+mWXpdb1KwjpvG1yLYkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3524
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 09:17:27PM +0200, Hans S wrote:
> On Fri, Jul 1, 2022 at 7:00 PM Ido Schimmel <idosch@nvidia.com> wrote:
> >
> > On Fri, Jul 01, 2022 at 06:07:10PM +0200, Hans S wrote:
> > > There is several issues when learning is turned off with the mv88e6xxx driver:
> >
> > Please don't top-post...
> 
> Sorry, I am using gmails own web interface for a short while now as my
> other options are not supported anymore by Google (not secure apps)
> 
> >
> > >
> > > Mac-Auth requires learning turned on, otherwise there will be no miss
> > > violation interrupts afair.
> > > Refreshing of ATU entries does not work with learning turn off, as the
> > > PAV is set to zero when learning is turned off.
> > > This then further eliminates the use of the HoldAt1 feature and
> > > age-out interrupts.
> > >
> > > With dynamic ATU entries (an upcoming patch set), an authorized unit
> > > gets a dynamic ATU entry, and if it goes quiet for 5 minutes, it's
> > > entry will age out and thus get removed.
> > > That also solves the port relocation issue as if a device relocates to
> > > another port it will be able to get access again after 5 minutes.
> >
> > You assume I'm familiar with mv88e6xxx, when in fact I'm not. Here is
> > what I think you are saying:
> >
> > 1. When a port is locked and a packet is received with a SA that is not
> > in the FDB, it will only generate a miss violation if learning is
> > enabled. In which case, you will notify the bridge driver about this
> > entry as externally learned and locked entry.
> 
> Right.
> 
> > 2. When a port is locked and a packet is received with a SA that matches
> > a different port, it will be dropped regardless if learning is enabled
> > or not.
> 
> I would think so.
> 
> > 3. From the above I conclude that the HW will not auto-populate its FDB
> > when a port is locked.
> 
> Right, and it should not as the locked port feature is basically CPU
> controlled learning.
> (yes it is an irony to have CPU controlled learning and learning
> turned on, but that is just how it is with the mv88e6xxx series :-) )
> 
> > 4. FDB entries that point to a port that does not have learning enabled
> > are not subject to ageing (why?).
> 
> Sorry if I said so. Dynamic ATU entries will age I am sure, but they
> will not refresh unless there is a match between the ingress port and
> the Port Association Vector (PAV).
> But an age out violation will not occur, and the HoldAt1 (entries age
> from 7 -> 0) feature will not work either as it is related to the
> refresh mechanism.
> 
> >
> > Assuming the above is correct, in order for mv88e6xxx to work correctly,
> > it needs to enable learning on all locked ports, but it should happen
> > regardless of the bridge driver learning configuration let alone impose
> > any limitations on it. In fact, hostapd must disable learning for all
> > locked ports.
> 
> To have hardware induced refreshing I would say learning should be on
> also for 802.1X (hostapd). This relies of course on user added dynamic
> ATU entries, which is what my follow-up patch set is about. Besides it
> is perfectly feasible to have both 802.1X and Mac-Auth on the same
> port.

IIUC, with mv88e6xxx, when the port is locked and learning is disabled:

1. You do not get miss violation interrupts. Meaning, you can't report
'locked' entries to the bridge driver.

2. You do not get aged-out interrupts. Meaning, you can't tell the
bridge driver to remove aged-out entries.

My point is that this should happen regardless if learning is enabled on
the bridge driver or not. Just make sure it is always enabled in
mv88e6xxx when the port is locked. Learning in the bridge driver itself
can be off, thereby eliminating the need to disable learning from
link-local packets.
