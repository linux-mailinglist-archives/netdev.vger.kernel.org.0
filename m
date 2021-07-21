Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684573D0F89
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 15:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbhGUMta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 08:49:30 -0400
Received: from mail-am6eur05on2088.outbound.protection.outlook.com ([40.107.22.88]:55137
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238100AbhGUMtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 08:49:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pa5FdpfYxACi1pm0k87WDSdV/3qdU3GElBlm5bat52xkOhKSj99aJW3VajE2ITrkJNOB0Omgc5RjEnSrOsM0iHqwhvgflC5ZY3U9NqDCqaiE5SNWZ+HMVjFh1JYIIIi4qNbbs2QeDTsk9yEMFVAFyUSciLee1oX9xTmpWVIfo5zeooiOALnZjh3suJa+QzlX+XgQWGgI5FML0c3LaHo29cmQ2YY2JRACo1n8qMkvMW4Jdu8P6qSxz8eQ3hPgdru7Jv7SNvvJQ5jjy8DJ/B5oqGxBdO/5Zzhmuz99sGom6os/pVKdvSUxA9WA4GGCW+2iuca2sHWLQLSOoyTpm3kHXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfyKWTR/T8Gon4X2+jlQMgOMC0rwCoBGk6WmVlFfOM8=;
 b=G7x+OO40T7tduf8KcCGAJOUu2mGnaaXVelHXRv+wXTjXp85qQprK0QjzJ5rVDHwC4zQgBc0okp2u0m/ftilO+N+yAzT27BMxBPBVeKYXRGShhMYpJe233fl8EhBeMl/5A+8V/beJR85LTlNvEuZnV+r+UR1VGpDMobHwyUFoYyK/RLvjEnDPo6mDzDGoslmSsW9cjLFN3fE3VuWsdalUBGqZ2vZutjIjnTEKBWgMRT/jMcgzlRVSDxY75Htkn0ylVsGiJmhbgEVi90z1EpUvLz8TkWybcA2jHQ4F/mvRxshMBoBJx5EyokOSITQPIridKzTp7dHFUvXzYq86DBWC2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=peak-system.com; dmarc=pass action=none
 header.from=peak-system.com; dkim=pass header.d=peak-system.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=itpeak.onmicrosoft.com; s=selector2-itpeak-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfyKWTR/T8Gon4X2+jlQMgOMC0rwCoBGk6WmVlFfOM8=;
 b=Vp1T6WpZvCQ2BCoO9BNBl6OPO7mHaHS09OP1VXp+oUTOYhgVnkn10iSil04ikl6j58WF5Iu6TxwRWLv6cIvrPOuGe6iiq5SXjw0S1+RZdCWFDp7bFvHylLAadCcNtmY/1kvXYwkCDMPOIc5JhHjZmFDeBBDRJWO/jtI9pc/RTQI=
Received: from PA4PR03MB6797.eurprd03.prod.outlook.com (2603:10a6:102:f1::9)
 by PR3PR03MB6475.eurprd03.prod.outlook.com (2603:10a6:102:70::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 21 Jul
 2021 13:29:59 +0000
Received: from PA4PR03MB6797.eurprd03.prod.outlook.com
 ([fe80::74d1:41b6:bd14:588f]) by PA4PR03MB6797.eurprd03.prod.outlook.com
 ([fe80::74d1:41b6:bd14:588f%8]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 13:29:59 +0000
From:   =?Windows-1252?Q?St=E9phane_Grosjean?= <s.grosjean@peak-system.com>
To:     Andre Naujoks <nautsch2@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] Expose Peak USB device id in sysfs via phys_port_name.
Thread-Topic: [PATCH v2] Expose Peak USB device id in sysfs via
 phys_port_name.
Thread-Index: AQHXfjBTthf8tvd2c0W4sNoqwIwu4atNaaF8
Date:   Wed, 21 Jul 2021 13:29:59 +0000
Message-ID: <PA4PR03MB67973D473C7CE600A6104EE8D6E39@PA4PR03MB6797.eurprd03.prod.outlook.com>
References: <20210721124048.590426-1-nautsch2@gmail.com>,<20210721125926.593283-1-nautsch2@gmail.com>
In-Reply-To: <20210721125926.593283-1-nautsch2@gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=peak-system.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9147fcd-7f65-45fe-cb03-08d94c4ba35a
x-ms-traffictypediagnostic: PR3PR03MB6475:
x-microsoft-antispam-prvs: <PR3PR03MB6475FC72D4AF02D902E2F1F9D6E39@PR3PR03MB6475.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gc1dYE6MSirdryaIjY6yTk1kZxsNkWy6vXjqB9WvS8MXUUgZCeJ9oz8P79gaG8u/Ebg3jvOjnU3rofnOXvBbcgD1j5VNQ2gLkl59cU3sDoPP9UVMkWFzth4pHJdz11Y7fDKHRuQLG8sr7P7M8KH1/+BqzqwsTVPtwpowI5yb7jC0ikmf9r2FnkC67hfur+0c98WRbLuHKg18Vy9lztjAdxqfXDRf/p3v0hSCE9akNulFffoquKLUV9bYQoCu7XMQF567OaTHITuIZ8JpBXKNWN/xTyCJYt3nENt3i1Saiifm5TMNftlMvMysysFE56yiBwZTuHjr8KG6ns+sgl/XkOVJtEv6/OOuJNMxkfJ0uWoq7NsrcyQmwTmNR4+H+m0oRwHvRq33x0eQwbOVrdbYD9JFRGnBkwkwcHWRn1bX+4gHAAprCQAJsPmSHWLLhAw0jN3BhIHU2994G1IoiqA2Befqnq518O2L0SNuWWgD1gwcARD2irAH274UIiCbbvrR4wW0fEU3MXeoRRYcpo3+C0tk2tbswMtsjD1LVPgYEFAbid8dFELWFRcJnpxQyOke55NWym5axBZ0l1IdnThC4NdPQr4infwujht79TKkLsR/SQBKvqfD+tQYkKPRAA1WeTc88D6aNRCQu0Rtl/WmYiqdaSVbDNltjFOVdxD0X0vl2UiPvLuB/jxs1pjE205ymwjHzIR3OPwDqPN37JEOdwITcSFBVB3m928q43CZyRY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR03MB6797.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(376002)(136003)(39840400004)(478600001)(66574015)(76116006)(7696005)(26005)(66946007)(66476007)(66556008)(6506007)(64756008)(15974865002)(66446008)(921005)(52536014)(5660300002)(186003)(8936002)(316002)(33656002)(9686003)(8676002)(55016002)(2906002)(83380400001)(110136005)(86362001)(71200400001)(38100700002)(122000001)(7416002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?2a1aFiLTvrRbey7wzw1PQ5Z7w7OCiribCUjP98WVzZtGgdzE5KxbvLv0?=
 =?Windows-1252?Q?j6Jvzxtu4gYkMJgzjxz1IucUNwGnvlTvHRyclZf0luDTmmYWXbnFLnUt?=
 =?Windows-1252?Q?l0nA9T32SVRIdRtmRu3AwNbRbn1q6XxtE7n1yn1QOA998Zhcl2LHJned?=
 =?Windows-1252?Q?PQRFO3jNa2NYTX3mKv7Lgl0qNespCgCYOCEtkFbk6vUOGWCgDc3QEvKl?=
 =?Windows-1252?Q?Ak0dLOH4VFrgZ5UQWfx5GUrwhTN6XvxZxB5miB0GpCqXNphahc7nClfW?=
 =?Windows-1252?Q?5J46OJNgA/Kdmc6QVI1ECXXZihpaEbLhCG/J/BGgrho4uRPPMWbd0RQq?=
 =?Windows-1252?Q?vs2WZGXjhRQljVZfYZpM4dnfh7L5I7QseaVyfc0X0CQcuASArR6FQ0xB?=
 =?Windows-1252?Q?xh4+YfBDXnhKjUZPvfPmWzk33MMbWsjEEE3G6oFMmaFCNDrdOTrGqU7o?=
 =?Windows-1252?Q?9FMSLEUduB036zsXUrkPjqz6XgdJfUP0PtLrVoVWiv06P4vr9RFj65GF?=
 =?Windows-1252?Q?VyhsxyjefJ9GFNFeXQAzppHa5McxyFua82hv22CX3zuUfZ3sWDrhfO13?=
 =?Windows-1252?Q?s0FPbuxIhKi8bRNK0OK+As/2knWbuLA6HnPujj7xKgfGHyloC9fXLabt?=
 =?Windows-1252?Q?GANy0YIwbER26PU6kmuwShQ7xC4o7b9TnjWqPxLI4Sgyz1DDRoGJTKdv?=
 =?Windows-1252?Q?2OtNn7reS/VDGg7lTsnChj9bpwgH9h2nuZgDNhh88t8KrSaRy63jwKcK?=
 =?Windows-1252?Q?2hZLcIoy7ziEQmbq7aR7Yz8gqzX0B+JnleSxyQ9kcWrUBiPFcInhaE5w?=
 =?Windows-1252?Q?8EyAIauekMvQTp8GP8vRXxElHhvU8ZWgOeIirwEPVHWb95ZvHCg6vRLQ?=
 =?Windows-1252?Q?Z8hZeEpKEwRCcFmAJfJIq8fwIcHLSGI74Y7bAX4mSFMHujx1iAwvfKC+?=
 =?Windows-1252?Q?BZcDNcAqwEk/rGxx+nKKCAP5yAeMX/rBwy+TEDTzgItLSc9mrD7SLpoa?=
 =?Windows-1252?Q?T6Z/s2UaJ6o0Dhv3ph6QlOSk3UREbPRVBXb9EF48djFmgopLWUXRxxec?=
 =?Windows-1252?Q?N9wgOMsnNU4ImvcoIvzlgwDkI5VNkk+TeWWISrH3rcltZG3LVET8BmyE?=
 =?Windows-1252?Q?7F2gWtByoakycp2qsdarrZoPwOc8wrZis4YIUS1bOnGDPHsfdMH0UFI8?=
 =?Windows-1252?Q?AIjhEZsw8L2+SpPvB/GevqHlBAhifQMeieqBbud77fjoybxeobbonAQ3?=
 =?Windows-1252?Q?kZ8MbP5R7RDHLtXRQ0xUK8S9cVIWDZ3GlQAmHJHh4T/018LZ3JEsYBy0?=
 =?Windows-1252?Q?o0S+yzuoddPkNIfPhjHsnlSdb+bZeFi3jCTx2H0QJRG9PIKXiqgaRcNi?=
 =?Windows-1252?Q?gEnlDHP0k5G0lAYDqnJHpTycvOXlfbNLfnE31GrZW7nlmDkmj6cbF2Ew?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: peak-system.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR03MB6797.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9147fcd-7f65-45fe-cb03-08d94c4ba35a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2021 13:29:59.5071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e31dcbd8-3f8b-4c5c-8e73-a066692b30a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SkqU0rO60Eo+2FQqUdp8poUz1+amxrbsyHcAwn9R6yVVtuIIIXqowCT2hvHKnq0KN4IzoVe6/z5OInYoWsNS20JIV6qC8G2uD2F1CkneIQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR03MB6475
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The display and the possibility to change this "device_number" is a current=
 modification of the peak_usb driver. This modification will offer this pos=
sibility for all CAN - USB interfaces of PEAK-System.

However, it is planned to create new R/W entries for this (under /sys/class=
/net/canX/...) as is already the case in other USB - CAN interface drivers.

=97 St=E9phane


De : Andre Naujoks <nautsch2@gmail.com>
Envoy=E9 : mercredi 21 juillet 2021 14:59
=C0 : Wolfgang Grandegger <wg@grandegger.com>; Marc Kleine-Budde <mkl@pengu=
tronix.de>; David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@ker=
nel.org>; St=E9phane Grosjean <s.grosjean@peak-system.com>; Vincent Mailhol=
 <mailhol.vincent@wanadoo.fr>; Gustavo A. R. Silva <gustavoars@kernel.org>;=
 Pavel Skripkin <paskripkin@gmail.com>; Colin Ian King <colin.king@canonica=
l.com>; Andre Naujoks <nautsch2@gmail.com>; linux-can@vger.kernel.org <linu=
x-can@vger.kernel.org>; netdev@vger.kernel.org <netdev@vger.kernel.org>; li=
nux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
Objet : [PATCH v2] Expose Peak USB device id in sysfs via phys_port_name.

The Peak USB CAN adapters can be assigned a device id via the Peak
provided tools (pcan-settings). This id can currently not be set by the
upstream kernel drivers, but some devices expose this id already.

The id can be used for consistent naming of CAN interfaces regardless of
order of attachment or recognition on the system. The classical CAN Peak
USB adapters expose this id via bcdDevice (combined with another value)
on USB-level in the sysfs tree and this value is then available in
ID_REVISION from udev. This is not a feasible approach, when a single
USB device offers more than one CAN-interface, like e.g. the PCAN-USB
Pro FD devices.

This patch exposes those ids via the, up to now unused, netdevice sysfs
attribute phys_port_name as a simple decimal ASCII representation of the
id. phys_port_id was not used, since the default print functions from
net/core/net-sysfs.c output a hex-encoded binary value, which is
overkill for a one-byte device id, like this one.

Signed-off-by: Andre Naujoks <nautsch2@gmail.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can=
/usb/peak_usb/pcan_usb_core.c
index e8f43ed90b72..f6cbb01a58cc 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -408,6 +408,21 @@ static netdev_tx_t peak_usb_ndo_start_xmit(struct sk_b=
uff *skb,
         return NETDEV_TX_OK;
 }

+static int peak_usb_ndo_get_phys_port_name(struct net_device *netdev,
+                                          char *name, size_t len)
+{
+       const struct peak_usb_device *dev =3D netdev_priv(netdev);
+       int err;
+
+       err =3D snprintf(name, len, "%u", dev->device_number);
+
+       if (err >=3D len || err <=3D 0) {
+               return -EINVAL;
+       }
+
+       return 0;
+}
+
 /*
  * start the CAN interface.
  * Rx and Tx urbs are allocated here. Rx urbs are submitted here.
@@ -769,6 +784,7 @@ static const struct net_device_ops peak_usb_netdev_ops =
=3D {
         .ndo_stop =3D peak_usb_ndo_stop,
         .ndo_start_xmit =3D peak_usb_ndo_start_xmit,
         .ndo_change_mtu =3D can_change_mtu,
+       .ndo_get_phys_port_name =3D peak_usb_ndo_get_phys_port_name,
 };

 /*
--
2.32.0

--
PEAK-System Technik GmbH
Sitz der Gesellschaft Darmstadt - HRB 9183
Geschaeftsfuehrung: Alexander Gach / Uwe Wilhelm
Unsere Datenschutzerklaerung mit wichtigen Hinweisen
zur Behandlung personenbezogener Daten finden Sie unter
www.peak-system.com/Datenschutz.483.0.html
