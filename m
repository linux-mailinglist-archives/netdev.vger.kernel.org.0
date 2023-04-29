Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C3A6F22B6
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 05:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347165AbjD2DhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 23:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjD2DhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 23:37:20 -0400
Received: from m135.mail.163.com (m135.mail.163.com [220.181.13.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0DB432699;
        Fri, 28 Apr 2023 20:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
        Message-ID; bh=MjceFRfW62F8aqG76hi8GgFL21E5WvLsrnEWF8rmzUY=; b=F
        odRA6kIZ61IAHcohuz+FkqE0WqhL+HAPSC+iLNKj6J9OX1LE/NDvB3PZiIyJCCGM
        E89r7BLjl5i6nTxprPv5uZqEuv6qUBX/i/vDphR8VaAkpZCEFtOxESfvT0Qixrw7
        ur4/HOzS2avfa4ykUExo8A37inssY+Lfk1z5krSa3w=
Received: from luyun_611$163.com ( [116.128.244.169] ) by
 ajax-webmail-wmsvr5 (Coremail) ; Sat, 29 Apr 2023 11:35:31 +0800 (CST)
X-Originating-IP: [116.128.244.169]
Date:   Sat, 29 Apr 2023 11:35:31 +0800 (CST)
From:   "Yun Lu" <luyun_611@163.com>
To:     "Larry Finger" <Larry.Finger@lwfinger.net>
Cc:     Jes.Sorensen@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re:Re: [PATCH] wifi: rtl8xxxu: fix authentication timeout due to
 incorrect RCR value
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20230109(dcb5de15)
 Copyright (c) 2002-2023 www.mailtech.cn 163com
In-Reply-To: <d3743b66-23b1-011c-9dcd-c408b1963fca@lwfinger.net>
References: <20230427020512.1221062-1-luyun_611@163.com>
 <866570c9-38d8-1006-4721-77e2945170b9@lwfinger.net>
 <76a784b2.2cb3.187c60f0f68.Coremail.luyun_611@163.com>
 <d3743b66-23b1-011c-9dcd-c408b1963fca@lwfinger.net>
X-NTES-SC: AL_QuyTAPuYtkso5yWfZekXnUYWhOk5W8K0ufQg3IJTN5E0uCnB6iUjR35GB2fHwOiIMx+LsRmGSjl81ORncYtjWZvPEoTe0xRwoeQKzzOXevAR
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <62d9fe90.63b.187cb1481f8.Coremail.luyun_611@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: BcGowADn70+EkExkyaMLAA--.44748W
X-CM-SenderInfo: pox130jbwriqqrwthudrp/1tbiFQRgzl5mPYwCEgAAsm
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QXQgMjAyMy0wNC0yOSAwMTowNjowMywgIkxhcnJ5IEZpbmdlciIgPExhcnJ5LkZpbmdlckBsd2Zp
bmdlci5uZXQ+IHdyb3RlOgo+T24gNC8yNy8yMyAyMzoxMSwgd28gd3JvdGU6Cj4+IFvCoCAxNDku
NTk1NjQyXSBbcGlkOjcsY3B1Nixrd29ya2VyL3UxNjowLDBdQkVGT1JFOiBSRUdfUkNSIGRpZmZl
cnMgZnJvbSByZWdyY3I6IAo+PiAweDE4MzA2MTMgaW5zdGVkIG9mIDB4NzAwMDYwNGUKPj4gW8Kg
IDE2MC42NzY0MjJdIFtwaWQ6MjM3LGNwdTYsa3dvcmtlci91MTY6NSwzXUJFRk9SRTogUkVHX1JD
UiBkaWZmZXJzIGZyb20gCj4+IHJlZ3JjcjogMHg3MDAwNjAwOSBpbnN0ZWQgb2YgMHg3MDAwNjBj
ZQo+ID4gWyAgMzI3LjIzNDU4OF0gW3BpZDo3LGNwdTcsa3dvcmtlci91MTY6MCw1XUJFRk9SRTog
UkVHX1JDUiBkaWZmZXJzIGZyb20gCj5yZWdyY3I6IDB4MTgzMGQzMyBpbnN0ZWQgb2YgMHg3MDAw
NjA0ZQo+Cj4KPk15IHBhdGNoIHdhcyBtZXNzZWQgdXAsIGJ1dCBpdCBnb3QgdGhlIGluZm9ybWF0
aW9uIHRoYXQgSSB3YW50ZWQsIHdoaWNoIGlzIHNob3duIAo+aW4gdGhlIHF1b3RlZCBsaW5lcyBh
Ym92ZS4gT25lIG9mIHRoZXNlIGRpZmZlcnMgb25seSBpbiB0aGUgbG93LW9yZGVyIGJ5dGUsIAo+
d2hpbGUgdGhlIG90aGVyIDIgYXJlIGNvbXBsZXRlbHkgZGlmZmVyZW50LiBTdHJhbmdlIQo+Cj5J
dCBpcyBwb3NzaWJsZSB0aGF0IHRoZXJlIGlzIGEgZmlybXdhcmUgZXJyb3IuIE15IHN5c3RlbSwg
d2hpY2ggZG9lcyBub3Qgc2hvdyAKPnRoZSBwcm9ibGVtLCByZXBvcnRzIHRoZSBmb2xsb3dpbmc6
Cj4KPls1NDEzMC43NDExNDhdIHVzYiAzLTY6IFJUTDgxOTJDVSByZXYgQSAoVFNNQykgcm9tdmVy
IDAsIDJUMlIsIFRYIHF1ZXVlcyAyLCAKPldpRmk9MSwgQlQ9MCwgR1BTPTAsIEhJIFBBPTAKPls1
NDEzMC43NDExNTNdIHVzYiAzLTY6IFJUTDgxOTJDVSBNQUM6IHh4Onh4Onh4Onh4Onh4Onh4Cj5b
NTQxMzAuNzQxMTU1XSB1c2IgMy02OiBydGw4eHh4dTogTG9hZGluZyBmaXJtd2FyZSBydGx3aWZp
L3J0bDgxOTJjdWZ3X1RNU0MuYmluCj5bNTQxMzAuNzQyMzAxXSB1c2IgMy02OiBGaXJtd2FyZSBy
ZXZpc2lvbiA4OC4yIChzaWduYXR1cmUgMHg4OGMxKQo+Cj5XaGljaCBmaXJtd2FyZSBkb2VzIHlv
dXIgdW5pdCB1c2U/CgpUaGUgZmlybXdhcmUgdmVyaW9uIHdlIHVzZWQgaXMgODAuMCAoc2lnbmF0
dXJlIDB4ODhjMSkKIFsgIDkwMy44NzMxMDddIFtwaWQ6MTQsY3B1MCxrd29ya2VyLzA6MSwyXXVz
YiAxLTEuMjogUlRMODE5MkNVIHJldiBBIChUU01DKSAyVDJSLCBUWCBxdWV1ZXMgMiwgV2lGaT0x
LCBCVD0wLCBHUFM9MCwgSEkgUEE9MApbICA5MDMuODczMTM4XSBbcGlkOjE0LGNwdTAsa3dvcmtl
ci8wOjEsM111c2IgMS0xLjI6IFJUTDgxOTJDVSBNQUM6IDA4OmJlOnh4Onh4Onh4Onh4ClsgIDkw
My44NzMxMzhdIFtwaWQ6MTQsY3B1MCxrd29ya2VyLzA6MSw0XXVzYiAxLTEuMjogcnRsOHh4eHU6
IExvYWRpbmcgZmlybXdhcmUgcnRsd2lmaS9ydGw4MTkyY3Vmd19UTVNDLmJpbgpbICA5MDMuODcz
NDc0XSBbcGlkOjE0LGNwdTAsa3dvcmtlci8wOjEsNV11c2IgMS0xLjI6IEZpcm13YXJlIHJldmlz
aW9uIDgwLjAgKHNpZ25hdHVyZSAweDg4YzEpCgo+Cj5BdHRhY2hlZCBpcyBhIG5ldyB0ZXN0IHBh
dGNoLiBXaGVuIGl0IGxvZ3MgYSBDT1JSVVBURUQgdmFsdWUsIEkgd291bGQgbGlrZSB0byAKPmtu
b3cgd2hhdCB0YXNrIGlzIGF0dGFjaGVkIHRvIHRoZSBwaWQgbGlzdGVkIGluIHRoZSBtZXNzYWdl
LiBOb3RlIHRoYXQgdGhlIHR3byAKPmluc3RhbmNlcyB3aGVyZSB0aGUgZW50aXJlIHdvcmQgd2Fz
IHdyb25nIGNhbWUgZnJvbSBwaWQ6Ny4KPgo+Q291bGQgaW1wcm9wZXIgbG9ja2luZyBjb3VsZCBw
cm9kdWNlIHRoZXNlIHJlc3VsdHM/Cj4KPkxhcnJ5CgpBcHBseSB5b3VyIG5ldyBwYXRjaCwgdGhl
biB0dXJuIG9uL29mZiB0aGUgd2lyZWxlc3MgbmV0d29yayBzd2l0Y2ggb24gdGhlIG5ldHdvcmsg
Y29udHJvbCBwYW5lbCBzZXJ2ZXJsIGxvb3BzLgpUaGUgbG9nIHNob3dzOgpbICAgODUuMzg0NDI5
XSBbcGlkOjIyMSxjcHU2LGt3b3JrZXIvdTE2OjYsNV1SRUdfUkNSIGNvcnJ1cHRlZCBpbiBydGw4
eHh4dV9jb25maWd1cmVfZmlsdGVyOiAweDcwMDA2MDA5IGluc3RlZCBvZiAweDcwMDA2MGNlClsg
IDEyMS42ODE5NzZdIFtwaWQ6MjE2LGNwdTYsa3dvcmtlci91MTY6MywwXVJFR19SQ1IgY29ycnVw
dGVkIGluIHJ0bDh4eHh1X2NvbmZpZ3VyZV9maWx0ZXI6IDB4NzAwMDYwMDkgaW5zdGVkIG9mIDB4
NzAwMDYwY2UKWyAgMTQ0LjQxNjk5Ml0gW3BpZDoyMTcsY3B1Nixrd29ya2VyL3UxNjo0LDFdUkVH
X1JDUiBjb3JydXB0ZWQgaW4gcnRsOHh4eHVfY29uZmlndXJlX2ZpbHRlcjogMHg3MDAwNjAwOSBp
bnN0ZWQgb2YgMHg3MDAwNjBjZQoKQW5kIGlmIHdlIHVwL2Rvd24gdGhlIGludGVyZmFjZSBzZXJ2
ZXJsIGxvb3BzIGFzIGZvbGxvd3M6CmlmY29uZmlnIHdseDA4YmV4eHh4eHggZG93bgpzbGVlcCAx
CmlmY29uZmlnIHdseDA4YmV4eHh4eHggdXAKc2xlZXAgMTAKVGhlIGxvZyBzaG93czoKWyAgMjgy
LjExMjMzNV0gWzIwMjM6MDQ6MjkgMTA6MzA6MzRdW3BpZDo5NSxjcHU2LGt3b3JrZXIvdTE2OjEs
M11SRUdfUkNSIGNvcnJ1cHRlZCBpbiBydGw4eHh4dV9jb25maWd1cmVfZmlsdGVyOiAweDE4MzJl
MTMgaW5zdGVkIG9mIDB4NzAwMDYwNGUKWyAgMjkzLjMxMTQ2Ml0gWzIwMjM6MDQ6MjkgMTA6MzA6
NDVdW3BpZDoyMTcsY3B1Nyxrd29ya2VyL3UxNjo0LDldUkVHX1JDUiBjb3JydXB0ZWQgaW4gcnRs
OHh4eHVfY29uZmlndXJlX2ZpbHRlcjogMHgxODMwZTcyIGluc3RlZCBvZiAweDcwMDA2MDRlClsg
IDMwNC40MzUwODldIFsyMDIzOjA0OjI5IDEwOjMwOjU2XVtwaWQ6MjE3LGNwdTYsa3dvcmtlci91
MTY6NCw5XVJFR19SQ1IgY29ycnVwdGVkIGluIHJ0bDh4eHh1X2NvbmZpZ3VyZV9maWx0ZXI6IDB4
MTgzMGVkMyBpbnN0ZWQgb2YgMHg3MDAwNjA0ZQpbICAzMTUuNTMyMjU3XSBbMjAyMzowNDoyOSAx
MDozMTowN11bcGlkOjk1LGNwdTcsa3dvcmtlci91MTY6MSw4XVJFR19SQ1IgY29ycnVwdGVkIGlu
IHJ0bDh4eHh1X2NvbmZpZ3VyZV9maWx0ZXI6IDB4NzAwMDYwNGUgaW5zdGVkIG9mIDB4NzAwMDYw
NGUKWyAgMzI0LjExNDM3OV0gWzIwMjM6MDQ6MjkgMTA6MzE6MTZdW3BpZDoyMjEsY3B1Nixrd29y
a2VyL3UxNjo2LDddUkVHX1JDUiBjb3JydXB0ZWQgaW4gcnRsOHh4eHVfY29uZmlndXJlX2ZpbHRl
cjogMHgxODMyZTE0IGluc3RlZCBvZiAweDcwMDA2MDRlCgpXZSBhbHNvIHVwZGF0ZSB0aGUgIGZp
cm13YXJlIHZlcmlvbiB0byA4OC4yLCBhbmQgdGhlIHRlc3QgcmVzdWx0cyBhcmUgdGhlIHNhbWUg
YXMgYWJvdmUuCgpUaGFuayB5b3UgZm9yIGhlbHBpbmcgZGVidWcgdGhpcyBpc3N1ZSwgd2hpY2gg
c2VlbXMgdG8gYmUgcmVsYXRlZCB0byBzcGVjaWZpYyBkZXZpY2VzLgoKWXVuIEx1CgoKCgo=
