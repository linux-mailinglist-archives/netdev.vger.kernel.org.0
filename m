Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906E15EEAB9
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbiI2BLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbiI2BLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:11:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECA66111D;
        Wed, 28 Sep 2022 18:11:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA0B4614A0;
        Thu, 29 Sep 2022 01:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BC3C433D6;
        Thu, 29 Sep 2022 01:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664413891;
        bh=EabPSgc8C5yja8ZsoDC2luPpU7hZ2Rp63ar05PSol4c=;
        h=From:To:Cc:Subject:Date:From;
        b=ZM1m+6eSoGoMPhdFApCWtDq3GYxZMIm5erwF+n3NaOkWW9HLM4xuzZFeb4Np0T23q
         /uOMDI9UR9OI8gmu4iaomTODiEhSuJXKB5J4ujE6XoEM98DXQSA0S57HF7JY9vRmhM
         9uBVLTyfeEb4Usghqd7AIM8/4HPzsZ/4ZTn0qxJWRN4zD1mubdyMobLnoMxcU0zhMd
         F5pHRMMAj12b74SqrF2YZ/GVn6K+1QW2fyWz/tx2e4bEalTzZfIgsoqj/5rj0ZB5RF
         hrcLHCKR06EXbXrASxbfHaB1Uh1pW93ljsoQqO2qM3fyM257m77ICnCwXkZnzXDvph
         e5RW9bXAtLKrg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        robh@kernel.org, johannes@sipsolutions.net, ecree.xilinx@gmail.com,
        stephen@networkplumber.org, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/6] Netlink protocol specs
Date:   Wed, 28 Sep 2022 18:11:16 -0700
Message-Id: <20220929011122.1139374-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

I think the Netlink proto specs are far along enough to merge.
Filling in all attribute types and quirks will be an ongoing
effort but we have enough to cover FOU so it's somewhat complete.

I fully intend to continue polishing the code but at the same
time I'd like to start helping others base their work on the
specs (e.g. DPLL) and need to start working on some new families
myself.

That's the progress / motivation for merging. The RFC [1] has more
of a high level blurb, plus I created a lot of documentation, I'm
not going to repeat it here. There was also the talk at LPC [2].

[1] https://lore.kernel.org/all/20220811022304.583300-1-kuba@kernel.org/
[2] https://youtu.be/9QkXIQXkaQk?t=2562

Jakub Kicinski (6):
  docs: add more netlink docs (incl. spec docs)
  netlink: add schemas for YAML specs
  net: add basic C code generators for Netlink
  netlink: add a proto specification for FOU
  net: fou: regenerate the uAPI from the spec
  net: fou: use policy and operation tables generated from the spec

 Documentation/core-api/index.rst              |    1 +
 Documentation/core-api/netlink.rst            |   99 +
 Documentation/netlink/genetlink-c.yaml        |  287 +++
 Documentation/netlink/genetlink-legacy.yaml   |  313 +++
 Documentation/netlink/genetlink.yaml          |  252 +++
 Documentation/netlink/specs/fou.yaml          |  128 ++
 .../userspace-api/netlink/c-code-gen.rst      |  104 +
 .../netlink/genetlink-legacy.rst              |   96 +
 Documentation/userspace-api/netlink/index.rst |    5 +
 Documentation/userspace-api/netlink/specs.rst |  410 ++++
 MAINTAINERS                                   |    3 +
 include/uapi/linux/fou.h                      |   54 +-
 net/ipv4/Makefile                             |    2 +-
 net/ipv4/fou-nl.c                             |   48 +
 net/ipv4/fou-nl.h                             |   25 +
 net/ipv4/fou.c                                |   51 +-
 tools/net/ynl/ynl-gen-c.py                    | 1998 +++++++++++++++++
 tools/net/ynl/ynl-regen.sh                    |   30 +
 18 files changed, 3835 insertions(+), 71 deletions(-)
 create mode 100644 Documentation/core-api/netlink.rst
 create mode 100644 Documentation/netlink/genetlink-c.yaml
 create mode 100644 Documentation/netlink/genetlink-legacy.yaml
 create mode 100644 Documentation/netlink/genetlink.yaml
 create mode 100644 Documentation/netlink/specs/fou.yaml
 create mode 100644 Documentation/userspace-api/netlink/c-code-gen.rst
 create mode 100644 Documentation/userspace-api/netlink/genetlink-legacy.rst
 create mode 100644 Documentation/userspace-api/netlink/specs.rst
 create mode 100644 net/ipv4/fou-nl.c
 create mode 100644 net/ipv4/fou-nl.h
 create mode 100755 tools/net/ynl/ynl-gen-c.py
 create mode 100755 tools/net/ynl/ynl-regen.sh

-- 
2.37.3

