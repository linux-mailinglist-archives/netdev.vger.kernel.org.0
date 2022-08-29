Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A9C5A4AC4
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 13:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiH2LyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 07:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbiH2Lxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 07:53:42 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2086.outbound.protection.outlook.com [40.107.96.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687127D1C1;
        Mon, 29 Aug 2022 04:37:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFnR5qfaZCzHbGQ75auYhqGRYfUVwMVtctmt6fNNoTZJs4brW6ouMm7zMj4S26oRLaXDbY0mLhMxV4/ZtLiuqiQpKRqQbih+ylaJfNgOBC2zM2vCj+sIhQ1QO0wERZhCxF+kcqUI7XNXj+JhA/yiD/P+3tMlcS9RRkj9ONduZOHolvGCfBgXMJ9GSPLDmxCzk9moEzm8nKwXgI+duXD2C/p5208ACRQlPzHaZ8yC/mrVtRKnx8CvRCvmJww9cZNbGfVcfnryMVX+Arm4UnECc8B3/3lUYesQ/5u6Dkc0sN/9hLQdVRiPSfmIBTWoJ/kmAOkFvafTAqaAFPvM5BrVVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b6FJ4mGB08F/bkBA0qBpCPnkDm2wkG0ym/ykj8fmmLo=;
 b=MwGp+Hup8tTVG4k3L7DKxgjqRvWwIsXev0g1kT0+1rIch7oRzULcTWGnBgRDAUROe3+41kXkBKFPYX89DHwlBwLJr0j1xx57tSKIBZwM99POi2qfgAVJc3mdmLbJ0toFpKj46ZKEVsusKXQQoVI6ABO7Bp8o5dfW7ekZsrQB7bUYeSzZK5m3WCPHvF+UIsY5ms3vC7MsHARPOTU96DyYVNV1FHg0ORJJBXx1m2dDXnKSkZvvMZh2Kl7zTB7eQ8PL/sSDfDYp29UgnmYPk391AZrgXwOuaTxj3dKqPyvevtPnStO6/kjdHOVihSNmhCDHHmi1oHs+cN9X7AQwfMZ5Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b6FJ4mGB08F/bkBA0qBpCPnkDm2wkG0ym/ykj8fmmLo=;
 b=AMaTlI0HDLP+O0vR7Ec2OM/knBQClCOx4+3jEue69n3ZTszbDgawc5idq0J/Zd+5vtEKYcprFgbadgSL/MsE1xgkPv5NW14mXfOBw98iHGxX13eDAvDONQijWzfI1pyw6vUi/f0QqieqFKCNyOAcVSi2vinU9QqSF/EtO8x4Q5Qb8HCjsLiWrQoXrkwEsrQ+SJP/pFs0PUCaIwLe1HctfuFSCJV/M1EB8CK7/qj09WpAdhHkezQWvhJzhHTw4hhwh7Ko+Rx3NG6Qlbpw91l3iUmNInhc+Q8mdwtLz61+J6gQvwmB+U5bR5RJKJTxuGiIuBjkkCxbX18QCrjWzZMAYQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7SPRMB0001.namprd12.prod.outlook.com (2603:10b6:510:13c::20)
 by DM6PR12MB3564.namprd12.prod.outlook.com (2603:10b6:5:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Mon, 29 Aug
 2022 11:32:44 +0000
Received: from PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e]) by PH7SPRMB0001.namprd12.prod.outlook.com
 ([fe80::3ca6:ba11:2893:980e%6]) with mapi id 15.20.5504.025; Mon, 29 Aug 2022
 11:32:44 +0000
Date:   Mon, 29 Aug 2022 14:32:37 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
Message-ID: <Ywyj1VF1wlYqlHb6@shredder>
References: <20220826114538.705433-1-netdev@kapio-technology.com>
 <20220826114538.705433-7-netdev@kapio-technology.com>
 <YwpgvkojEdytzCAB@shredder>
 <7654860e4d7d43c15d482c6caeb6a773@kapio-technology.com>
 <YwxtVhlPjq+M9QMY@shredder>
 <2967ccc234bb672f5440a4b175b73768@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2967ccc234bb672f5440a4b175b73768@kapio-technology.com>
