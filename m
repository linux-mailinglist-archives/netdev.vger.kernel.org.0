Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545F732CAAB
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 04:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhCDDCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 22:02:22 -0500
Received: from nautica.notk.org ([91.121.71.147]:50898 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232113AbhCDDCG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 22:02:06 -0500
X-Greylist: delayed 166961 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2021 22:02:05 EST
Received: by nautica.notk.org (Postfix, from userid 108)
        id 02BF0C020; Thu,  4 Mar 2021 04:01:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1614826884; bh=5F7Z8p6mZsz3CvMl+8iJUXJXZOmn2B81gRz2UN5/6v0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yykxb+BSKnII9f2bQitmnPBKTpaugho7q80WToHdviyQjTExF6RiKrnTChRe+4K5r
         ub+LVSQGM2H9bj0WYCGDqQUoaS44HoPhPs5t5ZlC7JF+L9K5oGoOGe7OXSN64a1oGY
         5JbkmmClP1uT4Zyecl5gG/X8NokPAV3eiRUIhyGxENlkU1kK/GSp1vtnpR5RX7X12N
         I90XRfNFwItDUPk25GQkoGwKIN5bszpjRE2tS0FhsEWHbh8FxGQvWbB2w6JGbdYbfX
         YosteMEhC012WGkzHWTqNAg6qA4Fb+r17GY6AYN5mkbE7IeetAr7IH4m0qwgD0smdK
         YovYPZnv8YCoA==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 1936CC01B;
        Thu,  4 Mar 2021 04:01:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1614826883; bh=5F7Z8p6mZsz3CvMl+8iJUXJXZOmn2B81gRz2UN5/6v0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lqgbDHyu5B2kFuEFvDsEwHmrwLGDI0ZTAMyOUJEqsy7GMHO2Wv83xF/EXUvt242K/
         lI4gQyAdbuKMqbhQC9tNOCApUMhZjrlqTkCgVQTUm3V9o3bS6FkQDBiG7Yi4EkMOiL
         8mJet03MZv3adjHukzkTVbFOAJUDcMLwGhypIhiSjY4iZpZxacWYDHJPdK5zZcfXnG
         mQxK5JHQGYEX8tu4aP95z+Pd6pOfaA7Zxepz7BVVssrCqTQKVmNpIuJ7W3neG47KBk
         0ZKG2hy6KqEWewRw5H2vQPYn0l4d3uGc83KCeCdOUfZY/qK/oEeeloyEm4W6H+jY4B
         qMZkPY9ykEZyw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id c794a0c4;
        Thu, 4 Mar 2021 03:01:18 +0000 (UTC)
Date:   Thu, 4 Mar 2021 12:01:03 +0900
From:   asmadeus@codewreck.org
To:     davem@davemloft.net
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>, ericvh@gmail.com,
        lucho@ionkov.net, kuba@kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: 9p: advance iov on empty read
Message-ID: <YEBNb6MnQa7zRApd@codewreck.org>
References: <20210302171932.28e86231@xhacker.debian>
 <161482020724.32353.3785422808049340949.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <161482020724.32353.3785422808049340949.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


patchwork-bot+netdevbpf@kernel.org wrote on Thu, Mar 04, 2021 at 01:10:07AM +0000:
> This patch was applied to netdev/net.git

thanks for taking the patch, I didn't take the time to reply yesterday
after my bisect finally finished.

I've got the culprit now, could you add the following?

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
(or reviewed-by/tested-by, or just leave it out I'm not fussy)
Fixes: cf03f316ad20 ("fs: 9p: add generic splice_read file operations")
Cc: stable@vger.kernel.org # v5.11


Cheers,
-- 
Dominique
