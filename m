Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92442FD23E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 15:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388064AbhATOB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:01:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36206 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729636AbhATMqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 07:46:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611146670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sUAqRM/yS0M5hIXrhzb/rZQVUUoVZTMsafAH4hmcgY0=;
        b=RkKEDc7C19EuT5XCEc9+Fg3oPuS384oWNonZWWHoPY621gxNez53D7Gx3thb2p60SSqq80
        tLhCyz9PDIuhaNviG8huJE8h4TaYpGpvNJoHskqeyc6DXVkzUzY3p5lyDdyLbut975AZK1
        z04WQ9PhjXA9/zBNVZb1sctazlo1MkY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-EyT9mXjVPEewOITzCvOvhg-1; Wed, 20 Jan 2021 07:44:29 -0500
X-MC-Unique: EyT9mXjVPEewOITzCvOvhg-1
Received: by mail-ej1-f69.google.com with SMTP id x22so7446197ejb.10
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 04:44:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=sUAqRM/yS0M5hIXrhzb/rZQVUUoVZTMsafAH4hmcgY0=;
        b=bbDmnmdITblhYB2zcx4YsDOLmtf0TXTGET4BFKjNUHkGo1l3pCFJI7AZhanUwwtRxr
         nkS5+zDjNMx/EHyTyXZPCdsYZdFfPncTCuKZDCVSWfQYTTVSDBB/dudEpRbTS1ijP7wq
         H5ybnZTwIfPW/dS0acBMBFoL4qEqBdxMjHeIfd3ajA4CGDBsmNxUbg//g/2cTKNNyaOt
         WW4FW1uLXRlTcadzY+Q+ahTXiC0ZEQJcisP/m1mYi6qtkpfXe/MAp5puUmIOTk8mgIm6
         Fdfgd7TymMHXm6xnkykiZJNsOq0WxoeqD6eO7ocIEs/g2n8UCQ3tdhumqB/9l4thO8iZ
         lEWw==
X-Gm-Message-State: AOAM532kHv364RE9qXIYtbYvHuyKb8KKd+/hIKkk3KG0lUKKSg91R6N6
        r7RpXRQPHLn1KzIUQ15W1f45UPhv0nAiyw76HU/bCUeBwOORT1bVFGYGki3O7oUyDaLmfzuqa65
        JNDjMhKLuPiqYfX9U
X-Received: by 2002:a17:906:853:: with SMTP id f19mr5788738ejd.259.1611146666085;
        Wed, 20 Jan 2021 04:44:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5dm2HB0RZ5ZugSPvLT4yyM9ikHbHT6/9rABxR/0diF0XKB6XZRuRPdjbACzDcjhZAMtrsaA==
X-Received: by 2002:a17:906:853:: with SMTP id f19mr5788731ejd.259.1611146665894;
        Wed, 20 Jan 2021 04:44:25 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t21sm1083028edv.82.2021.01.20.04.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 04:44:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8EE95180331; Wed, 20 Jan 2021 13:44:24 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: Re: [PATCH bpf-next v2 1/8] xdp: restructure redirect actions
In-Reply-To: <20210119155013.154808-2-bjorn.topel@gmail.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-2-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Jan 2021 13:44:24 +0100
Message-ID: <87bldjeq1j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> The XDP_REDIRECT implementations for maps and non-maps are fairly
> similar, but obviously need to take different code paths depending on
> if the target is using a map or not. Today, the redirect targets for
> XDP either uses a map, or is based on ifindex.
>
> Future commits will introduce yet another redirect target via the a
> new helper, bpf_redirect_xsk(). To pave the way for that, we introduce
> an explicit redirect type to bpf_redirect_info. This makes the code
> easier to follow, and makes it easier to add new redirect targets.
>
> Further, using an explicit type in bpf_redirect_info has a slight
> positive performance impact by avoiding a pointer indirection for the
> map type lookup, and instead use the hot cacheline for
> bpf_redirect_info.
>
> The bpf_redirect_info flags member is not used by XDP, and not
> read/written any more. The map member is only written to when
> required/used, and not unconditionally.

I like the simplification. However, the handling of map clearing becomes
a bit murky with this change:

You're not changing anything in bpf_clear_redirect_map(), and you're
removing most of the reads and writes of ri->map. Instead,
bpf_xdp_redirect_map() will store the bpf_dtab_netdev pointer in
ri->tgt_value, which xdp_do_redirect() will just read and use without
checking. But if the map element (or the entire map) has been freed in
the meantime that will be a dangling pointer. I *think* the RCU callback
in dev_map_delete_elem() and the rcu_barrier() in dev_map_free()
protects against this, but that is by no means obvious. So confirming
this, and explaining it in a comment would be good.

Also, as far as I can tell after this, ri->map is only used for the
tracepoint. So how about just storing the map ID and getting rid of the
READ/WRITE_ONCE() entirely?

(Oh, and related to this I think this patch set will conflict with
Hangbin's multi-redirect series, so maybe you two ought to coordinate? :))

-Toke

