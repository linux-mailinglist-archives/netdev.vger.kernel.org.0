Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D69FEAA95
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 07:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfJaGMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 02:12:21 -0400
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:25826
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726331AbfJaGMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 02:12:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZqcuIH5rVGvXRenxUF+4AAWWpUjFL9m/ogVIdm8stvMWBQRaygnoPFZLkgZX6k3G+BwNk4OQ8TkfJXSDN34NaLVpnMrUMQLBQ1DJydapx+PBrSO6q26SrHs7Pzv9iO2ckU9p9z941V072NxCImUYfQ0/FZN31EnrYjR0vsFujNaT+Oeucyt2pY/vXqouhNYif+ngCecb+wjVGzI5ksnn5WMZJP65t96TcYwnQvDtwflRgfLnBc+o3K3zjtY8exjKOdse7WJ9hSCj1OuziiSGOzInUMcp7Vkwosc1iH9t1D/7p/iHY9RRPA0Qg7U8XQSJgvMWUfw0poVrZrm4FkPFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bOvoe44Dq0K+S1/COnkCfoiqPi4SCRHyx4iW0PH1QsA=;
 b=Hc7GGheDtgK1bQou5RE3RcZjdFgshCPq0oGt0XnNfO27FPHGYRAyRFcRxLbyjGoI2EhMm+DMBt4y2limHAOn/o5ydUwYfPGMKXndlQZhjShlnavQv3HtVnKQDS3yQ45DDV2La7COrcDfpI10EfnDQ8zPKMSSG8gw+dKgirV+cbVaxwA6UMDdspaZQPj93pBoLnczwT9tLeBSpDTCdj2msxsMGHOCn3WOvTOaZxb6kj59rdyOJTXP5l4AOhQZ54a6z+a9xT99JBsRYlQuNCnscTd1qnItn0/R998nnmu3CnNtTkBGr7wm0rvFODut8AA6EMW4+n5T4DLzbDBi/iWulw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bOvoe44Dq0K+S1/COnkCfoiqPi4SCRHyx4iW0PH1QsA=;
 b=kJEpOJcwAh03LkuvJzZLSyV1WDQ3RyKZooyFDt/uXy0j97O3e2Qpym43M1NArIDMy5uZ2ACzS00v6zEfLMg/Q6xHt+C5QepnO1Qkdmn9PnhRD8y4bdrRlhziAXEHjtcXLoGhviRftquicNF94VhMvm9/krOpqYoN0bpNwm8etqY=
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com (20.178.41.21) by
 DB7PR05MB5019.eurprd05.prod.outlook.com (20.176.235.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Thu, 31 Oct 2019 06:12:15 +0000
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::6507:ac3:8106:3d0]) by DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::6507:ac3:8106:3d0%4]) with mapi id 15.20.2387.028; Thu, 31 Oct 2019
 06:12:15 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] mlxsw: Fix 64-bit division in
 mlxsw_sp_sb_prs_init
Thread-Topic: [PATCH net-next] mlxsw: Fix 64-bit division in
 mlxsw_sp_sb_prs_init
Thread-Index: AQHVjztoaMLvPWvKT0y8eNhXMe1WZad0Rc+A
Date:   Thu, 31 Oct 2019 06:12:15 +0000
Message-ID: <20191031061213.GA30422@splinter>
References: <20191030160152.11305-1-natechancellor@gmail.com>
In-Reply-To: <20191030160152.11305-1-natechancellor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0202CA0019.eurprd02.prod.outlook.com
 (2603:10a6:208:1::32) To DB7PR05MB5338.eurprd05.prod.outlook.com
 (2603:10a6:10:64::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 735e8c35-23bf-40cc-c423-08d75dc946a3
x-ms-traffictypediagnostic: DB7PR05MB5019:|DB7PR05MB5019:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR05MB50198DF0F51989DB6CC2D38FBF630@DB7PR05MB5019.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(199004)(189003)(256004)(81166006)(4326008)(71190400001)(9686003)(6512007)(305945005)(2906002)(8676002)(6246003)(66066001)(81156014)(7736002)(71200400001)(86362001)(54906003)(478600001)(6436002)(229853002)(76176011)(3846002)(99286004)(6116002)(316002)(52116002)(6486002)(66556008)(64756008)(66446008)(5660300002)(66476007)(6916009)(25786009)(33656002)(8936002)(26005)(6506007)(386003)(102836004)(1076003)(33716001)(446003)(11346002)(486006)(186003)(476003)(1411001)(4744005)(14454004)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB5019;H:DB7PR05MB5338.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JCQVPNYdioC0oM3k7WHZR2xgvKovJylc0i9t2urNOASVuUrqPRB1juKI/Wv+XWJR282iA/2HyI/BnmbuNsAU6LvhBHBoAJyDvcdCWXl1JWrphYvIpvgVUD0dPn0lOoUECFjU5Tky5zi9sjT0dHx+o0iL2zpbkkSwAMAKrqq57HQRd8FHQOTyVPviLur/jLoAkbWqY1k4BskH7DY9+M61R0xONNMm6xPP6+f7Mz8KpdBvol3SkpnFPe0R6fvtmp3qKWRi+wsEOXRggcQ3Df+snjJBQoHV9YzI1teImx/hY45bplBWt4vRLq/XxT+BanfAm21D1GFKm8kcIoFYt6Pa58aVoiVIcRc8QTmjaDRfhWrmyJkdFWc895iPqxUVcxXi5bBjnkI2MitELNkTMHOn8hVL2m2sjjXutuY3ARSgq24pSnP7sOd3pP5pfvEbZ5kC
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BAE5E7D8476F134AB27455CBB9C667C7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 735e8c35-23bf-40cc-c423-08d75dc946a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 06:12:15.3300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4DlkCbi41XeasQaLsQkUhDk6esfdjBQRlGL8IAFMzLIOvwZBCg1QM7v5NcRG0ZplXGepGwI9rvZaVKuRYuhZdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5019
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 09:01:52AM -0700, Nathan Chancellor wrote:
> When building for 32-bit ARM, there is a link time error because of a
> 64-bit division:
>=20
> ld.lld: error: undefined symbol: __aeabi_uldivmod
> >>> referenced by spectrum_buffers.c
> >>>               net/ethernet/mellanox/mlxsw/spectrum_buffers.o:(mlxsw_s=
p_buffers_init) in archive drivers/built-in.a
> >>> did you mean: __aeabi_uidivmod
> >>> defined in: arch/arm/lib/lib.a(lib1funcs.o
>=20
> Avoid this by using div_u64, which is designed to avoid this problem.
>=20
> Fixes: bc9f6e94bcb5 ("mlxsw: spectrum_buffers: Calculate the size of the =
main pool")
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>

Thanks, Nathan!
