Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203C3CF246
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 07:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbfJHF4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 01:56:04 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:40354
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729375AbfJHF4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 01:56:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgsk8hc2Fw9eHN+gNPFA/qo+iauaMbd9gtltYdJefbQ2/b686yW3aS/eeYjJrsthGxpOMdrmIb0g3oQYb34+GxXZ6LNHIepyCAeze86nSl/WRz2vS3k4m4Z483ttSh7TO0hetqFjatSF+qrBc4dhzW5095oWDU2vo89VzM/e+bN4ib8M8Y+86NoKJoDSdESroGOhKZD1Q6L+pLcuZwEZWIR8MFqNzmNIWk9NNxSkMlztW/35zU/IsY1uugPfTzzJvVON/LbNWyaZiH203ZdmEPbMsHmwrBCVT5PT0DgMQS3aRVpu4JQwL0B84m6temac1pPF2kJ/PPNLjMm/CLUWgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cELSm5oPIxjpMakOL3CQ94p5EGIfXcF8OGdoTOGhuGk=;
 b=mYNgcowfndkN9iCZLtwW4mWJxm/YbiKzU8AfwdarH4hDyBhF0aS4k6BnS/QWjLE9P4jUnYSvjL5W2gJZHTYTY2VOmrrJI/llzeOulJHrWTkN1KkJLtHhxMnu2gud6s2hkWQfn7nWN7xrf8kK/plbm80Ietd/an5rT1p8shT+H/7rMj00S7JGSxfp7tpOYmPHkBmqKmxmyeiQ6AqLitWq+EC+vuiF+6TDDNLINl/1zPZn8dUI/YLhuPIDRq+U8WaFr7UHDpFWj447QjLt2y5C4Sg56Gwfn7BFsIJbQBP7q/2jUiOVKxYJMINLsUBFHkhsP06ePA6njZYOQZvJ5Q5G1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cELSm5oPIxjpMakOL3CQ94p5EGIfXcF8OGdoTOGhuGk=;
 b=EjH457jj4wCEtJGkH0l+IrNQagU7iJzA1wIA4s1gwbnWihEtaFr2mZUamIUeYtqDFBN50nPv8aMYcCo3BxLq6P9Wx+9bI+TPXW7PRJbbjIHlqaArYLNFSL/n8AL3MJwrw9riwLC2Ckow4G5chLvCnZafKUfrBMcBkiAejLyf6Hg=
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com (10.171.188.155) by
 AM4PR05MB3123.eurprd05.prod.outlook.com (10.170.126.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 05:55:59 +0000
Received: from AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::dde1:60df:efba:b3df]) by AM4PR05MB3137.eurprd05.prod.outlook.com
 ([fe80::dde1:60df:efba:b3df%7]) with mapi id 15.20.2327.026; Tue, 8 Oct 2019
 05:55:59 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>
CC:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next v2 1/3] net/mlx5: Expose optimal performance
 scatter entries capability
Thread-Topic: [PATCH mlx5-next v2 1/3] net/mlx5: Expose optimal performance
 scatter entries capability
Thread-Index: AQHVfRd47k7lLrZYBkWF5INDPoQUgqdQP+qA
Date:   Tue, 8 Oct 2019 05:55:58 +0000
Message-ID: <20191008055555.GE5855@unreal>
References: <20191007135933.12483-1-leon@kernel.org>
 <20191007135933.12483-2-leon@kernel.org>
In-Reply-To: <20191007135933.12483-2-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0096.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::37) To AM4PR05MB3137.eurprd05.prod.outlook.com
 (2603:10a6:205:8::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.137.89.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d507a1f3-c76c-476a-0683-08d74bb4311a
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM4PR05MB3123:|AM4PR05MB3123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3123674F6E7F34401C4B21F0B09A0@AM4PR05MB3123.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(366004)(376002)(396003)(346002)(39860400002)(136003)(199004)(189003)(316002)(66946007)(81166006)(54906003)(14454004)(81156014)(110136005)(64756008)(52116002)(76176011)(66446008)(478600001)(229853002)(99286004)(1076003)(66476007)(66556008)(6116002)(3846002)(9686003)(33656002)(66066001)(33716001)(6512007)(2906002)(71190400001)(8676002)(25786009)(71200400001)(256004)(476003)(11346002)(446003)(86362001)(486006)(14444005)(5660300002)(26005)(6486002)(4326008)(6436002)(6506007)(8936002)(7736002)(305945005)(186003)(4744005)(386003)(6246003)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3123;H:AM4PR05MB3137.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XVuHy+DJo5Usj9VQHOzj4eJXUEI0oxL4vIJB9AZd1725fm/geQlReNNxpLW8ylJ+GYACiAe6GaR/12tQEWqBMikZGC3g05sE1w5wevqhEUG0gUOa2XyCIZAKpB82fnNCxztL2IjLVXiygNg0kefbtIMtr/XRWUZMLJPXmPNcZwpM2F8g28hLYTZ6HuG1R9xcsEH6Fq2eMf6zUJYpkCSCGvehlF9nUozgLHmz2Zjduu+IsdCW0/jDNZdUzqCvPZfKQQVRAJd4ZLpmRGTHg5oIA+3z6URRge62BiY0xS71M5g6OSVSlrY02pMPtPHgZLblZP4IiIbPjQsFcXYOvLeII66ChebSEzY3I0XXO+T5IzNDSUsRIW1GlBNcZ5GhEiNGIE2vw3EJwSew7B+zTx5OpbcSfa5YdDAyP9wF8zvQln8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1C58A6E5AB404B4AA506A41AB11070FE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d507a1f3-c76c-476a-0683-08d74bb4311a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 05:55:58.8758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mn8BH2vocDKPt/okaC1Iz07LNan8gfC/IxsjK+u/a8gDJZUfN0reG4DWEL7YuCSb7BA0RIzAiRPlAqM0rKtrQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3123
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 04:59:31PM +0300, Leon Romanovsky wrote:
> From: Yamin Friedman <yaminf@mellanox.com>
>
> Expose maximum scatter entries per RDMA READ for optimal performance.
>
> Signed-off-by: Yamin Friedman <yaminf@mellanox.com>
> Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  include/linux/mlx5/mlx5_ifc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

I'm taking this patch to mlx5-next, since it is not controversial.

Thanks
