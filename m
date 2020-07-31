Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B17234AE8
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbgGaS1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387781AbgGaS1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 14:27:14 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33662C06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 11:27:14 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id e5so9636553qth.5
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 11:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tV7sc6wflPo/OY3J/lFfg1ZRZlhKID3SNfnVWUEEij0=;
        b=jirAyMKBcEnHMUKDFUsSmCToGT23RCdr6mO7c82AJACLIFDcftcqtQv7Y0rpjSOAZa
         0Hh+Gkg0mXocP7OYRjdIhqSzcbiRWDUjAWJRAlUl4vtGGsHuEh74PRbLnc0uSwtOpuy/
         +u+c664zqSnJ3ocdEv65VSLvGtOu1+TA+Le6rXbzmPjN1kTHwfPSCstj6EusTPHr06Ew
         tdI/nddtwUQsYmraBl7AGJhzOmKShzGAPGhJiypVRfJbrcIlL6IAyoF6oM05IjxYsHb0
         HBkqvC6HByoBCfOx3KJBz8HksYdfzNIAYp7926RYYrbyoGblBM7e1pjBe8gPKE4MlaFM
         CWjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tV7sc6wflPo/OY3J/lFfg1ZRZlhKID3SNfnVWUEEij0=;
        b=fvhQtt6WkFj5mz9bFAsj4khljEzTibaQin3Chpkgf2bdEpxZQlUjTMoDxcCODaKMES
         PBpMANWZS7oMy6JYr01NvsZ9EjWry/4k4qnUpnHv+phtn3ZfkX051o7kZPtbkJK392vJ
         c3vR2WemrnihaMddOtnLaGTozEg6dGIKfsT5lbqby3pCfuiNp8A48gUqsQZppDBQm0li
         8GG/RUQ1VSe4BjiM9oROMLZmTdVTqZkl1SzH4DTX0Bmg5qjqhdzI6H2Y30nUXcdCmsrR
         gFQfzniDNyxossKLhyo+QOZpwy//GqxeqlBpXQ/biOLI6IxCKLLqQ32lyaZIg6zeNuiE
         8MNQ==
X-Gm-Message-State: AOAM530ONeG/5Zs/24gRKstpy1nqf5y8/wSIxFWjNBiTv8LGwn+/vOAy
        XzTpOQMEYLIgo1Pg2KIwhBSPkQ==
X-Google-Smtp-Source: ABdhPJwzQPkhbiQL7KlW31VPxmlTv3PTAEP2UbW2gPotPOEEZgW2ADBjjJCvh6rUtEiaGporHH73jw==
X-Received: by 2002:ac8:8b3:: with SMTP id v48mr2085093qth.274.1596220033350;
        Fri, 31 Jul 2020 11:27:13 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id x67sm9513983qke.136.2020.07.31.11.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 11:27:12 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1k1ZkO-002AoB-41; Fri, 31 Jul 2020 15:27:12 -0300
Date:   Fri, 31 Jul 2020 15:27:12 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200731182712.GI24045@ziepe.ca>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal>
 <20200731053306.GA466103@kroah.com>
 <20200731053333.GB466103@kroah.com>
 <20200731140452.GE24045@ziepe.ca>
 <20200731142148.GA1718799@kroah.com>
 <20200731143604.GF24045@ziepe.ca>
 <20200731171924.GA2014207@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731171924.GA2014207@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 07:19:24PM +0200, Greg Kroah-Hartman wrote:

> > I tried for a bit and didn't find a way to get even old gcc 4.4 to not
> > initialize the holes.
> 
> Odd, so it is just the "= {0};" that does not zero out the holes?

Nope, it seems to work fine too. I tried a number of situations and I
could not get the compiler to not zero holes, even back to gcc 4.4

It is not just accidental either, take this:

	struct rds_rdma_notify {
		unsigned long user_token;
		unsigned char status;
		unsigned long user_token1 __attribute__((aligned(32)));
	} foo = {0};

Which has quite a big hole, clang generates:

	movq	$0, 56(%rdi)
	movq	$0, 48(%rdi)
	movq	$0, 40(%rdi)
	movq	$0, 32(%rdi)
	movq	$0, 24(%rdi)
	movq	$0, 16(%rdi)
	movq	$0, 8(%rdi)
	movq	$0, (%rdi)

Deliberate extra instructions to fill both holes. gcc 10 does the
same, older gcc's do create a rep stosq over the whole thing.

Some fiddling with godbolt shows quite a variety of output, but I
didn't see anything that looks like a compiler not filling
padding. Even godbolt's gcc 4.1 filled the padding, which is super old.

In several cases it seems the aggregate initializer produced better
code than memset, in other cases it didn't

Without an actual example where this doesn't work right it is hard to
say anything more..

Jason
