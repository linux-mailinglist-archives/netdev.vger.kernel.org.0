Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67A6D466A
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 19:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfJKRQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 13:16:56 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46263 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbfJKRQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 13:16:56 -0400
Received: by mail-pg1-f195.google.com with SMTP id b8so6130763pgm.13
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 10:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mBriml3iAfauQRKfpDbQ5vaiaD735vODzhiE9KF4g38=;
        b=Ub4xqxEXKetk/JV1WBUC4NL36KIS0kftpqOkawvxIYToHs/vjFe/4YqmK1OFX4mwVo
         5WZGZt2rLF7WoEv9/rKk1L2lAypfxdkDNZURmCUjqBjrGvaf52hFZtm5/mc/Gpr24Pgw
         RhprVxdJwYCDhjbCwracqpkAlx4SYSzsTFq0uOo8Mja/+E6CKL3VmuakLFVdm+41vozu
         3e5tO9+Mrv5hI/8so5sl5ibpgYP8qMaVPtxkyWu4DChlDYcfK35HC8Gf00Rx895FuPSu
         pzyx+lMVujTDx3QDdp0PDixeN3TbKkTqELkl1fY2VXxOXdVnm/4W91qsA2QUz7mI+cOI
         oE9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mBriml3iAfauQRKfpDbQ5vaiaD735vODzhiE9KF4g38=;
        b=EVp33vd2Y6tQY/eNEx4m1R3pHWapHTZauEG0n5qgLqSuYQR72bY02erSvPWl9hf7AI
         ipRDjS8P37rTG4+ZslfN534VhA00rrUMsQKkV3HF5+DHDDTwW8Z6MRy0S7ldLMRabikE
         YyoakntgUOXbpM2ahZXnBp+5KbHFZbuUsaTZA06cMMEmowC3QdKdsJmIJsvRMvUp1W9K
         CxOf3q1V67MR3x2uC6S8of8HWg3fTy96Df5XNU3/i+CwfwaOVUGmYOPuV6eCNebVKG0D
         nJ+0R16YSE4gkq2n/ejTXqYJ28FDw5Gm65Mb7uaptCJsc6CzTlO7G7Gm6AF9LYUUhEyN
         dfNA==
X-Gm-Message-State: APjAAAUGPAzkshMM/pmimOrq9Ti/pfAi28SCyTLRQjZv2JMfEJJToAzn
        sVyUDAzQLDslRpyI3U2U0knDRg==
X-Google-Smtp-Source: APXvYqw5pokzdLc2n6Op+HT2ZfXwi+YPWVWQFGtUwfC3RFA+PjDKcolG6VaPUhE98V4ZPamoeTyVTw==
X-Received: by 2002:a62:870c:: with SMTP id i12mr17524206pfe.247.1570814215586;
        Fri, 11 Oct 2019 10:16:55 -0700 (PDT)
Received: from minitux (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id w134sm9658594pfd.4.2019.10.11.10.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 10:16:54 -0700 (PDT)
Date:   Fri, 11 Oct 2019 10:16:52 -0700
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] ath10k: Correct error check of dma_map_single()
Message-ID: <20191011171652.GF571@minitux>
References: <20191010162653.141303-1-bjorn.andersson@linaro.org>
 <20191011115732.044BF60BE8@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011115732.044BF60BE8@smtp.codeaurora.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 11 Oct 04:57 PDT 2019, Kalle Valo wrote:

> Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> 
> > The return value of dma_map_single() should be checked for errors using
> > dma_mapping_error(), rather than testing for NULL. Correct this.
> > 
> > Fixes: 1807da49733e ("ath10k: wmi: add management tx by reference support over wmi")
> > Cc: stable@vger.kernel.org
> > Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> Did this fix any real bug? Or is this just something found during code review?
> 

CONFIG_DMA_API_DEBUG screamed at us for calling dma_unmap_single()
without ever having called dma_mapping_error() on the return value.

But Govind just pointed out to me that I hastily missed the fact that
this code path leaks the dequeued skb. So I'll respin the patch to fix
both issues at once.

Regards,
Bjorn

> -- 
> https://patchwork.kernel.org/patch/11183923/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
> 
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
