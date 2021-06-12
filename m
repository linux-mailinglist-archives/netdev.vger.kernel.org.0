Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FF43A4C43
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 04:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhFLCjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 22:39:31 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44017 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFLCjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 22:39:31 -0400
Received: by mail-pl1-f193.google.com with SMTP id v12so3724406plo.10;
        Fri, 11 Jun 2021 19:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IITX7U/U2NxdQ4BXZwOJpYFoyLbJ0R4PGybi+Tq0JRM=;
        b=qLhWylQHjo/V0ABaewfoPz2kj0xo0y+oG51iT858MekfOVQ2vMaSou6Bk7AFE7Bty6
         qKfvUhqpnNLik+UH4NEN/cZl/l9rEkAoEWmiLHmVuqk/jJ14ahtoxxdT34f9mii1qRCj
         gvuwkfdfmfQCep7zsZyF2/Jscq6cIcTBWQHqd//zcmEsXPs7CA1asdvZ7P21joR1q6aC
         RqyAxNawNjIPu8PLjA+f+3DQV1WEWgl+KjuW8cZHlozYlAvhYHyneGLTJ39htUxy6I1P
         r3RBZ1DqRHQuOLPQCzBOUxrEtX+grae4OgBsiZ65EtB8hoGyktstWaGhF2VJvoedCA/C
         1V2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IITX7U/U2NxdQ4BXZwOJpYFoyLbJ0R4PGybi+Tq0JRM=;
        b=irPuKuxjRkJp0WBCw6CENkmpgaNgydkwkzamZdKWP5j7k7To5r7KCDUKbEcNEuhlJo
         8xqFCVhpgcTT/PvfwPPADDmGkVSgbTdX/Yz6KFdPQfKPv5lfKqY6WFhZCHGkQxXqehxU
         kfsrULhruS5BdEdpq3vM1VQ8eA2CURSdIMoUjIyJlqnPKGfjXF4MhEHzlz8wHNJiZNry
         6NLf4lHNqa0inJBrqjJbnK6flPHXBAiMKsMzaV501H9cIcYGCJWIAc2fm/ejWqEhTC1v
         t2wtSM8T0HOtT7+LLk9tDSIhKq7lKyOGM9JzKsxmhyaNi4oiybXV/2RqQGSd0McJCNi/
         H+nQ==
X-Gm-Message-State: AOAM533Q3PFRYfsMwDTKOmxs+L7KRhstdhnSnPaxv1Dtn9CYU3IPEjcp
        CA/2JkcpjakiqA4t+R3r4+YRzmqK8lU=
X-Google-Smtp-Source: ABdhPJzFTmx0hBg0Jz7gl16khYdFFsmpdbuPl4Eyv3u8X/o6i6CqHoCsBUZ/XXCVQmpVbB4l5lNTjg==
X-Received: by 2002:a17:90a:d204:: with SMTP id o4mr7281964pju.23.1623465381271;
        Fri, 11 Jun 2021 19:36:21 -0700 (PDT)
Received: from localhost ([2409:4063:4d05:9fb3:bc63:2dba:460a:d70e])
        by smtp.gmail.com with ESMTPSA id fs24sm6059161pjb.6.2021.06.11.19.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 19:36:20 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next 0/3] Fixes for TC-BPF series
Date:   Sat, 12 Jun 2021 08:04:59 +0530
Message-Id: <20210612023502.1283837-1-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few simple cleanups. Two of these hopefully silence the coverity
warnings. Even though there is no real bug here, the report is valid as per
language rules, and overall it does make the code a bit simpler. There's one
other patch to add the forgotten NLM_F_EXCL that I spotted while doing this.

Andrii, would you be able to tell whether this silences the warnings? I wasn't
able to figure out how to run the Coverity suite locally.

Kumar Kartikeya Dwivedi (3):
  libbpf: remove unneeded check for flags during detach
  libbpf: set NLM_F_EXCL when creating qdisc
  libbpf: add request buffer type for netlink messages

 tools/lib/bpf/netlink.c | 111 +++++++++++++++-------------------------
 tools/lib/bpf/nlattr.h  |  37 +++++++++-----
 2 files changed, 66 insertions(+), 82 deletions(-)

-- 
2.31.1

