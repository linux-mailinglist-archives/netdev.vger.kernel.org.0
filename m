Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3604835AD9E
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 15:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhDJNav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 09:30:51 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:48509 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234668AbhDJNar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 09:30:47 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-210-bm-DHej2NTiib0mw0GQynw-1; Sat, 10 Apr 2021 14:30:28 +0100
X-MC-Unique: bm-DHej2NTiib0mw0GQynw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Sat, 10 Apr 2021 14:30:27 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.012; Sat, 10 Apr 2021 14:30:27 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tom Talpey' <tom@talpey.com>,
        Haakon Bugge <haakon.bugge@oracle.com>
CC:     Chuck Lever III <chuck.lever@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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
Thread-Index: AQHXLWixzqpV3HG00U+6H5w8s2gjs6qtuZCg
Date:   Sat, 10 Apr 2021 13:30:26 +0000
Message-ID: <f71b24433f4540f0a13133111a59dab8@AcuMS.aculab.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de> <20210405200739.GB7405@nvidia.com>
 <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
 <20210406114952.GH7405@nvidia.com>
 <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
 <8A5E83DF-5C08-49CE-8EE3-08DC63135735@oracle.com>
 <4b02d1b2-be0e-0d1d-7ac3-38d32e44e77e@talpey.com>
 <1FA38618-E245-4C53-BF49-6688CA93C660@oracle.com>
 <7b9e7d9c-13d7-0d18-23b4-0d94409c7741@talpey.com>
In-Reply-To: <7b9e7d9c-13d7-0d18-23b4-0d94409c7741@talpey.com>
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

