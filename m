Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C3D463437
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241541AbhK3McD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:32:03 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63342 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230089AbhK3McB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:32:01 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AUAUjMg003011;
        Tue, 30 Nov 2021 04:28:30 -0800
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cmtkpp5qk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 04:28:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HqS1AsEMB33y9/29GuRj/TGwtm/ftiCTx6TUdOMxS4I9EioiUmCvNgbmZkivqPZcgBEpwP8hmuCqW1k/T2gtkn2wUHovoNop2GR+IkBJnEapwrtxoJwWo2TtrhLtqcWRWJg8bLecQA1c9w4F1I2mYOwnE0vprS9UcklFrj5xZOqselEdTiBEfEZ1OPvEvItKbfaiPUNApdzfY9q3ohjDK7TeTsqQowYsNV0dZcFOwKhep/w623WMRZkdMmkEaCAFYuzSu3Di1TNmYOEcKuWadiq2rDkwjpjnnOB3jBO2BrV8oYeWwEn8M7VTkD8hRnEG1tmgQuj9Zx2i5CteRwQTmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wyLxnrURh3GIKOWUR371Jna2OFmvXRbdehgQxpH0ZZc=;
 b=LiVUFSBbrf73jnMexI8Kb0A/vIGn3bq0kmDVDBCFUQ/UjmjeOHqQJS5JrLURK9gldS3n/LxhCNZpDB8nzw5+vIFNmEMWRhwYAvsBaZhRial73XKd5Y5WEEaZWLSNfd0q40S2JGDx2cWcUgcgLbtmeuE7FRMFCwXxBo0K1y2GVaTBzpONBxCtEODmLRdF4DPlYYHVl9fEiJT9lZebXa8OeajxUoJJ9Dm1eI4r1CGG/Xn8nwgY0QFT1CtFfFSIoxzA0Ky6SNtUShXixG+pqwWZHXsVNuY+UlB9JkB1aHyRib4Rf7nRhVg1bAd6SmUXmiw4pvr7/BqyO+UQFPl5d1soIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyLxnrURh3GIKOWUR371Jna2OFmvXRbdehgQxpH0ZZc=;
 b=psfoufaFw1UZURHmnOd/AcKspq66aIz9fnDkD/vMbW2Rdam/Xgk3eAtZIhDxlVWpuIlKJRB/Mor+ZgklJ//eRl8HXAVkxQhnyr5MZA7LY1JPBCide383jt5d/7FOFA4LjpzEkBQbYuc4PvwdrV8wqW0DXeFvSD84IHvNGXq7zrQ=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by SJ0PR18MB3899.namprd18.prod.outlook.com (2603:10b6:a03:2ec::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Tue, 30 Nov
 2021 12:28:27 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::f5d7:4f64:40f1:2c31]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::f5d7:4f64:40f1:2c31%6]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 12:28:27 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Serhiy Boiko <serhiy.boiko@marvell.com>
