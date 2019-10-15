Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F67AD7010
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 09:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfJOHWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 03:22:05 -0400
Received: from mail-eopbgr20079.outbound.protection.outlook.com ([40.107.2.79]:12039
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725802AbfJOHWF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 03:22:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJjPQlkFXBPxFQc8DTBbTdvKcbc2386+dTL8MzJ+2FEaVSE9v5I1vzni/f1ApGe4u0QP9SK1aPz5oHaOx2DFglAyqXZO2rv3rw3fK5vpr9K5p0ssTitFy2vj97rwvqjM45o5na6fVd+xeR4ptmWTieDJvsGRmt2APV6UB9SQOOS++j40evSxLq5md++5LK6GLOa30dpG8MttHRUHzLU/DUHqUBz7R9jjjxAQB/sziANbmuVlpXXlojrt31wWjHxTSZ6WEBTD66tfYKHB19V8Fs2GXe/7c8hJNcsH1rF03xnN4rPFz6QgKHeG5iDVEoAyvQkvLs/ykyvlHLGaUHKf6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCZxCUKIwWvByEoQa3R3l2sVwL6inDE1LXDBpd2DFfY=;
 b=Yf+sliSwckc8Azn+68plxbQIWkxs3l7qhT+0nhxoNHqLhkHauR9r7rCytSRwfhE6ltzDh7gcibG7jF3LbR0d+V7Zl4QnoJS75WL1990flJvx2THhaGqECSkejSA5oZpeQ1/7hOOo8OE73TDzMcMWjCXMIQdmkZPIrtN9Y6iLHiY0Tv1McIxaJWABujC2Nc7QKeHCYBZW874IXSmI0AiTfR0m3H5FU6ReJItKc4sQOvVrNhItzDiC0SLO7jT0f0MNYaxurrPp16L+4+KUNWZvw+yBGWmMBGF5IIuyd9eq/G7JtDvD6VqTjk9Ts5eDp3oZibK+p577GEB/xhedh4cpEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCZxCUKIwWvByEoQa3R3l2sVwL6inDE1LXDBpd2DFfY=;
 b=qNDcOnkar6KeXJTNSULY0ez0BFtRiRQjnHIERYHZT1HczIKkXPsioi1D22FdXAduaoFyhzCG2sCZS2Umbq5MBdGvUz5b/Z6JBk3/oUVxC+s4+lx64571LAcNT9CKS5x05+SVQMY7EQ5FtSOAd9IesOJcCROOcqd/M4SZSqpIPfI=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.188.155) by
 AM4PR05MB3460.eurprd05.prod.outlook.com (10.171.187.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Tue, 15 Oct 2019 07:22:01 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::dde1:60df:efba:b3df]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::dde1:60df:efba:b3df%7]) with mapi id 15.20.2347.023; Tue, 15 Oct 2019
 07:22:01 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Randy Dunlap <rdunlap@infradead.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH] net: ethernet: broadcom: have drivers select DIMLIB as
 needed
Thread-Topic: [PATCH] net: ethernet: broadcom: have drivers select DIMLIB as
 needed
Thread-Index: AQHVgLILd9wXJZvpIUqDLTWD6nofXadbUREA
Date:   Tue, 15 Oct 2019 07:22:00 +0000
Message-ID: <20191015072158.GA6957@unreal>
References: <610f9277-adff-2f4b-1f44-8f41b6c3ccb5@infradead.org>
In-Reply-To: <610f9277-adff-2f4b-1f44-8f41b6c3ccb5@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR04CA0149.eurprd04.prod.outlook.com (2603:10a6:207::33)
 To AM4PR05MB3137.eurprd05.prod.outlook.com (2603:10a6:205:8::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b8554822-0ca7-4576-2898-08d751405ee2
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM4PR05MB3460:|AM4PR05MB3460:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB346050E67FDCA0B12D8DF8A3B0930@AM4PR05MB3460.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01917B1794
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(346002)(39860400002)(396003)(366004)(376002)(136003)(199004)(189003)(66476007)(66556008)(6306002)(6246003)(6506007)(386003)(229853002)(6512007)(9686003)(478600001)(81156014)(71200400001)(71190400001)(6436002)(81166006)(8676002)(33656002)(316002)(476003)(54906003)(486006)(64756008)(6116002)(102836004)(86362001)(186003)(52116002)(26005)(3846002)(6916009)(66946007)(66446008)(305945005)(446003)(11346002)(76176011)(7736002)(966005)(2906002)(14444005)(256004)(66066001)(14454004)(33716001)(4326008)(6486002)(25786009)(66574012)(1076003)(8936002)(5660300002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3460;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6cypjeV+H8/7qbzlDtTOTpuqNixdt78p2CZ+Zd/FHQbmEgB29WyHetGBSOisjQdgaUzlfbILUgYwKGSnF8ikLT0yz3SGd/Lo11zPfzm+21r009LL5bdtxGsaXg/Er5P2aOHcZPt0jOsnpc+sk0NI0FeRGttpmW3+/TtlGOppR9bMK6iRyCI5Z5vZW6aIoEg2U76lVO3aK4jHHS9Cljt1L5ghXrbynLHvJSPfyF4nvGAqxuNdKqaymJ1aAN0h9CxCmVbPJsURIbFVIReDu09Vt2UgmWtPaOka8Ew3YXwEd9i/KpbZAsw1OXd2NvuIdG6DUQd/E8CwxvNY/SXr4lTntzwTJOMevWeRKx4ttfQQZifenvBb6yLdDqU0zV40zDnye0h2lehyVuRogLk9hMmjimNDQxvUqLSU1G7a6bCTRMPsJd7ByLNJIDbJS2CeNbIwrFZ/x9/Naxgl9VEt0Capmg==
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <F61E0C50DD538E49933BCCA745B1A918@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8554822-0ca7-4576-2898-08d751405ee2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2019 07:22:00.9210
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oVYcNKj8/bccVYHmhM1T2mb84nQu2yPE8zcko/nzEZ4leKxlllv7r3xkyuTgDDxyf32VjqZ7aqOCqLOSf+7hkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3460
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 09:03:33PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> NET_VENDOR_BROADCOM is intended to control a kconfig menu only.
> It should not have anything to do with code generation.
> As such, it should not select DIMLIB for all drivers under
> NET_VENDOR_BROADCOM.  Instead each driver that needs DIMLIB should
> select it (being the symbols SYSTEMPORT, BNXT, and BCMGENET).
>
> Link: https://lkml.kernel.org/r/alpine.DEB.2.21.1907021810220.13058@ramsa=
n.of.borg/
>
> Fixes: 4f75da3666c0 ("linux/dim: Move implementation to .c files")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Uwe Kleine-K=F6nig <uwe@kleine-koenig.org>
> Cc: Tal Gilboa <talgi@mellanox.com>
> Cc: Saeed Mahameed <saeedm@mellanox.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Leon Romanovsky <leonro@mellanox.com>
> Cc: Or Gerlitz <ogerlitz@mellanox.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> ---
>  drivers/net/ethernet/broadcom/Kconfig |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
