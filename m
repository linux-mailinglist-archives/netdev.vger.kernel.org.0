Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA79F55AFB
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFYWXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:23:35 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:53733 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYWXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:23:34 -0400
Received: by mail-qt1-f201.google.com with SMTP id h47so298458qtc.20
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 15:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FdBlpsagwTRJbMA7Hzk2BzRggzKya+4KQ7pkEf2Z5gw=;
        b=ZjaQkMYUkVw2qRpcALtuunmsZ+Zwf46cVly3MO9ik/a08Obk5OT8J2DESoeGq0lMmO
         wbpr94q9HezhukSylrQ//o0WIt/qVQK7QQzrmj8myVJg0r1qmp/3KTnN+QPFKR04RYBv
         iKJTH/dd6m6YLLBgWT73W5pkpY/+m3r7JtgxrKT4dDtHqhSTx9G4PRvaNmaozy+Ej4bo
         hmaTq88FLWZRlpto+jOlTjU2Ld3zX+OFqG3fQtFmAZczAjlIR/4gM/ac8b0ANa0qy6CQ
         WHAX4UkqSyAfQiz/rVxgGo2ekmVXsr66zB5TUAk9nQkZOU5tOWQ23p4w3S3ECQZSO0UD
         rL4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FdBlpsagwTRJbMA7Hzk2BzRggzKya+4KQ7pkEf2Z5gw=;
        b=SN6Dp+VijRq2l5OIOZz5CaAtvnrYgpPdZdjSo6a5ykTjRn+LOGFWH6OFIaYZIHXJ8W
         b0BmPtv2FE8CGFL8Z2X/F7OPXbOxarhxyemNdIdGTDq8aWQ4rCMWbg6ZConCLmAn+x4D
         spGEFi4fNHkQP6Lir1gl0ZsGzT/tPVE5bsaYGHZDn1RXKUozeyTaqhi+aKoeJbliz12k
         mls/Gs+Esfx6s0+/YvnpJustInem2x1Xsp1MV+QuuFsCOjK5RCq7L6nn7+iGGyzlRk8C
         qx0wLi+zQf0AyVbgW6UnuDocPhsbpTVB2ibmNbQqj0RvGsqNzmNwaJPzdPp2jbyw0tAC
         O9sQ==
X-Gm-Message-State: APjAAAVHBy+IgPyamX5fDJxqwXoolic0HY4rxnIE9/0oFtGwCo7zci+9
        sJejcF3fOOnoBHafIGBcteQjeI7o9xw/aG9e
X-Google-Smtp-Source: APXvYqx3scg0ElyPMQwkLEek4soTUEO+ZZuGgUXriNHcDBT2orpnKlALW2BAm20RFpwGt0QKe1eFKDmGWUix9mdZ
X-Received: by 2002:a37:9e4f:: with SMTP id h76mr863302qke.469.1561501413909;
 Tue, 25 Jun 2019 15:23:33 -0700 (PDT)
Date:   Tue, 25 Jun 2019 15:23:27 -0700
Message-Id: <20190625222329.209732-1-allanzhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v5 0/2] bpf: Allow bpf_skb_event_output for more prog types
From:   allanzhang <allanzhang@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     allanzhang <allanzhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Software event output is only enabled by a few prog types right now (TC,
LWT out, XDP, sockops). Many other skb based prog types need
bpf_skb_event_output to produce software event.

More prog types are enabled to access bpf_skb_event_output in this
patch.

v2 changes:
Reformating log message.

v3 changes:
Reformating log message.

v4 changes:
Reformating log message.

v5 changes:
Fix typos, reformat comments in event_output.c, move revision history to
cover letter.

allanzhang (2):
  bpf: Allow bpf_skb_event_output for a few prog types
  bpf: Add selftests for bpf_perf_event_output

 net/core/filter.c                             |  6 ++
 tools/testing/selftests/bpf/test_verifier.c   | 33 ++++++-
 .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
 3 files changed, 132 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c

-- 
2.22.0.410.gd8fdbe21b5-goog

