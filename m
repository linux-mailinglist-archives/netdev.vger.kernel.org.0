Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5C03E9A70
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhHKVij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232156AbhHKVif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 17:38:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 428DC60F11;
        Wed, 11 Aug 2021 21:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628717890;
        bh=8TCZoA0RWguytepXsv6jjrJZ5XL9K0yD28JNI0V+wBk=;
        h=From:To:Cc:Subject:Date:From;
        b=H1AYA+mX4Z9SbM3norOivtBxGhUIlPoMQteD5UxXaQzswMXvyE9Wc/4iCfBLXQzXB
         xyuwcfPTlwwc0bVqXkETN0+TDxKIKxTiQLr6kJT5VSTTwEAo1asnQbZxZprKCwMRzT
         cW0ykcSwNvVWBSAr+LOyZ4/MikDv25VLiIGtC46FnGa9VslZMbNf1Fkuw50DjVG0rn
         AjrJrCEoClkEgU0uAORafnhLrccyNPZBB9pwS3vG2QYi4UZk5wUUgUohQi1X/kJXmk
         FOnOI5wGZPEYI4Pt61nSLQVS6Pg9NywjtFGdEAsN58XQ9iZYhvhX+QycUJXGLD/yxC
         cQnt6dml4BrwA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     michael.chan@broadcom.com, huangjw@broadcom.com,
        eddie.wai@broadcom.com, prashant@broadcom.com, gospo@broadcom.com,
        netdev@vger.kernel.org, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 0/4] bnxt: Tx NAPI disabling resiliency improvements
Date:   Wed, 11 Aug 2021 14:37:45 -0700
Message-Id: <20210811213749.3276687-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A lockdep warning was triggered by netpoll because napi poll
was taking the xmit lock. Fix that and a couple more issues
noticed while reading the code.

Jakub Kicinski (4):
  bnxt: don't lock the tx queue from napi poll
  bnxt: disable napi before canceling DIM
  bnxt: make sure xmit_more + errors does not miss doorbells
  bnxt: count Tx drops

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 60 ++++++++++++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 37 insertions(+), 24 deletions(-)

-- 
2.31.1

