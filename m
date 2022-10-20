Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF26605AAA
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 11:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiJTJJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 05:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiJTJIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 05:08:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762FD19C22F;
        Thu, 20 Oct 2022 02:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666256934; x=1697792934;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=VzVml3ru9djMLT9juNFps09rLYH/GdhMKWk//DGKRRE=;
  b=UUHovZC8jKpokzjM5tjAsox5audJw7IsNF6FxHdKejfvgiSvkkRtwIVS
   vDxOFEfAtgEKZ8+9B5kJ7zl61U5h6U2my/jJMhTQU9R2JqTbyAoCAtm9s
   2UUa0rtidpPJRsvdLIlciuIGZpFaLM5QT0nX1vw4+F0pT/07t0QYbJMHo
   09vvrR6hEPTDEdp7ifZHzBcWyJo3JoQJP1kOesKpiPeOMnP/EX57dkb+s
   5x9X7COhheL6un8dwB15rjIuycH3hEe/CrGX+pzDk7G4WBRYfQMxPIn/X
   WW+EWp4MyAu9adnk5rhFro8AUokgZV5i27ue5kYjKeQgKdxdlWZz+cwpC
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="196270069"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Oct 2022 02:08:53 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 20 Oct 2022 02:08:53 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 20 Oct 2022 02:08:51 -0700
Message-ID: <194f5d4aba163e9afeaa427d968bbcd3a0e4cbc5.camel@microchip.com>
Subject: Re: [PATCH net-next v2 4/9] net: microchip: sparx5: Adding initial
 tc flower support for VCAP API
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
Date:   Thu, 20 Oct 2022 11:08:50 +0200
In-Reply-To: <20221020073134.ru2p5m5ittadthzr@wse-c0155>
References: <20221019114215.620969-1-steen.hegelund@microchip.com>
         <20221019114215.620969-5-steen.hegelund@microchip.com>
         <20221020073134.ru2p5m5ittadthzr@wse-c0155>
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

