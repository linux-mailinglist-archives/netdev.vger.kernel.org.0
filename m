Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB751A76D2
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 11:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437335AbgDNJBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 05:01:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38554 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437280AbgDNJBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 05:01:37 -0400
Received: by mail-wm1-f65.google.com with SMTP id g12so5210235wmh.3;
        Tue, 14 Apr 2020 02:01:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZSEHFc2eh+N6K60wyVHbBWfK0AmjMN90oe2OMNtMMJ0=;
        b=VZcdmcPfe6bokelP+VcFo/KKk2US9O6S8tRgNtF/gLstaIJygVoMVr8X5z7aVnpfwx
         jGWGcCIyIgFX1qffbo5S4TmA9T/iLJ2Q0bT9GNRqVXaIfaO26J4K3BvaIU8/N/famYYr
         /Vzb3JOQMfu9RVXx6Bpfb/EFXzrUyx0L6hYIh3nTQjuAUmNc5PFB2moXYPWzc5+1uoKL
         VmqQFll+et195bcMN/B5vHfEjmD6kX7vTy47aaOOymqcG0eLYjjDaN7bgl0HghLX6r2H
         x5fja3K7pItACo6LAcf8KM9Q8pUzmB7j4w5YTazUVAxnL3Ecgxz4soRhBQlJPpMXAquC
         JSTQ==
X-Gm-Message-State: AGi0PuaRcU49yxnL2rzL+ZED8gAyGbXieOsW7r3oPqKXnqp2UpcU96/U
        XwPSodKQc3rqeZ01ta/hip0=
X-Google-Smtp-Source: APiQypIjMMKQ1krTcIb7iRe2Mn/fScrYHKTluZiYEwYRZsrwjhiGsUjKHrgwCKNk20IxGSD17N1euw==
X-Received: by 2002:a1c:a913:: with SMTP id s19mr23660673wme.134.1586854891811;
        Tue, 14 Apr 2020 02:01:31 -0700 (PDT)
Received: from localhost (ip-37-188-180-223.eurotel.cz. [37.188.180.223])
        by smtp.gmail.com with ESMTPSA id n6sm18637096wrs.81.2020.04.14.02.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 02:01:30 -0700 (PDT)
Date:   Tue, 14 Apr 2020 11:01:29 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Waiman Long <longman@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-ppp@vger.kernel.org,
        wireguard@lists.zx2c4.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fscrypt@vger.kernel.org, ecryptfs@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-bluetooth@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-nfs@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        cocci@systeme.lip6.fr, linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH 1/2] mm, treewide: Rename kzfree() to kfree_sensitive()
Message-ID: <20200414090129.GE4629@dhcp22.suse.cz>
References: <20200413211550.8307-1-longman@redhat.com>
 <20200413211550.8307-2-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413211550.8307-2-longman@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 13-04-20 17:15:49, Waiman Long wrote:
> As said by Linus:
> 
>   A symmetric naming is only helpful if it implies symmetries in use.
>   Otherwise it's actively misleading.
> 
>   In "kzalloc()", the z is meaningful and an important part of what the
>   caller wants.
> 
>   In "kzfree()", the z is actively detrimental, because maybe in the
>   future we really _might_ want to use that "memfill(0xdeadbeef)" or
>   something. The "zero" part of the interface isn't even _relevant_.
> 
> The main reason that kzfree() exists is to clear sensitive information
> that should not be leaked to other future users of the same memory
> objects.
> 
> Rename kzfree() to kfree_sensitive() to follow the example of the
> recently added kvfree_sensitive() and make the intention of the API
> more explicit. In addition, memzero_explicit() is used to clear the
> memory to make sure that it won't get optimized away by the compiler.
> 
> The renaming is done by using the command sequence:
> 
>   git grep -w --name-only kzfree |\
>   xargs sed -i 's/\bkzfree\b/kfree_sensitive/'
> 
> followed by some editing of the kfree_sensitive() kerneldoc and the
> use of memzero_explicit() instead of memset().
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Waiman Long <longman@redhat.com>

Makes sense. I haven't checked all the conversions and will rely on the
script doing the right thing. The core MM part is correct.

Acked-by: Michal Hocko <mhocko@suse.com>
-- 
Michal Hocko
SUSE Labs
