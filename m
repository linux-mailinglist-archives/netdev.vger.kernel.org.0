Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9009B68E912
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 08:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjBHHf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 02:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjBHHf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 02:35:57 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1D0367FE;
        Tue,  7 Feb 2023 23:35:55 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 3B30D5C0100;
        Wed,  8 Feb 2023 02:35:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 08 Feb 2023 02:35:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1675841755; x=1675928155; bh=PerO6IGIJ6
        5nnmUlpsSV7KJ4H6wHxkx1KrBHYtWqeK8=; b=XlK0ql5Uo4+GUPyxk69vOkZpVj
        +kTckZY03kANNg5oFgRCdZwRTy2H9ZDUxH8bcsd7IxnaA/b4ZSfIlWSdaX9TUNZV
        ydQnrUjmrs0LWiv83Yn8hoeNf9c4zBcoOLdrLnso8D5/otfrejBrv0ZPdHr3wMDY
        q26PCEYVZCJ8nZufbR4yiOd4hohRfvtvUP6VbHqI7UNXgGdNrzey8Nfd+gLqvGoT
        nrDuiqqnV4OJ4UQHseFgINwfiHRam9jUgFgCKpgnEHXpq+hKAYeRLW1vKXH8py3d
        zW7LA1S8S4rMPQ3nmUJI3mJEnaVn5chUyiGgzBUut0fZSAC5fLDy+Hjf1tZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1675841755; x=1675928155; bh=PerO6IGIJ65nnmUlpsSV7KJ4H6wH
        xkx1KrBHYtWqeK8=; b=VvmwWgoR3zm/wJdr+1HYiqjTn/RmWfsKVDnQQQl+6s16
        LuGwv1zWtrKw4u9D8khOXCqTha0fOSd6TVMxx1t+F5WwC3p7er/g4ua1N5gvS7KB
        q4Q+3Y0fa5RhSGCIPCE+4l0WLyrPvRoZDoOAGH3o6q5eSFedv6vDqb15erfwV32U
        a2ew6KKX669DivASYx3SLRDf5iTsZ4yTZRkINxODZQMyhlGhQ7XzOpXlyMaUlKVg
        ZlmB3tK64NIH8vqRvz7Sk2SYm3LX2ze3rIqkmdrOttRGiVpA2sfW+6i2Er8BuIOy
        ifb1UvXkFKR2bNZbrnUFyYEsiPR27QSkk8xDioCxng==
X-ME-Sender: <xms:2lDjY2ZYJPQmsQuob5fpH8dR0P0lk6PnjRBrGIN4pEWgpuDpFVTqHg>
    <xme:2lDjY5Zj49Re8UPA8fy7YKy-nBjzOnwW0inJo8RhBTitcVn5BpoAuhx4KXHhhXxj9
    p24OXufp7xHTQ>
X-ME-Received: <xmr:2lDjYw-D8sldemr5DNkcRqZZE5nxhZIbXBDI1hioP2_eTJ_lIUHMtBK7sx98trH6csmdU9Ih1rojo0Lji90SOZxeWbHZmg4KQl-zlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudegledguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:2lDjY4qzuPY69qXUKXJKQryVREn0tVn1A-_H3TBIpkMDrQnRHuSpTA>
    <xmx:2lDjYxoybmn2_eLg7nLs9T5lzzMDzkvwVKZnTywcD1D_M_gb7R9keQ>
    <xmx:2lDjY2RNzSHJvpxx5oBppaPAJTQS9OXJmtEDiahTLIZ19vBct-RtmA>
    <xmx:21DjY-h-jaWjVKaIFQ4GXzFNHj4NmOv6eC3Vt4WRH5eS8OueachQMQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Feb 2023 02:35:53 -0500 (EST)
Date:   Wed, 8 Feb 2023 08:35:51 +0100
From:   Greg KH <greg@kroah.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: duplicate patch in the usb tree
Message-ID: <Y+NQ1zP0UccKSq7E@kroah.com>
References: <20230208121734.37e45034@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208121734.37e45034@canb.auug.org.au>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 12:17:34PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> The following commit is also in the net tree tree as a different commit
> (but the same patch):
> 
>   93fd565919cf ("net: USB: Fix wrong-direction WARNING in plusb.c")
> 
> This is commit
> 
>   811d581194f7 ("net: USB: Fix wrong-direction WARNING in plusb.c")
> 
> in the net tree.

Not a problem, git will merge this properly.

thanks,

greg k-h
