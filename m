Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4796D59B28B
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 09:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiHUHIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 03:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiHUHIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 03:08:15 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on20613.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::613])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D908CBD2;
        Sun, 21 Aug 2022 00:08:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YkehRxApCDlx5mksUbMgwOss+fuxRwsrxpHlna1zb/8ob9GQ6kNJ1XJ86dPYGZIFgYEX73/vipLWluvDBzhI579j6w6+jpNczEUNDhUkLET5KHFU4lEm+TkHAZ3dHgS2xoEq14TKQoggMwWJ+3dEOZB/Bbs+ZK26iCpgzIOa+dWmaOtIAH19AW0Ulf69p3FsyKmQ6tXzwlkqtSexPtss6dBHAV3O5Z5EgeJOu+Pqtk2ST6SFodUWtW2qwnudVy4IF4VpKbVVRfTUgWJj83oWUN5GmhY/mPUvnE+gFx0+ojLZlqIWw0bkuj92Zo5rfN3mN4I1sa/SN4G/cr+R+xmS4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FFtX7f56EAJ2GK79rUwPSBrE9QN6y3cP519VS14ZrEE=;
 b=A/G0QE6QoGO4MqMES0Swzd4EJrpsLQBEa7sgorPxBAZKsNbGOZqdy7WDFrFhSKK0qMgR4a117PLQhfRO+OBXbJARGaYjp4QIwdPb+JP+R9yOJP7vI4QuhBura2k0vfWjXXqYWB/A5HajKSCmB+gH+1BHMKQLsap76eaY3wK5QYoRn6HL0Wkhp4xz9rBAEE+Opu4a/y1LMOJLgOx1bMHbJTMoIiSyJYhKAf5WY2XAkPTBlTpM7YeLeWU/lkqpZiMF1evstekF628KYDaWA4blhmp4vP2+tfFZAX4W8D5q+Fa4gULaCeITYCxpsdrCjgj9b85YCX8XTh5n0dw2VMTW0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FFtX7f56EAJ2GK79rUwPSBrE9QN6y3cP519VS14ZrEE=;
 b=jvmq3wPXLTB7VaUGnhFdDN2JZyVrcfAUyW8BSIgkQyzSsqjhK74Wg3ztndfjTXAF59NaECuTgneE+NsdK7J7pN5yfERY+hffTkV5bEwloVeXcP7/we6VX/9N9aJA/8h1q3R1gYg3zvA081Uo9uOnH0GZECwgKqFOokx3r2K0iSjvTTU3KKIijekleTd1wir1t6XPdNP6Z8hHFZJ1Hc4pbEqsT109uffZaMRZFLjll/wQ2OUVNa61ZN2vm3wuZAkbXEpoY45FIJTiPbm/5txfbQAVBL1EK7YFtaUtLxqKGO6VXva6TLCbWqqjykgxmm3Rh6vrcQw7o4XMEzldVzJORw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by BY5PR12MB4036.namprd12.prod.outlook.com (2603:10b6:a03:210::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Sun, 21 Aug
 2022 07:08:09 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5546.018; Sun, 21 Aug 2022
 07:08:09 +0000
Date:   Sun, 21 Aug 2022 10:08:04 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <YwHZ1J9DZW00aJDU@shredder>
References: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
 <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
X-ClientProxiedBy: LO4P123CA0089.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::22) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca2c8474-d42f-4911-375e-08da8343e711
X-MS-TrafficTypeDiagnostic: BY5PR12MB4036:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGNNlrjuLBD4x2TsrheXDg5N2qPMT4+3zrE8GM60Bd6YedXWoCETiWswLIQq1H1qrysnRgbDoBIDr65ayMVbgAWmDwS+34ynXB/EEEzjyVD1d5ncmPudJz6G7xVQLhNMkHLyfX/Tnk7aAbwrCDllpPsgfc56esgrev4Ly1uezKR19v+rw3URel6JRJxTz1kxhN9uVLVJ6COUOxdgNRh8EJbNDf5g+e1EcK5pTZdT3tLAo+omCBDNPydH73WxTpA/Uc3xc4+V36/7PsWK6QkqmGusGB/HbT6RKllaWIlRXXLF4SjfOQ+41u2VHJbNoWBePz2Y55ld027BEoQB4qsrAJruci2hwS9tU/Zf0TS+HyeiMFkr0poxMfAOFTHEJZyIc8Wfm1Er7emG/GT0I/m4b7yhMNFELOFWvUyoC9GuMeAknitngvPKlwdzucHBANxCcX0Wp0kUDeDmC6qschkWsEWJFPfaO3Bo471Pmp4Md/no775vllaDqN93wTdYptTa/SpPsvyyXNmqld0ORkTVbX7MlPS9fM6mY0HzWrPLZJYkrTGTT2+jQ+ElIl306t9QXB1lbGXsAeqTnaW5pZnxty7R4mVLDPNOg1V7fqtVmOIcbf2balEyDBKUsqzsbljlH5FZ2itnq17CljgVNYqZKTWwtnsZO0q7RKMGUTyKZWELGo/ZRPfVJAWCXvWz0PdAauLC5JD53aH9G3UUc4KvHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(346002)(136003)(376002)(396003)(366004)(7416002)(6666004)(8936002)(5660300002)(33716001)(6486002)(41300700001)(66476007)(4326008)(316002)(66946007)(66556008)(54906003)(478600001)(8676002)(6916009)(26005)(9686003)(6512007)(66574015)(6506007)(2906002)(83380400001)(53546011)(38100700002)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iEROivNvcCuYgmdFzJSHQ1IKqU6JJxXtIeswS5cAIn+i30DMMRF92OYauj5N?=
 =?us-ascii?Q?C2eB135YcDlTFXz5YCRN0otSWUqv2hSE1MS9dHVjb1SSyttPN7+UgQ1dR1Xx?=
 =?us-ascii?Q?tb5pXVftfMr5uWNN7pu4VDT8kMqqjTn0NyJTiyTpEv/eIhGVzC0gsYZzy1iD?=
 =?us-ascii?Q?MKAcj90sUaNVPBLY5jHk2g4Fgct0+Du1/3Jn1b7St6+tuxqDPhiTnZgJwHoz?=
 =?us-ascii?Q?yJaZDDHRYvjCAYlo4j+asrClUOR7pT2fnn6ThpHGjTZ6t8oskd2NprvnFe4y?=
 =?us-ascii?Q?O8YJm8cw5WzCiyt2MdApVxZuj+97tBwerU8JaCb0MYQ8bOFvlmhT66OwSp6j?=
 =?us-ascii?Q?SVpEzxZe04ENvYTGYdznUGuTFIOz0ZetmSOExvguw+Exa8q5GloeiudlHwhv?=
 =?us-ascii?Q?/xrheNvClPSmJ0vYNezaQTljgdx+AmvjDxQI/5Eg4ezWTUBIBoe5jBjPuf+8?=
 =?us-ascii?Q?7F6ijk2+gqKywrQbA2zRV1wQH8xCpu6iKJmO75NvenPS1CFgVfO+rM70IMjl?=
 =?us-ascii?Q?yPHs8nc0u24PhZ98DbmwrDSumqaQiq5xv2aATNDHC0xPzAme0QazF2HeolQy?=
 =?us-ascii?Q?6FWcVCZ5pjVd7foipT7ply8F6m873X25U5QlBOWuH/NKWJHD8+5qf9T+z/Qx?=
 =?us-ascii?Q?A69RqqNgLP4QSQudfKyJMsdFuw3ggm39VZeqg0lZIIVSxAVyVye9d1q+tfDb?=
 =?us-ascii?Q?2feN5L6UIeMtuqfonYPRuirmTnpwekTY8B3OUJY9XulZn1GU2NblWmVFhqo8?=
 =?us-ascii?Q?lhKE7KHFCrnvtVQ8F3GfNSqBaM0FW8Zb/9fq7v2pCVaARiZgUoJ7Z5Lig+kz?=
 =?us-ascii?Q?s/RQgsE/YM39+tWfTeSLpS7YNEQWY+7JCKayNGO1Kdfr6/PKMk4d2s9a9GmL?=
 =?us-ascii?Q?Yw9QpiGSCFE3TtLwdh2vTwXR5yUQr1DvvAyeXQRQ0Lv0o4uTlVLCcrO4gqwS?=
 =?us-ascii?Q?ROJECUzP7JuaAxEIQrdxJFFlVALH+zEi7otMjWBi32pfsT90CC17XdjYOf/m?=
 =?us-ascii?Q?yH2rU1X31eDnG8LzPp+kx1haMhtTcArAHHodJ4dlLsWxS50aeoT4zdjJ83+p?=
 =?us-ascii?Q?GfAYTPdaSp+tyUNPmaOrFtvEJCWzIA209eQJZh9MWBHck1b82HgnRZ69Ctju?=
 =?us-ascii?Q?Xt4GX5svA3kbWqcxVCowg8EZRX19egOTPB91zXRkQl49RIK0vTFd52sMaHx4?=
 =?us-ascii?Q?EjLevL86toJP3VufYO2dWrR7JLm6gU96yu+NATh8YqBtbeNPKl/Gvr2Zua1u?=
 =?us-ascii?Q?6ZKj57M8L2BEXGqmk3zdmAWzFsTCQ6OKFt1qLrNMA4lkpoR9u7/M97MAzCoZ?=
 =?us-ascii?Q?dtG+G73fQUaWD+Ezp9p9AVYWZwB76F7dxkLB+Jj5WJKUt5cSdeJqB8vw3LMJ?=
 =?us-ascii?Q?1qITgQWHIil/q5ikkiSz+/cVkIrQEAUwixp5bxb5Wt++B9FY6q1Dn2kMzOZj?=
 =?us-ascii?Q?JTyXwoQLzIBiZMq7Dqwp2mAAHKUimC+QneXvdV6E/Tvj9TmaWvh7F7fVT9OZ?=
 =?us-ascii?Q?7UUcYZiVOup4x7IVrWsuVXx7nRrW4B3jvnaxpihO7y4tkCoAyaQC9iT3LSv0?=
 =?us-ascii?Q?SWgsWIl0o+RT7Lzf2H49f1GZEZmj1e4fRx2DHTQ+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca2c8474-d42f-4911-375e-08da8343e711
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2022 07:08:08.9996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dDLK76gGfUtqHgacaUz9OLMM/gVB6EiDmC1WLLR/8gttOLVu0Cpqrvi8wSPu8ooLbAIcdaosUjlyYdqppuiSBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4036
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 11:51:11AM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-14 16:55, Ido Schimmel wrote:
> > On Fri, Aug 12, 2022 at 02:29:48PM +0200, netdev@kapio-technology.com
> > wrote:
> > > On 2022-08-11 13:28, Ido Schimmel wrote:
> > > 
> > > > > > I'm talking about roaming, not forwarding. Let's say you have a locked
> > > > > > entry with MAC X pointing to port Y. Now you get a packet with SMAC X
> > > > > > from port Z which is unlocked. Will the FDB entry roam to port Z? I
> > > > > > think it should, but at least in current implementation it seems that
> > > > > > the "locked" flag will not be reset and having locked entries pointing
> > > > > > to an unlocked port looks like a bug.
> 
> I have made the locked entries sticky in the bridge, so that they don't move
> to other ports.

