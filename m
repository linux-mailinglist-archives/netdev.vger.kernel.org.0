Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DDB30F2C5
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbhBDL5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:57:34 -0500
Received: from ares.krystal.co.uk ([77.72.0.130]:56468 "EHLO
        ares.krystal.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbhBDL5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 06:57:33 -0500
Received: from [51.148.178.73] (port=37344 helo=pbcl-dsk8.fritz.box)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1l7crn-008lpZ-Ew; Thu, 04 Feb 2021 11:32:07 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next 0/9] LAN7800 USB network interface driver NAPI support
Date:   Thu,  4 Feb 2021 11:31:12 +0000
Message-Id: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.17.1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ares.krystal.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - pebblebay.com
X-Get-Message-Sender-Via: ares.krystal.co.uk: authenticated_id: john.efstathiades@pebblebay.com
X-Authenticated-Sender: ares.krystal.co.uk: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds NAPI support to the lan78xx driver. This replaces
the existing tasklet based approach for processing completed packets.

The first patch introduces the NAPI support. The subsequent patches in
the series fix problems found during testing. The issues found were
not all due to the NAPI modifications. 

John Efstathiades (9):
  lan78xx: add NAPI interface support
  lan78xx: disable U1/U2 power state transitions
  lan78xx: fix USB errors and packet loss on suspend/resume
  lan78xx: disable MAC address filter before updating entry
  lan78xx: fix race condition in PHY handling causing kernel lock up
  lan78xx: reduce number of register access failure warnings
  lan78xx: set maximum MTU
  lan78xx: fix exception on link speed change
  lan78xx: remove set but unused 'ret' variable

 drivers/net/usb/lan78xx.c | 1992 +++++++++++++++++++++++++------------
 1 file changed, 1353 insertions(+), 639 deletions(-)

-- 
2.17.1

