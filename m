Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B2D2AE565
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732421AbgKKBPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732542AbgKKBNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 20:13:04 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8408EC0613D1;
        Tue, 10 Nov 2020 17:13:04 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id g7so529257pfc.2;
        Tue, 10 Nov 2020 17:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bdk9CuVg/WkPyrxXeQqKl2o6nG0rQI62N1QnyxONNVk=;
        b=D3JsiqvB1QhaXJJMINqEl/W000GbgmxxaW2ESt3EI+83KeLdHijnzKsjbGrMlrkUrc
         4TwQwT5bJ3HShsyA3vzRFibLANLoJqXQk3zfYkSrGrqdnMo+FxeS1B8nQ/mBNGbkKG+2
         mrrnku+Eqc/ZgPcsHYcV4/8QUKv2RSHzbERz6xLCD5VBB9y9f5OOD5hp0+8UUXco4Uxu
         Zjb7YMneI7ijJ+K4qnNuirIFX10ofhmOqpvCbW4UjYXivrqH4i+XXu5nXDVN4NEv2not
         NQ6T3mRyrLHaJ0NM+KDFAahbZ198NEoqfOSea/wZNZzuotR+eCjdPjBWaKnDLE0Mf16K
         Gcbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bdk9CuVg/WkPyrxXeQqKl2o6nG0rQI62N1QnyxONNVk=;
        b=W/i4Hd/BhLpUUmDWOoDDli5eArtgyk6nQ/mA94vv7yrNKEfFdDJ96F38PNLYs4Bg60
         0Sp2NGYfpDuHvp3dLncbLNwxg+43AnA0t2+i53/Nz3aMmFcfNnMeeVG4VxXtElc5HIzM
         w8iJ8gELfNxFRPnaLNAtSxWqNfU+uLqlp/coig5ogPxa2h5Kdwev6ouQzMh9+8Hibc4H
         bV7vipoYy0YBuegWuUHcWn7Hi2vAduEYb0o25kLK+qCKA/9JOmTdMlFfcBdiWYKVdv+m
         01waakXF2Gs8ay3afJ7MAj7OuVmoDBi8xZANVQJTcNLnP4KadyyeGITceaCSVFYLHBDf
         DpPw==
X-Gm-Message-State: AOAM532yRX4GQiIM5XUb7vF8nn48dRTufJHDi+js8yoYyUQcs8G7Ztby
        kngeCEuXhwBnNXfxpRElt5Qiy4CIk2vbbA==
X-Google-Smtp-Source: ABdhPJzGS+zdB13cxYj62o4sGftqieNvZDPXn1WLszByM3MaeVbTX+Ite3us9U1sY9Wm27VpApogbQ==
X-Received: by 2002:a17:90b:118d:: with SMTP id gk13mr1108374pjb.6.1605057184066;
        Tue, 10 Nov 2020 17:13:04 -0800 (PST)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c24sm203972pgk.34.2020.11.10.17.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 17:13:03 -0800 (PST)
Date:   Wed, 11 Nov 2020 09:12:53 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next] samples/bpf: add xdp_redirect_map with xdp_prog
 support
Message-ID: <20201111011253.GX2531@dhcp-12-153.nay.redhat.com>
References: <20201110124639.1941654-1-liuhangbin@gmail.com>
 <20201110152510.2a7fa65c@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110152510.2a7fa65c@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 03:25:10PM +0100, Jesper Dangaard Brouer wrote:
> On Tue, 10 Nov 2020 20:46:39 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> > This patch add running xdp program on egress interface support for
> > xdp_redirect_map sample. The new prog will change the IP ttl based
> > on egress ifindex.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> >  samples/bpf/xdp_redirect_map_kern.c | 74 ++++++++++++++++++++++++++++-
> >  samples/bpf/xdp_redirect_map_user.c | 21 ++++----
> 
> Hmmm... I don't think is it a good idea to modify xdp_redirect_map this way.
> 
> The xdp_redirect_map is used for comparative benchmarking and

Hi Jesper,

Would you please help explain or give some example about how to do
comparative benchmarking with xdp_redirect_map, just count the TX pkts?

Thanks
Hangbin
> mentioned+used in scientific articles.  As far as I can see, this
> change will default slowdown xdp_redirect_map performance, right?
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
