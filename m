Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A83148180A
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 02:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbhL3B1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 20:27:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50644 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbhL3B1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 20:27:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DE78615BB;
        Thu, 30 Dec 2021 01:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF86C36AEA;
        Thu, 30 Dec 2021 01:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640827666;
        bh=s26WabnK78sN9tQCrndeQKxJdVJVDJwBqtVU8Dv2AKw=;
        h=From:To:Cc:Subject:Date:From;
        b=n1Id8AFrABttPC/gUWeIkTiuYLaH+CYJUZk8CJlItC4/gwXsScVmpcQkV26pT/6FO
         qZnFJsS2fPIvBwjWgpvtK5QMenQ/cIYOK1wtPOC+F80x4PN1oC5Ld5mOg4MBSNHwvL
         phFKXtYD2fRe432XD6z8E8zr748d9xEsmrcm+7xWijemJ7wkq1a6PCptuBL6xbZOHY
         mMr8LDGnXT+cmwEGDI6SbEf9y5hk0N42bveJh3ZKYvecuNjAZz/023CizQQVwn29XH
         BD5ZhP/fMjyCOi4qhXqM/P7uwH8gO/K9D18E/LOEgMG/z1KRa646FCd2hJXBNf9K0A
         fA4UQwlTcrLIQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v2 0/2] lighten uapi/bpf.h rebuilds
Date:   Wed, 29 Dec 2021 17:27:40 -0800
Message-Id: <20211230012742.770642-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Last change in the bpf headers - disentangling BPF uapi from
netdevice.h. Both linux/bpf.h and uapi/bpf.h changes should
now rebuild ~1k objects down from the original ~18k. There's
probably more that can be done but it's diminishing returns.

Split into two patches for ease of review.

Jakub Kicinski (2):
  net: add includes masked by netdevice.h including uapi/bpf.h
  bpf: invert the dependency between bpf-netns.h and netns/bpf.h

 drivers/net/ethernet/amazon/ena/ena_netdev.h       | 1 +
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c | 1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       | 1 +
 drivers/net/ethernet/ti/cpsw_priv.h                | 2 ++
 include/linux/bpf-netns.h                          | 8 +-------
 include/net/ip6_fib.h                              | 1 +
 include/net/netns/bpf.h                            | 9 ++++++++-
 kernel/bpf/net_namespace.c                         | 1 +
 9 files changed, 18 insertions(+), 8 deletions(-)

-- 
2.31.1

