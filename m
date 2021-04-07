Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00702356FD0
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbhDGPGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:06:49 -0400
Received: from mail-bn8nam11on2075.outbound.protection.outlook.com ([40.107.236.75]:30401
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353326AbhDGPGr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:06:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ieZbNB/2vOgTAbNzbewh8HzB8nS50HH5DoI5VE9k5cDNWi/0DlPkaVZldU8Mos5pwgwbUssShg5Px2jcgjMGt7rL/O7hauVcgeqvHJAZfjcLq/JaG/PTAoR2pOw09mzxgNgnkBNtPsBSy/OxjlQgD4UH+g6bNSoLh5Ynf4isR+MKOEgSOIYwT4od14L1JYl4CdzKnxmlag8VCcX3XZWaY0AIxM+/RfIT31YVPreUNLOYeS5G8sNQphbKss5rwL8FAvj6q9YZsUFPflvIRaSK/SR81mY6mtVxgzy3tnMKeqCCObL/yLoAqP1TBMvz6rUBRRaK5e665HJAw50VctNh2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPQwxf67bL5nSAVrjUuRliFTISuv47cyiUmlA/zBR+Y=;
 b=GTgAkkA8rsUUp74XCkusRMzsR19Il5XaBokYc1vGkkW/xlyz6umN+pdew4gyxlGsht0c26pzZi7Z6f9rme5X6kwrzdL+VtXEKf5GLmZDhQm1Pev60nd+TDZWDHQxjBat2fKCBPsJXqHgxCOvZAAL+fZxax/eDLR8AXA7LYDZENHo+fcZUnYSIcQw7B9hW0tsrsZ3Vo8XXP54s/jbir5HcOC8g+LKg7J86uXgIgDCnhBBRtmaQVbr7nimRfxZYLQmszEhzLYU6L++puiQl4v6/yyIaPGkfcavZEHm8tMD7yuwd/VnTZM0JyQeqLLMGOGfyjaiBJyyq3M4DwzR0Q/ADw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPQwxf67bL5nSAVrjUuRliFTISuv47cyiUmlA/zBR+Y=;
 b=ekUjTeKBHZeZKYZTQkWkgZoEWve2KSJ+AcPmdbsTaFzlehQPtSEJla1rCoLR70p0H5w61ZnedRs/P0Rxw3s9wLpWHXQAp/bh0Mzr1iUpNfMzo2rqPl1/zOiNheW29JFpRhAWX+BI/JBuf7EUQbs4qfryKQJajQ/ZkO7/5ErrG3QbYK4qaC63qGFe5IicHz2VGMMR9swMYTTqvdey/tjAZ6s3k+X9t28IChttfEk+YVvc+zNwhNStluptjDT8Yoh7nma1mu9ICH6F+gwJl9fJCmdBTBewmvX4N/rBmZCS5o+sU/467OlXB8Inr670RSMyFbAwL4KiCKD7ws6PI5jrpA==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2998.namprd12.prod.outlook.com (2603:10b6:a03:dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Wed, 7 Apr
 2021 15:06:35 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073%9]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 15:06:35 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: RE: [PATCH rdma-next 4/8] IB/core: Skip device which doesn't have
 necessary capabilities
Thread-Topic: [PATCH rdma-next 4/8] IB/core: Skip device which doesn't have
 necessary capabilities
Thread-Index: AQHXKd+XJ6WIY5+vZk6+h+s0LuIetKqnpFkAgAGBvmA=
Date:   Wed, 7 Apr 2021 15:06:35 +0000
Message-ID: <BY5PR12MB4322E477DA2334233EAD5173DC759@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210405055000.215792-1-leon@kernel.org>
 <20210405055000.215792-5-leon@kernel.org> <20210406154646.GW7405@nvidia.com>
In-Reply-To: <20210406154646.GW7405@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [136.185.184.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1aaf124b-ce13-4218-45d5-08d8f9d6bcaa
x-ms-traffictypediagnostic: BYAPR12MB2998:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2998D61AB4123C0005A98FE3DC759@BYAPR12MB2998.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3dbPhjw6Gw1GTwJfDaCjKekA8j9FJ5roQSoi+BSATG7Lig6S5037Tey9PMmgPhHe3ARwn8jOEkfWcDs7SAQWa6CauO/JsZ83N8nVmDI0bHNuLE35kRt2F/nwtrs8P1IKtnwBYS8DZd8IJv8Jw/xlauo7esKWSMC4ELaXLm3Nd5IuXyZxjZ3f5ACNGIqDU87AZ8sej840XnXfnuqyOuX7li4e85En9LZV3YIalqRy9pRWTMlmCKYTrVry2rQGxQO4x1WxTW7h5ilyiCl1UNAMNgHqEdh6syPteHAfJS7MBBvb55Cm0e8mdrIG8bvQa78hXVtyhTMUQpWhZFGRlNRDBma/rs7c6HTOJHq87hWXOGb5nwxPvs5ghDOG2AdHsskWG/1ZpKBE7MR7VJ+NGxs361qLsuzK8aOnNf8wFhz62YQxO6RtC2W46GTTh+Cj2Jqyra72ZZ02IqKijB94fwIk8aCm6OKEx++ypWdY1Ip/h27qK38oAktp2V9YstZyLvPk8lUPknCdfbxgL2XKin6uyHt4RuuJjLybVS7QlT25ss9MTjwy6N+Gz04v37SyGFqg38zbIYUsFSYi5pWr+y0Hb/NLsA2+PLDzVhO/UuwlvQP/RLdH+NqtNFqPTsa/s785B7r4S1WVZcge3KKk4k6Y08qZQrMcHyJu3770aytFDm4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(33656002)(66476007)(4326008)(66556008)(64756008)(66446008)(76116006)(83380400001)(6506007)(66946007)(186003)(2906002)(26005)(55016002)(7416002)(110136005)(71200400001)(86362001)(7696005)(8676002)(8936002)(316002)(54906003)(478600001)(52536014)(9686003)(5660300002)(38100700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DompcuChYy9tPt6OBk0vZcw9Ls7eEmkoDQamFnyiqjdJ1Z1eBv+Kr8XKAacC?=
 =?us-ascii?Q?th4dWM2cGm7/QWCL+q+KZ4au9dalMJv94TRn2/qLVbq5R7ULvxdKcXzZupsD?=
 =?us-ascii?Q?bHhaJ98I59kZNbJLLOl7V5GDafzTXMmxyWWMzKkfVhuZY6534t/mp16uOQ6d?=
 =?us-ascii?Q?1+zNELfVXhKuEBKkarhxx+9zIPhJV7OZ+3wR4oQ+NGWT0QJ3+z/1/L3ENTtG?=
 =?us-ascii?Q?gG4RiQfxCQPcRUmBFP59BR4nDpw4EqH8r8cI/9fzNv1wSivlASdjzcizVUbN?=
 =?us-ascii?Q?zvB81wyKUsMM5awAa8ik/CELF3s/TFxElAeY2YA5BfutqmKX7wZmwiW/H+sT?=
 =?us-ascii?Q?VHSTMTcPwehjEMBOqunPoSlZ/8cnQC1dYLTXaBV09gpCeLm1Yux9jfbEKOLN?=
 =?us-ascii?Q?ik8oHRNAG+L7YVdkWVoNqoyTs0u/fxhurrWeY4XDq8wFHcurana7gD7vj5mg?=
 =?us-ascii?Q?68mlW3z/AAY6vELzBhclVhLTH5/ZU7u/38smmZUyfRWjW1Jf1iNt3J9Ic3Nm?=
 =?us-ascii?Q?5SZCFqhqg3cDSR7t249xcRkT5Zce8fcKCycPi4HW2WPJKvJhQTtGKCnVf1j8?=
 =?us-ascii?Q?cWviHJ8dpCirTx2IE19FC1JC6QwMhSg5PPihbUdDQf4kIN9BDu5Af2ADk5WS?=
 =?us-ascii?Q?2Mdyj6V/sNU7lPyF52ra8hWbDM5wNK38853qQY0aYoOpaEGj/fZ1nclkJGOU?=
 =?us-ascii?Q?59QQ8PcRz7SJWKjpGuTLgPyhi7uhcoJLkM7ApRGpHicKwWh3uEDWM0rNaSZW?=
 =?us-ascii?Q?dzmk5imriGvBu0XCI15jdGTm8+tX5/2h8utkfXZspnKC0t6rRnZqpt2HC1dP?=
 =?us-ascii?Q?aQTYaBKGuqBjIASMlwbSjZRUDIkt99fvqofck52d0nb3SReGKtqkFybZcVSk?=
 =?us-ascii?Q?ApXGxWV73d1es8HnT6MzhbKimXnk29JWp8L8jil+SZn/QOR5+e6nVK3QmrSA?=
 =?us-ascii?Q?kf3nfx2ft0HqxOmRe6+SeyrE/XigNfq/v+LDOmtk82HMCFkwcFF+6LRJeaOm?=
 =?us-ascii?Q?rQAsSPfC0KHjgTxYZvyxlxfaeag60NtTXgkR+r/MdoD9clOj68cI+P3nvt/5?=
 =?us-ascii?Q?02eP9j4aCVFL6zlbscWxRCpQe5T5aPpUTdzS81fYmR1JVaM2jdkSVuTkd2pL?=
 =?us-ascii?Q?3y5FdZsM5PiVY0ZFP5Z1chIvMmXN4/HBSo+7NKdVbp52Ga1hBpvG7+yYE9NW?=
 =?us-ascii?Q?hswF7Xz8cKlmTv42wT4Vf9NB8+yJDp8ZSQN0Bg6NxFEsXo2b0p6lMhEPemeO?=
 =?us-ascii?Q?O4tSdHxLiaDBaJA7T0v+qSiCOV+9KgFJc5lNuQ8GdeBS/OgSRdZt5rvNi3BG?=
 =?us-ascii?Q?/SKCWmOY5YHbWTbQ0wZTWs4f?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aaf124b-ce13-4218-45d5-08d8f9d6bcaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 15:06:35.5492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AQDhr0KAWI+5unAdQKJ06ltjYROdu8SLiDkk+94saYL9Tx7qxDqVRgIsEPVguVL7ITdIViKyi55upOLG2jI0dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2998
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, April 6, 2021 9:17 PM
>=20
> On Mon, Apr 05, 2021 at 08:49:56AM +0300, Leon Romanovsky wrote:
> > @@ -2293,6 +2295,17 @@ static void ib_sa_event(struct ib_event_handler
> *handler,
> >  	}
> >  }
> >
> > +static bool ib_sa_client_supported(struct ib_device *device) {
> > +	unsigned int i;
> > +
> > +	rdma_for_each_port(device, i) {
> > +		if (rdma_cap_ib_sa(device, i))
> > +			return true;
> > +	}
> > +	return false;
> > +}
>=20
> This is already done though:
It is but, ib_sa_device() allocates ib_sa_device worth of struct for each p=
ort without checking the rdma_cap_ib_sa().
This results into allocating 40 * 512 =3D 20480 rounded of to power of 2 to=
 32K bytes of memory for the rdma device with 512 ports.
Other modules are also similarly wasting such memory.

>=20
> 	for (i =3D 0; i <=3D e - s; ++i) {
> 		spin_lock_init(&sa_dev->port[i].ah_lock);
> 		if (!rdma_cap_ib_sa(device, i + 1))
> 			continue;
> [..]
>=20
> 	if (!count) {
> 		ret =3D -EOPNOTSUPP;
> 		goto free;
>=20
> Why does it need to be duplicated? The other patches are all basically li=
ke
> that too.
>=20
> The add_one function should return -EOPNOTSUPP if it doesn't want to run
> on this device and any supported checks should just be at the front - thi=
s is
> how things work right now
>=20
I am ok to fold this check at the beginning of add callback.
When 512 to 1K RoCE devices are used, they do not have SA, CM, CMA etc caps=
 on and all the client needs to go through refcnt + xa + sem and unroll the=
m.
Is_supported() routine helps to cut down all of it. I didn't calculate the =
usec saved with it.

Please let me know.
