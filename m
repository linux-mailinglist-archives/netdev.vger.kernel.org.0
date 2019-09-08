Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBC9ACC6A
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 13:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfIHLZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 07:25:40 -0400
Received: from mail-eopbgr70084.outbound.protection.outlook.com ([40.107.7.84]:23875
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728608AbfIHLZk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Sep 2019 07:25:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVtVaU28oN6x3sUr6vnxs0i//4joxBjZbWOkEAUGpev8G7fnzBQir7yCih0/Yzy2yL71lSJ02AAv9nNj2M9kqbf4Mxo2OCTM8f8dON/R4TRTK5Qi2vlJhl6ROqgqJhP7cQYgBm8S7xiEwADfuJ6nO+PO2O/oe2hnuSe7YuTOfNFFOtH/5taAY0+cjgE5l1GEpdMTsfJyHs+kMzqLfrAb494WbxBIBYlU3UsIYI+0qMKV9+Z8913pdrzeQSzp2GXknXN4Zyb+xC3X2aR7l6H2K4bJgOp5vQGtWvZUgil4obb+oQj9Tq0sZeoCLVje+knvWUtS6y4AnoGmY8oZ7/5fZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/P7nGd5wtEHPUBRHt7ayL+g5GL7/AUq2ISgpyKmZXg=;
 b=FnBVVzNszMgUILxdOzZcIgud+8t6EWAkBkiQwyq5LXmyrs8C9Yd1m1AdGF/g8iMKnycaurKVNNqPzDu9LrI72lxjtWTtGJ8wXSJ12slq0L7dk2D/2AkoQqWsjAdx6V5YLp9KSFd6zHvNzIQ2HPFD3RyvzeNIGCREtg6ZvzuhDw5EdeLK/A2hlrVjmA9ljQtI5Kkdl+C41PLKyd6WSHynyOnxYie0BvG0oSW2T11SwuAteUdcHr9YpaZ9OuIGaC7pFIqSIU7u8ow67W9mu6s6GzuNMsmPEbgw3ztvkgOZy1+29VnJuGO4CnN1+9P+so5vc7VFHMVi6ZLivLWdqklSqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/P7nGd5wtEHPUBRHt7ayL+g5GL7/AUq2ISgpyKmZXg=;
 b=R4GIluAD+hbFwUKKPZGFfM7ZZG6G+hizI6Hyi4aSj7iAIRXiPOelqSPTE8WfoA+psT/picbXha3Wirf0VZJfUgWDDCl23aWWykzfFST7yEMxfkHKm+HidCa+yTYZNk0tOq1FTAJymimB2VEHwHp73bRcrpxxx/xDpp4HPw9SQik=
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com (20.178.41.21) by
 DB7PR05MB4889.eurprd05.prod.outlook.com (20.176.235.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.16; Sun, 8 Sep 2019 11:25:36 +0000
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::fb:7161:ff28:1b3b]) by DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::fb:7161:ff28:1b3b%5]) with mapi id 15.20.2241.018; Sun, 8 Sep 2019
 11:25:36 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Tariq Toukan <tariqt@mellanox.com>, mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next v2 3/3] net: devlink: move reload fail indication
 to devlink core and expose to user
Thread-Topic: [patch net-next v2 3/3] net: devlink: move reload fail
 indication to devlink core and expose to user
Thread-Index: AQHVZjHHXlSzXvqvdEOU1kYu1RnBdKcho98A
Date:   Sun, 8 Sep 2019 11:25:36 +0000
Message-ID: <20190908112534.GA27998@splinter>
References: <20190907205400.14589-1-jiri@resnulli.us>
 <20190907205400.14589-4-jiri@resnulli.us>
In-Reply-To: <20190907205400.14589-4-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0102CA0039.eurprd01.prod.exchangelabs.com
 (2603:10a6:208::16) To DB7PR05MB5338.eurprd05.prod.outlook.com
 (2603:10a6:10:64::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4adea950-3e11-4100-9293-08d7344f452a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR05MB4889;
x-ms-traffictypediagnostic: DB7PR05MB4889:|DB7PR05MB4889:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR05MB48896ED3EF358B74DB5CFD92BFB40@DB7PR05MB4889.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0154C61618
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(199004)(189003)(476003)(66066001)(7736002)(33656002)(6506007)(8936002)(6916009)(86362001)(186003)(3846002)(6116002)(81156014)(81166006)(8676002)(478600001)(256004)(2906002)(305945005)(386003)(14454004)(102836004)(54906003)(6486002)(5660300002)(1076003)(25786009)(107886003)(6246003)(229853002)(66946007)(66476007)(4326008)(64756008)(66556008)(66446008)(71190400001)(71200400001)(26005)(316002)(6512007)(9686003)(558084003)(11346002)(76176011)(6436002)(446003)(99286004)(33716001)(52116002)(486006)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB4889;H:DB7PR05MB5338.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: mhM491ePU4C0jP81+3Ko9iM8VHRFSQmnRcr9nQe58i1re2dygQsSW9Jmu2bpygV3jLqQi3Y8LETX0S4MdSSdP9YJdjU2gjX7UYFKnN0TJbPKVY11W7ZFUWiO7v5IKhwJeUJPjHhPK0+kLE4FG0D/OtMNiGufrcc0b2bSxQGy/WnVIb8pVC4EvqGKL0nxVxOzzQZNx+E6hwLvicX6bxWVYL+lpgD33AYXvmTRLVnMcU0xdEE3fyNDOq10ULpPtIKl+cgE2ikicpDnh9oZXJSlSVGjHdTi1Pfq0alyrJFjcWWrIEGFSq8eyjUjyPWNucJfcTbQQUwbdSR9TxOrvmudTqT+VRl2FYZstzm4a6nM+CCiE350cmC32tNxMEpzPLkwYXt0Oj6J7hK3Sg+vYk5r+fG+L2tth0k6ag82RD8qQoY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C786AE329D012D4285C00B7D961B0612@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4adea950-3e11-4100-9293-08d7344f452a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2019 11:25:36.5752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: haBP5YvDCEXU6BlMfOHNWcpVOOWWYQpiOEOT5ZlHy82voXfuXEvdtCLVM5EFmLaTeshXPltjxmxuO2Lh8Pb6cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4889
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 07, 2019 at 10:54:00PM +0200, Jiri Pirko wrote:
> +bool devlink_is_reload_failed(struct devlink *devlink)

Forgot to mention that this can be 'const'

> +{
> +	return devlink->reload_failed;
> +}
> +EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
