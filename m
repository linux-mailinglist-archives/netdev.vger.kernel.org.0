Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16905ADC32
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 02:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiIFALl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 20:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiIFALk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 20:11:40 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2063.outbound.protection.outlook.com [40.107.21.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BFE564ED;
        Mon,  5 Sep 2022 17:11:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfE6Arkg278avp/wgBNPVm3sZrRZGllkz1/AjsxvhwRe0CeCsKu1UY8TCg0qSEkMGj9BajnM6g2wvuglJRiJnIEfm3YjtBDbthEZKRdQAxSa3c3txR4Yf8xfBrcy8cVlcoAiYkEqDA4McYHGsoQnsLZbQqEtMoMTxSzYGE//Sneay+/3fSdSoY0gQtJAV4BlPuvwGg7js49zxTWpAGrQrZ6sFam1s24p17eloR6uB1hmDnVSCqERSByV3bXw4TWiq682dsQdHFS/Ieu9TWI3vM/zxdJuRMgUL13OA/fxRdHzFPaRvyQkq5LnbqI4z7nhmYsi1Uun7i0/ZEsZ8C+g8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7/eSX9rASAZT1pn05OHM7xWpag666/WIDJQwWrs5QY=;
 b=NGckbBk380GhwkOxLs4MsQ4FeBT3QbmRcSOL8vXZ1l75YllIJElP8bHZqD1Upx3Z/FpcAHvrlzt/kUlgObccxxCppBatB1Ho/jYUzQbgqaQb47loc/Hb4YKlw/8ZKWf5n3etut6cLaINQwCxiQmNamoqtk1DYccaRuvBjFZ4ojOS07FL48D0yLy0a2Sps8Jtv6dsVS2Fl4ts1rkbOQUhObGhQ8xp8DQ19QuSefUf526hStnzAMGX3Gl+uEFecUGY2TrfN7ctA+eKnO9hiODkELMCGgfJNYi9+by8Ydi0bMN17li0JZvSySB2h0RYwrU1Nl+AXOFr07J6usrRLOcjcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7/eSX9rASAZT1pn05OHM7xWpag666/WIDJQwWrs5QY=;
 b=dqIqvlcOt2Csabzt14DiWzSurkS0tCsB5045CnVS+ylTto6eJ6Vpgc77IR9vlaPWjk4L8ueWhm+QDIRXpUcVHYZUsxNcWNGHWY/GoyhG/bNsw3gRAqj2AOM4fNnSCAC0qXDU4J5xP572ZHXigU5CJm/a04RKbfyOw7+dxyLCI4I=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4047.eurprd04.prod.outlook.com (2603:10a6:803:40::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Tue, 6 Sep
 2022 00:11:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Tue, 6 Sep 2022
 00:11:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net 1/3] net: dsa: felix: tc-taprio intervals smaller
 than MTU should send at least one packet
Thread-Topic: [PATCH v2 net 1/3] net: dsa: felix: tc-taprio intervals smaller
 than MTU should send at least one packet
Thread-Index: AQHYwUk14/pm9c7470yWPIvkUCp1kK3RcgQAgAAV2wA=
Date:   Tue, 6 Sep 2022 00:11:35 +0000
Message-ID: <20220906001134.ikooyzebb4pmgzib@skbuf>
References: <20220905170125.1269498-1-vladimir.oltean@nxp.com>
 <20220905170125.1269498-2-vladimir.oltean@nxp.com>
 <d50be0e224c70453e1a4a7d690cfdf1b@walle.cc>
In-Reply-To: <d50be0e224c70453e1a4a7d690cfdf1b@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9191468-519d-446b-a8b4-08da8f9c5c39
x-ms-traffictypediagnostic: VI1PR04MB4047:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jTzMD85ImOq0w7337dY/Oizm/MgMVQkm5xhTAIn3GrE3imIN9XMYZKAnCL3l69B5vIxET8KZK9fyXV7f0BSVF/pxh66L0OjFqnxRylv8NuysnIXnScltXJfWZ9WW04ZL8qEr/nyz92Z9R+gUL62zgB//6drt+o+JkiLcnun0RDPPj1uEd1u2Jmsu/cIqmUWCjY3hIdRUN0Bfij5umB9mdVr7jByGnLu3gvdJX1bU0glCUxiDiXB/jmhfA0QdotWhevmF8ES8oH304LxdSb93czAkv+MCTu3ioA+C6UPgjk4Bl7seUpU8CXt1muPVW+6iyrYSGtLOCW3N4/rvMdavHWUf82gICsNOYqzgXG4j74Xy3tjbP1kTrS65hjEOoUGWC44dTxomCCcZ019deQG5OGBXUGGGqrF8R1Rs7k2zJIN2LTWbw1Hhyr0P+1ZMNkUY/qCIoMn2ZZpSkBJUgYVivvqWBSdOQ0a99+EljCOZo1YpwZM5ztVG/FmtWRscdQJ0Z5jUQ5GZ6nStWRdwvhsi3vFL+Vrx1ToFGb4cGxDo2gOkS383GN3giFqt/ywIkZ9j8OvcgBkbxZfi/5VW0DsRy9KcEJrFtCm/Q79/jkv+aAO2L+eYK9EZ7/SYC0elnDbNtaMKMTs+o9+knppmfUESp5144uviEdxrmK0oeVUw78o7TwfNWDao+zYnZh5jiDPTw6RRGIixQzMJpOQMgeiwCqxe1c5QvNDEdUGKgvNL5c3xDdBqpX6pu6Rcxx2MYotQF45IKEUC6aBbX8WBjHJWOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(396003)(366004)(136003)(39860400002)(346002)(38070700005)(7416002)(5660300002)(71200400001)(478600001)(6916009)(44832011)(6486002)(41300700001)(54906003)(6512007)(9686003)(4326008)(26005)(122000001)(316002)(186003)(2906002)(1076003)(38100700002)(8936002)(33716001)(64756008)(66946007)(76116006)(6506007)(66556008)(8676002)(66446008)(66476007)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?POBzR+5elCvlRnzVq7QtQ7zW8T+H2IEG23Ox5Ug8jY6iasDr6xQ3F87hFECg?=
 =?us-ascii?Q?Y2Hy0HTLuNpPPey/0JvUBm3hOSqDDVFFY8hoWt1DE3tU1YbKjy7voy0P6QtN?=
 =?us-ascii?Q?iSR5lPQ5xcbSnj+0M6l1qLTRJgYXWdXs8L8qdUOfH9tlwYNdLItlNkxnPZUI?=
 =?us-ascii?Q?EnhtEpIfq9sa8fBDSi4Upn4PUfOqHZxgH/9UQTuP9LxnLDjHhAEHzKxN8Goi?=
 =?us-ascii?Q?Kivf0BlgY7MBOiEj7gGQzIRb1/AbhRJ6Z19Sztg1XAN4pP6shn3JOUK0p81j?=
 =?us-ascii?Q?BYOZ7AT5ggmrRZH+Lp8TXIxQQBfGpp5XMMqVmpnR1KwVbK6FsdRo5Zzm398f?=
 =?us-ascii?Q?NnMZoH25Z8FBZoT+EoP0BYBpzMw7c6BzgnuuYjPNxT/ico7VfKQrNFYL75Ol?=
 =?us-ascii?Q?ICvS89IKjwp6tdqpIX0XIG7sjJm/ARd/51QG9BNJHT2mkdpq+fFp/tKHdynd?=
 =?us-ascii?Q?jWBfmGzfixLt7Kd5g44AghlfUkxvVv5kPKH4ie1UBQIo+FUfw/2/tXwhEW1t?=
 =?us-ascii?Q?nJJSxbkuiKmmLScFzk0I9ELERmqRurzIiiXKcsJW/nB1aY+SrVB3RXpCU+3e?=
 =?us-ascii?Q?D5iD3gbiv5Jw1BHLMdaUXULqziGypylo38Qh4h0uWOXLQQ6NQslhtrdgOsjN?=
 =?us-ascii?Q?PK8WG0zykWNEri+m/MbsnlTqkMchfj17jJlgVj3fGyVZTSBqON6tUqJsVuwD?=
 =?us-ascii?Q?iyNK9r8uPcEhE355DD61jil+fHc7mzjgfkS2NefE7GYqtY6sXdwBKEKL007w?=
 =?us-ascii?Q?BNxJgyPkj7rBLOgx+DqB+ucVeDobGmZXQWMn/RJWRo2DStQPceclxppB+g2X?=
 =?us-ascii?Q?0DiNNevA/lr731Z/H/D/ETzozfcra1y539KpUvFlVHfKKpk+mgeVgdsBcGMg?=
 =?us-ascii?Q?xskcDMAS5DPTaihmQ2nMSPYZHWlNxK9e7A0Xqq8RKW6MxJ0t/oPh6z0v2Ixo?=
 =?us-ascii?Q?vjG3qb05VtVVpq9OnoVnuchJag955OK37HTzUCRu4t5C1qOA1OojTem85ETs?=
 =?us-ascii?Q?aVt1TsKgesNhV/IAlJvFOklfpLQPGpS56Tw4tMn3BTu6/Cj7ESZdW8iNA9CW?=
 =?us-ascii?Q?mIcU03UsgIv7twmUkawt5M+dAznq0J2DRrI/msYAbZK7ngdWVNjUoVcpVadF?=
 =?us-ascii?Q?7QuwYD2SUwP/f0m4dZ4JXofUZJIsNLmdlnipk1Yv9zll5aj4i09JzvFCbGL2?=
 =?us-ascii?Q?ey9eKlpujrVZUjSHJEvflDk1YMfx4xW5BECGc9RobBqVkWQT2oH0RJ3Ygqgf?=
 =?us-ascii?Q?F7SjCFlp477ZAr9ajWP7LWdVKkT5ZYn+wPBWWO2Y/YumQ+1F/t9yHy4D1qvD?=
 =?us-ascii?Q?For/o5vDf39L5zMvRydWMePP2KBnOVrD0y/MYCQWBtyiIKeArC8GDq8r5xyI?=
 =?us-ascii?Q?+6WWYln5s8jGEDJlpoWYEPZInUIZo2U7y57l7SUALbdB6h+x+ZLCrBx/1f/Q?=
 =?us-ascii?Q?IPWUNMcShEI6qYvwXDcno7W0LZijNDxAb1UjDuqG73/4lZinGYDUYxhpKm0w?=
 =?us-ascii?Q?MuPK4XgonUh6uN23AwO0QNv9WtuRtyxu2AmAdA1iLRPX4q5NfCrK3wQWD55b?=
 =?us-ascii?Q?tlaCihRtIFaesFCCDIuGNQ0XrUNzwJCCCLYctBzs2aXq7b4JbxpTkxiCg1rZ?=
 =?us-ascii?Q?zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <445F2FA754CFE44BA34E5573F4EA7B14@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9191468-519d-446b-a8b4-08da8f9c5c39
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 00:11:35.0830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hACyjYUN7hcLb60+1QSEelCAFLTU9SH+yMEq8ZlPTHUIydrHRm/P8IWPOQb85mgHoT3t2/neE29BuP7kJrXmfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4047
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 12:53:20AM +0200, Michael Walle wrote:
> I haven't looked at the overall code, but the solution described
> above sounds good.
>=20
> FWIW, I don't think such a schedule, where exactly one frame
> can be sent, is very likely in the wild though. Imagine a piece
> of software is generating one frame per cycle. It might happen
> that during one (hardware) cycle there is no frame ready (because
> it is software and it jitters), but then in the next cycle, there
> are now two frames ready. In that case you'll always lag one frame
> behind and you'll never recover from it.
>=20
> Either I'd make sure I can send at two frames in one cycle, or
> my software would only send a frame every other cycle.

A 10 us interval is a 10 us interval, it shouldn't matter if you slice
it up as one 1250B frame, or two 500B frames, or four 200B frames, etc.
Except with the Microchip hardware implementation, it does. In v1, we
were slicing the 10 us interval in half for useful traffic and half for
the guard band. So we could fit more small packets in 5 us. In v2, at
your proposal, we are slicing it in 33 ns for the useful traffic, and
10 us - 33 ns for the guard band. This indeed allows for a single
packet, be it big or small. It's how the hardware works; without any
other input data point, a slicing point needs to be put somewhere.
Somehow it's just as arbitrary in v2 as where it was in v1, just
optimized for a different metric which you're now saying is less practical.

By the way, I was a fool in last year's discussion on guard bands for
saying that there isn't any way for the user to control per-tc MTU.
IEEE 802.1Qbv, later standardized as IEEE 802.1Q clause 8.6.8.4
Enhancements for scheduled traffic, does contain a queueMaxSDUTable
structure with queueMaxSDU elements. I guess I have no choice except to
add this to the tc-taprio UAPI in a net-next patch, because as I've
explained above, even though I've solved the port hanging issue, this
hardware needs more fine tuning to obtain a differentiation between many
small packets vs few large packets per interval.=
