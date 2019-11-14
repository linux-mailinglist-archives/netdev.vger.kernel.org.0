Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8C51FCE2F
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfKNSzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:55:47 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45521 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfKNSzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:55:46 -0500
Received: by mail-wr1-f66.google.com with SMTP id z10so7746047wrs.12
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=opUFnsaebs6C2mFWskfzQsaN37UDV7z/YZ4k3PjDWWQ=;
        b=OhAlL0OHxPq+x6XKcT5P5Da1QG9QnXaU9gyjPliIZ6VlyYG2Xwx45NjjXddyyEmVSA
         RtlpsfKdORapUuk/5AQWCgHDuFki2bmSdUzVr9o2+vpqtdUG53CRb2KPurQBdrbYCewD
         aesalVzktHQE67xQMcfCxxlUQJjt61MjaLfoyxHiFIaYipqcm3LeFVV+I8qWARWRms8c
         RZ123FpSb/i99BxKPo65C9HozW6hLKuR2Xy9frne1aXPgevpEOTSlbXi9C+ZtmOu31h+
         Fx5XHLMV3dkhHF7hSiLmm0e1Vxi8O4mhtQRzbn9WBg2IGev6hHDGGtXEDJBB27z2h5Nt
         BP6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=opUFnsaebs6C2mFWskfzQsaN37UDV7z/YZ4k3PjDWWQ=;
        b=TWVy5vEPFjFGwuDDdXGO7A5ugVGq+6WUwPPTLdjs/rKg+4BvvR1DIqp9zQysc6U57d
         biS86Evy3MRij7woeYUvXaXyZxTSiXSfg3iYvgxeZdJ+eBRVv7evvcecxBhPtEkJeQOp
         FDEPoS5jK6+FNb2KkjPNikkMUer3oIXdlBdwzqw+sNzvCUBP5ViTHmwS9hTo8s1TQnlF
         FbQJn1usqmEYoDodbgS7mQxxx0HSBHqyvOkJymVXE8zb8Rz5h+0oabCVtyR3C57d/iEJ
         saE8GGCdFKfWN5UA7QDzh4RfjzZk13AL0Ej44vB6KxOfQDJ/ywZePP5+xOpT5QQ9oB+i
         G9KA==
X-Gm-Message-State: APjAAAUyGii3K7fT+zB5QvWOy2KyPL3K4KHiFonqs99s5+dmXq72yTWI
        nTBWsmBvMGAeUgV7Fnd/VQDkAA==
X-Google-Smtp-Source: APXvYqzBOvQahMUHsXbDoYo0q1r6KtoujbLVQ6KYmX7hRy6/cPgcahUFhOK4OypXyuz7dSPNcvYypg==
X-Received: by 2002:a05:6000:10c5:: with SMTP id b5mr10408528wrx.121.1573757744601;
        Thu, 14 Nov 2019 10:55:44 -0800 (PST)
Received: from PC192.168.49.172 (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id y6sm8154138wrr.19.2019.11.14.10.55.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 10:55:44 -0800 (PST)
Date:   Thu, 14 Nov 2019 20:53:26 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        matteo.croce@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to sync
 DMA memory for non-coherent devices
Message-ID: <20191114185326.GA43048@PC192.168.49.172>
References: <cover.1573383212.git.lorenzo@kernel.org>
 <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
 <6BF4C165-2AA2-49CC-B452-756CD0830129@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6BF4C165-2AA2-49CC-B452-756CD0830129@gmail.com>
User-Agent: Mutt/1.9.5 (2018-04-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]
> > index 2cbcdbdec254..defbfd90ab46 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -65,6 +65,9 @@ struct page_pool_params {
> >  	int		nid;  /* Numa node id to allocate from pages from */
> >  	struct device	*dev; /* device, for DMA pre-mapping purposes */
> >  	enum dma_data_direction dma_dir; /* DMA mapping direction */
> > +	unsigned int	max_len; /* max DMA sync memory size */
> > +	unsigned int	offset;  /* DMA addr offset */
> > +	u8 sync;
> >  };
> 
> How about using PP_FLAG_DMA_SYNC instead of another flag word?
> (then it can also be gated on having DMA_MAP enabled)

You mean instead of the u8?
As you pointed out on your V2 comment of the mail, some cards don't sync back to
device.
As the API tries to be generic a u8 was choosen instead of a flag to cover these
use cases. So in time we'll change the semantics of this to 'always sync', 'dont
sync if it's an skb-only queue' etc.
The first case Lorenzo covered is sync the required len only instead of the full
buffer


Thanks
/Ilias
