Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22966F06F0
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 16:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243678AbjD0OEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 10:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243218AbjD0OEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 10:04:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA9910D2;
        Thu, 27 Apr 2023 07:04:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7473363D82;
        Thu, 27 Apr 2023 14:04:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56162C433EF;
        Thu, 27 Apr 2023 14:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682604250;
        bh=KoZ+hzVrPZf61oJ0oYYUjItCz6bYmvndP/2vmuS5X2M=;
        h=From:To:Cc:Subject:Date:From;
        b=YKZvvKXSoAbbPJeKO1LXsVMABg37l/3amoYyr56QwTk6CX5ygmVW7n+SO97x6qIOe
         rIN8SR3Dy8J70iEywUkPsDl+0J9K7HBMHWYoVYS+Hf5xPuLZ5mOHedpgX4gZTTrRhz
         Bun7JRZXKh7Z+rmybjgS+3MrHPRe9H4Cw+TfnfhQAwkmrzt/lYtMruDndOVHgkkjZG
         XSzU+WhQIX6nRMW8lJ4kMpLm5cEsA5IRaBW+8J/+r5eZVOZ2zyyxd3LxYC2yZwgTwt
         2CB+S0jpvak05OizgnTK0MDGai8Q/ELCqmfa/x1oOuv4k23rpRj1BHnX/tvf8kErwJ
         QJOA9b649/JdA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, j.vosburgh@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, bpf@vger.kernel.org,
        andrii@kernel.org, mykolal@fb.com, ast@kernel.org,
        daniel@iogearbox.net, martin.lau@linux.dev, alardam@gmail.com,
        memxor@gmail.com, sdf@google.com, brouer@redhat.com,
        toke@redhat.com
Subject: [PATCH net 0/2] add xdp_features support for bonding driver
Date:   Thu, 27 Apr 2023 16:03:32 +0200
Message-Id: <cover.1682603719.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce missing xdp_features support for bonding driver. xdp_features
is required whenever we want to xdp_redirect traffic into a bond device
and then into selected slaves attached to it.

Lorenzo Bianconi (2):
  bonding: add xdp_features support
  selftests/bpf: add xdp_feature selftest for bond device

 drivers/net/bonding/bond_main.c               |  48 +++++++
 drivers/net/bonding/bond_options.c            |   2 +
 include/net/bonding.h                         |   1 +
 .../selftests/bpf/prog_tests/xdp_bonding.c    | 121 ++++++++++++++++++
 4 files changed, 172 insertions(+)

-- 
2.40.0

