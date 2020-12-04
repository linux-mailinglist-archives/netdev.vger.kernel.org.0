Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607F82CED95
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbgLDLxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:53:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20455 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730136AbgLDLxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 06:53:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607082734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4z8KXODqjwtErk41YpHMDb+O7Bt3e78Uq4SI4fcpBVc=;
        b=ZxfA/AkZA0Re0qKTLXV7NaDJ42+phaX5Ez3YCEZrHTnYqnpy/ZKufX3dJ2abKLgzAkaADa
        7ivvogPCRLo5wczW9u+/zAsnBd8wLtJ06d++0HSYnmbvc5oXNBfw/YTiX2wDf1eyUf4unn
        v03Y5xpkeJf1WPzVZjc3fsxZdENThf0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-w40M6VQIOwikbuju7gPUHA-1; Fri, 04 Dec 2020 06:52:12 -0500
X-MC-Unique: w40M6VQIOwikbuju7gPUHA-1
Received: by mail-ej1-f71.google.com with SMTP id f21so1976364ejf.11
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 03:52:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4z8KXODqjwtErk41YpHMDb+O7Bt3e78Uq4SI4fcpBVc=;
        b=H+8o5tYbOF7RvsAdh0Z7f8BUGjFC06t1tXVr8mmjLWUce3iUyh4Z8ZqaG7kpe19AZp
         L3bfNEK06gBHJPJ9o6tBOxsXJ/+UfYj1J7+2b3IGhMU0f7YL87WmmWOT9phntJ93BEjd
         v9ifXq8eKckk+kme6qJfRKzKVtLt6JgnRulxE3BDXnTJUO3Gol5WQAE2GSTtqt+kgAUO
         dYG268xjTnRM3N8gnslms7GfdWK5ZbamtIA9SBhqnq7/xYoPNx1uqeYkby8fqCjenP/J
         mBxJ0gTQNHPuMhumMMFb4QJsLrYrRuZ4nwJXTQvN2/CVpP/r/xSn+lCjML3PujIFThGk
         QYRw==
X-Gm-Message-State: AOAM530EktAUECVU3/tROQc2SaiUYIY8GgkQXDuz3E1qVxcwfvQcaVMW
        2rhaGntlpLs31lNFc0f6XbDEQ3cCs+hotc3mkta+iYlVsDx02CZVCfm+nLH5MKEEBbDGUg9mB/L
        zQzVVLYHW7p+bKH6f
X-Received: by 2002:a17:906:8042:: with SMTP id x2mr7188288ejw.79.1607082731756;
        Fri, 04 Dec 2020 03:52:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzrtWb6FuuLro5ty8zueEEvZOWwhg6p8KPWy4h8kxmLPsduHpi83CLwjqt251LWSV2eebcO4A==
X-Received: by 2002:a17:906:8042:: with SMTP id x2mr7188267ejw.79.1607082731598;
        Fri, 04 Dec 2020 03:52:11 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n16sm3284713edq.62.2020.12.04.03.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 03:52:10 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E1EBE1843EF; Fri,  4 Dec 2020 12:52:09 +0100 (CET)
Subject: [PATCH bpf v2 7/7] selftests/bpf/test_offload.py: filter bpftool
 internal map when counting maps
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
Date:   Fri, 04 Dec 2020 12:52:09 +0100
Message-ID: <160708272983.192754.10060052789845857257.stgit@toke.dk>
In-Reply-To: <160708272217.192754.14019805999368221369.stgit@toke.dk>
References: <160708272217.192754.14019805999368221369.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

A few of the tests in test_offload.py expects to see a certain number of
maps created, and checks this by counting the number of maps returned by
bpftool. There is already a filter that will remove any maps already there
at the beginning of the test, but bpftool now creates a map for the PID
iterator rodata on each invocation, which makes the map count wrong. Fix
this by also filtering the pid_iter.rodata map by name when counting.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/test_offload.py |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index 2128fbd8414b..b99bb8ed3ed4 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -184,9 +184,7 @@ def bpftool_prog_list(expected=None, ns=""):
 def bpftool_map_list(expected=None, ns=""):
     _, maps = bpftool("map show", JSON=True, ns=ns, fail=True)
     # Remove the base maps
-    for m in base_maps:
-        if m in maps:
-            maps.remove(m)
+    maps = [m for m in maps if m not in base_maps and m.get('name') not in base_map_names]
     if expected is not None:
         if len(maps) != expected:
             fail(True, "%d BPF maps loaded, expected %d" %
@@ -770,6 +768,9 @@ ret, progs = bpftool("prog", fail=False)
 skip(ret != 0, "bpftool not installed")
 base_progs = progs
 _, base_maps = bpftool("map")
+base_map_names = [
+    'pid_iter.rodata' # created on each bpftool invocation
+]
 
 # Check netdevsim
 ret, out = cmd("modprobe netdevsim", fail=False)

