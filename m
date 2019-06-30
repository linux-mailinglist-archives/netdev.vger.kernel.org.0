Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77DEC5ADE1
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 02:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfF3Ak5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 20:40:57 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:22173
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726956AbfF3Ak5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 20:40:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDlT/ipm1a/uqPT5WV7HzNtaQLZpb9RUfvKoyGWedA0=;
 b=IgHSG80jocTowmc7hqwQLR4ITfY5EXTCqMHfxXKEjKvFqzcUe58LDxYFyTDWocLqZEoI2qK2irFY5GBQ/hux3K+wxkXQhM3K69QnKSFo6M7B11mXBwhgnD4lG6kBEpTs9zvGXyA2qQQ9iwiCNGWe16iu/cM4vkSysOzjgAazsYo=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB4879.eurprd05.prod.outlook.com (20.177.51.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Sun, 30 Jun 2019 00:40:54 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2032.019; Sun, 30 Jun 2019
 00:40:54 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v4 06/17] RDMA/counter: Add "auto" configuration
 mode support
Thread-Topic: [PATCH rdma-next v4 06/17] RDMA/counter: Add "auto"
 configuration mode support
Thread-Index: AQHVJfsE3tKh9oGpaUGuOuzrE5Gb8KazbPUA
Date:   Sun, 30 Jun 2019 00:40:54 +0000
Message-ID: <20190630004048.GB7173@mellanox.com>
References: <20190618172625.13432-1-leon@kernel.org>
 <20190618172625.13432-7-leon@kernel.org>
In-Reply-To: <20190618172625.13432-7-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR1501CA0022.namprd15.prod.outlook.com
 (2603:10b6:207:17::35) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e10c5d3-4460-45f7-961f-08d6fcf39b95
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4879;
x-ms-traffictypediagnostic: VI1PR05MB4879:
x-microsoft-antispam-prvs: <VI1PR05MB4879AFDA96D5B624D9653075CFFE0@VI1PR05MB4879.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 008421A8FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(199004)(189003)(99286004)(102836004)(53936002)(76176011)(1076003)(8676002)(6486002)(3846002)(6512007)(6116002)(316002)(6436002)(14454004)(386003)(52116002)(71190400001)(26005)(8936002)(186003)(81166006)(81156014)(54906003)(5660300002)(229853002)(6916009)(6246003)(71200400001)(25786009)(4326008)(6506007)(478600001)(446003)(66066001)(256004)(14444005)(36756003)(11346002)(2616005)(476003)(68736007)(7736002)(4744005)(66556008)(66446008)(486006)(64756008)(73956011)(86362001)(66946007)(66476007)(2906002)(305945005)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4879;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XTQqBfcdD5kXx7p+qSbV5Q0Idx6IU/nvjbc5tlGzTP/oxpwsBmnpeDFmNQoIKX2f7QlgZZGJN86a5782vbb+9KKel1v3x0j/S/79b5Aca+UMRiq3XloCoLBOP4eg3wCxu1qlvpmdbKSG/yey9/cI1RxwGOjiabc6byNoXDHErpefRzyKqx0S9S10QeJoSv1xZuBo4lTnrP9T5IiLCCLd+KrOZjt2ctGQgtu79S/T7JjQ9Ss+7dV6pwbqMTW3pS5pp9fOcHzl/tb0Tl8ziVqQGJiP+ObWlSSWFAYJsW2ZJz+pWXbZtjlbYZG4agFjeUy+7+O6SWqyUzDtpUN656ewUl2PAC3FQZ+/fbw5I89VN1OV2iFbvy7D8fAVggyDGbku1Oen3BR7uJqdbh98mrqqkhIM8tAin71fykJR0etAVSw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A3580C98FF1F4F49ABD1124336F20483@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e10c5d3-4460-45f7-961f-08d6fcf39b95
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2019 00:40:54.1205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4879
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 08:26:14PM +0300, Leon Romanovsky wrote:

> +static void __rdma_counter_dealloc(struct rdma_counter *counter)
> +{
> +	mutex_lock(&counter->lock);
> +	counter->device->ops.counter_dealloc(counter);
> +	mutex_unlock(&counter->lock);
> +}

Does this lock do anything? The kref is 0 at this point, so no other
thread can have a pointer to this lock.

> +
> +static void rdma_counter_dealloc(struct rdma_counter *counter)
> +{
> +	if (!counter)
> +		return;

Counter is never NULL.

Jason