RnJvbTogVG9tIFRhbHBleQ0KPiBTZW50OiAwOSBBcHJpbCAyMDIxIDE4OjQ5DQo+IE9uIDQvOS8y
MDIxIDEyOjI3IFBNLCBIYWFrb24gQnVnZ2Ugd3JvdGU6DQo+ID4NCj4gPg0KPiA+PiBPbiA5IEFw
ciAyMDIxLCBhdCAxNzozMiwgVG9tIFRhbHBleSA8dG9tQHRhbHBleS5jb20+IHdyb3RlOg0KPiA+
Pg0KPiA+PiBPbiA0LzkvMjAyMSAxMDo0NSBBTSwgQ2h1Y2sgTGV2ZXIgSUlJIHdyb3RlOg0KPiA+
Pj4+IE9uIEFwciA5LCAyMDIxLCBhdCAxMDoyNiBBTSwgVG9tIFRhbHBleSA8dG9tQHRhbHBleS5j
b20+IHdyb3RlOg0KPiA+Pj4+DQo+ID4+Pj4gT24gNC82LzIwMjEgNzo0OSBBTSwgSmFzb24gR3Vu
dGhvcnBlIHdyb3RlOg0KPiA+Pj4+PiBPbiBNb24sIEFwciAwNSwgMjAyMSBhdCAxMTo0MjozMVBN
ICswMDAwLCBDaHVjayBMZXZlciBJSUkgd3JvdGU6DQo+ID4+Pj4+DQo+ID4+Pj4+PiBXZSBuZWVk
IHRvIGdldCBhIGJldHRlciBpZGVhIHdoYXQgY29ycmVjdG5lc3MgdGVzdGluZyBoYXMgYmVlbiBk
b25lLA0KPiA+Pj4+Pj4gYW5kIHdoZXRoZXIgcG9zaXRpdmUgY29ycmVjdG5lc3MgdGVzdGluZyBy
ZXN1bHRzIGNhbiBiZSByZXBsaWNhdGVkDQo+ID4+Pj4+PiBvbiBhIHZhcmlldHkgb2YgcGxhdGZv
cm1zLg0KPiA+Pj4+PiBSTyBoYXMgYmVlbiByb2xsaW5nIG91dCBzbG93bHkgb24gbWx4NSBvdmVy
IGEgZmV3IHllYXJzIGFuZCBzdG9yYWdlDQo+ID4+Pj4+IFVMUHMgYXJlIHRoZSBsYXN0IHRvIGNo
YW5nZS4gZWcgdGhlIG1seDUgZXRoZXJuZXQgZHJpdmVyIGhhcyBoYWQgUk8NCj4gPj4+Pj4gdHVy
bmVkIG9uIGZvciBhIGxvbmcgdGltZSwgdXNlcnNwYWNlIEhQQyBhcHBsaWNhdGlvbnMgaGF2ZSBi
ZWVuIHVzaW5nDQo+ID4+Pj4+IGl0IGZvciBhIHdoaWxlIG5vdyB0b28uDQo+ID4+Pj4NCj4gPj4+
PiBJJ2QgbG92ZSB0byBzZWUgUk8gYmUgdXNlZCBtb3JlLCBpdCB3YXMgYWx3YXlzIHNvbWV0aGlu
ZyB0aGUgUkRNQQ0KPiA+Pj4+IHNwZWNzIHN1cHBvcnRlZCBhbmQgY2FyZWZ1bGx5IGFyY2hpdGVj
dGVkIGZvci4gTXkgb25seSBjb25jZXJuIGlzDQo+ID4+Pj4gdGhhdCBpdCdzIGRpZmZpY3VsdCB0
byBnZXQgcmlnaHQsIGVzcGVjaWFsbHkgd2hlbiB0aGUgcGxhdGZvcm1zDQo+ID4+Pj4gaGF2ZSBi
ZWVuIHJ1bm5pbmcgc3RyaWN0bHktb3JkZXJlZCBmb3Igc28gbG9uZy4gVGhlIFVMUHMgbmVlZA0K
PiA+Pj4+IHRlc3RpbmcsIGFuZCBhIGxvdCBvZiBpdC4NCj4gPj4+Pg0KPiA+Pj4+PiBXZSBrbm93
IHRoZXJlIGFyZSBwbGF0Zm9ybXMgd2l0aCBicm9rZW4gUk8gaW1wbGVtZW50YXRpb25zIChsaWtl
DQo+ID4+Pj4+IEhhc3dlbGwpIGJ1dCB0aGUga2VybmVsIGlzIHN1cHBvc2VkIHRvIGdsb2JhbGx5
IHR1cm4gb2ZmIFJPIG9uIGFsbA0KPiA+Pj4+PiB0aG9zZSBjYXNlcy4gSSdkIGJlIGEgYml0IHN1
cnByaXNlZCBpZiB3ZSBkaXNjb3ZlciBhbnkgbW9yZSBmcm9tIHRoaXMNCj4gPj4+Pj4gc2VyaWVz
Lg0KPiA+Pj4+PiBPbiB0aGUgb3RoZXIgaGFuZCB0aGVyZSBhcmUgcGxhdGZvcm1zIHRoYXQgZ2V0
IGh1Z2Ugc3BlZWQgdXBzIGZyb20NCj4gPj4+Pj4gdHVybmluZyB0aGlzIG9uLCBBTUQgaXMgb25l
IGV4YW1wbGUsIHRoZXJlIGFyZSBhIGJ1bmNoIGluIHRoZSBBUk0NCj4gPj4+Pj4gd29ybGQgdG9v
Lg0KPiA+Pj4+DQo+ID4+Pj4gTXkgYmVsaWVmIGlzIHRoYXQgdGhlIGJpZ2dlc3QgcmlzayBpcyBm
cm9tIHNpdHVhdGlvbnMgd2hlcmUgY29tcGxldGlvbnMNCj4gPj4+PiBhcmUgYmF0Y2hlZCwgYW5k
IHRoZXJlZm9yZSBwb2xsaW5nIGlzIHVzZWQgdG8gZGV0ZWN0IHRoZW0gd2l0aG91dA0KPiA+Pj4+
IGludGVycnVwdHMgKHdoaWNoIGV4cGxpY2l0bHkpLiBUaGUgUk8gcGlwZWxpbmUgd2lsbCBjb21w
bGV0ZWx5IHJlb3JkZXINCj4gPj4+PiBETUEgd3JpdGVzLCBhbmQgY29uc3VtZXJzIHdoaWNoIGlu
ZmVyIG9yZGVyaW5nIGZyb20gbWVtb3J5IGNvbnRlbnRzIG1heQ0KPiA+Pj4+IGJyZWFrLiBUaGlz
IGNhbiBldmVuIGFwcGx5IHdpdGhpbiB0aGUgcHJvdmlkZXIgY29kZSwgd2hpY2ggbWF5IGF0dGVt
cHQNCj4gPj4+PiB0byBwb2xsIFdSIGFuZCBDUSBzdHJ1Y3R1cmVzLCBhbmQgYmUgdHJpcHBlZCB1
cC4NCj4gPj4+IFlvdSBhcmUgcmVmZXJyaW5nIHNwZWNpZmljYWxseSB0byBSUEMvUkRNQSBkZXBl
bmRpbmcgb24gUmVjZWl2ZQ0KPiA+Pj4gY29tcGxldGlvbnMgdG8gZ3VhcmFudGVlIHRoYXQgcHJl
dmlvdXMgUkRNQSBXcml0ZXMgaGF2ZSBiZWVuDQo+ID4+PiByZXRpcmVkPyBPciBpcyB0aGVyZSBh
IHBhcnRpY3VsYXIgaW1wbGVtZW50YXRpb24gcHJhY3RpY2UgaW4NCj4gPj4+IHRoZSBMaW51eCBS
UEMvUkRNQSBjb2RlIHRoYXQgd29ycmllcyB5b3U/DQo+ID4+DQo+ID4+IE5vdGhpbmcgaW4gdGhl
IFJQQy9SRE1BIGNvZGUsIHdoaWNoIGlzIElNTyBjb3JyZWN0LiBUaGUgd29ycnksIHdoaWNoDQo+
ID4+IGlzIGhvcGVmdWxseSB1bmZvdW5kZWQsIGlzIHRoYXQgdGhlIFJPIHBpcGVsaW5lIG1pZ2h0
IG5vdCBoYXZlIGZsdXNoZWQNCj4gPj4gd2hlbiBhIGNvbXBsZXRpb24gaXMgcG9zdGVkICphZnRl
ciogcG9zdGluZyBhbiBpbnRlcnJ1cHQuDQo+ID4+DQo+ID4+IFNvbWV0aGluZyBsaWtlIHRoaXMu
Li4NCj4gPj4NCj4gPj4gUkRNQSBXcml0ZSBhcnJpdmVzDQo+ID4+IAlQQ0llIFJPIFdyaXRlIGZv
ciBkYXRhDQo+ID4+IAlQQ0llIFJPIFdyaXRlIGZvciBkYXRhDQo+ID4+IAkuLi4NCj4gPj4gUkRN
QSBXcml0ZSBhcnJpdmVzDQo+ID4+IAlQQ0llIFJPIFdyaXRlIGZvciBkYXRhDQo+ID4+IAkuLi4N
Cj4gPj4gUkRNQSBTZW5kIGFycml2ZXMNCj4gPj4gCVBDSWUgUk8gV3JpdGUgZm9yIHJlY2VpdmUg
ZGF0YQ0KPiA+PiAJUENJZSBSTyBXcml0ZSBmb3IgcmVjZWl2ZSBkZXNjcmlwdG9yDQo+ID4NCj4g
PiBEbyB5b3UgbWVhbiB0aGUgV3JpdGUgb2YgdGhlIENRRT8gSXQgaGFzIHRvIGJlIFN0cm9uZ2x5
IE9yZGVyZWQgZm9yIGEgY29ycmVjdCBpbXBsZW1lbnRhdGlvbi4gVGhlbg0KPiBpdCB3aWxsIHNo
dXJlIHByaW9yIHdyaXR0ZW4gUk8gZGF0ZSBoYXMgZ2xvYmFsIHZpc2liaWxpdHkgd2hlbiB0aGUg
Q1FFIGNhbiBiZSBvYnNlcnZlZC4NCj4gDQo+IEkgd2Fzbid0IGF3YXJlIHRoYXQgYSBzdHJvbmds
eS1vcmRlcmVkIFBDSWUgV3JpdGUgd2lsbCBlbnN1cmUgdGhhdA0KPiBwcmlvciByZWxheGVkLW9y
ZGVyZWQgd3JpdGVzIHdlbnQgZmlyc3QuIElmIHRoYXQncyB0aGUgY2FzZSwgSSdtDQo+IGZpbmUg
d2l0aCBpdCAtIGFzIGxvbmcgYXMgdGhlIHByb3ZpZGVycyBhcmUgY29ycmVjdGx5IGNvZGVkISEN
Cg0KSSByZW1lbWJlciB0cnlpbmcgdG8gcmVhZCB0aGUgcmVsZXZhbnQgc2VjdGlvbiBvZiB0aGUg
UENJZSBzcGVjLg0KKFBvc3NpYmx5IGluIGEgYm9vayB0aGF0IHdhcyB0cnlpbmcgdG8gbWFrZSBp
dCBlYXNpZXIgdG8gdW5kZXJzdGFuZCEpDQpJdCBpcyBhYm91dCBhcyBjbGVhciBhcyBtdWQuDQoN
CkkgcHJlc3VtZSB0aGlzIGlzIGFsbCBhYm91dCBhbGxvd2luZyBQQ0llIHRhcmdldHMgKGVnIGV0
aGVybmV0IGNhcmRzKQ0KdG8gdXNlIHJlbGF4ZWQgb3JkZXJpbmcgb24gd3JpdGUgcmVxdWVzdHMg
dG8gaG9zdCBtZW1vcnkuDQpBbmQgdGhhdCBzdWNoIHdyaXRlcyBjYW4gYmUgY29tcGxldGVkIG91
dCBvZiBvcmRlcj8NCg0KSXQgaXNuJ3QgZW50aXJlbHkgY2xlYXIgdGhhdCB5b3UgYXJlbid0IHRh
bGtpbmcgb2YgbGV0dGluZyB0aGUNCmNwdSBkbyAncmVsYXhlZCBvcmRlcicgd3JpdGVzIHRvIFBD
SWUgdGFyZ2V0cyENCg0KRm9yIGEgdHlwaWNhbCBldGhlcm5ldCBkcml2ZXIgdGhlIHJlY2VpdmUg
aW50ZXJydXB0IGp1c3QgbWVhbnMNCidnbyBhbmQgbG9vayBhdCB0aGUgcmVjZWl2ZSBkZXNjcmlw
dG9yIHJpbmcnLg0KU28gdGhlcmUgaXMgYW4gYWJzb2x1dGUgcmVxdWlyZW1lbnQgdGhhdCB0aGUg
d3JpdGVzIGZvciBkYXRhDQpidWZmZXIgY29tcGxldGUgYmVmb3JlIHRoZSB3cml0ZSB0byB0aGUg
cmVjZWl2ZSBkZXNjcmlwdG9yLg0KVGhlcmUgaXMgbm8gcmVxdWlyZW1lbnQgZm9yIHRoZSBpbnRl
cnJ1cHQgKHJlcXVlc3RlZCBhZnRlciB0aGUNCmRlc2NyaXB0b3Igd3JpdGUpIHRvIGhhdmUgYmVl
biBzZWVuIGJ5IHRoZSBjcHUuDQoNClF1aXRlIG9mdGVuIHRoZSBkcml2ZXIgd2lsbCBmaW5kIHRo
ZSAncmVjZWl2ZSBjb21wbGV0ZScNCmRlc2NyaXB0b3Igd2hlbiBwcm9jZXNzaW5nIGZyYW1lcyBm
cm9tIGFuIGVhcmxpZXIgaW50ZXJydXB0DQooYW5kIG5vdGhpbmcgdG8gZG8gaW4gcmVzcG9uc2Ug
dG8gdGhlIGludGVycnVwdCBpdHNlbGYpLg0KDQpTbyB0aGUgd3JpdGUgdG8gdGhlIHJlY2VpdmUg
ZGVzY3JpcHRvciB3b3VsZCBoYXZlIHRvIGhhdmUgUk8gY2xlYXINCnRvIGVuc3VyZSB0aGF0IGFs
bCB0aGUgYnVmZmVyIHdyaXRlcyBjb21wbGV0ZSBmaXJzdC4NCg0KKFRoZSBmdXJ0aGVzdCBJJ3Zl
IGdvdCBpbnRvIFBDSWUgaW50ZXJuYWxzIHdhcyBmaXhpbmcgdGhlIGJ1Zw0KaW4gc29tZSB2ZW5k
b3Itc3VwcGxpZWQgRlBHQSBsb2dpYyB0aGF0IGZhaWxlZCB0byBjb3JyZWN0bHkNCmhhbmRsZSBt
dWx0aXBsZSBkYXRhIFRMUCByZXNwb25zZXMgdG8gYSBzaW5nbGUgcmVhZCBUTFAuDQpGb3J0dW5h
dGVseSBpdCB3YXNuJ3QgaW4gdGhlIGhhcmQtSVAgYml0LikNCg0KCURhdmlkDQoNCi0NClJlZ2lz
dGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24g
S2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

