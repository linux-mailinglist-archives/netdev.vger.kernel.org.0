Return-Path: <netdev+bounces-12077-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8B25735EB1
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 22:47:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83495280FD1
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:47:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B594ED52D;
	Mon, 19 Jun 2023 20:47:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA511EA8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 20:47:23 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62ABE63;
	Mon, 19 Jun 2023 13:47:20 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-30e412a852dso3342395f8f.0;
        Mon, 19 Jun 2023 13:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687207639; x=1689799639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Aq5AJzteC4m/ndim3zRr2CGCqXNuTqzT8Bn9CWt1FW0=;
        b=HDDqDnTqUXU9qkde5k7OnBXj9v2bfadQNXJWfzJHN7vJHb/i3kiQjKt/xBIr2yF3Ar
         yP2bC8MaGjqM0/aHFg7nRrTkmIE8OEFlzGf6/Q/2LOnqoh1DJQLw0In/quN938DqWOnS
         lXKwws6KIRhY2LtbVbZTAeXBy7yH76X0USK+1dnd57+3GzjYzGEy/i3VUVmftftqzLRJ
         h5tWZOs79ju/vhy3sfrphmWzl16eh03eZ4k5ma9/EqvzRxNPZprLjIM3kKeE/8hf6O/e
         byvKOv7KUk7XRVmWQhWNz61yO89FQL3naf4DbaQNV+fR3fsfVmW9CXcE8IcFqeIhYibJ
         zZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687207639; x=1689799639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aq5AJzteC4m/ndim3zRr2CGCqXNuTqzT8Bn9CWt1FW0=;
        b=b1UGgrdgbi+5s2AFAMs0W1tnCpzKNHPbKU/hLCuGMGnMEFql88ow/jnz6ytz1YD85t
         BlcV7T8Ez8QhEzPpPDo8Hr+y3k8MpCh4ihHdYsS/8JwdFxjfD72j6ypOEBt9NzYAgbsS
         0VWFmyf9975VUcunxWSYItQNXQKhxkGG/tZWF9XE143RXFCCt0QSoVpaDhg0y7pc0Xq8
         QaBc+1WvHgKSowt0czwam1kCcdOpYQEPglrS93qVTkSPvYFN6QiW8qJEcZ+qk89mxPiY
         Ua4860FOHwQTZPgjOToSC1Axog9XfcFna66mKCzn7HOzf/KM82Yn39NaaqCSXDry4loV
         hGZw==
X-Gm-Message-State: AC+VfDzA1md7XnmO0UkcMUmq89bsfL70XrajCrDC272xQPt82TP1tfZ4
	S+ZPC6ht3kQ3BMzfFnv2fPs=
X-Google-Smtp-Source: ACHHUZ7rY+fCw3LTviAJjzFnaEpmaCmfZPLc4GlmHXLdfMbUYD5Fizso7Amwr9eK8XG90/4Yy5Uljw==
X-Received: by 2002:adf:dcc3:0:b0:311:1946:fe7d with SMTP id x3-20020adfdcc3000000b003111946fe7dmr7861005wrm.53.1687207638792;
        Mon, 19 Jun 2023 13:47:18 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id k10-20020adff5ca000000b0030ae87bd3e3sm434043wrp.18.2023.06.19.13.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 13:47:18 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Christian Marangi <ansuelsmth@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [net-next PATCH v5 0/3] leds: trigger: netdev: add additional modes
Date: Mon, 19 Jun 2023 22:46:57 +0200
Message-Id: <20230619204700.6665-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is a continue of [1]. It was decided to take a more gradual
approach to implement LEDs support for switch and phy starting with
basic support and then implementing the hw control part when we have all
the prereq done.

This should be the final part for the netdev trigger.
I added net-next tag and added netdev mailing list since I was informed
that this should be merged with netdev branch.

We collect some info around and we found a good set of modes that are
common in almost all the PHY and Switch.

These modes are:
- Modes for dedicated link speed(10, 100, 1000 mbps). Additional mode
  can be added later following this example.
- Modes for half and full duplex.

The original idea was to add hw control only modes.
While the concept makes sense in practice it would results in lots of
additional code and extra check to make sure we are setting correct modes.

With the suggestion from Andrew it was pointed out that using the ethtool
APIs we can actually get the current link speed and duplex and this
effectively removed the problem of having hw control only modes since we
can fallback to software.

Since these modes are supported by software, we can skip providing an
user for this in the LED driver to support hw control for these new modes
(that will come right after this is merged) and prevent this to be another
multi subsystem series.

For link speed and duplex we use ethtool APIs.

To call ethtool APIs, rtnl lock is needed but this can be skipped on
handling netdev events as the lock is already held.

[1] https://lore.kernel.org/lkml/20230216013230.22978-1-ansuelsmth@gmail.com/

Changes v5:
- Fix conflict error on rebase
- Add Review-by tag by Andrew
Changes v4:
- Add net-next tag
- Add additional patch to expose hw_control via sysfs
- CC netdev mailing list
Changes v3:
- Add Andrew review tag
- Use SPEED_UNKNOWN to init link_speed
- Fix using HALF_DUPLEX as duplex init and use DUPLEX_UNKNOWN instead
Changes v2:
- Drop ACTIVITY patch as it can be handled internally in the LED driver
- Reduce duplicate code and move the link state to a dedicated helper

Christian Marangi (3):
  leds: trigger: netdev: add additional specific link speed mode
  leds: trigger: netdev: add additional specific link duplex mode
  leds: trigger: netdev: expose hw_control status via sysfs

 drivers/leds/trigger/ledtrig-netdev.c | 114 +++++++++++++++++++++++---
 include/linux/leds.h                  |   5 ++
 2 files changed, 109 insertions(+), 10 deletions(-)

-- 
2.40.1


