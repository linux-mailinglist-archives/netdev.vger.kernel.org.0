Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B75E64BF8
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfGJSSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:18:16 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:38844 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfGJSSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:18:16 -0400
Received: by mail-qt1-f202.google.com with SMTP id r58so3066437qtb.5
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=zmcA7W2KIeWO/NRsKmCZUnKStbXYZh1rptXN3dSxoGk=;
        b=oWd53YTo5cXnFyc67/rtOEqvGwbEId1VE1PQPGJhU8CKOgf4Vv/SNsbavZfUUTyr1y
         /pb7memZyEcxVieTJr965Nysph/Cy1XHGB+HglRD3BS4ktw06PQiKQuxCS2znsQHwZuo
         Ibd9pSm5enLMl/Z5tVobkSQvQiCqngIdJvmCA9h4xsQY274CixMyoNLVKN5jPSqF9N54
         JDftuBvKnX4ozurkmHC8jbBObl1UF806LmTpvvY704E+JrfuP62H+btlRB0IGhKZOTEf
         /3So4SXi2H7NSW6SUFie8lB0fVZm8/+Cahpx9r6I736NIU2ZqLBGQnjLQ1i005j9BesQ
         O5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=zmcA7W2KIeWO/NRsKmCZUnKStbXYZh1rptXN3dSxoGk=;
        b=jVzj5NmQPqxLhbPD1A6NL6zlTDTqndcBqhdf38DP9OPXsxB6x7jm+jFphuBwuox19j
         DyXREhn/6QO0bNbPt5nKSA61Vukua64PXHrQshlDBqMfSjMy29BRmKEqhAg2BntSOV8l
         Zxx5ZSbr26YjHgRUxgSaos81ogP02hsxpbrOOnupgsQI5/Hweq+k+/cK1BAz8VTO8b44
         jwkCy4CBouJr9bTaHhrSF3EseCUd+8djsGo685+lZoI4PX0Am6KA6Vr2mGDKls1kWVuZ
         owSTUBlCmqBTs7fv96h2zYk701jKE6RRQWiiISP77k4BvEpHtSfAWSLne/K5Ij0yz5nH
         WQ+g==
X-Gm-Message-State: APjAAAUpmXcGIMfRjlZY0gG/AldfE0zWtiX0lqBF7UQCNmF0Xck5y7Xb
        jP8y46Co/0H8JgFS7EFL4ebnmpR66Q1RQpg+Xc1nSe9CxcbNanBuP7nXcNcPd5QPlcv9efFUMBg
        hNDZAYe1pyzUjapD2hmiShB7dx4psMiQ8PSoTEf6LKzTTp97h6h1LVyy1LkhenIIr63sfeoAZ
X-Google-Smtp-Source: APXvYqzzFyw+K6sxOQVmsH6H8jXDOEOA5ORTIx2e1KL4UqEY5vJ8rRqqR5eSVRBZbWNMQDaDyZyvjZAjWlHCEAff
X-Received: by 2002:ac8:1410:: with SMTP id k16mr24525137qtj.335.1562782695250;
 Wed, 10 Jul 2019 11:18:15 -0700 (PDT)
Date:   Wed, 10 Jul 2019 11:18:09 -0700
Message-Id: <20190710181811.127374-1-allanzhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v9 0/2] bpf: Allow bpf_skb_event_output for more prog types
From:   Allan Zhang <allanzhang@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org, songliubraving@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com
Cc:     ast@kernel.org, Allan Zhang <allanzhang@google.com>
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

v9 changes:
add "Acked-by" field.

v8 changes:
No actual change, just cc to netdev@vger.kernel.org and
bpf@vger.kernel.org.
v7 patches are acked by Song Liu.

v7 changes:
Reformat from hints by scripts/checkpatch.pl, including Song's comment
on signed-off-by name to captical case in cover letter.
3 of hints are ignored:
1. new file mode.
2. SPDX-License-Identifier for event_output.c since all files under
   this dir have no such line.
3. "Macros ... enclosed in parentheses" for macro in event_output.c
   due to code's nature.

Change patch 02 subject "bpf:..." to "selftests/bpf:..."

v6 changes:
Fix Signed-off-by, fix fixup map creation.

v5 changes:
Fix typos, reformat comments in event_output.c, move revision history to
cover letter.

v4 changes:
Reformating log message.

v3 changes:
Reformating log message.

v2 changes:
Reformating log message.

Allan Zhang (2):
  bpf: Allow bpf_skb_event_output for a few prog types
  selftests/bpf: Add selftests for bpf_perf_event_output

 net/core/filter.c                             |  6 ++
 tools/testing/selftests/bpf/test_verifier.c   | 12 ++-
 .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
 3 files changed, 111 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c

-- 
2.22.0.410.gd8fdbe21b5-goog

