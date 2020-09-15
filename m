Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D5B269DB4
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 07:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgIOFNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 01:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgIOFNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 01:13:45 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D411C06174A;
        Mon, 14 Sep 2020 22:13:42 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mm21so1147157pjb.4;
        Mon, 14 Sep 2020 22:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yHkFrl3Bv6B6udCbLyaz9Af4oabGh1R3lkIWOhnNv0g=;
        b=ZWNyXnsbLfqzH3w9WKv2LKhpVULHRW2Txv3WiV7qjI6jIw9VVWj1mMWKmPuKLLUZ5p
         phHnhiIbSOy1/+I4h6vw1xC8Wb5PZ227bbpXqsWPQMd0c+aI+psliMJY4TvKvihxNeEg
         39xdUyuo1ac0woG+8AKKXMD5BrKJD4OLJZXkPGO6wKv3Sy0uq2szqnHPrYWnXWh6Fn6/
         GSm3oNbcR53fLjFOvNGgS3ee8pL3peP3lEiFTYjBX51NADHwH/FQvlxDlYKgyXZBSkh6
         kk/4DpHQeH+l8A7jaIW67QzBaBSUqSQ2DqmwWp4hE82tS8APStVQhQrpj6yFZcHs/2yB
         5VRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yHkFrl3Bv6B6udCbLyaz9Af4oabGh1R3lkIWOhnNv0g=;
        b=jksm30p3qJY6H2x9xPQswMPLDARq3KMFS1B26AgCClc+qsMNJvuTwnlb1HKl7ZrXG+
         W/bXE4wgZoPXlNaY2yiGL+1Y0EcnmUoxsi9ZOdiM9jq08G22vCr08rO2fC0TbId9hQou
         ZtAZ6IsE8ocIo5WPge6dnhE0naFc9YaNyiAPykbEELkxHuQpYL5HwNvvInJvozcWvF4T
         88bJiSwx49DJbg6cLbOS/b9H2QzZPTGRSVfio+cNaOV+zStg6dTxfA2BthPdEEIa9K22
         XRtP385h6nlpdjogAq+Qpb0liESAHxVPR2Tw/6a4wWhbaQZMPyQ1PXzKV7CkTCJbIVJ8
         5epA==
X-Gm-Message-State: AOAM530a411IIHhv3PTt3P6HYGdNThb1DJPoBi9YBLgpHcz3FlIpwZuX
        QvYPtWg02ICAv7AFs5BlIhI=
X-Google-Smtp-Source: ABdhPJzPRd+YYR2ntFr9sZ2/8C78t45z+RCD4rx7cSP8YZgRl1yztspa+/c0WJuhap130BHzqox0Yg==
X-Received: by 2002:a17:90a:738d:: with SMTP id j13mr2524443pjg.114.1600146821965;
        Mon, 14 Sep 2020 22:13:41 -0700 (PDT)
Received: from Thinkpad ([45.118.167.196])
        by smtp.gmail.com with ESMTPSA id m20sm12270590pfa.115.2020.09.14.22.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 22:13:41 -0700 (PDT)
Date:   Tue, 15 Sep 2020 10:43:31 +0530
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f7204dcf3df4bb4ce42c@syzkaller.appspotmail.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Necip Fazil Yildiran <necip@google.com>
Subject: Re: [Linux-kernel-mentees] [PATCH] idr: remove WARN_ON_ONCE() when
 trying to check id
Message-ID: <20200915051331.GA7980@Thinkpad>
References: <20200914071724.202365-1-anmol.karan123@gmail.com>
 <20200914110803.GL6583@casper.infradead.org>
 <20200914184755.GB213347@Thinkpad>
 <20200914192655.GW6583@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914192655.GW6583@casper.infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 08:26:55PM +0100, Matthew Wilcox wrote:
> On Tue, Sep 15, 2020 at 12:17:55AM +0530, Anmol Karn wrote:
> > On Mon, Sep 14, 2020 at 12:08:03PM +0100, Matthew Wilcox wrote:
> > > On Mon, Sep 14, 2020 at 12:47:24PM +0530, Anmol Karn wrote:
> > > > idr_get_next() gives WARN_ON_ONCE() when it gets (id > INT_MAX) true
> > > > and this happens when syzbot does fuzzing, and that warning is
> > > > expected, but WARN_ON_ONCE() is not required here and, cecking
> > > > the condition and returning NULL value would be suffice.
> > > > 
> > > > Reference: commit b9959c7a347 ("filldir[64]: remove WARN_ON_ONCE() for bad directory entries")
> > > > Reported-and-tested-by: syzbot+f7204dcf3df4bb4ce42c@syzkaller.appspotmail.com
> > > > Link: https://syzkaller.appspot.com/bug?extid=f7204dcf3df4bb4ce42c 
> > > > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > > 
> > > https://lore.kernel.org/netdev/20200605120037.17427-1-willy@infradead.org/
> > 
> > Hello sir,
> > 
> > I have looked into the patch, and it seems the problem is fixed to the root cause
> > in this patch, but not yet merged due to some backport issues, so, please ignore 
> > this patch(sent by me), and please let me know if i can contribute to fixing this 
> > bug's root cause.
> 
> The root cause is that the network maintainers believe I have a far
> greater interest in the qrtr code than I actually do, and the maintainer
> of the qrtr code is not doing anything.

Hello sir,

I hope the patch will get merged soon.

also, i have tried a patch for this bug

Link: https://syzkaller.appspot.com/bug?extid=3b14b2ed9b3d06dcaa07

can you please guide me little how should i proceede with it, and 
also syzbot tested it.  


Thanks,
Anmol
