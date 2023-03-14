Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870C16B9A1C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjCNPn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjCNPnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:43:49 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on0609.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe02::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E113A874;
        Tue, 14 Mar 2023 08:43:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMSK+c3+eSG/BRoLqc0IeQ9do2u2jZCQtzNGFMO21Yg89Kzr9tSiRzaXoEgZKY9faeJwHETDEIUMya/i4un6lEJFcoaTw2iGbHx3LbLPnVpWVBZzC6Yw2bED+eFhDZh77Jrc1HkRvxiBZffcHrS08WweMHHEmUzGPaUIruBLREYKpDl15r418QGf14rHXAxY0EDefGEbVS2Fu0G61oYaMRQEhRfs8RmqVRd0/SUPVqxp+MysBcQSNdhhreHKRZxdWEBkA3sPfJ8f9e3ioCKNWCCzzW1Ib4EyjfNrGqgMNXlOX2ZOXMqDr9tnmdgGtrT6+UleNyYlVpTHSEk7Y+EgjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZWaWmYnxAS+LfQEoBPmxmVZhnSDdYkAs+tWm/nZPuU=;
 b=Zyzbc7eFCyXBf2Z20pbR0X8AYIPAQr9ElbiJ/vGVI6LNYA4w+bjPawuMAN7WKkmKqGLPKVwLJdcZVYhB6EEf2967QvrTwRFASQmeXewaMSduQ/BN2D+nkv+TnD/mTDPNxZLL+xLt1qEgajZwlr15C7S9Dvy12kGOrPD/IUdguzjfI/f8jqopq/bmPr69KJouLXq4yeuqzosB8HhAGDwHdWlTckP7Kq9F2OKMVYn8VMdVZ3/dK2UBBg1WzPEoGCt3JcB6ghS/dJe5nfwnw/Bh8anbXnzhUM2JnMBV/O/xuRnHWnCdbAYhDhFHi1onPq+7aPzU/eEoGFJU/dIXfAzZwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZWaWmYnxAS+LfQEoBPmxmVZhnSDdYkAs+tWm/nZPuU=;
 b=SUEXAFFe+OLh/CZYNlCpCNeChnQHHop547mSPu+UFaFmwUiWh43PB1l8SQhzGv6lFxKjv6gci38USAdBUzNsszjE0DqcWLqZV8H2P2SYN0qbvUFCtzS+DSRelyGA1PT2c35fohB0I8Ccx+nPdjzzS/Hg2DseWma/hDnvCSlC7xQ=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by PA4PR04MB7744.eurprd04.prod.outlook.com (2603:10a6:102:c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 15:42:14 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:42:14 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: RE: [EXT] Re: [PATCH v10 2/3] dt-bindings: net: bluetooth: Add NXP
 bluetooth support
Thread-Topic: [EXT] Re: [PATCH v10 2/3] dt-bindings: net: bluetooth: Add NXP
 bluetooth support
Thread-Index: AQHZVbnd3icqlYegt0G4gt8kSub4oa76LqOAgAA8qfA=
Date:   Tue, 14 Mar 2023 15:42:14 +0000
Message-ID: <AM9PR04MB8603FDE2A6D54C31F5841925E7BE9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230313144028.3156825-1-neeraj.sanjaykale@nxp.com>
 <20230313144028.3156825-3-neeraj.sanjaykale@nxp.com>
 <e1b0452c-4068-deba-4773-14006fd32c2a@molgen.mpg.de>
In-Reply-To: <e1b0452c-4068-deba-4773-14006fd32c2a@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|PA4PR04MB7744:EE_
x-ms-office365-filtering-correlation-id: 390ce12e-4706-4456-95f6-08db24a2aef2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uR5P6LWFlhxJvxAQ4aXYWT0J3ou4E/m5LvGRfPjVZEy3YELknN/ScwpRAicJRuRuuRY5Alr1nnge0Hvhh7XXALhrnApEgmj3CLSfnIEtXLHOJOL5AwmP93wfRg8VPulqJzbpSGICM1t+9f1AHPkl5ILS7Usa8b3kvEnbCAWCeUF/WVdrbO3gJZPpzzU1Xm6zhtli2dldZ1JX5wGgJVd3RCImoUwlWzK7f2cS8nIUaJXmjf5eG49zEkQU094BoQz8jVKp5MR8w+dKrB0iBAZH/4dcHyKGeNd1ORKSeJoDDCYDCJkKnNNslwEiwkt/5wBeaPd1xbjrA4IKn0kvw78e1bNQ/jJimMxi08zHgX6Dy7/F6dH/QqcUxZdPi6nawBZYhdxjgU3c/Y5fAGzDwLyyeTXIbYB1djt0Gd6kSPwzuc/R4dNX+N0oGCjMqo082wx5NEoWRVwl57V05n4SSDFJAzBfe8YL5bkChpf5BkiPDbgyLNiP3/NG5JTrfOftMMTNVJS7h+CHt6BkrLrJlN1SC39vOM9p9KGsdarRw/89Fr7brxvb9qQ3AFr33NL8RJcn9h4F9P0xaExaO/1XxL2nphDAlNYVA95lFasCSaxEZoBUhWe45k6qyoMv8cCZkc/AfWMcRmTtm98ISVyr7MIWDRTm9TEvUewbY822Y/GxWfbPlDpOD6emufd1Nq3vbswpsSCOzF+UAIo/Ehc9KTQQXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(451199018)(6916009)(9686003)(4326008)(8936002)(5660300002)(52536014)(186003)(26005)(41300700001)(7416002)(6506007)(86362001)(33656002)(316002)(4744005)(2906002)(55236004)(83380400001)(66476007)(66556008)(64756008)(8676002)(66446008)(66946007)(7696005)(55016003)(71200400001)(54906003)(478600001)(38100700002)(38070700005)(76116006)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RbQijTenooHj2ksaIHQh5N1i0DLvBqMmCkZ2HQwymirlMmbv9fXKITzMra1S?=
 =?us-ascii?Q?FEMjyTktAAFuUMdIH0OBRE+c0Rv7ELa5qW8FTeHqUDycqkRGSv/H9LDx7KwU?=
 =?us-ascii?Q?sSe2rsyUKeQJCrCSAZ63pFfrdjcZBm9U0x50LHivEopMHOAI+9f+t0uIwCJ/?=
 =?us-ascii?Q?zTpgpzlQT3cx+mNU9+NaayZvIHXr7x+48v8iaccycjc4p2eIs43Gn4RO1q8C?=
 =?us-ascii?Q?luxrZ5FFLPR2x90ArzzW3hxT+ZruGzWVwpcdluKnDyhpgf5VvbhmnrBg9gcc?=
 =?us-ascii?Q?rZX8gbzWoBK8cwyCbe45t0ebolajXV8pST6ZSNAju2TYlQJd4P0u09An00/S?=
 =?us-ascii?Q?fjSNp27H/FWY+dAdRq4veS3FAe69foHIjQwQ3su0P7ovkx8PjL2jc/y9q+Z8?=
 =?us-ascii?Q?b62NDryeBSLt/KJh+o4YwVIwlwYY+l2LkiWsKG5B3wrJe8J4mG/0kJs7TtS9?=
 =?us-ascii?Q?ARmqkXZpiHGUgSwQSJ9FqIH54V6KDEnzwbyfmrH6K6rKGX5XvRx5ufYFtOOz?=
 =?us-ascii?Q?zVGKTu9wHcft3/U/gQnZMtsU8jx+xBAQAhrBIVIprPrOnz6/7FVhVxGh7IHd?=
 =?us-ascii?Q?+Q+8tQAgUOafv/fAZhHby3QVudE5NrHHhtJtq+ljqogXFKjd5YyPWx1Gvu1S?=
 =?us-ascii?Q?0r+wGLWMj5aIBp1RWK5vyZOorM5N5IG7QJmwl6CIePuaZzhUxMANVxM2Y6jO?=
 =?us-ascii?Q?6Zb1xdAUNOgQ4rG9pbhEMj8HG7ERQfYNRozFvhfp52eTv+PMwKUcFws5WQ4M?=
 =?us-ascii?Q?apyzYuv5HzLUUDAb26R9yN25Ie603rE2DVbmGw0MQPSBuZIPO3MzDK4a5AIq?=
 =?us-ascii?Q?0NT9IFIJIVZ7mJTyo/dF83HlMf/OcLQyhbQU9+Brqcb8OIRLOulEsEjSPLPy?=
 =?us-ascii?Q?nwbH3gnnZB6G6lQmHaxUpeLeqT+WBq8t4LhlpAV2uEjRBC+fS3fIoPrxusV0?=
 =?us-ascii?Q?GaUkhmcLQuCMqLSky/8i7gmingq4GJ/GzJHYbpQMKvlrI2taZC7Wg5KVB2KF?=
 =?us-ascii?Q?okjt0FReWt4tQsAdFUZrQkQse6SgbFCJIePxhbVKbJwIlevQSsPzuSwojMeT?=
 =?us-ascii?Q?Njiwujir9Q2hsJu5I4CArh5ZFesHGarkNkAw+IulhiXZxZGNIycUiXVo1huu?=
 =?us-ascii?Q?SbrNcL7KginPOr53sVtEmcZ4eoTwueL2TFdZZc12Ieq41P9xMUIiSt3cxMTM?=
 =?us-ascii?Q?/cvpSamZZtYdqks2VKcduGiH/r+OVliCs1LGrDW5fjNry1oiHXXb+PTylXEP?=
 =?us-ascii?Q?roq/dEtttfDaJGVv8/Betjt4g0OF9lcrZo4BDsi3COTF4cYmwJ8SnxuO592f?=
 =?us-ascii?Q?GYgUDlIst5loYPrIwAXLnN7eUHhHUKzXNTOJNYdtQXjRS8ffbZUA3Kyn0rLR?=
 =?us-ascii?Q?wVIP6YkWkaT8zYWU6atuT0UusezVJHpa4nyePPU9YfBdarRIGJK07t7aO1gC?=
 =?us-ascii?Q?IZUqoYfK4t/MW2NjNpsXK+wbCEebp5LclS6q9kIEdQYFqC/e+M205qGEtkFS?=
 =?us-ascii?Q?Gh61aM5MZpXUsZLTaK7pTqx/hMJxClOCGpLXqPf+XqMuF5PoAxXQLvMtcdZG?=
 =?us-ascii?Q?xACwCtriiN0ppwD8EnvCslRhdhlLn83c6oi5uVRF4c5bE4RS5GY7BZmagmJb?=
 =?us-ascii?Q?iw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 390ce12e-4706-4456-95f6-08db24a2aef2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2023 15:42:14.1336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y82rdXESXZQEZtAc1/dOgmgS6nF4U4CSgTXYxQISCB+AnkDuWOwNShvJYp++wUIDLqFm/yTEoWN0tXSvKG98/TL1JotkNROesE8J6Rpe+Xo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7744
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

Thank you for reviewing.

> > +
> > +description:
> > +  This binding describes UART-attached NXP bluetooth chips.
> > +  These chips are dual-radio chips supporting WiFi and Bluetooth.
> > +  The bluetooth works on standard H4 protocol over 4-wire UART.
> > +  The RTS and CTS lines are used during FW download.
> > +  To enable power save mode, the host asserts break signal
> > +  over UART-TX line to put the chip into power save state.
> > +  De-asserting break wakes-up the BT chip.
>=20
> The verb is spelled with a space: wakes up the BT chip.
>=20
> You seem to break the line whenever a sentence ends. Is that intentional?
>=20

Yes. But now I have resolved it in v11 patch.

Thanks,
Neeraj
