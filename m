Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4156766AE34
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 22:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjANVgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 16:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjANVgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 16:36:20 -0500
X-Greylist: delayed 959 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 14 Jan 2023 13:36:18 PST
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A0144AF
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 13:36:18 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NvWQl189gzXKm;
        Sat, 14 Jan 2023 22:20:10 +0100 (CET)
Message-ID: <cd0ce1e8-962a-4964-e6ee-69ebc0ec98b6@thelounge.net>
Date:   Sat, 14 Jan 2023 22:20:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
To:     netdev@vger.kernel.org
Content-Language: en-US
From:   Reindl Harald <h.reindl@thelounge.net>
Subject: iwlax2xx: no channel=acs_survey and no virtual access points
Organization: the lounge interactive design
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


iwlax2xx-firmware-20221214-145.fc36.noarch
Network controller: Intel Corporation Alder Lake-S PCH CNVi WiFi (rev 11

"channel=acs_survey" don't work at all and times out which maces 5 GHz 
WLAN practically unusable and in a city like vienna with tons of 
networks you really want automatic channel selection

when you don't comment out the last b,ockm for wlan1 you end with "Could 
not set interface wlan1 flags (UP): Device or resource busy Failed to 
add BSS (BSSID=02:ab:cd:ef:12:31)" and hostapd don't start at all

---------------------------

the more than 10 years old "Qualcomm Atheros AR5418 Wireless Network 
Adapter [AR5008E 802.11(a)bgn]" athk9 based card in the old machine just 
worked fine....

so is that the hardware itself, the kernel driver or the firmware?

---------------------------

interface=wlan0
driver=nl80211
ctrl_interface=/run/hostapd0
ctrl_interface_group=0

country_code=AT
hw_mode=g
channel=13

# don't work at all with the intel card
# channel=acs_survey

ieee80211ac=1
ieee80211d=1
ieee80211h=1
ieee80211n=1
wmm_enabled=1
wme_enabled=1

require_ht=1
ht_capab=[LDPC][HT40-][SHORT-GI-20][SHORT-GI-40][TX-STBC][RX-STBC1][SMPS-DYNAMIC][DSSS_CCK-40]

logger_syslog=-1
logger_syslog_level=2
logger_stdout=0
logger_stdout_level=4

################################################################
# wlan0                                                        #
################################################################

ssid=wlan-internal
bssid=02:ab:cd:ef:12:30
wpa_passphrase=******
bridge=br-lan
wpa=2
rsn_pairwise=CCMP

################################################################
# wlan1                                                        #
################################################################

bss=wlan1
ssid=wlan-guest
wpa_passphrase=******
bridge=br-guest
wpa=2
rsn_pairwise=CCMP
