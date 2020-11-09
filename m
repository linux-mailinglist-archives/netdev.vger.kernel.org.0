Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FF32AC731
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730772AbgKIVXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730702AbgKIVXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:23:37 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C4DC0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 13:23:36 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id i19so14403386ejx.9
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 13:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=j8My5IFmXvyB00yHZ5L8YDoeM8fRNSXkVe9OuZDrALU=;
        b=afgio80msR92ILON5S3opwXsM90Q9GcbNyd3mMzj6Pa+lmboHukGiEQnM+vlaYSwnv
         ui7x1o2qV37Wim8wBtws+jsKHwVA0qtg/KnJFN0OFRfsvt97u3qx1xXoIJ79i+WUwVme
         F+kIG22cJyhtQr94KxJQpy9RTttS9W9A0Ssss2/jfWsdMSabi5BYelfbYW2iWw7sYNq9
         HQYaELin35IxyULj5vw8V37My1ErhTX/npaSODZiQV+OHzA0RdZTWQZ/3m+Ah5dbtwah
         uF6GWjOCFpsJUCZn21wFgMufrfoUj34DvtG5/QMFqIQhPL2+Hx5xsJd0nfpwAAMrzzcV
         NLsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=j8My5IFmXvyB00yHZ5L8YDoeM8fRNSXkVe9OuZDrALU=;
        b=brIWWXFG92Hya5RSCb/Nma/araRbY0g0zV+JVBv3O8+mjoC1NpN5iOA3RBC4OBCXWp
         UhUbZT2QDr4173+estWJMbd/I4+pChwZz8fyElM/KkZ4rdvM7P7UOLmSSmZ5u/enmlyU
         IlTA/E1GgnMO7sXHa+0SDkQVVemy36Gzi03M8bOe0Yao3INbBCmqidTKZoDBAy8zqzcN
         WiNBlR9/hiS9JXMYaQ3Pg97otpYTaoaXNiuXZBpZNWHdMvaOEvFO3J9glpmj8BDOT32e
         yBVSoEWSHARNIn9GdQ5M9lA0nz7jLFsWtDP/V7/Ht3A0Hkv8hgZ4BVq2DWGIGa9RRrsM
         0Xdg==
X-Gm-Message-State: AOAM532O+03V5IkIA0R33dmPEO7xJ/vUFY9LkHN/f8wFL8gb2Axsrrum
        hQRfaiQ8GnkzbWjGIq5iegVDzQ==
X-Google-Smtp-Source: ABdhPJzCPYUCSBeDyT0rMK/QZdjFCxYcw4cw5LZ8Dam1u2cYKhdubfEhCk/Z4CH++TgsN8rncBDZ6A==
X-Received: by 2002:a17:906:3102:: with SMTP id 2mr5514565ejx.135.1604957015229;
        Mon, 09 Nov 2020 13:23:35 -0800 (PST)
Received: from [127.0.0.1] ([72.11.157.36])
        by smtp.gmail.com with ESMTPSA id j8sm9858514edk.79.2020.11.09.13.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 13:23:34 -0800 (PST)
Date:   Mon, 9 Nov 2020 21:23:33 +0000 (UTC)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Geliang Tang <geliangtang@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <62ab8297-41fc-446b-a09e-0b93118a478c@tessares.net>
In-Reply-To: <20201109125703.7d82a34a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <cover.1604930005.git.geliangtang@gmail.com> <ccf004469e02fb5bd7ec822414b9a98b0015f4a3.1604930005.git.geliangtang@gmail.com> <009ea5da-8a44-3ea2-1b9f-a658a09f3396@tessares.net> <20201109125703.7d82a34a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Subject: Re: [MPTCP][PATCH net 1/2] mptcp: fix static checker warnings in
 mptcp_pm_add_timer
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <62ab8297-41fc-446b-a09e-0b93118a478c@tessares.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

09 Nov 2020 21:57:05 Jakub Kicinski <kuba@kernel.org>:

> On Mon, 9 Nov 2020 17:28:54 +0100 Matthieu Baerts wrote:
>> A small detail (I think): the Signed-off-by of the sender (Geliang)
>> should be the last one in the list if I am not mistaken.
>> But I guess this is not blocking.
>>
>> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
>
> I take it you'd like me to apply patch 1 directly to net?

Sorry, I didn't know it was OK to apply only one patch of the series.
Then yes, if you don't mind, please apply this patch :)

Cheers,
Matt
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net

