Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165F2462AEC
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 04:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbhK3DQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 22:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhK3DQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 22:16:14 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5594CC061574;
        Mon, 29 Nov 2021 19:12:56 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id 15so10551068ilq.2;
        Mon, 29 Nov 2021 19:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fx1elTupkFbgmCM3YD9gEMysoL18Kn1d1nNxskCtHmU=;
        b=G2YSevvrJU/zsMfhPYtIuOqj4U4rEtZGbaV9+ELTq+jawNeYd1ee0FxJP+TTt9Ti3Z
         5ExUXsYTU6ZkAQvb0xppKuK20p+QWLjJv6BtCkIrkE/ToYkdV5Ynnpcjl+C5icanYw6x
         gMZiiGwO0qJTItadpTySGlhYKCv2FyRIcPUgZI2T6SeIp3f8Sv8u3ygoQ+SBtQNmikAX
         OemBM0g+CRss0zQZe9c+rYUk95FCGnNfC6nKqeU11PlQ0jxyn+hbCyOg0Zxr7wRo1FbX
         eJOoCuqchrcim+5AuN/gnCJfgsU/BlJvSwjx3HY3U/FYOcmp4gwGrqNaZr5Ph7UjeD/s
         g1JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fx1elTupkFbgmCM3YD9gEMysoL18Kn1d1nNxskCtHmU=;
        b=jwT3yai7kkzQqLft1DDXdI5XxaZpZum6MwW4L8bWnYO2fnb0/CLeRVwEaJSdRbzGUR
         mlBXhmbdv84CeGAeoVKUGfaDFj+bPaZxMzqGAvv1uPd7XjnkupvPGSkqXcycvGJTDvZ5
         JmYdxrOUPPyKvr/8vBmgxQYhfdS9nyL7FYwDneFAnf4MDn/kQh4Sos2nN4yjqGHyWPqM
         2Mh/daT5htfJz9vjifNzYuW1WeDY8+ecb4TQpgxp3A1MlE+w0R6ACKGFLFPQSbpcH1Kw
         dibFjOe6peMxNgVxA+9S0zJsoAl/8CRabr9dziwj9U9H6Tv2ieFAjn1zP8mF4AuDOIy+
         XTxQ==
X-Gm-Message-State: AOAM532NqNGmptjrcENzDxx/C67+knxKTx9CnaAvAbHP5gCdMJEbD+ZS
        NOAv7//s3AzmzR7CotHCmoU=
X-Google-Smtp-Source: ABdhPJwm/iFxG7GtT6zyr5QKBe4DoTVnfOn7/S5fnsPnymtg+/3+AxgbIMYsXg/FqBZ5vLrgDIS1Gg==
X-Received: by 2002:a92:c04e:: with SMTP id o14mr49149633ilf.273.1638241974780;
        Mon, 29 Nov 2021 19:12:54 -0800 (PST)
Received: from cth-desktop-dorm.mad.wi.cth451.me ([2600:6c44:113f:8901:6f66:c6f8:91db:cfda])
        by smtp.gmail.com with ESMTPSA id s21sm9094756ioj.11.2021.11.29.19.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 19:12:54 -0800 (PST)
Date:   Mon, 29 Nov 2021 21:12:51 -0600
From:   Tianhao Chai <cth451@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
Subject: Re: [PATCH] ethernet: aquantia: Try MAC address from device tree
Message-ID: <20211130031251.GA1416412@cth-desktop-dorm.mad.wi.cth451.me>
References: <20211128023733.GA466664@cth-desktop-dorm.mad.wi.cth451.me>
 <223aeb87-0949-65f1-f119-4c55d58bc14a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <223aeb87-0949-65f1-f119-4c55d58bc14a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Calling is_valid_ether_addr() shouldn't be needed here. of_get_mac_addr()
> does this check already.

You are right. I'll remove the check.

~cth451
