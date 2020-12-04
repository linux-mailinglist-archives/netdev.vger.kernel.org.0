Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A628A2CEF69
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 15:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387639AbgLDOIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 09:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgLDOIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 09:08:38 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF80C0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 06:07:58 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id v22so5939314edt.9
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 06:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZjmOUJaojXoxrkgPeECn64Xfm01YWTmJVuzwTBDa7u4=;
        b=s7zyqrWzBJSbPJcuTriuM1TvC7mz3CtPuZw2eWGluy/sSLZBaJ/lGopSga7EI+Ufga
         xkwVZcl5cIfw7YIcJ2l9qB3PhkX5AJcdQPgSUBPDMx5iXMcy+GD+J68YDHz0uhsaoXPh
         iD1LDJAqYbDTDjm/mKMwRLSWt3UVYHI8coFFDmLGYtGhf8FtwinTUKAuIjO5LBbvbB7I
         xEdBt49hS2QnXgkCf4OxL2QyRbBPV8sCOXSgS2oTyUtrFZFYdk9LDLZn6BWEvaN98zin
         6Yq6wcdRJQT4OpZ7feqqGUxjBOuKhDrDX3L2TzdZu888wIUN0bbF3RlQrZtvwVtR97k3
         nxrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZjmOUJaojXoxrkgPeECn64Xfm01YWTmJVuzwTBDa7u4=;
        b=T5buFAXwpaJWAlN08XkEI+jyr8Flkr0qSQ9ehtO2iiGAnVuZ90WWkktOg68ekgZRtw
         2/xW/aQV8l0HGT3SksaR4NVSZgkH/YVgkOnAs3o+iuX/UmziBX+snMQycv6pcQOXj9PP
         5dhRgYef/Xoq6TjLt2v1D/RzjzBTyP9YGHlNl9F/6QPXX9ArbwszXA39LUvfo78ojQfb
         7D0297OvvUq8VsWAn7iiGRE207nHLKqngjNLV4/XbWByF47xsvq+WBvG+TF6gV19mYKJ
         +ch9sWAbKWRIW0rgPQF4uxmRH/+/khco6IWEbjPJxmzRRyr/Cps1PC5s2qMUkAiXUt+C
         FTJA==
X-Gm-Message-State: AOAM533nKMvdkcOEn1VZbvZMIOhu8YeAWHT4cXmODFnRrDfnZH/MQIN0
        t6E2TSfQxsKDICYW/ChbcQHEabTDUVN+Rw==
X-Google-Smtp-Source: ABdhPJxn0/fbAOgVt/vHq2HVHpBezn7XfX3eXe0o5WoXbjhmZi8cuNY9B5u05/zqw1gye0Fj4skwPQ==
X-Received: by 2002:a05:6402:1ac4:: with SMTP id ba4mr7580758edb.383.1607090877021;
        Fri, 04 Dec 2020 06:07:57 -0800 (PST)
Received: from apalos.home (athedsl-4484548.home.otenet.gr. [94.71.57.204])
        by smtp.gmail.com with ESMTPSA id c25sm3152588ejx.39.2020.12.04.06.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 06:07:56 -0800 (PST)
Date:   Fri, 4 Dec 2020 16:07:54 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, brouer@redhat.com
Subject: Re: [PATCH net-next] net: netsec: add xdp tx return bulking support
Message-ID: <X8pCuq9gewShGGUL@apalos.home>
References: <01487b8f5167d62649339469cdd0c6d8df885902.1605605531.git.lorenzo@kernel.org>
 <20201120100007.5b138d24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201120180713.GA801643@apalos.home>
 <20201120101434.3f91005a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120101434.3f91005a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, 

On Fri, Nov 20, 2020 at 10:14:34AM -0800, Jakub Kicinski wrote:
> On Fri, 20 Nov 2020 20:07:13 +0200 Ilias Apalodimas wrote:
> > On Fri, Nov 20, 2020 at 10:00:07AM -0800, Jakub Kicinski wrote:
> > > On Tue, 17 Nov 2020 10:35:28 +0100 Lorenzo Bianconi wrote:  
> > > > Convert netsec driver to xdp_return_frame_bulk APIs.
> > > > Rely on xdp_return_frame_rx_napi for XDP_TX in order to try to recycle
> > > > the page in the "in-irq" page_pool cache.
> > > > 
> > > > Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > > This patch is just compile tested, I have not carried out any run test  
> > > 
> > > Doesn't look like anyone will test this so applied, thanks!  
> > 
> > I had everything applied trying to test, but there was an issue with the PHY the
> > socionext board uses [1].
> 
> FWIW feel free to send a note saying you need more time.
> 
> > In any case the patch looks correct, so you can keep it and I'll report any 
> > problems once I short the box out.
> 
> Cool, fingers crossed :)

FWIW I did eventually test this. 
I can't see anything wrong with it.

Cheers
/Ilias
