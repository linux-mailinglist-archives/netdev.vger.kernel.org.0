Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D8E2A4C93
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgKCRSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgKCRSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:18:52 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E7BC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:18:52 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id ay21so5794713edb.2
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/sPfvbVi7QXb8S3+JYBj/CdNR/b98WBDNC7gKHnJjUs=;
        b=R/+VGUB3fdJUTAaZGXZOf07ypwLtxRFbc74vJBf2GRW7Gb0giio8oG/Hpsix3bjjNy
         DBPwAiVd6LoNj9mCE2r9k/aAcKWvJJRQs3+HTAv7NAo+ylUnQeNZ+NsFiC2yoRhoXt7o
         wpBrg8/ba9XXDtt0hx2LipWGDbGzNoFWLHfDKmv3yx3r58rdtdXo7tfrRbh5kX+GzUl/
         SKluti5Fa3VSI4EYTk3CEe6fgZWL9jz8980VlIsFt7EOwmgtl9/jaaqZPn4V08oMU448
         Z8KcIyh+892yUbq9aRRFrFItBlGMDofC9DCG/LJb/EwTW9e4gKJFmRydG+2aLsF/MlUX
         Pcmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/sPfvbVi7QXb8S3+JYBj/CdNR/b98WBDNC7gKHnJjUs=;
        b=Jhxhy2Ogcc2uUKijfDXxclNlidi/RcvagSfCxogRK0Fd/fVOXrL4JaqPKZiE9QnKQV
         DIf/8k+E+eDgl76a7VudlBo2k2uPtdT81oPiDut9gh+//esM9YwkTYWzGvSc3FMWEYXU
         5R60yPnMkfULdbflSZFaxNatL6fkYViYHGmVoUhyhPfeH34vp0CdEnkbg2X2Js+OSXpu
         9MdZmun3gg/irJn1UaAdfKQqHZPSVfYjJE0yaBRU2eWht71C8kNydMQrDFdLTNzA6BEI
         KFq3Gt00PjsmXvG+bgC4wXxK4CDf+085YYR5QHy/vuB9PM4mbR6PcBVw2x7H+QS5kVQW
         6iXg==
X-Gm-Message-State: AOAM531EuOhxC4yto1N1CIMY/XN0TupIjbE5l54kOVa2/cDl9nrbryWf
        o/bO7ogV2P22wgkCTuwrd1Q=
X-Google-Smtp-Source: ABdhPJzMwauRGKhukELJYCyILT0P2jfJmAvIu8ZEifl1IZT+6ILiRDwPjy21qFCqUOrc1ocGIU8IQg==
X-Received: by 2002:aa7:d888:: with SMTP id u8mr22000712edq.210.1604423931211;
        Tue, 03 Nov 2020 09:18:51 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id r21sm9162766edp.92.2020.11.03.09.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:18:50 -0800 (PST)
Date:   Tue, 3 Nov 2020 19:18:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, james.jurack@ametek.com
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Message-ID: <20201103171849.vthpu7beenzeayrs@skbuf>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
 <20201103161319.wisvmjbdqhju6vyh@skbuf>
 <2b0606ef-71d2-cc85-98db-1e16cc63c9d2@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b0606ef-71d2-cc85-98db-1e16cc63c9d2@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 06:36:30PM +0200, Julian Wiedmann wrote:
> Given the various skb modifications in its xmit path, I wonder why
> gianfar doesn't clear IFF_TX_SKB_SHARING.

Thanks for the hint Julian :) I'll try to see if it makes any
difference.

Just a wild guess, but maybe because the gianfar maintainer (or me) had
no idea about the existence of the flag, and because IFF_SKB_TX_SHARED
was added _after_ gianfar was already a thing (which it was since the
beginning of git), which is insane to begin with?

commit d8873315065f1f527c7c380402cf59b1e1d0ae36
Author: Neil Horman <nhorman@tuxdriver.com>
Date:   Tue Jul 26 06:05:37 2011 +0000

    net: add IFF_SKB_TX_SHARED flag to priv_flags

    Pktgen attempts to transmit shared skbs to net devices, which can't be used by
    some drivers as they keep state information in skbs.  This patch adds a flag
    marking drivers as being able to handle shared skbs in their tx path.  Drivers
    are defaulted to being unable to do so, but calling ether_setup enables this
    flag, as 90% of the drivers calling ether_setup touch real hardware and can
    handle shared skbs.  A subsequent patch will audit drivers to ensure that the
    flag is set properly

    Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
    Reported-by: Jiri Pirko <jpirko@redhat.com>
    CC: Robert Olsson <robert.olsson@its.uu.se>
    CC: Eric Dumazet <eric.dumazet@gmail.com>
    CC: Alexey Dobriyan <adobriyan@gmail.com>
    CC: David S. Miller <davem@davemloft.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>
