Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078BF25CEFD
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 03:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgIDBIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 21:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbgIDBIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 21:08:06 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A6FC061244;
        Thu,  3 Sep 2020 18:08:06 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id v196so3704105pfc.1;
        Thu, 03 Sep 2020 18:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eQ0pdzitQ7jfWkypVMduYAbcdT/AT6R4MA3NcXRf4is=;
        b=BMnPXopiQrmJJ38WEoHC70HMK1QJ/Qg3ZTTEpbI+O9oTyXHwrk8ym8PaMMD7sWT8uK
         nWP/ZmMXPZ/HEMGlkvCnPzBsdoQGBBRpNJEy6SUWWeLqnKPFmrPEuJMEZGRmbglBP2Ag
         KnFyAEg7AuoZgG4erA+2tzVFXbikRNjv358vboVP1oPYl9PSRZoLNVqFrnBNfWRAjvif
         s/XHUjrgiZUuy7SG6mgH/jqbIi6BpvLNFpwHm+RRVZoWt6NT13+GwVzYXUTIXWrN1Ae1
         iN6id7oZax839fQESThtqbI7DQtPPzVzxge0UmWR30e8yQz5Fr1sCjXcKK7HoFGK6OWP
         n+CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eQ0pdzitQ7jfWkypVMduYAbcdT/AT6R4MA3NcXRf4is=;
        b=Jo468sZniHLgYbqmn9XSTH2ZA8//5eZhZEHyLUme8mwhDElHAnDOXPJ5rmTKGZNGYN
         On8cY6qmVKf7opS9OipabmINwZ4ovbj7eHqNKfpDLNgS165Mr6uzvxC9sQPF68J9xzwZ
         9afuSeqxKysb/i2pUU7EVxglPTRh5HlH4N4Oe4bC4kGMO/QSPEx1ncUNmo4CvIElQtBr
         hG12FaRySiOmJYUQ2n7qUfSZSC6aHOyoWkjvP9tT8fAaTP6FjO2u6129qvNL0JcuoG6Q
         NNDVUOU/UMg4QLEvFSsem6EBVAZYlShlg0RVYuutSAwYpQH9umOkhSZDcT8AJeJTmicj
         s1eA==
X-Gm-Message-State: AOAM533WHi5/eabt1dhlLHtNH6PmjtzMXGdgPV6PZXcvaZNbzf7kwewX
        Xd5YvRNss4anEFGds8fpTOPlq+Eqg6I=
X-Google-Smtp-Source: ABdhPJxWpGUMETOOyFkNe1/wEgSyGdeE89ZTMCkpqRRNBzAt1pnM3KH86rqgKP23qeJVgk4Ppw57Og==
X-Received: by 2002:aa7:83cf:: with SMTP id j15mr6071275pfn.251.1599181686296;
        Thu, 03 Sep 2020 18:08:06 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8159])
        by smtp.gmail.com with ESMTPSA id t20sm4439970pgj.27.2020.09.03.18.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 18:08:05 -0700 (PDT)
Date:   Thu, 3 Sep 2020 18:08:03 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Subject: Re: [PATCH v2 net-next 0/9] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20200904010803.nt2jfuhrbqe5cj53@ast-mbp.dhcp.thefacebook.com>
References: <cover.1599165031.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1599165031.git.lorenzo@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 10:58:44PM +0200, Lorenzo Bianconi wrote:
> For the moment we have not implemented any self-test for the introduced the bpf
> helpers. We can address this in a follow up series if the proposed approach
> is accepted.

selftest has to be part of the same patch set.
