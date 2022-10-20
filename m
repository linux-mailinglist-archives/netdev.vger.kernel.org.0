Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32126063AB
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiJTO6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJTO6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:58:53 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1D61C5A68;
        Thu, 20 Oct 2022 07:58:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ljzLE9KP5ea8AmLqZS2zsywgtG842AKJLmwdZMc/AnatYXfhAHDPNikT6/8aCWAttpLtpgZ+0huiQYecWOlfwADe6SgoYx+EQuw4h+KsObZbGPeDtNjIkkLkf5xGn8Ul5FB6w27sAYhseHh+tc8R2WVradz1r+ZGI/FIIUMCNiwGrbMcbhA1VIMxpjeuyaBBR01Pa0pQEL5kTGAJ+0haJZACwbsT6J2JWKJn5yd95ewfooQqGgU/bQxyEZSiWSK6J3PPhLvci9Xhx37pr2EV/89BFUC40JmqxLr1TTSWt8VcrzNECpCQBFLwMAAgQTI67VqLvR6ofg4fjSDgi5Tx7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rDjlAV2B5PLWaEiiAhnQ3gBii1XZvZttHzVQXmFo82I=;
 b=MQDFvCEnsQ/4OQ3EVepXcb0nUJPyncy1P/5iT3lREH71WNktSzkw4TBc3suChG5Fl8InGGwsKrdXTPJFRpGksVbp2HsD+hjwyCSK9iagVtg9IH0G3wI6eQy1oGCU8UDVZnUtzwcv85+D0Of3FQ+QZ6LrDzwSDqWmnjcA89S1YDHR39a4CxBkTF54OeA9ALN4lHVpWrV/5wl9DpYBb4MFVqfGoCQWQQWDWOQ/yn+18yC1Mq++CPmNzNNaCz3mLsNBWhMWKKeeMt2ihvH9OJM6E3FGPeMkTSesXDOMHyXwTuOR6MW2OX5Q4241FlaqCUmFMgBlcb0bhHFMrutFYCyz+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rDjlAV2B5PLWaEiiAhnQ3gBii1XZvZttHzVQXmFo82I=;
 b=PiOk1hZV8RsHJgz/bSeNc/o22QGZtXNazdIr1EydeD43PCfiQtLzD9zjNPIOYtzl1jE5paIz7T5G2FNVlTzXwNimd96TiR3lUXj5/VYAV1BpwT3d962XAYwCew0w0EhjOZ2u4Xi9CdPHWEoGCjg4dQYmy/4e86h9c+89vKQbF11lf0i3K0qE1xfk9N3Op2pdvi2UOZvwEyvEvMM2J2FvhfeK3qU4XVmwv4svPJ1TRV+xGral1Fc8+mNzugJ93bNGYXAMZbCJjrnHR8IOMMYcA4s9ME1lK0F94W9Qwrq8XQYzmA1VKcBjI9on29auusEfCUFLw5YcSbNetMAJryRLgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Thu, 20 Oct
 2022 14:58:49 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 14:58:49 +0000
Date:   Thu, 20 Oct 2022 17:58:42 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Hans J. Schultz" <netdev@kapio-technology.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
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
Subject: Re: [PATCH v8 net-next 05/12] net: dsa: propagate the locked flag
 down through the DSA layer
Message-ID: <Y1FiImF3i4s0bLuD@shredder>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221020130224.6ralzvteoxfdwseb@skbuf>
 <Y1FMAI9BzDRUPi5Y@shredder>
 <20221020133506.76wroc7owpwjzrkg@skbuf>
 <Y1FTzyPdTbAF+ODT@shredder>
 <20221020140400.h4czo4wwv7erncy7@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020140400.h4czo4wwv7erncy7@skbuf>
X-ClientProxiedBy: VI1PR0501CA0009.eurprd05.prod.outlook.com
 (2603:10a6:800:92::19) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB5805:EE_
