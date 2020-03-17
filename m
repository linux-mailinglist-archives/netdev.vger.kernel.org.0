Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B635187E3E
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 11:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgCQK0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 06:26:10 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36781 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgCQK0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 06:26:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id AC5B75C0179;
        Tue, 17 Mar 2020 06:26:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 17 Mar 2020 06:26:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=yKu34zzDB36bqTbEJuWtIcXkWMU
        gLDc3YXuL+xK/EjY=; b=hN+pJN6GdLBdWREs0yAMCWimSYvPFMrroTQSXm8Vc1N
        E91RJekkJeSxlGipTdk7filjDUcx8M1nstsZg6IYbDKQ4ndI7LRaUJYiVUqE9KX4
        q0mRkzNdEO4tYkndUYhBI8mYUZyPZzU9f/d+2eLgE+8K+QRtqC5xhuJAIyDDxbi1
        h12/0d2oGRz1rdK/pXNqIm0myqgyrvkbBuSTcTsjF3jVnQTnNdbJ79qqa8SGKEm5
        6HleL7VA9TGv1mfh4ZoGTiIpghokwS/Qydv9YMoJLfiW1PBoXOF2ti8kYRo9eMvH
        2xUHmyr4OUlL09YJVNPTlFGMYezcvEdcDmtbFg7vuow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yKu34z
        zDB36bqTbEJuWtIcXkWMUgLDc3YXuL+xK/EjY=; b=RGuS/kzGXJrMpP6CC1/hTZ
        EW0jTHtyqf4Q3sDYU79kK+7utGESasZ5MsamvZo3XRj7uUnaWDkm4HhQbCu/Wr7c
        i6MJtjOeDOX33zf2I1mOv5QyyXTGomiDrbDQuCHrs4s6sI/Fznpw32mH6xqY79CF
        Tu3hbWp4T7C8jHce7IgP6UzCMBahLU6yh2gKuxi3JZdClzj/Tzp3D0/1RmmzhtsU
        Qywn4d+vzq9VZ4bcF24vZ+VdgeBzI6aQo1uWDQVok4wFhsMfGOI1tskT5EHp1BEa
        HmGQPE8S5sk0NvJy9jHe7Wnjbyd6pT0hakygVjuHD4s28MPoI3xRERJkAra/3W9A
        ==
X-ME-Sender: <xms:vqVwXkJyG0AHvhcZdYt3-FERQy6VFhgFSwxxxoRW1-HjSC7WDmTAWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefhedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vqVwXsBoESAveUvZXcfjEOfs1roBlYBUtux1w8EyAMN0Z2IPyXwDYw>
    <xmx:vqVwXqoy9b_98nBQ0VCgisLLAYD6w-uZ1t8WCyAUzz5xTSRIwLVwGQ>
    <xmx:vqVwXlAtt_jEPPnRVkbIluz5M-xUKNQ8PD-CHRbNK8RPyfU5XU-ILA>
    <xmx:wKVwXgOZTwrdXZ2fhyHSbTKrbeNjq372jeE3lTGfstg3THdBF4E90Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5EEB03280067;
        Tue, 17 Mar 2020 06:26:06 -0400 (EDT)
Date:   Tue, 17 Mar 2020 11:26:04 +0100
From:   Greg KH <greg@kroah.com>
To:     Doug Anderson <dianders@chromium.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Wen Gong <wgong@codeaurora.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, ath11k@lists.infradead.org,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] net: qrtr: fix len of skb_put_padto in
 qrtr_node_enqueue
Message-ID: <20200317102604.GD1130294@kroah.com>
References: <20200103045016.12459-1-wgong@codeaurora.org>
 <20200105.144704.221506192255563950.davem@davemloft.net>
 <CAD=FV=WiceRwLUS1sdL_W=ELKYZ9zKE13e8vx9SO0+tRvX74QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=WiceRwLUS1sdL_W=ELKYZ9zKE13e8vx9SO0+tRvX74QQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 02:52:24PM -0800, Doug Anderson wrote:
> Hi,
> 
> 
> On Sun, Jan 5, 2020 at 2:47 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: Wen Gong <wgong@codeaurora.org>
> > Date: Fri,  3 Jan 2020 12:50:16 +0800
> >
> > > The len used for skb_put_padto is wrong, it need to add len of hdr.
> >
> > Thanks, applied.
> 
> I noticed this patch is in mainline now as:
> 
> ce57785bf91b net: qrtr: fix len of skb_put_padto in qrtr_node_enqueue
> 
> Though I'm not an expert on the code, it feels like a stable candidate
> unless someone objects.

Stable candidate for what tree(s)?

thanks,

greg k-h
