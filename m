Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D3345730A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbhKSQfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:35:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236354AbhKSQfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:35:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC768C061574;
        Fri, 19 Nov 2021 08:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=rOZ+ANybst6AtHDNRAt3UP4pF4f4L5Iq5XPXW8zXicM=; b=tqBqXPXFtj8PRSYSvxUcyOPHTK
        uGSBIB0GkgrR2QGN7rzpMJBTyWwxhjHVqqekripIXcq19KDobqC1wu2lY0gd6ZxLg2FUPtrRJgc5E
        8C1ghTQjU2nK4FZ0EN3lC7RzqevCYI8MeDURLIyxdE3DmiW8V6seeN++yLN8yJEOditwq1wu9JM7N
        xTNi6w0Ntau3EH0oWaOmeXeYqUXufVFH6s1D+jJkybsWC3jzsX4uuwsja7r4ZAlvv9fYEboV3IOPe
        yUQE+ttevi+FNt8I4XDNC2eSGVN6RONzxnPaHSomz7TEA4ye68kNWwCfyHzPCgsmDE/Lp+M4XBBDK
        h+BgCAcg==;
Received: from [2001:4bb8:180:22b2:ffb8:fd25:b81f:ac15] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mo6oC-009gCj-Cj; Fri, 19 Nov 2021 16:32:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: split up filter.rst v2
Date:   Fri, 19 Nov 2021 17:32:10 +0100
Message-Id: <20211119163215.971383-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

for historical reasons filter.rst not only documents the classic Berkely
Packet Filter, but also contains some of the most fundamental eBPF
documentation.  This series moves the actual eBPF documentation into newly
created files under Documentation/bpf/ instead.  Note that the instruction
set document is still a bit of a mess due to all the references to classic
BPF, but if this split goes through I plan to start on working to clean
that up as well.

Changes since v1:
 - rebased to the latest bpf-next
 - just refernence BPF instead of eBPF in most code
 - split the patches further up
 - better link the BPF documentation from filter.rst


Diffstat:
 Documentation/bpf/index.rst           |    9 
 Documentation/bpf/instruction-set.rst |  467 +++++++++++++++
 Documentation/bpf/maps.rst            |   43 +
 Documentation/bpf/verifier.rst        |  529 +++++++++++++++++
 Documentation/networking/filter.rst   | 1036 ----------------------------------
 arch/arm/net/bpf_jit_32.c             |    2 
 arch/arm64/net/bpf_jit_comp.c         |    2 
 arch/sparc/net/bpf_jit_comp_64.c      |    2 
 arch/x86/net/bpf_jit_comp.c           |    4 
 kernel/bpf/core.c                     |    3 
 net/core/filter.c                     |   11 
 11 files changed, 1063 insertions(+), 1045 deletions(-)
