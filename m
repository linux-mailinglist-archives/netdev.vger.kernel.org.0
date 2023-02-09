Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC74690AB5
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjBINnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBINnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:43:43 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC70D2CC52;
        Thu,  9 Feb 2023 05:43:18 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id f47-20020a05600c492f00b003dc584a7b7eso3887896wmp.3;
        Thu, 09 Feb 2023 05:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UJhX5uRHq4kGgYCUsrSMsI3fM2T8uaj+xuxLxu5jIHU=;
        b=ax3yDGUEAwJXtl0fGhCBS+VfBBMUefxqlbOhTaVgBtt2MwHdRc8blJwNsk8DtpHzz0
         F2C9b3tkATap42dQXw81INMJ63L88Dnd/83iGheziHlRehw4KC/FapL7DYQOLHt53pDh
         VJYRgVQ4UDLP4jGGUq6xwRU9RIcbOpRuqSr6Hv9T70Rb5tDZsVi6ScDqkuiICe0Y5gUV
         QvuO45iij+PM7OC5AtrMtkqQryAhmGQG85bRKnu43iqm58CFCXY+LRcBC75gPpS/CBlM
         SC/BZsKiP8VUh9P9xtLXjeMYlP60ve+/nMy5NWH7Z1MzEAhX3XE5m/+AC369f5UcF2qP
         Uh2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UJhX5uRHq4kGgYCUsrSMsI3fM2T8uaj+xuxLxu5jIHU=;
        b=akAeH/uU45YDd2h+jbfRkeOyAv6KoczW0dV2JhjGyEXi9l3NKEcF5/YBhxSqftyzIy
         epuzzxuUstEaXnwDRAFrG36R7szokvj4onQ5g+zA+EBEGtv+utgwbTcliGSg43rsMdRt
         5HNFuN+wxJSJ+ahJgoYoF3r25Q2ROdIcc3Rjajd8OTjEchsT0Fpxnh9lR1URe83/iF5F
         Sg0qbMBw54OZ9yjA/rUe/gQhJ4rqYl7nwP9atJmi5bIn77/Yv1IW638eiGxULryW8qRD
         k46Q8MtArI8lddBJpP367kfrSHJt+W+MQWC5Z+DGLvWYu9UqJN4000MMe3KhagID9k/m
         DPtA==
X-Gm-Message-State: AO0yUKWhGFifYRXNjF+0XZHNqKxzC8p28qYM+GOoLqzf0459xzMhTSih
        DO2jNoX+EbRWn+1TswOxVk8=
X-Google-Smtp-Source: AK7set/kjE+8CPZZmmxkjdQaYU+lpfU2VCSfRUwINVjYE/KYo1v+hC1g/ZYLOap3tnlv7QzNvsdwyg==
X-Received: by 2002:a05:600c:43c7:b0:3dc:932f:f7cb with SMTP id f7-20020a05600c43c700b003dc932ff7cbmr10357134wmn.37.1675950197161;
        Thu, 09 Feb 2023 05:43:17 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c450700b003dc42d48defsm2409481wmo.6.2023.02.09.05.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 05:43:16 -0800 (PST)
Date:   Thu, 9 Feb 2023 16:43:06 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     Mengyuan Lou <mengyuanlou@net-swift.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: libwx: fix an error code in
 wx_alloc_page_pool()
Message-ID: <Y+T4aoefc1XWvGYb@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function always returns success.  We need to preserve the error
code before setting rx_ring->page_pool = NULL.

Fixes: 850b971110b2 ("net: libwx: Allocate Rx and Tx resources")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Applies to net-next.

 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 57e1871ea0c6..ca92fe19a663 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1745,8 +1745,8 @@ static int wx_alloc_page_pool(struct wx_ring *rx_ring)
 
 	rx_ring->page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(rx_ring->page_pool)) {
-		rx_ring->page_pool = NULL;
 		ret = PTR_ERR(rx_ring->page_pool);
+		rx_ring->page_pool = NULL;
 	}
 
 	return ret;
-- 
2.35.1

