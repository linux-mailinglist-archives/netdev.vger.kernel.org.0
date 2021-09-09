Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598AB40481B
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 11:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbhIIJzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 05:55:12 -0400
Received: from mout.gmx.net ([212.227.17.22]:53389 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233436AbhIIJzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 05:55:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631181226;
        bh=iAMRA7J7B75qAx18nV5A5l4I0o/uKALUFm0ZoKS/HHg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=cXAyqhcJyiqOIZsACbKqoinbmnr/7VmWILgGOkAg/JcAMRhT9LrLWIxdVzEDbBi6U
         pAt/tTzHtbO1tzX/Erk71p15XOaia5BG/eRmhPBvIH/yL+2oicH+d66eHZv1HeBWhW
         K5+8GlQ+N0af7tVTbrE4A9+rMfx9QOPutBVcIWiU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([46.223.119.124]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MVvPJ-1mXrXb1RCP-00RoLG; Thu, 09
 Sep 2021 11:53:46 +0200
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     olteanv@gmail.com
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 3/3] net: dsa: microchip: tear down DSA tree at system shutdown
Date:   Thu,  9 Sep 2021 11:53:24 +0200
Message-Id: <20210909095324.12978-4-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:UbZPGZWtRgdxY+0Xbb+EY2aJRkm0/k/LthL4CtHbi2KZq/rfe0g
 Fw6SC7V+pEtF72erFJ9lBzjd4I4d6qlrM6r5T7OozRS0MmwIxLBXKd6hLP2ybcG8l/hghZk
 9X0KZrHSOTQENyoXrNKalfn10SG+IfAb5tANNhuU/WhkuvZWbtAgwQNFwCZ1Inkx20NmKee
 ai9frIHEigrqU+9cb3l1w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2B41uqs+kGA=:axrewgqKY8dNNzqw4KXZrU
 TOfdgrq5sJ5MmsARhKW7OYPoVrF/zBrdqQx3bPrI9/mpr/+uWMxU4Bh151t2Jb+TmkOJd62lu
 uo3hWF+mhABAVcRhwPtdt1Q/OZ5MgTB3WfcZYtKMxv1rWnpVemVtWREyf7hrjUq9+FRJTkoII
 Yj8YkRTTGd2NKICe6hBHfhihRB4WES9M01oCHG7UMKhQ0K1XmtLAz8Pmw0fWj3uqXjomVvx11
 rtNCQb8AgJ0OtuapliDJh1K8qKTyprQxlZcY94ZLpQUE85gduwZaLmqVOh5Uy7Z/RdSvZ/fbe
 Vvkf+3MQeYuBpdlqpULtxGuzjKS8UPDHoKMHOciDhyleKur5z+m6ufsMkeQbVg1UV86/nzBbd
 MeW6PvrM5zlDT/loPyiGSfj2zdDI/zMMHcOCmXOtnooi8saoSQKV9fm9dF+qi6B6tTTuFTmG/
 EDUSBfg8Go05YqDh/mJrHSH0LG3s2D7N13cpRZGFxvMp0IqppQiE6VTPGgi431bmeHHmV0DUg
 K7G5jp/J1Op6Si+c0vpAWzrXZmtadF6pLCu1t2Vdw6y++eDzsj64EaFvW54H4NTg1tmWaB7n9
 +J0SRD0l56M0Bhf2t25z6wT2937lB7SVueH2ilQ3j5xMNC41/aWk/2DJFxcNP2Io5CbWkheVe
 lj2fbwyagb6H5wqRJaiqXT0Ft+6U32aR60+h/A+wYHCsKlJR5LurVzB2+41PaZahaRsfv4BTF
 w6h7QRv2PJIhEWTtGZt7TRJPGGxYrSki9N7gC6TLKvyat1od24Lj+kkxDhtshGYCGLlDyGG73
 p0no8uI5erZk2hRPg6Dxd4fnCKXu5yyd2LqdsTQftr6pZgfo3sYYg8DZxEGlepcu5Fs0EdMvt
 6Tu3yGvQkPTOkMJv54EPO2eOkA1K2h7UyFpn7MzrM5vNfz4n3/5qjsHhLh/UdW6r73oxsuKvE
 bTYTFw+jpAJZinIZ51MyUKHoR9fMDKUy7KyobsAwFD2qNJJVE6NPACk9CeV4s8qoTmv1e1qy8
 FRjJtRkMS4pkltM7bzEa+5Wll1MjUx/VgLoeWpMlykxEUqBK1erZXR9dN4mAuAvC6+SpMIDua
 vE/Vy92+x9fzIY=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2h1dHRpbmcgZG93biB0aGUgc3lzdGVtIHdpdGggcmVnaXN0ZXJlZCBLU1o5NDc3IHNsYXZlIGRl
dmljZXMgcmVzdWx0cyBpbiBhCnN5c3RlbSBoYW5nLiBBZGRpdGlvbmFsbHkgdGhlIG1lc3NhZ2Ug
InVucmVnaXN0ZXJfbmV0ZGV2aWNlOiB3YWl0aW5nIGZvcgpFVEggdG8gYmVjb21lIGZyZWUuIFVz
YWdlIGNvdW50ID0gWCIgaXMgZHVtcGVkIGludG8gdGhlIGtlcm5lbCBsb2cgKHdpdGgKRVRIIGJl
aW5nIHRoZSBEU0EgbWFzdGVyIGRldmljZSBhbmQgWCB0aGUgbnVtYmVyIG9mIHJlZ2lzdGVyZWQg
c2xhdmUKZGV2aWNlcykuCgpUaGUgcmVhc29uIGZvciB0aGlzIGlzc3VlIGFyZSBwZW5kaW5nIHJl
ZmVyZW5jZXMgdG8gdGhlIERTQSBtYXN0ZXIgZGV2aWNlCndoaWNoIGFyZSBzdGlsbCBoZWxkIGJ5
IHRoZSBzbGF2ZSBkZXZpY2VzIGF0IHRoZSB0aW1lIG1hc3RlciBkZXZpY2UgaXMKdW5yZWdpc3Rl
cmVkLgoKV2hpbGUgdGhlc2UgcmVmZXJlbmNlcyBhcmUgc3VwcG9zZWQgdG8gYmUgcmVsZWFzZWQg
aW4ga3N6X3N3aXRjaF9yZW1vdmUoKQp0aGlzIGZ1bmN0aW9uIG5ldmVyIGdldHMgdGhlIGNoYW5j
ZSB0byBiZSBjYWxsZWQgZHVlIHRvIHRoZSBlYXJsaWVyIHN5c3RlbQpoYW5nIGF0IHRoZSBtYXN0
ZXIgZGV2aWNlIGRlcmVnaXN0cmF0aW9uLgoKRml4IHRoaXMgZGVhZGxvY2sgc2l0dWF0aW9uIGJ5
IGRlcmVnaXN0ZXJpbmcgdGhlIHN3aXRjaCAoYW5kIHRodXMgcmVsZWFzaW5nCnRoZSBtYXN0ZXIg
ZGV2aWNlIHJlZmVyZW5jZXMpIGluIHRoZSBLU1o5NDc3IHNodXRkb3duIGhhbmRsZXIuIFNpbmNl
IHRoaXMKaGFuZGxlciBpcyBjYWxsZWQgYmVmb3JlIHRoZSBtYXN0ZXIgZGV2aWNlIGRlcmVnaXN0
cmF0aW9uIGFsbCByZWZlcmVuY2VzIHRvCnRoZSBtYXN0ZXIgZGV2aWNlIGFyZSByZWxlYXNlZCBh
dCB0aGUgdGltZSBvZiBkZXJlZ2lzdHJhdGlvbiBhbmQgdGh1cyB0aGUKZGVhZGxvY2sgZG9lcyBu
b3Qgb2NjdXIuCgpTaWduZWQtb2ZmLWJ5OiBMaW5vIFNhbmZpbGlwcG8gPExpbm9TYW5maWxpcHBv
QGdteC5kZT4KLS0tCiBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzcuYyB8IDEyICsr
KysrKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzcuYyBiL2Ry
aXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3Ny5jCmluZGV4IDg1NGUyNWY0M2ZhNy4uNWRi
ODI4OThiNzM3IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0Nzcu
YworKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzcuYwpAQCAtMjI5LDYgKzIy
OSwxNiBAQCBzdGF0aWMgaW50IGtzejk0NzdfcmVzZXRfc3dpdGNoKHN0cnVjdCBrc3pfZGV2aWNl
ICpkZXYpCiAJcmV0dXJuIDA7CiB9CiAKK3N0YXRpYyBpbnQga3N6OTQ3N19zaHV0ZG93bihzdHJ1
Y3Qga3N6X2RldmljZSAqZGV2KQoreworCWludCByZXQ7CisKKwlyZXQgPSBrc3o5NDc3X3Jlc2V0
X3N3aXRjaChkZXYpOworCWtzel9zd2l0Y2hfc2h1dGRvd24oZGV2KTsKKworCXJldHVybiByZXQ7
Cit9CisKIHN0YXRpYyB2b2lkIGtzejk0Nzdfcl9taWJfY250KHN0cnVjdCBrc3pfZGV2aWNlICpk
ZXYsIGludCBwb3J0LCB1MTYgYWRkciwKIAkJCSAgICAgIHU2NCAqY250KQogewpAQCAtMTYwMSw3
ICsxNjExLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBrc3pfZGV2X29wcyBrc3o5NDc3X2Rldl9v
cHMgPSB7CiAJLnJfbWliX3BrdCA9IGtzejk0Nzdfcl9taWJfcGt0LAogCS5mcmVlemVfbWliID0g
a3N6OTQ3N19mcmVlemVfbWliLAogCS5wb3J0X2luaXRfY250ID0ga3N6OTQ3N19wb3J0X2luaXRf
Y250LAotCS5zaHV0ZG93biA9IGtzejk0NzdfcmVzZXRfc3dpdGNoLAorCS5zaHV0ZG93biA9IGtz
ejk0Nzdfc2h1dGRvd24sCiAJLmRldGVjdCA9IGtzejk0Nzdfc3dpdGNoX2RldGVjdCwKIAkuaW5p
dCA9IGtzejk0Nzdfc3dpdGNoX2luaXQsCiAJLmV4aXQgPSBrc3o5NDc3X3N3aXRjaF9leGl0LAot
LSAKMi4zMy4wCgo=
