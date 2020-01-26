Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFEA2149A48
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 11:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387397AbgAZKzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 05:55:03 -0500
Received: from mail-db8eur05on2078.outbound.protection.outlook.com ([40.107.20.78]:6019
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726571AbgAZKzC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 05:55:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTerZQxEsgFGaQV2d6HLzKqTcLAau3JqgSTmfprOvVEqK8bi1H75aIjIOhhXt4JhesoctBkyOvF/YHs69pfi6SYXa4updm/YnPTl/XXcyvAlCCmeqOaCj9aNY3d3jIgk95n5/hutLq6W1geIixL0BMcX8Y8JQkVwhjPth1ygvnHmi1pzCY9U8jwJXeQpWQ0RJIkfeURmKA3KeDv1I3WdD4gw/DkV3chtvgYiXQeXgoZRDbbHteSLIf1/JHeClYzNUAGw6QLkywlosZ0k/SNetyq0o+vUILxtodJaoZ/wrP68lJG1+Ocdta7NnSBtA+wpaGX2AzTNPMhEny5xJ8EskQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=du9Se3mNGKn8zFfACKpBkm6Hj3jFpm5B+80LOkhmx44=;
 b=UffuHek1pEGWeA4kDsHh9ESJ1loMWsuRJDtkMIjqMGOH07v75hZbC/Xh1HqMMiP/o+mgb8hTOzW3yI1HbUtyS71hZmxu1NZKYr30vq3ulozode8/juoQo+AKSY5NwFxJdc4yKKgxn0kzLrF9MF+vtRRknzrJ+WmPpyPGAUain6qXJ8PIADGbhOUW7VYbAp4HkijZibl2vd8muUPgH4G5C6VVhh0U8+P3t2v3I9q2FyB0+3o4YDAxcAGiCMgaACgAdC6mVnHwZnSOuAAWkRio9ItgQPy4UlpJgNqR+fIuUrgNAd3S5OiPoFzLesir+FRZTbWiIaMT+7HnL7LItvdObQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=du9Se3mNGKn8zFfACKpBkm6Hj3jFpm5B+80LOkhmx44=;
 b=hJJvJ5r80zGxHyRCGAdgHfine5yCtAHPfa6SwuEYOi658w75G6zlNLf4ApW/lx8+AqMVJCv/X1UWUmsg1ISPRwuIUaaHWpRR0KhEETEJoXopUeyxoQBoCInRut9jiGog+oQAQ0SFGKDqjaZhR64vFpxkuaWypx3FMoChiyKWw3w=
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB6581.eurprd05.prod.outlook.com (20.179.18.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Sun, 26 Jan 2020 10:54:59 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::d1:c74b:50e8:adba]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::d1:c74b:50e8:adba%5]) with mapi id 15.20.2665.017; Sun, 26 Jan 2020
 10:54:59 +0000
Received: from localhost (193.47.165.251) by FRYP281CA0012.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Sun, 26 Jan 2020 10:54:59 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2] net/core: Replace driver version to be
 kernel version
Thread-Topic: [PATCH rdma-next v2] net/core: Replace driver version to be
 kernel version
Thread-Index: AQHV1C+XjqDWoSyFQEi464MSnBcsQqf8xbmA
Date:   Sun, 26 Jan 2020 10:54:59 +0000
Message-ID: <20200126105457.GF2993@unreal>
References: <20200126100124.86014-1-leon@kernel.org>
In-Reply-To: <20200126100124.86014-1-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FRYP281CA0012.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::22)
 To AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 79aa52f6-ff96-4af4-a19e-08d7a24e3015
x-ms-traffictypediagnostic: AM6PR05MB6581:
x-microsoft-antispam-prvs: <AM6PR05MB6581B55B57AF7F80CBFA60C6B0080@AM6PR05MB6581.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02945962BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(54906003)(110136005)(316002)(9686003)(6496006)(66946007)(66556008)(66446008)(71200400001)(558084003)(6486002)(66476007)(86362001)(64756008)(956004)(26005)(52116002)(8676002)(81156014)(81166006)(5660300002)(8936002)(33656002)(33716001)(2906002)(16526019)(4326008)(186003)(1076003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6581;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LfrXbkzWb7zdYnZx7DkJ7j6kPPa4JD+YIyffz/9YhNFUCkW1Vn9GrfPds5+uZVlQ7a3+E+GGhJlfAC3QtzWvnUWOF/W+NPZVUYmwH3j34w9EJYo3gqG51BbkB1VoaeL/vxH8G2ACXPditjUJBlmkiRZjpPe7l0gqAHZXGY1zpdnU4TMBYzFBlEg06CLUgiGyUhkOzgnh+tLTWR5nLDYMEcznJJcBGBYVMTxQWdBuRd2HF75YyPvrWd5p66siPL+Y7YNkb3drEsLPw0xDBz1OOyv0qXSNv1vHegVkR6u4f2Q0mXB8+YQtHnJh/bQoojX3XA7BYrsQtcf5bcZiWc/r9xE10N9rEd9E+fyLwFdzDG8o1bXOn29pdDp7SO0LkfdSxIkBodlMlbwMleTPOBHPNysXROISju7WZ5Lhnfx8QBOod/Y2qneddH+TODFcTIPu
x-ms-exchange-antispam-messagedata: ii5piL+v+CSH6fqiZqgjxdZiftJRJewP9FoOUgl5/sFBvvLM5YS0OtuLE9Wg7h213C7a7yySozGScVW803x681GzLzFuC7+RVDfK1IPtCmnetTwJdz4Cc2i/h0+9sM/iz1MX6ZDy2+ZNevyYb2LDTg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A6FF9432045E0543B3ED22CDCF28A963@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79aa52f6-ff96-4af4-a19e-08d7a24e3015
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2020 10:54:59.5086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LUBVsYX6IF84vvA9jQcLWfA2IBHoh7jIfgdS3sVXf081BYg6XdDSmK6yAo+JLKoE2S7dQt79yAABkQ+WPozdqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6581
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 12:01:24PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>

Sorry, I used wrong target branch in the subject.
Thanks
