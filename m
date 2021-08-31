Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A353FC475
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 11:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240399AbhHaIrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 04:47:10 -0400
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:37824
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236028AbhHaIrK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 04:47:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mW8K9zdXx/prm+ZHqBAso/iGAdgoxVAjmVdrGMIqqIDbYISzDP4pJgR0zWh1xGoBqBoCXFahN5z2kkxh7HJtT+I/33RSZSOni+pP2kC6WKV9aU0ppgI90Eaz/d05aguh34TPehDY8SvF/fkDmT+d8aHkmr0QCcsXclkFlVVLi5G2UTy4ZKarw3Uo5yu+VmyOfuGNZEWogTns/xHow/I/D7weDuVbgNC3TuHDTUsq3/F7Jo1OCsVFhmGGmLn3uCk1i1+e0oZo/dekeBz5jKG7d69uTDWVK3DERS+Hi/DLAR+0p9O7uyaQOFa4f3bgjjm8IOQwMJ1jo3jpHTAj4RPv4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gHsxlmBG2naWKTby7VSn4YOnoBuDssE0IAHYYan34A=;
 b=NJZXGTZQqDRlEJQ5WfDe29T6WqonNSrYETqYGFRWYlAICIfUgzCuTVtVkDCBBDxjsLJVaqSOb7Vb9NjJdsDzKUWXVFIW45Z/BNOwqMKIMYt6vpPn8zzn/c9/HUpxv0plax727k3PViaMKtIfI/XMeJXSI15P/s6hah+FrBAJhoHJwlcC/OrEcoSzKGiVqLsb9I1go3X+yzqZU+nfDuovbIwUZx10STumJgE5P0hRvfqaytZ1d9jzYaJ4PdX7OTeOzvYbLwwegY8WQrrFMy0uWMfwuM1e4vxGunO1bfsyKnrbkgfbS0yQaDMgs/p+GpsVIXDs2TZzmevmRkca7j+XUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+gHsxlmBG2naWKTby7VSn4YOnoBuDssE0IAHYYan34A=;
 b=KchRGlSO5U2DloUTPcxmfGXCxdbvJfiqkwDiYc41VJc48LIuTkkeg+HK9lAHoVaBI/nLjC2FA5PsHi3RB3crrecCPyBcjf+P05TkZKzPadbZpod7KRa9SEidYlCg9LAc1KEBavwQ9bn6V+EuK3O5Mxfg4Yd7D/M6Eg4h7kGJBg4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Tue, 31 Aug
 2021 08:46:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.024; Tue, 31 Aug 2021
 08:46:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXnhk3bR+2BJOkCk2OO1PW76puEquNPsAAgAANEQCAAAFHAA==
Date:   Tue, 31 Aug 2021 08:46:11 +0000
Message-ID: <20210831084610.gadyyrkm4fwzf6hp@skbuf>
References: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
 <20210831034536.17497-6-xiaoliang.yang_1@nxp.com>
 <20210831075450.u7smg5bibz3vvw4q@skbuf>
 <DB8PR04MB5785D9E678164B7CFE2A38CCF0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB5785D9E678164B7CFE2A38CCF0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a7c370c-ddfe-4849-2a29-08d96c5bc8c4
