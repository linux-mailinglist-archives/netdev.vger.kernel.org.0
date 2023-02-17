Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AF069B1D4
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjBQRcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjBQRcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:32:23 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97FF6FF25
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 09:32:20 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id n18-20020a170902d2d200b0019af23e69dcso881366plc.19
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 09:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DArjXXDNQRsYQhK6h63j4dzN+54MRI8O7eHfF2Zt/UU=;
        b=NL9h4U5ep2E5sXOMhqy8I7wxmsEUWTdQW6RLDugopP/dGGeZWIuLRiWows0NlqGO9m
         EvIL1/+V211wxawY7HlmhX4tFpudQbfrSdlxdTsH0Wt132+qTxYgpjz0hR7LgWSoWULi
         uKzURgE1/GIEr2/YR/SW+9GQo4ZNDOcQtXpHhbgF7SWDKcJ2gydSUU6jYM/r6cHoVtkO
         lCCzk56Wz4PBR6D29aNB0v9PkBC4V2o5VCJHC1VGFUnjht8VqAaka/i+JxPRGi/p3SFh
         IJSPkR9z3FBbFPMWkF5JMjbIYcU4i0OgO0BQ9kVgxb06pBSiQPUnlxZVlByzCw1hV459
         W7Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DArjXXDNQRsYQhK6h63j4dzN+54MRI8O7eHfF2Zt/UU=;
        b=mO+ce6bPY2djPKdzp/Yyn9ArasdYm1W/q1d19zOWTAyt760zlhYfCbUNbV16og2qDr
         J6E5BiVg0k3tSsxO14ydSVT+5jcbyFtW08cgOo+AnmsJouPz7VjF4+bLwi+e1GVNDhtz
         L0eC5Wfs5pJEz8NRmiMOMHHrvhlabZ2oSzqtAor9jEE2Sxem//p3JEIvjFc4RuBiIVHC
         EXTYZFNVvNxQ87lApj2LQIKB8AXsDiWZXvVb8jYxseiBAJ0wD0HMHG/fPrvhGIYCS6ut
         JNGv62/9ZVSu8pVbzffSnXXPaJLCuugZda0Mp/PX/LVUWyIeybODOYiatu1nReNYilrb
         /jvQ==
X-Gm-Message-State: AO0yUKVL4JAy0KgbCe5XaJ16+CBDsXC2Hqh+ir5fg9sJ8D4Bb7MQPd1p
        /Aj0r8gBdAtYTf5GpBpxG9tULj0=
X-Google-Smtp-Source: AK7set/E9LNtU03e6AkqmhQ3HuHBrklEb4lresK5t85/XOf5jl7DUccaOnTpEACX6xjESgavq2uPsU8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:aa7:868d:0:b0:5a8:4dc1:5916 with SMTP id
 d13-20020aa7868d000000b005a84dc15916mr272903pfo.2.1676655140286; Fri, 17 Feb
 2023 09:32:20 -0800 (PST)
Date:   Fri, 17 Feb 2023 09:32:18 -0800
In-Reply-To: <167663589722.1933643.15760680115820248363.stgit@firesoul>
Mime-Version: 1.0
References: <167663589722.1933643.15760680115820248363.stgit@firesoul>
Message-ID: <Y++6IvP+PloUrCxs@google.com>
Subject: Re: [PATCH bpf-next V2] xdp: bpf_xdp_metadata use NODEV for no device support
From:   Stanislav Fomichev <sdf@google.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/17, Jesper Dangaard Brouer wrote:
> With our XDP-hints kfunc approach, where individual drivers overload the
> default implementation, it can be hard for API users to determine
> whether or not the current device driver have this kfunc available.

> Change the default implementations to use an errno (ENODEV), that
> drivers shouldn't return, to make it possible for BPF runtime to
> determine if bpf kfunc for xdp metadata isn't implemented by driver.

> This is intended to ease supporting and troubleshooting setups. E.g.
> when users on mailing list report -19 (ENODEV) as an error, then we can
> immediately tell them their device driver is too old.

I agree with the v1 comments that I'm not sure how it helps.
Why can't we update the doc in the same fashion and say that
the drivers shouldn't return EOPNOTSUPP?

I'm fine with the change if you think it makes your/users life
easier. Although I don't really understand how. We can, as Toke
mentioned, ask the users to provide jited program dump if it's
mostly about user reports.

> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   Documentation/networking/xdp-rx-metadata.rst |    3 ++-
>   net/core/xdp.c                               |    8 ++++++--
>   2 files changed, 8 insertions(+), 3 deletions(-)

> diff --git a/Documentation/networking/xdp-rx-metadata.rst  
> b/Documentation/networking/xdp-rx-metadata.rst
> index aac63fc2d08b..89f6a7d1be38 100644
> --- a/Documentation/networking/xdp-rx-metadata.rst
> +++ b/Documentation/networking/xdp-rx-metadata.rst
> @@ -26,7 +26,8 @@ consumers, an XDP program can store it into the  
> metadata area carried
>   ahead of the packet.

>   Not all kfuncs have to be implemented by the device driver; when not
> -implemented, the default ones that return ``-EOPNOTSUPP`` will be used.
> +implemented, the default ones that return ``-ENODEV`` will be used to
> +indicate the device driver have not implemented this kfunc.

>   Within an XDP frame, the metadata layout (accessed via ``xdp_buff``) is
>   as follows::
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 26483935b7a4..7bb5984ae4f7 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -722,10 +722,12 @@ __diag_ignore_all("-Wmissing-prototypes",
>    * @timestamp: Return value pointer.
>    *
>    * Returns 0 on success or ``-errno`` on error.
> + *
> + *  -ENODEV (19): means device driver doesn't implement kfunc
>    */
>   __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,  
> u64 *timestamp)
>   {
> -	return -EOPNOTSUPP;
> +	return -ENODEV;
>   }

>   /**
> @@ -734,10 +736,12 @@ __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const  
> struct xdp_md *ctx, u64 *tim
>    * @hash: Return value pointer.
>    *
>    * Returns 0 on success or ``-errno`` on error.
> + *
> + *  -ENODEV (19): means device driver doesn't implement kfunc
>    */
>   __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32  
> *hash)
>   {
> -	return -EOPNOTSUPP;
> +	return -ENODEV;
>   }

>   __diag_pop();


