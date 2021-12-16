Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840E147716E
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 13:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbhLPMNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 07:13:36 -0500
Received: from mailgw01.mediatek.com ([60.244.123.138]:41310 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233971AbhLPMNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 07:13:35 -0500
X-UUID: e6031b54c83246198f5d03cca87adb32-20211216
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=JsBeYaZYeXLVXHzQMc7eN1VR8gvo5vkunK6fwqeNtL4=;
        b=T/1nG0WuT18kRCDoDRUatg1nfJTohaClXY7BUkVHIdQ2NTcO74EoDOZsCJjuQ/0Ik2gag24eCVoXYLczQLUa/wUn2k4qS7u7CrOkDhbBvV91TIo0HtEG+j6YoV+P1r9PnmhoS8r1GMfwUcTvYJ2SJdtKRfOY75fTH1C7ISxET94=;
X-UUID: e6031b54c83246198f5d03cca87adb32-20211216
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <xiayu.zhang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1278258318; Thu, 16 Dec 2021 20:13:33 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 16 Dec 2021 20:13:31 +0800
Received: from mcddlt001.gcn.mediatek.inc (10.19.240.15) by
 mtkcas10.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 16 Dec 2021 20:13:30 +0800
Message-ID: <0e7b0e3d5796bb13d5243df34163849f32e8dfb3.camel@mediatek.com>
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
Date:   Thu, 16 Dec 2021 20:13:30 +0800
In-Reply-To: <CAHNKnsTWkiaKPmOghn_ztLDOcTbci8w4wkWhQ_EZPMNu0dRy3Q@mail.gmail.com>
References: <20211208040414.151960-1-xiayu.zhang@mediatek.com>
         <CAHNKnsRZpYsiWORgAejYwQqP5P=PSt-V7_i73G1yfh-UR2zFjw@mail.gmail.com>
         <6f4ae1d8b1b53cf998eaa14260d93fd3f4c8d5ad.camel@mediatek.com>
         <CAHNKnsQ6qLcUTiTiPEAp+rmoVtrGOjoY98nQFsrwSWUu-v7wYQ@mail.gmail.com>
         <76bc0c0174edc3a0c89bb880a237c844d44ac46b.camel@mediatek.com>
         <CAHNKnsTWkiaKPmOghn_ztLDOcTbci8w4wkWhQ_EZPMNu0dRy3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.1-2 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5IGFuZCBMb2ljLA0KDQpSZWFsbHkgdGhhbmsgeW91IGZvciB0aGVzZSBpbmZvcm1h
dGlvbi4NCg0KSXQgc2VlbXMgdGhhdCBJIG5lZWQgdG8gc3VibWl0IGFub3RoZXIgcGF0Y2ggZm9y
IGRpc2N1c3Npb24uDQoNCkF0IHRoZSBtZWFudGltZSwgSSBoYXZlIHNvbWUgcXVlc3Rpb25zIGJl
bG93IGFuZCBob3BlIHlvdSBjb3VsZCBkbyBtZSBhDQpmYXZvci4NCg0KT24gV2VkLCAyMDIxLTEy
LTE1IGF0IDIyOjE2ICswODAwLCBTZXJnZXkgUnlhemFub3Ygd3JvdGU6DQoNCj4gVGhlcmUgYXJl
IHR3byB0aGluZ3MgdGhhdCB0cmlnZ2VyIHRoZSBkaXNjdXNzaW9uOg0KPiAxKSBhYnNlbmNlIG9m
IHVzZXJzIG9mIHRoZSBuZXcgQVBJOw0KDQpDYW4gSSBjaG9vc2UgV1dBTiBkZXZpY2Ugc2ltdWxh
dG9yICh3d2FuX2h3c2ltLmMpIGFzIHRoZSBpbi10cmVlIHVzZXINCmZvciB0aGVzZSBuZXcgQVBJ
cz8gQW5kLCBDYW4gSSBzdWJtaXQgbmV3IEFQSXMgYW5kIGNoYW5nZXMgZm9yIHRoZSB1c2VyDQpk
cml2ZXIgaW4gYSBzaW5nbGUgcGF0Y2g/DQoNCj4gMikgYW4gYXR0ZW1wdCB0byBzaWxlbnRseSBj
b3JyZWN0IGEgdXNlciBjaG9pY2UgaW5zdGVhZCBvZiBleHBsaWNpdA0KPiByZWplY3Rpb24gb2Yg
YSB3cm9uZyB2YWx1ZS4NCg0KSSB3aWxsIHRyeSB0byBmb2xsb3cgdGhpczoNCiAgIGEuIElmIHVz
ZXIgZG9lc24ndCBzcGVjaWZ5IGEgbnVtYmVyLCB1c2UgV1dBTiBkcml2ZXIncyBkZWZhdWx0DQog
ICBudW1iZXIuDQogICBiLiBJZiB1c2VyIHNwZWNpZmllcyBhbiBpbXByb3BlciB2YWx1ZSwgcmVq
ZWN0IGl0IGV4cGxpY2l0bHkuDQo=

