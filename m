Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6C61D8CD5
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 03:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgESBDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 21:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgESBDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 21:03:06 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAEBC05BD09
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 18:03:06 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f134so1308026wmf.1
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 18:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uwuNGFJAq2sDPWpG9aNv6dzcxMBNAA6NXYKA7mcTybI=;
        b=drPHrcBCXZX1rda3Kpdk+cqo042O7DO1DIU9AeEqDf7UHkFJ4/c/onKSCTe3otqFTF
         jns2pg4DXnUY2hLBRDmiR1TxSV/1nViKvRFbfT2V11J/nWErA0mBfRLJRoPUtRzLZUgS
         EV2oY3nooJYb1s7urSS6Tu097ar0rPT5GtU/CYTnltusVt5x1LnukwgGwcZ+zzQ+TarC
         IeDak1/oXB27jw6FYqrWXDndFCAByBwu4APRQJGRiC96BB9N+kYXrzgE3au1Uqy77x9J
         fjXpXQ5aakljhndn/SHte+D4wTE8v9IKVrgcZtjcKxmOc/DhiZZOfsgalbkin+ZebIol
         n8HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uwuNGFJAq2sDPWpG9aNv6dzcxMBNAA6NXYKA7mcTybI=;
        b=QFmCYWdZx9Sk7Sz7mPRg1Q/W2v2yGSXh5KZA90v+D+K6DT8D4njbFlE/7e9rp5/Da/
         0SVlxXftstIvbbkOz/uqsm5TvkRrXqZ8b3QSdMqTPEs1mCfeNLWq7NFsYRIAHwWJwVoN
         phBqQhKIcDniEHYQsC6cAbDuQ6KXRi03BpPhhVQ1bF49Eg5/i7bHMijT0cfTuVo2oGis
         EL8IvrLud+e6g3AD+uptstjrTFMxYrQLXvpC/iZFNag9r6/+s221GZYZyQKi3gjBS61e
         V6UsuXqX76ohIZG44sJH2wnt24Z0rncRbLKoUygp+GHoJxrfgZAhiL/zgr1d9LPa1i+h
         YR9A==
X-Gm-Message-State: AOAM530FqE+GZlGu9pT3JqrL1cEjWHSkASDHlPF/dBALF748W+gWnsQY
        h16V0mvA1s/WEvE9wAtqPnczihNwlZs=
X-Google-Smtp-Source: ABdhPJxBU/Q//jj/zetOkVpdP3raoQMUciTl3LZyGYwOsbKeYbCF/iIr0qFPPGN8ye4L1Af1qUSRiw==
X-Received: by 2002:a05:600c:247:: with SMTP id 7mr2155491wmj.76.1589850184317;
        Mon, 18 May 2020 18:03:04 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.185.137])
        by smtp.gmail.com with ESMTPSA id 81sm1852918wme.16.2020.05.18.18.03.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 18:03:03 -0700 (PDT)
Subject: Re: [PATCH bpf-next] tools: bpftool: make capability check account
 for new BPF caps
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
References: <20200516005149.3841-1-quentin@isovalent.com>
 <CAEf4BzZDC9az2vFPTNW03gSUZiYdc9-XeyP+1h8WkAKHagkUTg@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <3ffe7cc3-01da-1862-d734-b7a8b1d7c63d@isovalent.com>
