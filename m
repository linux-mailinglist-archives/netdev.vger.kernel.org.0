Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C83453C20
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 23:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhKPWK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 17:10:28 -0500
Received: from mout.gmx.net ([212.227.15.19]:42335 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231370AbhKPWK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 17:10:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637100441;
        bh=RIc6Wv7HzTnmQXNy6Xs25l5nQkvi+3gn5IR+o2WfY1Y=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=TL/uTuflJY0VuLaGVXRKwC5fa859R50Bahviv0zgmsU51KHIg5K/PuBAebZh02Fi1
         jw/fh+bwodN6Gyc3EV8B1s5o7e4tm4x4HYj7iHM/rqKIvRM863s6Y6/njdYnlOrGOM
         /uc+hqa3mqBQDfWD7H+3Q5gLH9TeB7QygC7Dh00A=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.fritz.box ([62.216.209.243]) by mail.gmx.net
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1M8QS2-1miit72sU4-004VZG; Tue, 16 Nov 2021 23:07:21 +0100
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     ath9k-devel@qca.qualcomm.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v1] ath9k: fix intr_txqs setting
Date:   Tue, 16 Nov 2021 23:07:20 +0100
Message-Id: <20211116220720.30145-1-ps.report@gmx.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:Box3XGQPFl2JGGKJGy26znZeVn1xoVH/6uzAf3I+fQL/gCYWRzH
 H/YJqr6N3npf3FwTvpblKrwvyCbIRuA5PrciFKR2/lgo85nS8o+9BDD8j6ae3mHXFKIhTcR
 chInRKKxcXZPALlLKcP5mGXki+a72LnCsg0TzbU+518p4MjsHU47rlsP1ydJeo0E64sTNmQ
 jzCWg3KfyQZGHg/f9Akiw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ah2Lq1R+nbg=:6OZywLbYMDRAm9fk4keKvW
 1z8ZYMX8nskJzE+1FBPXE0bKJl/+CVQUBzUVpdWlpqKm9MJEHwoCeDMmP2gMZKcNGF4r95049
 zzM3RIqGw2y+ijYtRmgvJQRb/rvYWCg7lDpKufLLCEeMdvwV9+UHvjLq6nzUmv3JzxxahrZvz
 0Dk3sUk4uxd6ZrkH2Urz6fzfuJA3FSDakp0tDhFPBAmJmHmCP3QkRGmiQ2P/ItXLMLsKqTz3G
 F1lrX0eQJk/L6r1viIa6wXLCVF36/HO3KVH59J4BRda5MQcrgeZBJW0ZC/NzVCm9vC8Rit1ZJ
 k0rWxlpom3RkBloWT17kyJcRVnxzNkGTXc1f8qG0QsESs8WdyB9B6uxShxbDPt5FO20CKeAYR
 Nahix/jHET9L+DgWLOOQp6kJxm8i2jg50nV26m/yrlBsPPis+Y46OOdJ3LwqN4LxW1bLL13WO
 VL26RFAf9w+TFyYz5z1lQyOUIhopNMz3KFoThYJCHNV29soY1BBLmAZ4k4w/DdBiv5AVlNG5G
 GQpCH7e485ojoDDk95VgXgSX/sV4xL5UoQo0sfPLx/LH52sBq6dPxSvnIwvNDq8CGIoM23wiF
 P4DJfPcVxOLedZJ+SQDo9ptgSzTwRyHf8B2/X4/xwFPXJqtpBZkLMc9p45KuyQ1BS4VjUkWMB
 1VNNOE8GCDYfLP9/WbNxVIGEUd9TgjdvZmM2x8z3zF6grBSwi32JFBFYV/0+0UMEodpougoQm
 s1g8cYfHWV12oMnVLkMe8QjnPRil7h9J4uTHP7EQM4DBkm368YddvB4/pYGaD1ZeMviod/6TP
 jhUllgiZi3252XayAHFYd9ofRst2tV3If+0DFA+aYTYvGahNsCk5w66U2P4j3Dg4XiwE5u+AO
 TF56bx4a1gesUM4/4zCr9oUCdsDiv91jKIYLtG5/F26O+E4s3ZaXk1HYZJaWVFIfQ7eXVHqmD
 XzAeyFnAiSDD/U+sbqJTzkcATYS7ex7Uf70pKbaw1XrxqR8U1SZ/B4xUQnMgFSd+/V8MHZv4H
 bPdxMmo/ii+n9T65iMVFYqVTUe+3u2v7pj7nblwbj1Iv495pk2zaNhhwk783SRUj4Bal6XVAM
 uXWqYupX6heC7c=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIHN0cnVjdCBhdGhfaHcgbWVtYmVyIGludHJfdHhxcyBpcyBuZXZlciByZXNldC9hc3NpZ25l
