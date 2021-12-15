Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CA5476123
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 19:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344042AbhLOSyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 13:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238744AbhLOSya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 13:54:30 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63330C061574;
        Wed, 15 Dec 2021 10:54:30 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id r11so77349599edd.9;
        Wed, 15 Dec 2021 10:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=892DI7nBTUbNG0pVInYh7MAvJBd0sM6GoSF/qhjlPEk=;
        b=FexRi6oFB32LusaeYmHy3eNxdngvc/80shi5i1uhzyZjlRlht1FnXu6mktMoDycha8
         Zy9y1ieoXiNGjPcGgrL3aUeent/PD6TZOCcz5i+ZoGRUq+GXftpXT8NFdhzP13c8VZ4v
         jiUIajimnQfcB2hpi/Mi+DXYKksTGOKuMbTcGfw+soYsWLyZVWlEYlOYMeFpVHkF+9f+
         siYmCCbz4q4nleNH8DSMfkVX2IP95Es/HHjzjN0gs6nbD5GWlRggQHH9+xFlZj/m+RVE
         NABXCSX8QCTQLAm/rnZMmDoK2IIy/+E2N5fSBpL+oMuaAVue1oLAB//h9ZSHXOzP6yeX
         5RRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=892DI7nBTUbNG0pVInYh7MAvJBd0sM6GoSF/qhjlPEk=;
        b=7+cNf/WlwhVhVP7BaQ9KcHKXKa9N4ImadlNnOiJnYu2+FbsRrun/NCon30x9XxViLE
         P6Qww/Pf9tnLWO2v8TGv7rV8znqFcLShyQ8xPi29kXJNtuBWLAkBUiNxkTGYs5GgWwpm
         JYKGf3hNQsehmQut6b2psbXSa4JEHqWyWh7Md6yLx+57nbFm1K+D8lPHY45zdsIHUpYX
         KOm+hLSKvNBD+7wI2gQuK8VUA0EZwFgMQQuuCrdwz1i/cU1YTzi/BEN5Qa2VqNGotxoA
         5P5VdI6Nv8leGAyDh7eYfyj35xL4Qkiga+HFdi1aBe351cUtKER8viCExx7olVI0DmO+
         8PFA==
X-Gm-Message-State: AOAM532uYK5v4VXt6JumMlGT2CQAF+8x/iTpHLZ77v6a5lLrNgjXrQHJ
        MtE7VlQQ703N5K7bopKKYyU=
X-Google-Smtp-Source: ABdhPJx7IkAXDp9PoYFp8zW/9qa9BodUFLwG/1hYrYvR9mZfdGScA5aVdX6+VfNlRMI9kj3DsWcMxQ==
X-Received: by 2002:a17:906:bccc:: with SMTP id lw12mr12684917ejb.128.1639594468913;
        Wed, 15 Dec 2021 10:54:28 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id nd36sm1037595ejc.17.2021.12.15.10.54.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 10:54:28 -0800 (PST)
Message-ID: <e729a63a-cded-da9c-3860-a90013b87e2d@gmail.com>
Date:   Wed, 15 Dec 2021 18:54:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
Content-Language: en-US
To:     sdf@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
References: <462ce9402621f5e32f08cc8acbf3d9da4d7d69ca.1639579508.git.asml.silence@gmail.com>
 <Yboc/G18R1Vi1eQV@google.com>
 <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
 <Ybom69OyOjsR7kmZ@google.com>
 <634c2c87-84c9-0254-3f12-7d993037495c@gmail.com>
 <Yboy2WwaREgo95dy@google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Yboy2WwaREgo95dy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/21 18:24, sdf@google.com wrote:
> On 12/15, Pavel Begunkov wrote:
>> On 12/15/21 17:33, sdf@google.com wrote:
>> > On 12/15, Pavel Begunkov wrote:
>> > > On 12/15/21 16:51, sdf@google.com wrote:
>> > > > On 12/15, Pavel Begunkov wrote:
>> > > > > � /* Wrappers for __cgroup_bpf_run_filter_skb() guarded by cgroup_bpf_enabled. */
>> > > > > � #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)����������������� \
>> > > > > � ({����������������������������������������� \
>> > > > > ����� int __ret = 0;��������������������������������� \
>> > > > > -��� if (cgroup_bpf_enabled(CGROUP_INET_INGRESS))������������� \
>> > > > > +��� if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) && sk &&������������� \
>> > > > > +������� CGROUP_BPF_TYPE_ENABLED((sk), CGROUP_INET_INGRESS))���������� \
>> > > >
>> > > > Why not add this __cgroup_bpf_run_filter_skb check to
>> > > > __cgroup_bpf_run_filter_skb? Result of sock_cgroup_ptr() is already there
>> > > > and you can use it. Maybe move the things around if you want
>> > > > it to happen earlier.
>> >
>> > > For inlining. Just wanted to get it done right, otherwise I'll likely be
>> > > returning to it back in a few months complaining that I see measurable
>> > > overhead from the function call :)
>> >
>> > Do you expect that direct call to bring any visible overhead?
>> > Would be nice to compare that inlined case vs
>> > __cgroup_bpf_prog_array_is_empty inside of __cgroup_bpf_run_filter_skb
>> > while you're at it (plus move offset initialization down?).
> 
>> Sorry but that would be waste of time. I naively hope it will be visible
>> with net at some moment (if not already), that's how it was with io_uring,
>> that's what I see in the block layer. And in anyway, if just one inlined
>> won't make a difference, then 10 will.
> 
> I can probably do more experiments on my side once your patch is
> accepted. I'm mostly concerned with getsockopt(TCP_ZEROCOPY_RECEIVE).
> If you claim there is visible overhead for a direct call then there
> should be visible benefit to using CGROUP_BPF_TYPE_ENABLED there as
> well.

Interesting, sounds getsockopt might be performance sensitive to
someone.

FWIW, I forgot to mention that for testing tx I'm using io_uring
(for both zc and not) with good submission batching.

-- 
Pavel Begunkov
