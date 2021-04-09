Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E9D35A162
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 16:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbhDIOrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 10:47:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33730 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbhDIOrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 10:47:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 139EYvIe056054;
        Fri, 9 Apr 2021 14:45:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SP17EhIVdQvub+gajps3wxYVMgyTHERMV1JjC/TIzJs=;
 b=jf9Xr2K6bwo2NYOIUdYoFFBgbVlgT4WDjQ9ZB20UeilUyNbwTDp//wBb3/tbRD7HKPhG
 +ZJ0kVPq13ogqRLFj/d3AydEgNTe4RXRr3wZtwy7BenqFq5ehQxbmlJAu6/NJNdITloO
 ho/dQDpZ9u131k5foahhk8Sy2a7AYqnGSaARObCEp6P/1g0QpMLCgaOcF6KHHsDyol9d
 HSP9RqW2mLDi7VTzZxYik4PaGedMUtAC1cwMg3sRhnhpS67nBJwL06vjh2oHxQTMKGG6
 bb0zJKLVdAzRnG7toi9yR1iUvI2epzyz3fZiuO+4VNYZl8YEQ5czmeHult8FFXvgFOFN XA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37rvas9n4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 14:45:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 139Ea6nR108556;
        Fri, 9 Apr 2021 14:45:53 GMT
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2056.outbound.protection.outlook.com [104.47.38.56])
        by userp3030.oracle.com with ESMTP id 37rvbh43px-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 14:45:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJ9SAxTIlL1KaUeOKqAXqT/9JI7xre3mga8PEuY0NZqy5p8Drb9KgkRPwMu/k+riOiMjxZ/0rerzt3SIEL0aOBsFJzCYyQyS8qw/nZ1+ndlx6MVtr2Qly/nJU2WDvkUj2m+0t/yCoI0zJM/KDoidgul+PiU1RfRIxlpE05BIz7cyeCcyd37ZIJ19Ib2uxTY5mC/+gyQ8tjNWpd8gfGNfMW504qd0dEHh2u4mgkeVsLHrD11FiGoA/KYLtt+bcsN6LtZcBT9A1taxW5yeztUdcDfqk3cMbiIRbzUY0s5WjyaioSrbykY+Rd8DdN+ofHEQZWSWKKDThDtBcq9ZSTPUnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SP17EhIVdQvub+gajps3wxYVMgyTHERMV1JjC/TIzJs=;
 b=JfDbEJWCj/Q8ezAihUnqaJL3uBmYcGVyXRacydU8OuxkmAJ7QTCvNFz7Gu4OTTff7gzm6DUp5imBkcHgSuck4QBD6a84+IOp6YYYZqSpjEitPa+y1rRPpnw+Flr3piWTjcPX4SGdOOI0Vguo4wlU7dgd8oHgV3gWcOWiq2gp8TxvvcE3bJzev1Ofn5+6j9kz9lOkoavrF5MKQksJ/1HyQi+ZSmkr36QFQY1MaCnJCnumO1HvN1ri00PXalhLTqbclh2NSYsv7MBIPM+CKTDj+iLXc5PaezgAm0EshZ//jkF81qeDNlu/uVrgZUL6JSaNlJ49hhTippUz17aezaK2nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SP17EhIVdQvub+gajps3wxYVMgyTHERMV1JjC/TIzJs=;
 b=ONzy7XnXDrUT2hx3MIxynBE8bn2QaH7PTc1M9IJZ23oV3vOu8boFtbi7k6URN+PHTsRl5xOmU9VbpZ0EvxOq2s2ieDGd8zvqrknvlK6FIdTncoU6soYTHhccFRILNBsqbWtls5LitBotsGyRTwre8iFsfwM2tJWM2LNuU6bHdhg=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB3671.namprd10.prod.outlook.com (2603:10b6:a03:11c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Fri, 9 Apr
 2021 14:45:48 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.3999.035; Fri, 9 Apr 2021
 14:45:48 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Tom Talpey <tom@talpey.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leon@kernel.org>,
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
Thread-Index: AQHXKdvtaH6rA5oohECEHiKcvcnWG6ql7vqAgABr9oCAADwHAIAAyzkAgATit4CAAAVugA==
Date:   Fri, 9 Apr 2021 14:45:48 +0000
Message-ID: <8A5E83DF-5C08-49CE-8EE3-08DC63135735@oracle.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de> <20210405200739.GB7405@nvidia.com>
 <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
 <20210406114952.GH7405@nvidia.com>
 <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
In-Reply-To: <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: talpey.com; dkim=none (message not signed)
 header.d=none;talpey.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf16839a-59fc-440a-7fc6-08d8fb662a45
x-ms-traffictypediagnostic: BYAPR10MB3671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR10MB3671B5D8011D8FED73BBE36E93739@BYAPR10MB3671.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iYsp/GajRfZ9IuAFDeJmw4KDdVblIJlUnutfWrl/PhV6y9NDyMQZCoB3Sw0Uk2n/spXTZ2V3lziDbl1hJdisEL5Jfd68fRaG7StKYi+UtXtW3NBca8XVwKqtVZWZJ2UhlEX9gPtvcxoXaPJkOBzidPEq3omNOEzkCmXVT8FbcsDeN1tdd4fSa1UUu/dbylSwOBetSgyrfBIzMbMMLgfay5ugobp1o1jZHxL+UGUWWp5+RCpO+K9Zgays34OKsPPpUDboKPixJJbSQW+B4RzR2HPHZO1jRNce/xKwmBI9WpDcXQp6r38RHVQUOlF/iwn2Cn2jDQITCW8TuySNKqPHxgyEWdaqqm8p1MYscBN9++XXgcgbAzuvcExOx32EA3ta7pOZdvawDblzTWXjLHM4JZrwtF8/C1oe6G0LG2ZOUgs/c60hNEVm0at+fH32fe/XA7cZTugAvH5iX7f56npBRZ7DpMLQIy5mpkKhL7JoDMTRdY9j0N1hr8i5fEy4K2utzT30bGF2ff4QTNc+JrdhCcu+Fx1DBn0QdMiB8wJjhGDQL0tV0nkpJIE2kbJ1MSBn+Vxo4lnf5mY9PJ7Lb24aR32Cw7uUlte1XyFvmcGVQ14rADcHW0QGOc+IJjTnJ6Op+ImLn3ofWL9FJaDmlDNPBZ4LfUcilJJQbyuoiye5S7Eff0pbM9foN7Xu74uuico1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(366004)(39860400002)(376002)(33656002)(83380400001)(66946007)(6512007)(64756008)(66476007)(66556008)(66446008)(36756003)(478600001)(4326008)(86362001)(54906003)(53546011)(6506007)(6486002)(8936002)(7416002)(7366002)(7406005)(316002)(71200400001)(38100700001)(5660300002)(2616005)(91956017)(76116006)(26005)(6916009)(2906002)(8676002)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?KK++GEYweEUB/EZ5DV0uurrBn6z9JnpJjHci4FET96WGEcAA2TroR1jCF0s3?=
 =?us-ascii?Q?+zuJeSokoU1x6nhf8rWsSjdZEOjzsNuqsu8r+kRGQIzek1qokIHHYBcQ4/WN?=
 =?us-ascii?Q?yNcWuUMHFsebpS6U4K65ADbLp4EtbRh+2jthzZGx70L4+kZ+RN7N5liAuamE?=
 =?us-ascii?Q?kSWB79UyOiGFi2ajxEIEikMrMzrWShv/kxbOnN5qFaqif7uWCwh6REXroERP?=
 =?us-ascii?Q?fTH219pQB0Hr5fMbKiZCN7H2s3OJb0pjDbHQE8xc/JJ6cA1cpnoD9ghxIqLr?=
 =?us-ascii?Q?PMCyHKmGZZntYjzi04yyTUMAcEBAVQrgvQz501sBeY+D7hZmqAxqdBlQahdK?=
 =?us-ascii?Q?mqhu8M+idmaXfMcdx6KC8eY39EIyXpZN7FzdQZJidsHXNVTkiD0DJ5OnUB9h?=
 =?us-ascii?Q?WQ1aWVAJk655vSQmKsuxhzZHsIvjmNNFkHX43V0pJ9aHiPPiRBd18LZXaYeb?=
 =?us-ascii?Q?4rYn0TnakLA2rxId/7TmGzxXxOwJRiPJGKc1/Rx+QpJDGSDcaH6MvpPdKoI1?=
 =?us-ascii?Q?mkmc9D4mGZ6Lt1QaJ49zBAKpGasKHCYmk1XvyC99xlQP1qwXvM5gX2DJfIMV?=
 =?us-ascii?Q?gxGBuF+AFxDGfFI2RVcFavG5Td9GNx5mKo6W0l8s0uNNmbMlQqXETZ9/FKuF?=
 =?us-ascii?Q?/FIMmcQwwP/o22dk5Xevp0eklqcYNmATw1WNP2yoqT1OTbtnBromjKG/2OMh?=
 =?us-ascii?Q?5j/U/F+7VhpkOGpxm38MnL7uv2RbqlRWm9HaAtqWW7evnhdwQvFCJ53CgBF2?=
 =?us-ascii?Q?8DAkEFz/HMSAXABM/gXGxuNq3T6A4RmgQXDIeKeAcSLyTH9xub3xVOJ90s9T?=
 =?us-ascii?Q?hCf3soi184PxwVfYqZRPZgg+a1vNI5pT9BHKwGhmUB6LdQLxzJP1byzdhNKd?=
 =?us-ascii?Q?h8mP0O+VHISQumPqUsp7DVjjS/oUh9x5fDe1CZaHA2g30270JTjL9CMOM50H?=
 =?us-ascii?Q?DuT3UkIFLB/O29CAVQLN01h4guwD73gfiyetrz5xYcqId7U9WzHjQv1vUjyh?=
 =?us-ascii?Q?A6UyPcEtL0MQUAssgu/v1hPa+DFiQbjP7mKShZ6lRZidNS5d8OE890ryajeB?=
 =?us-ascii?Q?dKQbWR1NKFzEWSEKPKZRYmgD+/1CM8MjnVpls4/vZpz6gkPPgSaYg0F9XsMB?=
 =?us-ascii?Q?B6V65I4SGTF13WHI420tFNAE+kKJAAJqkNlrqS/cyjmpA9g/iIa2NJZdjl4Z?=
 =?us-ascii?Q?kzktW4isRDJMUjw5syqdzdYKTiwl2emtsU7yLkeJ8HD++t82NR3N/QI78QvN?=
 =?us-ascii?Q?3qGDyzwNbvuF5RtzRGUYUwE4TXc6iimYNUFKrCwMCPI8ryAkLlzbIioTmrh9?=
 =?us-ascii?Q?7q1lSt0oFzjYgzqo7mwbSWnI?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D62EBBF6794E7408545523A68F7C653@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf16839a-59fc-440a-7fc6-08d8fb662a45
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 14:45:48.5646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mNwNOTAxBPu1K4wUgi/1RTpjgipFNau8pXFBluvrkIjwOQkxDIYQoW1mvcRIHVPK/Wv84ryHZ0hGgA7yIe5Zcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3671
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9949 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104090110
X-Proofpoint-GUID: 6KS0KusKet8nE5slSniNY9EikOiXrCV8
X-Proofpoint-ORIG-GUID: 6KS0KusKet8nE5slSniNY9EikOiXrCV8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9949 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 clxscore=1015
 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104090110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 9, 2021, at 10:26 AM, Tom Talpey <tom@talpey.com> wrote:
>=20
> On 4/6/2021 7:49 AM, Jason Gunthorpe wrote:
>> On Mon, Apr 05, 2021 at 11:42:31PM +0000, Chuck Lever III wrote:
>> =20
>>> We need to get a better idea what correctness testing has been done,
>>> and whether positive correctness testing results can be replicated
>>> on a variety of platforms.
>> RO has been rolling out slowly on mlx5 over a few years and storage
>> ULPs are the last to change. eg the mlx5 ethernet driver has had RO
>> turned on for a long time, userspace HPC applications have been using
>> it for a while now too.
>=20
> I'd love to see RO be used more, it was always something the RDMA
> specs supported and carefully architected for. My only concern is
> that it's difficult to get right, especially when the platforms
> have been running strictly-ordered for so long. The ULPs need
> testing, and a lot of it.
>=20
>> We know there are platforms with broken RO implementations (like
>> Haswell) but the kernel is supposed to globally turn off RO on all
>> those cases. I'd be a bit surprised if we discover any more from this
>> series.
>> On the other hand there are platforms that get huge speed ups from
>> turning this on, AMD is one example, there are a bunch in the ARM
>> world too.
>=20
> My belief is that the biggest risk is from situations where completions
> are batched, and therefore polling is used to detect them without
> interrupts (which explicitly). The RO pipeline will completely reorder
> DMA writes, and consumers which infer ordering from memory contents may
> break. This can even apply within the provider code, which may attempt
> to poll WR and CQ structures, and be tripped up.

You are referring specifically to RPC/RDMA depending on Receive
completions to guarantee that previous RDMA Writes have been
retired? Or is there a particular implementation practice in
the Linux RPC/RDMA code that worries you?


> The Mellanox adapter, itself, historically has strict in-order DMA
> semantics, and while it's great to relax that, changing it by default
> for all consumers is something to consider very cautiously.
>=20
>> Still, obviously people should test on the platforms they have.
>=20
> Yes, and "test" be taken seriously with focus on ULP data integrity.
> Speedups will mean nothing if the data is ever damaged.

I agree that data integrity comes first.

Since I currently don't have facilities to test RO in my lab, the
community will have to agree on a set of tests and expected results
that specifically exercise the corner cases you are concerned about.


--
Chuck Lever



