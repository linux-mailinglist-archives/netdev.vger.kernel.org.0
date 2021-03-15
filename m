Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB3F33B205
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 13:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCOMET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 08:04:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230266AbhCOMEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 08:04:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615809853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3YjKsx//HRAhlNTprHpT9wozi3+fVsXIFMRQPWdBipU=;
        b=NFCFLzcIaExdB8MKW1rrWeqAdGJv5D0WufVIP81LFHDxS9jvq4Gh9gbIQyWDpjDUMxPaJ7
        JEkCwuNayxqSk1B9I5/RT0KhUgbf1/bvSZvxqkCzEbG7lD4n86aqHKpx/tqcyQRiYwEjal
        InBpKGzechGhdWzcI63AkLFdJih+TJA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-Ro88XS3WP4qdk_wf-BgIqw-1; Mon, 15 Mar 2021 08:04:11 -0400
X-MC-Unique: Ro88XS3WP4qdk_wf-BgIqw-1
Received: by mail-wm1-f72.google.com with SMTP id a68so2117543wme.1
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 05:04:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3YjKsx//HRAhlNTprHpT9wozi3+fVsXIFMRQPWdBipU=;
        b=UfcqQJBwf6FredW3ZDoJ7S+TcVXp0oKh4U0LYdxlCIQbCM+1I+UxSOTxK/Fmi0yvJj
         D5gcn9WgNMpp6sLeoe3aPjJ0/4Ykj+EwP4WpgEcoFqLIxxeKPoeF+Szx0JXWckfb3lCx
         RUQxjyipht1E5IC30GR9iuFirDsTp4Fd49h0mJr0yLNGaMDJOMqAf+DCAbs3Zd9mXlbj
         gQooXYurXRAuTp3kWEWFcmNeEzoeM3nOdqQ9E3nh60ibpifhmKNooGZe9D0rnXaIpzsK
         Qig28Oe6tqEeF6tjVOspz61melicPa2fz9K9aWqXZqOPmCZRXT7D80i7bc0VA+fgp5+r
         idSQ==
X-Gm-Message-State: AOAM530ZneY479jhLM/kHAP+TMeEQZvUdjxnqFFIh39N65OdLmUaii93
        aMycyixqF+6/1m5t/oAQMc6PbiZRonoyFDTgAbx/HNNeHLSH7WQ3yhnaztOMMCv9sjSCBRd3rjB
        DA/ssvLs8OixjPIul
X-Received: by 2002:adf:f948:: with SMTP id q8mr27196108wrr.296.1615809850623;
        Mon, 15 Mar 2021 05:04:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfaexDs/CFrOUeJgtIS5WT2AAyCBWiRRNpka1mPAWlmrJqPolX9L34kAfVIvrGhBjJZkAu+w==
X-Received: by 2002:adf:f948:: with SMTP id q8mr27196090wrr.296.1615809850464;
        Mon, 15 Mar 2021 05:04:10 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id d13sm19170594wro.23.2021.03.15.05.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 05:04:10 -0700 (PDT)
Date:   Mon, 15 Mar 2021 13:04:07 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     lyl2019@mail.ustc.edu.cn, paulus@samba.org, davem@davemloft.net,
        linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] net/ppp: A use after free in ppp_unregister_channe
Message-ID: <20210315120407.GB4296@linux.home>
References: <6057386d.ca12.1782148389e.Coremail.lyl2019@mail.ustc.edu.cn>
 <20210312101258.GA4951@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312101258.GA4951@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 10:12:58AM +0000, Tom Parkin wrote:
> Thanks for the report!
> 
> On  Thu, Mar 11, 2021 at 20:34:44 +0800, lyl2019@mail.ustc.edu.cn wrote:
> > File: drivers/net/ppp/ppp_generic.c
> > 
> > In ppp_unregister_channel, pch could be freed in ppp_unbridge_channels()
> > but after that pch is still in use. Inside the function ppp_unbridge_channels,
> > if "pchbb == pch" is true and then pch will be freed.
> 
> Do you have a way to reproduce a use-after-free scenario?
> 
> From static analysis I'm not sure how pch would be freed in
> ppp_unbridge_channels when called via. ppp_unregister_channel.
> 
> In theory (at least!) the caller of ppp_register_net_channel holds 
> a reference on struct channel which ppp_unregister_channel drops.

Agreed: ppp_unregister_channel() is going to drop a refcount from pch
in any case. So holding a refcount on pch is a hard requirement for any
caller of ppp_unregister_channel(), regardless of the channel bridging
code.

To lyl2019: Note that this refcount is (unsurprisingly) held by calling
ppp_register_net_channel().

