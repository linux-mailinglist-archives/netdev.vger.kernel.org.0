Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02495769B2
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbiGOWKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbiGOWIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:08:48 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD05DDA
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 15:03:39 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id cp18-20020a17090afb9200b001ef79e8484aso8804217pjb.1
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 15:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:cc:content-transfer-encoding;
        bh=o2ORP8XdWKFtqKvkH9cdGQnLjDL+KkLGE24Ewvy+76o=;
        b=OI3nGflbvfgR2FKmyOGjl1oIHCNat+VWFDMFesgIcmGapfRPLURvyoIJ+s7V3gls0o
         pxhpaXAoNZXVz3NtQiqU02tk+YbDkI7nsepVocfoqLuriIjJH8fa1EP1LpUjMrT8GSSb
         Rk4yxWnR4u4A6LdhLMBRigLzfCJ9NWJ9W4KTAVjv6bu5g5yflevPszLQuiTry/wugIVd
         Kqulhn2GAu2DfgN76bxto+BLrjXIBEAeZRCgAWlGiUnVTsi2YT5LzBo7nWhOXwtjlJZL
         j3Wan60GxAoDZvbLLxgFc2xUXA1zCyhrFy+rkMgzMssnumnPJE8MAPjlZzhUH/vMs6a8
         cHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=o2ORP8XdWKFtqKvkH9cdGQnLjDL+KkLGE24Ewvy+76o=;
        b=uEAxOwU0YpITPA0cPFry3gIhoMq718YkCPhH71jQKL+0i2eZOIlsC3yOMjYGuRqDZu
         NY9lEWKTmPqtySmeN5/VRGxA3YEgq4/gjuuXZ6Kw1yDbc53B7BmgF0RF60TEFf8sVb4w
         YnA24hxXxbmkaA/of2hd4QxTJFN7+jRlqtfU6aBvw8tK6rlmHanKM4+7ZaMZp1DroJJw
         bIpHQDPWHtF7odSow9gKScljMmwYxc2THg8V8bXmuwt/0p8Z7kB2isDCb+833f3k09XO
         sTc7RuUfB4IVdhxhX4kYY92lyARaGgVo3Tj31QsPiSktC2gzdFOz7IPLmbPjUl+uvQuT
         hC8Q==
X-Gm-Message-State: AJIora9KVzMlrHRMX67hcnZaNQYlhO9jJJQSAryFwUbT0Wjj1OoAookB
        X+Oe+6zr6sBuFGSZjPI5dp6x7KkNvkfrgA==
X-Google-Smtp-Source: AGRyM1uj65/gCvQFQi+2vy8ZEA5TILQFeWRRROedjpWnX97K2iyQRG9TGBkTb7sj9J5rA8X/gDxYTA==
X-Received: by 2002:a17:902:d542:b0:16c:8ac:f471 with SMTP id z2-20020a170902d54200b0016c08acf471mr15986807plf.39.1657922614808;
        Fri, 15 Jul 2022 15:03:34 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z12-20020a17090a7b8c00b001eee8998f2esm6018298pjc.17.2022.07.15.15.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 15:03:34 -0700 (PDT)
Message-ID: <bc98a0f1-199d-a84d-21bc-274a47fae5a6@kernel.dk>
Date:   Fri, 15 Jul 2022 16:03:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] net: fix compat pointer in get_compat_msghdr()
Cc:     Dylan Yudaken <dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A previous change enabled external users to copy the data before
calling __get_compat_msghdr(), but didn't modify get_compat_msghdr() or
__io_compat_recvmsg_copy_hdr() to take that into account. They are both
stil passing in the __user pointer rather than the copied version.

Ensure we pass in the kernel struct, not the pointer to the user data.

Link: https://lore.kernel.org/all/46439555-644d-08a1-7d66-16f8f9a320f0@samsung.com/
Fixes: 1a3e4e94a1b9 ("net: copy from user before calling __get_compat_msghdr")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

As this was staged in the io_uring tree, I plan on applying this fix
there as well. Holler if anyone disagrees.

diff --git a/io_uring/net.c b/io_uring/net.c
index 6b7d5f33e642..e61efa31c729 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -398,7 +398,7 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 	if (copy_from_user(&msg, sr->umsg_compat, sizeof(msg)))
 		return -EFAULT;
 
-	ret = __get_compat_msghdr(&iomsg->msg, sr->umsg_compat, &iomsg->uaddr);
+	ret = __get_compat_msghdr(&iomsg->msg, &msg, &iomsg->uaddr);
 	if (ret)
 		return ret;
 
diff --git a/net/compat.c b/net/compat.c
index 513aa9a3fc64..ed880729d159 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -89,7 +89,7 @@ int get_compat_msghdr(struct msghdr *kmsg,
 	if (copy_from_user(&msg, umsg, sizeof(*umsg)))
 		return -EFAULT;
 
-	err = __get_compat_msghdr(kmsg, umsg, save_addr);
+	err = __get_compat_msghdr(kmsg, &msg, save_addr);
 	if (err)
 		return err;
 
-- 
Jens Axboe

