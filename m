Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E679E310444
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 06:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhBEE7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhBEE7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 23:59:03 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F7EC0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 20:58:22 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id d1so5714706otl.13
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 20:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F2w0ekMTc0RSHwNnGXLw5ABqCyil44Hknn48Okbt3oY=;
        b=EIyrKEAUJZj4wzrpBxy/plw0YHxbJzWR0hy4RBacD8Ce9an8THenorLqmJ1hh0RiJd
         Gv001L8ihYqyz77LrFjFGZWNWIm6/XfQ5075sZN7gqpL+6to9EEPag8gV0vyCrJCLVC3
         OQwpvXjiz0qGLJybMnCy9SBPdgvij0E742z5HZ/P6rMrpb+5DWxDGMKsXQngB27fA3D3
         +ZvjuHXudbeD3yBPLUqnir5HsOpLFXZBrkYm8Wl1eeqMeWEcZwDtNWZfxFTrammtSq3b
         qOWt76p/YL7GtjeBfHlRP462Y4+DDyCNRAgs2gmDQnCK+v245f1wev3cD/UgCljc/rQR
         iQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F2w0ekMTc0RSHwNnGXLw5ABqCyil44Hknn48Okbt3oY=;
        b=YlWgnSbrr6V9OMd0UDEG+MuL2VXTY4lCEL3ydZt8F/Uj8J/TuRxDyrlRLAnZUWRynC
         q5DaKeBZ1ea7qxF7/djFjx+Ci5GRs2GnmH42yTVeSgC+IEwJmAIXOiW6pxPewLXHn5U3
         t3UVqaQdYLymurzg2OfJs50PZBK617ZGggBsM30WtWoBPyRCfsTExtkqblNLCBWZSfbt
         TAJR8fYF/4dnDDtomMush+tZODhT99/aiPB1EZUOalyOdfafxsztXvJsSCcpxCl+mzMQ
         wtUAnfVt6/bud3z9Ng294ZFSs2VpwXECxnyOi/svC6Nt0ygDTQ5GMJb0Yle6mNMrZ4tG
         syYw==
X-Gm-Message-State: AOAM533CoohNUhdMy2ety+quCCtA3yS3aD08a4jzni/4bGJkKGw/8IJ6
        I6I7jI3giA5iI/kcoaZx8ow=
X-Google-Smtp-Source: ABdhPJybJ3XT3oGU9FVyFs3iN1QQ6rOnI+UMoEhcJXoYb+/jp3ZG7YnJkSVf11+CiwKY8wc8JmSE7w==
X-Received: by 2002:a9d:748a:: with SMTP id t10mr2122349otk.336.1612501102411;
        Thu, 04 Feb 2021 20:58:22 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id e84sm895448oib.39.2021.02.04.20.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 20:58:21 -0800 (PST)
Subject: Re: [PATCH iproute2/net-next] tc: flower: Add support for ct_state
 reply flag
To:     Paul Blakey <paulb@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>
Cc:     Rony Efraim <ronye@nvidia.com>, nst-kernel@redhat.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
References: <1612268682-29525-1-git-send-email-paulb@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4ae1d0db-f8ec-5369-79a8-76f17f06d70e@gmail.com>
Date:   Thu, 4 Feb 2021 21:58:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1612268682-29525-1-git-send-email-paulb@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/21 5:24 AM, Paul Blakey wrote:
> Matches on conntrack rpl ct_state.
> 
> Example:
> $ tc filter add dev ens1f0_0 ingress prio 1 chain 1 proto ip flower \
>   ct_state +trk+est+rpl \
>   action mirred egress redirect dev ens1f0_1
> $ tc filter add dev ens1f0_1 ingress prio 1 chain 1 proto ip flower \
>   ct_state +trk+est-rpl \
>   action mirred egress redirect dev ens1f0_0
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> ---
>  man/man8/tc-flower.8 | 2 ++
>  tc/f_flower.c        | 1 +
>  2 files changed, 3 insertions(+)
> 

applied to iproute2-next. Thanks