Subject: Re: [PATCH net-next 2/3] net: prestera: add counter HW API
Thread-Topic: [PATCH net-next 2/3] net: prestera: add counter HW API
Thread-Index: AQHX5eXGTuZy2dZ++ku4gUQYU+OUXw==
Date:   Tue, 30 Nov 2021 12:28:27 +0000
Message-ID: <SJ0PR18MB400911740A1A73962CF5531EB2679@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1637686684-2492-1-git-send-email-volodymyr.mytnyk@plvision.eu>
        <1637686684-2492-3-git-send-email-volodymyr.mytnyk@plvision.eu>
 <20211124191649.08f7ba14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124191649.08f7ba14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 56fd872f-0b45-d0ba-8943-804786aa39eb
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 307e28c2-a954-4018-7698-08d9b3fce94a
x-ms-traffictypediagnostic: SJ0PR18MB3899:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR18MB389930996980004EE5B71BACB2679@SJ0PR18MB3899.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VyqUsslN49z6lfYRMAWPOx9q4Vvf3ubzXE+QGph5cbi0vqGZxft32HuPuXTlxXtC3XMqzUngVYqLTtrbffaZfN1ZG4MOzcKWEXLrmhU7ln9SUF1wPLd9H09p5Tu6JtxP6P4sE+kAH2v9QPtZ8tqosqTHUdSWmUciYsTy3LLjaPS6BIIhbU4s/7Gqxf7bHUpnmIEkKF5qNjwW0XPv2bYHvGTGJ+NHguGvnRONkbEvH4Nf0wMVh3IJ10pTffjP3N17OWH/7AIj7fT+vzA2f9yOioETziaBrJvozMDMKzX8Gx1Fr9pZesnGsv0OA4rBid1XTSo69t0is/QcoKiWENyXBMU8/knJw961X8gLRAa63KfKdYGTGQ8cJPz9Es3Mxa0s5ndrsa5+pDzTmth51dCyUShoxRtnMQjeytEOiwDAAEJrfP5S9utcknkunXxE8EqhGnkDE4z2HqsBO22RGZ0Rf5L3FQMBX0/3R2YCUzzW5cWqT5ezkIJD2ne4QYk2TWGUNPpIGkUG56KBzabz7QD3PWABh74jxT1UraR7plVohR9HQcfn5sbtyQJfuhReqZSM3CQ63ACJ+RwVe6JVAYS/ui0aH47VyomPNcmO5KJZeIG/01bzgLKgzNrMIY6MQW/1n4b1Jf0LRJsASWUZ31I+5n26cOLK6Hi9bwyrGN3fk9Lf7J+s8IjSZ1uHdbbZkBdLIoAH1PYhnGnw4LY1G8jBHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(2906002)(316002)(8936002)(8676002)(86362001)(4326008)(33656002)(71200400001)(83380400001)(66446008)(55016003)(38100700002)(52536014)(107886003)(38070700005)(6916009)(26005)(76116006)(186003)(54906003)(4744005)(66946007)(64756008)(66476007)(66556008)(508600001)(7696005)(6506007)(5660300002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?QGnklL7cfxwCTwblUl0LlfcPUk6LN92xtp2H7QoGfNQgU1rbhTKRIJIxBY?=
 =?iso-8859-1?Q?NmSjbPwA7jG4BCL7zGHEr5EsSMv0OEnbYkPOlZ5EZc30TLWP1ZkKYTHcEI?=
 =?iso-8859-1?Q?OQCzFvCUvP3JtoH1vtRuAw5Vrs5Pe7V+vfqRDF8H0rVCYwLxLoq4urMQ4H?=
 =?iso-8859-1?Q?lJiDF+FqOqHRyClOCXdLdepsZIq8KTzr/RQaJUgwfzGpH6ns5oTWFDZm3t?=
 =?iso-8859-1?Q?dk3IDlwotqMrVEB9Oxi1wdCObkXPfZZL2vz4XexqdoSr9l+rmFUYuogfdH?=
 =?iso-8859-1?Q?11VqNV3wxEeMVl5OubBgkC4J+ETGWW9aAOQCyvo9/sCyLCNAKHWAfUK8k9?=
 =?iso-8859-1?Q?QtAZgTy7QZOHwTDr4+BRVRqgOTvUpkL7F57bZaUIUMqgYsMtWcyByvHjBB?=
 =?iso-8859-1?Q?rwA7xo3xzH0gCAO5fzw7CwHWAuRhs5b9lDw3nOlJRD/SfqK8KwJb5PKZIS?=
 =?iso-8859-1?Q?v5tY7L8g4ff3oIkjGokgJ+7DkAETuii/RxTTPplErxemj9E7kLU1VQX+sp?=
 =?iso-8859-1?Q?G00S+/uhrnS/0gYoRf8kJJG3kHqERUDSlLIGJpg+54H+I08JBfoc9Pgiu3?=
 =?iso-8859-1?Q?kAXCVZfO66JPT8UbkPchdvVzqKRq2HVk+ito4zlVmJWqR0UczS4GX8Xm8B?=
 =?iso-8859-1?Q?Un2UGANGtIHiIqXTGeQhb7ojekYEJ7+7xMer8HOM8fyeQePWKzyuptaxKT?=
 =?iso-8859-1?Q?/sJ7j13GZNffui9qAMo3pxzN28H7lNs3eb3f2baFpSWQ4rGdkn9OlKYRsV?=
 =?iso-8859-1?Q?vmIvM2L85JybJuiJlGdNXt3zOhQaRfaZQin+/58AWZ8azIF26uTNwdVEVE?=
 =?iso-8859-1?Q?ZHZPU9MlGhoCysN09R92CyRxSdvqSharT/6gPE3x/2Y0vPuXgU5ttTO66z?=
 =?iso-8859-1?Q?Ku0GnPbDYv3GsMjKNMAqfCqrPZSmKMB1IgiJWPbDkhS8DgWHXQ4XRRTuWG?=
 =?iso-8859-1?Q?umMOe+nPASY6GQA1MdQlHhK31BBAOwB+1xz6rB84+qFZSVXW0lcAMfpZh6?=
 =?iso-8859-1?Q?qmzoiK18a2hrBvC1YoQr0X4z+sQOPWAP3cQKGxHGDAmr7ugBon7TzxJbl3?=
 =?iso-8859-1?Q?Coc73oJg5oywtz39TDuVdfSKJJmBBO3g0qNq7P899pW2wIUGjkWcomFnyF?=
 =?iso-8859-1?Q?pQGb+UEpdlE4BBbhxjaRLn3VDQAKntEBfIlQSLUdXOz+s72Tp3bhuRFDR+?=
 =?iso-8859-1?Q?vttaQex8D/mdqrT5JXy6l3pP5Ne1OD+NT8t4RkD9Avm5luH2p3FvWRfipV?=
 =?iso-8859-1?Q?Zfc9jdLfAOOELx02J1VSu2f2E255AhJ5iSJV1HkmzM34P3PuXsJhTtfAy2?=
 =?iso-8859-1?Q?QYHt1gmLcmYTi6DfjJm/fLieMHTH+Bn9DPyswgO9MOM/7yMWLlCGNQCoTL?=
 =?iso-8859-1?Q?1wxv8Ke9Zl3jbSwJODLj80nFuNJpBNrCLeDdPpEcQ9bAvrb2HdNaJayir3?=
 =?iso-8859-1?Q?+5NnJuqI52d45xmJ1bBmIw3SD3ntYoKeurBOGDgd5SOGIToxokWE2T21uB?=
 =?iso-8859-1?Q?SJJqYWa4ikwpes90fhkeXEfJoA3d3+VzHWksNHJ9hvu/laCtDk0c3X959W?=
 =?iso-8859-1?Q?Dqqsi/BKgMV4t9AdZ8Dt8bEY7sER9J4E31cgwvRO1Pm/RItMdV3FAI+wHt?=
 =?iso-8859-1?Q?952lEDIn+l8FgjMmMJznCjhi9wZI0jCG4YMxltI7eyOaLeRBEOQsuEeg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 307e28c2-a954-4018-7698-08d9b3fce94a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 12:28:27.4417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OpZyuLfUAb/btOCNw0yKRqg06uwyUJWxGqJx5OlwWBwlkNEJkATYflxZMEyw7GKMFAKywd4/DOYZXd9JPKE9MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB3899
X-Proofpoint-GUID: Oqs79sqlhfpx8S7g-dj-MYYwq56VJzXA
X-Proofpoint-ORIG-GUID: Oqs79sqlhfpx8S7g-dj-MYYwq56VJzXA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_07,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, 23 Nov 2021 18:58:01 +0200 Volodymyr Mytnyk wrote:=0A=
> > +     block =3D prestera_counter_block_lookup_not_full(counter, client)=
;=0A=
> > +     if (!block) {=0A=
> =0A=
> if (block)=0A=
>         return block;=0A=
=0A=
Fixed in v2, thanks.=0A=
=0A=
> =0A=
> > +             block =3D kzalloc(sizeof(*block), GFP_KERNEL);=0A=
> > +             if (!block)=0A=
> > +                     return ERR_PTR(-ENOMEM);=0A=
> > +=0A=
> > +             err =3D prestera_hw_counter_block_get(counter->sw, client=
,=0A=
> > +                                                 &block->id, &block->o=
ffset,=0A=
> > +                                                 &block->num_counters)=
;=0A=
> =0A=
=0A=
Regards,=0A=
  Volodymyr=
