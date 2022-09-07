Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303B45B0939
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiIGPwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiIGPwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:52:19 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D9C3DF10
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:52:17 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id bp20so20611741wrb.9
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 08:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=NYzhmzD+Hlo+7fMnBjpgbj1puf06rcJdgGC2mEQ/ztA=;
        b=LDxfrhEFnmzhrhYxmVz2myek1v8Bg4MQZrIBkKNIxjNF4GsBJfYRcaNQsrLU454+Zu
         m2M2HNxKxBP3PTGgdMVhVMxjLitd7P9ehj2zQpmTRyfI1uxnISmUzWktA5MqkektQfDT
         E467PnvS767e8UOwq0biUv1X5OjAnkPx4lXNpqD0FMYx4GuCqnVOQHjZE1iX7HlR285h
         QSkmX64GTXSzBaHFD+cQzyaOEyse2CjJ1YP5YheOh0tfzQ19wjd1uihOhetibhAQCi4s
         lgF42EhjbGXR5MpUDEgTRkxmIGThCEyB/us+RykzHCPcdcVx67w+gIZxiOCfDrulW2wH
         F8XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=NYzhmzD+Hlo+7fMnBjpgbj1puf06rcJdgGC2mEQ/ztA=;
        b=1cwqhWZ8fob4Z7Vv0Yk0Glytx7Tr4IaIN7+YZiZl6nu90U0O5Zgx0DOsTzj4ZQMA2a
         yEvNFBdxpX0wYXO8eMzQqlIanDqCc4Sj60/ISJOMQJNO3+Er+k6nv6E1mI6OtGv0pUCB
         nl1O6EhE68V1zPCn+/shwCUqmzWzeaLXgh3ef1sV6aJdBcs0xA2ZwzMJTNgZtaaYz2nL
         ckN0b/ITr72a3zo9Gtswu3TEAJclcB7kEntBv0yoSkVl6M/XTvCeI7u4P3/m6q1s7YCa
         c4jP88dzXqbTnpFb4RuVDEAMxpAZVI9Huu7Dhns1XdB6CmhhoQjdbm5+V2XPdIDs8Otc
         HgBg==
X-Gm-Message-State: ACgBeo2QEZ4auGvphDhmL0A5VslGEJNGFgLdjh+8JiFYdHDEhR5+V4Ub
        kYlwPM1h1V9nRlnM8pu+xa1K2Q==
X-Google-Smtp-Source: AA6agR6Ck/iuOSME6EjZf8jow12+0iA5PATS6wY7tjSqX+x7dYs/TYvadEnR8TtfnZ08Q6C4u32vow==
X-Received: by 2002:a05:6000:18a1:b0:222:c54a:3081 with SMTP id b1-20020a05600018a100b00222c54a3081mr2463664wri.666.1662565935974;
        Wed, 07 Sep 2022 08:52:15 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:d023:bfe9:4cda:fa70? ([2a01:e0a:b41:c160:d023:bfe9:4cda:fa70])
        by smtp.gmail.com with ESMTPSA id e4-20020a5d65c4000000b00228cd9f6349sm9500020wrw.106.2022.09.07.08.52.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 08:52:14 -0700 (PDT)
Message-ID: <953e16f5-80bd-2098-bd7f-5f4fd74ceaaa@6wind.com>
Date:   Wed, 7 Sep 2022 17:52:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20220831101617.22329-1-fw@strlen.de> <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc> <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc> <87ilm84goh.fsf@toke.dk>
 <20220831152624.GA15107@breakpoint.cc>
 <CAADnVQJp5RJ0kZundd5ag-b3SDYir8cF4R_nVbN8Zj9Rcn0rww@mail.gmail.com>
 <20220831155341.GC15107@breakpoint.cc>
 <CAADnVQJGQmu02f5B=mc1xJvVWSmk_GNZj9WAUskekykmyo8FzA@mail.gmail.com>
 <20220831215737.GE15107@breakpoint.cc>
 <bf148d57-dab9-0e25-d406-332d1b28f045@6wind.com>
 <CAADnVQLYcjhpVaFJ3vriDcv=bczXddRd=q83exNNPrgnvsCEAg@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <CAADnVQLYcjhpVaFJ3vriDcv=bczXddRd=q83exNNPrgnvsCEAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 07/09/2022 à 05:04, Alexei Starovoitov a écrit :
> On Mon, Sep 5, 2022 at 11:57 PM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
>>
>>
>> Le 31/08/2022 à 23:57, Florian Westphal a écrit :
>>> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
>>>>> This helps gradually moving towards move epbf for those that
>>>>> still heavily rely on the classic forwarding path.
>>>>
>>>> No one is using it.
>>>> If it was, we would have seen at least one bug report over
>>>> all these years. We've seen none.
>>>
>>> Err, it IS used, else I would not have sent this patch.
>>>
>>>> very reasonable early on and turned out to be useless with
>>>> zero users.
>>>> BPF_PROG_TYPE_SCHED_ACT and BPF_PROG_TYPE_LWT*
>>>> are in this category.
>>>
>>> I doubt it had 0 users.  Those users probably moved to something
>>> better?
>> We are using BPF_PROG_TYPE_SCHED_ACT to perform custom encapsulations.
>> What could we used to replace that?
> 
> SCHED_CLS. It has all of the features of cls and act combined.

Indeed, thanks.
