Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171222D43B9
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgLIOAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:00:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732679AbgLIN7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 08:59:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607522266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MU7CQgT+A+S9BhvCz6Q80+yj2qZjKz+oqKrOC0MV6ss=;
        b=cfbqpwi3fscj+G8riFtmkWBpCPZyQsms1zkfwBTQeWTbrlN0HQee4IdLZJKEKLoTsJLnjK
        GOwFYTDnsv5fAFDNLcTwrnTISiMdl04SZ552Lf0ydaigRkma1D0tVWBJTThH1w8y02OuZ/
        6OyU321KEczrfU9mKlEqCLlM5Um1QJs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-hzY7tMXRMiiK0AHcIRYTYA-1; Wed, 09 Dec 2020 08:57:45 -0500
X-MC-Unique: hzY7tMXRMiiK0AHcIRYTYA-1
Received: by mail-wr1-f70.google.com with SMTP id o4so678642wrw.19
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 05:57:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=MU7CQgT+A+S9BhvCz6Q80+yj2qZjKz+oqKrOC0MV6ss=;
        b=pldRXewXDQz4QMnd91UJnqOKj1xtOONjKD4UGqY3ohkESQ3J977mOa+GZqTD/MQHSt
         p1n6ZbKOTzlYfPH6GTzxJYkvkRJTXNfrLXvCi1YkujvbA6pg47Zwsd6SeBJbzW7gu7W+
         p8HDYSD8vyHz1W1Wn8DXRcgR3WS/IiZ8yDt1w0tY79IIcbpRLNyE14oLf0Tbk2VMQK57
         T4aHHuiw8xUMDJsAbVTZTwJipdUOnfU4h+w1WuhCqCE016xYD9hJChK+z83oteJA+MZ6
         paVPuxNAkcuE3TwN5Lm3Iu3Yc69KnlB7hplLwL2IYhUNWNjylGHLqiZhLnUcaihYK+PU
         iPfg==
X-Gm-Message-State: AOAM532ossP736df3dCQGjOYxQNtjt4Mm3/X5rJT21mker6KTX7GCAKq
        erQmOdq1Oa1c7Oi97SRJZNXEf+mpljaSACebw68nQgTBs0sn7jupHt+626t9Kap6zg/x0AePspc
        UXzptE/Voznuv3i/e
X-Received: by 2002:adf:b1ca:: with SMTP id r10mr2907513wra.252.1607522262870;
        Wed, 09 Dec 2020 05:57:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzEdQcGyzmkPOb0WiJgxV3ltkO/5FZhc3UVm9wXnk0V2hSLZwg/ifKKfI1NBVNaOt6phydLHQ==
X-Received: by 2002:adf:b1ca:: with SMTP id r10mr2907473wra.252.1607522262599;
        Wed, 09 Dec 2020 05:57:42 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a21sm3422827wmb.38.2020.12.09.05.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:57:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C48CD180003; Wed,  9 Dec 2020 14:57:41 +0100 (CET)
Subject: [PATCH bpf v4 5/7] selftests/bpf/test_offload.py: fix expected case
 of extack messages
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jiri Benc <jbenc@redhat.com>, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Wed, 09 Dec 2020 14:57:41 +0100
Message-ID: <160752226175.110217.11214100824416344952.stgit@toke.dk>
In-Reply-To: <160752225643.110217.4104692937165406635.stgit@toke.dk>
References: <160752225643.110217.4104692937165406635.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Commit 7f0a838254bd ("bpf, xdp: Maintain info on attached XDP BPF programs
in net_device") changed the case of some of the extack messages being
returned when attaching of XDP programs failed. This broke test_offload.py,
so let's fix the test to reflect this.

Fixes: 7f0a838254bd ("bpf, xdp: Maintain info on attached XDP BPF programs in net_device")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/test_offload.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index 61527b43f067..51a5e4d939cc 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -1004,7 +1004,7 @@ try:
                               fail=False, include_stderr=True)
     fail(ret == 0, "Replaced XDP program with a program in different mode")
     check_extack(err,
-                 "native and generic XDP can't be active at the same time.",
+                 "Native and generic XDP can't be active at the same time.",
                  args)
 
     start_test("Test MTU restrictions...")
@@ -1035,7 +1035,7 @@ try:
     offload = bpf_pinned("/sys/fs/bpf/offload")
     ret, _, err = sim.set_xdp(offload, "drv", fail=False, include_stderr=True)
     fail(ret == 0, "attached offloaded XDP program to drv")
-    check_extack(err, "using device-bound program without HW_MODE flag is not supported.", args)
+    check_extack(err, "Using device-bound program without HW_MODE flag is not supported.", args)
     rm("/sys/fs/bpf/offload")
     sim.wait_for_flush()
 

