Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C97AFF52
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 16:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbfIKO4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 10:56:36 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50602 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbfIKO4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 10:56:36 -0400
Received: by mail-wm1-f68.google.com with SMTP id c10so3865634wmc.0
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 07:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=B1IBhoHj9hZ06FtSxR59qwb+57T/p2xiDr0Ol4HSfNA=;
        b=vTsBLfxMVYW8DdwNpQfIMqFZXljeRn4xF6fzaBKk0GP6FN1597iq+scX99nuR9/Q+A
         513SbeRbUqro7uKKI6KpAaXKcn1ScUBg2MrqvUeNFMy03DpAXiSDev8MTfyOXVAdb8DD
         ZdA/Q7cezEdo8ltBPdmKX/VvHpcE4fQJvwddoCDSe77hx/tlkhhg6wz8VHLzi2MUV4mM
         I+Tc155QLpnLFYI6IGRJK7skaqtHuL7opQsAk2tZvUYUJDBvLAzg6LUIxy9hgPWYJSz+
         miMprwWxiERBZQOQY84RokHeQ22z2XXNV4ZxUZIidqmyOBYiPmwNOd4Hd6QChoiT8TdS
         3frg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=B1IBhoHj9hZ06FtSxR59qwb+57T/p2xiDr0Ol4HSfNA=;
        b=RQ/3ZO41HJAEZL3z92AdczudT+wRhFsR44x2CekL8oSFS70qNvCbOxP9kdvEoozrcO
         Oe/fApY84jkQynmSwsyOLWHTAV+o3RAxsr1c375TqBZKdu+xNySSR3d8E5hUPhHPD6bZ
         /2wRvFzEgquz/AqCZCPMFdnkedXHbvQ2PeD2x06O0qM79m1wP3nY8XRn/Ifpox8PhYQ2
         /IkO85Zb6zqjx/q0H9hUmwFIbegYV9eXAYSHrMc4LzNTGYuJHoknIdtxb+3c0ZM8JsWM
         OMsTp6YawhGErJhI02t8zzaBpyd4DxLMrRJtrGr1N4JsAgobCzriswjzqPJ7SIYanvlg
         4tog==
X-Gm-Message-State: APjAAAVX+3G46ZIAkjIKy0vIqBSQIjcXs3vT1xjPCm6O5VAM8T80oNEn
        C8ibwTKpPek+emOe9HEC9pAj0Q==
X-Google-Smtp-Source: APXvYqyq8vw7NxKjQ3dQZ3FJIK3exX8oSp1p+37lf/wuem1hlJRb7if+rD4/aTBylj0DQP8NGzuxMQ==
X-Received: by 2002:a1c:ef09:: with SMTP id n9mr4078675wmh.23.1568213792740;
        Wed, 11 Sep 2019 07:56:32 -0700 (PDT)
Received: from penelope.horms.nl ([148.69.85.38])
        by smtp.gmail.com with ESMTPSA id n8sm5031137wma.7.2019.09.11.07.56.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 07:56:31 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH iproute2-next] devlink: unknown 'fw_load_policy' string validation
Date:   Wed, 11 Sep 2019 15:56:29 +0100
Message-Id: <20190911145629.28259-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

The 'fw_load_policy' devlink parameter now supports an unknown value.

Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---

Sorry about these depenendencies, some related changes came through
in separate patch-sets.

1. Depends on iproute2-next patch sent earlier today:
   [PATCH iproute2-next] devlink: add 'reset_dev_on_drv_probe' devlink param

2. Depends on devlink.h changes present in net-next commit:
   64f658ded48e ("devlink: add unknown 'fw_load_policy' value")

   Which in turn depends on other devlink.h changes present in net-next commit:
   5bbd21df5a07 ("devlink: add 'reset_dev_on_drv_probe' param")
---
 devlink/devlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 15877a04f5d6..e4b494eb3e5d 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2259,6 +2259,11 @@ static const struct param_val_conv param_val_conv[] = {
 		.vuint = DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_UNKNOWN,
 	},
 	{
+		.name = "fw_load_policy",
+		.vstr = "unknown",
+		.vuint = DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_UNKNOWN,
+	},
+	{
 		.name = "reset_dev_on_drv_probe",
 		.vstr = "always",
 		.vuint = DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_ALWAYS,
-- 
2.11.0

