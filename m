Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CCE475527
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241177AbhLOJ1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:27:35 -0500
Received: from mail-eopbgr50049.outbound.protection.outlook.com ([40.107.5.49]:13538
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230475AbhLOJ1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 04:27:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ypw6uxoJU9qq9VyONJSPaREREHA35e1uiFe8ERty2lnsMuwIPZMepBposauTAQFecQU6t4JTugWaH6Fh4YJ/BTxxU647iHILA6c5N/Q7g4agrmoJAHrR9N6DqZti96X/tNnkFA+hZ2KI3tAWC+6hzPTTsO628PkX3vLAlkqi8e9PgqTIz1J1iriuRXa4FcYQaUQd9YNSvVOeo/0MeOZoeyNl0lUDZUplT5ZdRULpjZpxv/SI0gWKmI9o0qBZysWdLK8CzL8LnC1ONBlIBCeozRO16o/8/kZB51ETY+bbYJ9coQZmJ2T3zOdj0wrvsr+NvS96OoiBTXM2Gg5qj3AC7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RxYJkTvnmzFIV3WLWJYUxZHVDAGxhz4bL19MxeU/nlI=;
 b=DdNTMMz/K9TaV3nIZqxbHjNJZQVSW9pBZTD29mkiCDxhob6Pjuj0pqEyYmnauliKH6u195UdW5YX4BMmNbXd30mw58OZJnyu1c1WuWbNQnKYl7SjbYWyF9Lxrcnltf+x/uRf8ojbuMk8ZOk3mZBJRj38uQXascpAK60ty1dVVrRhSaZ0sMnil1HRi5W6/DodO7nwof2eX2d6quKNEsKRfaoRH4nMPfX4fcQW7gEwnxB+bRug6U2SAVHwf3UdKP/WaXDeyQHbMn4ByXx6E9kjO2qZ7q+BBBz3QXpmmJGkAbyPAaX67nvpZgAHsmZrhENf39UEXU7wurJHeS4VqP7RLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RxYJkTvnmzFIV3WLWJYUxZHVDAGxhz4bL19MxeU/nlI=;
 b=cjwN0HZIagiUKKjoZh9A+qrz5dGZtsmAtSfsmr+XD1M2hqcsxkFuKWY6HBu7BJZchuFwBuzhqqYagaYiGcW0/AhJjUlm8+rk47i5iFgdPuJOIMQorvBEyWd4xy09at7qQJLAkcr1DSA0GnqHOa+v7RYz0wN3bjwh9Q6SjPwgRC4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.18; Wed, 15 Dec
 2021 09:27:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.028; Wed, 15 Dec 2021
 09:27:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Thread-Topic: [PATCH net-next v3 6/6] net: lan966x: Add switchdev support
Thread-Index: AQHX7OGqma9W7JTLPke3A5iwt0gyh6wqKbcAgAA0OYCABd/MgIAAN0eAgAAMLwCAAACdgIAAEJAAgAAP1QCAAFPBAIAAK9+AgADy+YCAAT1mAA==
Date:   Wed, 15 Dec 2021 09:27:31 +0000
Message-ID: <20211215092730.w4ptdsymqgdhtcte@skbuf>
References: <20211209164311.agnofh275znn5t5c@soft-dev3-1.localhost>
 <20211213102529.tzdvekwwngo4zgex@soft-dev3-1.localhost>
 <20211213134319.dp6b3or24pl3p4en@skbuf>
 <20211213142656.tfonhcmmtkelszvf@soft-dev3-1.localhost>
 <20211213142907.7s74smjudcecpgik@skbuf>
 <20211213152824.22odaltycnotozkw@soft-dev3-1.localhost>
 <20211213162504.gc62jvm6csmymtos@skbuf>
 <20211213212450.ldu5budcx7ybe3nb@soft-dev3-1.localhost>
 <20211214000151.xiyserx62zq2wpzh@skbuf>
 <20211214143129.his7l6juatvv3nry@soft-dev3-1.localhost>
In-Reply-To: <20211214143129.his7l6juatvv3nry@soft-dev3-1.localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a585352-f05f-40dc-f428-08d9bfad1ed5
x-ms-traffictypediagnostic: VI1PR0402MB2862:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB28626EE1366B7EA4BD4E51E6E0769@VI1PR0402MB2862.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MbaErPzrEnBlRPJcaNiYispYCWJXfiTPKNJEXvD/oxL+RZjJ1kH38GhvFPfWIsb5HgygN1IXfFw9y8R5g4BnY+ON0+IvYkH7w+UJf1daHGpgTjloe7suK/JhU1FgYsRRHSw97dcIu4MC3L0ZhikmaStimLIUMrIDSrDk5pVgHd2bQDsf5tx4QGMElnQOgXozeodP8/8AQL1m9J45kussrgVJZkgBGfIhuQMtLAnAYWwyxmIxuUzJdcmubEAQi2sZ/uqJKRkERzRL0eCjESeK4tJz1CtQGSjiVAi+9R7DITeNatBV/plTYsH8iLgY/5Eal+pptv92sbx4rjWoRkskMOc8h4/cxa+3FONZxAp7PLhNZb9cyNk+5J43/FDt85ki5iQ4a3aMB7FzkqpLfYe6JhKpAJAq/I0HTQzkgmhsyyuMQVrMxUNVVQgQqor4jSibfGjghR+eWE3Unp2w2TSV36NwXVhIT5Vcu4JDmo6N0GfKJ07qtSDQYpbVgiZUo5Kv7uQizIIL2tEDYl3FOqE8nMqnMWO2SG/VFVDt6Lqu7NipC/P5Ju0l+Rc8Coo5NoOSXCRaE1od4yrEuJt0aoeRPmGQXNJ2tG9WaFOBGmSll419MwvusE3ZNfqK/AcbZ8ugh6rVuBNTEl5IoCkcDef6M5i+WgbwanfaNd/KsBb9i/lqJxRU2jc/BOz50yZvKgOU3BApucitXhwys568pk4gLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(38100700002)(316002)(4326008)(186003)(8676002)(66476007)(6512007)(91956017)(71200400001)(1076003)(83380400001)(26005)(122000001)(44832011)(9686003)(33716001)(4744005)(6486002)(76116006)(66446008)(508600001)(54906003)(38070700005)(6506007)(64756008)(5660300002)(7416002)(6916009)(66946007)(86362001)(66556008)(2906002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LaHFCXGv+9/C91XKmgp6XDVex4bPE3tGaH8IajuCKjWT6UgZyaBZP8qCbPGh?=
 =?us-ascii?Q?GTMmXnMzKLqCaDQMGLYdC2lZjp+oOgles/R0cEw+H7KBTe+Rnt+YLPpZEp8Y?=
 =?us-ascii?Q?YGV49rt3hrJFoXuu84mPnGSo/nM5QvfQOqAofLxqfJSYfKpKmqvtKTJQ39Sn?=
 =?us-ascii?Q?L8sQx8zZr5eckw58IhICJQjEcrnyqB07pcKF65ayvHU38qrJCUBFtIfoDWHP?=
 =?us-ascii?Q?0zKVPs+q38iS7RYCIVegMMor267EZLku9HVbGefL6M/WGoR9JFgWJ7bvMcC3?=
 =?us-ascii?Q?4S1MtOPArXNI9NyY2VJEXLuHrdxjvbNmB1g0lzVIj19/OO+VaZNI6vYV3RSp?=
 =?us-ascii?Q?2pX68mVDVWxhlJUodw67QG/p4btOLueej8xAl24OXA/3Ez0aWknd9ZKMHE5I?=
 =?us-ascii?Q?fINb9oSKcRSXrmGY9Kb/Db+w3KtvEW/a5AJKokouV16Tt7gbCi7oMrwEwSCe?=
 =?us-ascii?Q?COuEJlhaFsHitCh8Qr0aFUUCpbg++R2mpaLJg4gXqYfDurzI+Ftp1zSNa7zZ?=
 =?us-ascii?Q?NAp3/gtcRupudRUSi3agxOYZEUnzgTk4MIlBvPO57aQQv6oPOgj3P4BVC6lf?=
 =?us-ascii?Q?+NP3A6e0Gj0w7QLszVBBYeOEapKCQOlH/tMfK62IGi6STyBYpxPPOGtDHRcc?=
 =?us-ascii?Q?LIZkOObxvjKoP6/oVsVWGMFRR87Eosd6TxK/Oa9u3n5DBSJpMMa+mlVYDKxW?=
 =?us-ascii?Q?2/+wMNTfFOFcu/pS3JE/jc/dz47tzqcdISUhumd5hT7IdiDQvmnbG+uEF33z?=
 =?us-ascii?Q?HHYbuDNjkjGDbwUhdifHQNA+9H/quLMmmTpX5C2wz+ji/DIuJ9484JcCRS4a?=
 =?us-ascii?Q?5D/02DPkgjWFuM0arbL4uduo5tgEFxuIE8UunVhmpswOTeswBLv1KMaVTjJP?=
 =?us-ascii?Q?69Sbym6ZsFhfZoa73SD/vjrOgPm8ot9h5/88daDeFDbjcdk2sSPka0eQRwhs?=
 =?us-ascii?Q?g7D0Xmo0Ufkitrzb1ZVJSAws+lMQuxtK2v7BEyOEwoSe6RYSoUrQjrRWdVyp?=
 =?us-ascii?Q?2lpzaPWtpoLMwx5hycW04SrIusqrj3wdNIKShZeMNcCPa7iLoBoPcF80VUOC?=
 =?us-ascii?Q?P+WlUyz0edwychJ/6T0gb+4/xPi2XNXg4Jtcw/VLlPMe6pxQr8wFoQd1Y2L5?=
 =?us-ascii?Q?tDabT1XdJTh0bYxaRQe1Fex2PTt2P6VWZLIrConEDGba6wxj1reHhm6+sb3u?=
 =?us-ascii?Q?OFT4e84JVmLS9S6VvOknW5iCZ8toRzvzagQP1PIZvmYepmnU1Uf89kq+gl6L?=
 =?us-ascii?Q?bOYUuQYGhIQ3mueqAte7BfZ1g/31AfZLHzbaqq72X+RMB4CIGd0/5tccK3oD?=
 =?us-ascii?Q?KW5ImOxClcACuBu2RsQmlDx7XQT2w6BbL80wXGSuYpap1ExgnuCGnbV3+QZS?=
 =?us-ascii?Q?bokMUjpqYQla26bMxjW7jjMWaxz1VGXG7N6ZFOYn3H5w05wNatVvw+ABlopk?=
 =?us-ascii?Q?SSjkH+7CQP1kK2Q52/E8FPIRV1Adtg64uKZrKYlgm6bT8+sq+JMLk2gAuMh/?=
 =?us-ascii?Q?yoWaQ09k9K4rMW525sY7c0jtO1OFpOBuJPRLSBRCW9IznzEZ8hpxmpvIHNf3?=
 =?us-ascii?Q?7bE8bYFUbjpPyX20vGslCVpBENTToewAVZUpZ0n8+U8uIAgrUht6HT6uJCWl?=
 =?us-ascii?Q?lGcFmTUFhABQXMLvHDtLPdU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4F8DC25BC9077B4A973F01B1F35A2674@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a585352-f05f-40dc-f428-08d9bfad1ed5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 09:27:31.5815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kGyefxuqx2oHo9t5AoobHCWJ9iXYf42bvDY2/JKjT1DVZpn+6fvji7OlJSsN4dKHgV+4iANT3aesWfOb/kKapA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 03:31:29PM +0100, Horatiu Vultur wrote:
> So long story short, I agree with your comments, I can make the
> notifier_block as singleton objects and start to use
> switchdev_handle_port_obj_add and the other variants.
> In this way it should also work "parallel instances of the driver".

To be clear, what I'd like to see for v5 is a set of patterns that is
simple, clean and functional enough that it could be copied by other
drivers - I'd be interested in limiting the VLANs on the CPU ports in
DSA too.=
