Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A56468520
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 14:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385098AbhLDNse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 08:48:34 -0500
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:10190
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240119AbhLDNsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 08:48:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezHX/7W1Jdb1xDA8GPkjyAshXWXg7/18emo8MrNN5nsbGnj2MWCjXzPd2bduLcNYs4azanBkS1ozFnL/N3P3hTYFIWWBwrjRz7i1X+u6zxVZhWJihU4fmhktNUk1mVYJHhxbT3FputENLX7nwmB01Mdoq3WSVX3bMAQ3mACz29Rj6pJWboW8ofACWNzlePNFuqj1qekroysW+zC+1G5t9ry2k985n3Vl5p3pkyViTDK4e4PHhMoJsjPm1wuO1g+X6vjSZa1kubSuva6CHvMCUajdL3WO35kRftzg4ehBVmqWMx5Tk7KlfSVWej+hRxzSV0pNnDZOrFbmTvFp9GDvuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhvL7zZUfk9ARHOp03k98XNCcL8ykfj1TceQVu+mv5Y=;
 b=GP9UnArMWvBFywu0tNZBrPLqOZ6mraw4zP7sMMrt4H8e1pc3vARld8pdLKIUKqrmLh6ky3seReBImIohdhLOPGUcFVEndgT0IaafDmwewJsBZRXa96dmi0YvS44WCqq1IbhTkR7gpG7lk/Qds3bO/+ukd6qp5AanLLzmM8XT8aPlbaqOaENmWJKxpINBvU1APrsYWjU/+So484Cil9pi75MYVZhkWMA8oLDR5XKgwYlaWamGXAjxY62uMJCbdL/00kYmCjkfj8hjPFTCo1ZIyl2pNwHogBLLYB+HTmImT1N9ld1v81F8F8HcseYA/LwQfrD+jM0Bi29G9WqUz35Gmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhvL7zZUfk9ARHOp03k98XNCcL8ykfj1TceQVu+mv5Y=;
 b=DlBhL/lAmQMpxphy04tgjbGNP2T9DyKID5No2sPVeCR8mxQCloajKLFZKqv1mlhE6uRBAGRniW6TyuQ/lcWKLBYLmV5tgnlgfURrzDVY0l0yQxcuKXJzjk/OGiQ8dU4EI0JR3GkF5/bChLVKpdskw5jfnbWXUwwZ7vIBvWzSZLM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Sat, 4 Dec
 2021 13:45:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 13:45:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v4 3/4] net: ocelot: add support for
 ndo_change_mtu
Thread-Topic: [PATCH net-next v4 3/4] net: ocelot: add support for
 ndo_change_mtu
Thread-Index: AQHX6GoANn2TfF3YJUKhM3+j9K4sTqwiWXOA
Date:   Sat, 4 Dec 2021 13:45:04 +0000
Message-ID: <20211204134503.piezsfctdz5o25o2@skbuf>
References: <20211203171916.378735-1-clement.leger@bootlin.com>
 <20211203171916.378735-4-clement.leger@bootlin.com>
