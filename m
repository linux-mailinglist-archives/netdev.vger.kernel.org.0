Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9163327D855
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 22:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgI2Ufs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 16:35:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48362 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgI2Ufl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 16:35:41 -0400
Message-Id: <20200929202509.673358734@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601411738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=A9VmTcwkFTXzbdbbw121qWEfo2p4m5jmwhJ1CmJQMec=;
        b=dEktkI17Grpony7lZDKecnFEOdfjaxY0ryQd1B5sA+JU4DH7ltvZM5y90/S5ZbQN7kor0p
        nLbgJyFkDdibeBt0Ws0AFUWAwfpK6RKbtbq32hFBmipn16rznFFbSlROeQFlp+ycGanNWP
        QRMD1DrNO0zkyj7xOFwIs6S016IM/aeJPP/9HiWrKgxBMq9Sp/2CemfdS7b/xDowDOdaxh
        oUQcMLQPDEHoUThhcs+bMPyOJgTUxDiH6L6XKP3eajz21AjfzkSNNqe1W42cLHSqj4tk8o
        0aWkLxpZPgyBQNI6QCrDgY/PPpvKnuff2Aj0OUVYn/NAyfr2M4CjSm3+dt2zUw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601411738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=A9VmTcwkFTXzbdbbw121qWEfo2p4m5jmwhJ1CmJQMec=;
        b=pmrmwnMCbZFXDvPzt7v5jtJqkDoyPinCfkEKPf5sb51+5GYnhW1aOS8+hkZk3HEdGnrxXP
        lrF/CHb/+X9mNiBw==
