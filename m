Return-Path: <netdev+bounces-4038-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF3770A35E
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 01:31:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 664A41C20E53
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 23:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 750386AB1;
	Fri, 19 May 2023 23:31:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694733D3B6
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 23:31:07 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6F1E5D;
	Fri, 19 May 2023 16:30:59 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-64d2981e3abso1600945b3a.1;
        Fri, 19 May 2023 16:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684539059; x=1687131059;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cbkE4lFs3MjTSqGjLlORxHU2UXZyNUzXu0UGRUNEtpU=;
        b=g0ZQKuiT1TNc5fYsAOR7g43ipYNMSZubKLUriSON89qtsHKgpmK1icCXLH/8xM6aaf
         fjHX0w4wrqRiuYDGUH1E/ti40MUegKCUgC/f6WyKLyqvOUgeVgJDgw/An65vE3be7Ll0
         jAq6QIoLQfjpWR7th7R5ypG/kAUuC4790T9EikAX5Da1UG6qzE51er9M3baqejVvvJXg
         gWfjXy8aSnNG+40xvAGIrMzEchX+v8i9iInHf8tCR/FYVrZAye5eEPI+D1vMhEVLlNML
         DA0/joBZLYAj9L8XbxKXUyLHZJxHbf7TKLMeK5pCLGYAN+Ok0GnMq6oPr+otHGd2bVxt
         WBQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684539059; x=1687131059;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cbkE4lFs3MjTSqGjLlORxHU2UXZyNUzXu0UGRUNEtpU=;
        b=RA05c3vIxdbAq0ydS5B0mFs9P2UrzWMouP4Iwwp8uTCXdxGtTFjHMXh0itiVkQUP3N
         lFZlf2NsmUiVx4wSnJegDWMG7XkGUU8mRetseFt5CggKcOiw3WxA/l53xdQCjB9BgS4T
         AK0H4sg0zkeSh5SK0Ki0Ub6WF4J7ZQmDOpPXXfzHp0mnLcrE9+kFjzj7JiE9wZgYT6TH
         3SQYSt9apxu+u6JoVGaF3HA4msNbRgo+2kswB2JI4F7oGO1MpQsr9pBFv4LcMozZXQsM
         lg27dVxfCi8JF4a/uX965Q/h7JwoVI5b+pr5qAsuWuqIr6jzqIptn6MH4qy+fsJGeXRB
         sMAw==
X-Gm-Message-State: AC+VfDxcJhdod+9YaM9bqFtJdiXAntoC5aoNrn4AD9jo4xQHPjPRl7CH
	ljUYePTvlvs9ODi8M94pUn0=
X-Google-Smtp-Source: ACHHUZ7e8nf3ogsTYNesoZLMmTh9dZBLBAzRiwdD8os8pGSsolKgCtVs54sJtpiH13mPob6HFDDrag==
X-Received: by 2002:a05:6a20:8e15:b0:103:e05f:c6d2 with SMTP id y21-20020a056a208e1500b00103e05fc6d2mr3866686pzj.1.1684539058528;
        Fri, 19 May 2023 16:30:58 -0700 (PDT)
Received: from lvondent-mobl4.. (c-71-59-129-171.hsd1.or.comcast.net. [71.59.129.171])
        by smtp.gmail.com with ESMTPSA id k25-20020a63ff19000000b00530914c3bc1sm248348pgi.21.2023.05.19.16.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 16:30:57 -0700 (PDT)
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To: davem@davemloft.net,
	kuba@kernel.org
Cc: linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org
Subject: pull-request: bluetooth 2023-05-19
Date: Fri, 19 May 2023 16:30:56 -0700
Message-Id: <20230519233056.2024340-1-luiz.dentz@gmail.com>
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

The following changes since commit 9025944fddfed5966c8f102f1fe921ab3aee2c12:

  net: fec: add dma_wmb to ensure correct descriptor values (2023-05-19 09:17:53 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-05-19

for you to fetch changes up to 6ce5169e05aa5360a49a574cc1490ceea6b651a6:

  Bluetooth: btnxpuart: Fix compiler warnings (2023-05-19 15:38:29 -0700)

----------------------------------------------------------------
bluetooth pull request for net:

 - Fix compiler warnings on btnxpuart
 - Fix potential double free on hci_conn_unlink
 - Fix UAF on hci_conn_hash_flush

----------------------------------------------------------------
Neeraj Sanjay Kale (1):
      Bluetooth: btnxpuart: Fix compiler warnings

Ruihan Li (4):
      Bluetooth: Fix potential double free caused by hci_conn_unlink
      Bluetooth: Refcnt drop must be placed last in hci_conn_unlink
      Bluetooth: Fix UAF in hci_conn_hash_flush again
      Bluetooth: Unlink CISes when LE disconnects in hci_conn_del

 drivers/bluetooth/btnxpuart.c    |  6 ++--
 include/net/bluetooth/hci_core.h |  2 +-
 net/bluetooth/hci_conn.c         | 77 +++++++++++++++++++++-------------------
 3 files changed, 45 insertions(+), 40 deletions(-)

