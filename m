Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094FE3544F6
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 18:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240797AbhDEQNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 12:13:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58214 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240508AbhDEQNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 12:13:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 135G5T4n035550;
        Mon, 5 Apr 2021 16:11:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xsFCIaEfmlco+o79mXAKzfos7MLc4tYGa+arwJTWFC0=;
 b=sCOjuXCTbxcuj7MW7Q0vdaIdYkS4/0QyfOye6PplhnW7oORBUXKtlnhZrP2NGrU2JsJP
 SqPY6SC29EMoOFUv7VEL6xcRmh/0ms8m4yEPdLmoKs7lcKmsz4hMOTkTLI3+yaTuHMH4
 Dt1iWTx5m4hD43ITDv7rtKZ3OC+0Cdk4z4sVno22lHQtx9lI6YQ5AcccX4AsZWZp9P7N
 Yu/uAlF+yG3a+eZONKxCQwUDH0GjY3P8mihWkF1xdGRoVGlS7X3li/4NOpyC+Y4nOr1y
 HvA/zPNl5gg8RUGRxVR7ToSmc/P5z3801jl5M8CwdQztoaIdbfbDNbSI4d8riObn4bWY CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37qfux9vqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Apr 2021 16:11:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 135G5Dhr014186;
        Mon, 5 Apr 2021 16:11:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3020.oracle.com with ESMTP id 37q2pwedpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Apr 2021 16:11:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvQKa+PriphidA1w2Kh7SAcKyJoKDW8JOch9kpXK51ysZhrXaB8mj5IuQH1uLr1XBB6hq5PPk5C7pLXuTpQVRMVuGM5dRGahChPlJ7TBUjjc5CzZ6ZYAhLJzNS6ILbjmNMjcwpKXVwsAIDFbnXdqDDfO95QD3t3NkQz3YBx4tANR74MiGZL190v6HIPHkmrant5uKoFeupwtbuNFHkgg8KudZvhdirfikx29jdELnLXi0hWrl/nlhwaMpk2Eu6xiNS+2kX58vQTB4yITZvC20b/yE6/V2JDV3ekJwvzDCwAymHVNt+NJYvs+lkqpy1PCL1+jysv2Tovn+QfOTwDW4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsFCIaEfmlco+o79mXAKzfos7MLc4tYGa+arwJTWFC0=;
 b=KfmTllozOa7zRTG/m66Dj1QvLY6vG3L4iciXvqHUyJXhSCF6nTPP+prG7wlUOWs3UbEaNLsZAswbqziXwdW8z0TCcgSQBtDY5s1Nm5ukWw9vkHHo0UPeMIOoLG/aI9PYhYPxXIwXNaaz60ZnuXnQDc+SulcMKJcGCa4MtisU9r0b+abOfHvNeiKo7tZiHllLm8jhYmtG3vOHFEVszXQZB9gLTIR75ap1ztAMUqA2Taa98nhH3JZ8glMykHjiaPDSUttOAuVLlGFZfSY8D0Cs8N5PzNa3ZbPDsIO4elmwBmi9ugcNs8NQtZsZ5JEXjuSCN1s47EfUalBKm1nYpDi53w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsFCIaEfmlco+o79mXAKzfos7MLc4tYGa+arwJTWFC0=;
 b=DwpW5ynKLYyw2mCW88bLmmFjnsRnyh+vvh0dXRK3ABicLKb8PaYpepuIOP2HYhxde1nCioIW8Un2X+toDbXMJlb8p4bwsU8FdfKI1qZ2vCR3LsOiJ496xVkqj7f2WUXGU4qZXU6D8Zvo4AN7A4RR1MyURe+OXBks+jsPcRlIu+g=
