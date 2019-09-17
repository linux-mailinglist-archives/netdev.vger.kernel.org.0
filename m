Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B53C7B4F4B
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 15:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfIQNbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 09:31:32 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:49063 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726131AbfIQNbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 09:31:32 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id A026E3949;
        Tue, 17 Sep 2019 09:31:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 17 Sep 2019 09:31:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=uhE/vfnqybzdrsUOpjeY917kip
        DfITlsNpk0umiRhdo=; b=ot7xx72Uo7TcAMiBwtO2/SItXrLMSG0zRRjPWdrRmX
        +ARzYVeMVVz+3QFO7EbIHNcWn5umL1AeBbQvyfJQ4li9LX3YRd6tRKg0sKr3F2d8
        9pVy9K3SOca/dDXk9GHOt6ox+QElGyuez4SKyPTewjL+qieclViGFJJNwExBo0DH
        XYvl953WWHpUh0/FtLWklLP2xGiL5iUSIksUQ4rY66I7+xq7A0q+SLBhxkoZ1oUg
        rymd5cMpQ2XCAUMBiRKMPOugnTPXqYodHOl3py8+Q4N1lot+QGVNiUy5KxdIjuWD
        AeBvmPb6joma6X4IE39orwzgTg9yp+oSh2QgKxM6eBzw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uhE/vfnqybzdrsUOp
        jeY917kipDfITlsNpk0umiRhdo=; b=Q3zUB3OxJ5qFZVZ6fW5v2wxwFRc5EVcqA
        n0cPyCRAM5w9lkYlqNSoEMEpEohT461BueXTsWRKHsAdmebyYmHf+aQxnjO3e5U5
        6KCrvBSK0fxRn768ekBxsmL94T6U8zWrOeAEjIjNqot+lvW2yqO/ZaTjvySg5jsa
        OruMzJ4H1XKDXDSXtahCkVIRNjhJi6B9VY3BQAW0wa9hkg26AA13ARAUxxDFQ3k8
        8mn3Np0emgg6Hk0QgInDthPa7xL3OMX05HUw3ZqYD75zZIp0LyauM7u0+IPxo0yK
        IWcb/uHbZBTLWvr8mmLKsPxgOl08Pvgx1wXJvye8A8VCsVcsNcCbA==
X-ME-Sender: <xms:MeCAXYEG4Tp3yzO2Vkri9Lue4u1rFx850Q-w18ptikeTMYewqJDAYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeigdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephffvuf
    ffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceougiguhes
    ugiguhhuuhdrgiihiieqnecukfhppeduleelrddvtddurdeiiedrtdenucfrrghrrghmpe
    hmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihiienucevlhhushhtvghrufhiiigv
    pedt
X-ME-Proxy: <xmx:MeCAXbu_yKFdQ5Myo3XjICgCeKFkUYn7dEixxphC4dL9496n09z7Jg>
    <xmx:MeCAXYRE5tX0zc4o7Cy15QYEiOYEPWd74WNg3jMHgRkd9IzHm2JOmw>
    <xmx:MeCAXVPosLEDYC7ygArdMGchSqXMu8daorWtaPPgzQPx-BE6u28LuQ>
    <xmx:MuCAXbqvRTkzV5irFTH8JMdMQ2DEFhCQqhebxkRUbKUq9-n_ZF7jxyknemk>
Received: from dlxu-fedora-R90QNFJV.thefacebook.com (unknown [199.201.66.0])
        by mail.messagingengine.com (Postfix) with ESMTPA id 374CAD6005D;
        Tue, 17 Sep 2019 09:31:28 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org
Cc:     Daniel Xu <dxu@dxuuu.xyz>, ast@fb.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 0/5] Add PERF_FORMAT_LOST read_format
Date:   Tue, 17 Sep 2019 06:30:51 -0700
Message-Id: <20190917133056.5545-1-dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's useful to know kprobe's nmissed count. For example with tracing
tools, it's important to know when events may have been lost.  debugfs
currently exposes a control file to get this information, but it is not
compatible with probes registered with the perf API.

While bpf programs may be able to manually count nhit, there is no way
to gather nmissed. In other words, it is currently not possible to this
retrieve information about FD-based probes.

This patch adds a new field to perf's read_format that lets users query
misses. Misses include both misses from the underlying kprobe
infrastructure and misses from ringbuffer infrastructure.

I studied the code various code paths for perf software events and perf
tracepoints and it does not look like anything can "miss" in the same
way kprobes can. They can all, however, suffer from ringbuffer misses.
It's possible I missed something while reading the code so please let
me know if I am mistaken.

Daniel Xu (5):
  perf/core: Add PERF_FORMAT_LOST read_format
  perf/core: Sync perf_event.h to tools
  libbpf: Add helpers to extract perf fd from bpf_link
  libbpf: Set read_format PERF_FORMAT_LOST on kprobe perf fds
  libbpf: Add selftest for PERF_FORMAT_LOST perf read_format

 include/linux/trace_events.h                  |  1 +
 include/uapi/linux/perf_event.h               |  5 ++-
 kernel/events/core.c                          | 39 +++++++++++++++++--
 kernel/trace/trace_kprobe.c                   |  8 ++++
 tools/include/uapi/linux/perf_event.h         |  5 ++-
 tools/lib/bpf/libbpf.c                        | 30 ++++++++++++--
 tools/lib/bpf/libbpf.h                        | 13 +++++++
 tools/lib/bpf/libbpf.map                      |  3 ++
 .../selftests/bpf/prog_tests/attach_probe.c   | 32 ++++++++++++++-
 9 files changed, 127 insertions(+), 9 deletions(-)

-- 
2.21.0

