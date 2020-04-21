Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110261B330F
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 01:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgDUX1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 19:27:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:9759 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbgDUX1d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 19:27:33 -0400
IronPort-SDR: EpkZGjS1fOXUKrRa5UdreniWy9XPn91bxMTXoAhxB7HA95MI9MfGgVlgIIqqyZxBh+xx+ChEOU
 sQB8+U4o2yZw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:27:17 -0700
IronPort-SDR: vpwEruGXWtfAXCVoD0904u/eWx2tbj8FJX177T8CAOgYM7mmv0VJf7u8Crqu2xdV40teAU85HN
 t7dn4UeDKblg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="456284753"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga005.fm.intel.com with ESMTP; 21 Apr 2020 16:27:17 -0700
Received: from fmsmsx151.amr.corp.intel.com (10.18.125.4) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 16:27:16 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 FMSMSX151.amr.corp.intel.com (10.18.125.4) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 16:27:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 21 Apr 2020 16:27:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVobF1u1ybOSFW/Ce2tWQOIBq14RYXCyfWeVxWtmuaEVlbnqbWeTQt56KYVHVAc/6cJAU/nfzRoqcHWBdJgPUyJTt3C2Ycs/eXq4EhWas7k0Z+nr+QLY3lrmjzU2cNL5z3HA6mocO6QliNsi1NpPnKtLqoAqVYpAtr4eMibu0zZrFw6Fwg7MxA9OduGXBpD7WpA5AJTdVxJX9+TP8Fi0SEbZmdFL9hSjL092kVTV8Vbiw94bTZuPTfJ4QGID6X3L3RwCNCBzD2Uc2yqrLS60f0tLRpH4ZuE2UJYIfMQsg7pOA0q9bqfu6yGeFwSyRftwfUYctz+PjSZCd/+pp1DDAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDGCPWEAwGtCfs1ciOToQRx8LXYyUZ3CdlR2ZoItZm0=;
 b=k5oUGkSYpt6aFfCOAAmTcWdywllUDOkbgkiwC3lAPAWUJZ0VMI3g2LZ82hQDAw2CtTl/AonkoP5uaSx19hCS81F0nTs6X1s3idc36t/f2LqmgAW40S3u5qto5Y2ncenh06IMhGplyn9W/S5rqIYOpdAexd0WFu5Xrtg6JrQod6+dbULBb3dV/vqqcI/I3hgu3wUl6xTChXSBpermdohoktKe9W6AQGxEh0Oe81OKRdOKzq73NWD2LKun+fB6lPO2L49UPwwuORFeWnwFa84iRqmCuK92W3o64tcjTj4yOJ0RPGSozWmnKqNeKHxUq5gK+wBet//mH5li3CoRdtL+HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDGCPWEAwGtCfs1ciOToQRx8LXYyUZ3CdlR2ZoItZm0=;
 b=SR8BmDQrYuQ8sH8aFxr6tub3bP8t8Q3lNPjFtBzR/u+7Yzv5QDb/fTZTG9KdfvyVE9coY55e50etkndbhsv8TW+k9qIS+K97vIgkrkQfjO8XiD4tXPbzI68v+D6nr9bz4zQndV+KtgGOwTgJR4CwvwM9yWhvNarod73xUUEJ4jg=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB4594.namprd11.prod.outlook.com (2603:10b6:5:2a0::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.29; Tue, 21 Apr 2020 23:27:03 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::7069:6745:3ad1:bcde]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::7069:6745:3ad1:bcde%6]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 23:27:03 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "selvin.xavier@broadcom.com" <selvin.xavier@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "bharat@chelsio.com" <bharat@chelsio.com>,
        "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "leonro@mellanox.com" <leonro@mellanox.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aditr@vmware.com" <aditr@vmware.com>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 1/9] Implementation of Virtual Bus
Thread-Topic: [net-next 1/9] Implementation of Virtual Bus
Thread-Index: AQHWFNtEAfnineIPqEqJBqKNZCsJ6ah9uYwAgASKCECAAH7aAIABH23g
Date:   Tue, 21 Apr 2020 23:27:03 +0000
Message-ID: <DM6PR11MB28414BEF48AB56336F3456DEDDD50@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
 <20200417171034.1533253-2-jeffrey.t.kirsher@intel.com>
 <20200417195148.GL26002@ziepe.ca>
 <DM6PR11MB284111B69E966E68EBC2C508DDD40@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20200421004454.GP26002@ziepe.ca>
