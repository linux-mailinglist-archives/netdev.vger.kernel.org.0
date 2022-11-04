Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1ED61957C
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 12:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiKDLkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 07:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiKDLkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 07:40:03 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2043.outbound.protection.outlook.com [40.107.21.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB8B7120A0;
        Fri,  4 Nov 2022 04:40:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lndyS40M6h6AnHlr/xrDZju9tqPSRmi/Tu9l4OwWhDTyLWYuZgLN5Uud3SUkcX+H6N4ZBJ84uizCnBwMBgRWUTIJB3GPfcw4XzeXn91RtP6k7HijHeVUzRUr0axYrjj2Vbxe1l162z3kRPc7tp319Qn64Rj89wAknlRqDs2dumbqQu188ibe5T7MYJ33T/g2XBoiPN6vLIgXAhUm9ioopDDj3vuU/pzn5lVeqGB/Ensqn+QmodDNWcWwkoMOlAwds0CqHSdNgYlQEz/i+G6xyaaiJ8rwSM9QCV598RkaG6h10fwMCbpWyAQ6gNpU+rZkERpdkbfuF0mf1XXPB/i2TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EoecqDn/DXcKTWwBYqVT29HoB+o+gdGMgt1fkPOQbiM=;
 b=ocKHONeRHqzxc9UrawGe8Pj1FixOUzh2dqYBoojYIXSnzXHetBgyLc2pNnz0ZXKfDpic0p1SCPXvj6WW8qQeXttwXnMvGrAdg9RAoBdoRNrTa0Re0hsylD/qRRDyr105TNSJuJ1b3VeNQ8m3KGGMEuM+9au5mAG8aZbIc4IsOMpQrNyCbx/KR0Xj9RUbb3by4k82+e9XLFraeJEjsHl6tbFb0CGCILI6bwE2Acz8icsQL9VsKo3y9fAMZiksg0HQeo3kWKUfUaoNSaY+w1FQPFkYske8mHJzH/E+AYAB8Pqkm4MEi1pkD3MBcntVGr6jY2FkOgSZLh2x+CkcOk+5sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EoecqDn/DXcKTWwBYqVT29HoB+o+gdGMgt1fkPOQbiM=;
 b=5gdgmyTu9jp6EnEZxJizpCFaTzsZxvFT8ne5Hl/pQ3YnSUy2NNEN4L64HBbRgM5C1QpLYoi30F+J6g52Nrvf03GpGrgVRo2DLU+EKztfwgAwarRzcFjhhuOsrCRwql/9kAqKsqUCxUBgDltNjJRHw7f5w9NC7aZEWuvn1HchpRwZlfzTw63oHDzISYMkavLh8Eu7uYQKzvH+mJA/3B4xh8jqxrwkHTWTJnRRCW0EMsa4E4Ruz2xdSNROWW2d0imsN/a9RWD4KuabiTYKu9H/oR7pCsjv0VQEeEMpDW0wlXxOFaJrwx7uKpMjqFAgcRqZmGOBIW3v/NRq4ynAwrSbNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by AS8PR04MB8643.eurprd04.prod.outlook.com (2603:10a6:20b:42a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 11:39:59 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::2120:d5b6:79db:16a5]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::2120:d5b6:79db:16a5%6]) with mapi id 15.20.5769.021; Fri, 4 Nov 2022
 11:39:59 +0000
Date:   Fri, 4 Nov 2022 19:39:43 +0800
From:   Chester Lin <clin@suse.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Rob Herring <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>,
        Chester Lin <clin@suse.com>
Subject: Re: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
Message-ID: <Y2T5/w8CvZH5ZlE2@linux-8mug>
References: <20221031101052.14956-1-clin@suse.com>
 <20221031101052.14956-3-clin@suse.com>
 <20221102155515.GA3959603-robh@kernel.org>
 <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de>
 <Y2Q7KtYkvpRz76tn@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2Q7KtYkvpRz76tn@lunn.ch>
