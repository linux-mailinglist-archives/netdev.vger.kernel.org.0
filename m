Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D3E3F6978
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 21:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbhHXTEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 15:04:06 -0400
Received: from fish.birch.relay.mailchannels.net ([23.83.209.251]:38515 "EHLO
        fish.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234012AbhHXTEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 15:04:05 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2021 15:04:05 EDT
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 280C17C09E9;
        Tue, 24 Aug 2021 18:57:21 +0000 (UTC)
Received: from ares.krystal.co.uk (unknown [127.0.0.6])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 9E9437C0860;
        Tue, 24 Aug 2021 18:57:19 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.112.83.53 (trex/6.4.3);
        Tue, 24 Aug 2021 18:57:20 +0000
X-MC-Relay: Bad
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Company-Daffy: 1069d79464779ed3_1629831440872_1085779323
X-MC-Loop-Signature: 1629831440872:4092516305
X-MC-Ingress-Time: 1629831440872
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KDvDoXzzOJosPv5W8H6PR4Yko9ghIHPIc8LaF9mTefY=; b=fhDwi/A2L/BAm8X6bw7zp41Xsc
        6P0qSt1mgo4pAaBa0mdg+6MsX0X3s9qqQ/QcQAkKg3ekZsM6b2EUIcBmuq5SDrxcNM9L1hcdVz5Px
        um+VJDVguuxEDTL5lZOeSXBUqcVW5HuolCwOSKvPoo3Wav7k8fGmH5UvpyENORtOqIcHhcKfjDei9
        HXZkvkQekI3P7xUN52JoyMZ25h4VaWRZn2uqpZkAKIC+5w0NZ9HNhq1W67KvI7FaDr07qsHvKEaFJ
        1LVzEOgNMULwaBqrZW8IYF7q8ODKYfcSNdzntDADLslcKxU+xpHK3KMnDqJDOCriMz66xej27i0Gy
        Rs9bJemQ==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:51816 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mIbbq-00BQSi-MK; Tue, 24 Aug 2021 19:57:17 +0100
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-usb@vger.kernel.org, john.efstathiades@pebblebay.com
Subject: [PATCH net-next v2 00/10] LAN7800 driver improvements
Date:   Tue, 24 Aug 2021 19:56:03 +0100
Message-Id: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set introduces a number of improvements and fixes for
problems found during testing of a modification to add a NAPI-style
approach to packet handling to improve performance.

NOTE: the NAPI changes are not part of this patch set and the issues
      fixed by this patch set are not coupled to the NAPI changes.

Patch 1 fixes white space and style issues

Patch 2 removes an unused timer

Patch 3 introduces macros to set the internal packet FIFO flow
control levels, which makes it easier to update the levels in future.

Patch 4 removes an unused queue

Patch 5 (updated for v2) introduces function return value checks and
error propagation to various parts of the driver where a return
code was captured but then ignored.

This patch is completely different to patch 5 in version 1 of this patch
set. The changes in the v1 patch 5 are being set aside for the time
being.

Patch 6 updates the LAN7800 MAC reset code to ensure there is no
PHY register access in progress when the MAC is reset. This change
prevents a kernel exception that can otherwise occur.

Patch 7 fixes problems with system suspend and resume handling while
the device is transmitting and receiving data.

Patch 8 fixes problems with auto-suspend and resume handling and
depends on changes introduced by patch 7.

Patch 9 fixes problems with device disconnect handling that can result
in kernel exceptions and/or hang.

Patch 10 limits the rate at which driver warning messages are emitted.

John Efstathiades (10):
  lan78xx: Fix white space and style issues
  lan78xx: Remove unused timer
  lan78xx: Set flow control threshold to prevent packet loss
  lan78xx: Remove unused pause frame queue
  lan78xx: Add missing return code checks
  lan78xx: Fix exception on link speed change
  lan78xx: Fix partial packet errors on suspend/resume
  lan78xx: Fix race conditions in suspend/resume handling
  lan78xx: Fix race condition in disconnect handling
  lan78xx: Limit number of driver warning messages

 drivers/net/usb/lan78xx.c | 1060 +++++++++++++++++++++++++++++--------
 1 file changed, 832 insertions(+), 228 deletions(-)

-- 
2.25.1

