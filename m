Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F851B95BC
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 06:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgD0EPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 00:15:20 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33853 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726357AbgD0EPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 00:15:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1D0F85C00DE;
        Mon, 27 Apr 2020 00:15:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 00:15:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rylan.coffee; h=
        date:from:to:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=b2k2hy0obFtFe40lOY3WleQMvx/
        DeMs6uYX07xiuYUM=; b=llX/86K09l8ElFJedOdbRBX28xXwWgVXDiSP1UmlzEc
        0syw5duUk8wRFEenqJyGIEzj3uejgA/RAO0ihDyctwuBRKt4En+wVRZLcxe4Bb9O
        eJeL8PqhhR2XcPF86CsVkKqVnTZ4FIT68rPZx14qmHE2wgJx8CDiUZzFuO5BieX0
        pNtoIz5K12kEQQ5yK0CdgtK65RPRZLToydcdVErJ25xkPJ3ZYsmqmaU7adsJp8Jc
        CBzvIGiyWfj2dDQJ7f5PvXY0opTznBPMrlRwul81cEqdtRvQUvGdJP7NVbzh2nEv
        HHXiGC7k4oHPNYZGfEhTLBi7utfgiAAol2Vkj4w2new==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=b2k2hy
        0obFtFe40lOY3WleQMvx/DeMs6uYX07xiuYUM=; b=AlKMLq1bLc892cBt1Q1KmH
        64s5VqdC0fR2BCskqdMmeTDsrFAJUvB19qD9+rdCGLIHrPTy+b2mqyieQPz3vl6Y
        QXMVd86z3xEPE21Vm3oX2GuGIYQPBbSGeu4GbfBLhGS5maEihFTX4UdNu7jpQI8w
        WSTlDD9g4gS306oNBHLDdytTNh5cqgKlWwsDR35pkpV5v0tW56qjDkWJiUiF8hnp
        YIBn1zxhySKqwJWQIiz5XctteeJO+/4HskGAHixqchPRIqbbvGNrUkCldujXUHR2
        qNmdfSSUGCbgI32etLuy8ZTrar6ewFShjd11rrTrtn9rBhqzZaoJAH0NzSFbx0rA
        ==
X-ME-Sender: <xms:VVymXh84y6tCANY9_Y_ncc6r5-QCGhwGOfqqJ9RNkpt9TLq4Qon5Lw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheekgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtjeenucfhrhhomheptfihlhgrnhcu
    ffhmvghllhhouceomhgrihhlsehrhihlrghnrdgtohhffhgvvgeqnecukfhppedutdekrd
    egledrudehkedrkeegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghi
    lhhfrhhomhepmhgrihhlsehrhihlrghnrdgtohhffhgvvg
X-ME-Proxy: <xmx:VVymXuod60fD-NHqfvXPabNrd-OqBDq8iulf3jv79mvzYPhlRNje-Q>
    <xmx:VVymXsVmbP3nIDuarlYiRlGuLe4QB4pgdeJx_Uf4Yrn2bSbVJM5vsg>
    <xmx:VVymXpJyts3RNPEbSi-swCQfx_v0abltrYHVqGZNlNXlU22Cdr8ZxQ>
    <xmx:VlymXr1ioOfPPgoUySYicbyyax3FGEoCfJSXL7qPQIu033VdiQ5uiA>
Received: from athena (pool-108-49-158-84.bstnma.fios.verizon.net [108.49.158.84])
        by mail.messagingengine.com (Postfix) with ESMTPA id A9D47328005D;
        Mon, 27 Apr 2020 00:15:17 -0400 (EDT)
Date:   Mon, 27 Apr 2020 00:15:18 -0400
From:   Rylan Dmello <mail@rylan.coffee>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Benjamin Poirier <bpoirier@suse.com>,
        Jiri Pirko <jpirko@redhat.com>
Subject: [PATCH 3/3] staging: qlge: Remove print statements for lbq_clean_idx
 and lbq_free_cnt
Message-ID: <aa7e0197f4e34cec0855124e45696e33dd9527e5.1587959245.git.mail@rylan.coffee>
References: <cover.1587959245.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1587959245.git.mail@rylan.coffee>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove debug print statements referring to non-existent fields
'lbq_clean_idx' and 'lbq_free_cnt' in the 'rx_ring' struct, which causes
a compilation failure when QL_DEV_DUMP is set.

These fields were initially removed as a part of commit aec626d2092f
("staging: qlge: Update buffer queue prod index despite oom") in 2019.

Their replacement fields ('next_to_use' and 'next_to_clean') are already
being printed, so this patch does not add new debug statements for them.

Signed-off-by: Rylan Dmello <mail@rylan.coffee>
---
 drivers/staging/qlge/qlge_dbg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index bf157baace54..058889687907 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1757,8 +1757,6 @@ void ql_dump_rx_ring(struct rx_ring *rx_ring)
 	       rx_ring->lbq.prod_idx_db_reg);
 	pr_err("rx_ring->lbq.next_to_use = %d\n", rx_ring->lbq.next_to_use);
 	pr_err("rx_ring->lbq.next_to_clean = %d\n", rx_ring->lbq.next_to_clean);
-	pr_err("rx_ring->lbq_clean_idx = %d\n", rx_ring->lbq_clean_idx);
-	pr_err("rx_ring->lbq_free_cnt = %d\n", rx_ring->lbq_free_cnt);
 
 	pr_err("rx_ring->sbq.base = %p\n", rx_ring->sbq.base);
 	pr_err("rx_ring->sbq.base_dma = %llx\n",
-- 
2.26.2

