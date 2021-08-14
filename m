Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A80433EC48A
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 20:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239005AbhHNSlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 14:41:16 -0400
Received: from mail-bn7nam10on2092.outbound.protection.outlook.com ([40.107.92.92]:34400
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233713AbhHNSlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 14:41:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cN36BEYNGftDV4k99LzpJzM7qCE70+XZv719066uBOHzDysPODSRsnHMwrIXFkiAqGQMdOlY0Q3N2cxvwlScqG92fPGJnORB0oKWBhTVsCGBQ92W5Uneo2sc+UlWe9s9MTerK/pIUiKgYDXYT6G07GF303rnFv2eNni2Dds7LekPILB0lKv6+/+jvyPHeIHQbnA50LB6s1ZLfDMevlsMNJi4aR3edDh+d2JrvhopIOchyS1hk0lgp8bZBoZGImV8Y5tam5TF1q3SBiColRK/ShZR3sSPoLywI8YDtxmh/hyyNCrWEyf09fNCQOn5bssDqeULRGU2OPDdgVHYuyOqfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kr2r2Ngn1gcFBVPUa8Pej5l7xFYevbHkC5JWBO9Lqf8=;
 b=AnkJAiiREruAeBse8KjRA1OJMyq3gkio3mrIn8V5HhBHolqwwkUAFaaYTKYQh4x3dlisr1/uWix8LMhElxtVO48+9wbPpy6FTv6Jisv4a0/9u1eMcrIKhz1gEFRgkywTglVOpCsjF6kfWMYkPYwPA+W4uDBeItWsArtl8LCUMYsjuPpqrFKCpe4SuscEaou5Wj/XZBWH6pKutlrFzaes/GufMglcUz7eviiRA3S1b+Gt1OaLhfRh4Awhj0M4Noq6PBjbqE0L2L/5BqlnTorDZPsuhbI0kNOv6hB0Ybpkwp74xk6AxDOg3lNoor/z/e7UHEZ5kRT7vcoirHPXIvFMGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kr2r2Ngn1gcFBVPUa8Pej5l7xFYevbHkC5JWBO9Lqf8=;
 b=HePrG9vDSqPXQnoZJQMPLcUzrT1iNkhNMqMGA9gNuA3lkinu+Z5hhgrWzFqgTv3Tq/ReM6eBnyNlJKBGzga9MwB75iRehHHu7qPqSji0G2CtCj649tMZ4vfXDLWDAszIpXwM7ud+0VYHxUssW/+VV0CLLLdFINihqzwQ712TqIY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4401.namprd10.prod.outlook.com
 (2603:10b6:303:6d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Sat, 14 Aug
 2021 18:40:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 18:40:43 +0000
Date:   Sat, 14 Aug 2021 11:40:40 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 10/10] docs: devicetree: add
 documentation for the VSC7512 SPI device
Message-ID: <20210814184040.GD3244288@euler>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-11-colin.foster@in-advantage.com>
 <20210814114721.ncxi6xwykdi4bfqy@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210814114721.ncxi6xwykdi4bfqy@skbuf>
X-ClientProxiedBy: MWHPR21CA0030.namprd21.prod.outlook.com
 (2603:10b6:300:129::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MWHPR21CA0030.namprd21.prod.outlook.com (2603:10b6:300:129::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.1 via Frontend Transport; Sat, 14 Aug 2021 18:40:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78c661d4-6551-4a75-a6df-08d95f5305d1
X-MS-TrafficTypeDiagnostic: CO1PR10MB4401:
X-Microsoft-Antispam-PRVS: <CO1PR10MB44012731196AC2D46A93E746A4FB9@CO1PR10MB4401.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2jkaGGuMFPAzyDmG++25kWLgfaMRzsc1ifdhfFfIFRP+BPKSFMkd2yoGSir926XKTbj2MTJwGL8zorAQZC6eH4+AfsW4tk31BE4GmIgzEPhMmBXHJIztCjld6t39SkwVTg0Eh6YB35vxr4XNC1ZsrxiYV7QEp+cptCZfuSTHftHk48v8SC8qzxJ8CgwkyuciygVq403KTWcTuVzt6CKt6a65Nwefft0z0C6pz3/lX4lcK4/S5QdA+kvvpLyqhfl+6QEBJ+UfIYWqbIXn2xk5spZTiEN2nZuLSEeMQw/frgXWahG21raBrad8XkYWVNpMdB8Rsj4rbMaFa0J801iUvfWDCrNar3Eswzt2DqrkF+y+rFdFwo86jJ+EJJpT49sAHa99xHKOpYA8Vhf62HWWLr8VFra/LX75bjlT6tYf7WySe+wEtAU3hTtqgO20YMruZccCeJN4SmR1W1VyhAAlvvIA8ysiRwhl81auB2kcUPkj7tU70JMdIAlO+9wyZPTxo0YGt/HszLJ6sIdWU2rOG+oDrfysHRpTn5NCmLZoWMAknCs8Y2zLppUd5OGl7lxfiv30GS9MBftRLZT/Mmk0vS4k3rFje7vtpxTDifPdgPc6u6Oz1Fg4/Zpvtixw+GurCQJ56Ym5PUiKsj83zS11pei+vAiisPODhJOcEAtpFIBWej5ZcFdq/A4whlWy7fz5AROc4+CNAi/1lv/kSGr6KA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39830400003)(136003)(346002)(396003)(366004)(26005)(5660300002)(38350700002)(8676002)(6496006)(956004)(66556008)(33716001)(316002)(186003)(8936002)(38100700002)(44832011)(33656002)(66476007)(86362001)(9686003)(478600001)(9576002)(4326008)(83380400001)(52116002)(55016002)(1076003)(66946007)(2906002)(7416002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1ogxzDBZbtZ6BLg6rw+oa2Jj3XMHb46V6J7C5LCqp0riDz33bzKG9kCkXiWq?=
 =?us-ascii?Q?iHSy7D2c2Zqrqw8n5naVIpG2Jlk6EC6rVL8w8BJepDrc/gpEbwqIfY/137FJ?=
 =?us-ascii?Q?i97Zt27uC81spfPJtMsvLEjGQbKe7TIIfzaflQ5Y9z12kDeCPQoMbq22Atfh?=
 =?us-ascii?Q?F+yg6fbgFZbof2riLr9wtjdEy8L42hTw2nm56NjzQYvfGjDJ/zvBBCWBePnp?=
 =?us-ascii?Q?QXEb8SY42U4LaEb98kAVKt3R1EYSx96jBzfAQ3c4iFRdg8uBziLtxRvlB8Ty?=
 =?us-ascii?Q?lm/e5dbvVVCWzGSS+Hh/jHPF41ZPFEfpMr9ALevcrwcduSX9SCEp6BO9IpT+?=
 =?us-ascii?Q?CW4P7D6JmU0/LnrSdghHUahmf9vz09eMkFARrR1Xhawa4Fhpx/1ztiNb/t4d?=
 =?us-ascii?Q?JMhM6MOh7qJS1ZQ3f8w6fnWWCxLXceOfnAF1oGHWHwTlL17eJv/DReLWAGE/?=
 =?us-ascii?Q?I2Gvi3V+eVV6tiicLfZ851xSZM3MKk0RbYPS/XqUdC62tSZjsk2R0ZCEdmNe?=
 =?us-ascii?Q?c9E9Z1h0gDeeGY1saPHF/CAzKBH+hNsrEfgL6J0piZlsl0vJ8E5p4igeeRk6?=
 =?us-ascii?Q?dwguQOGbrkwLQSrDGXhwJGBfYmLBK7aEF2/cKPGTG871yzywhsMTgKwWjglc?=
 =?us-ascii?Q?89e4bK+03bmZVqtaL0CUCKn6vLAiS2wZGzhOM9FMrchvwtP+gTTMbxeGGwQL?=
 =?us-ascii?Q?LNKrG0amJ1IpyZ/D0rpFwZgaVCmWqxaZ9zhB5yt9IgH5iRfqoF19+5sEtCWj?=
 =?us-ascii?Q?G5OyG5Skc2uBtNEnUhRRFRHCbaioOdkvPOi3QM4nCMbhuG2aNEtmozllZGuh?=
 =?us-ascii?Q?BAlGp3T+TjlEvIY+HktPQ0Lu/0nayEQuZ73ZeyQMZ/E4b7ymFwBPumJyL5gG?=
 =?us-ascii?Q?jNM+T7/BQTdMj7J+fMGFnMdCrPw6OmXvr46ngh0KBsK598oBfpgBP0ITDfFr?=
 =?us-ascii?Q?eooooTV2uVTpn2XfBLpcAouzmlIdzOkR2FiVDkkoGBy+kLJGB7V/hrrrf0N6?=
 =?us-ascii?Q?22mj6l31DzYEUIrmSeXSH2KGEiTFVKGK79yHGmUIq/dZHeeZuyggDR+8rNYv?=
 =?us-ascii?Q?mDIsDo1AAcjx0UCl/YbUytiP/Bl3dBM8oR0e0e7UCGS2pGJLopbUcbIVQQCM?=
 =?us-ascii?Q?X9IS4dWbdr2pOUqYVp72XogsID97FWcjGftQhU0sEc8LgtZYToJUNkmfX0gk?=
 =?us-ascii?Q?88AsOnQQ/Q1ZwgzXReNmd+Ng+e6mk40Ed8S0yJFQfPhElN5zFpVX83q0MV4E?=
 =?us-ascii?Q?ZlasqcwN4MKla7ijC6sXpCTtm/OydNvUkR8Sk5/HyLJmjCS6BDafB/+j36ae?=
 =?us-ascii?Q?JpSAMrfWp6IALik4FZSdApxE?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78c661d4-6551-4a75-a6df-08d95f5305d1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 18:40:43.7314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nl3z/L5gboiQSNWHBv7RIcKaS+io5X+ZEftMD9l6n7clf49NiaoYfpc24QLMbRIy6dJMlTKpLnZtsMjYvtPv6YSJrklju7j6kYF4OfVl4jE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4401
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 02:47:21PM +0300, Vladimir Oltean wrote:
> On Fri, Aug 13, 2021 at 07:50:03PM -0700, Colin Foster wrote:
> > +* phy_mode =3D "sgmii": on ports 0, 1, 2, 3
>=20
> > +			port@0 {
> > +				reg =3D <0>;
> > +				ethernet =3D <&mac>;
> > +				phy-mode =3D "sgmii";
> > +
> > +				fixed-link {
> > +					speed =3D <100>;
> > +					full-duplex;
> > +				};
> > +			};
>=20
> Your driver is unconditionally setting up the NPI port at gigabit and
> you claim it works, yet the device tree sees a 100Mbps fixed-link? Which
> one is right, what speed does the port operate at?

Good catch!

I made the change to ocelot_spi_vsc7512 yesterday to set it up as
gigabit, tested it, and it still works. Previously for my testing I'd
had it hard-coded to 100, because the Beaglebone I'm using only supports
100Mbps on eth0.

# phytool print swp1/0

ieee-phy: id:0x00070540

   ieee-phy: reg:BMCR(0x00) val:0x1040
      flags:          -reset -loopback =1B[1m+aneg-enable=1B[0m -power-down=
 -isolate -aneg-restart -collision-test
      speed:          1000-half

   ieee-phy: reg:BMSR(0x01) val:0x796d
      capabilities:   -100-b4 =1B[1m+100-f=1B[0m =1B[1m+100-h=1B[0m =1B[1m+=
10-f=1B[0m =1B[1m+10-h=1B[0m -100-t2-f -100-t2-h
      flags:          =1B[1m+ext-status=1B[0m =1B[1m+aneg-complete=1B[0m -r=
emote-fault =1B[1m+aneg-capable=1B[0m =1B[1m+link=1B[0m -jabber =1B[1m+ext-=
register=1B[0m


Of course I understand that "it works" is not the same as "it's correct"

What I wanted to accomplish was to use the speed parameter and set up
the link based on that. I looked through all the DSA drivers and
couldn't find anything that seems to do that. The closest thing I saw
was in mt7531_cpu_port_config where they set the speed to either 2500 or
1000 based on the interface. But nothing that I saw would explicitly set
the speed based on this parameter.

So I think there's something I'm missing. The fixed-link speed should apply=
 to=20
the CPU port on the switch (port@0)? Then eth0 can be manually set to a
specific speed, but if it doesn't match the fixed-link speed I'd be out
of luck? Or should an ip link or ethtool command to eth0 modify the
speeds of both sides of the connection? It feels like setting port@0 to
the fastest speed and letting it negotiate down to eth0 makes sense...

To ask the same question a different way:

I can currently run "ethtool -s eth0 speed 10 duplex full autoneg on"=20
and the link at eth0 drops to 10Mbps. Pinging my desktop jumps from=20
about 400us to about 600us when I do that.

Should I not be able to do that? It should be fixed at 100Mbps without
autoneg, end of story? Because in the current configuration it feels
like the fixed-link settings are more a suggestion than a rule...

