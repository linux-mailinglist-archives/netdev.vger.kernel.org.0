Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3100E222ED3
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 01:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgGPXN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 19:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgGPXN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 19:13:27 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995B5C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 16:13:26 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id lx13so8602110ejb.4
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 16:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u7YjX47hqArFZji3f4cV31EtG37Xc315+j3Qqp1cu58=;
        b=IeLCFeWjf91VKxdfOiQYJjVA2U5jqN/0a5eVkz/+OcD2icCWdjs6pFbsNQm0zkVXUG
         jP0paov4rc5VtTaJyhCQBBnO9Z9tyyn8B88WUc/Q5lqxLilrfRiU4Il91F8Sdp0i+8dv
         HJ6xFrDH4WVMkgCL5luPabjPEsbMMn/mIEiUQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u7YjX47hqArFZji3f4cV31EtG37Xc315+j3Qqp1cu58=;
        b=SxuS7FEagkJtZDZngtq5XYG2pyt65jbikwDK4nZVTeeVM54oCsjCoicS+35wCQ0C2k
         cxh/m7KWc4J9toVTaCqpgzg/TVRqi4XDmx5qcb0+1LvycAkMvUKxgiMKrpmje1vZSj8Y
         5+nBieDpvYTHxTGBV11T5JDkRDtErUsKWkwoIhf4zm73zbLgIYkmrcEQHJBdOLBuFjby
         t0B8H3io13XATAUFyEP89EwtARKYg9IAszB/rqtuMXs2j1EBe5fj9279n42tFSKa3rnG
         MmKGjN5+xFPrE58WkM/cDqJLjmOLPyc9JjCAPXwk8Yxo4lF+dKrANBvjAjbQmR4l853U
         H9SA==
X-Gm-Message-State: AOAM530xLvxRxi6S+5EzfDDWPRd5gehSulVhPa/d4cwoOTktiFekt+3o
        71EThmwkBaDGHBS/2TaGxL/ISw==
X-Google-Smtp-Source: ABdhPJxUp694icLygoJQSEf16T0WOGqwjy/PheU82RUTBt1VX5M87ottP5NFpnR2N+nlpflESt/J/w==
X-Received: by 2002:a17:906:c150:: with SMTP id dp16mr5911917ejc.536.1594941205113;
        Thu, 16 Jul 2020 16:13:25 -0700 (PDT)
Received: from [192.168.2.66] ([81.6.44.51])
        by smtp.gmail.com with ESMTPSA id c10sm6608208edt.22.2020.07.16.16.13.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 16:13:24 -0700 (PDT)
Subject: Re: [PATCH v4 bpf-next 10/14] bpf: Add d_path helper
To:     Jiri Olsa <jolsa@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Florent Revest <revest@chromium.org>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-11-jolsa@kernel.org>
 <CAEf4BzY4EqkbB7Ob9EZAJrWdBRtH_k3sL=4JZzAiqkMXjYjNKA@mail.gmail.com>
 <20200628194242.GB2988321@krava>
From:   KP Singh <kpsingh@chromium.org>
Message-ID: <6f3fd6b0-cc3d-57e7-0444-dcaf399e6abd@chromium.org>
Date:   Fri, 17 Jul 2020 01:13:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200628194242.GB2988321@krava>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/28/20 9:42 PM, Jiri Olsa wrote:
> On Fri, Jun 26, 2020 at 01:38:27PM -0700, Andrii Nakryiko wrote:
>> On Thu, Jun 25, 2020 at 4:49 PM Jiri Olsa <jolsa@kernel.org> wrote:
>>>
>>> Adding d_path helper function that returns full path
>>> for give 'struct path' object, which needs to be the
>>> kernel BTF 'path' object.
>>>
>>> The helper calls directly d_path function.
>>>
>>> Updating also bpf.h tools uapi header and adding
>>> 'path' to bpf_helpers_doc.py script.
>>>
>>> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>>> ---
>>>  include/uapi/linux/bpf.h       | 14 +++++++++-
>>>  kernel/trace/bpf_trace.c       | 47 ++++++++++++++++++++++++++++++++++
>>>  scripts/bpf_helpers_doc.py     |  2 ++
>>>  tools/include/uapi/linux/bpf.h | 14 +++++++++-
>>>  4 files changed, 75 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index 0cb8ec948816..23274c81f244 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -3285,6 +3285,17 @@ union bpf_attr {
>>>   *             Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
>>>   *     Return
>>>   *             *sk* if casting is valid, or NULL otherwise.
>>> + *
>>> + * int bpf_d_path(struct path *path, char *buf, u32 sz)
>>> + *     Description
>>> + *             Return full path for given 'struct path' object, which
>>> + *             needs to be the kernel BTF 'path' object. The path is
>>> + *             returned in buffer provided 'buf' of size 'sz'.
>>> + *
>>> + *     Return
>>> + *             length of returned string on success, or a negative
>>> + *             error in case of failure
>>
>> It's important to note whether string is always zero-terminated (I'm
>> guessing it is, right?).
> 
> right, will add

