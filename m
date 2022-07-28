Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1425835EB
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 02:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiG1ALO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 20:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiG1ALM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 20:11:12 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2075.outbound.protection.outlook.com [40.107.22.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF6B1054D;
        Wed, 27 Jul 2022 17:11:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWbi6ygtzFwNSwWxOv5I7NDxY6z7mpBYELo7GiPaYqSpJEJmer85DTQi/BGsQ/J++FPGG4h4JvMzhu9E1hvf3xzNrM8lufig6CHCgivzX4BUVoriMnBOyywhuTG3P36TAGNUvNrvvbxq0dC8Ztv5ZP3TEqvQ4J0kLuzdZWdfvWR31B4/VSi+/d95eZ4KU796gXGgPdb0qVIxFGunOofaKQYGprX7gnMN8zh7vCG79ofW5LIxfp+46qUhP1+b1tBid4+BLGMMx+MQCpAJgeL1eoo75GjRw1/HB88I0j7KX5+PDFzHAeXpLkDsETUaXisbpqa26Zn6A8hlj6CkwFEbCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16Re5LtT3aZ6gQ2uvdWQscowbSO7R3YPOmX3k23Fml0=;
 b=odp1wZQoiA4Ak7cAgoAc6HYQsXvlLS8dR6dOQDo5dCYZVfCEiZMLp2vIP0HEufA2/eFXsM0MOOHUc2VQAHbXw9HHt7dKNbdMh3hZHX9AM1K60I2n0mcOvqA8NdtfKmErq94243CCehkBtQ7qVCbTQEzfXmYi2H1eGdSVwFzkQ/2rp9XHk/2v5sda00jLoMylRlVDYoj8pAXl3p2AmChfU4B/eVTtIJYeL9lgnih7yZh6sMG35cuFtg6GlwbcLJkRvyQ+/ntU4zMo6fViVugEjUy6VaGSLLnVvM+1toxLxl185Y5Lcpbo3UYtlM5Jp90Hmj1C8eEmg0RWMe09YZSm8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=16Re5LtT3aZ6gQ2uvdWQscowbSO7R3YPOmX3k23Fml0=;
 b=BnXZQDdxaPX3CujBCl5+W+wuSfuit+VrxEgvrIiv5U/oD0WOR0LkWW4qMM4/CHPpEoGzhtc/RpAE+H7o8Ut5tR1Nj5vsi2jyrYA0p6u0AmQctfdxoiFX0x3439n46wAlZKM+UzP14Ss579zUiiam/0iQsRnlaS5jbIjGb4+BUck=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2816.eurprd04.prod.outlook.com (2603:10a6:800:b7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Thu, 28 Jul
 2022 00:11:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5458.019; Thu, 28 Jul 2022
 00:11:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v1] selftests: net: dsa: Add a Makefile which
 installs the selftests
Thread-Topic: [PATCH net-next v1] selftests: net: dsa: Add a Makefile which
 installs the selftests
Thread-Index: AQHYoe1sbhZ5DZYw/UyGg0gcekBTAA==
Date:   Thu, 28 Jul 2022 00:11:07 +0000
Message-ID: <20220728001107.a3nl4beu65owjldi@skbuf>
References: <20220727191642.480279-1-martin.blumenstingl@googlemail.com>
 <20220727191642.480279-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20220727191642.480279-1-martin.blumenstingl@googlemail.com>
 <20220727191642.480279-1-martin.blumenstingl@googlemail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d298dc2b-fb03-45cd-c498-08da702dab65
x-ms-traffictypediagnostic: VI1PR0402MB2816:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K8TtC4HSG0PKeyvePMlseTkOhJGOAsN35h85rAgZbO/lcCJnkujnK9AOx03pD3otNNg7UpFr0bUUVky3aKQSvxdUqC3DS20c8S8ge0mwkFIDfTwOcpcxvYVlW6KwqyElAGPdgWwN6iQtd9iNKSb9Qd8Ve8NZx/V10BppOILt6x191vMtt20lLrcqA5GzsEC5MFu9NuNKdo69EaxYVo+KbkXREKwfMNUFGR2i/YMMCzajJRzGBTu7MTjrBFN66fIdY4X/Z3j2Rnn5UaWgLoBFBPq+F/px3ybn0OnYQm4AMSUQ9ajoCq8RjjVlmhsamJ71xeelnCaxNOCCDyxHcOyqFZ78aY1l0vCh1HGCL/1Y/meOeP6mZaLVdbiydJko/7WS7OPcR3p0tRdhMxJ9eaaY/8oQIhzime5Wd+c8FSkuLCAPmFfd/bSWEt/x15jwigwnusgshaB/+xW63/WLNpZHE+9dVLA/H7s+Os7d0AgCwF+OqPR2+SCjjr02Hc6NViUeI2zHq46eBm1jnHoxqA0boPJQShaGR6pJFTKQ/nYq+8/96aFlpuMezGcgGG8AXBwfU+Tdw92wwzq0vXouaimLPw4di6uMHla73mxk4u+RWXV+LmA5g9c9qiG8CWiE5TeTzNk54O3p6kfGK1QDEsbZ+YtI7ihI6HbcTAzt7AVQ6F9e8rG9+Bt5qczyrYtfkzXwa6+AiXD0Ugifg0pLIJkZiwoFxsvFVt5cUAwTpAvZJ6rGmQbz+J496q2HKxoTr60ZbA//NFYf3oOZsi0Wc61Wf23t8sJ8tGZA6078nzndGA0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(136003)(366004)(376002)(396003)(346002)(186003)(1076003)(8676002)(4326008)(64756008)(66946007)(66476007)(66446008)(6486002)(6916009)(76116006)(478600001)(6506007)(66556008)(2906002)(71200400001)(54906003)(41300700001)(9686003)(6512007)(91956017)(26005)(86362001)(122000001)(33716001)(38070700005)(38100700002)(44832011)(8936002)(5660300002)(316002)(4744005)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Q+qbS1XrwKU9FvzonMTnsXUmjDXaLmqs2nYjs6+1DDq7IvgAV7ezOdmiCCCc?=
 =?us-ascii?Q?d7NVVtzV5citGYF9n+SDxBZ7Gbx+pB4boEdCIefzRLmJRcGB3+oBMLXD79Bn?=
 =?us-ascii?Q?Qvzp/UYbrzsaKHuRNIVBc7XRvD7D3/Ug9kZSAzRCuGJS1/mu9XlsUI6IONfH?=
 =?us-ascii?Q?ovrGaMVBjDuZKq3QMVbhyih277pneQuKPQ7K3LBDcmr4a9tM2Ndt9X8L3svw?=
 =?us-ascii?Q?gpVzvxOLW6X/FKBIaSV07uIAd+9mIuv8dXsmM55xuW1i/VBZsx9Or3g6lfMX?=
 =?us-ascii?Q?pCvAr8rW7Lzb5t71Bb/sA7iCqpwYzPURR5AVu1qnToAVFfBD6KGpszvG/hSd?=
 =?us-ascii?Q?pIU6bM6k0fhRJujgFt6Ho9/RMVlMtWM5MhZC4JkebfI9SxXHob6za+jNQU6O?=
 =?us-ascii?Q?3HgWDdmDsCbfT0ovSC3l4gg0mFy8nyst73LB4BUIUsMnZGqk9611tcXUN83X?=
 =?us-ascii?Q?+xbQLNEYR989JgDcQQPrEJ3Jgwr5zuXCxoJuMgexW4AxhhNSeFwieV7zIXMe?=
 =?us-ascii?Q?F0oiF+CTeu42cRUNEZPR6xuhvVES2L+DC7JU8bejHpsjr4KEAMtk3ATI8oFk?=
 =?us-ascii?Q?hCok3XGXM5zGlICh3tYPGgjYVh+lymrR5+F4nNRXtWiO+ULg6oRCEZ5WbMEo?=
 =?us-ascii?Q?v+bCVvC3jnAlDCIxj1wyRmPOOEmdkK+Nr1MIoeRKy5eAwYuNomEDQBogSZRA?=
 =?us-ascii?Q?dvnz9J6ZcmydrYWmKBavKMYRFWi5RWi5WuXYpaomEtnsUuWo+DcQWN3Qcegu?=
 =?us-ascii?Q?uV6CVQH/SZcz0Beg4hdfh3vhmQfhQXathCm7HKHZgttXJgsCmIOVflfr+QCc?=
 =?us-ascii?Q?g0jlIXGRX4iuDKMNTaUafQi0li059JaZsIKbBb/NXcsJoU2iqj+PHVL6nvYz?=
 =?us-ascii?Q?/eODebKPNjW5QQpLCuXmgZ/WNEmw3Ngd5GDLYrf4rMqZrSklyiQM348pet+G?=
 =?us-ascii?Q?FRGrN6va+w0JB/zTYlEktCJBaxaKHCPfA6PWJHKtQLeiLEcydqAwegQRUxvX?=
 =?us-ascii?Q?T273d53lvcqiaHyGZ3VfgX9mvsZVNaGU7kFFK280mzPxWzDQunMvFr4gMjjL?=
 =?us-ascii?Q?xI+IEGkFjKQlhGwICeCPFDprg+ayK0ajjkH04D0UgMhIvtUXSiRxlR1l60+B?=
 =?us-ascii?Q?M9fNHeRlohDcCx/5Ke1z4yWFM1anN2zENNMu11MOdw2N9RWBoQvFiztU/oUj?=
 =?us-ascii?Q?/3RqGBxZE3LbWp5C3InrOAylv+MT5Km0M9yRPuJG3juabSO974eq9Y/SV41O?=
 =?us-ascii?Q?dJh8sFFetYb1pRIMIZn8rEokP54SWxobF8789z4ur+dxdd04pTGNjRkP+KLH?=
 =?us-ascii?Q?rwI8ednCAXJa4qio3Qd71N0HE+TXgCGJGsHCirzQTg98/pm+DwHh6aGLKZxr?=
 =?us-ascii?Q?fiBsSMcTjgf4rgNtg4Iren1s7tge3vrQKyzOQ3snZfH1Pn+Va7esHEv+Hbnc?=
 =?us-ascii?Q?IXSFVCLTfUYk2CXOrU1fbYkcUWnFFPf6Yq7LI5UWAXtM1CbzqV1P+JLFL66a?=
 =?us-ascii?Q?nXEjPc+gOBQVUEddKbOaJlzG68Kk61gYsN6aDt1tensn2yN1kVyh55Vg+b65?=
 =?us-ascii?Q?pqbq7EXhfb4wFi9p00ovX9s5HMlQdBIH3dw4KL4Ug2Fun/rtWPdltfsd7IEq?=
 =?us-ascii?Q?tg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BCADEF26CBF64E44B7BFEA30B6CEC61C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d298dc2b-fb03-45cd-c498-08da702dab65
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2022 00:11:07.6977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z1MuMMXn/bwnbhO/GSpRtq88d55PQ3Olw+AvicU9TxlSxJ3blDHptSARkop5LIrbgBk5C+cSAllQVrblZFtjag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2816
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 09:16:42PM +0200, Martin Blumenstingl wrote:
> Add a Makefile which takes care of installing the selftests in
> tools/testing/selftests/drivers/net/dsa. This can be used to install all
> DSA specific selftests and forwarding.config using the same approach as
> for the selftests in tools/testing/selftests/net/forwarding.
>=20
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Thanks for doing this!=
