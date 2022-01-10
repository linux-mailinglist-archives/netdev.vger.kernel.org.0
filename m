Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE5448A2C3
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 23:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345451AbiAJWae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 17:30:34 -0500
Received: from mout.gmx.net ([212.227.17.20]:59285 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345432AbiAJWad (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 17:30:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1641853825;
        bh=/vAc/cWpB6Hy72B79vKnewkrZjPB5a5e0t9n4ldSDgE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=kpnnFwt6pBnkle2F0xPbCcgsFrs2AI8du3+o3roXsD93oghPDI+kWXrkuUs7f9hWE
         OwkWyBxf/Yjd9z6boGau31/g0Bqq21ZYS+P0L8Y8xl30+OBzZFJjISVIL5d66KXvPB
         OeV+UZ0RVtO3ngBo1UmwoYY3rUAsjs1F+iN31wq4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.fritz.box ([62.216.209.151]) by mail.gmx.net
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MbAci-1mVWVV23VA-00beNI; Mon, 10 Jan 2022 23:30:25 +0100
From:   Peter Seiderer <ps.report@gmx.net>
To:     linux-wireless@vger.kernel.org
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 5/5] ath5k: fix ah_txq_isr_txok_all setting
Date:   Mon, 10 Jan 2022 23:30:21 +0100
Message-Id: <20220110223021.17655-5-ps.report@gmx.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110223021.17655-1-ps.report@gmx.net>
References: <20220110223021.17655-1-ps.report@gmx.net>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:Oaji8jUP8E5JVdmIs2XuC/fPruoDCWsfS+NAgngXlxs6gkmMvEr
 VEPKNHL7Xj40Kh3LcWiMCCBUoidxqK0D1IJYZ8Q9/fpx1cb8+ecFqAuxYmdY2UTw2Z8FOy2
 NgwsWQ75tPHoiUUzz1jqCWkKdPNd9yD9A5YqxvL3ZfydgTICK9bWOPmPuG43KWha6NDVrdT
 Enkh1nKhfMFHi5XNZUe5Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:q+oAgThdpHU=:44G2nolYim/11OA13VZwFu
 fGirkj/4bvbtjyBz0gse7k0I2gVAbTFBiKD+rNnYZCFZXlRxIs370pjolWegwUBhLeCVJmAdY
 seezpECorwr8deHSw4W7GdTsg5L8WIbMNmC/8V5Qb+jxWN+iCZ5HAZZYxjK5VDZ9CIh06+6mY
 G5PZPE5fu0mspSlaZ7pzHbWppJqPf/6aQq1CZehpOrVE8PrRSsZQ8V+njPUBbTnWQpJ6NeRG7
 5YS8pAboekHicOe56UZJpY/+OGz5OA2ZPJaTqvoTFxzsv3ozzLDNXGZD9QIkC40tD7bl+eHDy
 sZREGcQrL8BuXULP8lgOaRFckyMVDjqWYPScnEh2ZJIBaPMMbRfwN1Hq2MnLdYOwfBzSoJmhk
 +v2b0Q2FFal1g0bgfCgeSUICqQF/NiwmkLcndeHDjEjhKfX1o/1QaD0KsnBD4SSpuwJn6U/mX
 PU1cu+CuSdq2i6cWyBcKEMmJMjJ3FGDamsF45bxnxT8sJym7RsrJoPcb9vweNuxOyaKSmDxqT
 SsciNGABeVBrv+pusWxaE1fk0cS1NDJdOFK2vrQyqUycX2ie+WLVXomlLG8DubNs25EWPo6Q5
 f7/08J1m8BbrdMmmk8Lxxc3hqQUWlEZe7MnT8AI4gTqQLGMaMcWAbeQKUI94Ih3voQGTHFun1
 mTJr/pyw8uEb3ZKvAwaj1vaHzVXJeoiG7S/I6T+eNo4QAmqtIIcLybinJBySlCoViRgZQp1B0
 EUho0ue0WWT1ANNBnjZMLsJYtMAzrrKku8IWG0htotucb+k6Ifufqm1Z8QskaZilw5lcny6I7
 jxt2LQ+XjpTIA9HohFF22nlOM5bHqicKh5RH/0WIX8t6IbWvaQgpkyQx6OfNLm+Fq3abmF29j
 G5xzgmxG3go3wTW/eV064KS379CVq8hcfBlenW8BneTGCZzAHUJwBeX/YtUcsztz+eNxxkTlG
 aY0IL6DE33GQdZcTqMsTDB84EiadBFmxnUiP7K5xBGUlX2RZLBMkyrV6lHqa9IzS4mti++I8v
 odUshZdljdWlr6G+FEkMlI8VGRSYWFbLEe/ZZ/IsyxN6g4WMw8PeL16O7gKXhh3FkG89hft9f
 cmfSoCTn4aJAxI=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIHN0cnVjdCBhdGg1a19odyBtZW1iZXIgYWhfdHhxX2lzcl90eG9rX2FsbCBpcyBuZXZlciBy
ZXNldC9hc3NpZ25lZApvdXRzaWRlIG9mIGF0aDVrX2h3X2dldF9pc3IoKSBhbmQgd2l0aCB0aGUg
dXNlZCBiaXR3aXNlLW9yIGluIHRoZQppbnRlcnJ1cHQgaGFuZGxpbmcgYWNjdW11bGF0ZXMgYWxs
IGV2ZXIgc2V0IGludGVycnVwdCBmbGFncy4KCkZpeCB0aGlzIGJ5IGNsZWFyaW5nIGFoX3R4cV9p
c3JfdHhva19hbGwgYmVmb3JlIGFzc2lnbmluZy4KClBhdGNoIHRlc3RlZCB3aXRoIFNlbmFvIE5N
UC04NjAyIGNhcmQKCiAgUXVhbGNvbW0gQXRoZXJvcyBBUjU0MTMvQVI1NDE0IFdpcmVsZXNzIE5l
dHdvcmsgQWRhcHRlciBbQVI1MDA2WChTKSA4MDIuMTFhYmddIChyZXYgMDEpCiAgYXRoNWs6IHBo
eTY6IEF0aGVyb3MgQVI1NDEzIGNoaXAgZm91bmQgKE1BQzogMHhhNCwgUEhZOiAweDYxKQoKcnVu
bmluZyBJQlNTIG1vZGUgYWdhaW5zdCBBdGhlcm9zIChhdGg5aykgY2FyZCB1c2luZwpwaW5nIGFu
ZCBpcGVyZiB0cmFmZmljLgoKU2lnbmVkLW9mZi1ieTogUGV0ZXIgU2VpZGVyZXIgPHBzLnJlcG9y
dEBnbXgubmV0PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGg1ay9kbWEuYyB8IDEg
KwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvYXRoL2F0aDVrL2RtYS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0
aDVrL2RtYS5jCmluZGV4IDJiMTM1YTYyODRhMC4uZDllMzc2ZWIwNDBlIDEwMDY0NAotLS0gYS9k
cml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoNWsvZG1hLmMKKysrIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvYXRoL2F0aDVrL2RtYS5jCkBAIC02NTAsNiArNjUwLDcgQEAgYXRoNWtfaHdfZ2V0X2lz
cihzdHJ1Y3QgYXRoNWtfaHcgKmFoLCBlbnVtIGF0aDVrX2ludCAqaW50ZXJydXB0X21hc2spCiAJ
CSAqLwogCQkqaW50ZXJydXB0X21hc2sgPSAocGlzciAmIEFSNUtfSU5UX0NPTU1PTikgJiBhaC0+
YWhfaW1yOwogCisJCWFoLT5haF90eHFfaXNyX3R4b2tfYWxsID0gMDsKIAogCQkvKiBXZSB0cmVh
dCBUWE9LLFRYREVTQywgVFhFUlIgYW5kIFRYRU9MCiAJCSAqIHRoZSBzYW1lIHdheSAoc2NoZWR1
bGUgdGhlIHR4IHRhc2tsZXQpCi0tIAoyLjM0LjEKCg==
