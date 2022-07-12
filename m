Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A2857178B
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiGLKs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiGLKs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:48:58 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B148140E6
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:48:56 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id sz17so13572804ejc.9
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CtNLc+zHrE4eROp1W7Buw5YfPYD5lQRArRs16J3dFe8=;
        b=2c0Kj3e8AUuUs1kRzaJUJx80gaa6EN9J2FxKC3yFC27ugf3T6aZ9MNO6AOQgKKHlGO
         FGWHmvEB77aqb+Rh55m7rPU+4Rs88pdbscUaKUnAa+pKW8d/eozckkwPTy9c/KVn7iu2
         Rd8vavtcYXUmwm0y8r3gSyTqGJ5VkUNbAmmwS4frG6S/k2IXj+mnriwYkyZpk6sOsz/h
         ru3dAD4gaiVGkvPaZbZxewNUNVEc+eyYLsFHVJLt5sEK79cjWuV4fIE57aBWwPIyICVv
         RsZ1kGcwcmbOK0+tCaVDTVmfhzNZc00+kxXwee1NsY9+8LcMiXNcVyJsH+hY6+sIEac2
         Clow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CtNLc+zHrE4eROp1W7Buw5YfPYD5lQRArRs16J3dFe8=;
        b=wqvKrPQp99rrfoaiYUDWqexk8u8+9p1Ista8bmUSwvzu/Z+yjQV/lfb0OjEgNYlBHY
         jiKudyxVE+shrE07vIkKwxe/T57rNmC+gdfUkfUn8z3+RU77HJ9l/wIddsFYnX0lbMLy
         njYIAuC836BhlsUGES6Fi11i6zGJuxNpdtgD+yyvVz9G2LfLGDW1tQ2S5e47vjP5Aos+
         b5fGrjb2LPYL0vFGR5rxaJPvnwkVhWxp2sfFMqq1hgQX1/BZIW1npF0bq2AHgeVfxZdb
         JXXSQT7CD6reG+IyS1SVs0IgMqRaG56N95XmoRB/ydl4ymwVAJgXKqDyMwCHpJUr6cxQ
         26/A==
X-Gm-Message-State: AJIora/ZGmmMc1fJHbaEaD0/tIybzZcr3l4bYQQMp2oApF7qK6qpiGHj
        UrtMddt46CeY2dQWgUY8RfiU+m8orTrjBZvX3Uk=
X-Google-Smtp-Source: AGRyM1uWilH4SwroIQaIwadHP6RPQumFXfic5jAmWVVpm551YWJCz3lXizh1nLMQvtCd+PU3Hcs6vQ==
X-Received: by 2002:a17:907:1b1c:b0:6fe:f1a9:ef5a with SMTP id mp28-20020a1709071b1c00b006fef1a9ef5amr23794106ejc.233.1657622934937;
        Tue, 12 Jul 2022 03:48:54 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id su9-20020a17090703c900b0071cbc7487e1sm3689875ejb.69.2022.07.12.03.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:48:54 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next 0/3] net: devlink: couple of trivial fixes
Date:   Tue, 12 Jul 2022 12:48:50 +0200
Message-Id: <20220712104853.2831646-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Just a couple of trivial fixes I found on the way.

Jiri Pirko (3):
  net: devlink: make devlink_dpipe_headers_register() return void
  net: devlink: fix a typo in function name devlink_port_new_notifiy()
  net: devlink: fix return statement in devlink_port_new_notify()

 .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c |  6 ++----
 include/net/devlink.h                            |  2 +-
 net/core/devlink.c                               | 16 +++++++---------
 3 files changed, 10 insertions(+), 14 deletions(-)

-- 
2.35.3

