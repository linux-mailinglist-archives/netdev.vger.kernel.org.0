Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE236B84C9
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCMWa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCMWa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:30:57 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2042.outbound.protection.outlook.com [40.107.20.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF89D6A2D1
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 15:30:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7UB32LCw7PPCJ30iw6w7aOqFbbrwZNM/uKrzyVIQZCAaw53c+IYm2izFcd8nif4IbUmoTrNz8aQgUPtatAheN2kUaPa9rrzX3ZKz0TBDiq5qkRyWRTpLOxggomeXnVXeSYBazt/ufZyH7HzKwhXkik9orPdwsyjQDgQQ+KtdP7EHPZGUc4xF8LvxwcM/7j1oFvfWzXuO+WDmljxDXDnIEEvSo95W9FBjilyefGsI4u/jL3tTcf+NdBQ6xobFSqyx1n6GI1oPU4pgq6M3dbKV36kqPPdUAk67gdCX9Dw8nabLAhxUWlflp6qrYBSvBMxzwxnfOvtxajchNyxAq4WBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6EmKDb5mxYc6LbSeNhRtmRyQpb+xN3N1hDdFD3LrrQI=;
 b=WRyLwISUG55pzX943Eswua9+GUKXzS4r2blNliSgTpv/QaqI8oyN4t1yLCiupmCPVSU6nKJ8uh7gFYkI1t5jOjDi90CAvLQY/rPBZObM/TmEyvBTQWjzOFr5ogkjQWO59OjQvX08wa3POwhonGWCHwyNmviutZtwSJBOGBio6wbCohdCMjK/KHw+q3fu4bHTOrggD+i8KO5dZtV2+ZAnVxKgoECFekW/2uwwnI1ThdFMFioHqXW0AcHTbwVsLvr33F3N7iOrn5CGgCqyxKKpXNHWtxhUpFKCjgt4jEnm2ur4SO0yApF1Jjl2hOjGNt8edPYgilTio6KUfJY7eaLTLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6EmKDb5mxYc6LbSeNhRtmRyQpb+xN3N1hDdFD3LrrQI=;
 b=W0boiewmrA2iyZlCAh6NZX4b20GXSv5YQYv6xF7UDrubGSOWvG2OcTGC/rZqKR5oOZtgX7jh8suEDI+9Py8cFE0mzNGJch58MztuIRueWauRqsyIY9JzHt7x9fxyE0zr5UFlpHjWCa7yzNR3yn2ya2W2i8Di/l1admhoIXesPxQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB9174.eurprd04.prod.outlook.com (2603:10a6:20b:449::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Mon, 13 Mar
 2023 22:30:53 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.026; Mon, 13 Mar 2023
 22:30:53 +0000
Date:   Tue, 14 Mar 2023 00:30:49 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Etienne Champetier <champetier.etienne@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: mv88e6xxx / MV88E6176 + VLAN-aware unusable in 5.15.98 (ok in
 5.10.168) (resend)
Message-ID: <20230313223049.sjlxagsmbpjwwyqj@skbuf>
References: <cd306c78-14a6-bebb-e174-2917734b4799@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd306c78-14a6-bebb-e174-2917734b4799@gmail.com>
X-ClientProxiedBy: VI1PR03CA0075.eurprd03.prod.outlook.com
 (2603:10a6:803:50::46) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB9174:EE_
X-MS-Office365-Filtering-Correlation-Id: 3554bbcf-143a-4179-8888-08db24129af0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x23nVTmb9y+Z0Etu3sKsm44un6YuPkcCIENLIfycT8dtacKAHpA5l62cNUtwYVw9yF6tfVutMOvEvQt/YRbUuQqtXCgj0HiLtjTDGReFVYkk2fWhQnHQpHb07a6WqMszC/9yt0KzVi8YPINKQL9aAEHOGPtvmI3HFeSlX9z3/Nkflma76mKDrPcWeJYx7Febj8XSoSi+McK9Eq7msjtCaSig5aFlUUfzTwJMvBLaUI6krIjiR/En8bHd7fdtM6wfe7ldp07heYwEMdgKaagx6qPA7Tdaqsxs5iqVW3Hsi8NUIKdiuaDu495jloMtsgIkDNRMK9rO81A65sfhXjeufamwtbKNz9PMrOeLOsMLmbWeoIcTjAMGQBL7JNx1vGSghCR0S1XoZ9IE5iBihicX787vFRB28HIIQvziL4KZK8ND3LRpfHuv4TjZwemeSQfzRtSI/ngD+r/i5M/vOZ3GM88/G8JeskAIB0J1DsE2wPP1h7gvAQ0WaGhqEZCCLNQ66I3TzeR3rIVrfliUkNmVIl3MlJcRAeaoVUc5+S0EK4EfzbQzfQQ1fc/lzlIdMuc0O4osuLe4TewFRnSV6EX0HTjMWl1yIvHUkhYyEvSUtdZh0Uu/5eKus9W64j/tK9kL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199018)(86362001)(38100700002)(2906002)(3716004)(44832011)(41300700001)(5660300002)(8936002)(33716001)(4326008)(6512007)(6506007)(1076003)(9686003)(186003)(26005)(316002)(54906003)(66946007)(66556008)(66476007)(8676002)(6916009)(6666004)(6486002)(966005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bziMPu+Q6i7Morxug/sW6xD+UJASvATWPMXpTQkuFKkWsDh8p4oXNld5HqQU?=
 =?us-ascii?Q?6azu3+wfH41tjmcuu+ldElYhvA/b7ikBW1R03Fk5p3nsIy8lOK27kmIAQ3ZR?=
 =?us-ascii?Q?l8qsr/LA7UG6/WU1pDh47HMWMatPxG+MmgHt9YzyyPIxewXvzb0Dk692FIIz?=
 =?us-ascii?Q?GZ3tWaozDigI9XGsh3TH2Z6kEWd4QVXg7UYA5d9q3nfk0NQq+aq4Fs7v2MTk?=
 =?us-ascii?Q?c/1wnWTumtiuy1LdAjM1PVFw3t8XiR23NoniGsJ7LjIYrrevOOfwLB6d9+to?=
 =?us-ascii?Q?Eu9Dx9xDIivz8Q6q6vIjTV0IxGU4kCERGeFSzeFokpFZ+Hh4SiFpK3YkFFJS?=
 =?us-ascii?Q?z9RHg2SfeQnAaLdNVhdGPiI5cHhw8zV5+5lA80oJMMY/hLlTKQV7tBKHQoeY?=
 =?us-ascii?Q?FsgcR6Q2B/aMnbdv7MIBzFw2F6dm3IAQOYQeHMytgIMCqSpYSQaNdvV5y99j?=
 =?us-ascii?Q?FXlhKZyFXHp2Lm47gWeK8+G7+vi85n/NZUIz8eLPhs8GjCjjDukjTdqIOzGe?=
 =?us-ascii?Q?+HJi0/5xPjebOIdVN5pL0AZQy+EmXsIolbI2pnWAMKkus1t+btliNNT3Ky0L?=
 =?us-ascii?Q?G6vbZEfJvTTDFip02JrQEdz0fHGKQGJce8L3XsG+qPuWEUtXQNlFQCcfgr47?=
 =?us-ascii?Q?kubh4vuBzdeuCMWhFwZnS5g29QJfxEsMThY+ZkFXYI99pRzNQ7h+duc2oJgP?=
 =?us-ascii?Q?8Jw0ZoFXHNHHvx+A/MfhigxQqH3MBEkk5oh6p/lgR8CuOT8YM6IucaLpL40y?=
 =?us-ascii?Q?H4DbjgBPiUCD2MrN5NWLkrd4rsljuyTwHMbjZ8BVOgAE4uHU1lzu8Galw67l?=
 =?us-ascii?Q?ADfCvQXS/FHEyQQjTx7+qASC9EDMXN+f6EVwPH2gTX3mDd/sgUtEVY38snOI?=
 =?us-ascii?Q?JDhZ66CB12leTg6MUwvkjej5baXre52KUCZXbTyWetXaWPlHuNy0587xlWqS?=
 =?us-ascii?Q?T5kKnjIEuNDaDS4PaO0vC7/OI86ejat0xRb/qxNhlmMsvITEgHJuoJT+Cuwj?=
 =?us-ascii?Q?ScKOduLsSkEwybsXwkGXa7v/JUXiWic1jksbRCgjzZKRPGIsT2Ctb0lv4hb3?=
 =?us-ascii?Q?U4QEHyYc6ZRgoO+rwKSlq5e1FN0zf0cdrKITjnwu/CQViMvbIWKo+avMg5m0?=
 =?us-ascii?Q?FvBFfEHktkd/7e3oHEL0LnjR7nGGFdowVXC8K7dtEhvKJ3mZmENviEe6LInk?=
 =?us-ascii?Q?h1/nRqEJbfzlOM4bNTTgbh1kNXT5XsIvUmLD4KhiXCPx5fZ2v5h/I4rf4xRd?=
 =?us-ascii?Q?5y9Cs/r47z74FGtqTZA2liaZGHi2EvFsAN74v07AxoVLExiKDtLrQA5oz2Ga?=
 =?us-ascii?Q?SE4+JUpqP12G+zJHj+ptBMasrMpPzDbYnegRnHMrjlO1lE99aSoet6gsf6vD?=
 =?us-ascii?Q?iyQYdHRyo+UuYwZT/kvXAqrN4fWPuV2FvbPFtOozpcWRNKmB1PfGHusLavi0?=
 =?us-ascii?Q?8RdEv7s6E9b+ZPj0tWuEDCKQ1+AEiNzpnIdDX+XTOwMb2WaCZbFVm+FFHZQX?=
 =?us-ascii?Q?qhwhqj86EpILr5yX/sEINoSzgmpv+K5svC8TJ/D9WRYt5lYJPW6FzawFBLJm?=
 =?us-ascii?Q?6BfuNVIJRKyRNlzUzwdpHZPOf6I79slKTfsG8DEH5vpT79Pb76TpyTtZY+wb?=
 =?us-ascii?Q?hQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3554bbcf-143a-4179-8888-08db24129af0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 22:30:53.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0P6BruYOAJxSjOYld1lpCoNzpoufpDcTdBb89SEE+9tttjh5kvE81Txuo5zYGXvC1HqWxVaAVfenC1Yxh9fVuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9174
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Etienne,

On Sun, Mar 12, 2023 at 12:41:32AM -0500, Etienne Champetier wrote:
> I get tagged frame with VID 3 on lan4 (at least some multicast & broadcast), but lan4 is not a member of VLAN 3
> Also unicast frames from wifi to lan4 exit tagged with VID 2, broadcast frames are fine (verifed with scapy)
> Reverting
> 5bded8259ee3 "net: dsa: mv88e6xxx: isolate the ATU databases of standalone and bridged ports" from Vladimir
> and
> b80dc51b72e2 "net: dsa: mv88e6xxx: Only allow LAG offload on supported hardware"
> 57e661aae6a8 "net: dsa: mv88e6xxx: Link aggregation support"
> from Tobias allow me to get back to 5.10 behavior / working system.
> 
> On the OpenWrt side, 5.15 is the latest supported kernel, so I was not able to try more recent for now.

I don't know and I am not able to reproduce this on Turris MOX with a linux-5.15.y
kernel from https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git.

Could we approach this from the other end? I would like to try and
reproduce the issue with the kernel you are using. But I have no idea
how to use OpenWRT or to navigate through its build system. Could you
help me figure out which source code is built for the Omnia board (plus
additional OpenWRT patches, if any)?

I might also ask you to provide a reproducer for the issue using regular
iproute2 tools starting from an unconfigured system (bridge, ip, etc, as
opposed to the network manager from OpenWRT and its /etc/config/network
configuration file), if this wouldn't be too much effort.

Also, not clear which interface exactly you mean by "wifi" ("unicast
frames from wifi to lan4 exit tagged with VID 2").

Thanks.
