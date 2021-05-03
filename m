Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4BF371749
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 16:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhECO6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 10:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhECO6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 10:58:51 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD0DC061761
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 07:57:58 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id s22so3810429pgk.6
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 07:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2/OgfIPTbAC9NLUVtSRA/mfV9EgOxXzgWwld4I4WlBw=;
        b=snXsHpO1bZgbEBk2EQKrvB9pcvXblmJcHXAPCDM0Xlz1x+vECdDr54U1weiTipJIPI
         P4JgbZGeG5D5IE/fRqsvm6hpZDjKJ/tQzzZpWaF6PVjEC+wXlceHKITmxHBjzP4j2kLQ
         e9mPSqp8inCosOzTj/DsZUFczfal5EdjKjfvwnrWx/o2M5rbZ3BQ5eD0uW7KQGBBvoaE
         6G3HrrW++kA8ovo0B9vy7bNgvWFUejeO4dhKvKyDvbXuMmXatEuddbcbki7PulT2jR0x
         4eDIqMmFjmYG4JURO2KzGepmcdSRW917fBKtunXG5WAJvPk5FY3uutYRUjhG0MJpBNFe
         dA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2/OgfIPTbAC9NLUVtSRA/mfV9EgOxXzgWwld4I4WlBw=;
        b=KjOQRTlchJoQB2Gr4dQXmIgfLF5BArEoaGQdUTF/G2AVeWN+4VPSF5gVGQ0Y7lFFV+
         Rvu5r4XtahHlBNnfmsl4Lh/z/XqdO8v9tqO6LN7sGyPdTDVypKZKhTRH78wLfFunXIps
         16MarwvMq46s6qWtzNCoe/pwXoD7UxmF4HtBjxAWtVvt7rETJYj/gjyWMIEkxQzOS9Xm
         oVA24ss4Tfhfg5CokDjxO1Y1/meUUbEX41BExZHMe16wv+BPylAaX1X6tns1wE3g4rI2
         Qqc41Vz2cYaeQTB3dAi+sWDDPmUozuQAWOFaqMrPIzOrGZQH5/YvHMvU6sDY1kjqjz/K
         jxGw==
X-Gm-Message-State: AOAM533mY0Y96t9cG+41v78MKC/eOgpB0xSvN1NpOrCfCaO3LHQZu1qv
        bIhZBe4xpR4iwXjQM4+NlZ/pxw==
X-Google-Smtp-Source: ABdhPJyD5QY2SKDOECrRjVUrKOnuVdqLTtt3tkpqIhwvi3aTrpGCAj2kht428eTLNkijTLrEqu/4vA==
X-Received: by 2002:a65:5b8e:: with SMTP id i14mr18045251pgr.324.1620053877901;
        Mon, 03 May 2021 07:57:57 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id k20sm9173139pfa.34.2021.05.03.07.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 07:57:57 -0700 (PDT)
Date:   Mon, 3 May 2021 07:57:39 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PACTH iproute2-next] ip: dynamically size columns when
 printing stats
Message-ID: <20210503075739.46654252@hermes.local>
In-Reply-To: <20210501031059.529906-1-kuba@kernel.org>
References: <20210501031059.529906-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Apr 2021 20:10:59 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> This change makes ip -s -s output size the columns
> automatically. I often find myself using json
> output because the normal output is unreadable.
> Even on a laptop after 2 days of uptime byte
> and packet counters almost overflow their columns,
> let alone a busy server.
> 
> For max readability switch to right align.
> 
> Before:
> 
>     RX: bytes  packets  errors  dropped missed  mcast
>     8227918473 8617683  0       0       0       0
>     RX errors: length   crc     frame   fifo    overrun
>                0        0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     691937917  4727223  0       0       0       0
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       10
> 
> After:
> 
>     RX:  bytes packets errors dropped  missed   mcast
>     8228633710 8618408      0       0       0       0
>     RX errors:  length    crc   frame    fifo overrun
>                      0      0       0       0       0
>     TX:  bytes packets errors dropped carrier collsns
>      692006303 4727740      0       0       0       0
>     TX errors: aborted   fifo  window heartbt transns
>                      0      0       0       0      10
> 
> More importantly, with large values before:
> 
>     RX: bytes  packets  errors  dropped overrun mcast
>     126570234447969 15016149200 0       0       0       0
>     RX errors: length   crc     frame   fifo    missed
>                0        0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     126570234447969 15016149200 0       0       0       0
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       10
> 
> Note that in this case we have full shift by a column,
> e.g. the value under "dropped" is actually for "errors" etc.
> 
> After:
> 
>     RX:       bytes     packets errors dropped  missed   mcast
>     126570234447969 15016149200      0       0       0       0
>     RX errors:           length    crc   frame    fifo overrun
>                               0      0       0       0       0
>     TX:       bytes     packets errors dropped carrier collsns
>     126570234447969 15016149200      0       0       0       0
>     TX errors:          aborted   fifo  window heartbt transns
>                               0      0       0       0      10
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Looks good to me.

Maybe good time to refactor the code to make it table driven rather
than individual statistic items.
