Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A214AE13A
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 19:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385268AbiBHSo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 13:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385312AbiBHSoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 13:44:19 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80114.outbound.protection.outlook.com [40.107.8.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9808C0612B9
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 10:44:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwdnxitqMjFwk5MoE/dlKFtSQMzOAjRd02vIBd0hMxeuL1IaIaJD6HXHl/353u6BUTHWpkeuAaL98YjV9sMM2WvJuAPbeiiXpXiw/UOmxz0aVdHAt8eee2SSarsYf+uK2OEhztH9EvZiIYjmf24zQ/bXH+SplgLml1qEAcvz4VCQlNHzFZbpg9OcnmdxxK1zlyz/hREjn1G3Mk1ZquLSt3C9TJy1L12wO2iSlbBEb0GwVkYkpo7l8XVUZ+Rnmep7hNBwvwSYKpP5fcQZM4z6e+AgQ25T2alYkM5bjGQaxa62d6HrwwKyjKujCeH3FncnIe/RyGvoIz6GFg5hRX/Nkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/bCA2lgWBYpJELC6Dp/KIkyBqhf35H5ihZPAbI/6Pc=;
 b=WtselI3HCxY1UpUe50V5+bJBzv931Tkv6EaBfQCGmpoVWWM2wiTJZXETBIbqiAdnZEimDdPUSP6VAukl66Tw0+jJFHAxlpmvMKOseiyZSK6cf8x/mqf4bu8WAnmQqAJDZsv86CuNJgRjSceZoJg3gYnZOqEgJiR7gDA5ft5JmKlgwQPazGRgb57YG3HZVCe4gNAxstiylmrVMtL3RYQmKoBouk0uaeok2r9NjyCU2W0YVOvcHH6NCrGKAjZptFhvyKQ+XDZPNQG811kwq4a5FdM25BSZg9BZdwSWKdXnUXCVKGRmVuxGuwpNHibxQzwKZYrTGeXCKIdiajezf1LYhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/bCA2lgWBYpJELC6Dp/KIkyBqhf35H5ihZPAbI/6Pc=;
 b=V8maIOToqyKvL86Hdg1aut8wAC3iysVVlJY2GsC9/c1T13YuUN6/7j5GOB13jjVWnhg+Yvvwfg0Qf6JgEayrqkk/JRusJ6kYHpLl5/4/GwORvyyZVrrTTqXMw48ebNlUNOcB89nah10oqkUoGcYw48LAy0A9+0EX5DezF1knYIcB/4q/9cYh5of62+B6dsrCh6uSZLgzoTNxP2i3ZhXIoriB3s8SvbD2+KjkZGkD22jER3UmAFYAJNUa9ExDjqfa4sslvrZUKvJHCcJL/7h8U/mC3Yw172s8SbT1bKHYB2ac56KztpD35wYmjrbbBn93ww7JsHrxqLa5Wvg0zSbo3w==
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com (2603:10a6:208:2::19)
 by DB7PR06MB5145.eurprd06.prod.outlook.com (2603:10a6:10:65::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 18:44:10 +0000
Received: from AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::d829:17c8:daaa:709d]) by AM0PR0602MB3666.eurprd06.prod.outlook.com
 ([fe80::d829:17c8:daaa:709d%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 18:44:10 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: RE: [v4] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Thread-Topic: [v4] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Thread-Index: AQHYHNCY2iBDkP/V5kmDjyhNSL6ySayJ06mAgAApuEA=
Date:   Tue, 8 Feb 2022 18:44:10 +0000
Message-ID: <AM0PR0602MB3666D7273A855A23E188F065F72D9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
References: <20220208094455.28870-1-holger.brunck@hitachienergy.com>
 <20220208171219.022165d1@thinkpad>
In-Reply-To: <20220208171219.022165d1@thinkpad>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7ef5b57-97eb-4284-05f8-08d9eb32fe9f
x-ms-traffictypediagnostic: DB7PR06MB5145:EE_
x-microsoft-antispam-prvs: <DB7PR06MB5145C2EFD9B1F060CD5D8CEBF72D9@DB7PR06MB5145.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pHX+k5DJfZwecOsFIMe6+uMiG2cxuO8e0CTzHXEBi/Pp1v8HCM8QaFy1S9enBoZtfMldOoC4J+cTCZi36uwqTe+XmfZHe0i22DfLF+9wlAW2XeATQPIBbMu7ynvyHkfN/EdGVaFWDoOm+sMXpOqRvqvH6P+uYJW7SpyhESMSRuv5ItMKtm9wQcGqSsgMw75nik7E4PWOiZgrrFuwTTofEmiBkSXSqxUu9fSnt0hJ05XAfbyT0sqUOR0IAE+NT96WvUzsATyaffIoVBGk584z8Scg5UsMRqXq84lWMbA6zjLfROsossBh67CqOTXJ8SAzpAqDSV1Pjcy2VNOPEtIiy05R+qgiPCh8ws8u67+IIHjwOaCAqrHXltWOWPJKy0Xg6ekMlnSudOUE4tCdUdRrCdvYZ5g3IZiy2xJzxzKfhG85vjotzhoWWWLiiBbZQxYdCxC5w1zG3QlJMUAgL+0z5ZN5GZNeaO1CSzaQE0dxNWUL2Dni9R9E2M+bLN5RSgTmrYZ22mQis0WQa2qQ3a2AiIfV5UtFwaylo+WSmNnN7CBt7Qt33VxOFHtNbDZV2c1k/WXs2flSHhO+cYBae9L+m4DSJvyRa68R7pYrybtjN1koCmV3dzlms0bTnEnkSL2IaBjRPqKo9Ps/OGmnB1Dxq675Ga78queQCxEuNgYr0LpalAyi+86IvDobsCLX9vy7VB8bzeyqhj4Xh0z6sb2g6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3666.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55016003)(71200400001)(7696005)(76116006)(316002)(9686003)(508600001)(66556008)(44832011)(6506007)(2906002)(33656002)(66946007)(26005)(186003)(5660300002)(66476007)(8936002)(8676002)(86362001)(4326008)(52536014)(82960400001)(54906003)(6916009)(66446008)(64756008)(38100700002)(122000001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?kUXYkDG05p39ER2HqTGyQWAZHtVQoribrVKOP1POgnGObGQnqSRKhExtHN?=
 =?iso-8859-1?Q?HjQfj4Z/wX6DBYDCUwjSreoOsLNQFRT+gxpPnnB64N4+QK5NU6rQYwSAyl?=
 =?iso-8859-1?Q?3c+xNVieyVpfmQqcuBLIO3aRwsXuYKrvao5+nODMT+gr+1gI/kC+Bz0hla?=
 =?iso-8859-1?Q?N2p5a91hF0bSWybvxQ4fIMBFxRwvh67+vmDFQbuXF2O+laCFbhpJ10AFmZ?=
 =?iso-8859-1?Q?0+xfqfqtK+qz9ZxsyRzNNa80UT5BqGc30Kim2RkbO/Scdz+t2Sh0+UZq/N?=
 =?iso-8859-1?Q?7TgTmhhefWFovFS3jqLRoMRggm2pdb1WHG0jK3jMZD+ssZaXo6cQtEpTwV?=
 =?iso-8859-1?Q?zG2wirHFdU8C32RYysc/9iuOzIoqd1s0Asb4RTM5TUCZvwHzy6h84EjHFw?=
 =?iso-8859-1?Q?bEgP0vdUCO+HqT7nkTMhtQOGKW4iPO9/7fWzHh3BcQmEDS06ont6KAFfM6?=
 =?iso-8859-1?Q?c4O9Texzi7RVO9hJj/BQhstdr7TNoFXekFP8Kl//zrwxv70lwTRCc2R6K5?=
 =?iso-8859-1?Q?+MqXcnt5e1vAiRaS5xLw+TyS1KRY0Ku0RHExWbmrKyD4I3mGH9cbeXLoR2?=
 =?iso-8859-1?Q?ZoY5rwbf076+asCBW8nnBelhb3mXwdCpvvZV1wK+sN8VHlEscO+pIkTLIG?=
 =?iso-8859-1?Q?MttNKH/kXX3tB6A/zN9KPO5oc5d00bElZjSrIcbrb5dqPVSJqHREFez3tA?=
 =?iso-8859-1?Q?RVimBS8zR+1zT/wDYxYRuMIsN1qutJle8ZXTHRFU9l7B016xsO240WOOyD?=
 =?iso-8859-1?Q?DTbV5IzfkRV+vLCNX8Jn2JkIwp5db4u3ZB8x1bzn1rDsjiEVO/1MV0JDKM?=
 =?iso-8859-1?Q?AVR2vj6yPWYrKHzM/ze7AR3M1w7by+U9UiWWDSc32hzJy1+hHE5T8k3WPs?=
 =?iso-8859-1?Q?7zZFQEubv4k6AEhIRSAjkazZe4E98kyVNl81g9U9i0Flt/EsOudbSC4uui?=
 =?iso-8859-1?Q?yHvLDvE1Z8MC/Umh8544Pz6kYqtqlCFe56uuxiY2qywKvrbpLlo/YecnLr?=
 =?iso-8859-1?Q?X0D8po+NfR/RVKcW1qxhdXtfieio+w/7hJZGw4wV09gutfEL9uJoyN/GVV?=
 =?iso-8859-1?Q?gfvcbFM7G6JTPQyWZCvyKl4v4IiEJFkojv6cLaYtrDGqK6+j5IVJhnfcDH?=
 =?iso-8859-1?Q?UEOP7Kw2uz51kwv2r+FYIqcnXZzTeRMISLBtB9smccyau8TyrENNsoO0vd?=
 =?iso-8859-1?Q?9CTDje7gJc9V7Y0/+XkK4v0oftqC1lsX58+/Acx8Hmoog+gU1cOoaJXOkc?=
 =?iso-8859-1?Q?ieSOyIDCDbMKq127k8b0XAEquzjGmkR8GRteFGmdqGThJHjhXuThgCc/Go?=
 =?iso-8859-1?Q?1WVZXyCLy4G34LF5bfv6kEMwdallquSuMi4/qelTfNoQWqL+vVq/SQDPwe?=
 =?iso-8859-1?Q?ysaY8NKZXLWz/WZom370qNufIuISwiZhLPx14bIo22WXSp5m4uVCt+PEo7?=
 =?iso-8859-1?Q?P2sbG8xG69q0LTYzdIqJQt3qIkh4l/m3/BZNUByUiGaZlsAS/BxsrxUUPw?=
 =?iso-8859-1?Q?f3RgS7mABmMjxPT9ePGXPWfciF0XlNv6wTSc3A4DLEM2DE55bRB1AdFVQT?=
 =?iso-8859-1?Q?RQ5AIg6F7NTes4eSwdJniSrPVU/lrwGOM/nQEMCgMhV7dYh4eQ9uWBVDRJ?=
 =?iso-8859-1?Q?wzz3mVse6fVWGT2mEOyqGqpZCMCDkQFMT5wMCwklsuUE7amUu480V9CWWQ?=
 =?iso-8859-1?Q?td1gEHsUFEPR25edWO2PXjxTcJgQmcF0eVtNbe6LZVwuc/+EjdCUNEMArl?=
 =?iso-8859-1?Q?Aqlg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0602MB3666.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7ef5b57-97eb-4284-05f8-08d9eb32fe9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 18:44:10.1737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Su9psyfW/5uOlaIm3/RV0tvBcReeAJr7SMA+mzfzCtJD5blcwkHMDwfTisFf3mMI50IgyqJ8gavH+YR5B++fzb2rPMZl7cLaBYBXciFTUwE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR06MB5145
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static struct mv88e6352_serdes_p2p_to_val
> mv88e6352_serdes_p2p_to_val[] =3D {
> > +     /* Mapping of configurable mikrovolt values to the register value=
 */
> > +     { 14000, 0},
> > +     { 112000, 1},
> > +     { 210000, 2},
> > +     { 308000, 3},
> > +     { 406000, 4},
> > +     { 504000, 5},
> > +     { 602000, 6},
> > +     { 700000, 7},
> > +};
>=20
> ...
>=20
> > +     reg =3D (reg & MV88E6352_SERDES_OUT_AMP_MASK) | val;
>=20
> This is weird: normally in mask we have those bits set that are to be cha=
nged.
> So amplitude mask should be bits that specify the amplitue, and this shou=
ld be
>   reg &=3D ~MV88E6352_SERDES_OUT_AMP_MASK;
>   reg |=3D val & MV88E6352_SERDES_OUT_AMP_MASK; and mask should be
> defined inversely.
>=20

ok I will change that.

> ...
>=20
> > +#define MV88E6352_SERDES_OUT_AMP_MASK                0xfffc
>=20
> And this is also weird. 0xfffc is all bits set except last 2, but in the =
mapping above
> the maximum value is 7, so you use 3 bits for amplitude...
>

you are absolutely right. In this case it would be 0xfff8 to handle all thr=
ee bits.

Thanks
Holger

