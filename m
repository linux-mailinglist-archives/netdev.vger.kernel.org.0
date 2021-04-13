Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD5235D66B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 06:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhDMEZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 00:25:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56513 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229644AbhDMEZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 00:25:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618287882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q+1EoJgQHtcLO0TXGm3dZ+kuN9h3PKmHdMygVbCrH8A=;
        b=OY+/F/P4gSgUXOid2o2aHegndvqBe/6q9M0cpJrV7vxUzpuHBEYI9XlZ4OuQQnaO0JcLHZ
        GmIXy9u0Pg2SubZbjo5vXX8Jpg4J8HT7yQxELQXKG5O0TY/j/yA404R9OjYo2gDj7R3TKa
        l6yoyDNLMbnDPYe6JpxFJfGIWSWQ32Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-M-W-NVbzMWiEI9o-q5FbUg-1; Tue, 13 Apr 2021 00:24:40 -0400
X-MC-Unique: M-W-NVbzMWiEI9o-q5FbUg-1
Received: by mail-wm1-f69.google.com with SMTP id o3-20020a1c75030000b029010f4e02a2f2so596843wmc.6
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 21:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q+1EoJgQHtcLO0TXGm3dZ+kuN9h3PKmHdMygVbCrH8A=;
        b=Xc9956e5Z/yv/c+Uyuv0At+zkF4SB3A1hgEAoODGQUC8kfdq9ij7L4zMggETDmAPtK
         YX6F/ZAdpkzr2MZYrIJTSZKkMuLUnl0bWFiT0ZaZvn8vL8r+6Tqf/lMLp1voQbWLqDzP
         9h1jGmzsLN6sp64tC7xL/I5c8IQ5z/Z8sTCpCmIZTEq8mcR5Ch1jmtbyYdJ9re7OIKVF
         hDkmqnYOODEwNnfn8Ws5tWGJuWywlO05NqUSd6ZH25h4Xt2eWGNny99rZ7ITlhTzkv9Q
         hUp8LNNmYEc6oBccvZlZaXec0YPimf3OH/aHuHgecvaitA49aBR9LmqrhTy64XqZ5VRg
         /q8w==
X-Gm-Message-State: AOAM5314lpzhhNhBD7sSz9p0vPKDELWKcE96fAqZxxWuWVuQ8Kg53G3m
        vJAH5B8rlpBUdrpPLCyParRod5tjEGvojvacdRFdUaruNgXM3d/JObi1+Dg2zJ3w4LoSHh5hNel
        BghjJbjYlqKiNTmFU
X-Received: by 2002:a5d:69ca:: with SMTP id s10mr18463110wrw.78.1618287879418;
        Mon, 12 Apr 2021 21:24:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyodPDoN8x3GL83Cr9txbEz4M9Dd9UXgw0xTbFSIzIOWIhtoOQiLU8g9CAcs7gvxZ10oODxSA==
X-Received: by 2002:a5d:69ca:: with SMTP id s10mr18463104wrw.78.1618287879282;
        Mon, 12 Apr 2021 21:24:39 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id b16sm1161845wmb.39.2021.04.12.21.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 21:24:38 -0700 (PDT)
Date:   Tue, 13 Apr 2021 00:24:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     weiwan@google.com, netdev@vger.kernel.org, kuba@kernel.org,
        willemb@google.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net] virtio-net: suppress bad irq warning for tx napi
Message-ID: <20210413002340-mutt-send-email-mst@kernel.org>
References: <20210129002136.70865-1-weiwan@google.com>
 <20210412180353-mutt-send-email-mst@kernel.org>
 <20210412183141-mutt-send-email-mst@kernel.org>
 <20210412.161458.652699519749470159.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412.161458.652699519749470159.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 04:14:58PM -0700, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Mon, 12 Apr 2021 18:33:45 -0400
> 
> > On Mon, Apr 12, 2021 at 06:08:21PM -0400, Michael S. Tsirkin wrote:
> >> OK I started looking at this again. My idea is simple.
> >> A. disable callbacks before we try to drain skbs
> >> B. actually do disable callbacks even with event idx
> >> 
> >> To make B not regress, we need to
> >> C. detect the common case of disable after event triggering and skip the write then.
> >> 
> >> I added a new event_triggered flag for that.
> >> Completely untested - but then I could not see the warnings either.
> >> Would be very much interested to know whether this patch helps
> >> resolve the sruprious interrupt problem at all ...
> >> 
> >> 
> >> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > Hmm a slightly cleaner alternative is to clear the flag when enabling interrupts ...
> > I wonder which cacheline it's best to use for this.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Please make a fresh new submission if you want to use this approach, thanks.

Absolutely. This is untested so I just sent this idea out for early feedback
and hopefully help with testing on real hardware.
Sorry about being unclear.

-- 
MST

