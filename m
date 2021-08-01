Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FC43DCD47
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 21:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhHATf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 15:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhHATf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 15:35:27 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CBCC06175F;
        Sun,  1 Aug 2021 12:35:18 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id z2so29766557lft.1;
        Sun, 01 Aug 2021 12:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mAbYsU4RPaV/8B8ZdAc5/2u4OFxmje95un7poA9waH4=;
        b=i/TdiNJZXQYNOJ2eze2Awe3TxtRG6IWfVMgkW0vwPXWLrXSJhgrtX9m4H5E/zs0z9b
         ra97Fsa8aJU92b0fDjTi9t0GehvsyKdnxar7b+P40DD1lwpt0Jb+Rp1bFsDC0FAwcQoL
         wtoIfumwjk6p1TTc+xZrNqhs5wmFCi9+iPU1e22724Me3kiedCVhGHSLSOCio4hVNkPv
         WBnyc/sPuSoSPzLzsLYUSSvjZPMp4pv8ULos3W/o6fWxEi4nW70nUBKab5rMrtb362g/
         JwyLCAnBN9sL1xe5a7I3W0WccfihW9yV+HF5fwsMtU3iB+BC1baI3j4t7ob2hsWJanzr
         kB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mAbYsU4RPaV/8B8ZdAc5/2u4OFxmje95un7poA9waH4=;
        b=EjfBbfoivYQhNLLmKrwoup8oaexve6JaZJcxKxau6pkblzcHK6h9btwmCV6qMe7eSX
         CXv3iPtOKqI4vwcl3fXlFd/hBEz/VNAD4KPEyM8t/ntBXNQc89jSC9c83I4oMRKI/lNp
         ZVZZA2ucfoZkUN9Zj+LOVNEu2F1U7E34f8yi+B/b+5uYgMj+K1dSmTyal3bnvzhYtXy/
         PxWKBX2xejG8b4X8mmHi/gUunHFlnmEt73/GCjru08GeR+6EFPNRVgwiNywqLtSmregY
         HPBuP7WFw3BASyQ9Uux3A5D29fwLTuXqWJhhA78LOKzbVwM46DXWbJHldsYFM6xnzHuG
         vfHg==
X-Gm-Message-State: AOAM531X4PRmFaSskRqRE8d0DDwrDfZL3TnGxTY3Oe0u48ilHaqAbg15
        1EfmlfaJ30TQwc/oj9RgiY4=
X-Google-Smtp-Source: ABdhPJz56fImZkjgw7zEFTCzmrviyChKKvYj94gbU5Htb5MvXsIVLYrherV22wNlonbWvgWtTUTeVw==
X-Received: by 2002:a05:6512:314e:: with SMTP id s14mr9913562lfi.595.1627846516825;
        Sun, 01 Aug 2021 12:35:16 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id p22sm743442lfo.195.2021.08.01.12.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Aug 2021 12:35:16 -0700 (PDT)
Date:   Sun, 1 Aug 2021 22:35:13 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Petko Manolov <petkan@nucleusys.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: pegasus: fix uninit-value in
 get_interrupt_interval
Message-ID: <20210801223513.06bede26@gmail.com>
In-Reply-To: <YQaVS5UwG6RFsL4t@carbon>
References: <20210730214411.1973-1-paskripkin@gmail.com>
        <YQaVS5UwG6RFsL4t@carbon>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Aug 2021 15:36:27 +0300
Petko Manolov <petkan@nucleusys.com> wrote:

> On 21-07-31 00:44:11, Pavel Skripkin wrote:
> > Syzbot reported uninit value pegasus_probe(). The problem was in
> > missing error handling.
> > 
> > get_interrupt_interval() internally calls read_eprom_word() which
> > can fail in some cases. For example: failed to receive usb control
> > message. These cases should be handled to prevent uninit value bug,
> > since read_eprom_word() will not initialize passed stack variable
> > in case of internal failure.
> 
> Well, this is most definitelly a bug.
> 
> ACK!
> 
> 
> 		Petko
> 
> 

Thank you, Petko!


BTW: I found a lot uses of {get,set}_registers without error
checking. I think, some of them could be fixed easily (like in
enable_eprom_write), but, I guess, disable_eprom_write is not so easy.
For example, if we cannot disable eprom should we retry? If not, will
device get in some unexpected state?

Im not familiar with this device, but I can prepare a patch to wrap all
these calls with proper error checking



With regards,
Pavel Skripkin


