Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFD02FC002
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 20:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbhASTaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 14:30:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:40774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729583AbhASTMx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 14:12:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 758B520706;
        Tue, 19 Jan 2021 19:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611083532;
        bh=K0aFrjI6pPEcAH2/JsvicQJsAuJ357Xpe3SXzoH+kQs=;
        h=From:To:Cc:Subject:Date:From;
        b=Skv5R4EiGyE//mv5sFEkQw64tGCm+CwTSDwwLkC9qwXppajDH/UQ3alDMWg947l5Z
         ZOK8Ha5gf0MsdAskeSK9sP9wc1BMJnjqaS2ZdAS4EpJVto4venBcON08VBsvafYqUv
         r/GeWsEJaORhP3F1CRrNP/8Aml5u5U8XbcCpIdra/FbLK0yGn+UDaWaImpCwZY6S9T
         KjhqqHyZwtyItrCwoqGhX2gjPs7qpceApvWls/xHmeZLBGVP7nI6C2JR8RsKtXYC4U
         mAt67vxVygQXMLbG8Ars6n1qZeERV52bT1GM5sSaX6pUiD4wXZeDvo+gcPjeL4Fpq8
         CGT51zhTkTmmg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/4] net: inline rollback_registered() functions
Date:   Tue, 19 Jan 2021 11:11:54 -0800
Message-Id: <20210119191158.3093099-1-kuba@kernel.org>
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

Jakub Kicinski (4):
  net: move net_set_todo inside rollback_registered()
  net: inline rollback_registered()
  net: move rollback_registered_many()
  net: inline rollback_registered_many()

 net/core/dev.c | 209 +++++++++++++++++++++++--------------------------
 1 file changed, 97 insertions(+), 112 deletions(-)

-- 
2.26.2

