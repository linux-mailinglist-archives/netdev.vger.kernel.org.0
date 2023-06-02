Return-Path: <netdev+bounces-7284-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E56DD71F876
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 04:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 750B01C210E4
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0684C15A3;
	Fri,  2 Jun 2023 02:35:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F733EA1
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 02:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C06C433EF;
	Fri,  2 Jun 2023 02:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685673353;
	bh=stlYsFT2H5UEQElNhNlMXTi0MkQvCvBOP+I3z7z7kZU=;
	h=From:To:Cc:Subject:Date:From;
	b=lspE0cUQ0SQTnTY6GdYZPjmtUmdZ3+pqM2wq6Y1kJcMpwxWdu/iRKe9RLfDZBwvgF
	 Xtf05IkkFazIAapWUK0FiruXIJnZFlP8wGdIXcsGb5RwLsoKZ1C5ROP+6d3sbcUYOi
	 LaXipiI5O2vJ8YEqnHH+PvMoUEj99JXCQoEXeyDnazf3i8qLjmAUFErjdqSsor6ny6
	 1Z6VeVeRjiOGsW3xAhzaxk3FLrgyszz9x7iCZuFmEo7+z/eKF5HQg+Py4RbI1pJN2k
	 539g8Cn6ULR/nzHtv1CtelunNduje9Epfj07RQXfoO89bu0WNn4LPsHVaVMKTXK/qc
	 bUIRcveut1dKQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/10] tools: ynl-gen: dust off the user space code
Date: Thu,  1 Jun 2023 19:35:38 -0700
Message-Id: <20230602023548.463441-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Every now and then I wish I finished the user space part of
the netlink specs, Python scripts kind of stole the show but
C is useful for selftests and stuff which needs to be fast.
Recently someone asked me how to access devlink and ethtool
from C++ which pushed me over the edge.

Fix things which bit rotted and finish notification handling.
This series contains code gen changes only. I'll follow up
with the fixed component, samples and docs as soon as it's
merged.

Jakub Kicinski (10):
  tools: ynl-gen: add extra headers for user space
  tools: ynl-gen: fix unused / pad attribute handling
  tools: ynl-gen: don't override pure nested struct
  tools: ynl-gen: loosen type consistency check for events
  tools: ynl-gen: add error checking for nested structs
  tools: ynl-gen: generate enum-to-string helpers
  tools: ynl-gen: move the response reading logic into YNL
  tools: ynl-gen: generate alloc and free helpers for req
  tools: ynl-gen: switch to family struct
  tools: ynl-gen: generate static descriptions of notifications

 tools/net/ynl/ynl-gen-c.py | 253 +++++++++++++++++++++++++++++--------
 1 file changed, 199 insertions(+), 54 deletions(-)

-- 
2.40.1


