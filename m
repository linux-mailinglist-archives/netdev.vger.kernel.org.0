Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7219DB7F16
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 18:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404358AbfISQaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 12:30:07 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:46826 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404350AbfISQaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 12:30:07 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Sep 2019 12:30:05 EDT
Received: from mail.natalenko.name (vulcan.natalenko.name [IPv6:fe80::5400:ff:fe0c:dfa0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id C32835E2612;
        Thu, 19 Sep 2019 18:24:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1568910244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IsJrJR9edgNTBA9PLlDz/xnT9d6f7b7QwgTsriOltYw=;
        b=loWH/WDtnkYFpLIMhrxFmREeM4c/QkbSVWkZLi5MIJIA9yKvnReyF/jZVGKgWlxwY0Q6KB
        tSK3cpWu8XmKzBZyXBj4nfoU5yN+l1bmqGKqq1MMmNryawRUK+M5LEYaBeYX796Q6yKpIq
        l5ybNtGzt+SKM37Zrkrv2VSS1KyDA/4=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 19 Sep 2019 18:24:04 +0200
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     linux-mediatek@lists.infradead.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: mt76x2e hardware restart
Message-ID: <deaafa7a3e9ea2111ebb5106430849c6@natalenko.name>
X-Sender: oleksandr@natalenko.name
User-Agent: Roundcube Webmail/1.3.10
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=arc-20170712; t=1568910244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IsJrJR9edgNTBA9PLlDz/xnT9d6f7b7QwgTsriOltYw=;
        b=mgI2Q2q5EsLvn5vBzuOrygwCRA2r3Z4tTBzw/ENCbkOUtuhHRZvBFvJlkiDeKgHoNM8L57
        n3RFkP4Eoy2ncUpUczQmlU9xtBlz7FeRuXZ5v+SGSBNktzCsovhNWLqJSOKos+g/F4Dnzz
        39pyVVUPsO0r9TuiTqjGlnxP++AfJjA=
ARC-Seal: i=1; s=arc-20170712; d=natalenko.name; t=1568910244; a=rsa-sha256;
        cv=none;
        b=CHSLf2V6kh3lRldJ3FecPHYyY//KupbfEzWvG++8+qEysxN+Rvb2YVvxIkcM+fJ+b6PLYa
        SBXqq8QVA5XiZYSJNwLqUFC5Swd2yMZdlW9Ur7B5yrHyXQKGoVIHCnMDaTQhLR8xFDUdeF
        h18oEZ6zq+fpK9KFH1FTqiEQ1fpHt/4=
ARC-Authentication-Results: i=1;
        vulcan.natalenko.name;
        auth=pass smtp.auth=oleksandr@natalenko.name smtp.mailfrom=oleksandr@natalenko.name
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.

Recently, I've got the following card:

01:00.0 Network controller: MEDIATEK Corp. Device 7612
         Subsystem: MEDIATEK Corp. Device 7612
         Flags: bus master, fast devsel, latency 0, IRQ 16
         Memory at 81200000 (64-bit, non-prefetchable) [size=1M]
         Expansion ROM at 81300000 [disabled] [size=64K]
         Capabilities: [40] Power Management version 3
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
         Capabilities: [70] Express Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [148] Device Serial Number 00-00-00-00-00-00-00-00
         Capabilities: [158] Latency Tolerance Reporting
         Capabilities: [160] L1 PM Substates
         Kernel driver in use: mt76x2e
         Kernel modules: mt76x2e

I try to use it as an access point with the following configuration:

interface=wlp1s0
driver=nl80211
ssid=someap
channel=36
noscan=1
hw_mode=a
ieee80211n=1
require_ht=1
ieee80211ac=1
require_vht=1
vht_oper_chwidth=1
vht_capab=[SHORT-GI-80][RX-STBC-1][RX-ANTENNA-PATTERN][TX-ANTENNA-PATTERN]
vht_oper_centr_freq_seg0_idx=42
auth_algs=1
wpa=2
wpa_passphrase=somepswd
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
macaddr_acl=1
accept_mac_file=/etc/hostapd/hostapd.allow
ctrl_interface=/run/hostapd
ctrl_interface_group=0
country_code=CZ
ieee80211d=1
ieee80211h=1
wmm_enabled=1
ht_capab=[GF][HT40+][SHORT-GI-20][SHORT-GI-40][RX-STBC1][DSSS_CCK-40]

The hostapd daemon starts, and the AP broadcasts the beacons:

zář 19 17:50:04 srv hostapd[13251]: Configuration file: 
/etc/hostapd/ap_5ghz.conf
zář 19 17:50:05 srv hostapd[13251]: wlp1s0: interface state 
UNINITIALIZED->COUNTRY_UPDATE
zář 19 17:50:05 srv hostapd[13251]: Using interface wlp1s0 with hwaddr 
xx:xx:xx:xx:xx:xx and ssid "someap"
zář 19 17:50:05 srv hostapd[13251]: wlp1s0: interface state 
COUNTRY_UPDATE->ENABLED
zář 19 17:50:05 srv hostapd[13251]: wlp1s0: AP-ENABLED
zář 19 17:50:17 srv hostapd[13251]: wlp1s0: STA xx:xx:xx:xx:xx:xx IEEE 
802.11: authenticated
zář 19 17:50:17 srv hostapd[13251]: wlp1s0: STA xx:xx:xx:xx:xx:xx IEEE 
802.11: authenticated
zář 19 17:50:17 srv hostapd[13251]: wlp1s0: STA xx:xx:xx:xx:xx:xx IEEE 
802.11: associated (aid 1)
zář 19 17:50:17 srv hostapd[13251]: wlp1s0: STA xx:xx:xx:xx:xx:xx IEEE 
802.11: associated (aid 1)
zář 19 17:50:17 srv hostapd[13251]: wlp1s0: AP-STA-CONNECTED 
xx:xx:xx:xx:xx:xx
zář 19 17:50:17 srv hostapd[13251]: wlp1s0: STA xx:xx:xx:xx:xx:xx 
RADIUS: starting accounting session 07E311195378B570
zář 19 17:50:17 srv hostapd[13251]: wlp1s0: STA xx:xx:xx:xx:xx:xx WPA: 
pairwise key handshake completed (RSN)
zář 19 17:50:17 srv hostapd[13251]: wlp1s0: STA xx:xx:xx:xx:xx:xx 
RADIUS: starting accounting session 07E311195378B570
zář 19 17:50:17 srv hostapd[13251]: wlp1s0: STA xx:xx:xx:xx:xx:xx WPA: 
pairwise key handshake completed (RSN)

The client is able to see it and connect to it, but after a couple of 
seconds the following happens on the AP:

[  +9,979664] mt76x2e 0000:01:00.0: Firmware Version: 0.0.00
[  +0,000014] mt76x2e 0000:01:00.0: Build: 1
[  +0,000010] mt76x2e 0000:01:00.0: Build Time: 201507311614____
[  +0,018017] mt76x2e 0000:01:00.0: Firmware running!
[  +0,001101] ieee80211 phy4: Hardware restart was requested

and the AP dies. The client cannot reconnect to it, although hostapd 
logs show that it tries:

zář 19 17:51:15 srv hostapd[13504]: wlp1s0: STA xx:xx:xx:xx:xx:xx IEEE 
802.11: authenticated
zář 19 17:51:15 srv hostapd[13504]: wlp1s0: STA xx:xx:xx:xx:xx:xx IEEE 
802.11: authenticated
zář 19 17:51:19 srv hostapd[13504]: wlp1s0: STA xx:xx:xx:xx:xx:xx IEEE 
802.11: authenticated
zář 19 17:51:19 srv hostapd[13504]: wlp1s0: STA xx:xx:xx:xx:xx:xx IEEE 
802.11: authenticated
zář 19 17:52:54 srv hostapd[13504]: wlp1s0: STA xx:xx:xx:xx:xx:xx IEEE 
802.11: authenticated
zář 19 17:52:54 srv hostapd[13504]: wlp1s0: STA xx:xx:xx:xx:xx:xx IEEE 
802.11: authenticated
zář 19 17:52:59 srv hostapd[13504]: wlp1s0: STA xx:xx:xx:xx:xx:xx IEEE 
802.11: authenticated
zář 19 17:52:59 srv hostapd[13504]: wlp1s0: STA xx:xx:xx:xx:xx:xx IEEE 
802.11: authenticated
zář 19 17:56:14 srv hostapd[13504]: wlp1s0: STA xx:xx:xx:xx:xx:xx IEEE 
802.11: deauthenticated due to inactivity (timer DEAUTH/REMOVE)

AP stays completely unusable until I remove and modprobe mt76x2e module 
again. And then everything begins from scratch, and the AP dies within 
seconds.

I observe this on a fresh v5.3 kernel. I haven't tried anything older.

The only somewhat relevant thread I was able to found is [1], but it's 
not clear what's the resolution if any.

Could you please suggest how to deal with this issue?

Thanks.

[1] https://forum.openwrt.org/t/wifi-issues-with-18-06-4-on-mt76/40537

-- 
   Oleksandr Natalenko (post-factum)
