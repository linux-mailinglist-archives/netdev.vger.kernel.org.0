Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5295F1F145C
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 10:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbgFHIRI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jun 2020 04:17:08 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:52107 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729085AbgFHIRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 04:17:08 -0400
Received: from marcel-macpro.fritz.box (p5b3d2638.dip0.t-ipconnect.de [91.61.38.56])
        by mail.holtmann.org (Postfix) with ESMTPSA id A3843CEC82;
        Mon,  8 Jun 2020 10:26:54 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v3] Bluetooth: Allow suspend even when preparation has
 failed
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20200605135009.v3.1.I0ec31d716619532fc007eac081e827a204ba03de@changeid>
Date:   Mon, 8 Jun 2020 10:17:05 +0200
Cc:     Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        len.brown@intel.com,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        linux-pm@vger.kernel.org, rafael@kernel.org,
        todd.e.brandt@linux.intel.com, rui.zhang@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <24703FC2-32D1-434A-84FC-7111BEC45C2F@holtmann.org>
References: <20200605135009.v3.1.I0ec31d716619532fc007eac081e827a204ba03de@changeid>
To:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Abhishek,

> It is preferable to allow suspend even when Bluetooth has problems
> preparing for sleep. When Bluetooth fails to finish preparing for
> suspend, log the error and allow the suspend notifier to continue
> instead.
> 
> To also make it clearer why suspend failed, change bt_dev_dbg to
> bt_dev_err when handling the suspend timeout.
> 
> Fixes: dd522a7429b07e ("Bluetooth: Handle LE devices during suspend")
> Reported-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> ---
> To verify this is properly working, I added an additional change to
> hci_suspend_wait_event to always return -16. This validates that suspend
> continues even when an error has occurred during the suspend
> preparation.
> 
> Example on Chromebook:
> [   55.834524] PM: Syncing filesystems ... done.
> [   55.841930] PM: Preparing system for sleep (s2idle)
> [   55.940492] Bluetooth: hci_core.c:hci_suspend_notifier() hci0: Suspend notifier action (3) failed: -16
> [   55.940497] Freezing user space processes ... (elapsed 0.001 seconds) done.
> [   55.941692] OOM killer disabled.
> [   55.941693] Freezing remaining freezable tasks ... (elapsed 0.000 seconds) done.
> [   55.942632] PM: Suspending system (s2idle)
> 
> I ran this through a suspend_stress_test in the following scenarios:
> * Peer classic device connected: 50+ suspends
> * No devices connected: 100 suspends
> * With the above test case returning -EBUSY: 50 suspends
> 
> I also ran this through our automated testing for suspend and wake on
> BT from suspend continues to work.
> 
> 
> Changes in v3:
> - Changed printf format for unsigned long
> 
> Changes in v2:
> - Added fixes and reported-by tags
> 
> net/bluetooth/hci_core.c | 17 ++++++++++-------
> 1 file changed, 10 insertions(+), 7 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel

