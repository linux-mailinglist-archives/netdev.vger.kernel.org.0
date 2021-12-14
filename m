Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6509F473D18
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 07:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhLNGRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 01:17:31 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:60034 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbhLNGRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 01:17:30 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BE6H9d14009276, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BE6H9d14009276
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Dec 2021 14:17:09 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 14:17:09 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 14:17:08 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Tue, 14 Dec 2021 14:17:08 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "jian-hong@endlessm.com" <jhp@endlessos.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Bernie Huang <phhuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
Thread-Topic: [PATCH v2] rtw88: Disable PCIe ASPM while doing NAPI poll on
 8821CE
Thread-Index: AQHX8KxEGsnToIDXSUCJmFSUmWAcOawxeDaA//+B4wCAAIbGIA==
Date:   Tue, 14 Dec 2021 06:17:08 +0000
Message-ID: <db0e4a43a09f4618b0ed0ad191140e34@realtek.com>
References: <20211214053302.242222-1-kai.heng.feng@canonical.com>
 <4aaf5dd030004285a56bc55cc6b2731b@realtek.com>
 <CAAd53p6TWV=vciEPkM-_rPy4op1Nqpqye-UhHXnsUJ4MjoVk=w@mail.gmail.com>
In-Reply-To: <CAAd53p6TWV=vciEPkM-_rPy4op1Nqpqye-UhHXnsUJ4MjoVk=w@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEyLzE0IOS4iuWNiCAwNDo0NzowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEthaS1IZW5nIEZlbmcgPGth
aS5oZW5nLmZlbmdAY2Fub25pY2FsLmNvbT4NCj4gU2VudDogVHVlc2RheSwgRGVjZW1iZXIgMTQs
IDIwMjEgMjowNyBQTQ0KPiBUbzogUGtzaGloIDxwa3NoaWhAcmVhbHRlay5jb20+DQo+IENjOiB0
b255MDYyMGVtbWFAZ21haWwuY29tOyBqaWFuLWhvbmdAZW5kbGVzc20uY29tIDxqaHBAZW5kbGVz
c29zLm9yZz47IEthbGxlIFZhbG8gPGt2YWxvQGNvZGVhdXJvcmEub3JnPjsNCj4gRGF2aWQgUy4g
TWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVs
Lm9yZz47IEJlcm5pZSBIdWFuZw0KPiA8cGhodWFuZ0ByZWFsdGVrLmNvbT47IEJyaWFuIE5vcnJp
cyA8YnJpYW5ub3JyaXNAY2hyb21pdW0ub3JnPjsgbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwu
b3JnOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjJdIHJ0dzg4OiBEaXNhYmxlIFBDSWUgQVNQTSB3
aGlsZSBkb2luZyBOQVBJIHBvbGwgb24gODgyMUNFDQo+IA0KPiBPbiBUdWUsIERlYyAxNCwgMjAy
MSBhdCAxOjU5IFBNIFBrc2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPiB3cm90ZToNCj4gPg0KPiA+
DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogS2FpLUhlbmcg
RmVuZyA8a2FpLmhlbmcuZmVuZ0BjYW5vbmljYWwuY29tPg0KPiA+ID4gU2VudDogVHVlc2RheSwg
RGVjZW1iZXIgMTQsIDIwMjEgMTozMyBQTQ0KPiA+ID4gVG86IHRvbnkwNjIwZW1tYUBnbWFpbC5j
b207IFBrc2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KPiA+ID4gQ2M6IGppYW4taG9uZ0BlbmRs
ZXNzbS5jb207IEthaS1IZW5nIEZlbmcgPGthaS5oZW5nLmZlbmdAY2Fub25pY2FsLmNvbT47IEth
bGxlIFZhbG8NCj4gPiA+IDxrdmFsb0Bjb2RlYXVyb3JhLm9yZz47IERhdmlkIFMuIE1pbGxlciA8
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBC
ZXJuaWUNCj4gPiA+IEh1YW5nIDxwaGh1YW5nQHJlYWx0ZWsuY29tPjsgQnJpYW4gTm9ycmlzIDxi
cmlhbm5vcnJpc0BjaHJvbWl1bS5vcmc+OyBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7
DQo+ID4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnDQo+ID4gPiBTdWJqZWN0OiBbUEFUQ0ggdjJdIHJ0dzg4OiBEaXNhYmxlIFBDSWUgQVNQTSB3
aGlsZSBkb2luZyBOQVBJIHBvbGwgb24gODgyMUNFDQo+ID4gPg0KPiA+ID4gTWFueSBJbnRlbCBi
YXNlZCBwbGF0Zm9ybXMgZmFjZSBzeXN0ZW0gcmFuZG9tIGZyZWV6ZSBhZnRlciBjb21taXQNCj4g
PiA+IDllMmZkMjk4NjRjNSAoInJ0dzg4OiBhZGQgbmFwaSBzdXBwb3J0IikuDQo+ID4gPg0KPiA+
ID4gVGhlIGNvbW1pdCBpdHNlbGYgc2hvdWxkbid0IGJlIHRoZSBjdWxwcml0LiBNeSBndWVzcyBp
cyB0aGF0IHRoZSA4ODIxQ0UNCj4gPiA+IG9ubHkgbGVhdmVzIEFTUE0gTDEgZm9yIGEgc2hvcnQg
cGVyaW9kIHdoZW4gSVJRIGlzIHJhaXNlZC4gU2luY2UgSVJRIGlzDQo+ID4gPiBtYXNrZWQgZHVy
aW5nIE5BUEkgcG9sbGluZywgdGhlIFBDSWUgbGluayBzdGF5cyBhdCBMMSBhbmQgbWFrZXMgUlgg
RE1BDQo+ID4gPiBleHRyZW1lbHkgc2xvdy4gRXZlbnR1YWxseSB0aGUgUlggcmluZyBiZWNvbWVz
IG1lc3NlZCB1cDoNCj4gPiA+IFsgMTEzMy4xOTQ2OTddIHJ0d184ODIxY2UgMDAwMDowMjowMC4w
OiBwY2kgYnVzIHRpbWVvdXQsIGNoZWNrIGRtYSBzdGF0dXMNCj4gPiA+DQo+ID4gPiBTaW5jZSB0
aGUgODgyMUNFIGhhcmR3YXJlIG1heSBmYWlsIHRvIGxlYXZlIEFTUE0gTDEsIG1hbnVhbGx5IGRv
IGl0IGluDQo+ID4gPiB0aGUgZHJpdmVyIHRvIHJlc29sdmUgdGhlIGlzc3VlLg0KPiA+ID4NCj4g
PiA+IEZpeGVzOiA5ZTJmZDI5ODY0YzUgKCJydHc4ODogYWRkIG5hcGkgc3VwcG9ydCIpDQo+ID4g
PiBCdWd6aWxsYTogaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0y
MTUxMzENCj4gPiA+IEJ1Z0xpbms6IGh0dHBzOi8vYnVncy5sYXVuY2hwYWQubmV0L2J1Z3MvMTky
NzgwOA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogS2FpLUhlbmcgRmVuZyA8a2FpLmhlbmcuZmVuZ0Bj
YW5vbmljYWwuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiB2MjoNCj4gPiA+ICAtIEFkZCBkZWZhdWx0
IHZhbHVlIGZvciBtb2R1bGUgcGFyYW1ldGVyLg0KPiA+ID4NCj4gPiA+ICBkcml2ZXJzL25ldC93
aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BjaS5jIHwgNzQgKysrKysrKystLS0tLS0tLS0tLS0tLS0t
DQo+ID4gPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9wY2kuaCB8ICAxICsN
Cj4gPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDI0IGluc2VydGlvbnMoKyksIDUxIGRlbGV0aW9ucygt
KQ0KPiA+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVr
L3J0dzg4L3BjaS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9wY2kuYw0K
PiA+ID4gaW5kZXggM2IzNjdjOTA4NWViYS4uNGFiNzVhYzI1MDBlOSAxMDA2NDQNCj4gPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcGNpLmMNCj4gPiA+ICsrKyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcGNpLmMNCj4gPiA+IEBAIC0yLDcg
KzIsNiBAQA0KPiA+ID4gIC8qIENvcHlyaWdodChjKSAyMDE4LTIwMTkgIFJlYWx0ZWsgQ29ycG9y
YXRpb24NCj4gPiA+ICAgKi8NCj4gPiA+DQo+ID4gPiAtI2luY2x1ZGUgPGxpbnV4L2RtaS5oPg0K
PiA+ID4gICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4gPiA+ICAjaW5jbHVkZSA8bGludXgv
cGNpLmg+DQo+ID4gPiAgI2luY2x1ZGUgIm1haW4uaCINCj4gPiA+IEBAIC0xNiwxMCArMTUsMTMg
QEANCj4gPiA+DQo+ID4gPiAgc3RhdGljIGJvb2wgcnR3X2Rpc2FibGVfbXNpOw0KPiA+ID4gIHN0
YXRpYyBib29sIHJ0d19wY2lfZGlzYWJsZV9hc3BtOw0KPiA+ID4gK3N0YXRpYyBpbnQgcnR3X3J4
X2FzcG0gPSAtMTsNCj4gPiA+ICBtb2R1bGVfcGFyYW1fbmFtZWQoZGlzYWJsZV9tc2ksIHJ0d19k
aXNhYmxlX21zaSwgYm9vbCwgMDY0NCk7DQo+ID4gPiAgbW9kdWxlX3BhcmFtX25hbWVkKGRpc2Fi
bGVfYXNwbSwgcnR3X3BjaV9kaXNhYmxlX2FzcG0sIGJvb2wsIDA2NDQpOw0KPiA+ID4gK21vZHVs
ZV9wYXJhbV9uYW1lZChyeF9hc3BtLCBydHdfcnhfYXNwbSwgaW50LCAwNDQ0KTsNCj4gPiA+ICBN
T0RVTEVfUEFSTV9ERVNDKGRpc2FibGVfbXNpLCAiU2V0IFkgdG8gZGlzYWJsZSBNU0kgaW50ZXJy
dXB0IHN1cHBvcnQiKTsNCj4gPiA+ICBNT0RVTEVfUEFSTV9ERVNDKGRpc2FibGVfYXNwbSwgIlNl
dCBZIHRvIGRpc2FibGUgUENJIEFTUE0gc3VwcG9ydCIpOw0KPiA+ID4gK01PRFVMRV9QQVJNX0RF
U0MocnhfYXNwbSwgIlVzZSBQQ0llIEFTUE0gZm9yIFJYICgwPWRpc2FibGUsIDE9ZW5hYmxlLCAt
MT1kZWZhdWx0KSIpOw0KPiA+ID4NCj4gPiA+ICBzdGF0aWMgdTMyIHJ0d19wY2lfdHhfcXVldWVf
aWR4X2FkZHJbXSA9IHsNCj4gPiA+ICAgICAgIFtSVFdfVFhfUVVFVUVfQktdICAgICAgID0gUlRL
X1BDSV9UWEJEX0lEWF9CS1EsDQo+ID4gPiBAQCAtMTQwOSw3ICsxNDExLDExIEBAIHN0YXRpYyB2
b2lkIHJ0d19wY2lfbGlua19wcyhzdHJ1Y3QgcnR3X2RldiAqcnR3ZGV2LCBib29sIGVudGVyKQ0K
PiA+ID4gICAgICAgICogdGhyb3VnaHB1dC4gVGhpcyBpcyBwcm9iYWJseSBiZWNhdXNlIHRoZSBB
U1BNIGJlaGF2aW9yIHNsaWdodGx5DQo+ID4gPiAgICAgICAgKiB2YXJpZXMgZnJvbSBkaWZmZXJl
bnQgU09DLg0KPiA+ID4gICAgICAgICovDQo+ID4gPiAtICAgICBpZiAocnR3cGNpLT5saW5rX2N0
cmwgJiBQQ0lfRVhQX0xOS0NUTF9BU1BNX0wxKQ0KPiA+ID4gKyAgICAgaWYgKCEocnR3cGNpLT5s
aW5rX2N0cmwgJiBQQ0lfRVhQX0xOS0NUTF9BU1BNX0wxKSkNCj4gPiA+ICsgICAgICAgICAgICAg
cmV0dXJuOw0KPiA+ID4gKw0KPiA+ID4gKyAgICAgaWYgKChlbnRlciAmJiBhdG9taWNfZGVjX3Jl
dHVybigmcnR3cGNpLT5saW5rX3VzYWdlKSA9PSAwKSB8fA0KPiA+ID4gKyAgICAgICAgICghZW50
ZXIgJiYgYXRvbWljX2luY19yZXR1cm4oJnJ0d3BjaS0+bGlua191c2FnZSkgPT0gMSkpDQo+ID4g
PiAgICAgICAgICAgICAgIHJ0d19wY2lfYXNwbV9zZXQocnR3ZGV2LCBlbnRlcik7DQo+ID4gPiAg
fQ0KPiA+ID4NCj4gPg0KPiA+IEkgZm91bmQgY2FsbGluZyBwY2lfbGlua19wcyBpc24ndCBhbHdh
eXMgc3ltbWV0cmljLCBzbyB3ZSBuZWVkIHRvIHJlc2V0DQo+ID4gcmVmX2NudCBhdCBwY2lfc3Rh
cnQoKSBsaWtlIGJlbG93LCBvciB3ZSBjYW4ndCBlbnRlciBydHdfcGNpX2FzcG1fc2V0KCkNCj4g
PiBhbnltb3JlLiBUaGUgbmVnYXRpdmUgZmxvdyBJIGZhY2UgaXMNCj4gPiBpZnVwIC0+IGNvbm5l
Y3QgQVAgLT4gaWZkb3duIC0+IGlmdXAgKHJlZl9jbnQgaXNuJ3QgZXhwZWN0ZWQgbm93KS4NCj4g
DQo+IElzIGl0IGV4cGVjdGVkIHRvIGJlIGFzeW1tZXRyaWM/DQo+IElmIGl0J3MgaW50ZW5kZWQg
dG8gYmUgdGhpcyB3YXksIEknbGwgY2hhbmdlIHdoZXJlIHdlIHNldCBsaW5rX3VzYWdlLg0KPiBP
dGhlcndpc2UgSSB0aGluayBtYWtpbmcgaXQgc3ltbWV0cmljIG1ha2VzIG1vcmUgc2Vuc2UuDQoN
CkFncmVlIHdpdGggeW91ciB0aG91Z2h0LCBidXQgSSBkb24ndCByZW1lbWJlciBjbGVhcmx5IHdo
eSBpdCBlbnRlcnMgaWRsZSB0d2ljZQ0KaW4gYWJvdmUgZmxvdy4gU28sIHlvdSBtYXkgdXNlIHR3
byBmbGFncyB0byBpbmRpY2F0ZSB0aGUgc3RhdGUgd2FudGVkIGJ5DQp0d28gY2FsbGVycy4NCg0K
LS0NClBpbmctS2UNCg0KDQo=
