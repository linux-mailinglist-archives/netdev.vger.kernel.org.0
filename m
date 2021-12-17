Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D104795F5
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 22:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240971AbhLQVDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 16:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240965AbhLQVDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 16:03:43 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46925C06173F
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 13:03:43 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id c22-20020a17090a109600b001b101f02dd1so6788218pja.5
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 13:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ywG3K+b0v1h1vdIosCw5UiVznpeUbvFW73m/kjIxzss=;
        b=ld7kptwqGnD4zk5IhoFmhvMK4R5EJnfGLnrMKQP5DDbv8WJ9B9CatvpCefcpFWKeMA
         2BEcQfmwZkF9V6r5rqLsGYBg6BZu7ZwCTasBOnb1p9PrG4uSalG2hL3IbVK0P5b+pFNJ
         gMByKg/IcZj9Wfy6ol4DddS+VqVRbnjKMJVSZrswjwlOmk3H0GG1vh9IgX352Jn07yAm
         kpcxj78x9j171y98iRjpt6QWN8IusAkB/uti3XxaJXWDiuRv4Vjsz2KvsERTCieACJfS
         sqQA8JpLI5JqIzr5i1KioAdR03u/2MSWgxu3ADNcshoxHdsoOmAI1xm0HPEZpssnivnP
         ObsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ywG3K+b0v1h1vdIosCw5UiVznpeUbvFW73m/kjIxzss=;
        b=G65re1KkMLsE4709Gc7VmqsxQOwxMKjGLGexhd8o11fHsHCWtpBaK4QMFdyL9O/nA7
         4UpG1RwuSvXJcZCGp9xboX9BLCluTN553sI0g9fvRUIcbCZHTrZlyk3SoGthXB5f1GhS
         H2lQOERY76KIx+KwmMIpm1aJBfm5LYb2e6KUS3F+Nz1F1SjQiWDYcbq0fqf0M/3wlmPv
         y8TwloVWSrJlReBK3H89CuOX2koNkIQPYiRncO1s3UQ+AoLsz1QbcOuXaOrDpTRJ8vN+
         ZHrQ+WdGCAwU9Y4sKMALKuUHuVjVqsR9V4OzLHnFvboDKvhCNawNu6SwtmkAjXLaYcSX
         l3XA==
X-Gm-Message-State: AOAM532+kmBwkPUGlUB35iEZqJnUBJOXOjkIs3J/4ZihX87bNJm3xOS8
        oHYuJ91yLhLYFnCyrTXF3v4JSg==
X-Google-Smtp-Source: ABdhPJz+MLn1Xx7Uc9uThUDUYZ5pqe46UztRNM5KMmNkA7etR6yNz8Tlu0PiQsNJNWqbXmFESBlnxA==
X-Received: by 2002:a17:902:7686:b0:148:cba4:26b0 with SMTP id m6-20020a170902768600b00148cba426b0mr4970263pll.2.1639775022794;
        Fri, 17 Dec 2021 13:03:42 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id 145sm9265280pgd.0.2021.12.17.13.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 13:03:42 -0800 (PST)
Date:   Fri, 17 Dec 2021 13:03:40 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 6/6] net: marvell: prestera: Implement initial
 inetaddr notifiers
Message-ID: <20211217130340.67cb775b@hermes.local>
In-Reply-To: <20211217195440.29838-7-yevhen.orlov@plvision.eu>
References: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
        <20211217195440.29838-7-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Dec 2021 21:54:38 +0200
Yevhen Orlov <yevhen.orlov@plvision.eu> wrote:

> +/* This util to be used, to convert kernel rules for default vr in hw_vr */
> +static u32 prestera_fix_tb_id(u32 tb_id)
> +{
> +	if (tb_id == RT_TABLE_UNSPEC ||
> +	    tb_id == RT_TABLE_LOCAL ||
> +	    tb_id == RT_TABLE_DEFAULT)
> +		return tb_id = RT_TABLE_MAIN;

That is a useless assignment why?