In-Reply-To: <20211203171916.378735-4-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e146f13f-f85d-488a-02e6-08d9b72c4702
x-ms-traffictypediagnostic: VI1PR04MB5501:
x-microsoft-antispam-prvs: <VI1PR04MB5501AFDA6EDECD4394BA6FA1E06B9@VI1PR04MB5501.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pVYrmgL1l7tGgH+VLLkv0wiToQvUGBERQLsxoginCrCwsoJe1g5Gwy7OarI3knd2YIj378kfprADqdJtg3jh0mdRbI3pkw+fFaHh2Za59oa2mir98mdf4yCfd+QxR0hiSyTPgcCZcJNKobjKrZNTrRiMPDd0U4jSI6WhVOCPGPi1bLK0RgigIvHzjQfrKlQFfvyh/WOqkC6bpAJwjnedtXRFIww2f1f57e7oHR4HP2jvLO9KC28JlJq/EQXOmS1QwMRYAIm4xp5tLmWpw5o4cjVPzcEK5c2PKVAYvfE33gW9aIKwSYyYSEuFZW59ZJaxrNZbth961m48wQFfYCnM2b4fIFWH9V2XWDdjuF+CDeiHgWkcJKtY7mScpr38WSIgkQcXIgZtIbugrd8xvWyrxHtWsGaNg73B9IdW2TNk2v9odecFreBKFLBg259b7oONpGUUPsQvoLuiv6ro1U358FgoucBNHdKYqbJn2ft6weuj1pgXhrx6Uz7H3h1QU1OK115phsFWJZuJ7spKxvWDLbjoG1qC3ZyYJkHfUXcKwDsz8SUwE3M24fcCxJNwnE0OXNoKHdRSCtsWIhIzvE3OatEdVfPClOPSyq7PzI+ZMGpBa18AypMGFMRsGcFoyDstz4qsgEIQH5JvG4qRd9eeLjgJw5/bld3eA9B2NksOx/7u/HTuN6NhLqaaS80dUSw3zqCUoP7LI2gYXQdZ/Pz/CQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66556008)(66446008)(316002)(38070700005)(33716001)(66476007)(38100700002)(86362001)(5660300002)(54906003)(2906002)(122000001)(8936002)(8676002)(66946007)(26005)(4744005)(64756008)(71200400001)(508600001)(186003)(91956017)(76116006)(7416002)(1076003)(44832011)(4326008)(6486002)(6512007)(6506007)(9686003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?DO33a0lTji75mxjpxm2TkXZ9za2XcxYmgjCBSNyOz3rl6cy8DXlkyojU+w?=
 =?iso-8859-1?Q?Hh5UFgfe3RgcaKuB814iBXNw+ePcubTrBR582PuHltpYSZ5w1ONUp/U/3r?=
 =?iso-8859-1?Q?8NXlTXchddx21OQkH+ucyuLyuI6MVDm7oqse1oInyRQdRBg+Zn2Wgg0P9C?=
 =?iso-8859-1?Q?CcAowrgJDhQSqNDiTHcWuNGqKPOqlROiXx8XXJFSwiV4/P7hSk9ZwS4dxF?=
 =?iso-8859-1?Q?+5pAXf94jP1CAT3uTc13M7Lo6GYwRT1LzySot9xYjhQQ3lKuMpfqNYaF7s?=
 =?iso-8859-1?Q?kBuwnE8RoxgC0XjKb+CTFeoetGvfBusjdPHRbvYQtfm4fVGtylrhAc0YqO?=
 =?iso-8859-1?Q?pCKpx0j0eqICUSghlgw4KmWPsKTa3xjHN+tBeteMNktTIVpbN+6H/aAbDq?=
 =?iso-8859-1?Q?IzxDA0V2JBkEMkaIZKFgOIuVgnOMDpLAtSMxjoFTZZKD3iNz9LNlAP5yG8?=
 =?iso-8859-1?Q?Hj19FhRxN/FD1+QzgtmNpDA87uSJhDEi7qcwSToo2G9SsKtbKSND0od4vr?=
 =?iso-8859-1?Q?i1TgrlhVKvFfiR/9g0Gh1AE9v7em4VEhEIhHYZ0CCBdqfkk+aUtTBp4Ohc?=
 =?iso-8859-1?Q?7yQxkEDxtFGtmke27B/3CuRXWNZdXtKoxfi6f9TmT6VevokbujvejUfAj2?=
 =?iso-8859-1?Q?BOTNeMOFrGZtGFeWDhPdo1SSCePo9jPEfT5nUGCGu2Yd58yBa/JwapxXRz?=
 =?iso-8859-1?Q?oZhpUXa3AMZbpKqlUy8LIVd7nDcLYShw3r0Tl8xsg5pCGdJ4zf2qVEaFdD?=
 =?iso-8859-1?Q?bt/oKmJcZFHpPSVFd6T9qA3Pd2qLckC6h4121oliAZOnz36rY5Vv8plYkJ?=
 =?iso-8859-1?Q?XzvOC8NmG9ocxbiybfHHkE0ArE7KmXs9IQ7YWL65augawMMa4HfSgHu9mr?=
 =?iso-8859-1?Q?PY1DbtiHG7eLjwYY9uEZ8n6lBsbNaYypBsDxxDE5hrN8X7GyP6ewMPp1ul?=
 =?iso-8859-1?Q?2f+Wo5tb1xawtPSSHJ0DhkoBwkdtOTM2dG6w3757YZr1gwYtKYARWZGf0u?=
 =?iso-8859-1?Q?trzxVxPwJ8aOkfK/QXtT8jgX91mZh6qgY/XwDCrTqVZfCkwVKHSwU+vYXA?=
 =?iso-8859-1?Q?AkuiukwUsC7076SG+Buc3izntLZxxVQsLWvSI4UDsemJFzVs/yXFWz2els?=
 =?iso-8859-1?Q?4F7SXNLiq72T/id+aJhxjNGtLigtsfNlu3FdUpLdkrRM00CVFonF4+AWeO?=
 =?iso-8859-1?Q?zJeZVe0SWVfskQNyr9JkX1+NCa7wHe+VSYPYj0VAIBBApmzPm1ZlQF9nDo?=
 =?iso-8859-1?Q?PNZK98GQTNRsdcs5v70a9GSXPkq7ILbI+aNkSzlkU40pF9cxzh5iitjvbB?=
 =?iso-8859-1?Q?4sXw+40P4hx28SSrsWtNFB89WI8lbAtYP0kwZJbRsQYqXHZzjn7MBw+psG?=
 =?iso-8859-1?Q?XRFgS/1PBYW+G5zETc2Hv2d97w5sF7vIYKGz7BXANmR3fctOoCwnS1gGWl?=
 =?iso-8859-1?Q?2WdHsDNz9oCO4ScncJdvBBmKtj8IODxQUkCPfEfmrsrNcTcI50gF71xPj4?=
 =?iso-8859-1?Q?oVGqbuGWvB57bQDMniZ1H0RuwMbdP49+gWG2FKp8RLBnp/jJcCWA2VLYN2?=
 =?iso-8859-1?Q?91s3b4M1l61AdcoPXuAmoM90iQ2mMJsV5QLgiFcV0kmvCQOrN6ZPwrZTFm?=
 =?iso-8859-1?Q?lKaqnk4wENcXQQJS+BcpwH651FBzZTnK07lkHofmwYrK4/myUQywacJZ25?=
 =?iso-8859-1?Q?h6/2fJzUAV/z/P71Utg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <9679BC087DF65644BAF42009846E3395@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e146f13f-f85d-488a-02e6-08d9b72c4702
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 13:45:04.6144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bI3Lp9jflfq0E9MxnlTMNethJIwt44LeOUtZW8YWN9/98CBq6Obt6ROrY3SCAMFauyMij3Xyafoiz1ZNGAXuYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 06:19:15PM +0100, Cl=E9ment L=E9ger wrote:
> This commit adds support for changing MTU for the ocelot register based
> interface. For ocelot, JUMBO frame size can be set up to 25000 bytes
> but has been set to 9000 which is a saner value and allows for maximum
> gain of performance with FDMA.
>=20
> Signed-off-by: Cl=E9ment L=E9ger <clement.leger@bootlin.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
