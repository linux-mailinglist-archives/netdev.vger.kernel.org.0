Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9115459A78
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 04:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbhKWDcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 22:32:07 -0500
Received: from nautica.notk.org ([91.121.71.147]:56638 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229955AbhKWDcG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 22:32:06 -0500
Received: by nautica.notk.org (Postfix, from userid 108)
        id 651E7C01E; Tue, 23 Nov 2021 04:28:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1637638138; bh=q6rotOzdOtlyoSSsUgpQiMgUypI/OA4jyZNRndcqOFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LzwLmfRR+FLWwpc9kIFsfid0CAXMwFnDCQIqt4mt1Rq3g2vpKyq+8duspxhU6QnJ9
         Z1ZNeiRmltUyMVn16G8HAa3KmHfxmUXEUCoPx/lBqTIviOy2pZN6s5rilTmXUKeIGS
         E5DQCEURbsVCIuO8KpR9KVyMEgbGieE92hgWlncbtr0vNKts5QEGYpt/hoIYl5m5HD
         Jeu1qnavC3+KtuDj/Ca3gxyaAO0iFDNl1HpRyusrMrP3zSWVIyrSopCPbc95Sh1Wea
         yNZUcUCEw0QmqvTKsZkgFx4C3ARCrz6p6aQhmcVRWYj1eOULfQPfUboop8tqkh7tOW
         mcRS76pn+dfTA==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 4A359C009;
        Tue, 23 Nov 2021 04:28:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1637638137; bh=q6rotOzdOtlyoSSsUgpQiMgUypI/OA4jyZNRndcqOFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PCR2WFEZ1VR/2VKYJwZ6+70x9UHPJMuQbnrMZrSnt0gDmktO7l7PiJTH8UPwrx6L7
         qCZC0PCyr/oWk6J52X1gG80JRDwl1bLb/ll3pL0SdNpHxuAwSL0z0z14Dm6H+R6HeO
         bkCPcpNX6//JsfjHUmityk7hit4ONvRxiRJPr4JXjXmbbIObo2Yu3dRGjVaVQ6I6tR
         8YYOf3WWH5p58SDjJi5tEA+qAjfz2okDBlHDHvXJ3TTiN5A83UB79i4u+u1Vy6Rfox
         Mnf1tr65KJxULi3h7O1zFkKDa9NyNyvjHQO8xTep0PHRzPwGHWlXHy2S1cBzSR/5Ow
         HylfqYTARShYQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 797d049c;
        Mon, 22 Nov 2021 22:35:33 +0000 (UTC)
Date:   Tue, 23 Nov 2021 07:35:18 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Nikolay Kichukov <nikolay@oldum.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 6/7] 9p/trans_virtio: support larger msize values
Message-ID: <YZwbJiFcLgwITsUe@codewreck.org>
References: <YZl+eD6r0iIGzS43@codewreck.org>
 <4244024.q9Xco3kuGk@silver>
 <YZrEPj9WLx36Pm3k@codewreck.org>
 <1797352.eH9cFvQebf@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1797352.eH9cFvQebf@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Mon, Nov 22, 2021 at 02:32:23PM +0100:
> I "think" this could be used for all 9p message types except for the listed 
> former three, but I'll review the 9p specs more carefully before v4. For Tread 
> and Twrite we already received the requested size, which just leaves Treaddir, 
> which is however indeed tricky, because I don't think we have any info how 
> many directory entries we could expect.

count in Treaddir is a number of bytes, not a number of entries -- so
it's perfect for this as well :)

> A simple compile time constant (e.g. one macro) could be used instead of this 
> function. If you prefer a constant instead, I could go for it in v4 of course. 
> For this 9p client I would recommend a function though, simply because this 
> code has already seen some authors come and go over the years, so it might be 
> worth the redundant code for future safety. But I'll adapt to what others 
> think.

In this case a fallback constant seems simpler than a big switch like
you've done, but honestly I'm not fussy at this point -- if you work on
this you have the right to decide this kind of things in my opinion.

My worry with the snippet you listed is that you need to enumerate all
calls again, so if someday the protocol is extended it'll be a place to
forget adding new calls (although compiler warnings help with that),
whereas a fallback constant will always work as long as it's small
messages.

But really, as long as it's not horrible I'll take it :)

-- 
Dominique
