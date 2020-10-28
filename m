Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF2029D93F
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389573AbgJ1WuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389559AbgJ1WuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:50:12 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6C6C0613CF;
        Wed, 28 Oct 2020 15:50:11 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id w1so40790edv.11;
        Wed, 28 Oct 2020 15:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r8zdq5tnsEjU2mL7IhtYQ9z15emjzzbWyJ8LKOVG7LE=;
        b=qP+paProEdF2d4saX3R100bJ/TrIY0l8n7dW91ga0p79xT/ZhSInLMrEmTMDZkelqY
         RnkT/D2btIvexzGFA1jdM5yVobtaxWruyAfhhdHgmQiYXEtd3sfy1clg5UD2ebYGzeX+
         QHHeUFpmGqKU9U5jnGNI+RBaP0bOoAWYibWR8VDKjxaK7XsGxSgJ7mFx1wP3bIfQZaCf
         /Ba3Q8qmU4kQOtkPWXdLErd2q5snG888fMjkrystzbr+XDdQ48xD/w0Z+c7ilWsTSqCC
         lP3ofQve4fWbmpNcCIHx/ykTz4TwtNxbThI3BQABGCdj5hupLK0LydwL+bpTnTl1f87X
         9HNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r8zdq5tnsEjU2mL7IhtYQ9z15emjzzbWyJ8LKOVG7LE=;
        b=VLH5+ZxSiDaEPp0HOobMVY2CmqJ7EmMMGVD4alhuaLJMpl71241zWsaxs3aro8cF/O
         Kywk0gvvdZ2ZB47WaiQFX/YERglo1MPVFbex6rcm6nC/YdUxG/nZMQTa+X/fx97xnCzG
         KQC8zS+GzQAP936I4QsN9RK0+ysjRAUqgaO5S2rzWGM37qprQS0RQ7JEDIC7LUAbq0wo
         NaISEgaBmY02g9p3F09Vm/wD4spceBjm8Cd/JDYJvcw1vQ7aDwZvRxPEYgOOLixVaUIB
         L5FaixVwmLcoTAAfXAh0CQnjNBIHZpdkWmnfihr81EC0dWk0/zC2Pkon+hPneZ9yQHQr
         QsXQ==
X-Gm-Message-State: AOAM530RLh/7B82CoDojSCJ778QetNpXWtZf2Q2EFzR+YpPfXxVHhwLt
        HbsoJXqDHz2z9+gl6aMR/W7X2eWbbNmHlg==
X-Google-Smtp-Source: ABdhPJxBA5qMqdLRZUL5Kf6G6HD8gn1XbCDnPnvopPF9XIN7M19KVavJXUT6judWR09BvGo9b0WE4g==
X-Received: by 2002:a5d:498a:: with SMTP id r10mr729826wrq.106.1603909249969;
        Wed, 28 Oct 2020 11:20:49 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id r28sm531178wrr.81.2020.10.28.11.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:20:49 -0700 (PDT)
From:   Aleksandr Nogikh <aleksandrnogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Subject: [PATCH v4 0/3] net, mac80211, kernel: enable KCOV remote coverage collection for 802.11 frame handling
Date:   Wed, 28 Oct 2020 18:20:15 +0000
Message-Id: <20201028182018.1780842-1-aleksandrnogikh@gmail.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
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
SKBs as an skb extension. If the allocation happens inside a system
call context, the SKB will be tied to the process that issued the
syscall (if that process is interested in remote coverage collection).
3. Annotate the code that processes incoming 802.11 frames with
kcov_remote_start()/kcov_remote_stop().

v4:
* CONFIG_SKB_EXTENSIONS is now automatically selected by CONFIG_KCOV.
* Elaborated on a minor optimization in skb_set_kcov_handle().

v3:
https://lkml.kernel.org/r/20201026150851.528148-1-aleksandrnogikh@gmail.com
* kcov_handle is now stored in skb extensions instead of sk_buff
  itself.
* Updated the cover letter.

v2:
https://lkml.kernel.org/r/20201009170202.103512-1-a.nogikh@gmail.com
* Moved KCOV annotations from ieee80211_tasklet_handler to
  ieee80211_rx.
* Updated kcov_common_handle() to return 0 if it is called in
  interrupt context.
* Updated the cover letter.

v1:
https://lkml.kernel.org/r/20201007101726.3149375-1-a.nogikh@gmail.com

Aleksandr Nogikh (3):
  kernel: make kcov_common_handle consider the current context
  net: add kcov handle to skb extensions
  mac80211: add KCOV remote annotations to incoming frame processing

 include/linux/skbuff.h | 36 ++++++++++++++++++++++++++++++++++++
 include/net/mac80211.h |  2 ++
 kernel/kcov.c          |  2 ++
 lib/Kconfig.debug      |  1 +
 net/core/skbuff.c      | 11 +++++++++++
 net/mac80211/iface.c   |  2 ++
 6 files changed, 54 insertions(+)


base-commit: 1c86f90a16d413621918ae1403842b43632f0b3d
-- 
2.29.0.rc2.309.g374f81d7ae-goog

