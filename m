Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006182873D6
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 14:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgJHMLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 08:11:18 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:62022
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725852AbgJHMLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 08:11:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=go50HqACJAaQIwIH8xqczbMkC6X6g7ljpJfmXdqb3V0cBZyoRxkbgPpO90azGJQQZ6nKZNN+tENzxyE0Ln+ERTo21MnyjWu0q/wWxJqNI0o7m5bDBt7EkpuUPbORe/mvxtXVTDb8VDugRZCbXuZ5k0+6dfMhjYsuOR1o2N/1N6Abl6rcYupqxYhB0W/joYN+O/pid7uk/QCnt7hPYzBqaLPpkO4Yb55kkel9kTfKof9RPLR7Y4wbVYGtmvzX5HURJpvY2PY3mPGaaFx9qnyZ7ufbXfH6h9zaHD7+qlhOC8CUhWyk4MbIRfwjhf8UyH3olncXqrLFpWoE0LiE1Uu0Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2oq3JDYs9tW7/RCe6ACC2ICHA5kTBNwVhgptEyolwDA=;
 b=J90j5lvHRDVwq7s+Z0TmEim/sX9Nl8hoBsZNOWEwUPuOepcuTs3p+qGdqsrMFf9J+DD33/wKt5q5hJmt+G90OEFQhVZ/bAAFXdlNEKyvKV8/pV4KKEfjzgIfLeQxasb5cG+bXMTpJ9WVaS2/W4cQquHxRSLu40GQEifNOarXjqZDFFyilpYAhGo3wBBxcbgBUgV+tt7i7cWvkRi34Zfd7I75XJgiG3nOdKLhRudYpI5VDtX4dRQOtBC1y0DHsWjxYTYgygP84ID1YTNsm0meJoEmZKark41TXsXJFd32WPsX8+nDxwkNAy+6rFbY2gcT44ulAkm5GwysXNlE1cA8mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2oq3JDYs9tW7/RCe6ACC2ICHA5kTBNwVhgptEyolwDA=;
 b=qkbuxSv1sYIyEXjlS2iTZ5nGcFxDq9uFHrMmHunTrb1pIXHm7RozWOTe7IcI1Gwc/4PKHNhl1L/NgbLAcvvFPwZP85wcDNkK7aY/ZEaNuJzTSk/7lwTMO7/iir49/phQds/iWvgHf6On/1KcsG5vTjBn2OeOcEXvPkSVW2ZnN3g=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3965.eurprd04.prod.outlook.com (2603:10a6:803:3e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Thu, 8 Oct
 2020 12:11:13 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3455.024; Thu, 8 Oct 2020
 12:11:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH] dpaa_eth: enable NETIF_MSG_HW by default
Thread-Topic: [PATCH] dpaa_eth: enable NETIF_MSG_HW by default
Thread-Index: AQHWnWsJ0yR2veECCkK6KevTWbtpKKmNnWMA
Date:   Thu, 8 Oct 2020 12:11:13 +0000
Message-ID: <20201008121112.fr5j4zppctilzcle@skbuf>
References: <20201008120312.258644-1-vladimir.oltean@nxp.com>
In-Reply-To: <20201008120312.258644-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d91bde87-66ec-4043-8486-08d86b83406e
x-ms-traffictypediagnostic: VI1PR04MB3965:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB3965D8DBBAEE0F8E91156AD0E00B0@VI1PR04MB3965.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EFx6wNBh1weZCYr+LXegorJ6VSZIyiWcFj2fjMoseDkTsDE71Mnlx61J8h+wc/w3qMn3INkIS85lj/cgwiYhB8FejVwVAQBRMNpJtJrQiazEblTp4ArvmXJee2RIduCBZiePy0kMXeEpdF17P0FwdNftIa4d+unlsOenMX2ROC+9tSLKUua7bo0sdnS4aPjl71Sr9E7b9BOA3VWT7PLBxPiCR96gukIGO6KWeAT0oSrQ1BPeNyTR0TA0mMc48m6Ucq+TAU1LgqM/fHkhatvZdHB8+CkJF2bGwSZ9e+BHLJlVFddQpUj1tX2BLYZCY1hBWqKcV78sLZm9GON1y6qOVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(366004)(346002)(396003)(376002)(136003)(316002)(86362001)(71200400001)(83380400001)(4326008)(2906002)(6916009)(54906003)(44832011)(33716001)(66946007)(91956017)(76116006)(1076003)(64756008)(9686003)(66476007)(4744005)(6506007)(186003)(8936002)(6486002)(478600001)(5660300002)(66556008)(66446008)(26005)(8676002)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: qkJBA7RP3lcMkkBbt24SUHLxvS4a8B+Gkufus2KpHiLVPCHG2YMctbdJO6mp7XsRhfrIBaraJZLUzvrhPHaTssqcdyeniTi50k8q1TiDv5HwNhCdljmz7bCf5PdYRoi8U30imLPdmxcrRgj/G/7xoBjZnYXJg+m8xxJO5wxyxj5dZfaIcTAMucQPOLWYVCqynrJ/raOYbE7skwGKEh07Ndk1J70BW1Y9qutDhA1Q72nfOv7vihVpX4SOMazQXa57QfLPwNfXr5XZlZHzEW9Wd2CGPtAMz04Tz0lYl2v27K1lzpZvRbZGDcNT22fTfsVNWS3rLWjW7sNnqup7IUipa3btjOJ/aK6rj4sn+Kxm3mrPTZ2bjR3Dfzh51QwCc7m8GJMq7RzikdcvmXhquvK+9Pn1sJ2vFht1/VjiVP4JWlXn3/bCcZcX73WC8pHpIjfnhVUVgBMLkEdvV3PTkQ+vteO20HKFP+N6yEarfOPOni6C0KE0sYI8IPAfx5NLqVcFLW3YuIA7NAHhE5P3Wu0dxYxIs9pruDFh65fmgSfoJ6pGcaD8YfZPzpV77LKDCJKlJWBOUxHNwZTX7jNrlUe1SXK/CPtEBJ/tVDr1E+Anvt7y1BDMycXvM1nUG1Ra3Tmo3DykBj1ql0Ps1cSZCcoXOA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <83414B65F593EB489C63500B4EDB9707@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d91bde87-66ec-4043-8486-08d86b83406e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 12:11:13.7758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GdFh/BUJJOfpUstlvNPSZQKCYByM9ETosoTVZmivD3GvfwtU0Dr6/XBKVl/G07VIMQvT0h1hsC4ePRemnAT0KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3965
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 03:03:12PM +0300, Vladimir Oltean wrote:
> From: Maxim Kochetkov <fido_max@inbox.ru>
>=20
> When packets are received on the error queue, this function under
> net_ratelimit():
>=20
> netif_err(priv, hw, net_dev, "Err FD status =3D 0x%08x\n");
>=20
> does not get printed. Instead we only see:
>=20
> [ 3658.845592] net_ratelimit: 244 callbacks suppressed
> [ 3663.969535] net_ratelimit: 230 callbacks suppressed
> [ 3669.085478] net_ratelimit: 228 callbacks suppressed
>=20
> Enabling NETIF_MSG_HW fixes this issue, and we can see some information
> about the frame descriptors of packets.
>=20
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

I'm sorry for failing to mention the target tree in the email subject.
This is directed towards net-next.=
