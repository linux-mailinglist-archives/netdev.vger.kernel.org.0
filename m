Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70139FD6B7
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 08:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKOHF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 02:05:58 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44462 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfKOHF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 02:05:58 -0500
Received: by mail-wr1-f67.google.com with SMTP id f2so9724125wrs.11
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 23:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nAnIAGGtHw/Q6fcxh521kpfEKNfp0OkyR1BXBR5vZr8=;
        b=epMSIpQZm2eg5htR3zm0YVV7KRqO/COeXSxY0GC//N87jRkKVocH3wE7OZCtfegad/
         qxLZeUOvvb5ZOw/74Wb1t6Fnolz16I9Ap+adWanq7VGNgGPfORSKgGKyugHmL/rSDMZx
         lSKp5g5WJFce2iPrCBgsc9t4aAGVbWeuKU86mSFSpVaBl8ugFd/7aZq1NFBvyMKrkXPa
         ohTwvkFl5ut4eT+VYGz5HggJcaQCMn12U10L3kOe6/OJCavjQ/PcC3ZiW0IJ2bLUvv5S
         cxJIb+sy+LH6BkmBlX5I7Onmre1u0gvmUKrROudUeNietDHqlwolQNLxS2b7AECPEMrX
         pMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nAnIAGGtHw/Q6fcxh521kpfEKNfp0OkyR1BXBR5vZr8=;
        b=Dl5w7Lv0L5VnzbQLpQKgWGkRuLvN45MeeMdc+jZPR7oy+WKls3DWZcCXVSfPa9jZ5L
         N0hmX3ScbEwXqEsR/h1ggaa0TSrv8JGV3kPis/Gt2NqowfN5HiU7nFbf4OmBsMzufibz
         e06w49FjqNaJ+QwEshS2SEta1Yf6Vvb0Wp4BHuyXnHtDEJM/Vrg0zrcAS9yd8E5b2L/n
         3VC5bzsrDl8WHaF9vNZlTEIJeQqLuLDourLr42ACxlAAUwg/G0HtZFBg6u7Dq7DBxBhS
         7uMuxTIt28Elxx1SRDuJvucFoCPC9lUPDuS0ffwK3aF6LviE+7dYHaBvuEQ1mkIsadeB
         GMrQ==
X-Gm-Message-State: APjAAAVCYiNXTzCfVmZ5aKk95PWdRK2zT2dR6B3ZvXlJG1mEj2tcoGdR
        4XjlLqZfD8um06xSok5cJK/T0w==
X-Google-Smtp-Source: APXvYqx+nNTSDyhwWKJZmyth/aGk4+F9kXjeHxCo7PoXMJPukRLInRhgxTFw39mHlHK1i8NlpuqtIw==
X-Received: by 2002:a5d:530f:: with SMTP id e15mr5854516wrv.119.1573801554510;
        Thu, 14 Nov 2019 23:05:54 -0800 (PST)
Received: from apalos.home (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id p14sm10626640wrq.72.2019.11.14.23.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 23:05:53 -0800 (PST)
Date:   Fri, 15 Nov 2019 09:05:51 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, matteo.croce@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to sync
 DMA memory for non-coherent devices
Message-ID: <20191115070551.GA99458@apalos.home>
References: <cover.1573383212.git.lorenzo@kernel.org>
 <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
 <6BF4C165-2AA2-49CC-B452-756CD0830129@gmail.com>
 <20191114185326.GA43048@PC192.168.49.172>
 <3648E256-C048-4F74-90FB-94D184B26499@gmail.com>
 <20191114204227.GA43707@PC192.168.49.172>
 <ECC7645D-082A-4590-9339-C45949E10C4D@gmail.com>
 <20191114224309.649dfacb@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114224309.649dfacb@carbon>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 10:43:09PM +0100, Jesper Dangaard Brouer wrote:
> On Thu, 14 Nov 2019 13:04:26 -0800
> "Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:
> 
> > On 14 Nov 2019, at 12:42, Ilias Apalodimas wrote:
> > 
> > > Hi Jonathan,
> > >
> > > On Thu, Nov 14, 2019 at 12:27:40PM -0800, Jonathan Lemon wrote:  
> > >>
> > >>
> > >> On 14 Nov 2019, at 10:53, Ilias Apalodimas wrote:
> > >>  
> > >>> [...]  
> > >>>>> index 2cbcdbdec254..defbfd90ab46 100644
> > >>>>> --- a/include/net/page_pool.h
> > >>>>> +++ b/include/net/page_pool.h
> > >>>>> @@ -65,6 +65,9 @@ struct page_pool_params {
> > >>>>>  	int		nid;  /* Numa node id to allocate from pages from */
> > >>>>>  	struct device	*dev; /* device, for DMA pre-mapping purposes */
> > >>>>>  	enum dma_data_direction dma_dir; /* DMA mapping direction */
> > >>>>> +	unsigned int	max_len; /* max DMA sync memory size */
> > >>>>> +	unsigned int	offset;  /* DMA addr offset */
> > >>>>> +	u8 sync;
> > >>>>>  };  
> > >>>>
> > >>>> How about using PP_FLAG_DMA_SYNC instead of another flag word?
> > >>>> (then it can also be gated on having DMA_MAP enabled)  
> > >>>
> > >>> You mean instead of the u8?
> > >>> As you pointed out on your V2 comment of the mail, some cards don't 
> > >>> sync back to device.
> > >>>
> > >>> As the API tries to be generic a u8 was choosen instead of a flag
> > >>> to cover these use cases. So in time we'll change the semantics of
> > >>> this to 'always sync', 'dont sync if it's an skb-only queue' etc.
> > >>>
> > >>> The first case Lorenzo covered is sync the required len only instead 
> > >>> of the full buffer  
> > >>
> > >> Yes, I meant instead of:
> > >> +		.sync = 1,
> > >>
> > >> Something like:
> > >>         .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC
> > >>
> 
> I actually agree and think we could use a flag. I suggest
> PP_FLAG_DMA_SYNC_DEV to indicate that this DMA-sync-for-device.
> 
> Ilias notice that the change I requested to Lorenzo, that dma_sync_size
> default value is 0xFFFFFFFF (-1).  That makes dma_sync_size==0 a valid
> value, which you can use in the cases, where you know that nobody have
> written into the data-area.  This allow us to selectively choose it for
> these cases.

Okay, then i guess the flag is a better fit for this.
The only difference would be that the sync semantics will be done on 'per
packet' basis,  instead of 'per pool', but that should be fine for our cases.

Cheers
/Ilias
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
