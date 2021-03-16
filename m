Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4793733D9FD
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 18:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbhCPQ74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbhCPQ7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:59:30 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97906C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 09:59:29 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id 30so12686600ple.4
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 09:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mbGx3OQosxeVT9Kizfu9JXrZ5K92XBsZULUT8P0ZQJA=;
        b=mZzc23E7das5uLOdLxoKKEXWnf4byTyn2L/ZFHusuzk71cUFhqaH+N4baRkn7g9cY6
         lhRPNiDLMCyucYudbeyEXUsAVJerRlep1z7IvMemW1BD00XKFAjO1gogVdtHrKl9b53G
         PxWuEo61UJrfOvSdZPvYh3spbdiD1wnzkQzxht2WxVxZ5KIVZNzZ6Of+ROJZoFuSopm5
         TW91yH2W7ubGjzrE0oZpEDGi+ciINchV9UMSMJefvZKbF/70wPyEXVxNQjcKDzy49Uh8
         MVYTzpogZ7vDZLwyrMQP5BY/MzMmNmJWQdyYUJFD588wNiVcO4J5gMyhP4IxCXTyAmzh
         HJ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mbGx3OQosxeVT9Kizfu9JXrZ5K92XBsZULUT8P0ZQJA=;
        b=PJWD8OWpIlq+qOD9ACqVIGVRDUFVRD0VJWuFMI+EoBlQckRmGYpPiJn7W9+cE1cZTL
         7hPSZ6DHRNcsw6+i5R1uOYLu68OepHJrguB9zx7F5PPBQaAUMaRwH5qqTOdWqaAl4oNA
         Xfr5/pg7tSzUQh8UOpREdXOL0RYgoDil11+k24baz3vkZnCbM8hagK0IC4xk4FRa2xXW
         LakQasKSeDg1hN0W/4PuabIo8hMfFg/jm9ZxOrRHTlp87XeCJ4lCAUxpu+8EQAgVbFkm
         /lN+gLqVTxtm+GoZZKGS9RikVKN6MPnZtR7RyrqKDwxWygqLMcPm2Q6TW3LEVxtiYMe2
         0D5w==
X-Gm-Message-State: AOAM531lGBXt57OlMYLZg3rGQsMNRcFgPjSHrVwGC00mVNsjYDVO3+E+
        qGDpv7tIOtpTsuyi0luTFPC+Fw==
X-Google-Smtp-Source: ABdhPJxI1/GRJWoYJqz9ivzjyz50jAE037OMIDZ3J3HsMNu2ThZ0W2uzrTS3Ta0ttySWGW6kUfVtVw==
X-Received: by 2002:a17:902:8a82:b029:e6:ac65:469b with SMTP id p2-20020a1709028a82b02900e6ac65469bmr473496plo.74.1615913969109;
        Tue, 16 Mar 2021 09:59:29 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id n184sm17397800pfd.205.2021.03.16.09.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 09:59:28 -0700 (PDT)
Date:   Tue, 16 Mar 2021 09:59:21 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH iproute2-next v3 2/6] json_print: Add print_tv()
Message-ID: <20210316095921.175fac07@hermes.local>
In-Reply-To: <ef15d0e8dc8b58f93537116dd2a43f7d188a8fb6.1615889875.git.petrm@nvidia.com>
References: <cover.1615889875.git.petrm@nvidia.com>
        <ef15d0e8dc8b58f93537116dd2a43f7d188a8fb6.1615889875.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 11:20:12 +0100
Petr Machata <petrm@nvidia.com> wrote:

> Add a helper to dump a timeval. Print by first converting to double and
> then dispatching to print_color_float().
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  include/json_print.h |  1 +
>  lib/json_print.c     | 13 +++++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/include/json_print.h b/include/json_print.h
> index 6fcf9fd910ec..63eee3823fe4 100644
> --- a/include/json_print.h
> +++ b/include/json_print.h
> @@ -81,6 +81,7 @@ _PRINT_FUNC(0xhex, unsigned long long)
>  _PRINT_FUNC(luint, unsigned long)
>  _PRINT_FUNC(lluint, unsigned long long)
>  _PRINT_FUNC(float, double)
> +_PRINT_FUNC(tv, struct timeval *)

This 

Make it const please?
