Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB8C53BAE6
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbiFBOiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236005AbiFBOh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:37:57 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A802DA9C
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 07:37:56 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 137so4920717pgb.5
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 07:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Sk/LpREl6lCpYUK3sh4dhIYv+NwXzY+EQFNtou9uNgg=;
        b=WU//QHTddMEmbobKV3WmcaFVCVlqESjL4yadeBcxJG2Ehcb0sSYTsZ2ImwxNeLk/vm
         MlQdDacFExr4Y4YHDdLlFOOS1UjdqOIrJFDkP/uhF4qxxtDHANzfd/1htrEsoDczNBt9
         pbsUknttci1Qm1XuPwq7iten0RYvQ3EgZAPklHaWN5NWPnYBt1zpZrUUMCnLDduM4fQZ
         Jf+eiPYLSvXYm/5oFexTJemCClME2J4GAt69BjH4gRvnso9TSvpmG5pJdtSKY1ajWgPO
         24aLoQGMyZ221R2i8b0wtiAv/IeG1ozi7UfMDcsGOIeD7POBBFykhNSQ7/+AHwBJdikp
         NLMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Sk/LpREl6lCpYUK3sh4dhIYv+NwXzY+EQFNtou9uNgg=;
        b=xGGC7pZoRpzBVZ8TcNY0CibvOKw+8AiGZmwK7w7ltWaXc789WX322SI/Xg57QR/iF3
         ySWBGariepFXnrFvgIKmip3xuwBLfzy7qwC5rY7Z1E+NVKleUWBFQwn6F3OuDIiiOyTo
         0BtMb0FvUWJqAuwpn2cH0CSr7ARjOofMSn6j18GTKwXyWChrsCjG84T84de7NCt0G49H
         Sp6l0SZjDcUI6tVLBk6vvvfIaqP+4bBizAmXidz1S6qEMjCCGmjD8xFOgcTT9Ifjebgq
         1npOIcXFc2K1uMvblZYBS0yrzld3vvq695zah5KE/Q21Qza5R26csJZE2IGSCvrdVGiZ
         POJQ==
X-Gm-Message-State: AOAM533e1cZMWn+Gmdy+OVMCGg6q4HL9HA5hEHuhh/S1QazDcWzINYDP
        21h/KpCQIR/V9YxLPMTVILKakg==
X-Google-Smtp-Source: ABdhPJylye22XZAN19kga/OK9TT4aEC7VNrMVwD8tJrhsly5C9WmEfLmW7j0si2yIeXqk24ffGKw0Q==
X-Received: by 2002:a63:f955:0:b0:3fc:cf92:cd26 with SMTP id q21-20020a63f955000000b003fccf92cd26mr4494997pgk.137.1654180675640;
        Thu, 02 Jun 2022 07:37:55 -0700 (PDT)
Received: from [192.168.254.36] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id z14-20020a17090a170e00b001df239bab14sm3440275pjd.46.2022.06.02.07.37.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 07:37:54 -0700 (PDT)
Message-ID: <41265f4d-45b4-a3a6-e0c0-5460d2a06377@linaro.org>
Date:   Thu, 2 Jun 2022 07:37:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v4] bpf: Fix KASAN use-after-free Read in
 compute_effective_progs
Content-Language: en-US
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
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <CAEf4BzaD1Z6uOZwbquPYWB0_Z0+CkEKiXQ6zS2imiSHpTgX3pg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrii,
On 5/23/22 15:47, Andrii Nakryiko wrote:
>> Hi Andrii,
>> Do you have any more feedback? Does it look better to you now?
> Hi, this is on my TODO list, but I need a bit more focused time to
> think all this through and I haven't managed to get it in last week.
> I'm worried about the percpu_ref_is_zero(&desc->bpf.refcnt) portion
> and whether it can cause some skew in the calculated array index, I
> need to look at this a bit more in depth. Sorry for the delay.

Did you get a chance to look at this yet?

-- 
Thanks,
Tadeusz
