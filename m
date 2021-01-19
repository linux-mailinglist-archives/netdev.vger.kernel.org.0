Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3C22FC0F9
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403772AbhASU1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:27:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:56976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391742AbhASU0E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:26:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFBD623104;
        Tue, 19 Jan 2021 20:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611087924;
        bh=3od1SG0keRDEN3B3uDQZf6DuluTr0a4nFgA+n69wSZw=;
        h=From:To:Cc:Subject:Date:From;
        b=nJF42B+72vSHTDlyijpxW81atC4tAtbAhDgwjaJ5f9z8LuXLMWiNUNZ9U9oC1k0YQ
         QU8AW/V+aC8brBx/hvYwZic9Ksbo9f5Q/ubKNAZQS24chPrMdIScb6VI2uB0c0giCK
         tTVimu6HERetIj08r1ZKakR1sIrbyRiLPwY3S/M6MyjXNiWdsFReJCwERwtSWiaD4v
         rcTq9kx5H3rssaYlEZfxoD0AcnNPcnCiVsPUBAg6slQXRYzVQ53i0bHIkM4aMzwt2y
         SsuEgjv8E31bfQKk7Eis9+bUyBKiPpx1ADc1Vo3X+Su8oK2z17ATi7pA4XqwJ10lGm
         jjpi8egVeJqcQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/4] net: inline rollback_registered() functions
Date:   Tue, 19 Jan 2021 12:25:17 -0800
Message-Id: <20210119202521.3108236-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After recent changes to the error path of register_netdevice()
we no longer need a version of unregister_netdevice_many() which
does not set net_todo. We can inline the rollback_registered()
functions into respective unregister_netdevice() calls.

v2: - add missing list_del() in the last patch

Jakub Kicinski (4):
  net: move net_set_todo inside rollback_registered()
  net: inline rollback_registered()
  net: move rollback_registered_many()
  net: inline rollback_registered_many()

 net/core/dev.c | 210 +++++++++++++++++++++++--------------------------
 1 file changed, 98 insertions(+), 112 deletions(-)

-- 
2.26.2

