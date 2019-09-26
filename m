Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0284BF730
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 18:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfIZQzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 12:55:15 -0400
Received: from mail-eopbgr60057.outbound.protection.outlook.com ([40.107.6.57]:33577
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727502AbfIZQzO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 12:55:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GE5EiHah/+sg3NIsQtQtzpPWu7QtZbSbeOfwN8dd9a3q1lhh5XmErsGHm0xzt5UfW9mF9eSAjypHA7cmVjI1oeIlunRdrtLT2+OSsLG6pT/XRYxY8ghCTXomGDRP/cHfeusNvvuDp2TwLlkQlANECqhmEHufCVdqYpyWgSuRfhw7+YstArHyER+Z2YfcCoJTaEL0KSiL7jHuqp33wAb8e9b7kleOm2px58e54IE+jsikyzhUTaAZwS5H58h7VcDCrn1G3ODkKQMD0Fjx0oP6IbfNuIwUDLQ3T4oRjx+CScHcnCMlXxD/myf/xh2U63xfgP1GKFo4XfbIPcAg4LoCGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bfx50sh5KsYtibjch64cL9+T3q5vASkdKkLyK3g+4t8=;
 b=ZmKWx25SyJrN3mBc/l6kCOdxhhkhH/PTCkPOwj1ZGUw6+DQKoBYdx4yGmdO2YvPKm7ssuVsl2CY89LkinWk5iCD4IXrkN5nNU3Ebqia4cDNTQNW6MPX8jDL5l2CaQDeqRg0+kn3hr6Ezk03cb/NlnROHTTSyVglq+owDKNE685Lqbcifon7EPwPOB0050Kan9I4noSMcwdvJiiLPElOXjBaSXJ4TbPsdZvf1XR3ZVCO0Eof9Wc2ZPr+fa/AabmV6jZcRqYTG1a9d5D6KI6nXI0bc6ZmfgxeIC+rV4fRnPTPbQt+lIgqeukkqcfd32zX/hVZrX+xbUZeDtdf1P2npSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bfx50sh5KsYtibjch64cL9+T3q5vASkdKkLyK3g+4t8=;
 b=ZpMKDjpK+065qWte7VyYAc6OW4G9TI9TY+7ideRmBi7lTs3htCW4H+oX6SZrxUyMflx5BlFxGkkS2OXWY3/loeFmAk03jlEHniDRCmvWwKvHtPFaMHXW/X+hvTxPMR07wXEDRhwb6XgF8rCgD1yLpROtPkxG9rYg1keQUBSheyQ=
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com (52.135.129.16) by
 DB7PR05MB4267.eurprd05.prod.outlook.com (52.135.131.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.18; Thu, 26 Sep 2019 16:55:12 +0000
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::502e:52c1:3292:bf83]) by DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::502e:52c1:3292:bf83%7]) with mapi id 15.20.2284.028; Thu, 26 Sep 2019
 16:55:12 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Thread-Topic: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Thread-Index: AQHVdInRxKc9Xqm18UKMerHkf/S7lqc+LTcA
Date:   Thu, 26 Sep 2019 16:55:12 +0000
Message-ID: <20190926165506.GF19509@mellanox.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-5-jeffrey.t.kirsher@intel.com>
In-Reply-To: <20190926164519.10471-5-jeffrey.t.kirsher@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YTXPR0101CA0038.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:1::15) To DB7PR05MB4138.eurprd05.prod.outlook.com
 (2603:10a6:5:23::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.167.223.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9102b08a-fb67-4631-234e-08d742a24bd0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR05MB4267;
x-ms-traffictypediagnostic: DB7PR05MB4267:
x-microsoft-antispam-prvs: <DB7PR05MB4267FA999CAF9E51EBFAFA0BCF860@DB7PR05MB4267.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(189003)(199004)(6486002)(14454004)(81156014)(186003)(26005)(71200400001)(54906003)(4326008)(71190400001)(64756008)(81166006)(8676002)(11346002)(446003)(66946007)(66556008)(486006)(558084003)(66476007)(99286004)(76176011)(66446008)(8936002)(25786009)(316002)(478600001)(229853002)(86362001)(6512007)(476003)(33656002)(66066001)(3846002)(6116002)(102836004)(36756003)(5660300002)(2616005)(7736002)(52116002)(6246003)(305945005)(386003)(6436002)(6916009)(2906002)(256004)(6506007)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB4267;H:DB7PR05MB4138.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: v3Jyt4ePBomooouO/mUh/NLegk3hYNyi9YWqbpqC82TBcXCWai5o1Jbk2TFylgz+5v8cE1PM2pdCjL+anuvXNW0Q0MjM9pMCwqfMdNXW5rwzFCudHcJsC7UgXVZUB/j7Q0YCGhOunJO03MMTerUSnIUYglBuK69HuFf/nfgqEVovXAfy27sFCYgXD9cKUQ/D7T9+sk3nKQKCzInblPg8ZmerGnJjja+qJBIissbAOGJ6BdWhQfMty2FqPNPNejxDHGn5woJpzlKU9jE8vSjVkSR8c3cA+GhPL4dw+R3n1SzRSoph+xltFor2j7EWI+3c4oU/sqEn0eSMMx2EmoEmcRSByWu0SZAcjuVmFtvrvHNgJECyS7Sqxm94vMVSF9Xw0UCUmTfQTnxVNlWQOV4ow10EB6LE44KcoiTKGv2ZIKk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A07FD34015D04E4293770E82927CD499@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9102b08a-fb67-4631-234e-08d742a24bd0
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 16:55:12.2720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OD95xV/HzYfOLBLl6IaSBrZXUxWYnxoEvewd2GYasSrKiGgrTyjg79B1QgAGEu4GXWJtXk9sbChfEESXYuKkNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4267
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 09:45:03AM -0700, Jeff Kirsher wrote:
> +int i40iw_probe(struct platform_device *pdev)
> +{
> +	struct i40e_peer_dev_platform_data *pdata =3D
> +		dev_get_platdata(&pdev->dev);
> +	struct i40e_info *ldev;

I thought Greg already said not to use platform_device for this?

Jason
