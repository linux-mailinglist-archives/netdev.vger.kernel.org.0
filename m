Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E7C481747
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 23:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhL2Wbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 17:31:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35512 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhL2Wbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 17:31:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78C116159B;
        Wed, 29 Dec 2021 22:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C4DC36AEA;
        Wed, 29 Dec 2021 22:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640817106;
        bh=iPPEkXlSFfMYy3TNXqtjwk25DMq9c03VHds0cN61iPw=;
        h=From:To:Cc:Subject:Date:From;
        b=Rr5KfiWVV3Ubc/Yg9LexXUv9LSrJsDPA6E4xv7/RiJ62O7h58dlqcGoqyqmLUNdTu
         S5N+s79yk/Yix2mz9ceIBYM0wuvfW6aqNZB7xilxdPrKba4xECK91Co5mp0FyfAzhX
         ic1bCxlZxf/PcCpmgrbsUco4qLajcDlidzF4+EFD86UNW7S7N2BwkYqgBH2fIeSbqE
         PfA6t24LTRVdWsxRaJ/MNpXISBrucXc96G/mpObICdYrCUTw4QRrNrf7MDtTqjCPnd
         ozEYo55Qq3KRF3kEfXdZFXPVfD+6BKv4/R6eQGLWy/nHx6CJ1kIozdN+FhPL+fHLyV
         +PYocWrtq/rLw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next 0/2] lighten uapi/bpf.h rebuilds
Date:   Wed, 29 Dec 2021 14:31:37 -0800
Message-Id: <20211229223139.708975-1-kuba@kernel.org>
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
 include/net/netns/bpf.h                            | 9 ++++++++-
 kernel/bpf/net_namespace.c                         | 1 +
 8 files changed, 17 insertions(+), 8 deletions(-)

-- 
2.31.1

