Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E65529996
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 08:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbiEQGah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 02:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiEQGag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 02:30:36 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00064.outbound.protection.outlook.com [40.107.0.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0C944A2F;
        Mon, 16 May 2022 23:30:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndDItENE7XVm2N7yVaKp6Pkgl9864Pj8am1peiJj3vhPjkJSrqLIjHdCcI14sS39zgYG/85EcWrODynBHzzZQc6uc22zPMJol9UiDUqWDb1LGdx8BQhY3lTW/P/xC6hU6z1lBKiN6yhkfnJNFjxa1Cjh6PgYaNkX/bNQw061N0R+xCF1rlvUnAJOJb3n06XkvBTfPvtVAK3h6E3pIVr9urHbDM3Me8D15SrIKVhTQ8BJodP2SaFC9qp/Sccgu4hNxleN9PgDdbk5dGIb4+XhIYaWgrNgtZawLW6VZdevyzZ7Ib5XbZ8P8TLJX+Gc6cubHsOeYvKXxb6elUy8uEt04A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/O5BFQ/voFbJlXvfc7ECfQClnqFEdOz1Dzn+pQ3Tt9U=;
 b=MGb15zPIHw9pLB9gT+lF2AcGvKOUgVw5UIL3nLgheGuNYk0Le6tkX2xhWprS473EcUbNvaRSRnjozBYoFRDx7r+J/rLV2pcCfHZLht31Dnfv87uSHL/Ii+gS8SkfJ2yF7VnFMb0Qo/0DLmqfC33LJ3xN/rG1KDPlh+IrMz+8498D76e0jlO7g6HEM5Lst48Ltwl7K4wly9nlWKfARvrZStpxv9cYbmAzIddhpVAYaK40+gh8VRe36S0w5UQMNd//dWXRIvrRLiTBV42lQ6o7fZ5PfCdbm8uqT/oqZHSTf7612/BS0vvuDLBRBges5n+7G6xbDcOl8KRkTgj5Ajnu/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/O5BFQ/voFbJlXvfc7ECfQClnqFEdOz1Dzn+pQ3Tt9U=;
 b=lX3on2hiu7HYRXdQH96MTlW5+Z//bpY1GUAYARI2orMRSel9DgPlZRzazDr/SOF0HSpSNh0nzwIBLnRv4uXh5Uu8Z1bPYCYwGuxr0kF16IvoPCcZjm5Vjv/jIKenJ+rt1No578ixUW1sWGsNYEEPJj+s+Nn7fNEsS/oN7EedO8I=
Received: from VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16)
 by DB8PR04MB5659.eurprd04.prod.outlook.com (2603:10a6:10:aa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 06:30:32 +0000
Received: from VI1PR04MB5342.eurprd04.prod.outlook.com
 ([fe80::9102:a383:8cd8:9724]) by VI1PR04MB5342.eurprd04.prod.outlook.com
 ([fe80::9102:a383:8cd8:9724%4]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 06:30:32 +0000
From:   Gaurav Jain <gaurav.jain@nxp.com>
To:     Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Horia Geanta <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [BUG] Layerscape CAAM+kTLS+io_uring
Thread-Topic: [EXT] Re: [BUG] Layerscape CAAM+kTLS+io_uring
Thread-Index: AQHYYLVEoVF2rOzAV0qB47N0wrw+pK0Q+dUAgBBd9oCAAVSNoA==
Date:   Tue, 17 May 2022 06:30:32 +0000
Message-ID: <VI1PR04MB5342B4B4BC56387BB1193997E7CE9@VI1PR04MB5342.eurprd04.prod.outlook.com>
References: <878rrqrgaj.fsf@pengutronix.de>
 <20220505192046.hczmzg7k6tz2rjv3@pengutronix.de>
 <20220505171000.48a9155b@kernel.org> <87sfp9vlig.fsf@pengutronix.de>
In-Reply-To: <87sfp9vlig.fsf@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e94d507-66e0-4ea1-15b6-08da37cebe4d
x-ms-traffictypediagnostic: DB8PR04MB5659:EE_
x-microsoft-antispam-prvs: <DB8PR04MB565946A623B28297523EBB20E7CE9@DB8PR04MB5659.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 78snPIslfNfzXLVPy5/3vg6typFLFQwQkijILYoZBd6Gi8epw6BiAduuKBZf3ukkQgEyzlEMshAokzH4W6iSVMVSNP/nZ1yvZ2yr3Ev3Rl/MisGhUaix9F8feyjbjOsTUwc94G+SO5SDmu2h5ViJnebfE5BE2Q3sWqM6kmvMZ8Z5C9HiGDLVpUhihftWGNen1eVeRr22tePqdy52wU/vDYibbPQTbIfJa3n+LFpxGOC9pkMqhtKDSTe0IpMNXxRJpGjiOpoZ1G62roiVZGg7KLZlDbumse8z4R1Qpd7NhyX3liyZRizGF60NbO8eM2WOHXsff3OIC5rxPjjSwg/t1w4ey9kbdKwVWvGbHNvXWLK8R4Djc05rg0P46ufc1Cmvqw5+E5tp6YN1AbR2iKx1ezf9iPHLzvmCu84Mccfbr2XCqSNlBWLJrFj4MEetQHg0fGZihn1xevnS5rmVrnIJT0KLZHSnjzjqSzhv8C50tNCyTYDpCVZom9M5s5uVNqliJdOWYsTl9hHhfzLLbpe3zhWKy3eNxJA+ITredxLUNKMh9RUdqfk7t4nsYQ+LCPiXgs5LOJvYc4d5QkeDEeYDKdEZNMuwqCNkoQi7Yt6vxyipiTrb8ik4v1rcWLvtw+wrwPkIzrjIAYrh+0zIYy2uXZ5fyP2id+6cFnK/fzlmldnZCVQI/nNHGI9AwV4FzfUWwaWdXKc6/XQmcl8qjxV3A5xOrmkUII3FiBOeAm3oR4YVpYlsFtGIhtVAgg0uPw5zm/Io3cJExY5Sh9OITemUVxs0tDbH2dQOjMhvoOu+ubg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5342.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(71200400001)(38070700005)(83380400001)(38100700002)(53546011)(7696005)(55016003)(122000001)(6506007)(9686003)(8676002)(110136005)(966005)(54906003)(44832011)(508600001)(186003)(316002)(45080400002)(52536014)(5660300002)(2906002)(8936002)(7416002)(55236004)(4326008)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(86362001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F5v5wzqfehGxM6+QhKtUjIYFXDFjhNpvRK+fUTnU1gF/A3rSXt2Rxm6+C8Na?=
 =?us-ascii?Q?SvP3A57H9CLRuEjMGcl9dOUguHGXo/F3BpNO5c1CDYJuUZv1GmJrIPJlJXHX?=
 =?us-ascii?Q?p4j1RJ709S2eJ1dZMFoS5sqtc1MjmfhzYE1LnMhD0ziZkkwOfmEmrAf4/sOJ?=
 =?us-ascii?Q?NBJCp9OeQq4/4+0CCvs4S3Bqgppxq3LkGTl624R/0aKDnrnU1xqbDCDzV/2R?=
 =?us-ascii?Q?v5X67HeLM8MIi1y0eUqSNteJuicgh2yVLQjLNZd3V9UmYYWQ64R3v2R9zWyK?=
 =?us-ascii?Q?2NYnPkgzsTOiO8IekCY7CY0pqiglJUf5575+hZYRLCJHGhVA2YAuAsY8DKMc?=
 =?us-ascii?Q?JIZoDdQuBglacE2cY5eZFE6biyc/wusFUKwasWCRXako+1NIMqWK0Sz05eQk?=
 =?us-ascii?Q?mftNAh1HZhXvThereegweS3wONfv1LKavexJKqOazlFmdAE2EaALwoPsL1s6?=
 =?us-ascii?Q?swE/xf+aIlidaTxxYYbfwnqcgNKWPjHxeeyWWdZTeA6zIsG7kWnRsX7LK231?=
 =?us-ascii?Q?7BWpIoC03BZhTrMB0mxM/utHcJ7L9zoPGx7YJzWgbdrTKgr8JGc0WqDfXSTs?=
 =?us-ascii?Q?QfGR0ZDU5l1kM5vD76pZOSekWAueo82oaJVbiOud1M0ba0rNDmsKFkaDYoay?=
 =?us-ascii?Q?Aq/no8x83L8BPGHEuOC1xqpgQ1OLSl613vUPlJVjsmHlER2GQbq5pXWxCoHB?=
 =?us-ascii?Q?v9F24WaImvfx4ixSlWAax5Q+gmBexIfGXLHmQcm7OiPNjWzRbkr9kFfAuIHe?=
 =?us-ascii?Q?vk7l3BSFkb9ebKAJWwBtEffv8yRvCxN3SDJpXApRr0Frge2uiyyBSUQSta1u?=
 =?us-ascii?Q?/sFyBXurOCYKRzQDG5+kU5rDnhfYVdMj/vOthhhujLAN7fRZ995FU3Apgp4h?=
 =?us-ascii?Q?NqoxqYcpyCW5Hl6FuSUrHVxz+4NT8s1Dn3Vu27L5QRDWvyxT5hCALba79IHp?=
 =?us-ascii?Q?/B4W9B/i4fYsD0pHiE47+geNpitJxgWW7Ed2T3Kbq1vUO7tTosAheq7ty4Ni?=
 =?us-ascii?Q?blFP1wgmieemhp+quRA3tnL7Szfyen5TmD+y69guUiUOF/LrqQuEpL8+oZoX?=
 =?us-ascii?Q?DEs3pj1bDoKcV0nwiDbNSXPU0DNu40FOiBedvaRJ/kgYkFR4/tC+cihG5MnP?=
 =?us-ascii?Q?bpMny1mdnm8rae/kQIaLWuOmkFbmY3My9SqhZ+O1tDMFqqUO2ORdx+A7S9lK?=
 =?us-ascii?Q?cfHrADjjztge+M+B7+znvJvugseKQZZIdjm5Imv3BJN3E8oVo7Lixv9EGu1q?=
 =?us-ascii?Q?z6xe4bjJZS1zZ1rUqjvss0DaMJFCvvcpz/8dPfUQxKMRvZ1Zk1hzuRawSbjS?=
 =?us-ascii?Q?Ovhkm4Mms1RMYE//s/sTXW3TE0Jg+41xe6QM/RJnbAUUceAQH4J4l4PBF31p?=
 =?us-ascii?Q?AZpFiXvLD3Sxr+pvk2MFsiQ2TaSwrtYAsEbqz9vhZS1y+Ng5gHmY1AdA/zw4?=
 =?us-ascii?Q?qarnyjEGZJE/EpbBxicnWerRJwHtE1f1wJhe0XDwQVUQslrW7V656BukF0Yo?=
 =?us-ascii?Q?jeA2PR/aSABhv1q5pPv8yLHPsScLHZbQE6RfdL9MqwLwvbnERrnPhuv5yGRW?=
 =?us-ascii?Q?rUX0Yat6L3JpQZvG2uKfc7eQ4qkS0uhxHTwFTNIJXwH6RJrvvZ4z9WMsp7z8?=
 =?us-ascii?Q?Yfcf+nPrbx79B1Bk7Na/stILost9p0rZwcs7bat4w6wwFegXkWs7g7V1V/OU?=
 =?us-ascii?Q?VHXJvNwZJCsmXpkPsKrLg1k9GgccFLIv38ipcBIkFokwWr2zMGjY93vc+MFn?=
 =?us-ascii?Q?dHzmhwz1pg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5342.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e94d507-66e0-4ea1-15b6-08da37cebe4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2022 06:30:32.1235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O43eisyiGgUQTvZpt4oBl+Mca0/QNJPKp5kP9HLHctUBNki+V0V3iCTTRehPCOOG0J5Xt6sxBGmC1fapNWPZbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Steffen

> -----Original Message-----
> From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> Sent: Monday, May 16, 2022 3:36 PM
> To: Jakub Kicinski <kuba@kernel.org>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>; linux-crypto@vger.kernel.org;
> io-uring@vger.kernel.org; kernel@pengutronix.de; Horia Geanta
> <horia.geanta@nxp.com>; Pankaj Gupta <pankaj.gupta@nxp.com>; Gaurav Jain
> <gaurav.jain@nxp.com>; Jens Axboe <axboe@kernel.dk>; Pavel Begunkov
> <asml.silence@gmail.com>; Boris Pismenny <borisp@nvidia.com>; John
> Fastabend <john.fastabend@gmail.com>; Daniel Borkmann
> <daniel@iogearbox.net>; netdev@vger.kernel.org
> Subject: [EXT] Re: [BUG] Layerscape CAAM+kTLS+io_uring
>=20
> Caution: EXT Email
>=20
> Jakub Kicinski <kuba@kernel.org> writes:
>=20
> > On Thu, 5 May 2022 21:20:46 +0200 Marc Kleine-Budde wrote:
> >> Hello,
> >>
> >> no one seems to care about this problem. :/
> >>
> >> Maybe too many components are involved, I'm the respective
> >> maintainers on Cc.
> >>
> >> Cc +=3D the CAAM maintainers
> >> Cc +=3D the io_uring maintainers
> >> Cc +=3D the kTLS maintainers
> >>
> >> On 27.04.2022 10:20:40, Steffen Trumtrar wrote:
> >> > Hi all,
> >> >
> >> > I have a Layerscape-1046a based board where I'm trying to use a
> >> > combination of liburing (v2.0) with splice, kTLS and CAAM (kernel
> >> > v5.17). The problem I see is that on shutdown the last bytes are
> >> > missing. It looks like io_uring is not waiting for all completions
> >> > from the CAAM driver.
> >> >
> >> > With ARM-ASM instead of the CAAM, the setup works fine.
> >>
> >> What's the difference between the CAAM and ARM-ASM crypto? Without
> >> looking into the code I think the CAAM is asynchron while ARM-ASM is
> >> synchron. Is this worth investigating?
> >
> > Sounds like
> > 20ffc7adf53a ("net/tls: missing received data after fast remote
> > close")
>=20
> That fixes something in tls_sw. I have a kernel that includes this patch.=
 So this
> sounds right, but can't be it, right?
>=20
To understand more on problem, can you share how you are offloading ktls to=
 CAAM?

Gaurav
>=20
> Best regards,
> Steffen
>=20
> --
> Pengutronix e.K.                | Dipl.-Inform. Steffen Trumtrar |
> Steuerwalder Str. 21            |
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.p=
e
> ngutronix.de%2F&amp;data=3D05%7C01%7Cgaurav.jain%40nxp.com%7Cc225fa4
> 3da7f4a43f16b08da3723dc4a%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%
> 7C0%7C637882924400875890%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wL
> jAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C
> %7C&amp;sdata=3DfI1BHNZIT5RlpjEdEMXVkv1WaHcvgTlZOcaC0LRojac%3D&amp;
> reserved=3D0    |
> 31137 Hildesheim, Germany       | Phone: +49-5121-206917-0       |
> Amtsgericht Hildesheim, HRA 2686| Fax:   +49-5121-206917-5555    |