X-ClientProxiedBy: FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::18) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|AS8PR04MB8643:EE_
X-MS-Office365-Filtering-Correlation-Id: c22322f3-b438-42b5-4a2c-08dabe594d73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m2D88KBL/+UZTKzHNXKZHPGI1kEt12F17sKvzl8QxoWKxanY+ah8pAr/vgke2cHAoZOuyNB8bgc/BWvBS+NbYaW1gpnTP1ciCQzpwkwRYD9CJJzxo1gYqlKw5phPfHtrK8b/LDFLrgk17ZSvmNKCAh6lntrwqlzkRGux+80qK6otrA2BTFQf6tN26O0lA1OxjyMzs6fko+GfTejunpH62PREiO0iGQRq3S7q2v3vFgbYCq5RM1BZpZ56vDweeksaQyYiJNAt8JF1ZMx6d67dWDjq07JGYL/5NPkEat0RhFRWgjnQmIPjSN3/AA0w8KF2sn5oY8avsHbvlEJ2g5hk3tyv3VFVYjZZnqLzA5fyCCEuJ1/TqwRa8LWFFrRoNx3jqwpHLNGxVsnpfaPIPuL9vuJomgK8KbAfeDt6KYoLW1SVwHoEML/GdojJy16HHmbZTg0bzl0sEAc8w57DS8MdF3R3q8fqeBe2g6K7/zdkrZYNucAYlPMCKnHIXA7ryXuLP1fVT+buUe4OmKC0KvRUbjVtuV/FNSRx1+AUE1Aw0j5kgPpXbVqkelMJuyjmnxnlHFQa17/7FsuQ+1DTAR5uHZJ/xRlpp14Hpzt5HzvjOkdvYXUNfr/iJQ1DA12IJo0BbIpND5G9HN3zNQrvh3e/7ZmvZoFmruBZ8CCkAMwUOyg2jRnO+/BK63PS0Ti2TybxwJoJVaUmXzLKi4o9xLasV9JM3LhUIl3yMgI+luh2mNQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(366004)(396003)(346002)(39860400002)(376002)(451199015)(83380400001)(2906002)(7416002)(8676002)(4326008)(6512007)(66946007)(9686003)(66556008)(66476007)(26005)(41300700001)(33716001)(86362001)(6666004)(316002)(107886003)(38100700002)(5660300002)(186003)(8936002)(6506007)(6916009)(54906003)(6486002)(966005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Lhf5uA48vQ7iml1gm30RHA8IJhnyHLVQgqXZvxwXb5Cml0HpDB4GHWRVUv9J?=
 =?us-ascii?Q?8AntfRC4RNmh8s9rP/jTTbie/r+GvqfgeM4/Ov3DwHrSzOMu9/I49F9Zls0p?=
 =?us-ascii?Q?FR+ELM78qCQth0y/S7/6o+g9nXe6M2lSKOKmQwYRBgnOjk61uF4hBbQyP+65?=
 =?us-ascii?Q?M69XwOL/PMROZhLmbcbRz7IflGeaLKileoptDgFIon+YKfCrZdedkjp0+R5P?=
 =?us-ascii?Q?4ziwqO86F9yGv8R4nw6AFrYmDtL5PPXojHQW/BHVEIJMCXXJi8o/pys+89PS?=
 =?us-ascii?Q?i3YRChIBNUhQNq5XoBCkYeVaLe7vGYqk/KSDc6clYRRAcQECpxA6gnXx/m++?=
 =?us-ascii?Q?EaZZ1PE000tNZPh0rW22Rzf6Rqsb+N7a67B7DkwjuY784OGxSyd2shGeVKw2?=
 =?us-ascii?Q?29StC+3/z0TuSRnsFfyxzxXWf+Z+qOf0h1uB9fY/Mi8JzppCD1EBqI2WOvx2?=
 =?us-ascii?Q?/wZiFmHXC0F4Ne89A4kj3l0ORzoT0J2vfmFcOi4njdh1ackJfiJ1YR/IThSD?=
 =?us-ascii?Q?a8ZZRUQTf8pL28i1cxwHDT/8GGjZx5ws7zb+6Lu23POyMV7I1WZQPc4w6eHM?=
 =?us-ascii?Q?qs85aT6G1OjOoNL7UALaOlcumvEAs7WMQv5He6eHCziAjIHku/EnCzYOqw/D?=
 =?us-ascii?Q?4i96nbadG+PvW13I5+vKxHWfB7yltUtxn6srCl38txXtykiOt+12VyzD47C2?=
 =?us-ascii?Q?yTd0rTDBSD2KXF2ndA4tdrwBZS+AlpcD0QWcDn9qzi7vaSQmhjkvN0LpTGad?=
 =?us-ascii?Q?3Vt6ajQ8PNv3NDnd5KghNDLRIjGGWb8b6qjDuMZUETFSlIFvXvxmcfTIydFS?=
 =?us-ascii?Q?+S8WyDO+JxXn33zVTRj4Kaxn5bfi8TmzRVqgpJQlGtZpbJT82nXRr+flA5p/?=
 =?us-ascii?Q?tFXyHcvdVVbuubDLlMn92n7ACU05/r5paiD5iaKsDFONimLnbx+l28pa01DH?=
 =?us-ascii?Q?YZfkboAYypBVJ2d0zM5qwP2O7O2fOSx4G5krCXagdTXt2rCrBzzCeKsP+WoC?=
 =?us-ascii?Q?A6J5dsv7tsc7MlNKC5DaO81Vx5YSj6tOe6+qk2j453JV3fHyUUwKCrgG337d?=
 =?us-ascii?Q?kFQ7FXm7kHbeJ4G+xYppQor/Ok2q9T5CfyfTPEf9URC41VvvyB+304aWS8p2?=
 =?us-ascii?Q?9ChpdXdcp/Zj1bPRA6IOawhfT2WioOwY5xoC/lQEQ80VsdmcAHjUK4V1JS8L?=
 =?us-ascii?Q?n8BL4K5PP9wddjTOUmEnoGr748oLr2N1HQMESlh9RSRFoUtNOiAFraXaWUpw?=
 =?us-ascii?Q?a1mLXYgQsIVJ6VdaeehYGHCJaTMKGpfs6S0wQkt5ncxf37IWTn82mUGgaXS4?=
 =?us-ascii?Q?u/6Y9PkQfHC1AYhISr9A4E/ADOncApswyufa/c/7dApkmm9z3KsuAt1CV3cF?=
 =?us-ascii?Q?1lxQ+2ryDOh6EwF/DDx0/15aTzauYLz5r4TP/xaTEQw1B1MaNK+t9UkJO4ec?=
 =?us-ascii?Q?jsCPHQA5d8DYue8GuIZcOw+yW4BotgHPmewTztkxayRS2nWBpQog4GR5sbAJ?=
 =?us-ascii?Q?zwDkuGsYxg8OEXOeL2yA28KTyHfTKG67UwQdOJcvVL4C8ydVv9FVQlkGctKo?=
 =?us-ascii?Q?VfBAERKXybRpk4fMnLw=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c22322f3-b438-42b5-4a2c-08dabe594d73
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 11:39:59.0551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0YVA0ShnyCsgPgYSQ4IO2+nFWz4wbry0IK3CYn/YpmaBmyN2QehjQLdlJlFjeJ8U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8643
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew and Andreas,

On Thu, Nov 03, 2022 at 11:05:30PM +0100, Andrew Lunn wrote:
> > > > +      - description: Main GMAC clock
> > > > +      - description: Peripheral registers clock
> > > > +      - description: Transmit SGMII clock
> > > > +      - description: Transmit RGMII clock
> > > > +      - description: Transmit RMII clock
> > > > +      - description: Transmit MII clock
> > > > +      - description: Receive SGMII clock
> > > > +      - description: Receive RGMII clock
> > > > +      - description: Receive RMII clock
> > > > +      - description: Receive MII clock
> > > > +      - description:
> > > > +          PTP reference clock. This clock is used for programming the
> > > > +          Timestamp Addend Register. If not passed then the system
> > > > +          clock will be used.
> 
> > Not clear to me has been whether the PHY mode can be switched at runtime
> > (like DPAA2 on Layerscape allows for SFPs) or whether this is fixed by board
> > design.
> 
> Does the hardware support 1000BaseX? Often the hardware implementing
> SGMII can also do 1000BaseX, since SGMII is an extended/hacked up
> 1000BaseX.
> 
> If you have an SFP connected to the SERDES, a fibre module will want
> 1000BaseX and a copper module will want SGMII. phylink will tell you
> what phy-mode you need to use depending on what module is in the
> socket. This however might be a mute point, since both of these are
> probably using the SGMII clocks.
> 
> Of the other MII modes listed, it is very unlikely a runtime swap will
> occur.
> 
> 	Andrew

Here I just focus on GMAC since there are other LAN interfaces that S32 family
uses [e.g. PFE]. According to the public GMACSUBSYS ref manual rev2[1] provided
on NXP website, theoretically GMAC can run SGMII in 1000Mbps and 2500Mbps so I
assume that supporting 1000BASE-X could be achievable. I'm not sure if any S32
board variant might have SFP ports but RJ-45 [1000BASE-T] should be the major
type used on S32G-EVB and S32G-RDB2.

@NXP, please feel free to correct me if anything wrong.

Thanks,
Chester

[1] https://www.nxp.com/webapp/Download?colCode=GMACSUBSYSRM -> Membership
subscription is required although it's free IIRC.
