Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02FE488C85
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 22:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbiAIVUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 16:20:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59782 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiAIVUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 16:20:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F79560C2C;
        Sun,  9 Jan 2022 21:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CE9C36AE5;
        Sun,  9 Jan 2022 21:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641763239;
        bh=Fw2ZSnJI+rXcbS3/Wr8CkxNQc+pIPx3R0OoQAJv5CKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vMDxasgGDQX9VRoEWtBcWot2wz6pn1WUdGACygWjueohayCZgI+l/VqAXsgJtpWqc
         4uGtj1bRE353ezc1F2Vf1AuuVcEN4hZD7Zw0m8oeJ8Hm5RvN+nmwqkUfzj2qas2UK/
         xmjjf7nl2T82f486Au7vHM495NzUbCdqE6zN4ZwqHSRm7ZzB5xbl0g0uhwAzT31Wck
         Aixk5ebxOBPAbHgNPgUaesJBUoPoG4/180ymssz8yUn2xgY02JjC8ct7vZE1kGCA8F
         fbzu3/d8Ed9pYDTCNsC8SZgGd5+NmYo8EblTJnL/23XcwjIHstXRMD2Qyoooq8Im2y
         +IZC9bdCSsIFA==
Date:   Sun, 9 Jan 2022 13:20:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Rao Shoaib <rao.shoaib@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>,
        regressions@lists.linux.dev
Subject: Re: Observation of a memory leak with commit 314001f0bf92
 ("af_unix: Add OOB support")
Message-ID: <20220109132038.38f8ae4f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAKXUXMzZkQvHJ35nwVhcJe+DrtEXGw+eKGVD04=xRJkVUC2sPA@mail.gmail.com>
References: <CAKXUXMzZkQvHJ35nwVhcJe+DrtEXGw+eKGVD04=xRJkVUC2sPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jan 2022 07:48:46 +0100 Lukas Bulwahn wrote:
> Dear Rao and David,
> 
> 
> In our syzkaller instance running on linux-next,
> https://elisa-builder-00.iol.unh.edu/syzkaller-next/, we have been
> observing a memory leak in prepare_creds,
> https://elisa-builder-00.iol.unh.edu/syzkaller-next/report?id=1dcac8539d69ad9eb94ab2c8c0d99c11a0b516a3,
> for quite some time.
> 
> It is reproducible on v5.15-rc1, v5.15, v5.16-rc8 and next-20220104.
> So, it is in mainline, was released and has not been fixed in
> linux-next yet.
> 
> As syzkaller also provides a reproducer, we bisected this memory leak
> to be introduced with  commit 314001f0bf92 ("af_unix: Add OOB
> support").
> 
> We also tested that reverting this commit on torvalds' current tree
> made the memory leak with the reproducer go away.
> 
> Could you please have a look how your commit introduces this memory
> leak? We will gladly support testing your fix in case help is needed.

Let's test the regression/bug report tracking bot :)

#regzbot introduced: 314001f0bf92
