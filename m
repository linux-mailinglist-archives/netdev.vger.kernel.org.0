Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A8B66570E
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238432AbjAKJMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238433AbjAKJLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:11:54 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FAB18B16
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:26 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id q64so15220456pjq.4
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6EY9adrD63KRn8BZcOqI9Bj+3V9vlRyGorkRdpRCnM=;
        b=uMXkqx4TRf5x65jbcbPdvnVzmpJ18C642Rzp6EVAX3Df7TEUX+J9ijZycXqpEFY6vj
         e9d5JA0n0o2Mpb/j7CF3os0Tj9hZqnrWtUUYRduOsVRRTot2t6x3nJp9Z6nAsRYIH5ke
         dgDI2LgrCAIW2yGAeahd5VH7kf+SObnr9mA9kDPuLLDtrk9nY+Ih+dde41dkLCy10Hi+
         PoXtN/w09g4jO9zN5iZxrGxFJqAWHmJt0lgk4k0SpeaVZMyGbpkRJnkH2PH7pqUbGMZr
         4DK77mi9F+BKGJgsKALvdTTBnwEkj4aZHOlhMQq6QuBpnjN6rgACqA8gbi52mt8JrI8j
         ruwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W6EY9adrD63KRn8BZcOqI9Bj+3V9vlRyGorkRdpRCnM=;
        b=19deHstY+c7iOwA1AxKvGtKmb5npbvhDC4FdWdng2LqcjubfEDXJDRP4XZJY08mvyj
         qRlMw3lJwmHI6H8zL4g+eSPMoY3FAcnqCYzaL2MqOGXQRPviTG9q/ZBp5UVKVpgoMPeF
         g/6YeVJPB28ZZhN5q+Goq18DhHDJZ8LVRzQ1vWGT4BL+LpHxfQF4CHPu5tdAwOy0Y1ue
         j8tAppgoAMZF+0vdQ3fDV4wH8z20RVZhcNgAIwIvfqd3oSbwfEHxYN4cIruFIilbjfbY
         j+RRIvU48lxfMepAPJCHqDVPwV6VuucTCwntlfgdgHEmO1m1sp2VGeIgsQHsg11qjQum
         7Jrg==
X-Gm-Message-State: AFqh2kqLTSjmuR3BYV9HP8sVn4jat+t6EWyhokXT3PBmgJp6yAUdWjEN
        Nq+xG6D2Eo8Uu7bt+OfK2yyfKJ9D1ihibotJz5KCqQ==
X-Google-Smtp-Source: AMrXdXs6CGNtbils8jL/9i7+iS2FCpFPQSeg0pjUvWcm4DFCNzU/50N77ySRdf8ZLTxYbXfjpLecKw==
X-Received: by 2002:a17:902:ebc6:b0:194:4fb3:65a6 with SMTP id p6-20020a170902ebc600b001944fb365a6mr584437plg.18.1673428105943;
        Wed, 11 Jan 2023 01:08:25 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id a14-20020a170902710e00b00194516b2d88sm318206pll.260.2023.01.11.01.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 01:08:25 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next v4 10/10] devlink: add instance lock assertion in devl_is_registered()
Date:   Wed, 11 Jan 2023 10:07:48 +0100
Message-Id: <20230111090748.751505-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111090748.751505-1-jiri@resnulli.us>
References: <20230111090748.751505-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

After region and linecard lock removals, this helper is always supposed
to be called with instance lock held. So put the assertion here and
remove the comment which is no longer accurate.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/devl_internal.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index b61e522321ac..02097c09ab80 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -84,9 +84,7 @@ struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp);
 
 static inline bool devl_is_registered(struct devlink *devlink)
 {
-	/* To prevent races the caller must hold the instance lock
-	 * or another lock taken during unregistration.
-	 */
+	devl_assert_locked(devlink);
 	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 }
 
-- 
2.39.0

