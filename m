Return-Path: <netdev+bounces-7613-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F18720DEB
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 07:25:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7156A281AD3
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 05:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F5AB23CB;
	Sat,  3 Jun 2023 05:25:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2BB10F2
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 05:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855CDC433D2;
	Sat,  3 Jun 2023 05:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685769950;
	bh=ANxeT6brPF0FHRNhyL5gJBCMcSGqtgQPeUyAJUvKk7A=;
	h=From:To:Cc:Subject:Date:From;
	b=iv4SoxRrsZ5rjrGG+JSDA7Pm+hyZXE+PJXHmvF1t5hr+KioEOPgPUk0LoUNbYgxCp
	 RibsHyZkY0VLaEGrsbPTQtkrLaQqNQxADvI6GedS/a/K/6gtjg5Gx2kSF3xcO0RfcY
	 jVrcPIzhfHf2/v0J1bDm32lqBbuOexngndI1oLJHNGqAQ29CXZ1U0EbK478yDhVSOs
	 JP0a9dEi6ZSgZtFSxhrfSLVh4geP9ZRlXOH7kibzAQ8ZysOIOFXR+pruMkweyYJvy8
	 Q/3pyXf0QI9OgLaivWUxe93RMRER9fy5cxPWyxwQ/ge9wb6VWyhDXTUIWd4lnql7jy
	 qb6Ccy3s8NRLg==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/4] tools: ynl: user space C
Date: Fri,  2 Jun 2023 22:25:43 -0700
Message-Id: <20230603052547.631384-1-kuba@kernel.org>
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
 tools/net/ynl/lib/ynl.h                       | 229 +++++
 tools/net/ynl/samples/.gitignore              |   1 +
 tools/net/ynl/samples/Makefile                |  28 +
 tools/net/ynl/samples/netdev.c                | 108 +++
 tools/net/ynl/ynl-gen-c.py                    |   7 +-
 tools/net/ynl/ynl-regen.sh                    |   2 +-
 15 files changed, 2458 insertions(+), 4 deletions(-)
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


