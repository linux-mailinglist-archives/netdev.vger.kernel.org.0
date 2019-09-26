Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63872BF7B3
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 19:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfIZRkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 13:40:09 -0400
Received: from mail-eopbgr40053.outbound.protection.outlook.com ([40.107.4.53]:37393
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727631AbfIZRkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 13:40:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmc1X4MxfZsYIiH6zOFcmk+pBggIXCCWxgVxiI/xUIKIi5cc/BFKbh1eoZX/HFuDDsLSPtOtMLpCIL+0I0IXx9VJHC5X5qNmPIm9SffLEVa88r+PMr2HcP/kXUVYv+pTStGSLXG6kc2uXLb+X1Dwb+jtQmEAdEo99AdG1lAp10gqs1hnrULF4BJP/j1mw35cL/VzXXeWxgYgtpKdbAM1RnuFyIZTy54rLZXFvHCFmLhn9cbWa85ps9JQIfKl8nT78yL6gKRTALyRsbqRGZl9h4P5r7JXv5cdr4EU23FIPsAUGGiSJld145t/WuiKkVK1VZ9UmTAGHw23qSuwiMLvRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOeyYmn+Lg5cqX9Chhf5UbsWp/lJvXQmWLl0N81CQos=;
 b=TaJJDTcjUjmWkDKtAJ0ir3I2ywT8rpiYLSNMcaReAoNe1Dygk5d418St7wxwDXf8QPy4U1OorK6oCEDQu+K4fFIxcxX5aJOVzADRlTZ6bAXBK3UjztK+S0DVUNmJRoDvIWllcT6jE9eQETjWr6xHGqQ4W1abWBHJrldGvIp0a3bgbzgopUp+JYwhjoLRNUAhh16uD71G/dNjT/mGKxPh1d6CIKOv3c1xCORToRH835dK8cAazDxDS2PhLIZhGsspCFoNugglc4WwGjeShV2LEESNwDTmGzvxxhBE3M4qQ6omkL4qsSOXLou8AGvwuprF/tt7pOCmkWTxzQA9LhJteg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vOeyYmn+Lg5cqX9Chhf5UbsWp/lJvXQmWLl0N81CQos=;
 b=DxqWaAUEqYwmiqn4RyfrKUEo04fCL+XpJFWU+7pcx6hoBijVfcwoPy1DeCqtpH9Y9x+iiT2JxFJhwcmVdVb4XijZvreE5rC0KFkO5b5vs049GQem2aA79TamM2t8FV74H2iWeBLosTnR+P2IYkILRw9SqV+I1rXfil81XnISBm4=
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com (52.135.129.16) by
 DB7PR05MB4426.eurprd05.prod.outlook.com (52.135.130.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Thu, 26 Sep 2019 17:40:05 +0000
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::502e:52c1:3292:bf83]) by DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::502e:52c1:3292:bf83%7]) with mapi id 15.20.2284.028; Thu, 26 Sep 2019
 17:40:05 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
Thread-Topic: [RFC 12/20] RDMA/irdma: Implement device supported verb APIs
Thread-Index: AQHVdInU/wHVkWnGQUC6/z1Uc689m6c+OPgAgAAAzIA=
Date:   Thu, 26 Sep 2019 17:40:05 +0000
Message-ID: <20190926174001.GG19509@mellanox.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-13-jeffrey.t.kirsher@intel.com>
 <20190926173710.GC14368@unreal>
