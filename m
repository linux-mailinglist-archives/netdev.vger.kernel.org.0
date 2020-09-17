Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 406EF26D8CD
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 12:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgIQKWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 06:22:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50399 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbgIQKWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 06:22:09 -0400
X-Greylist: delayed 940 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 06:22:08 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600338126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sEmMbKMe1QxV4bqUE2e3u88bhKfdXmOnJBcOmDFHAOM=;
        b=hufcEQ8RiissjUs7/bZcakkq7BhkPlb7VZLzrhWxmYHlkEr4aIfNbwxhZT3KVSfOtrve91
        54yCTHPAB2v8Z4MntGEuc4hEktjz7MLiwpnDraYHzd5M0OfOLWWvC5h0Zd3CCZ2FP3w1r2
        VeNOSuHjCpfjfKKeQgGweoiHr7XB2KI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-r9EWlpyLOT2MBwt5j5Ww3A-1; Thu, 17 Sep 2020 06:06:20 -0400
X-MC-Unique: r9EWlpyLOT2MBwt5j5Ww3A-1
Received: by mail-wm1-f69.google.com with SMTP id m125so565685wmm.7
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 03:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=sEmMbKMe1QxV4bqUE2e3u88bhKfdXmOnJBcOmDFHAOM=;
        b=k4CfmG02iHWu/GXqGq15Of+yD33VjKVB+vINvRrCUdpzGlI9ss+lo5y/lacDjtzAIJ
         v2/CUEdjqUwoiWWA/kZ3/veca+7ljnYrxRpKtkbM8u4ku1fpCmiKFPX2l2KS/5z36AbC
         C/DvaRtnKXL98TCsyKxuwBcBoW8oSAYDQB/7TrE17W7AV8Zs6Oz9enZ6sJDpHSb6Y5rJ
         7lD6yVrhW+0dkVkLfto86pOdeDhCsN8MKPDKdQMs6yDkMIde7hBMtO4NbenrRTUPQQsn
         N/tWwqwcS7bp862iFy3ptImUB8bNDGJHvV8+pL4OTMteYIKqUIwA0tpTtcpq9FA/8Ssb
         m8aQ==
X-Gm-Message-State: AOAM532gqnbdDN49DPKbEEueRLXayA5P2eVhooWsTC3Qf/dKrgI6zJ8O
        qrpRxYi9wTmhTapnXsUIsV6VOws2C3Gq8lcxmJrqM0lqQUFRDBpd9hs5nXbUryakrekgXMgXafQ
        /xdwZCBIK73o5KEhI
X-Received: by 2002:a1c:e1d6:: with SMTP id y205mr9127465wmg.92.1600337179485;
        Thu, 17 Sep 2020 03:06:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtfuVSMV3O8PmBqY1xTI1QMjknEHbUV/QY8IcHDGPPKFenck2biv+CQ6avEdNmg9m6cTlirA==
X-Received: by 2002:a1c:e1d6:: with SMTP id y205mr9127429wmg.92.1600337179219;
        Thu, 17 Sep 2020 03:06:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d23sm9785425wmb.6.2020.09.17.03.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 03:06:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2FD5D183A90; Thu, 17 Sep 2020 12:06:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v5 2/8] bpf: verifier: refactor
 check_attach_btf_id()
In-Reply-To: <CAEf4BzbAsnzAUPksUs+bcNuuUPkumc15RLESu3jOGf87mzabBA@mail.gmail.com>
References: <160017005691.98230.13648200635390228683.stgit@toke.dk>
 <160017005916.98230.1736872862729846213.stgit@toke.dk>
 <CAEf4BzbAsnzAUPksUs+bcNuuUPkumc15RLESu3jOGf87mzabBA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 17 Sep 2020 12:06:18 +0200
Message-ID: <87lfh8ogyt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

>>
>> +int bpf_check_attach_target(struct bpf_verifier_log *log,
>> +                           const struct bpf_prog *prog,
>> +                           const struct bpf_prog *tgt_prog,
>> +                           u32 btf_id,
>> +                           struct btf_func_model *fmodel,
>> +                           long *tgt_addr,
>> +                           const char **tgt_name,
>> +                           const struct btf_type **tgt_type);
>
> So this is obviously an abomination of a function signature,
> especially for a one exported to other files.
>
> One candidate to remove would be tgt_type, which is supposed to be a
> derivative of target BTF (vmlinux or tgt_prog->btf) + btf_id,
> **except** (and that's how I found the bug below), in case of
> fentry/fexit programs attaching to "conservative" BPF functions, in
> which case what's stored in aux->attach_func_proto is different from
> what is passed into btf_distill_func_proto. So that's a bug already
> (you'll return NULL in some cases for tgt_type, while it has to always
> be non-NULL).

Okay, looked at this in more detail, and I don't think the refactored
code is doing anything different from the pre-refactor version?

Before we had this:

		if (tgt_prog && conservative) {
			prog->aux->attach_func_proto = NULL;
			t = NULL;
		}

and now we just have

		if (tgt_prog && conservative)
			t = NULL;

in bpf_check_attach_target(), which gets returned as tgt_type and
subsequently assigned to prog->aux->attach_func_proto.

> But related to that is fmodel. It seems like bpf_check_attach_target()
> has no interest in fmodel itself and is just passing it from
> btf_distill_func_proto(). So I was about to suggest dropping fmodel
> and calling btf_distill_func_proto() outside of
> bpf_check_attach_target(), but given the conservative + fentry/fexit
> quirk, it's probably going to be more confusing.
>
> So with all this, I suggest dropping the tgt_type output param
> altogether and let callers do a `btf__type_by_id(tgt_prog ?
> tgt_prog->aux->btf : btf_vmlinux, btf_id);`. That will both fix the
> bug and will make this function's signature just a tad bit less
> horrible.

Thought about this, but the logic also does a few transformations of the
type itself, e.g., this for bpf_trace_raw_tp:

		tname += sizeof(prefix) - 1;
		t = btf_type_by_id(btf, t->type);
		if (!btf_type_is_ptr(t))
			/* should never happen in valid vmlinux build */
			return -EINVAL;
		t = btf_type_by_id(btf, t->type);
		if (!btf_type_is_func_proto(t))
			/* should never happen in valid vmlinux build */
			return -EINVAL;

so to catch this we really do have to return the type from the function
as well.

I do agree that the function signature is a tad on the long side, but I
couldn't think of any good way of making it smaller. I considered
replacing the last two return values with a boolean 'save' parameter,
that would just make it same the values directly in prog->aux; but I
actually find it easier to reason about a function that is strictly
checking things and returning the result, instead of 'sometimes modify'
semantics...

-Toke

