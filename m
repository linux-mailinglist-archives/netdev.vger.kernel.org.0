Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449E6606255
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiJTN5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJTN5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:57:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60A91A0465;
        Thu, 20 Oct 2022 06:57:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNig/qdr5m3x6H+P0CTvVckee3XUXB1t1o7y9blk5j32QFGqw434WBkPCDESCG+JuYIYRJSm6Ve/5lSNLQWctxZ7z1u5guoo1DLSsf6gd85QKGzKsva4e/9qTlXlnYh/Nu4pti78eZZYnikg2PkrgxD2MSuwYvJ/5LSP50xDud2ZuqJhVJzGPwbkvRMxMb4CB3l3fGTv5iksDFuLPF8vTSqd5CIy/G/YRCr/BbZZRzuZOdeDjd4K+dH9SzZbKhmE/0zzC9cOjQWef7nZ7W0D8J9GwDf1cfBXavF0ZRz/VDAONaEuXd9hZ3JDtOlQxmt9k1Q3q/Mvp0iTcZlk9BW6uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dm0o9mHop6b0I4FI/6OXQ8r0Zc9OO/jUVv73AkKKGZI=;
 b=Z3EACbDd948iLLnN8Y6VSqL8E4tsaMe+huEGa/bwgJrRUpG9kS8A5sNXvj7DXohy1RLn/COMJ9LS7p723HTYIblPBWT1usHCr60Tw9eix7Wgd4HCWMN73gwJvNj54KfkuzCPS9+HhflCRrhBAdXu21oQRhK833K2uMqoa+1fr98AJohdgzFdDlOOlJ2ZetgLyCvH7WBChQy/vQd4mGsOIc3IiUFWcJ3kNo6OTDM4CiidAO3tUlsfevEAy0GMxLCfa5ZVE1C+QeSWw/b7qh+q9wE6+FBxyPpzBGFIJe30L73Ssi7qWB9lpPp4HKVVDu0b3owxCWAlvT8KxT/hpYawRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dm0o9mHop6b0I4FI/6OXQ8r0Zc9OO/jUVv73AkKKGZI=;
 b=qK5xeyHPLTm06Glv4QwULnwBqxWP4iPXKycUsj7eINgnT/gtSvOSOyg7hqwN1TyWHFzH/0aeO4NvQrFufqupiXCpH0XxiCQxc3DNQCllRc9FRCvv+/qO5h/ansSBS1dZMhS2t3b76dPj1gQIz4/LIdk3o454lgeKyoi3olgsjE3u86GLhoMwZt07ZkTBYXQu2iokYdlFTLBwB6iSTjx1i7iHNhNIvNGykHXs+LeFkR/leX70Izjl1v2DxRtY53r9IF2pkl0dvd9J2WUXwTmoLvti37yGe9fYEOEXr3qR9v63W4tPvtqMVQYG5No32IcExpoJpxJyS8oGsfWv6jxExA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW4PR12MB6949.namprd12.prod.outlook.com (2603:10b6:303:208::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Thu, 20 Oct
 2022 13:57:41 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 13:57:41 +0000
Date:   Thu, 20 Oct 2022 16:57:35 +0300
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
Message-ID: <Y1FTzyPdTbAF+ODT@shredder>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221020130224.6ralzvteoxfdwseb@skbuf>
 <Y1FMAI9BzDRUPi5Y@shredder>
 <20221020133506.76wroc7owpwjzrkg@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020133506.76wroc7owpwjzrkg@skbuf>
X-ClientProxiedBy: VI1PR09CA0185.eurprd09.prod.outlook.com
 (2603:10a6:800:120::39) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW4PR12MB6949:EE_
X-MS-Office365-Filtering-Correlation-Id: 09aa19bf-6df5-4529-e8c5-08dab2a30e29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iCzP986j72Q7q+gjBHu94PJB2VlKBB78HjH0wEVZfF281abRk3MnOI8OohVKgy0ualUPm8OsflgsG2cPyL3MBkxON5HVVQ9g5/Igf8KnSrhZjv1vXuarajSmetx4UT5CTTOZDM7n3xJ3JPa6TH5nkJFznKYkm0geNUtv66c4Qt2quR5Ewm9zLFiI3qnMoFrvmIAaX3x/rek5KugDquKpKGzQ0DIg2dn6WQSnK0n4rrXqabTg4nTQmmDatPGAxeoEJ3Gm6nI0I9ovH01Fug/Evw23W8EZ+AW11tGZFBJ+N9yV3hOEV/RmNamZdlEzjTZOBGxkX9ZNDTAVPUqIuB+RK5fuiIxJj+WHV4eineZYt865Cr1MwTcXgUt5bS9dbyE4pjFtgM/OEa4Zq85O/smp+BFYAPBTmhHO18hyWZWmDJiW12fTnua3QGaeOQryxPDOXLyqcKPyJi1slauS4lHkyoI9PXL/icJHzD/JpoK2xih3M6+9dyOnL0+6sjv621KoM6hN8DAUBhk9ylr0StQPmWDh6BeIdFwe4Ssw+jI82H7i6c/GIkKZXuxkE9uaXfmkHVWRedQf38YtGfMnjIQWaJCSxUB7tpmikCK8GIOCgrOtOB8JB7Q5susRpsmX7Gx0aAHrwHAqYPR8uwpwNI1qWn3G5SU7JWphOaeZaHpiau6ouZZ0obj+CSPuv1pB8GtnJzJqb37FJyJtjKYvlsNF8Ah0xUfjAI2AWAnDclvshr9rxrdAOSR/RXZtT92kEfYV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199015)(26005)(54906003)(7406005)(41300700001)(86362001)(7416002)(2906002)(186003)(5660300002)(38100700002)(6486002)(83380400001)(316002)(6512007)(478600001)(6506007)(66946007)(66476007)(9686003)(6916009)(66556008)(8936002)(4326008)(33716001)(6666004)(8676002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kK6t+ncCllltfie2k/Rsxe+A+hka/f1ATJRTZsLw/A5VMFtQ2h2qCfYZCquq?=
 =?us-ascii?Q?I/lvhVZpoVIRMi4n+E2eciEpcm9oq0h7MPoQG80DQgICEi9OqcpFnAu1O64+?=
 =?us-ascii?Q?nrqWf1Mu09vA1F4uxB7irqJi9etvU83DjipB8cxgBteJCiCahLqL0FI9FEJx?=
 =?us-ascii?Q?thpLWy4gRXaf5o1FYgkrI3lKX4Ncg3SP2ZtlrJ2XiSzt6Bzh0X0TWAhm0Ug0?=
 =?us-ascii?Q?ecklCA9mcxgC7QQqir6pkzzNI+GGVv6a/ZH2FDsbo7evG875dcq2LmSdAegN?=
 =?us-ascii?Q?lrUbY+6F4Ywwg3na9Jvk+Gy8a9fCgU5aA381/lwyCgLIECug++HhguODFXAX?=
 =?us-ascii?Q?TT4MmHLGEd5KdDsXFguu9p65bz/+aA3cfgx1ukl+2C4Ez2FlZzUksPVuHpMA?=
 =?us-ascii?Q?1vHFMSsKYJGL1fE626bgcYGoti6qM4BSkdHBf254MBfll0dGD3qPy+roUq3J?=
 =?us-ascii?Q?R3G1Hi0z96YlMeQ47oFWMFexbi/H1afTgUxSvZk9X2vKO59b3jdsutOBatMC?=
 =?us-ascii?Q?CmEOETcgQnarzx6gHwR+YXza26MsFQAXrY/y3EJ23aXoO3DIyOIY5HvsudDo?=
 =?us-ascii?Q?hM6VyEdif9ijXxok2Z+tAtL1JJHJS8zdZAvxysjUkfa20nSJcaUrtc8onO5W?=
 =?us-ascii?Q?/8L9G2sJv7YIN+5yDMD3RiaJGS/Oikc97IBD2h8x0CheGHvMPtnPol+YSW+4?=
 =?us-ascii?Q?mNEA5dXZcKONhqA9Fln3sCoR2lIhqykWtzIZatZPVzVstKzm90d/5QjETouv?=
 =?us-ascii?Q?yyXxyogFsSW3YvrkqJtIKfJIlDlAQc7Rcoo/CL7bp/nRegnIi2W4n6wj0dyh?=
 =?us-ascii?Q?DfEI7kCNBNtPN7w8oM7AOuiiXpucf2nKW07b9gQ+Jbok2ctngMYltn61ZVr5?=
 =?us-ascii?Q?jZ/Gl0GVB3t6/tHpXsxekleYtuw3FqJU3pESmWKO5dLSiNI6cr3bc0aXc8Xp?=
 =?us-ascii?Q?7XNXHMesARzR1vYmBfJTBWDSiY30F+ztKB27xh6jXVV3ukGa4ohnH/EfHIFU?=
 =?us-ascii?Q?a4KAPexM9L034KAaDCRCvkSPQWNg86ch3zo4cRcm95H9v937t2pzoHkrR25f?=
 =?us-ascii?Q?Q8WGePnfPNMBR2NbaiYLx4EUakkR1dcuV/pX7zgQUzpd/b++1gKc1BAWlTl2?=
 =?us-ascii?Q?IaCqRKhPbdY5FeSFiBgN8joINi4xem9Kg8DUnAxXFr9+NRB/I4UA12Jx83RA?=
 =?us-ascii?Q?4kYVFMSJ6dcbeFLeQEFr0uloJw0QHnPub/cAJWd46p8Ep/llg0QVkZXgihzx?=
 =?us-ascii?Q?UK5QJ24g1ygYLUYqGnKgnb3P/yUZsNPlwfB9xZvmzQkwEWiHsOyXNjVhtkZw?=
 =?us-ascii?Q?pDHpypdLjrBz9gIiI/A6Ky/I3pyZgkgPj9FrqKe8GC1ElyaIIvd53/5WP0CO?=
 =?us-ascii?Q?sUzuVpxHZyoohN4zG62grG3aan1o7czTENdj5lgsNhgBPMhxmDSXsJRKb/z4?=
 =?us-ascii?Q?Sn0E5ozobw+AxIMpH0oIFkBUf4FfIrBbly1d9BrRcgVS6Zdxbng27p47Z0RP?=
 =?us-ascii?Q?YJYlrVkAb4WidL4lIX+ji2LWmdEsca1+hxc+13trLZA2fxD/WI8xMOQ51Hhx?=
 =?us-ascii?Q?YAIHm3T6i17CS/8JNKJlFC1abXnfsU90dgn5qtAG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09aa19bf-6df5-4529-e8c5-08dab2a30e29
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 13:57:41.5418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G/SLzM4cfJtIWT1Rj6DU/PWqAfIic9cbKNRG274eQm+F5Te5MFyrjhZ4Oq7oex5MgYvfC4e7eIZJXNyBH531WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6949
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 04:35:06PM +0300, Vladimir Oltean wrote:
> On Thu, Oct 20, 2022 at 04:24:16PM +0300, Ido Schimmel wrote:
> > On Thu, Oct 20, 2022 at 04:02:24PM +0300, Vladimir Oltean wrote:
> > > On Tue, Oct 18, 2022 at 06:56:12PM +0200, Hans J. Schultz wrote:
> > > > @@ -3315,6 +3316,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
> > > >  	struct dsa_port *dp = dsa_slave_to_port(dev);
> > > >  	bool host_addr = fdb_info->is_local;
> > > >  	struct dsa_switch *ds = dp->ds;
> > > > +	u16 fdb_flags = 0;
> > > >  
> > > >  	if (ctx && ctx != dp)
> > > >  		return 0;
> > > > @@ -3361,6 +3363,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
> > > >  		   orig_dev->name, fdb_info->addr, fdb_info->vid,
> > > >  		   host_addr ? " as host address" : "");
> > > >  
> > > > +	if (fdb_info->locked)
> > > > +		fdb_flags |= DSA_FDB_FLAG_LOCKED;
> > > 
> > > This is the bridge->driver direction. In which of the changes up until
> > > now/through which mechanism will the bridge emit a
> > > SWITCHDEV_FDB_ADD_TO_DEVICE with fdb_info->locked = true?
> > 
> > I believe it can happen in the following call chain:
> > 
> > br_handle_frame_finish
> >    br_fdb_update // p->flags & BR_PORT_MAB
> >        fdb_notify
> >            br_switchdev_fdb_notify
> > 
> > This can happen with Spectrum when a packet ingresses via a locked port
> > and incurs an FDB miss in hardware. The packet will be trapped and
> > injected to the Rx path where it should invoke the above call chain.
> 
> Ah, so this is the case which in mv88e6xxx would generate an ATU
> violation interrupt; in the Spectrum case it generates a special packet.

Not sure what you mean by "special" :) It's simply the packet that
incurred the FDB miss on the SMAC.

> Right now this packet isn't generated, right?

Right. We don't support BR_PORT_LOCKED so these checks are not currently
enabled in hardware. To be clear, only packets received via locked ports
are able to trigger the check.

> 
> I think we have the same thing in ocelot, a port can be configured to
> send "learn frames" to the CPU.
> 
> Should these packets be injected into the bridge RX path in the first
> place? They reach the CPU because of an FDB miss, not because the CPU
> was the intended destination.

The reason to inject them to the Rx path is so that they will trigger
the creation of the "locked" entry in the bridge driver (when MAB is
on), thereby notifying user space about the presence of a new MAC behind
the locked port. We can try to parse them in the driver and notify the
bridge driver via SWITCHDEV_FDB_ADD_TO_BRIDGE, but it's quite ugly...
