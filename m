Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3775608D7B
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 15:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiJVNuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 09:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJVNuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 09:50:03 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2089.outbound.protection.outlook.com [40.107.96.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6505D8B5;
        Sat, 22 Oct 2022 06:50:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuATBWpid0/UgVzC2PItgQvaqPhTcnqHcfOIuTklGggNQFXgSqiuiyjhRkKECvKXlmd8gm9DQ4aVrv00Dyjj4zR1/2yXtJZT+XYQCTnkBwM8iKeqbl+HhqzQmPyJ8cBY7BAgBXb29yz1Y/ZflP28S7JOoU21AMIxiOXxee4aqENcXGZMF2y/puGQeLW38n0orlxMiodjqalmohiJYIL5SRFaI4jsZvuA0VYNzj295nPsJ6MqAK6u+vlFZND24f/CGsT4tU22Sf0POCTcY7uKgQP0akD1i8VATeD5OB25qhjWIa3R0v2GnTxOt9P6OB08XlMA1+9KTjviJAuj2OTpkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPkw3sqydEdDqWUSxJi+g/0nFlMp6TBnxJ3JPbwmh/U=;
 b=BqnD3LnK+PgdRMew+F1veQtD92qv6yaLXIugllLKcU4QAg1Xr8JKN9scRj6ZcwTkAc7hRGS295GmvjZMTDiJYFm2u4q/DbFDPLBCl8Su0SdZK4cexsygla7pgSGTcImSE+taFoAobaybGocHtiSn4BgCmYMXVuLW+2iB9csmfmH89GW0rh4Fy6st+oysb40g+W6jmQ9hhLeuo3l0W5vXBPCIv70rl/N06Uu4dSOjGK8HidSlXMU5j9C9juHsEO4xv75OPuldcU8iZRkYDHSmM/ozUFfjfS9IWFoCPpibRzP3iAYf8t8oModX/nrBofmtKnEVSRRZvab3rEqb1lY0YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPkw3sqydEdDqWUSxJi+g/0nFlMp6TBnxJ3JPbwmh/U=;
 b=pQc2DU2lwYwDmuwU8qlM//5MPT83/XAbgUzaFWFU9n0bSDvKQOTjdZ8ZOZ200XvI22sfkhWUfRA/RiGOljVz13ijyiMiHWlbKclfgi6NfzhmEWOtsMgZaIgsBf2QkhTUDB6s5nfHIwkUpeiw+eUz4ZB0SZ3BUxyUeEWvE4wTdIIi7grfNr9J54jWpPNO61X+FmluTFGrPBuk0trWK52YcjeGb5c344LfmHY3PS1eHL03Oe/NJacETNmjVSGem9TcYY1QTD/aEVuya1G04b8xvxqSon1MtCrnqV42KpfTmF9qtDkeh8z7dfuebmhSYDZm0heOiVRzbUfC60Ejhb9CWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL1PR12MB5364.namprd12.prod.outlook.com (2603:10b6:208:314::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Sat, 22 Oct
 2022 13:49:57 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.021; Sat, 22 Oct 2022
 13:49:57 +0000
Date:   Sat, 22 Oct 2022 16:49:50 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@kapio-technology.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
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
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 10/12] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <Y1P0/gYdvrk+W866@shredder>
References: <2565c09bb95d69142522c3c3bcaa599e@kapio-technology.com>
 <20221020225719.l5iw6vndmm7gvjo3@skbuf>
 <82d23b100b8d2c9e4647b8a134d5cbbf@kapio-technology.com>
 <20221021112216.6bw6sjrieh2znlti@skbuf>
 <7bfaae46b1913fe81654a4cd257d98b1@kapio-technology.com>
 <20221021163005.xljk2j3fkikr6uge@skbuf>
 <d1fb07de4b55d64f98425fe66156c4e4@kapio-technology.com>
 <20221021173014.oit3qmpkrsjwzbgu@skbuf>
 <b88e331e016ad3801f1bf1a0dec507f3@kapio-technology.com>
 <20221021181411.sv52q4yxr5r7urab@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021181411.sv52q4yxr5r7urab@skbuf>
