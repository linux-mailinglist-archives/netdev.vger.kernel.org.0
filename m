Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CC0404814
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 11:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbhIIJzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 05:55:07 -0400
Received: from mout.gmx.net ([212.227.17.20]:55077 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhIIJzH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 05:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631181225;
        bh=lOMq6mIVSm791q9k547I0Pwd+JX/iGxJ0ezFxEmjQMU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=X7WMtApsAwTudpzbERjcgss498fi+47/LqseH1v7tp6wB3+K135WpMJ3JXlq9KZXF
         bg2PFt72n9RbuGWhr73Sw5rYSsXSJBq8C0X/O4AMz+EK5I7+/hqFMHeHhhiE+HhlVf
         pLYWSB5j53ujoEJS/LOAJ79Wtgm8pkDd8s+kBvks=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([46.223.119.124]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M89L1-1mK81S2AOh-005JPk; Thu, 09
 Sep 2021 11:53:45 +0200
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     olteanv@gmail.com
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 1/3] net: dsa: introduce function dsa_tree_shutdown()
Date:   Thu,  9 Sep 2021 11:53:22 +0200
Message-Id: <20210909095324.12978-2-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:zY7aPPcJ0rmWg4P/dSuY7pJFB0odksbjtzKJhmdm/EzodkWhJ3T
 uzskNG0ufBfkEC+ciIyvyc2Xxv96ezfWkTR0ZPZbS0U2EfNNQUk8OB9vAWgPUPM7LJUULTR
 IdsDIWeknCES1pVfsZhZknxCYroHwG31KNoty/F/P2QKLhOLBj3Nf4tX3z4zn2vTKARbrsJ
 IgQW4hVV0QFN7W78HVj2w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tliuW64YXfo=:2lwrRn40DgF3MBgCVKhleE
 HxENN0vqsKNMtOzaBwm+9C2w13Xxi+21OJ8Y0CgRJ6KNFQT83zKIeO9KUZCiXy/r7zLondTNG
 ndMcaMSccKi1cNA6TyI6Il1tigoRRYqlniXPkz/AhfFYvZZAHWgEWJZ0pgWdhTVB80URlofTT
 1CBDrRbQ5kPJPpIi50Wr8J17IK42Jy4xJfQvXxXGUKWULCoSRPsu1arsJAJDXQfgMqVWLFlwh
 XUt4m40QLdPRJWbihch0HqXEK0BQb4CkB+uXBuHg0bCj6GVFo7Mh2ndl5enaPFbr82vahRqFl
 nGsR+jnNH1Ap++vdhHzPN9ZKetojvY8Jsnlx3W20bSXBSBfJbR8ITCjSVaDeVmbhMCUcZ7rpH
 +M9NqvmXXs4AO6JjlbRbdOfT3pUJHW36g5xJMukKqwA7pkYRpKgkeBclUdWz+uio07nRnglcm
 AKkWMfMIBtb35efrNhsG9iLhWJRLTRWxj3a6cXNmuEfc1SwDk8928q3sHMDqOYj+ciUM7Ms7X
 MBeDP5o2hKSIhoWg044XFxgXoTdVUK0GGnfyhVLc6eP1IJhG1VPeWK9I/JBmmfGH+k0/cJYdM
 I4D2t3FhXG1YXnNNmUQ+1rfFWPlfW/Pr7DHhXle7wuo/47knD3iP00vVNXC+bFJ4zsQF4oKak
 Bx+PGV1S3ndlPkjIdipHw3Wg88oFmEv/+a3Sp6/TuhQV1fDXrwsGjNf2BpbQw/wijkXtKCVcS
 1eT31IBWH2bYKIV3hDmUgwjtx5xhdLYEq6tDlpFwGUCQJfRYpJctXaZh7wI2yiRB5nHogWOnU
 JjKrFw6IqNqTw9MxTUw27i83zsKiXxr0IE2qmzrbzI/9Rt5U8uXLVm0qimqXfMDgD2BmXd7bM
 Ccok5xnvFeKDwgnYpBqpkIi9f4T9bxwLBG8WmqTheJSTNP34rR2j8oPWbnooPUXX+XTlnuVxK
 7M7eB/b/q87RxyqWJaZA/Vb5XWCWdvmOrVtg+5zT7PBXDKxyAA9nwLZUZS0EW/xLrWaEXiEV9
 b38eLQLg2BVcRkCIc97OxKKfaYeyEbzpFVAv6Ajvbun5zY+WLU/v/F1rxv8rRrRILND4Yfa7P
 W+bmeggn3mZYIQ=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UHJvdmlkZSB0aGUgZnVuY3Rpb24gZHNhX3RyZWVfc2h1dGRvd24oKSB0aGF0IGNhbiBiZSBjYWxs
ZWQgYnkgRFNBIGRyaXZlcnMKdG8gdGVhciBkb3duIHRoZSBEU0EgdHJlZS4KVGhpcyBpcyBwYXJ0
aWN1bGFybHkgdXNlZnVsIGZvciBzaHV0ZG93biBoYW5kbGVycyB0byBtYWtlIHN1cmUgdGhhdCB0
aGUgRFNBCnRyZWUgaXMgdG9ybiBkb3duIChhbmQgdGh1cyBhbGwgcmVmZXJlbmNlcyB0byB0aGUg
bWFzdGVyIGRldmljZSBhcmUKcmVsZWFzZWQpIGJlZm9yZSB0aGUgbWFzdGVyIGRldmljZSBpcyBk
ZXJlZ2lzdGVyZWQuCgpTaWduZWQtb2ZmLWJ5OiBMaW5vIFNhbmZpbGlwcG8gPExpbm9TYW5maWxp
cHBvQGdteC5kZT4KLS0tCiBpbmNsdWRlL25ldC9kc2EuaCB8IDEgKwogbmV0L2RzYS9kc2EyLmMg
ICAgfCA4ICsrKysrKysrCiAyIGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKQoKZGlmZiAt
LWdpdCBhL2luY2x1ZGUvbmV0L2RzYS5oIGIvaW5jbHVkZS9uZXQvZHNhLmgKaW5kZXggZjlhMTcx
NDUyNTVhLi43ZDQwOTRmYWFhM2EgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbmV0L2RzYS5oCisrKyBi
L2luY2x1ZGUvbmV0L2RzYS5oCkBAIC0xMDM5LDYgKzEwMzksNyBAQCBzdGF0aWMgaW5saW5lIGlu
dCBkc2FfbmRvX2V0aF9pb2N0bChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBzdHJ1Y3QgaWZyZXEg
KmlmciwKIH0KICNlbmRpZgogCit2b2lkIGRzYV90cmVlX3NodXRkb3duKHN0cnVjdCBkc2Ffc3dp
dGNoX3RyZWUgKmRzdCk7CiB2b2lkIGRzYV91bnJlZ2lzdGVyX3N3aXRjaChzdHJ1Y3QgZHNhX3N3
aXRjaCAqZHMpOwogaW50IGRzYV9yZWdpc3Rlcl9zd2l0Y2goc3RydWN0IGRzYV9zd2l0Y2ggKmRz
KTsKIHN0cnVjdCBkc2Ffc3dpdGNoICpkc2Ffc3dpdGNoX2ZpbmQoaW50IHRyZWVfaW5kZXgsIGlu
dCBzd19pbmRleCk7CmRpZmYgLS1naXQgYS9uZXQvZHNhL2RzYTIuYyBiL25ldC9kc2EvZHNhMi5j
CmluZGV4IDFiMmIyNWQ3YmQwMi4uMDU4ODU4MWY2NTMxIDEwMDY0NAotLS0gYS9uZXQvZHNhL2Rz
YTIuYworKysgYi9uZXQvZHNhL2RzYTIuYwpAQCAtMTA2Niw2ICsxMDY2LDE0IEBAIHN0YXRpYyB2
b2lkIGRzYV90cmVlX3RlYXJkb3duKHN0cnVjdCBkc2Ffc3dpdGNoX3RyZWUgKmRzdCkKIAlkc3Qt
PnNldHVwID0gZmFsc2U7CiB9CiAKK3ZvaWQgZHNhX3RyZWVfc2h1dGRvd24oc3RydWN0IGRzYV9z
d2l0Y2hfdHJlZSAqZHN0KQoreworCW11dGV4X2xvY2soJmRzYTJfbXV0ZXgpOworCWRzYV90cmVl
X3RlYXJkb3duKGRzdCk7CisJbXV0ZXhfdW5sb2NrKCZkc2EyX211dGV4KTsKK30KK0VYUE9SVF9T
WU1CT0xfR1BMKGRzYV90cmVlX3NodXRkb3duKTsKKwogLyogU2luY2UgdGhlIGRzYS90YWdnaW5n
IHN5c2ZzIGRldmljZSBhdHRyaWJ1dGUgaXMgcGVyIG1hc3RlciwgdGhlIGFzc3VtcHRpb24KICAq
IGlzIHRoYXQgYWxsIERTQSBzd2l0Y2hlcyB3aXRoaW4gYSB0cmVlIHNoYXJlIHRoZSBzYW1lIHRh
Z2dlciwgb3RoZXJ3aXNlCiAgKiB0aGV5IHdvdWxkIGhhdmUgZm9ybWVkIGRpc2pvaW50IHRyZWVz
IChkaWZmZXJlbnQgImRzYSxtZW1iZXIiIHZhbHVlcykuCi0tIAoyLjMzLjAKCg==
