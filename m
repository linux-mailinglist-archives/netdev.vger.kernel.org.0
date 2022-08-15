Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBE7594E29
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 03:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiHPBuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 21:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbiHPBtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 21:49:33 -0400
Received: from forward500p.mail.yandex.net (forward500p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B873DC480B
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:43:21 -0700 (PDT)
Received: from sas8-b59f42c5f2d6.qloud-c.yandex.net (sas8-b59f42c5f2d6.qloud-c.yandex.net [IPv6:2a02:6b8:c1b:2912:0:640:b59f:42c5])
        by forward500p.mail.yandex.net (Yandex) with ESMTP id A11FAF01681;
        Tue, 16 Aug 2022 00:43:15 +0300 (MSK)
Received: by sas8-b59f42c5f2d6.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id UiEkEyuDID-hEiKVJQt;
        Tue, 16 Aug 2022 00:43:15 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ya.ru; s=mail; t=1660599795;
        bh=8ZyaZTApZziGajGGmRuw5J6mSJr7frwBf4z/whD9IcA=;
        h=Cc:References:Date:Message-ID:In-Reply-To:From:To:Subject;
        b=P00mJFlymWHF7qdAH99DhIXUq4+iEtzm4ZLKfvGY36mOGBz6LiB+w8rZK0pOJbU3+
         ZbxJ4K3yboX6GuinyFzSrYpoLb7zhE2n/DF/rNdIPRLzAycV4nY6nZFNDBTB63GXXJ
         PSmIDCM5dwFk0DOuJe4RcKHY6oQow6RADJ/HLr00=
Authentication-Results: sas8-b59f42c5f2d6.qloud-c.yandex.net; dkim=pass header.i=@ya.ru
Subject: [PATCH v2 1/2] fs: Export __receive_fd()
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, viro@zeniv.linux.org.uk
References: <0b07a55f-0713-7ba4-9b6b-88bc8cc6f1f5@ya.ru>
From:   Kirill Tkhai <tkhai@ya.ru>
Message-ID: <efcefa79-bd30-d65e-8233-f134e7a9623b@ya.ru>
Date:   Tue, 16 Aug 2022 00:42:45 +0300
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



