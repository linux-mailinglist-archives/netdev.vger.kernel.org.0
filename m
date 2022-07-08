Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5166956B8BC
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 13:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237945AbiGHLlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 07:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237623AbiGHLlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 07:41:08 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5647226104
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 04:41:06 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 02AF3C01A; Fri,  8 Jul 2022 13:41:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657280465; bh=CESzf00bqxk8zPwTMZ8J7GXH4+tR1d5gAM6n61EMPow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rTrzggeWnPYhCRVhdtYvy5iyWdgip05jelmVydBomV52Pcl/qePVSZrObhJjsh98C
         J3U7ecf8yyjI+gW0JKUWKsSufIqqZEHdgoswBXTkQDIZLJhUZ5DmKpiS8E1zavBCcP
         6dk8q8YVV9/8uV1JswBHNFCMGncUOAn3Hy+YhNWX2HKt4tSVkICTSCfCuqlZAvUNuJ
         jv/XZh1lS0OmPkyHnlUywmoLRlPMnHaZyZwx33P8UX5IP7FFkE99rHZ4Ba/zDJHX5J
         2vnTnZf1LXDcVYnkqZ8bzLBeYQ7MR/+a86aU2E5mzg7ZI+IzG9oI+VDlYB6EQifnw4
         j4NKEnpBfTEVQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id CF790C009;
        Fri,  8 Jul 2022 13:40:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657280456; bh=CESzf00bqxk8zPwTMZ8J7GXH4+tR1d5gAM6n61EMPow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l2pe+aFn0nIRfP/yrcn4rqTxdifWA3zG6w66vXl0gQu3DYC8un2P/4BBMMmujG/SS
         nJLtcVTxJ+fukYNDxXpY0vcHsq/Os6QKmz11uZHjiTQjiG7H9mD8F3aTbIV+4wmPbv
         7SPaQep3zKLkBAr6gLHdqRCKT5IanYQau1vh4FA9AeHRq0GTCFehUUGYGmHatUIu43
         b4hwTIjwud9ldg+GDOz2REbGpLx8IE/DndZivvjl0h1qSCEB4hqLFKncHg9YQgNubT
         ts1PV0Oy3lOm115uUl5bq8k2yWNIdTlYBuNBlqpf0oq0XiAiS80xpKXa3/0kP8Rh2Z
         n/0Z31pWVcZPQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id f9afc261;
        Fri, 8 Jul 2022 11:40:51 +0000 (UTC)
Date:   Fri, 8 Jul 2022 20:40:36 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>, Greg Kurz <groug@kaod.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
Message-ID: <YsgXtBsfLEQ9dFux@codewreck.org>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
 <YseFPgFoLpjOGq40@codewreck.org>
 <CAFkjPTngeFh=0mPVW-Yf1Sxkxp_HDNUeANndoYN3-eU9_rGLuQ@mail.gmail.com>
 <1690835.L3irNgtgWz@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1690835.L3irNgtgWz@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Fri, Jul 08, 2022 at 01:18:40PM +0200:
> On Freitag, 8. Juli 2022 04:26:40 CEST Eric Van Hensbergen wrote:
> > kvmtool might be the easiest I guess - I’m traveling right now but I can
> > try and find some others.  The arm fast models have free versions that are
> > downloadable as well.  I know I’ve seem some other less-traditional uses of
> > virtio particularly in libos deployments but will take some time to rattle
> > those from my memory.
> 
> Some examples would indeed be useful, thanks!

https://github.com/kvmtool/kvmtool indeed has a 9p server, I think I
used to run it ages ago.
I'll give it a fresh spin, thanks for the reminder.

For this one it defines VIRTQUEUE_NUM to 128, so not quite 1024.


> > > I found https://github.com/moby/hyperkit for OSX but that doesn't really
> > > help me, and can't see much else relevant in a quick search
> 
> So that appears to be a 9p (@virtio-PCI) client for xhyve,

oh the 9p part is client code?
the readme says it's a server:
"It includes a complete hypervisor, based on xhyve/bhyve"
but I can't run it anyway, so I didn't check very hard.

> with max. 256kB buffers <=> max. 68 virtio descriptors (memory segments) [1]:

huh...

Well, as long as msize is set I assume it'll work out anyway? How does
virtio queue size work with e.g. parallel messages?

Anyway, even if the negotiation part gets done servers won't all get
implemented in a day, so we need to think of other servers a bit..

--
Dominique
