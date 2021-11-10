Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1E044C168
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 13:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhKJMlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 07:41:40 -0500
Received: from mail-eopbgr130059.outbound.protection.outlook.com ([40.107.13.59]:30439
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231210AbhKJMlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 07:41:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AubSW+EkZthYN9Fw0xbSr6rDB//4DRxw0xNTM+OgJFU/PZIzdH16/ohhkhOLqIetrBLSEO5MWdVkpC/wnvod6CQksQ5TbdirDwW4RLg5ZSptl75Yksgh8csrdXUGsxla3YS8VR0k6QtRPe5+DE4ITwyhfSCnyUsa9bJwyK/UifPpAZUQBjdp62K9vLXRiVYVvRO2mLUSGyx5hDTFrrAG2f7VTWwK0Mwnc7db1NManXz6bSRJ6wb1tlhCgxlaPShggYTHqXjzy+hzP3zTpdqm9zZUI+lPQXFxDmL0L+hCSbZJNKWV4oOAE7EbHI0GW5d4eHL5g0x64Hd5fphIOSH47Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dT+tYcgPtBaduBEatQbSnTN32nn30+9B+OJlHQmyFA=;
 b=ZDWDxLqjx2nf2/jzT5F6wzoe9BLXjNo4TgEce4+mOKkcatapEBYLoCJXREIROwSd2xSm/ZyRObgpwDjjcjsOAppdO/XyFPDrmrLCYnxQ6lyhQn96sv/+dleMZ4Y3WmrkKlt50mJbJi1/Gd9affnXwqLfWYxDy3c1J13OUObdMNw+CvWjM2Csfkoq6kXDtjpxD/hqXMa5dkkOCq62N0O1YRt3pXzJyDB8h5vczrlTsjV/3ZjO90UTqG3AFeJf5WwBVyVOBumIsj54XOkk0zPlQ6uoZJ+ByoPbps352y4TLhHvUz39yxnaNmwjdSIyu+M8idBoVyBLuTYBF/J63qTwHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dT+tYcgPtBaduBEatQbSnTN32nn30+9B+OJlHQmyFA=;
 b=lajKnWYxc6ZJbguHp1x5kENSZHOBrochxUH+1mYKvdFcjY+hTdkJ0Na6ogKvn/sXDJwnFMlx9Cya0szA4sok0nrayWx7cwecFAY8q/BxcFuirv9sgXhNdB3yn6YNqsMoNNf1sOi2iyhJI+5lqns4k0FtuhAU9SSEJZzm7kYRaQs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2512.eurprd04.prod.outlook.com (2603:10a6:800:4e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Wed, 10 Nov
 2021 12:38:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.016; Wed, 10 Nov 2021
 12:38:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Michael Olbrich <m.olbrich@pengutronix.de>,
        Holger Assmann <h.assmann@pengutronix.de>
CC:     Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Holger Assmann <h.assmann@pengutronix.de>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [Linux-stm32] [PATCH net] net: stmmac: allow a tc-taprio
 base-time of zero
Thread-Topic: [Linux-stm32] [PATCH net] net: stmmac: allow a tc-taprio
 base-time of zero
Thread-Index: AQHX1N9HLp/45dXZAUyXM5qWRykZXav6262AgAAlfgCAAD6yAIAAAPeAgAF1OIA=
Date:   Wed, 10 Nov 2021 12:38:43 +0000
Message-ID: <20211110123843.3u4jo3xe7plows6r@skbuf>
References: <20211108202854.1740995-1-vladimir.oltean@nxp.com>
 <87bl2t3fkq.fsf@kurt> <20211109103504.ahl2djymnevsbhoj@skbuf>
 <6bf6db8b-4717-71fe-b6de-9f6e12202dad@pengutronix.de>
 <20211109142255.5ohhfyin7hsffmlk@skbuf>
In-Reply-To: <20211109142255.5ohhfyin7hsffmlk@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9474c9b-0ffe-4663-8eed-08d9a447086d
x-ms-traffictypediagnostic: VI1PR0401MB2512:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1PR0401MB2512A0D5944DCBFF789B716AE0939@VI1PR0401MB2512.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LN7qzJ6W44LCdWljR+EgykzrNuzoZyglNF7wxyR9c6xX9hYtRZSlvm8coJvnSn0XY/SmLh2oPDleNgH6i+8rHYbMvkxJHlXRpIzgxvm+Am42gIcen0vYVEJwAd+j4swuElMdOcqTaGYzXXnJyhk3+VSzUtREOD+RrEsWjd/mGfD4bjS8ElMi3KCFkmCju36YPWOJdY74y+8LGdC4gimyBGpz/5PMBumsPn32N9YJeSvmHHEXqtJOKOuWjifg/TAF/o5EqOZZCnXx/SPji/kdCHcV8Lb/ADXi33gpgoJtEfYOeO5hQfHmVHsXbbHIB3+MKJI2fujgz5woa4JLtTzzE9dginGeD7i/7wsOVo/VPzBWmvlQsxy6zNTuzGL0b9D9llmUgOTLq4EmLS5n8W9JqdRFHMS7D22kP/DsEgQiZKxh73HfnguLFJKhaya+o83qYOEFaC7IqSWXoH38qRYYhtACXfCzVOqpY17L8aV7g30m2HG49QdtLewE4I+skdyU9KfZsn1AqA1IGyUOCpgnmhZLZECnQCgm7Gg0DOmt2YOZjOmk7uJ/b4vLxiYhRRcoKWQffkMPiZincsoyXYz9FdOuR1nlGTo3vHmiuQgWJafB9yoZYMELKrhCmUAAGllFxQW/QVFIPLbqL7B4BHacEv1Ttwg4HrBpFKbsV2lxnr4Q0XiQh1bn5PWfrDcf4hp9w4x9jeCOxZVhQ+v3lfEOzxjATo0Doaq9/KEBcfB9mG95yPsWUE6Ppum3CkmdSIrOfiAw6Vibm8wgmPhW/p6sy12kzaULg2QWr+nU1k3hAU8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(316002)(44832011)(71200400001)(110136005)(86362001)(5660300002)(33716001)(54906003)(122000001)(7416002)(38100700002)(38070700005)(26005)(6486002)(2906002)(186003)(8676002)(64756008)(4326008)(9686003)(83380400001)(66476007)(66556008)(1076003)(66446008)(66946007)(6512007)(53546011)(966005)(6506007)(76116006)(8936002)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pnqwgwMg/WXFu4GiYHfjCYfYYWYHZuvL8VNRpdoLWeli1nfYzhWy57LZgebK?=
 =?us-ascii?Q?8DxarNsldyvOn5L8HpDsiKwW8q5auyEe9yjMWPlImbzkN4UQYG1YeV3hpjnf?=
 =?us-ascii?Q?etlbnwmsN8CmItRW4It893Eb24EDL5OhdkBC9yvaDkbrxoLgTxf+Q3/LtHxt?=
 =?us-ascii?Q?UfsvORuUGLPzuo4R1LhohvfOypOVpFpRy5Fk9JyxZ1aPsVwz4FCCAScddHXw?=
 =?us-ascii?Q?E13J+JoZfsvqoq89PC0sYVTPXVYjofANSf5rhC5WaAn5nDju4SS2qUo20es4?=
 =?us-ascii?Q?PVplOdfhHRml9bY76lEnWJ3sTYkaHQwi7i3SFblLLpy5wNvY6U7/z1wUGwXA?=
 =?us-ascii?Q?qk2gXpns1ywX7929WGUpHj68gSuvgJEbmPykYVmq4a6E3yWRytzJVl5R8QWC?=
 =?us-ascii?Q?7LmLVS2ajv+kX0iLxizGn0ojVyM7NWSN367iVrJyWd1sCNaGNj158/nPkx4d?=
 =?us-ascii?Q?+4+HXSCskdKSKF2K7Q65eg7wwqcNODno9tn719zfZrJ89R6wU61M+TJo2CJE?=
 =?us-ascii?Q?MQD+u6ftFwsj/rtLWfr864WARru/uxbKkmmXpbgcUefSM4+8bRhcp2LXHg6e?=
 =?us-ascii?Q?hztt4wbxdP/XmBJMQ597/WhVs4JhQL3YYbmLy2OFWN8K+aP6e7XqwXJrQrx4?=
 =?us-ascii?Q?BUk5dzuDVVQbN1i5IzIHUngjULfmh5u9GO2r+hKqkiZMjr+SVB6tTgg5O4DF?=
 =?us-ascii?Q?agoDOkWTCycrZJxK1l0pyQMVeWLYFnbAsfJxxOSiUk8UNiDetZlp7OufyCbz?=
 =?us-ascii?Q?hA9FOeR0CkEsOSzNzy+BGP8uiC8N2ugbfU5LqHzTn3wYIu9a05g5fjPl1wMC?=
 =?us-ascii?Q?IWJqtvyfcBRJliJkSeQ5nhIB/QUmazX/Cs4qBSUFx5FxKHRwZevop4yDuzrw?=
 =?us-ascii?Q?btwCSvCII0I/IdmVHXMOicdnBoUhQ8SB358kQj5oaDB+Go24P8kFKt3EO15J?=
 =?us-ascii?Q?jzwGVkAZLLl8UOsHtI0YHE2dzN6uUTQs8tyUHNkvKjvXcZbZ3NByCQMCeaft?=
 =?us-ascii?Q?QPuKGm0nf7K9SZXOP35C9eTB4on/OU3k8PLIPRPSpGl/op17TMs7w0wGSCiZ?=
 =?us-ascii?Q?e41Ir9WImLRjR7SbEG/riOepu2ueunUSQmcv7UurrZAlWmMIudLqKNbcWOfy?=
 =?us-ascii?Q?duUg4DlO4Bqx1gRfoJrs0R1OXETceX3O/L34ONyc3CrqPw6nbsvCXG99OfrR?=
 =?us-ascii?Q?G1l+HSVGutiLAzTK5nzrNWyyMqwXM+e374wqXP9P0wmqYMrDvBshY68gHPEP?=
 =?us-ascii?Q?NlEXSxDR5ENBSWZuTErjyPiaP56KetatoN7LzP4Dgqsvb/lrlXEorNIBA72Y?=
 =?us-ascii?Q?1SbnmqHndD7+OOFkK1dLfsuO3FFNOL7Yqanl5gf08Wbck4ywPjN1JFp81rXz?=
 =?us-ascii?Q?4pMWxiWktdhiyIKQPTBMREhT5TWgBZh5TVx9gJH/WmnV8ELa2D5MO31v8mIf?=
 =?us-ascii?Q?9l0ix+T42YY7p1ty3nyf6m/FByOAJG1KQWuz8UDCYHyNkOFc5VqyA9QVsMIk?=
 =?us-ascii?Q?0F1HS2YRkytn28wM56wlw2fVQoh882prxe6MYS11gD4O53GsdaSlb7ZmwPsh?=
 =?us-ascii?Q?yBKLn0s+EUm0l3RvjAZdVkh61mDsXaX1SlbCl0Y8iFJp3Y1wgI59vFZjC85w?=
 =?us-ascii?Q?vo4T4o/iXEVlw30J49ZJTuY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A81652E6B8EE054D99F851AD69956E1A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9474c9b-0ffe-4663-8eed-08d9a447086d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2021 12:38:43.9887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: huAkNNQ5V1YP8MSJzxhvC2d5nO+beXNB4DpzhPpou/RGIBuf0cVF46CPr+zxTH3XrH8oD0/UJCxpgkHGVY3/gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 09, 2021 at 04:22:55PM +0200, Vladimir Oltean wrote:
> On Tue, Nov 09, 2021 at 03:19:28PM +0100, Ahmad Fatoum wrote:
> > Hello Vladimir, Kurt,
> >=20
> > On 09.11.21 11:35, Vladimir Oltean wrote:
> > > On Tue, Nov 09, 2021 at 09:20:53AM +0100, Kurt Kanzenbach wrote:
> > >> Hi Vladimir,
> > >>
> > >> On Mon Nov 08 2021, Vladimir Oltean wrote:
> > >>> Commit fe28c53ed71d ("net: stmmac: fix taprio configuration when
> > >>> base_time is in the past") allowed some base time values in the pas=
t,
> > >>> but apparently not all, the base-time value of 0 (Jan 1st 1970) is =
still
> > >>> explicitly denied by the driver.
> > >>>
> > >>> Remove the bogus check.
> > >>>
> > >>> Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO schedu=
ler API")
> > >>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >>
> > >> I've experienced the same problem and wanted to send a patch for
> > >> it. Thanks!
> > >>
> > >> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
> > >=20
> > > Cool. So you had that patch queued up? What other stmmac patches do y=
ou
> > > have queued up? :) Do you have a fix for the driver setting the PTP t=
ime
> > > every time when SIOCSHWTSTAMP is called? This breaks the UTC-to-TAI
> > > offset established by phc2sys and it takes a few seconds to readjust,
> > > which is very annoying.
> >=20
> > Sounds like the same issue in:
> > https://lore.kernel.org/netdev/20201216113239.2980816-1-h.assmann@pengu=
tronix.de/
> >=20
> > Cheers,
> > Ahmad
>=20
> Indeed. Was there a v2 to that?

FWIW I've applied that patch and made a few fixups according to my
liking, and it works fine. I can resend it myself if there aren't any
volunteers from Pengutronix.=
