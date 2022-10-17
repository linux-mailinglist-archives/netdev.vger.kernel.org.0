Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA16D601436
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 19:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiJQRDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 13:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiJQRDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 13:03:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0EF70E54
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:03:39 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id a10so19364370wrm.12
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 10:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wWx9ZLl6eMErHwIX6BhdtNdjpwYlqyXoA4EnFmsxy6M=;
        b=VyqSkBotHNpPmoDqByv1qhVthhMYb134HXuGZPtLZCB9MCGVEUyq3QcFeSBxkCE+7n
         ENn5Un2n8XMKQsKdfLCXaaxVqQCYvfSxeRhArHQ24ZD6OoVBoVvTVGH9cNuZ12mHDgYh
         R7A7vje5hiw8wIG8yy5fZ/lN/bJwJTF1CT6XGv/wSEjTrzGGyEeucOhx5EJrAPRE9Jlm
         qwOQSUn8ooFCqSZXabXnYrstHlSoCdJ4+GkcLKrqtU4fK8xD+z+nKsnZS3lmL3UbWlWN
         3FcxKVJFrt/+HQsc4gOLin4RHu02ohJCGIw0VlV1wmu9P3hUVm0/MFCuMHjdp0kNfcZh
         rJtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wWx9ZLl6eMErHwIX6BhdtNdjpwYlqyXoA4EnFmsxy6M=;
        b=O8lQz9WcRvhng354Z7esITRgDGoyUJqdruC36vD8MYefxvFIq6wvXedCaE7TNWbG1d
         xdCT0fkFT3qP4+r6sK/JZUxLt+83zIs3aUzAccEqXiOB1v2T1mcMD6NHK9pxytt1/5DE
         SmHaLeCQ2QLWHUnRDds8HEaznsNttZIHUOGGHl97VjYH8Ou9O98+NkFzRkrQgR5pUH+L
         vhjBQS+zcD6QbPnvZrFJbQhANCVqijAGySFGAxGO82C0/wixtBi32fiwIL26SjPVt1Cz
         3NgJfxrM+LnzmR01yZfA3ZhpuZFDOoSpCn8775Fv8ZLUCH8SWy9SxGojJKAFCpY0n20Z
         aZnw==
X-Gm-Message-State: ACrzQf0degGDVVvf2cu6buyBymCgONvL6cMUMv15g+GMfvMSzniETXi4
        +QfqCTzS/kV+NWiPBAgcgGcpAw==
X-Google-Smtp-Source: AMsMyM6thaAcRTDPpbUy8TQ/o9h8YfwT48gHJHEar+t/1uFkHjjlVPc7/5wS7DKLCIZNF0eFWxhmPg==
X-Received: by 2002:a5d:5a9a:0:b0:232:c7fb:3063 with SMTP id bp26-20020a5d5a9a000000b00232c7fb3063mr7289441wrb.50.1666026217813;
        Mon, 17 Oct 2022 10:03:37 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id w16-20020adf8bd0000000b0022f40a2d06esm9079196wra.35.2022.10.17.10.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 10:03:37 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH iproute2 0/4] ss: add missing entries in man-pages and 'ss -h'
Date:   Mon, 17 Oct 2022 19:03:04 +0200
Message-Id: <20221017170308.1280537-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When checking something else, I noticed the '-M' / '--mptcp' parameter for ss
was missing in the man page.

While at it, I also checked which other ones were missing and I even found TIPC
query support has been accidentally dropped during a previous merge.

Matthieu Baerts (4):
  ss: man: add missing entries for MPTCP
  ss: man: add missing entries for TIPC
  ss: usage: add missing parameters
  ss: re-add TIPC query support

 man/man8/ss.8 | 18 +++++++++++++++---
 misc/ss.c     |  4 +++-
 2 files changed, 18 insertions(+), 4 deletions(-)


base-commit: cb2c7ff0075901c54627a310f7c27d664ac289cc
-- 
2.37.2

