Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3EE5313B5
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbiEWQBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238426AbiEWQBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:01:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B61D225FB
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:01:04 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-169-xDrvVGGiMgGkenFXfLrRLw-1; Mon, 23 May 2022 17:01:01 +0100
X-MC-Unique: xDrvVGGiMgGkenFXfLrRLw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Mon, 23 May 2022 17:01:00 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Mon, 23 May 2022 17:01:00 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Pavan Chebbi' <pavan.chebbi@broadcom.com>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mchan@broadcom.com" <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>
Subject: RE: tg3 dropping packets at high packet rates
Thread-Topic: tg3 dropping packets at high packet rates
Thread-Index: AdhqyKyabzDEQq15SKKGm31SHwTbKwAC24IAAAoYsMAABXOQgAASBiKAAAHW4wAABHST0AACH9sAAAKZZrD///3FgP//7fNg//44TdD/98XoIA==
Date:   Mon, 23 May 2022 16:01:00 +0000
Message-ID: <9119f62fadaa4342a34882cac835c8b0@AcuMS.aculab.com>
References: <70a20d8f91664412ae91e401391e17cb@AcuMS.aculab.com>
 <6576c307ed554adb443e62a60f099266c95b55a7.camel@redhat.com>
 <153739175cf241a5895e6a5685a89598@AcuMS.aculab.com>
 <CACKFLinwh=YgPGPZ0M0dTJK1ar+SoPUZtYb5nBmLj6CNPdCQ2g@mail.gmail.com>
 <13d6579e9bc44dc2bfb73de8d9715b10@AcuMS.aculab.com>
 <CALs4sv1RxAbVid2f8EQF_kQkk48fd=8kcz2WbkTXRkwLbPLgwA@mail.gmail.com>
 <f3d1d5bf11144b31b1b3959e95b04490@AcuMS.aculab.com>
 <5cc5353c518e27de69fc0d832294634c83f431e5.camel@redhat.com>
 <f8ff0598961146f28e2d186882928390@AcuMS.aculab.com>
 <CALs4sv2M+9N1joECMQrOGKHQ_YjMqzeF1gPD_OBQ2_r+SJwOwQ@mail.gmail.com>
 <1bc5053ef6f349989b42117eda7d2515@AcuMS.aculab.com>
 <ae631eefb45947ac84cfe0468d0b7508@AcuMS.aculab.com>
