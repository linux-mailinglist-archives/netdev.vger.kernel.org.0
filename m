Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60DB2C4504
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 17:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbgKYQZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 11:25:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731180AbgKYQZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 11:25:32 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FB9C061A51
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 08:25:32 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id o16so2932446qvq.4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 08:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=kvx4ypKzsvTsNRkpKLbQXMSUgG7LqQJ459IESbUi2Pg=;
        b=F46PSwOpar3alalr8VdSc32WF8ZCnTqLw516KRpy+NOz0v2dRAp7gABdRgRy8vjc3h
         7j9Nl1u6k9E/YCFDbyixPa0kxt5kmVdTEoYgRoNMuG8nh9WznyRGlXREt4+7KWt3t5+D
         0mbpMOJCD+b0a0SrqcmW9u+MwFadoYmAehlXbW3jlik8aKZyrBKtL0hIBc1pcmkV9ckJ
         /urKKWEifAqDent70J4kJ4VQMtzZikcxO6WeycD/z/Cx5HgOuW3K23BXrunnfAwuVTj0
         6XJhNI0VCNdf8bjVH+fXHX4pma9+ByASbgUTb42vKQ38Hn/oC/oiOeTpyouKnSfEPx6l
         YCMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=kvx4ypKzsvTsNRkpKLbQXMSUgG7LqQJ459IESbUi2Pg=;
        b=AraZhARPJMuWx8bgqoiNt8g4uf3XlNB7xaMKIzsJAc2EYondYBMVNg8FVKLN/uIJ7+
         a/mXbqvD/slPIb5PDCJdN3aVkZAfYM7hj4RisgLsHCXDhYPQmIKhzxHvJk49tPtFN1WW
         P3GvRpmRAcD2ByRc56urVTdIDiRB0TuH65p5NsWZA3oRmveOBMLUItwqGLyPwRKek/Oh
         Zu3u4u+TkdHwAD8gLRoLzIyRiyuYWtATE3iBo5TWYPQBSrkPEa/B32LU2BP6l6ERD0Fm
         gaaTrivz0pwR90WvSshLqtaY6stZX+fNfOIxiH3pbf7tAJCH+vF7u0cWHfkFZQPjnC0J
         1YHw==
X-Gm-Message-State: AOAM5335aGVso1r+XsqjmEBy5Pn390wnRmt+q8vCQkadG3L9NjjthOFq
        v440EpLkspzdnYqG4GX177UBn6pysg==
X-Google-Smtp-Source: ABdhPJxvAj93w4pXw/f7H9LNJVuezNeFs/6sMy3/w1UTClQjk6mqW2m/0/aBkAlKr80YHn7hMsyar/P5Vg==
Sender: "elver via sendgmr" <elver@elver.muc.corp.google.com>
X-Received: from elver.muc.corp.google.com ([2a00:79e0:15:13:f693:9fff:fef4:2449])
 (user=elver job=sendgmr) by 2002:a0c:9e6b:: with SMTP id z43mr4415819qve.6.1606321531530;
 Wed, 25 Nov 2020 08:25:31 -0800 (PST)
Date:   Wed, 25 Nov 2020 17:24:52 +0100
Message-Id: <20201125162455.1690502-1-elver@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v6 0/3] net, mac80211, kernel: enable KCOV remote coverage
 collection for 802.11 frame handling
From:   Marco Elver <elver@google.com>
To:     elver@google.com, davem@davemloft.net, kuba@kernel.org,
        johannes@sipsolutions.net
Cc:     akpm@linux-foundation.org, a.nogikh@gmail.com, edumazet@google.com,
        andreyknvl@google.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, idosch@idosch.org, fw@strlen.de,
        willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

This patch series enables remote KCOV coverage collection during 802.11
frames processing. These changes make it possible to perform
coverage-guided fuzzing in search of remotely triggerable bugs.

Normally, KCOV collects coverage information for the code that is
executed inside the system call context. It is easy to identify where
that coverage should go and whether it should be collected at all by
looking at the current process. If KCOV was enabled on that process,
coverage will be stored in a buffer specific to that process.
Howerever, it is not always enough as handling can happen elsewhere
(e.g. in separate kernel threads).

When it is impossible to infer KCOV-related info just by looking at the
currently running process, one needs to manually pass some information
to the code that should be instrumented. The information takes the form
of 64 bit integers (KCOV remote handles). Zero is the special value that
corresponds to an empty handle. More details on KCOV and remote coverage
collection can be found in Documentation/dev-tools/kcov.rst.

The series consists of three patches:

1. Apply a minor fix to kcov_common_handle() so that it returns a valid
   handle (zero) when called in an interrupt context.

2. Take the remote handle from KCOV and attach it to newly allocated
   SKBs. If the allocation happens inside a system call context, the SKB
   will be tied to the process that issued the syscall (if that process
   is interested in remote coverage collection).

3. Annotate the code that processes incoming 802.11 frames with
   kcov_remote_start()/kcov_remote_stop().


v6:
* Revert usage of skb extensions due to potential memory leak. Patch 2/3 is now
  idential to that in v2.
* Patches 1/3 and 3/3 are otherwise identical to v5.

v5: https://lore.kernel.org/linux-wireless/20201029173620.2121359-1-aleksandrnogikh@gmail.com/
* Collecting remote coverate at ieee80211_rx_list() instead of
  ieee80211_rx()

v4: https://lkml.kernel.org/r/20201028182018.1780842-1-aleksandrnogikh@gmail.com
* CONFIG_SKB_EXTENSIONS is now automatically selected by CONFIG_KCOV.
* Elaborated on a minor optimization in skb_set_kcov_handle().

v3: https://lkml.kernel.org/r/20201026150851.528148-1-aleksandrnogikh@gmail.com
* kcov_handle is now stored in skb extensions instead of sk_buff
  itself.
* Updated the cover letter.

v2: https://lkml.kernel.org/r/20201009170202.103512-1-a.nogikh@gmail.com
* Moved KCOV annotations from ieee80211_tasklet_handler to
  ieee80211_rx.
* Updated kcov_common_handle() to return 0 if it is called in
  interrupt context.

v1: https://lkml.kernel.org/r/20201007101726.3149375-1-a.nogikh@gmail.com

Aleksandr Nogikh (3):
  kernel: make kcov_common_handle consider the current context
  net: store KCOV remote handle in sk_buff
  mac80211: add KCOV remote annotations to incoming frame processing

 include/linux/skbuff.h | 21 +++++++++++++++++++++
 kernel/kcov.c          |  2 ++
 net/core/skbuff.c      |  1 +
 net/mac80211/iface.c   |  2 ++
 net/mac80211/rx.c      | 16 +++++++++-------
 5 files changed, 35 insertions(+), 7 deletions(-)

-- 
2.29.2.454.gaff20da3a2-goog

