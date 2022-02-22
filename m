Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E3C4BEE7C
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 02:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237510AbiBVAJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 19:09:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiBVAJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 19:09:42 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E0024BD3
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 16:09:18 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b8so16632219pjb.4
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 16:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ELxjC/+OPQRNjN+644dAiKb0tAFIoNl4g1dGiuw+pmE=;
        b=QTVfrNYMFDSNRozNQTHVzdnUgbSFtfNGcFB+9jCam+cd0MZ75PTjKxG+yS2Hh13FUW
         xuQOUWbbQLYNoZBXrUj7pkj1tVFTaudiumk8rI6HQQsDPBqnkXPDBc0huiWAFq32y97x
         RsqwPgCkSBVU5qYS5Y9fEHYQ3mjLefqGOHqtvX21aczf5eceJUxt9C44NbVqVX8d1lHm
         013gz2Mgfhs8HqeocUfRhZxKLKL1DV0gQcjSzT+QQlJ76YqTugJ4qxcny1/i3uAzbWdN
         r63gpkX6kGgeZiWFMxQmxqbdS9JIxqYWkGW5DIUChxe3St/7NM40WktJYmTcE1m3WNUG
         0jgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ELxjC/+OPQRNjN+644dAiKb0tAFIoNl4g1dGiuw+pmE=;
        b=3zkRbmRm1bOZvTmOnQVTYzL/1UNrlnLfdXVjndmA1BCUXc2je53eUWjXolukUhL92T
         9PwbDMd+YQXpqiALPbN16/hbSN5YwTPb0FIUqDNFADKAp28iPMVDGCvYTOPkjzxqL2aY
         AJg8A//cV5U5WgoxDYW679REgtSSYgeOcU4JQ3L8MdrairBevE1CZyG/uqcoqiT3DyxN
         /qjo+RurpayjplGrUhOlPm82QRt795mqIvHhwRW2b95XLZcCZR4eyb/hMAei5qn0a5KL
         JiLeIiR43OhlH4JOYQWUSeEphXwXnsdUCvT8yaLzD+eH/K4q6kOm3CRB/gRH3B9fC4rP
         O2Pw==
X-Gm-Message-State: AOAM530iaaXdYiOQ9n6S5ts5IBumqcATrF4GicMR6SDlGxLKeosayr7C
        dBGBIpG0iKiT5ILztcGDI8hpK2LscVI=
X-Google-Smtp-Source: ABdhPJyd3Q+5jfJEGLj2K+old/coJJrf42I961o03uyOkQFW1MCvx89pvp3wzjDaa7SvTfu0UEVpPQ==
X-Received: by 2002:a17:90a:d797:b0:1bc:652f:d0fd with SMTP id z23-20020a17090ad79700b001bc652fd0fdmr1396683pju.16.1645488558129;
        Mon, 21 Feb 2022 16:09:18 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q9sm19300345pgf.73.2022.02.21.16.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 16:09:17 -0800 (PST)
Date:   Mon, 21 Feb 2022 16:09:15 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Maciek Machnikowski <maciek@machnikowski.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] testptp: add option to shift clock by
 nanoseconds
Message-ID: <20220222000915.GA8362@hoboy.vegasvil.org>
References: <20220221200637.125595-1-maciek@machnikowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221200637.125595-1-maciek@machnikowski.net>
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

On Mon, Feb 21, 2022 at 09:06:37PM +0100, Maciek Machnikowski wrote:
> Add option to shift the clock by a specified number of nanoseconds.
> 
> The new argument -n will specify the number of nanoseconds to add to the
> ptp clock. Since the API doesn't support negative shifts those needs to
> be calculated by subtracting full seconds and adding a nanosecond offset.
> 
> Signed-off-by: Maciek Machnikowski <maciek@machnikowski.net>

Acked-by: Richard Cochran <richardcochran@gmail.com>
