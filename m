Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A25C29A75E
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 10:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895389AbgJ0JJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 05:09:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51199 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2509681AbgJ0JJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 05:09:47 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kXKz9-0007nL-13; Tue, 27 Oct 2020 09:09:43 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] vsock: fix the error return when an invalid ioctl command is used
Date:   Tue, 27 Oct 2020 09:09:42 +0000
Message-Id: <20201027090942.14916-3-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201027090942.14916-1-colin.king@canonical.com>
References: <20201027090942.14916-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently when an invalid ioctl command is used the error return
is -EINVAL.  Fix this by returning the correct error -ENOIOCTLCMD.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 865331b809e4..597c86413089 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2072,7 +2072,7 @@ static long vsock_dev_do_ioctl(struct file *filp,
 		break;
 
 	default:
-		retval = -EINVAL;
+		retval = -ENOIOCTLCMD;
 	}
 
 	return retval;
-- 
2.27.0

