Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C426D09F
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 17:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfGRPAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 11:00:39 -0400
Received: from mail-eopbgr00065.outbound.protection.outlook.com ([40.107.0.65]:19943
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbfGRPAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 11:00:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=APbUZ9t6CULlRuJ1s65wkiPj3doCKy4jUX2w0DVlYuo3RzMhcpT9EKKrwU3izErBdtAkJe28fTKMVmOsHTQZy+OchTn6VkV5xd89tM+oTPqaquSn0Kp7GV2n/gcF3lBsu9t+dCMsbPzpxW7Z2rjNxpBeoJJZ8+VWM90mJm39GrSasT+aYLbP5qngegrirnfG02V1nx6pliMnprNLleMmgzVvF2dmFNYHtafOZ26+U3LxLCiKPp30o1XRwOS83wSu+2gvRw0C/KXUyzB6T0/gNpS//83LYls9jay+9EsrJZN0OhINuzKinS9xqdM77/egJXzetM86Clj3j3yQp0IkJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rmIPaCYGTk1f8WPdVS39y7y7yKiwlpELVsM8Hly+qU=;
 b=e//889kUQpVxb7l34nOyJTkL6IWhJVJ+3MVVJp4+cGVx4x+CHWUoxNdbs4m4TcrHNNbmdVTNCQ3+6Sfknevj6Db4MWGoGjqBY5g9oepmZb8rr416xvXCn8q2W9nQJj2sz+8X/KkAHyzGisRtf4MrZwimWCTQQkVGbW5XE1LRDJufN9G2UeMAJFHzeI3Uh2dt/p23BeT7mS954S4NGY3ZjD5um+h3gDuE9gBPE73qsMTPDrYdwzSHslAw0GwUZXcNDVYlnlqWjrH4gKYf7h3vFyqi55TMRHizjjr2W3qel6S+5XFAQWi7SQVqedk+kiHvBDNMia3WzCdV/r5lEgxOAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rmIPaCYGTk1f8WPdVS39y7y7yKiwlpELVsM8Hly+qU=;
 b=LaDItsgWkyzm6B1u8FUA4m0vwmJpfSW5wxtINv/yy7v5NU6A6cM/Y9QVtWnSssSyBMQH8QgWwM4nopWgyq2QLIwTO7LrOqxk5+ZmdfKYYG54yWUYBCJpp6QAbIsDZxwMORIvu2Lm1nNe2p31jV8IMfOtu61uq65BtqZcdr/aH3g=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3124.eurprd05.prod.outlook.com (10.171.186.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Thu, 18 Jul 2019 15:00:34 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7%4]) with mapi id 15.20.2073.012; Thu, 18 Jul 2019
 15:00:34 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
CC:     Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next iproute2 v2 0/3] net/sched: Introduce tc
 connection tracking
Thread-Topic: [PATCH net-next iproute2 v2 0/3] net/sched: Introduce tc
 connection tracking
Thread-Index: AQHVN8Cy+rBWMx7e50Gn6HHo/QIoc6bQg5MA
Date:   Thu, 18 Jul 2019 15:00:34 +0000
Message-ID: <9286cbad-6821-786a-6882-d2bf56b3cf05@mellanox.com>
References: <1562832867-32347-1-git-send-email-paulb@mellanox.com>
In-Reply-To: <1562832867-32347-1-git-send-email-paulb@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0084.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::24) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a661a41f-a5b1-49be-4c72-08d70b90af57
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3124;
x-ms-traffictypediagnostic: AM4PR05MB3124:
x-microsoft-antispam-prvs: <AM4PR05MB312427D412DFACF16C7A6148CFC80@AM4PR05MB3124.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-forefront-prvs: 01026E1310
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(189003)(199004)(3846002)(86362001)(486006)(2906002)(14454004)(64756008)(8676002)(66476007)(31696002)(6512007)(476003)(446003)(66066001)(110136005)(66946007)(8936002)(25786009)(66556008)(6116002)(2616005)(558084003)(229853002)(6436002)(386003)(54906003)(11346002)(68736007)(52116002)(305945005)(99286004)(36756003)(19618925003)(6486002)(2501003)(76176011)(478600001)(7736002)(31686004)(4270600006)(81166006)(66446008)(81156014)(256004)(6246003)(53936002)(71200400001)(71190400001)(186003)(26005)(4326008)(6506007)(316002)(102836004)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3124;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: blqmckXFa5OPVBl+UU0tJYYsztCkaYj/K6WGVCJvx2i50VN1NdcwxNT+bzOvo0h7rpSYh1ydj5QG+6BjvTfu0Ft9qfIijigraRunvh0z/RxSWT4AbL4myqMMOCDx+8tuFvxjCMaEB1vY0TkOa2lzfDwyIh0ZyhMk9oPm9vOwMB6XtK16gOpQetSyVy8MhLBsFp5D5kHSdPvdV6DGGcEtATa63L2mtzzfdRFnnbRrg5qaggTojBN0W21FHUsbVfcuLJUVDPLcpa+/+B6bZQjhfOQjiXYK6cnED3x3n9ZJzmCGrzNZY5Hug2/EEkm/YWPMEX7/Sw3Rq8tuK9MiroKtNQ5NW62dc7z29s/SbacEheU0cfhWovy5iNHfuv4e9WgYbTH7jOt7LonBfGedJylCo3qBjEQ59c8U7vkILMcVnig=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7230AAB90BDEEC49BBB8616C582E79AC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a661a41f-a5b1-49be-4c72-08d70b90af57
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2019 15:00:34.3993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGV5IGd1eXMsDQoNCmFueSBtb3JlIGNvbW1lbnRzPw0KDQp0aGFua3MsDQoNClBhdWwuDQoNCg0K
