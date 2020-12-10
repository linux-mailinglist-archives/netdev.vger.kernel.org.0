Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E792D637E
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 18:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392751AbgLJR1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 12:27:05 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17534 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392745AbgLJRRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 12:17:25 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BAHAw9Z016752;
        Thu, 10 Dec 2020 09:15:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=CuiPH2Cz033m/atfVMgfZDTo8M88EX0cJmseDeFxPz4=;
 b=Uu1jOHmZoB0LtKTiG8vznqgueJadaSCTlZBSVrE9SrbmCU8BO/Rofv1mYdtM0YvZvbQ1
 YO1Y+QXOZJBs3A8wQ6lLYxXlqh3Rh1H++b8wxkj/OCrwrr7w8vBSQKhvfcvg5AwDK4Kj
 EoWF52bIhQZs5eQjhwsvysbEU+RutnORPB4Yf3ND1erei1qjwsIxEbbtvRmkzZjYnZIh
 hTnKqVMlqV18K6zZBJMMpIK2EnyVMB//k+7bXDVo2JVur6pV8WPAbYiF3SPuhqigIiCK
 GMIItDXjSEr04swo+1UHYij402VEe1ctr4POURnPZenibv59Nu4uJPP4AtboHSe8qwyt qg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35bhfm9b3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 09:15:33 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Dec
 2020 09:15:32 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Dec
 2020 09:15:32 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 10 Dec 2020 09:15:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fs2RbLM6kjyDYMLb3kbyehZokD+qmEB4VxVjDWeYOG2Hkd0GVJKZqHgugjKRJAhLY4KUuyq8ZmyrsNLEBpdqn8KpmAqp5djZiri6RacCySdWUWOzVvq9Os1vb2OTUzrBgg2FdKFwRIEJJSkEllkUh6o/TLTEpg8yva286FPrg/xGC43jlhEbmf5pzwt2u+TnAnog3yOkNRY994PN/G2mU8ULZzXLxFvai5ku0yAOGerBa7lRu+VUAPxv9aV8lOCHrSAD2P7tCK9rgYmJ2aK2Ov7j0+v9D4/L20UCvoR8jT2pHtOOibrHVKppCL2mq8MwUZtQ3r32mZ7Fch50cogmkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuiPH2Cz033m/atfVMgfZDTo8M88EX0cJmseDeFxPz4=;
 b=PSEq9Q/4ZZU7R/eDctnD+Jhzo1wQWEstBdl1vLRUfpXoziAWMXmt9t7QU4/D/Y8eEC6yOYkoju4cuQmMvU7sNUysMqn0a0p0Ge3Lh6zI1vj+rDyQ3SVbhusWApEPopa1tpK/K+EqkJS8dhhXtqCf2/3EUNIrVHKDpD8gsArV6b93OiZushfqvnfbJgth5yEkNDef3KVQ3gO5YMhiRNBExSR/HuqlJfq1ZGDCJRtsSWcYdhxIYX8hJucrkkMwXb+kcNthUedY0indLPgbxSURRcRbuqo/jB6HNzVb/0RCFcBy9PBvx+2Pn+7fClcka4bkPiD/BHBUZR+dLBQbJqC+6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuiPH2Cz033m/atfVMgfZDTo8M88EX0cJmseDeFxPz4=;
 b=qlwG9Yxl3mI4+Akye518vJKaRpY8opIq1pN7O0ZM10FyX5oOSzK+T8w7znU1V5J7Vr0HsndHgbH55tGc+6p1UZYuhQ5uv77eey82iPkRypqgIimivCyNxke/1gpVts4MvoXrWMo+eJvu7bYYgSjkcc1RerrYbRFxJNt/HyJielc=