X-ClientProxiedBy: VI1PR04CA0100.eurprd04.prod.outlook.com
 (2603:10a6:803:64::35) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL1PR12MB5364:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bdcc1f6-a257-42f3-f31e-08dab4344e0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UBh/HNiYb1WanlCZ6yNnRH54paqHc+wK/TtlOSZCg0VVeh0bWXl0IDAr1WkNWqKLcCojUvg3FE2bb/xUnx/jwWEkuecyYATqnDoGUmzwue9jpw6e+i3lkZJ+oo/CHvGwwKbp0T4XwbQ+AXM2uj88M7/4P3BcTibX6hb2aqQbg+kqzkqJ/S3kSntO3qLrDlRCHdumBuYdLidaNLf9ootLdiDFg5TlTmOOdIY4OrJLeKBn13nQq/tkeCWlM9WglSF7ksiYH5ILqbcQhf4abG8EwcjvYoXyRJJO2XJd7NwoPOrv1gKdcBWqwIV5XFlErGMRNSbzq3BeH3UquySLN1gj1XNr5mw0gQB0NEagZlpLvOJrTI8bLe+33D0KEbkYpo7WiHl+9kn2WXAxcAbH93a9/B3RvQwdFUrUzZfvOMn1fp75gtCJerP54ZV2QZqHH2Di9TBqwTWLXfhWJkKmIRP1hGINWpaGnYXC+MR45db124XYv95qGjdLv8h7DqDE6xSpaK1exdheD9P1Jy4ZKs6ekbx0i8NfRvXUIff84hGtqzCTd0J7ADWzSp3blDbblZbcrqkbFdbUtsls+64HAhOZo28NX/YIDGGSzj+BqNyO2MUZCgKo3wV+FM/D0XgEjfkbRn19XOI/gXwLCXbSEZ735lAK9Qx8tcmi00l2nnSPxHsvtOHOFaE+t4TFAJBoeVMDhkrpoUtzPRFJPFLwwiyOQVw1+fV31TDng1YvTFKnD8iCC8SNxX+tp0WjlRZUbdCyHTbdXnynk5GgFTbPHUeYtqIPt6yFocu7Am1PIL3dQh7gUH8bcWkREBrM6kh8c29qN/lEdBzQxsUINWoIi3zvWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199015)(26005)(83380400001)(41300700001)(9686003)(6506007)(6512007)(66946007)(8676002)(6916009)(86362001)(4326008)(66556008)(66476007)(7416002)(5660300002)(7406005)(8936002)(6666004)(316002)(54906003)(966005)(38100700002)(66899015)(6486002)(33716001)(186003)(2906002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mrVURjN1xJ4yeO1XZSJpSXItkqrh7aeQGLzeQx7sp2ij4UFc6N2j4b91IT/Z?=
 =?us-ascii?Q?D2oDLoyTYLGyZFmJxdVH0ty042GA5DzZ6ayc4+pNXK4FFhGdzA/L/2NKn24D?=
 =?us-ascii?Q?EW+dBif03+GXwl4cnGq382njyFtcDZEW1Un+PG57OF16uTrlVdWDAprGOvcz?=
 =?us-ascii?Q?pAuXWWrs9PcuOO0bQYz5g3c/LCjpln9ftN9ygcJOJ+75ac5qf/IyMWB9XgLl?=
 =?us-ascii?Q?ifTHp0zL8Cxa+jwDTNuIEE7j2eDpxffqUoNET81yEf931xMVXM/YKdAaLsme?=
 =?us-ascii?Q?9X/LgCf40cyxdeHmmmaxlFj1RdUTw2WuYgOpHhgy+qF7CsZU9VBbzRtppb5G?=
 =?us-ascii?Q?WSZcNSoG/AnHeisXHdsOqGJak6B6zKwZlC2AayfMvVj6iwrCW5hg3QOdI/xC?=
 =?us-ascii?Q?p37j1TwfpnvMeGdyAOU3emd4EL6BmpM6hJ1HRogGi8kdFkIPIofUNA3r/JT9?=
 =?us-ascii?Q?tS42H9eqbk5gsXoGyqi/06j0YMYXzgcHfqONvkFQPB/w2UdcPHF3df+Wfh2/?=
 =?us-ascii?Q?uEwRDVccLqpXytgbm2mfxUGcJ2UufscqnBKgj1PELYteN1LSK30ukeXnHZUj?=
 =?us-ascii?Q?hrGVgVWRIR4VrGhQsCkOPBA/44SBT/qidIQzRc/bKKgKOFIm+iGlgEEXYwHb?=
 =?us-ascii?Q?+sZtodJv12sNb1kovS3E995VVLD/adx3A0hZISGJZ62vT2J7btTZaYjIKfev?=
 =?us-ascii?Q?TLTmOGKZoOzFDggl/n4Kqxg/DzatmSsJDAyQsAmo3nt3EaiXc8SNfVWIVbZF?=
 =?us-ascii?Q?tuv4Qwlgu86dn9XDZ2Y7qmd3Z7vNIMRde0KgiG7RDxM+jlpiyKSfo6vpBY2H?=
 =?us-ascii?Q?MVAkcCu0GdtoNomyvMYO3cdo5OIZ+GjNoviQXkzFa2zR2bD1QjuGOMI+tEft?=
 =?us-ascii?Q?Kv6gUxep/00lPClbhWWzOXnV4cDFraroT7ghxUiy9/FqzFNfim9BcvQwJWgR?=
 =?us-ascii?Q?9Zo7NnjZUr4Ic0WE+VUno3eKS5OZEzsnq0gzSAiRAcaKrXhLWPUd4q6vSZeS?=
 =?us-ascii?Q?rKFZG1g/u8g999Yoj6HRXFF2mabFI7zH2mHkkBUy1onzx1gGZoIldbNf7qHJ?=
 =?us-ascii?Q?4c4iGdQZkiCHDaoTBPgTQTMl47Mi2G9Yo9hGbQJippHHcrWp0BkmOtDOzQ/u?=
 =?us-ascii?Q?RfIHnBa4B/yKKEpCaLeJRbGy+8z0dBl9stpgbutNlMgTrlLykRdetl4MBYix?=
 =?us-ascii?Q?zlgkYhQtoDaxLfxwblp8ddjA6IoBaiEm5+1qTPCcQ02qSlIkjuseMeJbWpye?=
 =?us-ascii?Q?u68qiML/BdVK3ypndga24ETLdyUIrVMWLIpuui8yoWjRnRWd0+DmVY2BdPAp?=
 =?us-ascii?Q?CKMZKTea6Nu+YBnS/4BWmdTmy0rF81agF8l+XQD3+KuTM8OBRQEQIZF+CFyu?=
 =?us-ascii?Q?JPruJJG4zgOH2DiUcITyOcGKmacDXAz8lsnH/4oxh9pIAPigNo1KxFVJAr5K?=
 =?us-ascii?Q?k6TmMZ7nqGjqrKhuZfEM0rzePdn1GEDQFfVi2zOKVs72H7QLGgGcTuk3Bmre?=
 =?us-ascii?Q?mtM9XsuBCEGLZBidgfbBY62IrL2487HFHB7Wn7MLRDn977HJFhbx6EiIWDDM?=
 =?us-ascii?Q?N7co8Y4OzX9zinaUcJFNlqIl2CDlj2PRfU8Ak7HJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bdcc1f6-a257-42f3-f31e-08dab4344e0f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2022 13:49:57.1219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aCcZ0mQ1JCz2re4HT17tOVDaKiqxZAGDX+WnjYFXT6MYMhqAp/P1ntLc8EJSMYl315KU+6Di/Opx3sz5sE+Y4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5364
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 09:14:11PM +0300, Vladimir Oltean wrote:
> On Fri, Oct 21, 2022 at 07:39:34PM +0200, netdev@kapio-technology.com wrote:
> > Well, with this change, to have MAB working, the bridge would need learning on
> > of course, but how things work with the bridge according to the flags, they
> > should also work in the offloaded case if you ask me. There should be no
> > difference between the two, thus MAB in drivers would have to be with
> > learning on.
> 
> Am I proposing for things to work differently in the offload and
> software case, and not realizing it? :-/
> 
> The essence of my proposal was to send a bug fix now which denies
> BR_LEARNING to be set together with BR_PORT_LOCKED. The fact that
> link-local traffic is learned by the software bridge is something
> unintended as far as I understand.
> 
> You tried to fix it here, and as far as I could search in my inbox, that
> didn't go anywhere:
> https://lore.kernel.org/netdev/47d8d747-54ef-df52-3b9c-acb9a77fa14a@blackwall.org/T/#u
> 
> I thought only mv88e6xxx offloads BR_PORT_LOCKED, but now, after
> searching, I also see prestera has support for it, so let me add
> Oleksandr Mazur to the discussion as well. I wonder how they deal with
> this? Has somebody come to rely on learning being enabled on a locked
> port?
> 
> 
> MAB in offloading drivers will have to be with learning on (same as in
> software). When BR_PORT_LOCKED | BR_LEARNING will be allowed together
> back in net-next (to denote the MAB configuration), offloading drivers
> (mv88e6xxx and prestera) will be patched to reject them. They will only
> accept the two together when they implement MAB support.
> 
> Future drivers after this mess has been cleaned up will have to look at
> the BR_PORT_LOCKED and BR_LEARNING flag in combination, to see which
> kind of learning is desired on a port (secure, CPU based learning or
> autonomous learning).
> 
> Am I not making sense?

I will try to summarize what I learned from past discussions because I
think it is not properly explained in the commit messages.

If you look at the hostapd fork by Westermo [1], you will see that they
are authorizing hosts by adding dynamic FDB entries from user space, not
static ones. Someone from Westermo will need to confirm this, but I
guess the reasons are that a) They want hosts that became silent to lose
their authentication after the aging time b) They want hosts to lose
their authentication when the carrier of the bridge port goes down. This
will cause the bridge driver to flush dynamic FDB entries, but not
static ones. Otherwise, an attacker with physical access to the switch
and knowledge of the MAC address of the authenticated host can connect a
different (malicious) host that will be able to communicate through the
bridge.

