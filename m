Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BED5331184
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 15:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhCHO7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 09:59:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231148AbhCHO7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 09:59:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615215561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FzrZY3kdadmKkYLYKaxp0O/bmgBTVjzWf4MuqaU6rL0=;
        b=HPkRnq/7sAFjE9vKiFsW/Ujf4xGxN9dzLVab1o8OFSZb87Vs2DKZlbpWHtZ/2F9VCkFKhO
        NyoTA/+6/rzz6m7TS7wkAZz3Vl0cBWXeIjdDy2Is83iXgb1TvgIEOhNfx4BmWr4Q3lIQe3
        2iStGr6wCedBRN04e8GmiLTsbZckD7Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-dJpEyGtgO0SdWN5EILSdOQ-1; Mon, 08 Mar 2021 09:59:19 -0500
X-MC-Unique: dJpEyGtgO0SdWN5EILSdOQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 279E919057A2;
        Mon,  8 Mar 2021 14:59:18 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEBF510016F9;
        Mon,  8 Mar 2021 14:59:14 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 79F2130736C73;
        Mon,  8 Mar 2021 15:59:13 +0100 (CET)
Subject: [PATCH bpf V3 0/2] bpf: Updates for BPF-helper bpf_check_mtu
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 08 Mar 2021 15:59:13 +0100
Message-ID: <161521552920.3515614.3831682841593366034.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FIB lookup example[1] show how the IP-header field tot_len
(iph->tot_len) is used as input to perform the MTU check. The recently
added MTU check helper bpf_check_mtu() should also support this type
of MTU check.

Lets add this feature before merge window, please. This is a followup
to 34b2021cc616 ("bpf: Add BPF-helper for MTU checking").

[1] samples/bpf/xdp_fwd_kern.c
---
V2: Fixed spelling and added ACKs from John

Jesper Dangaard Brouer (2):
      bpf: BPF-helper for MTU checking add length input
      selftests/bpf: Tests using bpf_check_mtu BPF-helper input mtu_len param


 include/uapi/linux/bpf.h                           |   16 ++-
 net/core/filter.c                                  |   12 ++-
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |    4 +
 tools/testing/selftests/bpf/progs/test_check_mtu.c |   92 ++++++++++++++++++++
 4 files changed, 117 insertions(+), 7 deletions(-)

--

