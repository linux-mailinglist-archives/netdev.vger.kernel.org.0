Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0750A3452E0
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhCVXOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhCVXNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:13:37 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070BAC061574;
        Mon, 22 Mar 2021 16:13:37 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x16so18864450wrn.4;
        Mon, 22 Mar 2021 16:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tYvb3I5DkX3N6jN+5U7mg9SkFokyTC7DYO1POXsmyXA=;
        b=JAukgRqBFlBqYxoTg07QIe3L0u4Zd4pnU8/KawSiQ9CobCuM3gzIOiljfx6LuzgDWA
         UowTprAJ6pvQSXvs4KSQRoxyhk97bRV/HvA6p2Z7/U2jyU55VRoMchp/WW94qOWwfctx
         xjztqDCBK6KyOMwxPOwi4e26tFik5N8gD8ME46WI4P9N9+IGYjmYXftjUoCOmT9YRUhI
         oxS7NQe6LKxh0Fe3YkrHljuKHXVZGAd59GORjepGb1sCy/oTzRkzKEYxW8PIJ/sFr1d6
         zI5HyhOjX7JC0HU1eEG4mNxiJ04gBc9w35eUnfsZO8LW67/ihxMVwREYJPst2Xb0XGu3
         JGJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=tYvb3I5DkX3N6jN+5U7mg9SkFokyTC7DYO1POXsmyXA=;
        b=YWEIQudAlD8UPdpfZbMw7eFHAPO4URDrfWpUqcL/ddYKm4xwcS86t5pnE+Fa0yyTLY
         uRFMFx9nzVj4tAEp88qh4eei9VlLkTJTU3e3bq1FCItb3W+4ity+WGwQs1ewiFJOPcMd
         8rwojnFSaozI5v7OFW+Qhf69y8zmNbnlVWtiQL338fUQwiK+/FB2APQ8Alg0crLkMMpM
         LtKepgiTCrvRJsAv8J9RTsW8qxCXL31kKfvDGhJ3/dOdzHu0plT6oeFIDr16DEe+l7Zh
         2TKcDfWVQ8reCNgb976fsOQa6oXA8+Jf2OiTF66fuixeTWxPdX9/cpk1/+pMCP/rxFO9
         PeKQ==
X-Gm-Message-State: AOAM531LI619K+9GVV7hIhi5qgtJ3KmDtV6vICLoPzaykVQP8ZtGzJuJ
        aUsOe7PtC1Ri7DNmu9B5NpA=
X-Google-Smtp-Source: ABdhPJwD5sKWkDZI+WUiEv9LaU8t0tl7e3Sco91hCCQ6VjFxt+KbUyFjpi5+6SIPcvWKZoMwC1DUgg==
X-Received: by 2002:adf:b642:: with SMTP id i2mr867183wre.8.1616454815721;
        Mon, 22 Mar 2021 16:13:35 -0700 (PDT)
Received: from gmail.com (54033286.catv.pool.telekom.hu. [84.3.50.134])
        by smtp.gmail.com with ESMTPSA id w6sm20916828wrl.49.2021.03.22.16.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 16:13:35 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Tue, 23 Mar 2021 00:13:32 +0100
From:   Ingo Molnar <mingo@kernel.org>
To:     Martin Sebor <msebor@gmail.com>
Cc:     Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
        Martin Sebor <msebor@gcc.gnu.org>,
        Ning Sun <ning.sun@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, cgroups@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 02/11] x86: tboot: avoid Wstringop-overread-warning
Message-ID: <20210322231332.GA1984184@gmail.com>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-3-arnd@kernel.org>
 <20210322202958.GA1955909@gmail.com>
 <b944a853-0e4b-b767-0175-cc2c1edba759@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b944a853-0e4b-b767-0175-cc2c1edba759@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


* Martin Sebor <msebor@gmail.com> wrote:

> > I.e. the real workaround might be to turn off the -Wstringop-overread-warning,
> > until GCC-11 gets fixed?
> 
> In GCC 10 -Wstringop-overread is a subset of -Wstringop-overflow.
> GCC 11 breaks it out as a separate warning to make it easier to
> control.  Both warnings have caught some real bugs but they both
> have a nonzero rate of false positives.  Other than bug reports
> we don't have enough data to say what their S/N ratio might be
> but my sense is that it's fairly high in general.
> 
>   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=wstringop-overread
>   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=wstringop-overflow
> 
> In GCC 11, all access warnings expect objects to be either declared
> or allocated.  Pointers with constant values are taken to point to
> nothing valid (as Arnd mentioned above, this is to detect invalid
> accesses to members of structs at address zero).
> 
> One possible solution to the known address problem is to extend GCC
> attributes address and io that pin an object to a hardwired address
> to all targets (at the moment they're supported on just one or two
> targets).  I'm not sure this can still happen before GCC 11 releases
> sometime in April or May.
> 
> Until then, another workaround is to convert the fixed address to
> a volatile pointer before using it for the access, along the lines
> below.  It should have only a negligible effect on efficiency.

Thank you for the detailed answer!

I think I'll go with Arnd's original patch - which makes the code a 
slightly bit cleaner by separating out the check_tboot_version() check 
into a standalone function.

The only ugly aspect is the global nature of the 'tboot' pointer - but 
that's a self-inflicted wound.

I'd also guess that the S/N ratio somewhat unfairly penalizes this 
warning right now, because the kernel had a decade of growing real 
fixes via other efforts such as static and dynamic instrumentation as 
well.

So the probability of false positive remaining is in fact higher, and 
going forward we should see a better S/N ratio of this warning. Most 
of which will never be seen by upstream maintainers, as the mishaps 
will stay at the individual developer level. :-)

Thanks,

	Ingo
