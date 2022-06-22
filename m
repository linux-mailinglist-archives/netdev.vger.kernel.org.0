Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D2C553F76
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 02:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354793AbiFVAUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 20:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354006AbiFVAU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 20:20:29 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80D8C27FCC;
        Tue, 21 Jun 2022 17:20:27 -0700 (PDT)
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxD086YLJiiTNTAA--.26216S3;
        Wed, 22 Jun 2022 08:20:10 +0800 (CST)
Subject: Re: [PATCH] libbpf: Fix is_pow_of_2
To:     Zvi Effron <zeffron@riotgames.com>, Pavel Machek <pavel@ucw.cz>
References: <20220603041701.2799595-1-irogers@google.com>
 <20220619171248.GC3362@bug>
 <CAC1LvL0rZcEHe_ZHDcB38XD49FmdURg4+yKHP0O=J7=4Xx8M3Q@mail.gmail.com>
Cc:     Ian Rogers <irogers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuze Chi <chiyuze@google.com>
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <baa6d799-187c-75e8-313c-36f5ea3e8f3f@loongson.cn>
Date:   Wed, 22 Jun 2022 08:20:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAC1LvL0rZcEHe_ZHDcB38XD49FmdURg4+yKHP0O=J7=4Xx8M3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9DxD086YLJiiTNTAA--.26216S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Xw1rCFWxCryfAF1kGryrtFb_yoWfuwbEyr
        1jk3s7G3y8ZF1rWwn0yr9xWrZ0k3WDXFn8trW0vr13Ja95AasrXw43Kr92vF98KFW2yry7
        u3s5XFyfuwsayjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb-xYjsxI4VWxJwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z2
        80aVCY1x0267AKxVW8JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY
        jI0SjxkI62AI1cAE67vIY487MxkIecxEwVAFwVWDMxAIw28IcxkI7VAKI48JMxC20s026x
        CaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_
        JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r
        1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_
        WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r
        4UJbIYCTnIWIevJa73UjIFyTuYvjxUc89NDUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/22/2022 07:03 AM, Zvi Effron wrote:
> On Sun, Jun 19, 2022 at 12:13 PM Pavel Machek <pavel@ucw.cz> wrote:
>>
>> Hi!
>>
>>> From: Yuze Chi <chiyuze@google.com>
>>>
>>> +++ b/tools/lib/bpf/libbpf.c
>>> @@ -4956,7 +4956,7 @@ static void bpf_map__destroy(struct bpf_map *map);
>>>
>>> static bool is_pow_of_2(size_t x)
>>> {
>>> - return x && (x & (x - 1));
>>> + return x && !(x & (x - 1));
>>> }
>>
>> I'm pretty sure we have this test in macro in includes somewhere... should we use
>> that instead?
>
> I went looking for a macro that provided this check and could not find one. I

arch/microblaze/mm/pgtable.c

#define is_power_of_2(x)	((x) != 0 && (((x) & ((x) - 1)) == 0))

> did find the inlined static function is_power_of_2 in log2.h, though, that we
> could use.

Here is a patch, but it seems that this is not worth the extra pain.

https://lore.kernel.org/bpf/8e5291b7-bd89-6fea-bfb7-954cacdb8523@iogearbox.net/

Thanks,
Tiezhu

