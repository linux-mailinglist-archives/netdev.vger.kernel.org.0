Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A756B707B
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 08:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjCMHzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 03:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjCMHyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 03:54:54 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2885F51CB9
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 00:53:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o130-20020a257388000000b00b3a7d06fd2eso3615824ybc.22
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 00:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678694014;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z24uQpiavHAngW50bCNl8uTNwZ8fleLlAkzaTnRscxM=;
        b=OQgkqx6X5V6rKpLh9Xsn9DoKoy3YdupoYxQjYwUzt8/rchFTZ0uRVR6TN4N/BEbmC+
         EVvCc0MHcStVh7WaOaMdFbdq2QIxlistUOiGDAayeAVaE8sV/WECjwI6epdz0nzmpJWc
         Y35whQyJIwewum8GJkoHAPBQiN4QlJqcocAjXCdv2rNA5lJcMR6gy38YeUOo9uDelUPI
         FQt1a9zTGCKejfG0Bq5xP23oI3ja54W2TmKQ7BYyVrSYdF0+na6apX1nQFlbWpl9n5hC
         AxT0O9i6ltGnVmfALuwHFhy7t2ekRVJNW9I4WTZj6i420aBLUDUX6RTLi5ZrpqxZA0fH
         MQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678694014;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z24uQpiavHAngW50bCNl8uTNwZ8fleLlAkzaTnRscxM=;
        b=dL4N4YJ/7WgGDKXY1sVGLp8MQ1q+XG9TarJCguxRdAq6MkP54a6i6feSWroHmCKevs
         sK+HcbDTw1g/TECrXSiOEXHy+XBt5iH95DcwQfzSR8IxsVri74jfCY/xHATA+2EIyGMA
         7kwkuO1trt//FNkU8PP1O9i3H5xOIFm5oc/vPVUWzcmMhw6k43VeFCm2Jvlv13vF3JWY
         Z0V0PGiHShXuuE/82pE0j3XMwFiUvTCdh8bcz3cI3vn5imGpjNmK6ghbZ+/rSoT89OWw
         JR8BGztMnoDwJK+XgyB/plZYSEaOrnQIN+zbUvLg9+f4TvLG/QGioRR8uz9k0lyCNBJp
         /wIQ==
X-Gm-Message-State: AO0yUKUsmHZGHbp5rL0K0Qe4tpVhAnav5mH7uxHPf9XypjjJmxqhhEgL
        Hp7eBfwGkaX+gwBSC/r1Tr95edzhHXY=
X-Google-Smtp-Source: AK7set/E2prpWdYGCw6fFLpCJdo1zsAkbWFEB/WiRTPvMTHE1CeErQCVUCKsRcZ5ECuTKwfp2AjpxwjCalc=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a5b:1cb:0:b0:a6b:bc64:a0af with SMTP id
 f11-20020a5b01cb000000b00a6bbc64a0afmr20648253ybp.4.1678694013992; Mon, 13
 Mar 2023 00:53:33 -0700 (PDT)
Date:   Mon, 13 Mar 2023 07:53:21 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313075326.3594869-1-jaewan@google.com>
Subject: [PATCH v9 0/5] mac80211_hwsim: Add PMSR support
From:   Jaewan Kim <jaewan@google.com>
To:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com,
        Jaewan Kim <jaewan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Kernel maintainers,

First of all, thank you for spending your precious time for reviewing
my changes.

Let me propose series of patches for adding PMSR support in the
mac80211_hwsim.

PMSR (peer measurement) is generalized measurement between STAs,
and currently FTM (fine time measurement or flight time measurement)
is the one and only measurement.

FTM measures the RTT (round trip time) and FTM can be used to measure
distances between two STAs. RTT is often referred as 'measuring distance'
as well.

Kernel had already defined protocols for PMSR in the
include/uapi/linux/nl80211.h and relevant parsing/sending code are in the
net/wireless/pmsr.c, but they are only used in intel's iwlwifi driver.

Patchset is tested with iw tool on Virtual Android device (a.k.a.
Cuttlefish). Hope this explains my changes.

Many Thanks,
--
V8 -> V9: Removed any wrong words for patch. Changed to reject unknown
          PMSR types.
V7 -> V8: Separated patch for exporting nl80211_send_chandef
V6 -> V7: Split 'mac80211_hwsim: handle FTM requests with virtio'
          with three pieces
V5 -> V6: Added per patch change history.
V4 -> V5: Fixed style
V3 -> V4: Added detailed explanation to cover letter and per patch commit
          messages, includes explanation of PMSR and FTM.
          Also fixed memory leak.
V1 -> V3: Initial commits (include resends)

Jaewan Kim (5):
  mac80211_hwsim: add PMSR capability support
  wifi: nl80211: make nl80211_send_chandef non-static
  mac80211_hwsim: add PMSR request support via virtio
  mac80211_hwsim: add PMSR abort support via virtio
  mac80211_hwsim: add PMSR report support via virtio

 drivers/net/wireless/mac80211_hwsim.c | 776 +++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |  58 ++
 include/net/cfg80211.h                |   9 +
 net/wireless/nl80211.c                |   4 +-
 4 files changed, 835 insertions(+), 12 deletions(-)

-- 
2.40.0.rc1.284.g88254d51c5-goog

