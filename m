Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54AFD792E5
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 20:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbfG2SQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 14:16:24 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:63559
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728412AbfG2SQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 14:16:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQN3yZlSZny53sWLSFFMOLNAQppqU2UXidQxLFLehA7z5fEWAaI+l2S1XYSoJcrEjKZ6dX2bKHYYXKj8ycIBeNqEkUQ4YWLgJwIbsepF6H6i/h3xEKDuv7t/LuwIx1vWnBxHpZYItPBqlzvAz8xgpdlruPsTurxjRYrxk9NYv28tzhhm85D4fN9WyK5jd6ekaXYx8mqjEshUEq8SQ0luagSwOjQRjgBCrWFUMLbalqvuCNHOvA4wIzMnolCK4kb+iwK6BIKu8KBstXYxtVKgjcjaCI8LO+stC3ACrLAfJec4OG/T/BRr/GobL+IvD+L6SoYiz+h3KhkfDzzsobGxcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmO0ErvG8Oamhgx4daLikh5kuY3hF1v1/N/MF4ET8D0=;
 b=YlEVHX4pmTwtrh367E1xPX3tBtpiHMsSoKmTrJ3WzgL0qVSyKoq0UFnMGrRrbw39W1vZ15Vq/5957zzDd/CcJ4oaHMJ2Bkk+YMDuWLv8157xJ+OWtsOh05FkTBMaacDBO4S4NHPXxVmymWqdoexp1kTmVFE4OHLiKc0S9sNgUCzG/i6ETKBTkJUQ2MIdNW7gt0ZDQEKk6TWy9YQeqMQOwTWE739IbXJRqtDB9t0e7ByqxkpVavkgL6l/m3pmaM1ucCQJKSLGzN2fAR9Vbf7nc3ZiJVYSli1B570+OOEP0YQXTs8s5HQ5cpyaOrAG/ZKxnD2VQR8l6wvliAL5f9H6fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmO0ErvG8Oamhgx4daLikh5kuY3hF1v1/N/MF4ET8D0=;
 b=TtOuAMGqfv3zJaPpgUPZ2Qedq3NrhqE0f5Ns8JIhtjayd+uo5tDQdziu1iSj80nvpIF5golGYRZ3E8L3yAYEBsf1UxeULbmxIPCqQyIyyijwxGP+5gTP+DpnLv2o8LqT2k6Xw+UmBHCBTuzRmHmFZxo0gjoGr56+hIPA5mPTSIs=
Received: from AM6PR05MB6037.eurprd05.prod.outlook.com (20.179.2.84) by
 AM6PR05MB4934.eurprd05.prod.outlook.com (20.177.35.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 29 Jul 2019 18:16:20 +0000
Received: from AM6PR05MB6037.eurprd05.prod.outlook.com
 ([fe80::d919:6738:87c5:9839]) by AM6PR05MB6037.eurprd05.prod.outlook.com
 ([fe80::d919:6738:87c5:9839%3]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 18:16:20 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     David Miller <davem@davemloft.net>
CC:     "idosch@idosch.org" <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net] mlxsw: spectrum_ptp: Increase parsing depth when PTP
 is enabled
Thread-Topic: [PATCH net] mlxsw: spectrum_ptp: Increase parsing depth when PTP
 is enabled
Thread-Index: AQHVRKHGPnHHYnHCZEyMyBThj2SmFabh5JqAgAAFkQA=
Date:   Mon, 29 Jul 2019 18:16:20 +0000
Message-ID: <87wog0zoy5.fsf@mellanox.com>
References: <20190727173532.7231-1-idosch@idosch.org>
 <20190729.105623.1884187062066808743.davem@davemloft.net>
In-Reply-To: <20190729.105623.1884187062066808743.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0105.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::21) To AM6PR05MB6037.eurprd05.prod.outlook.com
 (2603:10a6:20b:aa::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [78.45.160.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ce9dbf6-8863-488f-e560-08d71450db2a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4934;
x-ms-traffictypediagnostic: AM6PR05MB4934:
x-microsoft-antispam-prvs: <AM6PR05MB4934918767D0F66074A2B753DBDD0@AM6PR05MB4934.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(189003)(199004)(102836004)(53936002)(99286004)(486006)(2906002)(86362001)(81166006)(64756008)(76176011)(6506007)(25786009)(26005)(8936002)(6512007)(6436002)(81156014)(5660300002)(52116002)(386003)(66066001)(6246003)(186003)(6916009)(316002)(14454004)(54906003)(6486002)(476003)(4326008)(2616005)(4744005)(71190400001)(71200400001)(256004)(305945005)(14444005)(8676002)(7736002)(107886003)(66946007)(68736007)(478600001)(229853002)(66476007)(66556008)(66446008)(11346002)(446003)(3846002)(6116002)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4934;H:AM6PR05MB6037.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8FFivaeLv4oT6weP97LMTvz/OgHNJFe1tfvHYQ2T8FDcWXLV7MbDbJXB7sd8FHm28QyjaXZLph1p/qCK+STInmTmKnNggbVDPuivg8HPNDHOo5JQdB+mqorI8E9NV8DyX42YVsBnI4u58BIMKRLqBo3bMDWnRFO/erXRI+GI/+5EwdVxYWEsuC7qQiOBM8FRgpCPZ2Zu1dU5mCe+CI3vprLPDycZl+iFU8JaYFVCpCMwpi3+gmD8KaYxfrvi5ZAnmaRAer3nRvcPJFzYvyyuo+iulxrYCLFpw+BonZNQAsxL6Z5lwABuOEWnOi+MBhvxxEXYQaI+LMWgiEY9KoZ8Gmhy8Pwo4Lq1i1CgYeeD3Q86a0s+pn4BuvqdTfB6mX6d2cmBjdzLfCUUfFJCJpMvtitJ/GolXL2AB68sgTdwzaM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ce9dbf6-8863-488f-e560-08d71450db2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 18:16:20.5104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Miller <davem@davemloft.net> writes:

> From: Ido Schimmel <idosch@idosch.org>
> Date: Sat, 27 Jul 2019 20:35:32 +0300
>
>> @@ -979,19 +979,36 @@ static int mlxsw_sp1_ptp_mtpppc_update(struct mlxs=
w_sp_port *mlxsw_sp_port,
>>  {
>>  	struct mlxsw_sp *mlxsw_sp =3D mlxsw_sp_port->mlxsw_sp;
>>  	struct mlxsw_sp_port *tmp;
>> +	u16 orig_ing_types =3D 0;
>> +	u16 orig_egr_types =3D 0;
>>  	int i;
>> +	int err;
>
> Please preserve the reverse christmas tree here, thank you.

All right, will respin momentarily.
