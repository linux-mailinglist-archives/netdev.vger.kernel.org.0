Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF4DFCFA5
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 21:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfKNU1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 15:27:43 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38096 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfKNU1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 15:27:43 -0500
Received: by mail-pf1-f193.google.com with SMTP id c13so5071095pfp.5
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 12:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=dEU776sqvEqf63FyZHaxMoM1yxhqsrxknj0XsvdhvCU=;
        b=fyxcm7hbOjZqQaa0GmvKeCbGa50e0C0XXHJONWMIsKp78eyVXI32g7qFvPbR/qImAd
         oNCpzSH9J5SIYsd8qeIgLZr5d0tlyTZwnfGqBqEKONiNl+DjtO9xf808wTOaTt+qX0Yf
         QSjsYFOy+1P0QD4RjklM5o8Cx/AHI/7+vviRDXCoC58R7wS5JpYF5QWRQGZGJHY06em3
         +mgg904LDNKKZM9HIAkio+YE5Du8BEcHjyFJzvciTc8q3tJ5pqijwYH7tvjyGthux/WY
         KQXAVqC7jtPMAODpeaNWmdgOS6uzzTttbVdDPxh+p5hY+G/y7LJ80E+c4yJpzBaLRTs3
         hYBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=dEU776sqvEqf63FyZHaxMoM1yxhqsrxknj0XsvdhvCU=;
        b=EsYtHom4o1MCOYA9gCPD+hzWqe5phvq+mkBFOlnTdHq6h1bpSDMzVQVAO4tAUjqh/d
         TfzEDhv6KNk56wnTmaYP6acoxABCQGhFSKi3IXBHv+88mU7Rh2qMW9S5MStCryICovnT
         4RMxwL0P/bydnhogQHY808qCEHSmyZ+7ufuiZ2gsl2JlEWJMXkLNTLTzHK7EUBJLyXyN
         d7A9oN0ttEbq/CPy/rbz3Py6aOw3lVVwf7HKE0cfscgbGN8IjFYpi/piXNbXWV1ryx6u
         XcXKyA/bbxCSfmXcLi1V8vruuzHM1PGJhls6gfJAHa8ZUX7pv6CI0206RvL7rtR+yaZj
         4HPQ==
X-Gm-Message-State: APjAAAVBFyRzgjNIU8WlcHof6B8X2stzHic5vRgRoxbowkZ2JytUu9uF
        aWQq2Nd7TGZkMAai28QykqA=
X-Google-Smtp-Source: APXvYqzqThj73OAh5LfRFwp9aSat7NrjYWiOfhCuCAYzcr/7+Ub3XyW9xY5yx+FjFOeDM4lqJkscnw==
X-Received: by 2002:a62:1517:: with SMTP id 23mr13162944pfv.236.1573763262496;
        Thu, 14 Nov 2019 12:27:42 -0800 (PST)
Received: from [172.20.189.1] ([2620:10d:c090:180::dd67])
        by smtp.gmail.com with ESMTPSA id p123sm8030459pfg.30.2019.11.14.12.27.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 12:27:41 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Cc:     "Lorenzo Bianconi" <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        matteo.croce@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to sync
 DMA memory for non-coherent devices
Date:   Thu, 14 Nov 2019 12:27:40 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <3648E256-C048-4F74-90FB-94D184B26499@gmail.com>
In-Reply-To: <20191114185326.GA43048@PC192.168.49.172>
References: <cover.1573383212.git.lorenzo@kernel.org>
 <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
 <6BF4C165-2AA2-49CC-B452-756CD0830129@gmail.com>
 <20191114185326.GA43048@PC192.168.49.172>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14 Nov 2019, at 10:53, Ilias Apalodimas wrote:

> [...]
>>> index 2cbcdbdec254..defbfd90ab46 100644
>>> --- a/include/net/page_pool.h
>>> +++ b/include/net/page_pool.h
>>> @@ -65,6 +65,9 @@ struct page_pool_params {
>>>  	int		nid;  /* Numa node id to allocate from pages from */
>>>  	struct device	*dev; /* device, for DMA pre-mapping purposes */
>>>  	enum dma_data_direction dma_dir; /* DMA mapping direction */
>>> +	unsigned int	max_len; /* max DMA sync memory size */
>>> +	unsigned int	offset;  /* DMA addr offset */
>>> +	u8 sync;
>>>  };
>>
>> How about using PP_FLAG_DMA_SYNC instead of another flag word?
>> (then it can also be gated on having DMA_MAP enabled)
>
> You mean instead of the u8?
> As you pointed out on your V2 comment of the mail, some cards don't 
> sync back to
> device.
> As the API tries to be generic a u8 was choosen instead of a flag to 
> cover these
> use cases. So in time we'll change the semantics of this to 'always 
> sync', 'dont
> sync if it's an skb-only queue' etc.
> The first case Lorenzo covered is sync the required len only instead 
> of the full
> buffer

Yes, I meant instead of:
+		.sync = 1,

Something like:
         .flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC

Since .sync alone doesn't make sense if the page pool isn't performing 
any
DMA mapping, right?  Then existing drivers, if they're converted, can 
just
add the SYNC flag.

I did see the initial case where only the RX_BUF_SIZE (1536) is sync'd
instead of the full page.

Could you expand on your 'skb-only queue' comment?  I'm currently 
running
a variant of your patch where iommu mapped pages are attached to skb's 
and
sent up the stack, then reclaimed on release.  I imagine that with this
change, they would have the full RX_BUF_SIZE sync'd before returning to 
the
driver, since the upper layers could basically do anything with the 
buffer
area.
-- 
Jonathan
