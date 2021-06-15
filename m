Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4833A8320
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbhFOOqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:46:14 -0400
Received: from mail-db8eur05on2090.outbound.protection.outlook.com ([40.107.20.90]:8488
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230187AbhFOOqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 10:46:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYR8oTzF73m7iJYGWWrA0AE/TQwElgWofarPX9p222D0KisJom2rQZdnHizPm/I8B6nLIwkf3uivJuTBYcSEvkACEfvLV8TzrjWrNZ1+h4MziE09YdDbZz3SNRaSDMbHxSpf3DLVCxHEdQPCHIC1tn5VRd+RKMW2OE+qBke8o8BqQM8RJlyrQklptuVg7S5fmNJ0gBPjWt6GHrHv3c9Q3hgwDpQNESc4VYY5cEtkBl/sSlb6JUYz3ZOqSacyW1NZw59IndYlT4q7MJVFclyyXGA1qJGsNE5X/BGU+tZNNEWvD5UOgFi4gcc2M8wlyKlGGmYIyd/NHLAfExfrWaqt/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lrv0vf7ddRL6px4LBYiXsAvW2LvRTJiftIxkAR+4wUE=;
 b=ldXqq5KyYOgMKxnYJMt1SdUNRqAij9aNmmng2z1ag1nPilXN433zDx7Gxzt1gi2LsEJEXxfBcxO/2rPl/87CQnoxddH9/XR2ZQEEl/RQvLCaL7PigW8gf/YUCX03tb/3LucCEGlRSfKKHxAqJWNGmGqr38DQLLMMs045GLR0urCGQ74mgkKCTASqqbIsSacsD27uYzVWhTn5/cr0OkqtCV+OWlgfYnRyXz+KMuCi3eC8wmmqgfiQc0fzdAyC1DfaAeiWT8FRplwgDnf1esbUV4d/9blC4mlZ3XhR5Hg1SiamYKiCVQs/1pGUP8loaj67rknVCU6VvZrZ154vBAT9EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lrv0vf7ddRL6px4LBYiXsAvW2LvRTJiftIxkAR+4wUE=;
 b=bu74RQKqeSRNnOxtoYyqR3wVR34z4Ts2GXSjq1YyHiB8ecb3RxiULEzzCG0yL0ATW6peA0SHwLwgkZmnuqexb1wNSFt7xxNEdU/jKDiBj52r0343m50vWldE+q7FsiCOaci8yDAshIaqvo6MZWGxchOFXmgJdNhkmJJTay8i9Tw=
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM0P190MB0737.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:195::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Tue, 15 Jun
 2021 14:44:06 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 14:44:06 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Jonathan Corbet <corbet@lwn.net>
CC:     "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] documentation: networking: devlink: fix prestera.rst
 formatting that causes build errors
Thread-Topic: [PATCH] documentation: networking: devlink: fix prestera.rst
 formatting that causes build errors
Thread-Index: AQHXYe1Fn7zIPKOl9U2HK9KZGh+J3qsVHh6AgAABvwCAAAUxlg==
Date:   Tue, 15 Jun 2021 14:44:06 +0000
Message-ID: <AM0P190MB0738E4FB662B2A626137A629E4309@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
References: <20210615134847.22107-1-oleksandr.mazur@plvision.eu>
 <87sg1jz00m.fsf@meer.lwn.net>,<20210615142224.GA18219@plvision.eu>
In-Reply-To: <20210615142224.GA18219@plvision.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
x-originating-ip: [185.95.23.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f51de435-f5fa-4f12-b7f6-08d9300c0702
x-ms-traffictypediagnostic: AM0P190MB0737:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0P190MB073790E4914A915F47974F88E4309@AM0P190MB0737.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E3JU99LcHAtj1/rLWHtP55Lp2UYBUHyHH++03HK+GU85wcv6SwwaZqiF1519dSmXpTWzeRoInWVnNtKXkjGOJComtedMgZf2C/rbo5sIoAeFBtB1AAlPeXTzAenWtQE3gY1U/yeaq8JrgsKVPQWbaubLt+I+LXBWZ6ZuBMAaILBHAjeRkQQJfiD3PbhCSxBw1D+XhlfwP+8sYzaSVn4JkzDqIoD1dzM7mR+gY7cdPLdoW0FL6NdoA/84xQd/iK/3odMH+nkNnaMEsg30iwMPt6JAmeWRGWvngDdhy6JsOMXhv01RNEl3XTKK+00eSTj9EZK6TiXUcJpnlvMA5C2MS2RDbAVFK7oirNrRzQW9kE4HxKWvoo0Qe+c58P/9ftb6/aX0pOrIHVF9uuhlJ7V+SIIvV4JbVZWFnM7BQR7xsLwkB4Ohmxt+NxZrtxjUri6smMZluCliI3YfZPJySp9vUf7vzXHwhNOPshYCWjZGrAQ2ND+u0cGaDJQEZHBAyO5FDvmrvlbXsGxr+RgcPHjmRqlk1YG/kTmVnFJYpJXrzCRupegKRmn0yy9IaK2lTWCtJpZ1VSYKYNFILFd5eAk6Y5yI508SfBPlixxKWRIZNdw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(376002)(39830400003)(86362001)(66446008)(64756008)(5660300002)(52536014)(7696005)(91956017)(76116006)(2906002)(66556008)(66946007)(66476007)(44832011)(4744005)(6506007)(122000001)(4326008)(316002)(71200400001)(110136005)(186003)(38100700002)(83380400001)(8676002)(9686003)(33656002)(7416002)(55016002)(54906003)(8936002)(478600001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?yFz6bO6xAPfWLeNajJHhdh0h9B9N/3fZP4JqNo6iH/47LpiI3PIqOu/QbO?=
 =?iso-8859-1?Q?l727bobOjlcMgf9n0gzYTqvURfGE2AugAT1vgzPgv15Ecy5rIW9WGee3Rb?=
 =?iso-8859-1?Q?JBJwFPUgtTo3Vf8GQ7/6YKHH6Hc3tCP/MKF8iHgjPdxma9y0obRhilvRn+?=
 =?iso-8859-1?Q?h5SN2OTAEpqpOYjRJSIcYwAbE5YQl1wOpxi3vDCHUO9W7bJZGixg8Uotk2?=
 =?iso-8859-1?Q?oGwOktVZb8SLg6GXtcAb3lTBHf/OJu9futFQ1PMU6AXXgLA16MmodEgr5c?=
 =?iso-8859-1?Q?Zpjfnwr3zBHOYOopgv4vbl7v25a3sEi7OtwSu7wyblC86O+oNWIeNQmMBu?=
 =?iso-8859-1?Q?dNs12yibm0zGlgHFLOgDF1Zp+DHDoijiGaj2X2EM4+5l3wYC/Pf+FmcIBg?=
 =?iso-8859-1?Q?ui+2oXU/zjzHsvhZkF+qJunUoXqKWwkwkoiwyu8A/Jg5uohtz3fevTVusi?=
 =?iso-8859-1?Q?A+dXFJpDP5TdrwGJqV42/75ESko/9oKPyq5NBFBOmv0gCPppKimepbyhtM?=
 =?iso-8859-1?Q?mZQ5CmDmkgN0WXV6+blSJh5RUtbZscbVKqTXLJLTU7Sx3J6YdtkKlWD/ao?=
 =?iso-8859-1?Q?J4AKVbdNMZ+9l1EKCyvIOuViWUH89sgs92xOHMoTLepQ0QfXZbMwcOkbEZ?=
 =?iso-8859-1?Q?fLz4DqYxKa4MZQqw4ABG8rGmH3KGC/20dyLflvweSDz8y5eTKAHTAkfGkd?=
 =?iso-8859-1?Q?4Bgkr02aD383urroRMdUONJWXS5JxS7cZfHxqJMcSKzErOvqfIUY7j4YL5?=
 =?iso-8859-1?Q?9SwS+fi0RW7r6OM8Xg2kJl3W1tTRBh1Wa7gpnH2jXePhFaJqKvmY+0mmff?=
 =?iso-8859-1?Q?XvAiygsCnKzL54PtQf6Iexq+zpgdcWbaNwjcVBLvfgfAhwmmsd8qrTFfQn?=
 =?iso-8859-1?Q?3cSWrHMoPzpJS7bOhG1qjUEt6YMXqYUuhmLIFV5ANOTlvVkwzby4KGzNiC?=
 =?iso-8859-1?Q?unQTBwzGqBasLZ+D0yWb2Vgy+3MubJTknye1hD/r0u0EqL3aANQ9kjkJZw?=
 =?iso-8859-1?Q?Blw425gwiGvJW+KjkErYrKqQ9hZ3E8dCRiUuT5Q+8/H1YhoL+HkBr+kurX?=
 =?iso-8859-1?Q?bO/OTQQ5lEbE1CYCGkzgz05rAQrp/N3C7yLvuixhXdQXWEKa3Q7wUzwGjv?=
 =?iso-8859-1?Q?GVTBsf4jxtk1rh0j3C+KUGf+eQY7RjSfBHCE16OFZgK2jN1F+420rrL23c?=
 =?iso-8859-1?Q?gOg4K8v71FwHie1xuhrg33UU/+jl4ftCdTz1XOsUbGgk1Z6Kg4+rYUmvE7?=
 =?iso-8859-1?Q?SL4Aan2SoFBbvaJAVwGU0bQbt5nyC6XR1FeGCWOC/vYaIU1s4GyMIfJukP?=
 =?iso-8859-1?Q?vK9dHcFspWqqnZZNpatKFKuuHcioEh2gpn/fEHFQ9Hc1JFQ=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f51de435-f5fa-4f12-b7f6-08d9300c0702
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2021 14:44:06.4139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WMRGgj1T8gTzifDsCj7rjtYaBSxwNFQHGBNPUYHg9OkJCeJeYOyjxG45iGeIfnCNbWKxTm+2uZG6PtFUs+eBc1YRDwnNY+A+umjCfOeqFek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0737
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Oleksandr Mazur <oleksandr.mazur@plvision.eu> writes:=0A=
> =0A=
> Fixes: a5aee17deb88 ("documentation: networking: devlink: add prestera sw=
itched driver Documentation")=0A=
>=0A=
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>=0A=
> ---=0A=
>=A0 Documentation/networking/devlink/devlink-trap.rst | 1 +=0A=
>=A0 Documentation/networking/devlink/index.rst=A0=A0=A0=A0=A0=A0=A0 | 1 +=
=0A=
>=A0 Documentation/networking/devlink/prestera.rst=A0=A0=A0=A0 | 4 ++--=0A=
>=A0 3 files changed, 4 insertions(+), 2 deletions(-)=0A=
=0A=
Sorry, i've missed the 'net-next' tag in the patch subject. Should i re-sen=
d the patch with 'net-next' tag?=0A=
E.g. form a V2 patch with proper subject/tag: [PATCH net-next v2] documenta=
tion: networking: devlink: fix prestera.rst formatting that causes build er=
rors?=
