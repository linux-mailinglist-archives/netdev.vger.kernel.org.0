Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB141C7B8D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgEFUxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728172AbgEFUxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:53:01 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B013C061A10
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 13:53:01 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h186so3146332qkc.22
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 13:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CQcbxKSUYsAHBe7Ebehk8JAKNTVPAr/UiGZDOPwaAGc=;
        b=Qc2qN9c83pfJHD8uho1tepgh5pW6tBfZF37n4CM3MD32Y0xOob1XZT1Xv+y3pZ+qx7
         dBB3TftZel2t+tBVFBd8Gmpd8I5YkwQYtydO5Ubo9P4sTrTHbdqfX4CpaxnQmWfWWvgM
         GB0IZxjFVxH21WEMvJry1tpuESxde2u8nQYSHCdadbK+JU0TiFO0kVdGrVkPTvGBJVbo
         hK0NlJTJiZMfi1lUhirdBpVEgN4skITYyCBi0AVgxXzHXTLJ47/oWq3xpYZd9ylfxUj9
         u5EyHrWqrjBvrtX8v6pNmKv7i9YRjxMyZS2xaYfpjkuEcvzXdsdCBIu7GTDszAEDs3cX
         ApSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CQcbxKSUYsAHBe7Ebehk8JAKNTVPAr/UiGZDOPwaAGc=;
        b=tyP7HSz90VB/BzGZgVelBTyQ5STbb3z8bogmU9s2cq3EYJRE0VIgbfF6r9XlnJ8ZQr
         F2vByrVmQptYI9qCSGWE0I1zjDDHK5V3/sqAfMZMkk0EBhfTjK2Gq3TTOcbTiTKqingN
         GoPPau4OHGZB4a1c0dsDIht9hPy1HK3kIHqjRZM8WB+N35plTGf+I7ibJnlyUlE/Pm19
         chf3TM5nd5mmWsbn9d3xsFaPPW8o2aW5/Fcx/rF1EiF9uW6YmEz6J4ZK2Kj3ZeEMo2mf
         kdJOjq/T5arQ2XAbU4uU/oEq5UpMS3RrwkVYxrOFhb6OWqzHntdkIZ+ZpmM2HbG+FGsS
         n2gg==
X-Gm-Message-State: AGi0PuaYR4t0/hNBSc3ULmTBUmVdx7fKDp+OhYfF/27XFN1YnNRVarWi
        j9V34XPd7P12BN/yzxkXzhOflzgBhZAd
X-Google-Smtp-Source: APiQypIdNrd+yYhBZP4TBZUTUJU1co/gZ+3o6Cxir236qhPBm0psRF02DA8GRECv92XUv8iiH2WZiB7LkvTh
X-Received: by 2002:a0c:fc42:: with SMTP id w2mr9758882qvp.77.1588798380452;
 Wed, 06 May 2020 13:53:00 -0700 (PDT)
Date:   Wed,  6 May 2020 13:52:55 -0700
Message-Id: <20200506205257.8964-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH 0/2] lib/bpf hashmap portability and fix
From:   Ian Rogers <irogers@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm experimenting with hashmap in perf for perf events within a metric
expression. In doing this I encountered some issues with lib/bpf
hashmap. Ignoring the perf change, I think these fixes are likely
still worthwhile. Thanks!

Ian Rogers (2):
  lib/bpf hashmap: increase portability
  lib/bpf hashmap: fixes to hashmap__clear

 tools/lib/bpf/hashmap.c | 6 ++++++
 tools/lib/bpf/hashmap.h | 3 +--
 2 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.26.2.526.g744177e7f7-goog

