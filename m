Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53F424622B
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgHQJLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgHQJLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:11:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1706CC061342
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 02:11:43 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a5so14182300wrm.6
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 02:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=07PeHWdMcjvU0Z3mRCz4j6J4OnybjlFdXNQEtkp5iNM=;
        b=v15ar5ZUf9fg2i9QpHlhA6tdSPxe3HKgh6yeZR7gDrMQwuAwkn6z0ypi/Jst3Xy+/9
         znCE6w6lWD3t0eiVK1ZnPHfiRnsWsNz+N0PIp5zraYB3uKpz2TBYyrDWVPEhcZ9G9tBv
         mby8rluoaeyMAXtw9tU5Mb8qKohXcPYb0BJkvdX+bZRi5rl0V1Y2GdLEdEp+tX/IuqiZ
         pFNDiah4j6cRgiSjjUcXqrHTdSJw+qCfUzu+CM+b/Dft1Q8pQrScUi5PmBDf9fvZh925
         1Q7Sv9WDpx0GX/iB1FJBym/ML+ZNHveCrT5hC/Q1z1IHpgFqmxaMnqt9+Z2wW4DnPHqN
         wNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=07PeHWdMcjvU0Z3mRCz4j6J4OnybjlFdXNQEtkp5iNM=;
        b=M3HjxkLzmBHgGcNUQmMSM4yMx7YI5mTDScKancPAsHJyyNaNKbZ5gJh6KPCn2JD7xf
         3S7f2A9PyHWFW7b0PIEU6CaIwdRUCK2D26ke0AswYP4Ci+/mDufd/jXI7Nln6k0SmRba
         ARb0lnv1pLsFSau01fjjJLewK2Buv26pEwUA1JRXnXXcNILJ6auF7kcxhMZrrTuGgHl5
         hakMCtDs0ZSb+8I7101rlqmRAk+ItYbBusPg2uwfGJUboR8xncB3c9IA2LCB5q4qolw3
         3vAd75jqtzKjK6Hsrbs//aRKiFLLCUmViGb2o0lhVlA7ar1TCj0BRRtkvS+9gS3LYetr
         KPAA==
X-Gm-Message-State: AOAM5311F8nOh1/ZGhuy9Ml74Ov0XDNLRTrvMKNw3Mn2XYo1Jms4idGf
        KVPSrdfLw0ieVn2QzSiIpDiwuQ==
X-Google-Smtp-Source: ABdhPJzb6oTwo2yK93dI70IfJGN9epiVad6B2+zA3GHeS9TaBGz+cBETqM9IVYZ/+Y6/tC5EHWTY/A==
X-Received: by 2002:a5d:6910:: with SMTP id t16mr15249162wru.178.1597655502546;
        Mon, 17 Aug 2020 02:11:42 -0700 (PDT)
Received: from dell ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 15sm27555396wmo.33.2020.08.17.02.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:11:41 -0700 (PDT)
Date:   Mon, 17 Aug 2020 10:11:39 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        Michael Buesch <m@bues.ch>,
        Stefano Brivio <stefano.brivio@polimi.it>,
        Andreas Jaggi <andreas.jaggi@waterwave.ch>,
        Network Development <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        Martin Langer <martin-langer@gmx.de>,
        van Dyk <kugelfang@gentoo.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 26/30] net: wireless: broadcom: b43: phy_common: Demote
 non-conformant kerneldoc header
Message-ID: <20200817091139.GU4354@dell>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
 <20200814113933.1903438-27-lee.jones@linaro.org>
 <CACna6ryNNyyVftEFNFEwouKc3O21oPaeqie+bjJR4L_Cf8z2BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACna6ryNNyyVftEFNFEwouKc3O21oPaeqie+bjJR4L_Cf8z2BQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Aug 2020, Rafał Miłecki wrote:

> On Fri, 14 Aug 2020 at 13:41, Lee Jones <lee.jones@linaro.org> wrote:
> > Fixes the following W=1 kernel build warning(s):
> >
> >  drivers/net/wireless/broadcom/b43/phy_common.c:467: warning: Function parameter or member 'work' not described in 'b43_phy_txpower_adjust_work'
> 
> Why you can't document @work instead? Should be quite a better solution.

It some circumstances it would, but not this one.

 1. This 'kernel-doc' function is not referenced from any
    documentation location i.e. it is presently unused and there is no
    reason for it to be kernel-doc in the first place.
 2. This patch stops `scripts/find-unused-docs.sh` complaining about
    phy_common.c
 3. 'b43_phy_txpower_adjust_work' is the only function that has been
     documented as kernel-doc - why is that?  Seems like a mistake.
 
-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
