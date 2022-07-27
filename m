Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1015581E0E
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240257AbiG0DPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240223AbiG0DPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:15:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9B01E3E9
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:15:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 547D461794
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 03:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6272DC433D6;
        Wed, 27 Jul 2022 03:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658891727;
        bh=eYG8q+DFUdQ//yN3krbmnoVm+dXsUCgbMwy/Zk9e4rY=;
        h=From:To:Cc:Subject:Date:From;
        b=SNyziVM6Kd++p1SE0GJRx8OtP9l3ixWAwMp+7ifSTQgfGSFsjCTqWoSH19j8xeLtk
         yeRSvLXycm1DvxGTO278dYvuOIyl1j6ckba6O0qEjyUFUWYgP9J38arjc+tO+ZnauK
         wsCR6bu58fUe8sHXec69eTVqJcfxSPOpPsGGfscsequ8RsoTkDfglnDAd6OgcBjs6Z
         xGsvb4AC+tz1TcLZ/8ynDdbrVgRW2wS3HpTlQcZuT8ZxTAllt6RTH3CdLeWMK6R1tN
         DnyaV8qIflSNkB89ubav+ep70pGPy3vdA0j81B0CLVBCgnvJWdLQrVmiy4/ufXHcz3
         ZMpUxCWoJwc8A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/4] tls: rx: follow ups to rx work
Date:   Tue, 26 Jul 2022 20:15:20 -0700
Message-Id: <20220727031524.358216-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A selection of unrelated changes. First some selftest polishing.
Next a change to rcvtimeo handling for locking based on an exchange
with Eric. Follow up to Paolo's comments from yesterday. Last but
not least a fix to a false positive warning, turns out I've been
testing with DEBUG_NET=n this whole time.

Jakub Kicinski (4):
  selftests: tls: handful of memrnd() and length checks
  tls: rx: don't consider sock_rcvtimeo() cumulative
  tls: strp: rename and multithread the workqueue
  tls: rx: fix the false positive warning

 net/tls/tls_strp.c                |  2 +-
 net/tls/tls_sw.c                  | 39 ++++++++++++++++---------------
 tools/testing/selftests/net/tls.c | 26 ++++++++++++++-------
 3 files changed, 38 insertions(+), 29 deletions(-)

-- 
2.37.1

