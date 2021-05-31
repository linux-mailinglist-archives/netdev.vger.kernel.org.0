Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D332B3953F8
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 04:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhEaCoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 22:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhEaCoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 22:44:20 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D00C061574
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 19:42:40 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id x10so3557646plg.3
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 19:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nSSyopAtkodXam0rk9bPy9dMoXqKVHlq6okLtwZw0Ko=;
        b=VhnGr1hnnxURoldGBuaG627dwczbinEqsmNgavaj5a3T50KqHg27UtpM6+al41teks
         KMUBN7/EqC5gSCy55ReAnH+4XMmY67r5hlEXr4Kn1K42fNW5gdhND42K7sxhipFW8wal
         JFw7XepdheyPhg35JjoXzab/yhvL/VFW0x8Nip7ntLToaDoCFwDw7exhDaHm0XXDFKlQ
         2Ozlu9lTjzHoHZgYoXfN5xVhM90Sc85oixvwoKDZz5PtPS87Gu63I83Rl3tJNZfgAppC
         1Fi/UuSBwxDSfR6TxdFnAgGseP31an1dFA+W/LldpWUUG7Z7dLy2jtYz70LWNNv+NjdM
         +yDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nSSyopAtkodXam0rk9bPy9dMoXqKVHlq6okLtwZw0Ko=;
        b=p+2PY3D2qCaCKWng/TXewpGKiPQiyGVagz09VROyyVjPIJ8YmgySNQjYxx+iPKO+Qq
         ZneFp4Ob49lqrvhDV9xqxin9fvt+FDqpCUVqQTKhxHqSSdhvJcdv6no1OkjU1MjFomtG
         0kRGCdcD0C+S6ds/WgWKt1cTpgJpZpY4imrrxQjkHiHT1ZZPLxoiIU/Mx1B/RKDkEC5Z
         zWmSypMH/+xegE5u22SVjx079CIPtatjxga4zg3WfQNgzt/q5fuiBNhtdO0/Pb0crGfp
         xsZ/dyPeRrLwnn3yPb66wUsNo1SZXeHVcO0bws1p+CWr6zi680gB0A++WQre6iduOlnK
         cEsg==
X-Gm-Message-State: AOAM532H3bNiVAewLXM8OJue6CqIz6ckFdeq6c8aDaiP2WKCNW852ERl
        6hVqSlQuaB6WeVtFFM0RFZTu2A==
X-Google-Smtp-Source: ABdhPJzF45oicpEILtAMZcOUpf2b1haXW7u9IJl6+y4tlW5sNxjuc6gnffkqsFOS2//pGv6h/GVlVA==
X-Received: by 2002:a17:902:e812:b029:ee:ff2f:da28 with SMTP id u18-20020a170902e812b02900eeff2fda28mr18153025plg.15.1622428959880;
        Sun, 30 May 2021 19:42:39 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id i14sm9354564pfk.130.2021.05.30.19.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 19:42:39 -0700 (PDT)
Date:   Sun, 30 May 2021 19:42:34 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hongren Zheng <i@zenithal.me>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [RFC] add extack errors for iptoken
Message-ID: <20210530194234.2fd8b269@hermes.local>
In-Reply-To: <YLHf3ETTHj6uaY9Y@Sun>
References: <YF80x4bBaXpS4s/W@Sun>
 <20210331204902.78d87b40@hermes.local>
 <YIlbLP5PpaKrE0P2@Sun>
 <YLHf3ETTHj6uaY9Y@Sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 May 2021 14:31:56 +0800
Hongren Zheng <i@zenithal.me> wrote:

> On Wed, Apr 28, 2021 at 08:55:08PM +0800, Hongren Zheng wrote:
> > > Perhaps the following (NOT TESTED) kernel patch will show you how such error messages
> > > could be added.  
> > 
> > Since this patch has been tested, and we have waited a long time for
> > comments and there is no further response, I wonder if it is the time
> > to submit this patch to the kernel.  
> 
> Is there any updates?
> 
> I'm not quite familiar with "RFC" procedure. Should I send this patch to
> netdev mailing list with title "[PATCH] add extack errors for iptoken" now
> (I suppose not), or wait for Stephen Hemminger sending it, or wait for
> more comments?
> 

The kernel changes is already upstream with this commit for 5.12 kernel

commit 3583a4e8d77d44697a21437227dd53fc6e7b2cb5
Author: Stephen Hemminger <stephen@networkplumber.org>
Date:   Wed Apr 7 08:59:12 2021 -0700

    ipv6: report errors for iftoken via netlink extack
    
    Setting iftoken can fail for several different reasons but there
    and there was no report to user as to the cause. Add netlink
    extended errors to the processing of the request.
    
    This requires adding additional argument through rtnl_af_ops
    set_link_af callback.
    
    Reported-by: Hongren Zheng <li@zenithal.me>
    Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
    Reviewed-by: David Ahern <dsahern@kernel.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>
