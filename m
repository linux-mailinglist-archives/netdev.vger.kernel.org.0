Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12C525BB30
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 08:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgICGmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 02:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbgICGmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 02:42:10 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CCAC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 23:42:09 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id q13so2192390ejo.9
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 23:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1DnBvyVmJ6E56trU1tEQPaDLWvCL4Jwm2s9nJo5Mp9o=;
        b=c8pPpYsLcg0DiP6Q2M6ucCS2/V1ejPDxBryVQ35ru6knLwERqjX70W62pPqIIeMndD
         nBZHHV6KH8oHdRBpa4o7iluD31/5S21TXSxQYrxJFIx8hYVo7lk7V92ZoCiFge4/kquK
         y48LOzZI8w/n8W/r4IjImpzxhRjAGSsJD7l7nnirPS6fkNxHKJkUL7rB9nDiT4gzxnu9
         CEo4+bDMB+zuJipN2oCPh0DEORlDs8uGWc6fOses47djF8v3mc0K89aFz+p49raAPNH3
         0nQiG1y0/irxA0N6gjtk2NJr4Bug+7ZszcV5yybtvcUuTN0h/hmw6bwS8g5DHWmZgmiw
         OAGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1DnBvyVmJ6E56trU1tEQPaDLWvCL4Jwm2s9nJo5Mp9o=;
        b=PHiLjZU6pVQqEtux0h6neCtQgZZKSwCjhzmQPNagqpsUnjQiGhYl9ZV4Lzwe+DMiId
         lgtPdTzyGXl4U0TBwRmbhE+LFdxt1Zmcni2iEIOWl/PdmMvOTB1OSGmaRLXbu33uRXIl
         F8yaV/X0YTfkjXbgQ7R6ubFjg7O8Uo965zMlizl86MgsyJ21VWj3zvw9nHF+u/p8qtPM
         +aTcnGjZaSrhiFOtofK91j6GoP1GPmaBz3mxbcSrO3+++F0ItFfQYx6Mg6odKzWADPiv
         Wl+Tb+oI0qz3eNwQN8OauU4eEJ5+r7yLcrtav70LHfXeGr17WP5O2rkWakw8R0H7HX9C
         zRBQ==
X-Gm-Message-State: AOAM532COqB4RVxQ6L+s7DeE+aBvEaBvN2TVqQ5U3UgaOjL8Hax5/2Vt
        6SMjCXFEppqB1UhI0eNsVm1L0dWwfSfHPg==
X-Google-Smtp-Source: ABdhPJyLyZFn9EFu4ApFcLK/V5dDCr5fg/HVsWIdYBmE5HkJlIQJcjw7Zlya94blv0kGU3DfsWPG/g==
X-Received: by 2002:a17:906:6d81:: with SMTP id h1mr629413ejt.436.1599115328513;
        Wed, 02 Sep 2020 23:42:08 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id o14sm2062759edj.77.2020.09.02.23.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 23:42:07 -0700 (PDT)
Date:   Thu, 3 Sep 2020 08:42:07 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, louis.peens@netronome.com, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH net] nfp: flower: fix ABI mismatch between driver and
 firmware
Message-ID: <20200903064206.GA32494@netronome.com>
References: <20200902150458.10024-1-simon.horman@netronome.com>
 <20200902.160054.1576232309562383787.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902.160054.1576232309562383787.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 04:00:54PM -0700, David Miller wrote:
> From: Simon Horman <simon.horman@netronome.com>
> Date: Wed,  2 Sep 2020 17:04:58 +0200
> 
> > From: Louis Peens <louis.peens@netronome.com>
> > 
> > Fix an issue where the driver wrongly detected ipv6 neighbour updates
> > from the NFP as corrupt. Add a reserved field on the kernel side so
> > it is similar to the ipv4 version of the struct and has space for the
> > extra bytes from the card.
> > 
> > Fixes: 9ea9bfa12240 ("nfp: flower: support ipv6 tunnel keep-alive messages from fw")
> > Signed-off-by: Louis Peens <louis.peens@netronome.com>
> > Signed-off-by: Simon Horman <simon.horman@netronome.com>
> 
> Applied and queued up for -stable, thanks Simon.

Great, thanks Dave.
