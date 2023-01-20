Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE36C675156
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjATJiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:38:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjATJiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:38:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A4B46701;
        Fri, 20 Jan 2023 01:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674207491; x=1705743491;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=CrCPdp7DU2SR8H3wVBv22zVG9Do/L77hwFPlJuPD8FM=;
  b=vo6pkY3W6yeu/JTrWVNIxX4nAPEi2Yv2Zl9MKaKYmPOAFIpfdXMzkwzw
   V42jqvibhxwon5T/467luv8WK9nnpCQ2qysVGH8OXOROrhd25UNvfzcaI
   OEqK18Nx33gspjPfXsP+67TZjCE7vJiuLTKklI95C4XtF8vlloziZJHJV
   GRamAwbK9xMjB6+3Vqwm2j5dj3YvSq8sznKCovHRSocnHVVuZtpD1wBh8
   b+Zz4usOXreNwevME6qR0skZlv0ome9VzELPNUkU4DElh9EIRqKJ5K4pI
   kgRAw1b3esiFgsH47N58YQ0K796cbNjjjrY9MuX1b8H6G8BvsBPyYzNEA
   w==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="197602287"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 02:38:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 02:38:09 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 02:38:06 -0700
Message-ID: <878fd32f9315f587f34da544a67c9a2fb27e0f44.camel@microchip.com>
Subject: Re: [PATCH net-next 7/8] net: microchip: sparx5: Add support for
 IS0 VCAP ethernet protocol types
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
Date:   Fri, 20 Jan 2023 10:38:05 +0100
In-Reply-To: <Y8pcyOn2tgscwO/A@kadam>
References: <20230120090831.20032-1-steen.hegelund@microchip.com>
         <20230120090831.20032-8-steen.hegelund@microchip.com>
         <Y8pcyOn2tgscwO/A@kadam>
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

SGkgRGFuLAoKT24gRnJpLCAyMDIzLTAxLTIwIGF0IDEyOjIwICswMzAwLCBEYW4gQ2FycGVudGVy
IHdyb3RlOgo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRh
Y2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlCj4gY29udGVudCBpcyBzYWZlCj4gCj4gT24gRnJp
LCBKYW4gMjAsIDIwMjMgYXQgMTA6MDg6MzBBTSArMDEwMCwgU3RlZW4gSGVnZWx1bmQgd3JvdGU6
Cj4gPiArYm9vbCBzcGFyeDVfdmNhcF9pc19rbm93bl9ldHlwZShzdHJ1Y3QgdmNhcF9hZG1pbiAq
YWRtaW4sIHUxNiBldHlwZSkKPiA+ICt7Cj4gPiArwqDCoMKgwqAgY29uc3QgdTE2ICprbm93bl9l
dHlwZXM7Cj4gPiArwqDCoMKgwqAgaW50IHNpemUsIGlkeDsKPiA+ICsKPiA+ICvCoMKgwqDCoCBz
d2l0Y2ggKGFkbWluLT52dHlwZSkgewo+ID4gK8KgwqDCoMKgIGNhc2UgVkNBUF9UWVBFX0lTMDoK
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga25vd25fZXR5cGVzID0gc3Bhcng1X3ZjYXBf
aXMwX2tub3duX2V0eXBlczsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6ZSA9IEFS
UkFZX1NJWkUoc3Bhcng1X3ZjYXBfaXMwX2tub3duX2V0eXBlcyk7Cj4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGJyZWFrOwo+ID4gK8KgwqDCoMKgIGNhc2UgVkNBUF9UWVBFX0lTMjoKPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga25vd25fZXR5cGVzID0gc3Bhcng1X3ZjYXBfaXMy
X2tub3duX2V0eXBlczsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6ZSA9IEFSUkFZ
X1NJWkUoc3Bhcng1X3ZjYXBfaXMyX2tub3duX2V0eXBlcyk7Cj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGJyZWFrOwo+ID4gK8KgwqDCoMKgIGRlZmF1bHQ6Cj4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGJyZWFrOwo+IAo+IHJldHVybiBmYWxzZTsgdG8gYXZvaWQgYW4gdW5pbml0
aWFsaXplZCAic2l6ZSIuCgpHb29kIGNhdGNoLiAgSSB3aWxsIHVwZGF0ZSB0aGF0Lgo+IAo+ID4g
K8KgwqDCoMKgIH0KPiA+ICvCoMKgwqDCoCBmb3IgKGlkeCA9IDA7IGlkeCA8IHNpemU7ICsraWR4
KQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoa25vd25fZXR5cGVzW2lkeF0gPT0g
ZXR5cGUpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1
cm4gdHJ1ZTsKPiA+ICvCoMKgwqDCoCByZXR1cm4gZmFsc2U7Cj4gPiArfQo+IAo+IHJlZ2FyZHMs
Cj4gZGFuIGNhcnBlbnRlcgoKVGhhbmtzIGZvciB0aGUgcmV2aWV3LgoKQlIKU3RlZW4KCgo=

