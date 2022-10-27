Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF886102D7
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbiJ0Ulk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbiJ0Ulj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:41:39 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2068.outbound.protection.outlook.com [40.107.249.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF0E61749
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 13:41:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Imol2tOusGIO1plqBWurL93gVh2ExT86xTDAAoN4JDK0eHOFViKrc5PSZ5dP0kwsN4dONOL0ELIvl1em0XGv3o7GYoEAs82QbGE1msKNoUhTnEz6jk7UYt/gJT7N4qBvWZEb5sbbvkZ2GbTBpAj7JWhS3n4fmAKfZS83s9Ft5iBcnl5WbitiCL344PJuy+KMqLQp0yeM7MQN6AbONJDd+xUzbhIRV9yaDJtW38o/s26rviKVYNN819rF08JAYsc8JwyLP62uzh1SNDMwLPVLBcLztlCHPyFCTD6y98BKHBXZT/gJno9zIL9U0+catx95dPGDLdUqWdK/keWh0pQqpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OfasP3BC81GiS0fhErJyDgXMCma8YwJVa1wG7fzEUoQ=;
 b=GL0xqZDTBu+P0O/hJOm4OaukGI3K5AKMXuuJHMqU4MTbbzJsARiGRuUoRkCQ8OMPSmoU/grqgk9skXdRP7ZGaLN0TS8G1lGGdTrtBkYkCMSNC8ZMIGl7WjhNnipYdzDHOnTRKgXzH1M9wRE9HbXFb0N6wMe8Vis5/fcD9/mgQXz/VhmGg1npYQnf8oBAYj+9qW6VraBVxCRWSUdfeaysDk+yQjlYyk4vB3EbaPDg0127K8M0Myn2M+dubYurLDbwFHZ1YocCUhNRBttLFvNRgzi2Gao/lohQKI3G7e9dZLc797Nim+P7+bFKNPpDYWxHArb8h4oi8YUX8hZeiNeqOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OfasP3BC81GiS0fhErJyDgXMCma8YwJVa1wG7fzEUoQ=;
 b=XyMqONMFI2EA6znHumaqn7bPOTuDNPnuxoUZmtucsqqjjuNV8fL2RBh3cr2wRSqmnaKXzOr9iLzPtuMcD9evTbv69jGbdh2T3Fg1IafbnPX7Vr215u4sgcxRfyod2x6U3FyBLbApDhxMFtKkWa1DeqVQm+BTsOczvDXC/wzEvAk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9373.eurprd04.prod.outlook.com (2603:10a6:102:2b5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 27 Oct
 2022 20:41:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 20:41:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "tharvey@gateworks.com" <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        Fabio Estevam <festevam@denx.de>
Subject: Re: Marvell 88E6320 connected to i.MX8MN
Thread-Topic: Marvell 88E6320 connected to i.MX8MN
Thread-Index: AQHY6aoyY0Ej62Wnd0Swyri7wm0Iva4ita2A
Date:   Thu, 27 Oct 2022 20:41:35 +0000
Message-ID: <20221027204135.grfsorkt7fdk6ccp@skbuf>
References: <CAOMZO5DJAsj8-m2tEfrHn4xZdK6FE0bZepRZBrSD9=tWSSCNOA@mail.gmail.com>
In-Reply-To: <CAOMZO5DJAsj8-m2tEfrHn4xZdK6FE0bZepRZBrSD9=tWSSCNOA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB9373:EE_
x-ms-office365-filtering-correlation-id: ef263a75-bf98-410c-9e7f-08dab85ba404
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1IanwkILHWYN+roAxMU76sdvsXHqtcRQ8xOxzZ446eMjE3WBip6aVdK6RCTkXOOVlSAyyp6lJdEha3hQucK/uZ0fa4c4Azbf8ExFotSZZ3AwqKZ/D/i49URd7B80pkffVBpNGeEQcwvpCcmcWWvSbiFG+EUyC7o9kefMmGKESo+NbYS7h4qNlSoT+4nA5WZkCfmzOraYnMQ5/3gN8MWqcSjNdzqplh0zid6GBqFDX5QUCU9AdlK4Yq4CUOa+LPPcMU9RMbDbmkwSl/Ve0gh2qppsfG5F8NvjierNhcO/NXEXGDnb6Enu6EUzaUJkwr5sMqcW7VWCZAXV+wyDNuprLd+7Xr6lNSzwH6+ElRXG4fFCMEzh2FZLo+aU8MCABBLT4JSwKsuIytXNRJjpJdBy77ERURQy+M/dLWIzLAXwuk5XhOx0puoWK/LkzwE26B1ZapUaQtxev2+y0fhXCgU10ofc64/RGgag3YhWxo7sL4i0MX35kuclwqPK3zo+Bbr+MwBWQ3MWDAbojflg5uoC+9Y5D1tmI1JTTPIsl0OgFNl0lfOEdEY72Hy11gOfsARdK0R+7Ms6l/GDC5v/2FLKZJmSfEIp9kDuvsgbg9OgIZRjRTluiyuSZ3k/sTTSNMVvsl2GlbeXHWsEVBmLnB1gYMMWxeHUyYIL9OzPGWZk9f+vinPfNjck8UGClPmmrbL3rJ43fgmYQXkiqiu+giWKDbK43WsMdzitQFdbZJC/Rh90rb+gxkJTmYh3oNFw1B2lCNICn2titHpBQ96PduhlRp6sie0VNoR6JdyazZWXK3L6McCUH+ZYuOzDTKhb73bVqHAPCFS4bFWQ8mctBp5plFJPSMO407O19TlNTD6TMLM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199015)(966005)(6486002)(83380400001)(478600001)(91956017)(71200400001)(76116006)(66946007)(66446008)(66476007)(66556008)(6506007)(4326008)(64756008)(8676002)(8936002)(5660300002)(1076003)(122000001)(316002)(86362001)(9686003)(54906003)(41300700001)(6512007)(2906002)(38100700002)(26005)(6916009)(33716001)(44832011)(186003)(38070700005)(10126625003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?E0IWGupXLPhHCkozVtiDGh4tMFWGlAC+W7YaCB2pjoSygIZ92dFj9c5XEHMO?=
 =?us-ascii?Q?VW6DI7mVQs6+jH/oyAKr9OTbPKcSoJhzApTebyBLMWQO/PCHYnOs/PdXpaRH?=
 =?us-ascii?Q?+PUXxq9k4ArsKIaLstc2Z9U0H/c6KVELm/YK2i7CB9NfZHTLmC3Ckp3n6krU?=
 =?us-ascii?Q?jwFSSxr/8eT6thBG5jKH06NE1QPlCQ7++1KZSQmBeF6YTfoQ9nQyFJ4zMkkS?=
 =?us-ascii?Q?gA7DW24SmFpvm9Oy1xFs6ooNI82LjuEw82Z2POVzu3g02Y5Ww6JFJ6RFTjeH?=
 =?us-ascii?Q?ViFc9bK2MCFTxL0ivq40HUZHCQFaRB5tli6ohWZ6VX5xdvdZ59S//c22PQMh?=
 =?us-ascii?Q?l3AFmRAku/ecEQA+15qPBcYluymIj5bkRV+as2RHeOOCobTzsJ/LR2W117Pq?=
 =?us-ascii?Q?sS08AUWm0PoabhTlhMUwJo51x7nuEvzgkFpLOQBvm6B/gHA6MmeeRfGlf/AK?=
 =?us-ascii?Q?5SaSbcFfN+0dzz03AysmuYUUVELv5D78fz2fLrFokVsSgxWZ1GrMJ7qzGzzK?=
 =?us-ascii?Q?pyypf0y+otZZ/ucJOCjx0z3d4jCEIWKbBpQRMCRXcarzl9JENjeo3KfkeLZi?=
 =?us-ascii?Q?P/6X8SYaWKOZXSWUwWOZE/Wg+2KThpoYmzTod2/sSn0lPJ4tSqcHuK5vAaMw?=
 =?us-ascii?Q?wG3MTSwDfSScXNKVm1+aynS7AlOB9K20kLw+4Pa28zQ+ZCBSA0HyDMvICwjv?=
 =?us-ascii?Q?Vlg+PFpUh71YIw3MVajnXz5IYKaAQVYBlyay6Ba6Hjpqo4BB5U2Wz6ax+Db4?=
 =?us-ascii?Q?F7UIYfq/MuPOsfYG/8JsFWDNZ0W/UhMy4p0lDJf5kkS4XgdEGmkTXQszHJAi?=
 =?us-ascii?Q?blIsyPt7OSVzPWIVi/NTAfYnRYoqJ3tkySsHb3zUe5jG7CetIVKb6vOLUuEv?=
 =?us-ascii?Q?CebgGnMLrOaBMLbmG9WU8mF4p1c09qYfbRkPKmZ1yH26CKzz2UObvwyv/G77?=
 =?us-ascii?Q?0D9bGvoe9jS9TC66s5/9e8kkadhJI7eIpaaQN+yf+jPRCQT0xTGueHj+JFVC?=
 =?us-ascii?Q?qsZ8kfGEmJ9isLLlSlt492KbiG4ZM5JnbryKgIw52W6iGgJ6Fl5ZMm3TyopZ?=
 =?us-ascii?Q?4kjfO+/H6dOnWvqpVGMj8b0jAfRguedTGM9fB50bt69SJ1JNY4bS1msgFUne?=
 =?us-ascii?Q?BKFEgp1V3Cghc8HnZgCapWfgmVguw+rBe8LlQf4akxXI2da5GoXPStLQE8dz?=
 =?us-ascii?Q?l0CL8hMfbyJdaAATUu20d5oAnVYeMm+yht79fccOb5bz/gzMC85tpyLvS0aV?=
 =?us-ascii?Q?mCC7N22geKD9uRhevebsfJsEke2OzBeNQyZuxOZHX63pirLbvGAE3Enb16qs?=
 =?us-ascii?Q?iR4ZWtSIad13Je1+Q6TUPqGIdHy1chOHUo4ZfxN3JoTfzOlP7AAYawpDHjFd?=
 =?us-ascii?Q?gJRG7TNoF5UzPwvtYQ+JRfQkD20NHjvscMhxRLWgCgsVfMEOy+GWlHmytdVh?=
 =?us-ascii?Q?J5GiIcGGEOYQws1OjPuBBFwDPc+hMbTH066qrj33ciZ/NiCyJLX+g57x0eqU?=
 =?us-ascii?Q?FoVoibZqQB07tZ/ggKgWgx/0A+S9xDOLBKA8uOn/drXfJMSCZrXyM64pUCDB?=
 =?us-ascii?Q?ZmkH+yUDasFhsJ0S1bjrAdRlm6nZdK6RuL1n1xvqx9xWUILZT64Vh6e97c+a?=
 =?us-ascii?Q?oA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <395DE0825ACA504085DEC92D61F69DC9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef263a75-bf98-410c-9e7f-08dab85ba404
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 20:41:35.9491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PkUJtOX4bFL6PmaoHhUQrkMwj79mnjTwQohGSf4uN9LFAqWsu3SeEyNEl1aqNJlo2eAvsXVsxRxHE1FOiHRGjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9373
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Fabio,

On Wed, Oct 26, 2022 at 11:16:45PM -0300, Fabio Estevam wrote:
> Hi,
>=20
> I am trying to make a Marvell 88E6320 switch to work on an imx8mn-based b=
oard
> running kernel 6.0.5.
>=20
> Ethernet is functional in U-Boot with Tim's series:
> https://lore.kernel.org/all/20221004164918.2251714-1-tharvey@gateworks.co=
m/
>=20
> However, in the kernel I am not able to retrieve an IP via DHCP:
>=20
> mv88e6085 30be0000.ethernet-1:00: switch 0x1150 detected: Marvell 88E6320=
, revision 2
> fec 30be0000.ethernet eth0: registered PHC device 0
> mv88e6085 30be0000.ethernet-1:00: switch 0x1150 detected: Marvell 88E6320=
, revision 2
> mv88e6085 30be0000.ethernet-1:00: configuring for fixed/rgmii-id link mod=
e
> mv88e6085 30be0000.ethernet-1:00: Link is Up - 1Gbps/Full - flow control =
off
> mv88e6085 30be0000.ethernet-1:00 lan3 (uninitialized): PHY
> [!soc@0!bus@30800000!ethernet@30be0000!mdio!switch@0!mdio:03] driver [Gen=
eric PHY] (irq=3DPOLL)
> mv88e6085 30be0000.ethernet-1:00 lan4 (uninitialized): PHY
> [!soc@0!bus@30800000!ethernet@30be0000!mdio!switch@0!mdio:04] driver [Gen=
eric PHY] (irq=3DPOLL)

Looks like you are missing the Marvell PHY driver; the generic PHY
driver gets used. Can you enable CONFIG_MARVELL_PHY?

> device eth0 entered promiscuous mode
> DSA: tree 0 setup
> ...
>=20
> ~# udhcpc -i lan4
> udhcpc: started, v1.31.1
> [   25.174846] mv88e6085 30be0000.ethernet-1:00 lan4: configuring for
> phy/gmii link mode
> udhcpc: sending discover
> [   27.242123] mv88e6085 30be0000.ethernet-1:00 lan4: Link is Up -
> 100Mbps/Full - flow control rx/tx
> [   27.251064] IPv6: ADDRCONF(NETDEV_CHANGE): lan4: link becomes ready
> udhcpc: sending discover
> udhcpc: sending discover
> udhcpc: sending discover
> ...
>=20
> This is my devicetree:
> https://pastebin.com/raw/TagQJK2a
>=20
> The only way that I can get IP via DHCP to work in the kernel is if
> I access the network inside U-Boot first and launch the kernel afterward.
>=20
> It looks like U-Boot is doing some configuration that the kernel is missi=
ng.

Yeah, sounds like the Marvell PHY driver could be what's the difference.

> Does anyone have any suggestions, please?

If that doesn't work, the next step is to isolate things. Connect a
cable to the other switch port, create a bridge, and forward packets
between one station and the other. This doesn't involve the CPU port, so
you'll learn if the internal PHYs are the problem or the CPU port is.
Next step would be to collect ethtool -S lan0, ethtool -S eth0, and post
those.=
