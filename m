Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EE922DB86
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 05:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgGZDSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 23:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbgGZDSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 23:18:07 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EAAC0619D2
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 20:18:07 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g67so7503139pgc.8
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 20:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=20oWGLBn2Xzgzp3jlz+c9a+GPfo7KJN2mwhINQO/Vbo=;
        b=jCmXOAJrYELw6b9eSmRrkh80a5LzuSS8TXXPMYYI6afdB811UETBFFSiCQ7VrhT22q
         87MipC2lF/gFKU/P2Z+EOMfxuYanU0KDv0Pmm0Bm/vMvG/++akaXCdBTGd8FpIncp9lR
         pPzU4n6G7ib0KvfjUtRUFsfTd2Yb+jfDZMejch2kMKoMDSUB8qX5EBTqBs9+6DxBLYLN
         2yQ2gfpNfsAhpdzxkk4VT6n25IklK9hv27rhckZsLfdpRIqgIcX30YkUMkOwBP0XqIxt
         jK9+aTlptCmqyJSXiUfbhGsH5asK9aRem0w0AKcMx2oHdd3Ys6jaui9ezY6ygxz656xc
         lPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=20oWGLBn2Xzgzp3jlz+c9a+GPfo7KJN2mwhINQO/Vbo=;
        b=iLbX7mq0HFF2xk5O8FQvQrKJZnGROulmvU8f4weC6Il4u/z1lecZ3d990SXpGbW36J
         Tyl+Y3LI4cezfZVH38uYaWUJ0WYzZ5EeDnZtCNFdXb5dZH7nVU4+Q/nQBmirxnaCE9NU
         p9zcc3bCwFYoUEocl4fGogn/eyk2WLk9eXqwBUcVLiz7Jl5FtVcUoxSNSgJPbv1VX/QN
         INxIJ0EHsipJsFI1+Eixmtm2FJ/A0bZrDj8Q90eHoyg/kx7dUsMOJ5yFXHlQGylFCTh9
         EDTxMize17radjr7GsuNmAIt8RQBF/AOjAM4Fe1NcF/OK6ba1W6d0Jh0IxAW3KSQKfI6
         KGhg==
X-Gm-Message-State: AOAM5302y5kwTP9AnHgiO9H5XpgJDVcEPKD+46bFT8a2BlV6mFxq4Nos
        tUksIghmKqmvvOq9hbA/xzA85Q==
X-Google-Smtp-Source: ABdhPJxvENbUer9wMy2t7byDLixStwnwrEWi8lbhoYdI4+NZbuITnCAEfVw9a90OFi24alNpdk61UA==
X-Received: by 2002:a63:f814:: with SMTP id n20mr13915424pgh.92.1595733487174;
        Sat, 25 Jul 2020 20:18:07 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i13sm9737003pjd.33.2020.07.25.20.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 20:18:06 -0700 (PDT)
Date:   Sat, 25 Jul 2020 20:17:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Miller <davem@davemloft.net>
Cc:     nikolay@cumulusnetworks.com, amarao@servers.com,
        netdev@vger.kernel.org, jiri@resnulli.us
Subject: Re: [RFT iproute2] iplink_bridge: scale all time values by USER_HZ
Message-ID: <20200725201758.4cfae512@hermes.lan>
In-Reply-To: <20200724.173112.451428196025351292.davem@davemloft.net>
References: <869fed82-bb31-589f-bd26-591ccfa976ed@servers.com>
        <20200724091517.7f5c2c9c@hermes.lan>
        <F074B3B5-1B07-490F-87B8-887E2EFB32F3@cumulusnetworks.com>
        <20200724.173112.451428196025351292.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jul 2020 17:31:12 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: nikolay@cumulusnetworks.com
> Date: Fri, 24 Jul 2020 19:24:35 +0300
> 
> > While I agree this should have been done from the start, it's too late to change.   
> 
> Agreed.

Please fix the man page, the  usage and add a warning.