Received: from PH0PR18MB3845.namprd18.prod.outlook.com (2603:10b6:510:27::11)
 by PH0PR18MB3864.namprd18.prod.outlook.com (2603:10b6:510:26::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:15:30 +0000
Received: from PH0PR18MB3845.namprd18.prod.outlook.com
 ([fe80::cd9b:85b8:cef5:e543]) by PH0PR18MB3845.namprd18.prod.outlook.com
 ([fe80::cd9b:85b8:cef5:e543%7]) with mapi id 15.20.3654.013; Thu, 10 Dec 2020
 17:15:30 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Boris Pismenny <borisp@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>, "hch@lst.de" <hch@lst.de>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "edumazet@google.com" <edumazet@google.com>
CC:     Yoray Zack <yorayz@mellanox.com>,
        "yorayz@nvidia.com" <yorayz@nvidia.com>,
        "boris.pismenny@gmail.com" <boris.pismenny@gmail.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        "benishay@nvidia.com" <benishay@nvidia.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "ogerlitz@nvidia.com" <ogerlitz@nvidia.com>,
        "Ariel Elior" <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: RE: [PATCH v1 net-next 05/15] nvme-tcp: Add DDP offload control path
Thread-Topic: [PATCH v1 net-next 05/15] nvme-tcp: Add DDP offload control path
Thread-Index: AQHWzN1HG/NZMJlMnEO6aRrtWts3nKnwjXFQ
Date:   Thu, 10 Dec 2020 17:15:30 +0000
Message-ID: <PH0PR18MB3845486FF240614CA08E7B4CCCCB0@PH0PR18MB3845.namprd18.prod.outlook.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-6-borisp@mellanox.com>
In-Reply-To: <20201207210649.19194-6-borisp@mellanox.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [79.182.80.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b541bdc-543b-40e6-2ec8-08d89d2f327c
x-ms-traffictypediagnostic: PH0PR18MB3864:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR18MB38643CD1625087DEAEDCB7DECCCB0@PH0PR18MB3864.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZpUESW5xq3jzolYp1RU+uzqlSPL+RByTXeqpfvJ33tzh/SvqiHSoYJ65dz+Bui4PZZg3tk48/CPVMlz2b3NlcywyW6MXy+H9iWCQEDYsxFDZuoXcBxbDuj48gr/iV3R18O+am72nPU5aqN7Qj93rdg22kuNXJSIgdVF4z5KkLHNfkPurw74zi2tNSYCNu3Y6RIskie1k/vPxCbEWFThUvSiUPpj0uKOteT76cVz4BKIsiBf38F20L/f1XOQt+14DhQwhH3TJcZxX8hqomc54i8ipJuJ9OOY9DiaCEpTGcb9aWiubRWwA7v0NptCD0huCHLLe0/H7GUtX5TKhcyW+HefordIyas3sU3DfHOMQQd+IT+tVr77vpq+vOqEuF3o3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB3845.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(4744005)(508600001)(26005)(5660300002)(54906003)(33656002)(110136005)(186003)(71200400001)(7416002)(921005)(7696005)(9686003)(86362001)(66476007)(2906002)(64756008)(66556008)(55016002)(66946007)(4326008)(66446008)(8676002)(6506007)(52536014)(76116006)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?grxxmBagXy4Lmp9iz/GdcqY48HuPEfDMOm/U663/jh+wxSdNvQ5/DUXlkHmG?=
 =?us-ascii?Q?tt21X0G0mtDJ7OqOOSvVHUCrBMPs/QNYmSHgy8BbzZwgeCnaxjdvWJP0cRpS?=
 =?us-ascii?Q?AlKXMEgzBxlfo3Bul17JecYK+QzmhGVlp5z9A9RCRH77qyMSlu7Xuw5xy/J/?=
 =?us-ascii?Q?VldhYYMz6fWg/7mbBn9jDoVLIJAgPdwRvn5Pfv3CKyQomkfsXoyxHhVoibG1?=
 =?us-ascii?Q?iq405Ttwth5ThNg/UJ0vYDePoWQH4IVoVjvA6vPN21Oho4tJAGFhSLsom6BI?=
 =?us-ascii?Q?sD3MGKU1NuH1qnNEq7i+EW8enbOl34zSWEMEq+LNhSv8H9GW+rOYxPpoM+7S?=
 =?us-ascii?Q?HuwhhfovdCCR7WhMh17EQUzbqY1ZeuKg99OtrIF9LScNG4kUgRuDyrtYZ3rB?=
 =?us-ascii?Q?t75dXkRTYMFbJ4hCTNCZZ4rhkAh6FeYduZtNm4ouaFaSwD1tSRPeWWz0aIK7?=
 =?us-ascii?Q?5Xa6U+dHb5kKPKBuVzO9B8hYsKpuoYFcmiLhO969cmzoSKEz/p06yX/vTbnZ?=
 =?us-ascii?Q?9sspOjv3teUM1m0HynRQXDE4OJitYkx/b/9GnFphQfezAUR+G5AXKoBbBrQi?=
 =?us-ascii?Q?m5uBDayonbiheyrsU6OS7JgC9M8rGO73WbwguZDoVNsy3nPKeiUryqDVC7mU?=
 =?us-ascii?Q?lNejD5OHA+Qjm46TL0qT3FuIfbHkRMXQE9U8YZ89qqFJjhH30ZCoM5r8LnSb?=
 =?us-ascii?Q?T119mjrM4mecfI0QFtjQzak4DexTOSA6ZX6+K+h0UfuvmEaF3CV9/QX83T4S?=
 =?us-ascii?Q?WCgayRpTgg6q+sJQJmCdDB4t0/TEDNiH7w6oADzpzHa1vmZp/XfUhcXsFjXb?=
 =?us-ascii?Q?rYAMvZxZdx77Yjtqje7KKFrvuZgXkNxH1MefCFG8YPWCgMs06W6AUfPIUILm?=
 =?us-ascii?Q?M+VHcwGwaMP1pRbKSvB6ig+QmSexrsA48CZ9IFUSHD3nCgXfYqu7dAQ8VZVj?=
 =?us-ascii?Q?rcSZBaNoG9eZjzcr8pHKR6AFpyOfk9LzN65I2ATQigs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB3845.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b541bdc-543b-40e6-2ec8-08d89d2f327c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2020 17:15:30.7414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cPl0zE4Ivbhp9NW9OocJIxy2cmPVbYV+DVMrlxkBLf+3VRqIEUNPEfDUxmsMVbgn8bOQcTqt7DZm+bxVXbZvdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB3864
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_06:2020-12-09,2020-12-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c index c0c333=
20fe65..ef96e4a02bbd 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -14,6 +14,7 @@
 #include <linux/blk-mq.h>
 #include <crypto/hash.h>
 #include <net/busy_poll.h>
+#include <net/tcp_ddp.h>
=20
 #include "nvme.h"
 #include "fabrics.h"
@@ -62,6 +63,7 @@ enum nvme_tcp_queue_flags {
 	NVME_TCP_Q_ALLOCATED	=3D 0,
 	NVME_TCP_Q_LIVE		=3D 1,
 	NVME_TCP_Q_POLLING	=3D 2,
+	NVME_TCP_Q_OFFLOADS     =3D 3,
 };

The same comment from the previous version - we are concerned that perhaps=
=20
the generic term "offload" for both the transport type (for the Marvell wor=
k)=20
and for the DDP and CRC offload queue (for the Mellanox work) may be=20
misleading and confusing to developers and to users.

As suggested by Sagi, we can call this NVME_TCP_Q_DDP.=20
