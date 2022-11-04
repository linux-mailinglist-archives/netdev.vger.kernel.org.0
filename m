Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FA16199D3
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbiKDO2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiKDO2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:28:07 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140049.outbound.protection.outlook.com [40.107.14.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DC031F8C
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 07:25:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfBqpxefgeSmOlv/GIVx6NQR7U0GuJ3XhQBq1xh7IIZVEm7/Y/1BGRvrjoWXN9tenrCosoEw2g4Fgf7cFqeOSH7aDG6ciejB2V8IlaSMheTFb64cxNfZKxrBjDLopla6SJYaYK8ZyXMb11sIqoVv9hGXOtSJsdoe2fZW+o6qza8FV7cea05DSYSy1BNQ8Mr0Tp61wcSz7duiaE1nPOzYaDDAgviTlSuK/9K1eK0lg3/MfkM+5d04tCGjbJ+kZc9YDUTZdz4taIV8vNXTqXu76NQc/NhBthtjNQtFR21tMkqqYzo3GyQVTvUXLVunqXbD0P2bbw0bc0vCSA+XtVnukQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxm6Dtme6/6MPHWtqX5k2LVCfUmfD7wn/ReG9h4LRT8=;
 b=gUtjCzBIF3qgm5Q/+j3tjVpNjh1GnGv6vGlZy2wJ/NXZbF8EUhHLwAzEU13rJWEax2qfmsj3+35BvqfaPd1XoEFd7DPtF9LAz5p73CWXrn01qxau44VPyc7qc7ZQay1nBSq0BWekBY4jC2UjOCxEKW4Oo/gHqsJKIJQlWrb2/hdwMAdXrPT81Wy4ov1SLQpoJ7sZ2CsdgSrpOCPEPhHvvBqRoqkxmZjKf2lBvRNfrGrtVerpjURjiLqI/f3a9W2EsR8kXPz9ogM5V3eJ9MORQQXAK4/efXjXH0wjEQfucpHmURsx2FSVSeb2twvZvudHxsVvsCoL8aQDKZ9FRZ25+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxm6Dtme6/6MPHWtqX5k2LVCfUmfD7wn/ReG9h4LRT8=;
 b=P2CtRuCp3OvMs6+1FdoURhYYgsSr5DIpFQ+fIvMFSy6yVt465ix4ZLkruIF3ll4dH2IotQOgR1kB3qvJx/WLMIMOGYU/6f5uo8ZDXjSRKa+hPsLmdn/emVZWDj+x+B04DKSirPeOjiTapzNfcniNaYRwIUxUUNb6oiQz6hphvsQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB7095.eurprd04.prod.outlook.com (2603:10a6:20b:11c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Fri, 4 Nov
 2022 14:25:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.022; Fri, 4 Nov 2022
 14:25:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Thread-Topic: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Thread-Index: AQHY7efc5i1n/1Oz0kGxX/wEp9VJma4upEMAgAAC6ACAACDfgIAAB/SAgAAG3YA=
Date:   Fri, 4 Nov 2022 14:25:50 +0000
Message-ID: <20221104142549.gdgolb6uljq3b7kc@skbuf>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-5-vladimir.oltean@nxp.com>
 <Y2T2fIb5SBRQbn8I@shell.armlinux.org.uk>
 <Y2T47CorBztXGgS4@shell.armlinux.org.uk>
 <20221104133247.4cfzt4wcm6oei563@skbuf>
 <Y2UbK8/LLJwIZ3st@shell.armlinux.org.uk>
In-Reply-To: <Y2UbK8/LLJwIZ3st@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM7PR04MB7095:EE_
x-ms-office365-filtering-correlation-id: 2e177f9f-4f05-45ee-e988-08dabe707930
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c+BtyWcr18QAvGndWDa5aJSWKHdhhc/9nIezw8f1r5oi9IjwryUHIwMW/bpR7SJt+q+rOPBPMnhtnuM48I2DRB2+3B6PWbgJrsfQ3RCjTO6LseWSTHeLNnQQH5RNK8NrCGrQ0ZsLagqo59nHAC6DYmG5wQCgfpfVnWWoa0wWe/kg1sz3HQzmGrdCp9uf39TJgh3z44g4W7ndZJ/3fsrL2gST2HYvxXkFYfNpeNbNs6LkgDo+AhtbuEQMGm6rC4QXghC2NyTOwFBV4+5bQah/lbLkSx27TFw43+/w674Hh09MYVO9kq+3d2enD3kdGsoQrXcwSHn/Zji/Ju1RoocAC8XukcnWcZZeDSMWj/o6YHMKQ3MMmFyPJIxkZpDEnrs2Wxl7GiCumF2GNtCKqbNldqXwBaaUXwtU44nK4Mf7RJSketK+ifYwDmyF/qK7QgyaRyQTLBd0VY4o7vvh+JrwuiBcVxpA7b2Ayaa5fEXMP2L//V8ZUap6XTQSSR+JIEnqYnP5NT9TT40z1c0PttsNow5SITQ7s6My1KrBzNxCgRU1oZHVJz5/pzAOYppbVhDZXPIKi1AJzHTA1tgrLAIclwgdP+MmccQ6/344D//SJv5iVC/O2Q1959VZx72yClUPIHWrivwkDFm05PrQSyeACvtnJ/WyegMd3oFgruxPfKP01fd3/ocaayETjGH8JEIKxGYjiJiYmTSqH9+p/FeEi8nMtIjYMWDlXDPBN1/ZBnwugjWZWow5p4dxf1eflWMtMDa8+66/xtMFBdZ65wnGn4GV9N96vgUS8CS0gu8jLpU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199015)(8936002)(66446008)(26005)(38100700002)(478600001)(38070700005)(7416002)(44832011)(9686003)(86362001)(122000001)(83380400001)(5660300002)(2906002)(8676002)(66476007)(66556008)(66946007)(64756008)(6506007)(33716001)(316002)(1076003)(966005)(6486002)(6512007)(41300700001)(54906003)(71200400001)(6916009)(4326008)(76116006)(91956017)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7SXFrFDYZRGG62TrajbzPxqlN+pgzm/aG6vEkjekHjIT4Xsv7G1UjhmcICjg?=
 =?us-ascii?Q?44t96ACqko3YmyjosOQnHTGXN5KMtAiRSr9JSyaqTTT0TFXUjpDC4pWtnzxN?=
 =?us-ascii?Q?bVKHeceXavlwx5t6PFe1sMHpt6qJxH3w3sMhpCTsUhRsgX5WjMGjG47r2IkT?=
 =?us-ascii?Q?pteiCWOPkGeWI0GZ7ekqdFlYnvpHMUjtcYYfqIQ1Wpz7IaaRZ2G4ZzWEDRNH?=
 =?us-ascii?Q?7xu1Dp+GxHsq/qitt+OvfVbc5ew+UB4EJOmpPDZcrjvbWPf/mpG93mmHp7K3?=
 =?us-ascii?Q?uY8yULunZajb96WJnEG9NXYKcUWBkioohtebPyKRbhtJt/NTR13UsIlPtuJL?=
 =?us-ascii?Q?IALYLt1VrvJDJgHWSbUCiKjKorxiAUZBIkQHGJfCLNJxs39xLrGOCilCftaI?=
 =?us-ascii?Q?O69t5uaUHI7micxpznC5sfD/iCTa/93SMFZ5jcB50CWwDudDhpOYfSRoIV7E?=
 =?us-ascii?Q?VsJ8EoCcJ0dIrDmJhCYKqV96/NgcffxThHreNKXyTVBWj1PpM0jQkLCSb7gF?=
 =?us-ascii?Q?esZIoTj/kA5lp7s/3zWYMh9sThPlg4Z28Uu5/7Bj2biyhQvnn4CMX1gozna1?=
 =?us-ascii?Q?4tiabOB5KFtFLOc/xzNESBzntbHT9trlX36/5ciP5Joc20euDsMPif4extH1?=
 =?us-ascii?Q?rgA/4XPSHOv4BLnzC9tV85xWS67U9oeHG4uy7tpr1RfxMsNqQiKoJDFBCToN?=
 =?us-ascii?Q?OsIk+8Id7pnhRGqyeXono3OnqT+JGE3ii+zsB4+Tjz8iK6fcZMPG090IPiQC?=
 =?us-ascii?Q?LcOzqzDsDXGOnNffB5WvRkqlJTaA15gB2X7exAJIz3YtiS2CzBvgXzlrQd8G?=
 =?us-ascii?Q?rMXvWj0nfPswKuDTClYIr0OLLffdEGTtIcxcNrCawxlazwkBE+47m060QrHa?=
 =?us-ascii?Q?elpID294iW8joZzjv/i9lNVOtO8wtDiqv+NEabix9GkUylYRN59RJs9X08WE?=
 =?us-ascii?Q?5PU4anTQPUJC8IuaDLGxSbenjlXLZ3F/1lb5KjqSIq5h71US/nzOXro1EQpt?=
 =?us-ascii?Q?L5iuvI0t5z1hkFCKHF/Wnn0+l9RjTq4MN/Omttaz61jLR7z7AaA0bn9sRAC5?=
 =?us-ascii?Q?Y+D3asoqc5pppQpYodAqZc1dyUUIa/C+u8k7wNWJJTBfbt7rXzAdAmooOTDO?=
 =?us-ascii?Q?nFzH9zZ6tF1fS/rD/LtaYYEO2Ki2Spdd1CUfCt4NzaFN6Oi9nnJWWzsNsJLK?=
 =?us-ascii?Q?nbjexiUIRhTlNtj4yH/hSWTCAjovLNKwc0IrQx0MIvmwwFNjKDMvsP0jBduW?=
 =?us-ascii?Q?yvpxXppk1aSBQ10dvipxC1WhdsMiLblVCO/InzgDrlsEgMrkjIQa2LpL3Xv9?=
 =?us-ascii?Q?NPpnr8DnEBXwrDe4eSIchVlz6VCPoAgyHmDIOuqFGCoXPyBLgvwXhyRblJs3?=
 =?us-ascii?Q?7FKCAD1L4msmfU6A5thLJKfq5xYiobrg+GrBCUyTf6QnN9kYttBMvszsPFd4?=
 =?us-ascii?Q?8m3F9bG3tftzjedt7vhJIRoGQf49sEVV6Lj3/CG4+CtXwn7PjJCw1TVWw3Oi?=
 =?us-ascii?Q?dmtmHIljJQbvybyXr9VWxSrGyYwkHwtj3ThFj2dVkGKaCPgrh8TfxyXyVtWS?=
 =?us-ascii?Q?IjEN6Wr5cEpghM/E1eZO1gQqB2hIGhACchjxBDj/zM1K61WHBCnLLRFPCRu3?=
 =?us-ascii?Q?3g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6C286AB9FC88F74FBAEAF481471610FF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e177f9f-4f05-45ee-e988-08dabe707930
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 14:25:50.4897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rE117OITk/uY9Dd4n/P7s/GTuX5y7LCe7M27zCqR+vKRLXHIYAHbZ/QWwbUUnN62V5x9pP08YOUNhy369KpNwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7095
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 02:01:15PM +0000, Russell King (Oracle) wrote:
> On Fri, Nov 04, 2022 at 01:32:48PM +0000, Vladimir Oltean wrote:
> > On Fri, Nov 04, 2022 at 11:35:08AM +0000, Russell King (Oracle) wrote:
> > > On Fri, Nov 04, 2022 at 11:24:44AM +0000, Russell King (Oracle) wrote=
:
> > > > There is one remaining issue that needs to be properly addressed,
> > > > which is the bcm_sf2 driver, which is basically buggy. The recent
> > > > kernel build bot reports reminded me of this.
> > > >=20
> > > > I've tried talking to Florian about it, and didn't make much progre=
ss,
> > > > so I'm carrying a patch in my tree which at least makes what is
> > > > provided to phylink correct.
> > > >=20
> > > > See
> > > > http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=3Dnet-queue=
&id=3D63d77c1f9db167fd74994860a4a899df5c957aab
> > > > and all the FIXME comments in there.
> > > >=20
> > > > This driver really needs to be fixed before we kill DSA's
> > > > phylink_validate method (although doing so doesn't change anything
> > > > in mainline, but will remove my reminder that bcm_sf2 is still
> > > > technically broken.)
> > >=20
> > > Here's the corrected patch, along with a bit more commentry about the
> > > problems that I had kicking around in another commit.
> >=20
> > The inconsistencies in the sf2 driver seem valid - I don't know why/if
> > the hardware doesn't support flow control on MoCA, internal ports and
> > (some but not all?!) RGMII modes. I hope Florian can make some clarific=
ations.
> >=20
> > However, I don't exactly understand your choice of fixing this
> > inconsistency (by providing a phylink_validate method). Why don't you
> > simply set MAC_ASYM_PAUSE | MAC_SYM_PAUSE in config->mac_capabilities
> > from within bcm_sf2_sw_get_caps(), only if we know this is an xMII port
> > (and not for MoCA and internal PHYs)? Then, phylink_generic_validate()
> > would know to exclude the "pause" link modes, right?
>=20
> bcm_sf2_sw_get_caps() doesn't have visibility of which interface mode
> will be used.

Update your tree, commit 4d2f6dde4daa ("net: dsa: bcm_sf2: Have PHYLINK
configure CPU/IMP port(s)") has appeared in net-next and now the check
in mac_link_up() is for phy_interface_is_rgmii().=
