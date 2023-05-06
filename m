Return-Path: <netdev+bounces-656-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F986F8D33
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF23C281135
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 00:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0D910E6;
	Sat,  6 May 2023 00:45:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AEA621;
	Sat,  6 May 2023 00:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240B4C433EF;
	Sat,  6 May 2023 00:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683333919;
	bh=JlPSvOTGN/lrTMu4sjUnp9Jq2iN+uO0djrh24cm2MaQ=;
	h=Subject:From:To:Cc:Date:From;
	b=j1K7pzefZbVY/LnOQVoTo9mB2JONPShLc8OfbZiGXjj877NwSG2UnHFsYZKS4k/WF
	 3k27tZkzcP/yjH+voSR3J7HLfwKkRLZpX8bGjPojNtWN5dlj5jUK9EGZrL9e+E2LiH
	 Aegb7LGx2Sm961sBH7EsRepWdZhJ0XkpanCCL/1VY0QCXhP/pN7wTYw2LRUFdRGYft
	 sxjPidG4AZ6NJPPnI1y8vFophElr3o7CMh1o6Xlw3jMoLYFarpij7kw/v4Hak9YMc6
	 M2e7J8nvbXPzrCQvaTq726291FSdJIPoiLaftUGdGXm2LSlr0FUeKqPTJ+GMJO3FyS
	 kMO8tEiYC//HQ==
Subject: [PATCH v2 0/6] Bug fixes for net/handshake
From: Chuck Lever <cel@kernel.org>
To: kernel-tls-handshake@lists.linux.dev
Cc: netdev@vger.kernel.org, dan.carpenter@linaro.org
Date: Fri, 05 May 2023 20:45:08 -0400
Message-ID: 
 <168333373851.7813.11884763481187785511.stgit@oracle-102.nfsv4bat.org>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Build tested only, but these should address Jakub's review comments.

Please consider these for merge via net-next.

Changes since v1:
- Rework "Fix handshake_dup() ref counting"
- Unpin sock->file when a handshake is cancelled

---

Chuck Lever (6):
      net/handshake: Remove unneeded check from handshake_dup()
      net/handshake: Fix handshake_dup() ref counting
      net/handshake: Fix uninitialized local variable
      net/handshake: handshake_genl_notify() shouldn't ignore @flags
      net/handshake: Unpin sock->file if a handshake is cancelled
      net/handshake: Enable the SNI extension to work properly


 Documentation/netlink/specs/handshake.yaml |  4 ++++
 Documentation/networking/tls-handshake.rst |  5 +++++
 include/net/handshake.h                    |  1 +
 include/uapi/linux/handshake.h             |  1 +
 net/handshake/handshake.h                  |  1 +
 net/handshake/netlink.c                    | 11 +++--------
 net/handshake/request.c                    |  4 ++++
 net/handshake/tlshd.c                      |  8 ++++++++
 8 files changed, 27 insertions(+), 8 deletions(-)

--
Chuck Lever


