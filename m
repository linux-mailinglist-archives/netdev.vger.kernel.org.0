Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73521E6F8D
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437289AbgE1Wtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437209AbgE1Wtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:49:32 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6641EC08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:49:32 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 205so579838qkg.3
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 15:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CXW6P0TxQ4GnEwNvShd0J6dYuOhqJIG/ocrdyKGia3A=;
        b=vIV0jaLqQ5N5NgSdlFnQQhx+F7+5sGee1TZCilyBAcEZX85qLmXmJXfrwsmY2F/W0s
         756AplOZZMosThdZ38/Xbmp8aN/3yyTlLlaVGPXJdPVPpVMY3PYRFY2k9Lf91WD80GcY
         GYvSmxl77vjcUAQsR3zu2K/af8tLX1AZBf7FXvuHwzGhWRWiXTQkmlcfyG1gQX4vJXZW
         PzgLc1+di5fWC5aXKaX47PoFB9dBwQJDJADvklLhPFsZePNWlWvOEvSPRNyZh89ZqMMA
         a86+4HxBKu2AdnjOg+o5FLRcYT0MA0czgTU18EsnJc3bCobjjFiV5S9gr0SiT0Hs4sKZ
         rZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CXW6P0TxQ4GnEwNvShd0J6dYuOhqJIG/ocrdyKGia3A=;
        b=ld3SI+LihF90hxbDhY78HDee/ZAHsjzkKyet8rQL7f1TtmjUv5qX9U8wFD1Ru5ulFl
         x7mTdWqWgs9Z5YvlAeQwKVtOg60KrEhlXpyG1Td4SOTf5wP5yA0oIEtJuKwlCAiRfJeH
         pDIDEc1QXcMz6c5xNyx0XlzLsUalSnBpOLA6AsRWT9nXThKwYvZKZN8pp7KC7h6Fb0kn
         OHHuYDuMmLypHWfzYhq4kGfteQwRIsM0j7FPxna1qTPolhb4JNmyhITWVtaO9zEKNjw4
         AwiirGXS6svB+fQBBstA2adToq1nF+KJIUdD5I2xFH7LxYc2xOL0+WsIsf8Jol7jihbC
         tEMA==
X-Gm-Message-State: AOAM532aGh8MrWO0t5Bb0HJK3Oqx+g3r5WEC0XXue7o5zURN9MUCUJxp
        CpeRJmC3iIVam6Hg9s+ZYGs=
X-Google-Smtp-Source: ABdhPJzNjaTDAe5EpE597dE9MV+cSATkt+jbS8gakzbgau7GzyWPADPhnUrEN89/Rxb32tBrnuYrXw==
X-Received: by 2002:ae9:e00f:: with SMTP id m15mr5427376qkk.223.1590706171691;
        Thu, 28 May 2020 15:49:31 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2840:9137:669d:d1e7? ([2601:282:803:7700:2840:9137:669d:d1e7])
        by smtp.googlemail.com with ESMTPSA id d56sm6728728qtb.54.2020.05.28.15.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 15:49:31 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 4/5] libbpf: Add SEC name for xdp programs
 attached to device map
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20200528001423.58575-1-dsahern@kernel.org>
 <20200528001423.58575-5-dsahern@kernel.org>
 <CAEf4BzbwB+ON56HmRqhPD=iyiviYF9EwBvf-n5tPKn0qhzHjgA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5e885032-1909-86d8-d302-34d027062910@gmail.com>
Date:   Thu, 28 May 2020 16:49:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbwB+ON56HmRqhPD=iyiviYF9EwBvf-n5tPKn0qhzHjgA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/20 1:04 AM, Andrii Nakryiko wrote:
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 5d60de6fd818..493909d5d3d3 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -6657,6 +6657,8 @@ static const struct bpf_sec_def section_defs[] = {
>>                 .expected_attach_type = BPF_TRACE_ITER,
>>                 .is_attach_btf = true,
>>                 .attach_fn = attach_iter),
>> +       BPF_EAPROG_SEC("xdp_dm",                BPF_PROG_TYPE_XDP,
>> +                                               BPF_XDP_DEVMAP),
> 
> naming is hard and subjective, but does "dm" really associate with
> DEVMAP to you, rather than "direct message" or "direct memory" or

Yes it does b/c of the XDP context. Program name lengths being limited
to 15 characters makes me shorten all prefixes to leave some usable
characters for id'ing the program.


> something along those line? Is there any harm to call this
> "xdp_devmap"? It's still short enough, IMO.
> 

but for the SEC name, I switched it to xdp_devmap.
