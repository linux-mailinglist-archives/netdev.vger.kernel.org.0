Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D4D223350
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgGQGEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:04:44 -0400
Received: from mail-eopbgr1310118.outbound.protection.outlook.com ([40.107.131.118]:7595
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbgGQGEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 02:04:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0kdmUzDt31iCB8UKqtOGsSOD2y8WP3MmAqBihg/5bnFV+v6IfwhC/hM66O2rGqcXJWacchAG5Rk+zhJfDEgVuvIlobxmKrX96LUa6j9BTggcOs03rD2xvN9I/pyf+lSj9lis95rCUstLzFQFhX16fni7m4ccWX8Ok4SvmFv08Cyah0PXfQ41zWlpMpgf7lL+IK7ITxxFNL3+SrDFaMOFgJdEa0UaaWxmR34PYfree1MpwW3wHCLwHPN349AxwaAQG3YWNBW2aXGgJHZjsIWwlGC269DEUiIk4EgZK7gBw558O69uGRM3fTskHR/h4IqHuWKI3a0LnaK9gpMmq64EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDDANLUSfqTEe2b4Vz2hixm8ZUHTJQkFk3yZzng1SaM=;
 b=cIgJ9XnDtatZEA4TxsGw4O/c7M5dgmvaXWtghIQBniuWm2c8tISGt8gDqrzmyY5niuOr/aFRQps80eyLHerZxt+p5hOtxGKGgDFMwmJ4s/JvELKvJsBqZ+mFqjKdMjmeCDURtjGQeJNayCR0toYkgTshwdANVKmV1iAS4P7e+IcmcWb0MRWxjNu0gcIfPwKFf0DhmU1ogNdO4lZPLPLpleywuKxR1uGta2MQW7vtIIjme5VdE+Gi8Qc+P4RneWqjUDhWVW3cvc7hVLX4v7EMobv3JGeeZLR6cHXQ5UGhv+jJrbuqLfgtu662qjjqya4CDs1OlD+ZjXS0FMnB2E9htg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDDANLUSfqTEe2b4Vz2hixm8ZUHTJQkFk3yZzng1SaM=;
 b=T4rSOT9u6RpIMmjENs1TzVLCNzjZyEC4TAanWUrNinYCXQFCD0JvZtynyCWi925/XrGy1T38fG0pm4NAdpYjyal691U65LkmDJ4gmgz2syjTNv9T7Z46jRHno8zvu1/nlij/VQjvzdxXC2yF3VQZBsPhKgPDIY+mSXltbSKhOz4=
Received: from HK0P153MB0275.APCP153.PROD.OUTLOOK.COM (2603:1096:203:b2::14)
 by HKAP153MB0370.APCP153.PROD.OUTLOOK.COM (2603:1096:203:d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.13; Fri, 17 Jul
 2020 06:04:32 +0000
Received: from HK0P153MB0275.APCP153.PROD.OUTLOOK.COM
 ([fe80::b5ca:82a1:cb67:52e]) by HK0P153MB0275.APCP153.PROD.OUTLOOK.COM
 ([fe80::b5ca:82a1:cb67:52e%6]) with mapi id 15.20.3216.013; Fri, 17 Jul 2020
 06:04:32 +0000
From:   Chi Song <Song.Chi@microsoft.com>
To:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
 indirection table
Thread-Topic: [PATCH net-next] net: hyperv: Add attributes to show RX/TX
 indirection table
Thread-Index: AdZb/5iAkDMuWyahRIOBehKiULg7mg==
Date:   Fri, 17 Jul 2020 06:04:31 +0000
Message-ID: <HK0P153MB027502644323A21B09F6DA60987C0@HK0P153MB0275.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-17T06:04:30Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e65774ea-85c5-4afa-a5de-cbef4b422b7c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2404:f801:8050:1:4906:99ed:e85b:7e58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8185eb83-bf37-4f0a-326c-08d82a17464a
x-ms-traffictypediagnostic: HKAP153MB0370:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HKAP153MB0370FAD65B85B353335C6986987C0@HKAP153MB0370.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AWSh/tqwDyNF3Ane7vEs8hRdqASZ3us4XsVMPn+EfQyJdu40ENNUbKKbUrKehXk+duOjxGVgNYxrUzk4nMNIQxzcSoBxaE/sSnrCoCxsSHSId32sJoc/e+/4cI0Kjf4fx5uM9FtbJFF5ZXotCJHF4uwQwO1O7Pj+6A5NgiTXqraSetjgBSOtcze+aa3vmWnBlRYr3YPjDusrO0OzHCFX3y1MtNcWaFpxT1O+XHzRJEOBDrDdjjwr8U9Yd3BPYGgP+li/GhrfzA+Uwwwn29wTjrUqUr3tU3N3Kq9UI/0rTEMtIYrJm7qOqaQYqh4WGAiJXc58+QiQ6e5KLCR4QHnpaEoFuRP+LlbpY38og33jbjqJsRaJVl7isG/WaF3hllj6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0275.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(316002)(54906003)(8990500004)(110136005)(478600001)(10290500003)(7696005)(2906002)(186003)(4326008)(6506007)(55016002)(9686003)(7416002)(52536014)(33656002)(82950400001)(82960400001)(8936002)(8676002)(86362001)(71200400001)(66476007)(66446008)(66556008)(64756008)(76116006)(5660300002)(66946007)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 4Ux+fHsjMv6QasVsW0GJaRaCbEMgaNiFgT74m/Meb7qqCnJgtb1g63qKdgNfjDlEAHZElc8iTM4eXAKve6q8Fg5pB2DwmQnUxi/Q1jssZj1yuycDQUDO96iT0hWlUXVxX1cig994DatD98XaKGwJvGpx9NzoEXljz02aekq0KqoV9XYuTqK6Ne6j0J/vDdAcL5HYVZrC63Sl+XiStVsPqbOTDx9/U3i7Ha4XExcEhEanWAGHMX/+Oixn9oFrlLEd0uwdB4WCLSSXaPh2tPUxHvSWYvbitSQkmj2F/VIUXnyyAr2UX/XjtWZCwv4T2KduT1oSFNbsfQO4udNQ0g5ULRJuDzMY6Vu64XsO+gFmKkZ8EsV1GM0YNYccIp2Gc9URuoK5+huMduSddABrxB+UOCRxJsd0VTllXfpsPuCzx8QeYe5INMm1HfFUCX+u0sBMs2QV4QV5buBlvPgymRP+clTE3VLOgFWUyN8JMqt4KqoaCIUxIkPeV5/n4sJy1UOB/LdZeYjnxNmJ1m7j1+dq4vOC9TrM+lQcj8DGqZaR22w=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0P153MB0275.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8185eb83-bf37-4f0a-326c-08d82a17464a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2020 06:04:32.0119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P3XA5Ai1ozqjv2HJJ+zK4bfcu7t7iUNA7uk5/IHN+P16MR8ZQZzT7fDWclnBy+acK2aTro5pNtA5/8cenpxiNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HKAP153MB0370
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The network is observed with low performance, if TX indirection table is im=
balance.
But the table is in memory and set in runtime, it's hard to know. Add them =
to attributes can help on troubleshooting.
---
 drivers/net/hyperv/netvsc_drv.c | 46 +++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_dr=
v.c
index 6267f706e8ee..cd6fe96e10c1 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2370,6 +2370,51 @@ static int netvsc_unregister_vf(struct net_device *v=
f_netdev)
 	return NOTIFY_OK;
 }
=20
+static ssize_t tx_indirection_table_show(struct device *dev,
+					 struct device_attribute *dev_attr,
+					 char *buf)
+{
+	struct net_device *ndev =3D to_net_dev(dev);
+	struct net_device_context *ndc =3D netdev_priv(ndev);
+	int i =3D 0;
+	ssize_t offset =3D 0;
+
+	for (i =3D 0; i < VRSS_SEND_TAB_SIZE; i++)
+		offset +=3D sprintf(buf + offset, "%u ", ndc->tx_table[i]);
+	buf[offset - 1] =3D '\n';
+
+	return offset;
+}
+static DEVICE_ATTR_RO(tx_indirection_table);
+
+static ssize_t rx_indirection_table_show(struct device *dev,
+					 struct device_attribute *dev_attr,
+					 char *buf)
+{
+	struct net_device *ndev =3D to_net_dev(dev);
+	struct net_device_context *ndc =3D netdev_priv(ndev);
+	int i =3D 0;
+	ssize_t offset =3D 0;
+
+	for (i =3D 0; i < ITAB_NUM; i++)
+		offset +=3D sprintf(buf + offset, "%u ", ndc->rx_table[i]);
+	buf[offset - 1] =3D '\n';
+
+	return offset;
+}
+static DEVICE_ATTR_RO(rx_indirection_table);
+
+static struct attribute *netvsc_dev_attrs[] =3D {
+	&dev_attr_tx_indirection_table.attr,
+	&dev_attr_rx_indirection_table.attr,
+	NULL
+};
+
+const struct attribute_group netvsc_dev_group =3D {
+	.name =3D NULL,
+	.attrs =3D netvsc_dev_attrs,
+};
+
 static int netvsc_probe(struct hv_device *dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
@@ -2410,6 +2455,7 @@ static int netvsc_probe(struct hv_device *dev,
=20
 	net->netdev_ops =3D &device_ops;
 	net->ethtool_ops =3D &ethtool_ops;
+	net->sysfs_groups[0] =3D &netvsc_dev_group;
 	SET_NETDEV_DEV(net, &dev->device);
=20
 	/* We always need headroom for rndis header */
--=20
2.25.1
