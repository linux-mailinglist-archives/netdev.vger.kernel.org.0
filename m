Return-Path: <netdev+bounces-9741-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B33A872A59C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:53:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B8F41C209F7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A5C23C8E;
	Fri,  9 Jun 2023 21:53:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4771E1C760
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:53:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66896C433EF;
	Fri,  9 Jun 2023 21:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686347621;
	bh=jKTLZ8fJrKaLONzqPfVtbrFft5ryE0gFD5VTb1MKq5E=;
	h=From:To:Cc:Subject:Date:From;
	b=SMoRo2SgmQrsi+YYXAufoFfHOPJ6mmBVNr+2jP2/wavGZLo35nqzVRzdPiNBb4QXF
	 aJE4WQqj2JOQclS/e7Sfaaf2fj3fE9aMwEvjSu6be0IkOUEws98uy0Zxcg589MMg5F
	 Vvb4UQDVBoAE9qkZUzWkLTSTZZEvHwoa/pnUZnfCEG6EjzGN5JCFbz/hFZDNipK0V5
	 3z2nIdzYeW3IvlpfkUdRPcnDmorWPSiEwnjmp+nb8hxsVk5U7wQJ8FCoWuKTKI6cee
	 UbX29rOx70pLl2rY+K35zHKlEq6xt/0EFfU1gWr6ddu3cLw1Bgxm2vm3O1dTVqQp93
	 ggVxjY43PCW9w==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	dsahern@gmail.com,
	mkubecek@suse.cz,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/2] net: support extack in dump and simplify ethtool uAPI
Date: Fri,  9 Jun 2023 14:53:29 -0700
Message-Id: <20230609215331.1606292-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ethtool currently requires header nest to be always present even if
it doesn't have to carry any attr for a given request. This inflicts
unnecessary pain on the users.

What makes it worse is that extack was not working in dump's ->start()
callback. Address both of those issues.

Jakub Kicinski (2):
  netlink: support extack in dump ->start()
  net: ethtool: don't require empty header nests

 include/linux/netlink.h  | 1 +
 net/ethtool/netlink.c    | 2 ++
 net/netlink/af_netlink.c | 2 ++
 net/netlink/genetlink.c  | 2 ++
 4 files changed, 7 insertions(+)

-- 
2.40.1


