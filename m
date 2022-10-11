Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316DD5FB14D
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 13:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiJKLQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 07:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJKLQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 07:16:55 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88257167DF;
        Tue, 11 Oct 2022 04:16:51 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id l4so12891944plb.8;
        Tue, 11 Oct 2022 04:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=i4WAsnhbo3mj6+qRptDWdWyrS7sjNQ20usVEoY9BN20=;
        b=IK0W1JCopDHO3FpVF9n+RPJadViBF+kTshKxvh136W2VuPTpjvlRMiUxKRsrOixqxa
         5T99NE4XznLUWsd9jV3vCmm1sfSt2hxRtYDLvNbwPFguMyWCsZ9VX2Tk2VjxS2BoBwDv
         LT8VNvWwoD786nbCibPy6Mnho3OWhscs+sO8ngbCFHKWxGWvkfO7KiNfRQ6A59uEdtr+
         QIwegXEPplXIT0Y+7oPME5PGfySTofgnyC3JiRKE65e1b5gGm1tdheBppmQOmsrA4RWW
         nKh/rY9uKHZgBlyb1ghXiVzRjBD4ZWfiCQOko/XgvaihXPv0nFBauQcfogOMQNGfcpog
         bPhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i4WAsnhbo3mj6+qRptDWdWyrS7sjNQ20usVEoY9BN20=;
        b=uVJdQcBxU9TOnJyBXkhUp3xAiQl4VI8d9bTXTHPzAhlk9cFWS8fQUVfGNKej310uJL
         Jw7yUkceK2zuSN4Dy/eR2a2FQVD1F38MDOAxEp5+ODjmz1XtDtPTjGdkcciW+pEPjVDG
         +g9ijskTowKz3QIzdD90am7SNpJBaxpnCDF4KWm5IGP1Z68hvA2Z/KGv2wgcgzOFBxlc
         7TbojweYcWtzjiuPIC+GYwux9LyaRwmfbkLheefcX57H5pF5ZcnKHK0lp12GwWPl3YtV
         brasNMgJz2m3KkHXiVBOCDHspAbR2b1jH+MX39eEmb4GqTTXuxg7Azaw4fuXDqot7rEx
         Rlkw==
X-Gm-Message-State: ACrzQf3qNfXeqb21hEbJYzOS7UKE930kbp9UHNCpBAhBTQnXci3xwNVh
        /gzmUAfHn2hxtj/un1dWk4o=
X-Google-Smtp-Source: AMsMyM57ZWctsmlsdd6OOXLvsYniC7b+6zsqhFJ/dmNGqaEKN05YOuL3+RvxwzXFfbiONbkGUWd7GQ==
X-Received: by 2002:a17:90b:3805:b0:20d:4e77:371f with SMTP id mq5-20020a17090b380500b0020d4e77371fmr9137587pjb.170.1665487010884;
        Tue, 11 Oct 2022 04:16:50 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id s4-20020a170902ea0400b0017300ec80b0sm4510907plg.308.2022.10.11.04.16.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 04:16:49 -0700 (PDT)
From:   yexingchen116@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To:     anthony.l.nguyen@intel.com
Cc:     jesse.brandeburg@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ye xingchen <ye.xingchen@zte.com.cn>
Subject: [PATCH linux-next] iavf: Replace __FUNCTION__ with __func__
Date:   Tue, 11 Oct 2022 11:16:38 +0000
Message-Id: <20221011111638.324346-1-ye.xingchen@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

__FUNCTION__ exists only for backwards compatibility reasons with old
gcc versions. Replace it with __func__.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3fc572341781..98ab11972f5c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4820,7 +4820,7 @@ static void iavf_shutdown(struct pci_dev *pdev)
 		iavf_close(netdev);
 
 	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
-		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
+		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __func__);
 	/* Prevent the watchdog from running. */
 	iavf_change_state(adapter, __IAVF_REMOVE);
 	adapter->aq_required = 0;
-- 
2.25.1

