Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0082879E6
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbgJHQXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgJHQXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 12:23:43 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AAAC061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 09:23:43 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s7so7569249qkh.11
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 09:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3qGoVViPLcC2LJuxmI8xfDdStrAjTNHZLwV5FYlRu7k=;
        b=PYb8ki3AnrDvUMld1hOr56VMYtqjch5fFfg6qNaghS5C2OcwbpOBC2SJH6WivbiSKE
         pv8k3Eu49V8n9NlsKqkVJOQrmeo2gQZonXtOmeCYVrrIdA1KwHUscO/KT3yZN33+QdrA
         evpmX81008d3mGFz+xLVL//NTGPd+lKqBE23NdozNG822hBlvt+Rk+lT8qsOc/XTOQ8Z
         6ygSZhvw3Pg4kr+xSoN8cW8+AMxOOsTuy1xkTRVPe1tZE8ttx0jQDdhsqxCUWcNwXvyf
         DJUSFWM2IO8Vj9LR19haZl0rh3/9R0ni21r45bMdAdo6OLP+Lx99plzvponHYZmmiP2v
         IR0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3qGoVViPLcC2LJuxmI8xfDdStrAjTNHZLwV5FYlRu7k=;
        b=D7B/iwNca+ugldaL8i3wJJSCDNKC9k6rYJJ7AzrK5HOgFXVMlqZPwBvITLWBfzCXc5
         HqqZ7aSg7Glmjs5szuP1HgC4XBrOXAcp0BVwSy9/3VoWJEpAFc8kalsLg8UxUXxSNbCI
         9xVdAjNLRMTlo9NclF8uXXQ4G03WyzkeytnFVxSGrm1F0nZ2Qo+gtcxElN9hpofjzzTJ
         m6XNz9rqXtvdqmJVeIIuOtO+dzb6QUZVjtr28VeBWrhn6EjZE7PJ6OLvY14wZwGZ1MtC
         +Q6XnESY6seBshfNRNR2gYW2uRr9Ws89RHwt+N5OE09fRjWHP+EkGdsYAOZJJw3D4VI7
         98fA==
X-Gm-Message-State: AOAM530zsTmNGb0GHQcGDzqVL2u8NSvKFvFA1mUI3ADkHvX9gVPZSGsP
        VygOtwTyR/xp+/Em2bD7jgw=
X-Google-Smtp-Source: ABdhPJz1oH51wG0e4oZceOqkgf7bYKQ9jJu7MJ8eQJo0ni1tb8e5WZ1/H1+xAbLpmW14IZXoJfytMA==
X-Received: by 2002:a37:b283:: with SMTP id b125mr2050457qkf.407.1602174222837;
        Thu, 08 Oct 2020 09:23:42 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.121])
        by smtp.gmail.com with ESMTPSA id z3sm4108336qkf.92.2020.10.08.09.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 09:23:41 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 98EDDC317F; Thu,  8 Oct 2020 13:23:38 -0300 (-03)
Date:   Thu, 8 Oct 2020 13:23:38 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: fix sctp_auth_init_hmacs() error path
Message-ID: <20201008162338.GB70997@localhost.localdomain>
References: <20201008083831.521769-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008083831.521769-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 01:38:31AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After freeing ep->auth_hmacs we have to clear the pointer
> or risk use-after-free as reported by syzbot:
> 

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
