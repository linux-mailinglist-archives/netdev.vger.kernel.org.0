Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5DFD3F69
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 14:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfJKMXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 08:23:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37403 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbfJKMXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 08:23:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id p14so11700333wro.4
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 05:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=R2syL0YW+TeHAd/jZ19BY501P3Ze8eSUts4hhsrlbTg=;
        b=MdmGDn+RPpTN1sIesf3XhQOrqh33u0TrgoP2gSZ8orSGCtJjwhJpCAEXcl9mb9mrWx
         KsPGLx2e2QdgGf1g5jnTXTiwC1VvFT0CxS4vB+w8iW1BdmqkgZDiM4wdq7lvf+dlf1Jz
         vOh+GR18Aer/0dOMhZRG+BH9R57WLWThrrC9S+bUDud6eyigoKRH/kIqe79bysPPWwVq
         3/6hoXfMx3W+JjlXPoUb4kRuDOqHDUrKZBgqCKl+K4GvvPdQ/998vZ0iWIcL33p8S9F/
         uvgpLQQbCMPur8ttpcN2FwHMax8ISTC697dIzuXhP1ZIfuVzDQKBRgadvIcP7V0R/MTt
         PnTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=R2syL0YW+TeHAd/jZ19BY501P3Ze8eSUts4hhsrlbTg=;
        b=kVPlF8736E891yDUBwfzjKtTa5ESycDKE21RHJQqeAnZLa8ifHFaSW7LJIPWggKMTD
         zvDPZ/bTpQZXR3ycxS0k/9vk74ifJnsHBRaoxbLh1JGC/b5nb4IC4G44UzMGwjgBFbNL
         8YeZ77DYRn90Y2Abn1myjd7VCCcH18tEg93EQZsdkpZc2xOkSb9KsctoSHiUc93Ef019
         U3loNnQeH3NR7Asi/wRRmCp049OZ5KOc/joamnQUvfaayB9oK8meAH//6cjHrZvlyPay
         tiEAUnWBVeTAc94fd9Z5O2Tp4ax8c445Qc4OCQZqu2Sa7GasV8EsNd3gW+2b5S+7kM+i
         BLUg==
X-Gm-Message-State: APjAAAVigaM51bJf8ws9NeSQKQRYhHuOR87OmGCOZ7GxmHHT2tyScf5Q
        8UQEMlcS9BJAXaIwpxkc1GgE7g==
X-Google-Smtp-Source: APXvYqwVVTPqEFScgyagl6Zg7GstkjAmqaiWUrDab1xs8aw1wGbEDjQMh+7jovkqImHb+sxNiZEIAQ==
X-Received: by 2002:adf:f98b:: with SMTP id f11mr3017198wrr.350.1570796613172;
        Fri, 11 Oct 2019 05:23:33 -0700 (PDT)
Received: from apalos.home (ppp-94-65-93-45.home.otenet.gr. [94.65.93.45])
        by smtp.gmail.com with ESMTPSA id f18sm7670788wrv.38.2019.10.11.05.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 05:23:32 -0700 (PDT)
Date:   Fri, 11 Oct 2019 15:23:29 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
Message-ID: <20191011122329.GA8373@apalos.home>
References: <20191010144226.4115-1-alobakin@dlink.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010144226.4115-1-alobakin@dlink.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

On Thu, Oct 10, 2019 at 05:42:24PM +0300, Alexander Lobakin wrote:
> Hi Dave,
> 
> This series was written as a continuation to commit 323ebb61e32b
> ("net: use listified RX for handling GRO_NORMAL skbs"), and also takes
> an advantage of listified Rx for GRO. This time, however, we're
> targeting at a way more common and used function, napi_gro_receive().
> 
> There are about ~100 call sites of this function, including gro_cells
> and mac80211, so even wireless systems will benefit from it.
> The only driver that cares about the return value is
> ethernet/socionext/netsec, and only for updating statistics. I don't
> believe that this change can break its functionality, but anyway,
> we have plenty of time till next merge window to pay this change
> a proper attention.

I don't think this will break anything on the netsec driver. Dropped packets
will still be properly accounted for

> 
> Besides having this functionality implemented for napi_gro_frags()
> users, the main reason is the solid performance boost that has been
> shown during tests on 1-core MIPS board (with not yet mainlined
> driver):
> 
> * no batching (5.4-rc2): ~450/450 Mbit/s
> * with gro_normal_batch == 8: ~480/480 Mbit/s
> * with gro_normal_batch == 16: ~500/500 Mbit/s
> 
> Applies on top of net-next.
> Thanks.
> 
> Alexander Lobakin (2):
>   net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()
>   net: core: increase the default size of GRO_NORMAL skb lists to flush
> 
>  net/core/dev.c | 51 +++++++++++++++++++++++++-------------------------
>  1 file changed, 26 insertions(+), 25 deletions(-)
> 
> -- 
> 2.23.0
> 

Thanks
/Ilias
