Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF31736E5A3
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 09:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhD2HMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 03:12:19 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:44001
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231405AbhD2HMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 03:12:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7xzl31gZq9Bx+LTbr0RS/lHB7z+PChlB0RQf0qPvUxV2rTEgb00B6n2ZMkC9pmMY67YfZfJc+tGEDkyXoyh2RjPZsHR/Vm/jYewcLTiZQ3BhYdkvVt43UebK06fH0bp/PtwwEoXzVT9QlC7ZWIG0kT+YnkLMi1ZDzfGo+gVB+Di4T/j7q4vFhnhUon0yLpNcA6A5N6S+PPX6wEdUXRDOq9tFwVXiRjBpt0R8R1bG+j6hZVsr7i/NQEbaewjzI0H3g0tNjVmJyz1uxVMwXyf61o6YgA9lKFAeBhv0HMPMNGpHtOXtKbzPKz9HrTirqwZefkpjhpBmMc3p02epdrWgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zT4kAF1f5rHnVglyHdXjsaWLGPz+63Ixg4+KshwqE/U=;
 b=iIh7DzuD0npmChc+xKNKHa9e/kFd2zvVxTKCespKtzoKAonpM9bZOszbfZI8a9HkPhdc/39222zltYNiG+IkaQWJrVs0lXNoVn0lJP+grjG/WqPGMgnW2D/BXycedadQ6xVfr+NLDhDl7yvkZmft6PJY5g9glfRA00zyDk7R5dGG55viLmQDzLdqESiCM8Qd2YRz3k0Upkj9vwSZizSkgu9skRsMGK9e4ojcoU3HBPPB0py5tTefR1Fal15DXh7hF9eIXMmlPGzhzN041duW4bfEXg7WJPVUB9M4KZSWnm4Rk/B5LJpWXbVYxg83XheD8VI7LXgGWcSoIsMAgUlsPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zT4kAF1f5rHnVglyHdXjsaWLGPz+63Ixg4+KshwqE/U=;
 b=BvvZZAwpSVBJDHcYcW1+YN/GmzCjppcYZOqZ6mPN10KWYkJD/F3Vbz34PGqRYIQkDuh1KdVUl/WRUbGRijTmSa3fmAgP++6wQXXhLLF0lr2FPhBmU8vA2QHQNc430EQxiJwn4TowmkLK5FyLWlNrmFs7/drS5ZI/7tIzQwn7m6Q=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2328.eurprd04.prod.outlook.com (2603:10a6:4:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 29 Apr
 2021 07:11:28 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%7]) with mapi id 15.20.4065.027; Thu, 29 Apr 2021
 07:11:28 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Jisheng.Zhang@synaptics.com" <Jisheng.Zhang@synaptics.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V3 net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
