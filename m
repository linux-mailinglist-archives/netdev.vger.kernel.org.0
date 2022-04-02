Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183964F046C
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 17:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355423AbiDBPcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 11:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiDBPcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 11:32:19 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F38123BC1;
        Sat,  2 Apr 2022 08:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1648913416;
        bh=lZSOBxnkYshkouLS0XGvOyWTUsSm5nmlSADx/QK6Sfw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=kVQc5hIpXWsPIBo4CqyEoFtkrTTHR+l8ZKsnDBawQvRMO4d4OgLfptcilNjQPRmnP
         aGj5zk6Jd8xd0un09eFMrNQpKa9YzJNTRldjakHpkqr+fCrGEx5+yoEGK4BafWBypY
         i3kG9YNc2vhwGc7jleG6KxEMx+H3hSr7dsFSS9cA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.fritz.box ([62.216.209.166]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1M6ll8-1neWn80Xq2-008JPY; Sat, 02 Apr 2022 17:30:16 +0200
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] mac80211: minstrel_ht: fill all requested rates
Date:   Sat,  2 Apr 2022 17:30:14 +0200
Message-Id: <20220402153014.31332-2-ps.report@gmx.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220402153014.31332-1-ps.report@gmx.net>
References: <20220402153014.31332-1-ps.report@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:0wr3EzeN+lXmgwruwVbHbIItUpzgHp396SesflJa0YdqyVF7t9q
 AAfaD+Bqk5Z8ghMD22ji/bpePDOkXCm5iQpJqWksXImYnUzRj3IAFShCWrAk5OvIJiWvQYV
 omYoq8j7QN2w//ZnHY94nI4eiXh194ZMZ/01En5eiderY913paxogcTgjPukBO9nqPK6iGd
 Doyvjg7XAqbkVVFsgTaTg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:dQFF1XUE+VA=:+9BjDVBnY0wpvaIt/MzbH9
 pmGlfNEofzMulJnqM4e7NunE/2BHfI4EF4+aFHgR9G6w0cdeTeOZEujNlRBfUn+aDwuyOSoZZ
 jSEfcVb+rjw779miOENlYOfJWH4c0n74Vq8eUyEoaX8ZhYkddxLQAtNsjZQKQedXJFZ/AnNvY
 vcIc0BScF7Mt99WUQ7DUXxzj39AGkyRveARAvot6Nt6U2zPCdmqR7rCsEhMzusqkb0FrxR4Xd
 knNEbGPFU/LzzkCsVtV5hnLaCYPvx4w8OLso8z7RHYqWQgpUVr35Erd5jOAYRDBgRA94GE97p
 qX4IC2VxUuOw9rSLJJ5ysCtmgqoZY/Vb7N0zaabHdpF5QqwlpEpxiddiYuvhJ2jQTTVnzIThd
 8vjmbpcGEUIFGG6EoezQ0exDBoC6jSQVa+2kBixxluHZOBgscNqSKUPb2H3PRpXxAojc0tec7
 2uZon9zKNlviNUkvq/hZnN91YmdbqsecbE4gewXwzLWyUjH8oaJtbD5KDXSNcxod6tBPcw0JA
 JAJZ8ioMVb/ngpRW/LxoVlXMRkDIxzQb1xVxFLkH5Pp8Cobent8dSVJNMPyHPN17Aw6YlaQXu
 vtHq8gP6fRrRVL1RreRGmaOsHIhA4T6kdSux9OgJphSYz0z6YFTPqCUYik8GCzV3Htf9a2dVV
 lKT40dR5lF+jOly03fVVpFm6M2zEtFZFyVyqKztM48IS5Jd8dVDzZI/dhLvdwmlJYzvxXM4vR
 QrTQriskVhB2IynDyi9D9vp8KUgHLTxjY9nm/mMGB3nP6k3RBjzUqWV0/8sWdDighPD8oF0ao
 Ile0c7EaWDFVijVLkVFDl/roacDv5IMoEpkYIJHxU1rMaR0h/oKu3G5gjSEXNZCJRLJcWZj5h
 o0zJhHNwtDZi6iCUS4W9kRu1Q0oHw0ymjcPMuySxvR5RlDXrZ0N8w9V+scOJdOh8bdjv7d3lw
 q/kVvZjFHx7S6uiPeJ79Iy3CKH+G3W7DPma/qWkVyzbpWFJcumcmXlE7Q05cds9XYjSShygtF
 Sxvn8N0FfBA/nP1mGJTOv7A3Gts/ikY4r1Kzocg/NhkVkodaSjrSSwIA3gscDrWaxz+5w6LOc
 6Gh/cNOWpDAJr4=
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,MIME_BASE64_TEXT,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RmlsbCBhbGwgcmVxdWVzdGVkIHJhdGVzIChpbiBjYXNlIG9mIGF0aDlrIDQgcmF0ZSBzbG90cyBh
cmUKYXZhaWxhYmxlLCBzbyBmaWxsIGFsbCA0IGluc3RlYWQgb2Ygb25seSAzKSwgaW1wcm92ZXMg
dGhyb3VnaHB1dCBpbgpub2lzeSBlbnZpcm9ubWVudC4KClNpZ25lZC1vZmYtYnk6IFBldGVyIFNl
aWRlcmVyIDxwcy5yZXBvcnRAZ214Lm5ldD4KLS0tCiBuZXQvbWFjODAyMTEvcmM4MDIxMV9taW5z
dHJlbF9odC5jIHwgMTQgKysrKysrKy0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlv
bnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjExL3JjODAyMTFf
bWluc3RyZWxfaHQuYyBiL25ldC9tYWM4MDIxMS9yYzgwMjExX21pbnN0cmVsX2h0LmMKaW5kZXgg
OWM2YWNlODU4MTA3Li5jZDZhMGYxNTM2ODggMTAwNjQ0Ci0tLSBhL25ldC9tYWM4MDIxMS9yYzgw
MjExX21pbnN0cmVsX2h0LmMKKysrIGIvbmV0L21hYzgwMjExL3JjODAyMTFfbWluc3RyZWxfaHQu
YwpAQCAtMTQzNiwxNyArMTQzNiwxNyBAQCBtaW5zdHJlbF9odF91cGRhdGVfcmF0ZXMoc3RydWN0
IG1pbnN0cmVsX3ByaXYgKm1wLCBzdHJ1Y3QgbWluc3RyZWxfaHRfc3RhICptaSkKIAkvKiBTdGFy
dCB3aXRoIG1heF90cF9yYXRlWzBdICovCiAJbWluc3RyZWxfaHRfc2V0X3JhdGUobXAsIG1pLCBy
YXRlcywgaSsrLCBtaS0+bWF4X3RwX3JhdGVbMF0pOwogCi0JaWYgKG1wLT5ody0+bWF4X3JhdGVz
ID49IDMpIHsKLQkJLyogQXQgbGVhc3QgMyB0eCByYXRlcyBzdXBwb3J0ZWQsIHVzZSBtYXhfdHBf
cmF0ZVsxXSBuZXh0ICovCi0JCW1pbnN0cmVsX2h0X3NldF9yYXRlKG1wLCBtaSwgcmF0ZXMsIGkr
KywgbWktPm1heF90cF9yYXRlWzFdKTsKLQl9CisJLyogRmlsbCB1cCByZW1haW5pbmcsIGtlZXAg
b25lIGVudHJ5IGZvciBtYXhfcHJvYmVfcmF0ZSAqLworCWZvciAoOyBpIDwgKG1wLT5ody0+bWF4
X3JhdGVzIC0gMSk7IGkrKykKKwkJbWluc3RyZWxfaHRfc2V0X3JhdGUobXAsIG1pLCByYXRlcywg
aSwgbWktPm1heF90cF9yYXRlW2ldKTsKIAotCWlmIChtcC0+aHctPm1heF9yYXRlcyA+PSAyKSB7
CisJaWYgKGkgPCBtcC0+aHctPm1heF9yYXRlcykKIAkJbWluc3RyZWxfaHRfc2V0X3JhdGUobXAs
IG1pLCByYXRlcywgaSsrLCBtaS0+bWF4X3Byb2JfcmF0ZSk7Ci0JfQorCisJaWYgKGkgPCBJRUVF
ODAyMTFfVFhfUkFURV9UQUJMRV9TSVpFKQorCQlyYXRlcy0+cmF0ZVtpXS5pZHggPSAtMTsKIAog
CW1pLT5zdGEtPm1heF9yY19hbXNkdV9sZW4gPSBtaW5zdHJlbF9odF9nZXRfbWF4X2Ftc2R1X2xl
bihtaSk7Ci0JcmF0ZXMtPnJhdGVbaV0uaWR4ID0gLTE7CiAJcmF0ZV9jb250cm9sX3NldF9yYXRl
cyhtcC0+aHcsIG1pLT5zdGEsIHJhdGVzKTsKIH0KIAotLSAKMi4zNS4xCgo=
