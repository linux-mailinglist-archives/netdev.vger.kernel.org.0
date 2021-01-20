Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFAC2FD734
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390090AbhATOGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387504AbhATN3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 08:29:04 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19990C061575;
        Wed, 20 Jan 2021 05:28:24 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id n6so10662139edt.10;
        Wed, 20 Jan 2021 05:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=++2AFwNvgQfjY7NJOn30KJ+8z4S+tPwsAkQbDcQVkNU=;
        b=qJGIhgh29gfiTwdJB3uWEMMcFe9CIunqFE2jYkWM3sHOHFW7eyIP5XF3qO8cddkVtJ
         hFJkrYy1AVjCXzB375dNewQNomeREKZEJnZ3HrDSkfp4FVuWd9BucazsoccWATyy43gG
         Ahm2YrH/YogJLXYHgWIfCnr5+4/xef2s78QX5N2h8ctppw8bb8+nPtggHLMq8pBgLgqx
         +LYCQ0EsgLi9G0kHhs2h0+zLS3Z15oUiSvFJVmnqW4fu/P6ag3wLOlaZwQe7CYlOxB4F
         idzrU9ETBPqiuQgFqsg/K2h0+TX11H2GjBbqO+VgZMLEX+QW45hBIDFwqoqV/kjKuZcy
         SLfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=++2AFwNvgQfjY7NJOn30KJ+8z4S+tPwsAkQbDcQVkNU=;
        b=mGo6ejQLHT3SapGg7pujel1Q4pSki8fCkb+Np1IL38+xnu7rOW7sJrmlMlVN+AhhrX
         Zfq2QL7v9Re//OiQU9PcrFV2jpy2WaTQlPcP4Da+uCByMIexk+ZlLeS33ihPotyyL0Ox
         CKE2Wk/uAHH9qgHHzgGvL7uOAuWYd5rHyCBZR0fRK4RKPuiXqZCFS3TaS56jhSzfOb6M
         KfRKMy5Lhg8CKMpS1+1fG+7Sgnp20fMnkjzZAIXBHnfQjruF1ZKKUZmLPOJu2LbizUNI
         evbBedwVN54b/d3sqSPJ8ZzA6qIgt3at4EsoB8CrsVmLwQTyNq9Dc8zR6gN7Xy/XRpwT
         2bIQ==
X-Gm-Message-State: AOAM530oFjn7qmCSXJXsXKbTgz+3u2Y3nwlRRcrYHYlSN4XmvUpuswNZ
        p0Idr72W8hQ4XHcW8ezRDXPrtJAfSDzMDMXFTHs=
X-Google-Smtp-Source: ABdhPJzdAwrUr/ejJ1imp70wMJ/DwiBEjY9M8jZzuG1GXvGdAxA0fMAVsWqqVaaMVwTwQoq3GnLiBd/u8OBOjRPkyf0=
X-Received: by 2002:a05:6402:513:: with SMTP id m19mr7406967edv.229.1611149302795;
 Wed, 20 Jan 2021 05:28:22 -0800 (PST)
MIME-Version: 1.0
References: <20210118143932.56069-1-dong.menglong@zte.com.cn>
 <20210118143932.56069-4-dong.menglong@zte.com.cn> <20210120104621.GM19605@breakpoint.cc>
In-Reply-To: <20210120104621.GM19605@breakpoint.cc>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 20 Jan 2021 21:28:11 +0800
Message-ID: <CADxym3aV9hy3UdnVWnLeLF6BnwqqrJ1MdMKNQiSa4sCWQ2+4ng@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: core: Namespace-ify sysctl_rmem_max and sysctl_wmem_max
To:     Florian Westphal <fw@strlen.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, christian.brauner@ubuntu.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <dong.menglong@zte.com.cn>, daniel@iogearbox.net,
        gnault@redhat.com, ast@kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        ap420073@gmail.com, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, jakub@cloudflare.com,
        bjorn.topel@intel.com, Kees Cook <keescook@chromium.org>,
        viro@zeniv.linux.org.uk, rdna@fb.com,
        Mahesh Bandewar <maheshb@google.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello~

On Wed, Jan 20, 2021 at 6:46 PM Florian Westphal <fw@strlen.de> wrote:
>
> >
> > For that reason, make sysctl_wmem_max and sysctl_rmem_max
> > per-namespace.
>
> I think having those values be restricted by init netns is a desirable
> property.

I just thought that having these values per-namespace can be more flexible,
and users can have more choices. Is there any bad influence that I didn't
realize?

Thanks~
Menglong Dong
