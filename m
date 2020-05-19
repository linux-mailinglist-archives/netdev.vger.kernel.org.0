Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193931D9128
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 09:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgESHf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 03:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgESHf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 03:35:57 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22065C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 00:35:57 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e1so14669715wrt.5
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 00:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Ge024w0srW5Dqyx+Z5GsjoMzu9gC87CxxyiwG2PXoH8=;
        b=QAenRgyTNbPuet96Mmg1577X+4QhwJ2IPlMOZQ+NyTaHoE56o2dqHrtT2chn7XB6zB
         WL8Src9YPT3HfmvBgXfKdh1uU0EIlpQXENoFDFngv1WiJYhIM89m1Fda9p3aVhEZFHn+
         dH+pvsZQnJJpMNzvUbvJg7oArEeHjhK4u/Jj0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Ge024w0srW5Dqyx+Z5GsjoMzu9gC87CxxyiwG2PXoH8=;
        b=FljjI5k5zXZJoQLiDojFoMy8vE8xetxNOr4luU0SYRebhHzIwIl4Clq7OUrrp8x62C
         TgS+sI55SW/c9y0wHUrZns9kaIEPPIiM1/2jv5OLYKyPMFypJQwLFaxFyuB8SZY8FZvr
         bBGcv4FWOK8ovJTh3lNJ1Dk9clJy56IObzLuQTbh/h826CAud9DjR4OExrY6+XEiqy2x
         ERsvksaPjGTKcoFrrsXk85OxMt3zVOjIV7Qrm8SMvLafQnNoZUmCkCgXCVPSFzfFHE0T
         rkrhuqkCucNK2a/7+Bggfk+XwJAeaKXiaJgAOhpWlwWoe5HYj/sWnhVjSxT6aDYaNRM/
         C2RQ==
X-Gm-Message-State: AOAM530u+hwdlBe4kIFlD4gwhpqdY5svaHubXmrxKhxbHfrkCEwh+Jzz
        HM5N0E5EC6eKoJcCt83DaQ3+v9cqrvI=
X-Google-Smtp-Source: ABdhPJxyRBH2Y3Ae+V1isyAbs1EwA5IU6HXFz4FW/iB0WdbLewn2IYwzO4bDCe1M1o34sdS1UjaemA==
X-Received: by 2002:adf:fac4:: with SMTP id a4mr23066942wrs.134.1589873755049;
        Tue, 19 May 2020 00:35:55 -0700 (PDT)
Received: from noodle ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id p65sm2735373wmp.36.2020.05.19.00.35.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 May 2020 00:35:54 -0700 (PDT)
Date:   Tue, 19 May 2020 10:35:48 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] __netif_receive_skb_core: pass skb by reference
Message-ID: <20200519073547.GA11263@noodle>
References: <20200518090152.GA10405@noodle>
 <66773afc-e802-5af0-a80f-1cd43ecdf041@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <66773afc-e802-5af0-a80f-1cd43ecdf041@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 05:20:13PM +0100, Edward Cree wrote:
> Firstly, please add a Fixes: tag; I expect the relevant commit will be
>  88eb1944e18c ("net: core: propagate SKB lists through packet_type lookup")
>  but I'm not 100% sure so do check that yourself.

You are right, this is the right commit. Fixes tag added.

> Secondly:
> > @@ -5174,6 +5177,7 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
> >  	}
> >  
> >  out:
> > +	*pskb = skb;
> >  	return ret;
> >  }
> Could we have some sort of WARN_ONs (maybe under #ifdef DEBUG) to check
>  that we never have a NULL skb with a non-NULL pt_prev?  Or at least a
>  comment at the top of the function stating this part of its contract
>  with callers?  I've gone through and convinced myself that it never
>  happens currently, but that depends on some fairly subtle details.

I've added the comment at this hunk. The *ppt_prev assignment happens
several lines above and skb is being used right next to it.

Please see v2 of the patch with this changes.

Thanks,
Boris.
