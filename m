Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3343C354FA0
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 11:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244799AbhDFJMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 05:12:07 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55477 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236391AbhDFJMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 05:12:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D86D35C0060;
        Tue,  6 Apr 2021 05:11:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 06 Apr 2021 05:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=8WS8zanY9FE0fnyBFIsk5d9BynT
        FXKYLOq4YQPULBsk=; b=YX6Q+S7eLYQMHjdtH+3GvEO3gk9YtpTAyJBaw2EaMkG
        wvpnmJ3xb1qqMvVZAtPpc3dduxN9Ci4o46a3I44z5SYUUk5di/PK5qiZGEOt0KiY
        bJ8JWWRzEft8CLHLP6UXO0QHmQw30GXwZAzLoW3zkRGQZFgPPTpEpjaYmcFDC8TI
        oRcfUkZyIew+ymdt8mR01zQcxEvEF6/bUUaTf9Bu1mEt8LOCkAvcMev8vGFrzYWY
        I/8Td2Nvw8el/3YaPUNudJzEFYHQQ10ve9DE6i737HB+urKj13963qVXwLJF1f9x
        4HmiOTWZhj+dQD3pBG5bs8TFJsD+fACFH0sKd2e4zvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8WS8za
        nY9FE0fnyBFIsk5d9BynTFXKYLOq4YQPULBsk=; b=wsFW+cuqtxHenPZmARizoE
        3lDHJlKlpzwRquDWh0bSnOWOHZHHEVmQBKS6zzr+oE/gTtBi1qgQjIgKKE+QQ9JN
        Lz9DAfYg7Nz5shiL03ZhRg/NEuGMp5NlEG6hVXVw1PKMlfY803Yg+ubHA5bZYLbh
        qnOEEBSIrB/R/Z0/166DvrC6lgnnwzQhk23UZmfG7sqEy0Nq6a4PebCW+BEk0oks
        //RmlhCiJhCtpbh0s67a2sYsIOEi3xPFUyPTm7JiqNzzkGvQf3OFfH703yENAQ4A
        UDFp49ex9OvmM/omwboYCSCIOsbjdSaZnlMqI6BhEJhecwrVv79nG+eFkvru0JhQ
        ==
X-ME-Sender: <xms:3CVsYJ2YjchrrefrEEToo_ZVjpb8Dhw7J7fuxH4Mu1CgNpjMnQcrYw>
    <xme:3CVsYAElGbrmHfZwZLZMkHTAfRdc-BxDTTl1oPZzLEZc9wrh3uAUidg9ua20A9aWk
    0S6ESkH5AIS_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejgedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeel
    rddvtdehrdduvdelrddvgeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:3CVsYJ7_P8a4Pv-ROobKY2fCcIR_JyfD6zUOFTxkJesV_tzkxe7sZg>
    <xmx:3CVsYG02c9fy55QDtm31qnlKm9AxdsB9VhdNgrWZUPrXFS64U9eZbA>
    <xmx:3CVsYMHesy1A8yPSncxfMGCC6iYwIUPgm3qjZv4syf24GU0ZpGTATw>
    <xmx:3SVsYBNstZIFBtAxmWnIsovirB1Ir1eMAoBXMRu_lVxGBCjpT6C5cw>
Received: from localhost (unknown [89.205.129.244])
        by mail.messagingengine.com (Postfix) with ESMTPA id 373BB108005F;
        Tue,  6 Apr 2021 05:11:56 -0400 (EDT)
Date:   Tue, 6 Apr 2021 11:11:53 +0200
From:   Greg KH <greg@kroah.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: Re: linux-next: manual merge of the tty tree with the net-next tree
Message-ID: <YGwl2VvvGcmCciMn@kroah.com>
References: <20210406184814.3c958f51@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406184814.3c958f51@canb.auug.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 06, 2021 at 06:48:14PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tty tree got a conflict in:
> 
>   net/nfc/nci/uart.c
> 
> between commit:
> 
>   d3295869c40c ("net: nfc: Fix spelling errors in net/nfc module")
> 
> from the net-next tree and commit:
> 
>   c2a5a45c0276 ("net: nfc: nci: drop nci_uart_ops::recv_buf")
> 
> from the tty tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Change looks correct to me, thanks!

greg k-h
