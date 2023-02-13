Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A91694CB0
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjBMQ2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjBMQ2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:28:24 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9743CC0B
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:28:21 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id qb15so31196217ejc.1
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TvLjmK3J9jCTc0UO9rqDH8baqftLGIPgKLAo0GHKwZc=;
        b=hHZaiOnJ7VVSeA6Ycw3sCRaMlXNTYn6QHEIIe7ToZ9wwx3F7iNnSWUesNcLYbhBl8U
         ZX8Lg5QZBY5TmtX95asnkMZHdKYXg+Cy9wIK4g9JawmBc/TPeZ+ZzGMhLwaevrsxjG30
         CvQuEXyPtZ+tR5UtWVjiyT2ksZQozucVf0m7b3ld1RgrIE3WQdLVek7/FkC82w5ziDXv
         iLGAxH2JxCpNRoCENqJrI0L5rbRBIK12dCPvLCTA/MiG2M/Y4ZWcOEQJ9frbGd4+8XnY
         g5eNSmPEPan7yUEKuTgL7i90Qaa8h3jXWz7FVKciPqa/zM8GIIKPGp0iQhKgKzLU7pvb
         FR5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TvLjmK3J9jCTc0UO9rqDH8baqftLGIPgKLAo0GHKwZc=;
        b=y90JVj9iNpLLr3F4Z9SDXrhsDqG4K4ZeU78xVBeoaE6Osc71Dn7oNkQpizMSrApLa1
         rDbUaJra8n3TgbnqUcOV9OJulMWl6YxjcuPm3A3trt7+9UB0wnQZGAB/mtX+gQh7Hy3/
         oPNwYdc8bKGgsSP9Z6szfMduRNTxEQYih+yH63RrdH0gxuLGJzK0qxVV05hNR5ZNva2v
         h1fTI8lqqZBKP9fmpHBkf4UkS9tfYkVIaS5MF7UgloP2roAOV2tcKTVkdhlnxdhJliM+
         AEmAihPg+drsoPb+lENsDbv4+nH6GI0YcuVzdfeBKnlz0DJkEDNsB9CxOJiMXmb7RKhw
         9ePA==
X-Gm-Message-State: AO0yUKWMl6rBlkm3gA1OyiuL6rpj6JfrXXyOvXk1pafldmF2j51FTI5n
        3sTO1IqGpP8PNUbzUO9PYujhcw==
X-Google-Smtp-Source: AK7set/hQuOUOUx+9SojbNclSe7XHfDwLCeTMnjlaEMUbsaBR8GSa3E0oluAJTRMxXCZm/0SuO0xlA==
X-Received: by 2002:a17:906:704f:b0:878:955e:b4a4 with SMTP id r15-20020a170906704f00b00878955eb4a4mr24555009ejj.33.1676305700342;
        Mon, 13 Feb 2023 08:28:20 -0800 (PST)
Received: from [10.44.2.5] ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id e26-20020a170906081a00b008786675d086sm6984132ejd.29.2023.02.13.08.28.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 08:28:19 -0800 (PST)
Message-ID: <19a6a29d-85f3-b8d7-c9d9-3c97a625bd13@tessares.net>
Date:   Mon, 13 Feb 2023 17:28:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH bpf] selftests/bpf: enable mptcp before testing
Content-Language: en-GB
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Davide Caratti <dcaratti@redhat.com>
References: <20230210093205.1378597-1-liuhangbin@gmail.com>
 <6f0a72ee-ec30-8c97-0285-6c53db3d4477@tessares.net>
 <Y+m4KufriYKd39ot@Laptop-X1>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <Y+m4KufriYKd39ot@Laptop-X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin Liu,

On 13/02/2023 05:10, Hangbin Liu wrote:
> On Fri, Feb 10, 2023 at 05:22:24PM +0100, Matthieu Baerts wrote:
>> Hi Hangbin Liu,
>>
>> On 10/02/2023 10:32, Hangbin Liu wrote:
>>> Some distros may not enable mptcp by default. Enable it before start the
>>> mptcp server. To use the {read/write}_int_sysctl() functions, I moved
>>> them to test_progs.c
>>>
>>> Fixes: 8039d353217c ("selftests/bpf: Add MPTCP test base")
>>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
>>> ---
>>>  .../testing/selftests/bpf/prog_tests/mptcp.c  | 15 ++++++-
>>
>> Thank you for the patch!
>>
>> The modifications linked to MPTCP look good to me.
>>
>> But I don't think it is needed here: I maybe didn't look properly at
>> 'bpf/test_progs.c' file but I think each program from 'prog_tests'
>> directory is executed in a dedicated netns, no?
>>
>> I don't have an environment ready to validate that but if yes, it means
>> that on a "vanilla" kernel, net.mptcp.enabled sysctl knob should be set
>> to 1. In this case, this modification would be specific to these distros
>> patching MPTCP code to disable it by default. It might then be better to
>> add this patch next to the one disabling MPTCP by default, no? (or
>> revert it to have MPTCP available by default for the applications asking
>> for it :) )
> 
> I think this issue looks like the rp_filter setting. The default rp_filter is 0.
> But many distros set it to 1 for safety reason. Thus there are some fixes for
> the rp_filter setting like this one. e.g.

I think we should not compare net.mptcp.enabled with rp_filter because
the latter is a bit particular: the initial value of rp_filter in a
newly created netns is inherited from the "host" (the initial netns). In
this case, it is difficult to predict the value of rp_filter in a new
netns and it makes sense to force it to the expected value.

Here for net.mptcp.enabled, the value should be 1 in a newly created
netns. If not, it means the kernel has been modified. (It was making
sense to disable it when MPTCP was backported to older kernels and
marked as "Tech Preview". Now, I don't think we should recommend distros
to do that and support such modifications in the upstream kernel :) )

But again, I'm not totally against that, I'm just saying that if these
tests are executed in dedicated netns, this modification is not needed
when using a vanilla kernel ;-)

Except if I misunderstood and these tests are not executed in dedicated
netns?

(Note: to reduce the size of the patch, if these tests are correctly
executed in dedicated netns, then you can simply force net.mptcp.enabled
to be set to 1, no need to reset it to the previous value.)

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
