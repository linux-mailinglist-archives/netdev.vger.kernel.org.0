Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7940A605AFB
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 11:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiJTJTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 05:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiJTJTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 05:19:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F731BE91F;
        Thu, 20 Oct 2022 02:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666257543; x=1697793543;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=tb3/jJqfV/cnFY/+vPv1Q6XXe9/cFEmryhOXD4vins4=;
  b=THIyGqfOVcj/2YBDI2fhe5VF3AgWTUkKeSn0nPNdeubYtqZBnP5qwGEX
   VEpbULzXgnbglSGtUcpELuXMd3JcTZWZxW8LKjQ8upRUKmUcM/euT9VI0
   oh+wUEf8E2GQLX7gfGCbVEruaFf/CotfpTDVWbOPSYoc/wkmfiotOC5f4
   nA7zQOAiOLUgkC6ors8OZuLkuv9XhTZUliGeLAI6pD2xzXlxBN073C2Bu
   U4AWD8cjme9Be75bvddwGcAYN0iWPbYEc9CujBJ1LV6Rdv7yggMnUjGbr
   ibPSMNB2YYC8xEqa+QsJ72NCwURJN7FtTv2Di8iaIn8CFl5vwsZUsR00z
   g==;
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="185545953"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Oct 2022 02:19:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 20 Oct 2022 02:19:02 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 20 Oct 2022 02:18:59 -0700
Message-ID: <ad58204683d52a049fe8f3aba525184e48bd0821.camel@microchip.com>
Subject: Re: [PATCH net-next v2 6/9] net: microchip: sparx5: Adding basic
 rule management in VCAP API
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "Wan Jiabing" <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date:   Thu, 20 Oct 2022 11:18:59 +0200
In-Reply-To: <20221020074104.qmow2fc66v4is2rk@wse-c0155>
References: <20221019114215.620969-1-steen.hegelund@microchip.com>
         <20221019114215.620969-7-steen.hegelund@microchip.com>
         <20221020074104.qmow2fc66v4is2rk@wse-c0155>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2FzcGVyLAoKT24gVGh1LCAyMDIyLTEwLTIwIGF0IDA5OjQxICswMjAwLCBDYXNwZXIgQW5k
