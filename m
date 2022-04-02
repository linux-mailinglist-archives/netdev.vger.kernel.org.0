Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BA44F046D
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 17:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357305AbiDBPcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 11:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiDBPcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 11:32:19 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1355F12342E;
        Sat,  2 Apr 2022 08:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1648913415;
        bh=qbwQAiVMk58tGGoiDErQltrxLS9k74j45rz0UOdmUWQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Pxd0aROwUk9/A9tQ0k2UKk1KJoSoKhHq8Hj4Hpv1A7iu7KUxhx5vCRGpEqVBGA1Un
         mKXYQkU168aFSMXIcm0y9RKJqg4GkaXqqmB/CVeejjpeF8pUggsHnMhYuX6obqH68G
         nNl7Hr0HJQDuN+Zr9P+2yxKLJB3u0fTAW+Czfsqc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.fritz.box ([62.216.209.166]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MeU0q-1oB6Rv2kaa-00aTDi; Sat, 02 Apr 2022 17:30:15 +0200
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] ath9k: fix ath_get_rate_txpower() to respect the rate list end tag
Date:   Sat,  2 Apr 2022 17:30:13 +0200
Message-Id: <20220402153014.31332-1-ps.report@gmx.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:MohT/QwUArtXl+6vE+K5BnfsY+AJOMTC9brnN5PqrveWj7Xtzwa
 j1ywHVQK9DWdQWyIXP9CE9NW9jemaU8t4AxgAof4IwMWM2AQ640M5+fARZa1dCkmw+s6/vd
 REm3JcmbEf9nGryy7qUj6rjx30DwGAL9zFd5X0HWciAmqhhMAGiYwkYgkI/FcDVisB3+lE0
 5KI3gPozFDIhgaqbkyazg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2AFzgIAydoo=:gxx+/aJDdCMsTVrHZa6T7x
 IFEhbQNpZasl2nJDKQO3OdsvBzEWesDMBPVFR4wz7DoNc1YUWWHev9hNJ3pDOKNSlzIHiCDmJ
 FC/J2YymhG86K3UqwZzZIT9TSU0MzGrzGreaUP8LMhZjt0UTrsCYXW4BNbXcYaIOfJXEzwZkj
 gblK6j5dE/aEJlGsMxTatBJe6VyD69ZglbNz/wcemnAFLoV0+twLaO715CEjsDUSWUvODiBkt
 4udQQGG2ptTKh8fyhaD9fiYeX3qX/KXIRgjBF9PCqs0kKjDfTcE/WTTSLc5jZRf6fiFp61GHv
 g60vkct2wveZXnwqf+Jh3ywT92tuRyRiXvoB/trXKJvUrGj9d+ktuMxAkXANSBtQkQ/KTyXin
 33ss4mCoLf++M8GM380Hj8wUUUdICx+Ovrwa+10I1XhlEueGiAkQKZl4ZO7C8A2FdPsMcyyeW
 V4jF3MLeGHDj7W7K5Go2TqXPTIFMyU/aHqhcHKBoZX8QikEbUOz80Ql/icf9V2Mh1a3xkQ/0R
 FejqxUaQBE7Y6jxs3z1VngMtwH9ear9Keu97Y+DagdOkHvnpjEKU7KhXvCpRW8T+KmRFt4CV1
 6G7XFbl7hUqD4Qmn1JtkV0+dD4EYGouE9Ury7StHJeLskRMEAihpp51lA7Nuns2bL8ftUOe89
 S2MT6Mfzp2/N3foX+OljyT0gDwfPorEIaIxux2RelPDSjP7yQgR1bDRgJTLtFJWivwoDrEt+m
 /y7GR5ckyIBDkyrtfCWtT1oRXv1h4+J260DUOMNQi2ijKfIlMrrhJTG6YfO6tzue9AHGzWxC6
 BAjBUaZ7DmJl6GQzsfOj4h7ZvcKVQU6reJLD9aOQi1wIsaiDEWDz8vszssLuxZtKqfLOUqItE
 IpaMTm3+Nya5QYZ2imVpxTQmcuL5BbuYzGyQfxIaeM50N5Np3PaJNKuRYRsIT7asmrHXySUIh
 ZA0P57MjG9gwnbiwzsZyckYaB8AN1PuHWcHgH3MTwSxxvUk4ph43i5Jv5BNrFcEbpnMuw59hD
 LaczuQA9RLLNkTpATHzAe2y0HsxlTuSQR69kqfdYaf1sCX0cPmPSRRg5DkOrltjmKTsC1qQE+
 pW4fVQxb8cA+ak=
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,MIME_BASE64_TEXT,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U3RvcCByZWFkaW5nIChhbmQgY29weWluZykgZnJvbSBpZWVlODAyMTFfdHhfcmF0ZSB0byBhdGhf
dHhfaW5mby5yYXRlcwphZnRlciBsaXN0IGVuZCB0YWcgKGNvdW50ID09IDAsIGlkeCA8IDApLCBw
cmV2ZW50cyBjb3B5aW5nIG9mIGdhcmJhZ2UKdG8gY2FyZCByZWdpc3RlcnMuCgpOb3RlOiBubyBu
ZWVkIHRvIHdyaXRlIHRvIHRoZSByZW1haW5pbmcgYXRoX3R4X2luZm8ucmF0ZXMgZW50cmllcwph
cyB0aGUgY29tcGxldGUgYXRoX3R4X2luZm8gc3RydWN0IGlzIGFscmVhZHkgaW5pdGlhbGl6ZWQg
dG8gemVybyBmcm9tCmJvdGggY2FsbCBzaXRlcy4KClNpZ25lZC1vZmYtYnk6IFBldGVyIFNlaWRl
cmVyIDxwcy5yZXBvcnRAZ214Lm5ldD4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRo
OWsveG1pdC5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3htaXQu
YyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg5ay94bWl0LmMKaW5kZXggZDBjYWYxZGUy
YmRlLi5lYzliYWQyZDk1MTAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9h
dGg5ay94bWl0LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3htaXQuYwpA
QCAtMTI3MSw3ICsxMjcxLDcgQEAgc3RhdGljIHZvaWQgYXRoX2J1Zl9zZXRfcmF0ZShzdHJ1Y3Qg
YXRoX3NvZnRjICpzYywgc3RydWN0IGF0aF9idWYgKmJmLAogCQlpbnQgcGh5OwogCiAJCWlmICgh
cmF0ZXNbaV0uY291bnQgfHwgKHJhdGVzW2ldLmlkeCA8IDApKQotCQkJY29udGludWU7CisJCQli
cmVhazsKIAogCQlyaXggPSByYXRlc1tpXS5pZHg7CiAJCWluZm8tPnJhdGVzW2ldLlRyaWVzID0g
cmF0ZXNbaV0uY291bnQ7Ci0tIAoyLjM1LjEKCg==