In-Reply-To: <ae631eefb45947ac84cfe0468d0b7508@AcuMS.aculab.com>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T2sgdG9kYXlzIHRlc3QgaXMgY2FsbGluZyB0cmFjaW5nX29mZigpIHdoZW4gdGhlIG5hcGkgY2Fs
bGJhY2sNCmhhcyBtb3JlIHRoYW4gMTAwMCBwYWNrZXRzIHF1ZXVlZC4NCg0KVGhpcyBpcyByYXRo
ZXIgaW5mb3JtYXRpdmUuDQpKdXN0IHRha2luZyB0aGUgdHJhY2UgZm9yIGNwdSAzMiBhbmQgc2hv
cnRlbmluZyB0aGUgbGluZXMgc29tZXdoYXQNCmdpdmVzIHRoZSBmb2xsb3dpbmcuDQoNCjxpZGxl
Pi0wICA2LjU5NDY5NTogaXJxX2hhbmRsZXJfZW50cnk6IGlycT04NyBuYW1lPWVtMi1yeC0yDQo8
aWRsZT4tMCAgNi41OTQ2OTU6IG5hcGlfc2NoZWR1bGVfcHJlcCA8LXRnM19tc2lfMXNob3QNCjxp
ZGxlPi0wICA2LjU5NDY5NTogX19uYXBpX3NjaGVkdWxlIDwtdGczX21zaV8xc2hvdA0KPGlkbGU+
LTAgIDYuNTk0Njk1OiBpcnFfaGFuZGxlcl9leGl0OiBpcnE9ODcgcmV0PWhhbmRsZWQNCjxpZGxl
Pi0wICA2LjU5NDY5NTogc29mdGlycV9lbnRyeTogdmVjPTMgW2FjdGlvbj1ORVRfUlhdDQo8aWRs
ZT4tMCAgNi41OTQ2OTY6IG5hcGlfc2NoZWR1bGVfcHJlcCA8LXRnM19yeA0KPGlkbGU+LTAgIDYu
NTk0Njk2OiBfX25hcGlfc2NoZWR1bGUgPC10ZzNfcngNCjxpZGxlPi0wICA2LjU5NDY5NzogbmFw
aV9wb2xsOiBuYXBpIHBvbGwgb24gbmFwaSBzdHJ1Y3QgMDZlNDRlZGEgZm9yIGRldmljZSBlbTIg
d29yayAxIGJ1ZGdldCA2NA0KPGlkbGU+LTAgIDYuNTk0Njk3OiBzb2Z0aXJxX2V4aXQ6IHZlYz0z
IFthY3Rpb249TkVUX1JYXQ0KPGlkbGU+LTAgIDYuNTk0Njk3OiBzb2Z0aXJxX2VudHJ5OiB2ZWM9
MyBbYWN0aW9uPU5FVF9SWF0NCjxpZGxlPi0wICA2LjU5NDY5ODogbmFwaV9wb2xsOiBuYXBpIHBv
bGwgb24gbmFwaSBzdHJ1Y3QgOTA5ZGVmMDMgZm9yIGRldmljZSBlbTIgd29yayAwIGJ1ZGdldCA2
NA0KPGlkbGU+LTAgIDYuNTk0Njk4OiBzb2Z0aXJxX2V4aXQ6IHZlYz0zIFthY3Rpb249TkVUX1JY
XQ0KPGlkbGU+LTAgIDYuNTk0NzAwOiBpcnFfaGFuZGxlcl9lbnRyeTogaXJxPTg3IG5hbWU9ZW0y
LXJ4LTINCjxpZGxlPi0wICA2LjU5NDcwMTogbmFwaV9zY2hlZHVsZV9wcmVwIDwtdGczX21zaV8x
c2hvdA0KPGlkbGU+LTAgIDYuNTk0NzAxOiBfX25hcGlfc2NoZWR1bGUgPC10ZzNfbXNpXzFzaG90
DQo8aWRsZT4tMCAgNi41OTQ3MDE6IGlycV9oYW5kbGVyX2V4aXQ6IGlycT04NyByZXQ9aGFuZGxl
ZA0KPGlkbGU+LTAgIDYuNTk0NzAxOiBzb2Z0aXJxX2VudHJ5OiB2ZWM9MyBbYWN0aW9uPU5FVF9S
WF0NCjxpZGxlPi0wICA2LjU5NDcwNDogbmFwaV9zY2hlZHVsZV9wcmVwIDwtdGczX3J4DQo8aWRs
ZT4tMCAgNi41OTQ3MDQ6IF9fbmFwaV9zY2hlZHVsZSA8LXRnM19yeA0KPGlkbGU+LTAgIDYuNTk0
NzA1OiBuYXBpX3BvbGw6IG5hcGkgcG9sbCBvbiBuYXBpIHN0cnVjdCAwNmU0NGVkYSBmb3IgZGV2
aWNlIGVtMiB3b3JrIDMgYnVkZ2V0IDY0DQo8aWRsZT4tMCAgNi41OTQ3MDY6IHNvZnRpcnFfZXhp
dDogdmVjPTMgW2FjdGlvbj1ORVRfUlhdDQo8aWRsZT4tMCAgNi41OTQ3MTA6IGlycV9oYW5kbGVy
X2VudHJ5OiBpcnE9ODcgbmFtZT1lbTItcngtMg0KPGlkbGU+LTAgIDYuNTk0NzEwOiBuYXBpX3Nj
aGVkdWxlX3ByZXAgPC10ZzNfbXNpXzFzaG90DQo8aWRsZT4tMCAgNi41OTQ3MTA6IF9fbmFwaV9z
Y2hlZHVsZSA8LXRnM19tc2lfMXNob3QNCjxpZGxlPi0wICA2LjU5NDcxMDogaXJxX2hhbmRsZXJf
ZXhpdDogaXJxPTg3IHJldD1oYW5kbGVkDQo8aWRsZT4tMCAgNi41OTQ3MTI6IHNjaGVkX3N3aXRj
aDogcHJldl9waWQ9MCBwcmV2X3ByaW89MTIwIHByZXZfc3RhdGU9UiA9PT4gbmV4dF9waWQ9MjI3
NSBuZXh0X3ByaW89NDkNCnBpZC0yMjc1ICA2LjU5NDcyMDogc3lzX2Z1dGV4KHVhZGRyOiA3ZmJk
MmJmZTNhODgsIG9wOiA4MSwgdmFsOiAxLCB1dGltZTogMTA2NDcyMCwgdWFkZHIyOiAwLCB2YWwz
OiAyN2JlYSkNCnBpZC0yMjc1ICA2LjU5NDcyMTogc3lzX2Z1dGV4IC0+IDB4MA0KcGlkLTIyNzUg
IDYuNTk4MDY3OiBzeXNfZXBvbGxfd2FpdChlcGZkOiA2MSwgZXZlbnRzOiA3ZmJkMmJmZTMzMDAs
IG1heGV2ZW50czogODAsIHRpbWVvdXQ6IDApDQpwaWQtMjI3NSAgNi41OTg3NDc6IHNjaGVkX3N3
aXRjaDogcHJldl9waWQ9MjI3NSBwcmV2X3ByaW89NDkgcHJldl9zdGF0ZT1TID09PiBuZXh0X3Bp
ZD0xNzUgbmV4dF9wcmlvPTEyMA0KcGlkLTE3NSAgIDYuNTk4NzU5OiBzY2hlZF9zd2l0Y2g6IHBy
ZXZfcGlkPTE3NSBwcmV2X3ByaW89MTIwIHByZXZfc3RhdGU9UiA9PT4gbmV4dF9waWQ9ODE5IG5l
eHRfcHJpbz0xMjANCnBpZC04MTkgICA2LjU5ODc2Mzogc2NoZWRfc3dpdGNoOiBwcmV2X3BpZD04
MTkgcHJldl9wcmlvPTEyMCBwcmV2X3N0YXRlPUkgPT0+IG5leHRfcGlkPTE3NSBuZXh0X3ByaW89
MTIwDQpwaWQtMTc1ICAgNi41OTg3NjU6IHNvZnRpcnFfZW50cnk6IHZlYz0zIFthY3Rpb249TkVU
X1JYXQ0KcGlkLTE3NSAgIDYuNTk4NzcwOiBfX25hcGlfc2NoZWR1bGUgPC1uYXBpX2NvbXBsZXRl
X2RvbmUNCnBpZC0xNzUgICA2LjU5ODc3MTogbmFwaV9wb2xsOiBuYXBpIHBvbGwgb24gbmFwaSBz
dHJ1Y3QgOTA5ZGVmMDMgZm9yIGRldmljZSBlbTIgd29yayAwIGJ1ZGdldCA2NA0KDQpUaGUgZmly
c3QgZmV3IGludGVycnVwdHMgbG9vayBmaW5lLg0KVGhlbiB0aGVyZSBpcyBhIDRtcyBkZWxheSBi
ZXR3ZWVuIHRoZSBpcnFfaGFuZGxlciBjYWxpbmcgbmFwaV9zY2hlZHVsZSgpDQphbmQgdGhlIE5F
VF9SWCBmdW5jdGlvbiBhY3R1YWxseSBiZWluZyBjYWxsZWQuDQoNCkV4Y2VwdCB0aGF0IGlzbid0
IHRoZSBhY3R1YWwgZGVsYXkuDQpUaGVyZSBhcmUgMyByZWxldmFudCBuYXBpIHN0cnVjdHVyZXMu
DQowNmU0NGVkYSAoaG9ycmlkIGhhc2ggY29uZnVzaW5nIHRoaW5ncykgZm9yIHRoZSByeCByaW5n
IG9mIGlycT04Ny4NCnh4eHh4eHh4IChub3QgaW4gdGhlIGFib3ZlIHRyYWNlKSBmb3IgdGhlIG90
aGVyIGFjdGl2ZSByeCByaW5nLg0KOTA5ZGVmMDMgZm9yIGVtMi1yeC0xIHRoYXQgaXMgYWxzbyB1
c2VkIHRvIGNvcHkgdXNlZCByeCBkZXNjcmlwdG9ycw0KYmFjayB0byB0aGUgJ2ZyZWUgYnVmZmVy
JyByaW5nLg0KDQpTbyB0aGUgbm9ybWFsIHNlcXVlbmNlIGlzIHRoZSBoYXJkX2lycSBzY2hlZHVs
ZXMgdGhlICduYXBpJyBmb3IgdGhhdCByaW5nLg0KTWF4IDY0IHBhY2tldHMgYXJlIHByb2Nlc3Nl
ZCAoUlBTIGNyb3NzIHNjaGVkdWxlcyB0aGVtKS4NClRoZW4gdGhlICduYXBpJyBmb3IgcmluZyBl
bTItcngtMCBpcyBzY2hlZHVsZWQuDQpJdCBpcyB0aGlzIG5hcGkgdGhhdCBpcyBiZWluZyByZXBv
cnRlZCBjb21wbGV0ZS4NClRoZW4gdGhlIGVtMi1yeC0yIG5hcGkgaXMgY2FsbGVkIGFuZCBmaW5k
cyAxMDAwKyBpdGVtcyBvbiB0aGUgc3RhdHVzIHJpbmcuDQoNCkR1cmluZyB0aGUgNG1zIGdhcCBl
bTItcngtNCBpcyBiZWluZyBpbnRlcnJ1cHRlZCBhbmQgdGhlIG5hcGkgaXMNCnByb2Nlc3Npbmcg
cmVjZWl2ZSBwYWNrZXRzIC0gYnV0IHRoZSBzaGFyZWQgbmFwaSAoOTA5ZGVmMDMpIGlzbid0IHJ1
bi4NCihFYXJsaWVyIGluIHRoZSB0cmFjZSBpdCBnZXRzIHNjaGVkdWxlZCBieSBib3RoIElTUi4p
DQoNCnBpZCAxNzUgaXMga3NvZnRpcnFkLzMyIGFuZCA4MTkga3dvcmtlci8zMjoyLg0KcGlkIDIy
NzUgaXMgcGFydCBvZiBvdXIgYXBwbGljYXRpb24uDQpJdCBpcyBwb3NzaWJsZSB0aGF0IGl0IGxv
b3BlZCBpbiB1c2Vyc3BhY2UgZm9yIGEgZmV3IG1zLg0KDQpCdXQgdGhlIG5hcGlfc2NoZWR1bGUo
KSBhdCA2LjU5NDcwNCBzaG91bGQgaGF2ZSBjYWxsZWQgYmFjayBhcw0KOTA5ZGVmMDMgaW1tZWRp
YXRlbHkuDQoNCkkndmUgZ290IGEgbG90IG1vcmUgZnRyYWNlIC0gYnV0IGl0IGlzIGxhcmdlIGFu
ZCBtb3N0bHkgYm9yaW5nLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2Vz
aWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVL
DQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

