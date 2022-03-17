Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E6F4DC0B9
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiCQIOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiCQIOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:14:18 -0400
Received: from mail.sberdevices.ru (mail.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4370FBD7E8;
        Thu, 17 Mar 2022 01:12:59 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mail.sberdevices.ru (Postfix) with ESMTP id 812485FD05;
        Thu, 17 Mar 2022 11:12:56 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1647504776;
        bh=oNYXe+MX8qzbJCdiqWmvkgUmHLB8utUcXDJzvB5NPTQ=;
        h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version;
        b=czrNEOSWJPef3KIfJUcQOC7icquU7LBdbDULZBQlhD0C+6yHWHHStzphSxlM7sJP8
         SWr+/SoEIbeyIF4liuscl+mW9l+TE5rIB15hQJTiCJoI7joIoNYy4ycIshSVs4zyXs
         ELp1krrvJZSSh3SLj9UteV40FNSmlnOVDlG7op++KIL/jy9JOhUpHAGE+R9608tdZi
         KaDbLQjoDUGWZzIZ+KIUegeG1stCSo56tRrfGfVUA4F7+cbcVTNt2G5WCwBU5UjVou
         /oqSbA57/WRj0QtEY/PsXcxXX1EHS4c6pxpbtRP6Vu9iKiZl8TWMsZV2is9aIfivzS
         aGFL9hdx8HKgg==
Received: from S-MS-EXCH02.sberdevices.ru (S-MS-EXCH02.sberdevices.ru [172.16.1.5])
        by mail.sberdevices.ru (Postfix) with ESMTP;
        Thu, 17 Mar 2022 11:12:54 +0300 (MSK)
From:   Krasnov Arseniy Vladimirovich <AVKrasnov@sberdevices.ru>
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Krasnov Arseniy <oxffffaa@gmail.com>,
        Rokosov Dmitry Dmitrievich <DDRokosov@sberdevices.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 1/2] af_vsock: SOCK_SEQPACKET receive timeout
 test
Thread-Topic: [PATCH net-next v3 1/2] af_vsock: SOCK_SEQPACKET receive timeout
 test
Thread-Index: AQHYOb+Ukv8XF38YE06ap5RsA4YM1qzDBjQAgAABhoA=
Date:   Thu, 17 Mar 2022 08:11:43 +0000
Message-ID: <118c7f13-fa18-8699-1936-0b838f9adf5d@sberdevices.ru>
References: <4ecfa306-a374-93f6-4e66-be62895ae4f7@sberdevices.ru>
 <a3f95812-d5bb-86a0-46a0-78935651e39e@sberdevices.ru>
 <20220317080708.duovh4tnf6oxhciq@sgarzare-redhat>
