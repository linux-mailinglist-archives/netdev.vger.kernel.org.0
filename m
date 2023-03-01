Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA246A7387
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 19:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjCASgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 13:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCASgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 13:36:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50A047402;
        Wed,  1 Mar 2023 10:36:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F5546147A;
        Wed,  1 Mar 2023 18:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FABC433D2;
        Wed,  1 Mar 2023 18:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677695806;
        bh=dJbYJ/NNyQBREXfySmKAVF9Y4eFJgZ2sCCx+sMRma/g=;
        h=From:To:Cc:Subject:Date:From;
        b=GOYVXq1lFbqrDEdTGgGhmItOrXenTchQUhb1pBOxCEgTzWFcE/0KEhVLHsPYqp2vK
         UR2Bzn0dZNueSM2D19GPXmlrKeCHPpwFwQgQCvvUeoHCQfXw6+La2C/dbpU+ya3xMr
         DmaBAn1zaGWpxebkjHlksCtLQ3an1aA/yDHWVbD6ACcwEdxboj2hniVI0AOKs8evxy
         3kZXug9YCxvEyJtV6HNeJly0UZPTWnEhra7F58QyBDDgDKH7roN/9NpEqIN+baclqZ
         EXePWSJ3Ocn9U7U0p5S7fKpgpAS2Q5IeXnWnQtnb3vzZtAZiPavLEoCTnOhzNdGLYG
         11yE033kvNnRQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-doc@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/3] tools: ynl: fix subset use and change default value for attrs/ops
Date:   Wed,  1 Mar 2023 10:36:39 -0800
Message-Id: <20230301183642.2168393-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a problem in subsetting, which will become apparent when
the devlink family comes after the merge window. Even tho none
of the existing families need this, we don't want someone to
get "inspired" by the current, incorrect code when using specs
in other languages.

Change the default value for the first attr/op. This is a slight
behavior change so needs to go in now. The diffstat of the last
patch should serve as the clearest justification there..

Jakub Kicinski (3):
  tools: ynl: fully inherit attrs in subsets
  tools: ynl: use 1 as the default for first entry in attrs/ops
  netlink: specs: update for codegen enumerating from 1

 Documentation/netlink/specs/ethtool.yaml      | 15 -----------
 Documentation/netlink/specs/fou.yaml          |  2 ++
 Documentation/netlink/specs/netdev.yaml       |  2 --
 Documentation/userspace-api/netlink/specs.rst | 10 +++++--
 tools/net/ynl/lib/nlspec.py                   | 27 ++++++++++++-------
 tools/net/ynl/ynl-gen-c.py                    |  7 +++--
 6 files changed, 32 insertions(+), 31 deletions(-)

-- 
2.39.2

