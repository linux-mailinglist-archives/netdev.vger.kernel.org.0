Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7036BD27C
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 21:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441908AbfIXTRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 15:17:07 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36543 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441899AbfIXTRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 15:17:07 -0400
Received: by mail-pf1-f195.google.com with SMTP id y22so1937993pfr.3;
        Tue, 24 Sep 2019 12:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uuYvKDdlCCY0lggc9sBBXzR54+aLnXoUJm8jnQudcgU=;
        b=npKdJkon5qmHu+jpnZddVbrF8Pa8QGihVlW++CGVzdxayedYxp3dzYNLRYB11cF5L7
         /MqRAlTN0vIKtdNhuUAac/aZw7TYMtO4xdRolhbRrYZXJ5oqKPvEQMWmaFe2fYL63jDb
         c02/h8rRWN1g/7pbFc/16rPH4fHQBUYq+4Kvo9b9i5GVflEQc7onbvKIX7Kxalv9eonn
         3Nj7GC0X3N/00h3cxmeFOVp4Yh3S2K/7wPqFbuNQF+/GlEaUXERJxkscInYJqtnUox0H
         SRYQ66qFJuQcnGMHFW9hDIf2YBe/UZQT/8kk/BGUhlzdWPunls5Aamub6o9uGtrolJeM
         hd6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uuYvKDdlCCY0lggc9sBBXzR54+aLnXoUJm8jnQudcgU=;
        b=kp0AsZo8S+HRjPs5MErtqtYPmc40q6X2WS647ph8P7gtqsQitVvYPAJTAL1cH9dcEE
         cKQoOH1QzKY5atIqjb9VsEg+xRIeGSiv4hBe3r8a41JJlNCV0uQpK6FzxuTmFDunvEzr
         mm601xqK5CzG/gPtVIzllWKlqiKkhYwXHtjnT7yibjxzKZpJcIuU/oQY4EcB8eHKqjai
         gZgGrtUUNQgAFoqlap0ICveumturTkj0gAmIrG/W5cQF3x/7HgnFBlMb33bssCxz2Jyc
         qk6BMOU4wGVe7o5ThTs2nzq7qXeBh3yZerOfPnty28KsZO7PQ1laY9RvUYWsBMOzwRsb
         k1Kg==
X-Gm-Message-State: APjAAAUQBjlDigM9cxhsN19sr0DKW5BKdjwkCDGf/15v4Fmcvflvy0iy
        GIQGjef4vxmSiUjdemNw3gALlfIl
X-Google-Smtp-Source: APXvYqyX6VYd6yhegdHOFbFMdpSp1PJ8ZEll/P+fTVQTO9t4vYIhjdtG5duoWgLMsGAaJycf16RdQg==
X-Received: by 2002:a17:90b:946:: with SMTP id dw6mr1772489pjb.48.1569352626062;
        Tue, 24 Sep 2019 12:17:06 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id l62sm5360360pfl.167.2019.09.24.12.17.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 12:17:05 -0700 (PDT)
Subject: Re: [PATCH] kcm: use BPF_PROG_RUN
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Herbert <tom@herbertland.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190905211528.97828-1-samitolvanen@google.com>
 <0f77cc31-4df5-a74f-5b64-a1e3fc439c6d@fb.com>
 <CAADnVQJxrPDZtKAik4VEzvw=TwY6PoWytfp7HcQt5Jsaja7mxw@mail.gmail.com>
 <048e82f4-5b31-f9f4-5bf7-82dfbf7ec8f3@gmail.com>
 <20190924185908.GC5889@pc-63.home>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <589ccc1c-12b9-4700-f6d9-b2efd3f9a347@gmail.com>
Date:   Tue, 24 Sep 2019 12:17:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924185908.GC5889@pc-63.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/24/19 11:59 AM, Daniel Borkmann wrote:
> On Mon, Sep 23, 2019 at 02:31:04PM -0700, Eric Dumazet wrote:
>> On 9/6/19 10:06 AM, Alexei Starovoitov wrote:
>>> On Fri, Sep 6, 2019 at 3:03 AM Yonghong Song <yhs@fb.com> wrote:
>>>> On 9/5/19 2:15 PM, Sami Tolvanen wrote:
>>>>> Instead of invoking struct bpf_prog::bpf_func directly, use the
>>>>> BPF_PROG_RUN macro.
>>>>>
>>>>> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
>>>>
>>>> Acked-by: Yonghong Song <yhs@fb.com>
>>>
>>> Applied. Thanks
>>
>> Then we probably need this as well, what do you think ?
> 
> Yep, it's broken. 6cab5e90ab2b ("bpf: run bpf programs with preemption
> disabled") probably forgot about it since it wasn't using BPF_PROG_RUN()
> in the first place. If you get a chance, please send a proper patch,
> thanks!

Sure, I will send this today.