In-Reply-To: <20220317080708.duovh4tnf6oxhciq@sgarzare-redhat>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.1.12]
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D13004DD337E84780209FA0165C4696@sberdevices.ru>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2022/03/17 04:52:00 #18991242
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTcuMDMuMjAyMiAxMTowNywgU3RlZmFubyBHYXJ6YXJlbGxhIHdyb3RlOg0KPiBPbiBUaHUs
IE1hciAxNywgMjAyMiBhdCAwNToyNjo0NUFNICswMDAwLCBLcmFzbm92IEFyc2VuaXkgVmxhZGlt
aXJvdmljaCB3cm90ZToNCj4+IFRlc3QgZm9yIHJlY2VpdmUgdGltZW91dCBjaGVjazogY29ubmVj
dGlvbiBpcyBlc3RhYmxpc2hlZCwNCj4+IHJlY2VpdmVyIHNldHMgdGltZW91dCwgYnV0IHNlbmRl
ciBkb2VzIG5vdGhpbmcuIFJlY2VpdmVyJ3MNCj4+ICdyZWFkKCknIGNhbGwgbXVzdCByZXR1cm4g
RUFHQUlOLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IEtyYXNub3YgQXJzZW5peSBWbGFkaW1pcm92
aWNoIDxBVktyYXNub3ZAc2JlcmRldmljZXMucnU+DQo+PiAtLS0NCj4+IHYyIC0+IHYzOg0KPj4g
MSkgVXNlICdmcHJpbnRmKCknIGluc3RlYWQgb2YgJ3BlcnJvcigpJyB3aGVyZSAnZXJybm8nIHZh
cmlhYmxlDQo+PiDCoMKgIGlzIG5vdCBhZmZlY3RlZC4NCj4+IDIpIFByaW50ICdyZWFkKCknIG92
ZXJoZWFkLg0KPj4NCj4+IHRvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5jIHwgODQgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+IDEgZmlsZSBjaGFuZ2VkLCA4NCBpbnNl
cnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tf
dGVzdC5jIGIvdG9vbHMvdGVzdGluZy92c29jay92c29ja190ZXN0LmMNCj4+IGluZGV4IDJhMzYz
OGMwYTAwOC4uZjU0OThkZTY3NTFkIDEwMDY0NA0KPj4gLS0tIGEvdG9vbHMvdGVzdGluZy92c29j
ay92c29ja190ZXN0LmMNCj4+ICsrKyBiL3Rvb2xzL3Rlc3RpbmcvdnNvY2svdnNvY2tfdGVzdC5j
DQo+PiBAQCAtMTYsNiArMTYsNyBAQA0KPj4gI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPg0KPj4g
I2luY2x1ZGUgPHN5cy90eXBlcy5oPg0KPj4gI2luY2x1ZGUgPHN5cy9zb2NrZXQuaD4NCj4+ICsj
aW5jbHVkZSA8dGltZS5oPg0KPj4NCj4+ICNpbmNsdWRlICJ0aW1lb3V0LmgiDQo+PiAjaW5jbHVk
ZSAiY29udHJvbC5oIg0KPj4gQEAgLTM5MSw2ICszOTIsODQgQEAgc3RhdGljIHZvaWQgdGVzdF9z
ZXFwYWNrZXRfbXNnX3RydW5jX3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVzdF9vcHRzICpvcHRzKQ0K
Pj4gwqDCoMKgwqBjbG9zZShmZCk7DQo+PiB9DQo+Pg0KPj4gK3N0YXRpYyB0aW1lX3QgY3VycmVu
dF9uc2VjKHZvaWQpDQo+PiArew0KPj4gK8KgwqDCoCBzdHJ1Y3QgdGltZXNwZWMgdHM7DQo+PiAr
DQo+PiArwqDCoMKgIGlmIChjbG9ja19nZXR0aW1lKENMT0NLX1JFQUxUSU1FLCAmdHMpKSB7DQo+
PiArwqDCoMKgwqDCoMKgwqAgcGVycm9yKCJjbG9ja19nZXR0aW1lKDMpIGZhaWxlZCIpOw0KPj4g
K8KgwqDCoMKgwqDCoMKgIGV4aXQoRVhJVF9GQUlMVVJFKTsNCj4+ICvCoMKgwqAgfQ0KPj4gKw0K
Pj4gK8KgwqDCoCByZXR1cm4gKHRzLnR2X3NlYyAqIDEwMDAwMDAwMDBVTEwpICsgdHMudHZfbnNl
YzsNCj4+ICt9DQo+PiArDQo+PiArI2RlZmluZSBSQ1ZUSU1FT19USU1FT1VUX1NFQyAxDQo+PiAr
I2RlZmluZSBSRUFEX09WRVJIRUFEX05TRUMgMjUwMDAwMDAwIC8qIDAuMjUgc2VjICovDQo+PiAr
DQo+PiArc3RhdGljIHZvaWQgdGVzdF9zZXFwYWNrZXRfdGltZW91dF9jbGllbnQoY29uc3Qgc3Ry
dWN0IHRlc3Rfb3B0cyAqb3B0cykNCj4+ICt7DQo+PiArwqDCoMKgIGludCBmZDsNCj4+ICvCoMKg
wqAgc3RydWN0IHRpbWV2YWwgdHY7DQo+PiArwqDCoMKgIGNoYXIgZHVtbXk7DQo+PiArwqDCoMKg
IHRpbWVfdCByZWFkX2VudGVyX25zOw0KPj4gK8KgwqDCoCB0aW1lX3QgcmVhZF9vdmVyaGVhZF9u
czsNCj4+ICsNCj4+ICvCoMKgwqAgZmQgPSB2c29ja19zZXFwYWNrZXRfY29ubmVjdChvcHRzLT5w
ZWVyX2NpZCwgMTIzNCk7DQo+PiArwqDCoMKgIGlmIChmZCA8IDApIHsNCj4+ICvCoMKgwqDCoMKg
wqDCoCBwZXJyb3IoImNvbm5lY3QiKTsNCj4+ICvCoMKgwqDCoMKgwqDCoCBleGl0KEVYSVRfRkFJ
TFVSRSk7DQo+PiArwqDCoMKgIH0NCj4+ICsNCj4+ICvCoMKgwqAgdHYudHZfc2VjID0gUkNWVElN
RU9fVElNRU9VVF9TRUM7DQo+PiArwqDCoMKgIHR2LnR2X3VzZWMgPSAwOw0KPj4gKw0KPj4gK8Kg
wqDCoCBpZiAoc2V0c29ja29wdChmZCwgU09MX1NPQ0tFVCwgU09fUkNWVElNRU8sICh2b2lkICop
JnR2LCBzaXplb2YodHYpKSA9PSAtMSkgew0KPj4gK8KgwqDCoMKgwqDCoMKgIHBlcnJvcigic2V0
c29ja29wdCAnU09fUkNWVElNRU8nIik7DQo+PiArwqDCoMKgwqDCoMKgwqAgZXhpdChFWElUX0ZB
SUxVUkUpOw0KPj4gK8KgwqDCoCB9DQo+PiArDQo+PiArwqDCoMKgIHJlYWRfZW50ZXJfbnMgPSBj
dXJyZW50X25zZWMoKTsNCj4+ICsNCj4+ICvCoMKgwqAgaWYgKGVycm5vICE9IEVBR0FJTikgew0K
Pj4gK8KgwqDCoMKgwqDCoMKgIHBlcnJvcigiRUFHQUlOIGV4cGVjdGVkIik7DQo+PiArwqDCoMKg
wqDCoMKgwqAgZXhpdChFWElUX0ZBSUxVUkUpOw0KPj4gK8KgwqDCoCB9DQo+IA0KPiBTaG91bGQg
dGhpcyBjaGVjayBnbyBhZnRlciByZWFkKCk/DQo+IA0KPiBJbmRlZWQgbm93IHRoZSB0ZXN0IGZh
aWxzIG9uIG15IGVudmlyb25tZW50IHdpdGggIkVBR0FJTiBleHBlY3RlZCIgbWVzc2FnZS4NCj4g
DQo+IFRoZSByZXN0IExHVE0gOi0pDQoNCk9vcHMsIHNvcnJ5IDopIA0KDQo+IA0KPiBTdGVmYW5v
DQo+IA0KPj4gKw0KPj4gK8KgwqDCoCBpZiAocmVhZChmZCwgJmR1bW15LCBzaXplb2YoZHVtbXkp
KSAhPSAtMSkgew0KPj4gK8KgwqDCoMKgwqDCoMKgIGZwcmludGYoc3RkZXJyLA0KPj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgImV4cGVjdGVkICdkdW1teScgcmVhZCgyKSBmYWlsdXJlXG4iKTsN
Cj4+ICvCoMKgwqDCoMKgwqDCoCBleGl0KEVYSVRfRkFJTFVSRSk7DQo+PiArwqDCoMKgIH0NCj4+
ICsNCj4+ICvCoMKgwqAgcmVhZF9vdmVyaGVhZF9ucyA9IGN1cnJlbnRfbnNlYygpIC0gcmVhZF9l
bnRlcl9ucyAtDQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxMDAwMDAwMDAwVUxMICogUkNW
VElNRU9fVElNRU9VVF9TRUM7DQo+PiArDQo+PiArwqDCoMKgIGlmIChyZWFkX292ZXJoZWFkX25z
ID4gUkVBRF9PVkVSSEVBRF9OU0VDKSB7DQo+PiArwqDCoMKgwqDCoMKgwqAgZnByaW50ZihzdGRl
cnIsDQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAidG9vIG11Y2ggdGltZSBpbiByZWFkKDIp
LCAlbHUgPiAlaSBuc1xuIiwNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJlYWRfb3Zlcmhl
YWRfbnMsIFJFQURfT1ZFUkhFQURfTlNFQyk7DQo+PiArwqDCoMKgwqDCoMKgwqAgZXhpdChFWElU
X0ZBSUxVUkUpOw0KPj4gK8KgwqDCoCB9DQo+PiArDQo+PiArwqDCoMKgIGNvbnRyb2xfd3JpdGVs
bigiV0FJVERPTkUiKTsNCj4+ICvCoMKgwqAgY2xvc2UoZmQpOw0KPj4gK30NCj4+ICsNCj4+ICtz
dGF0aWMgdm9pZCB0ZXN0X3NlcXBhY2tldF90aW1lb3V0X3NlcnZlcihjb25zdCBzdHJ1Y3QgdGVz
dF9vcHRzICpvcHRzKQ0KPj4gK3sNCj4+ICvCoMKgwqAgaW50IGZkOw0KPj4gKw0KPj4gK8KgwqDC
oCBmZCA9IHZzb2NrX3NlcXBhY2tldF9hY2NlcHQoVk1BRERSX0NJRF9BTlksIDEyMzQsIE5VTEwp
Ow0KPj4gK8KgwqDCoCBpZiAoZmQgPCAwKSB7DQo+PiArwqDCoMKgwqDCoMKgwqAgcGVycm9yKCJh
Y2NlcHQiKTsNCj4+ICvCoMKgwqDCoMKgwqDCoCBleGl0KEVYSVRfRkFJTFVSRSk7DQo+PiArwqDC
oMKgIH0NCj4+ICsNCj4+ICvCoMKgwqAgY29udHJvbF9leHBlY3RsbigiV0FJVERPTkUiKTsNCj4+
ICvCoMKgwqAgY2xvc2UoZmQpOw0KPj4gK30NCj4+ICsNCj4+IHN0YXRpYyBzdHJ1Y3QgdGVzdF9j
YXNlIHRlc3RfY2FzZXNbXSA9IHsNCj4+IMKgwqDCoMKgew0KPj4gwqDCoMKgwqDCoMKgwqAgLm5h
bWUgPSAiU09DS19TVFJFQU0gY29ubmVjdGlvbiByZXNldCIsDQo+PiBAQCAtNDMxLDYgKzUxMCwx
MSBAQCBzdGF0aWMgc3RydWN0IHRlc3RfY2FzZSB0ZXN0X2Nhc2VzW10gPSB7DQo+PiDCoMKgwqDC
oMKgwqDCoCAucnVuX2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0X21zZ190cnVuY19jbGllbnQsDQo+
PiDCoMKgwqDCoMKgwqDCoCAucnVuX3NlcnZlciA9IHRlc3Rfc2VxcGFja2V0X21zZ190cnVuY19z
ZXJ2ZXIsDQo+PiDCoMKgwqDCoH0sDQo+PiArwqDCoMKgIHsNCj4+ICvCoMKgwqDCoMKgwqDCoCAu
bmFtZSA9ICJTT0NLX1NFUVBBQ0tFVCB0aW1lb3V0IiwNCj4+ICvCoMKgwqDCoMKgwqDCoCAucnVu
X2NsaWVudCA9IHRlc3Rfc2VxcGFja2V0X3RpbWVvdXRfY2xpZW50LA0KPj4gK8KgwqDCoMKgwqDC
oMKgIC5ydW5fc2VydmVyID0gdGVzdF9zZXFwYWNrZXRfdGltZW91dF9zZXJ2ZXIsDQo+PiArwqDC
oMKgIH0sDQo+PiDCoMKgwqDCoHt9LA0KPj4gfTsNCj4+DQo+PiAtLcKgDQo+PiAyLjI1LjENCj4g
DQoNCg==