SGkgQ2FzcGVyLAoKT24gVGh1LCAyMDIyLTEwLTIwIGF0IDA5OjMxICswMjAwLCBDYXNwZXIgQW5k
ZXJzc29uIHdyb3RlOgo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQo+IAo+IEhp
IFN0ZWVuLAo+IAo+IEl0J3MgYSBwcmV0dHkgYmlnIHBhdGNoIHNlcmllcywgYnV0IG92ZXJhbGwg
SSB0aGluayBpdCBsb29rcyB2ZXJ5IGdvb2QuCj4gSSd2ZSBnb3Qgc29tZSBtaW5vciBjb21tZW50
cy4gSSBhbHNvIHRlc3RlZCBpdCBvbiB0aGUgTWljcm9jaGlwIFBDQjEzNQo+IHN3aXRjaCBhbmQg
aXQgd29ya3MgYXMgZGVzY3JpYmVkLgoKUmVhbGx5IGdvb2QgdGhhdCB5b3UgY291bGQgZmluZCB0
aW1lIHRvIGRvIHRoaXMhCgo+IAo+IE9uIDIwMjItMTAtMTkgMTM6NDIsIFN0ZWVuIEhlZ2VsdW5k
IHdyb3RlOgo+ID4gK3N0YXRpYyB2b2lkIHNwYXJ4NV90Y19mbG93ZXJfc2V0X2V4dGVycihzdHJ1
Y3QgbmV0X2RldmljZSAqbmRldiwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGZsb3dfY2xz
X29mZmxvYWQgKmZjbywKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IHZjYXBfcnVsZSAqdnJ1
bGUpCj4gPiArewo+ID4gK8KgwqDCoMKgIHN3aXRjaCAodnJ1bGUtPmV4dGVycikgewo+ID4gK8Kg
wqDCoMKgIGNhc2UgVkNBUF9FUlJfTk9ORToKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
YnJlYWs7Cj4gPiArwqDCoMKgwqAgY2FzZSBWQ0FQX0VSUl9OT19BRE1JTjoKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgTkxfU0VUX0VSUl9NU0dfTU9EKGZjby0+Y29tbW9uLmV4dGFjaywK
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCAiTWlzc2luZyBWQ0FQIGluc3RhbmNlIik7Cj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGJyZWFrOwo+ID4gK8KgwqDCoMKgIGNhc2UgVkNBUF9FUlJfTk9fTkVUREVWOgo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBOTF9TRVRfRVJSX01TR19NT0QoZmNvLT5jb21t
b24uZXh0YWNrLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgICJNaXNzaW5nIG5ldHdvcmsgaW50ZXJmYWNlIik7Cj4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOwo+ID4gK8KgwqDCoMKgIGNhc2UgVkNBUF9F
UlJfTk9fS0VZU0VUX01BVENIOgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBOTF9TRVRf
RVJSX01TR19NT0QoZmNvLT5jb21tb24uZXh0YWNrLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJObyBrZXlzZXQgbWF0
Y2hlZCB0aGUgZmlsdGVyIGtleXMiKTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnJl
YWs7Cj4gPiArwqDCoMKgwqAgY2FzZSBWQ0FQX0VSUl9OT19BQ1RJT05TRVRfTUFUQ0g6Cj4gPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIE5MX1NFVF9FUlJfTVNHX01PRChmY28tPmNvbW1vbi5l
eHRhY2ssCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgIk5vIGFjdGlvbnNldCBtYXRjaGVkIHRoZSBmaWx0ZXIgYWN0aW9u
cyIpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPiA+ICvCoMKgwqDCoCBj
YXNlIFZDQVBfRVJSX05PX1BPUlRfS0VZU0VUX01BVENIOgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBOTF9TRVRfRVJSX01TR19NT0QoZmNvLT5jb21tb24uZXh0YWNrLAo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICJObyBwb3J0IGtleXNldCBtYXRjaGVkIHRoZSBmaWx0ZXIga2V5cyIpOwo+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBicmVhazsKPiA+ICvCoMKgwqDCoCB9Cj4gPiArfQo+IAo+IENvdWxk
IHRoaXMgYWxzbyBiZSBzaGFyZWQgaW4gdGhlIFZDQVAgQVBJPyBJdCBjdXJyZW50bHkgZG9lc24n
dCB1c2UKPiBhbnl0aGluZyBTcGFyeDUgc3BlY2lmaWMuIFRob3VnaCwgbmV0X2RldmljZSBpcyB1
bnVzZWQgc28gSSdtIGd1ZXNzaW5nCj4geW91IG1pZ2h0IGhhdmUgcGxhbnMgZm9yIHRoaXMgaW4g
dGhlIGZ1dHVyZS4gQW5kIGl0IG1pZ2h0IGZpdCBiZXR0ZXIKPiBoZXJlIGFjY29yZGluZyB0byB5
b3VyIGRlc2lnbiBnb2Fscy4KClllcyB0aGlzIGlzIG5vdCBTcGFyeDUgc3BlY2lmaWMgc28gaXQg
Y291bGQgYmUgYWRkZWQgdG8gdGhlIEFQSSAod2hlcmUgdGhlIGVudW1zIGFyZSBkZWZpbmVkCmFu
eXdheSkuCgo+IAo+IFRlc3RlZC1ieTogQ2FzcGVyIEFuZGVyc3NvbiA8Y2FzcGVyLmNhc2FuQGdt
YWlsLmNvbT4KPiBSZXZpZXdlZC1ieTogQ2FzcGVyIEFuZGVyc3NvbiA8Y2FzcGVyLmNhc2FuQGdt
YWlsLmNvbT4KPiAKClRoYW5rcyBmb3IgdGhlIHJldmlldy4KCkJSClN0ZWVuCg==