Thread-Topic: [PATCH V3 net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
Thread-Index: AQHXPAG4PBCaV54acUeCcTVpU+pS8KrJ22sAgABBzACAAPhLcA==
Date:   Thu, 29 Apr 2021 07:11:27 +0000
Message-ID: <DB8PR04MB67950DCAF237564B10BF57DFE65F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210428074107.2378-1-qiangqing.zhang@nxp.com>
 <YIlUdprPfqa5d2ez@lunn.ch> <ab8152e4-c462-def4-c2e8-0ec2bec5d638@gmail.com>
In-Reply-To: <ab8152e4-c462-def4-c2e8-0ec2bec5d638@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e92ccb2e-e9dc-4031-f6f8-08d90ade01f1
x-ms-traffictypediagnostic: DB6PR0401MB2328:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0401MB23280A8FB4C3AB9C36D9B95EE65F9@DB6PR0401MB2328.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CMtNv3Tgjsrf2QqhyBv2w7ibPZR8efIy41JrK9AEPNnKrNAdcy+GnTu1bOAZ2LUfvjHC6eOruHGEf0ofagyVzbU5t8+hUUm1DpE3JgQFGHQI6I3TeGXA/SJp7AYTrR0x6erzd86+m6HeWaJm3hrFq/fmceFeQJZk/cWYviZ0EN6JukZlSsBBmSQhQkK+K+oR+KvYEQ74HwsIE7Fz5pvdfctlyar6vPX8gH6DlWParIPHd5vaVUgUwRfp6UGy6QG78+GQvD1uMi0FAsUE4GqJByqPrXMFIoWDYo/wB730Hzr+HGE1EcEitdUBQgRM0V52CKn8LNw0iYm3+Thgg2LqxwDTQehN/vP24iDqQ2RnYiDa2tjeY5tINFvzIX3kL4jmCHYDzIMUxLVOE1sVvS+HWv0pYJ7vnUgFWl+/Qg0NtEKhY63AcN1eOe8TAnMuV0ufDH1eDpx4KX2U07+DMJrGyDUqtOKyekTkYS17sZKIV70540uqajWrGQybY6aHXeGTj+C1SEjmHBow9Gl/HNlTBwAzJBa4aL8TexlKcoXoAoxBOZHQgXVpkvRtAW02N1C4qjidGOS9rtjMmBfPB4Y4yIyC/fZsTYA9VEXJEEcdFbA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(6506007)(8936002)(316002)(8676002)(54906003)(478600001)(83380400001)(71200400001)(7696005)(110136005)(86362001)(122000001)(66556008)(76116006)(64756008)(53546011)(4326008)(55016002)(26005)(66946007)(66446008)(38100700002)(66476007)(186003)(33656002)(2906002)(5660300002)(9686003)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NHkxcTIxSlN3WkoxaHNaa2xNOUIwZ3dlZWlPcmllNXlZcHdYeWozdzQ0dThT?=
 =?utf-8?B?OFlVNHJSbnB2WkMxVUNIUlFCWkY4NVdYWGIySWRVWFM5WXhnc2IxbXFpSTdp?=
 =?utf-8?B?R0crVjM2N3N1NUk5VkduK00yMnRmZXZDRk5XbjQxUzRWTGorVDJGUWl6RVR3?=
 =?utf-8?B?MEo0ZW52QmVsaGZMMkZCbzFibzBLbkZUUWF4NlZFVWtSaGpwL3VsYmdLZ05V?=
 =?utf-8?B?MFBTREpWV2NYcEtSeDAvcG5ZaGU2NXRsM3duOXBxSFdSWXNwNFBYSkMvZzJN?=
 =?utf-8?B?Ylg0ZVc3YXBUUUt1c3MwcU9EakRUbHMwbkx4c0RYK3JpbTVWckdSUU93UkdP?=
 =?utf-8?B?eXY0bW5FNmhvYnFveFhwLytMYzNGSDJCTWx3eUxZeDQvS3JEYlBJaENWNW1Q?=
 =?utf-8?B?QVFxWmVmUE9PTzRqc1ZyQnVZV25ITVNweERPWGUva2lEYmdNbWw0a3NOV0VB?=
 =?utf-8?B?enZCRGM1ODh4TXF4RWNUcVNDVzU5Y3l3NXhFTVM3QmNaWVVMVXJWQTlzYVFF?=
 =?utf-8?B?VHYyaWdnUlBFK3FrOVIwaVAvUitLMVk1THJ5NWNNakxhQnBCSjZLc01EVEFJ?=
 =?utf-8?B?T2svdVpVdVhZRllmLzdoK3BPZGFSand6UCt5MTYybUZxWXRYS1diREp6RmVk?=
 =?utf-8?B?QVd6MThyU1BuTm5pWWhKKzNQU0creWQ3RjZEZTk1VDlPeXFobDRzT2dDbkZT?=
 =?utf-8?B?aXlYZjBDazNrOUhLdWt1TThDVUVyYlovYklmQmo1c3dRYU5TMW96dDBoc3gz?=
 =?utf-8?B?eEVRSTBBc1dtMjNkNllNMGp0TXlheGp6bzdpcGtOMHVjWCtQZGIzWVI3NW1y?=
 =?utf-8?B?WnBaWHBKbkRwNEdjdGg3bEd6TGEyNVhRTy9IczVhYW5pUXY0NmlsUy80ajIr?=
 =?utf-8?B?czBSNEQ4NDYyVDYrMzMyT3hlQk9qZFlRWlhUR05pZWl4a0tvaVhMakFMTUJS?=
 =?utf-8?B?V0lmNElnazR3ZllOWDlFb3BGL1ZNcHRwREZMLzdMcEVjQlpxUFZjdW5QSnJk?=
 =?utf-8?B?bmthT2VFWTNUclpKMWl1eDR5M1pRQmE3OGtJbUpqNmIxY2MwMFZJZ1ErNVlC?=
 =?utf-8?B?cm9EWmRMdVVGaGlqVXlLZnZVTmFSRlNJcUJRZ2tUUFNIbTJSVmdWbEhlTDFO?=
 =?utf-8?B?UHdJbVEra2JSQXlqc1BSMloxeEFHVzVOZW4vODViYnlsV2QvUTNycFdsOUR4?=
 =?utf-8?B?aXluQTZvMGhZdWxCUUFJcytsNmd5eTlLY2cwUlo2N1VCbXYzOFJ3STZ5bk1Y?=
 =?utf-8?B?bXJUVEtmOXBUWlpyU1d0aG5UWUVoaU9DZWZOTzY0OS9yaUdJRVUvZXhMN01Z?=
 =?utf-8?B?V3pqOVhSeEVZcVFNaENvMnlrOHNwaktxc1lIeFdEUE40TDRQZ0d5ZVVINVZH?=
 =?utf-8?B?a3FQMUJ6d3d5R01GMmJoNWxsR3lkRTluV2hhSm84c1g4dVB6UzBYSkgvVjVm?=
 =?utf-8?B?L1drOEQ0MlBGa1lUdlJucHZMV1M3VkJGSWNXOWJWK2JFZVFOd2hDSWhCUVUz?=
 =?utf-8?B?TnIyK1dXRGRRRnZIL2c5K3ljVlBEZ3BzbCt6bFE0eHgyVTFzZlQ0c3RjQ3I0?=
 =?utf-8?B?L1EvS21JaXVpMnVTRzhKb1FWMTFMR2h6RXpCdFhPTk9ud3NPd3BGY2YxODdk?=
 =?utf-8?B?Vk5SWDJHZGpwNmR1bitSOWJKdk9sMUFqcWdaZE1XTGZsMGdoOUlmUG41dlAy?=
 =?utf-8?B?Rzh2MDlLNFdrd0dUbzk1aDRSd29wT1BSdzhqK0VvbVJhZ1Bjdk9weE5XS2VY?=
 =?utf-8?Q?I5G8ZyKzxq/Yt1dd/4NcXwZaQQcRDTRoPRWnixM?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e92ccb2e-e9dc-4031-f6f8-08d90ade01f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2021 07:11:27.9913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OtmfG8WdJlAmJH8p1p04c2F+trxxrJ4J1Aa6tpNrNg8ku1oRJuxG52EtU19Po6sKMiJATvOp4GSVFRx/xHqaiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEZsb3JpYW4gRmFpbmVsbGkg
PGYuZmFpbmVsbGlAZ21haWwuY29tPg0KPiBTZW50OiAyMDIx5bm0NOaciDI55pelIDA6MjINCj4g
VG86IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IEpvYWtpbSBaaGFuZw0KPiA8cWlhbmdx
aW5nLnpoYW5nQG54cC5jb20+DQo+IENjOiBwZXBwZS5jYXZhbGxhcm9Ac3QuY29tOyBhbGV4YW5k
cmUudG9yZ3VlQHN0LmNvbTsNCj4gam9hYnJldUBzeW5vcHN5cy5jb207IGRhdmVtQGRhdmVtbG9m
dC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsNCj4gSmlzaGVuZy5aaGFuZ0BzeW5hcHRpY3MuY29tOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkbC1saW51eC1pbXgNCj4gPGxpbnV4LWlteEBueHAuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFYzIG5ldF0gbmV0OiBzdG1tYWM6IGZpeCBNQUMgV29M
IHVud29yayBpZiBQSFkgZG9lc24ndA0KPiBzdXBwb3J0IFdvTA0KPiANCj4gDQo+IA0KPiBPbiA0
LzI4LzIwMjEgNToyNiBBTSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+ID4+ICBzdGF0aWMgaW50IHN0
bW1hY19zZXRfd29sKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHN0cnVjdA0KPiA+PiBldGh0b29s
X3dvbGluZm8gKndvbCkgIHsNCj4gPj4gIAlzdHJ1Y3Qgc3RtbWFjX3ByaXYgKnByaXYgPSBuZXRk
ZXZfcHJpdihkZXYpOw0KPiA+PiAtCXUzMiBzdXBwb3J0ID0gV0FLRV9NQUdJQyB8IFdBS0VfVUNB
U1Q7DQo+ID4+ICsJc3RydWN0IGV0aHRvb2xfd29saW5mbyB3b2xfcGh5ID0geyAuY21kID0gRVRI
VE9PTF9HV09MIH07DQo+ID4+ICsJdTMyIHN1cHBvcnQgPSBXQUtFX01BR0lDIHwgV0FLRV9VQ0FT
VCB8IFdBS0VfTUFHSUNTRUNVUkUgfA0KPiA+PiArV0FLRV9CQ0FTVDsNCj4gPg0KPiA+IFJldmVy
c2UgY2hyaXN0bWFzcyB0cmVlIHBsZWFzZS4NCj4gPg0KPiA+Pg0KPiA+PiAtCWlmICghZGV2aWNl
X2Nhbl93YWtldXAocHJpdi0+ZGV2aWNlKSkNCj4gPj4gLQkJcmV0dXJuIC1FT1BOT1RTVVBQOw0K
PiA+PiArCWlmICh3b2wtPndvbG9wdHMgJiB+c3VwcG9ydCkNCj4gPj4gKwkJcmV0dXJuIC1FSU5W
QUw7DQo+ID4NCj4gPiBNYXliZSAtRU9QTk9UU1VQUCB3b3VsZCBiZSBiZXR0ZXIuDQo+ID4NCj4g
Pj4NCj4gPj4gLQlpZiAoIXByaXYtPnBsYXQtPnBtdCkgew0KPiA+PiArCS8qIEZpcnN0IGNoZWNr
IGlmIGNhbiBXb0wgZnJvbSBQSFkgKi8NCj4gPj4gKwlwaHlsaW5rX2V0aHRvb2xfZ2V0X3dvbChw
cml2LT5waHlsaW5rLCAmd29sX3BoeSk7DQo+ID4NCj4gPiBUaGlzIGNvdWxkIHJldHVybiBhbiBl
cnJvci4gSW4gd2hpY2ggY2FzZSwgeW91IHByb2JhYmx5IHNob3VsZCBub3QNCj4gPiB0cnVzdCB3
b2xfcGh5Lg0KPiA+DQo+ID4+ICsJaWYgKHdvbC0+d29sb3B0cyAmIHdvbF9waHkuc3VwcG9ydGVk
KSB7DQo+ID4NCj4gPiBUaGlzIHJldHVybnMgdHJ1ZSBpZiB0aGUgUEhZIHN1cHBvcnRzIG9uZSBv
ciBtb3JlIG9mIHRoZSByZXF1ZXN0ZWQgV29MDQo+ID4gc291cmNlcy4NCj4gPg0KPiA+PiAgCQlp
bnQgcmV0ID0gcGh5bGlua19ldGh0b29sX3NldF93b2wocHJpdi0+cGh5bGluaywgd29sKTsNCj4g
Pg0KPiA+IGFuZCBoZXJlIHlvdSByZXF1ZXN0IHRoZSBQSFkgdG8gZW5hYmxlIGFsbCB0aGUgcmVx
dWVzdGVkIFdvTCBzb3VyY2VzLg0KPiA+IElmIGl0IG9ubHkgc3VwcG9ydHMgYSBzdWJzZXQsIGl0
IGlzIGxpa2VseSB0byByZXR1cm4gLUVPUE5PVFNVUFAsIG9yDQo+ID4gLUVJTlZBTCwgYW5kIGRv
IG5vdGhpbmcuIFNvIGhlcmUgeW91IG9ubHkgd2FudCB0byBlbmFibGUgdGhvc2Ugc291cmNlcw0K
PiA+IHRoZSBQSFkgYWN0dWFsbHkgc3VwcG9ydHMuIEFuZCBsZXQgdGhlIE1BQyBpbXBsZW1lbnQg
dGhlIHJlc3QuDQo+IA0KPiBBbmQgd2hlbiB5b3VyIHJlc3VibWl0LCBJIGRvIG5vdCBiZWxpZXZl
IHRoYXQgdW53b3JrIGlzIGEgd29yZCwgeW91IGNvdWxkDQo+IHByb3ZpZGUgdGhlIGZvbGxvd2lu
ZyBzdWJqZWN0Og0KPiANCj4gbmV0OiBzdG1tYWM6IEZpeCBNQUMgV29MIG5vdCB3b3JraW5nIGlm
IFBIWSBkb2VzIG5vdCBzdXBwb3J0IFdvTA0KPiANCj4gb3Igc29tZXRoaW5nIGxpa2UgdGhhdC4N
Cg0KT2ssIHRoYW5rcyBGbG9yaWFuIQ0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4g
VGhhbmtzIQ0KPiAtLQ0KPiBGbG9yaWFuDQo=
