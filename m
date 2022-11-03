Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86770618CA3
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 00:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiKCXPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 19:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiKCXPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 19:15:10 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70087.outbound.protection.outlook.com [40.107.7.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7521CFCA
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 16:15:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGuUiJq7cm+TQFHb5KDfm90GYzi/3aHj87W9v3MJgsli5w31KfUjntLTZG0Q4c5FTi9wi9NWf1JOlFQa0gTDXfmSzBDMyNpikw3c/gGen8bf4wu09FH3O3xWraELeOE1gCDau5/fmKz0/pR1Kp2p0lpSSNLk6wHQCFZiKklyQp6T8FO4zLZrRdidho7zDxHI64r9nAB1IPNOyps8E9XonnUo333myFXBIwmk8e4+B1Ntkp5iD+I9tcBKIrTCERNSWc0tM9Q30UQUnwVrAD/swDjKZSWA9fQJaQa+JjPDrwdlK2jtMF/DqDvbe+3L9Rl4VBuPvOdcBjqvyyh+djDe/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h93TOatG9CaedH+ymgRkyIJAECWIfJzvAlu9+SVqKh8=;
 b=lX02a5/uqz0HfTjLG4aRHPsBesTgPNujnM/HmdLT2HRS28vb2AtEwwjH9O7mDQL8vNlVWLZx6Vtarnk/YdcxgXZqJ/OAdbK0zpQ7E/ETiY0DOWP0n1y8JXrxFztQD1Fo2xi9RC3hVdl/d6exiA/ZxkXJBZqajcjnwKoq4//oerUih772mZ8O2YWrkL0m4BYAyp24NB/uSu/WRp2GRmN6sDcuxU42FRG321C/qlSaLBP+wUF+q5s0qBBpspwspnRPVM3ZnlErRUQXk0K98Mb4XxNhD9my4jVljEOejlCW5IG0K4PFmoGjr6BDmx2RAHoDktPfzC9QKWBtEmec10m9+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h93TOatG9CaedH+ymgRkyIJAECWIfJzvAlu9+SVqKh8=;
 b=k6uUTmDH62qQQImoQBUDnlRO7u+i6SqsDviylLI32Q122XSP5AcVn6Or3SNiNx7Etkpf8DF86VCy01yytcLebQgfJZXz+4VprnvcBDFEPsldsPVahUWNr1733alm6bW3gM8h5TzKItpVBLon5r7z5yg7lL9rjgK+cR22y0dcuMY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS4PR04MB9412.eurprd04.prod.outlook.com (2603:10a6:20b:4eb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Thu, 3 Nov
 2022 23:15:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.022; Thu, 3 Nov 2022
 23:15:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 2/2] selftests: forwarding: Add MAC
 Authentication Bypass (MAB) test cases
Thread-Topic: [PATCH net-next 2/2] selftests: forwarding: Add MAC
 Authentication Bypass (MAB) test cases
Thread-Index: AQHY7inGn5/MmOY400i6bSLBouMGKA==
Date:   Thu, 3 Nov 2022 23:15:05 +0000
Message-ID: <20221103231505.7ftg2zcfoa7rzwtw@skbuf>
References: <20221101193922.2125323-1-idosch@nvidia.com>
 <20221101193922.2125323-1-idosch@nvidia.com>
 <20221101193922.2125323-3-idosch@nvidia.com>
 <20221101193922.2125323-3-idosch@nvidia.com>
In-Reply-To: <20221101193922.2125323-3-idosch@nvidia.com>
 <20221101193922.2125323-3-idosch@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS4PR04MB9412:EE_
x-ms-office365-filtering-correlation-id: 310ca47d-8164-4e28-fbce-08dabdf13e8f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dwq5JPsRct4Wl6w1OR8spWomtrX0CCpM1ut1qNTBGUh4fb1zV/GCYUYLcD+1sRC1m2+wQeLCN1hOGBjoZ/sLCwaq/HdoXFlPpDM/qdXpTv7vAygG6bO537BLBDQq01etRNE/f0Ti0XGtCtKTXUnnnzkSdaarlTaLXR4MOcgZWaejlh8cPdnG0+LEm0dD2q3+O7fOlHHQEH501Av9gieeSamZ0wwkm61O00/d8CGmD5jsTyfVhBiLrVrjN0TUmgPa5lIP5+ZGlZD2ddB7dNgs7V5jwAhvrjlQaflWL9mcju2XLF4etCkJFFNAY+HujpJMv8xwJR9CCchmveOFwxe7y+bnT5IXqeNPptedTNxPSAFyMR4oey/GfIUppCHTOm4URS9MF2oBIAjXOH4WqUxQR5Jp8wNekm6A9LRFf6e8FIvpm4aMLFwdRxuz1r7vPXdZtkpJsiye7CpRFigslB/QlqgwVWw7WpRb2p9oh/SKLAsme0qBRT/bY0pqJ+DxVo0CmveDGyfUpd1rnIx/YnzPHu4VZUJQyRFWjEvHud4puyfK4RWEjQV0QLwKC9ugtBXlGEwiD7LgZvw9NHi7avtoU5P4jh7s/rDiNpuCvroIV7x+5KpnVyqR9WZKPa5lL8tI5K9s9MBtSVoTU+VzuXtlDfzYpM0/F7Q/btdZ7muHy2crYepFeYpi8kvuSo7+dYBVzvb/roc4b2qfBA8An7Wq6/bh/1W1XMLVPV96eWIcRgX0juII02WdalT2MNlv1VFm1ybftKTY7IxFB4ZHulW3zg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(39860400002)(376002)(136003)(396003)(346002)(451199015)(6916009)(4744005)(54906003)(91956017)(316002)(44832011)(5660300002)(4326008)(478600001)(33716001)(86362001)(6486002)(8676002)(6506007)(71200400001)(7416002)(186003)(2906002)(83380400001)(38100700002)(66446008)(122000001)(66476007)(38070700005)(26005)(66946007)(64756008)(6512007)(9686003)(76116006)(66556008)(8936002)(41300700001)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?l/SDbY/NtJwyI/0VyTm4UqIhVvEMidQCt79oP/oPE6YCD7ZQSN0AHQY4HGo4?=
 =?us-ascii?Q?hKQcOTS3OUN7XMmKZRBreUW1qBtzS3O3jl6LKYlJSWfO9Ieq+hxP5315UuyO?=
 =?us-ascii?Q?zjf6unByOVWGMdKyJbKR1Sk2SSpF3uWXgGCa3Mfhcc0pUpCo4PaxuMCQItxF?=
 =?us-ascii?Q?8CSUFqibYuVD0DBwRTadO5YqkxMF2Mr3epiKM+hZcPyX852qmUuOE51x0I9x?=
 =?us-ascii?Q?Hb7Hzdxl1fHFH0yiZ69/K6MxfeCq8tPRAjk9cAfNK5XFWi5kwQdN+lnQa1uY?=
 =?us-ascii?Q?qTPxXkHldHgpQekLWgTy2u9liQBfA8+o+4tMn3aqXnRKMHnmV6ymNQBA8qa2?=
 =?us-ascii?Q?6qyV5Zdv8DqFRVpcohsngxjNf8OHoA9QUmJH8jasKmvnlRDwVvsyW5fdrJYN?=
 =?us-ascii?Q?Qa6zjLNz+0bSjwdvMf5Sr4axlr83putNeJfEa5tsaAhZzSRsHTnVlt8NY4QZ?=
 =?us-ascii?Q?bFpQCDXP3g87XWgIdln3zQ2zMCnGIFMfzW3J6zCSRMvbmFB7sXN8BEIJ25lR?=
 =?us-ascii?Q?e4WmMwLlj4VZO7L6MTTl56/t3giVTIVJGyOZFeehfx/LC9eTUZUkirEMCM3B?=
 =?us-ascii?Q?f99TsOhzByfEjiHzCKiIYz5TrSpQ5D58vd7HTu8GP8IEdYMhHXL/9ja4JvTq?=
 =?us-ascii?Q?imhs7na/37M3lcORDN4JC5UpyHowk0Zg5W0GZuWaKHTFeMDajV5yKVenuVn3?=
 =?us-ascii?Q?O2A/D5mCozSDqoLKx8WK2ZjvCix+IH38LzgYOmFc4KDTV7IWbCECoYySyXum?=
 =?us-ascii?Q?uEqzmIysFoh9GkIPLcZkciKjcUvbLAqKaWw6eU3Fp9BB8UDikjjVvZM31cfr?=
 =?us-ascii?Q?Rplnj/ItjmDRNAey6cPMneEYYCp6xfRRZBgNWrsXVDY/spJyeDul2JBuep7s?=
 =?us-ascii?Q?9wLuF7vMS+aa2SuXcxHF2VTch12c60sMpefyRmWiJtPUygrnMQWqhgfoALcz?=
 =?us-ascii?Q?oK5LD5tPO3/gTtaXmurLKy0H8Dz28/DpkNgzfXVL09eRoNp3KE2myz/CqvGw?=
 =?us-ascii?Q?Z7k0k8nvwfsgfJvVN/arAsRWqm+v7tOp72AWmaMvQynrlM9oE3aYugCFcGCr?=
 =?us-ascii?Q?6qgSd3Barkh6Y4uGNNiEL3WvO0bWfDklnb3An8IgFMQEIDicCZ73DysAZEO5?=
 =?us-ascii?Q?IUyRmxW/RFj05ah5tFvRVbgwSflLV/QC5sZA31f+fjOS+bd25vH4Wm3QrvQW?=
 =?us-ascii?Q?TXCTvSqaBwY+vcFcwzjiTlJr54rqwHt7gi1JRU+5tKG5EbZq1xp1Pz/yvwmG?=
 =?us-ascii?Q?Eb5VPF1Yd7pHaGHGkx1aVq9n1x5pAYVKSZN2gklG7sVJp8Oe+uZpCTA4IaWw?=
 =?us-ascii?Q?LRmXaOdr/Ftehbz7j6DyWjU0L3B/mtGUXUgDcFNbrevdzdW8y86klzIymvRG?=
 =?us-ascii?Q?WjHJBRMnlBlt69XyKXAtgq25kk5GHzUyAg5vXjBNiKyJm9/DB5dDJRw1JpNR?=
 =?us-ascii?Q?nHG/jnsjPybpaQbTGBlCSVbEglSSuWkiQz1AODGErUM9PxsDlHl+h1frStWl?=
 =?us-ascii?Q?tlw6cwp+9RU0sx6j2FH3PQgmssM91Ve/ZoQQfTAwLpz6gaU5y3KsWnMrH1eP?=
 =?us-ascii?Q?j7GZYcZpJBEVj+eE4iMLOf9H/jUdjfqq23XIXhmXuHdgXOI9h4Ja8rxb4vG1?=
 =?us-ascii?Q?Rw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F75D7CDCDF160F46A232BE9AF14B666E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 310ca47d-8164-4e28-fbce-08dabdf13e8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 23:15:06.0269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z/C6L3VfAFxiDSavso/S+SBmlD4B92ooqNpSANf/e8/8WFPyXZ3uHK41zc+s29KqwjLhrWJ2ftMxityb8zRrnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9412
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 09:39:22PM +0200, Ido Schimmel wrote:
> From: "Hans J. Schultz" <netdev@kapio-technology.com>
>=20
> Add four test cases to verify MAB functionality:
>=20
> * Verify that a locked FDB entry can be generated by the bridge,
>   preventing a host from communicating via the bridge. Test that user
>   space can clear the "locked" flag by replacing the entry, thereby
>   authenticating the host and allowing it to communicate via the bridge.
>=20
> * Test that an entry cannot roam to a locked port, but that it can roam
>   to an unlocked port.
>=20
> * Test that MAB can only be enabled on a port that is both locked and
>   has learning enabled.
>=20
> * Test that locked FDB entries are flushed from a port when MAB is
>   disabled.
>=20
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
