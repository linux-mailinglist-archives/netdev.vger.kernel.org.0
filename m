Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882906297C0
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbiKOLub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbiKOLu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:50:29 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2064.outbound.protection.outlook.com [40.107.104.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433CECE0A;
        Tue, 15 Nov 2022 03:50:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1EbvD+sC1Y2zqNq2Kt8dbx7v4r6nyp48c9qZr0+JcsdQieHNODPtHUb7zBxmg7Vbx+wixG8eo1DLKr+qLs4HF9K7TBUXluI+rULW7Jj3T+vDrNAQqV8FYg0DANVx4QFOi121rRoxzSlYtyeYcam7WWwtshMY4IKth7SGUhdpBGqsPruhO3JBubqkZDRBtjMjZ8bds32z3C8smES2nk/eb0vMGxrBHgd51p6/j4qx8wY6ybyi1a3NHH6BHjgqaXOwtbWkB1qUumdkS6iB9f85BcNrbr82CGpO7LsfHxnKCS51xWU7M/TQ6yFs13rSVKHoBImZhpyCWQfO8hpnIXoQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTEe9UHRnlI5S24R6QSgzGWVL4tEL0FlhSlwW0E/unA=;
 b=EmE7PW+sJ4i5z1rCWIBPyNtm5P/RXBLv//H5moksvX7wNOc2+dXAiyyn9ncQ7oI6e/apnMFGs4+byh8qutXjuFDFoXRC4scz5AOiKCnCF5tW+sKVmtxowVyhgsLKNSrsXZR16NW+yPVSPQ2QYPTf/PQ7bQ0YSfvj4kY9+L+0qnyhLmhvuyFcTSEVvmpuysHkudnP/3mcnOwLJzVLYYhNb/PGGjZ+H7mqYBg/2y4zgjmdGbaoLe+20ua1Yj1u2odTdiXkk0wLLvHDI1SyEmiQsWRVz7MgrR0murZQstqYmsGeIlpCq8bCLeeeOL4TPwaway3VoO7jSf4sX2uzWL9XBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTEe9UHRnlI5S24R6QSgzGWVL4tEL0FlhSlwW0E/unA=;
 b=b3M9QV9yVMlKrUlm+QR2Jgh4w8wXy+h48O8vyBYVlW/MOQGGkCeBQGAlvZN6bx4HDdfJgfGucVUb2euC9rri5BbmKyMRvmJqavBXUI0KAD3XNQahXSwdMKx6TkuivnleJ2qNB5dzlPD5qdvJKo9ShjWJTEm99+U5pH2SXim+MMQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7312.eurprd04.prod.outlook.com (2603:10a6:800:1a5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.15; Tue, 15 Nov
 2022 11:50:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 11:50:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
CC:     Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: Re: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Topic: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Index: AQHY8HTAfetHoGxM5E6HcRPQNrr8s64vpgIAgAOCEwCAAdB8gIAK0AQAgAAnZIA=
Date:   Tue, 15 Nov 2022 11:50:23 +0000
Message-ID: <20221115115023.hgc4ynrx3kylf6p3@skbuf>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
 <20221104174151.439008-4-maxime.chevallier@bootlin.com>
 <20221104200530.3bbe18c6@kernel.org> <20221107093950.74de3fa1@pc-8.home>
 <6b38ec27-65a3-c973-c5e1-a25bbe4f6104@nbd.name>
 <20221115102924.1329b49f@pc-7.home>
In-Reply-To: <20221115102924.1329b49f@pc-7.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|VE1PR04MB7312:EE_
x-ms-office365-filtering-correlation-id: fee7cfb2-fb1c-4d52-c98a-08dac6ff94ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vFjxmK1Q4wfoLxPD559rkOJE6yAGYhc9qKBQGcnJi6nNOFQtE+uAksFJQ4FfhO9M3nWoi1zugnYxqilF14AolVpF4xuCFyDdVTBPzGgcr92uiUJmbk1l4R+ywBRXFDTzszMRKOx/EZWFgQsiIHdQCACcJf2Q3TQGNgk4cYd88GQ1eXgwPbXbTZnWJBXcqp/WQB9rQIJBhvfC7X9byRNNk1ZlAgAMp56ciiXKPES8CJt875RvNsl/bldUxvPyrFJ2RhH1gjhC0BZVX0LbrMLbuY6dVUiTy9cTBSBCHogG1U7vGaof+4vOUM9VSpJvDfnHJ42FG1I2yh+OFrcA69fkkvmv1QOd+e+78BlZidlGNeWjn7Pwt/efZxeWqAIyvubhMEuggSU4eaa1wLuPzPMxgauUxwD1Fxw/+Yt+Ao8lVFHL9pcMxPZB4QHQFDiJMiTs+tpqOh5nQo+PnQYpM/KmlMG8By6kkALkzNanm+Qo8ofos63IxavpvyE1b1FK0vJIkRMi+RNXAGpCQGlJxmQmaCo0Q87k1ZPq5q+R9ohYGCkCY/jY/X2sxVivBQ3Wlo/4ed5Y5QKk0hPu6ioKFaZAiOlIRhRcUFH5G99UpE7OqL5TtjJyLmEpQR0mrmDqh4otA5GOZC044Gohp2Xgrbn3DEubBWeHs13oL95KwDdhaP0Q0FPjCIqOooIKs3ZfCnP9QHm9oecKok0lNNCduHqNT024pvlXYjUuLwrl+mrAWDuqTxJHE5JyjpfMghaiW6X6dckS0OINAdohdQpnFut5WFr9iOsVeqbaILoXl1zeL3M5OSXePltvbQ3hraPLJmx/9ePT2QzopSlU8mtCF/qfug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(451199015)(316002)(7416002)(8936002)(5660300002)(44832011)(64756008)(66476007)(66556008)(66446008)(41300700001)(4326008)(76116006)(8676002)(66946007)(38070700005)(966005)(54906003)(6916009)(71200400001)(122000001)(478600001)(6486002)(86362001)(6512007)(6506007)(26005)(9686003)(2906002)(186003)(1076003)(33716001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mLsDYzuAc+uubG/CtMAhBZ4qyw1b+8Xd4RBLdMh6l/cpxmYeLKyJbSxR73FB?=
 =?us-ascii?Q?hUvq6ZHeibc8h6i4eogAiilRCciYWpx6BSuunSVVAZW8W6VvtR3luAKc/sOs?=
 =?us-ascii?Q?bQ1maCQAGg3wDf9InPhTBDuqGxQwFLsHS46FH7RTU+LnezCss0VuAZuLDzxx?=
 =?us-ascii?Q?8lhqGLflQJdG3R46NeWNjedHr2kb/jc51UBF/K1cKFo0WKSiahVJjCtyOp70?=
 =?us-ascii?Q?dkc2kV4NqushGEQOWjlxE7BYkg5UOFkpYfkvfDF5eNVWwStrHOcvUprs6alG?=
 =?us-ascii?Q?3WWGEoFggaYusPxDuwf1snihU8A6oXjx1q+8diOKyZBiSXd9uzWeGdmoYyF+?=
 =?us-ascii?Q?ML/zanxK27nMZ0zvdFTOFU58Cw2bUbgdtkweqgyErmtB2OYwoq09CviFYPAw?=
 =?us-ascii?Q?jg5/A21JnpFhEIagULLgHOhDxGWYrRBX0s+9+lLnf9Sqsjy4tMF25TiWs6Ob?=
 =?us-ascii?Q?jOIUEHPGt1v27R9uzJJ6bedRYb6rMS3Dq3in42D3WkvKOth11Mm60Gf397sx?=
 =?us-ascii?Q?doTtDrfsIv53vF3TQC14+Fxv84Nylaxs5i9xZCaPPrV20qcCgC3T4LeGEszC?=
 =?us-ascii?Q?ixuQrMmk/tlkjys4fsIN4mdflzDaOrdv1jLbqsXmTZDxYSdhEOOjebdLP2di?=
 =?us-ascii?Q?AtJ6VgXZH9YGeJ5UDu6r0cKb8dqww2yRQSXQDhdfFQIC8psIbNDSw19KRGml?=
 =?us-ascii?Q?SnHbbnN9yD+OQtxKCetVFAKlGwl9Rhk/WxeMuUD64/0kL1f8aUoOjdreDGBp?=
 =?us-ascii?Q?0P8WtCDAQX1UnW1+UiBE/ZkaPz93jcu8SLZ/iAWDReGZBTMfi/lrecjM+ywu?=
 =?us-ascii?Q?Y8SOv1umTTiqDJfX6murH4+7tZW6DPXeZEEs6+r/9bIRbq84DC3VfEbztaI5?=
 =?us-ascii?Q?i9lgCOFTNB140k4KDjKikKCw9LyWHYflE4zQSpEVFaVaGgaSLh3HAaCPqJbH?=
 =?us-ascii?Q?GrPUdIXPlbUU9kqFVDBZQOzZvaQRMC2xHUo+h1wZlND/6RB0L1NnDSi4ck5C?=
 =?us-ascii?Q?lQZd1CmnLI78d83zcSKYWEURQbW0hc2sEG5uHS8WKGBRFolb1JKt9IbqjVkz?=
 =?us-ascii?Q?3VXbMZ7Y8KEPPjE9TQSRH/n7cHtPxrIrpr00YJRSFIDqrKqEQAui0g/jm1jL?=
 =?us-ascii?Q?6ADTMBNYvKwT7rLtn3A5wBjoJS8oe4HvjnpLArl/Ulf6foBovv3iIt67opNw?=
 =?us-ascii?Q?VpEipkH/QhS1jZIUmFiMs0m0tRCuSX/5bgcBHwVKttoxU4kpO4gbYDdRujeJ?=
 =?us-ascii?Q?jzX9ny/Cj0HZ7OuNxJWsuT6UaMQ8HooIRuCqH+AKAETt8gyYkTApx/pjcyC/?=
 =?us-ascii?Q?wrYNF+uSpTJ/8aZl0IaQuRbZXphls72zZRygTgkSLQ+f4HdRg/qBuBTrXXl6?=
 =?us-ascii?Q?hKretIEKC+O+EE2XdEPzo/U8y6Osyv+Z7QcnL30siuTw0Eu7KD5ooPr3kiRo?=
 =?us-ascii?Q?uV5mUo9eOUA2qmCFNiQGc2aM+BQxE5wYBGS5HfRyjebDaaiQTBsDfSXXn2K5?=
 =?us-ascii?Q?x1hVEalRfu7/58BGvwRORvijXZgdZZS80ETp15sCnLpCPDa8prRUfMDzdJEE?=
 =?us-ascii?Q?idCS/7pfef8RF9Tcui3sP0pWJvFahCgFwLtxmrzHI0rFx3CNgZLgH43MiEij?=
 =?us-ascii?Q?aQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <89071461ED882A48874503FE5BDEB161@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee7cfb2-fb1c-4d52-c98a-08dac6ff94ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2022 11:50:23.9320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vynkhPU1ILOLR1MfVtC5n6NPNjJ5ERUkHMQUo4RNaDantaZc2pBRm/rRdebd1tKp0+zQDgDwRw9qVvYIJMaQcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7312
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 10:29:24AM +0100, Maxime Chevallier wrote:
> Hello everyone,
>=20
> Felix, thanks for the feedback !
>=20
> On Tue, 8 Nov 2022 13:22:17 +0100
> Felix Fietkau <nbd@nbd.name> wrote:
>=20
> [...]
>=20
> > FYI, I'm currently working on hardware DSA untagging on the mediatek
> > mtk_eth_soc driver. On this hardware, I definitely need to keep the
> > custom DSA tag driver, as hardware untagging is not always available.
> > For the receive side, I came up with this patch (still untested) for
> > using METADATA_HW_PORT_MUX.
> > It has the advantage of being able to skip the tag protocol rcv ops
> > call for offload-enabled packets.
> >=20
> > Maybe for the transmit side we could have some kind of netdev feature
> > or capability that indicates offload support and allows skipping the
> > tag xmit function as well.
> > In that case, ipqess could simply use a no-op tag driver.
>=20
> If I'm not mistaken, Florian also proposed a while ago an offload
> mechanism for taggin/untagging :
>=20
> https://lore.kernel.org/lkml/1438322920.20182.144.camel@edumazet-glaptop2=
.roam.corp.google.com/T/
>=20
> It uses some of the points you're mentionning, such as the netdev
> feature :)
>=20
> All in all, I'm still a bit confused about the next steps. If I can
> summarize a bit, we have a lot of approaches, all with advantages and
> inconvenients, I'll try to summarize the state :
>=20
>  - We could simply use the skb extensions as-is, rename the tagger
>    something like "DSA_TAG_IPQDMA" and consider this a way to perform
>    tagging on this specific class of hardware, without trying too hard
>    to make it generic.

For Felix, using skb extensions would be inconvenient, since it would
involve per packet allocations which are now avoided with the metadata
dsts.

>  - We could try to move forward with this mechanism of offloading
>    tagging and untagging from the MAC driver, this would address
>    Florian's first try at this, Felix's use-case and would fit well the
>    IPQESS case

Someone would need to take things from where Felix left them:
https://patchwork.kernel.org/project/netdevbpf/patch/20221114124214.58199-2=
-nbd@nbd.name/
and add TX tag offloading support as well. Here there would need to be
a mechanism through which DSA asks "hey, this is my tagging protocol,
can the master offload it in the TX direction or am I just going to push
the tag into the packet?". I tried to sketch here something along those
lines:
https://patchwork.kernel.org/project/netdevbpf/patch/20221109163426.76164-1=
0-nbd@nbd.name/#25084481

>  - There's the option discussed by Vlad and Jakub to add several
>    frontends, one being a switchev driver, here I'm a bit lost TBH, if
>    we go this way I could definitely use a few pointers from Vlad :)

The assumption being here that there is more functionality to cover by
the metadata dst than a port mux. I'm really not clear what is the
hardware design truly, hopefully you could give more details about that.

The mechanism is quite simple, it's not rocket science. Take something
like a bridge join operation, the proposal is to do something like this:

    dsa_slave_netdevice_event
        (net/dsa/slave.c)
               |
               v
      dsa_slave_changeupper
       (net/dsa/slave.c)
               |
               v
       dsa_port_bridge_join                         ocelot_netdevice_event
        (net/dsa/port.c)                  (drivers/net/ethernet/mscc/ocelot=
_net.c)
               |                                           |
               v                                           v
     dsa_switch_bridge_join                     ocelot_netdevice_changeuppe=
r
       (net/dsa/switch.c)                 (drivers/net/ethernet/mscc/ocelot=
_net.c)
               |                                           |
               v                                           v
       felix_bridge_join                        ocelot_netdevice_bridge_joi=
n
(drivers/net/dsa/ocelot/felix.c)          (drivers/net/ethernet/mscc/ocelot=
_net.c)
               |                                           |
               |                                           |
               +---------------------+---------------------+
                                     |
                                     v
                           ocelot_port_bridge_join
                      (drivers/net/ethernet/mscc/ocelot.c)

with you maintaining the entire right branch that represents the switchdev =
frontend,
and more or less duplicates part of DSA.

The advantage of this approach is that you can register your own NAPI
handler where you can treat packets in whichever way you like, and have
your own ndo_start_xmit. This driver would treat the aggregate of the
ess DMA engine and the ipq switch as a single device, and expose it as a
switch with DMA, basically.=