Also note that bpf_probe_read_{kernel, user}_str return the length including
the NUL byte:

 * 	Return
 * 		On success, the strictly positive length of the string,
 * 		including the trailing NUL character. On error, a negative
 * 		value.

It would be good to keep this uniform. So you will need a len += 1 here as well.

- KP

> 
>>
>>> + *
>>>   */
>>>  #define __BPF_FUNC_MAPPER(FN)          \
>>>         FN(unspec),                     \
>>> @@ -3427,7 +3438,8 @@ union bpf_attr {
>>>         FN(skc_to_tcp_sock),            \
>>>         FN(skc_to_tcp_timewait_sock),   \
>>>         FN(skc_to_tcp_request_sock),    \
>>> -       FN(skc_to_udp6_sock),
>>> +       FN(skc_to_udp6_sock),           \
>>> +       FN(d_path),
>>>
>>>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>>>   * function eBPF program intends to call
>>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>>> index b124d468688c..6f31e21565b6 100644
>>> --- a/kernel/trace/bpf_trace.c
>>> +++ b/kernel/trace/bpf_trace.c
>>> @@ -1060,6 +1060,51 @@ static const struct bpf_func_proto bpf_send_signal_thread_proto = {
>>>         .arg1_type      = ARG_ANYTHING,
>>>  };
>>>
>>> +BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
>>> +{
>>> +       char *p = d_path(path, buf, sz - 1);
>>> +       int len;
>>> +
>>> +       if (IS_ERR(p)) {
>>> +               len = PTR_ERR(p);
>>> +       } else {
>>> +               len = strlen(p);
>>> +               if (len && p != buf) {
>>> +                       memmove(buf, p, len);
>>> +                       buf[len] = 0;
>>
>> if len above is zero, you won't zero-terminate it, so probably better
>> to move buf[len] = 0 out of if to do unconditionally
> 
> good catch, will change
> 
>>
>>> +               }
>>> +       }
>>> +
>>> +       return len;
>>> +}
>>> +
>>> +BTF_SET_START(btf_whitelist_d_path)
>>> +BTF_ID(func, vfs_truncate)
>>> +BTF_ID(func, vfs_fallocate)
>>> +BTF_ID(func, dentry_open)
>>> +BTF_ID(func, vfs_getattr)
>>> +BTF_ID(func, filp_close)
>>> +BTF_SET_END(btf_whitelist_d_path)
>>> +
>>> +static bool bpf_d_path_allowed(const struct bpf_prog *prog)
>>> +{
>>> +       return btf_id_set_contains(&btf_whitelist_d_path, prog->aux->attach_btf_id);
>>> +}
>>> +
>>
>> This looks pretty great and clean, considering what's happening under
>> the covers. Nice work, thanks a lot!
>>
>>> +BTF_ID_LIST(bpf_d_path_btf_ids)
>>> +BTF_ID(struct, path)
>>
>> this is a bit more confusing to read and error-prone, but I couldn't
>> come up with any better way to do this... Still better than
>> alternatives.
>>
>>> +
>>> +static const struct bpf_func_proto bpf_d_path_proto = {
>>> +       .func           = bpf_d_path,
>>> +       .gpl_only       = true,
>>
>> Does it have to be GPL-only? What's the criteria? Sorry if this was
>> brought up previously.
> 
> I don't think it's needed to be gpl_only, I'll set it to false
> 
> thanks,
> jirka
> 
