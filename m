Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9385B56EF
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 11:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiILJIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 05:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiILJIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 05:08:44 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B21513FA9;
        Mon, 12 Sep 2022 02:08:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhDCNe/QR+huZUXDhk+jxzlj6AtjjEpXBtnO0tJC34roAxDFifqz9NyCwAGgIddGvY+fS8qbSSUYz8v3I16Aa05Hve9QehgonZz0EWtId0WbCgqD7WP1e7rHOK2SS6IHeeDAnf1C0eQDpW8zvuUmvNAYCdvfDUTszBluHQgeBO2/TtspmIgrbNUFb1XLnIZ96KqykwYSOQ+hBOV+u4ckLdN29yQjxCUT3vvjk1PgDkCmWfl/jtfJDvPkz8Xb13IEGs+r9+V5Tlb9DO6VoCGg59TjfmGrQ2F2WNgpSSto+jQKk1+MvJg0ZZwz+CSCVZjfoU+XuXPsliK6CDIdgBkvkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XjmlklY01QSensRJAISfplHO3/WppVzYUPXq+tuvdc=;
 b=cc0OKDBrXxULkLI4xkbLSGVph2FMbJ3ruBcYVzyC2LBD2KSbFdFGNcJ5qaBs0RgaRf7YyAgu5fFcdwkFUtv1jOLfPfgz2N+WIpJEazj9eS5a0MWh2ZgStH1dxRBZILI9kWLA237oVfOatzyRDBkMlGC+1VZmNEg0vXdpSu4CL+jrEFojDWY1AQqCGQK1GCt8Ih+bZqETHDLGkHxnDMQ+aeTeZczjFdn4vRjPOwi/cmdhPc9HlqdRdLEotb6DgAm4cMQJrjKlSj2j0SrvPimibQX25jSV97/Cbyzo0f4ZLY9/8GAi75Q6rdMzsXDOuonNWlW0FoD6RuQA7wFefX7eCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XjmlklY01QSensRJAISfplHO3/WppVzYUPXq+tuvdc=;
 b=PTaHAI/aJ8of8r4fYeWDoWYdqVok7/a3oVrJFBSpEjlkTawRM3ZvuH8G520II02rfcrXmaspc/+qUp38Zqe1J/t0KXpdMi32Ihg7GtfmM7NKfuXZYWtR07+y/5dZbXfzI3LYBlOgxXdZpPg5c+6lB2i05/WIcQvpNcp8EaZzWYQVcCb3V3N4kFMOxxp3tvPuSur9m/wF1PD9Q6n7SKDkAzSicpBRt0l+xzOdSrEt8sayN55RKLmNu6VGs5wDblP/L5Wde6izO/EIJjVoWgF2kZZiQrsswpDM75lhU/9Z4jNwaDxyX8VnIUaOzhKOQgwmBXz+NvgHipoLn/UaDPfGqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM8PR12MB5429.namprd12.prod.outlook.com (2603:10b6:8:29::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 09:08:41 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::18a5:7a35:3bb2:929b]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::18a5:7a35:3bb2:929b%3]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 09:08:41 +0000
Date:   Mon, 12 Sep 2022 12:08:36 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 6/6] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <Yx73FOpN5uhPQhFl@shredder>
References: <YwzjPcQjfLPk3q/k@shredder>
 <f1a17512266ac8b61444e7f0e568aca7@kapio-technology.com>
 <YxNo/0+/Sbg9svid@shredder>
 <5cee059b65f6f7671e099150f9da79c1@kapio-technology.com>
 <Yxmgs7Du62V1zyjK@shredder>
 <8dfc9b525f084fa5ad55019f4418a35e@kapio-technology.com>
 <20220908112044.czjh3xkzb4r27ohq@skbuf>
 <152c0ceadefbd742331c340bec2f50c0@kapio-technology.com>
 <20220911001346.qno33l47i6nvgiwy@skbuf>
 <15ee472a68beca4a151118179da5e663@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15ee472a68beca4a151118179da5e663@kapio-technology.com>
X-ClientProxiedBy: VE1PR08CA0011.eurprd08.prod.outlook.com
 (2603:10a6:803:104::24) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM8PR12MB5429:EE_
