Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625A92BB40D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731504AbgKTSjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:39:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731210AbgKTSjq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:39:46 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CE252242B;
        Fri, 20 Nov 2020 18:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897586;
        bh=v1Gn6x73baTEirIVYn+YPO3Vj9enivyASeGZ6ba81Js=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bb2W0ZyHzyTQexuiKzZ1tsGPtRvsy3FK+uh5TuQpq4qnVK1ygVyd5HN4/MIGNxXak
         vgk/fAFRIaKqD+Ysqnqo2YfhvSHdUgV5lRaGY230J+Z83Rl8W2XR6QV8H1PtkVQIdG
         6u0AdCaz7P1JBvq/gFfR97pSh247uZ1NnVMwnWA4=
Date:   Fri, 20 Nov 2020 12:39:51 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Manish Chopra <manishc@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 127/141] staging: qlge: Fix fall-through warnings for Clang
Message-ID: <673bd9f27bcc2df8c9d12be94f54001d8066d4ab.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/staging/qlge/qlge_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 27da386f9d87..c41b1373dcf8 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -1385,6 +1385,7 @@ static void ql_categorize_rx_err(struct ql_adapter *qdev, u8 rx_err,
 		break;
 	case IB_MAC_IOCB_RSP_ERR_CRC:
 		stats->rx_crc_err++;
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

