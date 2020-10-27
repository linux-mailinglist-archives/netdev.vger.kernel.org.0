Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FC829A75C
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 10:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509696AbgJ0JJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 05:09:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51197 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2509680AbgJ0JJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 05:09:47 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kXKz8-0007nI-La; Tue, 27 Oct 2020 09:09:42 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2][V2] vsock: remove ratelimit unknown ioctl message
Date:   Tue, 27 Oct 2020 09:09:41 +0000
Message-Id: <20201027090942.14916-2-colin.king@canonical.com>
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

When exercising the kernel with stress-ng with some ioctl tests the
"Unknown ioctl" error message is spamming the kernel log at a high
rate. Remove this message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/vmw_vsock/af_vsock.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 9e93bc201cc0..865331b809e4 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2072,7 +2072,6 @@ static long vsock_dev_do_ioctl(struct file *filp,
 		break;
 
 	default:
-		pr_err("Unknown ioctl %d\n", cmd);
 		retval = -EINVAL;
 	}
 
-- 
2.27.0

