Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8AE4BB804
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbiBRL10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:27:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiBRL1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:27:24 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70118.outbound.protection.outlook.com [40.107.7.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DD3CA0D7;
        Fri, 18 Feb 2022 03:27:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkjetbIJg5YWlRySiwBUuiCnWkgNIPVV+sZsVtzVWH+QkYRohD17pLWE1zI3oGXDNBY8vmBQmTqAc7TsNBP7K3dpmoFpiIwMVaElDNs0M0PQF3MDwlWR1wMfnIXFjlRSaWG2H7AG27rN/NognoS3Lt1/okNS2UuiuCNpQA0dpgHcSdCcKEaUpdNFT1uamE4rnn21O4siEF5gE6Fv3db7I3OcUiLPJxdRiMqxK39bht/OG31hwHokCLQ2cuopG/G1KE5/Tl67TpbnScaHR1EbSneWxshJQT00ctz2acz0iCWSJk7z+mUPlR8R/fkvF6hTp6U5reyg5AO5PR2f4b+rJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9jJC7RScKoGEMEcpkjWU6lljhRRT8Jlhyp5cAhaSdE=;
 b=ccozQwevWnqDYZsEuut7NozbO1JM0yB2MQAzzU/EHVvEx5tYpIDnnmR7UwHiQa4d+eP6UjPfLrIbKusgOfShf1g7yx1V/PaSAtQTPYLQgCMViv0XOATNefnNQqg4jODFH6amClPkR3DayyiMBNDZkDkMMGjhO75EdRAocQCBVp7KFbRyxpWKr69f+68R7Uz5hLcgLUkNzyQB6jtRWospnsdXFRKfFnPb/Dn2GC/t+EcrP7JIZFWphPYayQcUvXtuylFeuMJrXuMxRLbS4Vc9KKyCmqFhmzKHkfMmx8oY+OaCVTLY+2OYrCNzl/h7Fs+gAWhav9wPXKCLL5g8VKgftQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=secomea.com; dmarc=pass action=none header.from=secomea.com;
 dkim=pass header.d=secomea.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secomea.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9jJC7RScKoGEMEcpkjWU6lljhRRT8Jlhyp5cAhaSdE=;
 b=dS6RSuO07lbKOWveRr4EVRXkG12kqmr3by3xNRQaMfsHnLQDQxRChKM6I39BtmxjQHr4dZhPQHdc1nCQgT+RanEO3M49p1wnJb8n71j6c8WOjDW5QRSxUqcQSP7CPSRm/67ccNf0y2mCvV5QJ4xGuL+hEGSRi12VUztCkFl3IMY=
Received: from DB7PR08MB3867.eurprd08.prod.outlook.com (2603:10a6:10:7f::13)
 by AM5PR0801MB1730.eurprd08.prod.outlook.com (2603:10a6:203:38::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Fri, 18 Feb
 2022 11:27:01 +0000
Received: from DB7PR08MB3867.eurprd08.prod.outlook.com
 ([fe80::216e:9d9:ffd1:7af1]) by DB7PR08MB3867.eurprd08.prod.outlook.com
 ([fe80::216e:9d9:ffd1:7af1%2]) with mapi id 15.20.4995.023; Fri, 18 Feb 2022
 11:27:01 +0000
From:   =?iso-8859-1?Q?Svenning_S=F8rensen?= <sss@secomea.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: dsa: microchip: fix bridging with more than two member
 ports
Thread-Topic: [PATCH] net: dsa: microchip: fix bridging with more than two
 member ports
Thread-Index: AQHYJLgPhxSH9f0hBUa1fDyr2aWPVA==
Date:   Fri, 18 Feb 2022 11:27:01 +0000
Message-ID: <DB7PR08MB3867F92FD096A79EAD736021B5379@DB7PR08MB3867.eurprd08.prod.outlook.com>
Accept-Language: da-DK, en-US
Content-Language: da-DK
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 0624a94d-7dc6-f106-e598-66f31f6e0770
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=secomea.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6aef47d0-a9f8-4359-6222-08d9f2d1950b
x-ms-traffictypediagnostic: AM5PR0801MB1730:EE_
x-microsoft-antispam-prvs: <AM5PR0801MB17306DC3C3D16355546E784BB5379@AM5PR0801MB1730.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:751;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lw0724BYDM5JPkdq0ohgdoMPVzLaoUsraikCcFYzUp6cjWyOxbcqnqVF6QRunTHWJRd52dLXsnxOiMGwotpZvXYTW78TZ3P1DJqo66Y+yV/sxt/B53jYE6v/lPMwQEjrfRl6yCLQ5MgNXfOeLwzGgcg761u+MJOdegs4Bqgw2hLbiod6fDf21AMtuWBQgQto13yhIiV79KhlShkPvE2xO94hLezUISovevi9u6ytXn9ENBu19ixlozCA9qlnc72YO+qsOJ+XqxLrmmz/ncsSuadw9t7hzdnsJWHBHrZklJD/eY5lCoaVD34m+A0ien8m/F836MIAjQCpQnNcWBdRbHl/mw3sS3WDpwvd6c2xfdCZzfdheSOKcoxmdH6SOEOSR0PFvCp5yj+250XGhQceo43UQngrvF8Epo3rHehrLe71xwip1dyzwIHdQOlpNegxgqPt85dSe8a3zkaQeIust6SNyk548OHXQdZNODKLp2KSYO0cykOs9TxREixA49aNfzNoL6lwZZcFxepI0yzafD92ANkdYXtSUoZ3B4uqnqhkMHVqH9FAPKoB368/HQtF4aBrTBw7bH3k7chIiWsh33aHu/rvSdkJbzTn0Uy7N+D9FNqARsKhFvoLun55Jnj7Byt0xh0WFFxCRGWNFmzYKafg2oAlh5rf3l7iHK65aoOBRxKYXQ/rHzYrukqgVko2uY1XxMTQ4WF8l3wCJHrWpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR08MB3867.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(346002)(366004)(136003)(39840400004)(396003)(376002)(26005)(38070700005)(122000001)(86362001)(66574015)(83380400001)(7416002)(5660300002)(2906002)(186003)(8936002)(110136005)(91956017)(54906003)(52536014)(64756008)(66446008)(66556008)(66946007)(66476007)(8676002)(4326008)(76116006)(7696005)(316002)(71200400001)(9686003)(55016003)(508600001)(33656002)(38100700002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?e/uSDQgtvmSatQi9gQiglah0xxRIql9zitJWTWpPRHgSyRmS75SSMy4n73?=
 =?iso-8859-1?Q?ww5PkAXlw1YW9QVDUXfLV8aY6yzY5AzYoQAT/Iy5tXKxsXOLIHpFuNcSWq?=
 =?iso-8859-1?Q?3qlGDp5tkJftYfOZMAveLqAd3Nav6vd9e6Gb1lYWf7XhgNZruaUnAuAn2W?=
 =?iso-8859-1?Q?yOTDxyqwjomNwyz25XAeXoMkFDoMRGBrUw+Hp+nebSsFPXJanfI2PEL7sw?=
 =?iso-8859-1?Q?52wCb3CtPXTjkIgoOEdCJucNcraZt61/KQvVMR+57RudRZahEHg0E7sEsz?=
 =?iso-8859-1?Q?/muHQPO+LiMwuT0PwXCYorU3ZJFgcXFQqmSf/YGOw7TxcKlY/FRBaKvbOT?=
 =?iso-8859-1?Q?ZNPrNNiLXIyYfhrg8tDoWpUTLCFwwYrnFrnlju29uawfxPpkb7BoutCYsv?=
 =?iso-8859-1?Q?IG1Vd5eyNK6A5TCID2prqFYG254Nys1AgZ4AAHdzbtVt68cguD9qzhPDKD?=
 =?iso-8859-1?Q?vyobaEHGJZWj2R1QyCOm3bcmP9P2ZGPurCCaH9l29Aw4gWu6SzS2xnPKyN?=
 =?iso-8859-1?Q?Vyz3amxYqoXbsaCSy08zOWhr/HRhQTHHRb4ATI0M2/f61Rx6E+2XMvpDP/?=
 =?iso-8859-1?Q?DxhmbZWU2CsWz1ln0+fjgqdsn99Px6FG72bWPX7xnwwgRNk9giULflyEDA?=
 =?iso-8859-1?Q?XWbblDnPdlnlV1pNEhunrb7+iz1QeQOrgc/7NssmjvHuJbgRyC/m1nmxIW?=
 =?iso-8859-1?Q?crY9YXCCrLUQSK/nokmwDNj/fQPKYfGeRXz7e9v3SGk1H2E4hCvlHqZMMd?=
 =?iso-8859-1?Q?Akh9DH/p5prT01k1dM45xEBo8xKudEhcyQNGgeOJLJMvmrJ+qMr0D4v/AT?=
 =?iso-8859-1?Q?8bDzF6L5RSHYG8jxjcvclcneQhur35Jr2/phzF/xz1hpVgsK7IjjyIf61h?=
 =?iso-8859-1?Q?6pDO1ZAt4Kor8VP1fIuiZZGS3IQSywZxhtOpW6/TVy8X/3rYzAHm7QY5hO?=
 =?iso-8859-1?Q?mjaHAEJKPUiBGmMdrIEvAXfgeSQkjTFCZKSkFW3+UnYqrR0mW1LozV4dJ0?=
 =?iso-8859-1?Q?QLdbP7ig/MuFUQ6Pao8t96asS6VuYI27BdYbKMbuMyjZg78WpK9AFetlWM?=
 =?iso-8859-1?Q?unuEqENynsheQYfpstR3aHSMr1JjTHoEc8cx2/jAwKUnUsn31Uxm3SapHn?=
 =?iso-8859-1?Q?1sBUmBXjCKTPK+plGEGKhIUSLyea1K+AJJH674KXVlR920wZRAY+T/LMNL?=
 =?iso-8859-1?Q?roxdYeL6z4IwjlczXcN7iutkQRhQlgrv1UTLUsAVnANwsGtfbml+JahbW5?=
 =?iso-8859-1?Q?C5sPPAk+tI7VWp6mvzTThtgv+8ZRGJ6SsjNzhRNS1IWPsdrIPAL0/Rv4hi?=
 =?iso-8859-1?Q?dddc9hcHI61qxeERZF174/H2EfDwTWe3ABgs3iDeZFURdb4Hmtb0PllEQU?=
 =?iso-8859-1?Q?nu0sPbLnwii9gJNd4agIAZN8NBTAG8fa9YPs/bRkxDYYPIhKkAwc6cH8dp?=
 =?iso-8859-1?Q?7jqfpIXWlG25h73SAqLdpXG+nYsDVw7Z/NQ5yoBcYSf8v/Y9VMu3hMwuTR?=
 =?iso-8859-1?Q?moGb7x40XqKSTA5cbiLiSC4YE9llo/Tc3odynytSoas2HwxvabmRKeQRzE?=
 =?iso-8859-1?Q?lB2VTCtW1+8Ku95UKaJEbi0uUlg/2P5bJJ5+7U1gccwY1vKHtw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: secomea.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR08MB3867.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aef47d0-a9f8-4359-6222-08d9f2d1950b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 11:27:01.1648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 979261ea-5b3f-4cae-9a49-3a7da1f4fb47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OFMeSZ/FKQkIhAbd0r+M18CvYr4pCBPG+IO/fhJCjfGxP8Q0HnNcbsQbc5ZOSjN3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB1730
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")=
=0A=
plugged a packet leak between ports that were members of different bridges.=
=0A=
Unfortunately, this broke another use case, namely that of more than two=0A=
ports that are members of the same bridge.=0A=
=0A=
After that commit, when a port is added to a bridge, hardware bridging=0A=
between other member ports of that bridge will be cleared, preventing=0A=
packet exchange between them.=0A=
=0A=
Fix by ensuring that the Port VLAN Membership bitmap includes any existing=
=0A=
ports in the bridge, not just the port being added.=0A=
=0A=
Fixes: b3612ccdf284 ("net: dsa: microchip: implement multi-bridge support")=
=0A=
Signed-off-by: Svenning S=F8rensen <sss@secomea.com>=0A=
---=0A=
 drivers/net/dsa/microchip/ksz_common.c | 26 +++++++++++++++++++++++---=0A=
 1 file changed, 23 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/micro=
chip/ksz_common.c=0A=
index 55dbda04ea62..243f8ad6d06e 100644=0A=
--- a/drivers/net/dsa/microchip/ksz_common.c=0A=
+++ b/drivers/net/dsa/microchip/ksz_common.c=0A=
@@ -26,7 +26,7 @@ void ksz_update_port_member(struct ksz_device *dev, int p=
ort)=0A=
 	struct dsa_switch *ds =3D dev->ds;=0A=
 	u8 port_member =3D 0, cpu_port;=0A=
 	const struct dsa_port *dp;=0A=
-	int i;=0A=
+	int i, j;=0A=
 =0A=
 	if (!dsa_is_user_port(ds, port))=0A=
 		return;=0A=
@@ -45,13 +45,33 @@ void ksz_update_port_member(struct ksz_device *dev, int=
 port)=0A=
 			continue;=0A=
 		if (!dsa_port_bridge_same(dp, other_dp))=0A=
 			continue;=0A=
+		if (other_p->stp_state !=3D BR_STATE_FORWARDING)=0A=
+			continue;=0A=
 =0A=
-		if (other_p->stp_state =3D=3D BR_STATE_FORWARDING &&=0A=
-		    p->stp_state =3D=3D BR_STATE_FORWARDING) {=0A=
+		if (p->stp_state =3D=3D BR_STATE_FORWARDING) {=0A=
 			val |=3D BIT(port);=0A=
 			port_member |=3D BIT(i);=0A=
 		}=0A=
 =0A=
+		/* Retain port [i]'s relationship to other ports than [port] */=0A=
+		for (j =3D 0; j < ds->num_ports; j++) {=0A=
+			const struct dsa_port *third_dp;=0A=
+			struct ksz_port *third_p;=0A=
+=0A=
+			if (j =3D=3D i)=0A=
+				continue;=0A=
+			if (j =3D=3D port)=0A=
+				continue;=0A=
+			if (!dsa_is_user_port(ds, j))=0A=
+				continue;=0A=
+			third_p =3D &dev->ports[j];=0A=
+			if (third_p->stp_state !=3D BR_STATE_FORWARDING)=0A=
+				continue;=0A=
+			third_dp =3D dsa_to_port(ds, j);=0A=
+			if (dsa_port_bridge_same(other_dp, third_dp))=0A=
+				val |=3D BIT(j);=0A=
+		}=0A=
+=0A=
 		dev->dev_ops->cfg_port_member(dev, i, val | cpu_port);=0A=
 	}=0A=
 =0A=
-- =0A=
2.20.1=0A=
=0A=
