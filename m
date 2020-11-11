Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD4C2AE4E2
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732043AbgKKAZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgKKAZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 19:25:38 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE2BC0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 16:25:37 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id m188so287389ybf.2
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 16:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=zd1aAP41GNUIab/GEls+0lHf4CGW3wK12sr3FNV2fnI=;
        b=BKgVGaKrlDPrGmLV26NBrTDMZSq5kxzOarYpsSw4RZFwGMSyI0JeSmiv8ahaymy0DK
         0YIGUvdN0b1a2LsZf+lizx49xuYU+dLE5Xp0EgfAJoClCmR7NS1aLVwYrnB3m0PT2Z0g
         PCv4X9iF4Uqc0kZo2n34ba1v7mqXnDtp0wFYVsVm/rmj5794ruxuhgDQazvEX2U9T5DU
         dj5Rm7e6maMpSqv5i6QMuinoCl5QrcudKGAbAgFDwbHpMvo89AATnu1dDo1KnrbzGacT
         /f3iPHxj96NnB/SpcT2ss7dJ+mcavg7rGsjQJRaf0Z2JeEQGo5sl8xIWslhSJ2gUwjaQ
         /OFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=zd1aAP41GNUIab/GEls+0lHf4CGW3wK12sr3FNV2fnI=;
        b=K+ZnfH39uRTIUGQaV6DwBYiMfDmEY1dFEZ7I/nTKOzie7ecM/VDJrBwWxNGP4QU6+S
         S2rHjG3D9Rb4y6GnEKFNBjjitLvBaPanSAogaS6I/aW4+GuYUBkLGa+tlkCB1Es921UC
         aCriVvIjNyTvGTfPAeW8GLXjS0q6QaBiiDf9Pc3+b2umtZ6dP3HkRu4GiyNxXRUjwQHy
         zWfECP4DXNWqD/nUg1GJj5+JdtA9LUMj8gfk9rzd9WrfQsN8Pf94UFSEX8rX8Wri2Zl8
         cE6BFUmyQqVKe9Wjnlm6KZgfPHZZyUqpvQAw4px+RR9ghGkZr66/gNloZ248FgEdgigs
         eLiw==
X-Gm-Message-State: AOAM53169nrsF18TApd5gtChN/thSeG8QEARRvGH+U05IwbMXD442BWI
        VSOW1KhvEeA5sRClkvQZkV+BUWjv0WhOLbcUAYF982+l
X-Google-Smtp-Source: ABdhPJyrMk9owkCbe/vB6Fpt8sSzB75Jd7hS7y26s+RVlgTnf/gidZylI/QZpQUe1k+ZUgdPTn5HrzLee3QFM/5Ol3s=
X-Received: by 2002:a25:c382:: with SMTP id t124mr32002742ybf.476.1605054336577;
 Tue, 10 Nov 2020 16:25:36 -0800 (PST)
MIME-Version: 1.0
References: <1605053800-74072-1-git-send-email-yihung.wei@gmail.com>
In-Reply-To: <1605053800-74072-1-git-send-email-yihung.wei@gmail.com>
From:   Yi-Hung Wei <yihung.wei@gmail.com>
Date:   Tue, 10 Nov 2020 16:25:25 -0800
Message-ID: <CAG1aQh+_k0=ZvS4yAJpk4dhQVrksbMxSq_w2PeQbAeigSHN_ag@mail.gmail.com>
Subject: Re: [PATCH] ip_tunnels: Set tunnel option flag when tunnel metadata
 is present
To:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        pieter.jansenvanvuuren@netronome.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 4:17 PM Yi-Hung Wei <yihung.wei@gmail.com> wrote:
>
> Currently, we may set the tunnel option flag when the size of metadata
> is zero.  For example, we set TUNNEL_GENEVE_OPT in the receive function
> no matter the geneve option is present or not.  As this may result in
> issues on the tunnel flags consumers, this patch fixes the issue.
>
> Related discussion:
> * https://lore.kernel.org/netdev/1604448694-19351-1-git-send-email-yihung.wei@gmail.com/T/#u
>
> Fixes: 256c87c17c53 ("net: check tunnel option type in tunnel flags")
> Signed-off-by: Yi-Hung Wei <yihung.wei@gmail.com>
> ---

Sorry that I did not indicate in the subject line of the previous
email.  It should be "[PATCH net]".

-Yi-Hung
