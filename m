Return-Path: <netdev+bounces-8931-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0845D726569
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:05:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EBB01C20E47
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1EE3370F8;
	Wed,  7 Jun 2023 16:05:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2293370EE
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:05:10 +0000 (UTC)
X-Greylist: delayed 585 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Jun 2023 09:05:09 PDT
Received: from mail.simonwunderlich.de (mail.simonwunderlich.de [IPv6:2a01:4f8:c17:e8c0::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290E619B6
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:05:08 -0700 (PDT)
Received: from kero.packetmixer.de (p200300C5970e9fD858c5a4eeF27C1696.dip0.t-ipconnect.de [IPv6:2003:c5:970e:9fd8:58c5:a4ee:f27c:1696])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.simonwunderlich.de (Postfix) with ESMTPSA id 9D6A6FA14B;
	Wed,  7 Jun 2023 17:55:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=simonwunderlich.de;
	s=09092022; t=1686153320; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=3bhEhu0OiNNDzF9hlUr2mVxR3tx7ZYsrXal5Roza8mg=;
	b=vYL141pjQ56Ybg/Hl8o3UsFCPAUZlQKv+5S+oXk5CYfgCpjfFeOFituGUh7F2xdCvNKWUL
	RlHg8uhZqUDPt74eI8TqB3sMRBECe4l7HhVdV07Rr6jDxHYdC6SMLrWTGz1/uWv47VkQk3
	yrPGZtjq8u82SU77pHEk+IpcnhxIrIyEl4rhWaehlxYnMngTfMtdjKj01LW+Sehd57cZfM
	PcODbTeJ9xJbumwxfulPUYbKtcO0mzMehucBEwLk8DEyYC55ieqeksEtN3iMHEcumJK5uB
	Dqyujb4vPqMtPN/REKdGTLWZEK++X8Q+s6URCWX8phQ7UgsS7i9jU0VBgY1Grg==
From: Simon Wunderlich <sw@simonwunderlich.de>
To: davem@davemloft.net,
	kuba@kernel.org
Cc: netdev@vger.kernel.org,
	b.a.t.m.a.n@lists.open-mesh.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/1] pull request for net: batman-adv 2023-06-07
Date: Wed,  7 Jun 2023 17:55:14 +0200
Message-Id: <20230607155515.548120-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=simonwunderlich.de; s=09092022; t=1686153320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=3bhEhu0OiNNDzF9hlUr2mVxR3tx7ZYsrXal5Roza8mg=;
	b=Ofhec/EtB3wobPBexMwcU+5vUwzFzTSttQDzNsE+uRZnrYtbZsBgf3/8sWFAKkmbPz3BPE
	kx3aQ6ShwmaDy9NPbYhCJtrKH5oj6TOEPbKp0YqQst7oHFc5ZGtMOF/MbWI8vjCvyYqKS0
	eIySPpDCnxUsgf+ciMZ5WE65NYRtOQ240RTpseoV2Y8gzZNibOZmwNFyaqoKq22RyX5xF5
	fawgTuzMjNjOYnY6jFgoljdIBNhf1g+p6a71QD3ddJMq7uAViuVJg3qOLoWLVUYcBkMFov
	ybPaOkf9NTTmhMzlJtcHJift3KvhjWwQ9jDtG1wMCIRFo8qagC07d95vwqpINg==
ARC-Seal: i=1; s=09092022; d=simonwunderlich.de; t=1686153320; a=rsa-sha256;
	cv=none;
	b=JvoZYcMWVjHQ+HuZg/hlPQqP/G8Edh2VzqJNUq2e+mbj+bdZ1rz6SM/h027wGo3zPMoS6m+tkvXTiy5ZHcWseoPgFiMszRgXSXpmdpX7VpXq2WawKTrskwIoK5AIqr6lSDCskUs01eILGDh6gu0wWA7NZW1e7/EP4uPJ331kTobNipfrd5WZK5DdNpxmW/Lx6F6++uTkYF7aA/Npoet/7rKjaVr5vwFVAMZOEbErHBTFGRM1hHrxaIwQa7L4C1xPpPpeL7E49dd65GWsi3Xl3ftRR+vhKI8ZFTKKnpQrjsRwisQgm8pAIpyuvrBCUNkTtpEFQ29xu2fIIRCqBr73JQ==
ARC-Authentication-Results: i=1;
	mail.simonwunderlich.de;
	auth=pass smtp.auth=sw@simonwunderlich.de smtp.mailfrom=sw@simonwunderlich.de
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi David, hi Jakub,

here is a bugfix for batman-adv which we would like to have integrated into net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 44c026a73be8038f03dbdeef028b642880cf1511:

  Linux 6.4-rc3 (2023-05-21 14:05:48 -0700)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-pullrequest-20230607

for you to fetch changes up to abac3ac97fe8734b620e7322a116450d7f90aa43:

  batman-adv: Broken sync while rescheduling delayed work (2023-05-26 23:14:49 +0200)

----------------------------------------------------------------
Here is a batman-adv bugfix:

 - fix a broken sync while rescheduling delayed work, by
   Vladislav Efanov

----------------------------------------------------------------
Vladislav Efanov (1):
      batman-adv: Broken sync while rescheduling delayed work

 net/batman-adv/distributed-arp-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

