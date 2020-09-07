Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE489260332
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgIGNRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 09:17:37 -0400
Received: from mail-bn8nam12on2040.outbound.protection.outlook.com ([40.107.237.40]:7520
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729350AbgIGNOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 09:14:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUiR9tgAuG2KoGizOhxioxT1t0i89QdXYz3IA3l1PgG7GbtTE1HsT7gYzMB182qtBNzrsXms83MK8uhzWtRlyX/Kkqi7lkG4muDXU7g8Pq2XDcoJFanX6uihprD25Seu2wZ2QvXHRH6TXj8kOvxvqSMQYRMOnNECpmMA3eUPAD4oRaIG19qk6XrQllSdVZYGOES5+2gb39LAkU3fnMgGYMLy30OB648JAZSwQGKLaXlKVnYriMAR0+CkvLOxa0V8dC60XbaerjzYeVgwtQ6FtXmRV9R9jHUnho1pOgjNNzuB2h0ddg9eSj6rNybawiISxHCsbEx+Es2AtU5VAMyDeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIG5nVSXmNiQ7oTb/9BefAzF/VsuaPjwanUnnCP/+08=;
 b=n01rB0iCVPVS8FbbC9YSwaaONHlhItA1utZ2BbOyynqBgaoHua1uKCjVf3Gth2+Zh/pbCaqbNeb8F4n/RHcy6cN8qnI3gxAu7rT5Kva056EKbKVfT1xrMIUEIJkK1zX+o9X3js58TFqHUrmF9TlG8CUgoZplN8Z+QbMQJRrDxzh3ajaSCwET1M9BJa9w3QCdwG8/2YNA1jm7ElMwT7MYOUD+wl+qgZEp7PBldzMspmyMXLL0sDrV0bgb0tLCRe0ei2i0NM3D8y9iRGZcTXCodVhLHOM2KshUsgCfFLXIIZ/AxT69Q1ZH1U9mGgBMIHIB0+8XQ7oISKx1y02+2xrtsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIG5nVSXmNiQ7oTb/9BefAzF/VsuaPjwanUnnCP/+08=;
 b=eQBtiDgJJ+daRSBWsRgnG+PmfkLorQj1JNrFP73mCwBvZj/O+mIN2fM84AckC4ewjxuJSKLgQwQKR+gZo9isZO6HwY5TQ2gvw799Z7suoyVX6B0eSDBIiqo6AC02hqGIDI5JwqEeX59Ii2elLOZlNXJ/a2nqcl5YK4rXUAvHBMk=
Received: from BYAPR02MB5638.namprd02.prod.outlook.com (2603:10b6:a03:9f::18)
 by BYAPR02MB5735.namprd02.prod.outlook.com (2603:10b6:a03:128::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.19; Mon, 7 Sep
 2020 13:14:05 +0000
Received: from BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::895c:ca2a:bd78:8c6b]) by BYAPR02MB5638.namprd02.prod.outlook.com
 ([fe80::895c:ca2a:bd78:8c6b%5]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 13:14:05 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Michal Simek <michals@xilinx.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: xilinx: remove redundant null check before
 clk_disable_unprepare()
Thread-Topic: [PATCH net-next] net: xilinx: remove redundant null check before
 clk_disable_unprepare()
Thread-Index: AQHWhRc+nua2aTQ0EUCz2lx+OASiAaldJw0w
Date:   Mon, 7 Sep 2020 13:14:05 +0000
Message-ID: <BYAPR02MB5638CE555F06629B3EC83043C7280@BYAPR02MB5638.namprd02.prod.outlook.com>
References: <1599483723-43704-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1599483723-43704-1-git-send-email-zhangchangzhong@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=xilinx.com;
x-originating-ip: [149.199.50.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6360e526-48f3-438e-5008-08d8532fe5d7
x-ms-traffictypediagnostic: BYAPR02MB5735:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR02MB5735E758ADAB2D545B19B420C7280@BYAPR02MB5735.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J/me3vKBoA4mDrbGOUqa1f+KVCkwkkJ12bSHQhY6TmGJP+FbdOW40Txi4p+rWIfFj+DFuZt25vjHPMK0YcdXceJIFID918U22nbGogjDsqKqiq8b4fkStsjTSw0wYIEt+ehoWQGzKNBZu59p4EqNakBNPJYpxrhmtfRHJV4oDzR7cNf1k6qHpzYtUpCT5jGC/Bcvin2KPBGbhXovTKzzIZKP+IgMG0GrdAvHyDMgXEx6unfYonzo/qrU8UW/idJLf7Jv17JRVko6WDIXlcKWJNwCyZbw2NdIhxkTtcA8O3xdfBn9lJKlc2AvP/CKIaUmszt0+IZTED0NKSKvQIXXsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5638.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(136003)(39860400002)(316002)(5660300002)(71200400001)(66446008)(66946007)(66476007)(76116006)(64756008)(66556008)(52536014)(2906002)(33656002)(9686003)(55016002)(54906003)(86362001)(26005)(186003)(8936002)(110136005)(478600001)(8676002)(53546011)(4326008)(6506007)(7696005)(83380400001)(6636002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: C0Qz8Z3PVYh0tVCjPq0EF5xRUhBujKjR0uKo3PcFwhIw4NHxfRWBtqiQonOZIuxeZhuvRDzL9SN6RxHrXhmxd0/H9gfpqmtUrjI8CUeCqnI8AyAqPziVzCLfeECo+qRGNwmnq5BnJF2hkLvaIU/uVxxDyAbT6ea9ebGNb9dP1sezo3/064IjjEJvQ72alxQ3eIIp+C/0KOGnwDnYXxVUMdGeuF58s7ukUbKGIu9x5iGwxgFhpsPwU2OczOZcP6ZcJrhNTbnS61CsghwL/AelWEg07z7c4m+nX0sqpwTCuKJ/ZhEg/4BxbpHXJK/xkBbwY7k9pWI4zqBVT4VxuPs/GM1eDzwkUpJr4q/YISDr6jGoftCoO+MQSECB9vqmEBdVki8MEFX3swPtONxbiF6bJLtp8qPK+ASYD6Mt5aSBJzyS5+Gz2KkitrMvS0UYVpvtJg5FisgRfRWrRrsYRyAz9VrkDHJa3Y0yb4PMzTm3kBRGRoQCH3sfQltZDNIGEF6PvadAVQHX1MnWYTziwokbTLgWazSFHmnp8LxCi3TGDsP6tMkaTWA4Z9DAUB8g87Og+YhjM1bHNEqeBadH7pTJBJCnALO2o9Ggmy2jBxcG4I+9tYITyOpDSKEnvApt0HDo0wciij5z3lCh8fGfEDIElQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5638.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6360e526-48f3-438e-5008-08d8532fe5d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2020 13:14:05.5577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cVp/5/XpnFWFhqZykun/wr5Vs0vYyNLC+lGRsoeUVXusU2pki36Kk/erQCEDYlXEFTZjpWUwLiCZCg3gp4gXZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5735
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Zhang Changzhong <zhangchangzhong@huawei.com>
> Sent: Monday, September 7, 2020 6:32 PM
> To: Radhey Shyam Pandey <radheys@xilinx.com>; davem@davemloft.net;
> kuba@kernel.org; Michal Simek <michals@xilinx.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH net-next] net: xilinx: remove redundant null check before
> clk_disable_unprepare()
>=20
> Because clk_prepare_enable() and clk_disable_unprepare() already checked
> NULL clock parameter, so the additional checks are unnecessary, just
> remove them.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Thanks!
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index fa5dc299..9aafd3e 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -2038,8 +2038,7 @@ static int axienet_remove(struct platform_device
> *pdev)
>=20
>  	axienet_mdio_teardown(lp);
>=20
> -	if (lp->clk)
> -		clk_disable_unprepare(lp->clk);
> +	clk_disable_unprepare(lp->clk);
>=20
>  	of_node_put(lp->phy_node);
>  	lp->phy_node =3D NULL;
> --
> 2.9.5

