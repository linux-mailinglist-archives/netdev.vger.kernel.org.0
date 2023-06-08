Return-Path: <netdev+bounces-9367-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 121667289FD
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:12:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C140C281762
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3173834CC4;
	Thu,  8 Jun 2023 21:12:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF74419936
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25931C433EF;
	Thu,  8 Jun 2023 21:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258727;
	bh=F18iNwpXuFqOZuELxRyuhgxtaPsFHjFfeALlxIEcA64=;
	h=From:To:Cc:Subject:Date:From;
	b=HtbrYD+dsSpX6cSYZcUFbBTuRcGQb+BzmbPCh7+pkvEiWNzXJGf8xnjvvC/ueuQZt
	 LX2jRB7BIopirGEkwZjZ0TCTv4oQ4/MTD8Hqa9IPb7hj4RYonxmsfsGNdOJA42AvDa
	 yhxDwozXu5OjQBeucZyzsapw8G5LxGvfu8QScLS1uthXjj8Pgrk4pljlHlCBdaiGT2
	 xqda4BaR1vO4emca7g7mobqrwXWnlGPvutsJC6ec3/I7LpPJyiIffbUiWGg+8V2Ex1
	 F/FZVG92J8Y2UQg8gZqKO7ZvDLCz+FgZs/FbVIrLaSR4UXIPcLIJ5X8HczQqBara4v
	 vGfyMSA9heX7A==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/12] tools: ynl-gen: code gen improvements before ethtool
Date: Thu,  8 Jun 2023 14:11:48 -0700
Message-Id: <20230608211200.1247213-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I was going to post ethtool but I couldn't stand the ugliness
of the if conditions which were previously generated.
So I cleaned that up and improved a number of other things
ethtool will benefit from.

Jakub Kicinski (12):
  tools: ynl-gen: cleanup user space header includes
  tools: ynl: regen: cleanup user space header includes
  tools: ynl-gen: complete the C keyword list
  tools: ynl-gen: combine else with closing bracket
  tools: ynl-gen: get attr type outside of if()
  tools: ynl: regen: regenerate the if ladders
  tools: ynl-gen: stop generating common notification handlers
  tools: ynl: regen: stop generating common notification handlers
  tools: ynl-gen: sanitize notification tracking
  tools: ynl-gen: support code gen for events
  tools: ynl-gen: don't pass op_name to RenderInfo
  tools: ynl-gen: support / skip pads on the way to kernel

 tools/net/ynl/generated/devlink-user.c   |  78 +++----
 tools/net/ynl/generated/fou-user.c       |  35 ++--
 tools/net/ynl/generated/handshake-user.c |  78 ++-----
 tools/net/ynl/generated/handshake-user.h |   3 -
 tools/net/ynl/generated/netdev-user.c    |  58 +-----
 tools/net/ynl/generated/netdev-user.h    |   3 -
 tools/net/ynl/lib/nlspec.py              |   7 +-
 tools/net/ynl/ynl-gen-c.py               | 253 ++++++++++-------------
 8 files changed, 186 insertions(+), 329 deletions(-)

-- 
2.40.1