Date:   Tue, 19 May 2020 02:03:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZDC9az2vFPTNW03gSUZiYdc9-XeyP+1h8WkAKHagkUTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-05-18 17:07 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Fri, May 15, 2020 at 5:52 PM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> Following the introduction of CAP_BPF, and the switch from CAP_SYS_ADMIN
>> to other capabilities for various BPF features, update the capability
>> checks (and potentially, drops) in bpftool for feature probes. Because
>> bpftool and/or the system might not know of CAP_BPF yet, some caution is
>> necessary:
>>
>> - If compiled and run on a system with CAP_BPF, check CAP_BPF,
>>   CAP_SYS_ADMIN, CAP_PERFMON, CAP_NET_ADMIN.
>>
>> - Guard against CAP_BPF being undefined, to allow compiling bpftool from
>>   latest sources on older systems. If the system where feature probes
>>   are run does not know of CAP_BPF, stop checking after CAP_SYS_ADMIN,
>>   as this should be the only capability required for all the BPF
>>   probing.
>>
>> - If compiled from latest sources on a system without CAP_BPF, but later
>>   executed on a newer system with CAP_BPF knowledge, then we only test
>>   CAP_SYS_ADMIN. Some probes may fail if the bpftool process has
>>   CAP_SYS_ADMIN but misses the other capabilities. The alternative would
>>   be to redefine the value for CAP_BPF in bpftool, but this does not
>>   look clean, and the case sounds relatively rare anyway.
>>
>> Note that libcap offers a cap_to_name() function to retrieve the name of
>> a given capability (e.g. "cap_sys_admin"). We do not use it because
>> deriving the names from the macros looks simpler than using
>> cap_to_name() (doing a strdup() on the string) + cap_free() + handling
>> the case of failed allocations, when we just want to use the name of the
>> capability in an error message.
>>
>> The checks when compiling without libcap (i.e. root versus non-root) are
>> unchanged.
>>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
>>  tools/bpf/bpftool/feature.c | 85 +++++++++++++++++++++++++++++--------
>>  1 file changed, 67 insertions(+), 18 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
>> index 1b73e63274b5..3c3d779986c7 100644
>> --- a/tools/bpf/bpftool/feature.c
>> +++ b/tools/bpf/bpftool/feature.c
>> @@ -758,12 +758,32 @@ static void section_misc(const char *define_prefix, __u32 ifindex)
>>         print_end_section();
>>  }
>>
>> +#ifdef USE_LIBCAP
>> +#define capability(c) { c, #c }
>> +#endif
>> +
>>  static int handle_perms(void)
>>  {
>>  #ifdef USE_LIBCAP
>> -       cap_value_t cap_list[1] = { CAP_SYS_ADMIN };
>> -       bool has_sys_admin_cap = false;
>> +       struct {
>> +               cap_value_t cap;
>> +               char name[14];  /* strlen("CAP_SYS_ADMIN") */
>> +       } required_caps[] = {
>> +               capability(CAP_SYS_ADMIN),
>> +#ifdef CAP_BPF
>> +               /* Leave CAP_BPF in second position here: We will stop checking
>> +                * if the system does not know about it, since it probably just
>> +                * needs CAP_SYS_ADMIN to run all the probes in that case.
>> +                */
>> +               capability(CAP_BPF),
>> +               capability(CAP_NET_ADMIN),
>> +               capability(CAP_PERFMON),
>> +#endif
>> +       };
>> +       bool has_admin_caps = true;
>> +       cap_value_t *cap_list;
>>         cap_flag_value_t val;
>> +       unsigned int i;
>>         int res = -1;
>>         cap_t caps;
>>
>> @@ -774,41 +794,70 @@ static int handle_perms(void)
>>                 return -1;
>>         }
>>
>> -       if (cap_get_flag(caps, CAP_SYS_ADMIN, CAP_EFFECTIVE, &val)) {
>> -               p_err("bug: failed to retrieve CAP_SYS_ADMIN status");
>> +       cap_list = malloc(sizeof(cap_value_t) * ARRAY_SIZE(required_caps));
> 
> I fail to see why you need to dynamically allocate cap_list?
> cap_value_t cap_list[ARRAY_SIZE(required_caps)] wouldn't work?

Oh I should have thought about that, thanks! I'll fix it.

>> +       if (!cap_list) {
>> +               p_err("failed to allocate cap_list: %s", strerror(errno));
>>                 goto exit_free;
>>         }
>> -       if (val == CAP_SET)
>> -               has_sys_admin_cap = true;
>>
>> -       if (!run_as_unprivileged && !has_sys_admin_cap) {
>> -               p_err("full feature probing requires CAP_SYS_ADMIN, run as root or use 'unprivileged'");
>> -               goto exit_free;
>> +       for (i = 0; i < ARRAY_SIZE(required_caps); i++) {
>> +               const char *cap_name = required_caps[i].name;
>> +               cap_value_t cap = required_caps[i].cap;
>> +
>> +#ifdef CAP_BPF
>> +               if (cap == CAP_BPF && !CAP_IS_SUPPORTED(cap))
>> +                       /* System does not know about CAP_BPF, meaning
>> +                        * that CAP_SYS_ADMIN is the only capability
>> +                        * required. We already checked it, break.
>> +                        */
>> +                       break;
>> +#endif
> 
> Seems more reliable to check all 4 capabilities independently (so
> don't stop if !CAP_IS_SUPPORTED(cap)), and drop those that you have
> set. Or there are some downsides to that?

If CAP_BPF is not supported, there is simply no point in going on
checking the other capabilities, since CAP_SYS_ADMIN is the only one we
need to do the feature probes. So in that case I see little point in
checking the others.

But if I understand your concern, you're right in the sense that the
current code would consider a user as "unprivileged" if they do not have
all four capabilities (in the case where CAP_BPF is supported); but they
may still have a subset of them and not be completely unprivileged, and
in that case we would have has_admin_caps at false and skip capabilities
drop.

I will fix that in next version. I am not sure about the advantage of
keeping track of the capabilities and building a list just for dropping
only the ones we have, but I can do that if you prefer.

Thanks a lot for the review!
Quentin
