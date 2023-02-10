Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E5C6924B0
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbjBJRjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjBJRjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:39:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587576CC7A
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 09:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676050731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FBaTiXgA5iu27pt+tBu2HMCwel4WBbOncMhPaoLql4w=;
        b=XRg/NoCf3zSLFnT68nlu/ZtrIjrfFQobyu7ay+XxGKZN81vPYmcdQWn4LtkYbRN6c6ykVA
        rvWnD6Iqi5o9ei75+pOJ4rnm4CMg37ZNhJdlsUOXEDjLYW8CUpfM9f8n03+xfptBbVWatw
        YyPcix9K1eCh0krLFh+XrgAttJsG9QA=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-457-tM5gKLODPRyZ9obv44ulsg-1; Fri, 10 Feb 2023 12:38:50 -0500
X-MC-Unique: tM5gKLODPRyZ9obv44ulsg-1
Received: by mail-ej1-f70.google.com with SMTP id wu9-20020a170906eec900b0088e1bbefaeeso4043265ejb.12
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 09:38:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FBaTiXgA5iu27pt+tBu2HMCwel4WBbOncMhPaoLql4w=;
        b=I+YGBHA84IIFLUtwZcDolbpV6JMfBquRIegJd2p2tRjCGEJTB/SIns30SDtg8NDWzk
         bZQQvem7EIAdYp9hCLgif0Z0HdbfRBiylpioY07l+qPGZUwI64Yia2l4EsADlSpxjLsp
         mutyjrevqw4KMsnLiaEkJZdQWETLD+RqIV1bxOanykzGCgh+zqBZgaJKK3PbXQFzJY4U
         p9+8uUi+lcgTD+dLhuejZq+uwKFVci/MGhIT2hq2+EXo90fe7mjwFBbJHk02baHeviQo
         CIgdtGLyf7BGUoW7ybtJDJPlyVcDFgxOxSnyWCjr4TxafvtXNvsF+BgTa+QXATXHmC/N
         4FsQ==
X-Gm-Message-State: AO0yUKUlK5huGiP77VniRkwqxuiTCV1w4pIJpxNLYPv/rK0UwZLL3Ww3
        zj2CqFaV2dtWdQLyxNibB7eCXj561s5WDHJr3GhLr/p9gjoukT8d5qeDvVH6rtDBeltcZwm82cU
        zLDx1r/OYXXNacDpa
X-Received: by 2002:a50:8aca:0:b0:4aa:a65c:69a6 with SMTP id k10-20020a508aca000000b004aaa65c69a6mr12350292edk.15.1676050728258;
        Fri, 10 Feb 2023 09:38:48 -0800 (PST)
X-Google-Smtp-Source: AK7set9bEH/8h3yh6LKh4ctPhmTHDSNi6mYoWvZ2Unm9hPDdyGeZywj8mdzzSzg4h/gUy1JNJcbudA==
X-Received: by 2002:a50:8aca:0:b0:4aa:a65c:69a6 with SMTP id k10-20020a508aca000000b004aaa65c69a6mr12350267edk.15.1676050727949;
        Fri, 10 Feb 2023 09:38:47 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s6-20020a50d486000000b004aab36ad060sm2522011edi.92.2023.02.10.09.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 09:38:47 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C88DB973E6F; Fri, 10 Feb 2023 18:38:45 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
In-Reply-To: <8d3a9feb-9ee5-4a49-330a-9a475e459228@intel.com>
References: <20230209172827.874728-1-alexandr.lobakin@intel.com>
 <87v8ka7gh5.fsf@toke.dk> <8d3a9feb-9ee5-4a49-330a-9a475e459228@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 10 Feb 2023 18:38:45 +0100
Message-ID: <87lel5774q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
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

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Date: Thu, 09 Feb 2023 21:04:38 +0100
>
>> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
>>=20
>>> &xdp_buff and &xdp_frame are bound in a way that
>>>
>>> xdp_buff->data_hard_start =3D=3D xdp_frame
>>>
>>> It's always the case and e.g. xdp_convert_buff_to_frame() relies on
>>> this.
>>> IOW, the following:
>>>
>>> 	for (u32 i =3D 0; i < 0xdead; i++) {
>>> 		xdpf =3D xdp_convert_buff_to_frame(&xdp);
>>> 		xdp_convert_frame_to_buff(xdpf, &xdp);
>>> 	}
>>>
>>> shouldn't ever modify @xdpf's contents or the pointer itself.
>>> However, "live packet" code wrongly treats &xdp_frame as part of its
>>> context placed *before* the data_hard_start. With such flow,
>>> data_hard_start is sizeof(*xdpf) off to the right and no longer points
>>> to the XDP frame.
>>=20
>> Oh, nice find!
>>=20
>>> Instead of replacing `sizeof(ctx)` with `offsetof(ctx, xdpf)` in several
>>> places and praying that there are no more miscalcs left somewhere in the
>>> code, unionize ::frm with ::data in a flex array, so that both starts
>>> pointing to the actual data_hard_start and the XDP frame actually starts
>>> being a part of it, i.e. a part of the headroom, not the context.
>>> A nice side effect is that the maximum frame size for this mode gets
>>> increased by 40 bytes, as xdp_buff::frame_sz includes everything from
>>> data_hard_start (-> includes xdpf already) to the end of XDP/skb shared
>>> info.
>>=20
>> I like the union approach, however...
>>=20
>>> (was found while testing XDP traffic generator on ice, which calls
>>>  xdp_convert_frame_to_buff() for each XDP frame)
>>>
>>> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_R=
UN")
>>> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>>> ---
>>>  net/bpf/test_run.c | 13 ++++++++-----
>>>  1 file changed, 8 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>>> index 2723623429ac..c3cce7a8d47d 100644
>>> --- a/net/bpf/test_run.c
>>> +++ b/net/bpf/test_run.c
>>> @@ -97,8 +97,11 @@ static bool bpf_test_timer_continue(struct bpf_test_=
timer *t, int iterations,
>>>  struct xdp_page_head {
>>>  	struct xdp_buff orig_ctx;
>>>  	struct xdp_buff ctx;
>>> -	struct xdp_frame frm;
>>> -	u8 data[];
>>> +	union {
>>> +		/* ::data_hard_start starts here */
>>> +		DECLARE_FLEX_ARRAY(struct xdp_frame, frm);
>>> +		DECLARE_FLEX_ARRAY(u8, data);
>>> +	};
>>=20
>> ...why does the xdp_frame need to be a flex array? Shouldn't this just b=
e:
>>=20
>>  +	union {
>>  +		/* ::data_hard_start starts here */
>>  +		struct xdp_frame frm;
>>  +		DECLARE_FLEX_ARRAY(u8, data);
>>  +	};
>>=20
>> which would also get rid of the other three hunks of the patch?
>
> That was my first thought. However, as I mentioned in between the lines
> in the commitmsg, this doesn't decrease the sizeof(ctx), so we'd have to
> replace those sizeofs with offsetof() in a couple places (-> the patch
> length would be the same). So I went this way to declare that frm
> doesn't belong to ctx but to the headroom.

Ah, right, I see! Okay, let's keep both as flex arrays, then. One other
nit, though: after your patch, we'll end up with this:

	frm =3D head->frm;
	data =3D &head->data;

both of those assignments refer to flex arrays, which seems a bit
inconsistent. The second one works because it's assigning to a void
pointer, so the compiler doesn't complain about the type mismatch; but
it should work with just 'data =3D head->data' as well, so can we update
that as well for consistency?

-Toke

