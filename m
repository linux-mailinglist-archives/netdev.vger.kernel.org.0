Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC6E48AAC
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbfFQRlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:41:32 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40142 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728681AbfFQRlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:41:31 -0400
Received: by mail-qk1-f194.google.com with SMTP id c70so6682481qkg.7
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7NyA8a7gBq/nfUvm9gvQAx8nzhYfXZQghQdSoODsjl4=;
        b=tXpAdb8fKWZbdIAXHAp/ul+RojCF16y2UMUTvIYp8XJUgcIHz925XOcQDsauu2028K
         piArOf+dmyDyf98lPzqa++/2p/JIYjW0854qwVoA3Q5/TeVzki6FyURH7eEpoeJ9gOzP
         b6EGLo3oSdqGj7Qd+UF66OM/Z0H0v7lZbgGaESWHfntbfzYWYr4dWwvcDWtEpAFGtly/
         NLN9oeA5vWdHS5MumSlTzUekgm4sWdhI5Y8MhqQUSxV8B9Oim002JQkfZfY3LmmnQfgv
         rx+Pi+0ji7TiTdNVfhYmzNTmKVGV7LoZ7ODkKuMtG43iQlg6gEHW5cf5IEWRxwNCQsbv
         yiYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7NyA8a7gBq/nfUvm9gvQAx8nzhYfXZQghQdSoODsjl4=;
        b=iOO5m1hMZKJ+wzA3u+5MlZQVRtSR2FKPVk8rX97e/uYQkTnHeNAYuHWUxDgbU/4gSq
         eBPJhUY2ZVSlXoVsk0LfGEOrZVpZxoVsULvDUp7L3R5GItNHjSMGTL+lk+rowCBwAt2D
         jFRk/kGhSQnwT8lOXyRpKKXHQ2tcRH6oTT4/uKOCkal+wyIHgHSqYRAWU9wfWB9Z+e0i
         MPCzxj4b1gXx4HuspvS0Qma8IdAO1+5sbSmZl9B23vRcPwP3juDkVeZOjBepEc10w672
         V3PXgcS+GESkx+zzOJyoG2vsbKHAlLlOYMsHgeiLmaqqXNL4DPdyCt57/0wXPsnwR1Pa
         S0/w==
X-Gm-Message-State: APjAAAW0zA94T0gurdv9Y6XUR/C0tY2dihCH2g76YQFUAvRIoc/BXKK/
        InHDivHoZoHQWFf8FSV06qe8jA==
X-Google-Smtp-Source: APXvYqyZX4qTliGmBwAA0qlJazpz9hJ63jJXKXGKdIird2/HtvLBbXfXS+VbRg3jjUjjaVqlBbwUgg==
X-Received: by 2002:a37:b342:: with SMTP id c63mr12619566qkf.292.1560793288588;
        Mon, 17 Jun 2019 10:41:28 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 2sm7928056qtz.73.2019.06.17.10.41.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 10:41:28 -0700 (PDT)
Date:   Mon, 17 Jun 2019 10:41:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/2] tcp: ulp: add functions to dump
 ulp-specific information
Message-ID: <20190617104118.362ac55b@cakuba.netronome.com>
In-Reply-To: <d840dc535ab546408f6280e04b8d492fa2b0c24c.camel@redhat.com>
References: <cover.1559747691.git.dcaratti@redhat.com>
        <a1feba1a1c03a331047d3a7a3a7acefdbee51735.1559747691.git.dcaratti@redhat.com>
        <20190605161400.6c87d173@cakuba.netronome.com>
        <d840dc535ab546408f6280e04b8d492fa2b0c24c.camel@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jun 2019 15:06:33 +0200, Davide Caratti wrote:
> > > +		if (icsk->icsk_ulp_ops->get_info_size)
> > > +			size += icsk->icsk_ulp_ops->get_info_size(sk);  
> > 
> > I don't know the diag code, is the socket locked at this point?  
> 
> as far as I can see, it's not. Thanks a lot for noticing this!
> 
> anyway, I see a similar pattern for icsk_ca_ops: when we set the congestion
> control with do_tcp_setsockopt(), the socket is locked - but then, when 'ss'
> reads a diag request with INET_DIAG_CONG bit set, the value of icsk->icsk_ca_ops
> is accessed with READ_ONCE(), surrounded by rcu_read_{,un}lock(). 
> 
> Maybe it's sufficient to do something similar, and then the socket lock can be
> optionally taken within icsk_ulp_ops->get_info(), only in case we need to access
> members of sk that are protected with the socket lock?

Sounds reasonable, we just need to keep that in mind as we extend TLS
code do dump more information.
