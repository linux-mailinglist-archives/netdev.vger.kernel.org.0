Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4902BFD6D1
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 08:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfKOHRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 02:17:08 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39562 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbfKOHRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 02:17:08 -0500
Received: by mail-wm1-f67.google.com with SMTP id t26so9162429wmi.4
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 23:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3rWXfoENBk01hvOSkg8kCt1Ez88OrYUmZuEToQ/hW7Y=;
        b=tw7VLLubU1v0LrWgVXyiOXB5Can5hWCnbuo68UCr0doGqLMjERKMAszkWW8jAQoAyB
         8vhVMbfP2ayvLx0jjPiWn19Trhn+0ZYC3GO2QaWOHiex1r5jT/2OCw2Ow8hhTP9hdmj9
         B8UDMK8D1rwfrZNx6P/81mmx7JO6xltRwipr77TMNfF9MNx16N7Jfx+omnaPGcdP5Ca4
         WWwrOuaGGOh2yuWf15ltJTPg+O6mSD6n02l3GYTcd8l2zRIc21tphXW4dcR71EBwp+Nj
         DtvDdCuj3oP77jCBdtn+MDbqsSrC65maAjUz/pego/Mi0TvAYgXJC/+xN0G/EjqCDVAF
         2/PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3rWXfoENBk01hvOSkg8kCt1Ez88OrYUmZuEToQ/hW7Y=;
        b=mFcBm//LGuZ46XfZehdF4bVOeDueCkqmw6jQnnyfmE0omb0q/MfoYBUtzw1TofT/rR
         Rs+tnatqkzyPv2PkGZqqCeHEs/RMqv8c5P7efCafXg0DmlszareW7fmB/oxTColXX3sV
         L4Y6RSMHzeb7pAMNrJ9jYs6ASDtPPiorjVgLYX9Z9SqErQO3x+2VfK/CDVqpd/2kz4TU
         8Xn834WWvK+zn71iCnrtK9ED54PLa2hTOQETvwNb3wFGDcIMcEnoWpMUSd4zUwtCFbVR
         /5qjmt16BwSodkPJvCK93t7GwIVUPDrKBptvyxuoHZxx+ABfoeaUXQvnhPUGIXp8bX4w
         5FQQ==
X-Gm-Message-State: APjAAAW29fuNegU1nq57AOLEohJ9KZvIGkZjWD0wccRUzx+VN3uVgFJ1
        Noq/BPWUZ6HRGzhc74+0Ro9gbA==
X-Google-Smtp-Source: APXvYqzReM+bpsihfuf0ohonI8fOMspQ/bGrJUagOi+uNBkqXaZck0XDCo/VT8LBq/xKgnCJ8c80Rg==
X-Received: by 2002:a05:600c:506:: with SMTP id i6mr13435203wmc.153.1573802226201;
        Thu, 14 Nov 2019 23:17:06 -0800 (PST)
Received: from apalos.home (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id w11sm12262094wra.83.2019.11.14.23.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 23:17:05 -0800 (PST)
Date:   Fri, 15 Nov 2019 09:17:03 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        matteo.croce@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to sync
 DMA memory for non-coherent devices
Message-ID: <20191115071703.GB99458@apalos.home>
References: <cover.1573383212.git.lorenzo@kernel.org>
 <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
 <6BF4C165-2AA2-49CC-B452-756CD0830129@gmail.com>
 <20191114185326.GA43048@PC192.168.49.172>
 <3648E256-C048-4F74-90FB-94D184B26499@gmail.com>
 <20191114204227.GA43707@PC192.168.49.172>
 <ECC7645D-082A-4590-9339-C45949E10C4D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ECC7645D-082A-4590-9339-C45949E10C4D@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan, 

> 
[...]
> > For the skb reserved queues, this depends on the 'anything'. If the rest
> > of the
> > layers touch (or rather write) into that area, then we'll again gave to
> > sync.
> > If we know that the data has not been altered though, we can hand them
> > back to
> > the device skipping that sync right?
> 
> Sure, but this is also true for eBPF programs.  How would the driver know
> that
> the data has not been altered / compacted by the upper layers?

I haven't looked that up in detail. I was just explaining the reasoning behind
picking a u8 instead of a flag. As Jesper pointed we can get the same result by
using len = 0, so i am fine with the proposed change.

Thanks
/Ilias
> -- 
> Jonathan
