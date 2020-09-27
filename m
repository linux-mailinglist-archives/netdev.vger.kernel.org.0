Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121E927A427
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgI0U5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgI0U5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 16:57:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051F0C0613CE;
        Sun, 27 Sep 2020 13:57:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AF20A13BB5083;
        Sun, 27 Sep 2020 13:40:20 -0700 (PDT)
Date:   Sun, 27 Sep 2020 13:57:07 -0700 (PDT)
Message-Id: <20200927.135707.1699954431349573308.davem@davemloft.net>
To:     tglx@linutronix.de
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        torvalds@linuxfoundation.org, paulmck@kernel.org,
        willy@infradead.org, benve@cisco.com, _govind@gmx.com,
        kuba@kernel.org, netdev@vger.kernel.org, corbet@lwn.net,
        mchehab+huawei@kernel.org, linux-doc@vger.kernel.org,
        bigeasy@linutronix.de, luc.vanoostenryck@gmail.com,
        jcliburn@gmail.com, chris.snook@gmail.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        snelson@pensando.io, drivers@pensando.io, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        tsbogend@alpha.franken.de, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com, jdmason@kudzu.us,
        dsd@gentoo.org, kune@deine-taler.de, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, arend.vanspriel@broadcom.com,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, stas.yakovlev@gmail.com,
        stf_xl@wp.pl, johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linuxwifi@intel.com
Subject: Re: [patch 00/35] net: in_interrupt() cleanup and fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200927194846.045411263@linutronix.de>
References: <20200927194846.045411263@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 27 Sep 2020 13:40:22 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+DQpEYXRlOiBTdW4sIDI3
IFNlcCAyMDIwIDIxOjQ4OjQ2ICswMjAwDQoNCj4gaW4gdGhlIGRpc2N1c3Npb24gYWJvdXQgcHJl
ZW1wdCBjb3VudCBjb25zaXN0ZW5jeSBhY2Nyb3NzIGtlcm5lbCBjb25maWd1cmF0aW9uczoNCg0K
UGxlYXNlIHJlc3BpbiB0aGlzIGFnYWluc3QgbmV0LW5leHQsIHNvbWUgb2YgdGhlIHBhdGNoZXMg
aW4gaGVyZSBhcmUgYWxyZWFkeQ0KaW4gbmV0LW5leHQgKHRoZSB3aXJlbGVzcyBkZWJ1ZyBtYWNy
byBvbmUpIGFuZCBldmVuIGFmdGVyIHRoYXQgdGhlIHNlcmllcw0KZG9lc24ndCBidWlsZDoNCg0K
ZHJpdmVycy9uZXQvZXRoZXJuZXQvY2lzY28vZW5pYy9lbmljX21haW4uYzogSW4gZnVuY3Rpb24g
oWVuaWNfcmVzZXSiOg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvY2lzY28vZW5pYy9lbmljX21haW4u
YzoyMzE1OjI6IGVycm9yOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBmdW5jdGlvbiChZW5pY19z
ZXRfYXBpX3N0YXRlojsgZGlkIHlvdSBtZWFuIKFlbmljX3NldF9hcGlfYnVzeaI/IFstV2Vycm9y
PWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uXQ0KIDIzMTUgfCAgZW5pY19zZXRfYXBpX3N0
YXRlKGVuaWMsIHRydWUpOw0KICAgICAgfCAgXn5+fn5+fn5+fn5+fn5+fn5+DQogICAgICB8ICBl
bmljX3NldF9hcGlfYnVzeQ0KQXQgdG9wIGxldmVsOg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvY2lz
Y28vZW5pYy9lbmljX21haW4uYzoyMjk4OjEzOiB3YXJuaW5nOiChZW5pY19zZXRfYXBpX2J1c3mi
IGRlZmluZWQgYnV0IG5vdCB1c2VkIFstV3VudXNlZC1mdW5jdGlvbl0NCiAyMjk4IHwgc3RhdGlj
IHZvaWQgZW5pY19zZXRfYXBpX2J1c3koc3RydWN0IGVuaWMgKmVuaWMsIGJvb2wgYnVzeSkNCiAg
ICAgIHwgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fn4NCg==
