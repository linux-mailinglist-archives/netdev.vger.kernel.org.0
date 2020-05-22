Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C861DEDE4
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 19:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgEVRK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 13:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730544AbgEVRK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 13:10:58 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48E4C05BD43
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 10:10:57 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id f83so11340959qke.13
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 10:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ekI5XPXMZlLYgIREK/4ZObBd8xLvApbBE4AcFTVJnl8=;
        b=KFaOCYXnQe9ZxRBTt8aHeAWg+tbTdmZrtftzZy3dHGsY9n4OzWFWCdxmGQ0OToAXj4
         pKMttYY+YeznQafL6kjaFfsSxdihG22hbB9Ak8PJCEYD4MBBoiKo7ZSTU6opjmgQpC9Y
         BgVNDHF8kOCzWXGuXSjT+pu4pzBqeSnT7NSNGNqamZeX0hTFYnXaxUUmsGnI+EBYKGLZ
         qndaeGc5jZS7iuq2jYsEo109PKEwVcajjOu/bDG0kRTManuOS66G+MIHu10Ux+ZTtXhM
         U+FK2HTcX6Cz5nqXphP/FoJiaFdqkfd7vW5zOyqvIa0kBzG9BaVuYbOKXw504RWr/O9t
         3mvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ekI5XPXMZlLYgIREK/4ZObBd8xLvApbBE4AcFTVJnl8=;
        b=Li7qNk6442ANEtE+rdsndZML8UvgaLwFrFOUtrRmm2CiYpdEuqGC0QlyoEEoqPHqce
         cfhI+3jZzdZ+3F171aqh6Pd3AV7uwe4rz/5ClDmtoKck/hHi9rYzBx4NStXgzJriebE6
         zbMqjoZzpJ0ag9gey2tV/htXLnJmD26Ry4VLvZCyc0WKydfhKJmhjphO9xxVRkBVGz9v
         T/opMRmPF0D1rAAgb8b6QLtl65kFGVv1LjGwA8UCOSj+vriNGuKEZcd4yGQiPq0LDpGX
         vzFevZtrxLApwevMl6WTl3Ftsi3Vn5cxXMG3/RjGRJlNfwtW1GQFwJE3aIAMc2+u6BIG
         4PiA==
X-Gm-Message-State: AOAM530WxMqDxURqArz980FvTxPTguVsfiUOEtwA8/Vj9Dkm4ivK4afp
        T3qsnIsRru4GXwIKKEtK/JTm3Q==
X-Google-Smtp-Source: ABdhPJw7wh06ILIAbiKKDEPB6686mei/PJCkVYuqcLlCOUTTm6edJZCO35UbzvypCLtB/bsz+K1D1A==
X-Received: by 2002:a05:620a:1472:: with SMTP id j18mr14472491qkl.363.1590167456403;
        Fri, 22 May 2020 10:10:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id t74sm7656718qka.21.2020.05.22.10.10.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 May 2020 10:10:55 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jcBCB-0007Gw-5T; Fri, 22 May 2020 14:10:55 -0300
Date:   Fri, 22 May 2020 14:10:55 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200522171055.GK17583@ziepe.ca>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
 <20200520125437.GH31189@ziepe.ca>
 <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200522145542.GI17583@ziepe.ca>
 <6e129db7-2a76-bc67-0e56-2abb4d9761a3@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e129db7-2a76-bc67-0e56-2abb4d9761a3@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 10:33:20AM -0500, Pierre-Louis Bossart wrote:

> > Maybe not great, but at least it is consistent with all the lifetime
> > models and the operation of the driver core.
> 
> I agree your comments are valid ones, I just don't have a solution to be
> fully compliant with these models and report failures of the driver probe
> for a child device due to configuration issues (bad audio topology, etc).


> My understanding is that errors on probe are explicitly not handled in the
> driver core, see e.g. comments such as:

Yes, but that doesn't really apply here...
 
> /*
>  * Ignore errors returned by ->probe so that the next driver can try
>  * its luck.
>  */
> https://elixir.bootlin.com/linux/latest/source/drivers/base/dd.c#L636
> 
> If somehow we could request the error to be reported then probably we
> wouldn't need this complete/wait_for_completion mechanism as a custom
> notification.

That is the same issue as the completion, a driver should not be
making assumptions about ordering like this. For instance what if the
current driver is in the initrd and the 2nd driver is in a module in
the filesystem? It will not probe until the system boots more
completely. 

This is all stuff that is supposed to work properly.

> Not at the moment, no. there are no failures reported in dmesg, and
> the user does not see any card created. This is a silent error.

Creating a partial non-function card until all the parts are loaded
seems like the right way to surface an error like this.

Or don't break the driver up in this manner if all the parts are really
required just for it to function - quite strange place to get into.

What happens if the user unplugs this sub driver once things start
running?

Jason
