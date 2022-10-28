Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9DE610D2E
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 11:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiJ1J2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 05:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJ1J2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 05:28:45 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2045.outbound.protection.outlook.com [40.107.20.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA721905CD
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 02:28:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOLaYmcOhNpQjFS2V5eoHimrSJEumvcp0MZ/i9m7f5pLQM1x4k+j6zWRkKn/6coEsjwVfpEOM/ObbUCv2aEZCLgPU6RXtbBAh1C4OJhghbGj/xvY9cy1OZV8p6K/ptWv9g4riMNUcdq++X1eF6DYmYlQ0hyz1fA2xb8r97sPR4KG4NEG6jvaVoYzh7yyh31sc9cCxzKkU4sluZ1GmT1IUO248odqDqA8Xxpe9LwD0PrrHs7YFhE48Vhn8tLMB/qNRzg6B84hRnP/o/BrAVndRpVCRzBa7KPNx1D2wQ+dN8DYxx20ym+4URD5M1oZp+TXtwXhujN0yJN2mlCLd8k6dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R4TKZvjl1RxI7734q5HHTdMhC9PftGp37MhzVyEhnD8=;
 b=UkbI6tFZ4Ot6sOMVsZ9nryQTkcHjv1AN8v2X2ddIPDZxdTos0PN5yX2f5AxirFErQyTymvCkTyKJ5wReusk3KrB5GWbht9ci09dM265Ta1PpwWS4It60jU+Ig8EBEcrthqRXBqR+JFqZFhCecR1tMN/XEksmYFZEx4MAFoE+TkPrQpvKKVPOpBShr7iY4LixL8aWqPnkjuGWnMKAXFohLQzGfIgPrYBaZWfs7f01FZ2OGbKc25JsbNa4g8Blz8orYZpaljnUE8uHZj/XCRU350N0bVRUFoj8n6Wj1HEKl71bpROyjSqTsepIiJi+qD71Prs4YB2yCgOLlW4pCCK6UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R4TKZvjl1RxI7734q5HHTdMhC9PftGp37MhzVyEhnD8=;
 b=IIvJzH897p/JYs2IqZBFnuv4XthQpHup703/Hsqwr8ZMJhTxUT3F5MVylGRDsSbLZEO4T5mpQXT9dIKcERCk9E3E+JOBmwZNvBgEo0ANkunc2ficf+3Nr6zRLuif3Ni7ewgAqcj7+v0n+hS4hao+Pl9oQaqJJ/+z7Ss+Q1U0pHs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8852.eurprd04.prod.outlook.com (2603:10a6:20b:42f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 09:28:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Fri, 28 Oct 2022
 09:28:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] Autoload DSA tagging driver when
 dynamically changing protocol
Thread-Topic: [RFC PATCH net-next 0/3] Autoload DSA tagging driver when
 dynamically changing protocol
Thread-Index: AQHY6khKXSRkT65VOUC0q3byqGpP9a4jh7AAgAADEwA=
Date:   Fri, 28 Oct 2022 09:28:41 +0000
Message-ID: <20221028092840.bprd37sn6nxwvzww@skbuf>
References: <20221027210830.3577793-1-vladimir.oltean@nxp.com>
 <2bad372ce42a06254c7767fd658d2a66@walle.cc>
In-Reply-To: <2bad372ce42a06254c7767fd658d2a66@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB8852:EE_
x-ms-office365-filtering-correlation-id: 1c25d47c-1a48-48af-61af-08dab8c6cd4d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AfWNqzNyl54e5FUxoL0HL9vq/6mDNpDaQ03VZHz4O/ek431Z0gmf0AaZ5Oqse6Lg1HJ8KdEmbdmIy8qxQsAHjtQlnJvSDmIR96wlZPedg7NEVDrrB3GSSTYUPB1Lxg2AK7fOyTyqebgx86Gve+e114ySUmXh4raFqYdDYQDFwUoD1c9CpPEjdbBGprYy1Ze1b25YBASStjX0903BjIGUkEDXfrNa3a/EJvvjxhCOfyDXj8YBBo5ov20KOfaLkbbBJrHHU0tOer+c9Ffi939BdlRssqyD8sBuNx8TZDwbXLhxaskX2jdjji6zUdevSLxkiRawjJ6lBFfRmI+hBA9SEKlet5uIqtG6rCu0qeoDEYzf3wNjz0Fd9o37CravKPyZu+lciVjwzvFsf5dlDe6Yrc30TToBolZDLiDwY5DgRMhOn/e6GNjkIq8AT7MToNso+LuHojYDrziJr0w454M3CMqMBMBF9LzswOKGeXspsjRlbLaLUQtYfLuKLU3kbb8Rp+JH6wsKxdOpuIt12E8cYD4GARixw5NOrI18AXlOMjMhHtLar5exoWbJGNUKL20jYduOpqq7Vnhp+HS+wPRApZHOfIzPWdOyhVT+9Sm6eo0wUTTg12cgIupc5Z0VDE2YX6nekeDqt83Et+yd/tuUlJrZPQSLX2PROJqipWURNeU6/hjAQyI0pu/YpNC9aisK0KUxzEyuIECJhk2bfoMe9TxqhRBQqPAP0RcEKPtUTFfoZ+71J0OYTvEDzEsM/p8T505r/d0m8Wx8aD4pHeBG1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(366004)(376002)(39860400002)(136003)(396003)(346002)(451199015)(83380400001)(4744005)(122000001)(5660300002)(2906002)(44832011)(7416002)(38100700002)(86362001)(38070700005)(6512007)(1076003)(186003)(9686003)(26005)(6486002)(91956017)(478600001)(71200400001)(316002)(6916009)(54906003)(8936002)(41300700001)(66946007)(4326008)(8676002)(66446008)(66476007)(66556008)(64756008)(6506007)(76116006)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qzBlRSTNf5N0wajY4UxLakYyLRgyk3lLv0QBXlpsQBxxmR1oPQs589F0be2x?=
 =?us-ascii?Q?CSB13R6LHVhE/mQOIWlrXYy1wzUqO4xhnBaLJsvZxBnzB9o1yTWn9qkGAFDO?=
 =?us-ascii?Q?U6ASGMqnUxLfaLOgroh7nDJ4ZP49S7rbsmnnec/XME6yvJJ9U6juNVcXe6QX?=
 =?us-ascii?Q?5esHQ2NIb2n6K7bFKpqNB8qCxBGflcCfUOOAgKq6Er3kbNTNKqwwdB1iiVMu?=
 =?us-ascii?Q?cW5IdNtinlsGRJgcsrJe6i/mnfdQUlUrjLIAe1isbzv0/dT718JrqpUlN3zg?=
 =?us-ascii?Q?KWm3fPwqcbSQaMzJfcTE3jBMU7P7fVJ9Fsj4LC+ivKwKjf++dcDgat13tRvH?=
 =?us-ascii?Q?+mfHyXLIT4iIEmCqDsn1hHLIgqWnd2l+z/C3ma6MEIGTFerSouBCqBwu80J+?=
 =?us-ascii?Q?pZ1aRbKnAOJPIV0AJ3nHsG8Zlxovtb5zaWdoGWSAHiQSp1NrxKH54Hj8IR/S?=
 =?us-ascii?Q?OwAihCbHw5jgx1V7QMS1mYNhCEt4M0KGA/RT6MatPBBw35kARBblJlXMWK/u?=
 =?us-ascii?Q?697rUSlEqOf6DCoddubjwkv2B+5qk1cS7feBIRCJKHehzdDw9TNtDqoPJ2zc?=
 =?us-ascii?Q?dmn11OHKWQ0FOz5ky/X/jzcIx3IPflXYdSU7wg/GxUnOnTm8KGnmF7IejB+Z?=
 =?us-ascii?Q?08++eLDliuy2uznWGkE/7uIDivpqjgcUHnMSK6ieppLWqMarWtbm/up7t9sV?=
 =?us-ascii?Q?vxzuM10CkvOwGaGVmNtALc7nRS6WLwnkOFFBl9mgzvtYaFbgZLFvEks6cLWw?=
 =?us-ascii?Q?iFpR1BORuC07+2GHraD7fOxekSErI0tIBxE636K+0HG1XC7UpqsyjXMFSd2h?=
 =?us-ascii?Q?9FUU0L6nR9c0dbAdkjLClC3KsnZ6kePJy2jX8oCI+lXj5MPoBRE/vtXHkDHc?=
 =?us-ascii?Q?DmpQD/GWJ+ee6XhPdzcPLeG+29c5XNPEbTEj3D1XGTJ3Q3EiHSPGS3pkZ/mq?=
 =?us-ascii?Q?iTAVjE7FdEN9/uBph1Uz6hYcn7gdNN1GsE0aZihAvsOE+NLMy9uC0ZbyUdJN?=
 =?us-ascii?Q?c6Wc15O9RVaUCuVdiEzeIB70oV5FbmVswzOmQ6UTBWc5k1Jn6Z3NlK4/osda?=
 =?us-ascii?Q?0WaQx/XPWsDDYXSXj5vBJmTFVcQWVi3Uk12UJjMW7GvrfV5ioMkMxT6/nuwJ?=
 =?us-ascii?Q?s4pfJpX5S6JJ80k4jVjF9VA3nGxqRv4CpIqZ2rEwHIwCiqK2lsVKEp+slfXU?=
 =?us-ascii?Q?2sYjxoJ3H3VCTSR9cB64VTeZVay7SndjwRn3WnSg1Wu7gEr0hoz/bR9Zxj1Z?=
 =?us-ascii?Q?UGbMv1oYbWLKoNGadCU+dYuNIdDy0ypM8Ft3str0bKdsWtju0/PTUTfSOr8d?=
 =?us-ascii?Q?1OK5D3tIEmOtuGI6qyeuAoP+qvD0zejioAEnx+iNXoLYydm6XygC+Mq8iYnq?=
 =?us-ascii?Q?iMvfZnxbHlooqq6R9saepZY73XqU8rzYqBMDMun0W6VOqykUj49jAGWiUAV7?=
 =?us-ascii?Q?9nhkNQkXbGpaZLQWoZ0sA8cH8LqVqXgGtzGz5qiOJ82DrJTHc6prvxVth9uE?=
 =?us-ascii?Q?t2yCrRIdyMEZJFQ2WkfGXVBCrzhAz4uxxlzE4Q2WzGHuEGPej8BkVZ0W2dVX?=
 =?us-ascii?Q?edqcD7O4dB+TEBNV3o+s7YgNXDcFzaa31PpOBiW7eghLDzwp+pmfEzXx4ODb?=
 =?us-ascii?Q?Gw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D43E0DC6A6D12A49A5CB26422AF6E932@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c25d47c-1a48-48af-61af-08dab8c6cd4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 09:28:41.3469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7BuokgiBsJg+aMFuyo/pELL0bHLtyAEUu+cFPvbW6IeFRVBOlWFeuge5ummk6FvKejj5QyhzleblQzSjxJ0dzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8852
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 11:17:40AM +0200, Michael Walle wrote:
> >   alias:          dsa_tag-ocelot-8021q
> >   alias:          dsa_tag-20
>=20
> I know that name clashes are not to be expected because one is a numerica=
l id
> and the other is a string, but it might still make sense to have a differ=
ent
> prefix so the user of modinfo can figure that out more easily.
>=20
> Presuming that backwards compatibility is not an issue, maybe:
> dsa_tag-ocelot-8021q
> dsa_tag-id-20

Hm, it probably isn't an issue, but I'd like to hear from
Andrew/Florian/Vivien as well?

In the same note, "enum dsa_tag_protocol" isn't considered ABI either,
or in other words, we can reorder them, and DSA_TAG_PROTO_OCELOT_8021Q_VALU=
E
could become, say, 19 instead of 20 in a future kernel version, and that
would still be fine, because we would never load a module built for
kernel 6.1 in a 6.2 kernel?

> FWIW
> Tested-by: Michael Walle <michael@walle.cc> # on kontron-sl28 w/
> ocelot_8021q

Thanks for reporting the problem and for testing!=
