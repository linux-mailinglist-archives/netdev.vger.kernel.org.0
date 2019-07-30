Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 445047A65A
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 13:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbfG3LAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 07:00:12 -0400
Received: from mail-eopbgr80083.outbound.protection.outlook.com ([40.107.8.83]:7426
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725974AbfG3LAM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 07:00:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbHhGEMsK4gPPrLfhBG3HYyEE5mvr3qYdbaidO92czXM2hQM/MEIbPoBHG6zb28xyR1kb2ihMUod2UkvaDqhWgOx9bsxRAxkIf97SFHyqAQpFYKNlPEj1mHG9xsgc4jyQeHZzoQjWb1/lPByNr2K6t14pZeBSh3IcSc7ujh7GvdtdXlymKs/5fGd/k8d0Bj1+/9K3iAfNpzHD/kqlRD7Y+e6GXDxe69TpyMcLA8kH/ivQf+vT7GXHpXMkGF9eG5q9XNHRtjuBxueZzZLPM6YByaajUOZfQoYm6RiAMdpZ7PIJVVKMaPTHvHMgTRxATUCNTM0IhyZ71GJTJ0OorOnPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XaghnOJNl4cmK8YUiQYoqg9Cotsj2zAuefEYTYQvN9M=;
 b=J/PcXmqcsUwKZCeM3/NWxLkxlkClxwKiEnA/BrgHEkld861xZt/ECIwJ2PYDWEDBBWpJDdI0vMjfpuQ1LEqVrLg0cfQQArFQKts0mZkvd5X102h8VyYxRII1WI7r8Eu5RFgDHZjAk14hvgOJZ20s3lfpe9aMJD1gWlOiTD0clZqrlnpyYTtW2eaM/tkrjEw4ShilEqTdeFllUHoREzgmXlY41sLzvARiclW3HlqHfCJ6C84SUQrVsScJ4v5kb7DN1czo4v/l9jc2GNdo1IAJ22Q93qaoSdsh40REydRa9wiANUYOFi42cNIiTiaDDoej2il+Qtw7R+b+Y7J2MVZ+tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XaghnOJNl4cmK8YUiQYoqg9Cotsj2zAuefEYTYQvN9M=;
 b=MZ7zpQ1Vy/664nebd49wlkxIcFUjUDotTFdCKaaX2p+PvzNFA2Wj3U8fCdtwvcZ7VPp9N8jgQ61T79en0eZky6wMG/AIYtoqkNXAGxD3vH9Y0GUbPTYUaYoXDCpi5nMnXomb+DdAvgwiw+jn4hzXBQICXfPq1wrC/6P5BaLy4KQ=
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com (20.179.10.157) by
 DB8PR05MB5979.eurprd05.prod.outlook.com (20.179.10.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 11:00:07 +0000
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e]) by DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e%3]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 11:00:07 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     Colin King <colin.king@canonical.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] mlxsw: spectrum_ptp: fix duplicated check on
 orig_egr_types
Thread-Topic: [PATCH][next] mlxsw: spectrum_ptp: fix duplicated check on
 orig_egr_types
Thread-Index: AQHVRsCGQQzG+jKZokepZOkvOqeUUqbi/mGA
Date:   Tue, 30 Jul 2019 11:00:06 +0000
Message-ID: <87mugvzt1m.fsf@mellanox.com>
References: <20190730102114.1506-1-colin.king@canonical.com>
In-Reply-To: <20190730102114.1506-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0202.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::22) To DB8PR05MB6044.eurprd05.prod.outlook.com
 (2603:10a6:10:aa::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [78.45.160.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 248f6bea-d2c0-4004-44b9-08d714dd14df
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5979;
x-ms-traffictypediagnostic: DB8PR05MB5979:
x-microsoft-antispam-prvs: <DB8PR05MB597994135849C186DFBB48ACDBDC0@DB8PR05MB5979.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(51914003)(189003)(199004)(8676002)(68736007)(2616005)(2906002)(316002)(256004)(11346002)(478600001)(229853002)(4326008)(14444005)(6916009)(81156014)(81166006)(6436002)(7736002)(476003)(25786009)(86362001)(8936002)(446003)(6486002)(186003)(64756008)(5660300002)(386003)(6506007)(36756003)(66446008)(486006)(99286004)(6116002)(66556008)(71190400001)(52116002)(66476007)(102836004)(3846002)(66066001)(71200400001)(66946007)(6512007)(54906003)(53936002)(6246003)(76176011)(14454004)(26005)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5979;H:DB8PR05MB6044.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5HOCsQ9JZ/h3fxBPwwvhiutBd9ovqYkhzUTzF5LB3tsDEG8OR7oIVUhzDwe7OIvVXbpzhsduWMDp8YPHm6GALBV/kY+XdmU/XGQeHXr0vzzuzv0hxJ87sW5Jij9znIfzuIxQ37Kgt0otefD5tbMwkZWaKDT2ucJyL+tTRVCRs5dy6MpdkgDarrIvF3d9xhyoqrIQzJRi/D1JNAIK4/68yyqSQUxmWdWDiRMJRUJ9QPxtsDt+skCslMYEjo/zAkFGmgeptOI6wM1RPvAvJLoFQhkd9riKQCnni520EwN0B9E5fxgugQ07hCEbG0Br6itpHgXtE7+I6cb2aVZLOBRKrPJ94n3ZrZO91QkBn4Iee7xIuAN2OQZIYUe3YY0ZCm5EEVVMF7+0uMjJywD0zP/SNH82UH5UUdl3ZDlNwIFlpwk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 248f6bea-d2c0-4004-44b9-08d714dd14df
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 11:00:06.9197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5979
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> Currently there is a duplicated check on orig_egr_types which is
> redundant, I believe this is a typo and should actually be
> orig_ing_types || orig_egr_types instead of the expression
> orig_egr_types || orig_egr_types.  Fix this.

Good catch, yes, there's a typo. Thanks for the fix!

> Addresses-Coverity: ("Same on both sides")
> Fixes: c6b36bdd04b5 ("mlxsw: spectrum_ptp: Increase parsing depth when PT=
P is enabled")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Reviewed-by: Petr Machata <petrm@mellanox.com>

> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c b/drivers=
/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
> index 98c5ba3200bc..f02d74e55d95 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c
> @@ -999,7 +999,7 @@ static int mlxsw_sp1_ptp_mtpppc_update(struct mlxsw_s=
p_port *mlxsw_sp_port,
>  		}
>  	}
> =20
> -	if ((ing_types || egr_types) && !(orig_egr_types || orig_egr_types)) {
> +	if ((ing_types || egr_types) && !(orig_ing_types || orig_egr_types)) {
>  		err =3D mlxsw_sp_nve_inc_parsing_depth_get(mlxsw_sp);
>  		if (err) {
>  			netdev_err(mlxsw_sp_port->dev, "Failed to increase parsing depth");

