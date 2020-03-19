Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A0418AD7B
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 08:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgCSHqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 03:46:39 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59709 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbgCSHqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 03:46:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B74C15C01EA;
        Thu, 19 Mar 2020 03:46:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 19 Mar 2020 03:46:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=f5rFjbDiH3kcnIpvJKnrExFwLrT
        thw0CoS09zAxpBd8=; b=Y9WmBzCwdRvXXIZC03nlFw+7z+iDs5rr8un9cqk1i2Q
        1Phkpc1ApRbSu4gQew0s4cwQ0ASuIJRqWodxUyqNWvaQTEmepSijmH5i1IjZUga1
        ICj/YMG4IL7qh4BKBkHY+RRpbzkLS75myixaaTeTuZfrFwuDMDD7u8YaxH+SZvmC
        TCwhDlaT76HtB7Bkm/xLzmO+euzw37YOGOwr4hvHEvLGGtI+Ag1k7ZAqXq++K9OT
        WPmluPXLcL5HFFtMmYBjJ2s+h4LtdDtLirguxZouzmCJ5Vz9zQyz+vmgOx/7s6DH
        +cqzUuj/93zrtSqJoQQja5idr7+Jr+nU1xhGtQinDww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=f5rFjb
        DiH3kcnIpvJKnrExFwLrTthw0CoS09zAxpBd8=; b=RBV6nW+f++25Letgc5eNXV
        xmhajnZQUnMaTeXrDR1WDLsvGjxeVNcmbHwkD2VSHzQXavHFgriWD+7y88TuM/K4
        +NXKuUpBh4v7G483Cu0LPv3F13CmnDPmiYfLFbh1lXz/aP9VXVFBg+R6/c/u6EZv
        y6yDd2YNQ53ulFTTpizlcGLcQPmWYCXnfi3MmqPrEkfjkqkNaOwywJAf0SlfxA+V
        EKuKsntMbNtErydIBuORz3px5NARhnTzYgg2uktzFelugRZcYzl1SSiLHhVFg9J+
        pkpKDVHHFVjGE8OxWYh+mEvEP5FkgA2oGo5xvBZDv6U1iMKIRp6O8xAswzlToKWA
        ==
X-ME-Sender: <xms:XSNzXneTT4lzd-_-iRKmo-USFBdB9L1BA1C0Af2fAzjWUocs_3qA-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefkedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:XSNzXskKR9qQy0jCaKOaJ7x-0EdmIzk8ohyQZXwQiRIp0WQoKE60lg>
    <xmx:XSNzXjGaFcVzSxHgJTYpP1sgM34-T6uRIdhfY03HcB8qOKQ6K8oNPg>
    <xmx:XSNzXqJxRiJs2Dd_2_eXIrNflwpcL69eU-wopSo_3Kj-61w4VAk1PA>
    <xmx:XSNzXgqBf8pOo_7Ic_wGYK0s6AkQUzZJKaLYZCdKdvOUg8ZqiZIGiQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B4B76328005E;
        Thu, 19 Mar 2020 03:46:36 -0400 (EDT)
Date:   Thu, 19 Mar 2020 08:46:34 +0100
From:   Greg KH <greg@kroah.com>
To:     Doug Anderson <dianders@chromium.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wen Gong <wgong@codeaurora.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, ath11k@lists.infradead.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] net: qrtr: fix len of skb_put_padto in
 qrtr_node_enqueue
Message-ID: <20200319074634.GA3421780@kroah.com>
References: <20200103045016.12459-1-wgong@codeaurora.org>
 <20200105.144704.221506192255563950.davem@davemloft.net>
 <CAD=FV=WiceRwLUS1sdL_W=ELKYZ9zKE13e8vx9SO0+tRvX74QQ@mail.gmail.com>
 <20200317102604.GD1130294@kroah.com>
 <CAD=FV=XXPACnPt=5=7gH3L6DufZ4tLSPTN-AtTAmvi5KAJuP6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=XXPACnPt=5=7gH3L6DufZ4tLSPTN-AtTAmvi5KAJuP6A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 08:45:09AM -0700, Doug Anderson wrote:
> Hi,
> 
> On Tue, Mar 17, 2020 at 3:26 AM Greg KH <greg@kroah.com> wrote:
> >
> > On Tue, Feb 25, 2020 at 02:52:24PM -0800, Doug Anderson wrote:
> > > Hi,
> > >
> > >
> > > On Sun, Jan 5, 2020 at 2:47 PM David Miller <davem@davemloft.net> wrote:
> > > >
> > > > From: Wen Gong <wgong@codeaurora.org>
> > > > Date: Fri,  3 Jan 2020 12:50:16 +0800
> > > >
> > > > > The len used for skb_put_padto is wrong, it need to add len of hdr.
> > > >
> > > > Thanks, applied.
> > >
> > > I noticed this patch is in mainline now as:
> > >
> > > ce57785bf91b net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
> > >
> > > Though I'm not an expert on the code, it feels like a stable candidate
> > > unless someone objects.
> >
> > Stable candidate for what tree(s)?
> 
> I noticed that it was lacking and applied cleanly on 5.4.  As of
> 5.4.25 it's still not stable there.  I only noticed it because I was
> comparing all the patches in mainline in "net/qrtr" with what we had
> in our tree and stumbled upon this one.
> 
> Looking at it a little more carefully, I guess you could say:
> 
> Fixes: e7044482c8ac ("net: qrtr: Pass source and destination to
> enqueue functions")
> 
> ...though it will be trickier to apply past commit 194ccc88297a ("net:
> qrtr: Support decoding incoming v2 packets") just because the math
> changed.

Given that both of those commits showed up in 4.15, it doesn't matter
much :)

I've queued this up for 5.4.y and 4.19.y now, thanks.

greg k-h
