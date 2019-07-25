Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CACF75812
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfGYTiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:38:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53970 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726177AbfGYTiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 15:38:17 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6PJZ30A023518;
        Thu, 25 Jul 2019 12:38:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=Ot9xOlkGNv0UJCPdOSINMqBqFpnuRWGisKDhNvH7vY4=;
 b=REcyAIfWcOkVWhKLfPM1FrP7AN4Z/e8e+/a+7+A38LPCP2Khz3vKdcyzt2RWmCZvuivF
 40ZSEQ0d9nhS6uunLsIlHODqVBWpqClZoL9N6BFzg68oSmcpNK+yFxFf5zZCNvW2LY1q
 vivJ2RHpp92M18hxboLm85VX9r3XiBx4MZ4Bgx5RwRsGIh+f5L4ihXSI77K7QHr15Xyw
 Arvj7xZNTbc0n7VtFUf2Wn/RZ/wHsWmXx0dPzKB0kLCvymMRU/w2p4eBEP3DRrtSQo2e
 22NZX6+Ms3dU6X9viytmi2GmlEiAr43B1Bf/vwgzRSHTH8pptR/4N+UoWKAToq0xTYU6 tw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tx6252v01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 25 Jul 2019 12:38:06 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 25 Jul
 2019 12:38:05 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.51) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 25 Jul 2019 12:38:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gfpjf/92uaGjHgS45x48U8OkyvOhiuqsVFn4IUj/49hf3SBEE8JDqfgyWjFEkvOxjsITZJVJnq+VgTJXXwoK8AFVivE9ObPk7B8CmkxIBixesLHJjWHwjbbU6bq0qa98lP418LVy8TQyIwCGvkkJBKozbFn93ux6QmFoQ5jX/HMJD7RIev0KOCXcdFZ02RXSHrX1Samxugecm666Oc9Lm0JUyylMclCMI2DSZMvSrdZ/LaZ24xgKYhqPgSnzsYlzN5xKPJys3jRJJVgZzoyTPEEBvWuw97vchbITG5iLG7xhSlV+nX4DMBjWuo0lAsiBdP8t7XsqHfcHORNg0WEmig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ot9xOlkGNv0UJCPdOSINMqBqFpnuRWGisKDhNvH7vY4=;
 b=Xy6DLiDXIE66MSDPZ4ECfDN7jTGvSIJfhR+VGf2iOTLYWSg8VRJH4Yy9fvOuj6AzcEuo+RvRgq1KPvxBWSvYqy4vF3ySxvYHhQ6meF0mg3hns8TWSVQ/zR/WA40wxe1AFis/TdVUJveeO+KzmzGkVc7mxuHkR/foIt1YOzgfFspdXxBIWpTPdBcrhI/jZH1rDorkzqfkRrEyONYDQfVGtlmeX+SiEGRMAFL7hOnGctvEuxvI328CPwsJu5tV8MXU9huwod3bvqgR7ud44/NBANd2JZuymT1RaU1aIa4sa0NLeWQtm+WMdmm86Hoth6ZSvdQ+eFRf7/JaQeZ5HUIqGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ot9xOlkGNv0UJCPdOSINMqBqFpnuRWGisKDhNvH7vY4=;
 b=Bdg3Qny4si8x6JyV0qGCpfMjAI4f3i9fqrv+2OAbSdr9cnOOXCeOgT3MGNc2MZ51Zvstr6PTeqZmfN9FQwFpseTxQQNGUKl55DeDDk6wThGFQbjvurpEX1dESs6H4RYtzq8UIIFODKJeAU13+juBP5gwM87c4YsgfaS1ljEEACI=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB3342.namprd18.prod.outlook.com (10.255.238.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Thu, 25 Jul 2019 19:38:03 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e%6]) with mapi id 15.20.2115.005; Thu, 25 Jul 2019
 19:38:03 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Ariel Elior <aelior@marvell.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v6 rdma-next 5/6] RDMA/qedr: Add doorbell
 overflow recovery support
