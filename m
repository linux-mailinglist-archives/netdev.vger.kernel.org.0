Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CBD27EC66
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbgI3PXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgI3PXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 11:23:50 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83466C0613D0
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 08:23:50 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id h9so1232880qvr.3
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 08:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=IvHq18Lc4WiZdtWJmzAeX9jp1pRwjzCbQflHsOOQmgw=;
        b=uisN+BblHp4nzOXvr4E3x3qbeN8PNxZgisNmR49Q+0GEqQNbN1JckswYrziFw+6lBx
         wYv/26r0cgCJAY2N291r/m6mQZNaJePp/xmn/jrNi/vbqLRV0Ii1CJO12ycegV/Ur+VP
         2sCFWNxuSPYsFMFFeossEItDyEeoeHafiOX0vpOuOcQ4RsWLkMJ+9s4KhwoHRvgzDBRh
         CSPvqCcnWVYG42eNddW+kYsEzXE99mpXkYWfqYupevnjJYki70CjsVmMWVSq8fXkOjBq
         5yqNQkQcchAanN2KLQF/QoEilr1T6Hb24pS6FuVyjbZwWlR1T+dIbJiqRapIMhu4larN
         DUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IvHq18Lc4WiZdtWJmzAeX9jp1pRwjzCbQflHsOOQmgw=;
        b=thdRT1ghOFwTW8g80Aq8H+5qOTZHxZF8OcrzEkZVMJjYZn9L6bzF6kBhB+VGKesCPo
         PWk+xbUGj1ClkHzi3GnVdxe/zzxY2tPVYqCOYJTieKDLOA/oWQK6hUlxs2alKgFHxCtm
         8D9qaFbBlc/N2F2OSABGHmlkZ1lDlo7R0+RVFzZJmX3N1pPC1YUxbUS2LntgEZHVXhaG
         3MxRMSnTTkpAEHu7S+EoXjWFkC2vQBmkXuFov6VLr39BkJaiUaUsKDEQ/hMQ9idjn+x5
         491BY4z/FsaTDMEIDP/7XRuw/UCu79h8TrvLj+PYGtO78A4KOKo6h+gzl7mMta9FWp7g
         eunA==
X-Gm-Message-State: AOAM532etCi7638idL//sn+4k8N4PkJXi4F1XJVxWnF2l1TqW/OqKWm9
        qFixyMASL+rkclNqRYVRxAY4Ut0=
X-Google-Smtp-Source: ABdhPJzHqznOgKgPLiM7/fnLyon5HQfPB7+cRg5PyxkcIwtzWAZNMpfZOYJDF0neVPCXSz4H/UBu3rc=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a0c:c48f:: with SMTP id u15mr3027227qvi.55.1601479429373;
 Wed, 30 Sep 2020 08:23:49 -0700 (PDT)
Date:   Wed, 30 Sep 2020 08:23:47 -0700
In-Reply-To: <20200820190104.2885895-1-kafai@fb.com>
Message-Id: <20200930152347.GA1856340@google.com>
Mime-Version: 1.0
References: <20200820190008.2883500-1-kafai@fb.com> <20200820190104.2885895-1-kafai@fb.com>
Subject: Re: [PATCH v5 bpf-next 09/12] bpf: tcp: Allow bpf prog to write and
 parse TCP header option
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/20, Martin KaFai Lau wrote:
> [..]
> +static inline void bpf_skops_init_child(const struct sock *sk,
> +					struct sock *child)
> +{
> +	tcp_sk(child)->bpf_sock_ops_cb_flags =
> +		tcp_sk(sk)->bpf_sock_ops_cb_flags &
> +		(BPF_SOCK_OPS_PARSE_ALL_HDR_OPT_CB_FLAG |
> +		 BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG |
> +		 BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG);
> +}
It looks like it breaks test_tcpbpf_user test in an interesting way, can
you verify on your side?

Awhile ago, I've added retries to this test to make it less flaky.
The test is waiting for 3 BPF_TCP_CLOSE events and now it
only gets 2 BPF_TCP_CLOSE events.

IIUC, we used to copy/inherit parent bpf_sock_ops_cb_flags and now
we are doing only a small subset (bpf tcp header) with the code above.

I'm still trying to understand whether that's working as intended
and we need to fix the test or it's a user-visible breakage.
Thoughts?
