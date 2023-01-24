Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C8E679CA2
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbjAXOyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:54:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235126AbjAXOyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:54:36 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF0F86BB
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:54:36 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 193-20020a6305ca000000b004cece0d0d64so7018439pgf.13
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D+RETE+69kvrgycMfRIlSWQ8SLcXQgvebrqZZkcm/1I=;
        b=dcOa8mBrB2R3fBeIf6EfIgUc/9jOM9PcYvS5oPT4bvUf85CAE+DAqMyMfWkPbwRyvB
         4bE87wnIjd5s+1aavNWMoS7ya9kgdpQWY1kOfrReamVa7r7CvqFi1koO4FkT9J50cPUW
         L+n7olUVcNUc48mHWXAI0uPS2ICdDgkj1CWoqaOZSwUab5LXcVe8QKfDE7Y532Ss/lLj
         ZSgyY22LvRYQf/GrYPZ1e4icOF63lPeW+nCqDqM47zBbnKJG4ZElzAjc0xfGLx0rtUut
         zUmvii5hQ6ZoRPLwVf81KYka1DMtP/WW807VD0WFadgB+/GOeeFa//o/YhZ20v2VqM+H
         Ri8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D+RETE+69kvrgycMfRIlSWQ8SLcXQgvebrqZZkcm/1I=;
        b=QKrhyNc7g+ypjyc61OHnt49tvkLcsv1z7e5Z0zLlHVy8S/pCzc2wIfrN1j9I/G6Yx6
         NCeA5hnfVU2y0qW1AaoGwccyVhst1CrybvSBdZu1IX4S1x2SW6/2nHUNqyuE9KHMucYF
         ie+EOGWYPzUID52dXHnphjpWYalVu9dXHdAAvtwX0Z+uEdmQiFrKXmFBDATwcEJ8eYKd
         FI3waA6PFGKXrI7PtsqT0mGfy+b6bW6kwL8HO8fG6Cj3rzn91Yv9j7rYIS0huR8y/k7d
         jEtSAIxXfj5thUA5jql0rKPQdpabHHn06eWiRWGk7hxJfXV2b2RxFgVjDULA5QkdbnhL
         fBOQ==
X-Gm-Message-State: AO0yUKV++K0dp6MUm0jx916bG1sWKyr+YO4LTcvFc5RG6/x9RAfOtN4O
        jFqV+rSDihcpzCDSjHSni59t+ZmgtgA=
X-Google-Smtp-Source: AK7set+yUN/11i5xH7MygJRSyExHDAD18x9cvVt4hkR9XZaD35jB5irY5QYZ5IcXeALmfVx7NlGKu6o7LNs=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a17:90a:a205:b0:229:f43c:4049 with SMTP id
 u5-20020a17090aa20500b00229f43c4049mr37838pjp.0.1674572075382; Tue, 24 Jan
 2023 06:54:35 -0800 (PST)
Date:   Tue, 24 Jan 2023 14:54:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230124145430.365495-1-jaewan@google.com>
Subject: [PATCH v6 0/2] mac80211_hwsim: Add PMSR support
From:   Jaewan Kim <jaewan@google.com>
To:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com,
        Jaewan Kim <jaewan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Kernel maintainers,

First of all, thank you for spending your precious time for reviewing
my changes, and also sorry for my mistakes in previous patchsets.

Let me propose series of CLs for adding PMSR support in the mac80211_hwsim.

PMSR (peer measurement) is generalized measurement between STAs,
and currently FTM (fine time measurement or flight time measurement)
is the one and only measurement.

FTM measures the RTT (round trip time) and FTM can be used to measure
distances between two STAs. RTT is often referred as 'measuring distance'
as well.

Kernel had already defined protocols for PMSR in the
include/uapi/linux/nl80211.h and relevant parsing/sending code are in the
net/wireless/pmsr.c, but they are only used in intel's iwlwifi driver.

CLs are tested with iw tool on Virtual Android device (a.k.a. Cuttlefish).
Hope this explains my CLs.

Many Thanks,

-- 
2.39.0.246.g2a6d74b583-goog

V5 -> V6: Added per CL change history.
V4 -> V5: Fixed style
V3 -> V4: Added detailed explanation to cover letter and per CL commit
          messages, includes explanation of PMSR and FTM.
          Also fixed memory leak.
V1 -> V3: Initial commits (include resends)

Jaewan Kim (2):
  mac80211_hwsim: add PMSR capability support
  mac80211_hwsim: handle FTM requests with virtio

 drivers/net/wireless/mac80211_hwsim.c | 826 +++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |  56 +-
 include/net/cfg80211.h                |  20 +
 net/wireless/nl80211.c                |  28 +-
 4 files changed, 912 insertions(+), 18 deletions(-)