X-MS-Office365-Filtering-Correlation-Id: ad99cae0-d89f-40b6-812a-08dab2ab9842
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNdsy0RNkiBCjD8dhFRkX2cXPwgNhJvg6UTXAoeN4QvmvgD7zFXIKCL52RwEV65pi6Tcgnea5LEn8Y71x5gJoKyzCdcxf2+JRAayYgMcsBjQXekqQe5432L7x7EN/4bv55z+I30MzhXFKcom21mcNnjjUYJmQ1wdjhEcmYGx1qfbqqYw5OYJ61x2qkziODLD/ciWfhiv16MTD5KmEdvMxQemWb2dYRJRmrX+WqNM80Qoful4nmPiG1zsYzdxWOPrka4dnAHwJtC8PIW1hpsiL4J7uS5/A6ktRBUfeaxuQ4AB6YbyrTraNNhBAXXwz//NmR45AxliEdi6gj3H9ULIKjgshFZKDElcJdHxh2gQmxKjoex7amWjypJKlvpysu6faW6qoTrfG3bb/VZvNvuP5kEAp5tP926X1Kq54OuHFCikRfBONER/2FokV4J+dN4ClqbQyIokeaPW+lsx17GdZqcbcNKQL7X7QUCJffcYNePaiCaOAF89NyUKNDPuLXFFDJIUNTppuoiDt67ScFsv+vmqG5oEGRSgT8bvf8icjicrkq7WhWYpYG5IAc+YN1VKbC3ZZoqusDk2HaJgIiIXxjMBCk9AZPSEbdCXLAYtLnjl65500S8fIWtZSUvyP5CIbfeZH2TqoYWeN43ihGj0fVv3coXgRKc030NEUrX8UIN0k7tOrRgA5HXArGvLGji+TbTnzEjl9IJ5eVfM+rf15Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(451199015)(54906003)(6916009)(316002)(8936002)(6512007)(186003)(7406005)(9686003)(7416002)(26005)(6506007)(8676002)(5660300002)(41300700001)(66476007)(38100700002)(66899015)(66946007)(6666004)(4326008)(2906002)(83380400001)(66556008)(478600001)(33716001)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RPuaKzJ/i9u5icSvS+soJY4vz4ypaM2G4DcURzHmZYUveBsR5v/P8c8tWKJa?=
 =?us-ascii?Q?yTYUhW6gAhsB6YN0DwXRdiiaPhRps5zl7RBIMQDH8l0mCWPPUFRTHCzx9KL2?=
 =?us-ascii?Q?tLk0Q04PR3PfZvM4dsPg7Cw3yH7HMjJFVbhkJ3X1wV+Oo6XduCVR7kWKn3Gn?=
 =?us-ascii?Q?PYpLeiag+NoIEVBmHWdNj8ztOE2qgANAWHExRBvpahEWhYhXSkTWKvz9xE5a?=
 =?us-ascii?Q?PUab6JGSuHkKupektJa/CnHzAmVaAs8HJhwSSxsoOdTmkG34XjUl38CRqGZN?=
 =?us-ascii?Q?58GMe2DbudSX3mkqASCKsLOC+xF74usMNrQ3ucS8nO9Z0ExR3wIlTuj9mEb5?=
 =?us-ascii?Q?2sAApTicvXHk6c6XlZMt7FPo8J2LK6RPNZAGavxoGw66WoPPl8CmV3DIwc/V?=
 =?us-ascii?Q?WkMt9pUybUVsbJzND7SpNQtKF1pR+FiNn0JrtjoqL0ZfHT0QVZp2RaBJT37h?=
 =?us-ascii?Q?YsUJvbokZa4tATWO7pkX1YM+epNIsG8Z/EbwK67oMIR+AXJUZp/c1Af9m3V8?=
 =?us-ascii?Q?Oq68gskXXoHcVVbHmjSYLRqFr8QfNZlp2ph4ne+01oQW40TwjH0eZp8N+R7u?=
 =?us-ascii?Q?P5OOWtR4Gdz2wmM27qLVOPvWE9esPPmkVG5LY8ZO2G2hT9lzAMQdGGWtBR7T?=
 =?us-ascii?Q?6WjXC8dXbmZqUiDM3mcmGbJ9/Q5aSjBGo54GYSH/1mCl14AsW5VFv2s20qbL?=
 =?us-ascii?Q?kCfzsLUXTSIcTE8RN0x0P0W3Y1/Kwr/cpIsh6vsp1z/TjSM0LSoASprlZuFd?=
 =?us-ascii?Q?0UJJ2ye/82LIrP1sk4v65GZeFq9iymuP4Qxw9yGPndFHHoQBsgHxigmlrKmy?=
 =?us-ascii?Q?sV34cx1gSrkhOmWBn0ucNPb39xubHqKyyHpOmDkB91QX72kOV6bKX60/zqZa?=
 =?us-ascii?Q?AjQxz8Htj64bm/ZGoo81xK2wmusfw0fxBVtXM63WKQ9COYO+sUfaHjB/4TIp?=
 =?us-ascii?Q?t0z/cDAAiH5Ravtqrk4xYaolD4Kkpw5r2cAHDY8Og1DBoVpRTsmFbds6fsfh?=
 =?us-ascii?Q?kO0E0yapbK69kzP0rsGYqiSJL5SZMirEaoPzOy7Lvv9iBK+lZgD4ssUxGmDl?=
 =?us-ascii?Q?atb94QzZVsjSWNba8TJgWOxQM0IYg9vaPBNT1EY5Z8gI4p4qlEcY+DuStLUG?=
 =?us-ascii?Q?vMETOfGLnhSDjLsGbImN9X08HKGAg98+rs4P69zS0aP16XGfQLA0qW/v3WOg?=
 =?us-ascii?Q?gJzb84dYHiOvykuVgdA3+dWXBO0BF1grje8pYytzaulppYOUNmzaH/3FYmYe?=
 =?us-ascii?Q?R2eWg7bxBUBQDMvMhn64QTEBQWSJB9wf3/wbqMR6LUAKVuO+WezmByulbpVE?=
 =?us-ascii?Q?v2sbgqPaZDZ1GpgpSVngYn4c+XEJ8Kj6PFQBNbqCKjK8NMSDHTfl6wuymMmc?=
 =?us-ascii?Q?swf+ElQ6iiM2a/NecRkC0axYKONBTJBJZsIlzzzhIyp74FP7XKDIKS407Kb3?=
 =?us-ascii?Q?Baqzns95yIpBQtxwR/V8EnBO18M8d4HboFT3ws8gdPgeD0vBqxNB8y0aLIaj?=
 =?us-ascii?Q?tsJ+lkXKQu/BfIY8RMDARGcPqoibVvQVpaYa046xQ0tGlm6IkcMWabG0e9yj?=
 =?us-ascii?Q?j9GElxm/9sTSdgoTWggFx8bGdnKxunLpgirzVuRu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad99cae0-d89f-40b6-812a-08dab2ab9842
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 14:58:49.1711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L05EuL5R73xa9sdfpppcAJhIwY7gsYt4IuWlbLQVE0HJjUeIo/aD1Fbw+qpLGvQHfmLcfleWTPkADiXFWmi4Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5805
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 05:04:00PM +0300, Vladimir Oltean wrote:
> On Thu, Oct 20, 2022 at 04:57:35PM +0300, Ido Schimmel wrote:
> > On Thu, Oct 20, 2022 at 04:35:06PM +0300, Vladimir Oltean wrote:
> > > On Thu, Oct 20, 2022 at 04:24:16PM +0300, Ido Schimmel wrote:
> > > > On Thu, Oct 20, 2022 at 04:02:24PM +0300, Vladimir Oltean wrote:
> > > > > On Tue, Oct 18, 2022 at 06:56:12PM +0200, Hans J. Schultz wrote:
> > > > > > @@ -3315,6 +3316,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
> > > > > >  	struct dsa_port *dp = dsa_slave_to_port(dev);
> > > > > >  	bool host_addr = fdb_info->is_local;
> > > > > >  	struct dsa_switch *ds = dp->ds;
> > > > > > +	u16 fdb_flags = 0;
> > > > > >  
> > > > > >  	if (ctx && ctx != dp)
> > > > > >  		return 0;
> > > > > > @@ -3361,6 +3363,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
> > > > > >  		   orig_dev->name, fdb_info->addr, fdb_info->vid,
> > > > > >  		   host_addr ? " as host address" : "");
> > > > > >  
> > > > > > +	if (fdb_info->locked)
> > > > > > +		fdb_flags |= DSA_FDB_FLAG_LOCKED;
> > > > > 
> > > > > This is the bridge->driver direction. In which of the changes up until
> > > > > now/through which mechanism will the bridge emit a
> > > > > SWITCHDEV_FDB_ADD_TO_DEVICE with fdb_info->locked = true?
> > > > 
> > > > I believe it can happen in the following call chain:
> > > > 
> > > > br_handle_frame_finish
> > > >    br_fdb_update // p->flags & BR_PORT_MAB
> > > >        fdb_notify
> > > >            br_switchdev_fdb_notify
> > > > 
> > > > This can happen with Spectrum when a packet ingresses via a locked port
> > > > and incurs an FDB miss in hardware. The packet will be trapped and
> > > > injected to the Rx path where it should invoke the above call chain.
> > > 
> > > Ah, so this is the case which in mv88e6xxx would generate an ATU
> > > violation interrupt; in the Spectrum case it generates a special packet.
> > 
> > Not sure what you mean by "special" :) It's simply the packet that
> > incurred the FDB miss on the SMAC.
> > 
> > > Right now this packet isn't generated, right?
> > 
> > Right. We don't support BR_PORT_LOCKED so these checks are not currently
> > enabled in hardware. To be clear, only packets received via locked ports
> > are able to trigger the check.
> > 
> > > 
> > > I think we have the same thing in ocelot, a port can be configured to
> > > send "learn frames" to the CPU.
> > > 
> > > Should these packets be injected into the bridge RX path in the first
> > > place? They reach the CPU because of an FDB miss, not because the CPU
> > > was the intended destination.
> > 
> > The reason to inject them to the Rx path is so that they will trigger
> > the creation of the "locked" entry in the bridge driver (when MAB is
> > on), thereby notifying user space about the presence of a new MAC behind
> > the locked port. We can try to parse them in the driver and notify the
> > bridge driver via SWITCHDEV_FDB_ADD_TO_BRIDGE, but it's quite ugly...
> 
> "ugly" => your words, not mine... But abstracting things a bit, doing
> what you just said (SWITCHDEV_FDB_ADD_TO_BRIDGE) for learn frames would
> be exactly the same thing as what mv88e6xxx is doing (so your "ugly"
> comment equally applies to Marvell).

