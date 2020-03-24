Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB34019066D
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 08:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgCXHjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 03:39:10 -0400
Received: from mail-eopbgr20055.outbound.protection.outlook.com ([40.107.2.55]:13330
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725905AbgCXHjJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 03:39:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFiPtf/Ik0Uab209wRs9TNXPk/0caTNXV08J7cgKZ1D/AtpgGDxtAF45lXWMUq7WIUYOQEsFr6McDJg/uN0buR931y3A/aQSUE4j4mdyKS5g4NS7gXeRz52Daw31aGbvosFwm8kCKyL/yKDdVmVp/qupCpRFRDcZwb888oaWK41+HQJ8nUSElso7btmDV48xEQGJIwGq5WsYjC3woTcv5heiNIeqTkwTbhbcFHiT8OPdu8WwcTgu6gEmwC5TH4E8jkeARwJQ1KQKh4pkHKcR+4jBgOgjNV9cSn35uf2FDe7XgkJ55+VFqTLTo8jSCVlmdMQacXDRwbQjSXZyivYJlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGdWZE/Yhq8KgB7W2YYJEZVWN3FEmtsYGWOh3la8m1s=;
 b=fOy9GYaWEm3Tzp1g/w3+vMZExeDmHCsrz0ZNiWuOgZZH3n1hPkbRJ6KtHe+PptAiG0o5mReAWdRjUqsmI/rXZdnofnrM+SMknngN05rAdPh/SvK9MaiDLL+TBUjHQ8WJbUuDyFB1hjbKJ2LHi8SZ9chyJqxEBEpCmOV6v0TVog6QKIQkGFuiYOCYBCcXgI7owsskRzsRHmcjwvWuDvz189Hb7qBZk89jeUnssMHYmbCnlLjT6ha6+OHzwFXYsBStacOulCyzL0g1ZMCrWcE0Rw/KdWZhrSvp8kt4+GQpGiwiXxqBXMFZpN2jrMIJzEVy9STrbW86e1+skvoku0YDww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGdWZE/Yhq8KgB7W2YYJEZVWN3FEmtsYGWOh3la8m1s=;
 b=rnE0p+rlwI4Bqudu6DtPpf+p+WJlOv+K/M2zjgmtUjeFxin5rbWlOTP5F3I+NSvYg6V9SPqSxhgWKf+NKynu824E4pRnoOE3fEbfInoScHkWaRol4zIzkSM5oZES6rrRkVUKJwXPe/HUWJdWAdrtVAgwPh6oVRyxFoZh4ORXguo=
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com (10.186.130.77) by
 AM0PR04MB6531.eurprd04.prod.outlook.com (20.179.255.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Tue, 24 Mar 2020 07:39:06 +0000
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::59c3:fa42:854b:aeb3]) by AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::59c3:fa42:854b:aeb3%6]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 07:39:06 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>, "Y.b. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/4] net: dsa: sja1105: unconditionally set
 DESTMETA and SRCMETA in AVB table
Thread-Topic: [PATCH net-next 1/4] net: dsa: sja1105: unconditionally set
 DESTMETA and SRCMETA in AVB table
Thread-Index: AdYBrop+1lRTlBolRoSr1CbZBSmlGA==
Date:   Tue, 24 Mar 2020 07:39:06 +0000
Message-ID: <AM0PR04MB7041125938BF9A9225B5A8B286F10@AM0PR04MB7041.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-originating-ip: [95.116.58.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 932f2bb5-b281-4534-e8e9-08d7cfc66ed0
x-ms-traffictypediagnostic: AM0PR04MB6531:|AM0PR04MB6531:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB65310AC584A9CED9A0D201D686F10@AM0PR04MB6531.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 03524FBD26
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(186003)(7696005)(71200400001)(5660300002)(4744005)(4326008)(6506007)(54906003)(110136005)(478600001)(8676002)(52536014)(26005)(81166006)(8936002)(86362001)(81156014)(316002)(44832011)(55016002)(9686003)(64756008)(66556008)(66476007)(66446008)(76116006)(66946007)(2906002)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6531;H:AM0PR04MB7041.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ziHV76rm8dUNmfN6on2+skTJtRjWHfYFERJI2WZNVCymaoi+QfQqBhNiRSIm1zcT0NxuHu50zN2/D41fNKGN86n+t5W7qgNHW8KOPGonk7puEW0oE2CKD2jVKc2biRXuQy7oJF5QgXPuF6iwKIHld4ZC+58PRq9SIaaVADlWFH9eS2bp2R74rHo0QG4cl2cAJLv7IZjvxRrTei5wmFL3Yr2hqq4V6WpkkOI6RPWyaHAi8nPEZmbcwB0DkVKboKTgHzv4G1vBbrUrqYABTZ8KBKuWJRaJPIAfk0zwNNWS/RPibVyQj/Kkc7ff5FdD9Ka1NUo6JEkNiAbP5woXVQGenx/xgoQjULtheIvcRZEGGlEanVMM4IXpeR4H+XSQ192RuvfYh4hS58uEEMqS7NFvfH/zHAqDtE2CKPKjCNY2ahiXg5o2Sa/oa5ygepniSzf
x-ms-exchange-antispam-messagedata: ImbC1fKAeIbP4rIzgGdjMM+b4JzvSq0gb908Y5l1KcoIC8fIMrV1p/R4DMowSmJvEA/KBRd91MPSMAE9I7Ekl/apELK13KhbXNVjlVRVNVOfzWlwrPXS430359epAvcaH5nOcG9BoUnhV2tR2inG2Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932f2bb5-b281-4534-e8e9-08d7cfc66ed0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2020 07:39:06.5316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: avWExCW8W4tYBIfFgXQWno4Ke5mHmfdUNbcJrkWT5AALicXfLpem5+VMitPnGFKnEU9lTZWyvIR4S0HhJ9WUJUJQPjG84YVE2R0K0cUKFq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6531
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>+static int sja1105_init_avb_params(struct sja1105_private *priv)
>+{
>+       struct sja1105_avb_params_entry *avb;
>+       struct sja1105_table *table;
>+
>+       table =3D &priv->static_config.tables[BLK_IDX_AVB_PARAMS];
>+
>+       /* Discard previous AVB Parameters Table */
>+       if (table->entry_count) {
>+               kfree(table->entries);
>+               table->entry_count =3D 0;
>+       }
>+
>+       table->entries =3D kcalloc(SJA1105_MAX_AVB_PARAMS_COUNT,
>+                                table->ops->unpacked_entry_size, GFP_KERN=
EL);
>+       if (!table->entries)
>+               return -ENOMEM;
>+
>+       table->entry_count =3D SJA1105_MAX_AVB_PARAMS_COUNT;
>+
>+       avb =3D table->entries;
>+
>+       /* Configure the MAC addresses for meta frames */
>+       avb->destmeta =3D SJA1105_META_DMAC;
>+       avb->srcmeta  =3D SJA1105_META_SMAC;
>+
>+       return 0;
>+}
>+
=20
Would it be possible to use the MAC address of the connected eth as destina=
tion? This is nicer also when going over multiple cascaded switches.

Christian
