Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B23853BCD7
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237283AbiFBQvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbiFBQvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:51:18 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDDE202D18
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 09:51:17 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id n13-20020a17090a394d00b001e30a60f82dso9939365pjf.5
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 09:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=TDQ+cU4491SkrItFnZHpClm+jYuYcgPGIy7tcDzQFG8=;
        b=uOpcLIN9c4RrfisvBugPN3DU8GT5x7q/U3iglMCQS2iPkf6OGDg/RlBsS4TbrfuHa+
         SF2uHL5r1DR1bUycKKwv4eHSrkxecyed8V89R24tG7kaZYXUpnYYnEB7FKXFMtiUNpcu
         bD9YZs8MzgjVhzapu9xBK6NoVnvzgb9QwHMa/Nus9D2QIE167N2oav9Pst/sYQEhyW9P
         eAu56AoaRhl33j/JSVbAUNYigMBLVC68FVIdZUrWi8MgzWb0atPoAZ/CukdYwy/HNS8N
         Ot9ZWFGiAxMu2HaXyL4lzIaXLnSRACVX6pSCyvdAwZp56RWl8IxS4/ex0JjuzQd/jVHf
         q58g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=TDQ+cU4491SkrItFnZHpClm+jYuYcgPGIy7tcDzQFG8=;
        b=EA+kijvVz4EuGQxerlILvxGoMouf3cHVxvlfOn3ovNmdfXkGb33BkXIOX4KVqRL2ak
         jx8roS1/UOZ3nEjnSogjPsTZfVzgad8ff6lyfVSD57cQszkPfxnMnh7fF03SxLpekolw
         Pe6um3evQwxDYBwfhxMBFI76/KITul7XTl/yMhTydZoGbvLC1eJoxIO03MvaIOx3cC+h
         Oow3m7qYC4PYMA5EtFLJ7S8Gp38swfWLxRz/fkj2z8xJ0SDSvMKC07lqntfbmqmcfXSY
         mz6JQGwpQxBGYdFfmllrmMAIRYrHIQTF6kr/6s0PtiRIDU3ZfQ2lPvUU6fGZP5c7dGYr
         iE/A==
X-Gm-Message-State: AOAM530AGby4ZT4xxXaEW7gs30WAD+ZQWrnYnzf7yZcaCQ+KKmj3AosF
        7hqyt60wb5ZiaFR+ngNCBXHf7A==
X-Google-Smtp-Source: ABdhPJxMosGB+Mky+SRCGAt1T9DAyMnXHNfnYdje10jH0ruMadl41RhUn/Hf0PTErE9vR4unxYUxWQ==
X-Received: by 2002:a17:90a:fa5:b0:1e2:ee1b:8f85 with SMTP id 34-20020a17090a0fa500b001e2ee1b8f85mr6235190pjz.216.1654188676791;
        Thu, 02 Jun 2022 09:51:16 -0700 (PDT)
Received: from [192.168.254.36] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id u11-20020a63d34b000000b003c14af505f6sm3609472pgi.14.2022.06.02.09.51.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 09:51:16 -0700 (PDT)
Message-ID: <902f1d2b-9e71-753c-566b-62a7d245c3a3@linaro.org>
Date:   Thu, 2 Jun 2022 09:51:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4] bpf: Fix KASAN use-after-free Read in
 compute_effective_progs
Content-Language: en-US
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com
References: <CAEf4BzY-p13huoqo6N7LJRVVj8rcjPeP3Cp=KDX4N2x9BkC9Zw@mail.gmail.com>
 <20220517180420.87954-1-tadeusz.struk@linaro.org>
 <7949d722-86e8-8122-e607-4b09944b76ae@linaro.org>
 <CAEf4BzaD1Z6uOZwbquPYWB0_Z0+CkEKiXQ6zS2imiSHpTgX3pg@mail.gmail.com>
 <41265f4d-45b4-a3a6-e0c0-5460d2a06377@linaro.org>
 <CAEf4Bza-fp-9j+dzwdJQagxVNseNofxY2aJV0E6eHw+eQyyeaQ@mail.gmail.com>
 <21780d7b-2fe0-e6b8-6b4c-7053ec7b99ef@linaro.org>
In-Reply-To: <21780d7b-2fe0-e6b8-6b4c-7053ec7b99ef@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/22 09:25, Tadeusz Struk wrote:
> On 6/2/22 09:11, Andrii Nakryiko wrote:
>>> Did you get a chance to look at this yet?
>>>
>> Hm.. I've applied it two days ago, but for some reason there was no
>> notification from the bot. It's now c89c79fda9b6 ("bpf: Fix KASAN
>> use-after-free Read in compute_effective_progs").

FYI. Just requested a test on bpf-next and it passed fine.
https://groups.google.com/g/syzkaller-android-bugs/c/nr6mD4vhRA4

-- 
Thanks,
Tadeusz
