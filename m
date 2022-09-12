Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25B15B5802
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 12:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiILKQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 06:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiILKQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 06:16:28 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2058.outbound.protection.outlook.com [40.107.22.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3273237E6;
        Mon, 12 Sep 2022 03:16:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOqzkuSCnMRjYvhNw4Nyvi3FV5pLegTnaCRNCjL9KsOSE/EJ24bzSNdE05MTk0l8IHOVINiYiOWr9DlHMDPkVf0I7uyYfkb+BM+a9NHEXI47ae4HNzU9ma7q3o99LoG/7DOxKfnu3gcLN4Mllpw2cZqSaRZLzKz/e5qcwCmBhpYH2cvkKEm7uJtyQaMtfoGCbLpDuu/9cK0n1KVChEZZu10XLhxg4uZzcMagGYs2cFoKG2RWIzyfCm0CJ+eg3Y/GJwu6OZk+bHVPQrGaDT8zHAjud8E9v/UIvnLi9QRNU1zQXhGkWIn7LEjJKx4iOGruF8y/6KDlxLaf8MWYaBkC9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tCU2WDWuTLpTynEqyy36TyNYUfzuNVVhkXvDYDghEBM=;
 b=NCAg/AYlB0bZv58pbw3Gse7Gqs3AuE5USHRlSgjV4p3MlvztIiYrYyUuL+/qbeZOCkcuti6eJN0XGNI/c38+hBObwX5F+nafSpWN+TjWHNx/DxqeNlshGJU46sCw5avHmMVuFZ/4GFI364k6WLZzLBCnMRj5BDTeBU6uVxYIkDEs3tQCqflsWmi0kVQPRUHfCKIdQ89/Y87gcuQ4JnNZxbgSBqaTn/MSha0UGZnkRY/hoMwj9cHy2cM+FVKe7dyPMeVdffkL5erFEyAealc4WtjA5DEJUd2+7f9AlCjV2G0OU1otzpt5jLlrMh1gUn3tD7ZHQDRrnCDzqz3mrJNY4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tCU2WDWuTLpTynEqyy36TyNYUfzuNVVhkXvDYDghEBM=;
 b=m99z2uljHykczOMwQaGXwgxwUbdI6LSZiYblbxepjpb4CPiTLqoTZPUE72jK+3k2Wqfx/ShKQGcCPY8VL1Dt1EcV4CvvALIMg/+BuuIajF+XY1gJ2ueZQ2f3x2SeRUYZBa/CQRlrJWdn7lodte6jHI544n6A+/+2wcPWILnDCRY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8853.eurprd04.prod.outlook.com (2603:10a6:10:2e0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 10:16:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 10:16:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Colin Foster <colin.foster@in-advantage.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 6/8] net: dsa: felix: populate mac_capabilities
 for all ports
Thread-Topic: [RFC v1 net-next 6/8] net: dsa: felix: populate mac_capabilities
 for all ports
Thread-Index: AQHYxhmBz++3+4sxbkG2gbfVifdN+a3bfLEAgAAYhIA=
Date:   Mon, 12 Sep 2022 10:16:21 +0000
Message-ID: <20220912101621.ttnsxmjmaor2cd7d@skbuf>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-7-colin.foster@in-advantage.com>
 <Yx7yZESuK6Jh0Q8X@shell.armlinux.org.uk>
In-Reply-To: <Yx7yZESuK6Jh0Q8X@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DU2PR04MB8853:EE_
x-ms-office365-filtering-correlation-id: 1984fd32-a476-46cd-0091-08da94a7d75e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RCeqbT36DtW2J2PEklJhMwfZ/NceWyhGOmY/7RAqmmOCxoaXgVqm0Ny7H+C5XF1WyAmtm0k/iy2vD0kHF5LRncxesE68RcQLxJi1Fif5xWwr4WWpgXcjnaNieHGWBZZ/HrqetZ3SG9ZpfXL93qSQLEEEYcMMx2Cb6iN7gPvfqR13V3sazHnhB1IYygu+8Ct0cLx5V0S5IQEmL+2U8UCyf+saXcCZyt57Qk6f++dcNQFFOuW10fmu5MssZtBsJ0E3Mf1C9bEpCb69FijhZLrNZ5VKcvwq8uitthTm6klhZXvg/6cvL+RYOqPwFnWIhwtIflBj6spXY6mCZm8KETykMD3IeCUx5hEAoA18IxpHGDgFxZqK3A4LwSsHM/6F5ILncG+te0qiARZF2TQNeccjJgV3GGDzS9DwnKlrPu6Xfj826di34TXNdV3zNhXQGkpShN4xVi9hosd9iiXHiGrsnscONFko++nj+Pnj5LsPwO1xQwPALOWpPD9cG/4SYlqS+pPvBAfIOtqyIvVxBf5rpdWbKbuIoEe4tb4UasPlUx8nBGGxFg52Y7a6a+NlDw+0PaYrdIMUOMSQgnLwoLBXnlx20zqvIZzoJcpFQrubaclEw0zSQRAn+11lwUFVushQsaEC2kJ24MPiP5TqUxjvYFqLnGM5cbLNWRXYLfcNjdT8TLddVuwDli+QLdS8GVcIKn+PWzbeW4RlkLZ/yO3N3doKK++C6sZNHDN29IgREiLMawaeo8y26s86dVk8skCpNVwFnHcH8eA9WqNT7M8mUHbSNfn8tqAzDzn1VM/al4U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(366004)(346002)(376002)(396003)(39860400002)(9686003)(71200400001)(26005)(6512007)(966005)(41300700001)(2906002)(6506007)(6486002)(478600001)(83380400001)(186003)(1076003)(5660300002)(44832011)(8936002)(7416002)(33716001)(54906003)(316002)(6916009)(38100700002)(122000001)(66556008)(64756008)(66446008)(8676002)(66946007)(76116006)(66476007)(91956017)(86362001)(38070700005)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DAoJ0reHxEkWLOKv+Jp3Wveustr9fskS3UlhsZVLWcdTr4ft7GozjeL2sNRR?=
 =?us-ascii?Q?JYEpF2utqKTSYPGhRC4NHlkcXRGB6k2oK4QvSw9gZPB/1KBY6QanIRNIM0ev?=
 =?us-ascii?Q?QCXaGoie5qMrgy0e0G9VRZSee+f5At4H/eiobzxZiQF8ivOu8xarWkcx7fMo?=
 =?us-ascii?Q?BzABrkCixW4aoRmNnoCyOF56TDKmn+5rlMiJ3zZ9KrwQH70C1o4By7HubyQT?=
 =?us-ascii?Q?pDCVrh5l/sLK8A4Y2ilXtJC7ofBkaR68QK1CPHb+9eN5SQtKn2PRY/WQ0RQv?=
 =?us-ascii?Q?2xLJ7rjN2YaSNyVCBSWW0cNne7G7tFFUQgTgCt4LpBmtU8aQf1cZah//a5JZ?=
 =?us-ascii?Q?5rgjdv/emRMQ6LPWKr+skV+64OPN5E1oCJLPcpQbbWLDZ1SQLhWvE8BWlneW?=
 =?us-ascii?Q?tdGOCuSa9vq5Jyo+KIZszpVHQXgG7cRlY8oUTCv4rt8nAb2G4MCA3sn9G3qr?=
 =?us-ascii?Q?uBMWSkd5EAen4bgw68tKFWhOlyzatS0FBh7wlFBa0avE7PBJPSBfR5+wLV/h?=
 =?us-ascii?Q?1Bm1UZfl0G9CKzwrUxlQ+Lzc6xwNWePkMVvaR7WBGCJdYmrdZa+I+UhWp3Z7?=
 =?us-ascii?Q?mjuEzabJGQ67BPBDerO5PnCgeun/7hD0zGaT3Z2e3p5X3XvCWiBC6uuWz6K1?=
 =?us-ascii?Q?hh4BgTqjzbxBSd4XOLxWYGk4S5aGXstM3/2cz/pmWvwpgl9HFMQHPbw1SYlH?=
 =?us-ascii?Q?whiU8thBYboTYomsgAyfB8lbvxMir1Gw2OAI1UcYn5pMpDFK+T71PcApEaF8?=
 =?us-ascii?Q?aY02X4LZzG4wP7TezjDToDkklOgUwzxXMAmmKHcRYdAptTma5iWw9Y6BPxB0?=
 =?us-ascii?Q?uyD2mIg1qxE7SvovT0BJGUImQQ3RRjk+tpPQtpbqR9lMaXgoYkOZ6UNqA9ca?=
 =?us-ascii?Q?XCEkEkiXSVP+pAp0bGO+JfaJhh3ilQkS97d8h2GO2fGWqaIUgkanWMqfyzMw?=
 =?us-ascii?Q?hOM0DAS98ZPhrZOMPMkY/rC+7205TusOqfzKYsQEtsdiLbKk0pzABWlPwbjY?=
 =?us-ascii?Q?e7O9kJtVcM69fo8bNU2IB8ZycrSOH03bZVe8DmFVSRW+qG5deVM0lxvHxz7m?=
 =?us-ascii?Q?6k5M/dYlbe6ecJcuvWmSWGKzbii4yrxGA3bzwNb6mYCYnUpfbGE1yvjnZDrC?=
 =?us-ascii?Q?ZJSTWlOdQ/v44dDiekBBUKeJf72afW6JvoRapFnxCLmLBzkkOttg648C4Fz7?=
 =?us-ascii?Q?jNlE2cjhxvz2FF4LPfacIEvqfEcFTD+PmBKPw4fVsI51q+HMY6qJl1I65tFY?=
 =?us-ascii?Q?DAcU9lg1BL/wKuSrsoQUWnS/ezORFjmUGuJwvbY5G1OJffRwLjfuvwDm2ZSk?=
 =?us-ascii?Q?Qx+XCIrYvyRDjb7ZGHpGCnM1FmHooLSH17nuOT7DGMuuZ7FZkBKokdRpS/v4?=
 =?us-ascii?Q?E5rvpUaCCvsiTzmc1oqRb5df59G6qoRP8omgcS6RIyg6H904FdIKJFunDvGN?=
 =?us-ascii?Q?0iKSiOfTos6UIlYbtwjUU/ZwMcvdLgre45d1xZDmxiniDDg1wMcac7bOzd8C?=
 =?us-ascii?Q?zeB5aZU5KBQU6mwAT/Rbh8Nz8qf9KkbNADwl+xw6UjwU5HtaWrydMSh5bMVF?=
 =?us-ascii?Q?DKKMl5kytF/5/GKyNHARlPQUp2pHbcQ9x5eD7sNZF+Eyn/ePvHvGwDORysGy?=
 =?us-ascii?Q?9A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9F76332D997AE4409C9271ACC188C369@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1984fd32-a476-46cd-0091-08da94a7d75e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 10:16:21.9432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eg/rFZDpJgsY3IBi5/41lX8d9OjHWMmLdHSGbeaz9URDptAFcSJpDGSA9s0f8YzNIwIWU+KwSe1WOM5/XWFovA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8853
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 09:48:36AM +0100, Russell King (Oracle) wrote:
> On Sun, Sep 11, 2022 at 01:02:42PM -0700, Colin Foster wrote:
> > phylink_generic_validate() requires that mac_capabilities is correctly
> > populated. While no existing drivers have used phylink_generic_validate=
(),
> > the ocelot_ext.c driver will. Populate this element so the use of exist=
ing
> > functions is possible.
>=20
> Ocelot always fills in the .phylink_validate method in struct
> dsa_switch_ops, mac_capabilities won't be used as
> phylink_generic_validate() will not be called by
> dsa_port_phylink_validate().

Correct, but felix_phylink_validate() _can_ still directly call
phylink_validate(), right? Colin does not have the full support for
ocelot_ext in this patch set, but this is what he intends to do.

> Also "no existing drivers have used phylink_generic_validate()" I
> wonder which drivers you are referring to there. If you are referring
> to DSA drivers, then it is extensively used. The following is from
> Linus' tree as of today:

By "existing drivers", it is meant felix_vsc9959.c and seville_vsc9953.c,
two drivers in their own right, which use the common felix.c to talk to
(a) DSA and (b) the ocelot switch lib in drivers/net/ethernet/mscc/.
It is true that these existing drivers do not use phylink_generic_validate(=
).
Furthermore, Colin's new ocelot_ext.c is on the same level as
felix_vsc9959.c and seville_vsc9953.c, will use felix.c in the same way,
and will want to use phylink_generic_validate().

> Secondly, I don't see a purpose for this patch in the following
> patches, as Ocelot continues to always fill in .phylink_validate,
> and as I mentioned above, as long as that member is filled in,
> mac_capabilities won't be used unless you explicitly call
> phylink_generic_validate() in your .phylink_validate() callback.

Yes, explicit calling is what Colin explained that he wants to do.

> Therefore, I think you can drop this patch from your series and
> you won't see any functional change.

This is true. I am also a bit surprised at Colin's choices to
(a) not ask the netdev maintainers to pull into net-next the immutable
    branch that Lee provided here:
    https://lore.kernel.org/lkml/YxrjyHcceLOFlT%2Fc@google.com/
    and instead send some patches for review which are difficult to
    apply directly to any tree
(b) split the work he submitted such that he populates mac_capabilities
    but does not make any use of it (not call phylink_generic_validate
    from anywhere). We try as much as possible to not leave dead code
    behind in the mainline tree, even if future work is intended to
    bring it to life. I do understand that this is an RFC so the patches
    weren't intended to be applied as is, but it is still confusing to
    review a change which, as you've correctly pointed out, has no
    effect to the git tree as it stands.=
