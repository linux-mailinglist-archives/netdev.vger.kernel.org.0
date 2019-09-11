Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3B5AFB17
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbfIKLIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:08:49 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:43637 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfIKLIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 07:08:48 -0400
Received: by mail-qk1-f193.google.com with SMTP id h126so12665828qke.10
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 04:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H7dm5LylxBCKDzcEYDJbXJgGjdRd2Jacret0oWgWP8M=;
        b=08DePBNnPNEqO7I2YEHkuw/6RhDnUl+Z1zOBRFHDZVJYoPTDs9R4FyBQvAaokwtTWk
         nwaiX2Fh7Tfm7oYIMDLcVqwkpF2QwFvppZKJfKrYekzTXLD1V6B5/Wm4icI5sgDSzYSH
         YH46LoVYDt06zIRVBjpDsBIjErc33UUNrEniQJitSnaA3KKjaBNjOddIk6TMK3yZ5r63
         FwX+QRO8Gpyvsd7CLinzHOoPvT94+Wkx6+GiPd3RHB1dNbmD9KN+oeDwGdyd9UnQ0mNh
         Fwzs2pZN7vf1H/2kaQmPViCB+kxA01JRavmz0a055kI+YP/yhfSR0KR3r51hfiKOdNRe
         ka7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H7dm5LylxBCKDzcEYDJbXJgGjdRd2Jacret0oWgWP8M=;
        b=hJHVwruXVPz5PfNgcK5NiZz4xgSIU0UoTb7pB/R2nREaJL/FCZBsBlxqKDNNTBziWg
         OsBhTGZga0KeSDIjkAYq2x/TljxLk0JI1uWMYLxvMLdnfj4j6qLPZUKKDLthAL3RsBjq
         4WY7zr0g450VClh3s4lybyRk+9yrjCAFv3v8CV+4oXhPfJyiCHDLQWPMjSYpx/QG7y/X
         nmIrqgxTDOmw2P+0Moe7uTBBCM9U2eFjVbiWBCv/Rm+IjAPZTeTOXnWIS6DJ3lWxp3XD
         umqlYFP7XnsOZD4TI9GqwlHVQXNWRDl+o17PIEDF0hlJwX6b3cDcIYFAwIHf7wALe+Tn
         /p7A==
X-Gm-Message-State: APjAAAWcdmqd7kTDYloOy/NWvG9PoYsXXqqArY3TrX6chNXeX5jNvNUt
        wMX+HzXIfdYz+nIGFT7bm2KEZTZKyAntPg==
X-Google-Smtp-Source: APXvYqws8d4+cYdj3QpWpQltul55gM2fIVWXxd4Ux2h6Ze+XzoiH5hl+kQP4DG8LyFAl1kS67wUGww==
X-Received: by 2002:a05:620a:1539:: with SMTP id n25mr34238279qkk.0.1568200127619;
        Wed, 11 Sep 2019 04:08:47 -0700 (PDT)
Received: from penelope.pa.netronome.com ([148.69.85.38])
        by smtp.gmail.com with ESMTPSA id a190sm10232501qkf.118.2019.09.11.04.08.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:08:46 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 1/2] devlink: add unknown 'fw_load_policy' value
Date:   Wed, 11 Sep 2019 12:08:32 +0100
Message-Id: <20190911110833.9005-2-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190911110833.9005-1-simon.horman@netronome.com>
References: <20190911110833.9005-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Similar to the 'reset_dev_on_drv_probe' devlink parameter, it is useful
to have an unknown value which can be used by drivers to report that the
hardware value isn't recognized or is otherwise invalid instead of
failing the operation.

This is especially useful for u8/enum parameters.

Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 include/uapi/linux/devlink.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 1da3e83f1fd4..8da5365850cd 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -203,6 +203,7 @@ enum devlink_param_fw_load_policy_value {
 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DRIVER,
 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH,
 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK,
+	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_UNKNOWN,
 };
 
 enum devlink_param_reset_dev_on_drv_probe_value {
-- 
2.11.0