ZCBvdXRzaWRlCm9mIGF0aDlrX2h3X2luaXRfcXVldWVzKCkgYW5kIHdpdGggdGhlIHVzZWQgYml0
d2lzZS1vciBpbiB0aGUgaW50ZXJydXB0CmhhbmRsaW5nIGFyOTAwMl9od19nZXRfaXNyKCkgYWNj
dW11bGF0ZXMgYWxsIGV2ZXIgc2V0IGludGVycnVwdCBmbGFncy4KCkZpeCB0aGlzIGJ5IHVzaW5n
IGEgcHVyZSBhc3NpZ24gaW5zdGVhZCBvZiBiaXR3aXNlLW9yIGZvciB0aGUKZmlyc3QgbGluZSAo
bm90ZTogaW50cl90eHFzIGlzIG9ubHkgZXZhbHVhdGVkIGluIGNhc2UgQVRIOUtfSU5UX1RYIGJp
dAppcyBzZXQpLgoKU2lnbmVkLW9mZi1ieTogUGV0ZXIgU2VpZGVyZXIgPHBzLnJlcG9ydEBnbXgu
bmV0PgotLS0KTm90ZToKICAtIHRoZSBhdGg1a19odyBtZW1iZXIgYWhfdHhxX2lzcl90eG9rX2Fs
bCBpbiBhdGg1a19od19nZXRfaXNyKCkKICAgIChzZWUgZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRo
L2F0aDVrL2RtYS5jKSBzdWZmZXJlcyBmcm9tIHRoZQogICAgc2FtZSBwcm9ibGVtIGFuZCBjYW4g
YmUgZml4ZWQgYnkgYW4gYXNzaWdubWVudCB0byB6ZXJvIGJlZm9yZQogICAgZnVyaHRlciB1c2Fn
ZSAoYnV0IEkgbGFjayBzdWl0YWJsZSBoYXJkd2FyZSBmb3IgdGVzdGluZykKLS0tCiBkcml2ZXJz
L25ldC93aXJlbGVzcy9hdGgvYXRoOWsvYXI5MDAyX21hYy5jIHwgMiArLQogMSBmaWxlIGNoYW5n
ZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2FyOTAwMl9tYWMuYyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L2F0aC9hdGg5ay9hcjkwMDJfbWFjLmMKaW5kZXggY2U5YTBhNTM3NzFlLi5mYmE1YTg0N2MzYmIg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay9hcjkwMDJfbWFjLmMK
KysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL2FyOTAwMl9tYWMuYwpAQCAtMTIw
LDcgKzEyMCw3IEBAIHN0YXRpYyBib29sIGFyOTAwMl9od19nZXRfaXNyKHN0cnVjdCBhdGhfaHcg
KmFoLCBlbnVtIGF0aDlrX2ludCAqbWFza2VkLAogCQkJCQkgQVJfSVNSX1RYRU9MKTsKIAkJCX0K
IAotCQkJYWgtPmludHJfdHhxcyB8PSBNUyhzMF9zLCBBUl9JU1JfUzBfUUNVX1RYT0spOworCQkJ
YWgtPmludHJfdHhxcyA9IE1TKHMwX3MsIEFSX0lTUl9TMF9RQ1VfVFhPSyk7CiAJCQlhaC0+aW50
cl90eHFzIHw9IE1TKHMwX3MsIEFSX0lTUl9TMF9RQ1VfVFhERVNDKTsKIAkJCWFoLT5pbnRyX3R4
cXMgfD0gTVMoczFfcywgQVJfSVNSX1MxX1FDVV9UWEVSUik7CiAJCQlhaC0+aW50cl90eHFzIHw9
IE1TKHMxX3MsIEFSX0lTUl9TMV9RQ1VfVFhFT0wpOwotLSAKMi4zMy4xCgo=
