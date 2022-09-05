Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499AE5ADC06
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 01:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiIEXyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 19:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIEXyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 19:54:18 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2051.outbound.protection.outlook.com [40.107.104.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B7F51A06;
        Mon,  5 Sep 2022 16:54:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuOWkSHFqCCQlkhmD7/2rqxocBS72+ZvQ3Xl2KuP3yoVmtK+Gh77vn8E2KK8lFHO1uvKE54snrlSqR1BpASgMnyXbzKxntQQdiUDh1NYm08+9P3Ev0/2frZGkVe75Tth4P9rPDd2ayW6LrNOztiyyFdGemLuCTL7CiIYGMjG3K8c3HxtpAcpWDIJeho6OT2HYNrf7D5Yx88xLDAjt9vgy6bRRyeZQcv3cA3rEqs6zi23DKmdB8ukr8aug6zbNxZu8prlQ244TfvNdBmjAiUqTsUzARURhIDzpCLlz04OrfSV7lBhfQM0rA597N08uZH7UfK2TwQfGeiadOAYS6vrSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITLWPEgPR6mnCcRsaF7aygSIRd+yn0DYQ9iTOMDmQEE=;
 b=I+JQt+wn6/UasOUaHSd9488BhbNl88Oc4dF0jt2ZVxDSJwnJhaw1lxVI7nD9m+s+mTZ2CF2Or0zzEkAGnvi7/Lf3+rujcKUSvgfY2bNUi1OkYV8Fr+b7D34gwg8lNzs3kbO+EWPU/Sl/dfNRa0BP/M5nBWZIk/05sliGwkCyl89GO4LPeocMiuVgz/ChlCYN2odlylh3BPtzCB/fsZSYc3W30s4+zqHglj7ct3wMTk+8vNbepEP4FvyOF8+7/t6LTfXpSun95jf8ShCF9GbFYHSJNtH2H/HjR09wHGUrBSOaJlGgCbTE2EBG/6JG1cUpwWN3CweeGQP9CawV7YubPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ITLWPEgPR6mnCcRsaF7aygSIRd+yn0DYQ9iTOMDmQEE=;
 b=gtEEJqaBy7DxT+5rLGqBE9SRXlCzGRClOh6ClguFJUxNRHipMJZtRWNuXzOuY6i7FWlmDKw3a184jgtIYqNbtYBYViQQogVh0fFwsvGjLwI5Io5yfymfn2gLk1wp3qu4+2DgaAj1OIuI+siE7x8nNfD8Rgl2jkJ3ocPIZF8WmBA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4771.eurprd04.prod.outlook.com (2603:10a6:208:c4::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Mon, 5 Sep
 2022 23:54:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Mon, 5 Sep 2022
 23:54:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH devicetree] arm64: dts: ls1028a-rdb: add more ethernet
 aliases
Thread-Topic: [PATCH devicetree] arm64: dts: ls1028a-rdb: add more ethernet
 aliases
Thread-Index: AQHYwW37dzULUFcX/0OQXQkpZmzQZq3RZ7aAgAAbB4A=
Date:   Mon, 5 Sep 2022 23:54:14 +0000
Message-ID: <20220905235413.6nfqi6vsp7iv32q3@skbuf>
References: <20220905212458.1549179-1-vladimir.oltean@nxp.com>
 <d00682d7e7aec2f979236338e7b3a688@walle.cc>
In-Reply-To: <d00682d7e7aec2f979236338e7b3a688@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9fe55502-b611-46f8-2646-08da8f99eff6
x-ms-traffictypediagnostic: AM0PR04MB4771:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c485J7tBJSAyBc/8kHTXcIR8HoCzKajIwZHOFeSc6Q5mVO1xXgbUjA990oXfOGdWPTcoOBVjrx0wXWN1H8e2KqaZfeNJfGLlHlQllEmXyMFyGvCHZyE75Vwytt2ob1SgMgkajuZCsR5IApUOD7fwCY4FjDOXkB3tCWadextqk63efOyds8q0n49LaXlB3GaWylpP2Lcuw+OIanJnb6wWtw00LujWz4XoblCWwtLeZI9mN5MCy9Mpdf3wLEBaVQJXxenKUE5GdJh1gtGpwtMzfF/AbPE2k2MExjM0zKC1UUifwtRlbsxJhnE+JsIual6HuxYpIFv8JYk1t9jiHNp+FHsaLcSHPzc2Nd6oN58y1x65VpgO7rYTOakEjyFvtFGVh2LuoACArs0fOV61Rre9Duhj16PnhTbnAYIdczUEvovUlV6ScxHEnTraARwwGdn4O7BPE1M/VGkyXWVBnLhrndc5jQI6DNwfeHalyljRguqdKbdDzcJO9/RHjXSIEq2FJCklRWhS4qhB25kTblqm6rGUmAa5mLUe3Edc8VuMUP+nvmbLf7yGI8ca6p1AYDHxXgPO1V/bLksvye5MaSH0jRfrO5OaxXeUpiY+T5/tSNdh58UXNBSRlyV3JDYkDuP+MgAFFIplbVGJVEEthGVw+eu96ucnXzO4c749tOqW9bmePvsVk2uMlGPAeoW/kMTfoPTbAd7EN1toZIygIjRXWZE8+OdO9JOg+eBPBUiTTfQNOIJhZIySIcJ5CGwS/ngqy4AmzPLwkMsSoQGA9RBoEVlM6Atmc0HngADni8cRbvKFAc5jFdA0brZ4CM0zgas5u9uWeAe6Ya0HkFVf7XGEkZRwvuzMxwrT6egqU9cZ0S+RpajLHdCN4voeKGRmachi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(136003)(396003)(366004)(39860400002)(346002)(8936002)(478600001)(122000001)(186003)(1076003)(38100700002)(71200400001)(44832011)(2906002)(6486002)(966005)(5660300002)(66946007)(64756008)(6916009)(316002)(66556008)(66446008)(54906003)(76116006)(4326008)(8676002)(66476007)(86362001)(9686003)(6512007)(26005)(66574015)(33716001)(83380400001)(41300700001)(38070700005)(6506007)(414714003)(473944003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZLnaGfRoj4jLRtS/2vVDEIb43aSL4f6PeiTkdj3zd6zJfCdPdJVbq0hPMOsI?=
 =?us-ascii?Q?x9M2YOtM1WfRZu8TriYGweauhJ0/qgzPKlsmN3rRBC+bII/SohyVnfYrbPAP?=
 =?us-ascii?Q?UdV39VzmJpMLdn7gazCXPzNpCYtKVcm54Rb30Q83zWTARzfLGN1X5oaAo9b/?=
 =?us-ascii?Q?zfhNYdHDPqZOMzLhbvq1+O0gxS0zQUH2O6amy1bA4CUewwvi17eQVYFO337Q?=
 =?us-ascii?Q?l0rRvw4ovR6Rqzanq5tHRdhbKqwKt8ZaZ+ABigQGjqn/0sa9Q4kN2cioQxiN?=
 =?us-ascii?Q?oZfLtHh7W5wLnDpbPxEPrjxQRbCMpVaJdChuYPXwTHvss5tdCwm88YI3OFZN?=
 =?us-ascii?Q?HurxV4TlO1LE6vbnKO0aa7WTAZxHkbv5GMGUIiALdYtPEfQVS79oQOYbZkMm?=
 =?us-ascii?Q?t8VMg6EHZu0GQFmy5BD4tWbpcZPGvDqQsdxwE4bx03y9SOPkXESx+XV6HboG?=
 =?us-ascii?Q?8p+ZVMOvQwCdnjy79a+5tLBJAXe11HqYtnSHqhoClu9TI5uFZH7vcxa+gc0L?=
 =?us-ascii?Q?AnUnUGI/095yirRK1kPrXsIgDXid09swJtgfynrTeWdQrYVq1XXH1y4DT8B9?=
 =?us-ascii?Q?P+F3+hsfSiYtu8AZwVVsklnIa+54VLN0wXOXbPPab6/jb1BTzohEE6Xy4Bsv?=
 =?us-ascii?Q?CavF8I8m5vEMR+F/9iVUiD47p0chO3n+GY8uofYGKJXq1ahb1INHiUg62IUB?=
 =?us-ascii?Q?xT5fUpG+0WIIrOC2Rw2aecu66GuXZLga7IiKFuzerbBCDEoKxSuA+UyPkLj7?=
 =?us-ascii?Q?K/Whfk1+3my03W5ZEAkxoZGaG6ykCSQ3xhSuWQJzAqVbX+Il75pGaB7jsBYA?=
 =?us-ascii?Q?hMbRNg+QFaxkkG9RqY9ckay/bLkFQen2KpaghcHpWAdfUBHG16PcYAUO2+mf?=
 =?us-ascii?Q?FgyZQdDE3XqJqHgIIVH4IhDZmkJLIcCiuEoKaiyOcKrUIlV26D8pUC6ChGjd?=
 =?us-ascii?Q?gNuujUnyyj8VRsiSGRF8hKbcKnySE0iz53+qGj22IjY+HET/FKEaVfbFrfXm?=
 =?us-ascii?Q?+WSzE3hy5n3HbVrwsXwW9d1ffOAioMyYv0xYAQTN8FxGpE58xQRg0IHA7O4j?=
 =?us-ascii?Q?0SZ1NJ5hMm6BbQWjSn2XhNHywvXKph5FDFfbtcNm2CEFg5qpaQrvKZh6snOa?=
 =?us-ascii?Q?T+K7/kaM+KvdL0174PzVmQY8ReW/XFDFtCuoraOovxKXxGkfzdPLlCPvjOk9?=
 =?us-ascii?Q?A9NxlauYHrX4Ltsvtynw5TbiNgwNbQw9oNWf+Q2i01JUTznTO2D30oMqjkah?=
 =?us-ascii?Q?5OtVDfXjRW5TgDTj5Glof5O/KmtzkB0TKErq2XTtbMxcrtDCE1k4LF+BU/Ti?=
 =?us-ascii?Q?gDv11007MwD4mkLU8dmTE1I9rHh34aKR0EMRQh/dCzGQuImmxILf4pXcOyLd?=
 =?us-ascii?Q?WI0v2v/XuPiRn5tVF9Uwhe/9Fk07Yw7axXYPPGkSqWEeGOXFbrKHVqaHb0Bi?=
 =?us-ascii?Q?z9UIw85dgob8nSVr/WOvKFvwh+n+m77wSHxnHRux3x1k3qF2d/LKJdCTZE+b?=
 =?us-ascii?Q?RSfDAGS3omzvlmo2sN+M5cRyoiazFBpD0JPYOIRcxw2QSFK0xmIhnsVDRm0B?=
 =?us-ascii?Q?9i8n9s6JImuBqKwi0Q8/i0w4+Eik1Pb1YY016HKxovUwE5npTBXCgUfcyiqb?=
 =?us-ascii?Q?Mg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <43BCFB0AC6C8454AA19DFACC2BB0AACA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fe55502-b611-46f8-2646-08da8f99eff6
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 23:54:14.4532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ae16PL9EzMLASflTxNZMhkz0kuCutJk9pVWBJepoXvTLgzQQgNKcTUq7TyZIp8hOdGtKrxYvjWyzgspGIZjSlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4771
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 12:17:29AM +0200, Michael Walle wrote:
> First, let me say, I'm fine with this patch. But I'm not sure,
> how many MAC addresses are actually reserved on your
> RDB/QDS boards?

AFAIK, the Reference Design Boards are sold with an unprogrammed I2C
EEPROM, but with a sticker containing 5 MAC addresses on the bottom of
the board. It doesn't have a clear correspondence between MAC addresses
and their intended use, although I suspect that one MAC address is
intended for each RJ45 port (although that isn't how I use them).

For the QIXIS Development Boards, I have no clue, it's probably even
nonsensical to talk about MAC address reservations since there is just
one onboard Ethernet port (RGMII) and the rest is routed via SERDES to
PCIe slots, to pluggable riser cards, from which Linux/U-Boot don't bother
too much to read back any info, even though I can't exclude something
like an EEPROM may be available on those cards too. In any case, I think
QDS boards don't leave the lab, so it doesn't matter too much.

The way I use the MAC addresses from the sticker of my RDBs, on a day to
day basis, is:

ethaddr (eno0) - #1
eth1addr (eno2) - #2
eth2addr (swp0) - #2
eth3addr (swp1) - #2
eth4addr (swp2) - #2
eth5addr (swp3) - #2

And now I'm adding these new env variables:

eth6addr (swp4) - #2
eth7addr (swp5) - #2
eth8addr (eno3) - #3

So I still have 2 more unique MAC addresses to burn through.

> I guess, they being evaluation boards you don't care? ;)

I do care a bit, but not that much.

> On the Kontron sl28 boards we reserve just 8 and that is
> already a lot for a board with max 6 out facing ports. 4 of
> these ports used to be a switch, so in theory it should work

/used/ to be a switch? What happened to them? Details? Or you mean
"4 ports are used as a switch"?

> with 3 MAC addresses, right?

Which 3 MAC addresses would those be? Not sure I'm following. enetc #0,
enetc #1, enetc #2? That could work, multiple DSA user ports can share
the same MAC address (inherited from the DSA master or not) and things
would work just fine unless you connect them to each other.

> Or even just 2 if there is no need to terminate any traffic on the
> switch interfaces.

And here, which 2? enetc #0 and enetc #1?

> Anyway, do we really need so many addresses?

idk, who's "we" and what does "need" mean? (serious questions)

I'm not sure I can give you any answer to this question. As an engineer
working with the kernel, I need to roll the LS1028A Ethernet around on
all its sides. The Linux RDB/QDS support will inevitably reflect what we
need to test. Everybody else will have a fixed configuration, and the
user reviews will vary from 'internet works! 5 stars!' to 'internet
doesn't work! 1 star!'.

To offer that quality of service for all front-facing ports, you don't
need much. I know of a 12 port industrial switch that entered production
with 1 MAC address, the "termination" address. It's fine, when it's
marketed as a switch, people come to expect that and don't wonder too much.

> What are the configurations here? For what is the address of the
> internal ports used?

By internal ports you mean swp4/swp5, or eno2/eno3? If eno2/eno3, then a
configuration where having MAC addresses on these interfaces is useful
to me is running some of the kselftests on the LS1028A-RDB, which does
not have enough external enetc ports for 2 loopback pairs, so I do
this, thereby having 1 external loopback through a cable, and 1 internal
loopback in the SoC:

./psfp.sh eno0 swp0 swp4 eno2
https://github.com/torvalds/linux/blob/master/tools/testing/selftests/drive=
rs/net/ocelot/psfp.sh

Speaking of kselftests, it actually doesn't matter that much what the
MAC addresses *are*, since we don't enter any network, just loop back
traffic. In fact we have an environment variable STABLE_MAC_ADDRS, which
when set, configures the ports to use some predetermined MAC addresses.

There are other configurations where it is useful for eno2 to see DSA
untagged traffic. These are downstream 802.1CB (where this hardware can
offload redundant streams in the forwarding plane, but not in the
termination plane, so we use eno2 as forwarding plane, for termination),
DPDK on eno2 (which mainline Linux doesn't care about), and vfio-pci +
QEMU, where DSA switch control still belongs to the Linux host, but the
guest has 'internet'.

> Let's say we are in the "port extender mode" and use the
> second internal port as an actual switch port, that would
> then be:
> 2x external enetc
> 1x internal enetc
> 4x external switch ports in port extender mode
>=20
> Which makes 7 addresses. The internal enetc port doesn't
> really make sense in a port extender mode, because there
> is no switching going on.

It can make sense. You can run ptp4l -i eno2, and ptp4l -i swp4, as
separate processes, and you can get high quality synchronization between
/dev/ptp0 (enetc) and /dev/ptp1 (felix) over internal Ethernet (there
isn't any other mechanism in the SoC to keep them in sync if that is
needed for some use case like a boundary_clock_jbod between eno0 + eno1
+ swp0-swp3).

> So uhm, 6 addresses are the maximum?

No, the maximum is given by the number of ports, PFs and VFs. But that's
a high number. It's the theoretical maximum. Then there's the practical
maximum, which is given by what kind of embedded system is built with it.
I think that the more general-purpose the system is, the more garden
variety the networking use cases will be. I also think it would be very
absurd for everybody to reserve a number of MAC addresses equal to the
number of possibilities in which the LS1028A can expose IP termination
points, if they're likely to never need them.

> This is the MAC address distribution for now on the
> sl28 boards:
> https://lore.kernel.org/linux-devicetree/20220901221857.2600340-19-michae=
l@walle.cc/
>=20
> Please tell me if I'm missing something here.

My 2 cents, if you don't need anything special like in-SoC PTP, 802.1CB,
virtualization, and don't habitually connect ports of the same ports to
each other or do some other sorts of redundant networking without VLANs,
then there isn't too much wrong with one MAC address per RJ45 port, but
best discuss with those who are actually marketing the devices.=
