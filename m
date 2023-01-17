Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAB866E1F6
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjAQPU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjAQPUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:20:48 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2076.outbound.protection.outlook.com [40.107.104.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327A13BD97;
        Tue, 17 Jan 2023 07:20:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbGA86eGEBRHY5HOo1W5vKZek7u2NmK9pjs/C9Dh3K9sNVvybuZ6lWnI4AzO3MtLSb8aB9iaTrbWcM6FUQy6ULu4bYz4Sx6CUYAhN+pTm4y/n4UWggltPz+XLM3WfB0jUqXfJht9HsvlRQHoHFe71bF/0E2aAmtARGunQyRHIokv7QrRxCXil9V8VdpCq3WPyzajZuC7DwMZ+DUj6rNGyf8b608ajH9lsueoVtoYds1hNH8BFncpfgm9htXzyaX1Q3fvNEsfuW7sY1AfRf71kSUEQBqOdStCa5FkdDDFo0D/poRoQyRoQ3C1+lOdSFGZ1o9/76VWUhoN4OGraJycLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hTXj4W+9+/0B8gvo37VE9cT54gqfccD9dK4JI+gjbHg=;
 b=n9B8rvvJW+cNisNMTYD8zhNezHd5UVuupQZ1FQrxuREUWQVVRnDFyLPuTqxOu2jlqjH04MHT41HJgxZWgeB++2FJrPiGgk702BBm47y8dPyy6qyamX0Yl8FyYofqKBRItKUvzQSUT2uD3LQ8LBnX7w9CTuq9LXDaxl6/ONtHpwvgedwb2Bgyjopn6I0O42Bcd2MNTmCl7j4GFCNaiWO+A4I+YmK7d3Bg6s0nT3+ovVVCTavanIAWezWXnrP+dggyGs1I01w5rN6HQsToBTNDwRlcA0xembT636PRU+fMIDEed/PfLsmSkO96ivi1sXAOHWBzAvmqOMJSQrXsoRV+oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hTXj4W+9+/0B8gvo37VE9cT54gqfccD9dK4JI+gjbHg=;
 b=cmMFqvcTX78dN4kIEITeyzJmFDndtawQWUTCB62asH1Cb1atWt2uyDA0KJhKUHfq278WUaGGqJ00OAbnNuL7Gee4n1AG+EnO4czfcDwBs5x37wUjm+4a8hmYUsylo5o7yrI3mxvurYQgaI1G0Uz4RuZEu2A9EN0LhYy20VweHxO/gTx2zMhk4slGPd51gEQBNUf3O47RXP2pWg6aAnuPNw5HmJxJs3qpBVEsyedluA6moBjbI+Con2PxUrc/MXz4p2xUDQs1lCPiOAIfGLyALe3SAfcNbnS6aX1ku00wiZktQ0/x5ZlbDovePyjkc0ivup3HIPP8iwYpXzFB+4AcuQ==
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by PAWPR08MB9517.eurprd08.prod.outlook.com (2603:10a6:102:2eb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 15:20:44 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Tue, 17 Jan 2023
 15:20:44 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Pierluigi Passaro <pierluigi.passaro@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Topic: [PATCH] net: mdio: force deassert MDIO reset signal
Thread-Index: AQHZKPvgQPO0npisDkSvgN3jEdgJF66fthyAgABQ/YCAAAm5gIAAG3CAgACcr+uAAd2SAIAAFc9b
Date:   Tue, 17 Jan 2023 15:20:44 +0000
Message-ID: <AM6PR08MB4376DE074FE7224AC821B922FFC69@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch> <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
 <CAJ=UCjUo3t+D9S=J_yEhxCOo5OMj3d-UW6Z6HdwY+O+Q6JO0+A@mail.gmail.com>
 <Y8SWPwM7V8yj9s+v@lunn.ch>
 <AM6PR08MB437630CD49B50D66543EC3BDFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <Y8aqTHyoFfzMILjl@lunn.ch>
In-Reply-To: <Y8aqTHyoFfzMILjl@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR08MB4376:EE_|PAWPR08MB9517:EE_
x-ms-office365-filtering-correlation-id: 6761995a-2492-4b77-9143-08daf89e671c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8PrTrEIDyEwEe6IyBBR733wt+R7gGKksoZmfl70X6BS1JsTVatwsYtAPSG9zcJZKnxsE7Nha4FsNNmjhc96KGof7QsTU4QkTv6SWRrHYmUub5Re5wccEsr6G0hBruwF2bYfdMqhF3GVVIdiCVPBp1w4P0xTViPVzHhxDqZM1u0B6xhmDrf4kR7pZ+DSIDU//FnaCVnFVTbpOpusPkTwoaIZlJVpTHstV2NzZ9XXytBvcYry4JN4GdRo3SUORmL9aqlWbdJT+oeQgTaO9Yw7ELq14SS5yooNtCVN4LTMIVGQz6EHGFftcTVqP3TkBBCQRDxPTYixv+chRH3z3kOqvJ5Tocae6UrP5Ib8E3iSNxdIqKQzU7PBURHAWw/0btT3Y/HEsE02qas/2zBJPzcreGXNUaJEDB1ChgDalGa8an9t3q2Wa/eMeEmKloxWO48Evdz/TzvQKwNz5pdLR+30iQjcYIEtcvbAhEYhiMAwIMqa0Vjm5jVrf9B5XH7sfvQoi/iC8DhgKbTamKEfGCNPL7eJwXCJtZaKHmC1UlDtZXJoCMJeYNwQBJxJ/0daFNpdmSMPa7M27l9zYXd++4CE1I6I9bTu2k0NHvatOetixvesu6zV2Xsw3SaqUBNdT4ahdm6QrwPFcFoT3NvcBP5epq45lDl59XrnyyXfsMwbg+AOUhKaJqDUWGc8NkPB7+Cm+yJFAmpeTDlhnGkvyEmw4eg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(396003)(136003)(376002)(366004)(346002)(451199015)(2906002)(122000001)(38100700002)(86362001)(55016003)(33656002)(6916009)(7696005)(54906003)(71200400001)(316002)(38070700005)(5660300002)(66556008)(76116006)(7416002)(4326008)(91956017)(8676002)(66446008)(64756008)(66946007)(41300700001)(66476007)(6506007)(107886003)(8936002)(52536014)(83380400001)(9686003)(186003)(478600001)(26005)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?hcT6/P/GpFAsZy3bWFswDmtYIcvxNmWcIWjmM53jBwh9sBaA8VdojgPwDs?=
 =?iso-8859-1?Q?Vr6bDXIVaoXeEWae6CiX67ZB/Vsnn8ipbaGyANiSu/APiZybxzMT+eQc6F?=
 =?iso-8859-1?Q?xm02NBPe1JvBp5SNQCwNwMe6l3ldMVQMRU4GZbL3dJukLXkpKmQBGhAd+Y?=
 =?iso-8859-1?Q?KXJ7oRECDuBmgCoBCvLtx6I+tj1SNxvl4aEANsZVpLvJnv3cYIKtXZo+/U?=
 =?iso-8859-1?Q?cjleiQyWYSV8CnR0miwwPfAqf1aq2f9qmhOYWbJ6vc+0S4qq4YSxvMfcFs?=
 =?iso-8859-1?Q?DiQWph0dQ7a9+lpHRKIpgUhzNQlyXQOQIcU0+eASYm9rgDeujPKTjyBBgL?=
 =?iso-8859-1?Q?ho1aQ2GJkJ9q/Wo0Za7m/4JsHC0QrKNl0vn5E9IWA8dQMGxKnGG4+9MI27?=
 =?iso-8859-1?Q?rwDVqelfvp+9OiJhtMjfyJlbIOZepGmfI6m9W1XeTv29dJMOzNZicaU4L2?=
 =?iso-8859-1?Q?OjVKQgDiAblPce1yhpmiWvjDKVyIR39po397metXx8QnLqdy6CkkfIqPkq?=
 =?iso-8859-1?Q?Lw+6HGmW+Srh/vVlmObXy8IHsx5OODm+bPkYtj1/6ruFkn5mVJ9W78xg8U?=
 =?iso-8859-1?Q?mbdMZhjO6egIh2QfantPVuvC6Rm0Y3ypw76X8tp0cn01XuCOkRmjya5kRz?=
 =?iso-8859-1?Q?R27VRmji8wY9j5hzWNNvDppn+HC2mZnpGasJvV2aCD62fhPEpYHmvlBQOS?=
 =?iso-8859-1?Q?boBICNLhb1+eDJ79hgqPCT7vcH5j5wCTap6e7z7EZrnq73+RuyBAqikCLl?=
 =?iso-8859-1?Q?vhSn9XM4f6cAtmsWW+5qjM/w1RPdm5wXq7VQJfnVXSZp+KruUVCTaieqU1?=
 =?iso-8859-1?Q?g11WM41xVjv4zGgj4hNexjr+w2qmMWVghmrDXxHOkGMQqJbBVGmoG7gIrb?=
 =?iso-8859-1?Q?q05opLD8CJFzv1pj5I99XwznGFzQeqgZ3xnQXThY9d4hWDon+PW8QM4i1F?=
 =?iso-8859-1?Q?U5VObSIRCeasWYu/ULFhdgKZcNpx2uqBnTgCpcQM3oWDBdlV+ZZybhV5X5?=
 =?iso-8859-1?Q?0/l760z2puOH2Zp96mjNCpC8Wsq3fmMeOTgN6uZrW/dRyO3yp2zCuRDdRR?=
 =?iso-8859-1?Q?+fy2VfiLz4CVTaVtC3ibarZ3SLeO5Ic9kZvEQfObJJ+X/d3IaIBqcHRghM?=
 =?iso-8859-1?Q?iA/FAxxt2oFHjBUZDKppMkEarYV6yivfmUg3lG/RWbAB1tJ5he+U4npBab?=
 =?iso-8859-1?Q?99Wq+mF2HUjr7HzYO9u6G2E9g3h08zWYvFhI62l6qSBJoCwi+IV+39AIIj?=
 =?iso-8859-1?Q?lg2BqueJK4KPez1HQa6wrdsdTHZkTxvGcZp0WqD9dYZDCFoXwg3M4QpszU?=
 =?iso-8859-1?Q?Fk8F/K5IRz/ezj6Chxrq2MLMw+jQv8TxAlsbyszLY73rXEZSupFxINg3uU?=
 =?iso-8859-1?Q?rLMyhdky+Oxy2Qf8v7Jz44iSCaDRmafUGmp6cbq08gn66jLX16uY60bJtU?=
 =?iso-8859-1?Q?73OjABkpjAnOvZN795iaFWNg705dJJrbyoJyaLKJBO2Ek59e14FURKptkk?=
 =?iso-8859-1?Q?IOVaqCHFoflK4VraGoLxpGXP7RKCxFbwFvzUxh5tPIdULhzXogHwH3lGQ6?=
 =?iso-8859-1?Q?8n6+i6Qtnrzpys6lU+4KshoCItFxdnnICoBStEwU8Vz92e8lVOKG7eeQ03?=
 =?iso-8859-1?Q?kJqJhUneDuHg4jex0cC+IbC/EXT4hZ2ZXm?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6761995a-2492-4b77-9143-08daf89e671c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 15:20:44.4324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fiXLEN9BcwUcuWJFCq/2ghMxpOq+0/9QFEhv8ynoH3IxoKP3WIhdIbH0T/WN+URCLIJE1yYBI0LjJjVNTy8SfqT0033uVvW0D03enlyOjzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9517
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 3:01 PM Andrew Lunn <andrew@lunn.ch> wrote:=0A=
> On Mon, Jan 16, 2023 at 09:44:01AM +0000, Pierluigi Passaro wrote:=0A=
> > On Mon, Jan 16, 2023 at 1:11 AM Andrew Lunn <andrew@lunn.ch> wrote:=0A=
> > > > IMHO, since the framework allows defining the reset GPIO, it does n=
ot sound=0A=
> > > > reasonable to manage it only after checking if the PHY can communic=
ate:=0A=
> > > > if the reset is asserted, the PHY cannot communicate at all.=0A=
> > > > This patch just ensures that, if the reset GPIO is defined, it's no=
t asserted=0A=
> > > > while checking the communication.=0A=
> > >=0A=
> > > The problem is, you are only solving 1/4 of the problem. What about=
=0A=
> > > the clock the PHY needs? And the regulator, and the linux reset=0A=
> > > controller? And what order to do enable these, and how long do you=0A=
> > > wait between each one?=0A=
> > >=0A=
> > Interesting point of view: I was thinking about solving one of 4 proble=
ms ;)=0A=
>=0A=
> Lots of small incremental 'improvements' sometimes get you into a real=0A=
> mess because you loose track of the big picture. And i do think we are=0A=
> now in a mess. But i also think we have a better understanding of the=0A=
> problem space. We know there can be arbitrate number of resources=0A=
> which need to be enabled before you can enumerate the bus. We need a=0A=
> generic solution to that problem. And Linux is good at solving a=0A=
> problem once and reusing it other places. So the generic solution=0A=
> should be applicable to other bus types.=0A=
>=0A=
> We also have a well understood workaround, put the IDs in DT. So as=0A=
> far as i'm concerned we don't need to add more incremental=0A=
> 'improvements', we can wait for somebody to put in the effort to solve=0A=
> this properly with generic code.=0A=
>=0A=
> So i don't want to merge this change. Sorry.=0A=
>=0A=
> =A0 =A0 =A0 =A0 Andrew=0A=
Hi Andrew,=0A=
I can understand your position and I apologize for the mess.=0A=
Thanks=0A=
Pier=
