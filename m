Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F5D46789A
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 14:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238691AbhLCNnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 08:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352356AbhLCNnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 08:43:21 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F92EC061757
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 05:39:57 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id m25-20020a7bcb99000000b0033aa12cdd33so4544421wmi.1
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 05:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ohIQaB84LArJ7RMWDRu6/DrUHfyigZQ0XOc04IPMQVk=;
        b=UBjV1JNjo+S+Dqw5OKdqx8IJXaq/sEdsuodIgLgKBn/FMM/115dr8inkmNRMaFktRx
         qV/2M+rRnzmZeNF55CRVS/DKFARRRD7rjPycyX6pVVv87nLHWrvjgiSGdBvauwBsxLwQ
         5PdaphjcFbipsdGa8i8JkULKDRXUusLzAlatusPjyOdYy7Og+oIAg/M0ophB5qLgQSBp
         SHnEZbJLdn8cgpzDU/tWt8ecxu5M9O/a8oleagBTWHWHpnSLmKg5DmghD+BFj7K0jsya
         WsbN/TdPHASAKywU0BfQSn1K3qLymyN9QmUZUA7/GlPbGXvRk8Qp0Ic+RvrDlIAGQlUU
         sshA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ohIQaB84LArJ7RMWDRu6/DrUHfyigZQ0XOc04IPMQVk=;
        b=uEywBsrEOyWNd2yE67TkBXyvOBprhwwgtMRb48GgmCRlfnoA/70Qkxd7LFrG9vlDcS
         ecuQPFRqmnQ3SeKnJnSHHIvebMk1pw9OvASO3AhKK2F4zRdViEm47P2vE+jn+1gfWA3c
         fAlGxJgfWK2uHE7aq2pCBqJrMOl/3KeWNzZ7XGDRlFZyxQOgX/8SHjFk6gUFc9HGY7OM
         vTgF0iclet3CB5mgNBMwQkeYl9fzqHyfwvkt2yI5DEjJnf9r+swBAnjHtTddnhgcQYBq
         TnRlRC8AKS4fzqhMf2le/QsTEWmpM/TBYcuWeYBLE+5I00lkSYbntQsewh7X92jBJmeT
         VWtQ==
X-Gm-Message-State: AOAM531WiU+7p9Lfx7seOPHbdG5r5Z4XS9qX9qJNWXjdki3uXRYUHrHy
        mfs3qPwCNQDAaViTDkVIHxsj3w==
X-Google-Smtp-Source: ABdhPJxwZDbDcKhAQgTLmFrplkYEpzZy5KyrNtYNt3ZDhm67WxoFiqVIJTBcXGvHKyIILhAkeAZFww==
X-Received: by 2002:a1c:a301:: with SMTP id m1mr15235234wme.118.1638538796060;
        Fri, 03 Dec 2021 05:39:56 -0800 (PST)
Received: from google.com ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id g13sm2601664wmk.37.2021.12.03.05.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 05:39:55 -0800 (PST)
Date:   Fri, 3 Dec 2021 13:39:53 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset
 or zero
Message-ID: <YaoeKfmJrDPhMXWp@google.com>
References: <20211202143437.1411410-1-lee.jones@linaro.org>
 <20211202175134.5b463e18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87o85yj81l.fsf@miraculix.mork.no>
 <Yan+nvfyS21z7ZUw@google.com>
 <87ilw5kfrm.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ilw5kfrm.fsf@miraculix.mork.no>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 03 Dec 2021, Bjørn Mork wrote:
> >> It's been a while since I looked at this, so excuse me if I read it
> >> wrongly.  But I think we need to catch more illegal/impossible values
> >> than just zero here?  Any buffer size which cannot hold a single
> >> datagram is pointless.
> >> 
> >> Trying to figure out what I possible meant to do with that
> >> 
> >>  	min = min(min, max);
> >> 
> >> I don't think it makes any sense?  Does it?  The "min" value we've
> >> carefully calculated allow one max sized datagram and headers. I don't
> >> think we should ever continue with a smaller buffer than that
> >
> > I was more confused with the comment you added to that code:
> >
> >    /* some devices set dwNtbOutMaxSize too low for the above default */
> >    min = min(min, max);
> >
> > ... which looks as though it should solve the issue of an inadequate
> > dwNtbOutMaxSize, but it almost does the opposite.
> 
> That's what I read too.  I must admit that I cannot remember writing any
> of this stuff.  But I trust git...

