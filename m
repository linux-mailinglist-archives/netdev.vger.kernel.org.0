Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86C1674FAA
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 09:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjATIqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 03:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjATIqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 03:46:13 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CAB8534B;
        Fri, 20 Jan 2023 00:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674204372; x=1705740372;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=tk8qj1rZrJvPEgK6EDY0l3oMB6o9yW6VyS0SSpwW99k=;
  b=VTkgQmIAbYv6v65ti0IaJt2jyolf0KYDh/K0yQO/Wbmwcw//M3tIBVuT
   Ozp35OnOKwpbxMhfelcaWj6XFZ7RPa1C4CtZZG14nGEKiunZZ2V/SXnMt
   5ZImuyOyh9w/zlkpV1R5V4IT7ptCx1ND58BZvvqHw0cn8hqTNVZauvIgV
   1A0WAxMggvi+Twxb/8RB3ItKsVBtosPkOSV//r4c5dva2ufqqrhmmmEjn
   uughwgQgpPxH6u0ErJWm8BDbXlgqr/fpdNxy16/wYy6j1jq1EDu51BTUw
   r4cf/BvT/Y343E6gNGA9wmYSLZ97gOTKRJXhsRUgUq7QjlwoYAy/uSNyj
   w==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="196667348"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 01:46:11 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 01:46:10 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 01:46:05 -0700
Message-ID: <08d8b47f8acc1fc51da2eee7eab3a55f0f678907.camel@microchip.com>
Subject: Re: [PATCH 3/7] net: lan966x: Convert to devm_of_phy_optional_get()
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?UTF-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        "Russell King" <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-phy@lists.infradead.org>,
        <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>
Date:   Fri, 20 Jan 2023 09:46:05 +0100
In-Reply-To: <a8673e0ed97d41721bb9718d3338fa6957a7f0f7.1674036164.git.geert+renesas@glider.be>
References: <cover.1674036164.git.geert+renesas@glider.be>
         <a8673e0ed97d41721bb9718d3338fa6957a7f0f7.1674036164.git.geert+renesas@glider.be>
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

SGkgR2VlcnQsCgpUaGlzIGxvb2tzIGdvb2QgdG8gbWUuCgpCUgpTdGVlbgoKUmV2aWV3ZWQtYnk6
IFN0ZWVuIEhlZ2VsdW5kIDxTdGVlbi5IZWdlbHVuZEBtaWNyb2NoaXAuY29tPgoKT24gV2VkLCAy
MDIzLTAxLTE4IGF0IDExOjE1ICswMTAwLCBHZWVydCBVeXR0ZXJob2V2ZW4gd3JvdGU6Cj4gRVhU
RVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVz
cyB5b3Uga25vdyB0aGUKPiBjb250ZW50IGlzIHNhZmUKPiAKPiBVc2UgdGhlIG5ldyBkZXZtX29m
X3BoeV9vcHRpb25hbF9nZXQoKSBoZWxwZXIgaW5zdGVhZCBvZiBvcGVuLWNvZGluZyB0aGUKPiBz
YW1lIG9wZXJhdGlvbi4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBHZWVydCBVeXR0ZXJob2V2ZW4gPGdl
ZXJ0K3JlbmVzYXNAZ2xpZGVyLmJlPgo+IC0tLQo+IMKgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWlj
cm9jaGlwL2xhbjk2NngvbGFuOTY2eF9tYWluLmMgfCA1ICsrLS0tCj4gwqAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9taWNyb2NoaXAvbGFuOTY2eC9sYW45NjZ4X21haW4uYwo+IGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL2xhbjk2NngvbGFuOTY2eF9tYWluLmMKPiBpbmRl
eCBjYWRkZTIwNTA1YmEwNjg5Li5kNjRhNTI1Y2RjOWVhMThiIDEwMDY0NAo+IC0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21pY3JvY2hpcC9sYW45NjZ4L2xhbjk2NnhfbWFpbi5jCj4gKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWljcm9jaGlwL2xhbjk2NngvbGFuOTY2eF9tYWluLmMKPiBA
QCAtMTE0Nyw5ICsxMTQ3LDggQEAgc3RhdGljIGludCBsYW45NjZ4X3Byb2JlKHN0cnVjdCBwbGF0
Zm9ybV9kZXZpY2UgKnBkZXYpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGxhbjk2
NngtPnBvcnRzW3BdLT5jb25maWcucG9ydG1vZGUgPSBwaHlfbW9kZTsKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgbGFuOTY2eC0+cG9ydHNbcF0tPmZ3bm9kZSA9IGZ3bm9kZV9oYW5k
bGVfZ2V0KHBvcnRucCk7Cj4gCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2VyZGVz
ID0gZGV2bV9vZl9waHlfZ2V0KGxhbjk2NngtPmRldiwgdG9fb2Zfbm9kZShwb3J0bnApLAo+IE5V
TEwpOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChQVFJfRVJSKHNlcmRlcykg
PT0gLUVOT0RFVikKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgc2VyZGVzID0gTlVMTDsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZXJkZXMg
PSBkZXZtX29mX3BoeV9vcHRpb25hbF9nZXQobGFuOTY2eC0+ZGV2LAo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdG9fb2Zfbm9kZShwb3J0bnApLCBOVUxMKTsKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKElTX0VSUihzZXJkZXMpKSB7Cj4gwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlcnIgPSBQVFJfRVJS
KHNlcmRlcyk7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBnb3RvIGNsZWFudXBfcG9ydHM7Cj4gLS0KPiAyLjM0LjEKPiAKCg==