ZXJzc29uIHdyb3RlOgo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQo+IAo+IE9u
IDIwMjItMTAtMTkgMTM6NDIsIFN0ZWVuIEhlZ2VsdW5kIHdyb3RlOgo+ID4gKy8qIFdyaXRlIFZD
QVAgY2FjaGUgY29udGVudCB0byB0aGUgVkNBUCBIVyBpbnN0YW5jZSAqLwo+ID4gK3N0YXRpYyBp
bnQgdmNhcF93cml0ZV9ydWxlKHN0cnVjdCB2Y2FwX3J1bGVfaW50ZXJuYWwgKnJpKQo+ID4gK3sK
PiA+ICvCoMKgwqDCoCBzdHJ1Y3QgdmNhcF9hZG1pbiAqYWRtaW4gPSByaS0+YWRtaW47Cj4gPiAr
wqDCoMKgwqAgaW50IHN3X2lkeCwgZW50X2lkeCA9IDAsIGFjdF9pZHggPSAwOwo+ID4gK8KgwqDC
oMKgIHUzMiBhZGRyID0gcmktPmFkZHI7Cj4gPiArCj4gPiArwqDCoMKgwqAgaWYgKCFyaS0+c2l6
ZSB8fCAhcmktPmtleXNldF9zd19yZWdzIHx8ICFyaS0+YWN0aW9uc2V0X3N3X3JlZ3MpIHsKPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJfZXJyKCIlczolZDogcnVsZSBpcyBlbXB0eVxu
IiwgX19mdW5jX18sIF9fTElORV9fKTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0
dXJuIC1FSU5WQUw7Cj4gPiArwqDCoMKgwqAgfQo+ID4gK8KgwqDCoMKgIC8qIFVzZSB0aGUgdmFs
dWVzIGluIHRoZSBzdHJlYW1zIHRvIHdyaXRlIHRoZSBWQ0FQIGNhY2hlICovCj4gPiArwqDCoMKg
wqAgZm9yIChzd19pZHggPSAwOyBzd19pZHggPCByaS0+c2l6ZTsgc3dfaWR4KyssIGFkZHIrKykg
ewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByaS0+dmN0cmwtPm9wcy0+Y2FjaGVfd3Jp
dGUocmktPm5kZXYsIGFkbWluLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBWQ0FQX1NFTF9FTlRSWSwg
ZW50X2lkeCwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmktPmtleXNldF9zd19yZWdzKTsKPiA+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmktPnZjdHJsLT5vcHMtPmNhY2hlX3dyaXRlKHJpLT5u
ZGV2LCBhZG1pbiwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVkNBUF9TRUxfQUNUSU9OLCBhY3RfaWR4
LAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByaS0+YWN0aW9uc2V0X3N3X3JlZ3MpOwo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCByaS0+dmN0cmwtPm9wcy0+dXBkYXRlKHJpLT5uZGV2LCBhZG1p
biwgVkNBUF9DTURfV1JJVEUsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgVkNBUF9TRUxfQUxMLCBhZGRyKTsKPiAKPiBB
cmd1bWVudHMgbm90IGFsaWduZWQgd2l0aCBvcGVuaW5nIHBhcmVudGhlc2lzLgoKSSB3aWxsIGZp
eCB0aGF0LgoKPiAKPiA+IMKgLyogVmFsaWRhdGUgYSBydWxlIHdpdGggcmVzcGVjdCB0byBhdmFp
bGFibGUgcG9ydCBrZXlzICovCj4gPiDCoGludCB2Y2FwX3ZhbF9ydWxlKHN0cnVjdCB2Y2FwX3J1
bGUgKnJ1bGUsIHUxNiBsM19wcm90bykKPiA+IMKgewo+ID4gwqDCoMKgwqDCoCBzdHJ1Y3QgdmNh
cF9ydWxlX2ludGVybmFsICpyaSA9IHRvX2ludHJ1bGUocnVsZSk7Cj4gPiArwqDCoMKgwqAgZW51
bSB2Y2FwX2tleWZpZWxkX3NldCBrZXlzZXRzWzEwXTsKPiA+ICvCoMKgwqDCoCBzdHJ1Y3QgdmNh
cF9rZXlzZXRfbGlzdCBrc2xpc3Q7Cj4gPiArwqDCoMKgwqAgaW50IHJldDsKPiA+IAo+ID4gwqDC
oMKgwqDCoCAvKiBUaGlzIHZhbGlkYXRpb24gd2lsbCBiZSBtdWNoIGV4cGFuZGVkIGxhdGVyICov
Cj4gPiArwqDCoMKgwqAgcmV0ID0gdmNhcF9hcGlfY2hlY2socmktPnZjdHJsKTsKPiA+ICvCoMKg
wqDCoCBpZiAocmV0KQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gcmV0Owo+
ID4gwqDCoMKgwqDCoCBpZiAoIXJpLT5hZG1pbikgewo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcmktPmRhdGEuZXh0ZXJyID0gVkNBUF9FUlJfTk9fQURNSU47Cj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPiA+IEBAIC0xMTMsMTQgKzMwNCw0MSBA
QCBpbnQgdmNhcF92YWxfcnVsZShzdHJ1Y3QgdmNhcF9ydWxlICpydWxlLCB1MTYgbDNfcHJvdG8p
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByaS0+ZGF0YS5leHRlcnIgPSBWQ0FQX0VS
Ul9OT19LRVlTRVRfTUFUQ0g7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4g
LUVJTlZBTDsKPiA+IMKgwqDCoMKgwqAgfQo+ID4gK8KgwqDCoMKgIC8qIHByZXBhcmUgZm9yIGtl
eXNldCB2YWxpZGF0aW9uICovCj4gPiArwqDCoMKgwqAga2V5c2V0c1swXSA9IHJpLT5kYXRhLmtl
eXNldDsKPiA+ICvCoMKgwqDCoCBrc2xpc3Qua2V5c2V0cyA9IGtleXNldHM7Cj4gPiArwqDCoMKg
wqAga3NsaXN0LmNudCA9IDE7Cj4gPiArwqDCoMKgwqAgLyogUGljayBhIGtleXNldCB0aGF0IGlz
IHN1cHBvcnRlZCBpbiB0aGUgcG9ydCBsb29rdXBzICovCj4gPiArwqDCoMKgwqAgcmV0ID0gcmkt
PnZjdHJsLT5vcHMtPnZhbGlkYXRlX2tleXNldChyaS0+bmRldiwgcmktPmFkbWluLCBydWxlLCAm
a3NsaXN0LAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBsM19wcm90byk7Cj4gPiAr
wqDCoMKgwqAgaWYgKHJldCA8IDApIHsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcHJf
ZXJyKCIlczolZDoga2V5c2V0IHZhbGlkYXRpb24gZmFpbGVkOiAlZFxuIiwKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBfX2Z1bmNfXywgX19MSU5FX18sIHJldCk7
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJpLT5kYXRhLmV4dGVyciA9IFZDQVBfRVJS
X05PX1BPUlRfS0VZU0VUX01BVENIOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1
cm4gcmV0Owo+ID4gK8KgwqDCoMKgIH0KPiA+IMKgwqDCoMKgwqAgaWYgKHJpLT5kYXRhLmFjdGlv
bnNldCA9PSBWQ0FQX0FGU19OT19WQUxVRSkgewo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgcmktPmRhdGEuZXh0ZXJyID0gVkNBUF9FUlJfTk9fQUNUSU9OU0VUX01BVENIOwo+ID4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4gPiDCoMKgwqDCoMKgIH0K
PiA+IC3CoMKgwqDCoCByZXR1cm4gMDsKPiA+ICvCoMKgwqDCoCB2Y2FwX2FkZF90eXBlX2tleWZp
ZWxkKHJ1bGUpOwo+ID4gK8KgwqDCoMKgIC8qIEFkZCBkZWZhdWx0IGZpZWxkcyB0byB0aGlzIHJ1
bGUgKi8KPiA+ICvCoMKgwqDCoCByaS0+dmN0cmwtPm9wcy0+YWRkX2RlZmF1bHRfZmllbGRzKHJp
LT5uZGV2LCByaS0+YWRtaW4sIHJ1bGUpOwo+ID4gKwo+ID4gK8KgwqDCoMKgIC8qIFJ1bGUgc2l6
ZSBpcyB0aGUgbWF4aW11bSBvZiB0aGUgZW50cnkgYW5kIGFjdGlvbiBzdWJ3b3JkIGNvdW50ICov
Cj4gPiArwqDCoMKgwqAgcmktPnNpemUgPSBtYXgocmktPmtleXNldF9zdywgcmktPmFjdGlvbnNl
dF9zdyk7Cj4gPiArCj4gPiArwqDCoMKgwqAgLyogRmluYWxseSBjaGVjayBpZiB0aGVyZSBpcyBy
b29tIGZvciB0aGUgcnVsZSBpbiB0aGUgVkNBUCAqLwo+ID4gK8KgwqDCoMKgIHJldHVybiB2Y2Fw
X3J1bGVfc3BhY2UocmktPmFkbWluLCByaS0+c2l6ZSk7Cj4gPiDCoH0KPiA+IMKgRVhQT1JUX1NZ
TUJPTF9HUEwodmNhcF92YWxfcnVsZSk7Cj4gCj4gVmFsaWRhdGluZyBhIHJ1bGUgYWxzbyBtb2Rp
ZmllcyBpdC4gSSB0aGluayB2YWxpZGF0aW9uIGFuZCBtb2RpZmljYXRpb24KPiBzaG91bGQgZ2Vu
ZXJhbGx5IGJlIGtlcHQgYXBhcnQuIEJ1dCBpdCBsb29rcyBsaWtlIGl0IG1pZ2h0IGJlIGhhcmQg
d2l0aAo+IHRoZSBjdXJyZW50IGRlc2lnbiBzaW5jZSB5b3UgbmVlZCB0byBhZGQgdGhlIGZpZWxk
cyB0byB0aGVuIGNoZWNrIHRoZQo+IHNwYWNlIGl0IHRha2VzLCBhbmQgdGhlIHJ1bGUgc2l6ZXMg
Y2FuIGRlcGVuZCBvbiB0aGUgaGFyZHdhcmUuCgpIbW0uICBZb3UgZ290IGEgcG9pbnQuICBJIGp1
c3Qgd2FudGVkIHRvIGtlZXAgdGhlIG51bWJlciBvZiBBUEkgY2FsbHMgZG93biBhIGJpdCwgc28g
dGhlIHZhbGlkYXRpb24KYWxzbyBlbnN1cmVzIHRoYXQgdGhlIHJ1bGUgaGFzIGEga2V5c2V0IHR5
cGUgZmllbGQgYW5kIGFueSBvdGhlciBkZWZhdWx0IGZpZWxkcyB0aGF0IGlzIG5lZWRlZCBpbgp0
aGUgcGFydGljdWxhciBWQ0FQIGFuZCBzZXR0aW5nIHRoZSBrZXlzZXQgZGVmaW5lcyB0aGUgc2l6
ZSBvZiB0aGUgcnVsZSwgc28gaXQgYWxsIG5lZWRzIHRvIGZpdAp0b2dldGhlciBpbiB0aGUgZW5k
LgpGb3Igbm93IEkgd291bGQgbGlrZSB0byBrZWVwIHRoaXMgYXMganVzdCBvbmUgdmFsaWRhdGlv
biBjYWxsLgoKPiAKPiBUZXN0ZWQgb24gTWljcm9jaGlwIFBDQjEzNSBzd2l0Y2guCj4gCj4gVGVz
dGVkLWJ5OiBDYXNwZXIgQW5kZXJzc29uIDxjYXNwZXIuY2FzYW5AZ21haWwuY29tPgo+IFJldmll
d2VkLWJ5OiBDYXNwZXIgQW5kZXJzc29uIDxjYXNwZXIuY2FzYW5AZ21haWwuY29tPgo+IAoKQlIK
U3RlZW4K