In Git we trust!

> > I initially
> > changed this segment to use the max() macro instead, but the
> > subsequent clamp_t() macro simply chooses 'max' (0) value over the now
> > sane 'min' one.
> 
> Yes, but what if we adjust max here instead of min?

That's what my patch does.

> > Which is why I chose 
> >> Or are there cases where this is valid?
> >
> > I'm not an expert on the SKB code, but in my simple view of the world,
> > if you wish to use a buffer for any amount of data, you should
> > allocate space for it.
> >
> >> So that really should haven been catching this bug with a
> >> 
> >>   max = max(min, max)
> >
> > I tried this.  It didn't work either.
> >
> > See the subsequent clamp_t() call a few lines down.
> 
> This I don't understand.  If we have for example
> 
>  new_tx = 0
>  max = 0
>  min = 1514(=datagram) + 8(=ndp) + 2(=1+1) * 4(=dpe) + 12(=nth) = 1542
> 
> then
> 
>  max = max(min, max) = 1542
>  val = clamp_t(u32, new_tx, min, max) = 1542
> 
> so we return 1542 and everything is fine.

I don't believe so.

#define clamp_t(type, val, lo, hi) \
              min_t(type, max_t(type, val, lo), hi)

So:
              min_t(u32, max_t(u32, 0, 1542), 0)

So:
	      min_t(u32, 1542, 0) = 0

So we return 0 and everything is not fine. :)

Perhaps we should use max_t() here instead of clamp?

> >> or maybe more readable
> >> 
> >>   if (max < min)
> >>      max = min
> >> 
> >> What do you think?
> >
> > So the data that is added to the SKB is ctx->max_ndp_size, which is
> > allocated in cdc_ncm_init().  The code that does it looks like:
> >
> >    if (ctx->is_ndp16)                                                                                         
> >         ctx->max_ndp_size = sizeof(struct usb_cdc_ncm_ndp16) +
> > 	                    (ctx->tx_max_datagrams + 1) *
> > 			    sizeof(struct usb_cdc_ncm_dpe16);                                                                                               
> >     else                                                                                                       
> >         ctx->max_ndp_size = sizeof(struct usb_cdc_ncm_ndp32) +
> > 	                    (ctx->tx_max_datagrams + 1) *
> > 			    sizeof(struct usb_cdc_ncm_dpe32);  
> >
> > So this should be the size of the allocation too, right?
> 
> This driver doesn't add data to the skb.  It allocates a new buffer and
> copies one or more skbs into it.  I'm sure that could be improved too..

"one or more skbs" == data :)

Either way, it's asking for more bits to be copied in than there is
space for.  It's amazing that this worked at all.  We only noticed it
when we increased the size of one of the SKB headers and some of the
accidentally allocated memory was eaten up.

> Without a complete rewrite we need to allocate new skbs large enough to hold
> 
> NTH          - frame header
> NDP x 1      - index table, with minimum two entries (1 datagram + terminator)
> datagram x 1 - ethernet frame
> 
> This gives the minimum "tx_max" value.
> 
> The device is supposed to tell us the maximum "tx_max" value in
> dwNtbOutMaxSize.  In theory.  In practice we cannot trust the device, as
> you point out.  We know aleady deal with too large values (which are
> commonly seen in real products), but we also need to deal with too low
> values.
> 
> I believe the "too low" is defined by the calculated minimum value, and
> the comment indicates that this what I tried to express but failed.

Right, that's how I read it too.

> > Why would the platform ever need to over-ride this?  The platform
> > can't make the data area smaller since there won't be enough room.  It
> > could perhaps make it bigger, but the min_t() and clamp_t() macros
> > will end up choosing the above allocation anyway.
> >
> > This leaves me feeling a little perplexed.
> >
> > If there isn't a good reason for over-riding then I could simplify
> > cdc_ncm_check_tx_max() greatly.
> >
> > What do *you* think? :)
> 
> I also have the feeling that this could and should be simplified. This
> discussion shows that refactoring is required.

I'm happy to help with the coding, if we agree on a solution.

> git blame makes this all too embarrassing ;-)

:D

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
