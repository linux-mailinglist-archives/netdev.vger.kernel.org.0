Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C712F3D1A8F
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 01:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhGUXPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 19:15:46 -0400
Received: from mout.gmx.net ([212.227.17.20]:38103 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229974AbhGUXPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 19:15:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626911767;
        bh=MTzoNI+4/t77AVtRX7F3dHidZZBtCwdh6utBGbbuUCM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=h1ixPFzUldtN6+MF1sX2ojNNcTYmbrtAtZu9qs3VOOvnt09Ry2+x0B5b9zWk97w2p
         /QVMTNgzHKUe3ytPAePdyF7kzV3zN3p0KmKZIUqvNXx1VtZkzqisbw7WMH3W2ODmvP
         w24kuQBEOESKReg/UcQrmVBH4XPffruJUfxHVI54=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([149.172.237.67]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M6ll8-1m1M8T2p1a-008KqK; Wed, 21
 Jul 2021 23:56:51 +0200
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     woojung.huh@microchip.com, olteanv@gmail.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH v2 2/2] net: dsa: tag_ksz: dont let the hardware process the layer 4 checksum
Date:   Wed, 21 Jul 2021 23:56:42 +0200
Message-Id: <20210721215642.19866-3-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
References: <20210721215642.19866-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:VrYRZ8zYIkA/EmJQWzaTUwoWNymemMyGpBXSXegQD3tN4gQv8hr
 SKV/Rfr0ylf4Afz6WxOvFNJ47HRx9YkCa8eomMPWnuPnE5rXCHl+wgYia4nV/RQI3kHRbpz
 JnYxqysjd8rwUEKc9obqdFK4cE/cxP91xjQpGMQz4lTk/87hb2SlbVbS5hRJHKvLZRBZ7AS
 6Oz0bYceci9NqZ0ricBrg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wttdpPwfjc8=:9y0l/U1MEUh58h4FCgqWsc
 uF2bw17XQlk+iIv91j6pCdIOf0hGu9AnwCR9tbVsGLQu2q0RXiHsvFhqNZPviXoWm45LXevJU
 b7ZGFelk9YvtIcXNUdfI0nzv4BqLToOdxFkrQi4TVI58PaVerNqmCbCdw03qv/Naq8ZTf9wiN
 ikCEPUZzF5+tNWaz2pA7Z2jjIEb5TAhgU9E7eWAlBOuetS8t1rt+mFkL0jxEZZp8iRFJg5HjE
 NIhoHX7tL5uErrNGsFgmBovQqVKl2p9oi1mLWWZvtNOV09u4W2Pdw1uUS9qqr3cboDd6uhcsY
 DZgW6MbDNjqYA9mkijp8RjyTMlPl68k4OuWYbeDK9aRtAw/60VTbASBbtl8w4b8b2XHH2L6YN
 CH/nGO3hTyyrLH4RM4tDScHRxoerfHnHZFT/BJ5gsc+Iq9xRAM7wMM4HF2PrKDtPIURCQSW3y
 ZplH9ssJNrFIeZz0IOSXdH5q0uCzBbZZzgpvPkl8J8ISZO1agSDxCLtv7Bxdf/uIFPByp0fHR
 gtq/1VjJQjxyRwBqol8O6oyAkmqmnvswziMCu9jWLyNhhtkeUHgkH0hasQR9OkZJcdg9NeNK3
 Xo4x/mT0JDe2vBIkuNBB4JkQHw6TMecKOoDbgT7XjeqnIjAPDViWFV+7eLDgWRhDjoDDTT6eq
 KUuyeIVstbWZ+Z3YXVx2PtrpDhjy/ilVbIgNhvu3hCXKN6ucfUWrdsjgCeGDIxsUmqGDnNhfd
 oxKyt3Kbzqx/IsRricuvNPi/RUeria5uy0T6DfodVPedz1OHt/hotI6XZYFzss86tiWNiRbG/
 elo+CySMsr7FPtAYPn6d8GykpNvgc/a6XBMFmb3BAjhCWNV4+gX/wkGvSdXmwjAnrMf/6PMqS
 oa07bBUeFQbu2rjffphWGo3zR34sIqHx1aRL42q+IaL1CloO+l34PduUy42TzC1JPNTlZJiIW
 PUIS3De+AOfmKC06A48bML4wwITualUq9RCu2/XkVwwtczwthelYtexI3aD1JQGLwUVlef5c2
 hV0ztaXXpYyF+9UjiZfEbpccelkz0zjHqVKygo91NTJVLQ7xMLCvYgaFfkWhpEAJDfpTlPwVm
 xqjnc/C36rpqP2lnu9uUdq5bkizW8PXsYoS1c5+CSMWVoRW7O6I9oSg3A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SWYgdGhlIGNoZWNrc3VtIGNhbGN1bGF0aW9uIGlzIG9mZmxvYWRlZCB0byB0aGUgbmV0d29yayBk
ZXZpY2UgKGUuZyBkdWUgdG8KTkVUSUZfRl9IV19DU1VNIGluaGVyaXRlZCBmcm9tIHRoZSBEU0Eg
bWFzdGVyIGRldmljZSksIHRoZSBjYWxjdWxhdGVkCmxheWVyIDQgY2hlY2tzdW0gaXMgaW5jb3Jy
ZWN0LiBUaGlzIGlzIHNpbmNlIHRoZSBEU0EgdGFnIHdoaWNoIGlzIHBsYWNlZAphZnRlciB0aGUg
bGF5ZXIgNCBkYXRhIGlzIGNvbnNpZGVyZWQgYXMgYmVpbmcgcGFydCBvZiB0aGUgZGFhIGFuZCB0
aHVzCmVycm9ybmVvdXNseSBpbmNsdWRlZCBpbnRvIHRoZSBjaGVja3N1bSBjYWxjdWxhdGlvbi4K
VG8gYXZvaWQgdGhpcywgYWx3YXlzIGNhbGN1bGF0ZSB0aGUgbGF5ZXIgNCBjaGVja3N1bSBpbiBz
b2Z0d2FyZS4KClNpZ25lZC1vZmYtYnk6IExpbm8gU2FuZmlsaXBwbyA8TGlub1NhbmZpbGlwcG9A
Z214LmRlPgotLS0KIG5ldC9kc2EvdGFnX2tzei5jIHwgOSArKysrKysrKysKIDEgZmlsZSBjaGFu
Z2VkLCA5IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9uZXQvZHNhL3RhZ19rc3ouYyBiL25l
dC9kc2EvdGFnX2tzei5jCmluZGV4IDUzNTY1ZjQ4OTM0Yy4uYTIwMWNjZjI0MzVkIDEwMDY0NAot
LS0gYS9uZXQvZHNhL3RhZ19rc3ouYworKysgYi9uZXQvZHNhL3RhZ19rc3ouYwpAQCAtNTMsNiAr
NTMsOSBAQCBzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKmtzejg3OTVfeG1pdChzdHJ1Y3Qgc2tfYnVm
ZiAqc2tiLCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQogCXU4ICp0YWc7CiAJdTggKmFkZHI7CiAK
KwlpZiAoc2tiLT5pcF9zdW1tZWQgPT0gQ0hFQ0tTVU1fUEFSVElBTCAmJiBza2JfY2hlY2tzdW1f
aGVscChza2IpKQorCQlyZXR1cm4gTlVMTDsKKwogCS8qIFRhZyBlbmNvZGluZyAqLwogCXRhZyA9
IHNrYl9wdXQoc2tiLCBLU1pfSU5HUkVTU19UQUdfTEVOKTsKIAlhZGRyID0gc2tiX21hY19oZWFk
ZXIoc2tiKTsKQEAgLTExNCw2ICsxMTcsOSBAQCBzdGF0aWMgc3RydWN0IHNrX2J1ZmYgKmtzejk0
NzdfeG1pdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCXU4ICphZGRyOwogCXUxNiB2YWw7CiAKKwlp
ZiAoc2tiLT5pcF9zdW1tZWQgPT0gQ0hFQ0tTVU1fUEFSVElBTCAmJiBza2JfY2hlY2tzdW1faGVs
cChza2IpKQorCQlyZXR1cm4gTlVMTDsKKwogCS8qIFRhZyBlbmNvZGluZyAqLwogCXRhZyA9IHNr
Yl9wdXQoc2tiLCBLU1o5NDc3X0lOR1JFU1NfVEFHX0xFTik7CiAJYWRkciA9IHNrYl9tYWNfaGVh
ZGVyKHNrYik7CkBAIC0xNjQsNiArMTcwLDkgQEAgc3RhdGljIHN0cnVjdCBza19idWZmICprc3o5
ODkzX3htaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwKIAl1OCAqYWRkcjsKIAl1OCAqdGFnOwogCisJ
aWYgKHNrYi0+aXBfc3VtbWVkID09IENIRUNLU1VNX1BBUlRJQUwgJiYgc2tiX2NoZWNrc3VtX2hl
bHAoc2tiKSkKKwkJcmV0dXJuIE5VTEw7CisKIAkvKiBUYWcgZW5jb2RpbmcgKi8KIAl0YWcgPSBz
a2JfcHV0KHNrYiwgS1NaX0lOR1JFU1NfVEFHX0xFTik7CiAJYWRkciA9IHNrYl9tYWNfaGVhZGVy
KHNrYik7Ci0tIAoyLjMyLjAKCg==