In the above scenario, learning does not need to be on for the bridge to
populate its FDB, but rather for the bridge to refresh the dynamic FDB
entries installed by hostapd. This seems like a valid use case and one
needs a good reason to break it in future kernels.

Regarding learning from link-local frames, this can be mitigated by [2]
without adding additional checks in the bridge. I don't know why this
bridge option was originally added, but if it wasn't for this use case,
then now it has another use case.

Regarding MAB, from the above you can see that a pure 802.1X
implementation that does not involve MAB can benefit from locked bridge
ports with learning enabled. It is therefore not accurate to say that
one wants MAB merely by enabling learning on a locked port. Given that
MAB is a proprietary extension and much less secure than 802.1X, we can
assume that there will be deployments out there that do not use MAB and
do not care about notifications regarding locked FDB entries. I
therefore think that MAB needs to be enabled by a separate bridge port
flag that is rejected unless the bridge port is locked and has learning
enabled.

Regarding hardware offload, I have an idea (needs testing) on how to
make mlxsw work in a similar way to mv88e6xxx. That is, does not involve
injecting frames that incurred a miss to the Rx path. If you guys want,
I'm willing to take a subset of the patches here, improve the commit
message, do some small changes and submit them along with an mlxsw
implementation. My intention is not to discredit anyone (I will keep the
original authorship), but to help push this forward and give another
example of hardware offload.

[1] https://github.com/westermo/hostapd/commit/10c584b875a63a9e58b0ad39835282545351c30e#diff-338b6fad34b4bdb015d7d96930974bd96796b754257473b6c91527789656d6ed
[2] https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=c74a8bc9cf5d6b6c9d8c64d5a80c5740165f315a
