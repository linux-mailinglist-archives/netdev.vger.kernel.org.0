Return-Path: <netdev+bounces-7802-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 041197218F6
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 19:58:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3136281147
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 17:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11823107B4;
	Sun,  4 Jun 2023 17:58:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A522728EC
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 17:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6E6C433D2;
	Sun,  4 Jun 2023 17:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685901526;
	bh=Gq8dUbD4ESE8sI+gl4Qz6MMGeuNgt/GubSoBWkViTkY=;
	h=From:To:Cc:Subject:Date:From;
	b=OcX2DN80Sj48ug1/uY18JPgARBxJgtA2YUMEfjrCsVs85rFy/oAzBQMu/Ab0veun3
	 SJoZ0CWuEb6uXryPBcbRTj5yrrIJ9ZtNG5fHARCI2F4cEvdQqkAzx4XBnepZnZ3H/r
	 b2N7D5Vjvm8ZgU8IPcHLd0hUqOGcZ/YVXY5sE5f1g8eUfyx/ZewKgeo3lu8jPW/0h6
	 TGVKJbe1rNLpt6bHxRWIM+5ctnvGMAY5myxXegmGFzYRM1icKric/G/YUzzGrpBzvX
	 hy7CGsKGAeYW1x/gyYCH0PvTj6cVVe+iSlzHA5GN9sq+L74dctnnMDQ+nPqr2zaau2
	 pF4ncLeK5tumQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	simon.horman@corigine.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/4] tools: ynl: user space C
Date: Sun,  4 Jun 2023 10:58:39 -0700
Message-Id: <20230604175843.662084-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the code gen which is already in tree to generate a user space
library for a handful of simple families. I find YNL C quite useful
in some WIP projects, and I think others may find it useful, too.
I was hoping someone will pick this work up and finish it...
but it seems that Python YNL has largely stolen the thunder.
Python may not be great for selftest, tho, and actually this lib
is more fully-featured. The Python script was meant as a quick demo,
funny how those things go.

v2:
 - fix kdoc on patch 2
v1: https://lore.kernel.org/all/20230603052547.631384-1-kuba@kernel.org/

Jakub Kicinski (4):
  tools: ynl-gen: clean up stray new lines at the end of reply-less
    requests
  tools: ynl: user space helpers
  tools: ynl: support fou and netdev in C
  tools: ynl: add sample for netdev

 .../userspace-api/netlink/intro-specs.rst     |  79 ++
 tools/net/ynl/Makefile                        |  19 +
 tools/net/ynl/generated/Makefile              |  45 +
 tools/net/ynl/generated/fou-user.c            | 340 +++++++
 tools/net/ynl/generated/fou-user.h            | 337 +++++++
 tools/net/ynl/generated/netdev-user.c         | 250 +++++
 tools/net/ynl/generated/netdev-user.h         |  88 ++
 tools/net/ynl/lib/Makefile                    |  28 +
 tools/net/ynl/lib/ynl.c                       | 901 ++++++++++++++++++
 tools/net/ynl/lib/ynl.h                       | 237 +++++
 tools/net/ynl/samples/.gitignore              |   1 +
 tools/net/ynl/samples/Makefile                |  28 +
 tools/net/ynl/samples/netdev.c                | 108 +++
 tools/net/ynl/ynl-gen-c.py                    |   7 +-
 tools/net/ynl/ynl-regen.sh                    |   2 +-
 15 files changed, 2466 insertions(+), 4 deletions(-)
 create mode 100644 tools/net/ynl/Makefile
 create mode 100644 tools/net/ynl/generated/Makefile
 create mode 100644 tools/net/ynl/generated/fou-user.c
 create mode 100644 tools/net/ynl/generated/fou-user.h
 create mode 100644 tools/net/ynl/generated/netdev-user.c
 create mode 100644 tools/net/ynl/generated/netdev-user.h
 create mode 100644 tools/net/ynl/lib/Makefile
 create mode 100644 tools/net/ynl/lib/ynl.c
 create mode 100644 tools/net/ynl/lib/ynl.h
 create mode 100644 tools/net/ynl/samples/.gitignore
 create mode 100644 tools/net/ynl/samples/Makefile
 create mode 100644 tools/net/ynl/samples/netdev.c

-- 
2.40.1


