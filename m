Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B16F43CC45
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238657AbhJ0Odq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:33:46 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:47963 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242590AbhJ0OdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 10:33:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635345056; x=1666881056;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+MX7dAP2eTHBxzWa+/zkM0OevJs+c2yhssikeRxNVgs=;
  b=q+nwzhu7La6VIep5F0DkMa/+k4sJ5nKo1dugO9ZMHNaXMI2cPwVPEY77
   NotuuK+wtOjPvw8ELfaYDFXNe69GlT+ghQo7uKKzeeWuwp/T/Wh6TE1rz
   jXq9aqmVoDlIqPlIP6etpUnW/jQcXu4CCvAcv9TpGsSes+t/E+nyrpU2s
   E/HuTqgZxwE8ClaujZ1d3a1pqAkanBwHFb75Kp747vdr344I3vIX/RqXd
   v35p9jPyzVVL4a8y2RJhzSFy1AbFWz0CXoQSoEsUoQX3Q51a5S3PlgUGh
   7yW+CiIM0+zoBcaAC7T0aLA7l8khlOsotZs30QBQkEGXDmLOTYeDv5paw
   g==;
IronPort-SDR: 7EXmspKScC1RZmQMXEz1ZDjlXYetERBm1vCJ7ZbHFE5QQP++ge97cKDMtg+SUVgdfA4kONU0BX
 vbIQlVmXu0v2vgZ9edPK5UrNqc1mmIfD26CLANN9tLrIhP+KJJWBESEmuIVB+YkyUeJC87LWTf
 KFmq3zpH3r+8zKD2UGSOlgd1+QxLYWmvo17qZy/Vr+4sXCWMHpVqymoMbZe5ZnFlDI1tWB0ply
 TUtbZ7BbK2YbNNh31jH8K3HGsQeKuoSNaVrOzWCZF+K9Bcn+YpU+ZJXzFbdHULKgYFIpZ6kxZG
 HLyHbVrdSvpBFiIlJNvIvLlk
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="141269268"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Oct 2021 07:30:50 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 27 Oct 2021 07:30:49 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14 via Frontend
 Transport; Wed, 27 Oct 2021 07:30:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgbS6xY0sxv7+0dV104nwQz8I0d2vG0mjY2WW16/Hso0M2VHpPxcfOEVkXo8n5LQExkA9Ni7l0nZKquNWl15v2Y8h7Xv97sFcLu5djyY73YwWBoO3zdyUBPNJAmPN6S0nHDZBc4G+MIhyUdCmRMrel0yYgPENfjQk20xOhiWUZ6Q+I87XHYcFs2zhGsihgRPdN46YuOIlQksDHzkDuxBYsc2K84brEtgpIT/MZaEOWjg6af6DkmpJ0S+dHuui1d2xWaunaA/bRTEDJfJdD8KRV1xrXR00fW3wC3aaZq2fsrpGiVp4BPk0yQNyXWIbTGZe+AbDBsyTy92nV8Y4Kcl2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRzwa/ndlvgW7T2BOZDfs5tcGCRUfggE+0AqZCqRxFg=;
 b=UMeZ+IJqD8gLpP9+LxxdzLlgO14L0e8zmXfGUgcWjJ3ESQl8l9CnWT0RX9yyEi9zfy21JqsNebtNi8ivz97+UIUUSi5Ht6CSGjNuPr0KESSUWf1mku/SSk55dZlWedgX/HkZPBHOvHQrQDh4YQQDNeVkLuYT2VMfPHW5PrBTJC/9dsM+JMeKPBoItZz1XeGPWaTHBlADv1gqiKfEssKKKSf66LhPBjkKpCMuuz948om5D7HjDXYOvMMgE5CNCoiwzg5cEtRplhzYlURfNq8v7WHQ2byHxNPzHoYty4nVgxkvBI1KFSmazajVEnsqhPlEPm+bUy79YIWUiKgFg5a5Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRzwa/ndlvgW7T2BOZDfs5tcGCRUfggE+0AqZCqRxFg=;
 b=QYKTpmUteZnhYl5zwvhIORr2TdDXJ/66h/qrXj1Iv0hBGEodNN2/CbnoYkNOLtiTqnN1co2XCFb6OT8zU0YoYnJTRyPTkkkVIsh+LGbG6RWz1pj9fbGROPnxcJ0Xng4qIJKtZjkot0FnbJv0g2wP2uq0VApn+j3rrefyDMNEQUg=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by CH0PR11MB5563.namprd11.prod.outlook.com (2603:10b6:610:d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 14:30:39 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::4907:3693:d51c:af7e]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::4907:3693:d51c:af7e%9]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 14:30:39 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <Nisar.Sayed@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next] net: phy: microchip_t1: add cable test support
 for lan87xx phy
