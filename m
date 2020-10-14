Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A62628E132
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 15:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731181AbgJNNWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 09:22:18 -0400
Received: from mail-eopbgr40040.outbound.protection.outlook.com ([40.107.4.40]:32601
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725944AbgJNNWR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 09:22:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OhkOrqnKVpa+y5HSP8bzSvpcS+h0c87YFTQAXETVldG8SrxerjWyUYsKZpWzVEd61mGji9JA/bvJIIeoY4/d1Chxz43nuf2bpMDQHWv0Ac9fRq6LmlxZ80gy3gq8QdHKSsGHEHPXbe79eAWUW9wbm/dbJj4DOtgtH4mmQiIDJ9l1BKVx3DnRqrhY4+gfKvf7u2iV+aaS7j49gQ0DOHhnMj2XDkLWvEHY4R6E6I1r1Hio5OgwOL1sf6sQ4G1Missg87cSEo86mm0S8Ndf86FJV+D8Qfe50bWpX4SL5cGlyIoEOCeXMgNMtx6UdVItHhL3xWr4tLmp2o0HYIG4fYhh6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1m6X3aWfes2vIysteM+lVgrqV21UZPiNcISrP+RxYVo=;
 b=BJCG9VpGF6CihM6ON5EeeN9QJadknJcEJQwh0iLBIthEgQW4is/yN81iv++V/M7waSR1cMBUHuwZLusgA6+kyxnzsssr6C/LY7nCHuD4ri0V7rrO5ni5dxgACzJRtjvoN5S23xDOSV0iMc3O/TTas8HJwBr+pOB6FrBHV14ik0d7PAFzEWykClNUHnbt6XMb5bE1aHFL43ApBzf8sjmwvcsVwKTq0C6HWpZeKTb/oMXTvJG7L7ShYecys1Q+17cfUFpwgA4sNB8hyzpF2ARLKzZWQkZll15BXqhQqqHkQBcZd3sA8zyGPJBkFscz8b23CkQSPUTmfXYrurzlsfDtKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=peak-system.com; dmarc=pass action=none
 header.from=peak-system.com; dkim=pass header.d=peak-system.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=itpeak.onmicrosoft.com; s=selector2-itpeak-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1m6X3aWfes2vIysteM+lVgrqV21UZPiNcISrP+RxYVo=;
 b=w0K4OX+BFVpi5uW2fwaM9ni4rnVNxK2vI+M/dfrjK3m/ca1m4yKmBsi9Gi6jPSQdcdMjv4nM3dAqzaWUM/s2u2VuMr1jVmDac+PKLsrnIscAPaoFvBUs4U5UaQR7X1jQgvGFcdmGYqzwJBRSyKj803dNqDQDZdvBbj0ZxWWEWgQ=
Received: from VI1PR03MB5053.eurprd03.prod.outlook.com (2603:10a6:803:bb::18)
 by VI1PR03MB6141.eurprd03.prod.outlook.com (2603:10a6:800:13b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Wed, 14 Oct
 2020 13:22:12 +0000
Received: from VI1PR03MB5053.eurprd03.prod.outlook.com
 ([fe80::5c89:33b8:a5ea:8b6a]) by VI1PR03MB5053.eurprd03.prod.outlook.com
 ([fe80::5c89:33b8:a5ea:8b6a%3]) with mapi id 15.20.3477.020; Wed, 14 Oct 2020
 13:22:12 +0000
From:   =?iso-8859-1?Q?St=E9phane_Grosjean?= <s.grosjean@peak-system.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andri Yngvason <andri.yngvason@marel.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: RE: [PATCH net] can: peak_usb: add range checking in decode
 operations
Thread-Topic: [PATCH net] can: peak_usb: add range checking in decode
 operations
Thread-Index: AQHWcXs9Qb/67FC9eEi/HZVs5d0UoamXawcA
Date:   Wed, 14 Oct 2020 13:22:11 +0000
Message-ID: <VI1PR03MB50536300783DBBEAFC7B0367D6050@VI1PR03MB5053.eurprd03.prod.outlook.com>
References: <20200813140604.GA456946@mwanda>
In-Reply-To: <20200813140604.GA456946@mwanda>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=peak-system.com;
x-originating-ip: [89.158.142.148]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ef993c1-0ac3-4a46-99e6-08d870442910
x-ms-traffictypediagnostic: VI1PR03MB6141:
x-microsoft-antispam-prvs: <VI1PR03MB61412D28727A0F65B95BB4FCD6050@VI1PR03MB6141.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XKqKUW3NkrsFpKgSXxwvZ2c9Yf/aglkDlibBgM3mv6jbCgV5ALCCbTVvNbcSFEORpDPO2Vy/6rZuHat/jY2PKKcc3161kDrNVTESadHXAzliQJOauvO370q9toce9dBffZt/ABBqFh2f1ThW4qwm+yNp6QuchnZJKeEANipn9H2N/JpOGnjeNL6Avag0Uo7S1E0rpR/d2WZCvL0BE2dBtCG56iVC8YKbaWOxcvhj24Eo11EhNkiqhZnGoytyaRklo3zmnl1sO4NFM+teASpNWBHlzIADzmg+oIqVx7Yn/d2yp7VLRinV8dbLzKv27BOw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB5053.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39840400004)(366004)(136003)(376002)(346002)(7696005)(54906003)(316002)(7416002)(2906002)(478600001)(86362001)(4326008)(91956017)(76116006)(52536014)(66476007)(66556008)(64756008)(66446008)(66946007)(55016002)(6506007)(71200400001)(186003)(26005)(33656002)(8936002)(9686003)(8676002)(66574012)(15974865002)(6916009)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0CUjwd+TOYS9igTuWRSzXRqQqQIcc91hOB+ia8Ii36y0vzYLmPIzUZ2o4qdzdvoqhOO4VWxEK9HH5fIfxxSBt1iJg3aqNd/70OoLyYHpagoFYK+rgDG8A3t7a7/rYwPCaK6ZfkN9/5rqERnZZ4grsZgZwtFMEg9MMYg6bv0Nnl12P1bep7kHwWg8JTY5dpwwamnDrT7TRB222GwTnqcAth7VmUp6J5A3nsmtXo5Mi4qFEN13LH4tgBK8Kbx3suPliX5eA/7T7RVNr0wL0Q/2nLlK4ZQCPLmp70TSwz8tTS6c7hNDYCpE9wpfUM2HXNkYE8oOu+I0paHEb9cuGSfZ763VJJA94+rmFCvAQs3AJjvKHxDQWFrcq1Hg6We8up0zAgoWWKOrlS1WAHl0izzp9l/6cwxLdAg/6r3fbiXg99kqnpdyejVScmZPWtuTI0dgq/AIF/zKNqSySeipuPdzTYJdxBuMXZkWrXnZs7iUFneBOc7muq4JHsnU/j7v5d7XVJTI/Taq4SGqQTx7T/i13E46j3e/hacVPHDnc7GNwrIFd9n8vCGzlVA7O44jQkuM+FGlgHf5uRwpCvYraz9wmvmGaHd9ztawbNzqPeEmUX2C9i6yiO23+T8dOMCR0a5Mj5MO3HImv+o5T6jYkqc+Jg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: peak-system.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB5053.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef993c1-0ac3-4a46-99e6-08d870442910
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 13:22:12.0067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e31dcbd8-3f8b-4c5c-8e73-a066692b30a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2cQrBv1hsLy6o80bh4GTbLXF8S+n8FgE0N1i0duHy7uZb7gNRWfhVqFWsvF7zdbL68WXiMf1g6cydWwQAgV59ArW2nRygTCmvxNPflaQlVE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6141
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dan,

Don't know if this patch is still relevant, but:

- there is absolutely no reason for the device firmware to provide a channe=
l index greater than or equal to 2, because the IP core of these USB device=
s handles 2 channels only. Anyway, these changes are correct.
- considering the verification of the length "cfd->len" on the other hand, =
this one comes directly from can_send() via dev_queue_xmit() AFAIK and it s=
eems to me that the underlying driver can assume that its value is smaller =
than 64.

Regards,
---
St=E9phane Grosjean
PEAK-System France
132, rue Andr=E9 Bisiaux
F-54320 MAXEVILLE
T=E9l : +(33) 9.72.54.51.97



De : Dan Carpenter <dan.carpenter@oracle.com>
Envoy=E9 : jeudi 13 ao=FBt 2020 16:06
=C0 : Wolfgang Grandegger <wg@grandegger.com>; St=E9phane Grosjean <s.grosj=
ean@peak-system.com>
Cc : Marc Kleine-Budde <mkl@pengutronix.de>; David S. Miller <davem@davemlo=
ft.net>; Jakub Kicinski <kuba@kernel.org>; Andri Yngvason <andri.yngvason@m=
arel.com>; Oliver Hartkopp <socketcan@hartkopp.net>; linux-can@vger.kernel.=
org <linux-can@vger.kernel.org>; netdev@vger.kernel.org <netdev@vger.kernel=
.org>; kernel-janitors@vger.kernel.org <kernel-janitors@vger.kernel.org>
Objet : [PATCH net] can: peak_usb: add range checking in decode operations

These values come from skb->data so Smatch considers them untrusted.  I
believe Smatch is correct but I don't have a way to test this.

The usb_if->dev[] array has 2 elements but the index is in the 0-15
range without checks.  The cfd->len can be up to 255 but the maximum
valid size is CANFD_MAX_DLEN (64) so that could lead to memory
corruption.

Fixes: 0a25e1f4f185 ("can: peak_usb: add support for PEAK new CANFD USB ada=
pters")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 48 +++++++++++++++++-----
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/u=
sb/peak_usb/pcan_usb_fd.c
index 47cc1ff5b88e..dee3e689b54d 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -468,12 +468,18 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_=
fd_if *usb_if,
                                      struct pucan_msg *rx_msg)
 {
         struct pucan_rx_msg *rm =3D (struct pucan_rx_msg *)rx_msg;
-       struct peak_usb_device *dev =3D usb_if->dev[pucan_msg_get_channel(r=
m)];
-       struct net_device *netdev =3D dev->netdev;
+       struct peak_usb_device *dev;
+       struct net_device *netdev;
         struct canfd_frame *cfd;
         struct sk_buff *skb;
         const u16 rx_msg_flags =3D le16_to_cpu(rm->flags);

+       if (pucan_msg_get_channel(rm) >=3D ARRAY_SIZE(usb_if->dev))
+               return -ENOMEM;
+
+       dev =3D usb_if->dev[pucan_msg_get_channel(rm)];
+       netdev =3D dev->netdev;
+
         if (rx_msg_flags & PUCAN_MSG_EXT_DATA_LEN) {
                 /* CANFD frame case */
                 skb =3D alloc_canfd_skb(netdev, &cfd);
@@ -519,15 +525,21 @@ static int pcan_usb_fd_decode_status(struct pcan_usb_=
fd_if *usb_if,
                                      struct pucan_msg *rx_msg)
 {
         struct pucan_status_msg *sm =3D (struct pucan_status_msg *)rx_msg;
-       struct peak_usb_device *dev =3D usb_if->dev[pucan_stmsg_get_channel=
(sm)];
-       struct pcan_usb_fd_device *pdev =3D
-                       container_of(dev, struct pcan_usb_fd_device, dev);
+       struct pcan_usb_fd_device *pdev;
         enum can_state new_state =3D CAN_STATE_ERROR_ACTIVE;
         enum can_state rx_state, tx_state;
-       struct net_device *netdev =3D dev->netdev;
+       struct peak_usb_device *dev;
+       struct net_device *netdev;
         struct can_frame *cf;
         struct sk_buff *skb;

+       if (pucan_stmsg_get_channel(sm) >=3D ARRAY_SIZE(usb_if->dev))
+               return -ENOMEM;
+
+       dev =3D usb_if->dev[pucan_stmsg_get_channel(sm)];
+       pdev =3D container_of(dev, struct pcan_usb_fd_device, dev);
+       netdev =3D dev->netdev;
+
         /* nothing should be sent while in BUS_OFF state */
         if (dev->can.state =3D=3D CAN_STATE_BUS_OFF)
                 return 0;
@@ -579,9 +591,14 @@ static int pcan_usb_fd_decode_error(struct pcan_usb_fd=
_if *usb_if,
                                     struct pucan_msg *rx_msg)
 {
         struct pucan_error_msg *er =3D (struct pucan_error_msg *)rx_msg;
-       struct peak_usb_device *dev =3D usb_if->dev[pucan_ermsg_get_channel=
(er)];
-       struct pcan_usb_fd_device *pdev =3D
-                       container_of(dev, struct pcan_usb_fd_device, dev);
+       struct pcan_usb_fd_device *pdev;
+       struct peak_usb_device *dev;
+
+       if (pucan_ermsg_get_channel(er) >=3D ARRAY_SIZE(usb_if->dev))
+               return -EINVAL;
+
+       dev =3D usb_if->dev[pucan_ermsg_get_channel(er)];
+       pdev =3D container_of(dev, struct pcan_usb_fd_device, dev);

         /* keep a trace of tx and rx error counters for later use */
         pdev->bec.txerr =3D er->tx_err_cnt;
@@ -595,11 +612,17 @@ static int pcan_usb_fd_decode_overrun(struct pcan_usb=
_fd_if *usb_if,
                                       struct pucan_msg *rx_msg)
 {
         struct pcan_ufd_ovr_msg *ov =3D (struct pcan_ufd_ovr_msg *)rx_msg;
-       struct peak_usb_device *dev =3D usb_if->dev[pufd_omsg_get_channel(o=
v)];
-       struct net_device *netdev =3D dev->netdev;
+       struct peak_usb_device *dev;
+       struct net_device *netdev;
         struct can_frame *cf;
         struct sk_buff *skb;

+       if (pufd_omsg_get_channel(ov) >=3D ARRAY_SIZE(usb_if->dev))
+               return -EINVAL;
+
+       dev =3D usb_if->dev[pufd_omsg_get_channel(ov)];
+       netdev =3D dev->netdev;
+
         /* allocate an skb to store the error frame */
         skb =3D alloc_can_err_skb(netdev, &cf);
         if (!skb)
@@ -716,6 +739,9 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_devic=
e *dev,
         u16 tx_msg_size, tx_msg_flags;
         u8 can_dlc;

+       if (cfd->len > CANFD_MAX_DLEN)
+               return -EINVAL;
+
         tx_msg_size =3D ALIGN(sizeof(struct pucan_tx_msg) + cfd->len, 4);
         tx_msg->size =3D cpu_to_le16(tx_msg_size);
         tx_msg->type =3D cpu_to_le16(PUCAN_MSG_CAN_TX);
--
2.28.0

--
PEAK-System Technik GmbH
Sitz der Gesellschaft Darmstadt - HRB 9183
Geschaeftsfuehrung: Alexander Gach / Uwe Wilhelm
Unsere Datenschutzerklaerung mit wichtigen Hinweisen
zur Behandlung personenbezogener Daten finden Sie unter
www.peak-system.com/Datenschutz.483.0.html
