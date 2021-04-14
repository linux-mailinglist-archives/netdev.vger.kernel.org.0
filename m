Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D764035F65E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 16:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351774AbhDNOmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 10:42:19 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:32827 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349881AbhDNOmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 10:42:18 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-186-m3nor2MZPjeBIWMoTKeI3A-1; Wed, 14 Apr 2021 15:41:53 +0100
X-MC-Unique: m3nor2MZPjeBIWMoTKeI3A-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Wed, 14 Apr 2021 15:41:52 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Wed, 14 Apr 2021 15:41:52 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tom Talpey' <tom@talpey.com>, Jason Gunthorpe <jgg@nvidia.com>
CC:     Haakon Bugge <haakon.bugge@oracle.com>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
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
        "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        "Jack Wang" <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bruce Fields <bfields@fieldses.org>, Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        "Michael Guralnik" <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Linux-Net <netdev@vger.kernel.org>,
        "Potnuri Bharat Teja" <bharat@chelsio.com>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "Santosh Shilimkar" <santosh.shilimkar@oracle.com>,
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
Subject: RE: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Thread-Topic: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Thread-Index: AQHXLWixzqpV3HG00U+6H5w8s2gjs6qtuZCggAZdLuKAAAS+kA==
Date:   Wed, 14 Apr 2021 14:41:52 +0000
Message-ID: <c2318ee1464a4d1c8439699cb0652d12@AcuMS.aculab.com>
References: <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
 <20210406114952.GH7405@nvidia.com>
 <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
 <8A5E83DF-5C08-49CE-8EE3-08DC63135735@oracle.com>
 <4b02d1b2-be0e-0d1d-7ac3-38d32e44e77e@talpey.com>
 <1FA38618-E245-4C53-BF49-6688CA93C660@oracle.com>
 <7b9e7d9c-13d7-0d18-23b4-0d94409c7741@talpey.com>
 <f71b24433f4540f0a13133111a59dab8@AcuMS.aculab.com>
 <880A23A2-F078-42CF-BEE2-30666BCB9B5D@oracle.com>
 <7deadc67-650c-ea15-722b-a1d77d38faba@talpey.com>
 <20210412224843.GQ7405@nvidia.com>
 <02593083-056e-cc62-22cf-d6bd6c9b18a8@talpey.com>
