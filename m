Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306816CABD4
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbjC0R1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjC0R1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:27:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665374229;
        Mon, 27 Mar 2023 10:26:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CB9CDCE18F5;
        Mon, 27 Mar 2023 17:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34C7C433EF;
        Mon, 27 Mar 2023 17:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679938011;
        bh=ofpr8LvHjegum9DXiaI8m5me7aU3KrZdWE8e+usLlEU=;
        h=From:To:Cc:Subject:Date:From;
        b=iTX/Drm8Xj3IgWIn9rXb+4McbMynUvuj7HmgrDVy4CaGMXddjqaW3m6vPxOOYkrfm
         djbAZ8bYiZvlKiNxg5xMa60BAhQXFU/T/SUcCu8fq0rWj1sqbOKmF6GDJbr5Ubw6hn
         5nZywhHsYDRyg87t4Q1wEPuC6UjEIMjIEkNXgFx9c642/HLwyOxZNekMFCL7oajFt6
         OVmyPtkUfXX3/na8oO8KDjNE+oO/6ljiVLKVsY/61nEhoZmrDaTw2Y09Z8WCuD6XmY
         l9QxiwbVtaF6xFEQY6BXEy3JVYjubgakAsQ84f0/NVZRSQ+9gq2x3Fy+2fGnCjtwqT
         PHp80mzkNcJFA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, corbet@lwn.net,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next] docs: netdev: clarify the need to sending reverts as patches
Date:   Mon, 27 Mar 2023 10:26:46 -0700
Message-Id: <20230327172646.2622943-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't state explicitly that reverts need to be submitted
as a patch. It occasionally comes up.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: corbet@lwn.net
CC: linux-doc@vger.kernel.org
---
 Documentation/process/maintainer-netdev.rst | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
index e31d7a951073..f6983563ff06 100644
--- a/Documentation/process/maintainer-netdev.rst
+++ b/Documentation/process/maintainer-netdev.rst
@@ -184,11 +184,18 @@ Handling misapplied patches
 
 Occasionally a patch series gets applied before receiving critical feedback,
 or the wrong version of a series gets applied.
-There is no revert possible, once it is pushed out, it stays like that.
+
+Making the patch disappear once it is pushed out is not possible, the commit
+history in netdev trees is stable.
 Please send incremental versions on top of what has been merged in order to fix
 the patches the way they would look like if your latest patch series was to be
 merged.
 
+In cases where full revert is needed the revert has to be submitted
+as a patch to the list with a commit message explaining the technical
+problems with the reverted commit. Reverts should be used as a last resort,
+when original change is completely wrong; incremental fixes are preferred.
+
 Stable tree
 ~~~~~~~~~~~
 
-- 
2.39.2

