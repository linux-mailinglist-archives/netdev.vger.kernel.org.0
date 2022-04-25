Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FEA50DAC4
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 09:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbiDYIBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 04:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiDYIBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 04:01:43 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C808427CE7;
        Mon, 25 Apr 2022 00:58:39 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id i21-20020a4ad395000000b0033a4c45246dso2655733oos.12;
        Mon, 25 Apr 2022 00:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zR3SdtKlOp4Z4lFcN7vvrmY5zhl40lIVin8T1dOigGE=;
        b=AguFV38TUhd52TAXg1m48mbU7nyWNJIoxXDddH/xHSjOHembF2jrBirIEDb07sbTEc
         zi4a5f+Xgg3K6qAv1kOmEaJIxUjflem9hYgm6plSnCqu5+lWJn5/yda5dmesvjBhTECW
         5J3b8P7FGI1OON059nf4vMOqa1m9RIQkmUC91ZJNzscJ63RpcS91MZ8C3ScxW3SzXYNc
         FJiDgivH5lxMdytBsIDahN0vEp/a00dQg23rmFD/TOm0WfM2pc81rSrvzJSZbrb80CAP
         Am+fsGMKIg2m4MZiH0Uf6E43d6ADzSg7Y88GkiKoprnXkK+XpY8O2JXaCpiba+GayBy9
         0qGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zR3SdtKlOp4Z4lFcN7vvrmY5zhl40lIVin8T1dOigGE=;
        b=OagHhiTjFydsOK561WzYZ2CzEdR8F5EhWG2ce0+wvQ7iv7WsAEoBTxgMNx0E+s66or
         H0dDQUGoVkXh6XWVtPAD3c5x8ENI8aH7L/ozAh28cqNi2d+/HKzuSP/xoYRyFfJVu+rP
         pookQt9jMGrDFS7aTd5RZPjksFSDpxuNqKtX/vTAhpOMwz0wdTZt9zlV/nRX7Wt/3M9W
         V9ahRzcrnDLnf59C04xk52Uz9OM8bJMZ/lU+SQ7TzexBb4H0dMjodYAwoNsk1zpx8VCx
         0JExXC+afRStbIWp1t0kNqVhGlF4ck99nsJRJZcu6FeXxocGaXM8/l8MwXEhoTVgZRf1
         rtWg==
X-Gm-Message-State: AOAM5326x/d0+GMZTqOrrkJFAqhWcAwV3iloWodreSO57oEl2PBU6nYl
        7UC3uKvIBdF3X8IDyp7PJmZIC+8YLsGEVhRkQhD4QQ==
X-Google-Smtp-Source: ABdhPJwM8MWYFSjh0xlo73yHp0vTj5enQOHIpyFJxzRHx7ObNG2ap9LrYlyNJLeQWBzt8CrOI2+6vA==
X-Received: by 2002:a4a:d984:0:b0:329:a95a:d492 with SMTP id k4-20020a4ad984000000b00329a95ad492mr5829472oou.61.1650873519031;
        Mon, 25 Apr 2022 00:58:39 -0700 (PDT)
Received: from C02FV47ZMD6T.corp.ebay.com ([2409:8a1e:6f32:c70:4860:8ac9:99a5:1188])
        by smtp.googlemail.com with ESMTPSA id z82-20020aca3355000000b002ef73b018absm3439329oiz.9.2022.04.25.00.58.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Apr 2022 00:58:38 -0700 (PDT)
From:   Jianlin Lv <iecedge@gmail.com>
X-Google-Original-From: Jianlin Lv <jianlv@ebay.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, quentin@isovalent.com, jean-philippe@linaro.org,
        mauricio@kinvolk.io, ytcoode@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jianlv@ebay.com, Jianlin Lv <iecedge@gmail.com>
Subject: [PATCH bpf-next] bpftoo: Support user defined vmlinux path
Date:   Mon, 25 Apr 2022 15:57:24 +0800
Message-Id: <20220425075724.48540-1-jianlv@ebay.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianlin Lv <iecedge@gmail.com>

Add EXTERNAL_PATH variable that define unconventional vmlinux path

Signed-off-by: Jianlin Lv <iecedge@gmail.com>
---
When building Ubuntu-5.15.0 kernel, '../../../vmlinux' cannot locate
compiled vmlinux image. Incorrect vmlinux generated vmlinux.h missing some
structure definitions that broken compiling pipe.
---
 tools/bpf/bpftool/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index c6d2c77d0252..fefa3b763eb7 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -160,6 +160,7 @@ $(OBJS): $(LIBBPF) $(LIBBPF_INTERNAL_HDRS)
 VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
 		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
 		     ../../../vmlinux					\
+		     $(if $(EXTERNAL_PATH),$(EXTERNAL_PATH)/vmlinux)	\
 		     /sys/kernel/btf/vmlinux				\
 		     /boot/vmlinux-$(shell uname -r)
 VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
-- 
2.25.1

