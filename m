Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47911CD38A
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 10:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbgEKIME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 04:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgEKIMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 04:12:03 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6429DC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 01:12:03 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w19so3290232wmc.1
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 01:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=ls5FGZ3NMMd9pZ2ifOZ6nZ+Bx8xenDkMs/JGqyyNeOk=;
        b=ypce30jsYoB4oOH5uyzvI6FfWPNaZEdSN0WPfQD2Z+ulYD3fn1zMdWDlVTTJONBqbd
         ucvrPYXAOrYtokeJh08MH/HNrDONjKw05rR9032ZX70V1/tXrBpvl0sFEierBeU/9Jhn
         lLjAysS9bpSNWYMbYIJuyHR7OaFs7FqV43qwo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=ls5FGZ3NMMd9pZ2ifOZ6nZ+Bx8xenDkMs/JGqyyNeOk=;
        b=G2kOG3oHlj6362liqgze2rhIFKn/L+c2/5jbRKtPQEKyyHfmkqIob13QH9d4wE4HYa
         kwfXCwH4o5VvpHRtvrFX4OkKzbzt120MOjQgqtArg5+UvGh/tFpQL+wIUM3CiTWGkAlT
         cdMBPJ/WPpRIvpVP91w+wmSApELbOYXwzoVQhPieoRaG0XxapndRuv+99dUVIQdeEB6X
         h0HGimIzD9Oe6kUBb9w4IJzdycQJRBKRe9DnKVzrfLEB34nPZFy5OpGhDswmzQEwwYuc
         HocrMJoqnHoRmLqixBdaN4BdzOSukCLSjveWF0VF8WJhIPVqOQJpmbu0l868zIquFY+7
         jkRw==
X-Gm-Message-State: AGi0PuaGn2TFEn5Cxbw2q22qdrZSZO94BpFYEuGqB/2KWoiQK/GfJehs
        YwxLXvwHLQ9UjnRsxlmge1q0LA==
X-Google-Smtp-Source: APiQypI5F4unHlHpd0VRSmQksF6FscYrL+ECxLshi/oChHiz/IxeUIi8HZB+2YHPn1GYwXzCn33dWA==
X-Received: by 2002:a1c:cc06:: with SMTP id h6mr27756687wmb.166.1589184722048;
        Mon, 11 May 2020 01:12:02 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id f8sm16247626wrm.8.2020.05.11.01.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 01:12:01 -0700 (PDT)
References: <20200506125514.1020829-1-jakub@cloudflare.com> <20200506125514.1020829-15-jakub@cloudflare.com> <CAEf4BzaE=+0ZkwqetjDHg4MnE1WDQDKFHqEkM825h6YMCZAdNA@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, dccp@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next 14/17] libbpf: Add support for SK_LOOKUP program type
In-reply-to: <CAEf4BzaE=+0ZkwqetjDHg4MnE1WDQDKFHqEkM825h6YMCZAdNA@mail.gmail.com>
Date:   Mon, 11 May 2020 10:12:00 +0200
Message-ID: <878shyvqjz.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 07:41 PM CEST, Andrii Nakryiko wrote:
> On Wed, May 6, 2020 at 5:58 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:

[...]

>> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
>> index e03bd4db827e..113ac0a669c2 100644
>> --- a/tools/lib/bpf/libbpf.map
>> +++ b/tools/lib/bpf/libbpf.map
>> @@ -253,6 +253,8 @@ LIBBPF_0.0.8 {
>>                 bpf_program__set_attach_target;
>>                 bpf_program__set_lsm;
>>                 bpf_set_link_xdp_fd_opts;
>> +               bpf_program__is_sk_lookup;
>> +               bpf_program__set_sk_lookup;
>>  } LIBBPF_0.0.7;
>>
>
> 0.0.8 is sealed, please add them into 0.0.9 map below
>

Ah, thanks. I missed that been rebases. Will fix in v2.
