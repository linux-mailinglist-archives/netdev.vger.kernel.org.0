Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A154F34CF1D
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbhC2Lb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhC2Lbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:31:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDBEC061574
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 04:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4lRvppfbCatue0pUQcAch4gdEffQ4JoiW/ML1NPhUDw=; b=foH0fTFgYRfbb/cVQVR8Ovrqam
        /KZjqF3lUagVIdHtQgKb90YbR4X56ol0iZWSYYR+vsIvmC+Hwvbu6VOMknNFebFxvYLyHgmDo53vW
        hNW03V2TPtlToYogvyy2gdIJKscSvyktW6mluGql+kP0xmP7GWILRthHvmFYtVFZt9BEkOM0H7iDp
        HG4SHBS3vdC5Xv4VplTPZUp9DuQT9SLPtxKjWeKliMAMed4ULJjgieEItn0AoYt8ejzgAHQW4nIsZ
        gaTNiKHzQK2C62jJC9PB5BQ4Z9QZEp3RcBE3iFq4VJ3UzR72wjuBg/zR1Q0boX6WMxKPoMRsOSUkE
        LgEkGy2A==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lQq6L-001TcA-Ai; Mon, 29 Mar 2021 11:30:49 +0000
Date:   Mon, 29 Mar 2021 12:30:33 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Network Development <netdev@vger.kernel.org>,
        Du Cheng <ducheng2@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH net-next] qrtr: move to staging
Message-ID: <20210329113033.GA351017@casper.infradead.org>
References: <20210328122621.2614283-1-gregkh@linuxfoundation.org>
 <CAMZdPi_3B9Bxg=7MudFq+RnhD10Mm5QbX_pBb5vyPsZAC_bNOQ@mail.gmail.com>
 <20210329105236.GB2763@work>
 <YGGz/BaibxykzxOW@kroah.com>
 <20210329110741.GC2763@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329110741.GC2763@work>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 04:37:41PM +0530, Manivannan Sadhasivam wrote:
> On Mon, Mar 29, 2021 at 01:03:24PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Mar 29, 2021 at 04:22:36PM +0530, Manivannan Sadhasivam wrote:
> > > Hi Greg,
> > > 
> > > On Mon, Mar 29, 2021 at 11:47:12AM +0200, Loic Poulain wrote:
> > > > Hi Greg,
> > > > 
> > > > On Sun, 28 Mar 2021 at 14:28, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > wrote:
> > > > 
> > > > > There does not seem to be any developers willing to maintain the
> > > > > net/qrtr/ code, so move it to drivers/staging/ so that it can be removed
> > > > > from the kernel tree entirely in a few kernel releases if no one steps
> > > > > up to maintain it.
> > > > >
> > > > > Reported-by: Matthew Wilcox <willy@infradead.org>
> > > > > Cc: Du Cheng <ducheng2@gmail.com>
> > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > >
> > > > 
> > > > As far as I know, QRTR/IPCR is still commonly used with Qualcomm-based
> > > > platforms for accessing various components of the SoC.
> > > > CCing Bjorn and Mani, In case they are interested in taking maintenance of
> > > > that.
> > > > 
> > > 
> > > As Loic said, QRTR is an integral component used in various Qualcomm based
> > > upstream supported products like ChromeOS, newer WLAN chipsets (QCA6390) etc...
> > > 
> > > It is unfortunate that no one stepped up so far to maintain it. After
> > > having an internal discussion, I decided to pitch in as a maintainer. I'll
> > > send the MAINTAINERS change to netdev list now.
> > 
> > Great, can you also fix up the reported problems with the codebase that
> > resulted in this "ask for removal"?
> > 
> 
> Yes, ofc. I do see couple of Syzbot bug reports now... I will look into them.
> It turned out I fixed one of them earlier but should've handled all :)

From my point of view, the important patch to get applied is this one:

https://lore.kernel.org/netdev/20200605120037.17427-1-willy@infradead.org/
