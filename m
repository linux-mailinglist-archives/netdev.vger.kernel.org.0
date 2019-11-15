Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF5FEFD7AA
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 09:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfKOIGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 03:06:20 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33797 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbfKOIGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 03:06:19 -0500
Received: by mail-wr1-f67.google.com with SMTP id e6so9926465wrw.1
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 00:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a0U+sPvL8Cn+hswtwRT1IPFr32mhGDBEbT4cUpTK/fQ=;
        b=g8+V5qTBrE4aUEOgRY9IQpOEBvXzhEO3Tuir8b0L85AihmNm+IB/P7IW6HOYKQ25K8
         r0nlHXjaFqUb13ewgGmpAvQvuiYGamVyT7GGeglJcuQdVz1LNneQh+uZIL2QcGHMzeGB
         WDLP06mzZeonboAb4G5zTGSKY7lXLoLGfVgVzPdFX3T6Nx7utL+J3a9WJU9GCQ5lqVfy
         Nuz/SOmjcdYJ/WeGxK070h/7jtiUJzRb4rgas8yVxGkHVC/cNkQuSo0HzaI/HP/EUHCW
         f82mdhEqqCE+R3Y5j3hM21ixPxtUT4ZO3lPQ/O8Ub/HO3SpsuFNmk1D/ajBZkvAJYAJA
         nStw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a0U+sPvL8Cn+hswtwRT1IPFr32mhGDBEbT4cUpTK/fQ=;
        b=qIQyNSbmAgqCXVEJE3zBbNQkw+Gttbk18qwwTlbWg+9u9u+XNFEx8B0obVk92YGPQt
         hZ3TvxZ5mLNowgZWRql7OS49Ia64amT56/5TQQcG5UAdK3DCr2c4ofMWMGo109xWwrfP
         GVJmfwlkXIKcbS3lPzIsxvILCQo9iFmBIQHFiZMLDTAQYO9GvYvC59JnR8807xO1fzIY
         zSrcFRCwKMoXW7FhzkX9qWKEGoNjy1ZF54obgwWo6EChcKNfabs32ZSfZA52SOR/gwuE
         n9b1jVH1C3snYqHx88WopF8nloMcDa7JDL75BmX70AYn7MQVifHPt2t0CEHHKaXob0Nc
         pI2w==
X-Gm-Message-State: APjAAAWT00tlkbOl2cyA+HeWC1ltQjNLKZ8vSglCyPRz1RDNWmSrb953
        O8QnyCZhM9B1QuKrUFYv6nsFsfWQeog=
X-Google-Smtp-Source: APXvYqxVoOJ1Qx1boHe6xCOIwhPYlY1HyC19PPJqL1odlEPah/xIHyejIwgI/IGGLxpGSfvLiZsosA==
X-Received: by 2002:adf:f282:: with SMTP id k2mr14193909wro.387.1573805176570;
        Fri, 15 Nov 2019 00:06:16 -0800 (PST)
Received: from PC192.168.49.172 (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id p4sm10843248wrx.71.2019.11.15.00.06.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 00:06:15 -0800 (PST)
Date:   Fri, 15 Nov 2019 10:03:52 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        matteo.croce@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to sync
 DMA memory for non-coherent devices
Message-ID: <20191115080352.GA45399@PC192.168.49.172>
References: <cover.1573383212.git.lorenzo@kernel.org>
 <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
 <6BF4C165-2AA2-49CC-B452-756CD0830129@gmail.com>
 <20191114185326.GA43048@PC192.168.49.172>
 <3648E256-C048-4F74-90FB-94D184B26499@gmail.com>
 <20191114204227.GA43707@PC192.168.49.172>
 <ECC7645D-082A-4590-9339-C45949E10C4D@gmail.com>
 <20191114224309.649dfacb@carbon>
 <20191115070551.GA99458@apalos.home>
 <20191115074743.GB10037@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115074743.GB10037@localhost.localdomain>
User-Agent: Mutt/1.9.5 (2018-04-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo, 

> > > > >>>> How about using PP_FLAG_DMA_SYNC instead of another flag word?
> > > > >>>> (then it can also be gated on having DMA_MAP enabled)  
> > > > >>>
> > > > >>> You mean instead of the u8?
> > > > >>> As you pointed out on your V2 comment of the mail, some cards don't 
> > > > >>> sync back to device.
> > > > >>>
> > > > >>> As the API tries to be generic a u8 was choosen instead of a flag
> > > > >>> to cover these use cases. So in time we'll change the semantics of
> > > > >>> this to 'always sync', 'dont sync if it's an skb-only queue' etc.
> > > > >>>
> > > > >>> The first case Lorenzo covered is sync the required len only instead 
> > > > >>> of the full buffer  
> > > > >>
> > > > >> Yes, I meant instead of:
> > > > >> +		.sync = 1,
> > > > >>
> > > > >> Something like:
> > > > >>         .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC
> > > > >>
> > > 
> > > I actually agree and think we could use a flag. I suggest
> > > PP_FLAG_DMA_SYNC_DEV to indicate that this DMA-sync-for-device.
> > > 
> > > Ilias notice that the change I requested to Lorenzo, that dma_sync_size
> > > default value is 0xFFFFFFFF (-1).  That makes dma_sync_size==0 a valid
> > > value, which you can use in the cases, where you know that nobody have
> > > written into the data-area.  This allow us to selectively choose it for
> > > these cases.
> > 
> > Okay, then i guess the flag is a better fit for this.
> > The only difference would be that the sync semantics will be done on 'per
> > packet' basis,  instead of 'per pool', but that should be fine for our cases.
> 
> Ack, fine for me.
> Do you think when checking for PP_FLAG_DMA_SYNC_DEV we should even verify
> PP_FLAG_DMA_MAP? Something like:
> 
> if ((pool->p.flags & (PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)) ==
>     (PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV))
> 	page_pool_dma_sync_for_device();
> 
> Regards,
> Lorenzo

I think it's better to do the check once on the pool registration and maybe
refuse to allocate the pool? Syncing without mapping doesn't really make sense

Cheers
/Ilias
> 
> > 
> > Cheers
> > /Ilias
> > > 
> > > -- 
> > > Best regards,
> > >   Jesper Dangaard Brouer
> > >   MSc.CS, Principal Kernel Engineer at Red Hat
> > >   LinkedIn: http://www.linkedin.com/in/brouer
> > > 
> > 


