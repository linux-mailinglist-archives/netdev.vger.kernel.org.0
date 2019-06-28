Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47EA25A221
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfF1RTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:19:40 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42771 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1RTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:19:40 -0400
Received: by mail-wr1-f68.google.com with SMTP id x17so7062194wrl.9
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/vWrZqXzBz7YDlbXUOiHiqZlnBjFFFFfxSYuQIDrANc=;
        b=oxSiIt3T22Vj/SdDQjwySJrR6cwEhi2FE4S5sFabiuZ0tRPM9MD8K5osd85P5J3rgb
         Lo0a8MTa0uXapPn2i5aum+NC4yi2OGjFfdknDpJ1nR6lMTcTRaHIZrxsqZ5VorRQTAi0
         z5h+VNKxQdSO7e8UHZxM3x+a1eE+e29Y8+6ymU/yx4ni7wRzQ48VEHYlDeuOSulog2FV
         HxSWhOEL48aq5Cxeg8TII7q1zuYRJAPp6Hv/lUijBDCq7VCpnIOzn/MMOI8fmISFYbLO
         Jcd3c3Q+jmfOgjeGv3D9gWiQrnVCcXPLqKuQb0YoxjLkywJjg0wkSWNsNpNa3MWPrIcA
         K8/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/vWrZqXzBz7YDlbXUOiHiqZlnBjFFFFfxSYuQIDrANc=;
        b=AzNU2tJXGbiy3sAc2wobBn32JZq2eTuVZqaxwx4a4G691Wh4NRBGZNmcJP4av7URyQ
         t3o6A3J0MigiwXah1u+2dl++2v7b1ddlKanv0XBgkRwjqBxfxQ5bLkr0a1IrT7ruBOb4
         D+fx1tWdX1rMpzA9l7t5ccGL8VjhcFMDGM/pPkIoTEgyPc732bLGRfJyuLnJ5nUZJ1qW
         AzYrmcHbWpR4Pau1alxNrNVg3yxFPHZ2K/RstyNVpfK8emUZzCTGLmq8ZbHjNxjqbsts
         piMc4X/GnG1px1+ca6qUHXPrKedDAy2rXCZO33TNBCQModafTp3kSAOJUCSa0PNL8U3f
         35kQ==
X-Gm-Message-State: APjAAAVif6RKbJzT6laFvcGWNGTLg9QNX0wRMrvuzpvQ8nxi8BOmB9Mo
        gj5pL1lVZIBDve9jUgVf6bAQvA==
X-Google-Smtp-Source: APXvYqzmxCOjiO84/UYYZFwuezxQG8UxskrgYRTFd2mWaGg2XPli8tbUdPLRQHZHCMHwrJ2cJrydAw==
X-Received: by 2002:adf:9791:: with SMTP id s17mr2187063wrb.251.1561742378142;
        Fri, 28 Jun 2019 10:19:38 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id q20sm4082337wra.36.2019.06.28.10.19.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 10:19:37 -0700 (PDT)
Date:   Fri, 28 Jun 2019 20:19:34 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     David Miller <davem@davemloft.net>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        jaswinder.singh@linaro.org, ard.biesheuvel@linaro.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, maciejromanfijalkowski@gmail.com
Subject: Re: [PATCH 1/3, net-next] net: netsec: Use page_pool API
Message-ID: <20190628171934.GA31070@apalos>
References: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561718355-13919-2-git-send-email-ilias.apalodimas@linaro.org>
 <20190628150434.30da8852@carbon>
 <20190628.094343.1065314747200152509.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628.094343.1065314747200152509.davem@davemloft.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, 

> >> Use page_pool and it's DMA mapping capabilities for Rx buffers instead
> >> of netdev/napi_alloc_frag()
> >> 
> >> Although this will result in a slight performance penalty on small sized
> >> packets (~10%) the use of the API will allow to easily add XDP support.
> >> The penalty won't be visible in network testing i.e ipef/netperf etc, it
> >> only happens during raw packet drops.
> >> Furthermore we intend to add recycling capabilities on the API
> >> in the future. Once the recycling is added the performance penalty will
> >> go away.
> >> The only 'real' penalty is the slightly increased memory usage, since we
> >> now allocate a page per packet instead of the amount of bytes we need +
> >> skb metadata (difference is roughly 2kb per packet).
> >> With a minimum of 4BG of RAM on the only SoC that has this NIC the
> >> extra memory usage is negligible (a bit more on 64K pages)
> >> 
> >> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> >> ---
> >>  drivers/net/ethernet/socionext/Kconfig  |   1 +
> >>  drivers/net/ethernet/socionext/netsec.c | 121 +++++++++++++++---------
> >>  2 files changed, 75 insertions(+), 47 deletions(-)
> > 
> > Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> Jesper this is confusing, you just asked if the code needs to be moved
> around to be correct and then right now immediately afterwards you ACK
> the patch.
I can answer on the driver, page_pool_free() needs re-arranging indeed.
I'll fix it and post a V2. I guess Jesper meant 'acked-if-fixed' so i can it on
V2


Thanks
/Ilias



