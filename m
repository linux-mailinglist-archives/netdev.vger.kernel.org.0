Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C458F46B391
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 08:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhLGHWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 02:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhLGHV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 02:21:59 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC9EC061746;
        Mon,  6 Dec 2021 23:18:29 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id m15so12937270pgu.11;
        Mon, 06 Dec 2021 23:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=B94UdsKCgTQF2XUw0WU+IEnqd9VGysceGby9DPepO0o=;
        b=BATXrCzS7rGpAfjh2CD0ElTU1L1wRJnHogCEmwFxybv1NU9OHUXfZhLrFy6pZXeUYp
         Bx0PpUlqnP4PJyW5ilxzGJKt04AvaCWzyt73Ij7DWlP1/lsKVzN74/KG3yndh00oJAUX
         zELVXrcaVlHru+zq3wm/+syHa2g/HmdYFAIx+Zk6Ehvhf0h1DDYU91TC7+LKoua64aTL
         r6UJGNseAOGUyGGKL1EpHU/Fj/u+qYTW6/6mIJEDUXfFd1+z5Lq3xxybgFS9OuZc/baj
         ZrPqT9XOrvrZzcVh/w+xwPi27qDC3E6d0z6DM04edQDdULFXzOJU9BwUeAX8Z5bpl7Z/
         /+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=B94UdsKCgTQF2XUw0WU+IEnqd9VGysceGby9DPepO0o=;
        b=ZjqcXcp/NlummxXpFbelMdG/8X7ciaGT9LF1MhntFHVB5vKDcpkMp3A+mBntjtv/Bw
         j98a+20vHLIrJ3fnhMb7uNB6GoohG2FYNWwubnRZ39L5VeM03TkU8FGTzWpjzwSY3CH1
         aejyjuGkUJwTDZtcgJJCYbaS0yj1sFgEe1WDPerzequM3Meczx/R2KxjZFZ9NFXF8R0U
         NLBg09aUaYW+767R6fhiE1TfCMdZJv38JVjQmzpxpUuJ7Il9vE2D4AnXvS8sHF5hbaDZ
         BR3iUlJP5BmlH3msbPLDgLvDJbkr0ZbtbOXMKnNCD1+kdIzAQW6LapoDTcmf3vXZSxz4
         ESXw==
X-Gm-Message-State: AOAM533bJk/3GeaoK2VggylAsrw4kxlB0EGTa5XNXwwGLw3PB1vkUSo+
        tef/d0FLxlDQAacpFsmsLlQ=
X-Google-Smtp-Source: ABdhPJxIu8sDi4ZPjCWEbYTq6hyJH9cL7IVKqclKMP+d+sjYEiXQ7yT8yfa448d8oqv+/LxWwYhDeA==
X-Received: by 2002:a63:5954:: with SMTP id j20mr22461276pgm.365.1638861509263;
        Mon, 06 Dec 2021 23:18:29 -0800 (PST)
Received: from localhost ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h22sm14486265pfv.25.2021.12.06.23.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 23:18:28 -0800 (PST)
Message-ID: <61af0ac4.1c69fb81.6badc.a755@mx.google.com>
X-Google-Original-Message-ID: <20211207071828.GA401291@cgel.zte@gmail.com>
Date:   Tue, 7 Dec 2021 07:18:28 +0000
From:   CGEL <cgel.zte@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, horms@verge.net.au, ja@ssi.bg,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        daniel@iogearbox.net, roopa@nvidia.com, yajun.deng@linux.dev,
        chinagar@codeaurora.org, xu.xin16@zte.com.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Eric Biederman <ebiederm@xmission.com>
Subject: Re: [PATCH net-next] net: Enable some sysctls for the userns root
 with privilege
References: <20211203032815.339186-1-xu.xin16@zte.com.cn>
 <20211206164520.51f8a2d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206164520.51f8a2d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 04:45:20PM -0800, Jakub Kicinski wrote:
> On Fri,  3 Dec 2021 03:28:15 +0000 cgel.zte@gmail.com wrote:
> > From: xu xin <xu.xin16@zte.com.cn>
> > 
> > Enabled sysctls include the followings: 
> > 1. net/ipv4/neigh/<if>/* 
> > 2. net/ipv6/neigh/<if>/* 
> > 3. net/ieee802154/6lowpan/* 
> > 4. net/ipv6/route/* 
> > 5. net/ipv4/vs/* 
> > 6. net/unix/* 
> > 7. net/core/xfrm_*
> > 
> > In practical work, some userns with root privilege have needs to adjust
> > these sysctls in their own netns, but limited just because they are not
> > init user_ns, even if they are given root privilege by docker -privilege.
> 
> You need to justify why removing these checks is safe. It sounds like
> you're only describing why having the permissions is problematic, which 
> is fair but not sufficient to just remove them.
> 
Hi, Jakub
My patch is a little radical. I just saw Eric's previous reply to
Alexander(https://lore.kernel.org/all/87pmsqyuqy.fsf@disp2133/).
These were disabled because out of an abundance of caution.

My original intention is to enable part of syscyls about neighbor which
I think was safe, but I will try to figure out which of these sysctls
are safe to be enabled.
> > Reported-by: xu xin <xu.xin16@zte.com.cn>
> > Tested-by: xu xin <xu.xin16@zte.com.cn>
> 
> These tags are superfluous for the author of the patch.
> 
Ok. thank you to correct me.
> > Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> > ---
> >  net/core/neighbour.c                | 4 ----
> >  net/ieee802154/6lowpan/reassembly.c | 4 ----
> >  net/ipv6/route.c                    | 4 ----
> >  net/netfilter/ipvs/ip_vs_ctl.c      | 4 ----
> >  net/netfilter/ipvs/ip_vs_lblc.c     | 4 ----
> >  net/netfilter/ipvs/ip_vs_lblcr.c    | 3 ---
> >  net/unix/sysctl_net_unix.c          | 4 ----
> >  net/xfrm/xfrm_sysctl.c              | 4 ----
> >  8 files changed, 31 deletions(-)
