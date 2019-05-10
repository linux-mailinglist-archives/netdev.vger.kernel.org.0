Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1134619F8E
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 16:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfEJOvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 10:51:40 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37291 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfEJOvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 10:51:39 -0400
Received: by mail-wm1-f66.google.com with SMTP id 7so1824626wmo.2
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 07:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=6LGGcB7ZoPAoJ3CF1IjStAUcu9/Mb+1LvT//iHSLJhs=;
        b=DLQQWjKiwiTwGj2DwxxjmShlz8xhm2ovlp8+dQkRhT7W6kcvhBO3OnAgikNrcTqt9w
         F7dDKuG8l3mE50AWnFvFsf7vBiLYUkNYq/r6dyqOuX4hhtT40DmusCW9szx4MXy9TWce
         7Vh1qh5RS6gd3Y5J1pEN1cYEO6ic303myPb9Rr8vt94QlbBhG75QIB97nDIcSQ0FQkTQ
         TAWJ8Y9akSRWqCzUujh5BxOX7D71x49Q98Wg9lqrPYj6umojEjH3D9NfPy/nTybGulmP
         6hkKP6PogUGlhJW5pG4DUR4vHCq+f8ENkis4I6+ImQ4VY5hgpvoyZ4kWW6kI2OmyQHQO
         v/bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6LGGcB7ZoPAoJ3CF1IjStAUcu9/Mb+1LvT//iHSLJhs=;
        b=RT8xwhDSnK/ckRY8inGd4ul5mx2Y15OnaO5ch4GD9Ig2EIp0G5yCYhNfriaOlpC0a0
         9xsx3Cj0oZZb1KPj63URN/5UlSTZ8wkxjrNvT8LVO6+X3SXI41QSDRD0LAovqBlJJEVR
         RbO1PaBOsOC+zMfBTkOZMya6JAKx10UadksT7cxET1q1BksttPubaoQwA87MOxrPjHtu
         5mAACCkl6VyOXBbBHnY1wFJZWA8g3CGg6zSzCq21cSEjRbM8KB63aSD0aOBu6HRw6xq1
         ccJzJ8MJItH8stSGgicP7SWd3G9Pi7svmeX86TKs/XXZ7JywC9gARDp2yVIWvAiwM1GQ
         BBUA==
X-Gm-Message-State: APjAAAUkVmbqJH4PkuyDg2ZKeQqOAUjaAe9ixDamFXGqfw89SQAtu6vn
        mheMwLnk+BvpeyPhipISgMUySg==
X-Google-Smtp-Source: APXvYqyh6upZS93umpI5UrYbS8EhdgsUkxY5yhuViGPT+LDNS7iXSt9BqZfXOZvA1t9bYjdNYTsEDg==
X-Received: by 2002:a7b:cb85:: with SMTP id m5mr7598655wmi.75.1557499897880;
        Fri, 10 May 2019 07:51:37 -0700 (PDT)
Received: from reblochon.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id p17sm7561027wrg.92.2019.05.10.07.51.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 07:51:37 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf 0/4] bpf: fix documentation for BPF helper functions
Date:   Fri, 10 May 2019 15:51:21 +0100
Message-Id: <20190510145125.8416-1-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.14.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another round of fixes for the doc in the BPF UAPI header, which can be
turned into a manual page. First patch is the most important, as it fixes
parsing for the bpf_strtoul() helper doc. Following patches are formatting
fixes (nitpicks, mostly). The last one updates the copy of the header,
located under tools/.

Quentin Monnet (4):
  bpf: fix script for generating man page on BPF helpers
  bpf: fix recurring typo in documentation for BPF helpers
  bpf: fix minor issues in documentation for BPF helpers.
  tools: bpf: synchronise BPF UAPI header with tools

 include/uapi/linux/bpf.h       | 145 +++++++++++++++++++++--------------------
 scripts/bpf_helpers_doc.py     |   8 +--
 tools/include/uapi/linux/bpf.h | 145 +++++++++++++++++++++--------------------
 3 files changed, 154 insertions(+), 144 deletions(-)

-- 
2.14.1

