Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7857D90AE4
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbfHPWYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:24:07 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38816 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbfHPWYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:24:07 -0400
Received: by mail-pf1-f195.google.com with SMTP id o70so3816230pfg.5;
        Fri, 16 Aug 2019 15:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z/RL8I+CX00aaoEA3B93OfzM8SWXYflpbq6Zuf69+2Q=;
        b=PCD6NB8TBlV/+xuB6WcPJ6ZvxS8yBi9wwHXyInSFgGxD55G8j3R8gvP+bb7gQEsNel
         UwNGTdYr/oghTCCM65TW7ecBXltVDwyWqZ00zBm7d+o407wI90UM2BCigLgBv0jeZ81O
         lkNJjNOSM64BSGDg9E+zVE5guJUEt9jJZ2g/yKy4nf7mLCjWoD0SQ+ktXySUAosoe4XF
         7R/yLHB0JMOGiJMpzOMQ9YPqLLYK5K7o78nQqxgz1cLOZZLgb/7is+F0K5ME2dGnPUde
         3mN7TuHHVDYc7FP3VXJU1NmS/FejfhOLwpyI+PPnL96RsC4P9x0Fv+xATfQSmMHPr9UB
         mHYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z/RL8I+CX00aaoEA3B93OfzM8SWXYflpbq6Zuf69+2Q=;
        b=D2Q0WW0aWd+nwRUH1I5GCrp8VJ4YCcVAEHEczp/P0R4xzxK5+RgrIcHAbzfLZhQfu1
         kM1001g44ELD2a3C14mCbf/0l/9gK143P3d03jr//21uCHBAp9cEIX4PPG+QHCEfnSrK
         dt2kyzqRfhqhcGrjlE2kpeFPjfHfaFmfKpfXB0ufjRWRvUDtlSN7FDZLKqdwgnkrOY2V
         nAQF+Yd/yeqUV1NigESZnFu+cld7nc6GZ5+g6cIdhiRoaYnYpjHCVbIh5NDTxjPih0iB
         ugh46Jhtne6zu9LILfpJnSvWsBc1KVjN5fmrPRHT70qrDL+/VPSrVo/zS0/9g/bbGbRt
         Mztw==
X-Gm-Message-State: APjAAAWjxY1YDEZGzTiHIhTsVXY7AGE/DJHlHzGSyGwky1QreJ+eC+zo
        0J6xW02Lhsb4G9cOluitI+I=
X-Google-Smtp-Source: APXvYqwfeEddZmSKMzfnbRIkkn5pkJotwXSMMLkGDy7aeLpXD5GJCVFazyjo4DIpIG1cw6MwYNKbuQ==
X-Received: by 2002:a17:90a:e38e:: with SMTP id b14mr9226497pjz.125.1565994246561;
        Fri, 16 Aug 2019 15:24:06 -0700 (PDT)
Received: from Asurada-Nvidia.nvidia.com (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id v21sm7433880pfe.131.2019.08.16.15.24.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Aug 2019 15:24:06 -0700 (PDT)
Date:   Fri, 16 Aug 2019 15:25:07 -0700
From:   Nicolin Chen <nicoleotsuka@gmail.com>
To:     Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Cc:     Christoph Hellwig <hch@lst.de>, kvalo@codeaurora.org,
        davem@davemloft.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, iommu@lists.linux-foundation.org,
        tobias.klausmann@freenet.de
Subject: Re: regression in ath10k dma allocation
Message-ID: <20190816222506.GA24413@Asurada-Nvidia.nvidia.com>
References: <8fe8b415-2d34-0a14-170b-dcb31c162e67@mni.thm.de>
 <20190816164301.GA3629@lst.de>
 <af96ea6a-2b17-9b66-7aba-b7dae5bcbba5@mni.thm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af96ea6a-2b17-9b66-7aba-b7dae5bcbba5@mni.thm.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias

On Fri, Aug 16, 2019 at 10:16:45PM +0200, Tobias Klausmann wrote:
> > do you have CONFIG_DMA_CMA set in your config?  If not please make sure
> > you have this commit in your testing tree, and if the problem still
> > persists it would be a little odd and we'd have to dig deeper:
> > 
> > commit dd3dcede9fa0a0b661ac1f24843f4a1b1317fdb6
> > Author: Nicolin Chen <nicoleotsuka@gmail.com>
> > Date:   Wed May 29 17:54:25 2019 -0700
> > 
> >      dma-contiguous: fix !CONFIG_DMA_CMA version of dma_{alloc, free}_contiguous()

> yes CONFIG_DMA_CMA is set (=y, see attached config), the commit you mention
> above is included, if you have any hints how to go forward, please let me
> know!

For CONFIG_DMA_CMA=y, by judging the log with error code -12, I
feel this one should work for you. Would you please check if it
is included or try it out otherwise?

dma-contiguous: do not overwrite align in dma_alloc_contiguous()
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=c6622a425acd1d2f3a443cd39b490a8777b622d7

Thanks
Nicolin
