Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CCD453BA6
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 22:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhKPVbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 16:31:35 -0500
Received: from mout.gmx.net ([212.227.17.20]:56845 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229556AbhKPVbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 16:31:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637098110;
        bh=JjihNC2AuMle56rp/XZwqMFFyfo8WjXDke4I/IpBhek=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=f+7IyAwqkBrue5PnhRySoRtMi567QBNukMC7C1UebYBMsoU95zkB4nclrrGy8HZO0
         Sxk6LxfvORM58mYSgzKOtYMModRSLuD2rwE0XGI7EEjZAQmYJmRK4Q1k6DcQHph4XR
         fh9a4HAS1FkHy8h4DhyLbmVmvmP6vvlV4ZYSeEUY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.fritz.box ([62.216.209.243]) by mail.gmx.net
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MnJlc-1mLhnN49dk-00jMJU; Tue, 16 Nov 2021 22:28:30 +0100
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC v2] mac80211: minstrel_ht: do not set RTS/CTS flag for fallback rates
Date:   Tue, 16 Nov 2021 22:28:28 +0100
Message-Id: <20211116212828.27613-1-ps.report@gmx.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:i0D7gr7L/ZCMLUuc1pnVQU1UzGNyCFGILH/EzO2yW/WcxBLuIaT
 2lPH/XkCH28ZPBg4U476PBfzrcqqOcH8iFvH15KRTtNwM+EF0eZVYlYIDGfOO4df8Hk/NEK
 6OkqaIP4o59tIlYD61SK1/QSRLgIZo5EuY9SLSBAhOwg1Cxs4R/2L8rzoq6Ti7e1Q3Mhn9s
 Oe7e743WZmFK5/NKBquBQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vfR6jKaB1wQ=:EZxKxdYDzgle0aw8IefyA7
 iLYQK0VPBaz7ECtaTRipoJ63ecxY1wPjD32uYl6mEsK4EvRN7iVE4F0u/JLqK4VUr+6VXa2hL
 Bu5ql38/LjFPpj4ivg22SjmmKONYViNoHLKMfNaT3O6oMrqarMv2PvXpUthQpTOno8yheWKgp
 CHlZ/mfEtdUBHpzdR58C45XwprZRf4+sSF3mV+kM8/TCXcDFb5cqWnlEVnKDuqmli7Jp2Skl6
 aa1pmqa+gZsoujubqvbBlswTUJykWToSgLU7G0zvhaA8QogsZmkbDw3cuFbwRmZUmWz4U4l/Y
 v7ltsUPmM6hOhUELtKkz+Xkpv0pNwi4xsiCNLF1+yS66Kd36uH6amyUlJk8HOGuj5fO6TYqMQ
 CWVrfgCu/h2113x9mztwWn90iQT+6muLotIkF39w0q4A53C7PuvigOS0WoUvCTYWM63WbidQG
 9hbu4u9if92Y0bP7qChjS7q8E8JC3jKpZWXR0TenMnBkqUJBWCp/dUcAL+pdR4UGNG3Mhy3bL
 SIO/wnOUT3tqq3s1IjRBOy8SqDiCwNQu9YMCxYKfA2W34FSgQcGZA3Svr0NxZC0IO5Kd8u525
 Vg6YZCzbqdYeVX3VdwT7goT3x4ghLhXhcxw4CwFiTakNIobOOIn6Ausqx2ow0BI8nOsv7JxeT
 Q1fH9Zivd+ZykiOm6+W/y1tkzh2gIx0qVmkK7Wu1pewYKPtw4um2jgWdTnn4AzsLjFqs2JaTa
 pg8nqv1TrMOX9cMC69n4hbUeMbVim1V8bvr62agCRculPkJeAFdVIhknVL2FbFiMBVzZbghdH
 pHCFID5g697gQAtwVZffVGLggYNaQB64r3tTqJpC91eB5lwafTySKNSjURqtmh2gOU68cOtqd
 uyfLy5rxjbFNwJNvIys/tCjFGQUTFsYXq4VA5yFAVzIh6Dn4sOyKv1l8LPWarPDcG6yQPL+Id
 n8sm0vTc54iXMaalAujnIS3aH+IuoRD/zANLBqzeA0tRgQ8Q01EQOdrWNpGhtrlQcu0QO1De3
 a4DB3e+FkFQoQ/SvWApdx71H6GmCKYtLQEhQDKzOney2ZQblw3s40zNGx/1tXG9jkHVBCunzX
 ueEOki3YG0lu5A=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVzcGl0ZSB0aGUgJ1JUUyB0aHI6b2ZmJyBzZXR0aW5nIGEgd2lyZXNoYXJrIHRyYWNlIG9mIElC
