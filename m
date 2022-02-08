Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC2B4ACF7A
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346028AbiBHDEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346017AbiBHDEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 22:04:12 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFAAC06109E;
        Mon,  7 Feb 2022 19:04:11 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id y5so15524504pfe.4;
        Mon, 07 Feb 2022 19:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oKz3cDt5XuIn9MReqD7LJiWdM67rRoAdNMAP2NNj1kc=;
        b=Ggk3auE00SgkK42rKT/+mpS7bWeUSWEbpQLHiG4Nks4fnuvdgWE6/HVOoQ8MQjdp0X
         ZRnVNFx962HFrnBCI7p2P7ACTPS7po01HnNsPIfIm41BOZ4R1YD7Czq7qeBI3Q3klU/m
         wDRev0/+Dg9HSAGeUYVno359cQh0cnZvPwz53pOsbBjI3M6xk67YuPUKKVlqwxEWXDwe
         nZtQqmWa4bGYwYBBrhrV3juAOZWzd2pa96Z/5U6dVplW2t+MLwSfkEjRbX0Ikktxy8zT
         LbLgqbHhjWBcUWDG/aevXiguhtTeNxutV5r0QI1bH3FEO7r8bYbWnKvOS+kdoqFAvhp3
         WXdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oKz3cDt5XuIn9MReqD7LJiWdM67rRoAdNMAP2NNj1kc=;
        b=IGyK0kEo9wXm9HP3i9TIVuP3XHu3q5gITgU8fUJAS+7OJmlcmf0Qv4EBgv4YI+mMQ7
         ttuVlWjAmHHcCenrXXzUoXAmmV+nC1GIrY3JNOTJc7aWpNE6WM1xUT7+ticarfI750CS
         o5OzsCuE7YuoQP9M+IwNIBhlH+6egfos+4CDXtwSUpy1tnCNB6wvqRSpjC0vebAOlRIE
         IYCQQ6avJUy8Eq+pvn3GP/VQFeJwOKqRkU1fA9FQb+Eom9di3YNdqECPYn9ywBQRFL1D
         dGgI1OU2AJGqddIH4SsKBtEl3FZknhKFewxHfbrmo2ayuP5uRRE3R1JEXwtF7FilYlHV
         Y/Aw==
X-Gm-Message-State: AOAM533yUJjBs8c5rAzAyNkiJG/1iLXjhaMKKwSwx6brF6w8eOpZKE9Q
        hYPQZ8ZNIb+ussABmbcgX0U=
X-Google-Smtp-Source: ABdhPJz0qONwgE+M+xdbK3zzPEV9ngh/dO78QRVj9sztXity3DEWVnr6VpMKE+64UMn91q5l/8PctA==
X-Received: by 2002:a63:745:: with SMTP id 66mr1861052pgh.505.1644289451334;
        Mon, 07 Feb 2022 19:04:11 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id m13sm12811358pfh.197.2022.02.07.19.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 19:04:11 -0800 (PST)
Date:   Mon, 7 Feb 2022 19:04:04 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/6] ptp_pch: use mac_pton()
Message-ID: <20220208030404.GA25856@hoboy.vegasvil.org>
References: <20220207210730.75252-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207210730.75252-1-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 11:07:25PM +0200, Andy Shevchenko wrote:
> Use mac_pton() instead of custom approach.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> v2: no changes
>  drivers/ptp/ptp_pch.c | 41 ++++++++++-------------------------------
>  1 file changed, 10 insertions(+), 31 deletions(-)

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
