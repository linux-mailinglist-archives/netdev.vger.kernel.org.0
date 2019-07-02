Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE855D1B1
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 16:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfGBOYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 10:24:51 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45871 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfGBOYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 10:24:51 -0400
Received: by mail-lj1-f196.google.com with SMTP id m23so17065794lje.12
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 07:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bSHjqClvRfHK2U9qiOj5LIMtdVJcukiMxcH2n03yaCU=;
        b=HFTZp006q8TZVX5sIuJIMOkk1C9wJQO4rJGRAiNBk/2WlyfUJ1rdVQY+PYz0ZhQz3Q
         wT17e2X0kch1+uP8KvE/V1ET2jlNw8aK4cHsN9Zf832n78lQJQUY75gbrep4TC2UbVpA
         axaAvW+VgyPKfoktsN3yY2BkGI/5aoxuUHGyQG0WSr2OOvsF8q/VePxkmkaj/PJRO9vE
         rGWXVn0dbCitwyb/iSKcxQgRgC7wf16i4cJRuO/qWn8T4MKiDjladJV35U+7gNDPkgpt
         /fHPgF/QGWi5AyHp75MflzSGf05Yw5Z8bbdVS03YBHG/wVa/f2iIl+T0k5Bb5yqMYZdq
         I35A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=bSHjqClvRfHK2U9qiOj5LIMtdVJcukiMxcH2n03yaCU=;
        b=PdI74saUIxDcLDLHtTYKfG5pwiTlKIEqqw5o3lPZAuto4i5ttuI2mDJzSI2Pxw5ovh
         +coRNAkjCPLTx2ODZL+A9fQLcU+gb+vCLYyPYAaX2b8Xd8iYXnlam9amSXoEy8vKnL78
         aI/T8dmqI5N2cuUEcoUMCKjK7ObhY41qRgWs1IlowwM1a0pJ/EzWOPsbxJT/ybzXiSD4
         dUUniICIaIEVHZJm8lH943+5QftjvoCmIhw5u8bBHNSXObBl8n3YM1kxN6HrMfqAIRXY
         /fYylNQznP9OQS16mGQfgsJkUbnv2zuCLM+5FrpG5tZfhe5qB72mKyNPtbnf2CGLZg0N
         gnJA==
X-Gm-Message-State: APjAAAWw5b1q+IfmxTyyho5DaoFfTNpNAH1Bi/bFbK+4sQDvB3DghK/P
        IcX0MFSkB82NFQyULkQvLkuESQ==
X-Google-Smtp-Source: APXvYqznUXLZarmJq51xBmcNdfHn/7nzoCiQ/8SROQ+yDmBZCj4RCuLLzIa94kh5HISHvcZ/J8lmOA==
X-Received: by 2002:a2e:9a96:: with SMTP id p22mr17345327lji.57.1562077488680;
        Tue, 02 Jul 2019 07:24:48 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id w28sm3817013ljd.12.2019.07.02.07.24.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 07:24:48 -0700 (PDT)
Date:   Tue, 2 Jul 2019 17:24:46 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH v5 net-next 6/6] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190702142444.GC4510@khorivan>
Mail-Followup-To: Jesper Dangaard Brouer <brouer@redhat.com>,
        grygorii.strashko@ti.com, davem@davemloft.net, ast@kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com
References: <20190630172348.5692-1-ivan.khoronzhuk@linaro.org>
 <20190630172348.5692-7-ivan.khoronzhuk@linaro.org>
 <20190701181901.150c0b71@carbon>
 <20190702113738.GB4510@khorivan>
 <20190702153902.0e42b0b2@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190702153902.0e42b0b2@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 03:39:02PM +0200, Jesper Dangaard Brouer wrote:
>On Tue, 2 Jul 2019 14:37:39 +0300
>Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> On Mon, Jul 01, 2019 at 06:19:01PM +0200, Jesper Dangaard Brouer wrote:
>> >On Sun, 30 Jun 2019 20:23:48 +0300
>> >Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>> >
>> >> +static int cpsw_ndev_create_xdp_rxq(struct cpsw_priv *priv, int ch)
>> >> +{
>> >> +	struct cpsw_common *cpsw = priv->cpsw;
>> >> +	int ret, new_pool = false;
>> >> +	struct xdp_rxq_info *rxq;
>> >> +
>> >> +	rxq = &priv->xdp_rxq[ch];
>> >> +
>> >> +	ret = xdp_rxq_info_reg(rxq, priv->ndev, ch);
>> >> +	if (ret)
>> >> +		return ret;
>> >> +
>> >> +	if (!cpsw->page_pool[ch]) {
>> >> +		ret =  cpsw_create_rx_pool(cpsw, ch);
>> >> +		if (ret)
>> >> +			goto err_rxq;
>> >> +
>> >> +		new_pool = true;
>> >> +	}
>> >> +
>> >> +	ret = xdp_rxq_info_reg_mem_model(rxq, MEM_TYPE_PAGE_POOL,
>> >> +					 cpsw->page_pool[ch]);
>> >> +	if (!ret)
>> >> +		return 0;
>> >> +
>> >> +	if (new_pool) {
>> >> +		page_pool_free(cpsw->page_pool[ch]);
>> >> +		cpsw->page_pool[ch] = NULL;
>> >> +	}
>> >> +
>> >> +err_rxq:
>> >> +	xdp_rxq_info_unreg(rxq);
>> >> +	return ret;
>> >> +}
>> >
>> >Looking at this, and Ilias'es XDP-netsec error handling path, it might
>> >be a mistake that I removed page_pool_destroy() and instead put the
>> >responsibility on xdp_rxq_info_unreg().
>>
>> As for me this is started not from page_pool_free, but rather from calling
>> unreg_mem_model from rxq_info_unreg. Then, if page_pool_free is hidden
>> it looks more a while normal to move all chain to be self destroyed.
>>
>> >
>> >As here, we have to detect if page_pool_create() was a success, and then
>> >if xdp_rxq_info_reg_mem_model() was a failure, explicitly call
>> >page_pool_free() because the xdp_rxq_info_unreg() call cannot "free"
>> >the page_pool object given it was not registered.
>>
>> Yes, it looked a little bit ugly from the beginning, but, frankly,
>> I have got used to this already.
>>
>> >
>> >Ivan's patch in[1], might be a better approach, which forced all
>> >drivers to explicitly call page_pool_free(), even-though it just
>> >dec-refcnt and the real call to page_pool_free() happened via
>> >xdp_rxq_info_unreg().
>> >
>> >To better handle error path, I would re-introduce page_pool_destroy(),
>>
>> So, you might to do it later as I understand, and not for my special
>> case but becouse it makes error path to look a little bit more pretty.
>> I'm perfectly fine with this, and better you add this, for now my
>> implementation requires only "xdp: allow same allocator usage" patch,
>> but if you insist I can resend also patch in question afterwards my
>> series is applied (with modification to cpsw & netsec & mlx5 & page_pool).
>>
>> What's your choice? I can add to your series patch needed for cpsw to
>> avoid some misuse.
>
>I will try to create a cleaned-up version of your patch[1] and
>re-introduce page_pool_destroy() for drivers to use, then we can build
>your driver on top of that.

I've corrected patch to xdp core and tested. The "page pool API" change
seems is orthogonal now. So no limits to send v6 that is actually done
and no more strict dependency on page pool API changes whenever that
can happen.

-- 
Regards,
Ivan Khoronzhuk
