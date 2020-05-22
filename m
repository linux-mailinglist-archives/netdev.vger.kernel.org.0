Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA5C1DECF0
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 18:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730534AbgEVQLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 12:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbgEVQLq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 12:11:46 -0400
Received: from localhost.localdomain.com (unknown [151.48.155.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C238C2072C;
        Fri, 22 May 2020 16:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590163905;
        bh=B+KugRx30gpqmqRXKe9lCkSukr1khZhgLQ6Kvm0cezI=;
        h=From:To:Cc:Subject:Date:From;
        b=RNlnNGYZ3e4/x3twOeW8mYZZ9FRUCFamrod1I6NwNYZ40pvy+sv3f36coJZEDOUXB
         zN0Ehcb34gb+tW4/fghCcgHw0AWYfoNGDKO6TCb3rV6zWQ0YAfkts4POjOlVTkVam4
         wdKJUeqsDwHMIZmwegVwEEI/lcXEyomiEeiZhpso=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, brouer@redhat.com,
        daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [RFC bpf-next 0/2] introduce support for XDP programs in cpumaps
Date:   Fri, 22 May 2020 18:11:30 +0200
Message-Id: <cover.1590162098.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to what David Ahern proposed here [1] for DEVMAPs, introduce the
capability to attach and run a XDP program to cpumap entries.
The idea behind this feature is to add the possibility to define on which CPU
run the eBPF program if the underlying hw does not support RSS.
Even if the series is functional, at the moment some bit are missing
(e.g XDP_REDIRECT support or defining a new attach type).
The goal of this series is to get feebacks to add missing features.

[1] https://patchwork.ozlabs.org/project/netdev/cover/20200522010526.14649-1-dsahern@kernel.org/

Lorenzo Bianconi (2):
  bpf: cpumap: add the possibility to attach a eBPF program to cpumap
  samples/bpf: xdp_redirect_cpu: load a eBPF program on cpu_map

 kernel/bpf/cpumap.c                 | 111 +++++++++++++++++++++++-----
 samples/bpf/xdp_redirect_cpu_kern.c |  24 +++++-
 samples/bpf/xdp_redirect_cpu_user.c |  83 +++++++++++++++++----
 3 files changed, 185 insertions(+), 33 deletions(-)

-- 
2.26.2

