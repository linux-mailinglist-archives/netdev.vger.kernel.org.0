Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6434504F8
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhKONKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhKONK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 08:10:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67384C061570;
        Mon, 15 Nov 2021 05:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=d2uMZhA9obk8T7w9uue+4zDbuPs/Bacv52+x2d/0HxI=; b=dj//C+i8LVGHtLiZnrNfvsTjD8
        5OvL7/3yZ8EnybuWd9oSx2uo8Y22JGMhIznERQ7QNwqgydVJsrwDli4FWuqNRRqwSNG+XSoQ9v2iN
        MJDmYzLKFMjOKXUaE5g3gqRmfwrV6kwq4EoQZqkVmnsHc+Sj09LfMPqfiuGiPFvbYjUuEVfeYneOv
        kPp0EdksEXPYNw1hAtjDMgCg7aqVGxhQZJ0OIBreBXWA+tKlfYTkisLJk98kW6eApO6FI4mw4wfw/
        K6lLcufv6JwGmq1JXTB2YXGSslbS2C5ne9GIXINzTIwL+zNvM+qr6k1JptisPjCc11ZYshmOamtsU
        J7pTNmYw==;
Received: from [2001:4bb8:192:3ffe:2cb6:6339:4f3e:fe11] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmbhc-005hrZ-7N; Mon, 15 Nov 2021 13:07:17 +0000
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
Subject: split up filter.rst
Date:   Mon, 15 Nov 2021 14:07:13 +0100
Message-Id: <20211115130715.121395-1-hch@lst.de>
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

Diffstat:
 Documentation/bpf/index.rst           |   30 
 Documentation/bpf/instruction-set.rst |  491 +++++++++++++++
 Documentation/bpf/maps.rst            |   43 +
 Documentation/bpf/verifier.rst        |  533 +++++++++++++++++
 Documentation/networking/filter.rst   | 1064 ----------------------------------
 arch/arm/net/bpf_jit_32.c             |    2 
 arch/arm64/net/bpf_jit_comp.c         |    2 
 arch/sparc/net/bpf_jit_comp_64.c      |    2 
 arch/x86/net/bpf_jit_comp.c           |    2 
 kernel/bpf/core.c                     |    4 
 net/core/filter.c                     |   11 
 11 files changed, 1113 insertions(+), 1071 deletions(-)