x-ms-traffictypediagnostic: VI1PR04MB4910:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB49106B4940A24D5311A507D4E0CC9@VI1PR04MB4910.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VUGhtQWyLjnMBwdXOTnHIczfc9FcZZLJQroxB6ESGfckGTSE2O55qOI8gsP+3YNZCqZn/+bqH/R+MpIBpqa6QNcSV7RWyYlIaQ7mn8HM+8AtBb8CRJP9c/WvzndpG4VAreheU1eoUyTAoSMLTELuanhF0+T2VrdMpE9ocrhwV3vugASjI7hGHxaftMm6x14BY29VBPk4cJKahBHpWs8lpVJaV0HBBYX7fmhTWph58vvebg+wz8xj2hHuN5jfC5T3VqrvD4sj16xgVStT0Q9jaES3VtVU4J1BxzVbW+BcmJHPXfMBLskH4dBVZLdkwbURUJkaQaZwEsXFkXms+d8ApVj37FgT0m1vTvsOg57yLhai1Tloh2UtyRHUDzX0Jagx/r1Jxl9xAcRhy2Y94ruU8VU7zgaCDYCD8HkmWQZUbFQ7TvDLFHdbt6NbeOa2dEGVKuCULoelXk+bMxF49j/nrgjiQYRii2o+nHX4m9kztWHqLhPZgXIKTUyTwveb4eZObG9TWzDUWWgmJrzjhZ9yJ+JxyI6wgWdHrbqCxtbsQhrOEX6X8Do3i0lSo9zoBTdJBYs1bxm+VTmcmycSAv61ch3hZqv9KFjCa8uLBamiKrSA7nd7NRYiSyYeYmCQU1MDJmq7cjHkJ6SzO7prvuUBa8OxETUV2xEHvU04NNdz3YJFV1wB3kq7K2J+hhFRcWOwANzdC60AtYWDcIcyedTBqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(5660300002)(186003)(38070700005)(122000001)(9686003)(6512007)(71200400001)(7416002)(86362001)(6862004)(1076003)(33716001)(8676002)(8936002)(6506007)(6636002)(91956017)(66556008)(66476007)(6486002)(64756008)(2906002)(76116006)(26005)(54906003)(316002)(38100700002)(66446008)(4326008)(44832011)(66946007)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EGEAMIk2fMSHMo6gIG+/Wg+CWK9plRzA7Z+Y+PBLOd+0s7icSJ93mBuJCRpT?=
 =?us-ascii?Q?ijFEXK4ZDdaIFfm12gKI6pQrmaoWPyFWU6D64V/oCO2WdGYKYbpbxp8AbV3a?=
 =?us-ascii?Q?OqoKhWr7mj+eEqx6b/Fj0/H5M/r+4sB98DzxWKaXkJoQCZffmtUbti5ZjvN8?=
 =?us-ascii?Q?KaOFFb7fmjwrZBr2Hqvc/TxZ6JAy/v9mgGdi1BJEnbfy/XY+IPXsmZQZd76o?=
 =?us-ascii?Q?geHKRpWmoaN+x/U4uIP3CGQXDxmWHvR7jCfyb8jmadrV4yMJhyaNmSObr6em?=
 =?us-ascii?Q?HZuJH08hDUg/7RAAJlCwg0f92pDQTiulbTNETvK9t0bo/4rTj3pcVR6RVkti?=
 =?us-ascii?Q?rAb4nQmD0RJlcM9b3J/CGM6mO5CEJlw0INBD5eIEfpbbcbK61lXGCNvdIicT?=
 =?us-ascii?Q?l6SJ7utilyOX0kRmidVcxjySwpLIXWdoUtcqDx3hJNvC4jlqiHzq+fOdItUV?=
 =?us-ascii?Q?DNFGBfFr/YSfX1gY0ohzyR9qd98Rk/IB90W1HNZ0yry2YLG8IR51TnAA8aMz?=
 =?us-ascii?Q?GRJRauBKkcAmLd7tHYNxn58lp8e2hkywhv2OzBGmI8M44hzULXciy3ZbI/8f?=
 =?us-ascii?Q?6VJ7opf+HnWcJhN3uFUzSLDFrvpftH3kyeYUDGNaAJv4+BmnZEhcl7G2SwUe?=
 =?us-ascii?Q?cwdPcCGlpfsdl9ginkBgdFJXVoZXU+FU3bb3OkLMoWU2dQYgHpTfn0IYa+q5?=
 =?us-ascii?Q?IatHBPhOCd5tEeFYbV1wp6vSFoR6XYkcwfhrWqM89NBCQAvot5pHZq4fiOYq?=
 =?us-ascii?Q?/rm3NVmPuvbTlaBwCskqD12A03PIgJfvuZHikYah120Ccdq4WWUQcF4QBd7z?=
 =?us-ascii?Q?eHq1+tN5qhcrn3C5RpWsEVX9Qkqjkj9V3MfZblKaZaUNH8nVQAsBVvpI3PA6?=
 =?us-ascii?Q?eiNBVWptFQIH5x4iazdheYAczd0uAS4C5nbOGaopAajDVqnz+UmPT7B+O+JF?=
 =?us-ascii?Q?G6Pmy97WScEWmx5gPRTXLTpowYI1Zz+pNCC4oLZz3lQp0tbInfCgOPz2DPVl?=
 =?us-ascii?Q?TC2eQOx2r27AswDt2C7i714VhVxOmou6sh68Rm5KOB7y88V7aApxE5gPq/oh?=
 =?us-ascii?Q?Hy/8oAM5xiS5sISEIORfqUsMNx2riiQod/CUss7c3CMimIQ1KaUQqonx/6up?=
 =?us-ascii?Q?SK0EnEY2TJ7j4LsLkFwqlKVsWf9w8NRLsIsC3baADuLM7l8n1BqPkCFH3+at?=
 =?us-ascii?Q?R21J8q7GeQXQljC89DiIQoDa921wjCrJKt/dV1/ICgerc8sk8Pxz+va4yLTm?=
 =?us-ascii?Q?Lg5xNaJEhd6J/JtUQGAQjAntaz3/zZ1SC8OxFpiJvXMQ0+LgY/yS2e5IcTJp?=
 =?us-ascii?Q?VXdCrB8ENl5Mf/tyT0tuZkonK2nhqiibwWi6zAWA8UbcpQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ABCCBBCFFAAD1549913671D80B9055F4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a7c370c-ddfe-4849-2a29-08d96c5bc8c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 08:46:11.3939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: od8PkQ107zJu72b2hpdKcqSy5UIcrNkJTeG4nG9itlgjmiwpehnSTkANhjzErgPei/1F+iH6YugsvM7Rb5SmiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 08:41:36AM +0000, Xiaoliang Yang wrote:
