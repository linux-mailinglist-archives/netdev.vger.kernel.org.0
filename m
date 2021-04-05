Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CC0354967
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 01:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242058AbhDEXoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 19:44:14 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52178 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242083AbhDEXoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 19:44:12 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 135Ncvl7057499;
        Mon, 5 Apr 2021 23:42:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=zKtM2+uDe32oGasrBZxOOoKchrt9wI6AkiWSVfkigHY=;
 b=qqqXBvbzbX9/DZYmSyaQSUi+Y7owIdydoXu0vIzBVLGOP48aPBNswS6RC8n4A19OAj2Z
 dqRgS8VMNVIfj6ijH3Cug0raew97YssgNu9zednVOT3gU7wi4iOcwocqmM4bV+IbQoJ9
 mg9WKaMLox49dpXEq3yZVp/XJkuSFKdgIWOGmDhD8J1ldfwosI20ZnS37TCmJ7EOyipH
 ed698g1i8qu5h768owxsdE/+Qdpgo0sMEUYOdwGyiidPtFj3vkjFBMTe6S5kvadvsU9+
 mQs6UkZve05T4nPxZiVh0g8YuZdwJeG5UQFx2ua11MOFA9mjvY7r8FnpDtHsbFM7FQJw hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37q38mkmvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Apr 2021 23:42:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 135NewkK163998;
        Mon, 5 Apr 2021 23:42:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3020.oracle.com with ESMTP id 37q2pthgqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Apr 2021 23:42:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oza/qf6ORAI3lgiuCa7uYUiyFrHkOFcLU3aQ6nOpKU6cs04HaBqd/QFsLmX2KKfuuGRZERHfquGdfgFwo2xaZO4Rl/nbN6et5ZfBE+7fQTLFAVTeBxDGDcsvfefpeExBW5euWbm82uKj6VIjR7sslrtgtdOT6jEWFEIGnvUMXeZhJzVGSKFjaNgKp0VyWROofSvql8xS8Gjyn452L/qlLY9Sdbf+wtQsrO4ZWdBYg7RCBPAtetKNPJHfqfGhB964es/+nenrdAQwB3+FJeKtigEgeNAE8HJO1F0+bBg3vPLNTidbsIBoBHB3yTIIrPNLPUOkYliTQcFGh0jM00V0jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKtM2+uDe32oGasrBZxOOoKchrt9wI6AkiWSVfkigHY=;
 b=B2yBIEvAzUULh72HKJZQbSFPqwZvECw+lLioPuhPIrnrftO5aFOWqqF1DSDzIvSVTsElhIRur0x5cHDpdEcLzu3VB9//2XSqmwJf/TqXa7VDUdoJuaDLzT9Z9x7qordNg1Ln0S59KRfykCXu5V/4WoNcuU5BdEKjKAGlOSGBF8CRSXA5AJZt+I7AQT5LLCKdIslM2ZbzJirqqe26OW0lAfNKICzd48mqNkwGAskDKLNryrW3bVAnwBrvpizASTpdlw7J7xwpUHk9aGvWUYjNiXI8i9VEmDPS5aQmSNu4UXjqjxvCyDNzFSAHBSuERaMjJIESSAe9YdT6n8urSke6SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKtM2+uDe32oGasrBZxOOoKchrt9wI6AkiWSVfkigHY=;
 b=TmHd73cZ4o/N1BNae19uz9JV6tn9dyBW6jXvm8HWf3f4CaaTQD5cOZDuKmpOxikY7zSP4PXR8GEM3OErKFwha8/de0KM3ceiSGigMWiJOXdIcCwAvCMkShjBn1D5aGDaitFnzt5wIgtVvyn00QosDGCb4OsT1RoUpfI1n2or3so=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB3669.namprd10.prod.outlook.com (2603:10b6:a03:119::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Mon, 5 Apr
 2021 23:42:31 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 23:42:31 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bruce Fields <bfields@fieldses.org>, Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Linux-Net <netdev@vger.kernel.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
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
Thread-Index: AQHXKdvtaH6rA5oohECEHiKcvcnWG6ql7vqAgABr9oCAADwHAA==
Date:   Mon, 5 Apr 2021 23:42:31 +0000
Message-ID: <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de> <20210405200739.GB7405@nvidia.com>
In-Reply-To: <20210405200739.GB7405@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0c56502-f0b5-4421-9459-08d8f88c7ac9
x-ms-traffictypediagnostic: BYAPR10MB3669:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR10MB3669C4B8FFC587AA19F90E9C93779@BYAPR10MB3669.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1P4/L1/ZJNVYsq3zoAQHsRP9UvupmZIfHQY+XnQnH5lv82rLLrpSzQeYH/12YKh6Ea1h23o0jB54TUuJW6z0y12ZyqjP9IwsB0hPS1pg9jHhRz31BDNAhm5wbXnizfOsFPmmd6QkjBYak5tKAOEU2OkVOGu71kVM9zMGUnX1zfVuRipXVO3jWjZUS8y9o1wgULZbv+ziayhlEjYV4FI5Q0//tYXalrI1JjwCZtaeqFiUj4vEdqK4FgldCtXopVZqrewNvQGeoUZUvAhffBucqw3C7w9nBKt4F3PvUQjqnIYw57NFPh0tRZxnPFeu7a1Icusb434uEzIMGEpHnb4gX+JIiT3xKX5nQHtu9GWMFY4jA1bNMH2QnAgqGdxCfl+2FvOdvN/gROdSRpV1BCxyPUQDNa4IJ/45i8TClvjnRTCdKWq2ScYhOW0V4i4WNtea6cu7lDpFJXME6HnDf9nz113NaHjJYGX/c+vhtwMVfzwu7MrhpjQydY6ggpzPtJbS/3Ho6ZI4ckkOONRsfwLXCa+11s7DUuKlsM+rwOAWLreYXBfuO2Fr6UulB7CKdsV30ohAa2Rst0rJ7W6/VZxGAHkyOeihc6LppT+19IHNaCxiEP3sKX4fHO4/PVuzpKa5yxG8Ro49YCqPgzduel5QHETYWnlu2x+Wv9sdEKWplGnqLRH0tsp82vQRKotgl9O2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(346002)(366004)(39860400002)(64756008)(66446008)(4326008)(6486002)(66476007)(38100700001)(8676002)(2906002)(66946007)(2616005)(66556008)(26005)(6916009)(33656002)(91956017)(8936002)(53546011)(6506007)(83380400001)(7416002)(7406005)(6512007)(478600001)(36756003)(186003)(54906003)(86362001)(76116006)(71200400001)(5660300002)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fU1731iuF5s3ZfAXU2eFrlz5VWawkbELDW24dAvCcoetlZ//NsdiLAW6Y1Gf?=
 =?us-ascii?Q?jwHFlUZir0fVOfxeASJmoRWbdkrqA2l5fGDOKJYx3nIop6jZOjgxUdCwQoAk?=
 =?us-ascii?Q?VGhDK2Bdtn36a/uO2szgA48BPHez7fhfFI6Gh7T45eo75uMd6Y6kLGRx8636?=
 =?us-ascii?Q?OVbmE/U/H6bJiDtS5wTiALUS7ZmiEQ2A84XnhbCFb8PvYsVU13X+7+rSJ+Px?=
 =?us-ascii?Q?Ysf/6T4jLe63J35INSfGTrr5eQAhprYEFBnjMzcOELD7J4OUPHb7yaPLdJLu?=
 =?us-ascii?Q?pPnjH9HqsX+b+2RQSQ/FFUJHDxeFikinzf3PUSDInYvJB+A6Trd5K3eAeoH/?=
 =?us-ascii?Q?CtNR7hRuUkaiV8MOhoKpMV9mwmMESLsRv2Ob2wGROSRO3OJ12O1mpTnP2GxL?=
 =?us-ascii?Q?o3PBnRmXK/e0VykBj8Pl445Hn41tKP8JUR13XKRDlpOcU12HGsCUQ0WL7HGh?=
 =?us-ascii?Q?BoQG61fmioyAWk+0PUMEdCkFH/+Rwiou6LnMVej9r88rWnRraj7zCjFldH2i?=
 =?us-ascii?Q?m9AJLcxpV4hwBMby0Y79x++A1b/G11vch4VyqL/y0UTwcdKFRoADT3uUiWfZ?=
 =?us-ascii?Q?O13pRBmTwetTqH16rA57lOy7cxj9WxbjTRvsd5xBjbvICEMbEcZAL+vJUu5I?=
 =?us-ascii?Q?/xuAAvVVwYluFCF4/U5XQCQjZxl+CBjBiJUZt8ON6A6SgDdtcttW+PaWHzjn?=
 =?us-ascii?Q?RPFLsF9LYAhBBQd3KPqejhO5IoKUyBO5Xtn9GRakEiS/CaBejBUcgVxig2T8?=
 =?us-ascii?Q?kuGQflA9T7OvQzh15LyPtNPyutSy1OskNivxyeyZk4Y8OrGdKQa0XrsYoqEc?=
 =?us-ascii?Q?+Czvqe62IbGS2ZgQVQREG5xCMMQrUz6gCXRalaIxJuWh5ZFmSPySf/xpWDN9?=
 =?us-ascii?Q?tjJXca2jYcDAGwz5fXVUPfB00BeTYhCbziIzuHtrA+vlGH742aRO+kh0t95b?=
 =?us-ascii?Q?gzc3bW9Wmu1FlIhp8Yw7nG/tW5JnbkbAiDZOe5DZ4PhXDst9/+wcQH5Gg4MF?=
 =?us-ascii?Q?z8gCvVZrMTFNPzRU0mPTymsC3SiFXAluiQl72LrS4yNnIT4bHa4KHWso3tK5?=
 =?us-ascii?Q?vdN3W9nGhv7lAhwoeccCPpnEIg2Mb93K2Aq1bT12xg7otA5RMzIu5L9y9eoO?=
 =?us-ascii?Q?wKxOxDX0/3L7pS1cybObTXO4ZfZRb0OtPOiWSR0ScDIdh/LoH/eTbR1quXgs?=
 =?us-ascii?Q?XawX/gauqz4cOlBSfDTfEBX7b88TX4kl0MzD/vCGn4fkuaeyB3/uQi3fZj9w?=
 =?us-ascii?Q?LxY+TVOKF07nJxA5DDhBLpP8mqx3Krcz644M+z47TV9DI1EYqbXgBolZq4YW?=
 =?us-ascii?Q?bJdvBDKv1dUkInkFAa2OQXL6?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <69878C021114F24EA5FA2F46F9DA0365@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0c56502-f0b5-4421-9459-08d8f88c7ac9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2021 23:42:31.0921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 25Gc+/aJACeCR+j9+mbqW0oTfQ1ncSEcbZ51VcLeEjMTOLkowk6VKD2PH0Q2km4W7lXFaZQGezA3lquPEFkUrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3669
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104050158
X-Proofpoint-GUID: sIuYRWDDGEAZZQlar9MnLoK_g2T-7nP9
X-Proofpoint-ORIG-GUID: sIuYRWDDGEAZZQlar9MnLoK_g2T-7nP9
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 suspectscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 spamscore=0 mlxscore=0
 bulkscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104050158
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 5, 2021, at 4:07 PM, Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> On Mon, Apr 05, 2021 at 03:41:15PM +0200, Christoph Hellwig wrote:
>> On Mon, Apr 05, 2021 at 08:23:54AM +0300, Leon Romanovsky wrote:
>>> From: Leon Romanovsky <leonro@nvidia.com>
>>>=20
>>>> From Avihai,
>>>=20
>>> Relaxed Ordering is a PCIe mechanism that relaxes the strict ordering
>>> imposed on PCI transactions, and thus, can improve performance.
>>>=20
>>> Until now, relaxed ordering could be set only by user space application=
s
>>> for user MRs. The following patch series enables relaxed ordering for t=
he
>>> kernel ULPs as well. Relaxed ordering is an optional capability, and as
>>> such, it is ignored by vendors that don't support it.
>>>=20
>>> The following test results show the performance improvement achieved
>>> with relaxed ordering. The test was performed on a NVIDIA A100 in order
>>> to check performance of storage infrastructure over xprtrdma:
>>=20
>> Isn't the Nvidia A100 a GPU not actually supported by Linux at all?
>> What does that have to do with storage protocols?
>=20
> I think it is a typo (or at least mit makes no sense to be talking
> about NFS with a GPU chip) Probably it should be a DGX A100 which is a
> dual socket AMD server with alot of PCIe, and xptrtrdma is a NFS-RDMA
> workload.

We need to get a better idea what correctness testing has been done,
and whether positive correctness testing results can be replicated
on a variety of platforms.

I have an old Haswell dual-socket system in my lab, but otherwise
I'm not sure I have a platform that would be interesting for such a
test.


> AMD dual socket systems are well known to benefit from relaxed
> ordering, people have been doing this in userspace for a while now
> with the opt in.


--
Chuck Lever



