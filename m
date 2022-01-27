Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB9749E5D3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbiA0PSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243139AbiA0PRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 10:17:52 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A9BC06175B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 07:17:52 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id b37so5268500uad.12
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 07:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3L9dijJzC3e3/PCe51KV9pEonuhgRM2pwbe2CRq/cZg=;
        b=Hi1EbSU3KfSYW6t3mHRqxA7YFt5tK95/PMV+AHZgPTzxlY/b12QKGs6RJbVAjhZepz
         ew/eQOgDvEriqLoJCwiLplxCz38HtJ0hU4P4NWAM4y5pbab4xYnzI0PcHrwhFintDOYQ
         tv5e32a18VVXRITOk9uUvNVBPXt/8K6rgI9Xkx9B4B7hgjRJS+vLFs1KE9t6Dj9vCoDw
         ibRBOqQW5x5fbUqTNxKx1a3g5UEnnYGfvDp4lHuHsm7cQAORMeOiRnvrDvD6PG3tHYpG
         PqvgPRfPCIucMcs63yIol5xLAe2MbrIZojEv8AB+VP1cm3n2ZzCsWLWRa+ys+wdCGAld
         pw0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3L9dijJzC3e3/PCe51KV9pEonuhgRM2pwbe2CRq/cZg=;
        b=t825eNlBHSl3+o9VmkFEigLXkX0fVtxxTIt3f+R9kawO1Wsmgg30gmKd+xspYX5MDX
         eHrSDWml6eqQ4B2hJ1lJH28zAIwIszdck7LMfysEQg/BK+SW7DXIPFDxg4T3051zEG50
         pESE1+TWTvxTzgdfpn6fhqDznWQ36uzoZDK/9HRVk/r4anLBd3SmZBqG9rDuI2AnCkFj
         w1mFWibKmZ4Pvki0FFgfOxpC3sS1UHoVd5MCGuGuQPXGtVGozdhTuPGw1tlVuGgnN3eQ
         WNI79y07uKKbBnWpBxnM8Gg4aWk7/sss/j6opnvJIEDq/m8cHSSAVOr+LvnR8iPkNX08
         6QEw==
X-Gm-Message-State: AOAM533FnZWSHcZ6PEpazjIbgiMlqy/rQt1wbqyDwV6Np/siBuYj8oP0
        0YGe8hCpL/njHaUQddqMhOpACKyisHs=
X-Google-Smtp-Source: ABdhPJyXw5JJkG4iO3a/8b/I5dsPd7YxYuvFR5K+4JqPLqhR35diCcSkfSqR9rvtQ3zAYM2SqaV1YA==
X-Received: by 2002:a67:e947:: with SMTP id p7mr1678936vso.59.1643296671316;
        Thu, 27 Jan 2022 07:17:51 -0800 (PST)
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com. [209.85.221.172])
        by smtp.gmail.com with ESMTPSA id e14sm636778vsu.3.2022.01.27.07.17.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 07:17:50 -0800 (PST)
Received: by mail-vk1-f172.google.com with SMTP id z15so2031517vkp.13
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 07:17:50 -0800 (PST)
X-Received: by 2002:a05:6122:1811:: with SMTP id ay17mr1708154vkb.2.1643296669982;
 Thu, 27 Jan 2022 07:17:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1643243772.git.asml.silence@gmail.com>
In-Reply-To: <cover.1643243772.git.asml.silence@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 27 Jan 2022 10:17:13 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdp-ueFOSSsX2+wCFK2PwdVuRx=8WCV8GjKGOORiwHeSA@mail.gmail.com>
Message-ID: <CA+FuTSdp-ueFOSSsX2+wCFK2PwdVuRx=8WCV8GjKGOORiwHeSA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 00/10] udp/ipv6 optimisations
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 7:36 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> Shed some weight from udp/ipv6. Zerocopy benchmarks over dummy showed
> ~5% tx/s improvement, should be similar for small payload non-zc
> cases.
>
> The performance comes from killing 4 atomics and a couple of big struct
> memcpy/memset. 1/10 removes a pair of atomics on dst refcounting for
> cork->skb setup, 9/10 saves another pair on cork init. 5/10 and 8/10
> kill extra 88B memset and memcpy respectively.
>
> v2: add a comment about setting dst early in ip6_setup_cork()
>     drop non-udp patches for now
>     add patch 10
>
> Pavel Begunkov (10):
>   ipv6: optimise dst refcounting on skb init
>   udp6: shuffle up->pending AF_INET bits
>   ipv6: remove daddr temp buffer in __ip6_make_skb
>   ipv6: clean up cork setup/release
>   ipv6: don't zero inet_cork_full::fl after use
>   ipv6: pass full cork into __ip6_append_data()
>   udp6: pass flow in ip6_make_skb together with cork
>   udp6: don't make extra copies of iflow
>   ipv6: optimise dst refcounting on cork init
>   ipv6: partially inline ipv6_fixup_options
>
>  include/net/ipv6.h    |  14 ++++--
>  net/ipv6/exthdrs.c    |   8 ++--
>  net/ipv6/ip6_output.c |  99 ++++++++++++++++++++++------------------
>  net/ipv6/udp.c        | 103 ++++++++++++++++++++----------------------
>  4 files changed, 118 insertions(+), 106 deletions(-)

For the series:

Reviewed-by: Willem de Bruijn <willemb@google.com>

Iterative review vs v1, where I only had one small comment, which was
addressed. NB: Due to some subject line changes, it wasn't immediately
clear to me that this was just a range-diff over the first 10 patches
in both series.