> Hi Vladimir,
>
> On Tue, Aug 31, 2021 at 15:55:26AM +0800, Vladimir Oltean wrote:
> > > +static int vsc9959_mact_stream_set(struct ocelot *ocelot,
> > > +				   struct felix_stream *stream,
> > > +				   struct netlink_ext_ack *extack) {
> > > +	struct ocelot_mact_entry entry;
> > > +	u32 row, col, reg, dst_idx;
> > > +	int ret;
> > > +
> > > +	/* Stream identification desn't support to add a stream with non
> > > +	 * existent MAC (The MAC entry has not been learned in MAC table).
> > > +	 */
> >
> > Who will add the MAC entry to the MAC table in this design? The user?
>
> Yes, The MAC entry is always learned by hardware, user also can add it
> by using "bridge fdb add".
>
> > So if the STREAMDATA entry for this SFID was valid, you mark the MAC ta=
ble
> > entry as static, otherwise you mark it as ageable? Why?
>
> If the MAC entry is learned by hardware, it's marked as ageable. When
> setting the PSFP filter on this stream, it needs to be set to static.
> For example, if the MAC table entry is not set to static, when link is
> down for a period of time, the MAC entry will be forgotten, and SFID
> information will be lost.
> After disable PSFP filter on the stream, there is no need to keep the
> MAC entry static, setting the type back to ageable can cope with
> network topology changes.
>

So if the MAC table entry is ageable, will the TSN stream disappear from
hardware even though it is still present in tc?

I think in previous versions you were automatically installing a static
MAC table entry when one was not present (either it was absent, or the
entry was dynamically learned). Why did that change?=
