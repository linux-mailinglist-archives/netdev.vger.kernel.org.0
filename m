Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AFC6911DE
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 21:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjBIUGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 15:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjBIUFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 15:05:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E4B6ADF6
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 12:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675973084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d0BqT8tPuat49tgSWN97OHDZtonJw6ZWxWI/LJDmqzg=;
        b=GpBXWVJwQPLiO1CaPW0JXlt4lAfcvz6pyb9Nf36OeDVlXkEBMVmK1yBRxD+5rCpF4xsKMY
        W+s+kuoqjyQW/gvllKtvI8eS/5xcESpl0hFtWEgEe42dF6zjvK2I4himbvP65RoouYO9Xc
        0n7iwMN2uhA7+S9b08dVMvlJW3VATFY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-39-EBDYQyk2MwOdN1zfaOqJqg-1; Thu, 09 Feb 2023 15:04:43 -0500
X-MC-Unique: EBDYQyk2MwOdN1zfaOqJqg-1
Received: by mail-ej1-f69.google.com with SMTP id l18-20020a1709067d5200b008af415fdd80so1536301ejp.21
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 12:04:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d0BqT8tPuat49tgSWN97OHDZtonJw6ZWxWI/LJDmqzg=;
        b=cIPojTeaa/RbENETvIS2JoYGrp9xYQO6sey7iDRfSjcIv9Pukez2RiyzJAheA702cr
         lzoEfubLNk8AGODnYhC/NhP8xXSY7ChGaCvTQoZEO6zAv2QR/Kj6Ijnk8atvJYMezyi2
         yoGFx98VZqsP0yLIMwze6lZ8cQUBE7LlfqmRSVgXATN8yLqMg8yo83iquJ2jGzDrNC/g
         kzEbugEQBGuGlz+TfFi1lxOGNsi4MKJGBpT0epWF3qPYqGzSPyMVgZwDConGhJ9cff7P
         MQMiqXLMT6ydm3vbEYVDZRXuU8axpEipLTn0HC0iLK0yP0ouHnQoCkXXc+vo2xg5HXMf
         nX5A==
X-Gm-Message-State: AO0yUKUwCyo0JcZAg1KF9FSQy88k86spF8SvxKgMbh4cwz5+tiab5NV4
        tvHrDE+OoreMyrnNg7s8PLl5xdh8a6BKpbVkZwIdUU7T0Y+K8y171PYHR0CStI91w1ykS6ZenvF
        2D1z4edW3ew2ioL1L
X-Received: by 2002:a17:907:98b7:b0:881:44e3:baae with SMTP id ju23-20020a17090798b700b0088144e3baaemr11499918ejc.54.1675973081145;
        Thu, 09 Feb 2023 12:04:41 -0800 (PST)
X-Google-Smtp-Source: AK7set/yf2CES5+C5nHAOSi4QKD1/IdjrsGDmNgVrkYJEE5A5Npz3f8tWssmZbfx7CJ76YM7FVy3QA==
X-Received: by 2002:a17:907:98b7:b0:881:44e3:baae with SMTP id ju23-20020a17090798b700b0088144e3baaemr11499894ejc.54.1675973080879;
        Thu, 09 Feb 2023 12:04:40 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n16-20020a1709062bd000b008af2a7438acsm1270734ejg.188.2023.02.09.12.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 12:04:40 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6DDD0973E1D; Thu,  9 Feb 2023 21:04:38 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
In-Reply-To: <20230209172827.874728-1-alexandr.lobakin@intel.com>
References: <20230209172827.874728-1-alexandr.lobakin@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 09 Feb 2023 21:04:38 +0100
Message-ID: <87v8ka7gh5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin <alexandr.lobakin@intel.com> writes:

> &xdp_buff and &xdp_frame are bound in a way that
>
> xdp_buff->data_hard_start == xdp_frame
>
> It's always the case and e.g. xdp_convert_buff_to_frame() relies on
> this.
> IOW, the following:
>
> 	for (u32 i = 0; i < 0xdead; i++) {
> 		xdpf = xdp_convert_buff_to_frame(&xdp);
> 		xdp_convert_frame_to_buff(xdpf, &xdp);
> 	}
>
> shouldn't ever modify @xdpf's contents or the pointer itself.
> However, "live packet" code wrongly treats &xdp_frame as part of its
> context placed *before* the data_hard_start. With such flow,
> data_hard_start is sizeof(*xdpf) off to the right and no longer points
> to the XDP frame.

Oh, nice find!

> Instead of replacing `sizeof(ctx)` with `offsetof(ctx, xdpf)` in several
> places and praying that there are no more miscalcs left somewhere in the
> code, unionize ::frm with ::data in a flex array, so that both starts
> pointing to the actual data_hard_start and the XDP frame actually starts
> being a part of it, i.e. a part of the headroom, not the context.
> A nice side effect is that the maximum frame size for this mode gets
> increased by 40 bytes, as xdp_buff::frame_sz includes everything from
> data_hard_start (-> includes xdpf already) to the end of XDP/skb shared
> info.

I like the union approach, however...

> (was found while testing XDP traffic generator on ice, which calls
>  xdp_convert_frame_to_buff() for each XDP frame)
>
> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  net/bpf/test_run.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 2723623429ac..c3cce7a8d47d 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -97,8 +97,11 @@ static bool bpf_test_timer_continue(struct bpf_test_timer *t, int iterations,
>  struct xdp_page_head {
>  	struct xdp_buff orig_ctx;
>  	struct xdp_buff ctx;
> -	struct xdp_frame frm;
> -	u8 data[];
> +	union {
> +		/* ::data_hard_start starts here */
> +		DECLARE_FLEX_ARRAY(struct xdp_frame, frm);
> +		DECLARE_FLEX_ARRAY(u8, data);
> +	};

...why does the xdp_frame need to be a flex array? Shouldn't this just be:

 +	union {
 +		/* ::data_hard_start starts here */
 +		struct xdp_frame frm;
 +		DECLARE_FLEX_ARRAY(u8, data);
 +	};

which would also get rid of the other three hunks of the patch?

-Toke

