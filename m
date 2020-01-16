Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35D4113DCED
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgAPOFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:05:01 -0500
Received: from mail-eopbgr60055.outbound.protection.outlook.com ([40.107.6.55]:40023
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726084AbgAPOFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 09:05:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gs9gEU70Y8k/ot0j4v5OpyAXdhw+XfFodCC+kPFt796PBFRpU+1z2sAJC+AvOewN86KJZYBh0oIWWhSNG4TbuTVH6ScGHab0jFAORNXJn1zNvMdVFjQMJVxoReYmzJGyEUIXX0PavMbOwT/Ls32OHvx6RRahAkWkF8KvG7gV9D9sbXqMju88/qcwu+CtMP2MiePqVLfe9p8+aDqWpesJXy7hy/s6BWMJO20x4WEzjRr2Rip9BffUjG/LdLLMFGs4kh6/POI5+e1nuc9OgKHosmWRV2F4ooNxTCiP0rzk3NTHWxM9xDQk5v3A2CnPA6lYd1DPkyOYbbZitf811Crzuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFo4Sked+yOeGGn22IGPjnTDVwEEPHTXBoqSgIFkAaQ=;
 b=K4ZIzGDB7vRe3h/73Dl3fe/R5rNn6IbSMRiuCVklGCnWw5vJqA67GIrmq5mnJW4eH5EPciBjqmpdFOffMtgZ/BdiESs9c8eb/tBhQZcTKCVOIusyb88NPf6AHJz0NWT3c0HetDoiYxuUoUtZQDT6UJQxkQxHZ3uA8Mr2mjCXCtImOAQVjAn5RKZMIad9TevcPhGsAnO/p28tTeKWJUkFzsIg7Fg3Q6f4k6HWAGQfwKJChinBVdItAqmCQEW30aUjm2jZdmcnIStsoyqTdnEI/QAqSpeN4lzeWxX5k5J8riFUqj/fv2PtBO0JXWSwYBXQVu0PZMWErxbPOBjW7Sm44g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFo4Sked+yOeGGn22IGPjnTDVwEEPHTXBoqSgIFkAaQ=;
 b=PEtYgq0HDt1YqtWikD5z2rdePkKwcoyIey2IvyKC6570fzpPB17lnw2Fw6FM7zwZ8ems79/rd2Jg81wHH2KwcM8rpgqokJEdXj1r04xUrkhNSgw1+U7Mgug8l0dHSBjjQZz+3xJxypBXRkRw+mes5Xx9jXMrKPjpHb0qaDnMYmk=
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB5603.eurprd05.prod.outlook.com (20.177.118.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Thu, 16 Jan 2020 14:04:56 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::d1:c74b:50e8:adba]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::d1:c74b:50e8:adba%5]) with mapi id 15.20.2623.017; Thu, 16 Jan 2020
 14:04:56 +0000
Received: from localhost (2a00:a040:183:2d::810) by FRYP281CA0011.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Thu, 16 Jan 2020 14:04:55 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 00/10] Use ODP MRs for kernel ULPs
Thread-Topic: [PATCH mlx5-next 00/10] Use ODP MRs for kernel ULPs
Thread-Index: AQHVzDp/CSjR/DYOQk+aO4L2fYjfAqftUTaAgAACK4A=
Date:   Thu, 16 Jan 2020 14:04:56 +0000
Message-ID: <20200116140451.GA12433@unreal>
References: <20200115124340.79108-1-leon@kernel.org>
 <20200116065926.GD76932@unreal> <20200116135701.GG20978@mellanox.com>
In-Reply-To: <20200116135701.GG20978@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FRYP281CA0011.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::21)
 To AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a00:a040:183:2d::810]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6de1a7d7-3a23-43d8-e7a2-08d79a8d10ae
x-ms-traffictypediagnostic: AM6PR05MB5603:|AM6PR05MB5603:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB560398D9DC48DEB98C77D23CB0360@AM6PR05MB5603.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(199004)(189003)(66946007)(9686003)(66476007)(86362001)(33716001)(4744005)(5660300002)(66556008)(6496006)(66446008)(64756008)(71200400001)(54906003)(478600001)(316002)(33656002)(6636002)(6486002)(8936002)(2906002)(16526019)(4326008)(8676002)(186003)(6862004)(81156014)(81166006)(1076003)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5603;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /Xq5+RNC2hI7qhiIkLXzYzWOeIEV+rGPTJqAB5hQXfPJUKPEqthFy3B9L3+JsyzcHvlLSAPRrTHBvJieyR+8K+Pi2rwDfdutS0Y4yhBubEVW5miHHtpx1lR7o2agKuiuexUmz8oGl9IULRu41rESks6k7zO9WD5Bc3DmgdwJ+3NpLPvfzVl60UYMf6Hfq/sjsm1RaAGiOLJCTLZ3uG/cNa1R4p9SGQX1TdJHj6soDabT9yEycGtHsGChoM4zDKJOAcdPeSWPksCDsJGJFDIMRgTiXyeMqnzqpXXGhGBjvjThHhkGJnKquSU15qZegtBPGpSunBH2EYh/yFTt/NdjsVGl1UWtaBCd1nqmVXuIKIPW+WBXyNN1SI1iqH8rHCXUlNtJFJw7sX4rnWFmCZjyUsRiuVTAdsfA2c0TQF47b6nMKOtUNu4EAaJOSApoGZpR
Content-Type: text/plain; charset="us-ascii"
Content-ID: <899AA8A1FCBB164EBBAC9024C0AB82C3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6de1a7d7-3a23-43d8-e7a2-08d79a8d10ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 14:04:56.4484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 65s/fd7Srp6sQvucUjwWI6Rjt783gXvPN1sAuV9T7IzHvNhdQUzhjye+mEnstEMNq2sY+Ie6NdDitM4uWICI6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5603
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 01:57:05PM +0000, Jason Gunthorpe wrote:
> On Thu, Jan 16, 2020 at 06:59:29AM +0000, Leon Romanovsky wrote:
> > >  45 files changed, 559 insertions(+), 256 deletions(-)
> >
> > Thanks Santosh for your review.
> >
> > David,
> > Is it ok to route those patches through RDMA tree given the fact that
> > we are touching a lot of files in drivers/infiniband/* ?
> >
> > There is no conflict between netdev and RDMA versions of RDS, but to be
> > on safe side, I'll put all this code to mlx5-next tree.
>
> Er, lets not contaminate the mlx5-next with this..
>
> It looks like it applies clean to -rc6 so if it has to be in both
> trees a clean PR against -rc5/6 is the way to do it.

Yes, it applies cleanly.

>
> Santos, do you anticipate more RDS patches this cycle?
>
> Jason
