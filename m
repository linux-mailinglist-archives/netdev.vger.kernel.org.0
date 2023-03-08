Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F351A6AFDC8
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 05:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjCHESZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 23:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCHESY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 23:18:24 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582F57F03D
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 20:18:23 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so1084286pjh.0
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 20:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678249102;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQuVo2cMLbzqVVJUKjSu9YA4jNw9aOqhRN0Lhp4EL/Q=;
        b=RtzJOoxI98zAFwNJeMOnSBUuTFGwY7w1lbcOwpjYTmDzZETZVXCoBlS2oLR/7guOQW
         5ARF/HaAmXZHrDgPIGpX1IZOqp2Sy+aU+B97gPKJRWimfamkLhV82yAZ5qN9cKYe2kSm
         PHufDwd+XL0GRA/qj2YEpBIQCNhdCE1MqNvL37teFAbhlcVO2NWRYvglzJ+/tfT65vIC
         u1Pu7MFb4d4nxrmimxyubj3eCZ17MyjoAkUZxGbzHpFYmneS3vHHZ6xNyBOQ1t0wYCgc
         +N7yJLHVe8NPsOvJTRmeMfMPJM8hb8e2mD0IZ8Zmaxd7Sogz0j+PrebxWh7r7Zt/Mui9
         FdZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678249102;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fQuVo2cMLbzqVVJUKjSu9YA4jNw9aOqhRN0Lhp4EL/Q=;
        b=OLnZfmaM4TrKBiU3IgW2tWaWq9Hso3iT6lhSCmMEe13134KdwsoSBU/xSVK8k5iSvo
         HX+uGqKaDFqmYf3sTEdW4ixJXH3Dobsrq5gppT7Bd2p593IX1CFhvz/kfALViKYCp0qa
         oyTa4jYT3mHsLGFYTTF9h5Y/+/afGgR2Nl63ZzHJDmuv8jJOsAqMK0nPWL8U/ag95ivk
         Miev2aWHV729iIZ56rPo3UIhr6oSM2pXLZ1DnUUwszz1fF+mvwiEqx6kEU3jCXfyi2Y8
         PUuUuSJYvyVKgkzQfJdOkouzxT3++x5/Z3EN+3t5Ruyg8fqKg4YSM783wkUnbiYh52jN
         YVwQ==
X-Gm-Message-State: AO0yUKXQtcLsIRT6scuuAliXFMQpHjhzwEv6tonr9QjGnzUykyB/ns1M
        0fcXuEbMEs6Tg3pe4oWBN5xDNkm8FqGTWMH+uBQ=
X-Google-Smtp-Source: AK7set9OGZT7YJm+qwJGgDZ/+FZ68Yv4KKRU5vzxM5AA8wrBQuS4ofodOVIL5hSc1n0WxS2/hIfRhw==
X-Received: by 2002:a17:90a:3d83:b0:23a:8d83:5259 with SMTP id i3-20020a17090a3d8300b0023a8d835259mr1445414pjc.4.1678249102564;
        Tue, 07 Mar 2023 20:18:22 -0800 (PST)
Received: from [172.20.4.229] ([50.233.106.125])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090a890200b0023a71a06c86sm7731236pjn.29.2023.03.07.20.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 20:18:22 -0800 (PST)
Message-ID: <8f859870-e6e2-09ca-9c0f-a2aa7c984fb2@kernel.dk>
Date:   Tue, 7 Mar 2023 21:18:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] tap: add support for IOCB_NOWAIT
To:     netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tap driver already supports passing in nonblocking state based
on O_NONBLOCK, add support for checking IOCB_NOWAIT as well. With that
done, we can flag it with FMODE_NOWAIT as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8941aa199ea3..ce993cc75bf3 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -555,6 +555,9 @@ static int tap_open(struct inode *inode, struct file *file)
 		goto err_put;
 	}
 
+	/* tap groks IOCB_NOWAIT just fine, mark it as such */
+	file->f_mode |= FMODE_NOWAIT;
+
 	dev_put(tap->dev);
 
 	rtnl_unlock();
@@ -771,8 +774,12 @@ static ssize_t tap_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct file *file = iocb->ki_filp;
 	struct tap_queue *q = file->private_data;
+	int noblock = 0;
+
+	if ((file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT))
+		noblock = 1;
 
-	return tap_get_user(q, NULL, from, file->f_flags & O_NONBLOCK);
+	return tap_get_user(q, NULL, from, noblock);
 }
 
 /* Put packet to the user space buffer */
@@ -888,8 +895,12 @@ static ssize_t tap_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct file *file = iocb->ki_filp;
 	struct tap_queue *q = file->private_data;
 	ssize_t len = iov_iter_count(to), ret;
+	int noblock = 0;
+
+	if ((file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT))
+		noblock = 1;
 
-	ret = tap_do_read(q, to, file->f_flags & O_NONBLOCK, NULL);
+	ret = tap_do_read(q, to, noblock, NULL);
 	ret = min_t(ssize_t, ret, len);
 	if (ret > 0)
 		iocb->ki_pos = ret;

-- 
Jens Axboe

