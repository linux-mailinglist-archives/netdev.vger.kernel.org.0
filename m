Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A483C8B83
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 21:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240144AbhGNTVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 15:21:16 -0400
Received: from mout.gmx.net ([212.227.15.18]:48889 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhGNTVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 15:21:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626290287;
        bh=0Vu294fMLWIi7gFkQR70Ggc20BScAncxP5pTxianCVo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=QLHTr+1KaDMeaIooUyH6iPx6kKaUUXbvZ9290LCAN0rZWfYJnObH8KTsPxpEjKkw1
         OGUdDUTTSMQp4VVPCE7PWIUb0ks82jg2X8zMzzENm7rVOpix9fZ3ku87j2852FVqVx
         5CLlvdV4ypEd/PzBlmzJqCYMSIckFgbzHOzYCwGY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([149.172.237.67]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MWRRZ-1lejeW1jWF-00XvkV; Wed, 14
 Jul 2021 21:18:07 +0200
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     woojung.huh@microchip.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware process the layer 4 checksum
Date:   Wed, 14 Jul 2021 21:17:23 +0200
Message-Id: <20210714191723.31294-3-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:JCoB5BM+Bai/xCSzcnAL1DpJwVTKmW5Z3yW1PB+KpAG290y0d/2
 nsDriOHoXw8vLXrLGyqKwZJX7CpsFKZUIY41S1ydmFF1CIAhg6tHUqFFE340YBg+uftBTgY
 ilN55HxyelA7ZZAiPyykc0Zq5XQkPD2lRi2ozjqtUaBk3rJb1vAAUqkwTZGkJ4TWZLzU0dH
 lzwcvFsCy6S9gv5qFnQ7w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Dy0uXD9Ok10=:D3rSzTC6gEaoRX4EfHM7xC
 RJonplED3trLlh7qeMMCKBIEF9MdfWCe/divPw1ewAwaTbj4ZqazDXG5qJaLX29o27zXeWhvy
 8wFFHRsBpWN6jcMJF/FNFsaw7lNWT7kYRnvh1AY2fRGU0UakrmHmzbRwE0xr09VxMyHhcE5Ak
 mxrl3nsXJ5n5YzX/AIL1BdZaF6Lp+uVoFz//YRv2cDSPIJ42TRVeKJHMq5bm4L3M+HTsPmRZA
 dQO1FoO8uzGhnTRGUAebZu3Zl1JFFa/mraN+arWdPcj1q//9h8jvCsIIGc1zL4/FZw6C7di1n
 xM3TayDXRMWDVj0gvq7Cu8n60JsyLbD7kHicZ83merUjaxygf2LFnBRyzoY8uMlDnZ+OKPbra
 1vgJTRHHlk/J9C0rz6OABSqbudqQjRI269OtrpcU0xTTLMo3/T15Pqxs6BbtqawJiW+JonsoF
 i1ZfA3Q6Cndb7QHKu4z1WIRpGwkb+Y7Q3AI8CTmFkQSqOlZcPIV4NJNgyTP7CshpgvGl7GMVk
 sz0XDJNpsWSZMK/T8DaySGCdl4ajS/sRu0JoIIQnaB87sFHJ894Y3EdspIYMsgGwSah2YHqVV
 VnFX35OL5mr9LYGv92lm18olFAJlMo/82ZGFZUUk83PrJfEkEW8M/ggsiAxSNJVX3napGCFFA
 UQYR5/HPhMUysE7dscttak8qlMC7NoGOguqZ+a/29rAe3E+TfPI9s4DuCLHdStSUmls5xhTvf
 T9krDnnFtRoHkrEpBVC/odCcEiZMz0BzeXOEJdazvhKGx9BjDJCBdufCwUtQdz7XXBcVx2UVy
 Sf/O94ILGXaM6nIa7u6jHtkKUZlpdARBrs7mSPGcO62+3BbcIfdCUitaP+ntfUVpXWfXrI4mY
 1gJr60cSEEM+jjwMMHgGlldhA/RTQYZtTrWDi9YeEUTB5a3B/xiKeWvgnwQNROfy2yuokYg5l
 zDJ6KFiWjzAhZuK/2bnkwnST7joDI2EpTfsWY8j3RlWxQFPlyFDxT7IDrpp4+dOb1gTFD2vsW
 hwtx0KtQGItAw2H7IgpwYfKbq35BtG1IGWM1ArOScDGM7MroPgTDrfX9K5f2l2rSAZUbOFDGI
 h5FGQ7yao+gy34MUm7CtdmfX/S3zQ9biyyr+T/cZgi7GvYeyoXGp+TtLw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SWYgdGhlIGNoZWNrc3VtIGNhbGN1bGF0aW9uIGlzIG9mZmxvYWRlZCB0byB0aGUgbmV0d29yayBk
ZXZpY2UgKGUuZyBkdWUgdG8KTkVUSUZfRl9IV19DU1VNIGluaGVyaXRlZCBmcm9tIHRoZSBEU0Eg
bWFzdGVyIGRldmljZSksIHRoZSBjYWxjdWxhdGVkCmxheWVyIDQgY2hlY2tzdW0gaXMgaW5jb3Jy
ZWN0LiBUaGlzIGlzIHNpbmNlIHRoZSBEU0EgdGFnIHdoaWNoIGlzIHBsYWNlZAphZnRlciB0aGUg
bGF5ZXIgNCBkYXRhIGlzIHNlZW4gYXMgYSBwYXJ0IG9mIHRoZSBkYXRhIHBvcnRpb24gYW5kIHRo
dXMKZXJyb3JuZW91c2x5IGluY2x1ZGVkIGludG8gdGhlIGNoZWNrc3VtIGNhbGN1bGF0aW9uLgpU
byBhdm9pZCB0aGlzLCBhbHdheXMgY2FsY3VsYXRlIHRoZSBsYXllciA0IGNoZWNrc3VtIGluIHNv
ZnR3YXJlLgoKU2lnbmVkLW9mZi1ieTogTGlubyBTYW5maWxpcHBvIDxMaW5vU2FuZmlsaXBwb0Bn
bXguZGU+Ci0tLQogbmV0L2RzYS90YWdfa3N6LmMgfCA5ICsrKysrKysrKwogMSBmaWxlIGNoYW5n
ZWQsIDkgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL25ldC9kc2EvdGFnX2tzei5jIGIvbmV0
L2RzYS90YWdfa3N6LmMKaW5kZXggMzY0ZjUwOWQ3Y2Q3Li5kNTlmMGU3MDE5ZTIgMTAwNjQ0Ci0t
LSBhL25ldC9kc2EvdGFnX2tzei5jCisrKyBiL25ldC9kc2EvdGFnX2tzei5jCkBAIC01Niw2ICs1
Niw5IEBAIHN0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAqa3N6ODc5NV94bWl0KHN0cnVjdCBza19idWZm
ICpza2IsIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpCiAJaWYgKHNrYl9saW5lYXJpemUoc2tiKSkK
IAkJcmV0dXJuIE5VTEw7CiAKKwlpZiAoc2tiLT5pcF9zdW1tZWQgPT0gQ0hFQ0tTVU1fUEFSVElB
TCAmJiBza2JfY2hlY2tzdW1faGVscChza2IpKQorCQlyZXR1cm4gTlVMTDsKKwogCS8qIFRhZyBl
bmNvZGluZyAqLwogCXRhZyA9IHNrYl9wdXQoc2tiLCBLU1pfSU5HUkVTU19UQUdfTEVOKTsKIAlh
ZGRyID0gc2tiX21hY19oZWFkZXIoc2tiKTsKQEAgLTEyMCw2ICsxMjMsOSBAQCBzdGF0aWMgc3Ry
dWN0IHNrX2J1ZmYgKmtzejk0NzdfeG1pdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCWlmIChza2Jf
bGluZWFyaXplKHNrYikpCiAJCXJldHVybiBOVUxMOwogCisJaWYgKHNrYi0+aXBfc3VtbWVkID09
IENIRUNLU1VNX1BBUlRJQUwgJiYgc2tiX2NoZWNrc3VtX2hlbHAoc2tiKSkKKwkJcmV0dXJuIE5V
TEw7CisKIAkvKiBUYWcgZW5jb2RpbmcgKi8KIAl0YWcgPSBza2JfcHV0KHNrYiwgS1NaOTQ3N19J
TkdSRVNTX1RBR19MRU4pOwogCWFkZHIgPSBza2JfbWFjX2hlYWRlcihza2IpOwpAQCAtMTczLDYg
KzE3OSw5IEBAIHN0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAqa3N6OTg5M194bWl0KHN0cnVjdCBza19i
dWZmICpza2IsCiAJaWYgKHNrYl9saW5lYXJpemUoc2tiKSkKIAkJcmV0dXJuIE5VTEw7CiAKKwlp
ZiAoc2tiLT5pcF9zdW1tZWQgPT0gQ0hFQ0tTVU1fUEFSVElBTCAmJiBza2JfY2hlY2tzdW1faGVs
cChza2IpKQorCQlyZXR1cm4gTlVMTDsKKwogCS8qIFRhZyBlbmNvZGluZyAqLwogCXRhZyA9IHNr
Yl9wdXQoc2tiLCBLU1pfSU5HUkVTU19UQUdfTEVOKTsKIAlhZGRyID0gc2tiX21hY19oZWFkZXIo
c2tiKTsKLS0gCjIuMzIuMAoK