Please make sure that this design choice is explained in the commit
message. To be clear, it cannot be "this is how device X happens to
work".

> 
> > > > > >
> > > > >
> > > 
> > > In general I have been thinking that the said setup is a network
> > > configuration error as I was arguing in an earlier conversation with
> > > Vladimir. In this setup we must remember that SMAC X becomes DMAC X
> > > in the
> > > return traffic on the open port. But the question arises to me why
> > > MAC X
> > > would be behind the locked port without getting authed while being
> > > behind an
> > > open port too?
> > > In a real life setup, I don't think you would want random hosts
> > > behind a
> > > locked port in the MAB case, but only the hosts you will let
> > > through. Other
> > > hosts should be regarded as intruders.
> > > 
> > > If we are talking about a station move, then the locked entry will
> > > age out
> > > and MAC X will function normally on the open port after the timeout,
> > > which
> > > was a case that was taken up in earlier discussions.
> > > 
> > > But I will anyhow do some testing with this 'edge case' (of being
> > > behind
> > > both a locked and an unlocked port) if I may call it so, and see to
> > > that the
> > > offloaded and non-offloaded cases correspond to each other, and will
> > > work
> > > satisfactory.
> > 
> > It would be best to implement these as additional test cases in the
> > current selftest. Then you can easily test with both veth pairs and
> > loopbacks and see that the hardware and software data paths behave the
> > same.
> > 
> 
> How many loops would be needed to have a selftest with a HUB and a MAC on
> both a locked and an unlocked port?

