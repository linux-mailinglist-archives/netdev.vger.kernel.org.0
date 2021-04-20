Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1620C365BF6
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 17:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhDTPQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 11:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhDTPQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 11:16:50 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24054C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 08:16:17 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gq23-20020a17090b1057b0290151869af68bso931853pjb.4
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 08:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W8oBZReBLaGVxXRThurxi1+1m1C5mVu6zWU7p2AMF/Q=;
        b=X6z7z8C5Vih4Q92DPFW8uMaRKxMNyJo8Xo0zngA+PgtY2W/Mgvi4M1Gs4ytB9DBueH
         8cDGx3pfSPsE7xlWny67+zluE0n6GOxGa/YTciaKPBwsXyK1QkMZ6phMP20vFTrbAPNO
         Yiu5P+Lop25LoKI1xvF26u5oikU+nPrXdlhV9TisQ8cfGw3FI/6C8t0es/23SOKv0uHf
         o7bSobQcvVEznTddO49J1Puzq99jCKdeoyNLE+ZgaykhmB3SiaE9otFvR/D33nRPLkSx
         30ijf8FES5hZFgizBoTjTx7bLE0+xq9IVwTfR6RMUzTEqxo/3HtYEDyxAPomZHPwV4ah
         QgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W8oBZReBLaGVxXRThurxi1+1m1C5mVu6zWU7p2AMF/Q=;
        b=IZQdW+8tA5QBjjyCQQo8IRxKLBdUuBZUlnT07vewqxlhY3kyVG+keF8/Wgcr/j2qSh
         LJEd7nkJlb1ASWQbDrN0aWtloUTbKDWZCd9CeK0aH9f0DLzcB2b/MKj/uaffnDutI9/V
         2lwxCuZQXB0iZP3en8njN/YIQzmJRMnUwC2/5xGwNN9Hu4b59QWqgtzm5XIse0xqcyiW
         YWgK8SUZm/ckfYHcrtpnQCc9zr2MJkWWQZfGgbUWFSX6pQviWUaqFU38ur9svLSliYh5
         PUhBNIF9Wu4zUCzQTdKKx400fCFAtsCW1/GcSgSRheEzCINTlK3kbj3sHcpuXIt3AB5x
         IvbQ==
X-Gm-Message-State: AOAM530pe2JbJ4WOIjRSTQ2php7njZyAClzejZIT+b3ex3YWJ3ySmW/B
        v8cMUnfNIO+XttMkQyV9GYIGdQ==
X-Google-Smtp-Source: ABdhPJxVmTEHNe8CuB9b1AEL7cRONkHsTzQKRprMD91+xTiPCUVqK26t/uqTVM5xasMzEZl11wlEHQ==
X-Received: by 2002:a17:90a:4381:: with SMTP id r1mr5779663pjg.214.1618931776619;
        Tue, 20 Apr 2021 08:16:16 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id y10sm529748pjt.22.2021.04.20.08.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 08:16:16 -0700 (PDT)
Date:   Tue, 20 Apr 2021 08:16:08 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Tony Ambardar <tony.ambardar@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 v2] ip: drop 2-char command assumption
Message-ID: <20210420081608.3287f75f@hermes.local>
In-Reply-To: <20210420082636.1210305-1-Tony.Ambardar@gmail.com>
References: <9008a711-be95-caf7-5c56-dad5450e8f5c@gmail.com>
        <20210420082636.1210305-1-Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Apr 2021 01:26:36 -0700
Tony Ambardar <tony.ambardar@gmail.com> wrote:

> The 'ip' utility hardcodes the assumption of being a 2-char command, where
> any follow-on characters are passed as an argument:
> 
>   $ ./ip-full help
>   Object "-full" is unknown, try "ip help".
> 
> This confusing behaviour isn't seen with 'tc' for example, and was added in
> a 2005 commit without documentation. It was noticed during testing of 'ip'
> variants built/packaged with different feature sets (e.g. w/o BPF support).
> 
> Mitigate the problem by redoing the command without the 2-char assumption
> if the follow-on characters fail to parse as a valid command.
> 
> Fixes: 351efcde4e62 ("Update header files to 2.6.14")
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> ---
> v2: (feedback from David Ahern)
>   * work around problem but remain compatible with 2-char assumption

I am ok with this, but if you change the name of command, you can expect some
friction (and non support).

The original commit was inherited from the original integration of tarball's
into BitKeeper. This "feature" was put in by Alexey Kuznetsov back in orignal 2.4
time frame.
