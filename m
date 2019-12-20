Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA671273A0
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 03:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfLTCsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 21:48:41 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37332 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfLTCsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 21:48:41 -0500
Received: by mail-pg1-f193.google.com with SMTP id q127so4185963pga.4
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 18:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ey8uzf4Q4XmfQ75/KbNSyCTj29WDhiQRVyqzSO301Sg=;
        b=DkyWVZirip+X7boYIsSC/rVfF/uPU0PO8ZScCa+Ysr4eRu7opGTsVHv4zN+cKsLn4T
         hvBSqJdUKo+khKy1SmJ822yQFm7iWaCLHcphVq3KttXDcG14hKw21AKF+QMBvB1ikEHQ
         NDhAZQ1MHKZXAGOVnuO9DxiQee8z9oEwc0x5uVXgXRcP+QBeB3+KM1Q0sFAwwUjjy2FK
         FU05HBkj01owwiOKbUkAiTU6/2Wh3r/Fn7q4D6pyuoCOP0PPDTWta49v2iTLAw09mWJB
         ElT2/FQK4AGZPLBW4IVlB6fv9uirYk+cePOkD2N2mWoJnkUiS1P4+GhwZhTPkEJEYuFL
         kgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ey8uzf4Q4XmfQ75/KbNSyCTj29WDhiQRVyqzSO301Sg=;
        b=r5vy+DF11nZ6OUm0p3527VJxpL167AFFK9PyEgQ9DrGxEGdBq74OyQeAomh8MVjyKs
         hog4DB7NTDo8pUAb0e0F/B1ll6pcYzhPl5KRP8msMqlWrbbIAOT+zGklAvekIwWwSJ+Y
         +C8ZRyQq6FGTG43zAU4sRQl3ndJSodGa+HeDtSWTc098A1XxoxrRfg9nCJsk97uAbx/X
         eAEkpO9UIZus4RdBMJ6CDhyj1pPtZNZuwmBURRv4kq77cF43HiLILuZEVTFVKDBxw27E
         JAvEqyJ3RgJR9OkmCjgL9qohN+5o+J33L8Q3r3qG59XXznZO6sUA6B0xwZpTiwtlCj53
         oWog==
X-Gm-Message-State: APjAAAXpVOi9wPXEfPOEvISbT4ksyhe75KIcA18jc9mv47h2W1DtYFKw
        EmOvHu5a6t5COG7DStmmDio=
X-Google-Smtp-Source: APXvYqx2DpW1lenodlTQKg6uio6f1qfOWJQ+e7NUGbPPdmuNalWTE+V8idDCDRtLiD5NzdkNOUbgKQ==
X-Received: by 2002:a63:5525:: with SMTP id j37mr12287760pgb.180.1576810120454;
        Thu, 19 Dec 2019 18:48:40 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e187sm6059271pfa.135.2019.12.19.18.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 18:48:39 -0800 (PST)
Date:   Fri, 20 Dec 2019 10:48:29 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>
Subject: Re: [PATCH net-next 0/8] disable neigh update for tunnels during
 pmtu update
Message-ID: <20191220024829.GC27948@dhcp-12-139.nay.redhat.com>
References: <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191218115313.19352-1-liuhangbin@gmail.com>
 <20191218120147.GA27948@dhcp-12-139.nay.redhat.com>
 <20191219175728.GD14566@linux.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219175728.GD14566@linux.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 06:57:28PM +0100, Guillaume Nault wrote:
> On Wed, Dec 18, 2019 at 08:01:48PM +0800, Hangbin Liu wrote:
> > On Wed, Dec 18, 2019 at 07:53:05PM +0800, Hangbin Liu wrote:
> > > When we setup a pair of gretap, ping each other and create neighbour cache.
> > > Then delete and recreate one side. We will never be able to ping6 to the new
> > > created gretap.
> > > 
> > 
> > Oh... Sorry I forgot to add PATCHv3 in the subject...
> > 
> Also, it looks like -net material to me.
> 

hmm.. I set it to net-next as we add new feature/parameter in
dst_ops.update_pmtu. But it looks make more sense to set to -net after
adding the Fixes tags.

Thanks
Hangbin