Date:   Tue, 29 Sep 2020 22:25:09 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Dave Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [patch V2 00/36] net: in_interrupt() cleanup and fixes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rm9sa3MsCgppbiB0aGUgZGlzY3Vzc2lvbiBhYm91dCBwcmVlbXB0IGNvdW50IGNvbnNpc3RlbmN5
IGFjY3Jvc3Mga2VybmVsIGNvbmZpZ3VyYXRpb25zOgoKICBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9yLzIwMjAwOTE0MjA0MjA5LjI1NjI2NjA5M0BsaW51dHJvbml4LmRlLwoKTGludXMgY2xlYXJs
eSByZXF1ZXN0ZWQgdGhhdCBjb2RlIGluIGRyaXZlcnMgYW5kIGxpYnJhcmllcyB3aGljaCBjaGFu
Z2VzCmJlaGF2aW91ciBiYXNlZCBvbiBleGVjdXRpb24gY29udGV4dCBzaG91bGQgZWl0aGVyIGJl
IHNwbGl0IHVwIHNvIHRoYXQKZS5nLiB0YXNrIGNvbnRleHQgaW52b2NhdGlvbnMgYW5kIEJIIGlu
dm9jYXRpb25zIGhhdmUgZGlmZmVyZW50IGludGVyZmFjZXMKb3IgaWYgdGhhdCdzIG5vdCBwb3Nz
aWJsZSB0aGUgY29udGV4dCBpbmZvcm1hdGlvbiBoYXMgdG8gYmUgcHJvdmlkZWQgYnkgdGhlCmNh
bGxlciB3aGljaCBrbm93cyBpbiB3aGljaCBjb250ZXh0IGl0IGlzIGV4ZWN1dGluZy4KClRoaXMg
aW5jbHVkZXMgY29uZGl0aW9uYWwgbG9ja2luZywgYWxsb2NhdGlvbiBtb2RlIChHRlBfKikgZGVj
aXNpb25zIGFuZAphdm9pZGFuY2Ugb2YgY29kZSBwYXRocyB3aGljaCBtaWdodCBzbGVlcC4KCklu
IHRoZSBsb25nIHJ1biwgdXNhZ2Ugb2YgJ3ByZWVtcHRpYmxlLCBpbl8qaXJxIGV0Yy4nIHNob3Vs
ZCBiZSBiYW5uZWQgZnJvbQpkcml2ZXIgY29kZSBjb21wbGV0ZWx5LgoKVGhpcyBpcyB0aGUgc2Vj
b25kIHZlcnNpb24gb2YgdGhlIGZpcnN0IGJhdGNoIG9mIHJlbGF0ZWQgY2hhbmdlcy4gVjEgY2Fu
IGJlCmZvdW5kIGhlcmU6CgogICAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMDA5Mjcx
OTQ4NDYuMDQ1NDExMjYzQGxpbnV0cm9uaXguZGUKCkNoYW5nZXMgdnMuIFYxOgoKICAtIFJlYmFz
ZWQgdG8gbmV0LW5leHQKCiAgLSBGaXhlZCB0aGUgaGFsZiBkb25lIHJlbmFtZSBzaWxseW5lc3Mg
aW4gdGhlIEVOSUMgcGF0Y2guCgogIC0gRml4ZWQgdGhlIElPTklDIGRyaXZlciBmYWxsb3V0LgoK
ICAtIFBpY2tlZCB1cCB0aGUgU0ZDIGZpeCBmcm9tIEVkd2FyZCBhbmQgYWRqdXN0ZWQgdGhlIEdG
UF9LRVJORUwgY2hhbmdlCiAgICBhY2NvcmRpbmdseS4KCiAgLSBBZGRyZXNzZWQgdGhlIHJldmll
dyBjb21tZW50cyB2cy4gQkNSRk1BQy4KCiAgLSBDb2xsZWN0ZWQgUmV2aWV3ZWQvQWNrZWQtYnkg
dGFncyBhcyBhcHByb3ByaWF0ZS4KClRoZSBwaWxlIGlzIGFsc28gYXZhaWxhYmxlIGZyb206Cgog
ICAgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RnbHgvZGV2
ZWwuZ2l0IG5ldC9jbGVhbnVwCgpUaGFua3MsCgoJdGdseAotLS0KIERvY3VtZW50YXRpb24vbmV0
d29ya2luZy9jYWlmL3NwaV9wb3J0aW5nLnJzdCAgICAgICAgICAgICAgICAgICB8ICAyMjkgLS0K
IGIvRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2NhaWYvaW5kZXgucnN0ICAgICAgICAgICAgICAg
ICAgICAgICB8ICAgIDEgCiBiL2RyaXZlcnMvbmV0L2NhaWYvS2NvbmZpZyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDE5IAogYi9kcml2ZXJzL25ldC9jYWlmL01ha2Vm
aWxlICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgNCAKIGIvZHJpdmVy
cy9uZXQvY2FpZi9jYWlmX2hzaS5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
ICAgMTkgCiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FtZC9zdW4zbGFuY2UuYyAgICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgIDExIAogYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hdGhlcm9zL2F0
bDFjL2F0bDFjX21haW4uYyAgICAgICAgICAgICAgIHwgICAgMSAKIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvYXRoZXJvcy9hdGwxZS9hdGwxZV9tYWluLmMgICAgICAgICAgICAgICB8ICAgIDIgCiBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2F0aGVyb3MvYXRseC9hdGwyLmMgICAgICAgICAgICAgICAg
ICAgICAgfCAgICAxIAogYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jaGVsc2lvL2N4Z2IzL2FkYXB0
ZXIuaCAgICAgICAgICAgICAgICAgIHwgICAgMSAKIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2hl
bHNpby9jeGdiMy9jeGdiM19tYWluLmMgICAgICAgICAgICAgICB8ICAgIDIgCiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2NoZWxzaW8vY3hnYjMvc2dlLmMgICAgICAgICAgICAgICAgICAgICAgfCAg
IDQ0IAogYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jaGVsc2lvL2N4Z2I0L3NnZS5jICAgICAgICAg
ICAgICAgICAgICAgIHwgICAgMyAKIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2lzY28vZW5pYy9l
bmljLmggICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDEgCiBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2Npc2NvL2VuaWMvZW5pY19hcGkuYyAgICAgICAgICAgICAgICAgICAgfCAgICA2IAogYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9jaXNjby9lbmljL2VuaWNfbWFpbi5jICAgICAgICAgICAgICAg
ICAgIHwgICAyNyAKIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tcGM1Mnh4
LmMgICAgICAgICAgICAgICAgICB8ICAgMTAgCiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2UxMDAuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICA0IAogYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9lMTAwMC9lMTAwMF9tYWluLmMgICAgICAgICAgICAgICAgIHwgICAg
MSAKIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZm0xMGsvZm0xMGtfcGNpLmMgICAgICAg
ICAgICAgICAgICB8ICAgIDIgCiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQw
ZV9tYWluLmMgICAgICAgICAgICAgICAgICAgfCAgICA0IAogYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pY2UvaWNlX21haW4uYyAgICAgICAgICAgICAgICAgICAgIHwgICAgMSAKIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9tYWluLmMgICAgICAgICAgICAgICAgICAg
ICB8ICAgIDEgCiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2lnYy9pZ2NfbWFpbi5jICAg
ICAgICAgICAgICAgICAgICAgfCAgICAxIAogYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9p
eGdiZS9peGdiZV9tYWluLmMgICAgICAgICAgICAgICAgIHwgICAgMSAKIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvaW50ZWwvaXhnYmV2Zi9peGdiZXZmX21haW4uYyAgICAgICAgICAgICB8ICAgIDIg
CiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L25hdHNlbWkvc29uaWMuYyAgICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgIDI0IAogYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9uYXRzZW1pL3NvbmljLmgg
ICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMiAKIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bmV0ZXJpb24vdnhnZS92eGdlLWNvbmZpZy5jICAgICAgICAgICAgICB8ICAgIDkgCiBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L25ldGVyaW9uL3Z4Z2UvdnhnZS1jb25maWcuaCAgICAgICAgICAgICAg
fCAgICA3IAogYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9wZW5zYW5kby9pb25pYy9pb25pY19kZXYu
YyAgICAgICAgICAgICAgIHwgICAgMiAKIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcGVuc2FuZG8v
aW9uaWMvaW9uaWNfbGlmLmMgICAgICAgICAgICAgICB8ICAgNjQgCiBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3BlbnNhbmRvL2lvbmljL2lvbmljX2xpZi5oICAgICAgICAgICAgICAgfCAgICAyIAog
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9wZW5zYW5kby9pb25pYy9pb25pY19tYWluLmMgICAgICAg
ICAgICAgIHwgICAgNCAKIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmMTAuYyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgMjQgCiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Nm
Yy9lZnhfY29tbW9uLmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAyIAogYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9zZmMvbmV0X2RyaXZlci5oICAgICAgICAgICAgICAgICAgICAgICAgIHwg
ICAgNSAKIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL25pY19jb21tb24uaCAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICAgIDcgCiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N1bi9zdW5ibWFj
LmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDE4IAogYi9kcml2ZXJzL25ldC9waHkv
bWRpb19idXMuYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAxNSAKIGIv
ZHJpdmVycy9uZXQvdXNiL2thd2V0aC5jICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB8ICAyNjEgLS0KIGIvZHJpdmVycy9uZXQvdXNiL25ldDEwODAuYyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAgIDEgCiBiL2RyaXZlcnMvbmV0L3dhbi9sbWMvbG1j
X2RlYnVnLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgIDE4IAogYi9kcml2ZXJz
L25ldC93YW4vbG1jL2xtY19kZWJ1Zy5oICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwg
ICAgMSAKIGIvZHJpdmVycy9uZXQvd2FuL2xtYy9sbWNfbWFpbi5jICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB8ICAxMDUgLQogYi9kcml2ZXJzL25ldC93YW4vbG1jL2xtY19tZWRpYS5j
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgNCAKIGIvZHJpdmVycy9uZXQvd2Fu
L2xtYy9sbWNfcHJvdG8uYyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMTYgCiBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9iY2RjLmMg
ICAgICAgfCAgICA0IAogYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEv
YnJjbWZtYWMvYmNtc2RoLmMgICAgIHwgICAgNCAKIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJv
YWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2J1cy5oICAgICAgICB8ICAgIDMgCiBiL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jb3JlLmMgICAgICAgfCAg
IDI2IAogYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMv
Y29yZS5oICAgICAgIHwgICAgMiAKIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJj
bTgwMjExL2JyY21mbWFjL2Z3ZWguYyAgICAgICB8ICAgIDggCiBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9md2VoLmggICAgICAgfCAgICA3IAogYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvZndzaWduYWwu
YyAgIHwgICAxMCAKIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2Jy
Y21mbWFjL2Z3c2lnbmFsLmggICB8ICAgIDIgCiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2Fk
Y29tL2JyY204MDIxMS9icmNtZm1hYy9tc2didWYuYyAgICAgfCAgICA3IAogYi9kcml2ZXJzL25l
dC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvcHJvdG8uaCAgICAgIHwgICAg
NiAKIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3Nk
aW8uYyAgICAgICB8ICAgIDggCiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204
MDIxMS9icmNtZm1hYy9zZGlvLmggICAgICAgfCAgICAyIAogYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvdXNiLmMgICAgICAgIHwgICAgMiAKIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXB3MngwMC9pcHcyMTAwLmMgICAgICAgICAgICAgICAg
ICB8ICAgIDMgCiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2lwdzJ4MDAvaXB3MjIwMC5o
ICAgICAgICAgICAgICAgICAgfCAgICA2IAogYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9p
cHcyeDAwL2xpYmlwdy5oICAgICAgICAgICAgICAgICAgIHwgICAgMyAKIGIvZHJpdmVycy9uZXQv
d2lyZWxlc3MvaW50ZWwvaXdsZWdhY3kvY29tbW9uLmggICAgICAgICAgICAgICAgICB8ICAgIDQg
CiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvaXdsLWRlYnVnLmMgICAgICAg
ICAgICAgICAgfCAgICA1IAogYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL2l3
bC1kZXZ0cmFjZS1tc2cuaCAgICAgICAgIHwgICAgNiAKIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
aW50ZXJzaWwvaG9zdGFwL2hvc3RhcF9ody5jICAgICAgICAgICAgICB8ICAgMTIgCiBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbGliZXJ0YXMvZGVmcy5oICAgICAgICAgICAgICAgICAg
fCAgICAzIAogYi9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL2xpYmVydGFzL3J4LmMgICAg
ICAgICAgICAgICAgICAgIHwgICAxMSAKIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9s
aWJlcnRhc190Zi9kZWJfZGVmcy5oICAgICAgICAgICB8ICAgIDMgCiBiL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL21hcnZlbGwvbXdpZmlleC91YXBfdHhyeC5jICAgICAgICAgICAgICAgfCAgICA2IAog
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvdXRpbC5jICAgICAgICAgICAg
ICAgICAgIHwgICAgNiAKIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2Jh
c2UuYyAgICAgICAgICAgICAgICAgICB8ICAgNDcgCiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnRsd2lmaS9iYXNlLmggICAgICAgICAgICAgICAgICAgfCAgICAzIAogYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYnRjb2V4aXN0L2hhbGJ0Y291dHNyYy5jIHwg
ICAxMiAKIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL2NvcmUuYyAgICAg
ICAgICAgICAgICAgICB8ICAgIDYgCiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRs
d2lmaS9kZWJ1Zy5jICAgICAgICAgICAgICAgICAgfCAgIDIwIAogYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9yZWFsdGVrL3J0bHdpZmkvZGVidWcuaCAgICAgICAgICAgICAgICAgIHwgICAgOCAKIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3BjaS5jICAgICAgICAgICAgICAg
ICAgICB8ICAgIDQgCiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9wcy5j
ICAgICAgICAgICAgICAgICAgICAgfCAgIDI3IAogYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFs
dGVrL3J0bHdpZmkvcHMuaCAgICAgICAgICAgICAgICAgICAgIHwgICAxMCAKIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3dpZmkuaCAgICAgICAgICAgICAgICAgICB8ICAg
IDMgCiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3p5ZGFzL3pkMTIxMXJ3L3pkX3VzYi5jICAgICAg
ICAgICAgICAgICAgfCAgICAxIAogYi9pbmNsdWRlL2xpbnV4L25ldGRldmljZS5oICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgMSAKIGIvbmV0L2NvcmUvZGV2LmMgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMTUgCiBkcml2
ZXJzL25ldC9jYWlmL2NhaWZfc3BpLmMgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgfCAgODc0IC0tLS0tLS0tLS0KIGRyaXZlcnMvbmV0L2NhaWYvY2FpZl9zcGlfc2xhdmUuYyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAyNTQgLS0KIGluY2x1ZGUvbmV0L2NhaWYv
Y2FpZl9zcGkuaCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAxNTUgLQog
ODkgZmlsZXMgY2hhbmdlZCwgMzU0IGluc2VydGlvbnMoKyksIDIyMzQgZGVsZXRpb25zKC0pCgo=
