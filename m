Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564D185F4F
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 12:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389922AbfHHKLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 06:11:05 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:12846
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389793AbfHHKLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 06:11:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPahigDfF6wEC/3GDVywJ3BfvxOL+SXRAWt9iQDI02bURx/Y9Yqj0RMBoPmcKgZhop6fp/dKVFPy25IPqvYUEniiLyncRRWJeTdHWqGhnt84ILiBoLeUOXe4UnrNq8mT1+DY1597DSHXJCN/ezpkC0khMFpQtbLnuR4Y0xixDQJt/aXs16lg+Ga73BaAJCNk5CzuYuNmTHOXE/2wWtSi17GgsvNtH2uSYKNiM0UthTWDXXDK7OhjC45mtFIp+LgphnMSbMb8aUZ4xLXhVG/PBlFbN2U3coSnd20bR7vmUAS5Pv50sINeBriaBzxENaqAEjnh96iFWEYJw0dnPyS5nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtmAxvYOKvJe7IuN36mkJudCF4EKWSd7gVNtboKXlxo=;
 b=YeG7zsUdCB3FeGDW4Vh136s4D65SWpe+hpoU/FA8Z/7jv7d4BEPgMHuimhrD2eUcH/Qet6XmRaHStZJdwz6fMKVN9t7PdxqnQMUdmpGcABVJFvSRYxoiuzGAWMxpD6WpuiVHylQiSJTl6D4AzsfRzfpXnnC9mcb7wmH/HFmeHXL71tQ/t0jiwME+NB/xB3yX+ZtR2wKYnHEmG2rjCRREaBNcyzapE1ZH/T0H343MPGMgU7VKm3XFLo1izQ1MHZ8NUGJOHsNzX6MeCJ1Iq9dceLK7ERDVWWg7f19Ug+Lx2j0oEmg9+sTZv8YCCXXvkTCCMucBNNZr6gdEN6WGmY15fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtmAxvYOKvJe7IuN36mkJudCF4EKWSd7gVNtboKXlxo=;
 b=Gic1EMQCtM4D16yLeRti/xK5/pyc+Qh+x7bBrCzR60RDHViS1YF9KkLo78dgDHEL0EbLPix4/bAlZEcOmqrR5SzU3HIbrATeeBO/VnKaHCfy/N6vYS8U9bSaIKcLoaLXnsCDbTj35KsKMGd5SqmJS3QkUVVAa+5SId/2iSgm+NA=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.188.155) by
 AM4PR05MB3412.eurprd05.prod.outlook.com (10.171.188.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Thu, 8 Aug 2019 10:11:01 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::a1bc:70:4ca9:49f6]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::a1bc:70:4ca9:49f6%7]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 10:11:01 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        Edward Srouji <edwards@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/4] Add XRQ and SRQ support to DEVX interface
Thread-Topic: [PATCH rdma-next 0/4] Add XRQ and SRQ support to DEVX interface
Thread-Index: AQHVTcVwaztmXBnL+06+efxz6YKskqbxB5uA
Date:   Thu, 8 Aug 2019 10:11:01 +0000
Message-ID: <20190808101059.GC28049@mtr-leonro.mtl.com>
References: <20190808084358.29517-1-leon@kernel.org>
In-Reply-To: <20190808084358.29517-1-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0010.eurprd09.prod.outlook.com
 (2603:10a6:101:16::22) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:8::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2de0816-1c53-462a-acfb-08d71be8b71c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3412;
x-ms-traffictypediagnostic: AM4PR05MB3412:
x-microsoft-antispam-prvs: <AM4PR05MB34129B10D3812D0501159C5FB0D70@AM4PR05MB3412.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(39860400002)(396003)(136003)(376002)(346002)(366004)(189003)(199004)(81166006)(81156014)(8936002)(25786009)(6246003)(86362001)(1076003)(486006)(6636002)(66066001)(8676002)(4326008)(476003)(53936002)(305945005)(54906003)(2906002)(7736002)(316002)(9686003)(6512007)(229853002)(478600001)(76176011)(6486002)(6436002)(110136005)(14454004)(446003)(66446008)(66476007)(11346002)(256004)(64756008)(66556008)(4744005)(66946007)(6116002)(3846002)(26005)(6506007)(386003)(71200400001)(71190400001)(102836004)(186003)(52116002)(99286004)(14444005)(5660300002)(33656002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3412;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EMxlMGpQaLsB1mNBDlXOgqyBIb7S6Yd9w9WBIS743UQr1yFyJTvYNzlNQ8CXke1lGLt+tu2Ckr24zycOOlpHGN5N3npY3LYaUa/RxQeRHg8AYDrSMalt0La/wX/X6i2YfE2K74/7npjOLaGc1o2Z7yMAyNLoGDMiro/bkmX5XioUF7H3o5cMx8DQQ2vWQaIzvOeY/K2vicdYvPIZla6V4jdFHlcDLn3Gf099OQqiTFf5V2x3AiKAv51/8W8JQMXZNagww5iWHpDE0uPykOo7KvlmA40WHQgYDEZBly73ZtdKzPT5QYFVvfO3cLBvzQxpxiGmSfr0ZyIj689xm8XOkgHNliaM0G1/h2Co4r82Cjlu7SGreMgJAltsYL6G3x59j5vhnFrwmuaYUmEx8rym3DDqSTrdReBTU37mrbvaeMU=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BD63A54FBDBD5C4A9F186042E3640BEC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2de0816-1c53-462a-acfb-08d71be8b71c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 10:11:01.6445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lC6rwwIk45OEDOhq8ayRxLNaeuQJRphncSnbLr8aQSv6UJwskoua6ZVTmSBc/Ha8QSnULAcbRcDF0+cOJis2sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3412
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 08, 2019 at 11:43:54AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Hi,
>
> This small series extends DEVX interface with SRQ and XRQ legacy commands=
.

Sorry for typo in cover letter, there is no SRQ here.

Thanks

>
> Thanks
>
> Yishai Hadas (4):
>   net/mlx5: Use debug message instead of warn
>   net/mlx5: Add XRQ legacy commands opcodes
>   IB/mlx5: Add legacy events to DEVX list
>   IB/mlx5: Expose XRQ legacy commands over the DEVX interface
>
>  drivers/infiniband/hw/mlx5/devx.c             | 12 ++++++++++++
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  4 ++++
>  drivers/net/ethernet/mellanox/mlx5/core/qp.c  |  2 +-
>  include/linux/mlx5/device.h                   |  9 +++++++++
>  include/linux/mlx5/mlx5_ifc.h                 |  2 ++
>  5 files changed, 28 insertions(+), 1 deletion(-)
>
> --
> 2.20.1
>
