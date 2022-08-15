Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64426594C90
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 03:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241609AbiHPBaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 21:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiHPBaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 21:30:04 -0400
X-Greylist: delayed 366 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 15 Aug 2022 14:21:36 PDT
Received: from forward501o.mail.yandex.net (forward501o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::611])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E58F2410
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:21:36 -0700 (PDT)
Received: from myt6-016ca1315a73.qloud-c.yandex.net (myt6-016ca1315a73.qloud-c.yandex.net [IPv6:2a02:6b8:c12:4e0e:0:640:16c:a131])
        by forward501o.mail.yandex.net (Yandex) with ESMTP id 282DB45C4203;
        Tue, 16 Aug 2022 00:15:26 +0300 (MSK)
Received: by myt6-016ca1315a73.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id DjV4VOrujZ-FPi4hwF6;
        Tue, 16 Aug 2022 00:15:25 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1660598125;
        bh=8ZyaZTApZziGajGGmRuw5J6mSJr7frwBf4z/whD9IcA=;
        h=Cc:References:Date:Message-ID:In-Reply-To:From:To:Subject;
        b=apPWwbjwXWjUqXDmbBeJQbPCyMHgPr4O7y2DnSeAgLsYSci8Sr/APe1YPMWwBFRJ1
         3gmwLpE80D9n8uZhk3b/ZD5J5F13C5lIesfSZ2YSB3InYJLwehnD98R4cp+Yqas8Bn
         WE87avoi2htPrG7BH2XDi1uExKF9c1vhzSbgZ1sU=
Authentication-Results: myt6-016ca1315a73.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Subject: [PATCH v2 1/2] fs: Export __receive_fd()
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, viro@zeniv.linux.org.uk
References: <0b07a55f-0713-7ba4-9b6b-88bc8cc6f1f5@ya.ru>
From:   Kirill Tkhai <tkhai@ya.ru>
Message-ID: <3a8da760-d58b-04fe-e251-e0d143493df1@ya.ru>
Date:   Tue, 16 Aug 2022 00:15:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0b07a55f-0713-7ba4-9b6b-88bc8cc6f1f5@ya.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is needed to make receive_fd_user() available in modules, and it will be used in next patch.

Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
---
v2: New
 fs/file.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/file.c b/fs/file.c
index 3bcc1ecc314a..e45d45f1dd45 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1181,6 +1181,7 @@ int __receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
 	__receive_sock(file);
 	return new_fd;
 }
+EXPORT_SYMBOL_GPL(__receive_fd);
 
 int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags)
 {