X-MS-Office365-Filtering-Correlation-Id: a1d795a3-0537-47d4-9e63-08da949e62c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BPUNXraNRhq9QKFrsuHnwDpROgUPjP3OHZWZqumhjO6xPGeLRPbVqrk82WKliIcaqqvB/jEcL/9hfFxtKIW1qNJfvjfevmBAMauph0mtVGY9J9sIpnztD8/nLtbdaFz+B6nFP5DgvVd2e1bKz8GzAc+ipvvcKz7Pe2iNPOL1bLlx1yNa9B1eL+1PTp+PGnROo5yxLaC1gWpzQm1dds1p0QxEhD0OkqUzkZzBl14JL02fkfJf4AO8HFSZs6uC5pFwlnmbNBjDL4D5VbxQBTFSnqyPAIwRByMcO9kQKhmvlS0p+41WPq3C192ttKuP5SbMTpT4bBCw4s13VkD5dzckQUfEsFUqAKpCkaArLJmNvX3qAtjMj6aCzKLYkQOtcaIewiyhhktfiaNUmGfbDC+hvr8bUvwCasENcpdbAtfCYVPffyIaF542ntogUvrxmnNZsxUuKr6IFDk8PuZKasiGlaKErSnE2wjknpyQXC8Sm/+DnTp2ZW/2iCZNBE7vaIYlxsDNuEX1bOql6+TjfeJdao8oOVRYkxn5oT5bWgBHdL64dKGRN4/nPdnpuwWrO58J7sCJ4cRi30xz5NV474bI/DDSR6Fqn9OJzzvuAxG/bH0tyeyCk3z2D17fqi7k4yZUEcUXVdGRwzdjgkb7bki2P9bNogg64N2BBb3aD7xIFY8DB/jhH2N5s2ThV4LviTinSogEctbJdCJ+cbHdF4TVaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(33716001)(7416002)(86362001)(38100700002)(6666004)(7406005)(66476007)(66556008)(66946007)(4326008)(8676002)(5660300002)(8936002)(41300700001)(54906003)(6916009)(478600001)(6486002)(316002)(83380400001)(6506007)(6512007)(26005)(2906002)(9686003)(186003)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D07mIkI0PCh1OEPupbhcy8BX1r9bcWsEZHhuFWb4YXNGbQe/H7z/Aa8iJMSO?=
 =?us-ascii?Q?MTiovmnqNm1OQgR+qEnz05onC40iA/Gf/POx/HJYH+pmXeJm35jkasBsuh5Z?=
 =?us-ascii?Q?U4Lpp2aepg98cYFX7cFY6yGRZ/riEOWg6ED+A9IauWXpc3hNgMETXi+FGo0b?=
 =?us-ascii?Q?G/kgJvVWwNF66C3E49/EsdlyCHniIupsMjRSUCYqA7+u8NlgsFIcfoTZ4rlK?=
 =?us-ascii?Q?qbHTLsbuGNZwSSyM+v50awFJpwSVWPB9EJ8wcx1ML9mc4pWOcFMyQmLiqY7q?=
 =?us-ascii?Q?OEJ6cqSoe5PTeDbdDFFlUGrDGr1t+skL44I9K/1OTyCr8e/jMqsSuZaSM71c?=
 =?us-ascii?Q?xFmsCGnS3j1wvVyjaoJLphoRapm9KEKHB/b8XYuvr0ekL99RpCyK7Li6Q94l?=
 =?us-ascii?Q?stGesyXHmFFWFfTasVUeuNKbXIHzO9rXnR6GgdpF3qmZXD9/9BEF+1G8G4ud?=
 =?us-ascii?Q?N02yAAn1a+IYmAlILVxg7AgNmQg9/wppXQaSm1c5dWD5gCOLntPeSJIMd6a7?=
 =?us-ascii?Q?wWGl/l/TBXzTdBJeJm8Sy8+FI9ojh6o6R21oxsvALLPkNS9QE9TBCrHqceZ4?=
 =?us-ascii?Q?i3Xh7AmMHL1kZgY94z1BCALlJ8WR7P06WEzf2P68mB/Tcw49hSwMfLUYtH+L?=
 =?us-ascii?Q?TC04Cip60x0EpvzvSVqcu87j9pq+FmKfqkjAuTRAmeeIL8m9u1EXTfpU8N0v?=
 =?us-ascii?Q?EAaVq/h8q6Fd32628BX413lDMwGyQAEfz0Yxi7Fi8fzPkqq5PTUW82YxbTGy?=
 =?us-ascii?Q?6IxqWAZ1dksllRUbqGDyHoOdhEPhVFJ6/JjZLvig4dBs53RbMz9zDLKab1jH?=
 =?us-ascii?Q?X+CBjPiz5IePV9hlqAAQaqbKZUZSgTq8kv2lPhpgarZNL0jHYBlFfRTrd09P?=
 =?us-ascii?Q?IMV6f4q6cMawKuuA2TZhhWrdAgNe+7VntoW/rq34bc74x25wpc8Hqh1CInY0?=
 =?us-ascii?Q?Qme5tOCyLUdrfIGk4SlUVI+6p6bg+naoZdgqDsOi3MY6vx15DUyRmIeVP4oC?=
 =?us-ascii?Q?gStVHzrCU50ZmldHlrixs5PfCTuLu62TSEzxOxvaGUNhpezuA7YiWl7Ggnqm?=
 =?us-ascii?Q?0azR8/dXWAQ3mz9pLpgAL1AGJsFEUFV6d3mFqFIVrw9duvbo0OZhFlsz8V5o?=
 =?us-ascii?Q?va96M0mEgOVCc6HrKV6LehZBhgfApn/qgN/hFpZEnofGNd355NynQEbMVrAX?=
 =?us-ascii?Q?P8EX6prUbFbM12WzBNAn7463puw3t/2LFHvx7kFqiiNy7GyEItcQoscYLAux?=
 =?us-ascii?Q?xyWUGmQ7eK5fNQDDuFUid5fVUnzfP8J0iMg+Yd1M+itoFAI+8ArZtqIXdv5w?=
 =?us-ascii?Q?bSvwzbssMJBBprepmGDegsIEyCvihAkZAAjvVIPWAuOO+CWoChSy0E0nJc3g?=
 =?us-ascii?Q?cJ4ujFX89kKFJ/JhtSqTuwRcLzn1VE66HrMax2zQpkOexU9/gz4VMA+yrC0G?=
 =?us-ascii?Q?rIRFP+6Lw4fzR6IdAG2iELNqcxhZsG5nh6uPOS6BKkIl4+olLr9vsvL8dSBJ?=
 =?us-ascii?Q?DQb1KNH5HNFVKdqVB2Boq8EVgRX9kvQ8FjxyLjccQELFVzZbi67Rp0PBbTG1?=
 =?us-ascii?Q?STAHCmQ6heChcdkPJp2vd/AqwBFLhzhsycUo/0mS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1d795a3-0537-47d4-9e63-08da949e62c4
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 09:08:41.1016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PAOTYUUUl0sbrkSf6Xdmgx/3ymZw9X9R++FAf/tQhWzqmad/N3oq1R0Sb+fBM742IZCTUAFx4rrehWXk8pxYNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5429
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 11, 2022 at 11:23:55AM +0200, netdev@kapio-technology.com wrote:
> On 2022-09-11 02:13, Vladimir Oltean wrote:
> > On Fri, Sep 09, 2022 at 03:11:56PM +0200, netdev@kapio-technology.com
> > wrote:
> > > > > > On Wed, Sep 07, 2022 at 11:10:07PM +0200, netdev@kapio-technology.com wrote:
> > > > > > > I am at the blackhole driver implementation now, as I suppose that the
> > > > > > > iproute2 command should work with the mv88e6xxx driver when adding blackhole
> > > > > > > entries (with a added selftest)?
> > > > > > > I decided to add the blackhole feature as new ops for drivers with functions
> > > > > > > blackhole_fdb_add() and blackhole_fdb_del(). Do you agree with that approach?
> > > > > >
> > > > > > I assume you are talking about extending 'dsa_switch_ops'?
> > > > >
> > > > > Yes, that is the idea.
> > > > >
> > > > > > If so, it's up to the DSA maintainers to decide.
> > > >
> > > > What will be the usefulness of adding a blackhole FDB entry from user
> > > > space?
> > > 
> > > With the software bridge it could be used to signal a untrusted host
> > > in
> > > connection with a locked port entry attempt. I don't see so much use
> > > other
> > > that test purposes with the driver though.
> > 
> > Not a huge selling point, to be honest. Can't the blackhole flag remain
> > settable only in the device -> bridge direction, with user space just
> > reading it?
> 
> That is possible, but it would of course not make sense to have selftests of
> the feature as that would not work unless there is a driver with this
> capability (now just mv88e6xxx).

The new "blackhole" flag requires changes in the bridge driver and
without allowing user space to add such entries, the only way to test
these changes is with mv88e6xxx which many of us do not have...
