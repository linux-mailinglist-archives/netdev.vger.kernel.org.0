Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662A4610685
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 01:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235227AbiJ0XtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 19:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbiJ0XtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 19:49:13 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2061.outbound.protection.outlook.com [40.107.105.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E80D22BD4
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 16:49:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POj3mutH8y2OxpCu1iqTqS0u0YffEj1c9OEP2Zz4fEmK3nRrPwReg9TdK0AUvn/4a1BYrMZo/6eKJYqbVaOJmp/8R8zqO9cveJKAwXvxWE4bS/1t4f6uNudeTg97imbm/NONYBhn0kR3srtQIUOcyqiAQ0Y46cUfngryKAribBVUoiv0btuH+IbkAW7OUNxa/pdN4u6VIetDSXoAG9XD+kinwYw8SzRQDOLbIojgCKQ8ou+1SnfnT/yOL+XuBbfyoXscra5C3bJ4PTk38B+1BSxYM1ZWdxWdbYdoZAeTy+1sOoGiNpacQicv3YmCuG+SzARYJQnRlFAGnZZZxTLueQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JJJB+CDMZx6MOhV2+WKtF8/AgZJPNv12+bo4pB3o6c=;
 b=jCmN1P2ROhlmlJdMsdi7ways7FRdgcZLfhDBLh4/mXTg/0Vfhd8RaQZ7Q7ExwCBwCtjnFdnKKYywaeD8weqrBMaDOZWP7WM8FR93dicOGqKc3fVv2r2aGdJWMcxbiqdPxN4qJrQYEZaRna1of2t/QUw2hbM59Kr9FnvGO9gBBqFkm/QTOdENBLTKRX5OJkqoVviidCMWOZXyhBFR+wNnPa5Vj3+HXiOAMGSTJ9tTxL0ovHjI531NYrfhjOr1V5TgqGnnwqRU9wOHmFs00ZItqvmr9nsaEWGbPFQb2OW0CK15SkkNy8q24tWwn6DF4iSf2KarVDtH/w17UwwCw910Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JJJB+CDMZx6MOhV2+WKtF8/AgZJPNv12+bo4pB3o6c=;
 b=WD6jIwEMe1Nm1acW4VJG/1GE9MrWAz1/4jlXZOTnxODX068g4hpfXYCpjglaFVk4UP0h49m0VaeU+wHW1hMC7ZXZh6fOdt9/SBXoWXH/oR7vXILvWIRxNTdPVm0mPEymFCeHe7ted6ADsivXV5M3az5ky4ZRxnguPk3RelHVfhI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8201.eurprd04.prod.outlook.com (2603:10a6:10:25e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 27 Oct
 2022 23:49:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 23:49:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [RFC PATCH net-next 00/16] bridge: Add MAC Authentication Bypass
 (MAB) support with offload
Thread-Topic: [RFC PATCH net-next 00/16] bridge: Add MAC Authentication Bypass
 (MAB) support with offload
Thread-Index: AQHY6FiqSuBl6BQsfE+PJ7KANWaSmK4i7LQA
Date:   Thu, 27 Oct 2022 23:49:08 +0000
Message-ID: <20221027234906.pm744rd2srwbq7be@skbuf>
References: <20221025100024.1287157-1-idosch@nvidia.com>
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|DB9PR04MB8201:EE_
x-ms-office365-filtering-correlation-id: 018e7848-c08f-43ae-5506-08dab875d713
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gk0R9Wtp5xSnwvoE5YGoV7z7rU7Cj1JEUC1xgLjF7RXTaiuRktU0wObX/ippMQm85sPWd3nfHWMSnXEaijDXFAkpTzj0eR0UZOUuRBuuqjUp3UHZOLbGicROk2UkAtAC7ZyNvLB58gVwkGBuu0DuqZ2gcjpYNDPFuMDRwSRPgYn0xUMl3ZyGlFAOx0B6yS/PwVlF4e0hZz5tnFhklB8Ok3f5xFlEBlW2rFf4t66cb2hs63M5z1lrk8ywDdFusJJJ/qP21gGAy73IXR7TwHuPhJ1VpKxB+5wotmKJ1tnIfsMDKu+SmzWAZD+E6kuiaoslNCbrWKBvf4BdH8RJnhg2+pdfjPJ9aGbjm1L2RQTAYg3c+O2l6OUFIcNn1VBcza8Y512nwS6Xuf6BwyNPlww8dC1O4Y4zBpatJDTwo1RBLtoswXYFM/39vim8xsdU7zSCsv6i8AbEqvvEbx4ORZDrzrsoAyvKKJqQuQgdqyMFLdTIlGuWXZE2WnhU3JPh59LX1FZiZM671GVI8UdnqI8O/PlYJk+0ZawTvAA+lLrbhIJ04+g6gNWoXq4RC8c2gczeFmxpeWbfC7TDU9L619zBvNS3rKhy+kexY928hOvx1IYGdGTEuQlN+K9luOTiCpGfJn1OoySUOJ/sY99JQHJPrMyslexGIyS/5E9tFvseoP+rvDVvsur0t8gLbH4QFce2RRBUcTcfclWuu3flK+91Kc++tJn+HRmq8h9Cwj7oew2uiRY8EsuwNjJy8ZFdEy/9fyWg71hNe+mu4kdVDNJpsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(346002)(39860400002)(396003)(366004)(136003)(451199015)(2906002)(44832011)(7416002)(5660300002)(38100700002)(122000001)(86362001)(38070700005)(26005)(6512007)(9686003)(186003)(1076003)(6486002)(71200400001)(478600001)(316002)(91956017)(54906003)(6916009)(41300700001)(8936002)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(6506007)(76116006)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oOejeZ/x49yppVw45GmJhKU3YukXhmAEUcI/wzhv7mc86eMdbPGeiTQ8BTHo?=
 =?us-ascii?Q?DO08ycNxdXikWmzlzQ0cH7nocxFHWCwJNkK29leZ1uUQGhXd55FcGYbt5LJ5?=
 =?us-ascii?Q?gKxMYCcfQSdDRKGK/RxXyHh8DMagit9BwJ2t7VVwbNDqbq+C8y3wzMsy1+iB?=
 =?us-ascii?Q?/0O6KXgZGtvgQU00dq7v5N/AbGmgccQRj8brb3gPYnMyEZ7CzjW8xUF5BVVY?=
 =?us-ascii?Q?GcYscihQz7Gud3whBTmqlszxa+lO8jBx8UL38brvabzD05VXve0BJ8zRpsHG?=
 =?us-ascii?Q?8fQAsOv4NWTmbsHV4yrLS7II7YczP8ICANB6C1NqBppL/WvKUn3qa/hMp09F?=
 =?us-ascii?Q?e5/W1NKc/YFZo+DcB4C8G3k9g6ac/N6fdv71az30K/JgOxg58QF1iRbdYKAE?=
 =?us-ascii?Q?cOQ2h8xmlQrusAVXM5/VpSlbN80D1kIvCIQj+JVCad/FoU28YCjIl2spXgCO?=
 =?us-ascii?Q?zgCdWfNosWexkgXrwd0FlKNfLVwbCmttFNDMqtvItUwyyfgkcamkTXPgeCqG?=
 =?us-ascii?Q?rVIIoc75z3W75Q2EYTWsiibjfSAiKSIBIMof9gqi7Pvu9Eubf6D65e2Qnkf0?=
 =?us-ascii?Q?Sp6MevIPvUyUXStNomESTDB+eQZaI3ObQaHrju3rUFiemnylkEOubok3nU6G?=
 =?us-ascii?Q?PzegVbXEWY4ggTPCFI/pNPd9AH8lToyznsgb0SVcHoaewcOjU9dGHb3X8bYA?=
 =?us-ascii?Q?A/59aNe8wKjDvKocD1/0Rj/0nniaB3eI8dUALUwqMj8aSKdcg4EJtBg0An8N?=
 =?us-ascii?Q?pUsS6VST+HON5wtjeXQfLafLw8uzJ7HMhVflIwOHkWMbl6oZ+HP20RlWqp7r?=
 =?us-ascii?Q?8+sHYXiIY2nAjevDnlvUmoWrAl7WmL243mcybHN26cuPsNTR9LODzD8FPArf?=
 =?us-ascii?Q?A7f1ZvyStkXMylOGyJfzN4J3UFL1/likRZGdbleksX+dI9/BA9QVitdujGjB?=
 =?us-ascii?Q?/V0Vpd4O21a5mOql/33IvYCa/tzgK2duZyW1s3psObiHiBjJjnZnUUROQfst?=
 =?us-ascii?Q?H6thkPjtkRFny7NjsZYBn9cQpsgt6t/FFWfTN7l1qQUoZks8z+Q2N6loR0a2?=
 =?us-ascii?Q?XGSYpzG6V87Flwok1gLAJR2R2GzieSY5dEZi63V9izJnlvgmj2bRAVEDmNPg?=
 =?us-ascii?Q?G9Yn65nTAkuhA/Peimy7X9LxQG4rrJ0qG7W7fMtwCWXw3ds/EdQUBk/jeGs+?=
 =?us-ascii?Q?FtGY5XOqTF7usAq1e2zPNefGmYL4XfAbW7K0TyVSR6bQUVi/mTJ7tbLEy1sz?=
 =?us-ascii?Q?nLaZahjJwFfdtAMWuHm4eRJiaTjLrNWRBo5J5RwI+q0PoI9Q7+5Jai+FSiYh?=
 =?us-ascii?Q?rdKHP5zBIFP5clxzAwUAlPx+Ghf4vJxj45awNojJxquPyKBUtRMXSvaX2KCr?=
 =?us-ascii?Q?BG/5TzNqHAvoAN5zewPC51TO3TquV0G1KjQKg6NwlucGJ+ud9dVDV43XhB3H?=
 =?us-ascii?Q?CKSAxFVaL6Zhw88eygr5+/TX/quHi0pfB9VR6d7yDyghbsDDNXuabCC/NYL/?=
 =?us-ascii?Q?dBUwv0+jkBsQX20BVtSIlZls5ESbMwS3YS6znQZpFRWOww6d2omD5pjq/x2a?=
 =?us-ascii?Q?WmCi4nVbxpLtBxe03aWStBp8xlqxKS7YifbGo3VxCFZWzCpN/L/b997D8/EB?=
 =?us-ascii?Q?3Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2BE7D0F76A2012409F411FC43941D83B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 018e7848-c08f-43ae-5506-08dab875d713
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 23:49:08.5086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XTeYAoKRqhEBWJq3nxHHIzKG6mp4AqM8OD8PJPG2XYXOhJ79CP1J/WYWdzGKOH7vt1cgRkKLZoc3/qfCjIgfog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8201
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 01:00:08PM +0300, Ido Schimmel wrote:
> Merge plan
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> We need to agree on a merge plan that allows us to start submitting
> patches for inclusion and finally conclude this work. In my experience,
> it is best to work in small batches. I therefore propose the following
> plan:
>=20
> * Add MAB support in the bridge driver. This corresponds to patches
>   #1-#2.

Yes, exactly, let's keep the software implementation its own patch set,
together with its selftest.

> * Switchdev extensions for MAB offload together with mlxsw
>   support. This corresponds to patches #3-#16. I can reduce the number
>   of patches by splitting out the selftests to a separate submission.

I don't think that further splitting of mlxsw will be necessary, the
threshold is 15 patches, and the current 16-2 =3D 14.

IMO patches 3-4 should go with mlxsw being the first user.

> * mv88e6xxx support. I believe the blackhole stuff is an optimization,
>   so I suggest getting initial MAB offload support without that. Support
>   for blackhole entries together with offload can be added in a separate
>   submission.
>=20
> * Switchdev extensions for dynamic FDB entries together with mv88e6xxx
>   support. I can follow up with mlxsw support afterwards.

The last 2 can also happen in parallel, if somebody else comes to it.

Looks great, thanks for doing this!=
