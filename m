Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E462695A0
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 21:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgINT1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 15:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgINT1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 15:27:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D413C06174A;
        Mon, 14 Sep 2020 12:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ElivZyaPzL8sTWfizym2+Owr1Ypn3yVUWdClnfRy/rE=; b=uCnI10CpbKyLkMZsRbCBF8NO8I
        E0yhU73bDJ+60I30Oz519RlDzCfRHrFUhKPMZve1jMRdXNNATwE4LrhysZFcnCpm6h7sB29Veomcx
        asEg1ycd3JxU9n64NMwptG2j9hrxUDUvfm1kDx8EM9i4ps7ZMziPmHbhSFji8qmWxOzmbw351PhxO
        VGKkvuAwTmqfPnVWqf7ySl5Z7rlPMGqJBYTrs6V1EbEgvhSbX4zTqwTYdOOX67arGecaoWCbDekkp
        JdhCKFTeEt7oCGR7nAZF+V+Q+eq5F8Ogj7FnRXq9YDFCCDeK/3f2UFfhxU4/b5IjD7cCCYotzFC8q
        RHNnIO1A==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHu7r-0004CT-Sp; Mon, 14 Sep 2020 19:26:55 +0000
Date:   Mon, 14 Sep 2020 20:26:55 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Anmol Karn <anmol.karan123@gmail.com>
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
Message-ID: <20200914192655.GW6583@casper.infradead.org>
References: <20200914071724.202365-1-anmol.karan123@gmail.com>
 <20200914110803.GL6583@casper.infradead.org>
 <20200914184755.GB213347@Thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914184755.GB213347@Thinkpad>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 12:17:55AM +0530, Anmol Karn wrote:
> On Mon, Sep 14, 2020 at 12:08:03PM +0100, Matthew Wilcox wrote:
> > On Mon, Sep 14, 2020 at 12:47:24PM +0530, Anmol Karn wrote:
> > > idr_get_next() gives WARN_ON_ONCE() when it gets (id > INT_MAX) true
> > > and this happens when syzbot does fuzzing, and that warning is
> > > expected, but WARN_ON_ONCE() is not required here and, cecking
> > > the condition and returning NULL value would be suffice.
> > > 
> > > Reference: commit b9959c7a347 ("filldir[64]: remove WARN_ON_ONCE() for bad directory entries")
> > > Reported-and-tested-by: syzbot+f7204dcf3df4bb4ce42c@syzkaller.appspotmail.com
> > > Link: https://syzkaller.appspot.com/bug?extid=f7204dcf3df4bb4ce42c 
> > > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > 
> > https://lore.kernel.org/netdev/20200605120037.17427-1-willy@infradead.org/
> 
> Hello sir,
> 
> I have looked into the patch, and it seems the problem is fixed to the root cause
> in this patch, but not yet merged due to some backport issues, so, please ignore 
> this patch(sent by me), and please let me know if i can contribute to fixing this 
> bug's root cause.

The root cause is that the network maintainers believe I have a far
greater interest in the qrtr code than I actually do, and the maintainer
of the qrtr code is not doing anything.
