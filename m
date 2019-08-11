Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B27C89128
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 11:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfHKJ4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 05:56:05 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:50760
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725900AbfHKJ4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 05:56:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQtZkbdYptQtCagSdMzg5d3sbrKrdL6yvWVN6o1yFDftUUpOIASdRWBqNisVpL6KSPhjBojvbvGtEZcTqZWlUi2/yVTrTvaPJuovXkhx+Eyq+hmG81zTFN5rxlFre7nrgdoRSNCjQVr5XtevdphIPtaI+OscB181YFT9PjThGmmSLVhXzwqWvyW2pK+MLamH0BQQMQKZNIe2FGV3+bKQRDY9pLZEXhtkNtP35jLXzDH509NvEDLv8SJO7rq2coN5rnKLXDav32KIbuBb8Sd6F5FvVFgq1JsuSw9QuPbNgljn1pc1JmRSjXpMlQ8J1PXfRkV+mX1GSSTZ6/7MOOBqqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJtzcYhH8Dei1lvX5Lut2M+WOEfZoTyMfeC5WS3b/og=;
 b=EDtNbfuKl4qdHOdDg5Zhgujc3AZ0u31pXf9CUeHptsJrb9abZAmfHe6sMLcAiCcjqRguTPQUnAkP7dGlQO6zXS2Icx616nyBcEX9aEpFNVpkb93hvKs4mlTpXNWaYkjOVueqayYioG1kcMQQBAtHVEOuKFRZlZG37d5cU9KGg/eYDvKFEIpOKhyZXV9zf08BjAB+eBZlpCTwXsvqFEhBcQS4z7DeG5KaGgQNI05slgQE35DRf367738YFVkTwSBJz2GGOR1l1Y5KDGE+jS89JtLmPT7byNATA3Pb5sIt29Jk087OGuMTg47P2O0ax0MjvEme09RThjxC1z6Ss614BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LJtzcYhH8Dei1lvX5Lut2M+WOEfZoTyMfeC5WS3b/og=;
 b=Irf3nmJbp1R2uoOy+bKZC6gszk5O7YkJ8c5NFfYcA3K9n9GU8cqbAIunYGyULnuEa25vKiK4rR34HhA9wEI3ZFBYXHAimCn6Dr7oc92jQofiJMzsHNgSHA1xQ8rnUIUIcAyTU3QpM2JimwR5mHD6VWKMu2tfdanDpeTx25ZIK7c=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.188.155) by
 AM4PR05MB3458.eurprd05.prod.outlook.com (10.170.125.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Sun, 11 Aug 2019 09:55:58 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::a1bc:70:4ca9:49f6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::a1bc:70:4ca9:49f6%7]) with mapi id 15.20.2157.022; Sun, 11 Aug 2019
 09:55:58 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
CC:     "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Boris Pismenny <borisp@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>
Subject: Re: [PATCH 11/11] treewide: remove dummy Makefiles for single targets
Thread-Topic: [PATCH 11/11] treewide: remove dummy Makefiles for single
 targets
Thread-Index: AQHVT5QeRE/eBhrx90G8ydJdkg0FfKb1tsaA
Date:   Sun, 11 Aug 2019 09:55:58 +0000
Message-ID: <20190811095555.GF28049@mtr-leonro.mtl.com>
References: <20190810155307.29322-1-yamada.masahiro@socionext.com>
 <20190810155307.29322-12-yamada.masahiro@socionext.com>
In-Reply-To: <20190810155307.29322-12-yamada.masahiro@socionext.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0020.eurprd09.prod.outlook.com
 (2603:10a6:101:16::32) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:8::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a6960f3-1c5c-406b-f5ef-08d71e421c0e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3458;
x-ms-traffictypediagnostic: AM4PR05MB3458:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3458C667CF8B910D35D17B15B0D00@AM4PR05MB3458.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0126A32F74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(376002)(366004)(396003)(136003)(346002)(199004)(189003)(6246003)(4326008)(8676002)(11346002)(6486002)(478600001)(446003)(81156014)(81166006)(229853002)(5660300002)(66066001)(316002)(8936002)(4744005)(14454004)(2906002)(54906003)(486006)(6436002)(1076003)(66446008)(64756008)(66556008)(66476007)(66946007)(476003)(3846002)(6506007)(386003)(7416002)(52116002)(9686003)(6512007)(6116002)(102836004)(6916009)(25786009)(86362001)(186003)(53936002)(99286004)(71190400001)(71200400001)(305945005)(76176011)(33656002)(7736002)(26005)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3458;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: C1hooVLEz9S7qgTUPP8Zlpw5FQtCLRbfPMo7YyXFLvvb9F073Xk/btf9azTdxldc8ZlWSJ2SUjuLi5/cnHManxEwIdITcihL6aove01RaWwQvatTerBqbYQ9Hk+QmuWHsLw0XBnsTxmdl9WQQZDwx7hBUbCkKfUZsaOR9e6U5ITrBqxsgzBXEzksUxER1HbFjQsrHLbgknODGGJ8kApjvFtT4J6sjT0aivxkmqj2kYbXKxZgmRGgncne3Ubb2XOu2jasWESfT8NkaHhj0sb130Ylcfz62iVUoCNdeFV8oUwv+qK8Z9WtoPB6s2Uvclyv/zgHEhaCbnBIFrToCIL2a+NGbHWQSjbcEZpFv5s8MRvmxV6PP2pntXa3z834xZizLkBZ0i8cgLbeqTrxjbVQ6a1/Iqji4xIJWljsKbFIPlk=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D00E1D38B2CAF44D82BE59CBB71B2DAA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a6960f3-1c5c-406b-f5ef-08d71e421c0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2019 09:55:58.6030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yes2R86qFUOXZKiZF1gnTM+fy5wNPsgym0WfQhcCmZeOuLNs2hUD2a4zvtZuE4yDFj8D2rpmIs9GKaNm+uhlew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3458
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 11, 2019 at 12:53:07AM +0900, Masahiro Yamada wrote:
> Now that the single target build descends into sub-directories
> in the same ways as the normal build, these dummy Makefiles
> are not needed any more.
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
>

It is hard to test/review/ack on this patch without seeing previous
patches, especially patch #10 where you changed logic of single targets.

Thanks