In-Reply-To: <20190926173710.GC14368@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YTXPR0101CA0054.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:1::31) To DB7PR05MB4138.eurprd05.prod.outlook.com
 (2603:10a6:5:23::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.167.223.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 298b3a42-d6e7-428a-9258-08d742a890f6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR05MB4426;
x-ms-traffictypediagnostic: DB7PR05MB4426:
x-microsoft-antispam-prvs: <DB7PR05MB4426302567708A17C0CC3933CF860@DB7PR05MB4426.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-forefront-prvs: 0172F0EF77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(189003)(199004)(476003)(71200400001)(7736002)(66556008)(36756003)(66946007)(2906002)(386003)(6506007)(25786009)(256004)(316002)(3846002)(71190400001)(66446008)(305945005)(1076003)(64756008)(66476007)(102836004)(5660300002)(6246003)(14454004)(86362001)(8936002)(2616005)(229853002)(6486002)(54906003)(81156014)(81166006)(6512007)(6436002)(33656002)(6916009)(4326008)(66066001)(478600001)(486006)(52116002)(99286004)(76176011)(186003)(6116002)(446003)(26005)(11346002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB4426;H:DB7PR05MB4138.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6Sv7OxRiw8nKqIeXrtFSeEYAK6BQOgAnAhLbQZOYoEMwnGga6uZNcewADEFgDQxo9p1Cn/R0Pq0xsz4QHE8DLuZuY7qxtO9UokgHFo/UJTJclhAATWj8h8OBpLwhVURSAWCH5YLk1pLBm0JUEtPBUeWf4fAssC5RYgN/G3WY7Hb4kDmSY6jd20rXM5D3vTviiQgOfDuLFtcdm9xZwgYw05MmD9ERkIiOSixUUDNbv7O7R6OzrJcabbT0iCLwV6HcDSPFOJo2fZS5VzKxSmC9IS7izgEcZp2OFYCnT1CQP2Xww2ZoQ8ii2XuAcIGmHmTY7kidOrC1tDSi0SiZoZXGFr/UBKd6EshqB00JAtE2T+xBZN7KnejWx8Ngw23qvrRaNY9HGxD/IKYgz1XZL12ZkzO2fneIqN2pa7EspWvh/WM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AB47F688C18ED2419FE7F51ABA87EB7F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 298b3a42-d6e7-428a-9258-08d742a890f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2019 17:40:05.2070
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nR0tcdGgg180T/VUxgEQY9hvQmetYsHKN3I7ivOQaWnqPsULcfrurCxUTiRA9s+RH7SdxVp8mkpXtZWVt/FgDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4426
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 08:37:10PM +0300, Leon Romanovsky wrote:
> On Thu, Sep 26, 2019 at 09:45:11AM -0700, Jeff Kirsher wrote:
> > From: Mustafa Ismail <mustafa.ismail@intel.com>
> >
> > Implement device supported verb APIs. The supported APIs
> > vary based on the underlying transport the ibdev is
> > registered as (i.e. iWARP or RoCEv2).
> >
> > Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> >  drivers/infiniband/hw/irdma/verbs.c      | 4346 ++++++++++++++++++++++
> >  drivers/infiniband/hw/irdma/verbs.h      |  199 +
> >  include/uapi/rdma/rdma_user_ioctl_cmds.h |    1 +
> >  3 files changed, 4546 insertions(+)
> >  create mode 100644 drivers/infiniband/hw/irdma/verbs.c
> >  create mode 100644 drivers/infiniband/hw/irdma/verbs.h
> >
> > diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/h=
w/irdma/verbs.c
> > new file mode 100644
> > index 000000000000..025c21c722e2
> > +++ b/drivers/infiniband/hw/irdma/verbs.c
> > @@ -0,0 +1,4346 @@
> > +// SPDX-License-Identifier: GPL-2.0 or Linux-OpenIB
> > +/* Copyright (c) 2019, Intel Corporation. */
>=20
> <...>
>=20
> > +
> > +	size =3D sqdepth * sizeof(struct irdma_sq_uk_wr_trk_info) +
> > +	       (rqdepth << 3);
> > +	iwqp->kqp.wrid_mem =3D kzalloc(size, GFP_KERNEL);

This weird allocation math also looks sketchy, should it be using one
of the various anti-overflow helpers, or maybe a flex array?

Jason
