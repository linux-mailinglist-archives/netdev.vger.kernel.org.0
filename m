Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37688522698
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 00:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiEJWFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 18:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiEJWFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 18:05:42 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20051.outbound.protection.outlook.com [40.107.2.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C911D3CFE2
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 15:05:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuC+C6m/J8QPrErE1xbV8Hqx9jHUeQlcFScY37hKdbbT7One1EYJLXruuAq+fIRBNOYI8Y1HNBGlLHIU2lGuYmQrLB5L8BbsPA8OX9w9+KFVyVVALDdz82qcVyPKbv9HuQb5Ual7Lx0LhdRhpqLOv6W0Mff8ajqFJU/3IkjuuEdf3TJz+aXo/0Fk0d3scGZuXpZWuUXAoneDRO2FYY/vj0nRya7uUEASrCFsJ/qy9D13+Pq3tLzRAvUfodvBuxLnqxdrsDvggIG1GLP/NoJTdg22n0xBHf6uY24T8sbjrUPVVPV9LPkrjpOCSDSTuzjB9qdy7NUM908Y4MlKkfJopA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PGnwrZECpKu2UinqssWnUUsfA/B7LiT1lel+K+k3vWs=;
 b=PsCUeUi/cPM0LF9pzkBvxdWdxYw+nhMT0kyb/kZBE/A7/vK6LOZ6BWwYNS5osmqg7kHO/d6VMWhnqpITVij0rG66+F1/XHOLUgXS6/68P6hLPVUmN7/zKCqoMCJMesG+zLvdfvcxZGEg0v0tVmHt7V6Yh0KN5Z7tsAlZOg8Nzpv0Ax0QKH75XdOETVgk3EmUaqvL/Bs9zcev2hulOZ+reAO3NVJ5cF+TbhhNOCis6vgo3awQoccsEtouc3o28jUuxZHWaguaEn3GedlN7MYRk1Q7xxgqS6QRYxKi1XP7lbjkj3MGs5uYqv6WIXWwVEROMjGWQ2o8XQ7zReuE0CcsYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGnwrZECpKu2UinqssWnUUsfA/B7LiT1lel+K+k3vWs=;
 b=W6QMpRo2AAnkUk9rhDLC/DxQ0/d6uxjbUhnhNHTXEmzwuq60Vw0Wt1kVAJkFMojotUQg/tXtrPkxgFjNPtvh7GDqWt5NXIqDTvyEbp8BNjGYH2tGNcU0lDIuthvxZ6bmZR7CgJgmZaYKfzh2Q8f1z+2Zvr6lRglICGv5EH8M0Xw=
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7577.eurprd04.prod.outlook.com (2603:10a6:10:206::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 22:05:38 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Tue, 10 May 2022
 22:05:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFC PATCH net-next 6/8] net: dsa: remove port argument from
 ->change_tag_protocol()
Thread-Topic: [RFC PATCH net-next 6/8] net: dsa: remove port argument from
 ->change_tag_protocol()
Thread-Index: AQHYYvAlgWGbg0XvlEeFCwbOdhV/9q0WB2UAgAKm4QA=
Date:   Tue, 10 May 2022 22:05:38 +0000
Message-ID: <20220510220536.nxecr6jqxx6kjsgs@skbuf>
References: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
 <20220508152713.2704662-7-vladimir.oltean@nxp.com>
 <CAJq09z7AUCA9ya+8JJXGV_2NAFZ4W2jjq_OemkVokhOPBXxM_g@mail.gmail.com>
In-Reply-To: <CAJq09z7AUCA9ya+8JJXGV_2NAFZ4W2jjq_OemkVokhOPBXxM_g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74af3d92-a76d-4cc5-d6ca-08da32d13753
x-ms-traffictypediagnostic: DBBPR04MB7577:EE_
x-microsoft-antispam-prvs: <DBBPR04MB75778CDA37470FA9510E1448E0C99@DBBPR04MB7577.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8jQsua1V+Ng5xvmLY4Mp/CLBdJJMClSceYDuRivj4vrP4SHSk3mntwy93AbB8D1oVliPZWKITp9QJm0VrYLv1JM/YKnWEf1PcvN6IRzVgEdkjbeuJMIL3G3o+srKFjzwx5930g3iF5aP6VErJpJIdjwj7DSMOzeUHVyIEy+kuNB4wMJ+QPPp9pcLgRJE43Ik0DiwpCM70a+oauQZ8K3dHkBBfmGKH2HsyZDnIJLWv8wT1/EMAVZS0gj+Bjb/So8R25fyPv5uGQ7uaGqKNgcbzutzsG751gaR45LfzC/nrwwy9ucBsRssIMrNh/opwVFQYbYI8J7/TotM9wSatULak2BPYrNeGUpK6uySNguIQSecsPy4UCmL4xHW6x9a/HdKXQkZpLbsmGI6OjXFqkG8pBrJJClMHw9fn5lHXCcwfFWvJR99zQHmo2EdoAxNdr5aJz/NLvT60qPpi/Oagm/3MFMhxYstwDKvtU2eh/xWQq0NkM3G4ut9XZtHY+KvOhQ12q4/OCWr25N0lIYVwexL4ch/5W89YOIDZE7/ZzSLo4SboscV0J3Crm6UPNstu2pwT4daKyftEhXRlBjY7BYR8IzTU8Pd6kL7gnTHZRMX/Xwdaf5MrKJeNDNYnM9vCkm8BNxODYSbF64/l+6CiBGBIYD/wvZXpvtfUGLtgYlyiagoAz7s4XHOUNrqMi/VhEGHMc/ox25cruTEBL07ioXYjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(38070700005)(4326008)(76116006)(8676002)(66446008)(64756008)(66556008)(38100700002)(66946007)(2906002)(66476007)(508600001)(54906003)(33716001)(316002)(6506007)(6486002)(71200400001)(6916009)(7416002)(4744005)(5660300002)(9686003)(26005)(1076003)(186003)(86362001)(6512007)(122000001)(8936002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?Y3A6WQHTD6dTCmY0Rj2temyzs/YUq6N443/gM2w/QyjSTboBeEZ8j0D4?=
 =?Windows-1252?Q?aWJ6x3sVB+P39NZ3Kwoh/EtIMR+MWAu+BsipIAY27e25WRejj1ob6dwD?=
 =?Windows-1252?Q?dlHkL4dGu0WGoBQY5R6x5FMKytjpZ/Cbf/jBIN6xHgsqbG5yUQ5n6xYJ?=
 =?Windows-1252?Q?bUeOVxUi7zcvBgbc5OQ6/IH3wI0+VoMCwAZuERYL8GRQW5yG5Kvlmfd+?=
 =?Windows-1252?Q?IGC/Wn5F+xg1SOnQTStmEqQoqKiqx1bhoiHOsJernApzXUI2vTm5CIIC?=
 =?Windows-1252?Q?sWHy9PbH+V874ygQDqF0CimKeFrvmUdZ4qYrupq/Z+GXaMs/nYbHo2LL?=
 =?Windows-1252?Q?WLIM27c92yCgCl/bXw1tgn0cdkI8QtswHSWmWK4s68cuvuPYmj21qBbd?=
 =?Windows-1252?Q?dEf1LA1nh+sARYKNaUzoNqOhno4hGT0dl7OegXqa4Hpv9XKED0fzQLau?=
 =?Windows-1252?Q?gDbQv8XnOnyeqTJMh/piq1LosZANJ3E3WalEwjh6/eTQAGEJLgKQzE4S?=
 =?Windows-1252?Q?qtxHOE7SvfENWM1Obn3+Hs2slsoXHdMttl97B95n7O61g9iXLuGvBEwh?=
 =?Windows-1252?Q?JM7Ee5ItMfK6A6gm6Bjf9doP4N57k6VgsqQeQMBp5R2fu335W+BeI3V4?=
 =?Windows-1252?Q?kpwHiYtJg1snDgkkSgM4Z4hl0unn5m/4xueVHgSfDjpqk0/r12x61J//?=
 =?Windows-1252?Q?RSTdf+YXrfLEohZbCBi2ZPorknLG7U0OzCnCuo6S3odUOdXU5HOaopHF?=
 =?Windows-1252?Q?8vwVOJAvAYz39lP3gLdG5kRnfcJiF/O6ctsOe3DztzOrLVTmfN8/Af6O?=
 =?Windows-1252?Q?jHpSACQLQrU+4gApOoQTLyppKH9KNHjwYfw3d/UpVASSadWVz8/RQE6/?=
 =?Windows-1252?Q?tkBkC8hdT3GZwkFYIsYBMGKH2nDNOWnef4WgroUS51m0qGmDYsDA7hpM?=
 =?Windows-1252?Q?9BvxUCwlHH0Ci2RpPDrIqIKHtMiVDAVoNnfp9Vn7L00jE0Z2Co0kwg80?=
 =?Windows-1252?Q?HaXVTvxdlpagPpRvFOAgAmcox7w0XdYfb5sMUBnUP8BF7g2Bv1PhtgxO?=
 =?Windows-1252?Q?PQ7kCUxDQbzwhb+J+oxoxvFwmIezM5mmSY/C1qdF9syewqvfq9Xms26S?=
 =?Windows-1252?Q?IGQCI9Y2yvL7v7MmrHw2hvH2X9GG22kWj/6r+en2e/Aajy3GnLxhf+Az?=
 =?Windows-1252?Q?O5Y1Din05igQ7QSqn6/cRwaHscNIwnyRx7HNVQA5Mv5WUXfzIrRuTXcS?=
 =?Windows-1252?Q?dbV1PawtQsFJ5D9JuTwjxmTwj1yhN02tngcXbsZeCmu5NQgftDYe8CEc?=
 =?Windows-1252?Q?wfLLGA2aj841tUF31Rm1bz7OT89M3DDsQdakPMkwRlCIb3xAxCcJGAII?=
 =?Windows-1252?Q?jR/qkXST4LbzzVK+ai7AOSaHe3I7Poz38Ur69+SYsmJb4Au59GDmVcuW?=
 =?Windows-1252?Q?O2of9U/pdQpBcn97/o+YRPHRTmUuQ1imjXpuUDb2bXvuw8lwGV3LzXMT?=
 =?Windows-1252?Q?jqObsyqMEjfiSc+TiAskPeX07ZPEU7tTG+iSflJjDxSsG/sIIIUZ2Ywq?=
 =?Windows-1252?Q?ICxTD/Qxhr/lRvGrQOgDbhfAFQbV+/nh6B82aMR89eRCJzbKsKfBSKyS?=
 =?Windows-1252?Q?9Xhsu2Zikrm4k7yjp0wEKh90Nb1f0T+8fuMxNADVM/b7Pp6b4pVTJY1G?=
 =?Windows-1252?Q?SaI3ZfwQWgUNdDDjb0+44p+h7YXoCPez5xjmV4N/3ES5UKoXEa7LQb2f?=
 =?Windows-1252?Q?qPGjBK8WAldQDDG4nCariHwOWf1D08zRv2D3NLsVne28E/8A9t9+XvnS?=
 =?Windows-1252?Q?sfr33X1AG/tB15qX5zQz8kx6sRN0Gkhqp299f0Gx4CjvOOBwVWPJr8BO?=
 =?Windows-1252?Q?T3la/NBVoSkHhRUS3ZCEEWtQTDVcGL0EED0=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <5BE080858D64F34DB27232617D6E74E4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74af3d92-a76d-4cc5-d6ca-08da32d13753
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 22:05:38.3829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6wRHCSn5ZaBhp1AcUZZlkE4zyE+CU1CKVMed/1dLvFgKEQ6OtViHptyIG9pSRNZfXMjYIXPBheRhtYm9m6tAMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7577
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 02:35:48AM -0300, Luiz Angelo Daros de Luca wrote:
> > -static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds, int cp=
u_index,
> > +static int rtl8365mb_change_tag_protocol(struct dsa_switch *ds,
> >                                          enum dsa_tag_protocol proto)
> >  {
> >         struct realtek_priv *priv =3D ds->priv;
>=20
> For the rtl8365mb family, tag protocol is not a per-port property.
>=20
> Acked-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Thanks. I'll be resending the series as v2 if there are no other comments.=