Thread-Topic: [PATCH net-next] net: phy: microchip_t1: add cable test support
 for lan87xx phy
Thread-Index: AQHXx3OiBAiK8WCZ6kqAisnfUJKPX6vfbvYAgAd+HxA=
Date:   Wed, 27 Oct 2021 14:30:38 +0000
Message-ID: <CH0PR11MB55619DF408C4EC0D729BC87F8E859@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <20211022183632.8415-1-yuiko.oshino@microchip.com>
 <YXMXeuMUVvmR5Zrc@lunn.ch>
In-Reply-To: <YXMXeuMUVvmR5Zrc@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9d288a8-18cd-4c72-53d7-08d99956592e
x-ms-traffictypediagnostic: CH0PR11MB5563:
x-microsoft-antispam-prvs: <CH0PR11MB55638F31F873234C3E08C8798E859@CH0PR11MB5563.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6nl6fBhzngDHvbosbIYqp1ZQIMyNaC4v3mZjPz8tyEAtGk1Sv6JU6CdA60aF+AWUzHl1Rt5rBtHEsC04J8fEqRCB3noJ8otV3TzdPDs13jYfRlLD15n2bRDM0GW30cfs90DYlkSmHc6TG6SGCc2r9DBJ+Z/OrnEOzwJYLOiRrXqLCgD1SGJpddMU2D4gyIoeVt92rylFCB3dLMdQ0v2KQ1GwyJcD1oBKjFGP0RHqxsP+odqPEqnw6uWWWy8OnbvVKJRfnjG62TWtqVId3MzdRCjuxDBEvC2HR31yRg/ORdWZ8udHES8gD6IrZca6hogIImt+s5pqz+kPurBPGaOB/Bo/9aHfPUl4Vp4qsKNBr345f+6tzAnRjxriv1BH7Pc0nGXiGMXMmoQl+HU4tqgqxojgYJGhbEbDZyEN5sXgs2Ij8mr5UfkuNC9QJc+MLKVGTkeVcyLlMYhOZRE6VjqV+F7VyLYVK2i5RfcyPvdYyubVP0nXZjkAIA45dQR1fVqEULS6nWMuWirF+Nk557Z3Lxg+Wr+33vKOOH6Z6zhst/bVcl+uz6EP90XewYlis1w5PHvrvWeCbvvJY8Cp8ujbNfGhYFCXwH6ATwoFsi0pN1UgGPI3D+nrvUi3AAsa9hIqqxG1VU91Mtc9lusBzQhNgIQkZw6n9d6j/FW3L6msRcI6qTm/CBZQvKZMnQ391sKUP7AvWeGJCRVedFJgqmiA3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(52536014)(8676002)(107886003)(122000001)(2906002)(54906003)(316002)(508600001)(186003)(86362001)(6916009)(38070700005)(8936002)(83380400001)(38100700002)(71200400001)(55016002)(9686003)(7696005)(66446008)(76116006)(66556008)(66476007)(64756008)(4326008)(66946007)(6506007)(26005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sLsj16tvnAgP5tquvIqeDlC7ZsIY13HRJZQrA0mpPJIqwk82NU0kZCEMi45+?=
 =?us-ascii?Q?9ACeNx6bZkYaJPjTNq4/yEHy14p1aMVO2R2aRfo8ZCNFH4N6K4qaSukPO4wp?=
 =?us-ascii?Q?iBcmWzf+nZzLhrBOjYFKF8T6HcgymrtZ1UxvOIvRD/26bNI/V2cn02hQX7SU?=
 =?us-ascii?Q?71LeW1amu5u08PWQHc+Lz+q/6WACk5NYlxkIISI5SDqx21gucFw9WUdG+nXm?=
 =?us-ascii?Q?ItdQ3i/TYIR5I2foaOTr5L/0/0j/IvyVazVzywtV6CBTJa5cqJG2lzEbngaG?=
 =?us-ascii?Q?9ONPDOf0Y9jDyYv2pdZg1DYXeBkB6PuiYdx9BmWhTjf5pW8O7/7bJPZQGWuT?=
 =?us-ascii?Q?e3/urmwYZ8T1KSTlvwom3VP3qopX80nVjZiwScXrC7tPyGB451MgBBj/HYNU?=
 =?us-ascii?Q?3xIgozk3FgSp2lbp3Tsxpvi5Z6FN0ty0ktGHrwgJefqcCrn7XgN5bLQRYQK/?=
 =?us-ascii?Q?tE0hKkOYsoSAlWwY1NfM2QIYvGqjnRhxo8bSf21n+i8f19MVGD50fSESFaX/?=
 =?us-ascii?Q?L5ICMmFzqMTSvC5z5I1BLmqMhXVcH4qbx7GkCpFH86vB+JNSAU7zwQOgeHkz?=
 =?us-ascii?Q?6Q51E8XEk5y5y9AHEUltlZ6QoixVgxdduoFzB6WT7ZNBF4EMc83ZuFUMHIL1?=
 =?us-ascii?Q?tt83GSA8kCWcGYH8LxtO/GuBEwstpFiL5R9V5riNeyN8X1ruIesA1f5LAWu0?=
 =?us-ascii?Q?tVd8Xo96+0y4fE4ECswWdy+c22qssu2QOF1vjOACHBssv8djqWOtMGGL10xP?=
 =?us-ascii?Q?Tov2tFHYUyTLUxW/e77dBFVAV3GdRyMiS6HYwuoCs8HmwmLTAhVa8/dOcGji?=
 =?us-ascii?Q?TM9dnumvQ1G5TFmUFDALgb3KxtTVlkgFoYDj1uF4/BEo8b+fhI9iZJmp5Rzk?=
 =?us-ascii?Q?rSfA9P/W+UfSu0Kq3GxfGcqD+hZtMJZuRBn9UT2BifQlCR68AoIavl/cNm9j?=
 =?us-ascii?Q?f5mEuNemXB8yE8TstoycKPPO9kZxHYlBXfT0JZyYpwLgi9gAuhmaqsK8z1UE?=
 =?us-ascii?Q?ZeuhqjR41mGvmJiimxyRYAHQ6mYp2TZ5Ear3B9YgsCg5ZW8POZtT3rK9dvMa?=
 =?us-ascii?Q?3UOMX6LWzA1DzMQAZacdtjI704Hy+B3BCJuUfi/84pmuo5/1M+yqa9O5DrGh?=
 =?us-ascii?Q?b9ftGSfeVtyp6EkFCg9HhMyCVOedXMy7grZH6jXmGVSNlbJKDIEcmLhnk5Bq?=
 =?us-ascii?Q?N5SIaHvHKb8AgYJQQz720hEkHTU6JHAdXd4O+6kwQsx0FxXsUu00EcLs2NTA?=
 =?us-ascii?Q?zshLOE94T+TuH+QHY1NIUJxaG0nZr6k9ID/Bi/esa5aDptBwl++CUnSPww36?=
 =?us-ascii?Q?nQ9YjoGxN0QW4buZKEjKK8QMESUJhxzJcpIuRGFYshEVFvax6eOM0S5Y10Of?=
 =?us-ascii?Q?t70tU9x4joK4RB6U71dnRHVstyuQ+nfauA7Ynd5WesxZU7wXFWB7LGipe6hm?=
 =?us-ascii?Q?VX8EP4k1iK8W0cI7cXCHyqarXGIJ5YZrxM4KYvUvo7uIUAclxP7QCPjsbcuA?=
 =?us-ascii?Q?hu12wJ3VSxRFoV11eWCx76eGKs/od+Y1xNOwyZIlS6phTTRlUXgI2dqwXA+L?=
 =?us-ascii?Q?X+JbDAJSgHVpC/UJJaRJMdovoE/OGC0LnRxOVjtNnUZ1WWzH56V7Lk1fI2LU?=
 =?us-ascii?Q?lJAM5IOveNWqlo5pgeZqLLums4QYUoHWGTOinDlaevel4C6WO7A91gX6apNM?=
 =?us-ascii?Q?6HkzhQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d288a8-18cd-4c72-53d7-08d99956592e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 14:30:39.0269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9bphLgDAjpw18QVsm5e9fAMxTg4JfqWYYdJx7uRkiQ94y+BMxyPyEgM1Imb3AOn5v62qcRj3pvYUApQdi2+FYTLCIaa1zadpeYiIIqu2dX0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5563
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Friday, October 22, 2021 3:57 PM
>To: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>
>Cc: davem@davemloft.net; netdev@vger.kernel.org; Nisar Sayed - I17970
><Nisar.Sayed@microchip.com>; UNGLinuxDriver
><UNGLinuxDriver@microchip.com>
>Subject: Re: [PATCH net-next] net: phy: microchip_t1: add cable test suppo=
rt for
>lan87xx phy
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>content is safe
>
>> +static int lan87xx_cable_test_start(struct phy_device *phydev) {
>> +     static const struct access_ereg_val cable_test[] =3D {
>> +             /* min wait */
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 93,
>> +              0, 0},
>> +             /* max wait */
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 94,
>> +              10, 0},
>> +             /* pulse cycle */
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 95,
>> +              90, 0},
>> +             /* cable diag thresh */
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 92,
>> +              60, 0},
>> +             /* max gain */
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 79,
>> +              31, 0},
>> +             /* clock align for each iteration */
>> +             {PHYACC_ATTR_MODE_MODIFY, PHYACC_ATTR_BANK_DSP, 55,
>> +              0, 0x0038},
>> +             /* max cycle wait config */
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 94,
>> +              70, 0},
>> +             /* start cable diag*/
>> +             {PHYACC_ATTR_MODE_WRITE, PHYACC_ATTR_BANK_DSP, 90,
>> +              1, 0},
>> +     };
>> +     int rc, i;
>> +
>> +     rc =3D microchip_cable_test_start_common(phydev);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     /* start cable diag */
>> +     /* check if part is alive - if not, return diagnostic error */
>> +     rc =3D access_ereg(phydev, PHYACC_ATTR_MODE_READ,
>PHYACC_ATTR_BANK_SMI,
>> +                      0x00, 0);
>> +     if (rc < 0)
>> +             return rc;
>> +
>> +     if (rc !=3D 0x2100)
>> +             return -ENODEV;
>
>What does this actually mean? Would -EOPNOTSUPP be better?

This register should return the value of 0x2100. So if the return value is =
different, then I assume there is no device.
>
>> +static int lan87xx_cable_test_report_trans(u32 result) {
>> +     switch (result) {
>> +     case 0:
>> +             return ETHTOOL_A_CABLE_RESULT_CODE_OK;
>> +     case 1:
>> +             return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
>> +     case 2:
>> +             return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
>
>Please add some #defines for 0, 1, 2.

Sure, will do.
>
>       Andrew

Thank you.
Yuiko
