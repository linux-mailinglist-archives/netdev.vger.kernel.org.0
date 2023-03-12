Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384756B6580
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 12:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbjCLLdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 07:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbjCLLc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 07:32:58 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413B21FD2;
        Sun, 12 Mar 2023 04:32:31 -0700 (PDT)
Received: from pps.filterd (m0167088.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32C9m1Pn023905;
        Sun, 12 Mar 2023 07:30:52 -0400
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3p8mcbmq6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Mar 2023 07:30:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XyNk6lyyBN65+LJ0hs5r9pBCjCWME8OtbaBetNQT6J0TWszoU9VXUtBfzCA1h7y+THhXT/YUMQA47k/rpLPfcZO8zH/js0GuXfotLod4t/K+FvCjpj5bqp6mw8hpG8TefHQ8hOJYM9vvKZdEQD+A7sZEwyW+WePiouefaTFofLmj+niiiOLHAw8DBvPfGBfVgI3ijbV0i+y0pnvGvQvlAVIf5OjxElSzyxlAFNa7e/DTDewzmBrIspXPiPe6gQeE5VvIueMlr7gsflHjaiB/QtURnLJypUkmS9gupEuffLi8TINMg7rKrXYdBTxsePEUulNrqrdWN+6Sj4UUk0ONcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/SoonWXsZvQRKEZJpEKXqZoEd2nXizSgXZrFnBNxQoU=;
 b=e4Sh8kLKBHIVm4ZKLcrHOt8Rb0X13yaOZ0vbgDOE0B15r8i06uJFPuTP5blF1/4XzM0GtRzMgUGmF1hDoW7b4AvLXQTY9hO5Xr07NCakxh/HWOOWHF8GAgah0m/5pvKCmbGsQamCKWGo1X1JVlpXfxxzNiirG3eMAiHUfX2ReKl47baDX7Fzsl0iz5I4U69F2E8RRjbZV/dA7n7UPic+7y12dDFF9p5s71DjcMk1heYjMSY4pbL9wyHjmeYkvx1GwdOa7O5VNTFu1gPXneFixlqOHoK3f142SFMYpkWdmFNtbR7l6f0tq9+hw+xzmA/DlabGkMPxo8h19+rDP24xng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SoonWXsZvQRKEZJpEKXqZoEd2nXizSgXZrFnBNxQoU=;
 b=AsUXDe32GODFiicCMDog0cIBUc4WHuGXjUMRLYHJq/q+f8YpMi7AezXmMFbYFDgxHPPuc2Mzo6ubolgVMloCx1CN8FINZT/AtbxvOWD4oqW52QcZr7Kc6Hj59R8F0W5ojuGJAfykp4Y+5Osw7+MXDzF0V9PrAMjJZdZdFkzxM3I=
Received: from DM8PR03MB6246.namprd03.prod.outlook.com (2603:10b6:8:33::16) by
 MN2PR03MB5215.namprd03.prod.outlook.com (2603:10b6:208:1e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.23; Sun, 12 Mar
 2023 11:30:47 +0000
Received: from DM8PR03MB6246.namprd03.prod.outlook.com
 ([fe80::8c01:b841:bfe1:9b61]) by DM8PR03MB6246.namprd03.prod.outlook.com
 ([fe80::8c01:b841:bfe1:9b61%5]) with mapi id 15.20.6178.020; Sun, 12 Mar 2023
 11:30:47 +0000
From:   "Hennerich, Michael" <Michael.Hennerich@analog.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>
Subject: RE: [PATCH 11/12] net: ieee802154: adf7242: drop owner from driver
Thread-Topic: [PATCH 11/12] net: ieee802154: adf7242: drop owner from driver
Thread-Index: AQHZVD+Y5JGE/X2b1UOZy26bK8ppxK73A5dg
Date:   Sun, 12 Mar 2023 11:30:47 +0000
Message-ID: <DM8PR03MB62466759E6D4E05EC2BC92CF8EB89@DM8PR03MB6246.namprd03.prod.outlook.com>
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
 <20230311173303.262618-11-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230311173303.262618-11-krzysztof.kozlowski@linaro.org>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?iso-8859-1?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbWhlbm5lcm?=
 =?iso-8859-1?Q?lcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZi?=
 =?iso-8859-1?Q?ODRiYTI5ZTM1Ylxtc2dzXG1zZy01NDAyYjFjMS1jMGM5LTExZWQtYjc3MS?=
 =?iso-8859-1?Q?1iY2YxNzFjNDc2MTlcYW1lLXRlc3RcNTQwMmIxYzMtYzBjOS0xMWVkLWI3?=
 =?iso-8859-1?Q?NzEtYmNmMTcxYzQ3NjE5Ym9keS50eHQiIHN6PSIyMDExIiB0PSIxMzMyMz?=
 =?iso-8859-1?Q?A5NDI0NTg5MzIxMzUiIGg9IlB2cTU1SU0rM3VPRTZkazN3QWhMYUJQQXdq?=
 =?iso-8859-1?Q?VT0iIGlkPSIiIGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk?=
 =?iso-8859-1?Q?5DZ1VBQUVvQ0FBQ242MW9XMWxUWkFkNWpYRXJmTmFnODNtTmNTdDgxcUR3?=
 =?iso-8859-1?Q?REFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFIQUFBQURhQVFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFFQUFRQUJBQUFBUWRpazVRQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBSjRBQUFCaEFHUUFhUUJmQUhNQVpRQmpBSFVBY2dCbEFGOEFjQUJ5QU?=
 =?iso-8859-1?Q?c4QWFnQmxBR01BZEFCekFGOEFaZ0JoQUd3QWN3QmxBRjhBWmdCdkFITUFh?=
 =?iso-8859-1?Q?UUIwQUdrQWRnQmxBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQU?=
 =?iso-8859-1?Q?FBR0VBWkFCcEFGOEFjd0JsQUdNQWRRQnlBR1VBWHdCd0FISUFid0JxQUdV?=
 =?iso-8859-1?Q?QVl3QjBBSE1BWHdCMEFHa0FaUUJ5QURFQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVlRQmtB?=
 =?iso-8859-1?Q?R2tBWHdCekFHVUFZd0IxQUhJQVpRQmZBSEFBY2dCdkFHb0FaUUJqQUhRQW?=
 =?iso-8859-1?Q?N3QmZBSFFBYVFCbEFISUFNZ0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQU?=
 =?iso-8859-1?Q?FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?iso-8859-1?Q?QUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFBPT0iLz48L21ldGE+?=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR03MB6246:EE_|MN2PR03MB5215:EE_
x-ms-office365-filtering-correlation-id: 1005aac2-32ca-4df9-9509-08db22ed398d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cIWgnrc5WppRTiXeOdTg3VN3Uq5sERrZBqJ/exXAhVb3dI5ki2YyxfjwvnYcZthZxsEVNvmZ7+8yrVnIRSZlDRNbZwhYiM4cPYK7bD0k/XLXQ/QcaBh1mXa6H4+dfuSRaYlG2WO9qHuMiYKCnlXcS08WPkeaH/sSoeyEVAbSTc+m+wHE/i6Q8C9fji2cuwX20H/gk0CU0jMGWx3r8NLwp1bFghakx6HB/lM/fKBEX0/UGn4rIu0TU/7qvPuFjWrGnNV03YU7ntnSWPMxvylfJSUjQd16hqV7V0S8xoob0w3uoAJD7lsgAAAi/wZFUNLNtkK6lE35oMM6Nhs6PJKYjOhDp3ZJq4BxLb6X9bE4JPAhtMNKSQFi2JGjImjdv7TQzDzTBl0fCVumoTAkz40FGV4l4UvsgCoSd8t0uAniIl4O8lM330rKe/HD5gVFySTkz6XGSLDoKkgg4VheEotiDagM3B/3nTtnuU2MiYnyOYIuHI5C+4MJd8ip2XtBek21wm29+lPZnry20hWrZWsdrknUJBbndB2v3lGwnUClhoB/JR0QKhl3geKe+XV7p0mx0hHAkLIBMeippUxJMT6qvPzfFGv+Bw+0g6UKSr+NAiN0ZHYrvCflokfs0CNess3XaID00eP0Gp+je2pUImp+fAPIUrWObNK+N9cRYRTKsX4QNgWHi6nycTd06wClQm3jClVVHqsIBjABP8DVXPkZlJ8rDQcQMDi6N2AZ6Ez5uVM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR03MB6246.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(451199018)(921005)(86362001)(33656002)(38070700005)(122000001)(38100700002)(2906002)(41300700001)(7416002)(5660300002)(8936002)(52536014)(55016003)(66574015)(6506007)(26005)(83380400001)(9686003)(186003)(53546011)(316002)(110136005)(8676002)(66476007)(64756008)(66446008)(478600001)(66946007)(66556008)(76116006)(7696005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Kb24VTIPF+00fVdOG6lR8x1wIQFBEblmcaTGeSyGFPaELtsSckEmfrueG6?=
 =?iso-8859-1?Q?tpIK3B2bfuckf+UXy+CIE+59na07Z1Cn0S1jLjf4yAsSHBDYFx4FWmVQ+m?=
 =?iso-8859-1?Q?oShHtiqep4b2/a+U+N/xTKjiwGdcoAQMhBd4m09gQCFZA040/cdzpKyWtd?=
 =?iso-8859-1?Q?IqmyUHXx2Nqj3TtwmS+K5pev90eKH37kJIGIaj38ipUdhxOcGx+X5GT2N1?=
 =?iso-8859-1?Q?FjAZIG1tLNCg+ykN828hPJj9IQXEkWRmcc8nwYr/oE/ZJehlQlHklWTtHO?=
 =?iso-8859-1?Q?9TnB07A6U49p82vvNgGHmTp20ey0GaBS8TLjCNHKTuH9hkL46zt5lkVJXo?=
 =?iso-8859-1?Q?cjUaauLzpJRrhkUX9Twtl/Hs6RItZZXUJFeAFyDRqrQ8LZhCkmN3hCmWXc?=
 =?iso-8859-1?Q?Ph5sQhhBEZevDU6TvhYO0qsaotCZZjkGX5QYoflTEZTkiGZXqHjqpCzOSA?=
 =?iso-8859-1?Q?YLhanJcvG8FBrrXVR96ZnZvO9Hef0DAgtkegEYalTHD8QYnu7PcX79uMoE?=
 =?iso-8859-1?Q?CFiRKOPpl6/gg13j8nH7JI8GpEaz+p3FZklz7Q+YVKQJstTb45ugZJFqgc?=
 =?iso-8859-1?Q?1F63N1E5aPnouxq+gqEEz/IgqEoeBkPt/fFOKFVksqp6Hw1I687a6MrF4H?=
 =?iso-8859-1?Q?ddZf6C1TLmqCaxTItb3Aw4MbWKyfDTqhY0tlzCuaiL2VI20ip0XGb8GArD?=
 =?iso-8859-1?Q?bUeQV8fspXW83gC0WB+TiVDxt29x14qQHIMwFi3RyCOUBNR6ZjTuu2HKDt?=
 =?iso-8859-1?Q?WaZB7mAXtzjmQ7KaDDmd2ZftZp81DHLEib0hrvNCuXXHO5WaKYSeaGjGtm?=
 =?iso-8859-1?Q?scw61YayzIusyHDw3JJWw9kQ/d8wlV1WBleUsXVsHwJ4vUkiEsGVwuHanJ?=
 =?iso-8859-1?Q?tRfJJFha6nIhsEVJK9pF7l/nXHAvGtZHt1vEAxfXzvVHMX/gBmkakMbSm6?=
 =?iso-8859-1?Q?4Vg4cq1/LIbZqe/j4dz56LfTLJHBRHMUyGoWM38dIuKulj2teICEzS2FAW?=
 =?iso-8859-1?Q?tT3yiPU6585BU/IwZjMhm7V66ysvY7um5dTD4uVCEcwpt7pv6jiznJHAjt?=
 =?iso-8859-1?Q?ODpixv7XYYFXiA80oDYKeKK2yuDTR0xNvLX8M/gR7pnV8D3OuBtPZGpadC?=
 =?iso-8859-1?Q?3b+wlMD5eL2szpiTVcD0OS1HNqmU3y9/zOaGkhG+Bs5Ja5mVxPA+PLu1hV?=
 =?iso-8859-1?Q?rZCgPh39wzhVkvwAikrvad3AKr/R7Ovdk275USbxYnHUlK4cmsF/tgnx8C?=
 =?iso-8859-1?Q?pxnkThunqkJHbLjS3uW4/1Qe+1TkjsQVacn/r/pKi9RQAt6Tmaa/BP3zB6?=
 =?iso-8859-1?Q?k0Vvqd8leJf1QY9g/54mFocMGtztbscE70sJiNwdi8WEG8YwPemu89+8R6?=
 =?iso-8859-1?Q?TIrIz3Ab4Gp/nIierapZ9p1u+XNmvKe+B6urIdDD+//uGNKvx4XthzzMKP?=
 =?iso-8859-1?Q?zSay5Gx7tPmWsIhDYTp20gLfsSQFvuM24EWjDV5wDJa87FSY0BRzCRjY2q?=
 =?iso-8859-1?Q?hM9Zgptez9OSilRJtppbv7k2al1FWlNfQYzkAy1VibUDH42qQqbpXBSB3U?=
 =?iso-8859-1?Q?Q8muh704Mp1Ef8576s2SeS2VghpX/YR39m3XmUa9XdIca6MjbPYOG+jeQk?=
 =?iso-8859-1?Q?UhHNb8CWVa3FVIPne0qIxr1ejDh9OmVji7wluRYp2vJKbUf4ipAcYEUA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR03MB6246.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1005aac2-32ca-4df9-9509-08db22ed398d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2023 11:30:47.1074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r/8W8G6yxLJ+DPY24CYsGOVz3Oze+jBUJlh7fMuTBDyemB33UisVThWpmpwBwalwvHpt5RzVlVr0U7uQ1EYbaBAu77yKrVcpnvTdFOhiW94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB5215
X-Proofpoint-GUID: ZOMPMhcnSwtFkqfrUSZASNxmb8aMkcaa
X-Proofpoint-ORIG-GUID: ZOMPMhcnSwtFkqfrUSZASNxmb8aMkcaa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-11_04,2023-03-10_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 clxscore=1011 bulkscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303120099
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Sent: Samstag, 11. M=E4rz 2023 18:33
> To: Andrew Lunn <andrew@lunn.ch>; Florian Fainelli <f.fainelli@gmail.com>=
;
> Vladimir Oltean <olteanv@gmail.com>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Hauke
> Mehrtens <hauke@hauke-m.de>; Woojung Huh
> <woojung.huh@microchip.com>; UNGLinuxDriver@microchip.com; Claudiu
> Manoil <claudiu.manoil@nxp.com>; Alexandre Belloni
> <alexandre.belloni@bootlin.com>; Colin Foster <colin.foster@in-
> advantage.com>; Hennerich, Michael <Michael.Hennerich@analog.com>;
> Alexander Aring <alex.aring@gmail.com>; Stefan Schmidt
> <stefan@datenfreihafen.org>; Miquel Raynal <miquel.raynal@bootlin.com>;
> Heiner Kallweit <hkallweit1@gmail.com>; Russell King
> <linux@armlinux.org.uk>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-wpan@vger.kernel.org
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Subject: [PATCH 11/12] net: ieee802154: adf7242: drop owner from driver
>=20
> Core already sets owner in spi_driver.
>=20
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

> ---
>  drivers/net/ieee802154/adf7242.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/ieee802154/adf7242.c
> b/drivers/net/ieee802154/adf7242.c
> index 509acc86001c..f9972b8140f9 100644
> --- a/drivers/net/ieee802154/adf7242.c
> +++ b/drivers/net/ieee802154/adf7242.c
> @@ -1338,7 +1338,6 @@ static struct spi_driver adf7242_driver =3D {
>  	.driver =3D {
>  		   .of_match_table =3D adf7242_of_match,
>  		   .name =3D "adf7242",
> -		   .owner =3D THIS_MODULE,
>  		   },
>  	.probe =3D adf7242_probe,
>  	.remove =3D adf7242_remove,
> --
> 2.34.1

