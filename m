Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B97631BE32
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhBOQCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:02:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27213 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231243AbhBOPyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:54:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613404366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8W8oyOtoFedTd8/MN5RpicRNGAenQQvPM4O0fxYaAF8=;
        b=YpnioPa8cqSbHsPqlrjamrTuWIQ0XyIZQyn0lHU3Xfx2lHvkdoHMc5KfI7EzUN60gEruXR
        rxDg4PjPSk7sqFLppvGgel5uSmxUnOtBAl6nzDvgZQHN73PI94DwK3lXYhBWP+iV/0Dp3c
        HsEc+6OQ+oj+UnTX1rqGvz7acdgv7g4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-nhGW2NJXPzqgAZ568KL1-A-1; Mon, 15 Feb 2021 10:52:44 -0500
X-MC-Unique: nhGW2NJXPzqgAZ568KL1-A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78598107ACE6;
        Mon, 15 Feb 2021 15:52:43 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D680A60C0F;
        Mon, 15 Feb 2021 15:52:38 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B6C1530736C73;
        Mon, 15 Feb 2021 16:52:37 +0100 (CET)
Subject: [PATCH bpf-next V1 0/2] bpf: Updates for BPF-helper bpf_check_mtu
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 15 Feb 2021 16:52:37 +0100
Message-ID: <161340431558.1234345.9778968378565582031.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

Jesper Dangaard Brouer (2):
      bpf: BPF-helper for MTU checking add length input
      selftests/bpf: Tests using bpf_check_mtu BPF-helper input mtu_len param


 include/uapi/linux/bpf.h                           |   17 ++--
 net/core/filter.c                                  |   12 ++-
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |    4 +
 tools/testing/selftests/bpf/progs/test_check_mtu.c |   92 ++++++++++++++++++++
 4 files changed, 117 insertions(+), 8 deletions(-)

--

