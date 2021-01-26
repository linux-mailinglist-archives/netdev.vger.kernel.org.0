Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE3B305851
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314206AbhAZXAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730235AbhAZRFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 12:05:12 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8110C0613ED
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 09:00:08 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id w124so19185560oia.6
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 09:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EU+WTGu8bUI816wzRP2V2ST2vW8X+ERkOSMJ6GfAu7A=;
        b=pEMdUe1I+pz92rcVj3qrndpwiny2nUbbUT9WmvMR83b2whOeAhucNsaDELoIn2Dbro
         mPMtW1FeXb4aVdCgOLPc7KjI+XzgWFeNH3OU8VPiLPY4ZW5gxxYoyabLZ9XDsOmRcmwT
         AV2BlJrF5okewJUrUxknlRfEOTFBf0S2vq0VWvCzP7R4B3dFPgD2YlR6uiwlUBSGSl0J
         IUVj7S1vpZXFNyHS5CoyHU9R99ATSz0I7YDNuJHq9hqQwfoAXgUSj+p2NI7w0De4efON
         xTNCuo1oxoGemSpTOy0YbAl1i+90Q4G0Tu9UYQqF1spkrrPQQDdM8Mz04lLlbamV08Ba
         m2Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EU+WTGu8bUI816wzRP2V2ST2vW8X+ERkOSMJ6GfAu7A=;
        b=H4Yu5e2vin1myynQqsGn4HHBGOJ/jWXBpUDOtnFrZ22gVlVL5MItV0f+b8FqpaW2P2
         xAIedwfqCpH2hHlKGwAubZM4X+QmJXpcTdo4LCqIsgGAHEndrtVOD2WEYCRRccuJOK7t
         e8+UF8miAykwwyaLkEieN5/dYq+BYl4bQByCNHh9iB3OWiwBZMXRvgsNtOXhstLvM7Pd
         /h6EIRMJBEJHyg0ldhrEi8xxPmbs0nz9jO+ad7bLc5Wom08tHYWEQO6y58naOejJ/64A
         RsjElxhUbOoOK42snlxK81tvuzUcKG7+nUTwlVWcTbqDSsWHOHyU79pXpF7UuhbDd8Ol
         Gbrw==
X-Gm-Message-State: AOAM531DiVKlH1YJY8LritDhzmzY/p1ca+Advd8AOU7ERuH1nGWpj50P
        QIz4bu51GDDpnq3JroFLZyHblw==
X-Google-Smtp-Source: ABdhPJzJ9rDz6FYhds6jaMVjB00+YT+kXxwNhRowzyxERbBRdSPVyHiBFunvQyxwQf01zmcyTS2XkQ==
X-Received: by 2002:aca:d481:: with SMTP id l123mr360474oig.155.1611680408337;
        Tue, 26 Jan 2021 09:00:08 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id j8sm4236852oie.47.2021.01.26.09.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 09:00:07 -0800 (PST)
Date:   Tue, 26 Jan 2021 11:00:05 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: Preemptible idr_alloc() in QRTR code
Message-ID: <YBBKla3I2TxMFIvZ@builder.lan>
References: <20210126104734.GB80448@C02TD0UTHF1T.local>
 <20210126145833.GM308988@casper.infradead.org>
 <20210126162154.GD80448@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126162154.GD80448@C02TD0UTHF1T.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 26 Jan 10:21 CST 2021, Mark Rutland wrote:

> On Tue, Jan 26, 2021 at 02:58:33PM +0000, Matthew Wilcox wrote:
> > On Tue, Jan 26, 2021 at 10:47:34AM +0000, Mark Rutland wrote:
> > > Hi,
> > > 
> > > When fuzzing arm64 with Syzkaller, I'm seeing some splats where
> > > this_cpu_ptr() is used in the bowels of idr_alloc(), by way of
> > > radix_tree_node_alloc(), in a preemptible context:
> > 
> > I sent a patch to fix this last June.  The maintainer seems to be
> > under the impression that I care an awful lot more about their
> > code than I do.
> > 
> > https://lore.kernel.org/netdev/20200605120037.17427-1-willy@infradead.org/
> 
> Ah; I hadn't spotted the (glaringly obvious) GFP_ATOMIC abuse, thanks
> for the pointer, and sorry for the noise.
> 

I'm afraid this isn't as obvious to me as it is to you. Are you saying
that one must not use GFP_ATOMIC in non-atomic contexts?


That said, glancing at the code I'm puzzled to why it would use
GFP_ATOMIC.

> It looks like Eric was after a fix that trivially backported to v4.7
> (and hence couldn't rely on xarray) but instead it just got left broken
> for months. :/
> 
> Bjorn, is this something you care about? You seem to have the most
> commits to the file, and otherwise the official maintainer is Dave
> Miller per get_maintainer.pl.
> 

I certainly care about qrtr working and remember glancing at Matthew's
patch, but seems like I never found time to properly review it.

> It is very tempting to make the config option depend on BROKEN...
> 

I hear you and that would be bad, so I'll make sure to take a proper
look at this and Matthew's patch.

Thanks,
Bjorn
