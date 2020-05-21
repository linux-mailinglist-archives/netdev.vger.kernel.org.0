Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332901DCE2B
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 15:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgEUNdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 09:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729536AbgEUNdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 09:33:52 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C825C061A0E;
        Thu, 21 May 2020 06:33:52 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id z18so5466338qto.2;
        Thu, 21 May 2020 06:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EQm3KwRvgaHxQ5d1Q4EsqwYQDDPz8ESa9iFyt4vvvfU=;
        b=A1yY0pcUPS8ck0PV+oiK0L7Xz4/CMf99HFvZLNGUwtkmJl1HZgyPoRsWMMpkPViZh0
         g5zjGf3xBdccjZCBDrDAtY8wQjaBZ20OxMUJOX2ygsAZmQ7FAOTD578Pi8cO/AGsz/0k
         +6GEYqQqrDeTvrPiNG4dFgi17HrIhPWpILlQe2Haz/tBvylaHUHhtLMH1x1JgMBfFxbG
         dVhzC9D5lQnZ9bUPGy2DvBKfUkckuBYamDN1KFet5x5I1KxpS/Xd/0nP+OBlUFjYmTJ3
         d3tseyuZBcS/wV3owA0JIbRvtw028OV+O6ZJMOkqyJt0SMGeOHIN4l7beBYArRlnUqQR
         Cj1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EQm3KwRvgaHxQ5d1Q4EsqwYQDDPz8ESa9iFyt4vvvfU=;
        b=dsv0KKILWi1qP2fyzqRMUc2fyifuGsvTA5in5LUhKPDhnz6ko3ILxneAtEXyfQgm8j
         3//eoOl7Ut974Wig/Iyotsop7GBmCGnK+L68wj2C9qFebfUkQVwLkyCjDHaqd727Vf0t
         OZCRHW1IH+uSl3x/77aaX2AOf2KcZAhdxT9OLU827GEd41m4dTVEPra/MYrfYm0R1bEm
         WWkDkGiLGuLpQQQJTXWD/XPPLd7OMgaW97NDyPhz95RJyGCvllaEMWV27YijHwlXXuWK
         8F9z0gOjusZ0ymiSksdhgPQiaf5JvycnAdqxikGdqvyEQRxa9WTOROFRcDz7lgRltW/T
         Q5+g==
X-Gm-Message-State: AOAM531z8CQX+KVgcu2DS1axo/V1ovH/zd/mJyElUyi+srRstGc5h46g
        cWIDJ+sMm4hO3/wPyTDCTFBm8GkCEDjsdA==
X-Google-Smtp-Source: ABdhPJzWBT98PJLkbYawA91UQ6OHszxicgo3NkwFTGAv08qIHw76JSy/EnOeEfPbcxMUsuNECRy/Lw==
X-Received: by 2002:aed:2bc4:: with SMTP id e62mr11045622qtd.263.1590068031488;
        Thu, 21 May 2020 06:33:51 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.225])
        by smtp.gmail.com with ESMTPSA id l184sm4861282qke.115.2020.05.21.06.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 06:33:50 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 3AF26C0BEB; Thu, 21 May 2020 10:33:48 -0300 (-03)
Date:   Thu, 21 May 2020 10:33:48 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, jmaloy@redhat.com,
        ying.xue@windriver.com, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-nvme@lists.infradead.org, target-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        ceph-devel@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH 31/33] sctp: add sctp_sock_set_nodelay
Message-ID: <20200521133348.GX2491@localhost.localdomain>
References: <20200520195509.2215098-1-hch@lst.de>
 <20200520195509.2215098-32-hch@lst.de>
 <20200520231001.GU2491@localhost.localdomain>
 <20200520.162355.2212209708127373208.davem@davemloft.net>
 <20200520233913.GV2491@localhost.localdomain>
 <20200521083442.GA7771@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521083442.GA7771@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 10:34:42AM +0200, Christoph Hellwig wrote:
> On Wed, May 20, 2020 at 08:39:13PM -0300, Marcelo Ricardo Leitner wrote:
> > On Wed, May 20, 2020 at 04:23:55PM -0700, David Miller wrote:
> > > From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > > Date: Wed, 20 May 2020 20:10:01 -0300
> > > 
> > > > The duplication with sctp_setsockopt_nodelay() is quite silly/bad.
> > > > Also, why have the 'true' hardcoded? It's what dlm uses, yes, but the
> > > > API could be a bit more complete than that.
> > > 
> > > The APIs are being designed based upon what in-tree users actually
> > > make use of.  We can expand things later if necessary.
> > 
> > Sometimes expanding things later can be though, thus why the worry.
> > But ok, I get it. Thanks.
> > 
> > The comment still applies, though. (re the duplication)
> 
> Where do you see duplication?
> 
> sctp_setsockopt_nodelay does the following things:
> 
>  - verifies optlen, returns -EINVAL if it doesn't match
>  - calls get_user, returns -EFAULT on error
>  - converts the value from get_user to a boolean and assigns it
>    to sctp_sk(sk)->nodelay
>  - returns 0.
> 
> sctp_sock_set_nodelay does:
> 
>  - call lock_sock
>  - assign true to sctp_sk(sk)->nodelay
>  - call release_sock
>  - does not return an error code

With the patch there are now two ways of enabling nodelay. It may be
just a boolean set today, but if one wants to probe on it or if we
want to extend it with anything, say a debug msg, we have to do it in
two (very different) places.