U1MKdHJhZmZpYyB3aXRoIEhUNDAgbW9kZSBlbmFibGVkIGJldHdlZW4gdHdvIGF0aDlrIGNhcmRz
IHJldmVhbGVkCnNvbWUgUlRTL0NUUyB0cmFmZmljLgoKRGVidWcgYW5kIGNvZGUgYW5hbHlzaXMg
c2hvd2VkIHRoYXQgbW9zdCBwbGFjZXMgc2V0dGluZwpJRUVFODAyMTFfVFhfUkNfVVNFX1JUU19D
VFMgcmVzcGVjdCB0aGUgUlRTIHN0cmF0ZWd5IGJ5CmV2YWx1YXRpbmcgcnRzX3RocmVzaG9sZCwg
ZS5nLiBuZXQvbWFjODAyMTEvdHguYzoKCiA2OTggICAgICAgICAvKiBzZXQgdXAgUlRTIHByb3Rl
Y3Rpb24gaWYgZGVzaXJlZCAqLwogNjk5ICAgICAgICAgaWYgKGxlbiA+IHR4LT5sb2NhbC0+aHcu
d2lwaHktPnJ0c190aHJlc2hvbGQpIHsKIDcwMCAgICAgICAgICAgICAgICAgdHhyYy5ydHMgPSB0
cnVlOwogNzAxICAgICAgICAgfQogNzAyCiA3MDMgICAgICAgICBpbmZvLT5jb250cm9sLnVzZV9y
dHMgPSB0eHJjLnJ0czsKCm9yIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay94bWl0LmMK
CjEyMzggICAgICAgICAgICAgICAgIC8qCjEyMzkgICAgICAgICAgICAgICAgICAqIEhhbmRsZSBS
VFMgdGhyZXNob2xkIGZvciB1bmFnZ3JlZ2F0ZWQgSFQgZnJhbWVzLgoxMjQwICAgICAgICAgICAg
ICAgICAgKi8KMTI0MSAgICAgICAgICAgICAgICAgaWYgKGJmX2lzYW1wZHUoYmYpICYmICFiZl9p
c2FnZ3IoYmYpICYmCjEyNDIgICAgICAgICAgICAgICAgICAgICAocmF0ZXNbaV0uZmxhZ3MgJiBJ
RUVFODAyMTFfVFhfUkNfTUNTKSAmJgoxMjQzICAgICAgICAgICAgICAgICAgICAgdW5saWtlbHko
cnRzX3RocmVzaCAhPSAodTMyKSAtMSkpIHsKMTI0NCAgICAgICAgICAgICAgICAgICAgICAgICBp
ZiAoIXJ0c190aHJlc2ggfHwgKGxlbiA+IHJ0c190aHJlc2gpKQoxMjQ1ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgcnRzID0gdHJ1ZTsKMTI0NiAgICAgICAgICAgICAgICAgfQoKVGhl
IG9ubHkgcGxhY2Ugc2V0dGluZyBJRUVFODAyMTFfVFhfUkNfVVNFX1JUU19DVFMgdW5jb25kaXRp
b25hbGx5CndhcyBmb3VuZCBpbiBuZXQvbWFjODAyMTEvcmM4MDIxMV9taW5zdHJlbF9odC5jLgoK
QXMgdGhlIHVzZV9ydHMgdmFsdWUgaXMgb25seSBjYWxjdWxhdGVkIGFmdGVyIGhpdHRpbmcgdGhl
IG1pbnN0cmVsX2h0IGNvZGUKcHJlZmVycmUgdG8gbm90IHNldCBJRUVFODAyMTFfVFhfUkNfVVNF
X1JUU19DVFMgKGFuZCBvdmVycnVsaW5nIHRoZQpSVFMgdGhyZXNob2xkIHNldHRpbmcpIGZvciB0
aGUgZmFsbGJhY2sgcmF0ZXMgY2FzZS4KClNpZ25lZC1vZmYtYnk6IFBldGVyIFNlaWRlcmVyIDxw
cy5yZXBvcnRAZ214Lm5ldD4KLS0tCkNoYW5nZXMgdjEgLT4gdjI6CiAgLSBjaGFuZ2UgZnJvbSAn
cmVzcGVjdCBSVFMgdGhyZXNob2xkIHNldHRpbmcnIHRvICdkbyBub3Qgc2V0IFJUUy9DVFMKICAg
IGZsYWcgZm9yIGZhbGxiYWNrIHJhdGVzJyAoc2VlIGNvbW1pdCBtZXNzYWdlIGZvciByZWFzb25p
bmcpCi0tLQogbmV0L21hYzgwMjExL3JjODAyMTFfbWluc3RyZWxfaHQuYyB8IDYgKystLS0tCiAx
IGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL25ldC9tYWM4MDIxMS9yYzgwMjExX21pbnN0cmVsX2h0LmMgYi9uZXQvbWFjODAyMTEvcmM4
MDIxMV9taW5zdHJlbF9odC5jCmluZGV4IDcyYjQ0ZDRjNDJkMC4uZjE1MWFjYmU3YmY1IDEwMDY0
NAotLS0gYS9uZXQvbWFjODAyMTEvcmM4MDIxMV9taW5zdHJlbF9odC5jCisrKyBiL25ldC9tYWM4
MDIxMS9yYzgwMjExX21pbnN0cmVsX2h0LmMKQEAgLTEzNTUsMTEgKzEzNTUsOSBAQCBtaW5zdHJl
bF9odF9zZXRfcmF0ZShzdHJ1Y3QgbWluc3RyZWxfcHJpdiAqbXAsIHN0cnVjdCBtaW5zdHJlbF9o
dF9zdGEgKm1pLAogCiAJLyogZW5hYmxlIFJUUy9DVFMgaWYgbmVlZGVkOgogCSAqICAtIGlmIHN0
YXRpb24gaXMgaW4gZHluYW1pYyBTTVBTIChhbmQgc3RyZWFtcyA+IDEpCi0JICogIC0gZm9yIGZh
bGxiYWNrIHJhdGVzLCB0byBpbmNyZWFzZSBjaGFuY2VzIG9mIGdldHRpbmcgdGhyb3VnaAogCSAq
LwotCWlmIChvZmZzZXQgPiAwIHx8Ci0JICAgIChtaS0+c3RhLT5zbXBzX21vZGUgPT0gSUVFRTgw
MjExX1NNUFNfRFlOQU1JQyAmJgotCSAgICAgZ3JvdXAtPnN0cmVhbXMgPiAxKSkgeworCWlmICht
aS0+c3RhLT5zbXBzX21vZGUgPT0gSUVFRTgwMjExX1NNUFNfRFlOQU1JQyAmJgorCSAgICBncm91
cC0+c3RyZWFtcyA+IDEpIHsKIAkJcmF0ZXRibC0+cmF0ZVtvZmZzZXRdLmNvdW50ID0gcmF0ZXRi
bC0+cmF0ZVtvZmZzZXRdLmNvdW50X3J0czsKIAkJZmxhZ3MgfD0gSUVFRTgwMjExX1RYX1JDX1VT
RV9SVFNfQ1RTOwogCX0KLS0gCjIuMzMuMQoK
