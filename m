Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A196313FE67
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 00:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391673AbgAPXfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 18:35:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404089AbgAPXci (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 18:32:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCA5F206D9;
        Thu, 16 Jan 2020 23:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217558;
        bh=+Bey1xABKC1HL/CAqE3249BlH7P2i2zLFnUs7uty0ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoNIjrWaor9TuHMgxnH7/BUMEiuFLcWMQ0NmPcnVGmJHq0tS65a/yuuoZolKBfOfQ
         r+HWgXOruzDR4Xn9d8n+tIGT8uPr1POpolwefSpiN6OGxU2aZD0wwfn7Bs8PJ6TVp1
         SLqyS5gU7nv1vUPSr0b1ulI0/gWDgpYWAb1hrIgo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.14 47/71] compat_ioctl: handle SIOCOUTQNSD
Date:   Fri, 17 Jan 2020 00:18:45 +0100
Message-Id: <20200116231716.236179399@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 9d7bf41fafa5b5ddd4c13eb39446b0045f0a8167 upstream.

Unlike the normal SIOCOUTQ, SIOCOUTQNSD was never handled in compat
mode. Add it to the common socket compat handler along with similar
ones.

Fixes: 2f4e1b397097 ("tcp: ioctl type SIOCOUTQNSD returns amount of data not sent")
Cc: Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/socket.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/socket.c
+++ b/net/socket.c
@@ -3267,6 +3267,7 @@ static int compat_sock_ioctl_trans(struc
 	case SIOCSARP:
 	case SIOCGARP:
 	case SIOCDARP:
+	case SIOCOUTQNSD:
 	case SIOCATMARK:
 		return sock_do_ioctl(net, sock, cmd, arg);
 	}


