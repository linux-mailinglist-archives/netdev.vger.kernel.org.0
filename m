Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C132E7899
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 13:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbgL3Mjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 07:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbgL3Mji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 07:39:38 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D1CC06179C
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 04:38:57 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id v5so10786095qtv.7
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 04:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g6B1jvIYFNt+pTQgSfU1BPvEpqDrU6ozA3BgZ6EYLDY=;
        b=MXjsAv14Rgr17h9d/jZDMcK6WGX/Qm47KQois39oxpdzXXuMfTpGM+vM40WUp68V0y
         SYPZeeb94DYDRpgbigP/zp3zBaG7Eyl2Gc+NazI7Wk+pLXqR/1xd6JbGOtQwLdi17sE5
         RDv+0NwHiJloiJHye4rgN753/IUpTeMYI+2WlqXeOtsqolF6U7wKD2AuIVaJRkUUJAvj
         9DZylmvo3nL8qDZJ2RLkxf+RCZWgZm/ezo/0Oi/PDL3/nBYWG1V2R3pl5kq7c7I3o6fb
         h+obDDcmvrWmBFsU0Jjry78JJF+/0CSTUDkyoLKKYLXSKO5sX+7z2UWXE9+AbPKnCAcT
         SSyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g6B1jvIYFNt+pTQgSfU1BPvEpqDrU6ozA3BgZ6EYLDY=;
        b=Pk/HHX+IP/Vt0zG3k2odrukyYc3qx/t0j98Cx+ysElXS0jh17rb0RYWGyfIDjT+gUN
         UGNTx5UML+pgI4oOqA6wkOa/aXk9kZHj361V8UEZgcdbgnvYgWU+Iqvzw1GU8UArMkAe
         k3Fuuxsgc+CUIaxUJHAfryp92nFdzMv8M6svKaXjSLEUv7CoRHFT/SoWD16++WgzJoJs
         swoiLzlhju/6SoLBO/uS7oV13oFXygfFbuPupnEw7tM/gNe5NUN99ZxgmptGn7HHObgg
         Gd0BauAoypqBwlR/mKF1ZNEIV9TuU7wmLS8oEVXh67zAy04KsrAkFUtFNe3HrrCaVco+
         /Lfw==
X-Gm-Message-State: AOAM530dUw2XkVRT2PWM6XpNVX6yKhbYjzQ7nEKwGyqZ2kIoRoczfId+
        WiVUpf3sALpW4e0wMlIItQ8=
X-Google-Smtp-Source: ABdhPJyRju1DejHML5loTCAkgAtI+mezYkUzSQrbnfYJYwEvq1ilZdfnRz5sE67uPagoixp8Sr3F5g==
X-Received: by 2002:ac8:5794:: with SMTP id v20mr52481966qta.175.1609331937122;
        Wed, 30 Dec 2020 04:38:57 -0800 (PST)
Received: from hoboy.vegasvil.org (c-76-110-219-245.hsd1.fl.comcast.net. [76.110.219.245])
        by smtp.gmail.com with ESMTPSA id l1sm27717119qtb.42.2020.12.30.04.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 04:38:56 -0800 (PST)
Date:   Wed, 30 Dec 2020 04:38:54 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH rfc 3/3] virtio-net: support transmit timestamp
Message-ID: <20201230123854.GB2034@hoboy.vegasvil.org>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-4-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228162233.2032571-4-willemdebruijn.kernel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 11:22:33AM -0500, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Add optional delivery time (SO_TXTIME) offload for virtio-net.
> 
> The Linux TCP/IP stack tries to avoid bursty transmission and network
> congestion through pacing: computing an skb delivery time based on
> congestion information. Userspace protocol implementations can achieve
> the same with SO_TXTIME. This may also reduce scheduling jitter and
> improve RTT estimation.

This description is clear, but the Subject line is confusing.  It made
me wonder whether this series is somehow about host/guest synchronization
(but your comments do explain that that isn't the case).

How about this instead?

   virtio-net: support future packet transmit time

Thanks,
Richard
