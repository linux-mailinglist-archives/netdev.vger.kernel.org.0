Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E315859E3D8
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 14:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244049AbiHWMe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 08:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352748AbiHWMc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 08:32:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7456B1022B5
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 02:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661248003; x=1692784003;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=zdDraDg7CHaoFAHlQMnA+pIXWXlOjnWyZOMkM5hXw1I=;
  b=Do5TFXTOuK9hi7BFB6QenQyEVG4AopeKn6tR1iErny0Th88mt1VPtSYW
   TaeGWB58jraB9dxVlUknAe6FLNKcaVD+QDtTZIXSk9ZKzKAJYGmYUnzn7
   MzKTpOioqwhDmT8AkQt9se4vS8uTQ0gPgbxLnxzsPR5oCd0UGPDnnZ8mt
   uUH5bvWmKGsC/7yeo0fkcr8Y/YNmXVmSec49KPVDljZW4i7y5dK/S5RZy
   Mr9sGA64/VPDxhNiQ8mLTfWluQLrP1nZWK7G7/ZCeTITsQv/Pa+k+oDjs
   2/vzEQZ+100os6FEqxakjc0croZQFAY4lFouCU4tEhyatn1xxBRLSzEwy
   A==;
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="173681572"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Aug 2022 02:46:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 23 Aug 2022 02:46:07 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 23 Aug 2022 02:46:06 -0700
Message-ID: <c4825af2a2497001f64c45086e0397ce55053649.camel@microchip.com>
Subject: Re: [PATCH net-next 3/3] net: sparx5: add support for mrouter ports
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>
Date:   Tue, 23 Aug 2022 11:46:05 +0200
In-Reply-To: <20220822140800.2651029-4-casper.casan@gmail.com>
References: <20220822140800.2651029-1-casper.casan@gmail.com>
         <20220822140800.2651029-4-casper.casan@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2FzcGVyLAoKT24gTW9uLCAyMDIyLTA4LTIyIGF0IDE2OjA4ICswMjAwLCBDYXNwZXIgQW5k
ZXJzc29uIHdyb3RlOgo+ICtzdGF0aWMgdm9pZCBzcGFyeDVfcG9ydF9hdHRyX21yb3V0ZXJfc2V0
KHN0cnVjdCBzcGFyeDVfcG9ydCAqcG9ydCwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVj
dCBuZXRfZGV2aWNlICpvcmlnX2RldiwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJvb2wgZW5h
YmxlKQo+ICt7Cj4gK8KgwqDCoMKgwqDCoCBzdHJ1Y3Qgc3Bhcng1ICpzcGFyeDUgPSBwb3J0LT5z
cGFyeDU7Cj4gK8KgwqDCoMKgwqDCoCBzdHJ1Y3Qgc3Bhcng1X21kYl9lbnRyeSAqZTsKPiArwqDC
oMKgwqDCoMKgIGJvb2wgZmxvb2RfZmxhZzsKPiArCj4gK8KgwqDCoMKgwqDCoCBpZiAoKGVuYWJs
ZSAmJiBwb3J0LT5pc19tcm91dGVyKSB8fCAoIWVuYWJsZSAmJiAhcG9ydC0+aXNfbXJvdXRlcikp
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuOwo+ICsKPiArwqDCoMKgwqDC
oMKgIC8qIEFkZC9kZWwgbXJvdXRlciBwb3J0IG9uIGFsbCBhY3RpdmUgbWRiIGVudHJpZXMgaW4g
SFcuCj4gK8KgwqDCoMKgwqDCoMKgICogRG9uJ3QgY2hhbmdlIGVudHJ5IHBvcnQgbWFzaywgc2lu
Y2UgdGhhdCByZXByZXNlbnRzCj4gK8KgwqDCoMKgwqDCoMKgICogcG9ydHMgdGhhdCBhY3R1YWxs
eSBqb2luZWQgdGhhdCBncm91cC4KPiArwqDCoMKgwqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKg
IG11dGV4X2xvY2soJnNwYXJ4NS0+bWRiX2xvY2spOwo+ICvCoMKgwqDCoMKgwqAgbGlzdF9mb3Jf
ZWFjaF9lbnRyeShlLCAmc3Bhcng1LT5tZGJfZW50cmllcywgbGlzdCkgewo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGlmICghdGVzdF9iaXQocG9ydC0+cG9ydG5vLCBlLT5wb3J0X21h
c2spICYmCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBldGhlcl9hZGRy
X2lzX2lwX21jYXN0KGUtPmFkZHIpKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBzcGFyeDVfcGdpZF91cGRhdGVfbWFzayhwb3J0LCBlLT5wZ2lkX2lkeCwg
ZW5hYmxlKTsKPiArwqDCoMKgwqDCoMKgIH0KPiArwqDCoMKgwqDCoMKgIG11dGV4X3VubG9jaygm
c3Bhcng1LT5tZGJfbG9jayk7Cj4gKwo+ICvCoMKgwqDCoMKgwqAgLyogRW5hYmxlL2Rpc2FibGUg
Zmxvb2RpbmcgZGVwZWRpbmcgb24gaWYgcG9ydCBpcyBtcm91dGVyIHBvcnQKCmRlcGVuZGluZwoK
PiArwqDCoMKgwqDCoMKgwqAgKiBvciBpZiBtY2FzdCBmbG9vZCBpcyBlbmFibGVkLgo+ICvCoMKg
wqDCoMKgwqDCoCAqLwo+ICvCoMKgwqDCoMKgwqAgcG9ydC0+aXNfbXJvdXRlciA9IGVuYWJsZTsK
PiArwqDCoMKgwqDCoMKgIGZsb29kX2ZsYWcgPSBicl9wb3J0X2ZsYWdfaXNfc2V0KHBvcnQtPm5k
ZXYsIEJSX01DQVNUX0ZMT09EKTsKPiArwqDCoMKgwqDCoMKgIHNwYXJ4NV9wb3J0X3VwZGF0ZV9t
Y2FzdF9pcF9mbG9vZChwb3J0LCBmbG9vZF9mbGFnKTsKPiArfQo+IAoKQlIKU3RlZW4KCgo=