X-ClientProxiedBy: VI1PR0701CA0033.eurprd07.prod.outlook.com
 (2603:10a6:800:90::19) To PH7SPRMB0001.namprd12.prod.outlook.com
 (2603:10b6:510:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 055c0cf2-b1b7-43e0-f5c6-08da89b230f3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3564:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K7Hc7lQj/Mj3Xll6fjm9fTswTCrHPG6ewiiAmguYKf6LHAw76tQOL1u7xS8mkgWLyxmT8zYLdyffAZim2ElPxPTv/90w9+L4N4qzmxPGm8KcbiQ3YgL1OS6nWI9jarGkWz5NkHLZD1VmBvvrawV75BfyTIbRZL0FxLnUC1ZlHBM8NjKjwh07DgAmvaeKnNaOMxH7TkW4Fcv1trvjDQWItFXz0E/G1m1eWKiD7sT90lcINqESHUsWwB/hhSElwTR+c6zYEcOM70WdhI/e99pyByPe1zUrj+zTopojBfixuB/isxmsru1CFWpCbDtX+HY3ubrWgv1lfpdUu26j2V/ffzr58fOw0msKk/mP/Ws3IDny2gLMOfb1/Zh+we3kH8dqkuWEPEj42+3uWZS9RBR9EZyARw3vVrE1Df9payIWoftdWyX3ju3SNQnhVm7VcV/NNseUviKbHxgC9IYMUrXPF3XJm1s84y9vbu/n1Xs7TvWuaTvvJsF9Lp5BDPnojUU3GD27+Tgd6C9FkAu6W9BdRJQF9B5ta+LKrdcemXusr6p/6ssyl3L0AsHqhLSqMW+QsxUaqTTdgbXwVBlTD+nU7f4b2tbfgp9ArbqLcLD+251+zeBfkqPR0rEMEQVngx0wSkb+1keJsDQLCjEabei6R5XIgJRhA81jDgXFGCh0Dnv5BdGUYdq+MLb3YEViEU6etcA4yX8wFKqEuiiIoIjUgjXXwSg/l7fy61EyCJrS6rY1rGboLShu5csME7CWyHYCaZgKa8HL0i6oNtsnKVk9R7GcQfbTTnVXsOmVd78Kj8g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7SPRMB0001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(346002)(376002)(366004)(39860400002)(396003)(33716001)(7416002)(7406005)(86362001)(38100700002)(41300700001)(316002)(186003)(6916009)(26005)(9686003)(53546011)(6666004)(6506007)(54906003)(83380400001)(6512007)(66556008)(966005)(6486002)(8936002)(2906002)(478600001)(66946007)(4326008)(5660300002)(66476007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xw48PA+QQG9MS44M56/gVmLNHZmA5f29xizstytjMfXqjg7SB6fcQQIZZl28?=
 =?us-ascii?Q?2vv0UaBu8qTRFu7sr9LTh/I/9TIIKwwZOVrjdpFXoFt5itZL3vnDqjJMvOqp?=
 =?us-ascii?Q?LMCi202A/YLRX5kB4hzd1MNFLA0QFcYpRatEk5hw3FO3IJV8c2VbgRAVoXeN?=
 =?us-ascii?Q?/cVmBDjzci1yH+YP6fBCoYzTPuNRnjdZ51o7IqSChyLSMKO7nbbek0upnN3Q?=
 =?us-ascii?Q?DLsFu3AcYPoDHAGP+8KybVvERyP8x3P3euw8EJ/fN/yrCO/ILs8Ftgf2AJVj?=
 =?us-ascii?Q?jo8ZwHnTXqwpoqocism9l+QLuEBHie4pIwgYN8xLR1YTSgp2Vsrht7dcbobL?=
 =?us-ascii?Q?/wW/UQFzmbXj/6K1VCPGmQt5dmA9rP9c/FQYLaHxWt02XmP0OeQai9FBsGf2?=
 =?us-ascii?Q?NxHNmtQAC7KSacJN7S5oPKtHragneRbIJAiqdGCHqBrp43iCTc+Z3YZWTLZE?=
 =?us-ascii?Q?GAHOhphDcxGbczEPv1UJ6plderdx11W01p8ARLA+57+UON21XQO5dggIEKfZ?=
 =?us-ascii?Q?pvF7A+xDJhWeQZsOeUsJ6sYk0c213UNITM4Yz6ScrhUoayC3Iy60LokEzG7Q?=
 =?us-ascii?Q?OcYXl3ql7S6yJMUTj5h10ZEFL35HytkDFs8mNc3hPu8eTrtJjdHiC97VlwOu?=
 =?us-ascii?Q?s2Bb1jLwIKWyqhyjUWafo3z85vv9BTW740U1aktK0djZ57hxJSokApRv5mMu?=
 =?us-ascii?Q?MVXg7+IcKEeq4hQnahWLJgFL+QFNMo4WWuDilZShoL0p1Dmny+GN7p2UGjdD?=
 =?us-ascii?Q?GHL+dNNnSf1qLQfTn9J5jNnI3ixGSBpAt0wx0UzCos8UD99aX6K4MvOdCaOz?=
 =?us-ascii?Q?uXXna/zW16MzpRAAci3OcumqH5z4S2FruaY+1a9vfSr7+09Ct1YBFgVc3Thc?=
 =?us-ascii?Q?H90XwoWoX73o9tkQsb9BgALEuxqcfw0eEH5wfmMtjXwIiICwqjkMes1QFznh?=
 =?us-ascii?Q?3CEC/vkg8uzHZOklTky9ayQAU06t+l0TNEDWhJy2LE2yzWOCeV5o0Q9TSle6?=
 =?us-ascii?Q?iKUF8tmpXkVIOIMGsEOUISlx1GvEq4phKQvjbJsmp/B5qDKuIYKDYZE9+hOp?=
 =?us-ascii?Q?9pC+Uhr8eQtKHD/mKzF9Afxtwwg/WEwIlCUyZ7bcFk27tq1Cx797qTsoG+8I?=
 =?us-ascii?Q?4ihfglCA2PYjZ5gPdVGvrfIGeadpG6qyz5nVlm01M+cxnqhGVTP3nTOL9Dia?=
 =?us-ascii?Q?WbFAhQIYgAHPFyEhHaMyHkN3MNu7hKVS5KLqYu5vj44D2hoIuIpWxI5WPT7v?=
 =?us-ascii?Q?PjCqwkeOcLObGrqCV5/4lZF2d6PSV1YtsQ4unQpZPOlDKPaLq52278d0dMRr?=
 =?us-ascii?Q?ePdcTX3LsLhl25h20AXqY6mbBXqRxr+BOp8andFiemayDIl46Uz6YGV29QHQ?=
 =?us-ascii?Q?/tXPlPB5VoQBtn/SYM2OK/PDYAosqtxTTzHXM1D52YDrigfr74YPqF/9zmFq?=
 =?us-ascii?Q?VmRrbZ5NhduBeWZrSNz027OXFTQcdPF3zjK0I3i2w+3oqyaBprZJPGE6Vrd6?=
 =?us-ascii?Q?C+wjKpYyPshwcQKu3yq4O2Vsprn3orC7WMegrBs1eH/z226iBERVQQ5K6Yd8?=
 =?us-ascii?Q?Yb9I8Gmphjey5opJypbg/lN6qrVYsJ7r00IzVf24?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 055c0cf2-b1b7-43e0-f5c6-08da89b230f3
X-MS-Exchange-CrossTenant-AuthSource: PH7SPRMB0001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 11:32:44.6387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /tYm9FzK7e8NjwExPn/AFrsRF3gS9ndYTYxiRdusMAB2BuVyBl34jxHUwA9cw+6/1I7/J8nYEF4/gytotP9/+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3564
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 10:01:18AM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-29 09:40, Ido Schimmel wrote:
> > On Sun, Aug 28, 2022 at 02:00:29PM +0200, netdev@kapio-technology.com
> > wrote:
> > > On 2022-08-27 20:21, Ido Schimmel wrote:
> > > > On Fri, Aug 26, 2022 at 01:45:38PM +0200, Hans Schultz wrote:
> > > > > +locked_port_mab()
> > > > > +{
> > > > > +	RET=0
> > > > > +	check_locked_port_support || return 0
> > > > > +
> > > > > +	ping_do $h1 192.0.2.2
> > > > > +	check_err $? "MAB: Ping did not work before locking port"
> > > > > +
> > > > > +	bridge link set dev $swp1 locked on
> > > > > +	bridge link set dev $swp1 learning on
> > > >
> > > > "locked on learning on" is counter intuitive and IMO very much a
> > > > misconfiguration that we should have disallowed when the "locked" option
> > > > was introduced. It is my understanding that the only reason we are even
> > > > talking about it is because mv88e6xxx needs it for MAB for some reason.
> > > 
> > > As the way mv88e6xxx implements "learning off" is to remove port
> > > association
> > > for ingress packets on a port, but that breaks many other things
> > > such as
> > > refreshing ATU entries and violation interrupts, so it is needed and
> > > the
> > > question is then what is the worst to have 'learning on' on a locked
> > > port or
> > > to have the locked port enabling learning in the driver silently?
> > > 
> > > Opinions seem to differ. Note that even on locked ports without MAB,
> > > port
> > > association on ingress is still needed in future as I have a dynamic
> > > ATU
> > > patch set coming, that uses age out violation and hardware
> > > refreshing to let
> > > the hardware keep the dynamic entries as long as the authorized
> > > station is
> > > sending, but will age the entry out if the station keeps silent for
> > > the
> > > ageing time. But that patch set is dependent on this patch set, and
> > > I don't
> > > think I can send it before this is accepted...
> > 
> > Can you explain how you envision user space to work once everything is
> > merged? I want to make sure we have the full picture before more stuff
> > is merged. From what you describe, I expect the following:
> > 
> > 1. Create topology, assuming two unauthorized ports:
> > 
> > # ip link add name br0 type bridge no_linklocal_learn 1 (*)
> > # ip link set dev swp1 master br0
> > # ip link set dev swp2 master br0
> > # bridge link set dev swp1 learning on locked on
> > # bridge link set dev swp2 learning on locked on
> 
> The final decision on this rests with you I would say.

If the requirement for this feature (with or without MAB) is to work
with dynamic entries (which is not what is currently implemented in the
selftests), then learning needs to be enabled for the sole reason of
refreshing the dynamic entries added by user space. That is, updating
'fdb->updated' with current jiffies value.

So, is this the requirement? I checked the hostapd fork you posted some
time ago and I get the impression that the answer is yes [1], but I want
to verify I'm not missing something.

[1] https://github.com/westermo/hostapd/commit/95dc96f9e89131b2319f5eae8ae7ac99868b7cd0#diff-338b6fad34b4bdb015d7d96930974bd96796b754257473b6c91527789656d6edR11


> Actually I forgot to remove the port association in the driver in this
> version.
> 
> > # ip link set dev swp1 up
> > # ip link set dev swp2 up
> > # ip link set dev br0 up
> > 
> > 2. Assuming h1 behind swp1 was authorized using 802.1X:
> > 
> > # bridge fdb replace $H1_MAC dev swp1 master dynamic
> 
> With the new MAB flag 'replace' is not needed when MAB is not enabled.

Yes, but replace works in both cases.

> 
> > 
> > 3. Assuming 802.1X authentication failed for h2 behind swp2, enable MAB:
> > 
> > # bridge link set dev swp2 mab on
> > 
> > 4. Assuming $H2_MAC is in our allow list:
> > 
> > # bridge fdb replace $H2_MAC dev swp2 master dynamic
> > 
> > Learning is on in order to refresh the dynamic entries that user space
> > installed.
> 
> Yes, port association is needed for those reasons. :-)

Given that the current tests use "static" entries that cannot age, is
there a reason to have "learning on"?

> 
> > 
> > (*) Need to add support for this option in iproute2. Already exposed
> > over netlink (see 'IFLA_BR_MULTI_BOOLOPT').
> 
> Should I do that in this patch set?

No, I'm saying that this option is already exposed over netlink, but
missing iproute2 support. No kernel changes needed.
