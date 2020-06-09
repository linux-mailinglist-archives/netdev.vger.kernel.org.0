Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911871F3A23
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 13:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgFILzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 07:55:00 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:56747 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728754AbgFILy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 07:54:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 030BC58016E;
        Tue,  9 Jun 2020 07:54:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 09 Jun 2020 07:54:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=4XghQ4ngJrsVa7o3S5D2L5Fpmy6
        lr42o/I7ET5fuZBE=; b=jUFRqrs66EfQdyi4QdpnhZ8Oh+re4JJMZ7Rj7o3r5m5
        +ds97NPJ6VOO/zButAP+XIWrzEIg07/TyOvOKR4mvqSPM2lu7NsVaDwaZIpcouNm
        jt3bszRxaFO3NBtwI7MI3l/ciYYfW3lc4Wtkpeo9LxbqwEKsnFbG/nY3vNSevoLZ
        1k20y3uzc/WZbXTiW93oiP1szsmq0Cmau4Kw7YFEbVQ811iDIcoybCaaM+i0Ac3v
        /OOrV3SQty5MLo4WLavuRef7BabSUwbIj+BNq/uBNe6KIF9yqmYcvr3jSHpnfx+q
        xNuSBQHl6XUVpAcoPCaJ97lW9JEUSBWWnSDxlLzqoKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4XghQ4
        ngJrsVa7o3S5D2L5Fpmy6lr42o/I7ET5fuZBE=; b=FqkFJrFrPcz+sUJo4ImAAn
        TydrBGBzHIJwHPZo2QXSRonsQsT2Csj4anXD9+8fm/vjgs6Qs85sUG3gTzX5dpVc
        75E776c0zlSmM47kCiMUkyCgwxZC/ZtqG4zoxFHB43ApxojrLzm16cxDW/zvXGYq
        ydg6Vchn9Pde7V5c0ZOiIuYYVypFDM5RcOkgwk9zo/RRG2P77JZD52vppBeX33cx
        eUf0/+JGLzZ2UjYYU/gnorxi6h4Uz4GtvdL8oyuXnXfM/temhQZcHbMIor6ylswu
        HkLEqrE3elOdTpO2grvK7Fjc3o/3MK7TLKReWN3H6zL2pHPZLiMJEgy+5bruIheg
        ==
X-ME-Sender: <xms:j3jfXh9kqVH9-HALDlZLQVT7BENkZoY3hDDhBYhCD4-v7Fy4Y3BcMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehgedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:j3jfXluXnWs_jAK1jDLLMKaQOkMUfXjkIo8paM0MaD5kFP-dodvGQQ>
    <xmx:j3jfXvCLWdH0dctuGUr7cptGmFfiasX18CesjRfXan9IlErMbkq1Rg>
    <xmx:j3jfXleh_fyxlHaxgd1mYPPBZXa8vu7uQWLlYHGxKyqGoNP2E5vcFg>
    <xmx:j3jfXnn7jXQRdKIVOw7K18MEzLZer7ELe2Kuqlv-ZJxua8x3Gj4soA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CDD08328005E;
        Tue,  9 Jun 2020 07:54:54 -0400 (EDT)
Date:   Tue, 9 Jun 2020 13:54:53 +0200
From:   Greg KH <greg@kroah.com>
To:     Gaurav Singh <gaurav1086@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: your mail
Message-ID: <20200609115453.GB819153@kroah.com>
References: <20200609113839.9628-1-gaurav1086@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609113839.9628-1-gaurav1086@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 07:38:38AM -0400, Gaurav Singh wrote:
> Please find the patch below.
> 
> Thanks and regards,
> Gaurav.
> 
> >From Gaurav Singh <gaurav1086@gmail.com> # This line is ignored.
> From: Gaurav Singh <gaurav1086@gmail.com>
> Reply-To: 
> Subject: 
> In-Reply-To: 
> 
> 

I think something went wrong in your submission, just use 'git
send-email' to send the patch out.

thanks,

greg k-h
