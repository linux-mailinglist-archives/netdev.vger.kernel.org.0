Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4365ABF70
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 16:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiICO41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 10:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiICO40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 10:56:26 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A795244A;
        Sat,  3 Sep 2022 07:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=RNcrUL6eoD+LM/OK+4Ju+iIzC0SwnszRW35cDKHe6Pk=; t=1662216984; x=1663426584; 
        b=IBqlMoCBY2i7PylQgvY98Tw0JQN2XdOTMIpWNcrWoaJdx04SItxBvEKUnVmOTPOBdwQv0LABkaG
        fEeKUj+8YW2nejFS61eFySfXGcRmd72PFxxtt9HRZIaJUrTvrJF6Yvs5gRCNgXUF8eMf2HYxf/d7a
        SZs/nyQ1mfzsgC33oUrls3xj4nvRJ0S3bmhCQmaWmFKjjciqfTR1HDACX1UKCrBROJUyFgK89pn2A
        1mZ9bD5ZSXvf2Uo8nir/TV0W99ntXx1UwcbGHF+BPFZN6wKxBudXAJOoOZh7+ui+4GpdQvV5RTsYO
        fgABcy5TlhNVpKTC4+3PX1vbRrjbe+L67M5w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oUUZK-00703S-14;
        Sat, 03 Sep 2022 16:56:22 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: wireless-2022-09-03
Date:   Sat,  3 Sep 2022 16:56:17 +0200
Message-Id: <20220903145618.77721-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

So here we have a set of fixes for the current cycle again,
the one thing I know of that's been relatively widely reported
is the aggregation timer warning, which Mukesh fixes by setting
the link pointer. Also with various other fixes, of course, no
less important.

Due to the link pointer fix, I'd like you to ask to pull this
into net-next soonish, we need this code there to also fill the
link_sta pointer (which doesn't yet exist in net/wireless). I'm
going to send a pull request for wireless-next soon, without
that additional content that's waiting, and once it's all there
together in net-next I'll merge back and add more of wifi7/MLO
work.

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 4ba9d38bb5a3255390dc15d8ac81f656a968273c:

  Merge tag 'wireless-2022-08-26' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless (2022-08-26 11:43:20 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2022-09-03

for you to fetch changes up to 2aec909912da55a6e469fd6ee8412080a5433ed2:

  wifi: use struct_group to copy addresses (2022-09-03 16:40:06 +0200)

----------------------------------------------------------------
We have a handful of fixes:
 - fix DMA from stack in wilc1000 driver
 - fix crash on chip reset failure in mt7921e
 - fix for the reported warning on aggregation timer expiry
 - check packet lengths in hwsim virtio paths
 - fix compiler warnings/errors with AAD construction by
   using struct_group
 - fix Intel 4965 driver rate scale operation
 - release channel contexts correctly in mac80211 mlme code

----------------------------------------------------------------
Ajay.Kathat@microchip.com (1):
      wifi: wilc1000: fix DMA on stack objects

Deren Wu (1):
      wifi: mt76: mt7921e: fix crash in chip reset fail

Johannes Berg (3):
      wifi: mac80211: mlme: release deflink channel in error case
      wifi: mac80211: fix locking in auth/assoc timeout
      wifi: use struct_group to copy addresses

Mukesh Sisodiya (1):
      wifi: mac80211: fix link warning in RX agg timer expiry

Soenke Huster (1):
      wifi: mac80211_hwsim: check length for virtio packets

Stanislaw Gruszka (1):
      wifi: iwlegacy: 4965: corrected fix for potential off-by-one overflow in il4965_rs_fill_link_cmd()

 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |  5 +--
 drivers/net/wireless/mac80211_hwsim.c              |  7 +++-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |  2 +-
 drivers/net/wireless/microchip/wilc1000/netdev.h   |  1 +
 drivers/net/wireless/microchip/wilc1000/sdio.c     | 39 ++++++++++++++++++----
 drivers/net/wireless/microchip/wilc1000/wlan.c     | 15 +++++++--
 include/linux/ieee80211.h                          |  8 +++--
 net/mac80211/mlme.c                                | 12 +++----
 net/mac80211/rx.c                                  |  4 +++
 net/mac80211/wpa.c                                 |  4 +--
 net/wireless/lib80211_crypt_ccmp.c                 |  2 +-
 11 files changed, 73 insertions(+), 26 deletions(-)