Thread-Topic: [EXT] Re: [PATCH v6 rdma-next 5/6] RDMA/qedr: Add doorbell
 overflow recovery support
Thread-Index: AQHVNmFQ7zxBCvG5bE6H3DDyc/x+c6bbuRkAgAAa9GA=
Date:   Thu, 25 Jul 2019 19:38:03 +0000
Message-ID: <MN2PR18MB3182B06853B828BDBA0DB178A1C10@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-6-michal.kalderon@marvell.com>
 <20190725180106.GB18757@ziepe.ca>
In-Reply-To: <20190725180106.GB18757@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [79.183.34.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8d66ec2-85aa-4bbc-2c1f-08d711379c03
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3342;
x-ms-traffictypediagnostic: MN2PR18MB3342:
x-microsoft-antispam-prvs: <MN2PR18MB33420A15991A7D8E45D9343AA1C10@MN2PR18MB3342.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(39860400002)(376002)(136003)(199004)(189003)(186003)(6916009)(14454004)(2906002)(71190400001)(316002)(8676002)(71200400001)(3846002)(54906003)(305945005)(6506007)(74316002)(33656002)(68736007)(229853002)(6116002)(7696005)(7736002)(476003)(11346002)(446003)(66066001)(86362001)(66946007)(26005)(6436002)(76176011)(66556008)(5660300002)(76116006)(52536014)(66446008)(4744005)(102836004)(66476007)(25786009)(64756008)(8936002)(478600001)(9686003)(256004)(53936002)(81156014)(486006)(81166006)(4326008)(6246003)(99286004)(55016002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3342;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: syWPkoIno31d0z+3GZZIIxy9o6dfqRxkrSrNWlZzDNYh2wobZns4MtlJIubgdHZJYk5oyRgDpzVOayKWLwzgKlfRWXci/zjrw95L5wyefFlWc7uhZ4IJIX5apVxwO5GaoC9jWWLQU52gIOGAKwDyN2v8zu6niSwwYWxu//ffdt7sOfMP5gd18pgVN90VbZkRsJPxdNvYcX8OdK8CDVg03QcI62ji5YOP3lLEmZsZdbtutz8hRfR2w7jhHTtN2AE5a7lDFpXBKNDS+o28y7OobJcpLZymnX5e94u4K20+CXUpyG8qhD7asPaqhADHfsOyLEol1EVmIt4cwCohSFsnN0uiqNwVqyvMw7S7L/fA8HQyw+k3R2VX77F65N0kPBFk6+TiFHjoC44UWeDolek/upRl9jvyH3F2RhlvVBdQ12A=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f8d66ec2-85aa-4bbc-2c1f-08d711379c03
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 19:38:03.2542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3342
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-25_07:2019-07-25,2019-07-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Thursday, July 25, 2019 9:01 PM
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Tue, Jul 09, 2019 at 05:17:34PM +0300, Michal Kalderon wrote:
>=20
> > +static int qedr_init_user_db_rec(struct ib_udata *udata,
> > +				 struct qedr_dev *dev, struct qedr_userq *q,
> > +				 bool requires_db_rec)
> > +{
> > +	struct qedr_ucontext *uctx =3D
> > +		rdma_udata_to_drv_context(udata, struct qedr_ucontext,
> > +					  ibucontext);
> > +
> > +	/* Aborting for non doorbell userqueue (SRQ) or non-supporting lib
> */
> > +	if (requires_db_rec =3D=3D 0 || !uctx->db_rec)
> > +		return 0;
> > +
> > +	/* Allocate a page for doorbell recovery, add to mmap ) */
> > +	q->db_rec_data =3D (void *)get_zeroed_page(GFP_KERNEL);
>=20
> I now think this needs to be GFP_USER and our other drivers have a bug he=
re
> as well..
Ok, will fix this.

>=20
> Jason
