Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F73108573
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 00:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfKXXD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 18:03:59 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40893 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfKXXD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 18:03:59 -0500
Received: by mail-pl1-f193.google.com with SMTP id f9so5566550plr.7
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 15:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=i1qHwy+G9a0VSULNRaoms0tDekf8iU/51Ya/Xfrai40=;
        b=pfLTvoq6UuaicbxCNV7Fjs+l8+Gyt2W+YkaRQIm3yX8ESfgyWToe9ebcfObxRas8jp
         NhIYT1Mj52QiopTTftiyHo3iaeIEkST10vx4fV53IsisneDl8Yye6C2cChYpf+p/8Spt
         M1ukwMsODKTHcdh6Qd5jZnaop4Hp2kvTB+XWdJxdBwUimM66alr9aJ4n397ciEvjThKY
         roLEvdBQhUnIevVbfcboUXwuqIXU1ylt6p7tAVydBm0LuUSmw55aut/WC5ceDED4F5nf
         1OPXsmWUT/89mveM3Idz+o7AuCN/FCGpFESBFFnStjZwFqrgQBelB2aLOVPmgjPmmHBl
         JzIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=i1qHwy+G9a0VSULNRaoms0tDekf8iU/51Ya/Xfrai40=;
        b=kHaYjVQ+QSmnCtcB+yf1R98rIV5i/wCeMOonH1nc77NlwMous2w+L4KvKZ+6Cyq5lF
         LAM8MUxlh3XTMGHdBf8avO7s4+AkDvzAGySGDOidKZ0tdE5az2i/ng/Ywn23gpQ0/l9+
         srIMXkJBxPM0yVbHziX2Oq5gk0h44YnNo7yy/RRRsLkAp8/OaYeJxQTSqLs8tmImzKk4
         eX66n96X/a7D9HSXKNpH6vwfqMxT1XJb959CNz9z7n3HWeWO3PvT0XrGTIOrFSrA3RFW
         C06kb+GVJD+VisZhxYw7mie9b6Xn6TUMwSXgNMTvlJJOmREPYj+XBFM9IYGa09wJRukU
         fh7Q==
X-Gm-Message-State: APjAAAXykieYOYm5r6ajKZrqdXlZJrHgL29pzlXyP+PdA1MpoF5y3vIt
        JAhmd2I3+c8YY+QuEAiuh6IEGw==
X-Google-Smtp-Source: APXvYqxoORlmu7NvER9bWBQjpyIr5840UQFPogBmNb1dxXAhZ9CFlH832yGT792uTtGLND5sd3A32Q==
X-Received: by 2002:a17:90a:970a:: with SMTP id x10mr22772544pjo.39.1574636638757;
        Sun, 24 Nov 2019 15:03:58 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id w19sm5543817pga.83.2019.11.24.15.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 15:03:58 -0800 (PST)
Date:   Sun, 24 Nov 2019 15:03:52 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Julio Faracco <jcfaracco@gmail.com>, netdev@vger.kernel.org,
        Daiane Mendes <dnmendes76@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] drivers: net: virtio_net: Implement a
 dev_watchdog handler
Message-ID: <20191124150352.5cab3209@cakuba.netronome.com>
In-Reply-To: <20191124164411-mutt-send-email-mst@kernel.org>
References: <20191122013636.1041-1-jcfaracco@gmail.com>
        <20191122052506-mutt-send-email-mst@kernel.org>
        <CAENf94KX1XR4_KXz9KLZQ09Ngeaq2qzYY5OE68xJMXMu13SuEg@mail.gmail.com>
        <20191124100157-mutt-send-email-mst@kernel.org>
        <20191124164411-mutt-send-email-mst@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Nov 2019 16:48:35 -0500, Michael S. Tsirkin wrote:
> diff --git a/arch/m68k/emu/nfeth.c b/arch/m68k/emu/nfeth.c
> index a4ebd2445eda..8e06e7407854 100644
> --- a/arch/m68k/emu/nfeth.c
> +++ b/arch/m68k/emu/nfeth.c
> @@ -167,7 +167,7 @@ static int nfeth_xmit(struct sk_buff *skb, struct net_device *dev)
>  	return 0;
>  }
>  
> -static void nfeth_tx_timeout(struct net_device *dev)
> +static void nfeth_tx_timeout(struct net_device *dev, int txqueue)

Given the recent vf ndo problems, I wonder if it's worth making the
queue id unsigned from the start? Since it's coming from the stack
there should be no range checking required, but also signed doesn't
help anything so why not?

>  {
>  	dev->stats.tx_errors++;
>  	netif_wake_queue(dev);

