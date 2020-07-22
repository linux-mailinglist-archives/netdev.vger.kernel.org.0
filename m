Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F152299EF
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732465AbgGVOUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:20:02 -0400
Received: from mail-am6eur05on2080.outbound.protection.outlook.com ([40.107.22.80]:64350
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726003AbgGVOUC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 10:20:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgA3CwGKMuJ6vKi9aopN+iz78i4DCR3w98Sobste66xoahDMzKIdwggZmSikSJzwKNULWY5hH92+XjtsXRW5CWv2qkmcdQ+03I0AGj/zpqtuSe9UnXg/MPcUZW3f6DOUmOndKkANl3B/WziZrsrxEPAAAEtdo4vN8VYDpdrNVbpucdw+J23g3x+bGJvFAuRgcWDVuYTawsf4QI+D769Dk0cOMkXdn3aziDfOmEAfnygMPVQnF9WqhQlkdIniIh3Su6oqReJDJ+BaVqUkNiNIki9nrqWEuS5RL0zM/HFOu4hdGggB1AsE0cz99zGX8RIYRglT6NRkqBL/yJIL3GQnbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIPFULo9GIyUvSkYBXr9WeBPEuQ9G2QgnMuPt7LivwE=;
 b=SywIfg8dzTvQD7xcpFCtAVvKwq9KXWqCdHPqDQxQe1ugMCSW9O4lLQ9paZ3fr1C5PzyOIqTSENPRSWUdv/nbCUi+BAZrrp6J8VBR2bYGKasrDzCQWtXZ1XMuhGYUt/OBLnvjB2qQiiNbC6c/Nnl22PlQjB9h5yNbtU0Q+1hcsZJeDvzdepp2HF9kW/24itnNkWcxvLtDpJ3xJ0jnAkJOQtuiNuk3Sxux/u+2Kp+xuizfOhqijE+gK4tQrmgRb7DGQa2JNqHPpa+fZbklzJTjPHWSbDK43JKwnNhmecxXr2E6Q7APEOtZf95N7R9i3lLEYTfqhrVLF0XL8YktQ8/q2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIPFULo9GIyUvSkYBXr9WeBPEuQ9G2QgnMuPt7LivwE=;
 b=Anld91MzA+Zgi0Gsm0CS70qOvAyElMtFhozZ7YEWAiButGvU4slnD0TKnaMjL+0R3OZZO6Y5UiDcosZKD6P6Ehy5LNCHwVcfh73aVLzwpuktg2dinN+C3ytZsbV7mQSwSqUZFzvgm25ILRAZqLEYqVHxBVNwjEUu3QoiBYQ1q3s=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB6084.eurprd04.prod.outlook.com (2603:10a6:208:13e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Wed, 22 Jul
 2020 14:19:59 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::c80:f72:a951:3420]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::c80:f72:a951:3420%5]) with mapi id 15.20.3216.020; Wed, 22 Jul 2020
 14:19:59 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net] enetc: Remove the mdio bus on PF probe bailout
Thread-Topic: [PATCH net] enetc: Remove the mdio bus on PF probe bailout
Thread-Index: AQHWYCT3/fNelXIXFEGWOCjUwapg5KkTpQPg
Date:   Wed, 22 Jul 2020 14:19:59 +0000
Message-ID: <AM0PR04MB6754D12F2A2BA8EDBF6E7C4C96790@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <1595421487-13978-1-git-send-email-claudiu.manoil@nxp.com>
In-Reply-To: <1595421487-13978-1-git-send-email-claudiu.manoil@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.66.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a7d95dc4-1efa-43c0-23dd-08d82e4a5108
x-ms-traffictypediagnostic: AM0PR04MB6084:
x-microsoft-antispam-prvs: <AM0PR04MB6084139C5975D98A3CF5BF5D96790@AM0PR04MB6084.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZAomj5VEJ7amLX0tIcUK/jFyEzdNPXjh7NWX4/Y7BHFTMpzV9O69sJ1pmNT+xS/md8gFPC/E7o435pAQy5vsGbbH2ZQUikxE/lXA4jsTCMMcryUCowRF1/OrQ6/LWKU+LD8eWzjOnR08k0N2TFADkVU2d6+h/ma/Z9PEt00mXWqIN9LyQCL8864KmI66tTlAFRTH3CQOYPyVTkFDyLyGC7gjI6YTRpqPa/8afpNhBld7DtHZR8OnlKrIUbdx5bVXXpTSuEO3rJoMm128VZI/Nuuvk+dV7Xkgx3yvLsB6u58JQ0/on9oZys8xXKDFElZ0xjFvuTOMp4kLckZpALcweg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(33656002)(5660300002)(76116006)(2906002)(478600001)(52536014)(66946007)(66446008)(64756008)(66556008)(66476007)(55016002)(9686003)(6916009)(316002)(7696005)(4744005)(186003)(26005)(6506007)(71200400001)(86362001)(8676002)(83380400001)(8936002)(44832011)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hgYZmV866Eh3s16bvERA6cA9YJdHOAXyHDzxoa1zkPFYBrAkY534zwwQ/SX/iFNfEW0UMzpgp1oz3f61HI279FqyXuNF6saND6cc7b5H9zDGsm8xHA/fdJYwj03P1/Q6/pFb+wSQ1AEf3x1yQJqgnWOObPY4+WJ9LaglUXiWPtph1Y4xxMaXfrDtcD+PeY1fpJAM2J3BzDMt1oUjC0w/FI4+M8Oc74H1Jqh21E5Qyou+IAQCDDp48zbGK3NxDXgBdg7YnmOz3KezQQTpJ6VTDpb7HYuByGGBX3qVGJeEctNwCa3HydLUdfzCD8DZxUI4KWu1AGZ5Q32OaRFqbyfI+m3lQmVapuep4M9YSRlXTFOZbfjLR5J9PVDq84yP4Qe3yJmzoLCz/ghjI/F3S2BGscXyfwlijYt4ofWdCe7sl4iqkE4+YKw2okEcLps1w1fDzv8GVAHFRcMI/31ZgJC4bZOL18jhbuXJl6D5vZPCY+w=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d95dc4-1efa-43c0-23dd-08d82e4a5108
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 14:19:59.3151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AjaI1PnelLRpCV+Igc4HbvHTAHRLpTF4Y1OAJYjLIiA/tAKdEHlMdHAU1WJzL/WVREJ9hHxrpO/90qdPlpuXRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6084
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
>Behalf Of Claudiu Manoil
>Sent: Wednesday, July 22, 2020 3:38 PM
>To: David S . Miller <davem@davemloft.net>
>Cc: netdev@vger.kernel.org
>Subject: [PATCH net] enetc: Remove the mdio bus on PF probe bailout

Please disregard this patch, it was backported from net-next and does not b=
uild on top of net.
Will send v2 shortly. Sorry.
