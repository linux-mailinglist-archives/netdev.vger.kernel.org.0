Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15768675146
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjATJfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjATJfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:35:38 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B9761A1;
        Fri, 20 Jan 2023 01:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674207328; x=1705743328;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=4osl6iJGYr0CEOzlVC0rW6QOK/ju6t5fEqOHE72759g=;
  b=yEsSsfxCEvYtmIlM0xDVIM0DXrbQ3KoFwo/CwB/ydXDfEGk5Beq2QTEt
   cze27hcHlTg9gJ8Y2l9vPIEFl6luth+kJybTEYJelcopTWdYwrCUjIjhw
   9drFy0dHa0nEvSOG959AU1zof9iOguTewchpKXZI8ytblguYaZSyanX7Y
   9vL8WT1/klmKi/HZ/TQ2azr/BVctmEWbrDxiwQVg7RQhcI+9CKgRgDXGv
   6nsklZu338/BzMWD97P+SdgQNC1aFSdnjuuY76Lf5ECsJ/bSO3ldy+yYR
   wzyCK3wDTpG5S+idD7xhK7G/ehynpG15Eqg2G7hUnfQ1to8Kw2dT6pWZc
   A==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="196672906"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 02:35:24 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 02:35:24 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 02:35:20 -0700
Message-ID: <1a66c3d22f0d6fccb7847a6ae6df011a43af0a9c.camel@microchip.com>
Subject: Re: [PATCH net-next 3/8] net: microchip: sparx5: Add actionset type
 id information to rule
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Dan Carpenter <error27@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        "Russell King" <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Michael Walle <michael@walle.cc>
Date:   Fri, 20 Jan 2023 10:35:20 +0100
In-Reply-To: <Y8pawZOGjsfStC6n@kadam>
References: <20230120090831.20032-1-steen.hegelund@microchip.com>
         <20230120090831.20032-4-steen.hegelund@microchip.com>
         <Y8pawZOGjsfStC6n@kadam>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGFuLAoKVGhhbmtzIGZvciB0aGUgcmV2aWV3LgoKT24gRnJpLCAyMDIzLTAxLTIwIGF0IDEy
OjExICswMzAwLCBEYW4gQ2FycGVudGVyIHdyb3RlOgo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3Qg
Y2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlCj4gY29u
dGVudCBpcyBzYWZlCj4gCj4gT24gRnJpLCBKYW4gMjAsIDIwMjMgYXQgMTA6MDg6MjZBTSArMDEw
MCwgU3RlZW4gSGVnZWx1bmQgd3JvdGU6Cj4gPiArLyogQWRkIHRoZSBhY3Rpb25zZXQgdHlwZWZp
ZWxkIHRvIHRoZSBsaXN0IG9mIHJ1bGUgYWN0aW9uZmllbGRzICovCj4gPiArc3RhdGljIGludCB2
Y2FwX2FkZF90eXBlX2FjdGlvbmZpZWxkKHN0cnVjdCB2Y2FwX3J1bGUgKnJ1bGUpCj4gPiArewo+
ID4gK8KgwqDCoMKgIGVudW0gdmNhcF9hY3Rpb25maWVsZF9zZXQgYWN0aW9uc2V0ID0gcnVsZS0+
YWN0aW9uc2V0Owo+ID4gK8KgwqDCoMKgIHN0cnVjdCB2Y2FwX3J1bGVfaW50ZXJuYWwgKnJpID0g
dG9faW50cnVsZShydWxlKTsKPiA+ICvCoMKgwqDCoCBlbnVtIHZjYXBfdHlwZSB2dCA9IHJpLT5h
ZG1pbi0+dnR5cGU7Cj4gPiArwqDCoMKgwqAgY29uc3Qgc3RydWN0IHZjYXBfZmllbGQgKmZpZWxk
czsKPiA+ICvCoMKgwqDCoCBjb25zdCBzdHJ1Y3QgdmNhcF9zZXQgKmFzZXQ7Cj4gPiArwqDCoMKg
wqAgaW50IHJldCA9IC1FSU5WQUw7Cj4gPiArCj4gPiArwqDCoMKgwqAgYXNldCA9IHZjYXBfYWN0
aW9uZmllbGRzZXQocmktPnZjdHJsLCB2dCwgYWN0aW9uc2V0KTsKPiA+ICvCoMKgwqDCoCBpZiAo
IWFzZXQpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4gPiArwqDC
oMKgwqAgaWYgKGFzZXQtPnR5cGVfaWQgPT0gKHU4KS0xKcKgIC8qIE5vIHR5cGUgZmllbGQgaXMg
bmVlZGVkICovCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAwOwo+ID4gKwo+
ID4gK8KgwqDCoMKgIGZpZWxkcyA9IHZjYXBfYWN0aW9uZmllbGRzKHJpLT52Y3RybCwgdnQsIGFj
dGlvbnNldCk7Cj4gPiArwqDCoMKgwqAgaWYgKCFmaWVsZHMpCj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHJldHVybiAtRUlOVkFMOwo+ID4gK8KgwqDCoMKgIGlmIChmaWVsZHNbVkNBUF9B
Rl9UWVBFXS53aWR0aCA+IDEpIHsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0g
dmNhcF9ydWxlX2FkZF9hY3Rpb25fdTMyKHJ1bGUsIFZDQVBfQUZfVFlQRSwKPiA+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBhc2V0LT50eXBlX2lkKTsKPiA+ICvCoMKgwqDCoCB9IGVs
c2Ugewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoYXNldC0+dHlwZV9pZCkKPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9IHZjYXBfcnVs
ZV9hZGRfYWN0aW9uX2JpdChydWxlLCBWQ0FQX0FGX1RZUEUsCj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFZDQVBfQklUXzEpOwo+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBlbHNlCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCByZXQgPSB2Y2FwX3J1bGVfYWRkX2FjdGlvbl9iaXQocnVsZSwgVkNBUF9BRl9U
WVBFLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBW
Q0FQX0JJVF8wKTsKPiA+ICvCoMKgwqDCoCB9Cj4gPiArwqDCoMKgwqAgcmV0dXJuIDA7Cj4gCj4g
cmV0dXJuIHJldDsgPwoKeWVzIHRoYXQgY29ycmVjdC4uLiBJIHdpbGwgdXBkYXRlIHRoYXQuCgo+
IAo+ID4gK30KPiAKPiByZWdhcmRzLAo+IGRhbiBjYXJwZW50ZXIKPiAKCkJSClN0ZWVuCgo=