In-Reply-To: <02593083-056e-cc62-22cf-d6bd6c9b18a8@talpey.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVG9tIFRhbHBleQ0KPiBTZW50OiAxNCBBcHJpbCAyMDIxIDE1OjE2DQo+IA0KPiBPbiA0
LzEyLzIwMjEgNjo0OCBQTSwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiA+IE9uIE1vbiwgQXBy
IDEyLCAyMDIxIGF0IDA0OjIwOjQ3UE0gLTA0MDAsIFRvbSBUYWxwZXkgd3JvdGU6DQo+ID4NCj4g
Pj4gU28gdGhlIGlzc3VlIGlzIG9ubHkgaW4gdGVzdGluZyBhbGwgdGhlIHByb3ZpZGVycyBhbmQg
cGxhdGZvcm1zLA0KPiA+PiB0byBiZSBzdXJlIHRoaXMgbmV3IGJlaGF2aW9yIGlzbid0IHRpY2ts
aW5nIGFueXRoaW5nIHRoYXQgd2VudA0KPiA+PiB1bm5vdGljZWQgYWxsIGFsb25nLCBiZWNhdXNl
IG5vIFJETUEgcHJvdmlkZXIgZXZlciBpc3N1ZWQgUk8uDQo+ID4NCj4gPiBUaGUgbWx4NSBldGhl
cm5ldCBkcml2ZXIgaGFzIHJ1biBpbiBSTyBtb2RlIGZvciBhIGxvbmcgdGltZSwgYW5kIGl0DQo+
ID4gb3BlcmF0ZXMgaW4gYmFzaWNhbGx5IHRoZSBzYW1lIHdheSBhcyBSRE1BLiBUaGUgaXNzdWVz
IHdpdGggSGFzd2VsbA0KPiA+IGhhdmUgYmVlbiB3b3JrZWQgb3V0IHRoZXJlIGFscmVhZHkuDQo+
ID4NCj4gPiBUaGUgb25seSBvcGVuIHF1ZXN0aW9uIGlzIGlmIHRoZSBVTFBzIGhhdmUgZXJyb3Jz
IGluIHRoZWlyDQo+ID4gaW1wbGVtZW50YXRpb24sIHdoaWNoIEkgZG9uJ3QgdGhpbmsgd2UgY2Fu
IGZpbmQgb3V0IHVudGlsIHdlIGFwcGx5DQo+ID4gdGhpcyBzZXJpZXMgYW5kIHBlb3BsZSBzdGFy
dCBydW5uaW5nIHRoZWlyIHRlc3RzIGFnZ3Jlc3NpdmVseS4NCj4gDQo+IEkgYWdyZWUgdGhhdCB0
aGUgY29yZSBSTyBzdXBwb3J0IHNob3VsZCBnbyBpbi4gQnV0IHR1cm5pbmcgaXQgb24NCj4gYnkg
ZGVmYXVsdCBmb3IgYSBVTFAgc2hvdWxkIGJlIHRoZSBkZWNpc2lvbiBvZiBlYWNoIFVMUCBtYWlu
dGFpbmVyLg0KPiBJdCdzIGEgaHVnZSByaXNrIHRvIHNoaWZ0IGFsbCB0aGUgc3RvcmFnZSBkcml2
ZXJzIG92ZXJuaWdodC4gSG93DQo+IGRvIHlvdSBwcm9wb3NlIHRvIGVuc3VyZSB0aGUgYWdncmVz
c2l2ZSB0ZXN0aW5nIGhhcHBlbnM/DQo+IA0KPiBPbmUgdGhpbmcgdGhhdCB3b3JyaWVzIG1lIGlz
IHRoZSBwYXRjaDAyIG9uLWJ5LWRlZmF1bHQgZm9yIHRoZSBkbWFfbGtleS4NCj4gVGhlcmUncyBu
byB3YXkgZm9yIGEgVUxQIHRvIHByZXZlbnQgSUJfQUNDRVNTX1JFTEFYRURfT1JERVJJTkcNCj4g
ZnJvbSBiZWluZyBzZXQgaW4gX19pYl9hbGxvY19wZCgpLg0KDQpXaGF0IGlzIGEgVUxQIGluIHRo
aXMgY29udGV4dD8NCg0KSSd2ZSBwcmVzdW1lZCB0aGF0IHRoaXMgaXMgYWxsIGFib3V0IGdldHRp
bmcgUENJZSB0YXJnZXRzIChpZSBjYXJkcykNCnRvIHNldCB0aGUgUk8gKHJlbGF4ZWQgb3JkZXJp
bmcpIGJpdCBpbiBzb21lIG9mIHRoZSB3cml0ZSBUTFAgdGhleQ0KZ2VuZXJhdGUgZm9yIHdyaXRp
bmcgdG8gaG9zdCBtZW1vcnk/DQoNClNvIHdoYXRldmVyIGRyaXZlciBpbml0aWFsaXNlcyB0aGUg
dGFyZ2V0IG5lZWRzIHRvIGNvbmZpZ3VyZSB3aGF0ZXZlcg0KdGFyZ2V0LXNwZWNpZmljIHJlZ2lz
dGVyIGVuYWJsZXMgdGhlIFJPIHRyYW5zZmVycyB0aGVtc2VsdmVzLg0KDQpBZnRlciB0aGF0IHRo
ZXJlIGNvdWxkIGJlIGZsYWdzIGluIHRoZSBQQ0llIGNvbmZpZyBzcGFjZSBvZiB0aGUgdGFyZ2V0
DQphbmQgYW55IGJyaWRnZXMgdGhhdCBjbGVhciB0aGUgUk8gZmxhZy4NCg0KVGhlcmUgY291bGQg
YWxzbyBiZSBmbGFncyBpbiB0aGUgYnJpZGdlcyBhbmQgcm9vdCBjb21wbGV4IHRvIGlnbm9yZQ0K
dGhlIFJPIGZsYWcgZXZlbiBpZiBpdCBpcyBzZXQuDQoNClRoZW4gdGhlIExpbnV4IGtlcm5lbCBj
YW4gaGF2ZSBvcHRpb24ocykgdG8gdGVsbCB0aGUgZHJpdmVyIG5vdA0KdG8gZW5hYmxlIFJPIC0g
ZXZlbiB0aG91Z2ggdGhlIGRyaXZlciBiZWxpZXZlcyBpdCBzaG91bGQgYWxsIHdvcmsuDQpUaGlz
IGNvdWxkIGJlIGEgc2luZ2xlIGdsb2JhbCBmbGFnLCBvciBmaW4tZ3JhaW5lZCBpbiBzb21lIHdh
eS4NCg0KU28gd2hhdCBleGFjdGx5IGlzIHRoaXMgcGF0Y2ggc2VyaWVzIGRvaW5nPw0KDQoJRGF2
aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50
IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTcz
ODYgKFdhbGVzKQ0K

