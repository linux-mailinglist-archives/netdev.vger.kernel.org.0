Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEFC177871
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgCCOKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:10:52 -0500
Received: from mail-eopbgr30066.outbound.protection.outlook.com ([40.107.3.66]:51140
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726079AbgCCOKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 09:10:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HD9M3r/TLdG2wjK7lhnJsw5DFdOABl5hyO/DyTnHAAeEYt10oJnqLMDKYYR4/uFWya8tLpld2g/gnr28PIwtoi+RD1lwKkdR6cdr6l+TvBjKlvERHArmlyNEXuY+73UC66/uhLpB25f0B9zVyjjdg0x289BlaGWgNbxAO8ErLnmF2NePzHo6DdLPf2lzp0om1fUXjOAM+zGjjI5KXTQNbRzOB/imIe/aljZR0FDzAP1zPUc+qHGhfw0HaG2PJndaTFScPy4HxRRLXw+0PsXXL0ucEe0YJIFXUktMZtdcJC42rtj0ogtuMjdabsJOyBFkBnfNM3OnOR+gjyQaxqUcZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSlgJKLDeEYQf+oWE2tS9LdLyi15KuS4VOg59F4efxc=;
 b=L77qaoWgQoFYoav2lyxgsAOJV2pqrgiAwfSrT8qBDGJXYGYovPl3OyZ9gf64jk6QnQtbkb8qNBSvlMvKtB9cDFNzYJpgYFt3xVw5SIABD8ONbSNvlJ+Wo1zyuHwNf4DTmM3XZnzkJQHKDXpYGTzOSuAaCe3iwdeyqshF+/sxoRUZ8OhghJGHcZVZ5OV205cUu7PMXD4YaDGrbgFCjW2n/toJzjrADbkbeuvWIHLoVefYjWTmk+ztg32WllEbiAJc2i1SDZvODSoqzu8hVZqgQwUigVFpyFLXGQbvQxrRHHyqUMPiN8CnkrpnV031HI7xf1QjwR205YSsYzRjtiSlPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSlgJKLDeEYQf+oWE2tS9LdLyi15KuS4VOg59F4efxc=;
 b=bH+/95PqP412vQA4fy3YFze2u9TpMZNw5FaJT5r/M//6QILEDnHDiajEBjdEwVHVnlJU/LlaD2XZHWTokMin6jozDKDd3tQGtujztbVKZpqTZkpbq+WI2RD7UJ3im85lNOfWNP4pI/ocOgJswjNQ67u9R/CSce/T10Mg8CAcdWc=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6147.eurprd05.prod.outlook.com (20.178.112.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Tue, 3 Mar 2020 14:10:47 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 14:10:47 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH] IB/mlx5: Fix missing debugfs entries
Thread-Topic: [PATCH] IB/mlx5: Fix missing debugfs entries
Thread-Index: AQHV8WVHFBItap29JUeOqd2Am8bBcqg26CRA
Date:   Tue, 3 Mar 2020 14:10:47 +0000
Message-ID: <AM0PR05MB48666E6E18E435E4D947D475D1E40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200303140834.7501-1-parav@mellanox.com>
 <20200303140834.7501-2-parav@mellanox.com>
In-Reply-To: <20200303140834.7501-2-parav@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:5121:27a4:7e98:56ad]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f50ea9d2-1e09-419a-81be-08d7bf7cabdc
x-ms-traffictypediagnostic: AM0PR05MB6147:|AM0PR05MB6147:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB614770D66A03D924AAF829A3D1E40@AM0PR05MB6147.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 03319F6FEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(199004)(189003)(7696005)(66556008)(316002)(66946007)(66476007)(2906002)(478600001)(64756008)(8676002)(81166006)(81156014)(53546011)(4326008)(66446008)(6506007)(110136005)(54906003)(76116006)(55016002)(9686003)(5660300002)(33656002)(71200400001)(86362001)(186003)(8936002)(52536014)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6147;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sNJ8jywMUrWHVbkjPE8NFidxqJZmLZ0EWhTHOI1aQbpihJGWHcr+WkvxS1duHT1y9L/MmzRHB8WrKYFjoUABEc3ggErbOqWWyOmpZAKdRMLzFxDNMtMzG/SOlMcnNL568EBgWN4AoPj5aYMaApTwsEGSRgb0rKZJ150WN8clcadFPpQL9OQjbeLiNYp5unjRAJ5ZX02WYbGfbeA8rVrO7CCqm17MCtakalxMcOeO+JhupskoenHNbKH3p2vT8q70luacG4hGFwrArbwXlJTp+h6xmpBxc5iSAyzi98UZceXr9OCRS99wf529SbOtGDqxYJ5ETDGOIwWLMKJuFB+l9brxIUAQW9LaC8/6lzeNJTRx1C5e0JRcm+Ss0AAO2CmU9SvMPCUvL1r2XtgZWCALJNC80YimwCb6kW4g0tAfVjG9u6AUoUC7ibGswxlYnDVW
x-ms-exchange-antispam-messagedata: FWhAtAxFheyRy1kUeYJUApfzMK/OdTBl2a4r23lhlo5BOpcAriGPgfan5mhkN/idYUjl5+zE8Ulu+8eJ4HMlL99jU1DvS6vaK6AGp8evQOGrD+fauJ39N8ZQ/97iGmOr99qIcS737jl7DsWdGLehoqQi5SA/Wv3odQ4s88dRjA7LlG/MmAPWoRlQTZPYTb4TXrJBs/Nr/3nM/+VzxPXkYg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f50ea9d2-1e09-419a-81be-08d7bf7cabdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 14:10:47.4870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1yBnJG/p2rDevroFA0EpkF07w41Xw2oiAhs3n2ZKIS8Y1rQIXOlgZvs+BOxQTrKI7RuBWig7WbDVLJwwB3DZbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Parav Pandit <parav@mellanox.com>
> Sent: Tuesday, March 3, 2020 8:09 AM
> To: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org
> Cc: Parav Pandit <parav@mellanox.com>; Jiri Pirko <jiri@mellanox.com>;
> Moshe Shemesh <moshe@mellanox.com>; Vladyslav Tarasiuk
> <vladyslavt@mellanox.com>; Saeed Mahameed <saeedm@mellanox.com>;
> leon@kernel.org
> Subject: [PATCH] IB/mlx5: Fix missing debugfs entries

Please ignore the noise of this unrelated patch.
