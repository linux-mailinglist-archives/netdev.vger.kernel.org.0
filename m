Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F246D53A3A4
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 13:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352522AbiFALLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 07:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348849AbiFALLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 07:11:05 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DDD8A309
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 04:11:03 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id s12so1524918plp.0
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 04:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=RztceQpkOH+b1euLJDregPonfnUXBMYlNLzc07b5pM8=;
        b=6hqNElVOq7Fdo6fAS2LEGbyJoFnKEwclCRU2ohzM7SaeW06XVagil5PBJWp0Hxf58G
         cw0VUGew8cXRfwXbZQH+1fgUB3/TyrnDWnp3a2dxWpUQOBo5ldw8m4PwUGXhngsYkQiT
         7cpkBQ9kUhEQojIweIzDgp0NoBKwHxWKxBowt2OwKQ2XoABy8TaX5+PqNSghjj4z+zwG
         7/8mtNDbAOn2Jn1pExFrw7i/X1oqXJr24MOVnRGfS/FjO5urGgRc30Kr7E2gA3JDTCNn
         WIWmI6ZJ6C/gAhBei1vXDSWLg/xuZJ+X7a9X9QThkCx+wRoHvAh7nTb7dohyYRvIoB7P
         K33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RztceQpkOH+b1euLJDregPonfnUXBMYlNLzc07b5pM8=;
        b=BSmO39P1NIEJkmbWRhJ++f65n62hSIxcToxzu/StGS7lU0EDw3GtCnzzEntwoaIcPo
         FgdS5PN5S2JT3mBCjB6apqT/yh2E5AffKbobF1rPTF38r+pJ+3ulxZ04F4lFpfIHhfPM
         0+mQjlriYSR3rqunsEzqryQ1WtTyXSacarDVAD5Dup1proANRiuFGErkUgaYk1FJJlhH
         nwc+/kgH0a2c6ACGcyG0ouq2yaLvKIj+rW+QP4ON7iZMGG1pBP7Z01foxvNryIX0v2DR
         aomh8kG9o/2+kz+bwbAYf5p/KUsaOa7wwqJ3CNIOFR7706tWgMKy3GcpQcmGkte9Vdjm
         ecnw==
X-Gm-Message-State: AOAM530LjZbk+2n/BR6muWNXigpQBz23TUxIw65rG46mEXZGgqjDCwPh
        ux5Hv0szM6Q9jf96sEDUj81ucA==
X-Google-Smtp-Source: ABdhPJzCdkK+KSwdCRzkP90vR3+34vwgGt1T6MFBz3VtYKpv+73JwCS/c52eDkgH47wjQk7wk9cBFA==
X-Received: by 2002:a17:903:11c9:b0:154:be2d:eb9 with SMTP id q9-20020a17090311c900b00154be2d0eb9mr64668108plh.91.1654081862570;
        Wed, 01 Jun 2022 04:11:02 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id e16-20020a056a0000d000b0050dc762819bsm1206315pfj.117.2022.06.01.04.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jun 2022 04:11:02 -0700 (PDT)
Message-ID: <21ec90e3-2e89-09c1-fd22-de76e6794d68@bytedance.com>
Date:   Wed, 1 Jun 2022 19:10:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [External] Re: [PATCH v4 1/2] bpf: avoid grabbing spin_locks of
 all cpus when no free elems
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
References: <20220601084149.13097-1-zhoufeng.zf@bytedance.com>
 <20220601084149.13097-2-zhoufeng.zf@bytedance.com>
 <CAADnVQJcbDXtQsYNn=j0NzKx3SFSPE1YTwbmtkxkpzmFt-zh9Q@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAADnVQJcbDXtQsYNn=j0NzKx3SFSPE1YTwbmtkxkpzmFt-zh9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/6/1 下午5:50, Alexei Starovoitov 写道:
> On Wed, Jun 1, 2022 at 10:42 AM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>>   static inline void ___pcpu_freelist_push(struct pcpu_freelist_head *head,
>> @@ -130,14 +134,19 @@ static struct pcpu_freelist_node *___pcpu_freelist_pop(struct pcpu_freelist *s)
>>          orig_cpu = cpu = raw_smp_processor_id();
>>          while (1) {
>>                  head = per_cpu_ptr(s->freelist, cpu);
>> +               if (READ_ONCE(head->is_empty))
>> +                       goto next_cpu;
>>                  raw_spin_lock(&head->lock);
>>                  node = head->first;
>>                  if (node) {
> extra bool is unnecessary.
> just READ_ONCE(head->first)

As for why to add is_empty instead of directly judging head->first, my
understanding is this, head->first is frequently modified during updating
map, which will lead to invalid other cpus's cache, and is_empty is after
freelist having no free elems will be changed, the performance will be 
better.
If I'm thinking wrong, please tell me why.

