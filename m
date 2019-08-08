Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29551866F7
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 18:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403802AbfHHQZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 12:25:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:38275 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732680AbfHHQZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 12:25:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 09:25:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,362,1559545200"; 
   d="scan'208";a="258761935"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga001.jf.intel.com with ESMTP; 08 Aug 2019 09:25:08 -0700
Received: from fmsmsx119.amr.corp.intel.com (10.18.124.207) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 8 Aug 2019 09:25:07 -0700
Received: from crsmsx104.amr.corp.intel.com (172.18.63.32) by
 FMSMSX119.amr.corp.intel.com (10.18.124.207) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 8 Aug 2019 09:25:07 -0700
Received: from crsmsx101.amr.corp.intel.com ([169.254.1.115]) by
 CRSMSX104.amr.corp.intel.com ([169.254.6.74]) with mapi id 14.03.0439.000;
 Thu, 8 Aug 2019 10:25:05 -0600
From:   "Weiny, Ira" <ira.weiny@intel.com>
To:     John Hubbard <jhubbard@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>
CC:     Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Jason Gunthorpe" <jgg@ziepe.ca>,
        =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "devel@lists.orangefs.org" <devel@lists.orangefs.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-rpi-kernel@lists.infradead.org" 
        <linux-rpi-kernel@lists.infradead.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: RE: [PATCH 00/34] put_user_pages(): miscellaneous call sites
Thread-Topic: [PATCH 00/34] put_user_pages(): miscellaneous call sites
Thread-Index: AQHVSNjU1EYxEMQcyke2Y16AlWiV+abn98YAgAA6ZwCAABzEgIAAB8CAgABJHoCABynCAIAAAqCAgAC1jYCAAIj3AIAAatiQ
Date:   Thu, 8 Aug 2019 16:25:04 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E79E79644@CRSMSX101.amr.corp.intel.com>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
 <20190802091244.GD6461@dhcp22.suse.cz>
 <20190802124146.GL25064@quack2.suse.cz>
 <20190802142443.GB5597@bombadil.infradead.org>
 <20190802145227.GQ25064@quack2.suse.cz>
 <076e7826-67a5-4829-aae2-2b90f302cebd@nvidia.com>
 <20190807083726.GA14658@quack2.suse.cz>
 <20190807084649.GQ11812@dhcp22.suse.cz>
 <20190808023637.GA1508@iweiny-DESK2.sc.intel.com>
 <e648a7f3-6a1b-c9ea-1121-7ab69b6b173d@nvidia.com>
