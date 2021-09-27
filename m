Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866BD419E39
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 20:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbhI0S2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 14:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbhI0S2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 14:28:42 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168B5C061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 11:27:03 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id pf3-20020a17090b1d8300b0019e081aa87bso777649pjb.0
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 11:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cqZ/haXgFjIpSJHfI1VAsLg6naAL8kq0nI4pUX8OICI=;
        b=Ae/GnkZxx3AzOrnhpyQniuKHJ0wlNZWBFXL/PP1m5XyrATkGpzSqE3Uq9DuDZcHqBT
         3/7Pw6GZqWYV5lFyBe6YWzOm62BJxOQ1gbk2uXzktlBWHR6jSykmBSNWR3rHP9Q44Ws4
         uBBuE2m75g5Q8oX4OZxMmO0/NIOGZwIvpfmq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cqZ/haXgFjIpSJHfI1VAsLg6naAL8kq0nI4pUX8OICI=;
        b=siqlsB1N5ofs37Icnxg+tPofxXuQIWUN/am9CiRqjwssO0UjCsBkTFLWDSPQPgOpYF
         tbxs9d5GNyAo75nZtwy9JBiLujXRiAfPBGbHSjsMLGQdGFe1GTRBHdNLnN7QCy0/qCuc
         nlzj1QPCRcO8CXbdEltd6LNpSY09fiOxoyCiR992J7hJ8VSIzIZZ9pyO2UndSAzZHUIR
         bF+TmT1tYZvxwR5ikFTxHNy7Ys8+L9cV1uAX7FX9WOW9lR4biMHB2M+1sgFMP4U2r1LF
         oaM8s3A5f5/JqyZPJXGT8Gt75GOo/YXqAG74I5fjeLKcaf+R4YjM3+7CLmh+w5UP3haV
         9cuw==
X-Gm-Message-State: AOAM533qhwfDHmkhOOE/ICIif9YAkjifwyeMMat6HdIgOA7VD+OAw6Pn
        WUSfmfOsaRQJmg3OE8UR84kkTQ==
X-Google-Smtp-Source: ABdhPJywmhpBzovEAGLAlFReddqtfL+7gRfxRwqhTffp+Of1COtfe+1K/C/r12SNHYB9tQ7E7aOY9Q==
X-Received: by 2002:a17:902:bd8d:b0:13a:8c8:a2b2 with SMTP id q13-20020a170902bd8d00b0013a08c8a2b2mr1103469pls.89.1632767223468;
        Mon, 27 Sep 2021 11:27:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p26sm16995621pfw.137.2021.09.27.11.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 11:27:02 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH 0/2] bpf: Build with -Wcast-function-type
Date:   Mon, 27 Sep 2021 11:26:58 -0700
Message-Id: <20210927182700.2980499-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=813; h=from:subject; bh=MnT3y2POoh9krBGr+oM0LKIH9K7M9hDNGXXQn9PnoRw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhUgzzvGdW82BhK8YP1w6/r5Vk4Bo4qJhhkmiN8oKK zuSXBkqJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYVIM8wAKCRCJcvTf3G3AJhHyD/ 92lm82tkG/wPJiioqfs+Kxaa88GuCYKYWWP/IpncLQxmww37DgGOH/Wl/oJrhtTcw8GZZpOoNH3sse 7rn2JRT4QSEt5CzLLoD05pa6ceTWKIjkJ/d/VXCqNv+AfWepP3FacdWj60HKye/chGORzdj39B1tvC v62lA+y14QDzdx/r3AZ9MVzrnNaQFo4toGxCBRp7MnHFxL/mEv4cgPPAjFTfouI8vjnDy9GxHwlWnC xRONH7W48GvmgxCCtQg8Xmj380nJ/j3EImlyRlV0GulKQE8HUggfHnCp0BhmGL+RnuYJgfcpRkeO8F xI5c1r+1N6SZdUoRpQeXoaXu06lnFVybmVEa2qQwbq8zB0lCmpWH4moHHvk2EJ6lejNPCr8Tqbhyz7 2Sfh9Wzdb0IwASUho4vpo8yC3j3Z1EglOYMbTnM0yfx9K8vVmDNfJAi07mlFimGY/El21EE+vEb0Bb ZWJEP5ZsVJoI2H+wJXoNMM1rYE9WVWNJlCakhG7SJKxKbe85sJ6Z0/bPeukf+StZP+PhGG9uYGsygG kTPKuc45qiVI4IKKLnwhHm4B8BAg8WqCGUqePAvbi0tIopgbzqU37XmEc07HeCiwfr70U+YuVMs2wD x8/ZL4nbwMj00/sy7GZ/kgYZFPRtsLQ2djb0/g0c0gZAzlD9lQHeSbx4nrmA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

In order to keep ahead of cases in the kernel where Control Flow Integrity
(CFI) may trip over function call casts, enabling -Wcast-function-type
is helpful. To that end, replace BPF_CAST_CALL() as it triggers warnings
with this option and is now one of the last places in the kernel in need
of fixing.

Thanks,

-Kees

Kees Cook (2):
  bpf: Replace "want address" users of BPF_CAST_CALL with BPF_CALL_IMM
  bpf: Replace callers of BPF_CAST_CALL with proper function typedef

 include/linux/bpf.h    |  4 +++-
 include/linux/filter.h |  7 +++----
 kernel/bpf/arraymap.c  |  7 +++----
 kernel/bpf/hashtab.c   | 13 ++++++-------
 kernel/bpf/helpers.c   |  5 ++---
 kernel/bpf/verifier.c  | 26 +++++++++-----------------
 6 files changed, 26 insertions(+), 36 deletions(-)

-- 
2.30.2

