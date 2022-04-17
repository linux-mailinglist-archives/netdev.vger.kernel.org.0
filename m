Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB1B5047F1
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 15:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbiDQNzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 09:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiDQNzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 09:55:37 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539D31EC77;
        Sun, 17 Apr 2022 06:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=PcP8dW0ioRzK0xPAKsYs093XS1ccwWxt22yQcI8gb10=; b=UWKQqpDU3c4xffoQchHhHqWtTF
        AXEk2xZp4BYO03KZEIoakG2oH9LcFksrrtvo5mbOSpkTWvoMCs5t/1G05OFZ45P7BqjydMR4cYhCC
        zN3SN8pe2rSsuGhMsiDHjJYv1/XrcKY24JgXuxd6jaglkBHWFybMIz+L2401kVVI10xW//dLag9eR
        jmgfJzCceE51uVsXGGW0usZGkUTbbcYgdpzrumtA+T8w+V1TLC8cYsvgl8PDd3XpBZe6c8xFrk0Nl
        2TV88rnxIMNzYLhRd3210SF2S21iWvoXPiwEotk9g7GHoXmvuaVCBrpR7C7mwX3cMUBkl+1nJB/4/
        gHIImD9PpNYzq5Hdfu0N7+BtSqbUhDzB2jgQaADaRupzo/m8HnOoP/hXViKBhZOguXEzU62MVkiiX
        9gcIGr+RkgSOR5KHhu4kk0OsDpBSuxqxrRxWnlKDRoAeLqIWussDZWLy/aTa7LPT9RrKmpBffKhTo
        +hBbZ02RmAjsVbTteL0SMzl5egXD1ObNErtMI2kBcyi8OR7KNHZVcyv9DIF8raE2C9LgZSqc0GWRb
        I4wqMu+OwMUqiONlMkvZTVys3X3V7gPj8t01J8KPH0Y/lBOnHcNaahlsV4xL8zNM+CSfCWQ+JfGfX
        AAdigAYdjiUeO5OtDSSLx4x3Q97c1cYevUPjJxrC0=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>, Greg Kurz <groug@kaod.org>
Subject: Re: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie detected)
Date:   Sun, 17 Apr 2022 15:52:43 +0200
Message-ID: <8420857.9FB56xACZ5@silver>
In-Reply-To: <YlwOdqVCBZKFTIfC@codewreck.org>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <2551609.RCmPuZc3Qn@silver> <YlwOdqVCBZKFTIfC@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sonntag, 17. April 2022 14:56:22 CEST asmadeus@codewreck.org wrote:
> Christian Schoenebeck wrote on Thu, Apr 14, 2022 at 02:44:53PM +0200:
> > > Yes, I'm not sure why I can't reproduce... All my computers are pretty
> > > slow but the conditions should be met.
> > > I'll try again with a command line closer to what you just gave here.
> > 
> > I'm not surprised that you could not reproduce the EBADF errors yet. To
> > make this more clear, as for the git client errors: I have like 200+ git
> > repositories checked out on that test VM, and only about 5 of them
> > trigger EBADF errors on 'git pull'. But those few repositories reproduce
> > the EBADF errors reliably here.
> > 
> > In other words: these EBADF errors only seem to trigger under certain
> > circumstances, so it requires quite a bunch of test material to get a
> > reproducer.
> > 
> > Like I said though, with the Bullseye installation I immediately get EBADF
> > errors already when booting, whereas with a Buster VM it boots without
> > errors.
> Okay, I had missed that!
> 
> I've managed to reproduce with git:
> https://gaia.codewreck.org/local/tmp/c.tar.zst
> 
> This archive (~300KB) when decompressed is a ~150MB repo where git reset
> produces EBADF reliably for me.

I'm glad you were able to reproduce these EBADF errors!

> From the looks of it, write fails in v9fs_write_begin, which itself
> fails because it tries to read first on a file that was open with
> O_WRONLY|O_CREAT|O_APPEND.
> Since this is an append the read is necessary to populate the local page
> cache when writing, and we're careful that the writeback fid is open in
> write, but not about read...
> 
> Will have to think how we might want to handle this; perhaps just giving
> the writeback fid read rights all the time as well...
> Ran out of time for tonight, but hopefully we can sort it out soonish now!

I fear that would just trade symptoms: There are use cases for write-only 
permissions, which would then fail after such kind of simple change.

Independent of this EBADF issue, it would be good to know why 9p performance 
got so slow with cache=loose by the netfs changes. Maybe David has an idea?

Best regards,
Christian Schoenebeck


