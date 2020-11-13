Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1712B1441
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 03:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgKMCZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 21:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgKMCZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 21:25:27 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D780AC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 18:25:26 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id 11so7621355qkd.5
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 18:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MJeO88rdUY/oUjTt3kBVeCNa14mxVqONBGuFhaYXGSE=;
        b=EjMBccxcnQnBQ9jXWPKzjsYt3+2WkCHkTGanZJxDEce4eugc+mUTFSPxWcSm20LUVE
         0j4GZiKKFeMlBn6ENX1epP0EVFhRUcLezymeNQoWNQbClpLwx2bncX6YmD8z+64N8wH5
         w/QfPF4IfcSNxgvtNou2DQNSqfuM8e8gMkyBP9/9oRd07a7aYAtWeqgbjvgusdKc5aC6
         eiY1An2UYtJ63CpguWDcegtAHAZhVHveIG/4F/5tJuzwAJwAqxoYZoeTs/kWtJxwO2ei
         FDdxlhzbYiL+rdxEsZmVxLoNEw2dkN4iveAFvL6aU1qMXxo3VVMxJ+oAIZkNHH7h6s+R
         Dr5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MJeO88rdUY/oUjTt3kBVeCNa14mxVqONBGuFhaYXGSE=;
        b=nLJktuyhpxKQsXXnpJjy0EyCPSV4FfE1W5eL6kbKbfGWXuWz2A28Yo4R3Ka9ZQND6G
         infiKXoSIXG2prlZWDLpdU9s4cnk7XmiOtLud50KxMrNtlShp+K6Vw9SkG52lIlfIhMA
         oqqH4XWwM3Hj58ovkXp7Fw5ggpP/cqn6tlhusgmEK6BazI9KOnaI8iXj3ezFNl1q1efE
         vv/4lRalYzgkTJ/MJ6ZCb9cyPypRcyIHAvceSrE3k+JOGs2RAqseNyqXdrBdjULxsMIy
         uke2FH9or6nOXrJbf2zDzxgZEZ3KX4ZPCe79hYc94KhN8zYg790TKJkLDQgzf20WbL/d
         LxWw==
X-Gm-Message-State: AOAM532aX7HGU17QANWluSf0Aj1PxsTzHONUEeE0XnAp8OBsGvAxqTRM
        eGinUCwGbRK6l3hnUpsopIo=
X-Google-Smtp-Source: ABdhPJxKzqUXJu/oVYaAewBC2SJn/V8TNxQKbqQB8XlZEXaTKeIdeoIKuxKsMJzpiI1N8nGWui7C8A==
X-Received: by 2002:a05:620a:15a:: with SMTP id e26mr95611qkn.28.1605234325994;
        Thu, 12 Nov 2020 18:25:25 -0800 (PST)
Received: from localhost.localdomain ([177.220.174.182])
        by smtp.gmail.com with ESMTPSA id o62sm6498652qkb.94.2020.11.12.18.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 18:25:25 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 8339AC2B35; Thu, 12 Nov 2020 23:25:22 -0300 (-03)
Date:   Thu, 12 Nov 2020 23:25:22 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     wenxu@ucloud.cn, vladbu@nvidia.com, netdev@vger.kernel.org
Subject: Re: [PATCH v10 net-next 3/3] net/sched: act_frag: add implict packet
 fragment support.
Message-ID: <20201113022522.GH3913@localhost.localdomain>
References: <1605151497-29986-1-git-send-email-wenxu@ucloud.cn>
 <1605151497-29986-4-git-send-email-wenxu@ucloud.cn>
 <20201112142058.61202752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112142058.61202752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 02:20:58PM -0800, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 11:24:57 +0800 wenxu@ucloud.cn wrote:
> > v7-v10: fix __rcu warning 
> 
> Are you reposting stuff just to get it build tested?
> 
> This is absolutely unacceptable.

I don't know if that's the case, but maybe we could have a shadow
mailing list just for that? So that bots would monitor and would run
(almost) the same tests are they do here. Then when patches are posted
here, a list that people actually subscribe, they are already more
ready. The bots would have to email an "ok" as well, but that's
implementation detail already. Not that developers shouldn't test
before posting, but the bots are already doing some tests that may be
beyond of what one can think of testing before posting.
