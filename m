Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA2B6AFB65
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 01:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjCHAk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 19:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjCHAkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 19:40:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E0AA8EA2
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 16:39:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F6B8615E8
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 00:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48ACDC433D2;
        Wed,  8 Mar 2023 00:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678235969;
        bh=MGw4N3944+4uKQhiLLME2EcyrRl03GjLufk1ULH9bEI=;
        h=From:To:Cc:Subject:Date:From;
        b=MKw751VTYJgCCs7QS3njjm03+u7kKvGaihTSsnrASsQt+jVjRRqC1xTqmMGI/mq2m
         QPME+IleOIKFruKEk63MH2aQKQGSkJj8B5ymwLzx0F8s9mrg6rTCQ1VHnbCHULHSqh
         rdyqqU4PK4AfumM/rkPCEV0RMimXnwdNettubN6Rjr8J/NHF0JnIcPr/t1QOY2peCZ
         1d+2Y626oILe/Gk6VwjVfN31tKBG5o8gcuYixQkIsq6YrhCBcC+9BmvU3SYMc0EX5N
         9VdAWTkX2FPX+3jgvwNT07PHDtqoXKM0K8Sjy6UEax90EbUwd+n5A8EnjBXDMl03gi
         AQSv+yHk5Hafw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        lorenzo@kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/2] tools: ynl: fix enum-as-flags in the generic CLI
Date:   Tue,  7 Mar 2023 16:39:21 -0800
Message-Id: <20230308003923.445268-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CLI needs to use proper classes when looking at Enum definitions
rather than interpreting the YAML spec ad-hoc, because we have more
than on format of the definition supported.

Jakub Kicinski (2):
  tools: ynl: move the enum classes to shared code
  tools: ynl: fix enum-as-flags in the generic CLI

 tools/net/ynl/lib/__init__.py |   7 ++-
 tools/net/ynl/lib/nlspec.py   |  99 +++++++++++++++++++++++++++++++
 tools/net/ynl/lib/ynl.py      |   9 +--
 tools/net/ynl/ynl-gen-c.py    | 107 +++++++---------------------------
 4 files changed, 126 insertions(+), 96 deletions(-)

-- 
2.39.2

