Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4604417787E
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgCCOMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:12:24 -0500
Received: from mail-eopbgr50042.outbound.protection.outlook.com ([40.107.5.42]:50247
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727175AbgCCOMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 09:12:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NQdeCbRZ+FoRKIc1KrdqKZXvhK5JeTo23E4VMxiFrRA8NskbP4WQm7QH9m5rk29tSMsDcBQ1PunX9E5OEYAFMQcnfnZWXvEwhah+c2wGX3zk4GdxrDS5hwuKc/yHiRWDn+Szpij3hPurvwYYIQzHWlwZbRWZs8sZ1R485FwxQl7fNXgpFD/SdRMm3V1iRc4Uph75KOtypFF0iS2sO7VxYECjTSYe6bghOzjmTIdmmFMJw3qJJ9Gk4i2+1WOAA9f1kNX7OIdvviL4VCN3SJxrXHXREyrXW5vwvGdDUtkyXlm+LXT6sa7EV28n/BuCtziGaiz/DCcViWIuKpkslq0szA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkOKUjiBZjziQhoUjasMaKLGSUNqwMCLxFLNOKnEPr8=;
 b=lR7+bts8prs3nPcvg6GmLOwjhx181HRdxZdg4o47t1MVwqZEcsBkwk6igUpN8feTjnukVUbBPyvs/PLExgN/7H1Nf92KvE6UlETPAhOBDUzRuveVDr71YME7U/EYKw/BaplPlkpPr1pTrKN56IQJdv3PJVg7g+x1ull9VzdPpRpkc7yM0UoBEzX3CnHxbo++gPOBxZj3VfGrmWJalWr438vvJxTIFsMMkrvBeyTbyb/c0xEhz3kODpWx0QY+kZfyLKhvLGWBYQY067w0RdYaDeQPBcFnthSmM2GrBjqjGgVpnTL14uS8wheIQyqX0kSDCg8Wp3Qy2Ze+NXIb+cobkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkOKUjiBZjziQhoUjasMaKLGSUNqwMCLxFLNOKnEPr8=;
 b=bUw1ZBQEMRhbVaMvJtldX8P8YD+4Kprf4ee5aEwiQFUdt3l3fHh5pZGhy2mZBJgNukRjXtDqUL53SD5ZjH1ZZPtp4jTc3k4reDz/0W9ShfuYqrLjC4XLBaMlUBdXg0sUETxM/O5wdCwXkE9A6LueqnfEiBkUXj2dyO4dTBpIdno=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6497.eurprd05.prod.outlook.com (20.179.34.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Tue, 3 Mar 2020 14:12:20 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 14:12:20 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH] Revert "net/mlx5: Support lockless FTE read lookups"
Thread-Topic: [PATCH] Revert "net/mlx5: Support lockless FTE read lookups"
Thread-Index: AQHV8WVPyxUzyxzXk0+f6B8HdHHKdqg26KeQ
Date:   Tue, 3 Mar 2020 14:12:20 +0000
Message-ID: <AM0PR05MB486663958A8169205C33C182D1E40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200303140834.7501-1-parav@mellanox.com>
 <20200303140834.7501-4-parav@mellanox.com>
In-Reply-To: <20200303140834.7501-4-parav@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:5121:27a4:7e98:56ad]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 83ddb81c-8091-4d58-ad29-08d7bf7ce354
x-ms-traffictypediagnostic: AM0PR05MB6497:|AM0PR05MB6497:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6497DD12D5704621CC791D31D1E40@AM0PR05MB6497.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 03319F6FEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(199004)(189003)(66446008)(6506007)(52536014)(64756008)(186003)(54906003)(71200400001)(8676002)(9686003)(66556008)(81166006)(66476007)(7696005)(76116006)(81156014)(66946007)(478600001)(110136005)(316002)(2906002)(5660300002)(33656002)(4744005)(86362001)(55016002)(4326008)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6497;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nwhF/XjsL+cx3kh8IhwqLTt5oMh1+7NSKv0MyxVOVadARBEZov00nFVjvAMF8Yu2Gypf1h0P6Eyxv5a9M2VnzgUQKRllTCWAn384OQO2nCQiTPKf2Ue3x9NQij/o++CZgDp2hJAhPM23FkiSjJNu8cAEiyPWkD2Cg8j8VAdsrERXydAEIsfiFP55z8qmCzHPeCgj2/G1aJ32a4hzzIvnidHkgAt3/wVN1sxvZwytsKTWdrVwRQ1zVpG8KZez5krHYkJVaQlCbD9lKLzFu2PrKz1C3uEKNVXlZUBeJe4R7j2UhOLm56+QyqgAyRvimOWK9CHmpb9tQPqHTBt8GEmlCzz5pSCd1XhydhoTpHmtHYk6AQdHobDIoQSTC6/arvL81t7sWnvIG/OU+FnuVUHFhqZbnP2QkUvgwzHsnKvzZ5X39s/kvGEmnmyMYWHMGQkw
x-ms-exchange-antispam-messagedata: dN+gJPq8ADq9j+HYF6feKkJbLlIE+0CRy8K+DrpU67UVxq2/XsfH6W/iJ1SqEyeyfQ7KpG5J3jb3y4OSzBBu8ymiUKY6/0zTZhXJdJ8YoBOHz73yvsFdEt+ICKDFh4b/2iBedQJRxH6F3SQyF8DwlPu70GTQ/2Nv4hTBhWZTroWz62huPYxdGjpitYjtibD2bsBfQvdPmREuDN7Gu8Wp+Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ddb81c-8091-4d58-ad29-08d7bf7ce354
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 14:12:20.5272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NjmZo5xVBtdpktlYHawK3nsNilYov52sAR3ZJrBGHJ++EjtOPhVC2QmDRL440PwM8aiOam4lfQqR4AcOYCm/Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6497
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> Sent: Tuesday, March 3, 2020 8:09 AM
> To: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org
> Cc: Parav Pandit <parav@mellanox.com>; Jiri Pirko <jiri@mellanox.com>;
> Moshe Shemesh <moshe@mellanox.com>; Vladyslav Tarasiuk
> <vladyslavt@mellanox.com>; Saeed Mahameed <saeedm@mellanox.com>;
> leon@kernel.org
> Subject: [PATCH] Revert "net/mlx5: Support lockless FTE read lookups"

Please ignore the noise of this unrelated patch. Sent from wrong directory.
Sorry for the noise.
