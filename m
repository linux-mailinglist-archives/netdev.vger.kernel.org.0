Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4E3F8967
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 08:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfKLHM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 02:12:27 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:56760 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725781AbfKLHM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 02:12:27 -0500
X-UUID: c19496428a674e58810dc17e98c68a90-20191112
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=Z8nkDd87nqB6TMe3KppZYI70npGkzQs4p3QaevqC/mg=;
        b=KNuo0RNe5yA1qiUFxfuyiE79LWSXisMrO83y4l0JmYwAGsx00rVlI31C/vjPMWzqZ6WVu35Amq0I2NGl32a7dl5q+ze1QAki53Z8QKSSJMYFYin++ZeFM87gTkl8bkQi4o0e66fIp+HKL5vd3gNsLHvQ8vSRJFvADS5TPD2K1m4=;
X-UUID: c19496428a674e58810dc17e98c68a90-20191112
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 450768700; Tue, 12 Nov 2019 15:12:22 +0800
Received: from mtkmbs05dr.mediatek.inc (172.21.101.97) by
 mtkexhb02.mediatek.inc (172.21.101.103) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 12 Nov 2019 15:12:20 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05dr.mediatek.inc (172.21.101.97) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 12 Nov 2019 15:12:20 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 12 Nov 2019 15:12:20 +0800
Message-ID: <1573542740.10348.12.camel@mtksdccf07>
Subject: Re: [PATCH net,v2 1/3] net: ethernet: mediatek: Integrate GDM/PSE
 setup operations
From:   mtk15127 <Mark-MC.Lee@mediatek.com>
To:     David Miller <davem@redhat.com>
CC:     <sean.wang@mediatek.com>, <john@phrozen.org>,
        <matthias.bgg@gmail.com>, <andrew@lunn.ch>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <opensource@vdorst.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <jakub.kicinski@netronome.com>,
        <Mark-MC.Lee@mediatek.com>
Date:   Tue, 12 Nov 2019 15:12:20 +0800
In-Reply-To: <20191111.215617.1625420574702786179.davem@redhat.com>
References: <20191111065129.30078-1-Mark-MC.Lee@mediatek.com>
         <20191111065129.30078-2-Mark-MC.Lee@mediatek.com>
         <20191111.215617.1625420574702786179.davem@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTExLTExIGF0IDIxOjU2IC0wODAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IE1hcmtMZWUgPE1hcmstTUMuTGVlQG1lZGlhdGVrLmNvbT4NCj4gRGF0ZTogTW9uLCAx
MSBOb3YgMjAxOSAxNDo1MToyNyArMDgwMA0KPiANCj4gPiArc3RhdGljIHZvaWQgbXRrX2dkbV9j
b25maWcoc3RydWN0IG10a19ldGggKmV0aCwgdTMyIGNvbmZpZykNCj4gPiArew0KPiA+ICsJaW50
IGk7DQo+ID4gKw0KPiA+ICsJZm9yIChpID0gMDsgaSA8IE1US19NQUNfQ09VTlQ7IGkrKykgew0K
PiA+ICsJCXUzMiB2YWwgPSBtdGtfcjMyKGV0aCwgTVRLX0dETUFfRldEX0NGRyhpKSk7DQo+ID4g
Kw0KPiA+ICsJCS8qIGRlZmF1bHQgc2V0dXAgdGhlIGZvcndhcmQgcG9ydCB0byBzZW5kIGZyYW1l
IHRvIFBETUEgKi8NCj4gPiArCQl2YWwgJj0gfjB4ZmZmZjsNCj4gPiArDQo+ID4gKwkJLyogRW5h
YmxlIFJYIGNoZWNrc3VtICovDQo+ID4gKwkJdmFsIHw9IE1US19HRE1BX0lDU19FTiB8IE1US19H
RE1BX1RDU19FTiB8IE1US19HRE1BX1VDU19FTjsNCj4gPiArDQo+ID4gKwkJdmFsIHw9IGNvbmZp
ZzsNCj4gPiArDQo+ID4gKwkJbXRrX3czMihldGgsIHZhbCwgTVRLX0dETUFfRldEX0NGRyhpKSk7
DQo+ID4gKwl9DQo+ID4gKwkvKlJlc2V0IGFuZCBlbmFibGUgUFNFKi8NCj4gDQo+IFBsZWFzZSBw
dXQgc3BhY2VzIGJlZm9yZSBhbmQgYWZ0ZXIgdGhlIGNvbW1lbnQgc2VudGVuY2UsIGxpa2U6DQo+
IA0KPiAJLyogUmVzZXQgYW5kIGVuYWJsZSBQU0UgKi8NCj4gDQpUaGFua3MgZm9yIHRoZSByZW1p
bmRlciwgd2lsbCBjb3JyZWN0IGl0IGluIHRoZSBuZXh0IHBhdGNoLg0KDQoNCg==

