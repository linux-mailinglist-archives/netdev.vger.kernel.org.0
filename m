Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452E35D37F
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfGBPvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:51:20 -0400
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:41729
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725922AbfGBPvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 11:51:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brO73ixZOe8DGZmg5e2jQmlH+kevr1g/wfAWOvS3o+o=;
 b=QlSOKQrB5aTAUXnr3tUCMYfLRkhiFq67wi5CVJNPI1zGuhOYB4e+B/AB6K3iRx9Ze58D8kLdnaH/39fEIj2bLtvGft1JwYxU2AABGbHGIG7cC9AIjEsO8K/nzv3kgQhVN45I9CTjyP8ZF79T7L6Rsg60pKaWYtrz/yP+5hhHuwc=
Received: from AM6PR05MB6037.eurprd05.prod.outlook.com (20.179.2.84) by
 AM6PR05MB4197.eurprd05.prod.outlook.com (52.135.161.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Tue, 2 Jul 2019 15:51:17 +0000
Received: from AM6PR05MB6037.eurprd05.prod.outlook.com
 ([fe80::c5b1:6971:9d4b:d5cd]) by AM6PR05MB6037.eurprd05.prod.outlook.com
 ([fe80::c5b1:6971:9d4b:d5cd%7]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 15:51:17 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     Colin Ian King <colin.king@canonical.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mlxsw: spectrum: PTP: Support timestamping on Spectrum-1 -
 potential null ptr dereference
Thread-Topic: mlxsw: spectrum: PTP: Support timestamping on Spectrum-1 -
 potential null ptr dereference
Thread-Index: AQHVMOcY3L7Wjb9apkGPAWlUHGBxiaa3eieA
Date:   Tue, 2 Jul 2019 15:51:17 +0000
Message-ID: <87r278sado.fsf@mellanox.com>
References: <4fb676a6-1de8-8bcf-5f2e-3157827546c8@canonical.com>
In-Reply-To: <4fb676a6-1de8-8bcf-5f2e-3157827546c8@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR10CA0070.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:80::47) To AM6PR05MB6037.eurprd05.prod.outlook.com
 (2603:10a6:20b:aa::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [78.45.160.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 408e183b-4fb7-454b-cea3-08d6ff051e2a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4197;
x-ms-traffictypediagnostic: AM6PR05MB4197:
x-microsoft-antispam-prvs: <AM6PR05MB4197308712FF4EF53E3BFF2CDBF80@AM6PR05MB4197.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(51914003)(199004)(189003)(2906002)(8936002)(52116002)(478600001)(186003)(68736007)(305945005)(2616005)(11346002)(446003)(6246003)(81166006)(6486002)(3846002)(86362001)(6116002)(5660300002)(6436002)(25786009)(8676002)(76176011)(102836004)(256004)(316002)(64756008)(71190400001)(71200400001)(6916009)(229853002)(66066001)(476003)(73956011)(99286004)(386003)(486006)(53936002)(14454004)(66476007)(66446008)(7736002)(54906003)(81156014)(66946007)(66556008)(6512007)(4326008)(36756003)(26005)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4197;H:AM6PR05MB6037.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /xmhY/JQ2JFy1WGjf40O3s61MD44c8F5/5vOPlURdhY/2FWzz0lkaJ2beTokbTh2/VNo9E4lSebxRYokIJFQzkbg8Y1nBEBmKJLK9fl08Qh2jfOEoKMFrjxHXPedF0NzXaM0m2tC2T8nzbyxUEGlVvvV7LjBKhkghZrxGHvNxLSDIHvQRXP1JwLO+tAYY0bxDNQgO5BwrpVuQxVVh+SXweQxsru0iJ9OKSMjZSBbCVuWd+4RJtOzP80vsOIT1B5i1LPPSvkq+RsQTw7O3HzWC9TKKObVRQ0Pgb3BuOxZZTQ6SsX0qYVVX+j7QJdlUV0AEvpdKBxHTChZsa786t9BzCS0FQYaHp2Gj355UZiY1uyW8Y//JDzqRC4agNsvbhijJfYbh3OzV8vKgeYlxBytom6mzIM1iK8vF1XLK/jy5EA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 408e183b-4fb7-454b-cea3-08d6ff051e2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 15:51:17.1501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4197
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Colin Ian King <colin.king@canonical.com> writes:

> Hi,
>
> Static analysis with Coverity on today's linux-next has found a
> potential null pointer dereference bug with the following commit:
>
> commit d92e4e6e33c8b19635be70fb8935b627d2e4f8fe
> Author: Petr Machata <petrm@mellanox.com>
> Date:   Sun Jun 30 09:04:56 2019 +0300
>
>     mlxsw: spectrum: PTP: Support timestamping on Spectrum-1
>
>
> In function: mlxsw_sp1_ptp_packet_finish the offending code is as follows=
:
>
>        /* Between capturing the packet and finishing it, there is a
> window of
>         * opportunity for the originating port to go away (e.g. due to a
>         * split). Also make sure the SKB device reference is still valid.
>         */
>        mlxsw_sp_port =3D mlxsw_sp->ports[local_port];
>        if (!mlxsw_sp_port && (!skb->dev || skb->dev =3D=3D mlxsw_sp_port-=
>dev)) {
>                dev_kfree_skb_any(skb);
>                return;
>        }
>
> If mlxsw_sp_port is null and skb->dev is not-null then the comparison
> "skb->dev =3D=3D mlxsw_sp_port->dev" ends up with a null pointer derefere=
nce.
>
> I think the if statement should be:
>
> if (mlxsw_sp_port && (!skb->dev || skb->dev =3D=3D mlxsw_sp_port->dev))
>
> ..but I'm not 100% sure as I may be missing something a bit more subtle
> here.

Yes, that line is wrong. It's missing a pair of parens, it should be:

        if (!(mlxsw_sp_port && (!skb->dev || skb->dev =3D=3D mlxsw_sp_port-=
>dev))) {

I.e. I need a port && I need the skb->dev to still refer to that port
(or else be NULL). If that doesn't hold, bail out.

Thanks for the report, I'll spin a fix!
