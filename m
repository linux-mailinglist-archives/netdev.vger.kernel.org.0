Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7462959E3CD
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 14:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242404AbiHWMda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 08:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351880AbiHWMc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 08:32:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB2910228C
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 02:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661247988; x=1692783988;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ODfdSnvWj7LpmhD6dP5W2j1HkmPxHgWTb+QAB0pZWTg=;
  b=vaP6GtzsTTWpZ/f2dQ0GZBmnJYiGEYjz74hvLBJOgmp9ehHRn2XqWa26
   ZagU5hgOfpG3gPkkE+ozozz2Bdz90uqQbJ2SWUwEvK4nabcg97hmEHDEb
   eH/pFme3/0Fr3NA/Gk72i/FNnNJjTFqO63BYZVlY09b2K8PFzubD6sINs
   9eetQt0jKgVBsLYx2EnBXX2hp9IIAfbqmeuoaUyOXfJWeLBtiA8BLVrCR
   idJxQyxEpwtzHyork4Pu3Svhg999Y4J8lNIF+cBxVCcXETVrfzFbAGw6W
   f5KrNvoz7CzRIKUOz1KuSE5e59N/4dcwBW7pfVssP75UzYl/jvCZUmYcx
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="187663480"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Aug 2022 02:44:52 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 23 Aug 2022 02:44:52 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 23 Aug 2022 02:44:50 -0700
Message-ID: <5ef2437f89fd5d7a5e53b5c0a460bb32277b866a.camel@microchip.com>
Subject: Re: [PATCH net-next 2/3] net: sparx5: add list for mdb entries in
 driver
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Casper Andersson <casper.casan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        <UNGLinuxDriver@microchip.com>
Date:   Tue, 23 Aug 2022 11:44:50 +0200
In-Reply-To: <20220822140800.2651029-3-casper.casan@gmail.com>
References: <20220822140800.2651029-1-casper.casan@gmail.com>
         <20220822140800.2651029-3-casper.casan@gmail.com>
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

T24gTW9uLCAyMDIyLTA4LTIyIGF0IDE2OjA3ICswMjAwLCBDYXNwZXIgQW5kZXJzc29uIHdyb3Rl
Ogo+ICtzdGF0aWMgdm9pZCBzcGFyeDVfZnJlZV9tZGJfZW50cnkoc3RydWN0IHNwYXJ4NSAqc3Bh
cng1LAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGNvbnN0IHVuc2lnbmVkIGNoYXIgKmFkZHIsCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdTE2
IHZpZCkKPiArewo+ICvCoMKgwqDCoMKgwqAgc3RydWN0IHNwYXJ4NV9tZGJfZW50cnkgKmVudHJ5
LCAqdG1wOwo+ICsKPiArwqDCoMKgwqDCoMKgIG11dGV4X2xvY2soJnNwYXJ4NS0+bWRiX2xvY2sp
Owo+ICvCoMKgwqDCoMKgwqAgbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKGVudHJ5LCB0bXAsICZz
cGFyeDUtPm1kYl9lbnRyaWVzLCBsaXN0KSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgaWYgKCh2aWQgPT0gMCB8fCBlbnRyeS0+dmlkID09IHZpZCkgJiYKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGV0aGVyX2FkZHJfZXF1YWwoYWRkciwgZW50cnktPmFk
ZHIpKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGxp
c3RfZGVsKCZlbnRyeS0+bGlzdCk7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBzcGFyeDVfcGdpZF9mcmVlKHNwYXJ4NSwgZW50cnktPnBnaWRfaWR4
KTsKPiArCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRl
dm1fa2ZyZWUoc3Bhcng1LT5kZXYsIGVudHJ5KTsKCkNvdWxkIHlvdSBub3QgYWxzbyBiYWlsIG91
dCBoZXJlLCBsaWtlIHlvdSBkbyBiZWxvdz8KCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgfQo+ICvCoMKgwqDCoMKgwqAgfQo+ICvCoMKgwqDCoMKgwqAgbXV0ZXhfdW5sb2NrKCZzcGFy
eDUtPm1kYl9sb2NrKTsKPiArfQo+ICsKPiAKPiAtLQo+IDIuMzQuMQo+IAoKQlIKU3RlZW4KCg==