I assume you want a hub to simulate multiple MACs behind the same port.
You don't need a hub for that. You can set the MAC using mausezahn. See
'-a' option:

"
   -a <src-mac|keyword>
       Use specified source MAC address with hexadecimal notation such as 00:00:aa:bb:cc:dd.  By default the interface MAC address will be used. The  keywords  ''rand''
       and  ''own''  refer to a random MAC address (only unicast addresses are created) and the own address, respectively. You can also use the keywords mentioned below
       although broadcast-type source addresses are officially invalid.
"

> 
> > > 
> > > I think it will be good to have a flag to enable the mac-auth/MAB
> > > feature,
> > > and I suggest just calling the flag 'mab', as it is short.
> 
> I have now created the flag to enable Mac-Auth/MAB with iproute2:
> bridge link set dev DEV macauth on|off

You have 'macauth' here, but 'mab' in the output below. They need to
match. I prefer the latter unless you have a good reason to use
'macauth'.

> 
> with the example output from 'bridge -d link show dev DEV' when macauth is
> enabled:
> 1: ethX: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state
> forwarding priority 32 cost 19
>     hairpin off guard off root_block off fastleave off learning on flood off
> mcast_flood on bcast_flood on mcast_router 1 mcast_to_unicast off
> neigh_suppress off vlan_tunnel off isolated off locked mab on
> 
> The flag itself in the code is called BR_PORT_MACAUTH.
> 
> > 
> > Fine by me, but I'm not sure everyone agrees.
