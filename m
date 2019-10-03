Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F446CA86C
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391108AbfJCQ0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 12:26:38 -0400
Received: from mail-eopbgr10073.outbound.protection.outlook.com ([40.107.1.73]:53316
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391081AbfJCQ0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 12:26:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGFBrsHAGEhC8CHhjkMDJsNozNx3CZqtG5PWl9oYecHUMbiDPOtbtKDIoBQVrIDT0X/ty7YxrTGRYTexSEpzFZwSoAQjM3ZgKiXX68bJIGP4rKrG8dJjqdFYtK03Ae+DY4S4Q+FquTsGse5c9vHAsikHPvUshr//2uENnd8X3gqbmPhoZWndO0yyjl6ENYGjiyfNT4W9vFXVGlU6WROa9bXmaXVSiJ9opMNyVZIC45PRJ7FWRCw9wHKTQ+TzQGc+e7ISjgl/ejTf8r9SMgzWRg9bLwCkzAZOnFxa78L/A3Qtcvl47g36L9drq7zx5Qe6dhPcEN73atMm2i1kJVg4sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8m0OgLMXrlnN1S1LWjf5bBgposl1eYuNgcDSK2N504E=;
 b=HHfM940CWKKbZEYRmakGktK5bY7/Cht1z4RU/eGeoFaaYGdVT085rTifWsvNepeTDHxtnT7xqe2y4yTQynmWtFSxjI7CCqV9OhS1oI+VUiArJnXa9vv/7T5b2E+azk8QP/JMaOi72c5PegnAS9pFwImwFz1KAekgr8rvIzSkIDmoqeq6ZXKHr3BtXucmwg4/RigwonnMEieIdwB1Rqn7nRgW+3iEsKtHk0w/1wFs32fW5e1WH/HPULr47qqkr5i548ZVTzrSvuHG1RY94tJsTNhxIZ0OT3wdz2ExQkMG0cpu1MfihP9OweVT5T51l63MRJsqjW4VtRvjTRXv0tEyKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8m0OgLMXrlnN1S1LWjf5bBgposl1eYuNgcDSK2N504E=;
 b=i6UwknwbvmMMxx4Vab9t2zLn1UQMQNcFZutFnJnfQtPqOVs+YywXcQ+tFK22saknqLqCVOtunBeDBrEmjBkLM3NpFj6lMjDVeUQ5clc5u3SQiCsJjWavI2xYtT+liisXX4CrPrdB0FbgKdXP3zmlYbI4R4ec6UhU0sbTs67v46w=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB6029.eurprd05.prod.outlook.com (20.178.127.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Thu, 3 Oct 2019 16:26:28 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3486:1273:89de:8cc7%3]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 16:26:28 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     John Hurley <john.hurley@netronome.com>
CC:     Vlad Buslov <vladbu@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Subject: Re: [RFC net-next 0/2] prevent sync issues with hw offload of flower
Thread-Topic: [RFC net-next 0/2] prevent sync issues with hw offload of flower
Thread-Index: AQHVeXc5O/tBF1cs/0KKA2t1J+rpTKdJG6uA
Date:   Thu, 3 Oct 2019 16:26:28 +0000
Message-ID: <vbfk19lokwe.fsf@mellanox.com>
References: <1570058072-12004-1-git-send-email-john.hurley@netronome.com>
In-Reply-To: <1570058072-12004-1-git-send-email-john.hurley@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0184.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::28) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 217056ba-9293-42b6-b4ee-08d7481e711d
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR05MB6029:|VI1PR05MB6029:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6029C367E31D164C33910F3FAD9F0@VI1PR05MB6029.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(346002)(136003)(39850400004)(189003)(199004)(6116002)(3846002)(4326008)(99286004)(5660300002)(52116002)(26005)(186003)(7736002)(6436002)(86362001)(256004)(6512007)(64756008)(66446008)(36756003)(66476007)(11346002)(446003)(6246003)(2616005)(476003)(486006)(66556008)(76176011)(229853002)(478600001)(6486002)(25786009)(305945005)(14444005)(66066001)(6916009)(66946007)(386003)(81166006)(14454004)(102836004)(6506007)(54906003)(316002)(71190400001)(81156014)(71200400001)(8676002)(8936002)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6029;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2m5s7BRJqoCgmc2M2cT/0M3PyBLI36DP78FHvg+FdGRPEfJcbwdFb4Kwf1z73Mkw5a7z5Hke5tbY8+ukEjuaBFIfvyRDSk8GWSpzrU50wURGt2Ezcd1N+BqdelaTTk0FL5sjdrIl7sIM7w1dfU+xV0qnR2RD7GpmAJOxFvJ5G7+IXvVn9VVxjv2dpiCbtS+xyX+BCux73a+O8c0QuJIofN73zlf9HEAeryoXREYKMBeUZy22KbuUQlviDlIIuQL+2rl+aKd2qmT15wDDgTAOdSP60tJpqzq0AyVhMYP5LSK3XhdWE8QXFYWaJ/ZRbSE0T+7/lMNQcmw6KbAXqWXbAK+Qh5eCGd7lYRRvoXIVzjedKRb5H0JUHMmyuFNk/d6LqqlslP7XLCauqN9jQzxGm4E7/rvhPxZ7lo4aDC0zV34=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 217056ba-9293-42b6-b4ee-08d7481e711d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 16:26:28.2234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MW4MCjerjsYyR2Vhm8Nr82Z8nGmStgvskUoWtL9UmHmPZKBNdxBJwzB2HdBEeHd9jzapcWmXdKTzyErqdKJ9Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6029
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 03 Oct 2019 at 02:14, John Hurley <john.hurley@netronome.com> wrote:
> Hi,
>
> Putting this out an RFC built on net-next. It fixes some issues
> discovered in testing when using the TC API of OvS to generate flower
> rules and subsequently offloading them to HW. Rules seen contain the same
> match fields or may be rule modifications run as a delete plus an add.
> We're seeing race conditions whereby the rules present in kernel flower
> are out of sync with those offloaded. Note that there are some issues
> that will need fixed in the RFC before it becomes a patch such as
> potential races between releasing locks and re-taking them. However, I'm
> putting this out for comments or potential alternative solutions.
>
> The main cause of the races seem to be in the chain table of cls_api. If
> a tcf_proto is destroyed then it is removed from its chain. If a new
> filter is then added to the same chain with the same priority and protoco=
l
> a new tcf_proto will be created - this may happen before the first is
> fully removed and the hw offload message sent to the driver. In cls_flowe=
r
> this means that the fl_ht_insert_unique() function can pass as its
> hashtable is associated with the tcf_proto. We are then in a position
> where the 'delete' and the 'add' are in a race to get offloaded. We also
> noticed that doing an offload add, then checking if a tcf_proto is
> concurrently deleting, then remove the offload if it is, can extend the
> out of order messages. Drivers do not expect to get duplicate rules.
> However, the kernel TC datapath they are not duplicates so we can get out
> of sync here.
>
> The RFC fixes this by adding a pre_destroy hook to cls_api that is called
> when a tcf_proto is signaled to be destroyed but before it is removed fro=
m
> its chain (which is essentially the lock for allowing duplicates in
> flower). Flower then uses this new hook to send the hw delete messages
> from tcf_proto destroys, preventing them racing with duplicate adds. It
> also moves the check for 'deleting' to before the sending the hw add
> message.
>
> John Hurley (2):
>   net: sched: add tp_op for pre_destroy
>   net: sched: fix tp destroy race conditions in flower
>
>  include/net/sch_generic.h |  3 +++
>  net/sched/cls_api.c       | 29 ++++++++++++++++++++++++-
>  net/sched/cls_flower.c    | 55 ++++++++++++++++++++++++++---------------=
------
>  3 files changed, 61 insertions(+), 26 deletions(-)

Hi John,

Thanks for working on this!

Are there any other sources for race conditions described in this
letter? When you describe tcf_proto deletion you say "main cause" but
don't provide any others. If tcf_proto is the only problematic part,
then it might be worth to look into alternative ways to force concurrent
users to wait for proto deletion/destruction to be properly finished.
Maybe having some table that maps chain id + prio to completion would be
simpler approach? With such infra tcf_proto_create() can wait for
previous proto with same prio and chain to be fully destroyed (including
offloads) before creating a new one.

Regards,
Vlad
