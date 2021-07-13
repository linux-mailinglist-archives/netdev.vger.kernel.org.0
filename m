Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE323C6BEB
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 10:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhGMISL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 04:18:11 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.34]:21164 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234157AbhGMISK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 04:18:10 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jul 2021 04:18:10 EDT
Received: from dispatch1-eu1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 029EA24A542
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 08:09:56 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-am5eur02lp2058.outbound.protection.outlook.com [104.47.4.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CA6204C0075
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 08:09:52 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYk3Ml/hfLRSw3HyBMBJLtAnbgGLUCCZHPzdQFGBrr/hk4HR432SsERZIuNGQzeH+Tb5p2fi4wnP0F0KDnlk692sE/5moFphWSMyqJbM92j1uMPjwz/70BqVumLYmc2AGx+EgZZ7tYFC4CiB+W6MS9n3X633+V58GfHCUqef3TD78rkon2e29R55VySMLkPflGqyk0ikdPUhJyr9UcpyFO/IZtVH6COuqNAiso/iiiI9u995Ho52O0Q5ZR0eqsdxZegPRPh5agVx2m2rIxyEmUnmPub3t/Ik8RE8namkoSzX//S27nyBnLO1m2DCwdIc03GCzUFRh8VLiHvd6zkGzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sIbBM0GgCE4xlH6jmqPRUb1zwSv1gtlQv91dkj9d0E=;
 b=PdIX92ouBsIqZVvNA1PXmFrmuNom0IlrkvI4gkc87KKBuST6j5j1iNY9EG5tb6pxJrV+vcVlNtodQ20ac98wp6O74S99eiLBWRP5zIOoadKynQjHQzxr0uv7WDB2I3EVLg2kWUPRJfO9ZeXAbJRhuP7BkmjNAaiXDJ7+QAbCy/ysTxdQfYLOynzB/SSDbLML26rxuagMbZnE8TRhSoujD9Wtz+HgfEBOInrwwDe/SYJCN6FytuFkyGlmo9Q/DnV4Lkef/ZlMKQItr8gkn/wbaXiBCmB1TGt7SPituSrGut1jOgyYNXBhNyrb2+TZ+iCJJwepc+nlT5uydNcdv69pzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sIbBM0GgCE4xlH6jmqPRUb1zwSv1gtlQv91dkj9d0E=;
 b=gnPc5L37Xc0et294niu2+YeMzIiD6QJgvr9oYzJJdoDTXuLE8C9hluGQcNRVyK7a00i0o53amYT40AMQBnFHktcH2svIh05xPYarCiB+VQNTfIXSbfMcQKCOSy8Pr1MF3ulosEyAJuq2yUl0UDzywR+2cbA0yQxmReQdfU7pvrw=
Received: from PR3PR08MB5801.eurprd08.prod.outlook.com (2603:10a6:102:81::20)
 by PA4PR08MB5966.eurprd08.prod.outlook.com (2603:10a6:102:ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.24; Tue, 13 Jul
 2021 08:09:51 +0000
Received: from PR3PR08MB5801.eurprd08.prod.outlook.com
 ([fe80::7d50:aa90:37a5:b185]) by PR3PR08MB5801.eurprd08.prod.outlook.com
 ([fe80::7d50:aa90:37a5:b185%5]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 08:09:51 +0000
From:   Lahav Daniel Schlesinger <lschlesinger@drivenets.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Patch to fix 'ip' utility recvmsg with ancillary data
Thread-Topic: Patch to fix 'ip' utility recvmsg with ancillary data
Thread-Index: AQHXd750YeWQ1hslg0SYeHVuI8rNpg==
Date:   Tue, 13 Jul 2021 08:09:51 +0000
Message-ID: <0644F993-A061-4133-B3AD-E7BEB129EFDD@drivenets.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=drivenets.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28e863eb-28c7-4fbd-1d58-08d945d596e6
x-ms-traffictypediagnostic: PA4PR08MB5966:
x-microsoft-antispam-prvs: <PA4PR08MB5966BC11EA83727F1F705B28CC149@PA4PR08MB5966.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uu7+4GhsW/BPSzygL/xHhSWuF+owSDz+i6I7zLeyBoqu3cSUyApGT0RcDRRZ0e92ezEM9OIvs62kmdg6Oo3BEDRp7fJ585V5RN3kIdy7S9kKAMxfsQF5hBWLlnO/3GATn9Cdsd9YMMqNWt5EHMwe9VMS7Yqq0VQreARxO9B/kat1BDMyJEFsdFukNjjjNqNTcYwlMmZvvV2FqYW1o2dWRWniVIes6HgqJh/N+XkK3ZMoQoaQyF1nzAtk5SVRhHqqNZl6rRgZ50qhJtTx4FmXN6FBC421d3sG5RmBj1QtY3eQMsnGIbKuggHn7JI9XEYdtdJ+yKppG70oWj34iRAM5fi96LN0pnc530UFVKQPWpYv+toM3sADe7yQKT3wAhu2I69w+9R7anIi3t3/gataK+kC30POsWDFNVgJUc6atv5JtJpymFAL+zOJocNCk7r+HMf4+3W7LAHJPm9zsPoopu+mrX9/47QGUQADg80b4F/uYTgFMuEn/U0OwDUP/bSTVAZUn7znWKI9DHSkRTqpVFp1Chggt2CUOKnkb+WFlw5DsdRMKJVYcmy2Soge41icL+IerPh9G1LFaz5pjTdidp/C1D9Clw43ab5r93KltJIMciX3gzDf+3hEJFW/c35bXjS9KGH328bp8HtqBKCf0rR3ku+K0lxOAJwHbSoqALbfYqC6HJu6tk6+SrlR3zs4H70gIUaW/0hMqLVBSjrYhA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3PR08MB5801.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39830400003)(396003)(136003)(376002)(346002)(86362001)(64756008)(478600001)(6486002)(8676002)(4744005)(6512007)(91956017)(66556008)(66616009)(38100700002)(66446008)(66476007)(2906002)(8936002)(66946007)(2616005)(76116006)(5660300002)(6916009)(186003)(36756003)(71200400001)(99936003)(33656002)(26005)(316002)(122000001)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VuKseAPMpQxInYvkr4vy4ImMKXqip/1DqD7LZFH4p8lY7Ncd7ydF3uZAtFRI?=
 =?us-ascii?Q?DY6YhWHE7bAGkACisL+XkrlaqI/M8Nb0ZmVsC0pVhgLbNPNkVqfl39frYt1c?=
 =?us-ascii?Q?TKAYT8bWgShkpaT8gkdA5Y3sH6Q4lkJWmndPOvyovAJw4GsvifALoyimztoX?=
 =?us-ascii?Q?Soa2ziN1NxKVNOYd4vv9TjBQXxddSXMhW1xNQi0ZwnaW93lsg8iA+vmVL+rs?=
 =?us-ascii?Q?SUnB6hTMcjQLJIhQaCr/mN/TSyurEjFoJgLlaP4uVXO67QDzLejfy+yEYki+?=
 =?us-ascii?Q?5nlB2hDMYTNtyp1ZXjAdwi6oudqUseCxPuPbM7DilBgp1Yo3XRSBBHReTljA?=
 =?us-ascii?Q?FADpyHMNLOYb29UeLK/sojgVua6VOEVbjkrLdBqjruZBiXQ6Ao7xmqOAzONI?=
 =?us-ascii?Q?XztQYKTwI9xtRlPiYM6IUxIBw2h4CcqyrW0cqI5Lx4zud2vRH2F0aJCHNxMw?=
 =?us-ascii?Q?zhrlrIV6njEC2ykNWxvvGzYNO+tOGaYiLlwFn76mSIttxIsAQJMO0FoVAoW2?=
 =?us-ascii?Q?Qzba7vqY0jgd+DBxjlvQSnV6buDBceZzGyBYXIv9x2LneFlRjLcg5iHKF9j4?=
 =?us-ascii?Q?S9CnOZakw53vz2uYe9h+EjNUNTAF1TRN8DavjsDk73nM8Y4CUjBuKYwL5G88?=
 =?us-ascii?Q?NIP9BHzpFgPyZpWy3I0mgnl6rkpFmDW9BUcL19fmPW6tpkfcHBoVifAoiH3h?=
 =?us-ascii?Q?Hje09VM6WplgwrgXzBSa5cBPJI7Lulh+B8P+OOjwClEiYLFgO7LKezFfUuqh?=
 =?us-ascii?Q?fsUxbdjrlaJPEzEWIZ3GZ33L+wMKrqPC/w5RJRPp2Mexaw6/aDmE/tgSaYgM?=
 =?us-ascii?Q?NRHYKj7zy997wMugtrL4AWpJU4YYJ+eJyksbmRRkf7ddvBV5qHp40jQBobgP?=
 =?us-ascii?Q?ZflNnrwvjrXNv0LE5oBteZXZRwqbtN8Y6wvCrbwD6A7FKUlL0LErq5bdrRBn?=
 =?us-ascii?Q?26AfWqVgbgdUViXpdJfvSfEZCQRyScddI1td+Qvx0MHMsHCHmYyL2AYK5Qpg?=
 =?us-ascii?Q?ngwuXGcwVxSGFTUB9VvE98lWY7pC/UBHROG6SeqeVr0KRGkd99OzLccMdY4u?=
 =?us-ascii?Q?VhtEhnS34btbG/YhluLx5kQmWErUL46ezZxWrRXZXoM6r96XjrCWEk+UHz/m?=
 =?us-ascii?Q?vVPkwzLZU6R3wH42vnz8n7o2obhe7e3nTkd2r7KK4L/9XFTfYhSnqYFgv1+l?=
 =?us-ascii?Q?jRd8V05SYOUJqrjeMsXluAy0ds6kRnZcFFGSBrYyxUB/MFIc8WbHpV+IrmzM?=
 =?us-ascii?Q?wsjvq+gebvr0oSnmnWfycoQOXssPaFlM3vwMCCtpeqEpb8joEgzaiaDLuig4?=
 =?us-ascii?Q?lu6QZdENio0Xco7uy6+JCu2Q?=
x-ms-exchange-transport-forked: True
Content-Type: multipart/mixed;
        boundary="_002_0644F993A0614133B3ADE7BEB129EFDDdrivenetscom_"
MIME-Version: 1.0
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PR3PR08MB5801.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28e863eb-28c7-4fbd-1d58-08d945d596e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2021 08:09:51.0564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3DWTAjrkLyKtyCZA+S03Ar6dQ3Nb9wJ6I/yozMfD0Pk/bDkJqdGWkmXZ7W96YjKRCHE5NMgv2Tay3LFHh0eKGUO0aIAONXGVIlGLONqwtjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB5966
X-MDID: 1626163793-FhAmVT4nS9Pu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_0644F993A0614133B3ADE7BEB129EFDDdrivenetscom_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3F04B5DDA5CB5A4C913E197765D6FFE8@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable



A successful call to recvmsg() causes msg.msg_controllen to contain the len=
gth of the received ancillary data. However, the current code in the 'ip' u=
tility doesn't reset this value after each recvmsg().

This means that if a call to recvmsg() doesn't have ancillary data, then ms=
g.msg_controllen will be set to 0, causing future recvmsg() which do contai=
n ancillary data to get MSG_CTRUNC set in msg.msg_flags.

This fixes 'ip monitor' running with the all-nsid option - With this option=
 the kernel passes the nsid as ancillary data. If while 'ip monitor' is run=
ning an even on the current netns is received, then no ancillary data will =
be sent, causing msg.msg_controllen to be set to 0, which causes 'ip monito=
r' to indefinitely print "[nsid current]" instead of the real nsid.=

--_002_0644F993A0614133B3ADE7BEB129EFDDdrivenetscom_
Content-Type: application/octet-stream; name="fix_msg_control.patch"
Content-Description: fix_msg_control.patch
Content-Disposition: attachment; filename="fix_msg_control.patch"; size=700;
	creation-date="Tue, 13 Jul 2021 08:09:50 GMT";
	modification-date="Tue, 13 Jul 2021 08:09:50 GMT"
Content-ID: <1719F7B585C5E947B81598FF5D3343D9@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2xpYi9saWJuZXRsaW5rLmMgYi9saWIvbGlibmV0bGluay5jDQppbmRleCAy
ZjJjYzFmZS4uMzlhNTUyZGYgMTAwNjQ0DQotLS0gYS9saWIvbGlibmV0bGluay5jDQorKysgYi9s
aWIvbGlibmV0bGluay5jDQpAQCAtMTEzOCwxNiArMTEzOCwxNiBAQCBpbnQgcnRubF9saXN0ZW4o
c3RydWN0IHJ0bmxfaGFuZGxlICpydG5sLA0KIAljaGFyICAgYnVmWzE2Mzg0XTsNCiAJY2hhciAg
IGNtc2didWZbQlVGU0laXTsNCiANCi0JaWYgKHJ0bmwtPmZsYWdzICYgUlROTF9IQU5ETEVfRl9M
SVNURU5fQUxMX05TSUQpIHsNCi0JCW1zZy5tc2dfY29udHJvbCA9ICZjbXNnYnVmOw0KLQkJbXNn
Lm1zZ19jb250cm9sbGVuID0gc2l6ZW9mKGNtc2didWYpOw0KLQl9DQotDQogCWlvdi5pb3ZfYmFz
ZSA9IGJ1ZjsNCiAJd2hpbGUgKDEpIHsNCiAJCXN0cnVjdCBydG5sX2N0cmxfZGF0YSBjdHJsOw0K
IAkJc3RydWN0IGNtc2doZHIgKmNtc2c7DQogDQorCQlpZiAocnRubC0+ZmxhZ3MgJiBSVE5MX0hB
TkRMRV9GX0xJU1RFTl9BTExfTlNJRCkgew0KKwkJCW1zZy5tc2dfY29udHJvbCA9ICZjbXNnYnVm
Ow0KKwkJCW1zZy5tc2dfY29udHJvbGxlbiA9IHNpemVvZihjbXNnYnVmKTsNCisJCX0NCisNCiAJ
CWlvdi5pb3ZfbGVuID0gc2l6ZW9mKGJ1Zik7DQogCQlzdGF0dXMgPSByZWN2bXNnKHJ0bmwtPmZk
LCAmbXNnLCAwKTsNCiANCg==

--_002_0644F993A0614133B3ADE7BEB129EFDDdrivenetscom_--
