Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EB63D1A92
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 01:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhGUXQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 19:16:36 -0400
Received: from mout.gmx.net ([212.227.17.22]:38379 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229632AbhGUXQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 19:16:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626911827;
        bh=TUgnLmRkp0LP6RB5mhH4ikN8orhgOMwAhKdeGxyPRqY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=bi83QHyi0IJ2+l66HemlLBVXJM5aLtPOEQv/zv7NCSlObcVtj+oDxTX3xZoxFrLiB
         wl/vjxVysaKtdgvult4n7yKy2rdD8sY0dwVS/hjEPh9fL2vnze0QuvkvcF36U2DNJ7
         p8w3XKyEES19NU6ZxPAkw0KWYlyKfoa3F9hT3oEU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([149.172.237.67]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MGQnF-1lsJZv3EPF-00GtgN; Wed, 21
 Jul 2021 23:56:50 +0200
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     woojung.huh@microchip.com, olteanv@gmail.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH v2 0/2] Fixes for KSZ DSA switch
Date:   Wed, 21 Jul 2021 23:56:40 +0200
Message-Id: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:1rUgA+nhdaunIILTNb6XeAJBKlhljr/xcF3daK0td9u6FueZkqn
 jOMUVdDyW2LmNYeMb7lP8BOxAyjBBOI9Ux0a+WbczXs1JVT8qdRB05qxpGvlg9hInWqko+C
 7/tk9dYSOIfDIicIsRJxBztvUgQgwsi6OPIQffzXySoiSqUw+6LYN9aHkimBvPH4049CIS1
 nXwu9W8m/n663cXtc92Eg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XqdvfWyP0/8=:V4ZM4H4KaAIb/krYlbVcs6
 QiLeHHv39gFQDRvIMtjB9MoGUtXGLmJL8Maa30LsgAZK0EN5Ytp0t6XnzVVdACGkxqTp/EUSE
 aRGpHcZsd7djwpx1HFbPmUncG+slT36qDps7QP3hbBugJCRXn5hctLgA7i1m1GRRvXVeHqthF
 JQ2btQljEzEFbXMcofqZvYbvHC4xPLzo2RKmHrson091ienoNDDja6otFdZYpJkE8d9kdSqtI
 2YGG7bHvfLiEK1G/0+3Evurfk9sQp3Wsuz29QZXS90fb+qAdDSqsTYgisb3JS+H8y1r4P6+to
 mAnJSSuAQStr7e1ZTWBirx5eU0RgaAKU4KBX8gTf8Pq/SXkRgsas4dqOcARYfpLZzS9AQLMS+
 tzFErSwrUeOGaq+SpL+cIZYv/AOo4gmg1FYXU+kYbRwl028MRJ+lHi/KelYl4VNlUUcw19Pgv
 ByjSDjJDrHsCBGNCKruefBn4771YNcbpvj9PjJ0eNtxDZWgm6oBYqsgS/oOzRzcufLTETQia4
 jTmRW/gMzsSfmi5KnD+UVhRO+FUJNU2ljvv9TiQcl4Fx/QaL0BN3fxPNg4fWKoU6wZd8JqWz1
 GGLv9k054AToUQ6sIpOvULLP2YIZknD+4gkHLZouylQRoviUEBtR0BfDmDo4WuXy8h+N/Jy1g
 EGqHujhtx2daUgGvJ3YsBrGaWkO+WGw6gHdNpROH3Bg9VRBxLyH0RzQtuYFO2fyfSDMEVMdM2
 9QBTYTcEUtPaR4DCfXZKzq0dSISNVL5UvPC6qizRGJ4K6AJl7K6TEj6IjVRJnJMGnzkRwzpfs
 Qmoxq2GXyGoFUaxaPo04eGDr6rxlbeuHPCEnbcogFlMMqgpK53XlTWt+gxMxuI8QYOeKlenFI
 Nyy/8693BILUjJH1lYGi2Q3h97Cr8Tc2Dcu7LaIPCN9qBWxM+lsKCO+0zEhWGykR3QunEolKK
 DUI6pvqmPavp1IGmwo4hjEIoP8z8dI7Ef++X5YqT3Vb0pxn2celeOokmapJ77jI3TtagGR3wp
 Aoyf9cV6XvI2h3MA6f58g526WolpzP4YdiGLOXZgFZbXJIJpttrjlpb6YJs6FpkqNGVkuIAqw
 RkdGMDJ1+WFV5ZW+Q6y1nzNhWnVgL6oVKoEqU2qbMU9NXn9d6/ncPduwg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlc2UgcGF0Y2hlcyBmaXggaXNzdWVzIEkgZW5jb3VudGVyZWQgd2hpbGUgdXNpbmcgYSBLU1o5
ODk3IGFzIGEgRFNBCnN3aXRjaCB3aXRoIGEgYnJvYWRjb20gR0VORVQgbmV0d29yayBkZXZpY2Ug
YXMgdGhlIERTQSBtYXN0ZXIgZGV2aWNlLgoKUEFUQ0ggMSBmaXhlcyBhbiBpbnZhbGlkIGFjY2Vz
cyB0byBhbiBTS0IgaW4gY2FzZSBpdCBpcyBzY2F0dGVyZWQuClBBVENIIDIgZml4ZXMgaW5jb3Jy
ZWN0IGhhcmR3YXJlIGNoZWNrc3VtIGNhbGN1bGF0aW9uIGNhdXNlZCBieSB0aGUgRFNBCnRhZy4K
CkNoYW5nZXMgaW4gdjI6Ci0gaW5zdGVhZCBvZiBsaW5lYXJpemluZyB0aGUgU0tCcyBvbmx5IGZv
ciBLU1ogc3dpdGNoZXMgZW5zdXJlIGxpbmVhcml6ZWQKICBTS0JzIGZvciBhbGwgdGFpbCB0YWdn
ZXJzIGJ5IGNsZWFyaW5nIHRoZSBmZWF0dXJlIGZsYWdzIE5FVElGX0ZfSFdfU0cgYW5kCiAgTkVU
SUZfRl9GUkFHTElTVCAoc3VnZ2VzdGVkIGJ5IFZsYWRpbWlyIE9sdGVhbikKClRoZSBwYXRjaGVz
IGhhdmUgYmVlbiB0ZXN0ZWQgd2l0aCBhIEtTWjk4OTcgYW5kIGFwcGx5IGFnYWluc3QgbmV0LW5l
eHQuCgpMaW5vIFNhbmZpbGlwcG8gKDIpOgogIG5ldDogZHNhOiBlbnN1cmUgbGluZWFyaXplZCBT
S0JzIGluIGNhc2Ugb2YgdGFpbCB0YWdnZXJzCiAgbmV0OiBkc2E6IHRhZ19rc3o6IGRvbnQgbGV0
IHRoZSBoYXJkd2FyZSBwcm9jZXNzIHRoZSBsYXllciA0IGNoZWNrc3VtCgogbmV0L2RzYS9zbGF2
ZS5jICAgfCAxNCArKysrKysrKystLS0tLQogbmV0L2RzYS90YWdfa3N6LmMgfCAgOSArKysrKysr
KysKIDIgZmlsZXMgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCgpi
YXNlLWNvbW1pdDogNTRjYjQzMTk5ZTE0YzExODFkZGNkNGEzNzgyZjFmN2ViNTZiZGFiOAotLSAK
Mi4zMi4wCgo=
