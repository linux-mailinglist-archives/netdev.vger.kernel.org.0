Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B54288F7B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390089AbgJIRCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390077AbgJIRCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:02:10 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA092C0613D2;
        Fri,  9 Oct 2020 10:02:09 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g12so11012875wrp.10;
        Fri, 09 Oct 2020 10:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OQjXtAUBiUt8FZeF7VwlJkEHyrNsrnaij5FiCyQ3fQQ=;
        b=MecW84xz1Y6hya5EsgYzu/gfNosmgK1IQW0ERxhH6z3tyiZYmvq1BG+OSyvvc48kzJ
         QJsqiwl8CiVx/EjFoq2LOVQ87riqWUxp8xzwOq31agG5QWZkQyTXaLsf4BjuRSXirElI
         L76cra59A2J8F0Xj0AAQdYMBuZoe0TMiZuny4Ax33OaWBu4JgfyvAUzjGV7b4Hnu7G39
         eVC2urRtnaikTDkZZ5qU1n54Ag2iHpF0D6QFQ/gfdTUss+KGEgP3jhRa5y+RE3ymj3dp
         CPJuJwFwPDDKVGiUMynhBk6UdnmqRMjjs1xNjO1KbftD9UIzFlcnKG/ET5TGAKzCFzLb
         1xXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OQjXtAUBiUt8FZeF7VwlJkEHyrNsrnaij5FiCyQ3fQQ=;
        b=HJ8AKOg9JnRE5EbL5xHt/i8inIHDzXvCq2mLi8opGyLz9g3e0fnM9bM7l9qpXJ1N1q
         TMQqzuKIfcende8I3dJg2YQT4ZvTtbzTP/D4tLyVO3f6v6jEUUJAQ5oJdq9oYlf+tHtw
         qPk9xdZBFojD80DY1NhCbvzp3gwEZ372rkgrNxt/7h2bCpIvtfW6GAkz2v6uLWRXaiLn
         83D6J4KypuhvIprgNVwp6hM8ZSgKBXFrvRRxK+kb3GUdjBhNHSbRyftaTwk0jNSSh93O
         iW9iItpAj9WKDc8tXefnT4dSA+unM21KsmUW8Uzj4C/buwSRc6QbWOA0pjG2q+8g32EQ
         YlTg==
X-Gm-Message-State: AOAM531EY6oZ2+dRHnGQBO+hMq9nT359NpR9e9t1KlNCToJm2QhxQxLh
        /7W2UerK540ZoDLYNgJQq14=
X-Google-Smtp-Source: ABdhPJxOLPMJ/OTwRWLN6JGLl2IHYdtRODFUaAvYApkLJSw1zM761u1IKsAuwVY+wEvRe7p1OEoC9g==
X-Received: by 2002:a05:6000:c5:: with SMTP id q5mr16999496wrx.175.1602262928645;
        Fri, 09 Oct 2020 10:02:08 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id s6sm13211092wrg.92.2020.10.09.10.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:02:08 -0700 (PDT)
From:   Aleksandr Nogikh <a.nogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net,
        akpm@linux-foundation.org
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Subject: [PATCH v2 0/3] [PATCH v2 0/3] [PATCH v2 0/3] net, mac80211, kernel: enable KCOV remote coverage collection for 802.11 frame handling
Date:   Fri,  9 Oct 2020 17:01:59 +0000
Message-Id: <20201009170202.103512-1-a.nogikh@gmail.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

This patch series enables remote KCOV coverage collection during
802.11 frames processing. These changes make it possible to perform
coverage-guided fuzzing in search of remotely triggerable bugs.

Normally, KCOV collects coverage information for the code that is
executed inside the system call context. It is easy to identify where
that coverage should go and whether it should be collected at all by
looking at the current process. If KCOV was enabled on that process,
coverage will be stored in a buffer specific to that process.
Howerever, it is not always enough as handling can happen elsewhere
(e.g. in separate kernel threads).

When it is impossible to infer KCOV-related info just by looking at
the currently running process, one needs to manually pass some
information to the code that should be instrumented. The information
takes the form of 64 bit integers (KCOV remote handles). Zero is the
special value that corresponds to an empty handle. More details on
KCOV and remote coverage collection can be found in
Documentation/dev-tools/kcov.rst.

The series consists of three commits.
1. Apply a minor fix to kcov_common_handle() so that it returns a
valid handle (zero) when called in an interrupt context.
2. Take the remote handle from KCOV and attach it to newly allocated
SKBs. If the allocation happens inside a system call context, the SKB
will be tied to the process that issued the syscall (if that process
is interested in remote coverage collection).
3. Annotate the code that processes incoming 802.11 frames with
kcov_remote_start()/kcov_remote_stop()

This patch series conflicts with another proposed patch
http://lkml.kernel.org/r/223901affc7bd759b2d6995c2dbfbdd0a29bc88a.1602248029.git.andreyknvl@google.com
One of these patches needs to be rebased once the other one is merged.

v2:
* Moved KCOV annotations from ieee80211_tasklet_handler to
  ieee80211_rx.
* Updated kcov_common_handle() to return 0 if it is called in
  interrupt context.
* Updated the cover letter.
 
v1: https://lkml.kernel.org/r/20201007101726.3149375-1-a.nogikh@gmail.com

Aleksandr Nogikh (3):
  kernel: make kcov_common_handle consider the current context
  net: store KCOV remote handle in sk_buff
  mac80211: add KCOV remote annotations to incoming frame processing

 include/linux/skbuff.h | 21 +++++++++++++++++++++
 include/net/mac80211.h |  2 ++
 kernel/kcov.c          |  2 ++
 net/core/skbuff.c      |  1 +
 net/mac80211/iface.c   |  2 ++
 5 files changed, 28 insertions(+)


base-commit: a804ab086e9de200e2e70600996db7fc14c91959
-- 
2.28.0.1011.ga647a8990f-goog

