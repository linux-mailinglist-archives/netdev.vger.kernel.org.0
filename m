Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8534414C7D3
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 10:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgA2JHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 04:07:13 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:33834 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgA2JHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 04:07:12 -0500
Received: by mail-wr1-f54.google.com with SMTP id t2so19227808wrr.1
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 01:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lNi+L8jpe7mD0bN3fzLwwzVGYjLloxJdgUFqWgXQ49g=;
        b=cxj3gd8rmN+68mS/6mQtcV99B/8xCkga7YyiBww6xkdMmEl3NXWo2juk6/e8+xgbhd
         5AaXnDXzBELIIZkGmbbPua+PmtizHuBG9FUItKXs4ly3d3Olfj7GjeDHa30t7vaKqJ9l
         XQCnposqRFGFGi/iaKVKQAqAthy8MChWWbzVSy4Q2cPzTP0ZMWgUKICAoF+Z4rOw83Xg
         FbPil8xVY2uV1GfNMK7spKbzIHanWwHsEuB+rjRxxKgVRDn2lEERHDhZ7XtJ0KGRxHdI
         qtSVPJQzYYFwEZFY3jYFmr5fBklhT6RmlsDU+AoVHd59fFMTtMcLtvKwxnP7/nCoE9H/
         9+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lNi+L8jpe7mD0bN3fzLwwzVGYjLloxJdgUFqWgXQ49g=;
        b=CS51bBnA4ZOcHSZBnvsadhQmChi4/2y//7fM6+TnZRPLtabaRdVFbeUZ7ZOfZMXcsl
         KzLBp1ECmfxd1a15IOKvvWDx+M1dLcSOvbshH8266MLV3IdWlcFmbV5zjZKH2QZafFm6
         dxfJC+0L5GS5PcwgBzBHYvrNge1vJ+jLFY2z54wHBqvxEDFWXW7d0LAgadqhe1+8S9wc
         OHacvha+eziXa12hnQstyWdnhHsQ9B6K3pMe3S9f2Dzw7MFOfVIvBe32Hh+ESxiXo10f
         OI5c4tWZUrKmKeks1pn9Z2/PdOAaaP0EgB+LE1WJFEfXSULuo4EHTZKAevWTJ0ggGJJa
         +MOg==
X-Gm-Message-State: APjAAAVa/q5V9Y4WKs3WHIlLXRhWRtHDK9SZxMZtBL6VZlkAsy8Cuj31
        bXfvkx9frrsWFyie7kTurQ2n0Q==
X-Google-Smtp-Source: APXvYqy5u2BJIXvr1++RS283xezYlYrVKp0dVFRSdShF2tsgMD7ZXY8RsRnqerOzO7R4850DIsyyTw==
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr32684786wrw.289.1580288830786;
        Wed, 29 Jan 2020 01:07:10 -0800 (PST)
Received: from apalos.home (ppp-94-66-201-28.home.otenet.gr. [94.66.201.28])
        by smtp.gmail.com with ESMTPSA id w7sm1489146wmi.9.2020.01.29.01.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2020 01:07:10 -0800 (PST)
Date:   Wed, 29 Jan 2020 11:07:07 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Created benchmarks modules for page_pool
Message-ID: <20200129090707.GA260315@apalos.home>
References: <20200121170945.41e58f32@carbon>
 <20200122104205.GA569175@apalos.home>
 <20200122130932.0209cb27@carbon>
 <CAGnkfhy4O+VO9u+pGE83qmtce8+OR4Q2s1e9Wdupr-Bo5FU1fg@mail.gmail.com>
 <20200128194136.4dff1cb2@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128194136.4dff1cb2@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 07:41:36PM +0100, Jesper Dangaard Brouer wrote:
> On Tue, 28 Jan 2020 17:22:47 +0100
> Matteo Croce <mcroce@redhat.com> wrote:
> 
> > On Wed, Jan 22, 2020 at 1:09 PM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> > > On Wed, 22 Jan 2020 12:42:05 +0200  
> > > > Interesting, i'll try having a look at the code and maybe run then on
> > > > my armv8 board.  
> > >
> > > That will be great, but we/you have to fixup the Intel specific ASM
> > > instructions in time_bench.c (which we already discussed on IRC).
> > >  
> > 
> > What does it need to work on arm64? Replace RDPMC with something generic?
> 
> Replacing the RDTSC. Hoping Ilias will fix it for ARM ;-) 

I'll have a look today and run it on my armv8 box

Cheers
/Ilias