In-Reply-To: <e648a7f3-6a1b-c9ea-1121-7ab69b6b173d@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzg1NWU5YjgtN2QxYy00YWI4LWFkMDAtZTkzNjZiYzAyZWZhIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidDZjeGJDdmV4UkoyZDkrSFdhT0RlXC9jalFDREdKeXlsWlJnSkxPamJtaXZuU2VIUmFYNG12UFE5cVIrbkR6QzkifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [172.18.205.10]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gT24gOC83LzE5IDc6MzYgUE0sIElyYSBXZWlueSB3cm90ZToNCj4gPiBPbiBXZWQsIEF1
ZyAwNywgMjAxOSBhdCAxMDo0Njo0OUFNICswMjAwLCBNaWNoYWwgSG9ja28gd3JvdGU6DQo+ID4+
IE9uIFdlZCAwNy0wOC0xOSAxMDozNzoyNiwgSmFuIEthcmEgd3JvdGU6DQo+ID4+PiBPbiBGcmkg
MDItMDgtMTkgMTI6MTQ6MDksIEpvaG4gSHViYmFyZCB3cm90ZToNCj4gPj4+PiBPbiA4LzIvMTkg
Nzo1MiBBTSwgSmFuIEthcmEgd3JvdGU6DQo+ID4+Pj4+IE9uIEZyaSAwMi0wOC0xOSAwNzoyNDo0
MywgTWF0dGhldyBXaWxjb3ggd3JvdGU6DQo+ID4+Pj4+PiBPbiBGcmksIEF1ZyAwMiwgMjAxOSBh
dCAwMjo0MTo0NlBNICswMjAwLCBKYW4gS2FyYSB3cm90ZToNCj4gPj4+Pj4+PiBPbiBGcmkgMDIt
MDgtMTkgMTE6MTI6NDQsIE1pY2hhbCBIb2NrbyB3cm90ZToNCj4gPj4+Pj4+Pj4gT24gVGh1IDAx
LTA4LTE5IDE5OjE5OjMxLCBqb2huLmh1YmJhcmRAZ21haWwuY29tIHdyb3RlOg0KPiAgIFsuLi5d
DQo+ID4gQmVmb3JlIEkgZ28gb24sIEkgd291bGQgbGlrZSB0byBzYXkgdGhhdCB0aGUgImltYmFs
YW5jZSIgb2YNCj4gPiBnZXRfdXNlcl9wYWdlcygpIGFuZCBwdXRfcGFnZSgpIGJvdGhlcnMgbWUg
ZnJvbSBhIHB1cmlzdCBzdGFuZHBvaW50Li4uDQo+ID4gSG93ZXZlciwgc2luY2UgdGhpcyBkaXNj
dXNzaW9uIGNyb3BwZWQgdXAgSSB3ZW50IGFoZWFkIGFuZCBwb3J0ZWQgbXkNCj4gPiB3b3JrIHRv
IExpbnVzJyBjdXJyZW50IG1hc3Rlcg0KPiA+ICg1LjMtcmMzKykgYW5kIGluIGRvaW5nIHNvIEkg
b25seSBoYWQgdG8gc3RlYWwgYSBiaXQgb2YgSm9obnMgY29kZS4uLg0KPiA+IFNvcnJ5IEpvaG4u
Li4gIDotKA0KPiA+DQo+ID4gSSBkb24ndCBoYXZlIHRoZSBjb21taXQgbWVzc2FnZXMgYWxsIGNs
ZWFuZWQgdXAgYW5kIEkga25vdyB0aGVyZSBtYXkNCj4gPiBiZSBzb21lIGRpc2N1c3Npb24gb24g
dGhlc2UgbmV3IGludGVyZmFjZXMgYnV0IEkgd2FudGVkIHRvIHRocm93IHRoaXMNCj4gPiBzZXJp
ZXMgb3V0IHRoZXJlIGJlY2F1c2UgSSB0aGluayBpdCBtYXkgYmUgd2hhdCBKYW4gYW5kIE1pY2hh
bCBhcmUNCj4gPiBkcml2aW5nIGF0IChvciBhdCBsZWFzdCBpbiB0aGF0IGRpcmVjdGlvbi4NCj4g
Pg0KPiA+IFJpZ2h0IG5vdyBvbmx5IFJETUEgYW5kIERBWCBGUydzIGFyZSBzdXBwb3J0ZWQuICBP
dGhlciB1c2VycyBvZiBHVVANCj4gPiB3aWxsIHN0aWxsIGZhaWwgb24gYSBEQVggZmlsZSBhbmQg
cmVndWxhciBmaWxlcyB3aWxsIHN0aWxsIGJlIGF0DQo+ID4gcmlzay5bMl0NCj4gPg0KPiA+IEkn
dmUgcHVzaGVkIHRoaXMgd29yayAoYmFzZWQgNS4zLXJjMysgKDMzOTIwZjFlYzViZikpIGhlcmVb
M106DQo+ID4NCj4gPiBodHRwczovL2dpdGh1Yi5jb20vd2VpbnkyL2xpbnV4LWtlcm5lbC90cmVl
L2xpbnVzLXJkbWFmc2RheC1iMC12Mw0KPiA+DQo+ID4gSSB0aGluayB0aGUgbW9zdCByZWxldmFu
dCBwYXRjaCB0byB0aGlzIGNvbnZlcnNhdGlvbiBpczoNCj4gPg0KPiA+IGh0dHBzOi8vZ2l0aHVi
LmNvbS93ZWlueTIvbGludXgtDQo+IGtlcm5lbC9jb21taXQvNWQzNzc2NTNiYTVjZjExYzNiNzE2
ZjkwDQo+ID4gNGIwNTdiZWU2NjQxYWFmNg0KPiA+DQo+IA0KPiBvaGhoLi4uY2FuIHlvdSBwbGVh
c2UgYXZvaWQgdXNpbmcgdGhlIG9sZCBfX3B1dF91c2VyX3BhZ2VzX2RpcnR5KCkNCj4gZnVuY3Rp
b24/IA0KDQpBZ3JlZWQuLi4gSSBkaWQgbm90IGxpa2UgdGhhdC4gIFBhcnQgb2YgdGhlIHJlYXNv
biBJIGRpZCBub3QgcG9zdCB0aGlzIGlzIEknbSBzdGlsbCB0cnlpbmcgdG8gZmlndXJlIG91dCB3
aGF0IGhhcyBsYW5kZWQgYW5kIHdoYXQgSSBjYW4gYW5kIGNhbid0IGRlcGVuZCBvbi4NCg0KRm9y
IGV4YW1wbGUsIENocmlzdG9waCBILiB3YXMgcHJvcG9zaW5nIGNoYW5nZXMgdG8gc29tZSBvZiB0
aGUgR1VQIGNhbGxzIHdoaWNoIG1heSBjb25mbGljdC4gIEJ1dCBJJ20gbm90IHN1cmUgaGlzIGNo
YW5nZXMgYXJlIG1vdmluZyBmb3J3YXJkLiAgU28gcmF0aGVyIHRoYW4gd2FpdGluZyBmb3IgdGhl
IGR1c3QgdG8gc2V0dGxlIEkgZGVjaWRlZCB0byBzZWUgaG93IGhhcmQgaXQgd291bGQgYmUgdG8g
Z2V0IHRoaXMgcmViYXNlZCBhZ2FpbnN0IG1haW5saW5lIGFuZCB3b3JraW5nLiAgVHVybnMgb3V0
IGl0IHdhcyBub3QgdG9vIGhhcmQuDQoNCkkgdGhpbmsgdGhhdCBpcyBiZWNhdXNlLCBhcyB0aW1l
IGhhcyBtb3ZlZCBvbiBpdCBzZWVtcyB0aGF0LCBmb3Igc29tZSB1c2VycyBzdWNoIGFzIFJETUEs
IGEgc2ltcGxlIHB1dF91c2VyX3BhZ2UoKSBpcyBub3QgZ29pbmcgdG8gYmUgc3VmZmljaWVudC4g
IFdlIG5lZWQgc29tZXRoaW5nIGVsc2UgdG8gYWxsb3cgR1VQIHRvIGtlZXAgdHJhY2sgb2YgdGhl
IGZpbGUgcGlucyBhcyB3ZSBkaXNjdXNzZWQuICBTbyBJJ20gc3RhcnRpbmcgdG8gdGhpbmsgc29t
ZSBvZiB0aGlzIGNvdWxkIGdvIGluIGF0IHRoZSBzYW1lIHRpbWUuDQoNCj4gSSB0aG91Z2h0IEkn
ZCBjYXVnaHQgdGhpbmdzIGVhcmx5IGVub3VnaCB0byBnZXQgYXdheSB3aXRoIHRoZQ0KPiByZW5h
bWUgYW5kIGRlbGV0aW9uIG9mIHRoYXQuIFlvdSBjb3VsZCBlaXRoZXI6DQo+IA0KPiBhKSBvcGVu
IGNvZGUgYW4gaW1wbGVtZW50YXRpb24gb2YgdmFkZHJfcHV0X3BhZ2VzX2RpcnR5X2xvY2soKSB0
aGF0DQo+IGRvZXNuJ3QgY2FsbCBhbnkgb2YgdGhlICpwdXRfdXNlcl9wYWdlc19kaXJ0eSooKSB2
YXJpYW50cywgb3INCj4gDQo+IGIpIGluY2x1ZGUgbXkgZmlyc3QgcGF0Y2ggKCIiKSBhcmUgcGFy
dCBvZiB5b3VyIHNlcmllcywgb3INCj4gDQo+IGMpIGJhc2UgdGhpcyBvbiBBbmRyZXdzJ3MgdHJl
ZSwgd2hpY2ggYWxyZWFkeSBoYXMgbWVyZ2VkIGluIG15IGZpcnN0IHBhdGNoLg0KPiANCg0KWWVw
IEkgY2FuIGRvIHRoaXMuICBJIGRpZCBub3QgcmVhbGl6ZSB0aGF0IEFuZHJldyBoYWQgYWNjZXB0
ZWQgYW55IG9mIHRoaXMgd29yay4gIEknbGwgY2hlY2sgb3V0IGhpcyB0cmVlLiAgQnV0IEkgZG9u
J3QgdGhpbmsgaGUgaXMgZ29pbmcgdG8gYWNjZXB0IHRoaXMgc2VyaWVzIHRocm91Z2ggaGlzIHRy
ZWUuICBTbyB3aGF0IGlzIHRoZSBFVEEgb24gdGhhdCBsYW5kaW5nIGluIExpbnVzJyB0cmVlPw0K
DQpUbyB0aGF0IHBvaW50IEknbSBzdGlsbCBub3Qgc3VyZSB3aG8gd291bGQgdGFrZSBhbGwgdGhp
cyBhcyBJIGFtIG5vdyB0b3VjaGluZyBtbSwgcHJvY2ZzLCByZG1hLCBleHQ0LCBhbmQgeGZzLg0K
DQpJIGp1c3QgdGhvdWdodCBJIHdvdWxkIGNoaW1lIGluIHdpdGggbXkgcHJvZ3Jlc3MgYmVjYXVz
ZSBJJ20gdG8gYSBwb2ludCB3aGVyZSB0aGluZ3MgYXJlIHdvcmtpbmcgYW5kIHNvIEkgY2FuIHN1
Ym1pdCB0aGUgY29kZSBidXQgSSdtIG5vdCBzdXJlIHdoYXQgSSBjYW4vc2hvdWxkIGRlcGVuZCBv
biBsYW5kaW5nLi4uICBBbHNvLCBub3cgdGhhdCAwZGF5IGhhcyBydW4gb3Zlcm5pZ2h0IGl0IGhh
cyBmb3VuZCBpc3N1ZXMgd2l0aCB0aGlzIHJlYmFzZSBzbyBJIG5lZWQgdG8gY2xlYW4gdGhvc2Ug
dXAuLi4gIFBlcmhhcHMgSSB3aWxsIGJhc2Ugb24gQW5kcmV3J3MgdHJlZSBwcmlvciB0byBkb2lu
ZyB0aGF0Li4uDQoNClRoYW5rcywNCklyYQ0KDQo+IA0KPiB0aGFua3MsDQo+IC0tDQo+IEpvaG4g
SHViYmFyZA0KPiBOVklESUENCg0K
