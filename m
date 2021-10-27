Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C6C43C4CC
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240796AbhJ0IOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:14:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240780AbhJ0IOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 04:14:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89B4360C40;
        Wed, 27 Oct 2021 08:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635322338;
        bh=YCVY4T/yVuKK1cC1ORCwVubxEwfwbpMgdeajacOKp8c=;
        h=From:To:Cc:Subject:Date:From;
        b=ug9kp998gmMNFVn1CtpXrel1Ahxnd/SO98jAejsMNYlsXIcECrBC94hG8haKYp42a
         dGCQl4jnGOQCEtNsN2RXJFADit39tlq1FLmbZ8f+cj3gBn3pGRJ2HgOqvAnHfiMDlc
         UVnNKsBiMrBWbhmf85ILWgyYWSny7M/YmBDPb7ZC0CZuGvo7iINPoGBpLJ2fGenm7u
         DhFTIcf1U7ZLTqDtAq6uX83pqoWCIYMEiZNMYVKLIbxvg8YhBsQjtc8vBELHaxt6wM
         h5iTY4oQHMdtzERFRRfrCUiw2RXgrYf24nhk8QQCw2M42IVw5WT3qYCg0M1za3nlmn
         /igKG2dSebZRg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfe2R-0001le-Vm; Wed, 27 Oct 2021 10:12:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 0/3] wireless: fix division by zero in USB drivers
Date:   Wed, 27 Oct 2021 10:08:16 +0200
Message-Id: <20211027080819.6675-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds the missing endpoint sanity checks to the wireless USB
drivers that were doing packet-size calculations without first making
sure that the USB descriptors were sane.

Johan

Changes in v2:
 - tighten the sanity checks for the mwifiex firmware-download mode to
   handle also a missing bulk-out endpoint (noticed by Brian Norris)


Johan Hovold (3):
  ath10k: fix division by zero in send path
  ath6kl: fix division by zero in send path
  mwifiex: fix division by zero in fw download path

 drivers/net/wireless/ath/ath10k/usb.c      |  5 +++++
 drivers/net/wireless/ath/ath6kl/usb.c      |  5 +++++
 drivers/net/wireless/marvell/mwifiex/usb.c | 16 ++++++++++++++++
 3 files changed, 26 insertions(+)

-- 
2.32.0

