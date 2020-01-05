Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F2D1306F8
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 10:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgAEJxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 04:53:40 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:20280 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgAEJxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 04:53:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1578218019; x=1609754019;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rOnRBNnornS0UyFSWrNAvO6ifWNbLT/t+1ABl9YTxDg=;
  b=qLRI763kurSqShA+H+NCJL+xfoWfL1MwnbcsTFvPvV506F3KR1EEyz+o
   FEd4qJizacJyLK1uWVxC24hJPocowlZ5LU365lw01FZIn9frIzk6jaqeW
   xiO1KpLaD+IUzaWS/LegZxVuSle4C3/Tm5GhyZ7qnLWWJF7E5gj9Mx43V
   U=;
IronPort-SDR: Yv7ueT+lyoHi0LVEVXY6JY8c/JE1XdkLd2vcXbQJeuNGBKJ7YXb2l2ren1XVpWkh78DJl2jXNi
 N3x73vwUXU8w==
X-IronPort-AV: E=Sophos;i="5.69,398,1571702400"; 
   d="scan'208";a="11025968"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 05 Jan 2020 09:53:37 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 03CBEA2764;
        Sun,  5 Jan 2020 09:53:36 +0000 (UTC)
Received: from EX13D06EUC004.ant.amazon.com (10.43.164.101) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Sun, 5 Jan 2020 09:53:36 +0000
Received: from EX13D06EUC004.ant.amazon.com (10.43.164.101) by
 EX13D06EUC004.ant.amazon.com (10.43.164.101) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 5 Jan 2020 09:53:35 +0000
Received: from EX13D06EUC004.ant.amazon.com ([10.43.164.101]) by
 EX13D06EUC004.ant.amazon.com ([10.43.164.101]) with mapi id 15.00.1367.000;
 Sun, 5 Jan 2020 09:53:34 +0000
From:   "Bshara, Saeed" <saeedb@amazon.com>
To:     Liran Alon <liran.alon@oracle.com>,
        "Machulsky, Zorik" <zorik@amazon.com>
CC:     "Belgazal, Netanel" <netanel@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "Chauskin, Igor" <igorch@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Schmeilin, Evgeny" <evgenys@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Pressman, Gal" <galpress@amazon.com>,
        =?utf-8?B?SMOla29uIEJ1Z2dl?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH 2/2] net: AWS ENA: Flush WCBs before writing new SQ tail
 to doorbell
Thread-Topic: [PATCH 2/2] net: AWS ENA: Flush WCBs before writing new SQ tail
 to doorbell
Thread-Index: AQHVwZiv3JZfW3mmvU2NpEO5RPqyX6fZSREAgACqDICAAdxeZw==
Date:   Sun, 5 Jan 2020 09:53:34 +0000
Message-ID: <1578218014463.62861@amazon.com>
References: <20200102180830.66676-1-liran.alon@oracle.com>
 <20200102180830.66676-3-liran.alon@oracle.com>
 <37DACE68-F4B4-4297-9FE0-F12461D1FDC6@oracle.com>,<2BB3E76D-CAF7-4539-A8E3-540CDB253742@amazon.com>
In-Reply-To: <2BB3E76D-CAF7-4539-A8E3-540CDB253742@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.160.18]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ClRoYW5rcyBMaXJhbiwKCkkgdGhpbmsgd2UgbWlzc2VkIHRoZSBwYXlsb2FkIHZpc2liaWxpdHk7
IFRoZSBMTFEgZGVzY3JpcHRvciBjb250YWlucyB0aGUgaGVhZGVyIHBhcnQgb2YgdGhlIHBhY2tl
dCwgaW4gdGhlb3J5IHdlIHdpbGwgbmVlZCBhbHNvIHRvIG1ha2Ugc3VyZSB0aGF0IGFsbCBjcHUg
d3JpdGVzIHRvIHRoZSBwYWNrZXQgcGF5bG9hZCBhcmUgdmlzaWJsZSB0byB0aGUgZGV2aWNlLCBJ
IGJldCB0aGF0IGluIHByYWN0aWNlIHRob3NlIHN0b3JlcyB3aWxsIGJlIHZpc2libGUgd2l0aG91
dCBleHBsaWNpdCBiYXJyaWVyLCBidXQgd2UgYmV0dGVyIHN0aWNrIHRvIHRoZSBydWxlcy4Kc28g
d2Ugc3RpbGwgbmVlZCBkbWFfd21iKCksIGFsc28sIHRoYXQgbWVhbnMgdGhlIGZpcnN0IHBhdGNo
IGNhbid0IHNpbXBseSByZW1vdmUgdGhlIHdtYigpIGFzIGl0IGFjdHVhbGx5IG1heSBiZSB0YWtp
bmcgY2FyZSBmb3IgdGhlIHBheWxvYWQgdmlzaWJpbGl0eS4KCnNhZWVkCgpGcm9tOiBNYWNodWxz
a3ksIFpvcmlrClNlbnQ6IFNhdHVyZGF5LCBKYW51YXJ5IDQsIDIwMjAgNjo1NSBBTQpUbzogTGly
YW4gQWxvbgpDYzogQmVsZ2F6YWwsIE5ldGFuZWw7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IEJzaGFyYSwgU2FlZWQ7IEp1YnJhbiwgU2FtaWg7IENoYXVza2lu
LCBJZ29yOyBLaXlhbm92c2tpLCBBcnRodXI7IFNjaG1laWxpbiwgRXZnZW55OyBUemFsaWssIEd1
eTsgRGFnYW4sIE5vYW07IE1hdHVzaGV2c2t5LCBBbGV4YW5kZXI7IFByZXNzbWFuLCBHYWw7IEjD
pWtvbiBCdWdnZQpTdWJqZWN0OiBSZTogW1BBVENIIDIvMl0gbmV0OiBBV1MgRU5BOiBGbHVzaCBX
Q0JzIGJlZm9yZSB3cml0aW5nIG5ldyBTUSB0YWlsIHRvIGRvb3JiZWxsCsKgICAgCgoK77u/T24g
MS8zLzIwLCAxOjQ3IFBNLCAiTGlyYW4gQWxvbiIgPGxpcmFuLmFsb25Ab3JhY2xlLmNvbT4gd3Jv
dGU6CgrCoMKgwqAgCsKgwqDCoCAKwqDCoMKgID4gT24gMiBKYW4gMjAyMCwgYXQgMjA6MDgsIExp
cmFuIEFsb24gPGxpcmFuLmFsb25Ab3JhY2xlLmNvbT4gd3JvdGU6CsKgwqDCoCA+IArCoMKgwqAg
PiBBV1MgRU5BIE5JQyBzdXBwb3J0cyBUeCBTUSBpbiBMb3cgTGF0ZW5jeSBRdWV1ZSAoTExRKSBt
b2RlIChBbHNvCsKgwqDCoCA+IHJlZmVycmVkIHRvIGFzICJwdXNoLW1vZGUiKS4gSW4gdGhpcyBt
b2RlLCB0aGUgZHJpdmVyIHB1c2hlcyB0aGUKwqDCoMKgID4gdHJhbnNtaXQgZGVzY3JpcHRvcnMg
YW5kIHRoZSBmaXJzdCAxMjggYnl0ZXMgb2YgdGhlIHBhY2tldCBkaXJlY3RseQrCoMKgwqAgPiB0
byB0aGUgRU5BIGRldmljZSBtZW1vcnkgc3BhY2UsIHdoaWxlIHRoZSByZXN0IG9mIHRoZSBwYWNr
ZXQgcGF5bG9hZArCoMKgwqAgPiBpcyBmZXRjaGVkIGJ5IHRoZSBkZXZpY2UgZnJvbSBob3N0IG1l
bW9yeS4gRm9yIHRoaXMgb3BlcmF0aW9uIG1vZGUsCsKgwqDCoCA+IHRoZSBkcml2ZXIgdXNlcyBh
IGRlZGljYXRlZCBQQ0kgQkFSIHdoaWNoIGlzIG1hcHBlZCBhcyBXQyBtZW1vcnkuCsKgwqDCoCA+
IArCoMKgwqAgPiBUaGUgZnVuY3Rpb24gZW5hX2NvbV93cml0ZV9ib3VuY2VfYnVmZmVyX3RvX2Rl
digpIGlzIHJlc3BvbnNpYmxlCsKgwqDCoCA+IHRvIHdyaXRlIHRvIHRoZSBhYm92ZSBtZW50aW9u
ZWQgUENJIEJBUi4KwqDCoMKgID4gCsKgwqDCoCA+IFdoZW4gdGhlIHdyaXRlIG9mIG5ldyBTUSB0
YWlsIHRvIGRvb3JiZWxsIGlzIHZpc2libGUgdG8gZGV2aWNlLCBkZXZpY2UKwqDCoMKgID4gZXhw
ZWN0cyB0byBiZSBhYmxlIHRvIHJlYWQgcmVsZXZhbnQgdHJhbnNtaXQgZGVzY3JpcHRvcnMgYW5k
IHBhY2tldHMKwqDCoMKgID4gaGVhZGVycyBmcm9tIGRldmljZSBtZW1vcnkuIFRoZXJlZm9yZSwg
ZHJpdmVyIHNob3VsZCBlbnN1cmUKwqDCoMKgID4gd3JpdGUtY29tYmluZWQgYnVmZmVycyAoV0NC
cykgYXJlIGZsdXNoZWQgYmVmb3JlIHRoZSB3cml0ZSB0byBkb29yYmVsbArCoMKgwqAgPiBpcyB2
aXNpYmxlIHRvIHRoZSBkZXZpY2UuCsKgwqDCoCA+IArCoMKgwqAgPiBGb3Igc29tZSBDUFVzLCB0
aGlzIHdpbGwgYmUgdGFrZW4gY2FyZSBvZiBieSB3cml0ZWwoKS4gRm9yIGV4YW1wbGUsCsKgwqDC
oCA+IHg4NiBJbnRlbCBDUFVzIGZsdXNoZXMgd3JpdGUtY29tYmluZWQgYnVmZmVycyB3aGVuIGEg
cmVhZCBvciB3cml0ZQrCoMKgwqAgPiBpcyBkb25lIHRvIFVDIG1lbW9yeSAoSW4gb3VyIGNhc2Us
IHRoZSBkb29yYmVsbCkuIFNlZSBJbnRlbCBTRE0gc2VjdGlvbgrCoMKgwqAgPiAxMS4zIE1FVEhP
RFMgT0YgQ0FDSElORyBBVkFJTEFCTEU6CsKgwqDCoCA+ICJJZiB0aGUgV0MgYnVmZmVyIGlzIHBh
cnRpYWxseSBmaWxsZWQsIHRoZSB3cml0ZXMgbWF5IGJlIGRlbGF5ZWQgdW50aWwKwqDCoMKgID4g
dGhlIG5leHQgb2NjdXJyZW5jZSBvZiBhIHNlcmlhbGl6aW5nIGV2ZW50OyBzdWNoIGFzLCBhbiBT
RkVOQ0Ugb3IgTUZFTkNFCsKgwqDCoCA+IGluc3RydWN0aW9uLCBDUFVJRCBleGVjdXRpb24sIGEg
cmVhZCBvciB3cml0ZSB0byB1bmNhY2hlZCBtZW1vcnksIGFuCsKgwqDCoCA+IGludGVycnVwdCBv
Y2N1cnJlbmNlLCBvciBhIExPQ0sgaW5zdHJ1Y3Rpb24gZXhlY3V0aW9uLuKAnQrCoMKgwqAgPiAK
wqDCoMKgID4gSG93ZXZlciwgb3RoZXIgQ1BVcyBkbyBub3QgcHJvdmlkZSB0aGlzIGd1YXJhbnRl
ZS4gRm9yIGV4YW1wbGUsIHg4NgrCoMKgwqAgPiBBTUQgQ1BVcyBmbHVzaCB3cml0ZS1jb21iaW5l
ZCBidWZmZXJzIG9ubHkgb24gYSByZWFkIGZyb20gVUMgbWVtb3J5LgrCoMKgwqAgPiBOb3QgYSB3
cml0ZSB0byBVQyBtZW1vcnkuIFNlZSBBTUQgU29mdHdhcmUgT3B0aW1pc2F0aW9uIEd1aWRlIGZv
ciBBTUQKwqDCoMKgID4gRmFtaWx5IDE3aCBQcm9jZXNzb3JzIHNlY3Rpb24gMi4xMy4zIFdyaXRl
LUNvbWJpbmluZyBPcGVyYXRpb25zLgrCoMKgwqAgCsKgwqDCoCBBY3R1YWxseS4uLiBBZnRlciBy
ZS1yZWFkaW5nIEFNRCBPcHRpbWl6YXRpb24gR3VpZGUgU0RNLCBJIHNlZSBpdCBpcyBndWFyYW50
ZWVkIHRoYXQ6CsKgwqDCoCDigJxXcml0ZS1jb21iaW5pbmcgaXMgY2xvc2VkIGlmIGFsbCA2NCBi
eXRlcyBvZiB0aGUgd3JpdGUgYnVmZmVyIGFyZSB2YWxpZOKAnS4KwqDCoMKgIEFuZCB0aGlzIGlz
IGluZGVlZCBhbHdheXMgdGhlIGNhc2UgZm9yIEFXUyBFTkEgTExRLiBCZWNhdXNlIGFzIGNhbiBi
ZSBzZWVuIGF0CsKgwqDCoCBlbmFfY29tX2NvbmZpZ19sbHFfaW5mbygpLCBkZXNjX2xpc3RfZW50
cnlfc2l6ZSBpcyBlaXRoZXIgMTI4LCAxOTIgb3IgMjU2LiBpLmUuIEFsd2F5cwrCoMKgwqAgYSBt
dWx0aXBsZSBvZiA2NCBieXRlcy4KwqDCoMKgIArCoMKgwqAgU28gdGhpcyBwYXRjaCBpbiB0aGVv
cnkgY291bGQgbWF5YmUgYmUgZHJvcHBlZCBhcyBmb3IgeDg2IEludGVsICYgQU1EIGFuZCBBUk02
NCB3aXRoCsKgwqDCoCBjdXJyZW50IGRlc2NfbGlzdF9lbnRyeV9zaXplLCBpdCBpc27igJl0IHN0
cmljdGx5IG5lY2Vzc2FyeSB0byBndWFyYW50ZWUgdGhhdCBXQyBidWZmZXJzIGFyZSBmbHVzaGVk
LgrCoMKgwqAgCsKgwqDCoCBJIHdpbGwgbGV0IEFXUyBmb2xrcyB0byBkZWNpZGUgaWYgdGhleSBw
cmVmZXIgdG8gYXBwbHkgdGhpcyBwYXRjaCBhbnl3YXkgdG8gbWFrZSBXQyBmbHVzaCBleHBsaWNp
dArCoMKgwqAgYW5kIHRvIGF2b2lkIGhhcmQtdG8tZGVidWcgaXNzdWVzIGluIGNhc2Ugb2YgbmV3
IG5vbi02NC1tdWx0aXBseSBzaXplIGFwcGVhciBpbiB0aGUgZnV0dXJlLiBPcgrCoMKgwqAgdG8g
ZHJvcCB0aGlzIHBhdGNoIGFuZCBpbnN0ZWFkIGFkZCBhIFdBUk5fT04oKSB0byBlbmFfY29tX2Nv
bmZpZ19sbHFfaW5mbygpIGluIGNhc2UgZGVzY19saXN0X2VudHJ5X3NpemUKwqDCoMKgIGlzIG5v
dCBhIG11bHRpcGxlIG9mIDY0IGJ5dGVzLiBUbyBhdm9pZCB0YWtpbmcgcGVyZiBoaXQgZm9yIG5v
IHJlYWwgdmFsdWUuCsKgIApMaXJhbiwgdGhhbmtzIGZvciB0aGlzIGltcG9ydGFudCBpbmZvLiBJ
ZiB0aGlzIGlzIHRoZSBjYXNlLCBJIGJlbGlldmUgd2Ugc2hvdWxkIGRyb3AgdGhpcyBwYXRjaCBh
cyBpdCBpbnRyb2R1Y2VzIHVubmVjZXNzYXJ5IGJyYW5jaAppbiBkYXRhIHBhdGguIEFncmVlIHdp
dGggeW91ciBXQVJOX09OKCkgc3VnZ2VzdGlvbi4gCsKgIArCoMKgwqAgLUxpcmFuCsKgwqDCoCAK
wqDCoMKgIAoKICAgIA==
