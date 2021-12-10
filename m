Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50B946F85E
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 02:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbhLJBXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 20:23:35 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:41090 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231239AbhLJBXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 20:23:34 -0500
X-UUID: 9a336d24d0074c3b83b4b2734464980f-20211210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=1ZZO+ETOhfDa+Z01cdd25TwcHTHZC47+w8uPmJpLwqs=;
        b=iRRcQh+SEOFPdzh0m0f4Ik6IffPiuHF+IvOwARYMCtkrU79k0NSu4nXgoLxMATLkD86WvkiscbPvF0fnzF4YVk1BHk7wVgAQQV2ycESORFr5KBWvelnRlgUoEgJ9xp7P5Gj3mLpvMuXsU73YX0bMOlq0tA7yblUy/e04sgLJNgI=;
X-UUID: 9a336d24d0074c3b83b4b2734464980f-20211210
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1755670767; Fri, 10 Dec 2021 09:19:56 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 10 Dec 2021 09:19:55 +0800
Received: from mhfsdcap04 (10.17.3.154) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 10 Dec 2021 09:19:54 +0800
Message-ID: <37f9979ef59c84525faaa66c40c094a72751c8cb.camel@mediatek.com>
Subject: Re: [PATCH net-next v7 1/6] stmmac: dwmac-mediatek: add platform
 level clocks management
From:   Biao Huang <biao.huang@mediatek.com>
To:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <srv_heupstream@mediatek.com>, <macpaul.lin@mediatek.com>,
        <dkirjanov@suse.de>
Date:   Fri, 10 Dec 2021 09:19:55 +0800
In-Reply-To: <2e8ccd43-bba0-9695-8d6d-d37e0b71fa7d@collabora.com>
References: <20211208054716.603-1-biao.huang@mediatek.com>
         <20211208054716.603-2-biao.huang@mediatek.com>
         <2e8ccd43-bba0-9695-8d6d-d37e0b71fa7d@collabora.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBBbmdlbG8sDQoJVGhhbmtzIGZvciB5b3VyIGNvbW1lbnRzfg0KT24gVGh1LCAyMDIxLTEy
LTA5IGF0IDExOjUxICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBSZWdubyB3cm90ZToNCj4g
SWwgMDgvMTIvMjEgMDY6NDcsIEJpYW8gSHVhbmcgaGEgc2NyaXR0bzoNCj4gPiBUaGlzIHBhdGNo
IGltcGxlbWVudHMgY2xrc19jb25maWcgY2FsbGJhY2sgZm9yIGR3bWFjLW1lZGlhdGVrDQo+ID4g
cGxhdGZvcm0sDQo+ID4gd2hpY2ggY291bGQgc3VwcG9ydCBwbGF0Zm9ybSBsZXZlbCBjbG9ja3Mg
bWFuYWdlbWVudC4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBCaWFvIEh1YW5nIDxiaWFvLmh1
YW5nQG1lZGlhdGVrLmNvbT4NCj4gDQo+IFNvcnJ5LCBJJ3ZlIHNlbnQgbXkgYWNrIG9uIHY2LiBT
ZW5kaW5nIGl0IG9uIHY3Lg0KPiANCj4gQWNrZWQtYnk6IEFuZ2Vsb0dpb2FjY2hpbm8gRGVsIFJl
Z25vIDwNCj4gYW5nZWxvZ2lvYWNjaGluby5kZWxyZWdub0Bjb2xsYWJvcmEuY29tPg0KSSdsbCBh
ZGQgImFja2VkLWJ5IiBpbiBuZXh0IHNlbmQuDQo=