In-Reply-To: <20200421004454.GP26002@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=david.m.ertman@intel.com; 
x-originating-ip: [50.38.43.118]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af99190e-f640-4aee-d690-08d7e64b7fb5
x-ms-traffictypediagnostic: DM6PR11MB4594:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4594B75144263C53B71E4011DDD50@DM6PR11MB4594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(55016002)(9686003)(76116006)(64756008)(66946007)(33656002)(498600001)(66476007)(66446008)(52536014)(8936002)(66556008)(5660300002)(2906002)(7416002)(86362001)(7696005)(54906003)(8676002)(53546011)(81156014)(71200400001)(6506007)(6916009)(186003)(4326008)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 69XSa4PWSYjd00wYQF+ARJx+peAFE3Hzy3C52stPc/muAjcRnUMn1LwwFnuijyegtdhGkA6G4isvbiVim+Q4RkIWXbAO1CWeiutKSaetST4Uf9NN88YxMtscVxKfZO1vouNX3M+7B9GJV1sJnVBofALkeoy4LZlbzjiva9S9CrB7FUSsye3I2+fiC+iRZKS/b6pru9nLwCoPi0TAAUj3LI2i8HHC7V9XzE3kn9tlsrSRtVZCC87Cqjs5gs+Vs29+qmPEMeUrZLghxbfJNc4Gb08BFFH19FFxAAjEea5iRZtn/CFHMz2kPSt5y+eCGZaqyN4Ki7OPJ4IraIfpiWygZazWo7rb/daB03lSF+52A3fZP0udFxXldNTCwIb4KXt8fbA+iULgKdc5+rSLzmaL1MY8opMD7TB5jzZP5jQxvPT2z5tM71Vvv77aGjFsDYd/
x-ms-exchange-antispam-messagedata: RXeNRZIhdGuailB+G4fO5gbDI/Css7sAdSybwD8WY+iX1g93A+JUi4UoH7bn+2p/I0U22S+t08p+rdLgnOp3dFfAv/NaNRcpf88t4re/LbSeMC/3o+LW8lV54QlAwQYBbdpAU6Lq7/TXcxmTDcxxgg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: af99190e-f640-4aee-d690-08d7e64b7fb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2020 23:27:03.4704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0/QDDVSCYz40vrMMduLxeBNjOzCX+offocIoQzC8VCuGvaKioyKb2w4IH3p40pqD41F6pOxnGvkuzZRe+65Anl/CYx1FHMhVcAgyzEozCGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4594
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpn
Z0B6aWVwZS5jYT4NCj4gU2VudDogTW9uZGF5LCBBcHJpbCAyMCwgMjAyMCA1OjQ1IFBNDQo+IFRv
OiBFcnRtYW4sIERhdmlkIE0gPGRhdmlkLm0uZXJ0bWFuQGludGVsLmNvbT4NCj4gQ2M6IEtpcnNo
ZXIsIEplZmZyZXkgVCA8amVmZnJleS50LmtpcnNoZXJAaW50ZWwuY29tPjsgZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsNCj4gZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc7IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LQ0KPiByZG1hQHZnZXIua2VybmVsLm9yZzsgbmhvcm1hbkByZWRoYXQuY29t
OyBzYXNzbWFubkByZWRoYXQuY29tOw0KPiBwYXJhdkBtZWxsYW5veC5jb207IGdhbHByZXNzQGFt
YXpvbi5jb207DQo+IHNlbHZpbi54YXZpZXJAYnJvYWRjb20uY29tOyBzcmloYXJzaGEuYmFzYXZh
cGF0bmFAYnJvYWRjb20uY29tOw0KPiBiZW52ZUBjaXNjby5jb207IGJoYXJhdEBjaGVsc2lvLmNv
bTsgeGF2aWVyLmh1d2VpQGh1YXdlaS5jb207DQo+IHlpc2hhaWhAbWVsbGFub3guY29tOyBsZW9u
cm9AbWVsbGFub3guY29tOyBta2FsZGVyb25AbWFydmVsbC5jb207DQo+IGFkaXRyQHZtd2FyZS5j
b207IHJhbmphbmkuc3JpZGhhcmFuQGxpbnV4LmludGVsLmNvbTsgcGllcnJlLQ0KPiBsb3Vpcy5i
b3NzYXJ0QGxpbnV4LmludGVsLmNvbTsgUGF0aWwsIEtpcmFuIDxraXJhbi5wYXRpbEBpbnRlbC5j
b20+OyBCb3dlcnMsDQo+IEFuZHJld1ggPGFuZHJld3guYm93ZXJzQGludGVsLmNvbT4NCj4gU3Vi
amVjdDogUmU6IFtuZXQtbmV4dCAxLzldIEltcGxlbWVudGF0aW9uIG9mIFZpcnR1YWwgQnVzDQo+
IA0KPiBPbiBNb24sIEFwciAyMCwgMjAyMCBhdCAxMToxNjozOFBNICswMDAwLCBFcnRtYW4sIERh
dmlkIE0gd3JvdGU6DQo+ID4gPiA+ICsvKioNCj4gPiA+ID4gKyAqIHZpcnRidXNfcmVnaXN0ZXJf
ZGV2aWNlIC0gYWRkIGEgdmlydHVhbCBidXMgZGV2aWNlDQo+ID4gPiA+ICsgKiBAdmRldjogdmly
dHVhbCBidXMgZGV2aWNlIHRvIGFkZA0KPiA+ID4gPiArICovDQo+ID4gPiA+ICtpbnQgdmlydGJ1
c19yZWdpc3Rlcl9kZXZpY2Uoc3RydWN0IHZpcnRidXNfZGV2aWNlICp2ZGV2KQ0KPiA+ID4gPiAr
ew0KPiA+ID4gPiArCWludCByZXQ7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwkvKiBEbyB0aGlzIGZp
cnN0IHNvIHRoYXQgYWxsIGVycm9yIHBhdGhzIHBlcmZvcm0gYSBwdXRfZGV2aWNlICovDQo+ID4g
PiA+ICsJZGV2aWNlX2luaXRpYWxpemUoJnZkZXYtPmRldik7DQo+ID4gPiA+ICsNCj4gPiA+ID4g
KwlpZiAoIXZkZXYtPnJlbGVhc2UpIHsNCj4gPiA+ID4gKwkJcmV0ID0gLUVJTlZBTDsNCj4gPiA+
ID4gKwkJZGV2X2VycigmdmRldi0+ZGV2LCAidmlydGJ1c19kZXZpY2UgTVVTVCBoYXZlIGEgLnJl
bGVhc2UNCj4gPiA+IGNhbGxiYWNrIHRoYXQgZG9lcyBzb21ldGhpbmcuXG4iKTsNCj4gPiA+ID4g
KwkJZ290byBkZXZpY2VfcHJlX2VycjsNCj4gPiA+DQo+ID4gPiBUaGlzIGRvZXMgcHV0X2Rldmlj
ZSBidXQgdGhlIHJlbGVhc2UoKSBoYXNuJ3QgYmVlbiBzZXQgeWV0LiBEb2Vzbid0IGl0DQo+ID4g
PiBsZWFrIG1lbW9yeT8NCj4gPg0KPiA+IFRoZSBLTyByZWdpc3RlcmluZyB0aGUgdmlydGJ1c19k
ZXZpY2UgaXMgcmVzcG9uc2libGUgZm9yIGFsbG9jYXRpbmcNCj4gPiBhbmQgZnJlZWluZyB0aGUg
bWVtb3J5IGZvciB0aGUgdmlydGJ1c19kZXZpY2UgKHdoaWNoIHNob3VsZCBiZSBkb25lDQo+ID4g
aW4gdGhlIHJlbGVhc2UoKSBmdW5jdGlvbikuICBJZiB0aGVyZSBpcyBubyByZWxlYXNlIGZ1bmN0
aW9uDQo+ID4gZGVmaW5lZCwgdGhlbiB0aGUgb3JpZ2luYXRpbmcgS08gbmVlZHMgdG8gaGFuZGxl
IHRoaXMuICBXZSBhcmUNCj4gPiB0cnlpbmcgdG8gbm90IHJlY3JlYXRlIHRoZSBwbGF0Zm9ybV9i
dXMsIHNvIHRoZSBkZXNpZ24gcGhpbG9zb3BoeQ0KPiA+IGJlaGluZCB2aXJ0dWFsX2J1cyBpcyBt
aW5pbWFsaXN0Lg0KPiANCj4gT2gsIGEgcHJlY29uZGl0aW9uIGFzc2VydGlvbiBzaG91bGQganVz
dCBiZSB3cml0dGVuIGFzIHNvbWV0aGluZyBsaWtlOg0KPiANCj4gICAgaWYgKFdBUk5fT04oIXZk
ZXYtPnJlbGVhc2UpKQ0KPiAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+IA0KPiBBbmQgZG9uZSBi
ZWZvcmUgZGV2aWNlX2luaXRpYWxpemUNCj4gDQo+IEJ1dCBJIHdvdWxkbid0IGJvdGhlciwgdGhp
bmdzIHdpbGwganVzdCByZWxpYWJseSBjcmFzaCBvbiBudWxsIHBvaW50ZXINCj4gZXhjZXB0aW9u
cyBpZiBhIGRyaXZlciBtaXMtdXNlcyB0aGUgQVBJLg0KPiANCg0KRG9uZS4NCg0KPiA+ID4gPiAr
CX0NCj4gPiA+ID4gKw0KPiA+ID4gPiArCS8qIEFsbCBkZXZpY2UgSURzIGFyZSBhdXRvbWF0aWNh
bGx5IGFsbG9jYXRlZCAqLw0KPiA+ID4gPiArCXJldCA9IGlkYV9zaW1wbGVfZ2V0KCZ2aXJ0YnVz
X2Rldl9pZGEsIDAsIDAsIEdGUF9LRVJORUwpOw0KPiA+ID4gPiArCWlmIChyZXQgPCAwKSB7DQo+
ID4gPiA+ICsJCWRldl9lcnIoJnZkZXYtPmRldiwgImdldCBJREEgaWR4IGZvciB2aXJ0YnVzIGRl
dmljZQ0KPiBmYWlsZWQhXG4iKTsNCj4gPiA+ID4gKwkJZ290byBkZXZpY2VfcHJlX2VycjsNCj4g
PiA+DQo+ID4gPiBEbyB0aGlzIGJlZm9yZSBkZXZpY2VfaW5pdGlhbGl6ZSgpDQo+ID4NCj4gPiBU
aGUgbWVtb3J5IGZvciB2aXJ0YnVzIGRldmljZSBpcyBhbGxvY2F0ZWQgYnkgdGhlIEtPIHJlZ2lz
dGVyaW5nIHRoZQ0KPiA+IHZpcnRidXNfZGV2aWNlIGJlZm9yZSBpdCBjYWxscyB2aXJ0YnVzX3Jl
Z2lzdGVyX2RldmljZSgpLiAgSWYgdGhpcw0KPiA+IGZ1bmN0aW9uIGlzIGV4aXRpbmcgb24gYW4g
ZXJyb3IsIHRoZW4gd2UgaGF2ZSB0byBkbyBhIHB1dF9kZXZpY2UoKQ0KPiA+IHNvIHRoYXQgdGhl
IHJlbGVhc2UgaXMgY2FsbGVkIChpZiBpdCBleGlzdHMpIHRvIGNsZWFuIHVwIHRoZSBtZW1vcnku
DQo+IA0KPiBwdXRfZGV2aWNlKCkgbXVzdCBjYWxsIHZpcnRidXNfcmVsZWFzZV9kZXZpY2UoKSwg
d2hpY2ggZG9lcw0KPiBpZGFfc2ltcGxlX3JlbW92ZSgpIG9uIHZkZXYtPmlkIHdoaWNoIGhhc24n
dCBiZWVuIHNldCB5ZXQuDQo+IA0KPiBBbHNvIC0+cmVsZWFzZSB3YXNuJ3QgaW5pdGlhbGl6ZWQg
YXQgdGhpcyBwb2ludCBzbyBpdHMgbGVha3MgbWVtb3J5Li4NCg0KLT5yZWxlYXNlIGFzc2lnbm1l
bnQgbW92ZWQgdG8gYmVmb3JlIGlkYV9zaW1wbGVfZ2V0IGV2YWx1YXRpb24sDQphbmQgYWRkZWQg
YSBkZWZpbmUgZm9yIFZJUlRCVVNfSU5WQUxJRF9JRCBhbmQgYSBjaGVjayBpbiByZWxlYXNlDQp0
byBub3QgZG8gaWRhX3NpbXBsZV9yZW1vdmUgZm9yIGFuIGludmFsaWQgSUQuDQoNCj4gDQo+ID4g
VGhlIGlkYV9zaW1wbGVfZ2V0IGlzIG5vdCB1c2VkIHVudGlsIGxhdGVyIGluIHRoZSBmdW5jdGlv
biB3aGVuDQo+ID4gc2V0dGluZyB0aGUgdmRldi0+aWQuICBJdCBkb2Vzbid0IG1hdHRlciB3aGF0
IElEQSBpdCBpcyB1c2VkLCBhcw0KPiA+IGxvbmcgYXMgaXQgaXMgdW5pcXVlLiAgU28sIHNpbmNl
IHdlIGNhbm5vdCBoYXZlIHRoZSBlcnJvciBzdGF0ZQ0KPiA+IGJlZm9yZSB0aGUgZGV2aWNlX2lu
aXRpYWxpemUsIHRoZXJlIGlzIG5vIHJlYXNvbiB0byBoYXZlIHRoZQ0KPiA+IGlkYV9zaW5wbGVf
Z2V0IGJlZm9yZSB0aGUgZGV2aWNlX2luaXRpYWxpemF0aW9uLg0KPiANCj4gSSB3YXMgYSBiaXQg
d3Jvbmcgb24gdGhpcyBhZHZpY2UgYmVjYXVzZSBubyBtYXR0ZXIgd2hhdCB5b3UgaGF2ZSB0byBk
bw0KPiBwdXRfZGV2aWNlKCksIHNvIHlvdSBuZWVkIHRvIGFkZCBzb21lIGtpbmQgb2YgZmxhZyB0
aGF0IHRoZSB2ZGV2LT5pZA0KPiBpcyBub3QgdmFsaWQuDQo+IA0KDQpEaWQganVzdCB0aGF0IPCf
mIoNCg0KPiBJdCBpcyB1Z2x5LiBJdCBpcyBuaWNlciB0byBhcnJhbmdlIHRoaW5nIHNvIGluaXRp
YWxpemF0aW9uIGlzIGRvbmUNCj4gYWZ0ZXIga2FsbG9jIGJ1dCBiZWZvcmUgZGV2aWNlX2luaXRp
YWxpemUuIEZvciBpbnN0YW5jZSBsb29rIGhvdw0KPiB2ZHBhX2FsbG9jX2RldmljZSgpIGFuZCB2
ZHBhX3JlZ2lzdGVyKCkgd29yaywgdmVyeSBjbGVhbiwgdmVyeSBzaW1wbGUNCj4gZ290byBlcnJv
ciB1bndpbmRzIGV2ZXJ5d2hlcmUuDQo+IA0KPiA+IEdyZWdLSCB3YXMgcHJldHR5IGluc2lzdGVu
dCB0aGF0IGFsbCBlcnJvciBwYXRocyBvdXQgb2YgdGhpcw0KPiA+IGZ1bmN0aW9uIGdvIHRocm91
Z2ggYSBwdXRfZGV2aWNlKCkgd2hlbiBwb3NzaWJsZS4NCj4gDQo+IEFmdGVyIGRldmljZV9pbml0
aWFsaXplKCkgaXMgY2FsbGVkIGFsbCBlcnJvciBwYXRocyBtdXN0IGdvIHRocm91Z2gNCj4gcHV0
X2RldmljZS4NCj4gDQo+ID4gPiBDYW4ndCB1bmRlcnN0YW5kIHdoeSB2ZGV2LT5uYW1lIGlzIGJl
aW5nIHBhc3NlZCBpbiB3aXRoIHRoZSBzdHJ1Y3QsDQo+ID4gPiB3aHkgbm90IGp1c3QgYSBmdW5j
dGlvbiBhcmd1bWVudD8NCj4gPg0KPiA+IFRoaXMgYXZvaWRzIGhhdmluZyB0aGUgY2FsbGluZyBL
TyBoYXZlIHRvIG1hbmFnZSBhIHNlcGFyYXRlIHBpZWNlIG9mDQo+IG1lbW9yeQ0KPiA+IHRvIGhv
bGQgdGhlIG5hbWUgZHVyaW5nIHRoZSBjYWxsIHRvIHZpcnRidXNfZGV2aWNlX3JlZ3NpdGVyLiAg
SXQgaXMgYSBjbGVhbmVyDQo+ID4gbWVtb3J5IG1vZGVsIHRvIGp1c3Qgc3RvcmUgaXQgb25jZSBp
biB0aGUgdmlydGJ1c19kZXZpY2UgaXRzZWxmLiAgVGhpcyBuYW1lDQo+IGlzDQo+ID4gdGhlIGFi
YnJldmlhdGVkIG5hbWUgd2l0aG91dCB0aGUgSUQgYXBwZW5kZWQgb24gdGhlIGVuZCwgd2hpY2gg
d2lsbCBiZQ0KPiB1c2VkDQo+ID4gZm9yIG1hdGNoaW5nIGRyaXZlcnMgYW5kIGRldmljZXMuDQo+
IA0KPiBZb3VyIG90aGVyIGV4cGxhbmF0aW9uIHdhcyBiZXR0ZXIuIFRoaXMgd291bGQgYmUgbGVz
cyBjb25mdXNpbmcgaWYgaXQNCj4gd2FzIGNhbGxlZCBtYXRjaF9uYW1lL2RldmljZV9sYWJlbC9k
cml2ZXJfa2V5IG9yIHNvbWV0aGluZywgYXMgaXQgaXMNCj4gbm90IHRoZSAnbmFtZScuDQo+IA0K
DQpjaGFuZ2luZyB0aGUgdmRldi0+bmFtZSB0byB2ZGV2LT5tYXRjaF9uYW1lDQoNCj4gPiA+ID4g
KyAqIHZpcnRidXNfdW5yZWdpc3Rlcl9kZXZpY2UgLSByZW1vdmUgYSB2aXJ0dWFsIGJ1cyBkZXZp
Y2UNCj4gPiA+ID4gKyAqIEB2ZGV2OiB2aXJ0dWFsIGJ1cyBkZXZpY2Ugd2UgYXJlIHJlbW92aW5n
DQo+ID4gPiA+ICsgKi8NCj4gPiA+ID4gK3ZvaWQgdmlydGJ1c191bnJlZ2lzdGVyX2RldmljZShz
dHJ1Y3QgdmlydGJ1c19kZXZpY2UgKnZkZXYpDQo+ID4gPiA+ICt7DQo+ID4gPiA+ICsJZGV2aWNl
X2RlbCgmdmRldi0+ZGV2KTsNCj4gPiA+ID4gKwlwdXRfZGV2aWNlKCZ2ZGV2LT5kZXYpOw0KPiA+
ID4gPiArfQ0KPiA+ID4gPiArRVhQT1JUX1NZTUJPTF9HUEwodmlydGJ1c191bnJlZ2lzdGVyX2Rl
dmljZSk7DQo+ID4gPg0KPiA+ID4gSnVzdCBpbmxpbmUgdGhpcyBhcyB3cmFwcGVyIGFyb3VuZCBk
ZXZpY2VfdW5yZWdpc3Rlcg0KPiA+DQo+ID4gSSB0aG91Z2h0IHRoYXQgRVhQT1JUX1NZTUJPTCBt
YWtlcyBpbmxpbmUgbWVhbmluZ2xlc3M/DQo+ID4gQnV0LCBwdXR0aW5nIGRldmljZV91bnJlZ2lz
dGVyIGhlcmUgaXMgYSBnb29kIGNhdGNoLg0KPiANCj4gSSBtZWFuIG1vdmUgaXQgdG8gdGhlIGhl
YWRlciBmaWxlIGFuZCBpbmxpbmUgaXQNCg0KRG9uZS4NCg0KPiANCj4gSmFzb24NCg0KLURhdmVF
DQo=
