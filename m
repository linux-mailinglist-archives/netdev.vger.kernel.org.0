Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80AB3FFFA2
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 14:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348265AbhICMR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 08:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbhICMR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 08:17:26 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD16C061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 05:16:26 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j2so3206532pll.1
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 05:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7RsEFc5G/M5mEtFl6V5W+wdLbn42NgVxSOlGSj9BYMQ=;
        b=j0CyItVNpmzi31jGuIO3AnoLJr70sf5Rr+MbYEUeoDG5d+xvyFf+BHy9sSG3KrdKbj
         KNTu5CKMQUptcfW+WCw7gMTDnNIvCDn3WiodhPzE+VljGFaBoDLbp3HpeiQlqlrbidZN
         xHyb6fqRHDLWEsYjJODvfNFti9rZOJyc1UFfzcpmJstX7yuGX6Yrw0y+lzoo2aVv2FAC
         2nt31iYYjkk/rTX/mN+m8mx4NYB6T06OscogrDohgPLJoqnznDYhL2f63k36sALTWso3
         9CiVZXgHgu+uKY5TvdPniyEj/ihcNjDfJuUs/vVYGo7wEVElh/7ch9n02IqmwtqU22Z3
         a2+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=7RsEFc5G/M5mEtFl6V5W+wdLbn42NgVxSOlGSj9BYMQ=;
        b=bh+g6diGXA0uAjAixO/aj73BXYzyQ7qOisN1y7yA3v+0xhI0Xt8mzssM2yBfdbrHxp
         Wv1eMI2VCt9/EArOHv9DSObf43DusvOWWDXrblwHg/TqzfllNS4A1QzOrNsqTzhoWRru
         bGjSu61YtZqWh6eoZRIEt4c6vs8M8yqS3B7VDcqHMt2fzn/xXc2aa5nDC7Z1ViYHiyma
         ACNAvpPfc+tgrP84Dq5Dvl3g2Fo5DE1QStLA9N+hbUji5vPACExrcVUAD02Y6w91YA30
         hLtHPVJyVlnyu7m9bMucyqiw7fluxBSxHrxvJl3qZsDEO4Dp2SeGT0H0u9BemAhakemS
         8SxA==
X-Gm-Message-State: AOAM5315g9nUdrjM8YGFFclgNn9M4pHehbjJwmHHMVDOtQwonD/Rwm2I
        xhk6ttHDwO1SaNZ+fVNqSRsPMow5VCE=
X-Google-Smtp-Source: ABdhPJwESWt7PnH1e9xWhvnuH3TWQzV90q71BabG7+4YecekT6Pe0+MAP9t35mvpfoLigdMHaLseOA==
X-Received: by 2002:a17:90a:2f23:: with SMTP id s32mr9367333pjd.168.1630671385920;
        Fri, 03 Sep 2021 05:16:25 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o10sm5097907pfk.212.2021.09.03.05.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 05:16:25 -0700 (PDT)
Date:   Fri, 3 Sep 2021 20:16:19 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>, Xiumei Mu <xmu@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, wireguard@lists.zx2c4.com
Subject: Re: [PATCH net] wireguard: remove peer cache in netns_pre_exit
Message-ID: <YTISE6AI3y3Le9ww@Laptop-X1>
References: <20210901122904.9094-1-liuhangbin@gmail.com>
 <YS+GX/Y85bch4gMU@zx2c4.com>
 <877dfzt040.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877dfzt040.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 06:26:23PM +0200, Toke Høiland-Jørgensen wrote:
> Ran this through the same series of tests as the previous patch, and
> indeed it also seems to resolve the issue, so feel free to add:
> 
> Tested-by: Toke Høiland-Jørgensen <toke@redhat.com>


Thanks Toke for the testing during my PTO. I will try also do the test.
Toke has all my reproducer. So please feel free to send the patch if I
can't finish the test before next week.

Thanks
Hangbin
