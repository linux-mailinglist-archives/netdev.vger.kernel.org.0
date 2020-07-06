Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B65215630
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 13:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgGFLSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 07:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728683AbgGFLSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 07:18:09 -0400
X-Greylist: delayed 394 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Jul 2020 04:18:09 PDT
Received: from mail.disavowed.jp (mail.disavowed.jp [IPv6:2001:19f0:7001:a27:5400:ff:fe69:1687])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A62C061794
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 04:18:09 -0700 (PDT)
Received: from smtp.rezrov.net (o155203.dynamic.ppp.asahi-net.or.jp [202.208.155.203])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "smtp.rezrov.net", Issuer "Let's Encrypt Authority X3" (verified OK))
        by mail.disavowed.jp (Postfix) with ESMTPS id 1E7B4AC00C;
        Mon,  6 Jul 2020 20:11:30 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=disavowed.jp; s=mail;
        t=1594033890; bh=KZAMKG18n/taaGTBvNrmlJpI08jLKLByf2lsq4E2Og0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=oC1IA6XaaWGE89psbZNLJAkHj3CRq5oBXuIpKHDwLREccpxHgvQTAr60DdSCHJjuu
         DbnXLIeTiP7fIfKjY0xpwQU8jA7mjZKsVnlfzuUf8BIzV2Y3fZBHGQytCF+1fmwVDA
         l1SHYGj1MjVPEhf9EwQ+cJbqvU22pDal2NklGua0=
Received: from basementcat.rezrov.net (mikkabi.rezrov.net [192.168.1.35])
        by smtp.rezrov.net (Postfix) with ESMTPS id 292479076;
        Mon,  6 Jul 2020 20:11:30 +0900 (JST)
Date:   Mon, 6 Jul 2020 20:11:30 +0900
From:   Chris <chris@disavowed.jp>
To:     netdev@vger.kernel.org
Cc:     trivial@kernel.org
Subject: [PATCH v2] net/appletalk: restore success case for atalk_proc_init()
Message-ID: <20200706111130.GC153765@mikkabi>
References: <20191009012630.GA106292@basementcat>
 <20191008185741.10afd266@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191008185741.10afd266@cakuba.netronome.com>
User-Agent: =?utf-8?B?0JLQsNGBINGN0YLQviDQvdC1INC60LA=?=
 =?utf-8?B?0YHQsNC10YLRgdGP?= 
X-PGP-Key: https://www.disavowed.jp/keys/chris.disavowed.jp.asc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e2bcd8b0ce6ee3410665765db0d44dd8b7e3b348 to
net/appletalk/atalk_proc.c removed the success case, rendering
appletalk.ko inoperable.  This one-liner restores correct operation.

Fixes: e2bcd8b0ce6ee3410665765db0d44dd8b7e3b348 ("appletalk: use remove_proc_subtree to simplify procfs code")
Signed-off-by: Christopher KOBAYASHI <chris@disavowed.jp>
---

Apologies for the delay in revising this patch, life got a bit busy.

diff --git a/net/appletalk/atalk_proc.c b/net/appletalk/atalk_proc.c
index 550c6ca007cc..9c1241292d1d 100644
--- a/net/appletalk/atalk_proc.c
+++ b/net/appletalk/atalk_proc.c
@@ -229,6 +229,8 @@ int __init atalk_proc_init(void)
 				     sizeof(struct aarp_iter_state), NULL))
 		goto out;
 
+	return 0;
+
 out:
 	remove_proc_subtree("atalk", init_net.proc_net);
 	return -ENOMEM;

