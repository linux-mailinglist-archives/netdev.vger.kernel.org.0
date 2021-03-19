Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA30341A21
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 11:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCSKds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 06:33:48 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:42981 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229921AbhCSKdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 06:33:33 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 75DBC134B;
        Fri, 19 Mar 2021 06:33:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 19 Mar 2021 06:33:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=JfFHTg/BWux+nPcjdimtHrbbKaV
        mylHLXlbA6N7S8P8=; b=VHj1JYaCqDNHVHkWuEK9IwjqIjv9yka5RZuZRZ/6pUa
        Gp8743B+CgbXkf21B4MXExpqDcJptCI5Cl2HdW18qpi1XSUjWv2lZQ/pmHPYZyJF
        8Q4VHZpV6P+tax4aKZw/xi6aHBc1BmNV44c+MMWqiKI1dIuO9RMTv8JCFg+lj6Rz
        7kkS7UxuV+zdiYUF+Rf3z3B46r8FE98NIlJfM2yhHvAS1PmMOgtEaRESSqx3tz8j
        XNUT6Ek4wsaW9dAizgl5fRXVuqs/IuuhbbufCElsbiyoeP4UTjLYZ9pxmA4Yt5IC
        Blp0KxjI1Zy7IqVN/FaENlhHdqrKqHd8f48RfvPm8oQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JfFHTg
        /BWux+nPcjdimtHrbbKaVmylHLXlbA6N7S8P8=; b=wKRwnN89CoUNKlW0PVjxlz
        kRJPHL45VgI9yRTMJ9ITXf0MrsN/qs8ZbLI5Up7zPCzUyy5rZtwocLDILpXDud08
        zisxxpxxhKNEhEoejVZESxGAOqlUTc74uDn0/W7EpgfHxp/xHLvS74vQik4LW6Xa
        o+lNrhLaVPOADzN9fAnqAifMAyG3TBkYqa/yoyPM0teayE+bjQ2ch7s2COzmtcS8
        0sTRfieqVrBw+Dg4DMMAP1RyWJiOkjeY4hmhPsAoXOyGrLYz8cY1yud2X3m3mAc+
        ZTtYPHv5+Mxhg65eFQNMELNd54gxlK5OdgFBpczeOwFuaY6YfKDQNIlryvlY9+hQ
        ==
X-ME-Sender: <xms:-31UYCjqPRWhINRFce3NjfMTZdQxyjz9EKC4M3VuwG44mul4Pr4gdw>
    <xme:-31UYDC_koBDw6oLHxNr46cGuyeVlLffwpvLj95VJfm6onfVPgh6CfHbQJcI_Hy-u
    HtuJtXbm4XFgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefkedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-31UYKHf4G1_UvxpZV4pn_iLY92myysWFIrQnSsjEqgtcjXstZ9Buw>
    <xmx:-31UYLRJ-dyqvv_fV7cnPUVE-DiDAu3QF10PtxZf2exbF66JW1dX-g>
    <xmx:-31UYPzdj1RkCprLjVCCzxngsZU7SYAYI0QuplKoAdrYgc1wiYd7Sg>
    <xmx:_H1UYK8uopcMSRI32zmPJpeMjbdub9otMi4ApkuzxhIRB5xpLR1xvg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F53D24005A;
        Fri, 19 Mar 2021 06:33:31 -0400 (EDT)
Date:   Fri, 19 Mar 2021 11:33:30 +0100
From:   Greg KH <greg@kroah.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        Ilario Gelmetti <iochesonome@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH stable 5.4.y, 4.19.y] net: dsa: tag_mtk: fix 802.1ad VLAN
 egress
Message-ID: <YFR9+hKJTn09MHUm@kroah.com>
References: <20210318052935.1434546-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318052935.1434546-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 01:29:35PM +0800, DENG Qingfang wrote:
> [ Upstream commit 9200f515c41f4cbaeffd8fdd1d8b6373a18b1b67 ]
> 
> A different TPID bit is used for 802.1ad VLAN frames.
> 
> Reported-by: Ilario Gelmetti <iochesonome@gmail.com>
> Fixes: f0af34317f4b ("net: dsa: mediatek: combine MediaTek tag with VLAN tag")
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/dsa/tag_mtk.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)

Thanks for the backport, now queued up.

greg k-h
