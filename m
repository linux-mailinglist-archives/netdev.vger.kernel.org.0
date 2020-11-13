Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51622B1486
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 04:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgKMDFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 22:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgKMDFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 22:05:00 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C2EC0613D1;
        Thu, 12 Nov 2020 19:05:00 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id x15so5079999pfm.9;
        Thu, 12 Nov 2020 19:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J3xxlo0J7OEQ31x58M9zvwm+GKsy+33IUbEliZsTWrs=;
        b=Uykun2xa0ICp1fXGTHcbokQvuKH2nSIViYf1ItzAqP4kpZOI/jHohqmYYQTPVbheBO
         7M9rDA2UXDIUPxpm/Qnhz3nN/Ut3l8mWreU0z6JP4lBP9LBhgB6YZAmWTTI6Wac7Xqb4
         pn/BeOV5KXxe0/cUmRWLKaHnNhpT2PzOzcXF5jRERV1PSDGoCvKeMmnqTfHeDvxTidoc
         4NyulzTSKQgqwLmpSR2ie4fQxpL1xOzaweegv8ayneja963BHqMlglvsTLD66FybEZK5
         5kKAzipqwNLSZ1N9wUp/FmjHfsqbzU2kgyVQAhlBPhsDXvxJ0U8Ycm99YnrS3fCOfBse
         ZYLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J3xxlo0J7OEQ31x58M9zvwm+GKsy+33IUbEliZsTWrs=;
        b=j3fixrZCl+jE7X/kRObE6e3FqdGSIGUSlHk+Pi52N6e/3g515T3eH8+b+a6BaTf5v5
         zGH7T9rylQWeBo9Ni1lGDwBAsHyeF/oYLiBs8zxp5ZqDSxL7nabHqbWIB0eGUTfjoqkE
         OM6Fd5y9jKaYgYIk/WUsHSYDO9tuue3WwWPACT9v2JWpJqVJFcnsMMHZRxXZ3KIbk6Yq
         ChyC6q5Srak82eeDhtcdtan3yxvAjHdxghX5oyeyMGTXA90Sgt4g14MQiR0IUmHq17gK
         Z+e6dsHjDBkQcwTLbTXlX75xn5qSfDoAcUYaEsm9ilfvNP4uLm1qHuvpvI8LLdao/GLE
         A1vw==
X-Gm-Message-State: AOAM531JqzUenjv8W431KKzve41Q5Dya84CbVS/mczfiTG4CkQHrhy6W
        sK2XK8EJGpMdRp3CescpX4I=
X-Google-Smtp-Source: ABdhPJzMdJtLxZWjzkxjYFM+noXSnpWOIMV32Ng3PHbPRSaMSKsTIj/0HxBg3Meb0gCU6wO7fiyd6g==
X-Received: by 2002:aa7:9190:0:b029:18b:6556:1e62 with SMTP id x16-20020aa791900000b029018b65561e62mr207259pfa.62.1605236699666;
        Thu, 12 Nov 2020 19:04:59 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:a370])
        by smtp.gmail.com with ESMTPSA id 21sm8083426pfw.105.2020.11.12.19.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 19:04:58 -0800 (PST)
Date:   Thu, 12 Nov 2020 19:04:56 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Roman Gushchin <guro@fb.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v5 01/34] mm: memcontrol: use helpers to read
 page's memcg data
Message-ID: <20201113030456.drdswcndp65zmt2u@ast-mbp>
References: <20201112221543.3621014-1-guro@fb.com>
 <20201112221543.3621014-2-guro@fb.com>
 <20201113095632.489e66e2@canb.auug.org.au>
 <20201113002610.GB2934489@carbon.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113002610.GB2934489@carbon.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 04:26:10PM -0800, Roman Gushchin wrote:
> 
> These patches are not intended to be merged through the bpf tree.
> They are included into the patchset to make bpf selftests pass and for
> informational purposes.
> It's written in the cover letter.
...
> Maybe I had to just list their titles in the cover letter. Idk what's
> the best option for such cross-subsystem dependencies.

We had several situations in the past releases where dependent patches
were merged into multiple trees. For that to happen cleanly from git pov
one of the maintainers need to create a stable branch/tag and let other
maintainers pull that branch into different trees. This way the sha-s
stay the same and no conflicts arise during the merge window.
In this case sounds like the first 4 patches are in mm tree already.
Is there a branch/tag I can pull to get the first 4 into bpf-next?
