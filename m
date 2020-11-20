Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB0A2BB215
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgKTSHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728918AbgKTSHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 13:07:19 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D9DC0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 10:07:18 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id d12so10861907wrr.13
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 10:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0NmfAftvG8jfqP588MYFMuWr16XepF/3+Ptp+9A0+/s=;
        b=LOGELjwogd+qVgclrfNE3GPNQ4TXLgRQ/u/Nyz/Q/SI4LqfCNyHQypwgD8mrgjB4wv
         RUd+N2RSnfrrPA8WWy9RYfjeDKCBcBMZ1kuoyg1FL+jHRZA2H1cc+eXR0xlZUpWUA1cF
         LNji2Ixc9fU4Z+k/edn3KTUmTftJzZVpEMzv8rMVt1J/NDo9bwNhdr3nVk7wfphjltze
         +ioayE+kqEBe1rpqpDSEj7hfUeAwJQ+OP82SGl64sNDDIUgzpK+vre0EeEuItAAG+P3h
         qt76e+H9wt5Bo5ysfRs3NONPpgjdUtnTMbwVLmhLYXhbmynSNKImKn5c1M5T1zCKqep3
         G6KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0NmfAftvG8jfqP588MYFMuWr16XepF/3+Ptp+9A0+/s=;
        b=UrbetVjl2Z53WlfkRfghRiD4kze97dtMj8VegS/n4a6T6B6LJQOZCujYxScoXPPQMI
         IzkEebwFwLGHVPn09sv8BcMd0qCa46L9rRWrUTlFezI8mvAQLBpz9j7CO7YMk7p8lzym
         PPcYbQPQTeeVacR8CUGmjlw2aFevuBnnOoLoqljGLde2E3i8oeJdvZLfq35BqpDg1nhA
         IeN/V4l/osO8q9mIkllWHXzHN32JZxO0MKP2B9FVtU6P6u1Y9q/Lr5SDx8yt8y+JefbY
         lJTe4UFEKrS12R8TMsy3FDJ1StYYbnV2BHilON7qkCL/JBnwChObiwJgUO6GnbQIwW+i
         HuCA==
X-Gm-Message-State: AOAM5325uRQke51Bdf2561io1HJ8GSRL373/835ycXPOsp9qsuqvvQuG
        551SdFzylRKTX3B8PR8H5PCSJQ==
X-Google-Smtp-Source: ABdhPJx8mQhlF+q5KD5MU5LCSHBtRxN7Rp1bCBE+M6mbkEA2nnTXnxZChIwscKQAnaNG6CEqbjIKtQ==
X-Received: by 2002:a5d:5701:: with SMTP id a1mr17108310wrv.120.1605895636841;
        Fri, 20 Nov 2020 10:07:16 -0800 (PST)
Received: from apalos.home (ppp-94-64-112-220.home.otenet.gr. [94.64.112.220])
        by smtp.gmail.com with ESMTPSA id a144sm5357737wmd.47.2020.11.20.10.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 10:07:16 -0800 (PST)
Date:   Fri, 20 Nov 2020 20:07:13 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, brouer@redhat.com
Subject: Re: [PATCH net-next] net: netsec: add xdp tx return bulking support
Message-ID: <20201120180713.GA801643@apalos.home>
References: <01487b8f5167d62649339469cdd0c6d8df885902.1605605531.git.lorenzo@kernel.org>
 <20201120100007.5b138d24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120100007.5b138d24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, 

On Fri, Nov 20, 2020 at 10:00:07AM -0800, Jakub Kicinski wrote:
> On Tue, 17 Nov 2020 10:35:28 +0100 Lorenzo Bianconi wrote:
> > Convert netsec driver to xdp_return_frame_bulk APIs.
> > Rely on xdp_return_frame_rx_napi for XDP_TX in order to try to recycle
> > the page in the "in-irq" page_pool cache.
> > 
> > Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> > This patch is just compile tested, I have not carried out any run test
> 
> Doesn't look like anyone will test this so applied, thanks!

I had everything applied trying to test, but there was an issue with the PHY the
socionext board uses [1].

In any case the patch looks correct, so you can keep it and I'll report any 
problems once I short the box out.

[1] https://lore.kernel.org/netdev/20201017151132.GK456889@lunn.ch/T/

Cheers
/Ilias
