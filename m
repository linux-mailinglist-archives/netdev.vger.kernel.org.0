Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08ED3DCA37
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 07:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhHAF7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 01:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhHAF7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 01:59:31 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF7EC06175F
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 22:59:23 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id dw2-20020a17090b0942b0290177cb475142so1054665pjb.2
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 22:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=cXPhhLJuDwAzruBjJvzPuhBmNVp3OIyRdJhyvx7IXE8=;
        b=dD5aak9UAdKm8VlaQC5ejCMAu83bKXv38IXSoYEic+uk/RCzQ/nsGKdulqjGoPCwQ7
         8o9DYNyyi1zRybl0fIH8EK9TikS9oajBYP6+oO5AYhNUY7freIJeBuUJrpFDBFXQmVyy
         DjqCFkCuHuYs6lnHeXHHMD3CItuCyA0W5HmyFB1d1nY6DcT/cLIv/flpFvvIW6LQEOY0
         zvOic0sa5tHJrBSy53gRiaXa73Ob1Jv0OnejVAVCMBYCXX3cKULxTtQsGsEU4/MxQpXJ
         C6PIUN1CqZj1BIxMatWbkAs3+HlLOf6DViUng170GaHo0MbCmhLzTP5N5E+gLiqwmjys
         Ovuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=cXPhhLJuDwAzruBjJvzPuhBmNVp3OIyRdJhyvx7IXE8=;
        b=V10l3SFxyctymrR2HaNzhS6I8sNVErTct/e2cC2ybFQU4xyLhMrbkApWnbWlws3FzV
         H3mziQL7dtgeUBStPcknaTHln4bMP2f+K5Q4lYwyO1YG3Az1MnRmshYnSXLYkW4exz+0
         t+x57yuJuMAxIDJS4cvBxo7rsGwz1C9HP0U8PFhtOB//ocjJN/mCx+AgoeMeaN1qTsV9
         6qCwi3aKmbhTYyUf+dSQHmXANJ7Q16lIYIp6p3OJxJKV7TzjxPsNOShcUqdUWSvkxWLP
         8ZacrCDpkMXpHANvY1xCedguk4ZDRz378A6OgcKSn7o8gsZe+HlSa0t74ZI7HxCwgLoj
         bbwA==
X-Gm-Message-State: AOAM532iCBxtIFd2LmHzfAwLUNm3c55tCQIMx9/vk3WbIpuaXQRPzSvK
        IWRTS51zur/U/tLt94/9GSqajA==
X-Google-Smtp-Source: ABdhPJyJ4X9onZKvwxzRBD2e1o5AC+4Yc2luiEbH83ggQo7dV00G2KVSBlw0Nry5ZM/yMvLwRMcMaA==
X-Received: by 2002:a17:90a:420c:: with SMTP id o12mr11207830pjg.101.1627797562993;
        Sat, 31 Jul 2021 22:59:22 -0700 (PDT)
Received: from [10.255.101.149] ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id b12sm7154214pjw.6.2021.07.31.22.59.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Jul 2021 22:59:22 -0700 (PDT)
Subject: Re: [External] Re: [PATCH] lib/bpf: Fix btf_load error lead to enable
 debug log
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        kuznet@ms2.inr.ac.ru, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        chenzhuowen.simon@bytedance.com, cong.wang@bytedance.com
References: <20210729045516.7373-1-zhoufeng.zf@bytedance.com>
 <CAEf4BzY8_n9Yvd0Tpveca5-YRQYpqLgZHshHTWVUNOrAzUJfWw@mail.gmail.com>
From:   zhoufeng <zhoufeng.zf@bytedance.com>
Message-ID: <f3f725ac-99a1-be99-8940-a13d00eb8a24@bytedance.com>
Date:   Sun, 1 Aug 2021 13:59:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzY8_n9Yvd0Tpveca5-YRQYpqLgZHshHTWVUNOrAzUJfWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/7/31 上午2:40, Andrii Nakryiko 写道:
> On Wed, Jul 28, 2021 at 9:55 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>>
>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>
>> Use tc with no verbose, when bpf_btf_attach fail,
>> the conditions:
>> "if (fd < 0 && (errno == ENOSPC || !ctx->log_size))"
>> will make ctx->log_size != 0. And then, bpf_prog_attach,
>> ctx->log_size != 0. so enable debug log.
>> The verifier log sometimes is so chatty on larger programs.
>> bpf_prog_attach is failed.
>> "Log buffer too small to dump verifier log 16777215 bytes (9 tries)!"
>>
>> BTF load failure does not affect prog load. prog still work.
>> So when BTF/PROG load fail, enlarge log_size and re-fail with
>> having verbose.
>>
>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>> ---
> 
> This seems to be targeted against iproute2? It would be good to
> specify that as [PATCH iproute2] or something.
> 
> 

Yeah, it's a good idea. I will resend it.


>>   lib/bpf_legacy.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
>> index 8a03b9c2..d824388c 100644
>> --- a/lib/bpf_legacy.c
>> +++ b/lib/bpf_legacy.c
>> @@ -1531,7 +1531,7 @@ retry:
>>                   * into our buffer. Still, try to give a debuggable error
>>                   * log for the user, so enlarge it and re-fail.
>>                   */
>> -               if (fd < 0 && (errno == ENOSPC || !ctx->log_size)) {
>> +               if (fd < 0 && errno == ENOSPC) {
>>                          if (tries++ < 10 && !bpf_log_realloc(ctx))
>>                                  goto retry;
>>
>> @@ -2069,7 +2069,7 @@ retry:
>>          fd = bpf_btf_load(ctx->btf_data->d_buf, ctx->btf_data->d_size,
>>                            ctx->log, ctx->log_size);
>>          if (fd < 0 || ctx->verbose) {
>> -               if (fd < 0 && (errno == ENOSPC || !ctx->log_size)) {
>> +               if (fd < 0 && errno == ENOSPC) {
>>                          if (tries++ < 10 && !bpf_log_realloc(ctx))
>>                                  goto retry;
>>
>> --
>> 2.11.0
>>
