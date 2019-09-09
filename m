Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21168AE15B
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 01:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730670AbfIIXGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 19:06:14 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:42215 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728358AbfIIXGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 19:06:14 -0400
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Sep 2019 19:06:13 EDT
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id C597A5C0;
        Mon,  9 Sep 2019 18:58:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 09 Sep 2019 18:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=c7SRxgGkl/n7ftaGRuh/aN2wiSp
        1GC91qqjIL142vpY=; b=G3dZKzQxG/jRRbNObX/rxwuitX3uvOm0yJq4spn6u4F
        yD2CpkOUVoxiuTrX2QZMwr5LUXv+DKhqAkX4KgyhTaUT58aDQgRUxDJt3eWbC5Mr
        piw33yd5qX8u4yPMt9k2N5nEOUak+hc2Gr/H+CQBU8Ac8/4C2QL6WQ5RnDP9Mo4L
        FusaMeESRa7eu1NPJqXpWUlekmBNcr+TVhqNMjBQbiEF/cOOz9rBJNoqG1UBfLy8
        Ag2qtQf26igPzpoRjORYHrqlC6MIwfXJZAkfSFk0cBG3qqT5haB/DBlm5tUV8zrH
        tkA1PSImctrM9gglg+mp/j5nggylrKIQ5YXM375XTEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=c7SRxg
        Gkl/n7ftaGRuh/aN2wiSp1GC91qqjIL142vpY=; b=RPWpxAuxPaSDJpabSG4dYI
        Ptth1BbAnXyffkgaFO7Py31VLFwXre/UPi4ecVVdDVTqnRdQXj1g9s7cDnzaWDMv
        JX10+fZipUFybkjtTEWISPKVBJyuRF6RGoVgROZRp+o8rNB2IAhypKZejBtzfjKC
        lOYIqNLyqTqbn6aYVZL1VGSE0EcODUujXe7ewereY7ZM3MWvxQsOuN62IEU2X529
        7poLNXuYYaYAQTIFjjgnPcbh/i9+tDKNpXU+o94lhOIz1AFTB8bkKTANpaTDQ5d8
        aGK44GIfGfr2vqmCQZIgqlORbgROGILTtiJC3PmiXB9TwOMuN1I7ZWNgvp7AaJxw
        ==
X-ME-Sender: <xms:_th2XYFUAqHgaVXLqngGFV8WqvWxz17vLWRO4v8mF34Uq31HL17ARg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhprghmkfhpqdhouhhtucdlhedttddmnecujfgurhepfffhvffukfhfgggtuggjfges
    thdtredttdervdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtg
    homheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepiedvrddvkedrvdeg
    tddruddugeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtoh
    hmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:_th2XaF8_gevEinqTQQ_uNl-FdiE_vr_10nWdYvuL4Vg_bFMldp0Xg>
    <xmx:_th2XQ3WXthQKPBf4ag-nrUOUCrRJiQARH8mBGnLtBjyhhkeB5niqg>
    <xmx:_th2Xcdox1BsHrIBY_f9kUVdliBot0N3RNtWfUu8C9OINpQx6FUgoQ>
    <xmx:_9h2Xdt6HwnmZejBm85Y1O-QNzqJqOUZpCfmiAxqpLkysdRAiHtjdk5ywtk>
Received: from localhost (unknown [62.28.240.114])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1611280068;
        Mon,  9 Sep 2019 18:58:05 -0400 (EDT)
Date:   Mon, 9 Sep 2019 23:58:04 +0100
From:   Greg KH <greg@kroah.com>
To:     Mark Salyzyn <salyzyn@android.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] net: enable wireless core features with
 LEGACY_WEXT_ALLCONFIG
Message-ID: <20190909225804.GA26405@kroah.com>
References: <20190906192403.195620-1-salyzyn@android.com>
 <20190906233045.GB9478@kroah.com>
 <b7027a5d-5d75-677b-0e9b-cd70e5e30092@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7027a5d-5d75-677b-0e9b-cd70e5e30092@android.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 07:24:29AM -0700, Mark Salyzyn wrote:
> On 9/6/19 4:30 PM, Greg KH wrote:
> > On Fri, Sep 06, 2019 at 12:24:00PM -0700, Mark Salyzyn wrote:
> > > In embedded environments the requirements are to be able to pick and
> > > chose which features one requires built into the kernel.  If an
> > > embedded environment wants to supports loading modules that have been
> > > kbuilt out of tree, there is a need to enable hidden configurations
> > > for legacy wireless core features to provide the API surface for
> > > them to load.
> > > 
> > > Introduce CONFIG_LEGACY_WEXT_ALLCONFIG to select all legacy wireless
> > > extension core features by activating in turn all the associated
> > > hidden configuration options, without having to specifically select
> > > any wireless module(s).
> > > 
> > > Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> > > Cc: kernel-team@android.com
> > > Cc: Johannes Berg <johannes@sipsolutions.net>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Marcel Holtmann <marcel@holtmann.org>
> > > Cc: linux-wireless@vger.kernel.org
> > > Cc: netdev@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: stable@vger.kernel.org # 4.19
> > > ---
> > > v2: change name and documentation to CONFIG_LEGACY_WEXT_ALLCONFIG
> > > ---
> > >   net/wireless/Kconfig | 14 ++++++++++++++
> > >   1 file changed, 14 insertions(+)
> > > 
> > > diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> > > index 67f8360dfcee..0d646cf28de5 100644
> > > --- a/net/wireless/Kconfig
> > > +++ b/net/wireless/Kconfig
> > > @@ -17,6 +17,20 @@ config WEXT_SPY
> > >   config WEXT_PRIV
> > >   	bool
> > > +config LEGACY_WEXT_ALLCONFIG
> > > +	bool "allconfig for legacy wireless extensions"
> > > +	select WIRELESS_EXT
> > > +	select WEXT_CORE
> > > +	select WEXT_PROC
> > > +	select WEXT_SPY
> > > +	select WEXT_PRIV
> > > +	help
> > > +	  Config option used to enable all the legacy wireless extensions to
> > > +	  the core functionality used by add-in modules.
> > > +
> > > +	  If you are not building a kernel to be used for a variety of
> > > +	  out-of-kernel built wireless modules, say N here.
> > > +
> > >   config CFG80211
> > >   	tristate "cfg80211 - wireless configuration API"
> > >   	depends on RFKILL || !RFKILL
> > > -- 
> > > 2.23.0.187.g17f5b7556c-goog
> > > 
> > How is this patch applicable to stable kernels???
> 
> A) worth a shot ;-}

Not nice, please, you know better :)

> B) there is a shortcoming in _all_ kernel versions with respect to hidden
> configurations options like this, hoping to set one precedent in how to
> handle them if acceptable to the community.

That's fine, but it's a new feature, not for stable.

> C) [AGENDA ALERT] Android _will_ be back-porting this to android-4.19 kernel
> anyway, would help maintenance if via stable. <holding hat in hand>

That's fine, lots of distros backport loads of stuff for new features
for stuff that is upstream.  That's trivial to do, don't try to abuse
the stable tree for new features like this please.  It only makes
maintainers grumpy when you do so :(

> D) Not an ABI or interface break, does not introduce instability, but rather
> keeps downstream kernels of any distributions from having to hack in their
> own alternate means of dealing with this problem leading to further
> fragmentation.

Again, new feature, not fixing a bug, so not applicable for stable.

For penance I require a handwritten copy of:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

thanks,

greg k-h
