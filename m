Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52A25F8AF
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfGDM73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:59:29 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:43808 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726964AbfGDM73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 08:59:29 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4A663C0092;
        Thu,  4 Jul 2019 12:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562245168; bh=Yedl3Kehi4ZjU1SqExmNv9TW3SsQy4LZ1kgqHaYqmpE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=XYst7cK75RhtzzhSuF5SJ6bvqSVzx8NbPqp0L0kIR6UfUL1ybfFtPhpcke6Z0X58G
         nC6R6gML14FSGhZbrTHtfz5RJAgu+bbf07U6wEFbcpBRoZP+tpMb6xkUAL1QNvyvBL
         7wC3v16HJi/uBiDSQtV2KlrmEac49U/BbGrox9gUa75WMTJdQNdt02dn/7chxrAmmJ
         y25O+PI0fsuYBxLwR9Dw8quyzqvSdDNkfAMvuypf/g9bLQpRrVDOvceDMVVwwYY54m
         sVKNn9pnhZ7iOEmDyaFVV3LT4qDc51J0lFVcFsrKluka2z7DcKriHSNbifv4EiJCIC
         Z+RXwlsQly+2w==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 420D9A023C;
        Thu,  4 Jul 2019 12:59:24 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 4 Jul 2019 05:59:24 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 4 Jul 2019 05:59:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPyqfXY3a9fYZtQe2eaGGDOnS31Zd9aT2Fdbr2m/CbE=;
 b=KiSsUhqh3+nWrhHpb+jH0PszT/PV9OXwQa9d+k21eNfT1Lqr0SjYUMPn2zC0d0Pf35XSyWPv7RNabR1ZTckS7qquGfoZFBUWpL0Y/Jbrna0Nsvbv+bVJIce/XkJcWmxsD6fVc/0ZHakQxz07YTaDKWqJ56Ps8/oDPl8yypVBIEI=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB3077.namprd12.prod.outlook.com (20.178.54.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 4 Jul 2019 12:59:22 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2052.010; Thu, 4 Jul 2019
 12:59:22 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/aa6O3oAgAABAmCAAB7TAIAAAuyAgAAGtdA=
Date:   Thu, 4 Jul 2019 12:59:22 +0000
Message-ID: <BYAPR12MB3269D4FAAC5307A224D60A08D3FA0@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <20190704120018.4523a119@carbon>
 <BN8PR12MB3266BC5322AADFAC49D9BAFAD3FA0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190704135414.0dd5df76@carbon> <20190704120441.GA6866@apalos>
In-Reply-To: <20190704120441.GA6866@apalos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e807869-9fe2-4faa-a818-08d7007f6f75
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR12MB3077;
x-ms-traffictypediagnostic: BYAPR12MB3077:
x-microsoft-antispam-prvs: <BYAPR12MB3077F4DBC190F8A132D194C8D3FA0@BYAPR12MB3077.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(366004)(39860400002)(396003)(199004)(189003)(52536014)(26005)(102836004)(6506007)(446003)(66446008)(64756008)(2906002)(76176011)(7696005)(7736002)(55016002)(74316002)(11346002)(305945005)(110136005)(99286004)(54906003)(476003)(6246003)(25786009)(73956011)(76116006)(4326008)(66556008)(86362001)(66946007)(66476007)(316002)(3846002)(71200400001)(478600001)(66066001)(6116002)(71190400001)(486006)(53936002)(186003)(5660300002)(229853002)(8936002)(7416002)(33656002)(6436002)(68736007)(81156014)(81166006)(9686003)(8676002)(14454004)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB3077;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xrkdGt19J6qW0deTQUSZLHQm2BPRgkTis3u7UVIxLeyL97bSWYW5LNH0gvzjq5c6a5377u+jSKmHmXggZYEDYuexTLrcEVDYWLdAD0ODr78dwJpySJ2jqly1TwEJEVF00F2IFdAkwnsuOnYSVvAp3abHwx6loEWIGvGnm+eboGeX6sciH4gZC8p95rjc3PgWZZU5myINmqq9EXWO2lz6+R7Vo9+Kax2FpftU2/fPyjAeEFaTWPVusKIl+ojD7TEYQknBLosmAPzaS3Utw7HOjI1GJM5hnHjtkUlT4gfm3A2OAlPHmNTO7HybOzYNBpDIEeqANXUCG2p7SIJ61b0gK+oqflZjfIjNshkAUo528S5yCVBDP4rgKG5RFudIzj9l/RbVpQyqc6pfKH9lR4VhlUMIik/MGfxxrPWNaHM6qQk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e807869-9fe2-4faa-a818-08d7007f6f75
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 12:59:22.6083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3077
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you all for your review comments !

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

> That's why i was concerned on what will happen on > 1000b frames and what=
 the
> memory pressure is going to be.=20
> The trade off here is copying vs mapping/unmapping.

Well, the performance numbers I mentioned are for TSO with default MTU=20
(1500) and using iperf3 with zero-copy. Here follows netperf:

---
# netperf -c -C -H 1.2.3.2 -T 7,7 -t TCP_SENDFILE
TCP SENDFILE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 1.2.3.2=20
(1.2.3.2) port 0 AF_INET : demo : cpu bind
Recv   Send    Send                          Utilization       Service=20
Demand
Socket Socket  Message  Elapsed              Send     Recv     Send   =20
Recv
Size   Size    Size     Time     Throughput  local    remote   local  =20
remote
bytes  bytes   bytes    secs.    10^6bits/s  % S      % S      us/KB  =20
us/KB

131072  16384  16384    10.00      9132.37   6.13     11.79    0.440  =20
0.846 =20

---
# netperf -c -C -H 1.2.3.2 -T 7,7 -t TCP_STREAM
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to=20
1.2.3.2 (1.2.3.2) port 0 AF_INET : demo : cpu bind
Recv   Send    Send                          Utilization       Service=20
Demand
Socket Socket  Message  Elapsed              Send     Recv     Send   =20
Recv
Size   Size    Size     Time     Throughput  local    remote   local  =20
remote
bytes  bytes   bytes    secs.    10^6bits/s  % S      % S      us/KB  =20
us/KB

131072  16384  16384    10.01      9041.21   3.20     11.75    0.232  =20
0.852 =20

---
# netperf -c -C -H 1.2.3.2 -T 7,7 -t UDP_STREAM
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to=20
1.2.3.2 (1.2.3.2) port 0 AF_INET : demo : cpu bind
Socket  Message  Elapsed      Messages                   CPU     =20
Service
Size    Size     Time         Okay Errors   Throughput   Util     Demand
bytes   bytes    secs            #      #   10^6bits/sec % SS     us/KB

212992   65507   10.00      114455      0     5997.0     12.55    1.371=20
212992           10.00      114455            5997.0     8.12     0.887

---
# netperf -c -C -H 1.2.3.2 -T 7,7 -t UDP_STREAM -- -m 64
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to=20
1.2.3.2 (1.2.3.2) port 0 AF_INET : demo : cpu bind
Socket  Message  Elapsed      Messages                   CPU     =20
Service
Size    Size     Time         Okay Errors   Throughput   Util     Demand
bytes   bytes    secs            #      #   10^6bits/sec % SS     us/KB

212992      64   10.00     4013480      0      205.4     12.51    39.918
212992           10.00     4013480             205.4     7.99     25.482

---
# netperf -c -C -H 1.2.3.2 -T 7,7 -t UDP_STREAM -- -m 128
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to=20
1.2.3.2 (1.2.3.2) port 0 AF_INET : demo : cpu bind
Socket  Message  Elapsed      Messages                   CPU     =20
Service
Size    Size     Time         Okay Errors   Throughput   Util     Demand
bytes   bytes    secs            #      #   10^6bits/sec % SS     us/KB

212992     128   10.00     3950480      0      404.4     12.50    20.255
212992           10.00     3950442             404.4     7.70     12.485

---
# netperf -c -C -H 1.2.3.2 -T 7,7 -t UDP_STREAM -- -m 1024
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to=20
1.2.3.2 (1.2.3.2) port 0 AF_INET : demo : cpu bind
Socket  Message  Elapsed      Messages                   CPU     =20
Service
Size    Size     Time         Okay Errors   Throughput   Util     Demand
bytes   bytes    secs            #      #   10^6bits/sec % SS     us/KB

212992    1024   10.00     3466506      0     2838.8     12.50    2.886=20
212992           10.00     3466506            2838.8     7.39     1.707
