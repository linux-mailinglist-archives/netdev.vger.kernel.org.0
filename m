Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4254A404818
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 11:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhIIJzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 05:55:09 -0400
Received: from mout.gmx.net ([212.227.17.21]:59647 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233181AbhIIJzH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 05:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631181225;
        bh=TyajP3TQHWCSO51l7ROYmJ+J3jJ3UVz8VcrVa8pQORg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=MqqPi4cXk5xuygz7OEaR1/HLm5vz0ohwCR/hbiteIwo4vvt9pgmG/YnKPgCbDQQdA
         KrFmGjRRTD8Y8VE3hjzt3AlG8fBQzkk0SEbXf8Az3wkfbzIJhWXvbg36VPqGjQslko
         tVvLuKN1+o7nxeEarqoAP0IuVbka/zn7m+SdAvRo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([46.223.119.124]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N79u8-1n0ZaX0DeO-017Uwp; Thu, 09
 Sep 2021 11:53:45 +0200
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     olteanv@gmail.com
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Date:   Thu,  9 Sep 2021 11:53:21 +0200
Message-Id: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:hEctqTOBs7LoknwP+wrUDjHT7rIXAsnPX8ZNsFHTOJ0x7gOnybW
 wVjTrlD9IngF3bOVbU4O3ZKCWCG0QELQDfon0O0lBqpSfIHegVhy/Yskt3FTGRsPKaD8Qck
 Oqwmod6kD/wdM6v+H1SQKuzDu7jkryUV2ByyAXPvJQswDy1TdrtgC5pfPosOhGbLdF45nRT
 CxEDolLgXLnMhA9IPejMg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bCXA2YNG7G8=:kikj125z90xM7GquRStpKL
 tBlgYF+Gl7pZDCFNzh+9I80ir6qDR1F6vhDVuwpnvM6URRsBP78bgCVk5S49+jvNvp8h8v7tP
 zg9kvFyUnGRYTKvDQrdtdUmHG98AfZ4DMI8tAMEJqhAC2NuulrOrbdC9Gs2WP47EDrXnlMAlV
 gQCaWaYeHYJcUYUi8T9tHZnQFOlptP2LqynvPXY5kdN7QkFXy586cEVxuARimtnFXuVFMWRUw
 hY5i3vR6WYF3bKN8FdOUWPqpoGT/Rk6tS2x3e8D9NOIn5MueGbujGJcYLTuDH6yxfugneQDOD
 BwpJ76pxVpmmNBujji9aGy2+LdLjUL9cRoui/NzF2eGJ9AYWrtsyePs0g7WO1N9r7uag7auka
 Qo0KeTW7tatYXHznnm9lEUWuT9msz5LxIjmPIBNPNGzNDrZD2+p39lpsjLaNx7s+RMAEdwTzG
 Aw7sGTmR6Q3FvgfFammvNMq1pqI7Njj92C++s0MnOoTi1FIyaaugvdFURFvtYm9g7P5bm8gi9
 h924NJINgJHnOzjZStQY19E0y4tvTSEB+PimMFmyEwnb3NJTYePNQlOlB/7BsFIA8lLEfR0Td
 JCKKXnvSI880JWtUTPeamD2QXFzjX4oy0jYYei3ulchlW54nKWaK1vHpIU9VUjqXXU4/BN3fY
 beq5lpWex+XImcYvh+13UpCHTUNfTxCyj9lZWMgowsNlrlt1tQyFzYc0VN8nx6gKkbC/uPJOv
 2uoDQs9ZEWo6jD9SCdnFEvtlStWk+ky+ZkICZv2M5WdbGaUPMf3z6i1W2nASLKedzUacZjxbz
 7BeWPv28WPTOV8CpBR63zI9e7l8a91EnT7NLp+rkCDpeRXs/r2vH2Y6K43RYshFKQN524DpOJ
 EV9L+kY2IFq1JiIUp8Sx1x693f+/ccLQpzUwWAXV2aKSwo/oSEmTTmSpCPN0WZ1mxZk7JQT5K
 gpVfSKvlERnevbfFEZC78fesU89Qe35NoNoQHmoEDt4D++S125UA/4j9pvKFdbxJKgFnhF2xZ
 L1myNGN/492+RH4ZZPpJnv8H74fZoaJSU0URejN+gkJi0dkTgDwGrLkhF+5+uQsZBgHIpRPJX
 odHftVWAU0QTsc=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBwYXRjaCBzZXJpZXMgZml4ZXMgYSBzeXN0ZW0gaGFuZyBJIGdvdCBlYWNoIHRpbWUgaSB0
cmllZCB0byBzaHV0ZG93bgpvciByZWJvb3QgYSBzeXN0ZW0gdGhhdCB1c2VzIGEgS1NaOTg5NyBh
cyBhIERTQSBzd2l0Y2ggd2l0aCBhIGJyb2FkY29tCkdFTkVUIG5ldHdvcmsgZGV2aWNlIGFzIHRo
ZSBEU0EgbWFzdGVyIGRldmljZS4gQXQgdGhlIHRpbWUgdGhlIHN5c3RlbSBoYW5ncwp0aGUgbWVz
c2FnZSAidW5yZWdpc3Rlcl9uZXRkZXZpY2U6IHdhaXRpbmcgZm9yIGV0aDAgdG8gYmVjb21lIGZy
ZWUuIFVzYWdlCmNvdW50ID0gMi4iIGlzIGR1bXBlZCBwZXJpb2RpY2FsbHkgdG8gdGhlIGNvbnNv
bGUuCgpBZnRlciBzb21lIGludmVzdGlnYXRpb24gSSBmb3VuZCB0aGUgcmVhc29uIHRvIGJlIHVu
cmVsZWFzZWQgcmVmZXJlbmNlcyB0bwp0aGUgbWFzdGVyIGRldmljZSB3aGljaCBhcmUgc3RpbGwg
aGVsZCBieSB0aGUgc2xhdmUgZGV2aWNlcyBhdCB0aGUgdGltZSB0aGUKc3lzdGVtIGlzIHNodXQg
ZG93biAoSSBoYXZlIHR3byBzbGF2ZSBkZXZpY2VzIGluIHVzZSkuCgpXaGlsZSB0aGVzZSByZWZl
cmVuY2VzIGFyZSBzdXBwb3NlZCB0byBiZSByZWxlYXNlZCBpbiBrc3pfc3dpdGNoX3JlbW92ZSgp
CnRoaXMgZnVuY3Rpb24gbmV2ZXIgZ2V0cyB0aGUgY2hhbmNlIHRvIGJlIGNhbGxlZCBkdWUgdG8g
dGhlIHN5c3RlbSBoYW5nIGF0CnRoZSBtYXN0ZXIgZGV2aWNlIGRlcmVnaXN0cmF0aW9uIHdoaWNo
IGhhcHBlbnMgYmVmb3JlIGtzel9zd2l0Y2hfcmVtb3ZlKCkKaXMgY2FsbGVkLgoKVGhlIGZpeCBp
cyB0byBtYWtlIHN1cmUgdGhhdCB0aGUgbWFzdGVyIGRldmljZSByZWZlcmVuY2VzIGFyZSBhbHJl
YWR5CnJlbGVhc2VkIHdoZW4gdGhlIGRldmljZSBpcyB1bnJlZ2lzdGVyZWQuIEZvciB0aGlzIHJl
YXNvbiBQQVRDSDEgcHJvdmlkZXMKYSBuZXcgZnVuY3Rpb24gZHNhX3RyZWVfc2h1dGRvd24oKSB0
aGF0IGNhbiBiZSBjYWxsZWQgYnkgRFNBIGRyaXZlcnMgdG8KdW50ZWFyIHRoZSBEU0Egc3dpdGNo
IGF0IHNodXRkb3duLiBQQVRDSDIgdXNlcyB0aGlzIGZ1bmN0aW9uIGluIGEgbmV3CmhlbHBlciBm
dW5jdGlvbiBmb3IgS1NaIHN3aXRjaGVzIHRvIHByb3Blcmx5IHNodXRkb3duIHRoZSBLU1ogc3dp
dGNoLgpQQVRDSCAzIHVzZXMgdGhlIG5ldyBoZWxwZXIgZnVuY3Rpb24gaW4gdGhlIEtTWjk0Nzcg
c2h1dGRvd24gaGFuZGxlci4KClRoZXNlcyBwYXRjaGVzIGhhdmUgYmVlbiB0ZXN0ZWQgb24gYSBS
YXNwYmVycnkgUEkgNS4xMCBrZXJuZWwgd2l0aCBhCktTWjk4OTcuIFRoZSBwYXRjaGVzIGhhdmUg
YmVlbiBhZGp1c3RlZCB0byBhcHBseSBhZ2FpbnN0IG5ldC1uZXh0IGFuZCBhcmUKY29tcGlsZSB0
ZXN0ZWQgd2l0aCBuZXh0LW5leHQuCgpMaW5vIFNhbmZpbGlwcG8gKDMpOgogIG5ldDogZHNhOiBp
bnRyb2R1Y2UgZnVuY3Rpb24gZHNhX3RyZWVfc2h1dGRvd24oKQogIG5ldDogZHNhOiBtaWNyb2No
aXA6IHByb3ZpZGUgdGhlIGZ1bmN0aW9uIGtzel9zd2l0Y2hfc2h1dGRvd24oKQogIG5ldDogZHNh
OiBtaWNyb2NoaXA6IHRlYXIgZG93biBEU0EgdHJlZSBhdCBzeXN0ZW0gc2h1dGRvd24KCiBkcml2
ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzcuYyAgICB8IDEyICsrKysrKysrKysrLQogZHJp
dmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMgfCAxMyArKysrKysrKysrKysrCiBk
cml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uaCB8ICAxICsKIGluY2x1ZGUvbmV0
L2RzYS5oICAgICAgICAgICAgICAgICAgICAgIHwgIDEgKwogbmV0L2RzYS9kc2EyLmMgICAgICAg
ICAgICAgICAgICAgICAgICAgfCAgOCArKysrKysrKwogNSBmaWxlcyBjaGFuZ2VkLCAzNCBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgoKYmFzZS1jb21taXQ6IDYyNmJmOTFhMjkyZTIwMzVh
ZjViOWQ5Y2NlMzVjNWMxMzhkZmUwNmQKLS0gCjIuMzMuMAoK
