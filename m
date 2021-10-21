Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF7E4366BF
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhJUPwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbhJUPwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 11:52:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E80C0613B9;
        Thu, 21 Oct 2021 08:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=EJ1YfbQmfCOLL6I68UtVBFestdY2bzR3PRdcgl7aBOM=; t=1634831398; x=1636040998; 
        b=K55v3bdYu+BFYD2YPIXQ2dU7PBmxcevKXZb6y2LwjfQpTeaSioRKaFjQxL2yWF4yFD6kdcI6uGL
        cXM9wCVzhniOCT4fCQtFKzANuaC7akdp04wSL6S9n8RZRiUctyiL2M9LfAVJ8093dXlsH7vTEo8Y+
        vIfZIxRXlOD7ZwqsCkQJ/RnOSM9QSWFpHMz1XgHVvCGv91E0PcJkpegfiOXTJKd/AMJpLVohHVqla
        IR3m7v1DN0k3NeS9kflOlQMNWRqd4R59qX3n8fhUji2uC1Kf262DzGJVFJgVFhjjTnkK0FGhObxSd
        hm8G1MRIJ6yeZ2nePeZpUMeiQKOhHbDvSoBA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mdaKK-005KPO-HX;
        Thu, 21 Oct 2021 17:49:56 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: pull-request: mac80211-next 2021-10-21
Date:   Thu, 21 Oct 2021 17:49:52 +0200
Message-Id: <20211021154953.134849-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's another pull request for net-next - including the
eth_hw_addr_set() and related changes, but also quite a
few other things - see the tag description (below).

Please pull and let me know if there's any problem.

Thanks,
johannes



The following changes since commit 428168f9951710854d8d1abf6ca03a8bdab0ccc5:

  Merge branch 'mlxsw-trap-adjacency' (2021-09-22 14:35:02 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-net-next-2021-10-21

for you to fetch changes up to f9d366d420af4ce8719c59e60853573c02831f61:

  cfg80211: fix kernel-doc for MBSSID EMA (2021-10-21 17:34:10 +0200)

----------------------------------------------------------------
Quite a few changes:
 * the applicable eth_hw_addr_set() and const hw_addr changes
 * various code cleanups/refactorings
 * stack usage reductions across the wireless stack
 * some unstructured find_ie() -> structured find_element()
   changes
 * a few more pieces of multi-BSSID support
 * some 6 GHz regulatory support
 * 6 GHz support in hwsim, for testing userspace code
 * Light Communications (LC, 802.11bb) early band definitions
   to be able to add a first driver soon

----------------------------------------------------------------
Aloka Dixit (1):
      mac80211: split beacon retrieval functions

Emmanuel Grumbach (1):
      nl80211: vendor-cmd: intel: add more details for IWL_MVM_VENDOR_CMD_HOST_GET_OWNERSHIP

Jakub Kicinski (3):
      wireless: mac80211_hwsim: use eth_hw_addr_set()
      mac80211: use eth_hw_addr_set()
      cfg80211: prepare for const netdev->dev_addr

Johannes Berg (16):
      cfg80211: honour V=1 in certificate code generation
      mac80211: reduce stack usage in debugfs
      mac80211: mesh: clean up rx_bcn_presp API
      mac80211: move CRC into struct ieee802_11_elems
      mac80211: mlme: find auth challenge directly
      mac80211: always allocate struct ieee802_11_elems
      nl80211: don't put struct cfg80211_ap_settings on stack
      mac80211: twt: don't use potentially unaligned pointer
      cfg80211: always free wiphy specific regdomain
      nl80211: don't kfree() ERR_PTR() value
      mac80211: fix memory leaks with element parsing
      mac80211: fils: use cfg80211_find_ext_elem()
      nl80211: use element finding functions
      cfg80211: scan: use element finding functions in easy cases
      mac80211: use ieee80211_bss_get_elem() in most places
      cfg80211: fix kernel-doc for MBSSID EMA

John Crispin (2):
      nl80211: MBSSID and EMA support in AP mode
      mac80211: MBSSID support in interface handling

Len Baker (1):
      nl80211: prefer struct_size over open coded arithmetic

Loic Poulain (1):
      mac80211: Prevent AP probing during suspend

Lorenzo Bianconi (1):
      mac80211: check hostapd configuration parsing twt requests

Mordechay Goodstein (1):
      mac80211: debugfs: calculate free buffer size correctly

Ramon Fontes (1):
      mac80211_hwsim: enable 6GHz channels

Srinivasan Raju (1):
      nl80211: Add LC placeholder band definition to nl80211_band

Subrat Mishra (1):
      cfg80211: AP mode driver offload for FILS association crypto

Wen Gong (5):
      mac80211: use ieee802_11_parse_elems() in ieee80211_prep_channel()
      ieee80211: add power type definition for 6 GHz
      mac80211: add parse regulatory info in 6 GHz operation information
      mac80211: save transmit power envelope element and power constraint
      cfg80211: separate get channel number from ies

 drivers/net/wireless/mac80211_hwsim.c  | 163 ++++++++++--
 include/linux/ieee80211.h              |  38 +++
 include/net/cfg80211.h                 |  79 +++++-
 include/net/mac80211.h                 |  11 +
 include/uapi/linux/nl80211-vnd-intel.h |  29 +++
 include/uapi/linux/nl80211.h           | 115 ++++++++-
 net/mac80211/agg-rx.c                  |  14 +-
 net/mac80211/cfg.c                     |  38 +++
 net/mac80211/debugfs_sta.c             | 123 +++++----
 net/mac80211/fils_aead.c               |  22 +-
 net/mac80211/ibss.c                    |  33 ++-
 net/mac80211/ieee80211_i.h             |  35 +--
 net/mac80211/iface.c                   |  39 ++-
 net/mac80211/mesh.c                    |  87 ++++---
 net/mac80211/mesh_hwmp.c               |  44 ++--
 net/mac80211/mesh_plink.c              |  11 +-
 net/mac80211/mesh_sync.c               |  26 +-
 net/mac80211/mlme.c                    | 355 +++++++++++++++-----------
 net/mac80211/pm.c                      |   4 +
 net/mac80211/rx.c                      |  12 +-
 net/mac80211/s1g.c                     |   8 +-
 net/mac80211/scan.c                    |  16 +-
 net/mac80211/sta_info.c                |   1 +
 net/mac80211/tdls.c                    |  63 +++--
 net/mac80211/tx.c                      | 206 ++++++++-------
 net/mac80211/util.c                    |  40 ++-
 net/wireless/Makefile                  |   4 +-
 net/wireless/core.c                    |  10 +
 net/wireless/nl80211.c                 | 452 +++++++++++++++++++++++++--------
 net/wireless/rdev-ops.h                |  14 +
 net/wireless/scan.c                    |  59 +++--
 net/wireless/trace.h                   |  31 +++
 net/wireless/util.c                    |   2 +
 33 files changed, 1556 insertions(+), 628 deletions(-)

