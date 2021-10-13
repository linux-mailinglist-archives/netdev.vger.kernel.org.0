Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9144742C001
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 14:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhJMMbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 08:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbhJMMbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 08:31:23 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D59DCC061746
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 05:29:19 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id y3so7874406wrl.1
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 05:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jxXON34bwb9U7480ZI8tD9t7EEtIFIeyXWCvuOY9nFo=;
        b=VC+P5UlQ+oa8RbtjkI6ihbKMfbye3hyLHafy4vC6TZ/b2HfnrH7nV5364N8CnXHH1o
         GbrzBKBdRPPQwEX23FzhzFYs+Z/tTPuDETyDVqrmCttOwI/ei3kS9hWtQLQwrHOOqLQY
         7QVhHDvwEkBleqiz2KkdOF//mFKsb9feT36V6YQo1YENKhAt7e+1sGujzR09uh0pts6/
         IPzecce4A3D3bTmbWBNYJDdOgBeQtnep1bknl+zPOpw3Rro+Gzg7ki4oajHI0OLuU7qP
         y0yXUzV0jHJTZs31IUWS/8z+loY+KCEqCzPKP5tdrM02RliDA8izTq7dD3tMiygPax1t
         I5OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jxXON34bwb9U7480ZI8tD9t7EEtIFIeyXWCvuOY9nFo=;
        b=5Co9GVNM2ckI0LRT9h2nSIhCScXVKgGtmojPm1OCuzeRZwtuEwWKzA3H2bKj/r+RSs
         3L39ZTqwUee8NxSVAr6VIQ3RynxO3Lq36Wnbqpck2gMv5xsh28wbNCSxYRh9T/ogxc0e
         kU6UHnbwMZlNNmzZOb7ZBXmoSAHh9/JfGhK9EmhY/06SAnmsJddHsd7ZW9tbodlbWXf4
         +j/7InkbbDhfbpGmdRaBDJjqOhRD73+Cg/Yn4lv9Hw/hmTVvR3LAcg1EQljjmd5nM4yz
         XMEJ7/01OW2zouCm/SABwXlj/gbYdfl778eiqr9q0qX8hA9HGLzPtQHBsQRHtTXkXYpM
         WQdQ==
X-Gm-Message-State: AOAM53320D/8KYxYbptra8utbEOcOlfSyJW1ZTZO1hXTfxMnAThHzsG6
        Cd9dbfLpL37X4cyF9+VIBPSYoQ==
X-Google-Smtp-Source: ABdhPJzl6+sUsuUybRUSH6RZdbmAHK1EefCNIcA8VP9VCCbH04KII0GFLfkdnJcYa7FxDnWPNabdHg==
X-Received: by 2002:a7b:cf29:: with SMTP id m9mr12651264wmg.64.1634128158449;
        Wed, 13 Oct 2021 05:29:18 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:cdb4:f738:2bad:740f? ([2a01:e0a:410:bb00:cdb4:f738:2bad:740f])
        by smtp.gmail.com with ESMTPSA id v3sm13427135wrg.23.2021.10.13.05.29.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 05:29:18 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2 4/4] bpf: export bpf_jit_current
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Luke Nelson <luke.r.nels@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20211012135935.37054-1-lmb@cloudflare.com>
 <20211012135935.37054-5-lmb@cloudflare.com>
 <836d9371-7d51-b01f-eefd-cc3bf6f5f68e@6wind.com>
 <CACAyw99ZfALrTRYKOTifWXCRFS9sUOhONbyEyWjTBdzFE4fpQQ@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <1792748b-9204-c96e-b9c6-367eb19928cb@6wind.com>
Date:   Wed, 13 Oct 2021 14:29:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CACAyw99ZfALrTRYKOTifWXCRFS9sUOhONbyEyWjTBdzFE4fpQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 13/10/2021 à 10:35, Lorenz Bauer a écrit :
> On Tue, 12 Oct 2021 at 17:29, Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
>>
>> Le 12/10/2021 à 15:59, Lorenz Bauer a écrit :
>>> Expose bpf_jit_current as a read only value via sysctl.
>>>
>>> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
>>> ---
>>
>> [snip]
>>
>>> +     {
>>> +             .procname       = "bpf_jit_current",
>>> +             .data           = &bpf_jit_current,
>>> +             .maxlen         = sizeof(long),
>>> +             .mode           = 0400,
>> Why not 0444 ?
> 
> This mirrors what the other BPF related sysctls do, which only allow
> access from root with CAP_SYS_ADMIN. I'd prefer 0444 as well, but
> Daniel explicitly locked down these sysctls in
> 2e4a30983b0f9b19b59e38bbf7427d7fdd480d98.
Even after this patch, bpf_jit_enable is 0644.

In fact, if you have CAP_BPF or CAP_SYS_ADMIN, this value has no impact for your
programs. But I you don't have one of these capabilities, it may be rejected,
but you cannot read these values, which help to understand why.


Regards,
Nicolas
