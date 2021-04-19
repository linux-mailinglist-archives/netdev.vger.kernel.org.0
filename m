Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762B8363C4C
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 09:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237670AbhDSHQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 03:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237562AbhDSHQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 03:16:34 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143E3C061761
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 00:16:03 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id w23so35459769ejb.9
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 00:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NN0SIfMjTxjZbQRx0YAvjqNr/mU2jjCeZfOuWM1TKQg=;
        b=eey/l+RHXKvQeN6pj97BCplXIBEybQcxN3b7FvQmF61jOBhQh1L3SEeQQ75h/2HdsS
         lvYIqu8K+q2WjsDlLAeK9Wnb1NF6cyeqhlkGq0FPAm8DlUPS+AQFo/NJsd07cj0Q3ZlL
         w8WQ5kpSsHEVNjJVZ5gBLqQKoIsyvcX+/cFN8KMQZ3Iv///hFKsd8BwPgREnubNCqPL5
         Dv9i0qdko+0u1NPVIEUTdH9QkepmL8RujKMziiyLsXYQvB3kYOx688e/XZFtgAngxGsq
         QiydkHhZuGPAi067UJ3NLgK8UACRsB/vwxJjcJLrUCb9fFPP+3Jmcp+S2QopZl9iPKxG
         oZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NN0SIfMjTxjZbQRx0YAvjqNr/mU2jjCeZfOuWM1TKQg=;
        b=S1RdUq8ikdNEo55N5B9QE9KpwS53P94xg8blgLB4dFKpwghU1XczlCgreC0LnZAygE
         4CyYszoCluHcv2QgFlMlZ0BR497emgOy3cB0JRjaCHCHG9PbGkhGOcUuabdD9mB09yeX
         HAOHIR/s5AdFhj8T0NjXflCm+7LF6GXqt2zjdytKDDwn+UNuPbWFyADg7jHa3GnxtQgQ
         0joLL5Xk1TghKLirTFqA60AO1PtGn27hXIBpqLPWSwgGGaNJdjj+xV4a3v92xbxYOpas
         zOATuV10jE3yrXVX1gsNn11IHREyeMqb1kaxZ/o2UfUCPtNZrL4i3kE3hHu12N5sES0b
         vyzA==
X-Gm-Message-State: AOAM532lrwzGOV2uSTyO2gnsw5NkAjCC8SjWDYh+jtUriCS0ZqVhjQHT
        GLc+MayBl3oU6Q5BR/HAJYse8w==
X-Google-Smtp-Source: ABdhPJzED7HcLyGFPWdG5U4GtxJ9nU13WoMu/wsaNmOE8Ia2aHE+xQgk+fFtK5iYslBsmLLlnWZE0A==
X-Received: by 2002:a17:906:d109:: with SMTP id b9mr1894772ejz.548.1618816561662;
        Mon, 19 Apr 2021 00:16:01 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-88.home.otenet.gr. [94.65.92.88])
        by smtp.gmail.com with ESMTPSA id q10sm8586361eds.26.2021.04.19.00.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 00:16:01 -0700 (PDT)
Date:   Mon, 19 Apr 2021 10:15:58 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <YH0uLsnzdE9ya6kw@apalos.home>
References: <20210411103318.GC2531743@casper.infradead.org>
 <20210412011532.GG2531743@casper.infradead.org>
 <20210414101044.19da09df@carbon>
 <20210414115052.GS2531743@casper.infradead.org>
 <20210414211322.3799afd4@carbon>
 <20210414213556.GY2531743@casper.infradead.org>
 <a50c3156fe8943ef964db4345344862f@AcuMS.aculab.com>
 <20210415200832.32796445@carbon>
 <20210416152755.GL2531743@casper.infradead.org>
 <20210419063441.GA18787@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419063441.GA18787@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

On Mon, Apr 19, 2021 at 08:34:41AM +0200, Christoph Hellwig wrote:
> On Fri, Apr 16, 2021 at 04:27:55PM +0100, Matthew Wilcox wrote:
> > On Thu, Apr 15, 2021 at 08:08:32PM +0200, Jesper Dangaard Brouer wrote:
> > > See below patch.  Where I swap32 the dma address to satisfy
> > > page->compound having bit zero cleared. (It is the simplest fix I could
> > > come up with).
> > 
> > I think this is slightly simpler, and as a bonus code that assumes the
> > old layout won't compile.
> 
> So, why do we even do this crappy overlay of a dma address?  This just
> all seems like a giant hack.  Random subsystems should not just steal
> a few struct page fields as that just turns into the desasters like the
> one we've seen here or probably something worse next time.

The page pool API was using page->private in the past to store these kind of
info. That caused a problem to begin with, since it would fail  on 32-bit
systems with 64bit DMA.  We had a similar discussion on the past but decided
struct page is the right place to store that [1].

Another advantage is that we can now use the information from the networking 
subsystem and enable recycling of SKBs and SKB fragments, by using the stored 
metadata of struct page [2].

[1] https://lore.kernel.org/netdev/20190207.132519.1698007650891404763.davem@davemloft.net/
[2] https://lore.kernel.org/netdev/20210409223801.104657-1-mcroce@linux.microsoft.com/

Cheers
/Ilias