Received: from BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25)
 by BYAPR10MB3464.namprd10.prod.outlook.com (2603:10b6:a03:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Mon, 5 Apr
 2021 16:11:32 +0000
Received: from BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::9ceb:27f9:6598:8782]) by BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::9ceb:27f9:6598:8782%5]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 16:11:32 +0000
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Chuck Lever III <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Thread-Topic: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Thread-Index: AQHXKjZXCIoekM3Ip0au2KyTXmdGOg==
Date:   Mon, 5 Apr 2021 16:11:32 +0000
Message-ID: <AD59A399-EFC9-4609-AFCB-8F346E60F5CC@oracle.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de> <YGsZ4Te1+DQODj34@unreal>
In-Reply-To: <YGsZ4Te1+DQODj34@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [138.3.200.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c74df2d-8595-4410-7a8b-08d8f84d7a9a
x-ms-traffictypediagnostic: BYAPR10MB3464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR10MB346465832BCE806C8DBB94A693779@BYAPR10MB3464.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jon13GLoX8rGOwyOwwG/Y8j6Ggw5GMHlIlES1ZiJ3dShDX1mNzJt8XMEUwnYV1Tcq90+zO3swRfm4kIJcWH/aerIG4nY7xyHfTBznzfHGeWwpn+L49bsx8Dc3jymbnNioXhtkCaAtwhHI7BykD4i4MnnigHEJE7WoS7DPqhCR+dr9v0akl7A8b08gwyiXj8uZ9M8MItvP63KXCln10yCuL6A1Ry4QcPy1ckOx02I42sC82SjmLnF7Cdpu3LIhqZ37Ux6r0iZgUXVXQafCPc4YSpyQ08BJUqTKJZ1KO2BF6psdoFiHNK/qjRTS0oubLli7IMwGtOJbrQWJ7CMFbV9SqMf9oiMpTgRllRln43zF8HwIkpI8B4L8fYsXDLDpqbMPJ47OKTl6X+eYqHiUKeQ2oFoyAxOD2XH1uuvCwD+UkQVtDXpdx7ik6V0RnxJf8yRUL9+L+6MP7uSPN6Vfbw5V7iIatZl9nsd1Db/PNFOFNGf8tI8jQT92/7S7pg7Um40DI8pCzi+vzze6eG0jQbZb1lTBhQXt5sFOmHmfej8Chwy61QseUkJymOU6HcM+LA2SuXYNfqozS9f8cmF1OLKz8qGZaVxNrzL+YL4qIW5IQ2Za0bUMZz7cotHnXoYqAwG29TQnpOTTzbdi8GMu2yXMzhfe1Pr1ZI51WyA9MXhUbsw4lu6swq2wf1HPjL+c+yt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39860400002)(376002)(136003)(6916009)(71200400001)(76116006)(8676002)(36756003)(6506007)(66446008)(66476007)(86362001)(66946007)(83380400001)(6486002)(66556008)(64756008)(26005)(5660300002)(186003)(91956017)(2616005)(7406005)(478600001)(38100700001)(6512007)(316002)(44832011)(4326008)(53546011)(8936002)(33656002)(7416002)(54906003)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bndMNHROUjgvVitES05TcW82UG42VFdRdWZBM2RLRVBZVXFJd3FET0VCYVRD?=
 =?utf-8?B?VThUdEZBaXFNdXByS2hDUHRYaUZLRlkvNXNiZjVtbEpTUVNFUVhzZUVXZXZS?=
 =?utf-8?B?ZDJYUTU1ajh5WUVqVThlK2VvQmRMTW9EdW1nOFBoOVlUN3pBNGUyWWV1Uk5D?=
 =?utf-8?B?TGpMQUVVRGdRVEpZMllQM1NJTDA2alVDbWF2d0tCNFpqeXlLaXVqaDZLS2NH?=
 =?utf-8?B?WnJ6WmRDY3pqb1JDMVRaOE9Ucmwxd1lRVEU1VFhWN0lCQll3RzdlSnQyQjVt?=
 =?utf-8?B?R3lZZHdQd2NpZ0FiUHMxeVBRVkxzbzY0RVNmWnJOclVyVzA0dkZwYXRJanpv?=
 =?utf-8?B?ZHByaW8ySGswUkxLZGZWKzF3WkVSR2N3N0M4RXJwK2pnM1VPeGhWWndLK3Yw?=
 =?utf-8?B?TmJOZjdhZVZrTFMzODY2STQ1SHQ5QVJUbi91NHg0ZktkYmx2ZFB5THpHNTJm?=
 =?utf-8?B?RG9mNlhLOStqZDdIS0RYOFR4RmhVazV6TzRXcFJmTXVldXdGRjBrQStCdTNa?=
 =?utf-8?B?Ym9Md0FkWjF5Q0NUMkRGVWhrWHJxQmpjUzRZSGRBL3V2VmZPOFQ0YVgxWkJN?=
 =?utf-8?B?RnlZd0c5b0piVVVWTXlVOTJOdFFhMzhZMXUyT05CQTdQMVdtVjFLTDlWM1Q4?=
 =?utf-8?B?MGlVOGdwMGhHUm93Y0pZNXV2ZnRVNDNXa0szZWFORHJ5emNEU3QxR2hCRjlC?=
 =?utf-8?B?T2o5WVIyVW1QclRMUDJSYmppMjMxUUN2NHpJSlRWSUFqdStzeW5lQWFYbVJn?=
 =?utf-8?B?WVF3dFc1RXVuMFBWRFlFOE11MVR2bXFTeXJyYklCQnUyekN2RS84aW5HeG5z?=
 =?utf-8?B?dGQ2eHRBQzI5S2s1M0tjVkFFM3FWeXREZjA1V3cxWkIyZVZJUzI4Ry83clQz?=
 =?utf-8?B?YlFyajlORnFzVy9PU2xuUjVaVm1kQW01S0wrQU9DcEVEVytOVlVKUjhqZDFI?=
 =?utf-8?B?V3Z6UWRMYnhKQkpad1pySGtqU0V1Sjdnall3enZ1aTc0d3NBWXhPRFlFS3dh?=
 =?utf-8?B?UmdjL1k3Rm9ad2RsbittK0t3L3BKQnVGTGU1UDRkT3pDZTZiVGtEVmVUZVlh?=
 =?utf-8?B?WmxOSFBtMTl5M2lmU2ZpSkFaYXllWXkwY2d3NTNENW9qQ092Q0NHQ2NMYXpa?=
 =?utf-8?B?Z3RPYXRIZTJ6ZXVxVnF1SXU4OTBTUkNuYi9SbHdReXNNeGFTWjZYMU92MHRt?=
 =?utf-8?B?QjJqTVdDQVhXbmREaDczVXUvOGllbERjNEwyUnNhQ1czVHZjdWZsOFdhamhk?=
 =?utf-8?B?NVpaQ21hZUJ6Y1hMOEFEMjRKWlptY2lmdElhWWdYK3gwRjNZeStLTDlac01k?=
 =?utf-8?B?VVA0U2FFd3Y3aCsraHFEeE9aWFFmazdoVmptQi84dVovYytSbXg4U0JzR05i?=
 =?utf-8?B?UlRDY0sza2IrcTBKeFRpNFIvZnlsNDRrUDJ1d1VSbjNyVDc5RjJOMXVrOGh5?=
 =?utf-8?B?VmhQTkRRU3Mwalpkb2RxOStCSjh5eDRVL1FTdVA5SnhtYXV4ZXV3a2MxekMr?=
 =?utf-8?B?K1d1ano0MEhJOWVjYUh1aWlGcHRlNVZPZzI5Nm0wM01rME9FN0RKQ0Nxc0dF?=
 =?utf-8?B?VEdrQnQwcTQ3cnp5OXN4cEphak5ONlNkcnJNcDB1Zm1BUERFZUZCNTNnOHB4?=
 =?utf-8?B?WlltaXV6NGw1aURSYUk4b1lUVFlrdStCVEVsM3lSM28wYXNGbFBvYktXOXht?=
 =?utf-8?B?M2JpK0cvSHZWN3BtZlZrQUNxcndGZFB5T0RlS252bm4yQkY1d1R5cmh5Sk1I?=
 =?utf-8?Q?F+/qZ748VLAUAPLUa3M2EXRrCoSYKhfOnRDjx7y?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C184FA69C22E624F97CCB5307544C837@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c74df2d-8595-4410-7a8b-08d8f84d7a9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2021 16:11:32.3331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kw570ZfqPFKY+qivMZXnTtu0rN7gdNYQljBts0rtLU5py10fEpds5HlSxAuov+ezu/ZiDa6yHpFV8ah+QssjQigHx0jcgjCSgd5ynl17d6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3464
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104050108
X-Proofpoint-GUID: Dwyo9EyT_R8GAs7jRsZDux-dF6T-Dsdj
X-Proofpoint-ORIG-GUID: Dwyo9EyT_R8GAs7jRsZDux-dF6T-Dsdj
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 malwarescore=0
 suspectscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104050108
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IE9uIEFwciA1LCAyMDIxLCBhdCA3OjA4IEFNLCBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2Vy
bmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIEFwciAwNSwgMjAyMSBhdCAwMzo0MToxNVBN
ICswMjAwLCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4+IE9uIE1vbiwgQXByIDA1LCAyMDIx
IGF0IDA4OjIzOjU0QU0gKzAzMDAsIExlb24gUm9tYW5vdnNreSB3cm90ZToNCj4+PiBGcm9tOiBM
ZW9uIFJvbWFub3Zza3kgPGxlb25yb0BudmlkaWEuY29tPg0KPj4+IA0KPj4+PiBGcm9tIEF2aWhh
aSwNCj4+PiANCj4+PiBSZWxheGVkIE9yZGVyaW5nIGlzIGEgUENJZSBtZWNoYW5pc20gdGhhdCBy
ZWxheGVzIHRoZSBzdHJpY3Qgb3JkZXJpbmcNCj4+PiBpbXBvc2VkIG9uIFBDSSB0cmFuc2FjdGlv
bnMsIGFuZCB0aHVzLCBjYW4gaW1wcm92ZSBwZXJmb3JtYW5jZS4NCj4+PiANCj4+PiBVbnRpbCBu
b3csIHJlbGF4ZWQgb3JkZXJpbmcgY291bGQgYmUgc2V0IG9ubHkgYnkgdXNlciBzcGFjZSBhcHBs
aWNhdGlvbnMNCj4+PiBmb3IgdXNlciBNUnMuIFRoZSBmb2xsb3dpbmcgcGF0Y2ggc2VyaWVzIGVu
YWJsZXMgcmVsYXhlZCBvcmRlcmluZyBmb3IgdGhlDQo+Pj4ga2VybmVsIFVMUHMgYXMgd2VsbC4g
UmVsYXhlZCBvcmRlcmluZyBpcyBhbiBvcHRpb25hbCBjYXBhYmlsaXR5LCBhbmQgYXMNCj4+PiBz
dWNoLCBpdCBpcyBpZ25vcmVkIGJ5IHZlbmRvcnMgdGhhdCBkb24ndCBzdXBwb3J0IGl0Lg0KPj4+
IA0KPj4+IFRoZSBmb2xsb3dpbmcgdGVzdCByZXN1bHRzIHNob3cgdGhlIHBlcmZvcm1hbmNlIGlt
cHJvdmVtZW50IGFjaGlldmVkDQo+Pj4gd2l0aCByZWxheGVkIG9yZGVyaW5nLiBUaGUgdGVzdCB3
YXMgcGVyZm9ybWVkIG9uIGEgTlZJRElBIEExMDAgaW4gb3JkZXINCj4+PiB0byBjaGVjayBwZXJm
b3JtYW5jZSBvZiBzdG9yYWdlIGluZnJhc3RydWN0dXJlIG92ZXIgeHBydHJkbWE6DQo+PiANCj4+
IElzbid0IHRoZSBOdmlkaWEgQTEwMCBhIEdQVSBub3QgYWN0dWFsbHkgc3VwcG9ydGVkIGJ5IExp
bnV4IGF0IGFsbD8NCj4+IFdoYXQgZG9lcyB0aGF0IGhhdmUgdG8gZG8gd2l0aCBzdG9yYWdlIHBy
b3RvY29scz8NCj4gDQo+IFRoaXMgc3lzdGVtIGlzIGluIHVzZSBieSBvdXIgc3RvcmFnZSBvcmll
bnRlZCBjdXN0b21lciB3aG8gcGVyZm9ybWVkIHRoZQ0KPiB0ZXN0LiBIZSBydW5zIGRyaXZlcnMv
aW5maW5pYmFuZC8qIHN0YWNrIGZyb20gdGhlIHVwc3RyZWFtLCBzaW1wbHkgYmFja3BvcnRlZA0K
PiB0byBzcGVjaWZpYyBrZXJuZWwgdmVyc2lvbi4NCj4gDQo+IFRoZSBwZXJmb3JtYW5jZSBib29z
dCBpcyBzZWVuIGluIG90aGVyIHN5c3RlbXMgdG9vLg0KPiANCj4+IA0KPj4gQWxzbyBpZiB5b3Ug
ZW5hYmxlIHRoaXMgZm9yIGJhc2ljYWxseSBhbGwga2VybmVsIFVMUHMsIHdoeSBub3QgaGF2ZQ0K
Pj4gYW4gb3B0LW91dCBpbnRvIHN0cmljdCBvcmRlcmluZyBmb3IgdGhlIGNhc2VzIHRoYXQgbmVl
ZCBpdCAoaWYgdGhlcmUgYXJlDQo+PiBhbnkpLg0KPiANCj4gVGhlIFJPIHByb3BlcnR5IGlzIG9w
dGlvbmFsLCBpdCBjYW4gb25seSBpbXByb3ZlLiBJbiBhZGRpdGlvbiwgYWxsIGluLWtlcm5lbCBV
TFBzDQo+IGRvbid0IG5lZWQgc3RyaWN0IG9yZGVyaW5nLiBJIGNhbiBiZSBtaXN0YWtlbiBoZXJl
IGFuZCBKYXNvbiB3aWxsIGNvcnJlY3QgbWUsIGl0DQo+IGlzIGJlY2F1c2Ugb2YgdHdvIHRoaW5n
czogVUxQIGRvZXNuJ3QgdG91Y2ggZGF0YSBiZWZvcmUgQ1FFIGFuZCBETUEgQVBJIHByb2hpYml0
cyBpdC4NCj4gDQoNClN0aWNraW5nIHRvIGluLWtlcm5lbCBVTFDigJlzIGRvbuKAmXQgbmVlZCBz
dHJpY3Qgb3JkZXJpbmcsIHdoeSBkb27igJl0IHlvdSBlbmFibGUgdGhpcw0KZm9yIEhDQeKAmXMg
d2hpY2ggc3VwcG9ydHMgaXQgYnkgZGVmYXVsdCBpbnN0ZWFkIG9mIHBhdGNoaW5nIHZlcnkgVUxQ
cy4gU29tZSBVTFBzDQppbiBmdXR1cmUgbWF5IGZvcmdldCB0byBzcGVjaWZ5IHN1Y2ggZmxhZy4N
Cg0KUmVnYXJkcywNClNhbnRvc2gNCg0K
