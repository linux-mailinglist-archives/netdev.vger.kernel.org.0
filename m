Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E194CEBA2
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 14:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbiCFNKp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 6 Mar 2022 08:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiCFNKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 08:10:44 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BB5424A8;
        Sun,  6 Mar 2022 05:09:50 -0800 (PST)
Received: from relay12.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::232])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id B1D8CC9CAD;
        Sun,  6 Mar 2022 13:00:15 +0000 (UTC)
Received: (Authenticated sender: pbl@bestov.io)
        by mail.gandi.net (Postfix) with ESMTPSA id AC7DF200007;
        Sun,  6 Mar 2022 13:00:09 +0000 (UTC)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 06 Mar 2022 14:00:08 +0100
Message-Id: <CICSX6EXTZ6U.MYGFTUDU5ZKW@enhorning>
From:   "Riccardo Paolo Bestetti" <pbl@bestov.io>
To:     <pbl@bestov.io>
Cc:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <shayne.chen@mediatek.com>,
        <sean.wang@mediatek.com>, <kvalo@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: MK7921K de-auths from AP every 5 minutes
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have recently installed an AMD RZ608 Wi-Fi card in my laptop. The card
uses the MT7921K chipset from MediaTek. I'm running Arch Linux, using
kernel 5.16.12-arch1-1. I'm using iwd 1.25-1 as my wireless daemon.

I'm experiencing de-auths every 5 minutes from my AP, which is a MikroTik
RB962UiGS-5HacT2HnT running the latest firmware. This has a AR9888 wireless
chip. It is indeed configured to update group keys every 5 minutes.

All the de-auths happen with excellent signal and SNR (consistently 50dB
or better as reported by the router, which is only a few meters apart
form the laptop). My router is set up on a fixed channel, with fixed
channel width 20MHz. The almost perfect periodicity also suggests that
bad signal is not an issue at play.

The kernel log does not report any messages from the driver. Only:

Mar 06 12:19:21 enhorning kernel: wlan0: deauthenticated from 08:55:31:cc:23:c3 (Reason: 16=GROUP_KEY_HANDSHAKE_TIMEOUT)
Mar 06 12:19:23 enhorning kernel: wlan0: authenticate with 08:55:31:cc:23:c3
Mar 06 12:19:23 enhorning kernel: wlan0: send auth to 08:55:31:cc:23:c3 (try 1/3)
Mar 06 12:19:23 enhorning kernel: wlan0: authenticated
Mar 06 12:19:23 enhorning kernel: wlan0: associate with 08:55:31:cc:23:c3 (try 1/3)
Mar 06 12:19:23 enhorning kernel: wlan0: RX AssocResp from 08:55:31:cc:23:c3 (capab=0x431 status=0 aid=2)
Mar 06 12:19:24 enhorning kernel: wlan0: associated
Mar 06 12:24:21 enhorning kernel: wlan0: deauthenticated from 08:55:31:cc:23:c3 (Reason: 16=GROUP_KEY_HANDSHAKE_TIMEOUT)
Mar 06 12:24:23 enhorning kernel: wlan0: authenticate with 08:55:31:cc:23:c3
Mar 06 12:24:23 enhorning kernel: wlan0: send auth to 08:55:31:cc:23:c3 (try 1/3)
Mar 06 12:24:23 enhorning kernel: wlan0: authenticated
Mar 06 12:24:23 enhorning kernel: wlan0: associate with 08:55:31:cc:23:c3 (try 1/3)
Mar 06 12:24:23 enhorning kernel: wlan0: RX AssocResp from 08:55:31:cc:23:c3 (capab=0x431 status=0 aid=2)
Mar 06 12:24:24 enhorning kernel: wlan0: associated
Mar 06 12:29:21 enhorning kernel: wlan0: deauthenticated from 08:55:31:cc:23:c3 (Reason: 6=CLASS2_FRAME_FROM_NONAUTH_STA)
Mar 06 12:29:28 enhorning kernel: wlan0: authenticate with 08:55:31:cc:23:c3
Mar 06 12:29:28 enhorning kernel: wlan0: send auth to 08:55:31:cc:23:c3 (try 1/3)
Mar 06 12:29:28 enhorning kernel: wlan0: authenticated
Mar 06 12:29:28 enhorning kernel: wlan0: associate with 08:55:31:cc:23:c3 (try 1/3)
Mar 06 12:29:28 enhorning kernel: wlan0: RX AssocResp from 08:55:31:cc:23:c3 (capab=0x431 status=0 aid=2)
Mar 06 12:29:28 enhorning kernel: wlan0: associated

Pretty much the same from the router:

12:19:21:
BE:1A:C2:58:95:F0@wlan2: disconnected, group key exchange timeout, signal strength -42

12:24:21:
BE:1A:C2:58:95:F0@wlan2: disconnected, group key exchange timeout, signal strength -42

12:29:21:
BE:1A:C2:58:95:F0@wlan2: disconnected, group key exchange timeout, signal strength -42


I have other devices connected to the same access point without issue,
and I can connect to other access points without issue. So I'm figuring
this is an issue specific to the combination of this chip and the
particular access point.

I am not able to say whether the issue is in this driver, or with the
access point. How might I go about finding out?

Best regards,
Riccardo P. Bestetti

