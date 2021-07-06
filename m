Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793043BDA44
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 17:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhGFPgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 11:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231773AbhGFPgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 11:36:49 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0252C061574
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 08:34:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mn20-20020a17090b1894b02901707fc074e8so1841923pjb.0
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 08:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BsILxpE46NZxaW3y4cbuMX4ZgJxYptV3+Zo9YLmJCg0=;
        b=HjKMT7ag7LdTGBjUbesPPGidtwOXQk80y6tqFu/ewL8qwi4vr/tvtW/bWv9FXd8mw6
         MoSAuxMm2DbIWt9Y01kTZmuAEz2nbgU7Vhixonoh8UMpkmyOnW+7A144G9i1QpMGp4o0
         P/1HG4ZTjtFTD3dsDcVqp5Eo/e+CIGHRRabadgHl3ttzk9jdVagmZUGU0ko5yuxJ1M0S
         q4mh3VfuidrsDOAGpKDOHdzAQuAWPsul9ZbopWnTTJ0brB0P99JS2O9wuedPWunLOaUY
         ZR4k5Z0cQUkI08aJ8EKx3I81uuD5OrdK310zM+U4GYh/TSCbg3w5xUjG7+dN6vc1mLuR
         bo6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BsILxpE46NZxaW3y4cbuMX4ZgJxYptV3+Zo9YLmJCg0=;
        b=PQeg9X5n2ZJABT5IAPc96hrPC6VhgIqb5YD0ZxUiLx5P59btPl3Nji8Fl8VnbnfTIZ
         2LqwPN8KxGdeNmEf0BNuJLkBMfqFLxivWEffmJE9F/Vrld3YlCUj1SRBf4BjPjuv63Ly
         6d0DhazfrNeamOhw5pQnxgV3FS50+JuLuQ7zqQ2JMHfKi9UM1LyFoD4+FZODXxEWMuLW
         euQJ3fZ5jyo+LNu+0YKZbCzHjVBSrGlNun09scgvv7HLMVWKAyZs5oygh+Fr+KIQPTIn
         h5On0+LwX5bfd1pwv5LiB7BIP3PMHFs7dZy2rFuvHUtAhNsLVGU+z36HaRTz2ekCI04H
         Youg==
X-Gm-Message-State: AOAM531knIadL1bFvUqmAMtKh79ZZbVIW4zgdSDpapqRvLb+308DYczc
        /NbdDTXeHslErphvWYurXTBeCQ==
X-Google-Smtp-Source: ABdhPJzUt5OLph3EKYgQASdOjqOrNa0dYM9yxxmVzE7aWC3pFf/OsnxMBx+b9xsfzt352VxfyuakFA==
X-Received: by 2002:a17:902:8484:b029:101:7016:fb7b with SMTP id c4-20020a1709028484b02901017016fb7bmr17143529plo.23.1625585650171;
        Tue, 06 Jul 2021 08:34:10 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id j22sm19180574pgb.62.2021.07.06.08.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 08:34:09 -0700 (PDT)
Date:   Tue, 6 Jul 2021 08:34:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCHv4 iproute2] ip route: ignore ENOENT during save if
 RT_TABLE_MAIN is being dumped
Message-ID: <20210706083407.76deb4c0@hermes.local>
In-Reply-To: <20210629155116.23464-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20210625104441.37756-1-alexander.mikhalitsyn@virtuozzo.com>
        <20210629155116.23464-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Jun 2021 18:51:15 +0300
Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com> wrote:

> +	const struct rtnl_dump_filter_arg a[2] = {
> +		{ .filter = filter, .arg1 = arg1,
> +		  .errhndlr = errhndlr, .arg2 = arg2, .nc_flags = nc_flags, },
> +		{ .filter = NULL,   .arg1 = NULL,
> +		  .errhndlr = NULL, .arg2 = NULL, .nc_flags = 0, },
>  	};

I am OK with this as is. But you don't need to add initializers for fields
that are 0/NULL (at least in C).

So could be:
	const struct rtnl_dump_filter_arg a[] = {
		{ .filter = filter, .arg1 = arg1,
		  .errhndlr = errhndlr, .arg2 = arg2, .nc_flags = nc_flags, },
		{  },
 	};