My understanding is that mv88e6xxx only reads the SMAC and FID/VID from
hardware and notifies them to the bridge driver. It does not need to
parse them out of the Ethernet frame that triggered the "violation".
This is the "ugly" part (in my opinion).

> The learn frames are "special" in the sense that they don't belong to
> the data path of the software bridge*, they are just hardware specific
> information which the driver must deal with, using a channel that
> happens to be Ethernet and not an IRQ/MDIO.

I think we misunderstand each other because I don't understand why you
call them "special" nor "hardware specific information" :/ We don't
inject to the software data path some hardware specific frames, but
rather the original Ethernet frames that triggered the violation. The
same thing happens with packets that encountered a neighbour miss during
routing or whose TTL was decremented to zero. The hardware can't
generate ARP or ICMP packets, so the original packet is injected to the
Rx path so that the kernel will generate the necessary control packets
in response.

> *in other words, a bridge with proper RX filtering should not even
> receive these frames, or would need special casing for BR_PORT_MAB to
> not drop them in the first place.
> 
> I would incline towards an unified approach for CPU assisted learning,
> regardless of this (minor, IMO) difference between Marvell and other
> vendors.

OK, understood. Assuming you don't like the above, I need to check if we
can do something similar to what mv88e6xxx is doing (because I don't
think mv88e6xxx can do anything else).
