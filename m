Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF7E4785E7
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbhLQIGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:06:01 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:48312 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230447AbhLQIGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 03:06:00 -0500
X-UUID: f5b200a3b8d040698929468e3edf1241-20211217
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=6wvHcOQUgOy7JO5hcgAvvG042aBuGqylo5iye7LWwUA=;
        b=U+djjF85SraZPanBApE5Z3KuhXE0YBs7RwUv50COVoJdkLWWuBtoDmSNC11hkZh90nSt8z+tzopjr85ILYMPo4Pni+2yqqbGEbmRAy61vYtzNLL96TEIA/L0B+L/8di0IbhQNMF73NV7NulK3qwzJ4n8xX/6D6uUZYX94DnFd4Q=;
X-UUID: f5b200a3b8d040698929468e3edf1241-20211217
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <xiayu.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1477008677; Fri, 17 Dec 2021 16:05:58 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 17 Dec 2021 16:05:57 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkcas10.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Fri, 17 Dec 2021 16:05:55 +0800
Message-ID: <66e7d51bb776b4127f0675ade249ef33eb54fad8.camel@mediatek.com>
Subject: Re: [PATCH] Add Multiple TX/RX Queues Support for WWAN Network
 Device
From:   Xiayu Zhang <xiayu.zhang@mediatek.com>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
CC:     Loic Poulain <loic.poulain@linaro.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Haijun Liu =?UTF-8?Q?=28=E5=88=98=E6=B5=B7=E5=86=9B=29?=" 
        <haijun.liu@mediatek.com>,
        Zhaoping Shu =?UTF-8?Q?=28=E8=88=92=E5=8F=AC=E5=B9=B3=29?= 
        <Zhaoping.Shu@mediatek.com>,
        HW He =?UTF-8?Q?=28=E4=BD=95=E4=BC=9F=29?= <HW.He@mediatek.com>,
        srv_heupstream <srv_heupstream@mediatek.com>
Date:   Fri, 17 Dec 2021 16:05:55 +0800
In-Reply-To: <CAHNKnsTMCbjS_vRZ=-sbtu6fxeDFph=r9kVuqnOVm7Y4RRJHag@mail.gmail.com>
References: <20211208040414.151960-1-xiayu.zhang@mediatek.com>
         <CAHNKnsRZpYsiWORgAejYwQqP5P=PSt-V7_i73G1yfh-UR2zFjw@mail.gmail.com>
         <6f4ae1d8b1b53cf998eaa14260d93fd3f4c8d5ad.camel@mediatek.com>
         <CAHNKnsQ6qLcUTiTiPEAp+rmoVtrGOjoY98nQFsrwSWUu-v7wYQ@mail.gmail.com>
         <76bc0c0174edc3a0c89bb880a237c844d44ac46b.camel@mediatek.com>
         <CAHNKnsTWkiaKPmOghn_ztLDOcTbci8w4wkWhQ_EZPMNu0dRy3Q@mail.gmail.com>
         <0e7b0e3d5796bb13d5243df34163849f32e8dfb3.camel@mediatek.com>
         <CAHNKnsTMCbjS_vRZ=-sbtu6fxeDFph=r9kVuqnOVm7Y4RRJHag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.1-2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQpMb29rcyBsaWtlIEkgY2FuIG9ubHkgc3VibWl0IG5ldyBXV0FOIEFQSXMg
dW50aWwgSSBmaW5kIGEgcmVhbCBpbi10cmVlDQp1c2VyIG9yIHN1Ym1pdCBhIG5ldyBkcml2ZXIu
DQoNCkFueXdheSwgdGhhbmtzIGEgbG90IGZvciB5b3VyIGhlbHAuDQoNCg0KT24gVGh1LCAyMDIx
LTEyLTE2IGF0IDIwOjM5ICswODAwLCBTZXJnZXkgUnlhemFub3Ygd3JvdGU6DQoNCj4gVGhpcyBp
cyBub3QgYSBnb29kIGlkZWEuIFNpbXVsYXRvciBpcyBpbnRlbmRlZCB0byB0ZXN0IHRoZSBBUEkg
dGhhdA0KPiBpcw0KPiB1c2VkIGJ5IG90aGVyIGRyaXZlcnMgZm9yIHJlYWwgaGFyZHdhcmUuIEJ1
dCBub3QgZm9yIGV4cGVyaW1lbnRzIHdpdGgNCj4gYW4gb3RoZXJ3aXNlICJ1c2VybGVzcyIgQVBJ
Lg0KPiANCj4gSWYgeW91IG5lZWQgdG8gY29uZmlndXJlIHRoZSBudW1iZXIgb2YgcXVldWVzIGZv
ciBhbiBhbHJlYWR5IGluLXRyZWUNCj4gZHJpdmVyLCB0aGVuIGp1c3Qgc3VibWl0IGEgcGF0Y2gg
Zm9yIGl0LiBJZiB5b3UgcGxhbiB0byBzdWJtaXQgYSBuZXcNCj4gZHJpdmVyIGFuZCB5b3UgbmVl
ZCBhbiBpbmZyYXN0cnVjdHVyZSBmb3IgaXQsIHRoZW4gaW5jbHVkZSBwYXRjaGVzDQo+IHdpdGgg
YSBuZXcgQVBJIGludG8gYSBzZXJpZXMgd2l0aCB0aGUgZHJpdmVyLg==

